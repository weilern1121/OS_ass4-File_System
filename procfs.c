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
        VIRTUALINODEINFO     = sbInodes + NPROC*(PROCINODES + 1); //offset for the virtual inodeInfo dirents
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
    int len = sizeof(name);
    memmove(designBuffer + strlen(designBuffer), name, (uint) len);
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
    getFileStat( &free, &total, &ref, &read, &write, &inode);

    //GOT HERE - WRITE OT BUFF
    char *tmp = "";
    writeToBuff("\nFree fds:\t", designBuffer);
    tmp = itoa(free, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    writeToBuff("\nUnique inode fds:\t", designBuffer);
    tmp = itoa(inode, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    writeToBuff("\nWriteable fds:\t", designBuffer);
    tmp = itoa(write, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    writeToBuff("\nReadable fds:\t", designBuffer);
    tmp = itoa(read, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    writeToBuff("\nRefs per fds:\t", designBuffer);
    tmp = itoa( ref, tmp);
    writeToBuff(tmp, designBuffer);
    tmp = "";
    writeToBuff(" / ", designBuffer);
    tmp = itoa( total, tmp);
    writeToBuff(tmp, designBuffer);
    tmp = "";
    writeToBuff(" = ", designBuffer);
    tmp = itoa( (ref / total) , tmp);
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

    struct inode *ind = readIcacheFS(1);

    if (!ind) //validation check
        panic("ERROR - ReafFromInodeInfo: INODE IS NULL!");




    for (int i = 0; i < NINODE; i++, ind++) {
        char *tmp = "";
        if (ind->ref > 0) {
            tmp = itoa(i, tmp);
            writeDirentToBuff(i, tmp, VIRTUALINODEINFO + i , designBuffer);

            //TODO we should create dirent list contain name of index
            //TODO and for each dirent the inode inum should be virtual
            //     so we can catch him later for information.

        }

    }

    readIcacheFS(0); //RELEASE LOCK
    return sizeof(designBuffer);

}

int ReadVirtInfo(char *designBuffer, int IPinum) {
    int inumIndex = IPinum - VIRTUALINODEINFO;
    struct inode *ind= readIcacheFS(1);
    char *tmp = "";

    if (!ind) //validation check
        panic("ERROR - ReafFromInodeInfo: INODE IS NULL!");

    while(inumIndex){
        ind++;
        inumIndex--;
    }
    //GOT HERE - IND POINTS TO THE REQUIRED INUM -> WRITE OT BUFF

    writeToBuff("Device:\t", designBuffer);
    tmp = itoa(ind->dev, tmp);
    writeToBuff(tmp,designBuffer);
    tmp = "";
    writeToBuff("\nInode number:\t", designBuffer);
    tmp = itoa(ind->inum, tmp);
    writeToBuff(tmp,designBuffer);
    tmp = "";
    writeToBuff("\nis valid:\t", designBuffer);
    if (ind->valid == VALID)
        tmp = itoa(1, tmp);
    else
        tmp = itoa(0, tmp);
    writeToBuff(tmp,designBuffer);
    tmp = "";
    writeToBuff("\ntype:\t", designBuffer);
    switch (ind->type) {
        case T_DIR:
            tmp = "DIR";
            break;
        case T_FILE:
            tmp = "FILE";
            break;
        case T_DEV:
            tmp = "DEV";
            break;
        default:
            panic("ERROR - switch (ind->type): UNKNOWN TYPE!");
    }
    writeToBuff(tmp,designBuffer);
    tmp = "";
    writeToBuff("\nmajor minor:\t( ", designBuffer);
    tmp = itoa(ind->major, tmp);
    writeToBuff(tmp,designBuffer);
    writeToBuff(" , ", designBuffer);
    tmp = "";
    tmp = itoa(ind->minor, tmp);
    writeToBuff(tmp,designBuffer);
    writeToBuff(" )\n", designBuffer);
    tmp = "";
    writeToBuff("\nhard link:\t", designBuffer);
    tmp = itoa(ind->nlink, tmp); //TODO - NOT SURE THAT THIS IS THE RELEVANT FIELD
    writeToBuff(tmp,designBuffer);
    tmp = "";
    if(ind->type == T_DEV)
        tmp = itoa(0 , tmp);
    else {
        int counter = 0;
        for (int i = 0; i < NDIRECT + 1; i++) {
            if (ind->addrs[i])//if pointer==0 ->not used block
                counter++;
        }
        tmp = itoa(counter, tmp); //TODO - NOT SURE THAT THIS IS THE RELEVANT FIELD
    }
    writeToBuff("\nblock used:\t", designBuffer);
    writeToBuff(tmp,designBuffer);
    writeToBuff("\n", designBuffer);


    readIcacheFS(0); //RELEASE LOCK
    return sizeof(designBuffer);


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


    struct buf *tmpNode = getIdeQeueue(1);
    if (!tmpNode) //validation check
        panic("ERROR - ReafFromIdeInfo: IDEQUEUE IS NULL!");

    int waitingCounter=0, readCounter=0, writeCounter=0;

    while(tmpNode){
        waitingCounter++;
        if(tmpNode->flags & IDE_CMD_READ) //READ OPERATION
            readCounter++;
        if(tmpNode->flags & IDE_CMD_WRITE) //WRITE OPERATION
            writeCounter++;
        tmpNode=tmpNode->next;
    }
    //GOT HERE - WRITE TO BUFF
    char *tmp = "";
    writeToBuff("\nWaiting operations:\t", designBuffer);
    tmp = itoa(waitingCounter, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    writeToBuff("\nRead waiting operations:\t", designBuffer);
    tmp = itoa(readCounter, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    writeToBuff("\nWrite waiting operations:\t", designBuffer);
    tmp = itoa(writeCounter, tmp);
    writeToBuff(tmp, designBuffer);

    tmp = "";
    //GOT HERE - WRITE TO BUFF ALL IDEQUEUE
    writeToBuff("\nWorking blocks:\t", designBuffer);
    getIdeQeueue(0);
    tmpNode=getIdeQeueue(1);

    if (!tmpNode) //validation check
        panic("ERROR - ReafFromIdeInfo: IDEQUEUE IS NULL!(2)");

    writeToBuff("(\t", designBuffer);
    int count = 0;

    while(tmpNode){
        writeToBuff("( ", designBuffer);
        tmp = itoa(tmpNode->dev, tmp);
        writeToBuff( tmp, designBuffer);
        writeToBuff( " , ", designBuffer);

        tmp = "";
        tmp=itoa(tmpNode->blockno,tmp);
        writeToBuff( tmp, designBuffer);
        writeToBuff( " )", designBuffer);

        if(tmpNode->next) //if last->print without delimiter
            writeToBuff( "  ;  ", designBuffer);
        else
            writeToBuff(" )\n", designBuffer);

        if( count % 5 == 0 )
            writeToBuff("\n  \t", designBuffer);
        //GOT HERE - NEXT ITERATION
        count++;
        tmpNode=tmpNode->next;
    }

    getIdeQeueue(0);
    return sizeof(designBuffer);
}




int ReadPidName(char *designBuffer, int IPinum ) {
    int proc=-1, procFd, currDirent = 0;
    char *tmp = "";
    struct proc *currproc=0;
    char searchDir[20];

    procInodeIndex(IPinum, &proc, &procFd, 0);
    currproc = getProc(proc);

    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");

    writeToBuff("/proc/" , searchDir);
    tmp = itoa( currproc->pid , tmp );
    writeToBuff( tmp , searchDir);

    writeDirentToBuff(currDirent, ".", namei(searchDir)->inum, designBuffer);
    currDirent++;
    writeDirentToBuff(currDirent, "..", namei("/proc/")->inum, designBuffer);
    currDirent++;

    writeToBuff( currproc->name , designBuffer );
    //currDirent++;


    //TODO how to link the name of process
    //writeDirentToBuff(currDirent, "name", sbInodes + 1 + ( (proc + 1) * PROCINODES ) , designBuffer);
    //currDirent++;
    //writeDirentToBuff(currDirent, "status", sbInodes + 2 + ( (proc + 1) * PROCINODES ) , designBuffer);
    //currDirent++;

    return ( sizeof(struct dirent) * currDirent + sizeof(currproc->name));
}



int ReadPidStatus(char *designBuffer, int IPinum ) {
    char *tmp = "";
    int proc=-1,procFd;
    procInodeIndex(IPinum,&proc,&procFd,0);

    struct proc *currproc=0;
    currproc= getProc(proc);
    if (!currproc) //validation check
        panic("ERROR - ReadPidStatus: PROC IS NULL!");

    //START WRITE - NAME OF FOLDER
    writeToBuff("/proc/", designBuffer);
    tmp = itoa(currproc->pid, tmp);
    writeToBuff(tmp,designBuffer);
    writeToBuff("/status",designBuffer);
    writeToBuff("\n run state:\t",designBuffer);
    tmp="";
    switch(currproc->state){
        case RUNNING:
            tmp="RUNNING";
            break;
        case RUNNABLE:
            tmp="RUNNABLE";
            break;
        case SLEEPING:
            tmp="SLEEPING";
            break;
        case UNUSED:
            tmp="UNUSED";
            break;
        case ZOMBIE:
            tmp="ZOMBIE";
            break;
        case EMBRYO:
            tmp="EMBRYO";
            break;
        default:
            panic("ERROR - WRONG STATE");
    }
    writeToBuff(tmp,designBuffer);
    tmp="";
    writeToBuff("\nsize (in bytes):\t",designBuffer);
    tmp=itoa(currproc->sz,tmp);
    writeToBuff(tmp,designBuffer);
    writeToBuff("\n",designBuffer);

    return sizeof(designBuffer);

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
    ip->nlink = 1;//todo
}

int
procfsread(struct inode *ip, char *dst, int off, int n) {
    initSbInodes(ip);

    char designBuffer[PGSIZE] = {0};
    int answer = 0, IPinum = ip->inum;

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

        answer = ReadFromMemInodes(designBuffer, IPinum);

        goto appliedFunc;
    }
    if ( (IPinum-sbInodes) % PROCINODES == 0) {
        answer = ReadPidName ( designBuffer, IPinum );

        goto appliedFunc;
    }
    if ( (IPinum-sbInodes) % PROCINODES == 1) {
        answer = ReadPidStatus ( designBuffer, IPinum );
        goto appliedFunc;
    }

    if (IPinum >= VIRTUALINODEINFO){
        answer = ReadVirtInfo ( designBuffer , IPinum);

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
