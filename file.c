//
// File descriptors
//

#include "types.h"
#include "defs.h"
#include "param.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

struct devsw devsw[NDEV];
struct {
    struct spinlock lock;
    struct file file[NFILE];
} ftable;


int countDistinct(int const *arr, int len) {
    int output = 0;
    int flag;
    for (int i = 0; i < len; i++) {
        flag = 1;
        int j = 0;
        for (; flag && j < len;) {
            if (arr[i] == arr[j])
                flag = 0;
            else
                j++;
        }
        if (i == j)
            output++;
    }
    return output;
}


void
fileinit(void) {
    initlock(&ftable.lock, "ftable");
}

void getFileStat(int *free, int *total, int *ref, int *read, int *write, int *inode) {
    struct file *f;
    int freeFD = 0, totalFD = 0, refFD = 0, readFD = 0, writeFD = 0, inodeFD = 0;
    int i = 0;
    int arr[NOFILE] = {0};

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
        if (f->ref == 0) {
            freeFD++;
        } else {
            totalFD++;
            refFD += f->ref;
            if (f->readable)
                readFD++;
            if (f->writable)
                writeFD++;
            if (f->type == FD_INODE) {
                arr[i] = f->ip->inum;
                i++;
            }
        }
    }
    inodeFD = countDistinct(arr, i - 1);

    release(&ftable.lock);

    *free = freeFD;
    *total = totalFD;
    *ref = refFD;
    *read = readFD;
    *write = writeFD;
    *inode = inodeFD;
}


// Allocate a file structure.
struct file *
filealloc(void) {
    struct file *f;

    acquire(&ftable.lock);
    for (f = ftable.file; f < ftable.file + NFILE; f++) {
        if (f->ref == 0) {
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    return 0;
}

// Increment ref count for file f.
struct file *
filedup(struct file *f) {
    acquire(&ftable.lock);
    if (f->ref < 1)
        panic("filedup");
    f->ref++;
    release(&ftable.lock);
    return f;
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f) {
    struct file ff;

    acquire(&ftable.lock);
    if (f->ref < 1)
        panic("fileclose");
    if (--f->ref > 0) {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    f->ref = 0;
    f->type = FD_NONE;
    release(&ftable.lock);

    if (ff.type == FD_PIPE)
        pipeclose(ff.pipe, ff.writable);
    else if (ff.type == FD_INODE) {
        begin_op();
        iput(ff.ip);
        end_op();
    }
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st) {
    if (f->type == FD_INODE) {
        ilock(f->ip);
        stati(f->ip, st);
        iunlock(f->ip);
        return 0;
    }
    return -1;
}

// Read from file f.
int
fileread(struct file *f, char *addr, int n) {
    int r;

    if (f->readable == 0)
        return -1;
    if (f->type == FD_PIPE)
        return piperead(f->pipe, addr, n);
    if (f->type == FD_INODE) {
        ilock(f->ip);
        if ((r = readi(f->ip, addr, f->off, n)) > 0)
            f->off += r;
        iunlock(f->ip);
        return r;
    }
    panic("fileread");
}

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n) {
    int r;

    if (f->writable == 0)
        return -1;
    if (f->type == FD_PIPE)
        return pipewrite(f->pipe, addr, n);
    if (f->type == FD_INODE) {
        // write a few blocks at a time to avoid exceeding
        // the maximum log transaction size, including
        // i-node, indirect block, allocation blocks,
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * 512;
        int i = 0;
        while (i < n) {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
            ilock(f->ip);
            if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
                f->off += r;
            iunlock(f->ip);
            end_op();

            if (r < 0)
                break;
            if (r != n1)
                panic("short filewrite");
            i += r;
        }
        return i == n ? n : -1;
    }
    panic("filewrite");
}

