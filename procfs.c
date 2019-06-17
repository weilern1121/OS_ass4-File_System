#include "types.h"
#include "stat.h"
#include "defs.h"
#include "param.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "buf.h"

int sbInodes = 0;
int IDEINFO = 0;
int FILESTAT = 0;
int INODEINFO = 0;
int VIRTUALINODEINFO = 0;


// this function init major params.

void initSbInodes(struct inode *ip) {
    if (!sbInodes) {
        struct superblock sb;
        readsb(ip->dev, &sb);
        sbInodes = sb.ninodes;
        IDEINFO = sbInodes + 1;
        FILESTAT = sbInodes + 2;
        INODEINFO = sbInodes + 3;
        VIRTUALINODEINFO = sbInodes + NPROC * (PROCINODES + 1); //offset for the virtual inodeInfo dirents
    }
}

// Implementation of itoa()
char *itoa(int num, char *str) {
    int i = 0;
    /* Handle 0 explicitely, otherwise empty string is printed for 0 */
    if (num == 0) {
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }

    // Process individual digits
    while (num != 0) {
        int rem = num % 10;
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
        num = num / 10;
    }
    str[i] = '\0'; // Append string terminator

    // Reverse the string
    int start = 0;
    int end = i -1;
    while (start < end)
    {
        //swap
        char tmp= str[start];
        str[start]=str[end];
        str[end]=tmp;
//        swap(*(str+start), *(str+end));
        start++;
        end--;
    }

    return str;
}



void writeDirentToBuff(int currDirent, char *name, int IPinum, char *designBuffer) {
    struct dirent newDirent;
    newDirent.inum = (ushort) IPinum;

    memmove(&newDirent.name, name, (uint) (strlen(name) + 1));

    int size = sizeof(newDirent);
    int offset = currDirent * size;
    memmove(designBuffer + offset, &newDirent, (uint) size);

}


void writeToBuff(char *name, char *designBuffer) {
    if (!name)
        panic("ERROR - writeToBuff: NAME IS NULL!");
    int len = strlen(name);
    int sz = strlen(designBuffer);
    memmove(designBuffer + sz, name, (uint) len);
}


void cleanName(char *name) {
    for (int i = 0; i < DIRSIZ; i++)
        name[i] = 0;
}


//todo - not sure that need to send IPnum as argument to this specific func!
int ReadFromMemInodes(char *designBuffer, int IPinum) {

    int currDirent = 0;

    writeDirentToBuff(currDirent, ".", namei("/proc")->inum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "..", namei("")->inum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "ideinfo", IDEINFO, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "filestat", FILESTAT, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "inodeinfo", INODEINFO, designBuffer);
    currDirent++;

    int procName[NPROC] = {0}; //array of RUNNING/RUNNABLE/SLEEPING procs
    char procNameString[DIRSIZ] = {0}; //used to iota the pid to string

    int numProcs = getValidProcs(procName);

    for (int i = 0; i < numProcs; i++) {
        cleanName(procNameString);
        char *pidNameInString = itoa(procName[i], procNameString);
        int currLocation = sbInodes + PROCINODES * (i + 1);

        writeDirentToBuff(currDirent, pidNameInString, currLocation, designBuffer);
        currDirent++;
    }

    //TEST : in this point currDirent should be == numProcs+5
    return currDirent * sizeof(struct dirent);

}



