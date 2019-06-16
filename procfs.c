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


void procInodeIndex(int IPinum, int *proc, int *procfd, int flag) {

    if (IPinum >= sbInodes + PROCINODES) {
        *proc = (IPinum - sbInodes) / PROCINODES - 1;

        //TODO - NOT SURE THAT NEED THIS PART BELOW -
        //TODO - THE ONLY PART THAT NEED THIS FLAG ON IS : fd >= 0 && fd <= NOFILE
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
    //cprintf("GOT inum inside fuck %d\n" , IPinum);
    //cprintf("GOT inum inside fuck22 %d\n" , namei("/proc")->inum);

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
//    return output;

}

void getPath(char searchDir, int fileIndex, char *folder) {
    int currPid = getPid(fileIndex);
    //first - write to path the folder
    memmove((void *) (searchDir + sizeof(folder)), folder, sizeof(*folder));
    //secondly - write the pid
    char *pidInString = "";
    itoa(currPid, pidInString);
    memmove((void *) (searchDir + sizeof(*pidInString)), pidInString, sizeof(*pidInString));
    //NOW searchDir HOLDS: folder/pid
}


int ReadFromFileStat(char *designBuffer, int IPinum) {
    /*int proc,procFd;
    procInodeIndex(IPinum,&proc,&procFd,0);
    struct file **file;
    file = getProcFile(proc); //file points to file[16] array
    int arr[NOFILE] = {0};
    if (!file) //validation check
        panic("ERROR - ReafFromFileStat: FILE IS NULL!");
    //start write
    int currDirent = 1;
    char searchDir[20];


    getPath((char) searchDir, proc, "/proc/");
    writeDirentToBuff(currDirent, "..", namei(searchDir)->inum, designBuffer);
    currDirent--;
    memmove((void *) (searchDir + sizeof("/fdinfo/")), "/fdinfo/", sizeof("/fdinfo/"));
    writeDirentToBuff(currDirent, ".", namei(searchDir)->inum, designBuffer);

    //GOT HERE - FOREACH FD  ACCUMULATE RELEVANT COUNTER
    int freeFdCounter = 0, writableCounter = 0, readableCounter = 0, totalRefCounter = 0;
    for (int i = 0; i > NOFILE; i++) {
        if (!file[i]->ref)
            freeFdCounter++;
        if (file[i]->writable)
            writableCounter++;
        if (file[i]->readable)
            readableCounter++;
        totalRefCounter += file[i]->ref;
        //init arr ->holds the inumIp
        arr[i] = file[i]->ip->inum;
    }
    int usedFds = NOFILE - freeFdCounter;
    int refsPerFds = totalRefCounter / usedFds; //TODO - MIGHT BE DOUBLE
    //GOT HERE - NEED TO CALCULATE UNIQUE INODE FDS
    int uniqueNum = countDistinct(arr, NOFILE);*/


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
    //int proc,procFd;
    //procInodeIndex(IPinum,&proc,&procFd,0);

    //START WRITE - NAME OF FOLDER

    /*int currDirent = 1;
    char searchDir[20];
        getPath((char) searchDir, proc, "/proc/");
        writeDirentToBuff(currDirent, "..", namei(searchDir)->inum, designBuffer);
        currDirent--;
        memmove((void *) (searchDir + sizeof("/inodeinfo/")), "/inodeinfo/", sizeof("/inodeinfo/"));
        writeDirentToBuff(currDirent, ".", namei(searchDir)->inum, designBuffer);
*/

    /*struct inode *ind = readIcacheFS(1);

    if (!ind) //validation check
        panic("ERROR - ReafFromInodeInfo: INODE IS NULL!");


    int count=0;
    for (int i = 0; i < NINODE; i++, ind++) {
        char tmp[DIRSIZ];
        if (ind->ref > 0) {
            count++;
            itoa(i, tmp);
            cprintf("writeDirentToBuff i= %d\tvirt_offset=%d\n",i,i+VIRTUALINODEINFO);
            writeDirentToBuff(i, tmp, VIRTUALINODEINFO + i, designBuffer);

            //TODO we should create dirent list contain name of index
            //TODO and for each dirent the inode inum should be virtual
            //     so we can catch him later for information.

        }

    }

    readIcacheFS(0); //RELEASE LOCK
//    return sizeof(designBuffer);

    cprintf("count=:%d\n",count);*/
    char tmp[DIRSIZ];
    int validInum[NINODE] = {0};
    int count = readIcacheFS(validInum);
    for(int i=0; i<count; i++){
        itoa(i, tmp);
        //cprintf("*validInum[i]=%d\n",validInum[i]);
        //cprintf("writeDirentToBuff i= %d\tvirt_offset=%d\n",i,VIRTUALINODEINFO + validInum[i]);
        writeDirentToBuff(i, tmp, VIRTUALINODEINFO + validInum[i], designBuffer);
        cleanName(tmp);
    }
    count--;
    return sizeof(struct dirent) * count;
}

int ReadVirtInfo(char *designBuffer, int IPinum) {
    int inumIndex = IPinum - VIRTUALINODEINFO;
//    cprintf("index= %d\n",inumIndex);
//    struct inode *ind = readIcacheFS(1);
    struct inode *ind = getInodeFromChache(inumIndex);
    char tmp[DIRSIZ];
    if (!ind) //validation check
        panic("ERROR - ReafFromInodeInfo: INODE IS NULL!");
    int output=0;
    /*while (inumIndex) {
        ind++;
        inumIndex--;
    }*/

    //GOT HERE - IND POINTS TO THE REQUIRED INUM -> WRITE OT BUFF
    output=strlen("\nDevice:\t");
    writeToBuff("\nDevice:\t", designBuffer);
    itoa(ind->dev, tmp);
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    cleanName(tmp);
    writeToBuff("\nInode number:\t", designBuffer);
    output+=strlen("\nInode number:\t");
    itoa(ind->inum, tmp);
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    cleanName(tmp);
    writeToBuff("\nis valid:\t", designBuffer);
    output+=strlen("\nis valid:\t");
    if (ind->valid == VALID)
        itoa(1, tmp);
    else
        itoa(0, tmp);
    writeToBuff(tmp, designBuffer);
    output++;
    cleanName(tmp);
    writeToBuff("\ntype:\t", designBuffer);
    output+=strlen("\ntype:\t");
    switch (ind->type) {
        case T_DIR:
            writeToBuff("DIR",tmp);
//            tmp = "DIR";
            break;
        case T_FILE:
            writeToBuff("FILE",tmp);
//            tmp = "FILE";
            break;
        case T_DEV:
            writeToBuff("DEV",tmp);
//            tmp = "DEV";
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
    itoa(ind->nlink, tmp); //TODO - NOT SURE THAT THIS IS THE RELEVANT FIELD
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
        itoa(counter, tmp); //TODO - NOT SURE THAT THIS IS THE RELEVANT FIELD
    }
    writeToBuff("\nblock used:\t", designBuffer);
    output+=strlen("\nblock used:\t");
    writeToBuff(tmp, designBuffer);
    output+=strlen(tmp);
    writeToBuff("\n", designBuffer);
    output+=strlen("\n");


//    readIcacheFS(0); //RELEASE LOCK
//    return sizeof(designBuffer);
    return output;


}


#define IDE_CMD_READ  0x20
#define IDE_CMD_WRITE 0x30

int ReadFromIdeInfo(char *designBuffer, int IPinum) {
    /* int fileIndex = IPinum % 50;  //%50 -> for this inum
      //START WRITE - NAME OF FOLDER
     int currDirent = 1;
     char searchDir[20];
     getPath((char) searchDir, fileIndex, "/proc/");
     writeDirentToBuff(currDirent, "..", namei(searchDir)->inum, designBuffer);
     currDirent--;
     memmove((void *) (searchDir + sizeof("/ideinfo/")), "/ideinfo/", sizeof("/ideinfo/"));
     writeDirentToBuff(currDirent, ".", namei(searchDir)->inum, designBuffer);
     //GOT HERE - GET ALL THE FUNCTUALITIES*/


//    if (!tmpNode) //validation check
//        panic("ERROR - ReafFromIdeInfo: IDEQUEUE IS NULL!");


//    while (tmpNode) {
//        waitingCounter++;
//        if (tmpNode->flags & IDE_CMD_READ) //READ OPERATION
//            readCounter++;
//        if (tmpNode->flags & IDE_CMD_WRITE) //WRITE OPERATION
//            writeCounter++;
//        tmpNode = tmpNode->next;
//    }


    int waitingCounter = 0, readCounter = 0, writeCounter = 0;
    int *block[50] = {0};
    int *dev[50] = {0};

    int listSize = getIdeQeueue( &waitingCounter, &readCounter, &writeCounter,
                               *block, *dev);

    //cprintf(" %d as %d asd %d " ,waitingCounter , readCounter , writeCounter );

    //GOT HERE - WRITE TO BUFF
    char tmp[DIRSIZ];
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
    //GOT HERE - WRITE TO BUFF ALL IDEQUEUE


    cleanName(tmp);
    writeToBuff("\nWorking blocks:\t", designBuffer);
    writeToBuff("(", designBuffer);

    int count = 0;
    if (listSize == 0) { //IF EMPTY PTR ->EMPTY LIST
        writeToBuff(" , )\n", designBuffer);
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


int ReadPidName(char *designBuffer, int IPinum) {
    int proc = -1, currDirent = 0;
    char tmp[DIRSIZ];
    struct proc *currproc = 0;
    char searchDir[20];

//    procInodeIndex(IPinum, &proc, &procFd, 0);
    if (IPinum >= sbInodes + PROCINODES) {
        proc = ((IPinum - sbInodes) / PROCINODES) - 1;
    }

    cprintf("SBINODE: %d \tGETPROC : %d\n",sbInodes,proc);

    currproc = getProc(proc);
    cprintf("AFTER GETPROC");


    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");

    writeToBuff("/proc", searchDir);
    itoa(currproc->pid, tmp);
    writeToBuff(tmp, searchDir);

//    writeDirentToBuff(currDirent, ".", namei(searchDir)->inum, designBuffer);
//    currDirent++;
    writeDirentToBuff(currDirent, "..", namei("/proc")->inum, designBuffer);
    currDirent++;

    writeToBuff("kname", designBuffer);
//    writeToBuff(currproc->name, designBuffer);//TODO - WRONG VALUE HERE
    //currDirent++;


    //TODO how to link the name of process
    //writeDirentToBuff(currDirent, "name", sbInodes + 1 + ( (proc + 1) * PROCINODES ) , designBuffer);
    //currDirent++;
    //writeDirentToBuff(currDirent, "status", sbInodes + 2 + ( (proc + 1) * PROCINODES ) , designBuffer);
    //currDirent++;

    return strlen(designBuffer);

//    return (sizeof(struct dirent) * currDirent + sizeof(currproc->name));
}



int ReadPidStatus(char *designBuffer, int IPinum) {
    char tmp[DIRSIZ];
    int proc = -1, procFd;
    procInodeIndex(IPinum, &proc, &procFd, 0);

    struct proc *currproc = 0;
    currproc = getProc(proc);
    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");

    //START WRITE - NAME OF FOLDER
    writeToBuff("/proc", designBuffer);
    itoa(currproc->pid, tmp);
    writeToBuff(tmp, designBuffer);
    writeToBuff("/status", designBuffer);
    writeToBuff("\n run state:\t", designBuffer);
    cleanName(tmp);
    switch (currproc->state) {
        case RUNNING:
            writeToBuff("RUNNING",tmp);
//            tmp = "RUNNING";
            break;
        case RUNNABLE:
            writeToBuff("RUNNABLE",tmp);
//            tmp = "RUNNABLE";
            break;
        case SLEEPING:
            writeToBuff("SLEEPING",tmp);
//            tmp = "SLEEPING";
            break;
        case UNUSED:
            writeToBuff("UNUSED",tmp);
//            tmp = "UNUSED";
            break;
        case ZOMBIE:
            writeToBuff("ZOMBIE",tmp);
//            tmp = "ZOMBIE";
            break;
        case EMBRYO:
            writeToBuff("EMBRYO",tmp);
//            tmp = "EMBRYO";
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

    return sizeof(designBuffer);

}


int
procfsisdir(struct inode *ip) {
    initSbInodes(ip);
    if (ip->type != T_DEV)
        return 0;
    if (ip->major != PROCFS)
        return 0;
    if (ip->inum == IDEINFO || ip->inum == FILESTAT )//|| ip->inum == INODEINFO)
        return 0;

//    return (ip->inum < sbInodes || ip->inum % PROCINODES == 0 || ip->inum % PROCINODES == 1);
    return (ip->inum < sbInodes || ip->inum % PROCINODES == 0 || ip->inum % PROCINODES == 1|| ip->inum == INODEINFO);
}

void
procfsiread(struct inode *dp, struct inode *ip) {
    ip->major = PROCFS;
    ip->valid = VALID;  //todo - maybe need to turn on flag ->  |=0x2
    ip->type = T_DEV;
    //ip->nlink = 1;//todo
}

int
procfsread(struct inode *ip, char *dst, int off, int n) {
    initSbInodes(ip);

    char designBuffer[PGSIZE] = {0};
    int answer = 0, IPinum = ip->inum;
    cprintf("\nGOT inum %d\n" , ip->inum);
    //cprintf("GOT IDEINFO %d\n" , IDEINFO);
    //cprintf("GOT FILESTAT %d\n" , FILESTAT);
    //cprintf("GOT sbInodes %d\n" , sbInodes);
    //cprintf("GOT VIRTUALINODEINFO %d\n" , VIRTUALINODEINFO);

    // procfd = file index after control and space block, or each proc size 50 block
//    int procfd = (IPinum % PROCINODES) - INODESSPACE;

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
//        cprintf("GOT inum map case %d\n" , IPinum);

        answer = ReadFromMemInodes(designBuffer, IPinum);
        //cprintf("GOT ANSWER fuck %d\n" , answer);

        goto appliedFunc;
    }
    if ((IPinum - sbInodes) % PROCINODES == 0) {
        cprintf("CHECKPOINT1: IPnum: %d\n",IPinum);
        answer = ReadPidName(designBuffer, IPinum);

        goto appliedFunc;
    }
    if ((IPinum - sbInodes) % PROCINODES == 1) {

        answer = ReadPidStatus(designBuffer, IPinum);
        goto appliedFunc;
    }

    if (IPinum >= VIRTUALINODEINFO) {
//        cprintf("CHECKPOINT1: IPnum: %d\n",IPinum);
        answer = ReadVirtInfo(designBuffer, IPinum);

        goto appliedFunc;
    }
    /*if (0 <= procfd && procfd < NOFILE) {
            inode info()
        //TODO
        goto appliedFunc;
    }*/

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
    panic("Cannot write in this system");
}

void
procfsinit(void) {
    devsw[PROCFS].isdir = procfsisdir;
    devsw[PROCFS].iread = procfsiread;
    devsw[PROCFS].write = procfswrite;
    devsw[PROCFS].read = procfsread;
}
