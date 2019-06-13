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

int sbInodes = 0;
int IDEINFO = 0;
int FILESTAT = 0;
int INODEINFO = 0;


void initSbInodes(struct inode *ip) {
    if (!sbInodes) {
        struct superblock sb;
        readsb(ip->dev, &sb);
        sbInodes = sb.ninodes;
        IDEINFO = sbInodes + 1;
        FILESTAT = sbInodes + 2;
        INODEINFO = sbInodes + 3;
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
    return str;
}


void procInodeIndex(int IPinum, int *proc, int *procfd, int flag) {

    if (IPinum >= sbInodes + PROCINODES) {
        *proc = (IPinum - sbInodes) / PROCINODES - 1;

        if (flag) {
            if ((IPinum % PROCINODES) >= 10)
                *procfd = (IPinum % PROCINODES) - 10;
            else
                panic("flag is on while not expected");
        }
    }
}

void writeDirentToBuff(int currDirent, char *name, int IPinum, char *designBuffer) {
    struct dirent newDirent;
    newDirent.inum = (ushort) IPinum;

    memmove(&newDirent.name, name, (uint) (strlen(name) + 1));

    int size = sizeof(newDirent);
    int offset = currDirent * size;
    memmove(designBuffer + offset, &newDirent, (uint) size);

}

void writeToBuff(char *name, char *designBuffer){
    if(!name)
        panic("ERROR - writeToBuff: NAME IS NULL!");
    int len = sizeof(name);
    memmove(designBuffer+strlen(designBuffer), designBuffer, (uint) len);
}

void cleanName(char *name) {
    for (int i = 0; i < NAMESIZE; i++)
        name[i] = 0;
}


//todo - not sure that need to send IPnum as argument to this specific func!
int ReadFromMemInodes(char *designBuffer, int IPinum) {
    int currDirent = 0;
    writeDirentToBuff(currDirent, ".", namei("/proc")->inum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "..", namei("")->inum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "ideInfo", IDEINFO, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "fileStat", FILESTAT, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "inodeInfo", INODEINFO, designBuffer);
    currDirent++;

    int procName[NPROC] = {0}; //array of RUNNING/RUNNABLE/SLEEPING procs
    char procNameString[NAMESIZE] = {0}; //used to iota the pid to string

    int numProcs = getValidProcs(procName);

    for (int i = 0; i < numProcs; i++) {
        cleanName(procNameString);
        char *pidNameInString = itoa(procName[i], procNameString);
        int currLocation = sbInodes + 50 * (i + 1);

        writeDirentToBuff(currDirent, pidNameInString, currLocation, designBuffer);
        currDirent++;
    }

    //TEST : in this point currDirent should be == numProcs+5
    return currDirent * sizeof(struct dirent);
//    return output;

}

void getPath(char searchDir , int fileIndex , char *folder){
    int currPid = getPid(fileIndex);
    //first - write to path the folder
    memmove((void *) (searchDir + sizeof(folder)), folder, sizeof(*folder));
    //secondly - write the pid
    char *pidInString ="";
    itoa(currPid, pidInString);
    memmove((void *) (searchDir + sizeof(*pidInString)), pidInString, sizeof(*pidInString));
    //NOW searchDir HOLDS: folder/pid
}

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

int ReafFromFileStat(char *designBuffer, int IPinum) {
    int fileIndex = IPinum % 50;  //%50 -> for this inum
//    int fdIndex = IPinum%50 -10; //%50 -> for this inum ; -10 -> for moving to currplace
    struct file **file;
    file = getProcFile(fileIndex); //file points to file[16] array
    int arr[NOFILE] ={0};
    if (!file) //validation check
        panic("ERROR - ReafFromFileStat: FILE IS NULL!");
    //start write
    int currDirent = 1;
    char searchDir[20];
    getPath((char) searchDir, fileIndex , "/proc/");
    writeDirentToBuff(currDirent, "..", namei(searchDir)->inum, designBuffer);
    currDirent--;
    memmove((void *) (searchDir + sizeof("/fdinfo/")), "/fdinfo/", sizeof("/fdinfo/"));
    writeDirentToBuff(currDirent, ".", namei(searchDir)->inum, designBuffer);

    //GOT HERE - FOREACH FD  ACCUMULATE RELEVANT COUNTER
    int freeFdCounter=0, writableCounter=0, readableCounter=0, totalRefCounter=0;
    for(int i=0; i>NOFILE; i++){
        if(!file[i]->ref)
            freeFdCounter++;
        if(file[i]->writable)
            writableCounter++;
        if(file[i]->readable)
            readableCounter++;
        totalRefCounter+=file[i]->ref;
        //init arr ->holds the inumIp
        arr[i]=file[i]->ip->inum;
    }
    int usedFds = NOFILE-freeFdCounter;
    int refsPerFds = totalRefCounter/usedFds; //TODO - MIGHT BE DOUBLE
    //GOT HERE - NEED TO CALCULATE UNIQUE INODE FDS
    int uniqueNum = countDistinct(arr,NOFILE);

    //GOT HERE - WRITE OT BUFF
    char *tmp="";
    writeToBuff("Free fds:\t",designBuffer);
    tmp=itoa(freeFdCounter,tmp);
    writeToBuff("%d\n",tmp);
    tmp="";
    writeToBuff("Unique inode fds:\t",designBuffer);
    tmp=itoa(uniqueNum,tmp);
    writeToBuff("%d\n",tmp);
    tmp="";
    writeToBuff("Unique inode fds:\t",designBuffer);
    tmp=itoa(uniqueNum,tmp);
    writeToBuff("%d\n",tmp);
    tmp="";
    writeToBuff("Writeable fds:\t",designBuffer);
    tmp=itoa(writableCounter,tmp);
    writeToBuff("%d\n",tmp);
    tmp="";
    writeToBuff("Readable fds:\t",designBuffer);
    tmp=itoa(readableCounter,tmp);
    writeToBuff("%d\n",tmp);
    tmp="";
    writeToBuff("Refs per fds:\t",designBuffer);
    tmp=itoa(refsPerFds,tmp);
    writeToBuff("%d\n",tmp);


    return strlen(designBuffer);


}

int
procfsisdir(struct inode *ip) {
    initSbInodes(ip);
    if (ip->type != T_DEV)
        return 0;
    if (ip->major != PROCFS)
        return 0;
    if (ip->inum == IDEINFO || ip->inum == FILESTAT || ip->inum == INODEINFO)
        return 0;

    return (ip->inum < sbInodes || ip->inum % PROCINODES == 0 || ip->inum % PROCINODES == 1);
}

void
procfsiread(struct inode *dp, struct inode *ip) {
    ip->major = PROCFS;
    ip->valid = VALID;  //todo - maybe need to turn on flag ->  |=0x2
    ip->type = T_DEV;
}

int
procfsread(struct inode *ip, char *dst, int off, int n) {
    initSbInodes(ip);

    char designBuffer[PGSIZE] = {0};
    int answer = 0, IPinum = ip->inum;

    // procfd = file index after control and space block, or each proc size 50 block
    int procfd = (IPinum % PROCINODES) - INODESSPACE;

    if (IPinum == IDEINFO) {

        goto appliedFunc;
    }
    if (IPinum == FILESTAT) {
        answer = ReafFromFileStat(designBuffer, IPinum);

        goto appliedFunc;
    }
    if (IPinum == INODEINFO) {

        goto appliedFunc;
    }
    if (IPinum < sbInodes) {
        answer = ReadFromMemInodes(designBuffer, IPinum);

        goto appliedFunc;
    }
    if (IPinum % PROCINODES == 0) {

        goto appliedFunc;
    }
    if (IPinum % PROCINODES == 1) {

        goto appliedFunc;
    }
    if (0 <= procfd && procfd < NOFILE) {

        goto appliedFunc;
    }

    panic(" Wrong IP -> INUM CAUSED THIS TRAP, procfsread");

    appliedFunc :

    memmove(dst, designBuffer + off, n);
    if (answer >= off + n)
        return (answer - off);
    else
        return n;
}

int
procfswrite(struct inode *ip, char *buf, int n) {
    panic("Cannot write in this system");
}

void
procfsinit(void) {
    devsw[PROCFS].isdir = procfsisdir;
    devsw[PROCFS].iread = procfsiread;
    devsw[PROCFS].write = procfswrite;
    devsw[PROCFS].read = procfsread;
}