int ReadFromFileStat(char *designBuffer, int IPinum) {

    int free, total, ref, read, write, inode;
    getFileStat(&free, &total, &ref, &read, &write, &inode);

    //GOT HERE - WRITE OT BUFF
    char tmp[DIRSIZ];
    writeToBuff("\nFree fds:\t", designBuffer);
    itoa(free, tmp);
    writeToBuff(tmp, designBuffer);

    cleanName(tmp);
    writeToBuff("\nUnique inode fds:\t", designBuffer);
    itoa(inode, tmp);
    writeToBuff(tmp, designBuffer);

    cleanName(tmp);
    writeToBuff("\nWriteable fds:\t", designBuffer);
    itoa(write, tmp);
    writeToBuff(tmp, designBuffer);

    cleanName(tmp);
    writeToBuff("\nReadable fds:\t", designBuffer);
    itoa(read, tmp);
    writeToBuff(tmp, designBuffer);

    cleanName(tmp);
    writeToBuff("\nRefs per fds:\t", designBuffer);
    itoa(ref, tmp);
    writeToBuff(tmp, designBuffer);
    cleanName(tmp);
    writeToBuff(" / ", designBuffer);
    itoa(total, tmp);
    writeToBuff(tmp, designBuffer);
    cleanName(tmp);
    writeToBuff(" = ", designBuffer);
    itoa((ref / total), tmp);
    writeToBuff(tmp, designBuffer);
    writeToBuff(" !\n", designBuffer);


    return strlen(designBuffer);


}

int ReadFromInodeInfo(char *designBuffer, int IPinum) {

    char tmp[DIRSIZ];
    int validInum[NINODE] = {0};
    int count = readIcacheFS(validInum);

    for(int i=0; i<count; i++){
        itoa(i, tmp);
        writeDirentToBuff(i, tmp, VIRTUALINODEINFO + validInum[i], designBuffer);
        cleanName(tmp);
    }
    //TODO WE MUST OVERVIEW THIS LINE AGAIN
//    count--;
    return sizeof(struct dirent) * count;
}

int ReadVirtInfo(char *designBuffer, int IPinum) {
    int inumIndex = IPinum - VIRTUALINODEINFO;
    char tmp[DIRSIZ];
    int output=0;

    struct inode *ind = getInodeFromChache(inumIndex);
    if (!ind) //validation check
    {
        panic("ERROR - ReafFromInodeInfo: INODE IS NULL!");
    }


    writeToBuff("\nDevice:\t", designBuffer);
    itoa(ind->dev, tmp);
    writeToBuff(tmp, designBuffer);

    output=strlen("\nDevice:\t");
    output+=strlen(tmp);
    cleanName(tmp);

    writeToBuff("\nInode number:\t", designBuffer);
    itoa(ind->inum, tmp);
    writeToBuff(tmp, designBuffer);

    output+=strlen("\nInode number:\t");
    output+=strlen(tmp);
    cleanName(tmp);

    writeToBuff("\nis valid:\t", designBuffer);
    output+=strlen("\nis valid:\t");
    if (ind->valid == VALID) {
        itoa(1, tmp);
    }
    else
        itoa(0, tmp);
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    cleanName(tmp);

    writeToBuff("\ntype:\t", designBuffer);
    output+=strlen("\ntype:\t");

    switch (ind->type) {
        case T_DIR:
            writeToBuff("DIR",tmp);
            break;
        case T_FILE:
            writeToBuff("FILE",tmp);
            break;
        case T_DEV:
            writeToBuff("DEV",tmp);
            break;
        default:
            panic("ERROR - switch (ind->type): UNKNOWN TYPE!");
    }

    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    cleanName(tmp);

    writeToBuff("\nmajor minor:\t( ", designBuffer);
    output+=strlen("\nmajor minor:\t( ");
    itoa(ind->major, tmp);
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);

    writeToBuff(" , ", designBuffer);
    output+=strlen(" , ");
    cleanName(tmp);
    itoa(ind->minor, tmp);
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);

    writeToBuff(" )", designBuffer);
    output+=strlen(" )");
    cleanName(tmp);

    writeToBuff("\nhard link:\t", designBuffer);
    output+=strlen("\nhard link:\t");
    itoa(ind->nlink, tmp);
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    cleanName(tmp);

    if (ind->type == T_DEV)
        itoa(0, tmp);
    else {
        int counter = 0;
        for (int i = 0; i < NDIRECT + 1; i++) {
            if (ind->addrs[i])//if pointer==0 ->not used block
                counter++;
        }
        itoa(counter, tmp);
    }
    writeToBuff("\nblock used:\t", designBuffer);
    output+=strlen("\nblock used:\t");
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    writeToBuff("\n", designBuffer);
    output+=strlen("\n");


    return output;
}



int ReadFromIdeInfo(char *designBuffer, int IPinum) {

    int waitingCounter = 0, readCounter = 0, writeCounter = 0;
    int *block[100] = {0};
    int *dev[100] = {0};
    char tmp[DIRSIZ];

    int listSize = getIdeQeueue( &waitingCounter, &readCounter, &writeCounter,
                               *block, *dev);


    writeToBuff("\nWaiting operations:\t", designBuffer);
    if(waitingCounter == 0 )
        writeToBuff("0", designBuffer);
    else {
        itoa(waitingCounter, tmp);
        writeToBuff(tmp, designBuffer);
    }

    cleanName(tmp);
    writeToBuff("\nRead waiting operations:\t", designBuffer);
    if(readCounter == 0 )
        writeToBuff("0", designBuffer);
    else {
        itoa(readCounter, tmp);
        writeToBuff(tmp, designBuffer);
    }

    cleanName(tmp);
    writeToBuff("\nWrite waiting operations:\t", designBuffer);
    if(writeCounter == 0 )
        writeToBuff("0", designBuffer);
    else {
        itoa(writeCounter, tmp);
        writeToBuff(tmp, designBuffer);
    }

    cleanName(tmp);
    writeToBuff("\nWorking blocks:\t", designBuffer);
    writeToBuff("(", designBuffer);

    int count = 0;
    if (listSize == 0) { //IF EMPTY PTR ->EMPTY LIST
        writeToBuff(" )\n", designBuffer);
    } else { //ELSE -> ITERATE  OVER THE LIST

        int k = 0;
        while( k < listSize ) {
            writeToBuff("( ", designBuffer);
            itoa(*dev[k], tmp);
            writeToBuff(tmp, designBuffer);
            writeToBuff(" , ", designBuffer);

            cleanName(tmp);
            itoa(*block[k], tmp);
            writeToBuff(tmp, designBuffer);
            writeToBuff(" )", designBuffer);

            k++;

            if (k < listSize ) { //if last->print without delimiter
                writeToBuff("  ;  ", designBuffer);
                if (count % 5 == 0)
                    writeToBuff("\n  \t", designBuffer);
                //GOT HERE - NEXT ITERATION
                count++;
            }
            else
                writeToBuff(" )\n", designBuffer);

        }
    }
   return strlen(designBuffer);
}


int ReadPid(char *designBuffer, int IPinum) {
    int proc = -1, currDirent = 0;
    struct proc *currproc = 0;


    if (IPinum >= sbInodes + PROCINODES) {
        proc = ((IPinum - sbInodes) / PROCINODES) - 1;
    }

    currproc = getProc(proc);


    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");


    writeDirentToBuff(currDirent, ".", IPinum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "..", namei("/proc")->inum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "name", IPinum + 1, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "status", IPinum + 2, designBuffer);
    currDirent++;

    return sizeof(struct dirent) * currDirent;
//    return strlen(designBuffer);

}



int ReadPidName(char *designBuffer, int IPinum) {
    int proc = -1;
    struct proc *currproc = 0;

    if (IPinum >= sbInodes + PROCINODES) {
        proc = ((IPinum - sbInodes) / PROCINODES) - 1;
    }

   currproc = getProc(proc);

    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");

    writeToBuff(currproc->name, designBuffer);
    return strlen(designBuffer);

}


int ReadPidStatus(char *designBuffer, int IPinum) {
    char tmp[DIRSIZ];
    int proc = -1;

    if (IPinum >= sbInodes + PROCINODES)
        proc = (IPinum - sbInodes) / PROCINODES - 1;

    struct proc *currproc = 0;
    currproc = getProc(proc);
    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");



    writeToBuff("run state:\t", designBuffer);
    cleanName(tmp);
    switch (currproc->state) {
        case RUNNING:
            writeToBuff("RUNNING",tmp);
            break;
        case RUNNABLE:
            writeToBuff("RUNNABLE",tmp);
            break;
        case SLEEPING:
            writeToBuff("SLEEPING",tmp);
            break;
        case UNUSED:
            writeToBuff("UNUSED",tmp);
            break;
        case ZOMBIE:
            writeToBuff("ZOMBIE",tmp);
            break;
        case EMBRYO:
            writeToBuff("EMBRYO",tmp);
            break;
        default:
            panic("ERROR - WRONG STATE");
    }
    writeToBuff(tmp, designBuffer);
    cleanName(tmp);
    writeToBuff("\nsize (in bytes):\t", designBuffer);
    itoa(currproc->sz, tmp);
    writeToBuff(tmp, designBuffer);
    writeToBuff("\n", designBuffer);

    return strlen(designBuffer);

}


int
procfsisdir(struct inode *ip) {
    initSbInodes(ip);
    if (ip->type != T_DEV)
        return 0;
    if (ip->major != PROCFS)
        return 0;
    if (ip->inum == IDEINFO || ip->inum == FILESTAT )
        return 0;

    return (ip->inum < sbInodes || ( ip->inum - sbInodes) % PROCINODES == 0 || ip->inum == INODEINFO);
}

void
procfsiread(struct inode *dp, struct inode *ip) {
    ip->major = PROCFS;
    ip->valid = VALID;  //todo - maybe need to turn on flag ->  |=0x2
    ip->type = T_DEV;
    ip->nlink = 1;//todo
}

int
procfsread(struct inode *ip, char *dst, int off, int n) {
    initSbInodes(ip);

    char designBuffer[PGSIZE] = {0};
    int answer = 0, IPinum = ip->inum;
    cprintf("\nGOT inum %d\n" , ip->inum);

    if (IPinum == IDEINFO) {
        answer = ReadFromIdeInfo(designBuffer, IPinum);

        goto appliedFunc;
    }
    if (IPinum == FILESTAT) {
        answer = ReadFromFileStat(designBuffer, IPinum);

        goto appliedFunc;
    }
    if (IPinum == INODEINFO) {
        answer = ReadFromInodeInfo(designBuffer, IPinum);

        goto appliedFunc;
    }
    if (IPinum < sbInodes) {
        answer = ReadFromMemInodes(designBuffer, IPinum);

        goto appliedFunc;
    }
    if ((IPinum - sbInodes) % PROCINODES == 0) {
        answer = ReadPid(designBuffer, IPinum);

        goto appliedFunc;
    }
    if ((IPinum - sbInodes) % PROCINODES == 1) {
        answer = ReadPidName(designBuffer, IPinum);

        goto appliedFunc;
    }
    if ((IPinum - sbInodes) % PROCINODES == 2) {

        answer = ReadPidStatus(designBuffer, IPinum);
        goto appliedFunc;
    }

    if (IPinum >= VIRTUALINODEINFO) {
        answer = ReadVirtInfo(designBuffer, IPinum);

        goto appliedFunc;
    }

    panic(" Wrong IP -> INUM CAUSED THIS TRAP, procfsread");

    appliedFunc :

    memmove(dst, designBuffer + off, (uint) n);
    if (answer - off <= n)
        return (answer - off);
    else
        return n;
}

int
procfswrite(struct inode *ip, char *buf, int n) {
    cprintf("ERROR - Cannot write in this system\n");
    return -1;
}

void
procfsinit(void) {
    devsw[PROCFS].isdir = procfsisdir;
    devsw[PROCFS].iread = procfsiread;
    devsw[PROCFS].write = procfswrite;
    devsw[PROCFS].read = procfsread;
}
