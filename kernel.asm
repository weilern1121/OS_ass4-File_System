
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc e0 d5 10 80       	mov    $0x8010d5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 32 10 80       	mov    $0x801032a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 14 d6 10 80       	mov    $0x8010d614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 8a 10 80       	push   $0x80108a40
80100051:	68 e0 d5 10 80       	push   $0x8010d5e0
80100056:	e8 45 47 00 00       	call   801047a0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 1d 11 80 dc 	movl   $0x80111cdc,0x80111d2c
80100062:	1c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 1d 11 80 dc 	movl   $0x80111cdc,0x80111d30
8010006c:	1c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 1c 11 80       	mov    $0x80111cdc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 8a 10 80       	push   $0x80108a47
80100097:	50                   	push   %eax
80100098:	e8 d3 45 00 00       	call   80104670 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 1d 11 80       	mov    0x80111d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 1c 11 80       	cmp    $0x80111cdc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 e0 d5 10 80       	push   $0x8010d5e0
801000e4:	e8 f7 47 00 00       	call   801048e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 1d 11 80    	mov    0x80111d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 2c 1d 11 80    	mov    0x80111d2c,%ebx
80100126:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 1c 11 80    	cmp    $0x80111cdc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100162:	e8 39 48 00 00       	call   801049a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 45 00 00       	call   801046b0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 23 00 00       	call   80102490 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 8a 10 80       	push   $0x80108a4e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 9d 45 00 00       	call   80104750 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 c7 22 00 00       	jmp    80102490 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 8a 10 80       	push   $0x80108a5f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 5c 45 00 00       	call   80104750 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 0c 45 00 00       	call   80104710 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 d5 10 80 	movl   $0x8010d5e0,(%esp)
8010020b:	e8 d0 46 00 00       	call   801048e0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 30 1d 11 80       	mov    0x80111d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 1c 11 80 	movl   $0x80111cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 1d 11 80       	mov    0x80111d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 1d 11 80    	mov    %ebx,0x80111d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 d5 10 80 	movl   $0x8010d5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 3f 47 00 00       	jmp    801049a0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 8a 10 80       	push   $0x80108a66
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int off, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 bb 17 00 00       	call   80101a40 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 4f 46 00 00       	call   801048e0 <acquire>
  while(n > 0){
80100291:	8b 5d 14             	mov    0x14(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002a7:	39 15 c4 1f 11 80    	cmp    %edx,0x80111fc4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 c0 1f 11 80       	push   $0x80111fc0
801002c5:	e8 b6 3e 00 00       	call   80104180 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 1f 11 80    	mov    0x80111fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 1f 11 80    	cmp    0x80111fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 00 39 00 00       	call   80103be0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 ac 46 00 00       	call   801049a0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 64 16 00 00       	call   80101960 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 c0 1f 11 80       	mov    %eax,0x80111fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 1f 11 80 	movsbl -0x7feee0c0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 14             	mov    0x14(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 4e 46 00 00       	call   801049a0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 06 16 00 00       	call   80101960 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 14             	mov    0x14(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 14             	cmp    0x14(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 c0 1f 11 80    	mov    %edx,0x80111fc0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 14             	mov    0x14(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 27 00 00       	call   80102b30 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 8a 10 80       	push   $0x80108a6d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 ea 95 10 80 	movl   $0x801095ea,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 e3 43 00 00       	call   801047c0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 8a 10 80       	push   $0x80108a81
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 5c 00 00       	call   801060c0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 5b 00 00       	call   801060c0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 5b 00 00       	call   801060c0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 5b 00 00       	call   801060c0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 77 45 00 00       	call   80104aa0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 aa 44 00 00       	call   801049f0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 8a 10 80       	push   $0x80108a85
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 b0 8a 10 80 	movzbl -0x7fef7550(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 2c 14 00 00       	call   80101a40 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 c0 42 00 00       	call   801048e0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 54 43 00 00       	call   801049a0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 0b 13 00 00       	call   80101960 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 7c 42 00 00       	call   801049a0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 98 8a 10 80       	mov    $0x80108a98,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 eb 40 00 00       	call   801048e0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 8a 10 80       	push   $0x80108a9f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 b8 40 00 00       	call   801048e0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100856:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 13 41 00 00       	call   801049a0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 1f 11 80    	sub    0x80111fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 1f 11 80    	mov    %edx,0x80111fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 1f 11 80    	mov    %cl,-0x7feee0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 1f 11 80       	mov    0x80111fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 1f 11 80    	cmp    %eax,0x80111fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 1f 11 80       	mov    %eax,0x80111fc4
          wakeup(&input.r);
80100911:	68 c0 1f 11 80       	push   $0x80111fc0
80100916:	e8 15 3a 00 00       	call   80104330 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
8010093d:	39 05 c4 1f 11 80    	cmp    %eax,0x80111fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 1f 11 80       	mov    %eax,0x80111fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
80100964:	3b 05 c4 1f 11 80    	cmp    0x80111fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 1f 11 80 0a 	cmpb   $0xa,-0x7feee0c0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 74 3a 00 00       	jmp    80104410 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 1f 11 80 0a 	movb   $0xa,-0x7feee0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 1f 11 80       	mov    0x80111fc8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 a8 8a 10 80       	push   $0x80108aa8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 cb 3d 00 00       	call   801047a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 9c 29 11 80 00 	movl   $0x80100600,0x8011299c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 98 29 11 80 70 	movl   $0x80100270,0x80112998
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 1c 00 00       	call   801026d0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 bf 31 00 00       	call   80103be0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 25 00 00       	call   80102fa0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 19 18 00 00       	call   80102250 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 13 0f 00 00       	call   80101960 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 e2 11 00 00       	call   80101c40 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 81 11 00 00       	call   80101bf0 <iunlockput>
    end_op();
80100a6f:	e8 9c 25 00 00       	call   80103010 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 77 67 00 00       	call   80107210 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 35 65 00 00       	call   80107030 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 43 64 00 00       	call   80106f70 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 e3 10 00 00       	call   80101c40 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 19 66 00 00       	call   80107190 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 56 10 00 00       	call   80101bf0 <iunlockput>
  end_op();
80100b9a:	e8 71 24 00 00       	call   80103010 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 81 64 00 00       	call   80107030 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ca 65 00 00       	call   80107190 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 24 00 00       	call   80103010 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 c1 8a 10 80       	push   $0x80108ac1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 a5 66 00 00       	call   801072b0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 d2 3f 00 00       	call   80104c10 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 bf 3f 00 00       	call   80104c10 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ae 67 00 00       	call   80107410 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 44 67 00 00       	call   80107410 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 c1 3e 00 00       	call   80104bd0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 a7 60 00 00       	call   80106de0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 4f 64 00 00       	call   80107190 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <countDistinct>:
  struct spinlock lock;
  struct file file[NFILE];
} ftable;


int countDistinct(int const *arr, int len) {
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	57                   	push   %edi
80100d64:	56                   	push   %esi
80100d65:	53                   	push   %ebx
80100d66:	83 ec 08             	sub    $0x8,%esp
    int output = 0;
    int flag;
    for (int i = 0; i < len; i++) {
80100d69:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6c:	85 c0                	test   %eax,%eax
80100d6e:	7e 6b                	jle    80100ddb <countDistinct+0x7b>
80100d70:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100d73:	31 ff                	xor    %edi,%edi
    int output = 0;
80100d75:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int countDistinct(int const *arr, int len) {
80100d80:	8b 55 08             	mov    0x8(%ebp),%edx
        flag = 1;
        int j = 0;
80100d83:	31 f6                	xor    %esi,%esi
80100d85:	3b 75 0c             	cmp    0xc(%ebp),%esi
80100d88:	b8 01 00 00 00       	mov    $0x1,%eax
80100d8d:	89 75 f0             	mov    %esi,-0x10(%ebp)
80100d90:	0f 9c c1             	setl   %cl
80100d93:	90                   	nop
80100d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        for (; flag && j < len;) {
80100d98:	85 c0                	test   %eax,%eax
80100d9a:	74 1c                	je     80100db8 <countDistinct+0x58>
80100d9c:	84 c9                	test   %cl,%cl
80100d9e:	74 18                	je     80100db8 <countDistinct+0x58>
            if (arr[i] == arr[j])
                flag = 0;
80100da0:	31 c0                	xor    %eax,%eax
            if (arr[i] == arr[j])
80100da2:	8b 32                	mov    (%edx),%esi
80100da4:	39 33                	cmp    %esi,(%ebx)
80100da6:	74 f0                	je     80100d98 <countDistinct+0x38>
80100da8:	8b 75 f0             	mov    -0x10(%ebp),%esi
80100dab:	83 c2 04             	add    $0x4,%edx
            else
                j++;
80100dae:	83 c6 01             	add    $0x1,%esi
80100db1:	eb d2                	jmp    80100d85 <countDistinct+0x25>
80100db3:	90                   	nop
80100db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100db8:	8b 75 f0             	mov    -0x10(%ebp),%esi
        }
        if (i == j)
            output++;
80100dbb:	31 c0                	xor    %eax,%eax
80100dbd:	39 fe                	cmp    %edi,%esi
80100dbf:	0f 94 c0             	sete   %al
    for (int i = 0; i < len; i++) {
80100dc2:	83 c7 01             	add    $0x1,%edi
            output++;
80100dc5:	01 45 ec             	add    %eax,-0x14(%ebp)
80100dc8:	83 c3 04             	add    $0x4,%ebx
    for (int i = 0; i < len; i++) {
80100dcb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80100dce:	75 b0                	jne    80100d80 <countDistinct+0x20>
    }
    return output;
}
80100dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100dd3:	83 c4 08             	add    $0x8,%esp
80100dd6:	5b                   	pop    %ebx
80100dd7:	5e                   	pop    %esi
80100dd8:	5f                   	pop    %edi
80100dd9:	5d                   	pop    %ebp
80100dda:	c3                   	ret    
    int output = 0;
80100ddb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
}
80100de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100de5:	83 c4 08             	add    $0x8,%esp
80100de8:	5b                   	pop    %ebx
80100de9:	5e                   	pop    %esi
80100dea:	5f                   	pop    %edi
80100deb:	5d                   	pop    %ebp
80100dec:	c3                   	ret    
80100ded:	8d 76 00             	lea    0x0(%esi),%esi

80100df0 <fileinit>:


void
fileinit(void)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100df6:	68 cd 8a 10 80       	push   $0x80108acd
80100dfb:	68 e0 1f 11 80       	push   $0x80111fe0
80100e00:	e8 9b 39 00 00       	call   801047a0 <initlock>
}
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	c9                   	leave  
80100e09:	c3                   	ret    
80100e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e10 <getFileStat>:

void getFileStat(int *free, int *total, int *ref, int *read, int *write, int *inode){
80100e10:	55                   	push   %ebp
    struct file *f;
    int freeFD = 0, totalFD = 0, refFD = 0, readFD = 0, writeFD = 0, inodeFD = 0;
    int i = 0;
    int arr[NOFILE] = {0};
80100e11:	31 c0                	xor    %eax,%eax
80100e13:	b9 10 00 00 00       	mov    $0x10,%ecx
void getFileStat(int *free, int *total, int *ref, int *read, int *write, int *inode){
80100e18:	89 e5                	mov    %esp,%ebp
80100e1a:	57                   	push   %edi
80100e1b:	56                   	push   %esi
80100e1c:	53                   	push   %ebx
    int arr[NOFILE] = {0};
80100e1d:	8d 7d a8             	lea    -0x58(%ebp),%edi
    int freeFD = 0, totalFD = 0, refFD = 0, readFD = 0, writeFD = 0, inodeFD = 0;
80100e20:	31 f6                	xor    %esi,%esi
80100e22:	31 db                	xor    %ebx,%ebx
void getFileStat(int *free, int *total, int *ref, int *read, int *write, int *inode){
80100e24:	83 ec 68             	sub    $0x68,%esp
    int arr[NOFILE] = {0};
80100e27:	f3 ab                	rep stos %eax,%es:(%edi)

    acquire(&ftable.lock);
80100e29:	68 e0 1f 11 80       	push   $0x80111fe0
    int freeFD = 0, totalFD = 0, refFD = 0, readFD = 0, writeFD = 0, inodeFD = 0;
80100e2e:	31 ff                	xor    %edi,%edi
    acquire(&ftable.lock);
80100e30:	e8 ab 3a 00 00       	call   801048e0 <acquire>
    int i = 0;
80100e35:	31 c9                	xor    %ecx,%ecx
    int freeFD = 0, totalFD = 0, refFD = 0, readFD = 0, writeFD = 0, inodeFD = 0;
80100e37:	31 d2                	xor    %edx,%edx
    acquire(&ftable.lock);
80100e39:	83 c4 10             	add    $0x10,%esp
    for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e3c:	b8 14 20 11 80       	mov    $0x80112014,%eax
80100e41:	89 55 a4             	mov    %edx,-0x5c(%ebp)
80100e44:	89 4d a0             	mov    %ecx,-0x60(%ebp)
80100e47:	eb 15                	jmp    80100e5e <getFileStat+0x4e>
80100e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if(f->ref == 0) {
            freeFD++;
80100e50:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	83 c0 18             	add    $0x18,%eax
80100e57:	3d 74 29 11 80       	cmp    $0x80112974,%eax
80100e5c:	73 3a                	jae    80100e98 <getFileStat+0x88>
        if(f->ref == 0) {
80100e5e:	8b 50 04             	mov    0x4(%eax),%edx
80100e61:	85 d2                	test   %edx,%edx
80100e63:	74 eb                	je     80100e50 <getFileStat+0x40>
        }
        else{
            totalFD++;
80100e65:	83 c7 01             	add    $0x1,%edi
            refFD += f->ref;

            if(f->readable)
                readFD++;
80100e68:	80 78 08 01          	cmpb   $0x1,0x8(%eax)
80100e6c:	83 db ff             	sbb    $0xffffffff,%ebx
            if(f->writable)
                writeFD++;
80100e6f:	80 78 09 01          	cmpb   $0x1,0x9(%eax)
80100e73:	83 de ff             	sbb    $0xffffffff,%esi
            if(f->type == FD_INODE)
80100e76:	83 38 02             	cmpl   $0x2,(%eax)
80100e79:	75 d9                	jne    80100e54 <getFileStat+0x44>
            {
                arr[i] = f->ip->inum;
80100e7b:	8b 48 10             	mov    0x10(%eax),%ecx
80100e7e:	8b 55 a0             	mov    -0x60(%ebp),%edx
    for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e81:	83 c0 18             	add    $0x18,%eax
                arr[i] = f->ip->inum;
80100e84:	8b 49 04             	mov    0x4(%ecx),%ecx
80100e87:	89 4c 95 a8          	mov    %ecx,-0x58(%ebp,%edx,4)
                i++;
80100e8b:	83 c2 01             	add    $0x1,%edx
    for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e8e:	3d 74 29 11 80       	cmp    $0x80112974,%eax
                i++;
80100e93:	89 55 a0             	mov    %edx,-0x60(%ebp)
    for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e96:	72 c6                	jb     80100e5e <getFileStat+0x4e>
80100e98:	8b 4d a0             	mov    -0x60(%ebp),%ecx
            }
        }
    }
    inodeFD = countDistinct( arr, i-1 );
80100e9b:	83 ec 08             	sub    $0x8,%esp
80100e9e:	8b 55 a4             	mov    -0x5c(%ebp),%edx
80100ea1:	8d 41 ff             	lea    -0x1(%ecx),%eax
80100ea4:	89 55 9c             	mov    %edx,-0x64(%ebp)
80100ea7:	50                   	push   %eax
80100ea8:	8d 45 a8             	lea    -0x58(%ebp),%eax
80100eab:	50                   	push   %eax
80100eac:	e8 af fe ff ff       	call   80100d60 <countDistinct>


    release(&ftable.lock);
80100eb1:	c7 04 24 e0 1f 11 80 	movl   $0x80111fe0,(%esp)
    inodeFD = countDistinct( arr, i-1 );
80100eb8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    release(&ftable.lock);
80100ebb:	e8 e0 3a 00 00       	call   801049a0 <release>


    *free = freeFD;
80100ec0:	8b 55 9c             	mov    -0x64(%ebp),%edx
80100ec3:	8b 4d 08             	mov    0x8(%ebp),%ecx
    *total = totalFD;
    *ref = readFD;
    *read = readFD;
    *write = writeFD;
    *inode = inodeFD;
}
80100ec6:	83 c4 10             	add    $0x10,%esp
    *inode = inodeFD;
80100ec9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
    *free = freeFD;
80100ecc:	89 11                	mov    %edx,(%ecx)
    *total = totalFD;
80100ece:	8b 55 0c             	mov    0xc(%ebp),%edx
80100ed1:	89 3a                	mov    %edi,(%edx)
    *ref = readFD;
80100ed3:	8b 55 10             	mov    0x10(%ebp),%edx
80100ed6:	89 1a                	mov    %ebx,(%edx)
    *read = readFD;
80100ed8:	8b 55 14             	mov    0x14(%ebp),%edx
80100edb:	89 1a                	mov    %ebx,(%edx)
    *write = writeFD;
80100edd:	8b 55 18             	mov    0x18(%ebp),%edx
80100ee0:	89 32                	mov    %esi,(%edx)
    *inode = inodeFD;
80100ee2:	8b 55 1c             	mov    0x1c(%ebp),%edx
80100ee5:	89 02                	mov    %eax,(%edx)
}
80100ee7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eea:	5b                   	pop    %ebx
80100eeb:	5e                   	pop    %esi
80100eec:	5f                   	pop    %edi
80100eed:	5d                   	pop    %ebp
80100eee:	c3                   	ret    
80100eef:	90                   	nop

80100ef0 <filealloc>:


// Allocate a file structure.
struct file*
filealloc(void)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ef4:	bb 14 20 11 80       	mov    $0x80112014,%ebx
{
80100ef9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100efc:	68 e0 1f 11 80       	push   $0x80111fe0
80100f01:	e8 da 39 00 00       	call   801048e0 <acquire>
80100f06:	83 c4 10             	add    $0x10,%esp
80100f09:	eb 10                	jmp    80100f1b <filealloc+0x2b>
80100f0b:	90                   	nop
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f10:	83 c3 18             	add    $0x18,%ebx
80100f13:	81 fb 74 29 11 80    	cmp    $0x80112974,%ebx
80100f19:	73 25                	jae    80100f40 <filealloc+0x50>
    if(f->ref == 0){
80100f1b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f1e:	85 c0                	test   %eax,%eax
80100f20:	75 ee                	jne    80100f10 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f22:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f25:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f2c:	68 e0 1f 11 80       	push   $0x80111fe0
80100f31:	e8 6a 3a 00 00       	call   801049a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f36:	89 d8                	mov    %ebx,%eax
      return f;
80100f38:	83 c4 10             	add    $0x10,%esp
}
80100f3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f3e:	c9                   	leave  
80100f3f:	c3                   	ret    
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f43:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f45:	68 e0 1f 11 80       	push   $0x80111fe0
80100f4a:	e8 51 3a 00 00       	call   801049a0 <release>
}
80100f4f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f51:	83 c4 10             	add    $0x10,%esp
}
80100f54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f57:	c9                   	leave  
80100f58:	c3                   	ret    
80100f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	53                   	push   %ebx
80100f64:	83 ec 10             	sub    $0x10,%esp
80100f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f6a:	68 e0 1f 11 80       	push   $0x80111fe0
80100f6f:	e8 6c 39 00 00       	call   801048e0 <acquire>
  if(f->ref < 1)
80100f74:	8b 43 04             	mov    0x4(%ebx),%eax
80100f77:	83 c4 10             	add    $0x10,%esp
80100f7a:	85 c0                	test   %eax,%eax
80100f7c:	7e 1a                	jle    80100f98 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f7e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f81:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f84:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f87:	68 e0 1f 11 80       	push   $0x80111fe0
80100f8c:	e8 0f 3a 00 00       	call   801049a0 <release>
  return f;
}
80100f91:	89 d8                	mov    %ebx,%eax
80100f93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f96:	c9                   	leave  
80100f97:	c3                   	ret    
    panic("filedup");
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	68 d4 8a 10 80       	push   $0x80108ad4
80100fa0:	e8 eb f3 ff ff       	call   80100390 <panic>
80100fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fb0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	57                   	push   %edi
80100fb4:	56                   	push   %esi
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 28             	sub    $0x28,%esp
80100fb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100fbc:	68 e0 1f 11 80       	push   $0x80111fe0
80100fc1:	e8 1a 39 00 00       	call   801048e0 <acquire>
  if(f->ref < 1)
80100fc6:	8b 43 04             	mov    0x4(%ebx),%eax
80100fc9:	83 c4 10             	add    $0x10,%esp
80100fcc:	85 c0                	test   %eax,%eax
80100fce:	0f 8e 9b 00 00 00    	jle    8010106f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100fd4:	83 e8 01             	sub    $0x1,%eax
80100fd7:	85 c0                	test   %eax,%eax
80100fd9:	89 43 04             	mov    %eax,0x4(%ebx)
80100fdc:	74 1a                	je     80100ff8 <fileclose+0x48>
    release(&ftable.lock);
80100fde:	c7 45 08 e0 1f 11 80 	movl   $0x80111fe0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe8:	5b                   	pop    %ebx
80100fe9:	5e                   	pop    %esi
80100fea:	5f                   	pop    %edi
80100feb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100fec:	e9 af 39 00 00       	jmp    801049a0 <release>
80100ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ff8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ffc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ffe:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101001:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101004:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010100a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010100d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101010:	68 e0 1f 11 80       	push   $0x80111fe0
  ff = *f;
80101015:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101018:	e8 83 39 00 00       	call   801049a0 <release>
  if(ff.type == FD_PIPE)
8010101d:	83 c4 10             	add    $0x10,%esp
80101020:	83 ff 01             	cmp    $0x1,%edi
80101023:	74 13                	je     80101038 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101025:	83 ff 02             	cmp    $0x2,%edi
80101028:	74 26                	je     80101050 <fileclose+0xa0>
}
8010102a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010102d:	5b                   	pop    %ebx
8010102e:	5e                   	pop    %esi
8010102f:	5f                   	pop    %edi
80101030:	5d                   	pop    %ebp
80101031:	c3                   	ret    
80101032:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101038:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010103c:	83 ec 08             	sub    $0x8,%esp
8010103f:	53                   	push   %ebx
80101040:	56                   	push   %esi
80101041:	e8 0a 27 00 00       	call   80103750 <pipeclose>
80101046:	83 c4 10             	add    $0x10,%esp
80101049:	eb df                	jmp    8010102a <fileclose+0x7a>
8010104b:	90                   	nop
8010104c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101050:	e8 4b 1f 00 00       	call   80102fa0 <begin_op>
    iput(ff.ip);
80101055:	83 ec 0c             	sub    $0xc,%esp
80101058:	ff 75 e0             	pushl  -0x20(%ebp)
8010105b:	e8 30 0a 00 00       	call   80101a90 <iput>
    end_op();
80101060:	83 c4 10             	add    $0x10,%esp
}
80101063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101066:	5b                   	pop    %ebx
80101067:	5e                   	pop    %esi
80101068:	5f                   	pop    %edi
80101069:	5d                   	pop    %ebp
    end_op();
8010106a:	e9 a1 1f 00 00       	jmp    80103010 <end_op>
    panic("fileclose");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 dc 8a 10 80       	push   $0x80108adc
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	53                   	push   %ebx
80101084:	83 ec 04             	sub    $0x4,%esp
80101087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010108a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010108d:	75 31                	jne    801010c0 <filestat+0x40>
    ilock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 73 10             	pushl  0x10(%ebx)
80101095:	e8 c6 08 00 00       	call   80101960 <ilock>
    stati(f->ip, st);
8010109a:	58                   	pop    %eax
8010109b:	5a                   	pop    %edx
8010109c:	ff 75 0c             	pushl  0xc(%ebp)
8010109f:	ff 73 10             	pushl  0x10(%ebx)
801010a2:	e8 69 0b 00 00       	call   80101c10 <stati>
    iunlock(f->ip);
801010a7:	59                   	pop    %ecx
801010a8:	ff 73 10             	pushl  0x10(%ebx)
801010ab:	e8 90 09 00 00       	call   80101a40 <iunlock>
    return 0;
801010b0:	83 c4 10             	add    $0x10,%esp
801010b3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801010b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010b8:	c9                   	leave  
801010b9:	c3                   	ret    
801010ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801010c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010c5:	eb ee                	jmp    801010b5 <filestat+0x35>
801010c7:	89 f6                	mov    %esi,%esi
801010c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801010d0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 0c             	sub    $0xc,%esp
801010d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010dc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010df:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010e2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010e6:	74 60                	je     80101148 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010e8:	8b 03                	mov    (%ebx),%eax
801010ea:	83 f8 01             	cmp    $0x1,%eax
801010ed:	74 41                	je     80101130 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ef:	83 f8 02             	cmp    $0x2,%eax
801010f2:	75 5b                	jne    8010114f <fileread+0x7f>
    ilock(f->ip);
801010f4:	83 ec 0c             	sub    $0xc,%esp
801010f7:	ff 73 10             	pushl  0x10(%ebx)
801010fa:	e8 61 08 00 00       	call   80101960 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010ff:	57                   	push   %edi
80101100:	ff 73 14             	pushl  0x14(%ebx)
80101103:	56                   	push   %esi
80101104:	ff 73 10             	pushl  0x10(%ebx)
80101107:	e8 34 0b 00 00       	call   80101c40 <readi>
8010110c:	83 c4 20             	add    $0x20,%esp
8010110f:	85 c0                	test   %eax,%eax
80101111:	89 c6                	mov    %eax,%esi
80101113:	7e 03                	jle    80101118 <fileread+0x48>
      f->off += r;
80101115:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101118:	83 ec 0c             	sub    $0xc,%esp
8010111b:	ff 73 10             	pushl  0x10(%ebx)
8010111e:	e8 1d 09 00 00       	call   80101a40 <iunlock>
    return r;
80101123:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101129:	89 f0                	mov    %esi,%eax
8010112b:	5b                   	pop    %ebx
8010112c:	5e                   	pop    %esi
8010112d:	5f                   	pop    %edi
8010112e:	5d                   	pop    %ebp
8010112f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101130:	8b 43 0c             	mov    0xc(%ebx),%eax
80101133:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101136:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101139:	5b                   	pop    %ebx
8010113a:	5e                   	pop    %esi
8010113b:	5f                   	pop    %edi
8010113c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010113d:	e9 be 27 00 00       	jmp    80103900 <piperead>
80101142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101148:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010114d:	eb d7                	jmp    80101126 <fileread+0x56>
  panic("fileread");
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	68 e6 8a 10 80       	push   $0x80108ae6
80101157:	e8 34 f2 ff ff       	call   80100390 <panic>
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101160 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101160:	55                   	push   %ebp
80101161:	89 e5                	mov    %esp,%ebp
80101163:	57                   	push   %edi
80101164:	56                   	push   %esi
80101165:	53                   	push   %ebx
80101166:	83 ec 1c             	sub    $0x1c,%esp
80101169:	8b 75 08             	mov    0x8(%ebp),%esi
8010116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010116f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101173:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101176:	8b 45 10             	mov    0x10(%ebp),%eax
80101179:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010117c:	0f 84 aa 00 00 00    	je     8010122c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101182:	8b 06                	mov    (%esi),%eax
80101184:	83 f8 01             	cmp    $0x1,%eax
80101187:	0f 84 c3 00 00 00    	je     80101250 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010118d:	83 f8 02             	cmp    $0x2,%eax
80101190:	0f 85 d9 00 00 00    	jne    8010126f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101199:	31 ff                	xor    %edi,%edi
    while(i < n){
8010119b:	85 c0                	test   %eax,%eax
8010119d:	7f 34                	jg     801011d3 <filewrite+0x73>
8010119f:	e9 9c 00 00 00       	jmp    80101240 <filewrite+0xe0>
801011a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801011a8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801011ab:	83 ec 0c             	sub    $0xc,%esp
801011ae:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801011b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011b4:	e8 87 08 00 00       	call   80101a40 <iunlock>
      end_op();
801011b9:	e8 52 1e 00 00       	call   80103010 <end_op>
801011be:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011c1:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
801011c4:	39 c3                	cmp    %eax,%ebx
801011c6:	0f 85 96 00 00 00    	jne    80101262 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801011cc:	01 df                	add    %ebx,%edi
    while(i < n){
801011ce:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801011d1:	7e 6d                	jle    80101240 <filewrite+0xe0>
      int n1 = n - i;
801011d3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011d6:	b8 00 06 00 00       	mov    $0x600,%eax
801011db:	29 fb                	sub    %edi,%ebx
801011dd:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801011e3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801011e6:	e8 b5 1d 00 00       	call   80102fa0 <begin_op>
      ilock(f->ip);
801011eb:	83 ec 0c             	sub    $0xc,%esp
801011ee:	ff 76 10             	pushl  0x10(%esi)
801011f1:	e8 6a 07 00 00       	call   80101960 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011f9:	53                   	push   %ebx
801011fa:	ff 76 14             	pushl  0x14(%esi)
801011fd:	01 f8                	add    %edi,%eax
801011ff:	50                   	push   %eax
80101200:	ff 76 10             	pushl  0x10(%esi)
80101203:	e8 38 0b 00 00       	call   80101d40 <writei>
80101208:	83 c4 20             	add    $0x20,%esp
8010120b:	85 c0                	test   %eax,%eax
8010120d:	7f 99                	jg     801011a8 <filewrite+0x48>
      iunlock(f->ip);
8010120f:	83 ec 0c             	sub    $0xc,%esp
80101212:	ff 76 10             	pushl  0x10(%esi)
80101215:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101218:	e8 23 08 00 00       	call   80101a40 <iunlock>
      end_op();
8010121d:	e8 ee 1d 00 00       	call   80103010 <end_op>
      if(r < 0)
80101222:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101225:	83 c4 10             	add    $0x10,%esp
80101228:	85 c0                	test   %eax,%eax
8010122a:	74 98                	je     801011c4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010122c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010122f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101234:	89 f8                	mov    %edi,%eax
80101236:	5b                   	pop    %ebx
80101237:	5e                   	pop    %esi
80101238:	5f                   	pop    %edi
80101239:	5d                   	pop    %ebp
8010123a:	c3                   	ret    
8010123b:	90                   	nop
8010123c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101240:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101243:	75 e7                	jne    8010122c <filewrite+0xcc>
}
80101245:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101248:	89 f8                	mov    %edi,%eax
8010124a:	5b                   	pop    %ebx
8010124b:	5e                   	pop    %esi
8010124c:	5f                   	pop    %edi
8010124d:	5d                   	pop    %ebp
8010124e:	c3                   	ret    
8010124f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101250:	8b 46 0c             	mov    0xc(%esi),%eax
80101253:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101256:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101259:	5b                   	pop    %ebx
8010125a:	5e                   	pop    %esi
8010125b:	5f                   	pop    %edi
8010125c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010125d:	e9 8e 25 00 00       	jmp    801037f0 <pipewrite>
        panic("short filewrite");
80101262:	83 ec 0c             	sub    $0xc,%esp
80101265:	68 ef 8a 10 80       	push   $0x80108aef
8010126a:	e8 21 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010126f:	83 ec 0c             	sub    $0xc,%esp
80101272:	68 f5 8a 10 80       	push   $0x80108af5
80101277:	e8 14 f1 ff ff       	call   80100390 <panic>
8010127c:	66 90                	xchg   %ax,%ax
8010127e:	66 90                	xchg   %ax,%ax

80101280 <iget>:

// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode *
iget(uint dev, uint inum) {
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	89 c7                	mov    %eax,%edi
    struct inode *ip, *empty;

    acquire(&icache.lock);

    // Is the inode already cached?
    empty = 0;
80101288:	31 f6                	xor    %esi,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
8010128a:	bb 74 2a 11 80       	mov    $0x80112a74,%ebx
iget(uint dev, uint inum) {
8010128f:	83 ec 28             	sub    $0x28,%esp
80101292:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    acquire(&icache.lock);
80101295:	68 40 2a 11 80       	push   $0x80112a40
8010129a:	e8 41 36 00 00       	call   801048e0 <acquire>
8010129f:	83 c4 10             	add    $0x10,%esp
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801012a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012a5:	eb 17                	jmp    801012be <iget+0x3e>
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012b0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012b6:	81 fb 94 46 11 80    	cmp    $0x80114694,%ebx
801012bc:	73 22                	jae    801012e0 <iget+0x60>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
801012be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012c1:	85 c9                	test   %ecx,%ecx
801012c3:	7e 04                	jle    801012c9 <iget+0x49>
801012c5:	39 3b                	cmp    %edi,(%ebx)
801012c7:	74 4f                	je     80101318 <iget+0x98>
            ip->ref++;
            release(&icache.lock);
            return ip;
        }
        if (empty == 0 && ip->ref == 0)    // Remember empty slot.
801012c9:	85 f6                	test   %esi,%esi
801012cb:	75 e3                	jne    801012b0 <iget+0x30>
801012cd:	85 c9                	test   %ecx,%ecx
801012cf:	0f 44 f3             	cmove  %ebx,%esi
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++) {
801012d2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012d8:	81 fb 94 46 11 80    	cmp    $0x80114694,%ebx
801012de:	72 de                	jb     801012be <iget+0x3e>
            empty = ip;
    }

    // Recycle an inode cache entry.
    if (empty == 0)
801012e0:	85 f6                	test   %esi,%esi
801012e2:	74 5b                	je     8010133f <iget+0xbf>
    ip = empty;
    ip->dev = dev;
    ip->inum = inum;
    ip->ref = 1;
    ip->valid = 0;
    release(&icache.lock);
801012e4:	83 ec 0c             	sub    $0xc,%esp
    ip->dev = dev;
801012e7:	89 3e                	mov    %edi,(%esi)
    ip->inum = inum;
801012e9:	89 56 04             	mov    %edx,0x4(%esi)
    ip->ref = 1;
801012ec:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
    ip->valid = 0;
801012f3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
    release(&icache.lock);
801012fa:	68 40 2a 11 80       	push   $0x80112a40
801012ff:	e8 9c 36 00 00       	call   801049a0 <release>

    return ip;
80101304:	83 c4 10             	add    $0x10,%esp
}
80101307:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130a:	89 f0                	mov    %esi,%eax
8010130c:	5b                   	pop    %ebx
8010130d:	5e                   	pop    %esi
8010130e:	5f                   	pop    %edi
8010130f:	5d                   	pop    %ebp
80101310:	c3                   	ret    
80101311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
80101318:	39 53 04             	cmp    %edx,0x4(%ebx)
8010131b:	75 ac                	jne    801012c9 <iget+0x49>
            release(&icache.lock);
8010131d:	83 ec 0c             	sub    $0xc,%esp
            ip->ref++;
80101320:	83 c1 01             	add    $0x1,%ecx
            return ip;
80101323:	89 de                	mov    %ebx,%esi
            release(&icache.lock);
80101325:	68 40 2a 11 80       	push   $0x80112a40
            ip->ref++;
8010132a:	89 4b 08             	mov    %ecx,0x8(%ebx)
            release(&icache.lock);
8010132d:	e8 6e 36 00 00       	call   801049a0 <release>
            return ip;
80101332:	83 c4 10             	add    $0x10,%esp
}
80101335:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101338:	89 f0                	mov    %esi,%eax
8010133a:	5b                   	pop    %ebx
8010133b:	5e                   	pop    %esi
8010133c:	5f                   	pop    %edi
8010133d:	5d                   	pop    %ebp
8010133e:	c3                   	ret    
        panic("iget: no inodes");
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	68 ff 8a 10 80       	push   $0x80108aff
80101347:	e8 44 f0 ff ff       	call   80100390 <panic>
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101350 <balloc>:
balloc(uint dev) {
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	56                   	push   %esi
80101355:	53                   	push   %ebx
80101356:	83 ec 1c             	sub    $0x1c,%esp
    for (b = 0; b < sb.size; b += BPB) {
80101359:	8b 0d 20 2a 11 80    	mov    0x80112a20,%ecx
balloc(uint dev) {
8010135f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    for (b = 0; b < sb.size; b += BPB) {
80101362:	85 c9                	test   %ecx,%ecx
80101364:	0f 84 87 00 00 00    	je     801013f1 <balloc+0xa1>
8010136a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        bp = bread(dev, BBLOCK(b, sb));
80101371:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101374:	83 ec 08             	sub    $0x8,%esp
80101377:	89 f0                	mov    %esi,%eax
80101379:	c1 f8 0c             	sar    $0xc,%eax
8010137c:	03 05 38 2a 11 80    	add    0x80112a38,%eax
80101382:	50                   	push   %eax
80101383:	ff 75 d8             	pushl  -0x28(%ebp)
80101386:	e8 45 ed ff ff       	call   801000d0 <bread>
8010138b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
8010138e:	a1 20 2a 11 80       	mov    0x80112a20,%eax
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101399:	31 c0                	xor    %eax,%eax
8010139b:	eb 2f                	jmp    801013cc <balloc+0x7c>
8010139d:	8d 76 00             	lea    0x0(%esi),%esi
            m = 1 << (bi % 8);
801013a0:	89 c1                	mov    %eax,%ecx
            if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
801013a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            m = 1 << (bi % 8);
801013a5:	bb 01 00 00 00       	mov    $0x1,%ebx
801013aa:	83 e1 07             	and    $0x7,%ecx
801013ad:	d3 e3                	shl    %cl,%ebx
            if ((bp->data[bi / 8] & m) == 0) {  // Is block free?
801013af:	89 c1                	mov    %eax,%ecx
801013b1:	c1 f9 03             	sar    $0x3,%ecx
801013b4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013b9:	85 df                	test   %ebx,%edi
801013bb:	89 fa                	mov    %edi,%edx
801013bd:	74 41                	je     80101400 <balloc+0xb0>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
801013bf:	83 c0 01             	add    $0x1,%eax
801013c2:	83 c6 01             	add    $0x1,%esi
801013c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013ca:	74 05                	je     801013d1 <balloc+0x81>
801013cc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013cf:	77 cf                	ja     801013a0 <balloc+0x50>
        brelse(bp);
801013d1:	83 ec 0c             	sub    $0xc,%esp
801013d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013d7:	e8 04 ee ff ff       	call   801001e0 <brelse>
    for (b = 0; b < sb.size; b += BPB) {
801013dc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013e3:	83 c4 10             	add    $0x10,%esp
801013e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013e9:	39 05 20 2a 11 80    	cmp    %eax,0x80112a20
801013ef:	77 80                	ja     80101371 <balloc+0x21>
    panic("balloc: out of blocks");
801013f1:	83 ec 0c             	sub    $0xc,%esp
801013f4:	68 0f 8b 10 80       	push   $0x80108b0f
801013f9:	e8 92 ef ff ff       	call   80100390 <panic>
801013fe:	66 90                	xchg   %ax,%ax
                bp->data[bi / 8] |= m;  // Mark block in use.
80101400:	8b 7d e4             	mov    -0x1c(%ebp),%edi
                log_write(bp);
80101403:	83 ec 0c             	sub    $0xc,%esp
                bp->data[bi / 8] |= m;  // Mark block in use.
80101406:	09 da                	or     %ebx,%edx
80101408:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
                log_write(bp);
8010140c:	57                   	push   %edi
8010140d:	e8 5e 1d 00 00       	call   80103170 <log_write>
                brelse(bp);
80101412:	89 3c 24             	mov    %edi,(%esp)
80101415:	e8 c6 ed ff ff       	call   801001e0 <brelse>
    bp = bread(dev, bno);
8010141a:	58                   	pop    %eax
8010141b:	5a                   	pop    %edx
8010141c:	56                   	push   %esi
8010141d:	ff 75 d8             	pushl  -0x28(%ebp)
80101420:	e8 ab ec ff ff       	call   801000d0 <bread>
80101425:	89 c3                	mov    %eax,%ebx
    memset(bp->data, 0, BSIZE);
80101427:	8d 40 5c             	lea    0x5c(%eax),%eax
8010142a:	83 c4 0c             	add    $0xc,%esp
8010142d:	68 00 02 00 00       	push   $0x200
80101432:	6a 00                	push   $0x0
80101434:	50                   	push   %eax
80101435:	e8 b6 35 00 00       	call   801049f0 <memset>
    log_write(bp);
8010143a:	89 1c 24             	mov    %ebx,(%esp)
8010143d:	e8 2e 1d 00 00       	call   80103170 <log_write>
    brelse(bp);
80101442:	89 1c 24             	mov    %ebx,(%esp)
80101445:	e8 96 ed ff ff       	call   801001e0 <brelse>
}
8010144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144d:	89 f0                	mov    %esi,%eax
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
80101454:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010145a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101460 <bmap>:
// listed in block ip->addrs[NDIRECT].

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn) {
80101460:	55                   	push   %ebp
80101461:	89 e5                	mov    %esp,%ebp
80101463:	57                   	push   %edi
80101464:	56                   	push   %esi
80101465:	53                   	push   %ebx
80101466:	89 c6                	mov    %eax,%esi
80101468:	83 ec 1c             	sub    $0x1c,%esp
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT) {
8010146b:	83 fa 0b             	cmp    $0xb,%edx
8010146e:	77 18                	ja     80101488 <bmap+0x28>
80101470:	8d 3c 90             	lea    (%eax,%edx,4),%edi
        if ((addr = ip->addrs[bn]) == 0)
80101473:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101476:	85 db                	test   %ebx,%ebx
80101478:	74 76                	je     801014f0 <bmap+0x90>
        brelse(bp);
        return addr;
    }

    panic("bmap: out of range");
}
8010147a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010147d:	89 d8                	mov    %ebx,%eax
8010147f:	5b                   	pop    %ebx
80101480:	5e                   	pop    %esi
80101481:	5f                   	pop    %edi
80101482:	5d                   	pop    %ebp
80101483:	c3                   	ret    
80101484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bn -= NDIRECT;
80101488:	8d 5a f4             	lea    -0xc(%edx),%ebx
    if (bn < NINDIRECT) {
8010148b:	83 fb 7f             	cmp    $0x7f,%ebx
8010148e:	0f 87 90 00 00 00    	ja     80101524 <bmap+0xc4>
        if ((addr = ip->addrs[NDIRECT]) == 0)
80101494:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010149a:	8b 00                	mov    (%eax),%eax
8010149c:	85 d2                	test   %edx,%edx
8010149e:	74 70                	je     80101510 <bmap+0xb0>
        bp = bread(ip->dev, addr);
801014a0:	83 ec 08             	sub    $0x8,%esp
801014a3:	52                   	push   %edx
801014a4:	50                   	push   %eax
801014a5:	e8 26 ec ff ff       	call   801000d0 <bread>
        if ((addr = a[bn]) == 0) {
801014aa:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801014ae:	83 c4 10             	add    $0x10,%esp
        bp = bread(ip->dev, addr);
801014b1:	89 c7                	mov    %eax,%edi
        if ((addr = a[bn]) == 0) {
801014b3:	8b 1a                	mov    (%edx),%ebx
801014b5:	85 db                	test   %ebx,%ebx
801014b7:	75 1d                	jne    801014d6 <bmap+0x76>
            a[bn] = addr = balloc(ip->dev);
801014b9:	8b 06                	mov    (%esi),%eax
801014bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014be:	e8 8d fe ff ff       	call   80101350 <balloc>
801014c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            log_write(bp);
801014c6:	83 ec 0c             	sub    $0xc,%esp
            a[bn] = addr = balloc(ip->dev);
801014c9:	89 c3                	mov    %eax,%ebx
801014cb:	89 02                	mov    %eax,(%edx)
            log_write(bp);
801014cd:	57                   	push   %edi
801014ce:	e8 9d 1c 00 00       	call   80103170 <log_write>
801014d3:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
801014d6:	83 ec 0c             	sub    $0xc,%esp
801014d9:	57                   	push   %edi
801014da:	e8 01 ed ff ff       	call   801001e0 <brelse>
801014df:	83 c4 10             	add    $0x10,%esp
}
801014e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e5:	89 d8                	mov    %ebx,%eax
801014e7:	5b                   	pop    %ebx
801014e8:	5e                   	pop    %esi
801014e9:	5f                   	pop    %edi
801014ea:	5d                   	pop    %ebp
801014eb:	c3                   	ret    
801014ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            ip->addrs[bn] = addr = balloc(ip->dev);
801014f0:	8b 00                	mov    (%eax),%eax
801014f2:	e8 59 fe ff ff       	call   80101350 <balloc>
801014f7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801014fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
            ip->addrs[bn] = addr = balloc(ip->dev);
801014fd:	89 c3                	mov    %eax,%ebx
}
801014ff:	89 d8                	mov    %ebx,%eax
80101501:	5b                   	pop    %ebx
80101502:	5e                   	pop    %esi
80101503:	5f                   	pop    %edi
80101504:	5d                   	pop    %ebp
80101505:	c3                   	ret    
80101506:	8d 76 00             	lea    0x0(%esi),%esi
80101509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101510:	e8 3b fe ff ff       	call   80101350 <balloc>
80101515:	89 c2                	mov    %eax,%edx
80101517:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010151d:	8b 06                	mov    (%esi),%eax
8010151f:	e9 7c ff ff ff       	jmp    801014a0 <bmap+0x40>
    panic("bmap: out of range");
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	68 25 8b 10 80       	push   $0x80108b25
8010152c:	e8 5f ee ff ff       	call   80100390 <panic>
80101531:	eb 0d                	jmp    80101540 <readsb>
80101533:	90                   	nop
80101534:	90                   	nop
80101535:	90                   	nop
80101536:	90                   	nop
80101537:	90                   	nop
80101538:	90                   	nop
80101539:	90                   	nop
8010153a:	90                   	nop
8010153b:	90                   	nop
8010153c:	90                   	nop
8010153d:	90                   	nop
8010153e:	90                   	nop
8010153f:	90                   	nop

80101540 <readsb>:
readsb(int dev, struct superblock *sb) {
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
    bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	pushl  0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
80101555:	89 c3                	mov    %eax,%ebx
    memmove(sb, bp->data, sizeof(*sb));
80101557:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155a:	83 c4 0c             	add    $0xc,%esp
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 3a 35 00 00       	call   80104aa0 <memmove>
    brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
    brelse(bp);
80101572:	e9 69 ec ff ff       	jmp    801001e0 <brelse>
80101577:	89 f6                	mov    %esi,%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101580 <bfree>:
bfree(int dev, uint b) {
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	89 d3                	mov    %edx,%ebx
80101587:	89 c6                	mov    %eax,%esi
    readsb(dev, &sb);
80101589:	83 ec 08             	sub    $0x8,%esp
8010158c:	68 20 2a 11 80       	push   $0x80112a20
80101591:	50                   	push   %eax
80101592:	e8 a9 ff ff ff       	call   80101540 <readsb>
    bp = bread(dev, BBLOCK(b, sb));
80101597:	58                   	pop    %eax
80101598:	5a                   	pop    %edx
80101599:	89 da                	mov    %ebx,%edx
8010159b:	c1 ea 0c             	shr    $0xc,%edx
8010159e:	03 15 38 2a 11 80    	add    0x80112a38,%edx
801015a4:	52                   	push   %edx
801015a5:	56                   	push   %esi
801015a6:	e8 25 eb ff ff       	call   801000d0 <bread>
    m = 1 << (bi % 8);
801015ab:	89 d9                	mov    %ebx,%ecx
    if ((bp->data[bi / 8] & m) == 0)
801015ad:	c1 fb 03             	sar    $0x3,%ebx
    m = 1 << (bi % 8);
801015b0:	ba 01 00 00 00       	mov    $0x1,%edx
801015b5:	83 e1 07             	and    $0x7,%ecx
    if ((bp->data[bi / 8] & m) == 0)
801015b8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801015be:	83 c4 10             	add    $0x10,%esp
    m = 1 << (bi % 8);
801015c1:	d3 e2                	shl    %cl,%edx
    if ((bp->data[bi / 8] & m) == 0)
801015c3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801015c8:	85 d1                	test   %edx,%ecx
801015ca:	74 25                	je     801015f1 <bfree+0x71>
    bp->data[bi / 8] &= ~m;
801015cc:	f7 d2                	not    %edx
801015ce:	89 c6                	mov    %eax,%esi
    log_write(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
    bp->data[bi / 8] &= ~m;
801015d3:	21 ca                	and    %ecx,%edx
801015d5:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
    log_write(bp);
801015d9:	56                   	push   %esi
801015da:	e8 91 1b 00 00       	call   80103170 <log_write>
    brelse(bp);
801015df:	89 34 24             	mov    %esi,(%esp)
801015e2:	e8 f9 eb ff ff       	call   801001e0 <brelse>
}
801015e7:	83 c4 10             	add    $0x10,%esp
801015ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ed:	5b                   	pop    %ebx
801015ee:	5e                   	pop    %esi
801015ef:	5d                   	pop    %ebp
801015f0:	c3                   	ret    
        panic("freeing free block");
801015f1:	83 ec 0c             	sub    $0xc,%esp
801015f4:	68 38 8b 10 80       	push   $0x80108b38
801015f9:	e8 92 ed ff ff       	call   80100390 <panic>
801015fe:	66 90                	xchg   %ax,%ax

80101600 <readIcacheFS>:
int readIcacheFS(int *arr) {
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 75 08             	mov    0x8(%ebp),%esi
    int count = 0, i = 0;
80101608:	31 db                	xor    %ebx,%ebx
    acquire(&icache.lock);
8010160a:	83 ec 0c             	sub    $0xc,%esp
8010160d:	68 40 2a 11 80       	push   $0x80112a40
80101612:	e8 c9 32 00 00       	call   801048e0 <acquire>
80101617:	83 c4 10             	add    $0x10,%esp
    int count = 0, i = 0;
8010161a:	31 c9                	xor    %ecx,%ecx
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++, i++) {
8010161c:	ba 74 2a 11 80       	mov    $0x80112a74,%edx
80101621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (ip->ref > 0)
80101628:	8b 42 08             	mov    0x8(%edx),%eax
8010162b:	85 c0                	test   %eax,%eax
8010162d:	7e 06                	jle    80101635 <readIcacheFS+0x35>
            arr[count++] = i;
8010162f:	89 0c 9e             	mov    %ecx,(%esi,%ebx,4)
80101632:	83 c3 01             	add    $0x1,%ebx
    for (ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++, i++) {
80101635:	81 c2 90 00 00 00    	add    $0x90,%edx
8010163b:	83 c1 01             	add    $0x1,%ecx
8010163e:	81 fa 94 46 11 80    	cmp    $0x80114694,%edx
80101644:	72 e2                	jb     80101628 <readIcacheFS+0x28>
    release(&icache.lock);
80101646:	83 ec 0c             	sub    $0xc,%esp
80101649:	68 40 2a 11 80       	push   $0x80112a40
8010164e:	e8 4d 33 00 00       	call   801049a0 <release>
}
80101653:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101656:	89 d8                	mov    %ebx,%eax
80101658:	5b                   	pop    %ebx
80101659:	5e                   	pop    %esi
8010165a:	5d                   	pop    %ebp
8010165b:	c3                   	ret    
8010165c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101660 <getInodeFromChache>:
struct inode* getInodeFromChache(int index) {
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
8010166a:	68 40 2a 11 80       	push   $0x80112a40
8010166f:	e8 6c 32 00 00       	call   801048e0 <acquire>
    for (int i = 0; i < index; i++, ip++); //MOVE IP TO THE SPECIFIC INUM BY INDEX
80101674:	83 c4 10             	add    $0x10,%esp
80101677:	85 db                	test   %ebx,%ebx
80101679:	7e 25                	jle    801016a0 <getInodeFromChache+0x40>
8010167b:	8d 1c db             	lea    (%ebx,%ebx,8),%ebx
8010167e:	c1 e3 04             	shl    $0x4,%ebx
80101681:	81 c3 74 2a 11 80    	add    $0x80112a74,%ebx
    release(&icache.lock);
80101687:	83 ec 0c             	sub    $0xc,%esp
8010168a:	68 40 2a 11 80       	push   $0x80112a40
8010168f:	e8 0c 33 00 00       	call   801049a0 <release>
}
80101694:	89 d8                	mov    %ebx,%eax
80101696:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101699:	c9                   	leave  
8010169a:	c3                   	ret    
8010169b:	90                   	nop
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = &icache.inode[0];
801016a0:	bb 74 2a 11 80       	mov    $0x80112a74,%ebx
801016a5:	eb e0                	jmp    80101687 <getInodeFromChache+0x27>
801016a7:	89 f6                	mov    %esi,%esi
801016a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801016b0 <lsndFS>:
void lsndFS(){
801016b0:	55                   	push   %ebp
    int validInum[NINODE] = {0};
801016b1:	31 c0                	xor    %eax,%eax
801016b3:	b9 32 00 00 00       	mov    $0x32,%ecx
void lsndFS(){
801016b8:	89 e5                	mov    %esp,%ebp
801016ba:	57                   	push   %edi
801016bb:	56                   	push   %esi
801016bc:	53                   	push   %ebx
    int validInum[NINODE] = {0};
801016bd:	8d bd 20 ff ff ff    	lea    -0xe0(%ebp),%edi
    int count = readIcacheFS(validInum);
801016c3:	8d 9d 20 ff ff ff    	lea    -0xe0(%ebp),%ebx
void lsndFS(){
801016c9:	81 ec e8 00 00 00    	sub    $0xe8,%esp
    int validInum[NINODE] = {0};
801016cf:	f3 ab                	rep stos %eax,%es:(%edi)
    int count = readIcacheFS(validInum);
801016d1:	53                   	push   %ebx
801016d2:	e8 29 ff ff ff       	call   80101600 <readIcacheFS>
801016d7:	89 c6                	mov    %eax,%esi
    cprintf("\n");
801016d9:	c7 04 24 ea 95 10 80 	movl   $0x801095ea,(%esp)
801016e0:	e8 7b ef ff ff       	call   80100660 <cprintf>
    for(int i=0; i<count; i++){
801016e5:	83 c4 10             	add    $0x10,%esp
801016e8:	85 f6                	test   %esi,%esi
801016ea:	7e 65                	jle    80101751 <lsndFS+0xa1>
801016ec:	8d 34 b3             	lea    (%ebx,%esi,4),%esi
801016ef:	90                   	nop
        struct inode *ind = getInodeFromChache(validInum[i]);
801016f0:	83 ec 0c             	sub    $0xc,%esp
801016f3:	ff 33                	pushl  (%ebx)
801016f5:	e8 66 ff ff ff       	call   80101660 <getInodeFromChache>
801016fa:	8d 50 5c             	lea    0x5c(%eax),%edx
801016fd:	8d b8 90 00 00 00    	lea    0x90(%eax),%edi
80101703:	83 c4 10             	add    $0x10,%esp
        int blocks = 0;
80101706:	31 c9                	xor    %ecx,%ecx
80101708:	90                   	nop
80101709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                blocks++;
80101710:	83 3a 01             	cmpl   $0x1,(%edx)
80101713:	83 d9 ff             	sbb    $0xffffffff,%ecx
80101716:	83 c2 04             	add    $0x4,%edx
        for (int j = 0; j < NDIRECT + 1; j++) {
80101719:	39 fa                	cmp    %edi,%edx
8010171b:	75 f3                	jne    80101710 <lsndFS+0x60>
        cprintf(" %d %d %d %d ( %d, %d ) %d %d \n",
8010171d:	83 ec 0c             	sub    $0xc,%esp
80101720:	83 c3 04             	add    $0x4,%ebx
80101723:	51                   	push   %ecx
80101724:	0f bf 50 56          	movswl 0x56(%eax),%edx
80101728:	52                   	push   %edx
80101729:	0f bf 50 54          	movswl 0x54(%eax),%edx
8010172d:	52                   	push   %edx
8010172e:	0f bf 50 52          	movswl 0x52(%eax),%edx
80101732:	52                   	push   %edx
80101733:	0f bf 50 50          	movswl 0x50(%eax),%edx
80101737:	52                   	push   %edx
80101738:	ff 70 4c             	pushl  0x4c(%eax)
8010173b:	ff 70 04             	pushl  0x4(%eax)
8010173e:	ff 30                	pushl  (%eax)
80101740:	68 b8 8b 10 80       	push   $0x80108bb8
80101745:	e8 16 ef ff ff       	call   80100660 <cprintf>
    for(int i=0; i<count; i++){
8010174a:	83 c4 30             	add    $0x30,%esp
8010174d:	39 f3                	cmp    %esi,%ebx
8010174f:	75 9f                	jne    801016f0 <lsndFS+0x40>
}
80101751:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101754:	5b                   	pop    %ebx
80101755:	5e                   	pop    %esi
80101756:	5f                   	pop    %edi
80101757:	5d                   	pop    %ebp
80101758:	c3                   	ret    
80101759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101760 <iinit>:
iinit(int dev) {
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	53                   	push   %ebx
80101764:	bb 80 2a 11 80       	mov    $0x80112a80,%ebx
80101769:	83 ec 0c             	sub    $0xc,%esp
    initlock(&icache.lock, "icache");
8010176c:	68 4b 8b 10 80       	push   $0x80108b4b
80101771:	68 40 2a 11 80       	push   $0x80112a40
80101776:	e8 25 30 00 00       	call   801047a0 <initlock>
8010177b:	83 c4 10             	add    $0x10,%esp
8010177e:	66 90                	xchg   %ax,%ax
        initsleeplock(&icache.inode[i].lock, "inode");
80101780:	83 ec 08             	sub    $0x8,%esp
80101783:	68 52 8b 10 80       	push   $0x80108b52
80101788:	53                   	push   %ebx
80101789:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010178f:	e8 dc 2e 00 00       	call   80104670 <initsleeplock>
    for (i = 0; i < NINODE; i++) {
80101794:	83 c4 10             	add    $0x10,%esp
80101797:	81 fb a0 46 11 80    	cmp    $0x801146a0,%ebx
8010179d:	75 e1                	jne    80101780 <iinit+0x20>
    readsb(dev, &sb);
8010179f:	83 ec 08             	sub    $0x8,%esp
801017a2:	68 20 2a 11 80       	push   $0x80112a20
801017a7:	ff 75 08             	pushl  0x8(%ebp)
801017aa:	e8 91 fd ff ff       	call   80101540 <readsb>
    cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801017af:	ff 35 38 2a 11 80    	pushl  0x80112a38
801017b5:	ff 35 34 2a 11 80    	pushl  0x80112a34
801017bb:	ff 35 30 2a 11 80    	pushl  0x80112a30
801017c1:	ff 35 2c 2a 11 80    	pushl  0x80112a2c
801017c7:	ff 35 28 2a 11 80    	pushl  0x80112a28
801017cd:	ff 35 24 2a 11 80    	pushl  0x80112a24
801017d3:	ff 35 20 2a 11 80    	pushl  0x80112a20
801017d9:	68 d8 8b 10 80       	push   $0x80108bd8
801017de:	e8 7d ee ff ff       	call   80100660 <cprintf>
}
801017e3:	83 c4 30             	add    $0x30,%esp
801017e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017e9:	c9                   	leave  
801017ea:	c3                   	ret    
801017eb:	90                   	nop
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017f0 <ialloc>:
ialloc(uint dev, short type) {
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 1c             	sub    $0x1c,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
801017f9:	83 3d 28 2a 11 80 01 	cmpl   $0x1,0x80112a28
ialloc(uint dev, short type) {
80101800:	8b 45 0c             	mov    0xc(%ebp),%eax
80101803:	8b 75 08             	mov    0x8(%ebp),%esi
80101806:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for (inum = 1; inum < sb.ninodes; inum++) {
80101809:	0f 86 91 00 00 00    	jbe    801018a0 <ialloc+0xb0>
8010180f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101814:	eb 21                	jmp    80101837 <ialloc+0x47>
80101816:	8d 76 00             	lea    0x0(%esi),%esi
80101819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        brelse(bp);
80101820:	83 ec 0c             	sub    $0xc,%esp
    for (inum = 1; inum < sb.ninodes; inum++) {
80101823:	83 c3 01             	add    $0x1,%ebx
        brelse(bp);
80101826:	57                   	push   %edi
80101827:	e8 b4 e9 ff ff       	call   801001e0 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++) {
8010182c:	83 c4 10             	add    $0x10,%esp
8010182f:	39 1d 28 2a 11 80    	cmp    %ebx,0x80112a28
80101835:	76 69                	jbe    801018a0 <ialloc+0xb0>
        bp = bread(dev, IBLOCK(inum, sb));
80101837:	89 d8                	mov    %ebx,%eax
80101839:	83 ec 08             	sub    $0x8,%esp
8010183c:	c1 e8 03             	shr    $0x3,%eax
8010183f:	03 05 34 2a 11 80    	add    0x80112a34,%eax
80101845:	50                   	push   %eax
80101846:	56                   	push   %esi
80101847:	e8 84 e8 ff ff       	call   801000d0 <bread>
8010184c:	89 c7                	mov    %eax,%edi
        dip = (struct dinode *) bp->data + inum % IPB;
8010184e:	89 d8                	mov    %ebx,%eax
        if (dip->type == 0) {  // a free inode
80101850:	83 c4 10             	add    $0x10,%esp
        dip = (struct dinode *) bp->data + inum % IPB;
80101853:	83 e0 07             	and    $0x7,%eax
80101856:	c1 e0 06             	shl    $0x6,%eax
80101859:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
        if (dip->type == 0) {  // a free inode
8010185d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101861:	75 bd                	jne    80101820 <ialloc+0x30>
            memset(dip, 0, sizeof(*dip));
80101863:	83 ec 04             	sub    $0x4,%esp
80101866:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101869:	6a 40                	push   $0x40
8010186b:	6a 00                	push   $0x0
8010186d:	51                   	push   %ecx
8010186e:	e8 7d 31 00 00       	call   801049f0 <memset>
            dip->type = type;
80101873:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101877:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010187a:	66 89 01             	mov    %ax,(%ecx)
            log_write(bp);   // mark it allocated on the disk
8010187d:	89 3c 24             	mov    %edi,(%esp)
80101880:	e8 eb 18 00 00       	call   80103170 <log_write>
            brelse(bp);
80101885:	89 3c 24             	mov    %edi,(%esp)
80101888:	e8 53 e9 ff ff       	call   801001e0 <brelse>
            return iget(dev, inum);
8010188d:	83 c4 10             	add    $0x10,%esp
}
80101890:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return iget(dev, inum);
80101893:	89 da                	mov    %ebx,%edx
80101895:	89 f0                	mov    %esi,%eax
}
80101897:	5b                   	pop    %ebx
80101898:	5e                   	pop    %esi
80101899:	5f                   	pop    %edi
8010189a:	5d                   	pop    %ebp
            return iget(dev, inum);
8010189b:	e9 e0 f9 ff ff       	jmp    80101280 <iget>
    panic("ialloc: no inodes");
801018a0:	83 ec 0c             	sub    $0xc,%esp
801018a3:	68 58 8b 10 80       	push   $0x80108b58
801018a8:	e8 e3 ea ff ff       	call   80100390 <panic>
801018ad:	8d 76 00             	lea    0x0(%esi),%esi

801018b0 <iupdate>:
iupdate(struct inode *ip) {
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018b8:	83 ec 08             	sub    $0x8,%esp
801018bb:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018be:	83 c3 5c             	add    $0x5c,%ebx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018c1:	c1 e8 03             	shr    $0x3,%eax
801018c4:	03 05 34 2a 11 80    	add    0x80112a34,%eax
801018ca:	50                   	push   %eax
801018cb:	ff 73 a4             	pushl  -0x5c(%ebx)
801018ce:	e8 fd e7 ff ff       	call   801000d0 <bread>
801018d3:	89 c6                	mov    %eax,%esi
    dip = (struct dinode *) bp->data + ip->inum % IPB;
801018d5:	8b 43 a8             	mov    -0x58(%ebx),%eax
    dip->type = ip->type;
801018d8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode *) bp->data + ip->inum % IPB;
801018df:	83 e0 07             	and    $0x7,%eax
801018e2:	c1 e0 06             	shl    $0x6,%eax
801018e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    dip->type = ip->type;
801018e9:	66 89 10             	mov    %dx,(%eax)
    dip->major = ip->major;
801018ec:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018f0:	83 c0 0c             	add    $0xc,%eax
    dip->major = ip->major;
801018f3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
    dip->minor = ip->minor;
801018f7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018fb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
    dip->nlink = ip->nlink;
801018ff:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101903:	66 89 50 fa          	mov    %dx,-0x6(%eax)
    dip->size = ip->size;
80101907:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010190a:	89 50 fc             	mov    %edx,-0x4(%eax)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010190d:	6a 34                	push   $0x34
8010190f:	53                   	push   %ebx
80101910:	50                   	push   %eax
80101911:	e8 8a 31 00 00       	call   80104aa0 <memmove>
    log_write(bp);
80101916:	89 34 24             	mov    %esi,(%esp)
80101919:	e8 52 18 00 00       	call   80103170 <log_write>
    brelse(bp);
8010191e:	89 75 08             	mov    %esi,0x8(%ebp)
80101921:	83 c4 10             	add    $0x10,%esp
}
80101924:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101927:	5b                   	pop    %ebx
80101928:	5e                   	pop    %esi
80101929:	5d                   	pop    %ebp
    brelse(bp);
8010192a:	e9 b1 e8 ff ff       	jmp    801001e0 <brelse>
8010192f:	90                   	nop

80101930 <idup>:
idup(struct inode *ip) {
80101930:	55                   	push   %ebp
80101931:	89 e5                	mov    %esp,%ebp
80101933:	53                   	push   %ebx
80101934:	83 ec 10             	sub    $0x10,%esp
80101937:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquire(&icache.lock);
8010193a:	68 40 2a 11 80       	push   $0x80112a40
8010193f:	e8 9c 2f 00 00       	call   801048e0 <acquire>
    ip->ref++;
80101944:	83 43 08 01          	addl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101948:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
8010194f:	e8 4c 30 00 00       	call   801049a0 <release>
}
80101954:	89 d8                	mov    %ebx,%eax
80101956:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101959:	c9                   	leave  
8010195a:	c3                   	ret    
8010195b:	90                   	nop
8010195c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101960 <ilock>:
ilock(struct inode *ip) {
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	56                   	push   %esi
80101964:	53                   	push   %ebx
80101965:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || ip->ref < 1)
80101968:	85 db                	test   %ebx,%ebx
8010196a:	0f 84 b7 00 00 00    	je     80101a27 <ilock+0xc7>
80101970:	8b 53 08             	mov    0x8(%ebx),%edx
80101973:	85 d2                	test   %edx,%edx
80101975:	0f 8e ac 00 00 00    	jle    80101a27 <ilock+0xc7>
    acquiresleep(&ip->lock);
8010197b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010197e:	83 ec 0c             	sub    $0xc,%esp
80101981:	50                   	push   %eax
80101982:	e8 29 2d 00 00       	call   801046b0 <acquiresleep>
    if (ip->valid == 0) {
80101987:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	85 c0                	test   %eax,%eax
8010198f:	74 0f                	je     801019a0 <ilock+0x40>
}
80101991:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101994:	5b                   	pop    %ebx
80101995:	5e                   	pop    %esi
80101996:	5d                   	pop    %ebp
80101997:	c3                   	ret    
80101998:	90                   	nop
80101999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019a0:	8b 43 04             	mov    0x4(%ebx),%eax
801019a3:	83 ec 08             	sub    $0x8,%esp
801019a6:	c1 e8 03             	shr    $0x3,%eax
801019a9:	03 05 34 2a 11 80    	add    0x80112a34,%eax
801019af:	50                   	push   %eax
801019b0:	ff 33                	pushl  (%ebx)
801019b2:	e8 19 e7 ff ff       	call   801000d0 <bread>
801019b7:	89 c6                	mov    %eax,%esi
        dip = (struct dinode *) bp->data + ip->inum % IPB;
801019b9:	8b 43 04             	mov    0x4(%ebx),%eax
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019bc:	83 c4 0c             	add    $0xc,%esp
        dip = (struct dinode *) bp->data + ip->inum % IPB;
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
        ip->type = dip->type;
801019c9:	0f b7 10             	movzwl (%eax),%edx
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019cc:	83 c0 0c             	add    $0xc,%eax
        ip->type = dip->type;
801019cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
        ip->major = dip->major;
801019d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801019d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
        ip->minor = dip->minor;
801019db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801019df:	66 89 53 54          	mov    %dx,0x54(%ebx)
        ip->nlink = dip->nlink;
801019e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
        ip->size = dip->size;
801019eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ee:	89 53 58             	mov    %edx,0x58(%ebx)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019f1:	6a 34                	push   $0x34
801019f3:	50                   	push   %eax
801019f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019f7:	50                   	push   %eax
801019f8:	e8 a3 30 00 00       	call   80104aa0 <memmove>
        brelse(bp);
801019fd:	89 34 24             	mov    %esi,(%esp)
80101a00:	e8 db e7 ff ff       	call   801001e0 <brelse>
        if (ip->type == 0)
80101a05:	83 c4 10             	add    $0x10,%esp
80101a08:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
        ip->valid = 1;
80101a0d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
        if (ip->type == 0)
80101a14:	0f 85 77 ff ff ff    	jne    80101991 <ilock+0x31>
            panic("ilock: no type");
80101a1a:	83 ec 0c             	sub    $0xc,%esp
80101a1d:	68 70 8b 10 80       	push   $0x80108b70
80101a22:	e8 69 e9 ff ff       	call   80100390 <panic>
        panic("ilock");
80101a27:	83 ec 0c             	sub    $0xc,%esp
80101a2a:	68 6a 8b 10 80       	push   $0x80108b6a
80101a2f:	e8 5c e9 ff ff       	call   80100390 <panic>
80101a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a40 <iunlock>:
iunlock(struct inode *ip) {
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	56                   	push   %esi
80101a44:	53                   	push   %ebx
80101a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a48:	85 db                	test   %ebx,%ebx
80101a4a:	74 28                	je     80101a74 <iunlock+0x34>
80101a4c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a4f:	83 ec 0c             	sub    $0xc,%esp
80101a52:	56                   	push   %esi
80101a53:	e8 f8 2c 00 00       	call   80104750 <holdingsleep>
80101a58:	83 c4 10             	add    $0x10,%esp
80101a5b:	85 c0                	test   %eax,%eax
80101a5d:	74 15                	je     80101a74 <iunlock+0x34>
80101a5f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a62:	85 c0                	test   %eax,%eax
80101a64:	7e 0e                	jle    80101a74 <iunlock+0x34>
    releasesleep(&ip->lock);
80101a66:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a69:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a6c:	5b                   	pop    %ebx
80101a6d:	5e                   	pop    %esi
80101a6e:	5d                   	pop    %ebp
    releasesleep(&ip->lock);
80101a6f:	e9 9c 2c 00 00       	jmp    80104710 <releasesleep>
        panic("iunlock");
80101a74:	83 ec 0c             	sub    $0xc,%esp
80101a77:	68 7f 8b 10 80       	push   $0x80108b7f
80101a7c:	e8 0f e9 ff ff       	call   80100390 <panic>
80101a81:	eb 0d                	jmp    80101a90 <iput>
80101a83:	90                   	nop
80101a84:	90                   	nop
80101a85:	90                   	nop
80101a86:	90                   	nop
80101a87:	90                   	nop
80101a88:	90                   	nop
80101a89:	90                   	nop
80101a8a:	90                   	nop
80101a8b:	90                   	nop
80101a8c:	90                   	nop
80101a8d:	90                   	nop
80101a8e:	90                   	nop
80101a8f:	90                   	nop

80101a90 <iput>:
iput(struct inode *ip) {
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 28             	sub    $0x28,%esp
80101a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
    acquiresleep(&ip->lock);
80101a9c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a9f:	57                   	push   %edi
80101aa0:	e8 0b 2c 00 00       	call   801046b0 <acquiresleep>
    if (ip->valid && ip->nlink == 0) {
80101aa5:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101aa8:	83 c4 10             	add    $0x10,%esp
80101aab:	85 d2                	test   %edx,%edx
80101aad:	74 07                	je     80101ab6 <iput+0x26>
80101aaf:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101ab4:	74 32                	je     80101ae8 <iput+0x58>
    releasesleep(&ip->lock);
80101ab6:	83 ec 0c             	sub    $0xc,%esp
80101ab9:	57                   	push   %edi
80101aba:	e8 51 2c 00 00       	call   80104710 <releasesleep>
    acquire(&icache.lock);
80101abf:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
80101ac6:	e8 15 2e 00 00       	call   801048e0 <acquire>
    ip->ref--;
80101acb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
    release(&icache.lock);
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	c7 45 08 40 2a 11 80 	movl   $0x80112a40,0x8(%ebp)
}
80101ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adc:	5b                   	pop    %ebx
80101add:	5e                   	pop    %esi
80101ade:	5f                   	pop    %edi
80101adf:	5d                   	pop    %ebp
    release(&icache.lock);
80101ae0:	e9 bb 2e 00 00       	jmp    801049a0 <release>
80101ae5:	8d 76 00             	lea    0x0(%esi),%esi
        acquire(&icache.lock);
80101ae8:	83 ec 0c             	sub    $0xc,%esp
80101aeb:	68 40 2a 11 80       	push   $0x80112a40
80101af0:	e8 eb 2d 00 00       	call   801048e0 <acquire>
        int r = ip->ref;
80101af5:	8b 73 08             	mov    0x8(%ebx),%esi
        release(&icache.lock);
80101af8:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
80101aff:	e8 9c 2e 00 00       	call   801049a0 <release>
        if (r == 1) {
80101b04:	83 c4 10             	add    $0x10,%esp
80101b07:	83 fe 01             	cmp    $0x1,%esi
80101b0a:	75 aa                	jne    80101ab6 <iput+0x26>
80101b0c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101b12:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101b15:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101b18:	89 cf                	mov    %ecx,%edi
80101b1a:	eb 0b                	jmp    80101b27 <iput+0x97>
80101b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b20:	83 c6 04             	add    $0x4,%esi
itrunc(struct inode *ip) {
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++) {
80101b23:	39 fe                	cmp    %edi,%esi
80101b25:	74 19                	je     80101b40 <iput+0xb0>
        if (ip->addrs[i]) {
80101b27:	8b 16                	mov    (%esi),%edx
80101b29:	85 d2                	test   %edx,%edx
80101b2b:	74 f3                	je     80101b20 <iput+0x90>
            bfree(ip->dev, ip->addrs[i]);
80101b2d:	8b 03                	mov    (%ebx),%eax
80101b2f:	e8 4c fa ff ff       	call   80101580 <bfree>
            ip->addrs[i] = 0;
80101b34:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101b3a:	eb e4                	jmp    80101b20 <iput+0x90>
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        }
    }

    if (ip->addrs[NDIRECT]) {
80101b40:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b46:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b49:	85 c0                	test   %eax,%eax
80101b4b:	75 33                	jne    80101b80 <iput+0xf0>
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    iupdate(ip);
80101b4d:	83 ec 0c             	sub    $0xc,%esp
    ip->size = 0;
80101b50:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
    iupdate(ip);
80101b57:	53                   	push   %ebx
80101b58:	e8 53 fd ff ff       	call   801018b0 <iupdate>
            ip->type = 0;
80101b5d:	31 c0                	xor    %eax,%eax
80101b5f:	66 89 43 50          	mov    %ax,0x50(%ebx)
            iupdate(ip);
80101b63:	89 1c 24             	mov    %ebx,(%esp)
80101b66:	e8 45 fd ff ff       	call   801018b0 <iupdate>
            ip->valid = 0;
80101b6b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b72:	83 c4 10             	add    $0x10,%esp
80101b75:	e9 3c ff ff ff       	jmp    80101ab6 <iput+0x26>
80101b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b80:	83 ec 08             	sub    $0x8,%esp
80101b83:	50                   	push   %eax
80101b84:	ff 33                	pushl  (%ebx)
80101b86:	e8 45 e5 ff ff       	call   801000d0 <bread>
80101b8b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b91:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        a = (uint *) bp->data;
80101b97:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	89 cf                	mov    %ecx,%edi
80101b9f:	eb 0e                	jmp    80101baf <iput+0x11f>
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ba8:	83 c6 04             	add    $0x4,%esi
        for (j = 0; j < NINDIRECT; j++) {
80101bab:	39 fe                	cmp    %edi,%esi
80101bad:	74 0f                	je     80101bbe <iput+0x12e>
            if (a[j])
80101baf:	8b 16                	mov    (%esi),%edx
80101bb1:	85 d2                	test   %edx,%edx
80101bb3:	74 f3                	je     80101ba8 <iput+0x118>
                bfree(ip->dev, a[j]);
80101bb5:	8b 03                	mov    (%ebx),%eax
80101bb7:	e8 c4 f9 ff ff       	call   80101580 <bfree>
80101bbc:	eb ea                	jmp    80101ba8 <iput+0x118>
        brelse(bp);
80101bbe:	83 ec 0c             	sub    $0xc,%esp
80101bc1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bc4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bc7:	e8 14 e6 ff ff       	call   801001e0 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
80101bcc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101bd2:	8b 03                	mov    (%ebx),%eax
80101bd4:	e8 a7 f9 ff ff       	call   80101580 <bfree>
        ip->addrs[NDIRECT] = 0;
80101bd9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101be0:	00 00 00 
80101be3:	83 c4 10             	add    $0x10,%esp
80101be6:	e9 62 ff ff ff       	jmp    80101b4d <iput+0xbd>
80101beb:	90                   	nop
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bf0 <iunlockput>:
iunlockput(struct inode *ip) {
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	53                   	push   %ebx
80101bf4:	83 ec 10             	sub    $0x10,%esp
80101bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    iunlock(ip);
80101bfa:	53                   	push   %ebx
80101bfb:	e8 40 fe ff ff       	call   80101a40 <iunlock>
    iput(ip);
80101c00:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c03:	83 c4 10             	add    $0x10,%esp
}
80101c06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c09:	c9                   	leave  
    iput(ip);
80101c0a:	e9 81 fe ff ff       	jmp    80101a90 <iput>
80101c0f:	90                   	nop

80101c10 <stati>:
}

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st) {
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	8b 55 08             	mov    0x8(%ebp),%edx
80101c16:	8b 45 0c             	mov    0xc(%ebp),%eax
    st->dev = ip->dev;
80101c19:	8b 0a                	mov    (%edx),%ecx
80101c1b:	89 48 04             	mov    %ecx,0x4(%eax)
    st->ino = ip->inum;
80101c1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c21:	89 48 08             	mov    %ecx,0x8(%eax)
    st->type = ip->type;
80101c24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c28:	66 89 08             	mov    %cx,(%eax)
    st->nlink = ip->nlink;
80101c2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
    st->size = ip->size;
80101c33:	8b 52 58             	mov    0x58(%edx),%edx
80101c36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c39:	5d                   	pop    %ebp
80101c3a:	c3                   	ret    
80101c3b:	90                   	nop
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <readi>:

//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n) {
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c4f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80101c52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
readi(struct inode *ip, char *dst, uint off, uint n) {
80101c57:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    if (ip->type == T_DEV) {
80101c63:	0f 84 a7 00 00 00    	je     80101d10 <readi+0xd0>
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
            return -1;
        return devsw[ip->major].read(ip, dst, off, n);
    }

    if (off > ip->size || off + n < off)
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	8b 40 58             	mov    0x58(%eax),%eax
80101c6f:	39 c6                	cmp    %eax,%esi
80101c71:	0f 87 b9 00 00 00    	ja     80101d30 <readi+0xf0>
80101c77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c7a:	89 f9                	mov    %edi,%ecx
80101c7c:	01 f1                	add    %esi,%ecx
80101c7e:	0f 82 ac 00 00 00    	jb     80101d30 <readi+0xf0>
        return -1;
    if (off + n > ip->size)
        n = ip->size - off;
80101c84:	89 c2                	mov    %eax,%edx
80101c86:	29 f2                	sub    %esi,%edx
80101c88:	39 c8                	cmp    %ecx,%eax
80101c8a:	0f 43 d7             	cmovae %edi,%edx

    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101c8d:	31 ff                	xor    %edi,%edi
80101c8f:	85 d2                	test   %edx,%edx
        n = ip->size - off;
80101c91:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101c94:	74 6c                	je     80101d02 <readi+0xc2>
80101c96:	8d 76 00             	lea    0x0(%esi),%esi
80101c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101ca0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ca3:	89 f2                	mov    %esi,%edx
80101ca5:	c1 ea 09             	shr    $0x9,%edx
80101ca8:	89 d8                	mov    %ebx,%eax
80101caa:	e8 b1 f7 ff ff       	call   80101460 <bmap>
80101caf:	83 ec 08             	sub    $0x8,%esp
80101cb2:	50                   	push   %eax
80101cb3:	ff 33                	pushl  (%ebx)
80101cb5:	e8 16 e4 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
80101cba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101cbd:	89 c2                	mov    %eax,%edx
        m = min(n - tot, BSIZE - off % BSIZE);
80101cbf:	89 f0                	mov    %esi,%eax
80101cc1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cc6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ccb:	83 c4 0c             	add    $0xc,%esp
80101cce:	29 c1                	sub    %eax,%ecx
        memmove(dst, bp->data + off % BSIZE, m);
80101cd0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101cd4:	89 55 dc             	mov    %edx,-0x24(%ebp)
        m = min(n - tot, BSIZE - off % BSIZE);
80101cd7:	29 fb                	sub    %edi,%ebx
80101cd9:	39 d9                	cmp    %ebx,%ecx
80101cdb:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(dst, bp->data + off % BSIZE, m);
80101cde:	53                   	push   %ebx
80101cdf:	50                   	push   %eax
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101ce0:	01 df                	add    %ebx,%edi
        memmove(dst, bp->data + off % BSIZE, m);
80101ce2:	ff 75 e0             	pushl  -0x20(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101ce5:	01 de                	add    %ebx,%esi
        memmove(dst, bp->data + off % BSIZE, m);
80101ce7:	e8 b4 2d 00 00       	call   80104aa0 <memmove>
        brelse(bp);
80101cec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101cef:	89 14 24             	mov    %edx,(%esp)
80101cf2:	e8 e9 e4 ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m) {
80101cf7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d00:	77 9e                	ja     80101ca0 <readi+0x60>
    }
    return n;
80101d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d08:	5b                   	pop    %ebx
80101d09:	5e                   	pop    %esi
80101d0a:	5f                   	pop    %edi
80101d0b:	5d                   	pop    %ebp
80101d0c:	c3                   	ret    
80101d0d:	8d 76 00             	lea    0x0(%esi),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d14:	66 83 f8 09          	cmp    $0x9,%ax
80101d18:	77 16                	ja     80101d30 <readi+0xf0>
80101d1a:	c1 e0 04             	shl    $0x4,%eax
80101d1d:	8b 80 88 29 11 80    	mov    -0x7feed678(%eax),%eax
80101d23:	85 c0                	test   %eax,%eax
80101d25:	74 09                	je     80101d30 <readi+0xf0>
}
80101d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d2a:	5b                   	pop    %ebx
80101d2b:	5e                   	pop    %esi
80101d2c:	5f                   	pop    %edi
80101d2d:	5d                   	pop    %ebp
        return devsw[ip->major].read(ip, dst, off, n);
80101d2e:	ff e0                	jmp    *%eax
            return -1;
80101d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d35:	eb ce                	jmp    80101d05 <readi+0xc5>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d40 <writei>:

// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n) {
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	57                   	push   %edi
80101d44:	56                   	push   %esi
80101d45:	53                   	push   %ebx
80101d46:	83 ec 1c             	sub    $0x1c,%esp
80101d49:	8b 45 08             	mov    0x8(%ebp),%eax
80101d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d4f:	8b 7d 14             	mov    0x14(%ebp),%edi
    uint tot, m;
    struct buf *bp;

    if (ip->type == T_DEV) {
80101d52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
writei(struct inode *ip, char *src, uint off, uint n) {
80101d57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d60:	89 7d e0             	mov    %edi,-0x20(%ebp)
    if (ip->type == T_DEV) {
80101d63:	0f 84 b7 00 00 00    	je     80101e20 <writei+0xe0>
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
            return -1;
        return devsw[ip->major].write(ip, src, n);
    }

    if (off > ip->size || off + n < off)
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d6f:	0f 82 eb 00 00 00    	jb     80101e60 <writei+0x120>
80101d75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d78:	31 d2                	xor    %edx,%edx
80101d7a:	89 f8                	mov    %edi,%eax
80101d7c:	01 f0                	add    %esi,%eax
80101d7e:	0f 92 c2             	setb   %dl
        return -1;
    if (off + n > MAXFILE * BSIZE)
80101d81:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d86:	0f 87 d4 00 00 00    	ja     80101e60 <writei+0x120>
80101d8c:	85 d2                	test   %edx,%edx
80101d8e:	0f 85 cc 00 00 00    	jne    80101e60 <writei+0x120>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101d94:	85 ff                	test   %edi,%edi
80101d96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d9d:	74 72                	je     80101e11 <writei+0xd1>
80101d9f:	90                   	nop
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101da0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101da3:	89 f2                	mov    %esi,%edx
80101da5:	c1 ea 09             	shr    $0x9,%edx
80101da8:	89 f8                	mov    %edi,%eax
80101daa:	e8 b1 f6 ff ff       	call   80101460 <bmap>
80101daf:	83 ec 08             	sub    $0x8,%esp
80101db2:	50                   	push   %eax
80101db3:	ff 37                	pushl  (%edi)
80101db5:	e8 16 e3 ff ff       	call   801000d0 <bread>
        m = min(n - tot, BSIZE - off % BSIZE);
80101dba:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101dbd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
        bp = bread(ip->dev, bmap(ip, off / BSIZE));
80101dc0:	89 c7                	mov    %eax,%edi
        m = min(n - tot, BSIZE - off % BSIZE);
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101dc9:	83 c4 0c             	add    $0xc,%esp
80101dcc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101dd1:	29 c1                	sub    %eax,%ecx
        memmove(bp->data + off % BSIZE, src, m);
80101dd3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
        m = min(n - tot, BSIZE - off % BSIZE);
80101dd7:	39 d9                	cmp    %ebx,%ecx
80101dd9:	0f 46 d9             	cmovbe %ecx,%ebx
        memmove(bp->data + off % BSIZE, src, m);
80101ddc:	53                   	push   %ebx
80101ddd:	ff 75 dc             	pushl  -0x24(%ebp)
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101de0:	01 de                	add    %ebx,%esi
        memmove(bp->data + off % BSIZE, src, m);
80101de2:	50                   	push   %eax
80101de3:	e8 b8 2c 00 00       	call   80104aa0 <memmove>
        log_write(bp);
80101de8:	89 3c 24             	mov    %edi,(%esp)
80101deb:	e8 80 13 00 00       	call   80103170 <log_write>
        brelse(bp);
80101df0:	89 3c 24             	mov    %edi,(%esp)
80101df3:	e8 e8 e3 ff ff       	call   801001e0 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m) {
80101df8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101dfb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dfe:	83 c4 10             	add    $0x10,%esp
80101e01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e04:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e07:	77 97                	ja     80101da0 <writei+0x60>
    }

    if (n > 0 && off > ip->size) {
80101e09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e0f:	77 37                	ja     80101e48 <writei+0x108>
        ip->size = off;
        iupdate(ip);
    }
    return n;
80101e11:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        if (ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101e20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e24:	66 83 f8 09          	cmp    $0x9,%ax
80101e28:	77 36                	ja     80101e60 <writei+0x120>
80101e2a:	c1 e0 04             	shl    $0x4,%eax
80101e2d:	8b 80 8c 29 11 80    	mov    -0x7feed674(%eax),%eax
80101e33:	85 c0                	test   %eax,%eax
80101e35:	74 29                	je     80101e60 <writei+0x120>
        return devsw[ip->major].write(ip, src, n);
80101e37:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e3d:	5b                   	pop    %ebx
80101e3e:	5e                   	pop    %esi
80101e3f:	5f                   	pop    %edi
80101e40:	5d                   	pop    %ebp
        return devsw[ip->major].write(ip, src, n);
80101e41:	ff e0                	jmp    *%eax
80101e43:	90                   	nop
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ip->size = off;
80101e48:	8b 45 d8             	mov    -0x28(%ebp),%eax
        iupdate(ip);
80101e4b:	83 ec 0c             	sub    $0xc,%esp
        ip->size = off;
80101e4e:	89 70 58             	mov    %esi,0x58(%eax)
        iupdate(ip);
80101e51:	50                   	push   %eax
80101e52:	e8 59 fa ff ff       	call   801018b0 <iupdate>
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb b5                	jmp    80101e11 <writei+0xd1>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            return -1;
80101e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e65:	eb ad                	jmp    80101e14 <writei+0xd4>
80101e67:	89 f6                	mov    %esi,%esi
80101e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e70 <namecmp>:

//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t) {
80101e70:	55                   	push   %ebp
80101e71:	89 e5                	mov    %esp,%ebp
80101e73:	83 ec 0c             	sub    $0xc,%esp
    return strncmp(s, t, DIRSIZ);
80101e76:	6a 0e                	push   $0xe
80101e78:	ff 75 0c             	pushl  0xc(%ebp)
80101e7b:	ff 75 08             	pushl  0x8(%ebp)
80101e7e:	e8 8d 2c 00 00       	call   80104b10 <strncmp>
}
80101e83:	c9                   	leave  
80101e84:	c3                   	ret    
80101e85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff) {
80101e90:	55                   	push   %ebp
80101e91:	89 e5                	mov    %esp,%ebp
80101e93:	57                   	push   %edi
80101e94:	56                   	push   %esi
80101e95:	53                   	push   %ebx
80101e96:	83 ec 2c             	sub    $0x2c,%esp
80101e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
    uint off, inum;
    struct dirent de;
    struct inode *ip;

    if (dp->type != T_DIR && !IS_DEV_DIR(dp))
80101e9c:	0f b7 43 50          	movzwl 0x50(%ebx),%eax
80101ea0:	66 83 f8 01          	cmp    $0x1,%ax
80101ea4:	74 30                	je     80101ed6 <dirlookup+0x46>
80101ea6:	66 83 f8 03          	cmp    $0x3,%ax
80101eaa:	0f 85 d0 00 00 00    	jne    80101f80 <dirlookup+0xf0>
80101eb0:	0f bf 43 52          	movswl 0x52(%ebx),%eax
80101eb4:	c1 e0 04             	shl    $0x4,%eax
80101eb7:	8b 80 80 29 11 80    	mov    -0x7feed680(%eax),%eax
80101ebd:	85 c0                	test   %eax,%eax
80101ebf:	0f 84 bb 00 00 00    	je     80101f80 <dirlookup+0xf0>
80101ec5:	83 ec 0c             	sub    $0xc,%esp
80101ec8:	53                   	push   %ebx
80101ec9:	ff d0                	call   *%eax
80101ecb:	83 c4 10             	add    $0x10,%esp
80101ece:	85 c0                	test   %eax,%eax
80101ed0:	0f 84 aa 00 00 00    	je     80101f80 <dirlookup+0xf0>
dirlookup(struct inode *dp, char *name, uint *poff) {
80101ed6:	31 ff                	xor    %edi,%edi
//    cprintf("\nLOOKING FOR name: %s\t and INODE-DP->INUM: %d\nDIRENTS:\n",name,dp->inum);
//    for(off=0; off<dp->size; off+= sizeof((de)))


    for (off = 0; off < dp->size || dp->type == T_DEV; off += sizeof(de)) {
        if (readi(dp, (char *) &de, off, sizeof(de)) != sizeof(de)) {
80101ed8:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101edb:	eb 25                	jmp    80101f02 <dirlookup+0x72>
80101edd:	8d 76 00             	lea    0x0(%esi),%esi
            panic("dirlookup read");
        }

//        cprintf("%d\t",de.inum);

        if (de.inum == 0)
80101ee0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ee5:	74 18                	je     80101eff <dirlookup+0x6f>
    return strncmp(s, t, DIRSIZ);
80101ee7:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eea:	83 ec 04             	sub    $0x4,%esp
80101eed:	6a 0e                	push   $0xe
80101eef:	50                   	push   %eax
80101ef0:	ff 75 0c             	pushl  0xc(%ebp)
80101ef3:	e8 18 2c 00 00       	call   80104b10 <strncmp>
            continue;
        if (namecmp(name, de.name) == 0) {
80101ef8:	83 c4 10             	add    $0x10,%esp
80101efb:	85 c0                	test   %eax,%eax
80101efd:	74 39                	je     80101f38 <dirlookup+0xa8>
    for (off = 0; off < dp->size || dp->type == T_DEV; off += sizeof(de)) {
80101eff:	83 c7 10             	add    $0x10,%edi
80101f02:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101f05:	77 07                	ja     80101f0e <dirlookup+0x7e>
80101f07:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101f0c:	75 19                	jne    80101f27 <dirlookup+0x97>
        if (readi(dp, (char *) &de, off, sizeof(de)) != sizeof(de)) {
80101f0e:	6a 10                	push   $0x10
80101f10:	57                   	push   %edi
80101f11:	56                   	push   %esi
80101f12:	53                   	push   %ebx
80101f13:	e8 28 fd ff ff       	call   80101c40 <readi>
80101f18:	83 c4 10             	add    $0x10,%esp
80101f1b:	83 f8 10             	cmp    $0x10,%eax
80101f1e:	74 c0                	je     80101ee0 <dirlookup+0x50>
            if (dp->type == T_DEV)
80101f20:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101f25:	75 66                	jne    80101f8d <dirlookup+0xfd>
                return 0;
80101f27:	31 c0                	xor    %eax,%eax
        }
    }
//    cprintf("\n");

    return 0;
}
80101f29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2c:	5b                   	pop    %ebx
80101f2d:	5e                   	pop    %esi
80101f2e:	5f                   	pop    %edi
80101f2f:	5d                   	pop    %ebp
80101f30:	c3                   	ret    
80101f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            if (poff)
80101f38:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101f3b:	85 c9                	test   %ecx,%ecx
80101f3d:	74 05                	je     80101f44 <dirlookup+0xb4>
                *poff = off;
80101f3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101f42:	89 38                	mov    %edi,(%eax)
            inum = de.inum;
80101f44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
            ip = iget(dp->dev, inum);
80101f48:	8b 03                	mov    (%ebx),%eax
80101f4a:	e8 31 f3 ff ff       	call   80101280 <iget>
            if (ip->valid == 0 && dp->type == T_DEV && devsw[dp->major].iread) {
80101f4f:	8b 50 4c             	mov    0x4c(%eax),%edx
80101f52:	85 d2                	test   %edx,%edx
80101f54:	75 d3                	jne    80101f29 <dirlookup+0x99>
80101f56:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
80101f5b:	75 cc                	jne    80101f29 <dirlookup+0x99>
80101f5d:	0f bf 53 52          	movswl 0x52(%ebx),%edx
80101f61:	c1 e2 04             	shl    $0x4,%edx
80101f64:	8b 92 84 29 11 80    	mov    -0x7feed67c(%edx),%edx
80101f6a:	85 d2                	test   %edx,%edx
80101f6c:	74 bb                	je     80101f29 <dirlookup+0x99>
                devsw[dp->major].iread(dp, ip);
80101f6e:	83 ec 08             	sub    $0x8,%esp
80101f71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101f74:	50                   	push   %eax
80101f75:	53                   	push   %ebx
80101f76:	ff d2                	call   *%edx
80101f78:	83 c4 10             	add    $0x10,%esp
80101f7b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80101f7e:	eb a9                	jmp    80101f29 <dirlookup+0x99>
        panic("dirlookup not DIR");
80101f80:	83 ec 0c             	sub    $0xc,%esp
80101f83:	68 87 8b 10 80       	push   $0x80108b87
80101f88:	e8 03 e4 ff ff       	call   80100390 <panic>
            panic("dirlookup read");
80101f8d:	83 ec 0c             	sub    $0xc,%esp
80101f90:	68 99 8b 10 80       	push   $0x80108b99
80101f95:	e8 f6 e3 ff ff       	call   80100390 <panic>
80101f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fa0 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name) {
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	57                   	push   %edi
80101fa4:	56                   	push   %esi
80101fa5:	53                   	push   %ebx
80101fa6:	89 cf                	mov    %ecx,%edi
80101fa8:	89 c3                	mov    %eax,%ebx
80101faa:	83 ec 1c             	sub    $0x1c,%esp
    struct inode *ip, *next;

    if (*path == '/')
80101fad:	80 38 2f             	cmpb   $0x2f,(%eax)
namex(char *path, int nameiparent, char *name) {
80101fb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if (*path == '/')
80101fb3:	0f 84 97 01 00 00    	je     80102150 <namex+0x1b0>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
80101fb9:	e8 22 1c 00 00       	call   80103be0 <myproc>
    acquire(&icache.lock);
80101fbe:	83 ec 0c             	sub    $0xc,%esp
        ip = idup(myproc()->cwd);
80101fc1:	8b 70 68             	mov    0x68(%eax),%esi
    acquire(&icache.lock);
80101fc4:	68 40 2a 11 80       	push   $0x80112a40
80101fc9:	e8 12 29 00 00       	call   801048e0 <acquire>
    ip->ref++;
80101fce:	83 46 08 01          	addl   $0x1,0x8(%esi)
    release(&icache.lock);
80101fd2:	c7 04 24 40 2a 11 80 	movl   $0x80112a40,(%esp)
80101fd9:	e8 c2 29 00 00       	call   801049a0 <release>
80101fde:	83 c4 10             	add    $0x10,%esp
80101fe1:	eb 08                	jmp    80101feb <namex+0x4b>
80101fe3:	90                   	nop
80101fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        path++;
80101fe8:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/')
80101feb:	0f b6 03             	movzbl (%ebx),%eax
80101fee:	3c 2f                	cmp    $0x2f,%al
80101ff0:	74 f6                	je     80101fe8 <namex+0x48>
    if (*path == 0)
80101ff2:	84 c0                	test   %al,%al
80101ff4:	0f 84 1e 01 00 00    	je     80102118 <namex+0x178>
    while (*path != '/' && *path != 0)
80101ffa:	0f b6 03             	movzbl (%ebx),%eax
80101ffd:	3c 2f                	cmp    $0x2f,%al
80101fff:	0f 84 e3 00 00 00    	je     801020e8 <namex+0x148>
80102005:	84 c0                	test   %al,%al
80102007:	89 da                	mov    %ebx,%edx
80102009:	75 09                	jne    80102014 <namex+0x74>
8010200b:	e9 d8 00 00 00       	jmp    801020e8 <namex+0x148>
80102010:	84 c0                	test   %al,%al
80102012:	74 0a                	je     8010201e <namex+0x7e>
        path++;
80102014:	83 c2 01             	add    $0x1,%edx
    while (*path != '/' && *path != 0)
80102017:	0f b6 02             	movzbl (%edx),%eax
8010201a:	3c 2f                	cmp    $0x2f,%al
8010201c:	75 f2                	jne    80102010 <namex+0x70>
8010201e:	89 d1                	mov    %edx,%ecx
80102020:	29 d9                	sub    %ebx,%ecx
    if (len >= DIRSIZ)
80102022:	83 f9 0d             	cmp    $0xd,%ecx
80102025:	0f 8e c1 00 00 00    	jle    801020ec <namex+0x14c>
        memmove(name, s, DIRSIZ);
8010202b:	83 ec 04             	sub    $0x4,%esp
8010202e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102031:	6a 0e                	push   $0xe
80102033:	53                   	push   %ebx
80102034:	57                   	push   %edi
80102035:	e8 66 2a 00 00       	call   80104aa0 <memmove>
        path++;
8010203a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        memmove(name, s, DIRSIZ);
8010203d:	83 c4 10             	add    $0x10,%esp
        path++;
80102040:	89 d3                	mov    %edx,%ebx
    while (*path == '/')
80102042:	80 3a 2f             	cmpb   $0x2f,(%edx)
80102045:	75 11                	jne    80102058 <namex+0xb8>
80102047:	89 f6                	mov    %esi,%esi
80102049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        path++;
80102050:	83 c3 01             	add    $0x1,%ebx
    while (*path == '/')
80102053:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102056:	74 f8                	je     80102050 <namex+0xb0>

    while ((path = skipelem(path, name)) != 0) {
        ilock(ip);
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	56                   	push   %esi
8010205c:	e8 ff f8 ff ff       	call   80101960 <ilock>
        if (ip->type != T_DIR && !IS_DEV_DIR(ip)) {
80102061:	0f b7 46 50          	movzwl 0x50(%esi),%eax
80102065:	83 c4 10             	add    $0x10,%esp
80102068:	66 83 f8 01          	cmp    $0x1,%ax
8010206c:	74 30                	je     8010209e <namex+0xfe>
8010206e:	66 83 f8 03          	cmp    $0x3,%ax
80102072:	0f 85 b8 00 00 00    	jne    80102130 <namex+0x190>
80102078:	0f bf 46 52          	movswl 0x52(%esi),%eax
8010207c:	c1 e0 04             	shl    $0x4,%eax
8010207f:	8b 80 80 29 11 80    	mov    -0x7feed680(%eax),%eax
80102085:	85 c0                	test   %eax,%eax
80102087:	0f 84 a3 00 00 00    	je     80102130 <namex+0x190>
8010208d:	83 ec 0c             	sub    $0xc,%esp
80102090:	56                   	push   %esi
80102091:	ff d0                	call   *%eax
80102093:	83 c4 10             	add    $0x10,%esp
80102096:	85 c0                	test   %eax,%eax
80102098:	0f 84 92 00 00 00    	je     80102130 <namex+0x190>
            iunlockput(ip);
            return 0;
        }
        if (nameiparent && *path == '\0') {
8010209e:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020a1:	85 d2                	test   %edx,%edx
801020a3:	74 09                	je     801020ae <namex+0x10e>
801020a5:	80 3b 00             	cmpb   $0x0,(%ebx)
801020a8:	0f 84 b8 00 00 00    	je     80102166 <namex+0x1c6>
            // Stop one level early.
            iunlock(ip);
            return ip;
        }
        if ((next = dirlookup(ip, name, 0)) == 0) {
801020ae:	83 ec 04             	sub    $0x4,%esp
801020b1:	6a 00                	push   $0x0
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	e8 d6 fd ff ff       	call   80101e90 <dirlookup>
801020ba:	83 c4 10             	add    $0x10,%esp
801020bd:	85 c0                	test   %eax,%eax
801020bf:	74 6f                	je     80102130 <namex+0x190>
    iunlock(ip);
801020c1:	83 ec 0c             	sub    $0xc,%esp
801020c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020c7:	56                   	push   %esi
801020c8:	e8 73 f9 ff ff       	call   80101a40 <iunlock>
    iput(ip);
801020cd:	89 34 24             	mov    %esi,(%esp)
801020d0:	e8 bb f9 ff ff       	call   80101a90 <iput>
801020d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801020d8:	83 c4 10             	add    $0x10,%esp
801020db:	89 c6                	mov    %eax,%esi
801020dd:	e9 09 ff ff ff       	jmp    80101feb <namex+0x4b>
801020e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while (*path != '/' && *path != 0)
801020e8:	89 da                	mov    %ebx,%edx
801020ea:	31 c9                	xor    %ecx,%ecx
        memmove(name, s, len);
801020ec:	83 ec 04             	sub    $0x4,%esp
801020ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
801020f2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801020f5:	51                   	push   %ecx
801020f6:	53                   	push   %ebx
801020f7:	57                   	push   %edi
801020f8:	e8 a3 29 00 00       	call   80104aa0 <memmove>
        name[len] = 0;
801020fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102100:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010210a:	89 d3                	mov    %edx,%ebx
8010210c:	e9 31 ff ff ff       	jmp    80102042 <namex+0xa2>
80102111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            return 0;
        }
        iunlockput(ip);
        ip = next;
    }
    if (nameiparent) {
80102118:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010211b:	85 c0                	test   %eax,%eax
8010211d:	75 5d                	jne    8010217c <namex+0x1dc>
        iput(ip);
        return 0;
    }
    return ip;
}
8010211f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102122:	89 f0                	mov    %esi,%eax
80102124:	5b                   	pop    %ebx
80102125:	5e                   	pop    %esi
80102126:	5f                   	pop    %edi
80102127:	5d                   	pop    %ebp
80102128:	c3                   	ret    
80102129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iunlock(ip);
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	56                   	push   %esi
80102134:	e8 07 f9 ff ff       	call   80101a40 <iunlock>
    iput(ip);
80102139:	89 34 24             	mov    %esi,(%esp)
            return 0;
8010213c:	31 f6                	xor    %esi,%esi
    iput(ip);
8010213e:	e8 4d f9 ff ff       	call   80101a90 <iput>
            return 0;
80102143:	83 c4 10             	add    $0x10,%esp
}
80102146:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102149:	89 f0                	mov    %esi,%eax
8010214b:	5b                   	pop    %ebx
8010214c:	5e                   	pop    %esi
8010214d:	5f                   	pop    %edi
8010214e:	5d                   	pop    %ebp
8010214f:	c3                   	ret    
        ip = iget(ROOTDEV, ROOTINO);
80102150:	ba 01 00 00 00       	mov    $0x1,%edx
80102155:	b8 01 00 00 00       	mov    $0x1,%eax
8010215a:	e8 21 f1 ff ff       	call   80101280 <iget>
8010215f:	89 c6                	mov    %eax,%esi
80102161:	e9 85 fe ff ff       	jmp    80101feb <namex+0x4b>
            iunlock(ip);
80102166:	83 ec 0c             	sub    $0xc,%esp
80102169:	56                   	push   %esi
8010216a:	e8 d1 f8 ff ff       	call   80101a40 <iunlock>
            return ip;
8010216f:	83 c4 10             	add    $0x10,%esp
}
80102172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102175:	89 f0                	mov    %esi,%eax
80102177:	5b                   	pop    %ebx
80102178:	5e                   	pop    %esi
80102179:	5f                   	pop    %edi
8010217a:	5d                   	pop    %ebp
8010217b:	c3                   	ret    
        iput(ip);
8010217c:	83 ec 0c             	sub    $0xc,%esp
8010217f:	56                   	push   %esi
        return 0;
80102180:	31 f6                	xor    %esi,%esi
        iput(ip);
80102182:	e8 09 f9 ff ff       	call   80101a90 <iput>
        return 0;
80102187:	83 c4 10             	add    $0x10,%esp
8010218a:	eb 93                	jmp    8010211f <namex+0x17f>
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <dirlink>:
dirlink(struct inode *dp, char *name, uint inum) {
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 20             	sub    $0x20,%esp
80102199:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if ((ip = dirlookup(dp, name, 0)) != 0) {
8010219c:	6a 00                	push   $0x0
8010219e:	ff 75 0c             	pushl  0xc(%ebp)
801021a1:	53                   	push   %ebx
801021a2:	e8 e9 fc ff ff       	call   80101e90 <dirlookup>
801021a7:	83 c4 10             	add    $0x10,%esp
801021aa:	85 c0                	test   %eax,%eax
801021ac:	75 67                	jne    80102215 <dirlink+0x85>
    for (off = 0; off < dp->size; off += sizeof(de)) {
801021ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801021b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021b4:	85 ff                	test   %edi,%edi
801021b6:	74 29                	je     801021e1 <dirlink+0x51>
801021b8:	31 ff                	xor    %edi,%edi
801021ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021bd:	eb 09                	jmp    801021c8 <dirlink+0x38>
801021bf:	90                   	nop
801021c0:	83 c7 10             	add    $0x10,%edi
801021c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021c6:	73 19                	jae    801021e1 <dirlink+0x51>
        if (readi(dp, (char *) &de, off, sizeof(de)) != sizeof(de))
801021c8:	6a 10                	push   $0x10
801021ca:	57                   	push   %edi
801021cb:	56                   	push   %esi
801021cc:	53                   	push   %ebx
801021cd:	e8 6e fa ff ff       	call   80101c40 <readi>
801021d2:	83 c4 10             	add    $0x10,%esp
801021d5:	83 f8 10             	cmp    $0x10,%eax
801021d8:	75 4e                	jne    80102228 <dirlink+0x98>
        if (de.inum == 0)
801021da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801021df:	75 df                	jne    801021c0 <dirlink+0x30>
    strncpy(de.name, name, DIRSIZ);
801021e1:	8d 45 da             	lea    -0x26(%ebp),%eax
801021e4:	83 ec 04             	sub    $0x4,%esp
801021e7:	6a 0e                	push   $0xe
801021e9:	ff 75 0c             	pushl  0xc(%ebp)
801021ec:	50                   	push   %eax
801021ed:	e8 7e 29 00 00       	call   80104b70 <strncpy>
    de.inum = inum;
801021f2:	8b 45 10             	mov    0x10(%ebp),%eax
    if (writei(dp, (char *) &de, off, sizeof(de)) != sizeof(de))
801021f5:	6a 10                	push   $0x10
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
    de.inum = inum;
801021fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    if (writei(dp, (char *) &de, off, sizeof(de)) != sizeof(de))
801021fe:	e8 3d fb ff ff       	call   80101d40 <writei>
80102203:	83 c4 20             	add    $0x20,%esp
80102206:	83 f8 10             	cmp    $0x10,%eax
80102209:	75 2a                	jne    80102235 <dirlink+0xa5>
    return 0;
8010220b:	31 c0                	xor    %eax,%eax
}
8010220d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102210:	5b                   	pop    %ebx
80102211:	5e                   	pop    %esi
80102212:	5f                   	pop    %edi
80102213:	5d                   	pop    %ebp
80102214:	c3                   	ret    
        iput(ip);
80102215:	83 ec 0c             	sub    $0xc,%esp
80102218:	50                   	push   %eax
80102219:	e8 72 f8 ff ff       	call   80101a90 <iput>
        return -1;
8010221e:	83 c4 10             	add    $0x10,%esp
80102221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102226:	eb e5                	jmp    8010220d <dirlink+0x7d>
            panic("dirlink read");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 a8 8b 10 80       	push   $0x80108ba8
80102230:	e8 5b e1 ff ff       	call   80100390 <panic>
        panic("dirlink");
80102235:	83 ec 0c             	sub    $0xc,%esp
80102238:	68 c6 91 10 80       	push   $0x801091c6
8010223d:	e8 4e e1 ff ff       	call   80100390 <panic>
80102242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102250 <namei>:

struct inode *
namei(char *path) {
80102250:	55                   	push   %ebp
    //cprintf(" \n namiPath is %s \n" , path );
    char name[DIRSIZ];
    return namex(path, 0, name);
80102251:	31 d2                	xor    %edx,%edx
namei(char *path) {
80102253:	89 e5                	mov    %esp,%ebp
80102255:	83 ec 18             	sub    $0x18,%esp
    return namex(path, 0, name);
80102258:	8b 45 08             	mov    0x8(%ebp),%eax
8010225b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010225e:	e8 3d fd ff ff       	call   80101fa0 <namex>
}
80102263:	c9                   	leave  
80102264:	c3                   	ret    
80102265:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <nameiparent>:

struct inode *
nameiparent(char *path, char *name) {
80102270:	55                   	push   %ebp
    return namex(path, 1, name);
80102271:	ba 01 00 00 00       	mov    $0x1,%edx
nameiparent(char *path, char *name) {
80102276:	89 e5                	mov    %esp,%ebp
    return namex(path, 1, name);
80102278:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010227b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010227e:	5d                   	pop    %ebp
    return namex(path, 1, name);
8010227f:	e9 1c fd ff ff       	jmp    80101fa0 <namex>
80102284:	66 90                	xchg   %ax,%ax
80102286:	66 90                	xchg   %ax,%ax
80102288:	66 90                	xchg   %ax,%ax
8010228a:	66 90                	xchg   %ax,%ax
8010228c:	66 90                	xchg   %ax,%ax
8010228e:	66 90                	xchg   %ax,%ax

80102290 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102299:	85 c0                	test   %eax,%eax
8010229b:	0f 84 b4 00 00 00    	je     80102355 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022a1:	8b 58 08             	mov    0x8(%eax),%ebx
801022a4:	89 c6                	mov    %eax,%esi
801022a6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022ac:	0f 87 96 00 00 00    	ja     80102348 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022b7:	89 f6                	mov    %esi,%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022c0:	89 ca                	mov    %ecx,%edx
801022c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022c3:	83 e0 c0             	and    $0xffffffc0,%eax
801022c6:	3c 40                	cmp    $0x40,%al
801022c8:	75 f6                	jne    801022c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ca:	31 ff                	xor    %edi,%edi
801022cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801022d1:	89 f8                	mov    %edi,%eax
801022d3:	ee                   	out    %al,(%dx)
801022d4:	b8 01 00 00 00       	mov    $0x1,%eax
801022d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801022de:	ee                   	out    %al,(%dx)
801022df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801022e4:	89 d8                	mov    %ebx,%eax
801022e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801022e7:	89 d8                	mov    %ebx,%eax
801022e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801022ee:	c1 f8 08             	sar    $0x8,%eax
801022f1:	ee                   	out    %al,(%dx)
801022f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801022f7:	89 f8                	mov    %edi,%eax
801022f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801022fa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801022fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102303:	c1 e0 04             	shl    $0x4,%eax
80102306:	83 e0 10             	and    $0x10,%eax
80102309:	83 c8 e0             	or     $0xffffffe0,%eax
8010230c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010230d:	f6 06 04             	testb  $0x4,(%esi)
80102310:	75 16                	jne    80102328 <idestart+0x98>
80102312:	b8 20 00 00 00       	mov    $0x20,%eax
80102317:	89 ca                	mov    %ecx,%edx
80102319:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010231a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010231d:	5b                   	pop    %ebx
8010231e:	5e                   	pop    %esi
8010231f:	5f                   	pop    %edi
80102320:	5d                   	pop    %ebp
80102321:	c3                   	ret    
80102322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102328:	b8 30 00 00 00       	mov    $0x30,%eax
8010232d:	89 ca                	mov    %ecx,%edx
8010232f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102330:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102335:	83 c6 5c             	add    $0x5c,%esi
80102338:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010233d:	fc                   	cld    
8010233e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret    
    panic("incorrect blockno");
80102348:	83 ec 0c             	sub    $0xc,%esp
8010234b:	68 34 8c 10 80       	push   $0x80108c34
80102350:	e8 3b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102355:	83 ec 0c             	sub    $0xc,%esp
80102358:	68 2b 8c 10 80       	push   $0x80108c2b
8010235d:	e8 2e e0 ff ff       	call   80100390 <panic>
80102362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <ideinit>:
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102376:	68 46 8c 10 80       	push   $0x80108c46
8010237b:	68 80 c5 10 80       	push   $0x8010c580
80102380:	e8 1b 24 00 00       	call   801047a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102385:	58                   	pop    %eax
80102386:	a1 60 4d 11 80       	mov    0x80114d60,%eax
8010238b:	5a                   	pop    %edx
8010238c:	83 e8 01             	sub    $0x1,%eax
8010238f:	50                   	push   %eax
80102390:	6a 0e                	push   $0xe
80102392:	e8 39 03 00 00       	call   801026d0 <ioapicenable>
80102397:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010239a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010239f:	90                   	nop
801023a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023a1:	83 e0 c0             	and    $0xffffffc0,%eax
801023a4:	3c 40                	cmp    $0x40,%al
801023a6:	75 f8                	jne    801023a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023b2:	ee                   	out    %al,(%dx)
801023b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023bd:	eb 06                	jmp    801023c5 <ideinit+0x55>
801023bf:	90                   	nop
  for(i=0; i<1000; i++){
801023c0:	83 e9 01             	sub    $0x1,%ecx
801023c3:	74 0f                	je     801023d4 <ideinit+0x64>
801023c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023c6:	84 c0                	test   %al,%al
801023c8:	74 f6                	je     801023c0 <ideinit+0x50>
      havedisk1 = 1;
801023ca:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
801023d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801023d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023de:	ee                   	out    %al,(%dx)
}
801023df:	c9                   	leave  
801023e0:	c3                   	ret    
801023e1:	eb 0d                	jmp    801023f0 <ideintr>
801023e3:	90                   	nop
801023e4:	90                   	nop
801023e5:	90                   	nop
801023e6:	90                   	nop
801023e7:	90                   	nop
801023e8:	90                   	nop
801023e9:	90                   	nop
801023ea:	90                   	nop
801023eb:	90                   	nop
801023ec:	90                   	nop
801023ed:	90                   	nop
801023ee:	90                   	nop
801023ef:	90                   	nop

801023f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	57                   	push   %edi
801023f4:	56                   	push   %esi
801023f5:	53                   	push   %ebx
801023f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801023f9:	68 80 c5 10 80       	push   $0x8010c580
801023fe:	e8 dd 24 00 00       	call   801048e0 <acquire>

  if((b = idequeue) == 0){
80102403:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
80102409:	83 c4 10             	add    $0x10,%esp
8010240c:	85 db                	test   %ebx,%ebx
8010240e:	74 67                	je     80102477 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102410:	8b 43 58             	mov    0x58(%ebx),%eax
80102413:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102418:	8b 3b                	mov    (%ebx),%edi
8010241a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102420:	75 31                	jne    80102453 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102422:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102427:	89 f6                	mov    %esi,%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102430:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102431:	89 c6                	mov    %eax,%esi
80102433:	83 e6 c0             	and    $0xffffffc0,%esi
80102436:	89 f1                	mov    %esi,%ecx
80102438:	80 f9 40             	cmp    $0x40,%cl
8010243b:	75 f3                	jne    80102430 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010243d:	a8 21                	test   $0x21,%al
8010243f:	75 12                	jne    80102453 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102441:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102444:	b9 80 00 00 00       	mov    $0x80,%ecx
80102449:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010244e:	fc                   	cld    
8010244f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102451:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102453:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102456:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102459:	89 f9                	mov    %edi,%ecx
8010245b:	83 c9 02             	or     $0x2,%ecx
8010245e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102460:	53                   	push   %ebx
80102461:	e8 ca 1e 00 00       	call   80104330 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102466:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010246b:	83 c4 10             	add    $0x10,%esp
8010246e:	85 c0                	test   %eax,%eax
80102470:	74 05                	je     80102477 <ideintr+0x87>
    idestart(idequeue);
80102472:	e8 19 fe ff ff       	call   80102290 <idestart>
    release(&idelock);
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 80 c5 10 80       	push   $0x8010c580
8010247f:	e8 1c 25 00 00       	call   801049a0 <release>

  release(&idelock);
}
80102484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102487:	5b                   	pop    %ebx
80102488:	5e                   	pop    %esi
80102489:	5f                   	pop    %edi
8010248a:	5d                   	pop    %ebp
8010248b:	c3                   	ret    
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 10             	sub    $0x10,%esp
80102497:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010249a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010249d:	50                   	push   %eax
8010249e:	e8 ad 22 00 00       	call   80104750 <holdingsleep>
801024a3:	83 c4 10             	add    $0x10,%esp
801024a6:	85 c0                	test   %eax,%eax
801024a8:	0f 84 c6 00 00 00    	je     80102574 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024ae:	8b 03                	mov    (%ebx),%eax
801024b0:	83 e0 06             	and    $0x6,%eax
801024b3:	83 f8 02             	cmp    $0x2,%eax
801024b6:	0f 84 ab 00 00 00    	je     80102567 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024bc:	8b 53 04             	mov    0x4(%ebx),%edx
801024bf:	85 d2                	test   %edx,%edx
801024c1:	74 0d                	je     801024d0 <iderw+0x40>
801024c3:	a1 60 c5 10 80       	mov    0x8010c560,%eax
801024c8:	85 c0                	test   %eax,%eax
801024ca:	0f 84 b1 00 00 00    	je     80102581 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 80 c5 10 80       	push   $0x8010c580
801024d8:	e8 03 24 00 00       	call   801048e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024dd:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801024e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801024e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024ed:	85 d2                	test   %edx,%edx
801024ef:	75 09                	jne    801024fa <iderw+0x6a>
801024f1:	eb 6d                	jmp    80102560 <iderw+0xd0>
801024f3:	90                   	nop
801024f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024f8:	89 c2                	mov    %eax,%edx
801024fa:	8b 42 58             	mov    0x58(%edx),%eax
801024fd:	85 c0                	test   %eax,%eax
801024ff:	75 f7                	jne    801024f8 <iderw+0x68>
80102501:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102504:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102506:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
8010250c:	74 42                	je     80102550 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	74 23                	je     8010253b <iderw+0xab>
80102518:	90                   	nop
80102519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102520:	83 ec 08             	sub    $0x8,%esp
80102523:	68 80 c5 10 80       	push   $0x8010c580
80102528:	53                   	push   %ebx
80102529:	e8 52 1c 00 00       	call   80104180 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010252e:	8b 03                	mov    (%ebx),%eax
80102530:	83 c4 10             	add    $0x10,%esp
80102533:	83 e0 06             	and    $0x6,%eax
80102536:	83 f8 02             	cmp    $0x2,%eax
80102539:	75 e5                	jne    80102520 <iderw+0x90>
  }


  release(&idelock);
8010253b:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102545:	c9                   	leave  
  release(&idelock);
80102546:	e9 55 24 00 00       	jmp    801049a0 <release>
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102550:	89 d8                	mov    %ebx,%eax
80102552:	e8 39 fd ff ff       	call   80102290 <idestart>
80102557:	eb b5                	jmp    8010250e <iderw+0x7e>
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102560:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102565:	eb 9d                	jmp    80102504 <iderw+0x74>
    panic("iderw: nothing to do");
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 60 8c 10 80       	push   $0x80108c60
8010256f:	e8 1c de ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102574:	83 ec 0c             	sub    $0xc,%esp
80102577:	68 4a 8c 10 80       	push   $0x80108c4a
8010257c:	e8 0f de ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102581:	83 ec 0c             	sub    $0xc,%esp
80102584:	68 75 8c 10 80       	push   $0x80108c75
80102589:	e8 02 de ff ff       	call   80100390 <panic>
8010258e:	66 90                	xchg   %ax,%ax

80102590 <getIdeQeueue>:


int getIdeQeueue(int *numO, int *readO, int *writeO, int *workblock, int *workdev){
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	57                   	push   %edi
80102594:	56                   	push   %esi
80102595:	53                   	push   %ebx
  struct buf *pp;
  int numOp = 0, readOp = 0, writeOp = 0;
80102596:	31 f6                	xor    %esi,%esi
80102598:	31 db                	xor    %ebx,%ebx
int getIdeQeueue(int *numO, int *readO, int *writeO, int *workblock, int *workdev){
8010259a:	83 ec 18             	sub    $0x18,%esp
  int i = 0;

  acquire(&idelock);
8010259d:	68 80 c5 10 80       	push   $0x8010c580
801025a2:	e8 39 23 00 00       	call   801048e0 <acquire>

  pp = idequeue;
801025a7:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
  while(pp){
801025ad:	83 c4 10             	add    $0x10,%esp
  int numOp = 0, readOp = 0, writeOp = 0;
801025b0:	31 c0                	xor    %eax,%eax
  while(pp){
801025b2:	85 d2                	test   %edx,%edx
801025b4:	74 3e                	je     801025f4 <getIdeQeueue+0x64>
801025b6:	8d 76 00             	lea    0x0(%esi),%esi
801025b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    numOp++;
    if(pp->flags & IDE_CMD_READ) //READ OPERATION
801025c0:	8b 0a                	mov    (%edx),%ecx
    numOp++;
801025c2:	83 c3 01             	add    $0x1,%ebx
    if(pp->flags & IDE_CMD_READ) //READ OPERATION
801025c5:	89 cf                	mov    %ecx,%edi
801025c7:	83 e7 20             	and    $0x20,%edi
      readOp++;
801025ca:	83 ff 01             	cmp    $0x1,%edi
    if(pp->flags & IDE_CMD_WRITE) //WRITE OPERATION
      writeOp++;
    workblock[i] = pp->blockno;
801025cd:	8b 7d 14             	mov    0x14(%ebp),%edi
      readOp++;
801025d0:	83 de ff             	sbb    $0xffffffff,%esi
    if(pp->flags & IDE_CMD_WRITE) //WRITE OPERATION
801025d3:	83 e1 30             	and    $0x30,%ecx
      writeOp++;
801025d6:	83 f9 01             	cmp    $0x1,%ecx
    workblock[i] = pp->blockno;
801025d9:	8b 4a 08             	mov    0x8(%edx),%ecx
      writeOp++;
801025dc:	83 d8 ff             	sbb    $0xffffffff,%eax
    workblock[i] = pp->blockno;
801025df:	89 4c 9f fc          	mov    %ecx,-0x4(%edi,%ebx,4)
    workdev[i] = pp->dev;
801025e3:	8b 7d 18             	mov    0x18(%ebp),%edi
801025e6:	8b 4a 04             	mov    0x4(%edx),%ecx
801025e9:	89 4c 9f fc          	mov    %ecx,-0x4(%edi,%ebx,4)

    i++;
    pp=pp->next;
801025ed:	8b 52 54             	mov    0x54(%edx),%edx
  while(pp){
801025f0:	85 d2                	test   %edx,%edx
801025f2:	75 cc                	jne    801025c0 <getIdeQeueue+0x30>
  }


  *numO = numOp;
801025f4:	8b 55 08             	mov    0x8(%ebp),%edx
  *readO = readOp;
  *writeO = writeOp;

  release(&idelock);
801025f7:	83 ec 0c             	sub    $0xc,%esp
  *numO = numOp;
801025fa:	89 1a                	mov    %ebx,(%edx)
  *readO = readOp;
801025fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801025ff:	89 32                	mov    %esi,(%edx)
  *writeO = writeOp;
80102601:	8b 55 10             	mov    0x10(%ebp),%edx
80102604:	89 02                	mov    %eax,(%edx)
  release(&idelock);
80102606:	68 80 c5 10 80       	push   $0x8010c580
8010260b:	e8 90 23 00 00       	call   801049a0 <release>
  return i;

}
80102610:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102613:	89 d8                	mov    %ebx,%eax
80102615:	5b                   	pop    %ebx
80102616:	5e                   	pop    %esi
80102617:	5f                   	pop    %edi
80102618:	5d                   	pop    %ebp
80102619:	c3                   	ret    
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102620:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102621:	c7 05 94 46 11 80 00 	movl   $0xfec00000,0x80114694
80102628:	00 c0 fe 
{
8010262b:	89 e5                	mov    %esp,%ebp
8010262d:	56                   	push   %esi
8010262e:	53                   	push   %ebx
  ioapic->reg = reg;
8010262f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102636:	00 00 00 
  return ioapic->data;
80102639:	a1 94 46 11 80       	mov    0x80114694,%eax
8010263e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102647:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010264d:	0f b6 15 c0 47 11 80 	movzbl 0x801147c0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102654:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102657:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010265a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010265d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102660:	39 c2                	cmp    %eax,%edx
80102662:	74 16                	je     8010267a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102664:	83 ec 0c             	sub    $0xc,%esp
80102667:	68 94 8c 10 80       	push   $0x80108c94
8010266c:	e8 ef df ff ff       	call   80100660 <cprintf>
80102671:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
80102677:	83 c4 10             	add    $0x10,%esp
8010267a:	83 c3 21             	add    $0x21,%ebx
{
8010267d:	ba 10 00 00 00       	mov    $0x10,%edx
80102682:	b8 20 00 00 00       	mov    $0x20,%eax
80102687:	89 f6                	mov    %esi,%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102690:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102692:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102698:	89 c6                	mov    %eax,%esi
8010269a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026a3:	89 71 10             	mov    %esi,0x10(%ecx)
801026a6:	8d 72 01             	lea    0x1(%edx),%esi
801026a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801026ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801026ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801026b0:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
801026b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801026bd:	75 d1                	jne    80102690 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026c2:	5b                   	pop    %ebx
801026c3:	5e                   	pop    %esi
801026c4:	5d                   	pop    %ebp
801026c5:	c3                   	ret    
801026c6:	8d 76 00             	lea    0x0(%esi),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026d0:	55                   	push   %ebp
  ioapic->reg = reg;
801026d1:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
{
801026d7:	89 e5                	mov    %esp,%ebp
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026dc:	8d 50 20             	lea    0x20(%eax),%edx
801026df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026e5:	8b 0d 94 46 11 80    	mov    0x80114694,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026f6:	a1 94 46 11 80       	mov    0x80114694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102701:	5d                   	pop    %ebp
80102702:	c3                   	ret    
80102703:	66 90                	xchg   %ax,%ax
80102705:	66 90                	xchg   %ax,%ax
80102707:	66 90                	xchg   %ax,%ax
80102709:	66 90                	xchg   %ax,%ax
8010270b:	66 90                	xchg   %ax,%ax
8010270d:	66 90                	xchg   %ax,%ax
8010270f:	90                   	nop

80102710 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	53                   	push   %ebx
80102714:	83 ec 04             	sub    $0x4,%esp
80102717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010271a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102720:	75 70                	jne    80102792 <kfree+0x82>
80102722:	81 fb 08 75 11 80    	cmp    $0x80117508,%ebx
80102728:	72 68                	jb     80102792 <kfree+0x82>
8010272a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102730:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102735:	77 5b                	ja     80102792 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102737:	83 ec 04             	sub    $0x4,%esp
8010273a:	68 00 10 00 00       	push   $0x1000
8010273f:	6a 01                	push   $0x1
80102741:	53                   	push   %ebx
80102742:	e8 a9 22 00 00       	call   801049f0 <memset>

  if(kmem.use_lock)
80102747:	8b 15 d4 46 11 80    	mov    0x801146d4,%edx
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	85 d2                	test   %edx,%edx
80102752:	75 2c                	jne    80102780 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102754:	a1 d8 46 11 80       	mov    0x801146d8,%eax
80102759:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010275b:	a1 d4 46 11 80       	mov    0x801146d4,%eax
  kmem.freelist = r;
80102760:	89 1d d8 46 11 80    	mov    %ebx,0x801146d8
  if(kmem.use_lock)
80102766:	85 c0                	test   %eax,%eax
80102768:	75 06                	jne    80102770 <kfree+0x60>
    release(&kmem.lock);
}
8010276a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276d:	c9                   	leave  
8010276e:	c3                   	ret    
8010276f:	90                   	nop
    release(&kmem.lock);
80102770:	c7 45 08 a0 46 11 80 	movl   $0x801146a0,0x8(%ebp)
}
80102777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277a:	c9                   	leave  
    release(&kmem.lock);
8010277b:	e9 20 22 00 00       	jmp    801049a0 <release>
    acquire(&kmem.lock);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	68 a0 46 11 80       	push   $0x801146a0
80102788:	e8 53 21 00 00       	call   801048e0 <acquire>
8010278d:	83 c4 10             	add    $0x10,%esp
80102790:	eb c2                	jmp    80102754 <kfree+0x44>
    panic("kfree");
80102792:	83 ec 0c             	sub    $0xc,%esp
80102795:	68 c6 8c 10 80       	push   $0x80108cc6
8010279a:	e8 f1 db ff ff       	call   80100390 <panic>
8010279f:	90                   	nop

801027a0 <freerange>:
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	56                   	push   %esi
801027a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027bd:	39 de                	cmp    %ebx,%esi
801027bf:	72 23                	jb     801027e4 <freerange+0x44>
801027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027d7:	50                   	push   %eax
801027d8:	e8 33 ff ff ff       	call   80102710 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	39 f3                	cmp    %esi,%ebx
801027e2:	76 e4                	jbe    801027c8 <freerange+0x28>
}
801027e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e7:	5b                   	pop    %ebx
801027e8:	5e                   	pop    %esi
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <kinit1>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
801027f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027f8:	83 ec 08             	sub    $0x8,%esp
801027fb:	68 cc 8c 10 80       	push   $0x80108ccc
80102800:	68 a0 46 11 80       	push   $0x801146a0
80102805:	e8 96 1f 00 00       	call   801047a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010280a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102810:	c7 05 d4 46 11 80 00 	movl   $0x0,0x801146d4
80102817:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010281a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102820:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102826:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010282c:	39 de                	cmp    %ebx,%esi
8010282e:	72 1c                	jb     8010284c <kinit1+0x5c>
    kfree(p);
80102830:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102836:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102839:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010283f:	50                   	push   %eax
80102840:	e8 cb fe ff ff       	call   80102710 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102845:	83 c4 10             	add    $0x10,%esp
80102848:	39 de                	cmp    %ebx,%esi
8010284a:	73 e4                	jae    80102830 <kinit1+0x40>
}
8010284c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010284f:	5b                   	pop    %ebx
80102850:	5e                   	pop    %esi
80102851:	5d                   	pop    %ebp
80102852:	c3                   	ret    
80102853:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <kinit2>:
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	56                   	push   %esi
80102864:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102865:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102868:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010286b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102871:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102877:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010287d:	39 de                	cmp    %ebx,%esi
8010287f:	72 23                	jb     801028a4 <kinit2+0x44>
80102881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102888:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010288e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102891:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102897:	50                   	push   %eax
80102898:	e8 73 fe ff ff       	call   80102710 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	39 de                	cmp    %ebx,%esi
801028a2:	73 e4                	jae    80102888 <kinit2+0x28>
  kmem.use_lock = 1;
801028a4:	c7 05 d4 46 11 80 01 	movl   $0x1,0x801146d4
801028ab:	00 00 00 
}
801028ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028b1:	5b                   	pop    %ebx
801028b2:	5e                   	pop    %esi
801028b3:	5d                   	pop    %ebp
801028b4:	c3                   	ret    
801028b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801028c0:	a1 d4 46 11 80       	mov    0x801146d4,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	75 1f                	jne    801028e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801028c9:	a1 d8 46 11 80       	mov    0x801146d8,%eax
  if(r)
801028ce:	85 c0                	test   %eax,%eax
801028d0:	74 0e                	je     801028e0 <kalloc+0x20>
    kmem.freelist = r->next;
801028d2:	8b 10                	mov    (%eax),%edx
801028d4:	89 15 d8 46 11 80    	mov    %edx,0x801146d8
801028da:	c3                   	ret    
801028db:	90                   	nop
801028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801028e0:	f3 c3                	repz ret 
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801028e8:	55                   	push   %ebp
801028e9:	89 e5                	mov    %esp,%ebp
801028eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801028ee:	68 a0 46 11 80       	push   $0x801146a0
801028f3:	e8 e8 1f 00 00       	call   801048e0 <acquire>
  r = kmem.freelist;
801028f8:	a1 d8 46 11 80       	mov    0x801146d8,%eax
  if(r)
801028fd:	83 c4 10             	add    $0x10,%esp
80102900:	8b 15 d4 46 11 80    	mov    0x801146d4,%edx
80102906:	85 c0                	test   %eax,%eax
80102908:	74 08                	je     80102912 <kalloc+0x52>
    kmem.freelist = r->next;
8010290a:	8b 08                	mov    (%eax),%ecx
8010290c:	89 0d d8 46 11 80    	mov    %ecx,0x801146d8
  if(kmem.use_lock)
80102912:	85 d2                	test   %edx,%edx
80102914:	74 16                	je     8010292c <kalloc+0x6c>
    release(&kmem.lock);
80102916:	83 ec 0c             	sub    $0xc,%esp
80102919:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010291c:	68 a0 46 11 80       	push   $0x801146a0
80102921:	e8 7a 20 00 00       	call   801049a0 <release>
  return (char*)r;
80102926:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102929:	83 c4 10             	add    $0x10,%esp
}
8010292c:	c9                   	leave  
8010292d:	c3                   	ret    
8010292e:	66 90                	xchg   %ax,%ax

80102930 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	ba 64 00 00 00       	mov    $0x64,%edx
80102935:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102936:	a8 01                	test   $0x1,%al
80102938:	0f 84 c2 00 00 00    	je     80102a00 <kbdgetc+0xd0>
8010293e:	ba 60 00 00 00       	mov    $0x60,%edx
80102943:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102944:	0f b6 d0             	movzbl %al,%edx
80102947:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
8010294d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102953:	0f 84 7f 00 00 00    	je     801029d8 <kbdgetc+0xa8>
{
80102959:	55                   	push   %ebp
8010295a:	89 e5                	mov    %esp,%ebp
8010295c:	53                   	push   %ebx
8010295d:	89 cb                	mov    %ecx,%ebx
8010295f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102962:	84 c0                	test   %al,%al
80102964:	78 4a                	js     801029b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102966:	85 db                	test   %ebx,%ebx
80102968:	74 09                	je     80102973 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010296a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010296d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102970:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102973:	0f b6 82 00 8e 10 80 	movzbl -0x7fef7200(%edx),%eax
8010297a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010297c:	0f b6 82 00 8d 10 80 	movzbl -0x7fef7300(%edx),%eax
80102983:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102985:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102987:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010298d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102990:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102993:	8b 04 85 e0 8c 10 80 	mov    -0x7fef7320(,%eax,4),%eax
8010299a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010299e:	74 31                	je     801029d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801029a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801029a3:	83 fa 19             	cmp    $0x19,%edx
801029a6:	77 40                	ja     801029e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801029a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029ab:	5b                   	pop    %ebx
801029ac:	5d                   	pop    %ebp
801029ad:	c3                   	ret    
801029ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801029b0:	83 e0 7f             	and    $0x7f,%eax
801029b3:	85 db                	test   %ebx,%ebx
801029b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801029b8:	0f b6 82 00 8e 10 80 	movzbl -0x7fef7200(%edx),%eax
801029bf:	83 c8 40             	or     $0x40,%eax
801029c2:	0f b6 c0             	movzbl %al,%eax
801029c5:	f7 d0                	not    %eax
801029c7:	21 c1                	and    %eax,%ecx
    return 0;
801029c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801029cb:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
801029d1:	5b                   	pop    %ebx
801029d2:	5d                   	pop    %ebp
801029d3:	c3                   	ret    
801029d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801029d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801029db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801029dd:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
801029e3:	c3                   	ret    
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801029e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801029ef:	83 f9 1a             	cmp    $0x1a,%ecx
801029f2:	0f 42 c2             	cmovb  %edx,%eax
}
801029f5:	5d                   	pop    %ebp
801029f6:	c3                   	ret    
801029f7:	89 f6                	mov    %esi,%esi
801029f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a05:	c3                   	ret    
80102a06:	8d 76 00             	lea    0x0(%esi),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <kbdintr>:

void
kbdintr(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a16:	68 30 29 10 80       	push   $0x80102930
80102a1b:	e8 f0 dd ff ff       	call   80100810 <consoleintr>
}
80102a20:	83 c4 10             	add    $0x10,%esp
80102a23:	c9                   	leave  
80102a24:	c3                   	ret    
80102a25:	66 90                	xchg   %ax,%ax
80102a27:	66 90                	xchg   %ax,%ax
80102a29:	66 90                	xchg   %ax,%ax
80102a2b:	66 90                	xchg   %ax,%ax
80102a2d:	66 90                	xchg   %ax,%ax
80102a2f:	90                   	nop

80102a30 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a30:	a1 dc 46 11 80       	mov    0x801146dc,%eax
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a38:	85 c0                	test   %eax,%eax
80102a3a:	0f 84 c8 00 00 00    	je     80102b08 <lapicinit+0xd8>
  lapic[index] = value;
80102a40:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a47:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a61:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a67:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a6e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a74:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a7b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a81:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a88:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a8e:	8b 50 30             	mov    0x30(%eax),%edx
80102a91:	c1 ea 10             	shr    $0x10,%edx
80102a94:	80 fa 03             	cmp    $0x3,%dl
80102a97:	77 77                	ja     80102b10 <lapicinit+0xe0>
  lapic[index] = value;
80102a99:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102aa0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102abd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102acd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ad4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ada:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ae1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae4:	8b 50 20             	mov    0x20(%eax),%edx
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102af0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102af6:	80 e6 10             	and    $0x10,%dh
80102af9:	75 f5                	jne    80102af0 <lapicinit+0xc0>
  lapic[index] = value;
80102afb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b08:	5d                   	pop    %ebp
80102b09:	c3                   	ret    
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102b10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1a:	8b 50 20             	mov    0x20(%eax),%edx
80102b1d:	e9 77 ff ff ff       	jmp    80102a99 <lapicinit+0x69>
80102b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b30:	8b 15 dc 46 11 80    	mov    0x801146dc,%edx
{
80102b36:	55                   	push   %ebp
80102b37:	31 c0                	xor    %eax,%eax
80102b39:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b3b:	85 d2                	test   %edx,%edx
80102b3d:	74 06                	je     80102b45 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b3f:	8b 42 20             	mov    0x20(%edx),%eax
80102b42:	c1 e8 18             	shr    $0x18,%eax
}
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    
80102b47:	89 f6                	mov    %esi,%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b50:	a1 dc 46 11 80       	mov    0x801146dc,%eax
{
80102b55:	55                   	push   %ebp
80102b56:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	74 0d                	je     80102b69 <lapiceoi+0x19>
  lapic[index] = value;
80102b5c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b63:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b69:	5d                   	pop    %ebp
80102b6a:	c3                   	ret    
80102b6b:	90                   	nop
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
}
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret    
80102b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b81:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b86:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	53                   	push   %ebx
80102b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b94:	ee                   	out    %al,(%dx)
80102b95:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b9a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ba0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ba2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ba5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102bb0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102bb3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bb5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102bb8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102bbe:	a1 dc 46 11 80       	mov    0x801146dc,%eax
80102bc3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bcc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bd3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bd9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102be0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102be6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bf8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c0a:	5b                   	pop    %ebx
80102c0b:	5d                   	pop    %ebp
80102c0c:	c3                   	ret    
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi

80102c10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102c10:	55                   	push   %ebp
80102c11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c16:	ba 70 00 00 00       	mov    $0x70,%edx
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	57                   	push   %edi
80102c1e:	56                   	push   %esi
80102c1f:	53                   	push   %ebx
80102c20:	83 ec 4c             	sub    $0x4c,%esp
80102c23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c24:	ba 71 00 00 00       	mov    $0x71,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c35:	8d 76 00             	lea    0x0(%esi),%esi
80102c38:	31 c0                	xor    %eax,%eax
80102c3a:	89 da                	mov    %ebx,%edx
80102c3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c42:	89 ca                	mov    %ecx,%edx
80102c44:	ec                   	in     (%dx),%al
80102c45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c48:	89 da                	mov    %ebx,%edx
80102c4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c50:	89 ca                	mov    %ecx,%edx
80102c52:	ec                   	in     (%dx),%al
80102c53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c56:	89 da                	mov    %ebx,%edx
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
80102c61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 da                	mov    %ebx,%edx
80102c66:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	b8 08 00 00 00       	mov    $0x8,%eax
80102c79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7a:	89 ca                	mov    %ecx,%edx
80102c7c:	ec                   	in     (%dx),%al
80102c7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7f:	89 da                	mov    %ebx,%edx
80102c81:	b8 09 00 00 00       	mov    $0x9,%eax
80102c86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c87:	89 ca                	mov    %ecx,%edx
80102c89:	ec                   	in     (%dx),%al
80102c8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8c:	89 da                	mov    %ebx,%edx
80102c8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c94:	89 ca                	mov    %ecx,%edx
80102c96:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c97:	84 c0                	test   %al,%al
80102c99:	78 9d                	js     80102c38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c9f:	89 fa                	mov    %edi,%edx
80102ca1:	0f b6 fa             	movzbl %dl,%edi
80102ca4:	89 f2                	mov    %esi,%edx
80102ca6:	0f b6 f2             	movzbl %dl,%esi
80102ca9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cac:	89 da                	mov    %ebx,%edx
80102cae:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102cb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102cb4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102cb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102cbb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102cbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102cc2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102cc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102cc9:	31 c0                	xor    %eax,%eax
80102ccb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccc:	89 ca                	mov    %ecx,%edx
80102cce:	ec                   	in     (%dx),%al
80102ccf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd2:	89 da                	mov    %ebx,%edx
80102cd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cd7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cdd:	89 ca                	mov    %ecx,%edx
80102cdf:	ec                   	in     (%dx),%al
80102ce0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce3:	89 da                	mov    %ebx,%edx
80102ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ce8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ced:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cee:	89 ca                	mov    %ecx,%edx
80102cf0:	ec                   	in     (%dx),%al
80102cf1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf4:	89 da                	mov    %ebx,%edx
80102cf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cf9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cff:	89 ca                	mov    %ecx,%edx
80102d01:	ec                   	in     (%dx),%al
80102d02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d05:	89 da                	mov    %ebx,%edx
80102d07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d10:	89 ca                	mov    %ecx,%edx
80102d12:	ec                   	in     (%dx),%al
80102d13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d16:	89 da                	mov    %ebx,%edx
80102d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d21:	89 ca                	mov    %ecx,%edx
80102d23:	ec                   	in     (%dx),%al
80102d24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d30:	6a 18                	push   $0x18
80102d32:	50                   	push   %eax
80102d33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d36:	50                   	push   %eax
80102d37:	e8 04 1d 00 00       	call   80104a40 <memcmp>
80102d3c:	83 c4 10             	add    $0x10,%esp
80102d3f:	85 c0                	test   %eax,%eax
80102d41:	0f 85 f1 fe ff ff    	jne    80102c38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d4b:	75 78                	jne    80102dc5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d50:	89 c2                	mov    %eax,%edx
80102d52:	83 e0 0f             	and    $0xf,%eax
80102d55:	c1 ea 04             	shr    $0x4,%edx
80102d58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d64:	89 c2                	mov    %eax,%edx
80102d66:	83 e0 0f             	and    $0xf,%eax
80102d69:	c1 ea 04             	shr    $0x4,%edx
80102d6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d78:	89 c2                	mov    %eax,%edx
80102d7a:	83 e0 0f             	and    $0xf,%eax
80102d7d:	c1 ea 04             	shr    $0x4,%edx
80102d80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d8c:	89 c2                	mov    %eax,%edx
80102d8e:	83 e0 0f             	and    $0xf,%eax
80102d91:	c1 ea 04             	shr    $0x4,%edx
80102d94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	83 e0 0f             	and    $0xf,%eax
80102da5:	c1 ea 04             	shr    $0x4,%edx
80102da8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db4:	89 c2                	mov    %eax,%edx
80102db6:	83 e0 0f             	and    $0xf,%eax
80102db9:	c1 ea 04             	shr    $0x4,%edx
80102dbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102dc5:	8b 75 08             	mov    0x8(%ebp),%esi
80102dc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dcb:	89 06                	mov    %eax,(%esi)
80102dcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dd0:	89 46 04             	mov    %eax,0x4(%esi)
80102dd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dd6:	89 46 08             	mov    %eax,0x8(%esi)
80102dd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ddc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ddf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102de2:	89 46 10             	mov    %eax,0x10(%esi)
80102de5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102de8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102deb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df5:	5b                   	pop    %ebx
80102df6:	5e                   	pop    %esi
80102df7:	5f                   	pop    %edi
80102df8:	5d                   	pop    %ebp
80102df9:	c3                   	ret    
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e00:	8b 0d 28 47 11 80    	mov    0x80114728,%ecx
80102e06:	85 c9                	test   %ecx,%ecx
80102e08:	0f 8e 8a 00 00 00    	jle    80102e98 <install_trans+0x98>
{
80102e0e:	55                   	push   %ebp
80102e0f:	89 e5                	mov    %esp,%ebp
80102e11:	57                   	push   %edi
80102e12:	56                   	push   %esi
80102e13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e14:	31 db                	xor    %ebx,%ebx
{
80102e16:	83 ec 0c             	sub    $0xc,%esp
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e20:	a1 14 47 11 80       	mov    0x80114714,%eax
80102e25:	83 ec 08             	sub    $0x8,%esp
80102e28:	01 d8                	add    %ebx,%eax
80102e2a:	83 c0 01             	add    $0x1,%eax
80102e2d:	50                   	push   %eax
80102e2e:	ff 35 24 47 11 80    	pushl  0x80114724
80102e34:	e8 97 d2 ff ff       	call   801000d0 <bread>
80102e39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e3b:	58                   	pop    %eax
80102e3c:	5a                   	pop    %edx
80102e3d:	ff 34 9d 2c 47 11 80 	pushl  -0x7feeb8d4(,%ebx,4)
80102e44:	ff 35 24 47 11 80    	pushl  0x80114724
  for (tail = 0; tail < log.lh.n; tail++) {
80102e4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e4d:	e8 7e d2 ff ff       	call   801000d0 <bread>
80102e52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e57:	83 c4 0c             	add    $0xc,%esp
80102e5a:	68 00 02 00 00       	push   $0x200
80102e5f:	50                   	push   %eax
80102e60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e63:	50                   	push   %eax
80102e64:	e8 37 1c 00 00       	call   80104aa0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e69:	89 34 24             	mov    %esi,(%esp)
80102e6c:	e8 2f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e71:	89 3c 24             	mov    %edi,(%esp)
80102e74:	e8 67 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e79:	89 34 24             	mov    %esi,(%esp)
80102e7c:	e8 5f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e81:	83 c4 10             	add    $0x10,%esp
80102e84:	39 1d 28 47 11 80    	cmp    %ebx,0x80114728
80102e8a:	7f 94                	jg     80102e20 <install_trans+0x20>
  }
}
80102e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e8f:	5b                   	pop    %ebx
80102e90:	5e                   	pop    %esi
80102e91:	5f                   	pop    %edi
80102e92:	5d                   	pop    %ebp
80102e93:	c3                   	ret    
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e98:	f3 c3                	repz ret 
80102e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ea0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	56                   	push   %esi
80102ea4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	ff 35 14 47 11 80    	pushl  0x80114714
80102eae:	ff 35 24 47 11 80    	pushl  0x80114724
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102eb9:	8b 1d 28 47 11 80    	mov    0x80114728,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ebf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ec2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ec4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ec6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ec9:	7e 16                	jle    80102ee1 <write_head+0x41>
80102ecb:	c1 e3 02             	shl    $0x2,%ebx
80102ece:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ed0:	8b 8a 2c 47 11 80    	mov    -0x7feeb8d4(%edx),%ecx
80102ed6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102eda:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102edd:	39 da                	cmp    %ebx,%edx
80102edf:	75 ef                	jne    80102ed0 <write_head+0x30>
  }
  bwrite(buf);
80102ee1:	83 ec 0c             	sub    $0xc,%esp
80102ee4:	56                   	push   %esi
80102ee5:	e8 b6 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102eea:	89 34 24             	mov    %esi,(%esp)
80102eed:	e8 ee d2 ff ff       	call   801001e0 <brelse>
}
80102ef2:	83 c4 10             	add    $0x10,%esp
80102ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ef8:	5b                   	pop    %ebx
80102ef9:	5e                   	pop    %esi
80102efa:	5d                   	pop    %ebp
80102efb:	c3                   	ret    
80102efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f00 <initlog>:
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	53                   	push   %ebx
80102f04:	83 ec 2c             	sub    $0x2c,%esp
80102f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f0a:	68 00 8f 10 80       	push   $0x80108f00
80102f0f:	68 e0 46 11 80       	push   $0x801146e0
80102f14:	e8 87 18 00 00       	call   801047a0 <initlock>
  readsb(dev, &sb);
80102f19:	58                   	pop    %eax
80102f1a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f1d:	5a                   	pop    %edx
80102f1e:	50                   	push   %eax
80102f1f:	53                   	push   %ebx
80102f20:	e8 1b e6 ff ff       	call   80101540 <readsb>
  log.size = sb.nlog;
80102f25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f2b:	59                   	pop    %ecx
  log.dev = dev;
80102f2c:	89 1d 24 47 11 80    	mov    %ebx,0x80114724
  log.size = sb.nlog;
80102f32:	89 15 18 47 11 80    	mov    %edx,0x80114718
  log.start = sb.logstart;
80102f38:	a3 14 47 11 80       	mov    %eax,0x80114714
  struct buf *buf = bread(log.dev, log.start);
80102f3d:	5a                   	pop    %edx
80102f3e:	50                   	push   %eax
80102f3f:	53                   	push   %ebx
80102f40:	e8 8b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f48:	83 c4 10             	add    $0x10,%esp
80102f4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f4d:	89 1d 28 47 11 80    	mov    %ebx,0x80114728
  for (i = 0; i < log.lh.n; i++) {
80102f53:	7e 1c                	jle    80102f71 <initlog+0x71>
80102f55:	c1 e3 02             	shl    $0x2,%ebx
80102f58:	31 d2                	xor    %edx,%edx
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f64:	83 c2 04             	add    $0x4,%edx
80102f67:	89 8a 28 47 11 80    	mov    %ecx,-0x7feeb8d8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f6d:	39 d3                	cmp    %edx,%ebx
80102f6f:	75 ef                	jne    80102f60 <initlog+0x60>
  brelse(buf);
80102f71:	83 ec 0c             	sub    $0xc,%esp
80102f74:	50                   	push   %eax
80102f75:	e8 66 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f7a:	e8 81 fe ff ff       	call   80102e00 <install_trans>
  log.lh.n = 0;
80102f7f:	c7 05 28 47 11 80 00 	movl   $0x0,0x80114728
80102f86:	00 00 00 
  write_head(); // clear the log
80102f89:	e8 12 ff ff ff       	call   80102ea0 <write_head>
}
80102f8e:	83 c4 10             	add    $0x10,%esp
80102f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f94:	c9                   	leave  
80102f95:	c3                   	ret    
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fa6:	68 e0 46 11 80       	push   $0x801146e0
80102fab:	e8 30 19 00 00       	call   801048e0 <acquire>
80102fb0:	83 c4 10             	add    $0x10,%esp
80102fb3:	eb 18                	jmp    80102fcd <begin_op+0x2d>
80102fb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fb8:	83 ec 08             	sub    $0x8,%esp
80102fbb:	68 e0 46 11 80       	push   $0x801146e0
80102fc0:	68 e0 46 11 80       	push   $0x801146e0
80102fc5:	e8 b6 11 00 00       	call   80104180 <sleep>
80102fca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102fcd:	a1 20 47 11 80       	mov    0x80114720,%eax
80102fd2:	85 c0                	test   %eax,%eax
80102fd4:	75 e2                	jne    80102fb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fd6:	a1 1c 47 11 80       	mov    0x8011471c,%eax
80102fdb:	8b 15 28 47 11 80    	mov    0x80114728,%edx
80102fe1:	83 c0 01             	add    $0x1,%eax
80102fe4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fe7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fea:	83 fa 1e             	cmp    $0x1e,%edx
80102fed:	7f c9                	jg     80102fb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ff2:	a3 1c 47 11 80       	mov    %eax,0x8011471c
      release(&log.lock);
80102ff7:	68 e0 46 11 80       	push   $0x801146e0
80102ffc:	e8 9f 19 00 00       	call   801049a0 <release>
      break;
    }
  }
}
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	c9                   	leave  
80103005:	c3                   	ret    
80103006:	8d 76 00             	lea    0x0(%esi),%esi
80103009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103010 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103019:	68 e0 46 11 80       	push   $0x801146e0
8010301e:	e8 bd 18 00 00       	call   801048e0 <acquire>
  log.outstanding -= 1;
80103023:	a1 1c 47 11 80       	mov    0x8011471c,%eax
  if(log.committing)
80103028:	8b 35 20 47 11 80    	mov    0x80114720,%esi
8010302e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103031:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103034:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103036:	89 1d 1c 47 11 80    	mov    %ebx,0x8011471c
  if(log.committing)
8010303c:	0f 85 1a 01 00 00    	jne    8010315c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103042:	85 db                	test   %ebx,%ebx
80103044:	0f 85 ee 00 00 00    	jne    80103138 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010304a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010304d:	c7 05 20 47 11 80 01 	movl   $0x1,0x80114720
80103054:	00 00 00 
  release(&log.lock);
80103057:	68 e0 46 11 80       	push   $0x801146e0
8010305c:	e8 3f 19 00 00       	call   801049a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103061:	8b 0d 28 47 11 80    	mov    0x80114728,%ecx
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c9                	test   %ecx,%ecx
8010306c:	0f 8e 85 00 00 00    	jle    801030f7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103072:	a1 14 47 11 80       	mov    0x80114714,%eax
80103077:	83 ec 08             	sub    $0x8,%esp
8010307a:	01 d8                	add    %ebx,%eax
8010307c:	83 c0 01             	add    $0x1,%eax
8010307f:	50                   	push   %eax
80103080:	ff 35 24 47 11 80    	pushl  0x80114724
80103086:	e8 45 d0 ff ff       	call   801000d0 <bread>
8010308b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010308d:	58                   	pop    %eax
8010308e:	5a                   	pop    %edx
8010308f:	ff 34 9d 2c 47 11 80 	pushl  -0x7feeb8d4(,%ebx,4)
80103096:	ff 35 24 47 11 80    	pushl  0x80114724
  for (tail = 0; tail < log.lh.n; tail++) {
8010309c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309f:	e8 2c d0 ff ff       	call   801000d0 <bread>
801030a4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030a6:	8d 40 5c             	lea    0x5c(%eax),%eax
801030a9:	83 c4 0c             	add    $0xc,%esp
801030ac:	68 00 02 00 00       	push   $0x200
801030b1:	50                   	push   %eax
801030b2:	8d 46 5c             	lea    0x5c(%esi),%eax
801030b5:	50                   	push   %eax
801030b6:	e8 e5 19 00 00       	call   80104aa0 <memmove>
    bwrite(to);  // write the log
801030bb:	89 34 24             	mov    %esi,(%esp)
801030be:	e8 dd d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
801030c3:	89 3c 24             	mov    %edi,(%esp)
801030c6:	e8 15 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030cb:	89 34 24             	mov    %esi,(%esp)
801030ce:	e8 0d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030d3:	83 c4 10             	add    $0x10,%esp
801030d6:	3b 1d 28 47 11 80    	cmp    0x80114728,%ebx
801030dc:	7c 94                	jl     80103072 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030de:	e8 bd fd ff ff       	call   80102ea0 <write_head>
    install_trans(); // Now install writes to home locations
801030e3:	e8 18 fd ff ff       	call   80102e00 <install_trans>
    log.lh.n = 0;
801030e8:	c7 05 28 47 11 80 00 	movl   $0x0,0x80114728
801030ef:	00 00 00 
    write_head();    // Erase the transaction from the log
801030f2:	e8 a9 fd ff ff       	call   80102ea0 <write_head>
    acquire(&log.lock);
801030f7:	83 ec 0c             	sub    $0xc,%esp
801030fa:	68 e0 46 11 80       	push   $0x801146e0
801030ff:	e8 dc 17 00 00       	call   801048e0 <acquire>
    wakeup(&log);
80103104:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
    log.committing = 0;
8010310b:	c7 05 20 47 11 80 00 	movl   $0x0,0x80114720
80103112:	00 00 00 
    wakeup(&log);
80103115:	e8 16 12 00 00       	call   80104330 <wakeup>
    release(&log.lock);
8010311a:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
80103121:	e8 7a 18 00 00       	call   801049a0 <release>
80103126:	83 c4 10             	add    $0x10,%esp
}
80103129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312c:	5b                   	pop    %ebx
8010312d:	5e                   	pop    %esi
8010312e:	5f                   	pop    %edi
8010312f:	5d                   	pop    %ebp
80103130:	c3                   	ret    
80103131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103138:	83 ec 0c             	sub    $0xc,%esp
8010313b:	68 e0 46 11 80       	push   $0x801146e0
80103140:	e8 eb 11 00 00       	call   80104330 <wakeup>
  release(&log.lock);
80103145:	c7 04 24 e0 46 11 80 	movl   $0x801146e0,(%esp)
8010314c:	e8 4f 18 00 00       	call   801049a0 <release>
80103151:	83 c4 10             	add    $0x10,%esp
}
80103154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103157:	5b                   	pop    %ebx
80103158:	5e                   	pop    %esi
80103159:	5f                   	pop    %edi
8010315a:	5d                   	pop    %ebp
8010315b:	c3                   	ret    
    panic("log.committing");
8010315c:	83 ec 0c             	sub    $0xc,%esp
8010315f:	68 04 8f 10 80       	push   $0x80108f04
80103164:	e8 27 d2 ff ff       	call   80100390 <panic>
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103170 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103177:	8b 15 28 47 11 80    	mov    0x80114728,%edx
{
8010317d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103180:	83 fa 1d             	cmp    $0x1d,%edx
80103183:	0f 8f 9d 00 00 00    	jg     80103226 <log_write+0xb6>
80103189:	a1 18 47 11 80       	mov    0x80114718,%eax
8010318e:	83 e8 01             	sub    $0x1,%eax
80103191:	39 c2                	cmp    %eax,%edx
80103193:	0f 8d 8d 00 00 00    	jge    80103226 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103199:	a1 1c 47 11 80       	mov    0x8011471c,%eax
8010319e:	85 c0                	test   %eax,%eax
801031a0:	0f 8e 8d 00 00 00    	jle    80103233 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031a6:	83 ec 0c             	sub    $0xc,%esp
801031a9:	68 e0 46 11 80       	push   $0x801146e0
801031ae:	e8 2d 17 00 00       	call   801048e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031b3:	8b 0d 28 47 11 80    	mov    0x80114728,%ecx
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	83 f9 00             	cmp    $0x0,%ecx
801031bf:	7e 57                	jle    80103218 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801031c4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c6:	3b 15 2c 47 11 80    	cmp    0x8011472c,%edx
801031cc:	75 0b                	jne    801031d9 <log_write+0x69>
801031ce:	eb 38                	jmp    80103208 <log_write+0x98>
801031d0:	39 14 85 2c 47 11 80 	cmp    %edx,-0x7feeb8d4(,%eax,4)
801031d7:	74 2f                	je     80103208 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801031d9:	83 c0 01             	add    $0x1,%eax
801031dc:	39 c1                	cmp    %eax,%ecx
801031de:	75 f0                	jne    801031d0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801031e0:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801031e7:	83 c0 01             	add    $0x1,%eax
801031ea:	a3 28 47 11 80       	mov    %eax,0x80114728
  b->flags |= B_DIRTY; // prevent eviction
801031ef:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031f2:	c7 45 08 e0 46 11 80 	movl   $0x801146e0,0x8(%ebp)
}
801031f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031fc:	c9                   	leave  
  release(&log.lock);
801031fd:	e9 9e 17 00 00       	jmp    801049a0 <release>
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103208:	89 14 85 2c 47 11 80 	mov    %edx,-0x7feeb8d4(,%eax,4)
8010320f:	eb de                	jmp    801031ef <log_write+0x7f>
80103211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103218:	8b 43 08             	mov    0x8(%ebx),%eax
8010321b:	a3 2c 47 11 80       	mov    %eax,0x8011472c
  if (i == log.lh.n)
80103220:	75 cd                	jne    801031ef <log_write+0x7f>
80103222:	31 c0                	xor    %eax,%eax
80103224:	eb c1                	jmp    801031e7 <log_write+0x77>
    panic("too big a transaction");
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	68 13 8f 10 80       	push   $0x80108f13
8010322e:	e8 5d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103233:	83 ec 0c             	sub    $0xc,%esp
80103236:	68 29 8f 10 80       	push   $0x80108f29
8010323b:	e8 50 d1 ff ff       	call   80100390 <panic>

80103240 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	53                   	push   %ebx
80103244:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103247:	e8 74 09 00 00       	call   80103bc0 <cpuid>
8010324c:	89 c3                	mov    %eax,%ebx
8010324e:	e8 6d 09 00 00       	call   80103bc0 <cpuid>
80103253:	83 ec 04             	sub    $0x4,%esp
80103256:	53                   	push   %ebx
80103257:	50                   	push   %eax
80103258:	68 44 8f 10 80       	push   $0x80108f44
8010325d:	e8 fe d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103262:	e8 69 2a 00 00       	call   80105cd0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103267:	e8 d4 08 00 00       	call   80103b40 <mycpu>
8010326c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010326e:	b8 01 00 00 00       	mov    $0x1,%eax
80103273:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010327a:	e8 21 0c 00 00       	call   80103ea0 <scheduler>
8010327f:	90                   	nop

80103280 <mpenter>:
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103286:	e8 35 3b 00 00       	call   80106dc0 <switchkvm>
  seginit();
8010328b:	e8 a0 3a 00 00       	call   80106d30 <seginit>
  lapicinit();
80103290:	e8 9b f7 ff ff       	call   80102a30 <lapicinit>
  mpmain();
80103295:	e8 a6 ff ff ff       	call   80103240 <mpmain>
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <main>:
{
801032a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032a4:	83 e4 f0             	and    $0xfffffff0,%esp
801032a7:	ff 71 fc             	pushl  -0x4(%ecx)
801032aa:	55                   	push   %ebp
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	53                   	push   %ebx
801032ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032af:	83 ec 08             	sub    $0x8,%esp
801032b2:	68 00 00 40 80       	push   $0x80400000
801032b7:	68 08 75 11 80       	push   $0x80117508
801032bc:	e8 2f f5 ff ff       	call   801027f0 <kinit1>
  kvmalloc();      // kernel page table
801032c1:	e8 ca 3f 00 00       	call   80107290 <kvmalloc>
  mpinit();        // detect other processors
801032c6:	e8 75 01 00 00       	call   80103440 <mpinit>
  lapicinit();     // interrupt controller
801032cb:	e8 60 f7 ff ff       	call   80102a30 <lapicinit>
  seginit();       // segment descriptors
801032d0:	e8 5b 3a 00 00       	call   80106d30 <seginit>
  picinit();       // disable pic
801032d5:	e8 46 03 00 00       	call   80103620 <picinit>
  ioapicinit();    // another interrupt controller
801032da:	e8 41 f3 ff ff       	call   80102620 <ioapicinit>
  procfsinit();    // procfs file system
801032df:	e8 2c 57 00 00       	call   80108a10 <procfsinit>
  consoleinit();   // console hardware
801032e4:	e8 d7 d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801032e9:	e8 12 2d 00 00       	call   80106000 <uartinit>
  pinit();         // process table
801032ee:	e8 2d 08 00 00       	call   80103b20 <pinit>
  tvinit();        // trap vectors
801032f3:	e8 58 29 00 00       	call   80105c50 <tvinit>
  binit();         // buffer cache
801032f8:	e8 43 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032fd:	e8 ee da ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
80103302:	e8 69 f0 ff ff       	call   80102370 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103307:	83 c4 0c             	add    $0xc,%esp
8010330a:	68 8a 00 00 00       	push   $0x8a
8010330f:	68 8c c4 10 80       	push   $0x8010c48c
80103314:	68 00 70 00 80       	push   $0x80007000
80103319:	e8 82 17 00 00       	call   80104aa0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010331e:	69 05 60 4d 11 80 b0 	imul   $0xb0,0x80114d60,%eax
80103325:	00 00 00 
80103328:	83 c4 10             	add    $0x10,%esp
8010332b:	05 e0 47 11 80       	add    $0x801147e0,%eax
80103330:	3d e0 47 11 80       	cmp    $0x801147e0,%eax
80103335:	76 6c                	jbe    801033a3 <main+0x103>
80103337:	bb e0 47 11 80       	mov    $0x801147e0,%ebx
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80103340:	e8 fb 07 00 00       	call   80103b40 <mycpu>
80103345:	39 d8                	cmp    %ebx,%eax
80103347:	74 41                	je     8010338a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103349:	e8 72 f5 ff ff       	call   801028c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010334e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103353:	c7 05 f8 6f 00 80 80 	movl   $0x80103280,0x80006ff8
8010335a:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010335d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103364:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103367:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010336c:	0f b6 03             	movzbl (%ebx),%eax
8010336f:	83 ec 08             	sub    $0x8,%esp
80103372:	68 00 70 00 00       	push   $0x7000
80103377:	50                   	push   %eax
80103378:	e8 03 f8 ff ff       	call   80102b80 <lapicstartap>
8010337d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103380:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103386:	85 c0                	test   %eax,%eax
80103388:	74 f6                	je     80103380 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010338a:	69 05 60 4d 11 80 b0 	imul   $0xb0,0x80114d60,%eax
80103391:	00 00 00 
80103394:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010339a:	05 e0 47 11 80       	add    $0x801147e0,%eax
8010339f:	39 c3                	cmp    %eax,%ebx
801033a1:	72 9d                	jb     80103340 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	68 00 00 00 8e       	push   $0x8e000000
801033ab:	68 00 00 40 80       	push   $0x80400000
801033b0:	e8 ab f4 ff ff       	call   80102860 <kinit2>
  userinit();      // first user process
801033b5:	e8 56 08 00 00       	call   80103c10 <userinit>
  mpmain();        // finish this processor's setup
801033ba:	e8 81 fe ff ff       	call   80103240 <mpmain>
801033bf:	90                   	nop

801033c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801033cb:	53                   	push   %ebx
  e = addr+len;
801033cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801033cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033d2:	39 de                	cmp    %ebx,%esi
801033d4:	72 10                	jb     801033e6 <mpsearch1+0x26>
801033d6:	eb 50                	jmp    80103428 <mpsearch1+0x68>
801033d8:	90                   	nop
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033e0:	39 fb                	cmp    %edi,%ebx
801033e2:	89 fe                	mov    %edi,%esi
801033e4:	76 42                	jbe    80103428 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e6:	83 ec 04             	sub    $0x4,%esp
801033e9:	8d 7e 10             	lea    0x10(%esi),%edi
801033ec:	6a 04                	push   $0x4
801033ee:	68 58 8f 10 80       	push   $0x80108f58
801033f3:	56                   	push   %esi
801033f4:	e8 47 16 00 00       	call   80104a40 <memcmp>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	85 c0                	test   %eax,%eax
801033fe:	75 e0                	jne    801033e0 <mpsearch1+0x20>
80103400:	89 f1                	mov    %esi,%ecx
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103408:	0f b6 11             	movzbl (%ecx),%edx
8010340b:	83 c1 01             	add    $0x1,%ecx
8010340e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103410:	39 f9                	cmp    %edi,%ecx
80103412:	75 f4                	jne    80103408 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103414:	84 c0                	test   %al,%al
80103416:	75 c8                	jne    801033e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103418:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341b:	89 f0                	mov    %esi,%eax
8010341d:	5b                   	pop    %ebx
8010341e:	5e                   	pop    %esi
8010341f:	5f                   	pop    %edi
80103420:	5d                   	pop    %ebp
80103421:	c3                   	ret    
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010342b:	31 f6                	xor    %esi,%esi
}
8010342d:	89 f0                	mov    %esi,%eax
8010342f:	5b                   	pop    %ebx
80103430:	5e                   	pop    %esi
80103431:	5f                   	pop    %edi
80103432:	5d                   	pop    %ebp
80103433:	c3                   	ret    
80103434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010343a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103440 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103449:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103450:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103457:	c1 e0 08             	shl    $0x8,%eax
8010345a:	09 d0                	or     %edx,%eax
8010345c:	c1 e0 04             	shl    $0x4,%eax
8010345f:	85 c0                	test   %eax,%eax
80103461:	75 1b                	jne    8010347e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103463:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010346a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103471:	c1 e0 08             	shl    $0x8,%eax
80103474:	09 d0                	or     %edx,%eax
80103476:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103479:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010347e:	ba 00 04 00 00       	mov    $0x400,%edx
80103483:	e8 38 ff ff ff       	call   801033c0 <mpsearch1>
80103488:	85 c0                	test   %eax,%eax
8010348a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010348d:	0f 84 3d 01 00 00    	je     801035d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103496:	8b 58 04             	mov    0x4(%eax),%ebx
80103499:	85 db                	test   %ebx,%ebx
8010349b:	0f 84 4f 01 00 00    	je     801035f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034a7:	83 ec 04             	sub    $0x4,%esp
801034aa:	6a 04                	push   $0x4
801034ac:	68 75 8f 10 80       	push   $0x80108f75
801034b1:	56                   	push   %esi
801034b2:	e8 89 15 00 00       	call   80104a40 <memcmp>
801034b7:	83 c4 10             	add    $0x10,%esp
801034ba:	85 c0                	test   %eax,%eax
801034bc:	0f 85 2e 01 00 00    	jne    801035f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801034c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034c9:	3c 01                	cmp    $0x1,%al
801034cb:	0f 95 c2             	setne  %dl
801034ce:	3c 04                	cmp    $0x4,%al
801034d0:	0f 95 c0             	setne  %al
801034d3:	20 c2                	and    %al,%dl
801034d5:	0f 85 15 01 00 00    	jne    801035f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801034db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801034e2:	66 85 ff             	test   %di,%di
801034e5:	74 1a                	je     80103501 <mpinit+0xc1>
801034e7:	89 f0                	mov    %esi,%eax
801034e9:	01 f7                	add    %esi,%edi
  sum = 0;
801034eb:	31 d2                	xor    %edx,%edx
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034f0:	0f b6 08             	movzbl (%eax),%ecx
801034f3:	83 c0 01             	add    $0x1,%eax
801034f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034f8:	39 c7                	cmp    %eax,%edi
801034fa:	75 f4                	jne    801034f0 <mpinit+0xb0>
801034fc:	84 d2                	test   %dl,%dl
801034fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103501:	85 f6                	test   %esi,%esi
80103503:	0f 84 e7 00 00 00    	je     801035f0 <mpinit+0x1b0>
80103509:	84 d2                	test   %dl,%dl
8010350b:	0f 85 df 00 00 00    	jne    801035f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103511:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103517:	a3 dc 46 11 80       	mov    %eax,0x801146dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010351c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103523:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103529:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010352e:	01 d6                	add    %edx,%esi
80103530:	39 c6                	cmp    %eax,%esi
80103532:	76 23                	jbe    80103557 <mpinit+0x117>
    switch(*p){
80103534:	0f b6 10             	movzbl (%eax),%edx
80103537:	80 fa 04             	cmp    $0x4,%dl
8010353a:	0f 87 ca 00 00 00    	ja     8010360a <mpinit+0x1ca>
80103540:	ff 24 95 9c 8f 10 80 	jmp    *-0x7fef7064(,%edx,4)
80103547:	89 f6                	mov    %esi,%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103550:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103553:	39 c6                	cmp    %eax,%esi
80103555:	77 dd                	ja     80103534 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103557:	85 db                	test   %ebx,%ebx
80103559:	0f 84 9e 00 00 00    	je     801035fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010355f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103562:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103566:	74 15                	je     8010357d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103568:	b8 70 00 00 00       	mov    $0x70,%eax
8010356d:	ba 22 00 00 00       	mov    $0x22,%edx
80103572:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103573:	ba 23 00 00 00       	mov    $0x23,%edx
80103578:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103579:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010357c:	ee                   	out    %al,(%dx)
  }
}
8010357d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103580:	5b                   	pop    %ebx
80103581:	5e                   	pop    %esi
80103582:	5f                   	pop    %edi
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
80103585:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103588:	8b 0d 60 4d 11 80    	mov    0x80114d60,%ecx
8010358e:	83 f9 07             	cmp    $0x7,%ecx
80103591:	7f 19                	jg     801035ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103593:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103597:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010359d:	83 c1 01             	add    $0x1,%ecx
801035a0:	89 0d 60 4d 11 80    	mov    %ecx,0x80114d60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035a6:	88 97 e0 47 11 80    	mov    %dl,-0x7feeb820(%edi)
      p += sizeof(struct mpproc);
801035ac:	83 c0 14             	add    $0x14,%eax
      continue;
801035af:	e9 7c ff ff ff       	jmp    80103530 <mpinit+0xf0>
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801035b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801035bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801035bf:	88 15 c0 47 11 80    	mov    %dl,0x801147c0
      continue;
801035c5:	e9 66 ff ff ff       	jmp    80103530 <mpinit+0xf0>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801035d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801035d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035da:	e8 e1 fd ff ff       	call   801033c0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801035e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035e4:	0f 85 a9 fe ff ff    	jne    80103493 <mpinit+0x53>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	68 5d 8f 10 80       	push   $0x80108f5d
801035f8:	e8 93 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801035fd:	83 ec 0c             	sub    $0xc,%esp
80103600:	68 7c 8f 10 80       	push   $0x80108f7c
80103605:	e8 86 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010360a:	31 db                	xor    %ebx,%ebx
8010360c:	e9 26 ff ff ff       	jmp    80103537 <mpinit+0xf7>
80103611:	66 90                	xchg   %ax,%ax
80103613:	66 90                	xchg   %ax,%ax
80103615:	66 90                	xchg   %ax,%ax
80103617:	66 90                	xchg   %ax,%ax
80103619:	66 90                	xchg   %ax,%ax
8010361b:	66 90                	xchg   %ax,%ax
8010361d:	66 90                	xchg   %ax,%ax
8010361f:	90                   	nop

80103620 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103620:	55                   	push   %ebp
80103621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103626:	ba 21 00 00 00       	mov    $0x21,%edx
8010362b:	89 e5                	mov    %esp,%ebp
8010362d:	ee                   	out    %al,(%dx)
8010362e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103633:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103634:	5d                   	pop    %ebp
80103635:	c3                   	ret    
80103636:	66 90                	xchg   %ax,%ax
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010364c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010364f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103655:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010365b:	e8 90 d8 ff ff       	call   80100ef0 <filealloc>
80103660:	85 c0                	test   %eax,%eax
80103662:	89 03                	mov    %eax,(%ebx)
80103664:	74 22                	je     80103688 <pipealloc+0x48>
80103666:	e8 85 d8 ff ff       	call   80100ef0 <filealloc>
8010366b:	85 c0                	test   %eax,%eax
8010366d:	89 06                	mov    %eax,(%esi)
8010366f:	74 3f                	je     801036b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103671:	e8 4a f2 ff ff       	call   801028c0 <kalloc>
80103676:	85 c0                	test   %eax,%eax
80103678:	89 c7                	mov    %eax,%edi
8010367a:	75 54                	jne    801036d0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010367c:	8b 03                	mov    (%ebx),%eax
8010367e:	85 c0                	test   %eax,%eax
80103680:	75 34                	jne    801036b6 <pipealloc+0x76>
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103688:	8b 06                	mov    (%esi),%eax
8010368a:	85 c0                	test   %eax,%eax
8010368c:	74 0c                	je     8010369a <pipealloc+0x5a>
    fileclose(*f1);
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	50                   	push   %eax
80103692:	e8 19 d9 ff ff       	call   80100fb0 <fileclose>
80103697:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010369a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010369d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036a2:	5b                   	pop    %ebx
801036a3:	5e                   	pop    %esi
801036a4:	5f                   	pop    %edi
801036a5:	5d                   	pop    %ebp
801036a6:	c3                   	ret    
801036a7:	89 f6                	mov    %esi,%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801036b0:	8b 03                	mov    (%ebx),%eax
801036b2:	85 c0                	test   %eax,%eax
801036b4:	74 e4                	je     8010369a <pipealloc+0x5a>
    fileclose(*f0);
801036b6:	83 ec 0c             	sub    $0xc,%esp
801036b9:	50                   	push   %eax
801036ba:	e8 f1 d8 ff ff       	call   80100fb0 <fileclose>
  if(*f1)
801036bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801036c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 c6                	jne    8010368e <pipealloc+0x4e>
801036c8:	eb d0                	jmp    8010369a <pipealloc+0x5a>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801036d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801036d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036da:	00 00 00 
  p->writeopen = 1;
801036dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036e4:	00 00 00 
  p->nwrite = 0;
801036e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036ee:	00 00 00 
  p->nread = 0;
801036f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036f8:	00 00 00 
  initlock(&p->lock, "pipe");
801036fb:	68 b0 8f 10 80       	push   $0x80108fb0
80103700:	50                   	push   %eax
80103701:	e8 9a 10 00 00       	call   801047a0 <initlock>
  (*f0)->type = FD_PIPE;
80103706:	8b 03                	mov    (%ebx),%eax
  return 0;
80103708:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010370b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103711:	8b 03                	mov    (%ebx),%eax
80103713:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103717:	8b 03                	mov    (%ebx),%eax
80103719:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010371d:	8b 03                	mov    (%ebx),%eax
8010371f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103722:	8b 06                	mov    (%esi),%eax
80103724:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010372a:	8b 06                	mov    (%esi),%eax
8010372c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103730:	8b 06                	mov    (%esi),%eax
80103732:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103736:	8b 06                	mov    (%esi),%eax
80103738:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010373b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010373e:	31 c0                	xor    %eax,%eax
}
80103740:	5b                   	pop    %ebx
80103741:	5e                   	pop    %esi
80103742:	5f                   	pop    %edi
80103743:	5d                   	pop    %ebp
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
80103755:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103758:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	53                   	push   %ebx
8010375f:	e8 7c 11 00 00       	call   801048e0 <acquire>
  if(writable){
80103764:	83 c4 10             	add    $0x10,%esp
80103767:	85 f6                	test   %esi,%esi
80103769:	74 45                	je     801037b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010376b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103771:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103774:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010377b:	00 00 00 
    wakeup(&p->nread);
8010377e:	50                   	push   %eax
8010377f:	e8 ac 0b 00 00       	call   80104330 <wakeup>
80103784:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103787:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010378d:	85 d2                	test   %edx,%edx
8010378f:	75 0a                	jne    8010379b <pipeclose+0x4b>
80103791:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103797:	85 c0                	test   %eax,%eax
80103799:	74 35                	je     801037d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010379b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010379e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a1:	5b                   	pop    %ebx
801037a2:	5e                   	pop    %esi
801037a3:	5d                   	pop    %ebp
    release(&p->lock);
801037a4:	e9 f7 11 00 00       	jmp    801049a0 <release>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801037b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801037b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037c0:	00 00 00 
    wakeup(&p->nwrite);
801037c3:	50                   	push   %eax
801037c4:	e8 67 0b 00 00       	call   80104330 <wakeup>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	eb b9                	jmp    80103787 <pipeclose+0x37>
801037ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	53                   	push   %ebx
801037d4:	e8 c7 11 00 00       	call   801049a0 <release>
    kfree((char*)p);
801037d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037dc:	83 c4 10             	add    $0x10,%esp
}
801037df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e2:	5b                   	pop    %ebx
801037e3:	5e                   	pop    %esi
801037e4:	5d                   	pop    %ebp
    kfree((char*)p);
801037e5:	e9 26 ef ff ff       	jmp    80102710 <kfree>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
801037f6:	83 ec 28             	sub    $0x28,%esp
801037f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037fc:	53                   	push   %ebx
801037fd:	e8 de 10 00 00       	call   801048e0 <acquire>
  for(i = 0; i < n; i++){
80103802:	8b 45 10             	mov    0x10(%ebp),%eax
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	85 c0                	test   %eax,%eax
8010380a:	0f 8e c9 00 00 00    	jle    801038d9 <pipewrite+0xe9>
80103810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103813:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103819:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010381f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103822:	03 4d 10             	add    0x10(%ebp),%ecx
80103825:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103828:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010382e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103834:	39 d0                	cmp    %edx,%eax
80103836:	75 71                	jne    801038a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103838:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 4e                	je     80103890 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103842:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103848:	eb 3a                	jmp    80103884 <pipewrite+0x94>
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	57                   	push   %edi
80103854:	e8 d7 0a 00 00       	call   80104330 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103859:	5a                   	pop    %edx
8010385a:	59                   	pop    %ecx
8010385b:	53                   	push   %ebx
8010385c:	56                   	push   %esi
8010385d:	e8 1e 09 00 00       	call   80104180 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103862:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103868:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010386e:	83 c4 10             	add    $0x10,%esp
80103871:	05 00 02 00 00       	add    $0x200,%eax
80103876:	39 c2                	cmp    %eax,%edx
80103878:	75 36                	jne    801038b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010387a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103880:	85 c0                	test   %eax,%eax
80103882:	74 0c                	je     80103890 <pipewrite+0xa0>
80103884:	e8 57 03 00 00       	call   80103be0 <myproc>
80103889:	8b 40 24             	mov    0x24(%eax),%eax
8010388c:	85 c0                	test   %eax,%eax
8010388e:	74 c0                	je     80103850 <pipewrite+0x60>
        release(&p->lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	53                   	push   %ebx
80103894:	e8 07 11 00 00       	call   801049a0 <release>
        return -1;
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a4:	5b                   	pop    %ebx
801038a5:	5e                   	pop    %esi
801038a6:	5f                   	pop    %edi
801038a7:	5d                   	pop    %ebp
801038a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038a9:	89 c2                	mov    %eax,%edx
801038ab:	90                   	nop
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801038b3:	8d 42 01             	lea    0x1(%edx),%eax
801038b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801038c2:	83 c6 01             	add    $0x1,%esi
801038c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801038c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038d3:	0f 85 4f ff ff ff    	jne    80103828 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038df:	83 ec 0c             	sub    $0xc,%esp
801038e2:	50                   	push   %eax
801038e3:	e8 48 0a 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801038e8:	89 1c 24             	mov    %ebx,(%esp)
801038eb:	e8 b0 10 00 00       	call   801049a0 <release>
  return n;
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	8b 45 10             	mov    0x10(%ebp),%eax
801038f6:	eb a9                	jmp    801038a1 <pipewrite+0xb1>
801038f8:	90                   	nop
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103900 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 18             	sub    $0x18,%esp
80103909:	8b 75 08             	mov    0x8(%ebp),%esi
8010390c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010390f:	56                   	push   %esi
80103910:	e8 cb 0f 00 00       	call   801048e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010391e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103924:	75 6a                	jne    80103990 <piperead+0x90>
80103926:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010392c:	85 db                	test   %ebx,%ebx
8010392e:	0f 84 c4 00 00 00    	je     801039f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103934:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010393a:	eb 2d                	jmp    80103969 <piperead+0x69>
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	83 ec 08             	sub    $0x8,%esp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
80103945:	e8 36 08 00 00       	call   80104180 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010394a:	83 c4 10             	add    $0x10,%esp
8010394d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103953:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103959:	75 35                	jne    80103990 <piperead+0x90>
8010395b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103961:	85 d2                	test   %edx,%edx
80103963:	0f 84 8f 00 00 00    	je     801039f8 <piperead+0xf8>
    if(myproc()->killed){
80103969:	e8 72 02 00 00       	call   80103be0 <myproc>
8010396e:	8b 48 24             	mov    0x24(%eax),%ecx
80103971:	85 c9                	test   %ecx,%ecx
80103973:	74 cb                	je     80103940 <piperead+0x40>
      release(&p->lock);
80103975:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103978:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010397d:	56                   	push   %esi
8010397e:	e8 1d 10 00 00       	call   801049a0 <release>
      return -1;
80103983:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103989:	89 d8                	mov    %ebx,%eax
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5f                   	pop    %edi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103990:	8b 45 10             	mov    0x10(%ebp),%eax
80103993:	85 c0                	test   %eax,%eax
80103995:	7e 61                	jle    801039f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103997:	31 db                	xor    %ebx,%ebx
80103999:	eb 13                	jmp    801039ae <piperead+0xae>
8010399b:	90                   	nop
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039ac:	74 1f                	je     801039cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039ae:	8d 41 01             	lea    0x1(%ecx),%eax
801039b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801039b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801039bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801039c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039c5:	83 c3 01             	add    $0x1,%ebx
801039c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801039cb:	75 d3                	jne    801039a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801039cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801039d3:	83 ec 0c             	sub    $0xc,%esp
801039d6:	50                   	push   %eax
801039d7:	e8 54 09 00 00       	call   80104330 <wakeup>
  release(&p->lock);
801039dc:	89 34 24             	mov    %esi,(%esp)
801039df:	e8 bc 0f 00 00       	call   801049a0 <release>
  return i;
801039e4:	83 c4 10             	add    $0x10,%esp
}
801039e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ea:	89 d8                	mov    %ebx,%eax
801039ec:	5b                   	pop    %ebx
801039ed:	5e                   	pop    %esi
801039ee:	5f                   	pop    %edi
801039ef:	5d                   	pop    %ebp
801039f0:	c3                   	ret    
801039f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039f8:	31 db                	xor    %ebx,%ebx
801039fa:	eb d1                	jmp    801039cd <piperead+0xcd>
801039fc:	66 90                	xchg   %ax,%ax
801039fe:	66 90                	xchg   %ax,%ax

80103a00 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a04:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
{
80103a09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a0c:	68 80 4d 11 80       	push   $0x80114d80
80103a11:	e8 ca 0e 00 00       	call   801048e0 <acquire>
80103a16:	83 c4 10             	add    $0x10,%esp
80103a19:	eb 10                	jmp    80103a2b <allocproc+0x2b>
80103a1b:	90                   	nop
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a20:	83 c3 7c             	add    $0x7c,%ebx
80103a23:	81 fb b4 6c 11 80    	cmp    $0x80116cb4,%ebx
80103a29:	73 75                	jae    80103aa0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103a2b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a2e:	85 c0                	test   %eax,%eax
80103a30:	75 ee                	jne    80103a20 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a32:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103a37:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a3a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a41:	8d 50 01             	lea    0x1(%eax),%edx
80103a44:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103a47:	68 80 4d 11 80       	push   $0x80114d80
  p->pid = nextpid++;
80103a4c:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103a52:	e8 49 0f 00 00       	call   801049a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a57:	e8 64 ee ff ff       	call   801028c0 <kalloc>
80103a5c:	83 c4 10             	add    $0x10,%esp
80103a5f:	85 c0                	test   %eax,%eax
80103a61:	89 43 08             	mov    %eax,0x8(%ebx)
80103a64:	74 53                	je     80103ab9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a66:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a6c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a6f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a74:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a77:	c7 40 14 37 5c 10 80 	movl   $0x80105c37,0x14(%eax)
  p->context = (struct context*)sp;
80103a7e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a81:	6a 14                	push   $0x14
80103a83:	6a 00                	push   $0x0
80103a85:	50                   	push   %eax
80103a86:	e8 65 0f 00 00       	call   801049f0 <memset>
  p->context->eip = (uint)forkret;
80103a8b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a8e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a91:	c7 40 10 d0 3a 10 80 	movl   $0x80103ad0,0x10(%eax)
}
80103a98:	89 d8                	mov    %ebx,%eax
80103a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9d:	c9                   	leave  
80103a9e:	c3                   	ret    
80103a9f:	90                   	nop
  release(&ptable.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103aa3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103aa5:	68 80 4d 11 80       	push   $0x80114d80
80103aaa:	e8 f1 0e 00 00       	call   801049a0 <release>
}
80103aaf:	89 d8                	mov    %ebx,%eax
  return 0;
80103ab1:	83 c4 10             	add    $0x10,%esp
}
80103ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab7:	c9                   	leave  
80103ab8:	c3                   	ret    
    p->state = UNUSED;
80103ab9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ac0:	31 db                	xor    %ebx,%ebx
80103ac2:	eb d4                	jmp    80103a98 <allocproc+0x98>
80103ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ad0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ad6:	68 80 4d 11 80       	push   $0x80114d80
80103adb:	e8 c0 0e 00 00       	call   801049a0 <release>

  if (first) {
80103ae0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80103ae5:	83 c4 10             	add    $0x10,%esp
80103ae8:	85 c0                	test   %eax,%eax
80103aea:	75 04                	jne    80103af0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103aec:	c9                   	leave  
80103aed:	c3                   	ret    
80103aee:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103af0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103af3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
80103afa:	00 00 00 
    iinit(ROOTDEV);
80103afd:	6a 01                	push   $0x1
80103aff:	e8 5c dc ff ff       	call   80101760 <iinit>
    initlog(ROOTDEV);
80103b04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b0b:	e8 f0 f3 ff ff       	call   80102f00 <initlog>
80103b10:	83 c4 10             	add    $0x10,%esp
}
80103b13:	c9                   	leave  
80103b14:	c3                   	ret    
80103b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b20 <pinit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b26:	68 b5 8f 10 80       	push   $0x80108fb5
80103b2b:	68 80 4d 11 80       	push   $0x80114d80
80103b30:	e8 6b 0c 00 00       	call   801047a0 <initlock>
}
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	c9                   	leave  
80103b39:	c3                   	ret    
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b40 <mycpu>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b45:	9c                   	pushf  
80103b46:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b47:	f6 c4 02             	test   $0x2,%ah
80103b4a:	75 5e                	jne    80103baa <mycpu+0x6a>
  apicid = lapicid();
80103b4c:	e8 df ef ff ff       	call   80102b30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b51:	8b 35 60 4d 11 80    	mov    0x80114d60,%esi
80103b57:	85 f6                	test   %esi,%esi
80103b59:	7e 42                	jle    80103b9d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b5b:	0f b6 15 e0 47 11 80 	movzbl 0x801147e0,%edx
80103b62:	39 d0                	cmp    %edx,%eax
80103b64:	74 30                	je     80103b96 <mycpu+0x56>
80103b66:	b9 90 48 11 80       	mov    $0x80114890,%ecx
  for (i = 0; i < ncpu; ++i) {
80103b6b:	31 d2                	xor    %edx,%edx
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
80103b70:	83 c2 01             	add    $0x1,%edx
80103b73:	39 f2                	cmp    %esi,%edx
80103b75:	74 26                	je     80103b9d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b77:	0f b6 19             	movzbl (%ecx),%ebx
80103b7a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b80:	39 c3                	cmp    %eax,%ebx
80103b82:	75 ec                	jne    80103b70 <mycpu+0x30>
80103b84:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b8a:	05 e0 47 11 80       	add    $0x801147e0,%eax
}
80103b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b92:	5b                   	pop    %ebx
80103b93:	5e                   	pop    %esi
80103b94:	5d                   	pop    %ebp
80103b95:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b96:	b8 e0 47 11 80       	mov    $0x801147e0,%eax
      return &cpus[i];
80103b9b:	eb f2                	jmp    80103b8f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 bc 8f 10 80       	push   $0x80108fbc
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 98 90 10 80       	push   $0x80109098
80103bb2:	e8 d9 c7 ff ff       	call   80100390 <panic>
80103bb7:	89 f6                	mov    %esi,%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <cpuid>:
cpuid() {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103bc6:	e8 75 ff ff ff       	call   80103b40 <mycpu>
80103bcb:	2d e0 47 11 80       	sub    $0x801147e0,%eax
}
80103bd0:	c9                   	leave  
  return mycpu()-cpus;
80103bd1:	c1 f8 04             	sar    $0x4,%eax
80103bd4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bda:	c3                   	ret    
80103bdb:	90                   	nop
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103be0 <myproc>:
myproc(void) {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	53                   	push   %ebx
80103be4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103be7:	e8 24 0c 00 00       	call   80104810 <pushcli>
  c = mycpu();
80103bec:	e8 4f ff ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103bf1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf7:	e8 54 0c 00 00       	call   80104850 <popcli>
}
80103bfc:	83 c4 04             	add    $0x4,%esp
80103bff:	89 d8                	mov    %ebx,%eax
80103c01:	5b                   	pop    %ebx
80103c02:	5d                   	pop    %ebp
80103c03:	c3                   	ret    
80103c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c10 <userinit>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	53                   	push   %ebx
80103c14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c17:	e8 e4 fd ff ff       	call   80103a00 <allocproc>
80103c1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c1e:	a3 b8 c5 10 80       	mov    %eax,0x8010c5b8
  if((p->pgdir = setupkvm()) == 0)
80103c23:	e8 e8 35 00 00       	call   80107210 <setupkvm>
80103c28:	85 c0                	test   %eax,%eax
80103c2a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c2d:	0f 84 bd 00 00 00    	je     80103cf0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c33:	83 ec 04             	sub    $0x4,%esp
80103c36:	68 2c 00 00 00       	push   $0x2c
80103c3b:	68 60 c4 10 80       	push   $0x8010c460
80103c40:	50                   	push   %eax
80103c41:	e8 aa 32 00 00       	call   80106ef0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c46:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c49:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c4f:	6a 4c                	push   $0x4c
80103c51:	6a 00                	push   $0x0
80103c53:	ff 73 18             	pushl  0x18(%ebx)
80103c56:	e8 95 0d 00 00       	call   801049f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c5b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c5e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c63:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c68:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c6b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c72:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c76:	8b 43 18             	mov    0x18(%ebx),%eax
80103c79:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c7d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c81:	8b 43 18             	mov    0x18(%ebx),%eax
80103c84:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c88:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c8c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c8f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c96:	8b 43 18             	mov    0x18(%ebx),%eax
80103c99:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ca0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103caa:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cad:	6a 10                	push   $0x10
80103caf:	68 e5 8f 10 80       	push   $0x80108fe5
80103cb4:	50                   	push   %eax
80103cb5:	e8 16 0f 00 00       	call   80104bd0 <safestrcpy>
  p->cwd = namei("/");
80103cba:	c7 04 24 cf 96 10 80 	movl   $0x801096cf,(%esp)
80103cc1:	e8 8a e5 ff ff       	call   80102250 <namei>
80103cc6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103cc9:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103cd0:	e8 0b 0c 00 00       	call   801048e0 <acquire>
  p->state = RUNNABLE;
80103cd5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cdc:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103ce3:	e8 b8 0c 00 00       	call   801049a0 <release>
}
80103ce8:	83 c4 10             	add    $0x10,%esp
80103ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cee:	c9                   	leave  
80103cef:	c3                   	ret    
    panic("userinit: out of memory?");
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	68 cc 8f 10 80       	push   $0x80108fcc
80103cf8:	e8 93 c6 ff ff       	call   80100390 <panic>
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi

80103d00 <growproc>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d08:	e8 03 0b 00 00       	call   80104810 <pushcli>
  c = mycpu();
80103d0d:	e8 2e fe ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103d12:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d18:	e8 33 0b 00 00       	call   80104850 <popcli>
  if(n > 0){
80103d1d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d20:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d22:	7f 1c                	jg     80103d40 <growproc+0x40>
  } else if(n < 0){
80103d24:	75 3a                	jne    80103d60 <growproc+0x60>
  switchuvm(curproc);
80103d26:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d29:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d2b:	53                   	push   %ebx
80103d2c:	e8 af 30 00 00       	call   80106de0 <switchuvm>
  return 0;
80103d31:	83 c4 10             	add    $0x10,%esp
80103d34:	31 c0                	xor    %eax,%eax
}
80103d36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d39:	5b                   	pop    %ebx
80103d3a:	5e                   	pop    %esi
80103d3b:	5d                   	pop    %ebp
80103d3c:	c3                   	ret    
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d40:	83 ec 04             	sub    $0x4,%esp
80103d43:	01 c6                	add    %eax,%esi
80103d45:	56                   	push   %esi
80103d46:	50                   	push   %eax
80103d47:	ff 73 04             	pushl  0x4(%ebx)
80103d4a:	e8 e1 32 00 00       	call   80107030 <allocuvm>
80103d4f:	83 c4 10             	add    $0x10,%esp
80103d52:	85 c0                	test   %eax,%eax
80103d54:	75 d0                	jne    80103d26 <growproc+0x26>
      return -1;
80103d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d5b:	eb d9                	jmp    80103d36 <growproc+0x36>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d60:	83 ec 04             	sub    $0x4,%esp
80103d63:	01 c6                	add    %eax,%esi
80103d65:	56                   	push   %esi
80103d66:	50                   	push   %eax
80103d67:	ff 73 04             	pushl  0x4(%ebx)
80103d6a:	e8 f1 33 00 00       	call   80107160 <deallocuvm>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 b0                	jne    80103d26 <growproc+0x26>
80103d76:	eb de                	jmp    80103d56 <growproc+0x56>
80103d78:	90                   	nop
80103d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d80 <fork>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d89:	e8 82 0a 00 00       	call   80104810 <pushcli>
  c = mycpu();
80103d8e:	e8 ad fd ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103d93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d99:	e8 b2 0a 00 00       	call   80104850 <popcli>
  if((np = allocproc()) == 0){
80103d9e:	e8 5d fc ff ff       	call   80103a00 <allocproc>
80103da3:	85 c0                	test   %eax,%eax
80103da5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103da8:	0f 84 b7 00 00 00    	je     80103e65 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dae:	83 ec 08             	sub    $0x8,%esp
80103db1:	ff 33                	pushl  (%ebx)
80103db3:	ff 73 04             	pushl  0x4(%ebx)
80103db6:	89 c7                	mov    %eax,%edi
80103db8:	e8 23 35 00 00       	call   801072e0 <copyuvm>
80103dbd:	83 c4 10             	add    $0x10,%esp
80103dc0:	85 c0                	test   %eax,%eax
80103dc2:	89 47 04             	mov    %eax,0x4(%edi)
80103dc5:	0f 84 a1 00 00 00    	je     80103e6c <fork+0xec>
  np->sz = curproc->sz;
80103dcb:	8b 03                	mov    (%ebx),%eax
80103dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103dd0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103dd2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103dd5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103dd7:	8b 79 18             	mov    0x18(%ecx),%edi
80103dda:	8b 73 18             	mov    0x18(%ebx),%esi
80103ddd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103de2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103de4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103de6:	8b 40 18             	mov    0x18(%eax),%eax
80103de9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103df0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103df4:	85 c0                	test   %eax,%eax
80103df6:	74 13                	je     80103e0b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103df8:	83 ec 0c             	sub    $0xc,%esp
80103dfb:	50                   	push   %eax
80103dfc:	e8 5f d1 ff ff       	call   80100f60 <filedup>
80103e01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e04:	83 c4 10             	add    $0x10,%esp
80103e07:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e0b:	83 c6 01             	add    $0x1,%esi
80103e0e:	83 fe 10             	cmp    $0x10,%esi
80103e11:	75 dd                	jne    80103df0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e13:	83 ec 0c             	sub    $0xc,%esp
80103e16:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e19:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e1c:	e8 0f db ff ff       	call   80101930 <idup>
80103e21:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e24:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e27:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e2a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e2d:	6a 10                	push   $0x10
80103e2f:	53                   	push   %ebx
80103e30:	50                   	push   %eax
80103e31:	e8 9a 0d 00 00       	call   80104bd0 <safestrcpy>
  pid = np->pid;
80103e36:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e39:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103e40:	e8 9b 0a 00 00       	call   801048e0 <acquire>
  np->state = RUNNABLE;
80103e45:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e4c:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80103e53:	e8 48 0b 00 00       	call   801049a0 <release>
  return pid;
80103e58:	83 c4 10             	add    $0x10,%esp
}
80103e5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e5e:	89 d8                	mov    %ebx,%eax
80103e60:	5b                   	pop    %ebx
80103e61:	5e                   	pop    %esi
80103e62:	5f                   	pop    %edi
80103e63:	5d                   	pop    %ebp
80103e64:	c3                   	ret    
    return -1;
80103e65:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e6a:	eb ef                	jmp    80103e5b <fork+0xdb>
    kfree(np->kstack);
80103e6c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e6f:	83 ec 0c             	sub    $0xc,%esp
80103e72:	ff 73 08             	pushl  0x8(%ebx)
80103e75:	e8 96 e8 ff ff       	call   80102710 <kfree>
    np->kstack = 0;
80103e7a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103e81:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e88:	83 c4 10             	add    $0x10,%esp
80103e8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e90:	eb c9                	jmp    80103e5b <fork+0xdb>
80103e92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <scheduler>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	57                   	push   %edi
80103ea4:	56                   	push   %esi
80103ea5:	53                   	push   %ebx
80103ea6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ea9:	e8 92 fc ff ff       	call   80103b40 <mycpu>
80103eae:	8d 78 04             	lea    0x4(%eax),%edi
80103eb1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103eb3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103eba:	00 00 00 
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ec0:	fb                   	sti    
    acquire(&ptable.lock);
80103ec1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ec4:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
    acquire(&ptable.lock);
80103ec9:	68 80 4d 11 80       	push   $0x80114d80
80103ece:	e8 0d 0a 00 00       	call   801048e0 <acquire>
80103ed3:	83 c4 10             	add    $0x10,%esp
80103ed6:	8d 76 00             	lea    0x0(%esi),%esi
80103ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103ee0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103ee4:	75 33                	jne    80103f19 <scheduler+0x79>
      switchuvm(p);
80103ee6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103ee9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103eef:	53                   	push   %ebx
80103ef0:	e8 eb 2e 00 00       	call   80106de0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ef5:	58                   	pop    %eax
80103ef6:	5a                   	pop    %edx
80103ef7:	ff 73 1c             	pushl  0x1c(%ebx)
80103efa:	57                   	push   %edi
      p->state = RUNNING;
80103efb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f02:	e8 24 0d 00 00       	call   80104c2b <swtch>
      switchkvm();
80103f07:	e8 b4 2e 00 00       	call   80106dc0 <switchkvm>
      c->proc = 0;
80103f0c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f13:	00 00 00 
80103f16:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f19:	83 c3 7c             	add    $0x7c,%ebx
80103f1c:	81 fb b4 6c 11 80    	cmp    $0x80116cb4,%ebx
80103f22:	72 bc                	jb     80103ee0 <scheduler+0x40>
    release(&ptable.lock);
80103f24:	83 ec 0c             	sub    $0xc,%esp
80103f27:	68 80 4d 11 80       	push   $0x80114d80
80103f2c:	e8 6f 0a 00 00       	call   801049a0 <release>
    sti();
80103f31:	83 c4 10             	add    $0x10,%esp
80103f34:	eb 8a                	jmp    80103ec0 <scheduler+0x20>
80103f36:	8d 76 00             	lea    0x0(%esi),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f40 <sched>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
  pushcli();
80103f45:	e8 c6 08 00 00       	call   80104810 <pushcli>
  c = mycpu();
80103f4a:	e8 f1 fb ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103f4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f55:	e8 f6 08 00 00       	call   80104850 <popcli>
  if(!holding(&ptable.lock))
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 80 4d 11 80       	push   $0x80114d80
80103f62:	e8 49 09 00 00       	call   801048b0 <holding>
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	74 4f                	je     80103fbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f6e:	e8 cd fb ff ff       	call   80103b40 <mycpu>
80103f73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f7a:	75 68                	jne    80103fe4 <sched+0xa4>
  if(p->state == RUNNING)
80103f7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f80:	74 55                	je     80103fd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f82:	9c                   	pushf  
80103f83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f84:	f6 c4 02             	test   $0x2,%ah
80103f87:	75 41                	jne    80103fca <sched+0x8a>
  intena = mycpu()->intena;
80103f89:	e8 b2 fb ff ff       	call   80103b40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f97:	e8 a4 fb ff ff       	call   80103b40 <mycpu>
80103f9c:	83 ec 08             	sub    $0x8,%esp
80103f9f:	ff 70 04             	pushl  0x4(%eax)
80103fa2:	53                   	push   %ebx
80103fa3:	e8 83 0c 00 00       	call   80104c2b <swtch>
  mycpu()->intena = intena;
80103fa8:	e8 93 fb ff ff       	call   80103b40 <mycpu>
}
80103fad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fb9:	5b                   	pop    %ebx
80103fba:	5e                   	pop    %esi
80103fbb:	5d                   	pop    %ebp
80103fbc:	c3                   	ret    
    panic("sched ptable.lock");
80103fbd:	83 ec 0c             	sub    $0xc,%esp
80103fc0:	68 ee 8f 10 80       	push   $0x80108fee
80103fc5:	e8 c6 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103fca:	83 ec 0c             	sub    $0xc,%esp
80103fcd:	68 1a 90 10 80       	push   $0x8010901a
80103fd2:	e8 b9 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 0c 90 10 80       	push   $0x8010900c
80103fdf:	e8 ac c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103fe4:	83 ec 0c             	sub    $0xc,%esp
80103fe7:	68 00 90 10 80       	push   $0x80109000
80103fec:	e8 9f c3 ff ff       	call   80100390 <panic>
80103ff1:	eb 0d                	jmp    80104000 <exit>
80103ff3:	90                   	nop
80103ff4:	90                   	nop
80103ff5:	90                   	nop
80103ff6:	90                   	nop
80103ff7:	90                   	nop
80103ff8:	90                   	nop
80103ff9:	90                   	nop
80103ffa:	90                   	nop
80103ffb:	90                   	nop
80103ffc:	90                   	nop
80103ffd:	90                   	nop
80103ffe:	90                   	nop
80103fff:	90                   	nop

80104000 <exit>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104009:	e8 02 08 00 00       	call   80104810 <pushcli>
  c = mycpu();
8010400e:	e8 2d fb ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104013:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104019:	e8 32 08 00 00       	call   80104850 <popcli>
  if(curproc == initproc)
8010401e:	39 35 b8 c5 10 80    	cmp    %esi,0x8010c5b8
80104024:	8d 5e 28             	lea    0x28(%esi),%ebx
80104027:	8d 7e 68             	lea    0x68(%esi),%edi
8010402a:	0f 84 e7 00 00 00    	je     80104117 <exit+0x117>
    if(curproc->ofile[fd]){
80104030:	8b 03                	mov    (%ebx),%eax
80104032:	85 c0                	test   %eax,%eax
80104034:	74 12                	je     80104048 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	50                   	push   %eax
8010403a:	e8 71 cf ff ff       	call   80100fb0 <fileclose>
      curproc->ofile[fd] = 0;
8010403f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104045:	83 c4 10             	add    $0x10,%esp
80104048:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010404b:	39 fb                	cmp    %edi,%ebx
8010404d:	75 e1                	jne    80104030 <exit+0x30>
  begin_op();
8010404f:	e8 4c ef ff ff       	call   80102fa0 <begin_op>
  iput(curproc->cwd);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	ff 76 68             	pushl  0x68(%esi)
8010405a:	e8 31 da ff ff       	call   80101a90 <iput>
  end_op();
8010405f:	e8 ac ef ff ff       	call   80103010 <end_op>
  curproc->cwd = 0;
80104064:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010406b:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104072:	e8 69 08 00 00       	call   801048e0 <acquire>
  wakeup1(curproc->parent);
80104077:	8b 56 14             	mov    0x14(%esi),%edx
8010407a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407d:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
80104082:	eb 0e                	jmp    80104092 <exit+0x92>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104088:	83 c0 7c             	add    $0x7c,%eax
8010408b:	3d b4 6c 11 80       	cmp    $0x80116cb4,%eax
80104090:	73 1c                	jae    801040ae <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104092:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104096:	75 f0                	jne    80104088 <exit+0x88>
80104098:	3b 50 20             	cmp    0x20(%eax),%edx
8010409b:	75 eb                	jne    80104088 <exit+0x88>
      p->state = RUNNABLE;
8010409d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a4:	83 c0 7c             	add    $0x7c,%eax
801040a7:	3d b4 6c 11 80       	cmp    $0x80116cb4,%eax
801040ac:	72 e4                	jb     80104092 <exit+0x92>
      p->parent = initproc;
801040ae:	8b 0d b8 c5 10 80    	mov    0x8010c5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b4:	ba b4 4d 11 80       	mov    $0x80114db4,%edx
801040b9:	eb 10                	jmp    801040cb <exit+0xcb>
801040bb:	90                   	nop
801040bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040c0:	83 c2 7c             	add    $0x7c,%edx
801040c3:	81 fa b4 6c 11 80    	cmp    $0x80116cb4,%edx
801040c9:	73 33                	jae    801040fe <exit+0xfe>
    if(p->parent == curproc){
801040cb:	39 72 14             	cmp    %esi,0x14(%edx)
801040ce:	75 f0                	jne    801040c0 <exit+0xc0>
      if(p->state == ZOMBIE)
801040d0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040d4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040d7:	75 e7                	jne    801040c0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040d9:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
801040de:	eb 0a                	jmp    801040ea <exit+0xea>
801040e0:	83 c0 7c             	add    $0x7c,%eax
801040e3:	3d b4 6c 11 80       	cmp    $0x80116cb4,%eax
801040e8:	73 d6                	jae    801040c0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801040ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040ee:	75 f0                	jne    801040e0 <exit+0xe0>
801040f0:	3b 48 20             	cmp    0x20(%eax),%ecx
801040f3:	75 eb                	jne    801040e0 <exit+0xe0>
      p->state = RUNNABLE;
801040f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040fc:	eb e2                	jmp    801040e0 <exit+0xe0>
  curproc->state = ZOMBIE;
801040fe:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104105:	e8 36 fe ff ff       	call   80103f40 <sched>
  panic("zombie exit");
8010410a:	83 ec 0c             	sub    $0xc,%esp
8010410d:	68 3b 90 10 80       	push   $0x8010903b
80104112:	e8 79 c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104117:	83 ec 0c             	sub    $0xc,%esp
8010411a:	68 2e 90 10 80       	push   $0x8010902e
8010411f:	e8 6c c2 ff ff       	call   80100390 <panic>
80104124:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010412a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104130 <yield>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 80 4d 11 80       	push   $0x80114d80
8010413c:	e8 9f 07 00 00       	call   801048e0 <acquire>
  pushcli();
80104141:	e8 ca 06 00 00       	call   80104810 <pushcli>
  c = mycpu();
80104146:	e8 f5 f9 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 fa 06 00 00       	call   80104850 <popcli>
  myproc()->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 de fd ff ff       	call   80103f40 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
80104169:	e8 32 08 00 00       	call   801049a0 <release>
}
8010416e:	83 c4 10             	add    $0x10,%esp
80104171:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104174:	c9                   	leave  
80104175:	c3                   	ret    
80104176:	8d 76 00             	lea    0x0(%esi),%esi
80104179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104180 <sleep>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010418f:	e8 7c 06 00 00       	call   80104810 <pushcli>
  c = mycpu();
80104194:	e8 a7 f9 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 ac 06 00 00       	call   80104850 <popcli>
  if(p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	0f 84 87 00 00 00    	je     80104233 <sleep+0xb3>
  if(lk == 0)
801041ac:	85 f6                	test   %esi,%esi
801041ae:	74 76                	je     80104226 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041b0:	81 fe 80 4d 11 80    	cmp    $0x80114d80,%esi
801041b6:	74 50                	je     80104208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 80 4d 11 80       	push   $0x80114d80
801041c0:	e8 1b 07 00 00       	call   801048e0 <acquire>
    release(lk);
801041c5:	89 34 24             	mov    %esi,(%esp)
801041c8:	e8 d3 07 00 00       	call   801049a0 <release>
  p->chan = chan;
801041cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041d7:	e8 64 fd ff ff       	call   80103f40 <sched>
  p->chan = 0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041e3:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
801041ea:	e8 b1 07 00 00       	call   801049a0 <release>
    acquire(lk);
801041ef:	89 75 08             	mov    %esi,0x8(%ebp)
801041f2:	83 c4 10             	add    $0x10,%esp
}
801041f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5e                   	pop    %esi
801041fa:	5f                   	pop    %edi
801041fb:	5d                   	pop    %ebp
    acquire(lk);
801041fc:	e9 df 06 00 00       	jmp    801048e0 <acquire>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010420b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104212:	e8 29 fd ff ff       	call   80103f40 <sched>
  p->chan = 0;
80104217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010421e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5f                   	pop    %edi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
    panic("sleep without lk");
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	68 4d 90 10 80       	push   $0x8010904d
8010422e:	e8 5d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104233:	83 ec 0c             	sub    $0xc,%esp
80104236:	68 47 90 10 80       	push   $0x80109047
8010423b:	e8 50 c1 ff ff       	call   80100390 <panic>

80104240 <wait>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
  pushcli();
80104245:	e8 c6 05 00 00       	call   80104810 <pushcli>
  c = mycpu();
8010424a:	e8 f1 f8 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
8010424f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104255:	e8 f6 05 00 00       	call   80104850 <popcli>
  acquire(&ptable.lock);
8010425a:	83 ec 0c             	sub    $0xc,%esp
8010425d:	68 80 4d 11 80       	push   $0x80114d80
80104262:	e8 79 06 00 00       	call   801048e0 <acquire>
80104267:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010426a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010426c:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
80104271:	eb 10                	jmp    80104283 <wait+0x43>
80104273:	90                   	nop
80104274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104278:	83 c3 7c             	add    $0x7c,%ebx
8010427b:	81 fb b4 6c 11 80    	cmp    $0x80116cb4,%ebx
80104281:	73 1b                	jae    8010429e <wait+0x5e>
      if(p->parent != curproc)
80104283:	39 73 14             	cmp    %esi,0x14(%ebx)
80104286:	75 f0                	jne    80104278 <wait+0x38>
      if(p->state == ZOMBIE){
80104288:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010428c:	74 32                	je     801042c0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104291:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104296:	81 fb b4 6c 11 80    	cmp    $0x80116cb4,%ebx
8010429c:	72 e5                	jb     80104283 <wait+0x43>
    if(!havekids || curproc->killed){
8010429e:	85 c0                	test   %eax,%eax
801042a0:	74 74                	je     80104316 <wait+0xd6>
801042a2:	8b 46 24             	mov    0x24(%esi),%eax
801042a5:	85 c0                	test   %eax,%eax
801042a7:	75 6d                	jne    80104316 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042a9:	83 ec 08             	sub    $0x8,%esp
801042ac:	68 80 4d 11 80       	push   $0x80114d80
801042b1:	56                   	push   %esi
801042b2:	e8 c9 fe ff ff       	call   80104180 <sleep>
    havekids = 0;
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	eb ae                	jmp    8010426a <wait+0x2a>
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801042c0:	83 ec 0c             	sub    $0xc,%esp
801042c3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801042c6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042c9:	e8 42 e4 ff ff       	call   80102710 <kfree>
        freevm(p->pgdir);
801042ce:	5a                   	pop    %edx
801042cf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042d9:	e8 b2 2e 00 00       	call   80107190 <freevm>
        release(&ptable.lock);
801042de:	c7 04 24 80 4d 11 80 	movl   $0x80114d80,(%esp)
        p->pid = 0;
801042e5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042ec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042f3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042f7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104305:	e8 96 06 00 00       	call   801049a0 <release>
        return pid;
8010430a:	83 c4 10             	add    $0x10,%esp
}
8010430d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104310:	89 f0                	mov    %esi,%eax
80104312:	5b                   	pop    %ebx
80104313:	5e                   	pop    %esi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
      release(&ptable.lock);
80104316:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104319:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010431e:	68 80 4d 11 80       	push   $0x80114d80
80104323:	e8 78 06 00 00       	call   801049a0 <release>
      return -1;
80104328:	83 c4 10             	add    $0x10,%esp
8010432b:	eb e0                	jmp    8010430d <wait+0xcd>
8010432d:	8d 76 00             	lea    0x0(%esi),%esi

80104330 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 10             	sub    $0x10,%esp
80104337:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010433a:	68 80 4d 11 80       	push   $0x80114d80
8010433f:	e8 9c 05 00 00       	call   801048e0 <acquire>
80104344:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104347:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
8010434c:	eb 0c                	jmp    8010435a <wakeup+0x2a>
8010434e:	66 90                	xchg   %ax,%ax
80104350:	83 c0 7c             	add    $0x7c,%eax
80104353:	3d b4 6c 11 80       	cmp    $0x80116cb4,%eax
80104358:	73 1c                	jae    80104376 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010435a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010435e:	75 f0                	jne    80104350 <wakeup+0x20>
80104360:	3b 58 20             	cmp    0x20(%eax),%ebx
80104363:	75 eb                	jne    80104350 <wakeup+0x20>
      p->state = RUNNABLE;
80104365:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010436c:	83 c0 7c             	add    $0x7c,%eax
8010436f:	3d b4 6c 11 80       	cmp    $0x80116cb4,%eax
80104374:	72 e4                	jb     8010435a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104376:	c7 45 08 80 4d 11 80 	movl   $0x80114d80,0x8(%ebp)
}
8010437d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104380:	c9                   	leave  
  release(&ptable.lock);
80104381:	e9 1a 06 00 00       	jmp    801049a0 <release>
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104390 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	53                   	push   %ebx
80104394:	83 ec 10             	sub    $0x10,%esp
80104397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010439a:	68 80 4d 11 80       	push   $0x80114d80
8010439f:	e8 3c 05 00 00       	call   801048e0 <acquire>
801043a4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a7:	b8 b4 4d 11 80       	mov    $0x80114db4,%eax
801043ac:	eb 0c                	jmp    801043ba <kill+0x2a>
801043ae:	66 90                	xchg   %ax,%ax
801043b0:	83 c0 7c             	add    $0x7c,%eax
801043b3:	3d b4 6c 11 80       	cmp    $0x80116cb4,%eax
801043b8:	73 36                	jae    801043f0 <kill+0x60>
    if(p->pid == pid){
801043ba:	39 58 10             	cmp    %ebx,0x10(%eax)
801043bd:	75 f1                	jne    801043b0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043bf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043c3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ca:	75 07                	jne    801043d3 <kill+0x43>
        p->state = RUNNABLE;
801043cc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043d3:	83 ec 0c             	sub    $0xc,%esp
801043d6:	68 80 4d 11 80       	push   $0x80114d80
801043db:	e8 c0 05 00 00       	call   801049a0 <release>
      return 0;
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801043e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043e8:	c9                   	leave  
801043e9:	c3                   	ret    
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 80 4d 11 80       	push   $0x80114d80
801043f8:	e8 a3 05 00 00       	call   801049a0 <release>
  return -1;
801043fd:	83 c4 10             	add    $0x10,%esp
80104400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104408:	c9                   	leave  
80104409:	c3                   	ret    
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	57                   	push   %edi
80104414:	56                   	push   %esi
80104415:	53                   	push   %ebx
80104416:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104419:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
{
8010441e:	83 ec 3c             	sub    $0x3c,%esp
80104421:	eb 24                	jmp    80104447 <procdump+0x37>
80104423:	90                   	nop
80104424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104428:	83 ec 0c             	sub    $0xc,%esp
8010442b:	68 ea 95 10 80       	push   $0x801095ea
80104430:	e8 2b c2 ff ff       	call   80100660 <cprintf>
80104435:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104438:	83 c3 7c             	add    $0x7c,%ebx
8010443b:	81 fb b4 6c 11 80    	cmp    $0x80116cb4,%ebx
80104441:	0f 83 81 00 00 00    	jae    801044c8 <procdump+0xb8>
    if(p->state == UNUSED)
80104447:	8b 43 0c             	mov    0xc(%ebx),%eax
8010444a:	85 c0                	test   %eax,%eax
8010444c:	74 ea                	je     80104438 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010444e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104451:	ba 5e 90 10 80       	mov    $0x8010905e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104456:	77 11                	ja     80104469 <procdump+0x59>
80104458:	8b 14 85 c0 90 10 80 	mov    -0x7fef6f40(,%eax,4),%edx
      state = "???";
8010445f:	b8 5e 90 10 80       	mov    $0x8010905e,%eax
80104464:	85 d2                	test   %edx,%edx
80104466:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104469:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010446c:	50                   	push   %eax
8010446d:	52                   	push   %edx
8010446e:	ff 73 10             	pushl  0x10(%ebx)
80104471:	68 62 90 10 80       	push   $0x80109062
80104476:	e8 e5 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010447b:	83 c4 10             	add    $0x10,%esp
8010447e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104482:	75 a4                	jne    80104428 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104484:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104487:	83 ec 08             	sub    $0x8,%esp
8010448a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010448d:	50                   	push   %eax
8010448e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104491:	8b 40 0c             	mov    0xc(%eax),%eax
80104494:	83 c0 08             	add    $0x8,%eax
80104497:	50                   	push   %eax
80104498:	e8 23 03 00 00       	call   801047c0 <getcallerpcs>
8010449d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044a0:	8b 17                	mov    (%edi),%edx
801044a2:	85 d2                	test   %edx,%edx
801044a4:	74 82                	je     80104428 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044a6:	83 ec 08             	sub    $0x8,%esp
801044a9:	83 c7 04             	add    $0x4,%edi
801044ac:	52                   	push   %edx
801044ad:	68 81 8a 10 80       	push   $0x80108a81
801044b2:	e8 a9 c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	39 fe                	cmp    %edi,%esi
801044bc:	75 e2                	jne    801044a0 <procdump+0x90>
801044be:	e9 65 ff ff ff       	jmp    80104428 <procdump+0x18>
801044c3:	90                   	nop
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801044c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044cb:	5b                   	pop    %ebx
801044cc:	5e                   	pop    %esi
801044cd:	5f                   	pop    %edi
801044ce:	5d                   	pop    %ebp
801044cf:	c3                   	ret    

801044d0 <getValidProcs>:




int getValidProcs( int* validProcs ){
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	56                   	push   %esi
801044d4:	53                   	push   %ebx
801044d5:	8b 75 08             	mov    0x8(%ebp),%esi
  int output=0, tmp=0;
801044d8:	31 db                	xor    %ebx,%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044da:	83 ec 0c             	sub    $0xc,%esp
801044dd:	68 80 4d 11 80       	push   $0x80114d80
801044e2:	e8 f9 03 00 00       	call   801048e0 <acquire>
801044e7:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044ea:	ba b4 4d 11 80       	mov    $0x80114db4,%edx
801044ef:	90                   	nop
    if(p->state!=ZOMBIE&&p->state!=UNUSED&&p->state!=EMBRYO){
801044f0:	8b 4a 0c             	mov    0xc(%edx),%ecx
801044f3:	83 f9 05             	cmp    $0x5,%ecx
801044f6:	74 0e                	je     80104506 <getValidProcs+0x36>
801044f8:	83 f9 01             	cmp    $0x1,%ecx
801044fb:	76 09                	jbe    80104506 <getValidProcs+0x36>
      validProcs[tmp++]=p->pid;
801044fd:	8b 42 10             	mov    0x10(%edx),%eax
80104500:	89 04 9e             	mov    %eax,(%esi,%ebx,4)
      output++;
80104503:	83 c3 01             	add    $0x1,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104506:	83 c2 7c             	add    $0x7c,%edx
80104509:	81 fa b4 6c 11 80    	cmp    $0x80116cb4,%edx
8010450f:	72 df                	jb     801044f0 <getValidProcs+0x20>
    }
  }
  release(&ptable.lock);
80104511:	83 ec 0c             	sub    $0xc,%esp
80104514:	68 80 4d 11 80       	push   $0x80114d80
80104519:	e8 82 04 00 00       	call   801049a0 <release>
  return output;
}
8010451e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104521:	89 d8                	mov    %ebx,%eax
80104523:	5b                   	pop    %ebx
80104524:	5e                   	pop    %esi
80104525:	5d                   	pop    %ebp
80104526:	c3                   	ret    
80104527:	89 f6                	mov    %esi,%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <getProcFile>:

struct file** getProcFile( int fileIndex ){
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
80104537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = ptable.proc;

  acquire(&ptable.lock);
8010453a:	68 80 4d 11 80       	push   $0x80114d80
8010453f:	e8 9c 03 00 00       	call   801048e0 <acquire>
  for(int i=0 ; i < fileIndex; i++ , p++);//move p for the specific proc
80104544:	83 c4 10             	add    $0x10,%esp
80104547:	85 db                	test   %ebx,%ebx
80104549:	7e 25                	jle    80104570 <getProcFile+0x40>
8010454b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
8010454e:	81 c3 b4 4d 11 80    	add    $0x80114db4,%ebx
  release(&ptable.lock);
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	68 80 4d 11 80       	push   $0x80114d80
8010455c:	e8 3f 04 00 00       	call   801049a0 <release>
  return p->ofile;
80104561:	8d 43 28             	lea    0x28(%ebx),%eax
}
80104564:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104567:	c9                   	leave  
80104568:	c3                   	ret    
80104569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p = ptable.proc;
80104570:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
80104575:	eb dd                	jmp    80104554 <getProcFile+0x24>
80104577:	89 f6                	mov    %esi,%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <getPid>:

int getPid( int fileIndex ){
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 10             	sub    $0x10,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = ptable.proc;

  acquire(&ptable.lock);
8010458a:	68 80 4d 11 80       	push   $0x80114d80
8010458f:	e8 4c 03 00 00       	call   801048e0 <acquire>
  for(int i=0 ; i < fileIndex; i++ , p++);//move p for the specific proc
80104594:	83 c4 10             	add    $0x10,%esp
80104597:	85 db                	test   %ebx,%ebx
80104599:	7e 25                	jle    801045c0 <getPid+0x40>
8010459b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
8010459e:	81 c3 b4 4d 11 80    	add    $0x80114db4,%ebx
  release(&ptable.lock);
801045a4:	83 ec 0c             	sub    $0xc,%esp
801045a7:	68 80 4d 11 80       	push   $0x80114d80
801045ac:	e8 ef 03 00 00       	call   801049a0 <release>
  return p->pid;
801045b1:	8b 43 10             	mov    0x10(%ebx),%eax
}
801045b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045b7:	c9                   	leave  
801045b8:	c3                   	ret    
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p = ptable.proc;
801045c0:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
801045c5:	eb dd                	jmp    801045a4 <getPid+0x24>
801045c7:	89 f6                	mov    %esi,%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <getInode>:

struct inode* getInode( int fileIndex ){
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	53                   	push   %ebx
801045d4:	83 ec 10             	sub    $0x10,%esp
801045d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p = ptable.proc;

  acquire(&ptable.lock);
801045da:	68 80 4d 11 80       	push   $0x80114d80
801045df:	e8 fc 02 00 00       	call   801048e0 <acquire>
  for(int i=0 ; i < fileIndex; i++ , p++);//move p for the specific proc
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	85 db                	test   %ebx,%ebx
801045e9:	7e 25                	jle    80104610 <getInode+0x40>
801045eb:	6b db 7c             	imul   $0x7c,%ebx,%ebx
801045ee:	81 c3 b4 4d 11 80    	add    $0x80114db4,%ebx
  release(&ptable.lock);
801045f4:	83 ec 0c             	sub    $0xc,%esp
801045f7:	68 80 4d 11 80       	push   $0x80114d80
801045fc:	e8 9f 03 00 00       	call   801049a0 <release>
  return p->cwd;
80104601:	8b 43 68             	mov    0x68(%ebx),%eax
}
80104604:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104607:	c9                   	leave  
80104608:	c3                   	ret    
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *p = ptable.proc;
80104610:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
80104615:	eb dd                	jmp    801045f4 <getInode+0x24>
80104617:	89 f6                	mov    %esi,%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <getProc>:

struct proc* getProc( int fileIndex ){
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 10             	sub    $0x10,%esp
80104627:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p=0;
  int i;
  acquire(&ptable.lock);
8010462a:	68 80 4d 11 80       	push   $0x80114d80
8010462f:	e8 ac 02 00 00       	call   801048e0 <acquire>
  for(i=0 ,p = ptable.proc ; i < fileIndex; i++ , p++);//move p for the specific proc
80104634:	83 c4 10             	add    $0x10,%esp
80104637:	85 db                	test   %ebx,%ebx
80104639:	7e 25                	jle    80104660 <getProc+0x40>
8010463b:	6b db 7c             	imul   $0x7c,%ebx,%ebx
8010463e:	81 c3 b4 4d 11 80    	add    $0x80114db4,%ebx
  release(&ptable.lock);
80104644:	83 ec 0c             	sub    $0xc,%esp
80104647:	68 80 4d 11 80       	push   $0x80114d80
8010464c:	e8 4f 03 00 00       	call   801049a0 <release>
  return p;
}
80104651:	89 d8                	mov    %ebx,%eax
80104653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104656:	c9                   	leave  
80104657:	c3                   	ret    
80104658:	90                   	nop
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0 ,p = ptable.proc ; i < fileIndex; i++ , p++);//move p for the specific proc
80104660:	bb b4 4d 11 80       	mov    $0x80114db4,%ebx
80104665:	eb dd                	jmp    80104644 <getProc+0x24>
80104667:	66 90                	xchg   %ax,%ax
80104669:	66 90                	xchg   %ax,%ax
8010466b:	66 90                	xchg   %ax,%ax
8010466d:	66 90                	xchg   %ax,%ax
8010466f:	90                   	nop

80104670 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010467a:	68 d8 90 10 80       	push   $0x801090d8
8010467f:	8d 43 04             	lea    0x4(%ebx),%eax
80104682:	50                   	push   %eax
80104683:	e8 18 01 00 00       	call   801047a0 <initlock>
  lk->name = name;
80104688:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010468b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104691:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104694:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010469b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010469e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046a1:	c9                   	leave  
801046a2:	c3                   	ret    
801046a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046b8:	83 ec 0c             	sub    $0xc,%esp
801046bb:	8d 73 04             	lea    0x4(%ebx),%esi
801046be:	56                   	push   %esi
801046bf:	e8 1c 02 00 00       	call   801048e0 <acquire>
  while (lk->locked) {
801046c4:	8b 13                	mov    (%ebx),%edx
801046c6:	83 c4 10             	add    $0x10,%esp
801046c9:	85 d2                	test   %edx,%edx
801046cb:	74 16                	je     801046e3 <acquiresleep+0x33>
801046cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801046d0:	83 ec 08             	sub    $0x8,%esp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
801046d5:	e8 a6 fa ff ff       	call   80104180 <sleep>
  while (lk->locked) {
801046da:	8b 03                	mov    (%ebx),%eax
801046dc:	83 c4 10             	add    $0x10,%esp
801046df:	85 c0                	test   %eax,%eax
801046e1:	75 ed                	jne    801046d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801046e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801046e9:	e8 f2 f4 ff ff       	call   80103be0 <myproc>
801046ee:	8b 40 10             	mov    0x10(%eax),%eax
801046f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801046f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801046f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046fa:	5b                   	pop    %ebx
801046fb:	5e                   	pop    %esi
801046fc:	5d                   	pop    %ebp
  release(&lk->lk);
801046fd:	e9 9e 02 00 00       	jmp    801049a0 <release>
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	56                   	push   %esi
80104714:	53                   	push   %ebx
80104715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104718:	83 ec 0c             	sub    $0xc,%esp
8010471b:	8d 73 04             	lea    0x4(%ebx),%esi
8010471e:	56                   	push   %esi
8010471f:	e8 bc 01 00 00       	call   801048e0 <acquire>
  lk->locked = 0;
80104724:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010472a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104731:	89 1c 24             	mov    %ebx,(%esp)
80104734:	e8 f7 fb ff ff       	call   80104330 <wakeup>
  release(&lk->lk);
80104739:	89 75 08             	mov    %esi,0x8(%ebp)
8010473c:	83 c4 10             	add    $0x10,%esp
}
8010473f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104742:	5b                   	pop    %ebx
80104743:	5e                   	pop    %esi
80104744:	5d                   	pop    %ebp
  release(&lk->lk);
80104745:	e9 56 02 00 00       	jmp    801049a0 <release>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104750 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	57                   	push   %edi
80104754:	56                   	push   %esi
80104755:	53                   	push   %ebx
80104756:	31 ff                	xor    %edi,%edi
80104758:	83 ec 18             	sub    $0x18,%esp
8010475b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010475e:	8d 73 04             	lea    0x4(%ebx),%esi
80104761:	56                   	push   %esi
80104762:	e8 79 01 00 00       	call   801048e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104767:	8b 03                	mov    (%ebx),%eax
80104769:	83 c4 10             	add    $0x10,%esp
8010476c:	85 c0                	test   %eax,%eax
8010476e:	74 13                	je     80104783 <holdingsleep+0x33>
80104770:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104773:	e8 68 f4 ff ff       	call   80103be0 <myproc>
80104778:	39 58 10             	cmp    %ebx,0x10(%eax)
8010477b:	0f 94 c0             	sete   %al
8010477e:	0f b6 c0             	movzbl %al,%eax
80104781:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104783:	83 ec 0c             	sub    $0xc,%esp
80104786:	56                   	push   %esi
80104787:	e8 14 02 00 00       	call   801049a0 <release>
  return r;
}
8010478c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010478f:	89 f8                	mov    %edi,%eax
80104791:	5b                   	pop    %ebx
80104792:	5e                   	pop    %esi
80104793:	5f                   	pop    %edi
80104794:	5d                   	pop    %ebp
80104795:	c3                   	ret    
80104796:	66 90                	xchg   %ax,%ax
80104798:	66 90                	xchg   %ax,%ax
8010479a:	66 90                	xchg   %ax,%ax
8010479c:	66 90                	xchg   %ax,%ax
8010479e:	66 90                	xchg   %ax,%ax

801047a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801047a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801047a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801047af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801047b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801047b9:	5d                   	pop    %ebp
801047ba:	c3                   	ret    
801047bb:	90                   	nop
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801047c0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801047c1:	31 d2                	xor    %edx,%edx
{
801047c3:	89 e5                	mov    %esp,%ebp
801047c5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801047c6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801047c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801047cc:	83 e8 08             	sub    $0x8,%eax
801047cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047d0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047dc:	77 1a                	ja     801047f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801047de:	8b 58 04             	mov    0x4(%eax),%ebx
801047e1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047e4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047e7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047e9:	83 fa 0a             	cmp    $0xa,%edx
801047ec:	75 e2                	jne    801047d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801047ee:	5b                   	pop    %ebx
801047ef:	5d                   	pop    %ebp
801047f0:	c3                   	ret    
801047f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047fb:	83 c1 28             	add    $0x28,%ecx
801047fe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104806:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104809:	39 c1                	cmp    %eax,%ecx
8010480b:	75 f3                	jne    80104800 <getcallerpcs+0x40>
}
8010480d:	5b                   	pop    %ebx
8010480e:	5d                   	pop    %ebp
8010480f:	c3                   	ret    

80104810 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	53                   	push   %ebx
80104814:	83 ec 04             	sub    $0x4,%esp
80104817:	9c                   	pushf  
80104818:	5b                   	pop    %ebx
  asm volatile("cli");
80104819:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010481a:	e8 21 f3 ff ff       	call   80103b40 <mycpu>
8010481f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104825:	85 c0                	test   %eax,%eax
80104827:	75 11                	jne    8010483a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104829:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010482f:	e8 0c f3 ff ff       	call   80103b40 <mycpu>
80104834:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010483a:	e8 01 f3 ff ff       	call   80103b40 <mycpu>
8010483f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104846:	83 c4 04             	add    $0x4,%esp
80104849:	5b                   	pop    %ebx
8010484a:	5d                   	pop    %ebp
8010484b:	c3                   	ret    
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <popcli>:

void
popcli(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104856:	9c                   	pushf  
80104857:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104858:	f6 c4 02             	test   $0x2,%ah
8010485b:	75 35                	jne    80104892 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010485d:	e8 de f2 ff ff       	call   80103b40 <mycpu>
80104862:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104869:	78 34                	js     8010489f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010486b:	e8 d0 f2 ff ff       	call   80103b40 <mycpu>
80104870:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104876:	85 d2                	test   %edx,%edx
80104878:	74 06                	je     80104880 <popcli+0x30>
    sti();
}
8010487a:	c9                   	leave  
8010487b:	c3                   	ret    
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104880:	e8 bb f2 ff ff       	call   80103b40 <mycpu>
80104885:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010488b:	85 c0                	test   %eax,%eax
8010488d:	74 eb                	je     8010487a <popcli+0x2a>
  asm volatile("sti");
8010488f:	fb                   	sti    
}
80104890:	c9                   	leave  
80104891:	c3                   	ret    
    panic("popcli - interruptible");
80104892:	83 ec 0c             	sub    $0xc,%esp
80104895:	68 e3 90 10 80       	push   $0x801090e3
8010489a:	e8 f1 ba ff ff       	call   80100390 <panic>
    panic("popcli");
8010489f:	83 ec 0c             	sub    $0xc,%esp
801048a2:	68 fa 90 10 80       	push   $0x801090fa
801048a7:	e8 e4 ba ff ff       	call   80100390 <panic>
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <holding>:
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 75 08             	mov    0x8(%ebp),%esi
801048b8:	31 db                	xor    %ebx,%ebx
  pushcli();
801048ba:	e8 51 ff ff ff       	call   80104810 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048bf:	8b 06                	mov    (%esi),%eax
801048c1:	85 c0                	test   %eax,%eax
801048c3:	74 10                	je     801048d5 <holding+0x25>
801048c5:	8b 5e 08             	mov    0x8(%esi),%ebx
801048c8:	e8 73 f2 ff ff       	call   80103b40 <mycpu>
801048cd:	39 c3                	cmp    %eax,%ebx
801048cf:	0f 94 c3             	sete   %bl
801048d2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801048d5:	e8 76 ff ff ff       	call   80104850 <popcli>
}
801048da:	89 d8                	mov    %ebx,%eax
801048dc:	5b                   	pop    %ebx
801048dd:	5e                   	pop    %esi
801048de:	5d                   	pop    %ebp
801048df:	c3                   	ret    

801048e0 <acquire>:
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801048e5:	e8 26 ff ff ff       	call   80104810 <pushcli>
  if(holding(lk))
801048ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	53                   	push   %ebx
801048f1:	e8 ba ff ff ff       	call   801048b0 <holding>
801048f6:	83 c4 10             	add    $0x10,%esp
801048f9:	85 c0                	test   %eax,%eax
801048fb:	0f 85 83 00 00 00    	jne    80104984 <acquire+0xa4>
80104901:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104903:	ba 01 00 00 00       	mov    $0x1,%edx
80104908:	eb 09                	jmp    80104913 <acquire+0x33>
8010490a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104910:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104913:	89 d0                	mov    %edx,%eax
80104915:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104918:	85 c0                	test   %eax,%eax
8010491a:	75 f4                	jne    80104910 <acquire+0x30>
  __sync_synchronize();
8010491c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104921:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104924:	e8 17 f2 ff ff       	call   80103b40 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104929:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010492c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010492f:	89 e8                	mov    %ebp,%eax
80104931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104938:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010493e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104944:	77 1a                	ja     80104960 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104946:	8b 48 04             	mov    0x4(%eax),%ecx
80104949:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010494c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010494f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104951:	83 fe 0a             	cmp    $0xa,%esi
80104954:	75 e2                	jne    80104938 <acquire+0x58>
}
80104956:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104959:	5b                   	pop    %ebx
8010495a:	5e                   	pop    %esi
8010495b:	5d                   	pop    %ebp
8010495c:	c3                   	ret    
8010495d:	8d 76 00             	lea    0x0(%esi),%esi
80104960:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104963:	83 c2 28             	add    $0x28,%edx
80104966:	8d 76 00             	lea    0x0(%esi),%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104970:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104976:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104979:	39 d0                	cmp    %edx,%eax
8010497b:	75 f3                	jne    80104970 <acquire+0x90>
}
8010497d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104980:	5b                   	pop    %ebx
80104981:	5e                   	pop    %esi
80104982:	5d                   	pop    %ebp
80104983:	c3                   	ret    
    panic("acquire");
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	68 01 91 10 80       	push   $0x80109101
8010498c:	e8 ff b9 ff ff       	call   80100390 <panic>
80104991:	eb 0d                	jmp    801049a0 <release>
80104993:	90                   	nop
80104994:	90                   	nop
80104995:	90                   	nop
80104996:	90                   	nop
80104997:	90                   	nop
80104998:	90                   	nop
80104999:	90                   	nop
8010499a:	90                   	nop
8010499b:	90                   	nop
8010499c:	90                   	nop
8010499d:	90                   	nop
8010499e:	90                   	nop
8010499f:	90                   	nop

801049a0 <release>:
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 10             	sub    $0x10,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801049aa:	53                   	push   %ebx
801049ab:	e8 00 ff ff ff       	call   801048b0 <holding>
801049b0:	83 c4 10             	add    $0x10,%esp
801049b3:	85 c0                	test   %eax,%eax
801049b5:	74 22                	je     801049d9 <release+0x39>
  lk->pcs[0] = 0;
801049b7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801049be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801049c5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801049ca:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801049d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d3:	c9                   	leave  
  popcli();
801049d4:	e9 77 fe ff ff       	jmp    80104850 <popcli>
    panic("release");
801049d9:	83 ec 0c             	sub    $0xc,%esp
801049dc:	68 09 91 10 80       	push   $0x80109109
801049e1:	e8 aa b9 ff ff       	call   80100390 <panic>
801049e6:	66 90                	xchg   %ax,%ax
801049e8:	66 90                	xchg   %ax,%ax
801049ea:	66 90                	xchg   %ax,%ax
801049ec:	66 90                	xchg   %ax,%ax
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	53                   	push   %ebx
801049f5:	8b 55 08             	mov    0x8(%ebp),%edx
801049f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801049fb:	f6 c2 03             	test   $0x3,%dl
801049fe:	75 05                	jne    80104a05 <memset+0x15>
80104a00:	f6 c1 03             	test   $0x3,%cl
80104a03:	74 13                	je     80104a18 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a05:	89 d7                	mov    %edx,%edi
80104a07:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a0a:	fc                   	cld    
80104a0b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a0d:	5b                   	pop    %ebx
80104a0e:	89 d0                	mov    %edx,%eax
80104a10:	5f                   	pop    %edi
80104a11:	5d                   	pop    %ebp
80104a12:	c3                   	ret    
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a18:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a1c:	c1 e9 02             	shr    $0x2,%ecx
80104a1f:	89 f8                	mov    %edi,%eax
80104a21:	89 fb                	mov    %edi,%ebx
80104a23:	c1 e0 18             	shl    $0x18,%eax
80104a26:	c1 e3 10             	shl    $0x10,%ebx
80104a29:	09 d8                	or     %ebx,%eax
80104a2b:	09 f8                	or     %edi,%eax
80104a2d:	c1 e7 08             	shl    $0x8,%edi
80104a30:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104a32:	89 d7                	mov    %edx,%edi
80104a34:	fc                   	cld    
80104a35:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104a37:	5b                   	pop    %ebx
80104a38:	89 d0                	mov    %edx,%eax
80104a3a:	5f                   	pop    %edi
80104a3b:	5d                   	pop    %ebp
80104a3c:	c3                   	ret    
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi

80104a40 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
80104a46:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104a49:	8b 75 08             	mov    0x8(%ebp),%esi
80104a4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a4f:	85 db                	test   %ebx,%ebx
80104a51:	74 29                	je     80104a7c <memcmp+0x3c>
    if(*s1 != *s2)
80104a53:	0f b6 16             	movzbl (%esi),%edx
80104a56:	0f b6 0f             	movzbl (%edi),%ecx
80104a59:	38 d1                	cmp    %dl,%cl
80104a5b:	75 2b                	jne    80104a88 <memcmp+0x48>
80104a5d:	b8 01 00 00 00       	mov    $0x1,%eax
80104a62:	eb 14                	jmp    80104a78 <memcmp+0x38>
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a68:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104a6c:	83 c0 01             	add    $0x1,%eax
80104a6f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104a74:	38 ca                	cmp    %cl,%dl
80104a76:	75 10                	jne    80104a88 <memcmp+0x48>
  while(n-- > 0){
80104a78:	39 d8                	cmp    %ebx,%eax
80104a7a:	75 ec                	jne    80104a68 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104a7c:	5b                   	pop    %ebx
  return 0;
80104a7d:	31 c0                	xor    %eax,%eax
}
80104a7f:	5e                   	pop    %esi
80104a80:	5f                   	pop    %edi
80104a81:	5d                   	pop    %ebp
80104a82:	c3                   	ret    
80104a83:	90                   	nop
80104a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104a88:	0f b6 c2             	movzbl %dl,%eax
}
80104a8b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104a8c:	29 c8                	sub    %ecx,%eax
}
80104a8e:	5e                   	pop    %esi
80104a8f:	5f                   	pop    %edi
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret    
80104a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 45 08             	mov    0x8(%ebp),%eax
80104aa8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104aab:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104aae:	39 c3                	cmp    %eax,%ebx
80104ab0:	73 26                	jae    80104ad8 <memmove+0x38>
80104ab2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104ab5:	39 c8                	cmp    %ecx,%eax
80104ab7:	73 1f                	jae    80104ad8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104ab9:	85 f6                	test   %esi,%esi
80104abb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104abe:	74 0f                	je     80104acf <memmove+0x2f>
      *--d = *--s;
80104ac0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ac4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104ac7:	83 ea 01             	sub    $0x1,%edx
80104aca:	83 fa ff             	cmp    $0xffffffff,%edx
80104acd:	75 f1                	jne    80104ac0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104acf:	5b                   	pop    %ebx
80104ad0:	5e                   	pop    %esi
80104ad1:	5d                   	pop    %ebp
80104ad2:	c3                   	ret    
80104ad3:	90                   	nop
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104ad8:	31 d2                	xor    %edx,%edx
80104ada:	85 f6                	test   %esi,%esi
80104adc:	74 f1                	je     80104acf <memmove+0x2f>
80104ade:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104ae0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104ae4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104ae7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104aea:	39 d6                	cmp    %edx,%esi
80104aec:	75 f2                	jne    80104ae0 <memmove+0x40>
}
80104aee:	5b                   	pop    %ebx
80104aef:	5e                   	pop    %esi
80104af0:	5d                   	pop    %ebp
80104af1:	c3                   	ret    
80104af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b03:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b04:	eb 9a                	jmp    80104aa0 <memmove>
80104b06:	8d 76 00             	lea    0x0(%esi),%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b10 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b18:	53                   	push   %ebx
80104b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b1f:	85 ff                	test   %edi,%edi
80104b21:	74 2f                	je     80104b52 <strncmp+0x42>
80104b23:	0f b6 01             	movzbl (%ecx),%eax
80104b26:	0f b6 1e             	movzbl (%esi),%ebx
80104b29:	84 c0                	test   %al,%al
80104b2b:	74 37                	je     80104b64 <strncmp+0x54>
80104b2d:	38 c3                	cmp    %al,%bl
80104b2f:	75 33                	jne    80104b64 <strncmp+0x54>
80104b31:	01 f7                	add    %esi,%edi
80104b33:	eb 13                	jmp    80104b48 <strncmp+0x38>
80104b35:	8d 76 00             	lea    0x0(%esi),%esi
80104b38:	0f b6 01             	movzbl (%ecx),%eax
80104b3b:	84 c0                	test   %al,%al
80104b3d:	74 21                	je     80104b60 <strncmp+0x50>
80104b3f:	0f b6 1a             	movzbl (%edx),%ebx
80104b42:	89 d6                	mov    %edx,%esi
80104b44:	38 d8                	cmp    %bl,%al
80104b46:	75 1c                	jne    80104b64 <strncmp+0x54>
    n--, p++, q++;
80104b48:	8d 56 01             	lea    0x1(%esi),%edx
80104b4b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b4e:	39 fa                	cmp    %edi,%edx
80104b50:	75 e6                	jne    80104b38 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104b52:	5b                   	pop    %ebx
    return 0;
80104b53:	31 c0                	xor    %eax,%eax
}
80104b55:	5e                   	pop    %esi
80104b56:	5f                   	pop    %edi
80104b57:	5d                   	pop    %ebp
80104b58:	c3                   	ret    
80104b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b60:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104b64:	29 d8                	sub    %ebx,%eax
}
80104b66:	5b                   	pop    %ebx
80104b67:	5e                   	pop    %esi
80104b68:	5f                   	pop    %edi
80104b69:	5d                   	pop    %ebp
80104b6a:	c3                   	ret    
80104b6b:	90                   	nop
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	8b 45 08             	mov    0x8(%ebp),%eax
80104b78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b7e:	89 c2                	mov    %eax,%edx
80104b80:	eb 19                	jmp    80104b9b <strncpy+0x2b>
80104b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b88:	83 c3 01             	add    $0x1,%ebx
80104b8b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104b8f:	83 c2 01             	add    $0x1,%edx
80104b92:	84 c9                	test   %cl,%cl
80104b94:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b97:	74 09                	je     80104ba2 <strncpy+0x32>
80104b99:	89 f1                	mov    %esi,%ecx
80104b9b:	85 c9                	test   %ecx,%ecx
80104b9d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ba0:	7f e6                	jg     80104b88 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ba2:	31 c9                	xor    %ecx,%ecx
80104ba4:	85 f6                	test   %esi,%esi
80104ba6:	7e 17                	jle    80104bbf <strncpy+0x4f>
80104ba8:	90                   	nop
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104bb0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104bb4:	89 f3                	mov    %esi,%ebx
80104bb6:	83 c1 01             	add    $0x1,%ecx
80104bb9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104bbb:	85 db                	test   %ebx,%ebx
80104bbd:	7f f1                	jg     80104bb0 <strncpy+0x40>
  return os;
}
80104bbf:	5b                   	pop    %ebx
80104bc0:	5e                   	pop    %esi
80104bc1:	5d                   	pop    %ebp
80104bc2:	c3                   	ret    
80104bc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80104bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104bde:	85 c9                	test   %ecx,%ecx
80104be0:	7e 26                	jle    80104c08 <safestrcpy+0x38>
80104be2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104be6:	89 c1                	mov    %eax,%ecx
80104be8:	eb 17                	jmp    80104c01 <safestrcpy+0x31>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104bf0:	83 c2 01             	add    $0x1,%edx
80104bf3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104bf7:	83 c1 01             	add    $0x1,%ecx
80104bfa:	84 db                	test   %bl,%bl
80104bfc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104bff:	74 04                	je     80104c05 <safestrcpy+0x35>
80104c01:	39 f2                	cmp    %esi,%edx
80104c03:	75 eb                	jne    80104bf0 <safestrcpy+0x20>
    ;
  *s = 0;
80104c05:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c08:	5b                   	pop    %ebx
80104c09:	5e                   	pop    %esi
80104c0a:	5d                   	pop    %ebp
80104c0b:	c3                   	ret    
80104c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c10 <strlen>:

int
strlen(const char *s)
{
80104c10:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c11:	31 c0                	xor    %eax,%eax
{
80104c13:	89 e5                	mov    %esp,%ebp
80104c15:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c18:	80 3a 00             	cmpb   $0x0,(%edx)
80104c1b:	74 0c                	je     80104c29 <strlen+0x19>
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
80104c20:	83 c0 01             	add    $0x1,%eax
80104c23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104c27:	75 f7                	jne    80104c20 <strlen+0x10>
    ;
  return n;
}
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    

80104c2b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104c2b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104c2f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104c33:	55                   	push   %ebp
  pushl %ebx
80104c34:	53                   	push   %ebx
  pushl %esi
80104c35:	56                   	push   %esi
  pushl %edi
80104c36:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104c37:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104c39:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104c3b:	5f                   	pop    %edi
  popl %esi
80104c3c:	5e                   	pop    %esi
  popl %ebx
80104c3d:	5b                   	pop    %ebx
  popl %ebp
80104c3e:	5d                   	pop    %ebp
  ret
80104c3f:	c3                   	ret    

80104c40 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 04             	sub    $0x4,%esp
80104c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c4a:	e8 91 ef ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c4f:	8b 00                	mov    (%eax),%eax
80104c51:	39 d8                	cmp    %ebx,%eax
80104c53:	76 1b                	jbe    80104c70 <fetchint+0x30>
80104c55:	8d 53 04             	lea    0x4(%ebx),%edx
80104c58:	39 d0                	cmp    %edx,%eax
80104c5a:	72 14                	jb     80104c70 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c5f:	8b 13                	mov    (%ebx),%edx
80104c61:	89 10                	mov    %edx,(%eax)
  return 0;
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	83 c4 04             	add    $0x4,%esp
80104c68:	5b                   	pop    %ebx
80104c69:	5d                   	pop    %ebp
80104c6a:	c3                   	ret    
80104c6b:	90                   	nop
80104c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c75:	eb ee                	jmp    80104c65 <fetchint+0x25>
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 04             	sub    $0x4,%esp
80104c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c8a:	e8 51 ef ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz)
80104c8f:	39 18                	cmp    %ebx,(%eax)
80104c91:	76 29                	jbe    80104cbc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104c96:	89 da                	mov    %ebx,%edx
80104c98:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104c9a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104c9c:	39 c3                	cmp    %eax,%ebx
80104c9e:	73 1c                	jae    80104cbc <fetchstr+0x3c>
    if(*s == 0)
80104ca0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104ca3:	75 10                	jne    80104cb5 <fetchstr+0x35>
80104ca5:	eb 39                	jmp    80104ce0 <fetchstr+0x60>
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cb0:	80 3a 00             	cmpb   $0x0,(%edx)
80104cb3:	74 1b                	je     80104cd0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104cb5:	83 c2 01             	add    $0x1,%edx
80104cb8:	39 d0                	cmp    %edx,%eax
80104cba:	77 f4                	ja     80104cb0 <fetchstr+0x30>
    return -1;
80104cbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104cc1:	83 c4 04             	add    $0x4,%esp
80104cc4:	5b                   	pop    %ebx
80104cc5:	5d                   	pop    %ebp
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104cd0:	83 c4 04             	add    $0x4,%esp
80104cd3:	89 d0                	mov    %edx,%eax
80104cd5:	29 d8                	sub    %ebx,%eax
80104cd7:	5b                   	pop    %ebx
80104cd8:	5d                   	pop    %ebp
80104cd9:	c3                   	ret    
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104ce0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104ce2:	eb dd                	jmp    80104cc1 <fetchstr+0x41>
80104ce4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104cea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104cf0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cf5:	e8 e6 ee ff ff       	call   80103be0 <myproc>
80104cfa:	8b 40 18             	mov    0x18(%eax),%eax
80104cfd:	8b 55 08             	mov    0x8(%ebp),%edx
80104d00:	8b 40 44             	mov    0x44(%eax),%eax
80104d03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d06:	e8 d5 ee ff ff       	call   80103be0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d0b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d0d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d10:	39 c6                	cmp    %eax,%esi
80104d12:	73 1c                	jae    80104d30 <argint+0x40>
80104d14:	8d 53 08             	lea    0x8(%ebx),%edx
80104d17:	39 d0                	cmp    %edx,%eax
80104d19:	72 15                	jb     80104d30 <argint+0x40>
  *ip = *(int*)(addr);
80104d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d1e:	8b 53 04             	mov    0x4(%ebx),%edx
80104d21:	89 10                	mov    %edx,(%eax)
  return 0;
80104d23:	31 c0                	xor    %eax,%eax
}
80104d25:	5b                   	pop    %ebx
80104d26:	5e                   	pop    %esi
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret    
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d35:	eb ee                	jmp    80104d25 <argint+0x35>
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
80104d45:	83 ec 10             	sub    $0x10,%esp
80104d48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104d4b:	e8 90 ee ff ff       	call   80103be0 <myproc>
80104d50:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104d52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d55:	83 ec 08             	sub    $0x8,%esp
80104d58:	50                   	push   %eax
80104d59:	ff 75 08             	pushl  0x8(%ebp)
80104d5c:	e8 8f ff ff ff       	call   80104cf0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d61:	83 c4 10             	add    $0x10,%esp
80104d64:	85 c0                	test   %eax,%eax
80104d66:	78 28                	js     80104d90 <argptr+0x50>
80104d68:	85 db                	test   %ebx,%ebx
80104d6a:	78 24                	js     80104d90 <argptr+0x50>
80104d6c:	8b 16                	mov    (%esi),%edx
80104d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d71:	39 c2                	cmp    %eax,%edx
80104d73:	76 1b                	jbe    80104d90 <argptr+0x50>
80104d75:	01 c3                	add    %eax,%ebx
80104d77:	39 da                	cmp    %ebx,%edx
80104d79:	72 15                	jb     80104d90 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d7e:	89 02                	mov    %eax,(%edx)
  return 0;
80104d80:	31 c0                	xor    %eax,%eax
}
80104d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5d                   	pop    %ebp
80104d88:	c3                   	ret    
80104d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d95:	eb eb                	jmp    80104d82 <argptr+0x42>
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104da6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da9:	50                   	push   %eax
80104daa:	ff 75 08             	pushl  0x8(%ebp)
80104dad:	e8 3e ff ff ff       	call   80104cf0 <argint>
80104db2:	83 c4 10             	add    $0x10,%esp
80104db5:	85 c0                	test   %eax,%eax
80104db7:	78 17                	js     80104dd0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104db9:	83 ec 08             	sub    $0x8,%esp
80104dbc:	ff 75 0c             	pushl  0xc(%ebp)
80104dbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104dc2:	e8 b9 fe ff ff       	call   80104c80 <fetchstr>
80104dc7:	83 c4 10             	add    $0x10,%esp
}
80104dca:	c9                   	leave  
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd5:	c9                   	leave  
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <syscall>:
[SYS_lsndFS]   sys_lsndFS,
};

void
syscall(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104de7:	e8 f4 ed ff ff       	call   80103be0 <myproc>
80104dec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dee:	8b 40 18             	mov    0x18(%eax),%eax
80104df1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104df4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104df7:	83 fa 16             	cmp    $0x16,%edx
80104dfa:	77 1c                	ja     80104e18 <syscall+0x38>
80104dfc:	8b 14 85 40 91 10 80 	mov    -0x7fef6ec0(,%eax,4),%edx
80104e03:	85 d2                	test   %edx,%edx
80104e05:	74 11                	je     80104e18 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104e07:	ff d2                	call   *%edx
80104e09:	8b 53 18             	mov    0x18(%ebx),%edx
80104e0c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e12:	c9                   	leave  
80104e13:	c3                   	ret    
80104e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e18:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e19:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e1c:	50                   	push   %eax
80104e1d:	ff 73 10             	pushl  0x10(%ebx)
80104e20:	68 11 91 10 80       	push   $0x80109111
80104e25:	e8 36 b8 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104e2a:	8b 43 18             	mov    0x18(%ebx),%eax
80104e2d:	83 c4 10             	add    $0x10,%esp
80104e30:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e37:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e3a:	c9                   	leave  
80104e3b:	c3                   	ret    
80104e3c:	66 90                	xchg   %ax,%ax
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e46:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104e49:	83 ec 44             	sub    $0x44,%esp
80104e4c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104e4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e52:	56                   	push   %esi
80104e53:	50                   	push   %eax
{
80104e54:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104e57:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e5a:	e8 11 d4 ff ff       	call   80102270 <nameiparent>
80104e5f:	83 c4 10             	add    $0x10,%esp
80104e62:	85 c0                	test   %eax,%eax
80104e64:	0f 84 46 01 00 00    	je     80104fb0 <create+0x170>
    return 0;
  ilock(dp);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	89 c3                	mov    %eax,%ebx
80104e6f:	50                   	push   %eax
80104e70:	e8 eb ca ff ff       	call   80101960 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104e75:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104e78:	83 c4 0c             	add    $0xc,%esp
80104e7b:	50                   	push   %eax
80104e7c:	56                   	push   %esi
80104e7d:	53                   	push   %ebx
80104e7e:	e8 0d d0 ff ff       	call   80101e90 <dirlookup>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	89 c7                	mov    %eax,%edi
80104e8a:	74 34                	je     80104ec0 <create+0x80>
    iunlockput(dp);
80104e8c:	83 ec 0c             	sub    $0xc,%esp
80104e8f:	53                   	push   %ebx
80104e90:	e8 5b cd ff ff       	call   80101bf0 <iunlockput>
    ilock(ip);
80104e95:	89 3c 24             	mov    %edi,(%esp)
80104e98:	e8 c3 ca ff ff       	call   80101960 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104e9d:	83 c4 10             	add    $0x10,%esp
80104ea0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104ea5:	0f 85 95 00 00 00    	jne    80104f40 <create+0x100>
80104eab:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104eb0:	0f 85 8a 00 00 00    	jne    80104f40 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104eb9:	89 f8                	mov    %edi,%eax
80104ebb:	5b                   	pop    %ebx
80104ebc:	5e                   	pop    %esi
80104ebd:	5f                   	pop    %edi
80104ebe:	5d                   	pop    %ebp
80104ebf:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104ec0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104ec4:	83 ec 08             	sub    $0x8,%esp
80104ec7:	50                   	push   %eax
80104ec8:	ff 33                	pushl  (%ebx)
80104eca:	e8 21 c9 ff ff       	call   801017f0 <ialloc>
80104ecf:	83 c4 10             	add    $0x10,%esp
80104ed2:	85 c0                	test   %eax,%eax
80104ed4:	89 c7                	mov    %eax,%edi
80104ed6:	0f 84 e8 00 00 00    	je     80104fc4 <create+0x184>
  ilock(ip);
80104edc:	83 ec 0c             	sub    $0xc,%esp
80104edf:	50                   	push   %eax
80104ee0:	e8 7b ca ff ff       	call   80101960 <ilock>
  ip->major = major;
80104ee5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104ee9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104eed:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104ef1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ef5:	b8 01 00 00 00       	mov    $0x1,%eax
80104efa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104efe:	89 3c 24             	mov    %edi,(%esp)
80104f01:	e8 aa c9 ff ff       	call   801018b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f06:	83 c4 10             	add    $0x10,%esp
80104f09:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104f0e:	74 50                	je     80104f60 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f10:	83 ec 04             	sub    $0x4,%esp
80104f13:	ff 77 04             	pushl  0x4(%edi)
80104f16:	56                   	push   %esi
80104f17:	53                   	push   %ebx
80104f18:	e8 73 d2 ff ff       	call   80102190 <dirlink>
80104f1d:	83 c4 10             	add    $0x10,%esp
80104f20:	85 c0                	test   %eax,%eax
80104f22:	0f 88 8f 00 00 00    	js     80104fb7 <create+0x177>
  iunlockput(dp);
80104f28:	83 ec 0c             	sub    $0xc,%esp
80104f2b:	53                   	push   %ebx
80104f2c:	e8 bf cc ff ff       	call   80101bf0 <iunlockput>
  return ip;
80104f31:	83 c4 10             	add    $0x10,%esp
}
80104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f37:	89 f8                	mov    %edi,%eax
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5f                   	pop    %edi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104f40:	83 ec 0c             	sub    $0xc,%esp
80104f43:	57                   	push   %edi
    return 0;
80104f44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104f46:	e8 a5 cc ff ff       	call   80101bf0 <iunlockput>
    return 0;
80104f4b:	83 c4 10             	add    $0x10,%esp
}
80104f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f51:	89 f8                	mov    %edi,%eax
80104f53:	5b                   	pop    %ebx
80104f54:	5e                   	pop    %esi
80104f55:	5f                   	pop    %edi
80104f56:	5d                   	pop    %ebp
80104f57:	c3                   	ret    
80104f58:	90                   	nop
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104f60:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	53                   	push   %ebx
80104f69:	e8 42 c9 ff ff       	call   801018b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f6e:	83 c4 0c             	add    $0xc,%esp
80104f71:	ff 77 04             	pushl  0x4(%edi)
80104f74:	68 bc 91 10 80       	push   $0x801091bc
80104f79:	57                   	push   %edi
80104f7a:	e8 11 d2 ff ff       	call   80102190 <dirlink>
80104f7f:	83 c4 10             	add    $0x10,%esp
80104f82:	85 c0                	test   %eax,%eax
80104f84:	78 1c                	js     80104fa2 <create+0x162>
80104f86:	83 ec 04             	sub    $0x4,%esp
80104f89:	ff 73 04             	pushl  0x4(%ebx)
80104f8c:	68 bb 91 10 80       	push   $0x801091bb
80104f91:	57                   	push   %edi
80104f92:	e8 f9 d1 ff ff       	call   80102190 <dirlink>
80104f97:	83 c4 10             	add    $0x10,%esp
80104f9a:	85 c0                	test   %eax,%eax
80104f9c:	0f 89 6e ff ff ff    	jns    80104f10 <create+0xd0>
      panic("create dots");
80104fa2:	83 ec 0c             	sub    $0xc,%esp
80104fa5:	68 af 91 10 80       	push   $0x801091af
80104faa:	e8 e1 b3 ff ff       	call   80100390 <panic>
80104faf:	90                   	nop
    return 0;
80104fb0:	31 ff                	xor    %edi,%edi
80104fb2:	e9 ff fe ff ff       	jmp    80104eb6 <create+0x76>
    panic("create: dirlink");
80104fb7:	83 ec 0c             	sub    $0xc,%esp
80104fba:	68 be 91 10 80       	push   $0x801091be
80104fbf:	e8 cc b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	68 a0 91 10 80       	push   $0x801091a0
80104fcc:	e8 bf b3 ff ff       	call   80100390 <panic>
80104fd1:	eb 0d                	jmp    80104fe0 <argfd.constprop.0>
80104fd3:	90                   	nop
80104fd4:	90                   	nop
80104fd5:	90                   	nop
80104fd6:	90                   	nop
80104fd7:	90                   	nop
80104fd8:	90                   	nop
80104fd9:	90                   	nop
80104fda:	90                   	nop
80104fdb:	90                   	nop
80104fdc:	90                   	nop
80104fdd:	90                   	nop
80104fde:	90                   	nop
80104fdf:	90                   	nop

80104fe0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104fe7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104fea:	89 d6                	mov    %edx,%esi
80104fec:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104fef:	50                   	push   %eax
80104ff0:	6a 00                	push   $0x0
80104ff2:	e8 f9 fc ff ff       	call   80104cf0 <argint>
80104ff7:	83 c4 10             	add    $0x10,%esp
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	78 2a                	js     80105028 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105002:	77 24                	ja     80105028 <argfd.constprop.0+0x48>
80105004:	e8 d7 eb ff ff       	call   80103be0 <myproc>
80105009:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010500c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105010:	85 c0                	test   %eax,%eax
80105012:	74 14                	je     80105028 <argfd.constprop.0+0x48>
  if(pfd)
80105014:	85 db                	test   %ebx,%ebx
80105016:	74 02                	je     8010501a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105018:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010501a:	89 06                	mov    %eax,(%esi)
  return 0;
8010501c:	31 c0                	xor    %eax,%eax
}
8010501e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105021:	5b                   	pop    %ebx
80105022:	5e                   	pop    %esi
80105023:	5d                   	pop    %ebp
80105024:	c3                   	ret    
80105025:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105028:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502d:	eb ef                	jmp    8010501e <argfd.constprop.0+0x3e>
8010502f:	90                   	nop

80105030 <sys_dup>:
{
80105030:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105031:	31 c0                	xor    %eax,%eax
{
80105033:	89 e5                	mov    %esp,%ebp
80105035:	56                   	push   %esi
80105036:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105037:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010503a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010503d:	e8 9e ff ff ff       	call   80104fe0 <argfd.constprop.0>
80105042:	85 c0                	test   %eax,%eax
80105044:	78 42                	js     80105088 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105046:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105049:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010504b:	e8 90 eb ff ff       	call   80103be0 <myproc>
80105050:	eb 0e                	jmp    80105060 <sys_dup+0x30>
80105052:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105058:	83 c3 01             	add    $0x1,%ebx
8010505b:	83 fb 10             	cmp    $0x10,%ebx
8010505e:	74 28                	je     80105088 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105060:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105064:	85 d2                	test   %edx,%edx
80105066:	75 f0                	jne    80105058 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105068:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010506c:	83 ec 0c             	sub    $0xc,%esp
8010506f:	ff 75 f4             	pushl  -0xc(%ebp)
80105072:	e8 e9 be ff ff       	call   80100f60 <filedup>
  return fd;
80105077:	83 c4 10             	add    $0x10,%esp
}
8010507a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010507d:	89 d8                	mov    %ebx,%eax
8010507f:	5b                   	pop    %ebx
80105080:	5e                   	pop    %esi
80105081:	5d                   	pop    %ebp
80105082:	c3                   	ret    
80105083:	90                   	nop
80105084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105088:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010508b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105090:	89 d8                	mov    %ebx,%eax
80105092:	5b                   	pop    %ebx
80105093:	5e                   	pop    %esi
80105094:	5d                   	pop    %ebp
80105095:	c3                   	ret    
80105096:	8d 76 00             	lea    0x0(%esi),%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_read>:
{
801050a0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a1:	31 c0                	xor    %eax,%eax
{
801050a3:	89 e5                	mov    %esp,%ebp
801050a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050a8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801050ab:	e8 30 ff ff ff       	call   80104fe0 <argfd.constprop.0>
801050b0:	85 c0                	test   %eax,%eax
801050b2:	78 4c                	js     80105100 <sys_read+0x60>
801050b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b7:	83 ec 08             	sub    $0x8,%esp
801050ba:	50                   	push   %eax
801050bb:	6a 02                	push   $0x2
801050bd:	e8 2e fc ff ff       	call   80104cf0 <argint>
801050c2:	83 c4 10             	add    $0x10,%esp
801050c5:	85 c0                	test   %eax,%eax
801050c7:	78 37                	js     80105100 <sys_read+0x60>
801050c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050cc:	83 ec 04             	sub    $0x4,%esp
801050cf:	ff 75 f0             	pushl  -0x10(%ebp)
801050d2:	50                   	push   %eax
801050d3:	6a 01                	push   $0x1
801050d5:	e8 66 fc ff ff       	call   80104d40 <argptr>
801050da:	83 c4 10             	add    $0x10,%esp
801050dd:	85 c0                	test   %eax,%eax
801050df:	78 1f                	js     80105100 <sys_read+0x60>
  return fileread(f, p, n);
801050e1:	83 ec 04             	sub    $0x4,%esp
801050e4:	ff 75 f0             	pushl  -0x10(%ebp)
801050e7:	ff 75 f4             	pushl  -0xc(%ebp)
801050ea:	ff 75 ec             	pushl  -0x14(%ebp)
801050ed:	e8 de bf ff ff       	call   801010d0 <fileread>
801050f2:	83 c4 10             	add    $0x10,%esp
}
801050f5:	c9                   	leave  
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <sys_write>:
{
80105110:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105111:	31 c0                	xor    %eax,%eax
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105118:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010511b:	e8 c0 fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105120:	85 c0                	test   %eax,%eax
80105122:	78 4c                	js     80105170 <sys_write+0x60>
80105124:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105127:	83 ec 08             	sub    $0x8,%esp
8010512a:	50                   	push   %eax
8010512b:	6a 02                	push   $0x2
8010512d:	e8 be fb ff ff       	call   80104cf0 <argint>
80105132:	83 c4 10             	add    $0x10,%esp
80105135:	85 c0                	test   %eax,%eax
80105137:	78 37                	js     80105170 <sys_write+0x60>
80105139:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010513c:	83 ec 04             	sub    $0x4,%esp
8010513f:	ff 75 f0             	pushl  -0x10(%ebp)
80105142:	50                   	push   %eax
80105143:	6a 01                	push   $0x1
80105145:	e8 f6 fb ff ff       	call   80104d40 <argptr>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	85 c0                	test   %eax,%eax
8010514f:	78 1f                	js     80105170 <sys_write+0x60>
  return filewrite(f, p, n);
80105151:	83 ec 04             	sub    $0x4,%esp
80105154:	ff 75 f0             	pushl  -0x10(%ebp)
80105157:	ff 75 f4             	pushl  -0xc(%ebp)
8010515a:	ff 75 ec             	pushl  -0x14(%ebp)
8010515d:	e8 fe bf ff ff       	call   80101160 <filewrite>
80105162:	83 c4 10             	add    $0x10,%esp
}
80105165:	c9                   	leave  
80105166:	c3                   	ret    
80105167:	89 f6                	mov    %esi,%esi
80105169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105170:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_close>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105186:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105189:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010518c:	e8 4f fe ff ff       	call   80104fe0 <argfd.constprop.0>
80105191:	85 c0                	test   %eax,%eax
80105193:	78 2b                	js     801051c0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105195:	e8 46 ea ff ff       	call   80103be0 <myproc>
8010519a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010519d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051a0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801051a7:	00 
  fileclose(f);
801051a8:	ff 75 f4             	pushl  -0xc(%ebp)
801051ab:	e8 00 be ff ff       	call   80100fb0 <fileclose>
  return 0;
801051b0:	83 c4 10             	add    $0x10,%esp
801051b3:	31 c0                	xor    %eax,%eax
}
801051b5:	c9                   	leave  
801051b6:	c3                   	ret    
801051b7:	89 f6                	mov    %esi,%esi
801051b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c5:	c9                   	leave  
801051c6:	c3                   	ret    
801051c7:	89 f6                	mov    %esi,%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_fstat>:
{
801051d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801051d8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801051db:	e8 00 fe ff ff       	call   80104fe0 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 2c                	js     80105210 <sys_fstat+0x40>
801051e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e7:	83 ec 04             	sub    $0x4,%esp
801051ea:	6a 14                	push   $0x14
801051ec:	50                   	push   %eax
801051ed:	6a 01                	push   $0x1
801051ef:	e8 4c fb ff ff       	call   80104d40 <argptr>
801051f4:	83 c4 10             	add    $0x10,%esp
801051f7:	85 c0                	test   %eax,%eax
801051f9:	78 15                	js     80105210 <sys_fstat+0x40>
  return filestat(f, st);
801051fb:	83 ec 08             	sub    $0x8,%esp
801051fe:	ff 75 f4             	pushl  -0xc(%ebp)
80105201:	ff 75 f0             	pushl  -0x10(%ebp)
80105204:	e8 77 be ff ff       	call   80101080 <filestat>
80105209:	83 c4 10             	add    $0x10,%esp
}
8010520c:	c9                   	leave  
8010520d:	c3                   	ret    
8010520e:	66 90                	xchg   %ax,%ax
    return -1;
80105210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105215:	c9                   	leave  
80105216:	c3                   	ret    
80105217:	89 f6                	mov    %esi,%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105220 <sys_link>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
80105225:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105226:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105229:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010522c:	50                   	push   %eax
8010522d:	6a 00                	push   $0x0
8010522f:	e8 6c fb ff ff       	call   80104da0 <argstr>
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
80105239:	0f 88 fb 00 00 00    	js     8010533a <sys_link+0x11a>
8010523f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105242:	83 ec 08             	sub    $0x8,%esp
80105245:	50                   	push   %eax
80105246:	6a 01                	push   $0x1
80105248:	e8 53 fb ff ff       	call   80104da0 <argstr>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	0f 88 e2 00 00 00    	js     8010533a <sys_link+0x11a>
  begin_op();
80105258:	e8 43 dd ff ff       	call   80102fa0 <begin_op>
  if((ip = namei(old)) == 0){
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	ff 75 d4             	pushl  -0x2c(%ebp)
80105263:	e8 e8 cf ff ff       	call   80102250 <namei>
80105268:	83 c4 10             	add    $0x10,%esp
8010526b:	85 c0                	test   %eax,%eax
8010526d:	89 c3                	mov    %eax,%ebx
8010526f:	0f 84 ea 00 00 00    	je     8010535f <sys_link+0x13f>
  ilock(ip);
80105275:	83 ec 0c             	sub    $0xc,%esp
80105278:	50                   	push   %eax
80105279:	e8 e2 c6 ff ff       	call   80101960 <ilock>
  if(ip->type == T_DIR){
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105286:	0f 84 bb 00 00 00    	je     80105347 <sys_link+0x127>
  ip->nlink++;
8010528c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105291:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105294:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105297:	53                   	push   %ebx
80105298:	e8 13 c6 ff ff       	call   801018b0 <iupdate>
  iunlock(ip);
8010529d:	89 1c 24             	mov    %ebx,(%esp)
801052a0:	e8 9b c7 ff ff       	call   80101a40 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052a5:	58                   	pop    %eax
801052a6:	5a                   	pop    %edx
801052a7:	57                   	push   %edi
801052a8:	ff 75 d0             	pushl  -0x30(%ebp)
801052ab:	e8 c0 cf ff ff       	call   80102270 <nameiparent>
801052b0:	83 c4 10             	add    $0x10,%esp
801052b3:	85 c0                	test   %eax,%eax
801052b5:	89 c6                	mov    %eax,%esi
801052b7:	74 5b                	je     80105314 <sys_link+0xf4>
  ilock(dp);
801052b9:	83 ec 0c             	sub    $0xc,%esp
801052bc:	50                   	push   %eax
801052bd:	e8 9e c6 ff ff       	call   80101960 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052c2:	83 c4 10             	add    $0x10,%esp
801052c5:	8b 03                	mov    (%ebx),%eax
801052c7:	39 06                	cmp    %eax,(%esi)
801052c9:	75 3d                	jne    80105308 <sys_link+0xe8>
801052cb:	83 ec 04             	sub    $0x4,%esp
801052ce:	ff 73 04             	pushl  0x4(%ebx)
801052d1:	57                   	push   %edi
801052d2:	56                   	push   %esi
801052d3:	e8 b8 ce ff ff       	call   80102190 <dirlink>
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	85 c0                	test   %eax,%eax
801052dd:	78 29                	js     80105308 <sys_link+0xe8>
  iunlockput(dp);
801052df:	83 ec 0c             	sub    $0xc,%esp
801052e2:	56                   	push   %esi
801052e3:	e8 08 c9 ff ff       	call   80101bf0 <iunlockput>
  iput(ip);
801052e8:	89 1c 24             	mov    %ebx,(%esp)
801052eb:	e8 a0 c7 ff ff       	call   80101a90 <iput>
  end_op();
801052f0:	e8 1b dd ff ff       	call   80103010 <end_op>
  return 0;
801052f5:	83 c4 10             	add    $0x10,%esp
801052f8:	31 c0                	xor    %eax,%eax
}
801052fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052fd:	5b                   	pop    %ebx
801052fe:	5e                   	pop    %esi
801052ff:	5f                   	pop    %edi
80105300:	5d                   	pop    %ebp
80105301:	c3                   	ret    
80105302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105308:	83 ec 0c             	sub    $0xc,%esp
8010530b:	56                   	push   %esi
8010530c:	e8 df c8 ff ff       	call   80101bf0 <iunlockput>
    goto bad;
80105311:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105314:	83 ec 0c             	sub    $0xc,%esp
80105317:	53                   	push   %ebx
80105318:	e8 43 c6 ff ff       	call   80101960 <ilock>
  ip->nlink--;
8010531d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105322:	89 1c 24             	mov    %ebx,(%esp)
80105325:	e8 86 c5 ff ff       	call   801018b0 <iupdate>
  iunlockput(ip);
8010532a:	89 1c 24             	mov    %ebx,(%esp)
8010532d:	e8 be c8 ff ff       	call   80101bf0 <iunlockput>
  end_op();
80105332:	e8 d9 dc ff ff       	call   80103010 <end_op>
  return -1;
80105337:	83 c4 10             	add    $0x10,%esp
}
8010533a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010533d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105342:	5b                   	pop    %ebx
80105343:	5e                   	pop    %esi
80105344:	5f                   	pop    %edi
80105345:	5d                   	pop    %ebp
80105346:	c3                   	ret    
    iunlockput(ip);
80105347:	83 ec 0c             	sub    $0xc,%esp
8010534a:	53                   	push   %ebx
8010534b:	e8 a0 c8 ff ff       	call   80101bf0 <iunlockput>
    end_op();
80105350:	e8 bb dc ff ff       	call   80103010 <end_op>
    return -1;
80105355:	83 c4 10             	add    $0x10,%esp
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	eb 9b                	jmp    801052fa <sys_link+0xda>
    end_op();
8010535f:	e8 ac dc ff ff       	call   80103010 <end_op>
    return -1;
80105364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105369:	eb 8f                	jmp    801052fa <sys_link+0xda>
8010536b:	90                   	nop
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105370 <sys_unlink>:
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	57                   	push   %edi
80105374:	56                   	push   %esi
80105375:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105376:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105379:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010537c:	50                   	push   %eax
8010537d:	6a 00                	push   $0x0
8010537f:	e8 1c fa ff ff       	call   80104da0 <argstr>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	0f 88 77 01 00 00    	js     80105506 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010538f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105392:	e8 09 dc ff ff       	call   80102fa0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105397:	83 ec 08             	sub    $0x8,%esp
8010539a:	53                   	push   %ebx
8010539b:	ff 75 c0             	pushl  -0x40(%ebp)
8010539e:	e8 cd ce ff ff       	call   80102270 <nameiparent>
801053a3:	83 c4 10             	add    $0x10,%esp
801053a6:	85 c0                	test   %eax,%eax
801053a8:	89 c6                	mov    %eax,%esi
801053aa:	0f 84 60 01 00 00    	je     80105510 <sys_unlink+0x1a0>
  ilock(dp);
801053b0:	83 ec 0c             	sub    $0xc,%esp
801053b3:	50                   	push   %eax
801053b4:	e8 a7 c5 ff ff       	call   80101960 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053b9:	58                   	pop    %eax
801053ba:	5a                   	pop    %edx
801053bb:	68 bc 91 10 80       	push   $0x801091bc
801053c0:	53                   	push   %ebx
801053c1:	e8 aa ca ff ff       	call   80101e70 <namecmp>
801053c6:	83 c4 10             	add    $0x10,%esp
801053c9:	85 c0                	test   %eax,%eax
801053cb:	0f 84 03 01 00 00    	je     801054d4 <sys_unlink+0x164>
801053d1:	83 ec 08             	sub    $0x8,%esp
801053d4:	68 bb 91 10 80       	push   $0x801091bb
801053d9:	53                   	push   %ebx
801053da:	e8 91 ca ff ff       	call   80101e70 <namecmp>
801053df:	83 c4 10             	add    $0x10,%esp
801053e2:	85 c0                	test   %eax,%eax
801053e4:	0f 84 ea 00 00 00    	je     801054d4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
801053ea:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801053ed:	83 ec 04             	sub    $0x4,%esp
801053f0:	50                   	push   %eax
801053f1:	53                   	push   %ebx
801053f2:	56                   	push   %esi
801053f3:	e8 98 ca ff ff       	call   80101e90 <dirlookup>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	85 c0                	test   %eax,%eax
801053fd:	89 c3                	mov    %eax,%ebx
801053ff:	0f 84 cf 00 00 00    	je     801054d4 <sys_unlink+0x164>
  ilock(ip);
80105405:	83 ec 0c             	sub    $0xc,%esp
80105408:	50                   	push   %eax
80105409:	e8 52 c5 ff ff       	call   80101960 <ilock>
  if(ip->nlink < 1)
8010540e:	83 c4 10             	add    $0x10,%esp
80105411:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105416:	0f 8e 10 01 00 00    	jle    8010552c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010541c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105421:	74 6d                	je     80105490 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105423:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105426:	83 ec 04             	sub    $0x4,%esp
80105429:	6a 10                	push   $0x10
8010542b:	6a 00                	push   $0x0
8010542d:	50                   	push   %eax
8010542e:	e8 bd f5 ff ff       	call   801049f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105433:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105436:	6a 10                	push   $0x10
80105438:	ff 75 c4             	pushl  -0x3c(%ebp)
8010543b:	50                   	push   %eax
8010543c:	56                   	push   %esi
8010543d:	e8 fe c8 ff ff       	call   80101d40 <writei>
80105442:	83 c4 20             	add    $0x20,%esp
80105445:	83 f8 10             	cmp    $0x10,%eax
80105448:	0f 85 eb 00 00 00    	jne    80105539 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010544e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105453:	0f 84 97 00 00 00    	je     801054f0 <sys_unlink+0x180>
  iunlockput(dp);
80105459:	83 ec 0c             	sub    $0xc,%esp
8010545c:	56                   	push   %esi
8010545d:	e8 8e c7 ff ff       	call   80101bf0 <iunlockput>
  ip->nlink--;
80105462:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105467:	89 1c 24             	mov    %ebx,(%esp)
8010546a:	e8 41 c4 ff ff       	call   801018b0 <iupdate>
  iunlockput(ip);
8010546f:	89 1c 24             	mov    %ebx,(%esp)
80105472:	e8 79 c7 ff ff       	call   80101bf0 <iunlockput>
  end_op();
80105477:	e8 94 db ff ff       	call   80103010 <end_op>
  return 0;
8010547c:	83 c4 10             	add    $0x10,%esp
8010547f:	31 c0                	xor    %eax,%eax
}
80105481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105484:	5b                   	pop    %ebx
80105485:	5e                   	pop    %esi
80105486:	5f                   	pop    %edi
80105487:	5d                   	pop    %ebp
80105488:	c3                   	ret    
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105490:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105494:	76 8d                	jbe    80105423 <sys_unlink+0xb3>
80105496:	bf 20 00 00 00       	mov    $0x20,%edi
8010549b:	eb 0f                	jmp    801054ac <sys_unlink+0x13c>
8010549d:	8d 76 00             	lea    0x0(%esi),%esi
801054a0:	83 c7 10             	add    $0x10,%edi
801054a3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801054a6:	0f 83 77 ff ff ff    	jae    80105423 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054ac:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054af:	6a 10                	push   $0x10
801054b1:	57                   	push   %edi
801054b2:	50                   	push   %eax
801054b3:	53                   	push   %ebx
801054b4:	e8 87 c7 ff ff       	call   80101c40 <readi>
801054b9:	83 c4 10             	add    $0x10,%esp
801054bc:	83 f8 10             	cmp    $0x10,%eax
801054bf:	75 5e                	jne    8010551f <sys_unlink+0x1af>
    if(de.inum != 0)
801054c1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054c6:	74 d8                	je     801054a0 <sys_unlink+0x130>
    iunlockput(ip);
801054c8:	83 ec 0c             	sub    $0xc,%esp
801054cb:	53                   	push   %ebx
801054cc:	e8 1f c7 ff ff       	call   80101bf0 <iunlockput>
    goto bad;
801054d1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801054d4:	83 ec 0c             	sub    $0xc,%esp
801054d7:	56                   	push   %esi
801054d8:	e8 13 c7 ff ff       	call   80101bf0 <iunlockput>
  end_op();
801054dd:	e8 2e db ff ff       	call   80103010 <end_op>
  return -1;
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ea:	eb 95                	jmp    80105481 <sys_unlink+0x111>
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
801054f0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801054f5:	83 ec 0c             	sub    $0xc,%esp
801054f8:	56                   	push   %esi
801054f9:	e8 b2 c3 ff ff       	call   801018b0 <iupdate>
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	e9 53 ff ff ff       	jmp    80105459 <sys_unlink+0xe9>
    return -1;
80105506:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010550b:	e9 71 ff ff ff       	jmp    80105481 <sys_unlink+0x111>
    end_op();
80105510:	e8 fb da ff ff       	call   80103010 <end_op>
    return -1;
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551a:	e9 62 ff ff ff       	jmp    80105481 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	68 e0 91 10 80       	push   $0x801091e0
80105527:	e8 64 ae ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010552c:	83 ec 0c             	sub    $0xc,%esp
8010552f:	68 ce 91 10 80       	push   $0x801091ce
80105534:	e8 57 ae ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105539:	83 ec 0c             	sub    $0xc,%esp
8010553c:	68 f2 91 10 80       	push   $0x801091f2
80105541:	e8 4a ae ff ff       	call   80100390 <panic>
80105546:	8d 76 00             	lea    0x0(%esi),%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <sys_open>:

int
sys_open(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105556:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105559:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010555c:	50                   	push   %eax
8010555d:	6a 00                	push   $0x0
8010555f:	e8 3c f8 ff ff       	call   80104da0 <argstr>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	0f 88 1d 01 00 00    	js     8010568c <sys_open+0x13c>
8010556f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105572:	83 ec 08             	sub    $0x8,%esp
80105575:	50                   	push   %eax
80105576:	6a 01                	push   $0x1
80105578:	e8 73 f7 ff ff       	call   80104cf0 <argint>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	0f 88 04 01 00 00    	js     8010568c <sys_open+0x13c>
    return -1;

  begin_op();
80105588:	e8 13 da ff ff       	call   80102fa0 <begin_op>

  if(omode & O_CREATE){
8010558d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105591:	0f 85 a9 00 00 00    	jne    80105640 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105597:	83 ec 0c             	sub    $0xc,%esp
8010559a:	ff 75 e0             	pushl  -0x20(%ebp)
8010559d:	e8 ae cc ff ff       	call   80102250 <namei>
801055a2:	83 c4 10             	add    $0x10,%esp
801055a5:	85 c0                	test   %eax,%eax
801055a7:	89 c6                	mov    %eax,%esi
801055a9:	0f 84 b2 00 00 00    	je     80105661 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801055af:	83 ec 0c             	sub    $0xc,%esp
801055b2:	50                   	push   %eax
801055b3:	e8 a8 c3 ff ff       	call   80101960 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055b8:	83 c4 10             	add    $0x10,%esp
801055bb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055c0:	0f 84 aa 00 00 00    	je     80105670 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055c6:	e8 25 b9 ff ff       	call   80100ef0 <filealloc>
801055cb:	85 c0                	test   %eax,%eax
801055cd:	89 c7                	mov    %eax,%edi
801055cf:	0f 84 a6 00 00 00    	je     8010567b <sys_open+0x12b>
  struct proc *curproc = myproc();
801055d5:	e8 06 e6 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055da:	31 db                	xor    %ebx,%ebx
801055dc:	eb 0e                	jmp    801055ec <sys_open+0x9c>
801055de:	66 90                	xchg   %ax,%ax
801055e0:	83 c3 01             	add    $0x1,%ebx
801055e3:	83 fb 10             	cmp    $0x10,%ebx
801055e6:	0f 84 ac 00 00 00    	je     80105698 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801055ec:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055f0:	85 d2                	test   %edx,%edx
801055f2:	75 ec                	jne    801055e0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801055f4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801055f7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801055fb:	56                   	push   %esi
801055fc:	e8 3f c4 ff ff       	call   80101a40 <iunlock>
  end_op();
80105601:	e8 0a da ff ff       	call   80103010 <end_op>

  f->type = FD_INODE;
80105606:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010560c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010560f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105612:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105615:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010561c:	89 d0                	mov    %edx,%eax
8010561e:	f7 d0                	not    %eax
80105620:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105623:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105626:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105629:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010562d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105630:	89 d8                	mov    %ebx,%eax
80105632:	5b                   	pop    %ebx
80105633:	5e                   	pop    %esi
80105634:	5f                   	pop    %edi
80105635:	5d                   	pop    %ebp
80105636:	c3                   	ret    
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105646:	31 c9                	xor    %ecx,%ecx
80105648:	6a 00                	push   $0x0
8010564a:	ba 02 00 00 00       	mov    $0x2,%edx
8010564f:	e8 ec f7 ff ff       	call   80104e40 <create>
    if(ip == 0){
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105659:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010565b:	0f 85 65 ff ff ff    	jne    801055c6 <sys_open+0x76>
      end_op();
80105661:	e8 aa d9 ff ff       	call   80103010 <end_op>
      return -1;
80105666:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010566b:	eb c0                	jmp    8010562d <sys_open+0xdd>
8010566d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105670:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105673:	85 c9                	test   %ecx,%ecx
80105675:	0f 84 4b ff ff ff    	je     801055c6 <sys_open+0x76>
    iunlockput(ip);
8010567b:	83 ec 0c             	sub    $0xc,%esp
8010567e:	56                   	push   %esi
8010567f:	e8 6c c5 ff ff       	call   80101bf0 <iunlockput>
    end_op();
80105684:	e8 87 d9 ff ff       	call   80103010 <end_op>
    return -1;
80105689:	83 c4 10             	add    $0x10,%esp
8010568c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105691:	eb 9a                	jmp    8010562d <sys_open+0xdd>
80105693:	90                   	nop
80105694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	57                   	push   %edi
8010569c:	e8 0f b9 ff ff       	call   80100fb0 <fileclose>
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	eb d5                	jmp    8010567b <sys_open+0x12b>
801056a6:	8d 76 00             	lea    0x0(%esi),%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056b6:	e8 e5 d8 ff ff       	call   80102fa0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056be:	83 ec 08             	sub    $0x8,%esp
801056c1:	50                   	push   %eax
801056c2:	6a 00                	push   $0x0
801056c4:	e8 d7 f6 ff ff       	call   80104da0 <argstr>
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	85 c0                	test   %eax,%eax
801056ce:	78 30                	js     80105700 <sys_mkdir+0x50>
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d6:	31 c9                	xor    %ecx,%ecx
801056d8:	6a 00                	push   $0x0
801056da:	ba 01 00 00 00       	mov    $0x1,%edx
801056df:	e8 5c f7 ff ff       	call   80104e40 <create>
801056e4:	83 c4 10             	add    $0x10,%esp
801056e7:	85 c0                	test   %eax,%eax
801056e9:	74 15                	je     80105700 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056eb:	83 ec 0c             	sub    $0xc,%esp
801056ee:	50                   	push   %eax
801056ef:	e8 fc c4 ff ff       	call   80101bf0 <iunlockput>
  end_op();
801056f4:	e8 17 d9 ff ff       	call   80103010 <end_op>
  return 0;
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	31 c0                	xor    %eax,%eax
}
801056fe:	c9                   	leave  
801056ff:	c3                   	ret    
    end_op();
80105700:	e8 0b d9 ff ff       	call   80103010 <end_op>
    return -1;
80105705:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105710 <sys_mknod>:

int
sys_mknod(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105716:	e8 85 d8 ff ff       	call   80102fa0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010571b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010571e:	83 ec 08             	sub    $0x8,%esp
80105721:	50                   	push   %eax
80105722:	6a 00                	push   $0x0
80105724:	e8 77 f6 ff ff       	call   80104da0 <argstr>
80105729:	83 c4 10             	add    $0x10,%esp
8010572c:	85 c0                	test   %eax,%eax
8010572e:	78 60                	js     80105790 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105730:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105733:	83 ec 08             	sub    $0x8,%esp
80105736:	50                   	push   %eax
80105737:	6a 01                	push   $0x1
80105739:	e8 b2 f5 ff ff       	call   80104cf0 <argint>
  if((argstr(0, &path)) < 0 ||
8010573e:	83 c4 10             	add    $0x10,%esp
80105741:	85 c0                	test   %eax,%eax
80105743:	78 4b                	js     80105790 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105745:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105748:	83 ec 08             	sub    $0x8,%esp
8010574b:	50                   	push   %eax
8010574c:	6a 02                	push   $0x2
8010574e:	e8 9d f5 ff ff       	call   80104cf0 <argint>
     argint(1, &major) < 0 ||
80105753:	83 c4 10             	add    $0x10,%esp
80105756:	85 c0                	test   %eax,%eax
80105758:	78 36                	js     80105790 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010575a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010575e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105761:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105765:	ba 03 00 00 00       	mov    $0x3,%edx
8010576a:	50                   	push   %eax
8010576b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010576e:	e8 cd f6 ff ff       	call   80104e40 <create>
80105773:	83 c4 10             	add    $0x10,%esp
80105776:	85 c0                	test   %eax,%eax
80105778:	74 16                	je     80105790 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010577a:	83 ec 0c             	sub    $0xc,%esp
8010577d:	50                   	push   %eax
8010577e:	e8 6d c4 ff ff       	call   80101bf0 <iunlockput>
  end_op();
80105783:	e8 88 d8 ff ff       	call   80103010 <end_op>
  return 0;
80105788:	83 c4 10             	add    $0x10,%esp
8010578b:	31 c0                	xor    %eax,%eax
}
8010578d:	c9                   	leave  
8010578e:	c3                   	ret    
8010578f:	90                   	nop
    end_op();
80105790:	e8 7b d8 ff ff       	call   80103010 <end_op>
    return -1;
80105795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010579a:	c9                   	leave  
8010579b:	c3                   	ret    
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057a0 <sys_chdir>:

int
sys_chdir(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	56                   	push   %esi
801057a4:	53                   	push   %ebx
801057a5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057a8:	e8 33 e4 ff ff       	call   80103be0 <myproc>
801057ad:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057af:	e8 ec d7 ff ff       	call   80102fa0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b7:	83 ec 08             	sub    $0x8,%esp
801057ba:	50                   	push   %eax
801057bb:	6a 00                	push   $0x0
801057bd:	e8 de f5 ff ff       	call   80104da0 <argstr>
801057c2:	83 c4 10             	add    $0x10,%esp
801057c5:	85 c0                	test   %eax,%eax
801057c7:	78 77                	js     80105840 <sys_chdir+0xa0>
801057c9:	83 ec 0c             	sub    $0xc,%esp
801057cc:	ff 75 f4             	pushl  -0xc(%ebp)
801057cf:	e8 7c ca ff ff       	call   80102250 <namei>
801057d4:	83 c4 10             	add    $0x10,%esp
801057d7:	85 c0                	test   %eax,%eax
801057d9:	89 c3                	mov    %eax,%ebx
801057db:	74 63                	je     80105840 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057dd:	83 ec 0c             	sub    $0xc,%esp
801057e0:	50                   	push   %eax
801057e1:	e8 7a c1 ff ff       	call   80101960 <ilock>
  if(ip->type != T_DIR){
801057e6:	83 c4 10             	add    $0x10,%esp
801057e9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057ee:	75 30                	jne    80105820 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
801057f3:	53                   	push   %ebx
801057f4:	e8 47 c2 ff ff       	call   80101a40 <iunlock>
  iput(curproc->cwd);
801057f9:	58                   	pop    %eax
801057fa:	ff 76 68             	pushl  0x68(%esi)
801057fd:	e8 8e c2 ff ff       	call   80101a90 <iput>
  end_op();
80105802:	e8 09 d8 ff ff       	call   80103010 <end_op>
  curproc->cwd = ip;
80105807:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	31 c0                	xor    %eax,%eax
}
8010580f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105812:	5b                   	pop    %ebx
80105813:	5e                   	pop    %esi
80105814:	5d                   	pop    %ebp
80105815:	c3                   	ret    
80105816:	8d 76 00             	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	53                   	push   %ebx
80105824:	e8 c7 c3 ff ff       	call   80101bf0 <iunlockput>
    end_op();
80105829:	e8 e2 d7 ff ff       	call   80103010 <end_op>
    return -1;
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105836:	eb d7                	jmp    8010580f <sys_chdir+0x6f>
80105838:	90                   	nop
80105839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105840:	e8 cb d7 ff ff       	call   80103010 <end_op>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584a:	eb c3                	jmp    8010580f <sys_chdir+0x6f>
8010584c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105850 <sys_exec>:

int
sys_exec(void)
{
80105850:	55                   	push   %ebp
80105851:	89 e5                	mov    %esp,%ebp
80105853:	57                   	push   %edi
80105854:	56                   	push   %esi
80105855:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105856:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010585c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105862:	50                   	push   %eax
80105863:	6a 00                	push   $0x0
80105865:	e8 36 f5 ff ff       	call   80104da0 <argstr>
8010586a:	83 c4 10             	add    $0x10,%esp
8010586d:	85 c0                	test   %eax,%eax
8010586f:	0f 88 87 00 00 00    	js     801058fc <sys_exec+0xac>
80105875:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010587b:	83 ec 08             	sub    $0x8,%esp
8010587e:	50                   	push   %eax
8010587f:	6a 01                	push   $0x1
80105881:	e8 6a f4 ff ff       	call   80104cf0 <argint>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	78 6f                	js     801058fc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010588d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105893:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105896:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105898:	68 80 00 00 00       	push   $0x80
8010589d:	6a 00                	push   $0x0
8010589f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801058a5:	50                   	push   %eax
801058a6:	e8 45 f1 ff ff       	call   801049f0 <memset>
801058ab:	83 c4 10             	add    $0x10,%esp
801058ae:	eb 2c                	jmp    801058dc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801058b0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058b6:	85 c0                	test   %eax,%eax
801058b8:	74 56                	je     80105910 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058ba:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801058c6:	52                   	push   %edx
801058c7:	50                   	push   %eax
801058c8:	e8 b3 f3 ff ff       	call   80104c80 <fetchstr>
801058cd:	83 c4 10             	add    $0x10,%esp
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 28                	js     801058fc <sys_exec+0xac>
  for(i=0;; i++){
801058d4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801058d7:	83 fb 20             	cmp    $0x20,%ebx
801058da:	74 20                	je     801058fc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058dc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058e2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801058e9:	83 ec 08             	sub    $0x8,%esp
801058ec:	57                   	push   %edi
801058ed:	01 f0                	add    %esi,%eax
801058ef:	50                   	push   %eax
801058f0:	e8 4b f3 ff ff       	call   80104c40 <fetchint>
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	85 c0                	test   %eax,%eax
801058fa:	79 b4                	jns    801058b0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801058fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801058ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105904:	5b                   	pop    %ebx
80105905:	5e                   	pop    %esi
80105906:	5f                   	pop    %edi
80105907:	5d                   	pop    %ebp
80105908:	c3                   	ret    
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105910:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105916:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105919:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105920:	00 00 00 00 
  return exec(path, argv);
80105924:	50                   	push   %eax
80105925:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010592b:	e8 e0 b0 ff ff       	call   80100a10 <exec>
80105930:	83 c4 10             	add    $0x10,%esp
}
80105933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105936:	5b                   	pop    %ebx
80105937:	5e                   	pop    %esi
80105938:	5f                   	pop    %edi
80105939:	5d                   	pop    %ebp
8010593a:	c3                   	ret    
8010593b:	90                   	nop
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_pipe>:

int
sys_pipe(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105946:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105949:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010594c:	6a 08                	push   $0x8
8010594e:	50                   	push   %eax
8010594f:	6a 00                	push   $0x0
80105951:	e8 ea f3 ff ff       	call   80104d40 <argptr>
80105956:	83 c4 10             	add    $0x10,%esp
80105959:	85 c0                	test   %eax,%eax
8010595b:	0f 88 ae 00 00 00    	js     80105a0f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105961:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105964:	83 ec 08             	sub    $0x8,%esp
80105967:	50                   	push   %eax
80105968:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010596b:	50                   	push   %eax
8010596c:	e8 cf dc ff ff       	call   80103640 <pipealloc>
80105971:	83 c4 10             	add    $0x10,%esp
80105974:	85 c0                	test   %eax,%eax
80105976:	0f 88 93 00 00 00    	js     80105a0f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010597c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010597f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105981:	e8 5a e2 ff ff       	call   80103be0 <myproc>
80105986:	eb 10                	jmp    80105998 <sys_pipe+0x58>
80105988:	90                   	nop
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105990:	83 c3 01             	add    $0x1,%ebx
80105993:	83 fb 10             	cmp    $0x10,%ebx
80105996:	74 60                	je     801059f8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105998:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010599c:	85 f6                	test   %esi,%esi
8010599e:	75 f0                	jne    80105990 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801059a0:	8d 73 08             	lea    0x8(%ebx),%esi
801059a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059aa:	e8 31 e2 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801059af:	31 d2                	xor    %edx,%edx
801059b1:	eb 0d                	jmp    801059c0 <sys_pipe+0x80>
801059b3:	90                   	nop
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059b8:	83 c2 01             	add    $0x1,%edx
801059bb:	83 fa 10             	cmp    $0x10,%edx
801059be:	74 28                	je     801059e8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801059c0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801059c4:	85 c9                	test   %ecx,%ecx
801059c6:	75 f0                	jne    801059b8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801059c8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801059cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059cf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801059d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801059d4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801059d7:	31 c0                	xor    %eax,%eax
}
801059d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059dc:	5b                   	pop    %ebx
801059dd:	5e                   	pop    %esi
801059de:	5f                   	pop    %edi
801059df:	5d                   	pop    %ebp
801059e0:	c3                   	ret    
801059e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801059e8:	e8 f3 e1 ff ff       	call   80103be0 <myproc>
801059ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059f4:	00 
801059f5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801059f8:	83 ec 0c             	sub    $0xc,%esp
801059fb:	ff 75 e0             	pushl  -0x20(%ebp)
801059fe:	e8 ad b5 ff ff       	call   80100fb0 <fileclose>
    fileclose(wf);
80105a03:	58                   	pop    %eax
80105a04:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a07:	e8 a4 b5 ff ff       	call   80100fb0 <fileclose>
    return -1;
80105a0c:	83 c4 10             	add    $0x10,%esp
80105a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a14:	eb c3                	jmp    801059d9 <sys_pipe+0x99>
80105a16:	66 90                	xchg   %ax,%ax
80105a18:	66 90                	xchg   %ax,%ax
80105a1a:	66 90                	xchg   %ax,%ax
80105a1c:	66 90                	xchg   %ax,%ax
80105a1e:	66 90                	xchg   %ax,%ax

80105a20 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105a23:	5d                   	pop    %ebp
  return fork();
80105a24:	e9 57 e3 ff ff       	jmp    80103d80 <fork>
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_exit>:

int
sys_exit(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a36:	e8 c5 e5 ff ff       	call   80104000 <exit>
  return 0;  // not reached
}
80105a3b:	31 c0                	xor    %eax,%eax
80105a3d:	c9                   	leave  
80105a3e:	c3                   	ret    
80105a3f:	90                   	nop

80105a40 <sys_wait>:

int
sys_wait(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105a43:	5d                   	pop    %ebp
  return wait();
80105a44:	e9 f7 e7 ff ff       	jmp    80104240 <wait>
80105a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_kill>:

int
sys_kill(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a59:	50                   	push   %eax
80105a5a:	6a 00                	push   $0x0
80105a5c:	e8 8f f2 ff ff       	call   80104cf0 <argint>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	78 18                	js     80105a80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a68:	83 ec 0c             	sub    $0xc,%esp
80105a6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6e:	e8 1d e9 ff ff       	call   80104390 <kill>
80105a73:	83 c4 10             	add    $0x10,%esp
}
80105a76:	c9                   	leave  
80105a77:	c3                   	ret    
80105a78:	90                   	nop
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a85:	c9                   	leave  
80105a86:	c3                   	ret    
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a90 <sys_getpid>:

int
sys_getpid(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a96:	e8 45 e1 ff ff       	call   80103be0 <myproc>
80105a9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a9e:	c9                   	leave  
80105a9f:	c3                   	ret    

80105aa0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105aa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aaa:	50                   	push   %eax
80105aab:	6a 00                	push   $0x0
80105aad:	e8 3e f2 ff ff       	call   80104cf0 <argint>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	78 27                	js     80105ae0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ab9:	e8 22 e1 ff ff       	call   80103be0 <myproc>
  if(growproc(n) < 0)
80105abe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ac1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ac3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac6:	e8 35 e2 ff ff       	call   80103d00 <growproc>
80105acb:	83 c4 10             	add    $0x10,%esp
80105ace:	85 c0                	test   %eax,%eax
80105ad0:	78 0e                	js     80105ae0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ad2:	89 d8                	mov    %ebx,%eax
80105ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad7:	c9                   	leave  
80105ad8:	c3                   	ret    
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ae0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ae5:	eb eb                	jmp    80105ad2 <sys_sbrk+0x32>
80105ae7:	89 f6                	mov    %esi,%esi
80105ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105af0 <sys_sleep>:

int
sys_sleep(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105af7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 ee f1 ff ff       	call   80104cf0 <argint>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	0f 88 8a 00 00 00    	js     80105b97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	68 c0 6c 11 80       	push   $0x80116cc0
80105b15:	e8 c6 ed ff ff       	call   801048e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b1d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105b20:	8b 1d 00 75 11 80    	mov    0x80117500,%ebx
  while(ticks - ticks0 < n){
80105b26:	85 d2                	test   %edx,%edx
80105b28:	75 27                	jne    80105b51 <sys_sleep+0x61>
80105b2a:	eb 54                	jmp    80105b80 <sys_sleep+0x90>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	68 c0 6c 11 80       	push   $0x80116cc0
80105b38:	68 00 75 11 80       	push   $0x80117500
80105b3d:	e8 3e e6 ff ff       	call   80104180 <sleep>
  while(ticks - ticks0 < n){
80105b42:	a1 00 75 11 80       	mov    0x80117500,%eax
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	29 d8                	sub    %ebx,%eax
80105b4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b4f:	73 2f                	jae    80105b80 <sys_sleep+0x90>
    if(myproc()->killed){
80105b51:	e8 8a e0 ff ff       	call   80103be0 <myproc>
80105b56:	8b 40 24             	mov    0x24(%eax),%eax
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 d3                	je     80105b30 <sys_sleep+0x40>
      release(&tickslock);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	68 c0 6c 11 80       	push   $0x80116cc0
80105b65:	e8 36 ee ff ff       	call   801049a0 <release>
      return -1;
80105b6a:	83 c4 10             	add    $0x10,%esp
80105b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105b72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	68 c0 6c 11 80       	push   $0x80116cc0
80105b88:	e8 13 ee ff ff       	call   801049a0 <release>
  return 0;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	31 c0                	xor    %eax,%eax
}
80105b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
    return -1;
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	eb f4                	jmp    80105b92 <sys_sleep+0xa2>
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
80105ba4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ba7:	68 c0 6c 11 80       	push   $0x80116cc0
80105bac:	e8 2f ed ff ff       	call   801048e0 <acquire>
  xticks = ticks;
80105bb1:	8b 1d 00 75 11 80    	mov    0x80117500,%ebx
  release(&tickslock);
80105bb7:	c7 04 24 c0 6c 11 80 	movl   $0x80116cc0,(%esp)
80105bbe:	e8 dd ed ff ff       	call   801049a0 <release>
  return xticks;
}
80105bc3:	89 d8                	mov    %ebx,%eax
80105bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc8:	c9                   	leave  
80105bc9:	c3                   	ret    
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bd0 <sys_getProc>:


struct proc*
sys_getProc(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105bd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bd9:	50                   	push   %eax
80105bda:	6a 00                	push   $0x0
80105bdc:	e8 0f f1 ff ff       	call   80104cf0 <argint>
80105be1:	83 c4 10             	add    $0x10,%esp
80105be4:	85 c0                	test   %eax,%eax
80105be6:	78 18                	js     80105c00 <sys_getProc+0x30>
    return 0;
  return getProc(pid);
80105be8:	83 ec 0c             	sub    $0xc,%esp
80105beb:	ff 75 f4             	pushl  -0xc(%ebp)
80105bee:	e8 2d ea ff ff       	call   80104620 <getProc>
80105bf3:	83 c4 10             	add    $0x10,%esp
}
80105bf6:	c9                   	leave  
80105bf7:	c3                   	ret    
80105bf8:	90                   	nop
80105bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80105c00:	31 c0                	xor    %eax,%eax
}
80105c02:	c9                   	leave  
80105c03:	c3                   	ret    
80105c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105c10 <sys_lsndFS>:

int
sys_lsndFS(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	83 ec 08             	sub    $0x8,%esp
  lsndFS();
80105c16:	e8 95 ba ff ff       	call   801016b0 <lsndFS>
  return 0;
80105c1b:	31 c0                	xor    %eax,%eax
80105c1d:	c9                   	leave  
80105c1e:	c3                   	ret    

80105c1f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105c1f:	1e                   	push   %ds
  pushl %es
80105c20:	06                   	push   %es
  pushl %fs
80105c21:	0f a0                	push   %fs
  pushl %gs
80105c23:	0f a8                	push   %gs
  pushal
80105c25:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105c26:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105c2a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105c2c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105c2e:	54                   	push   %esp
  call trap
80105c2f:	e8 cc 00 00 00       	call   80105d00 <trap>
  addl $4, %esp
80105c34:	83 c4 04             	add    $0x4,%esp

80105c37 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105c37:	61                   	popa   
  popl %gs
80105c38:	0f a9                	pop    %gs
  popl %fs
80105c3a:	0f a1                	pop    %fs
  popl %es
80105c3c:	07                   	pop    %es
  popl %ds
80105c3d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105c3e:	83 c4 08             	add    $0x8,%esp
  iret
80105c41:	cf                   	iret   
80105c42:	66 90                	xchg   %ax,%ax
80105c44:	66 90                	xchg   %ax,%ax
80105c46:	66 90                	xchg   %ax,%ax
80105c48:	66 90                	xchg   %ax,%ax
80105c4a:	66 90                	xchg   %ax,%ax
80105c4c:	66 90                	xchg   %ax,%ax
80105c4e:	66 90                	xchg   %ax,%ax

80105c50 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105c50:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105c51:	31 c0                	xor    %eax,%eax
{
80105c53:	89 e5                	mov    %esp,%ebp
80105c55:	83 ec 08             	sub    $0x8,%esp
80105c58:	90                   	nop
80105c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105c60:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80105c67:	c7 04 c5 02 6d 11 80 	movl   $0x8e000008,-0x7fee92fe(,%eax,8)
80105c6e:	08 00 00 8e 
80105c72:	66 89 14 c5 00 6d 11 	mov    %dx,-0x7fee9300(,%eax,8)
80105c79:	80 
80105c7a:	c1 ea 10             	shr    $0x10,%edx
80105c7d:	66 89 14 c5 06 6d 11 	mov    %dx,-0x7fee92fa(,%eax,8)
80105c84:	80 
  for(i = 0; i < 256; i++)
80105c85:	83 c0 01             	add    $0x1,%eax
80105c88:	3d 00 01 00 00       	cmp    $0x100,%eax
80105c8d:	75 d1                	jne    80105c60 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c8f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80105c94:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105c97:	c7 05 02 6f 11 80 08 	movl   $0xef000008,0x80116f02
80105c9e:	00 00 ef 
  initlock(&tickslock, "time");
80105ca1:	68 01 92 10 80       	push   $0x80109201
80105ca6:	68 c0 6c 11 80       	push   $0x80116cc0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105cab:	66 a3 00 6f 11 80    	mov    %ax,0x80116f00
80105cb1:	c1 e8 10             	shr    $0x10,%eax
80105cb4:	66 a3 06 6f 11 80    	mov    %ax,0x80116f06
  initlock(&tickslock, "time");
80105cba:	e8 e1 ea ff ff       	call   801047a0 <initlock>
}
80105cbf:	83 c4 10             	add    $0x10,%esp
80105cc2:	c9                   	leave  
80105cc3:	c3                   	ret    
80105cc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105cd0 <idtinit>:

void
idtinit(void)
{
80105cd0:	55                   	push   %ebp
  pd[0] = size-1;
80105cd1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105cd6:	89 e5                	mov    %esp,%ebp
80105cd8:	83 ec 10             	sub    $0x10,%esp
80105cdb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105cdf:	b8 00 6d 11 80       	mov    $0x80116d00,%eax
80105ce4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ce8:	c1 e8 10             	shr    $0x10,%eax
80105ceb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105cef:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105cf2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    
80105cf7:	89 f6                	mov    %esi,%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d00 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
80105d06:	83 ec 1c             	sub    $0x1c,%esp
80105d09:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105d0c:	8b 47 30             	mov    0x30(%edi),%eax
80105d0f:	83 f8 40             	cmp    $0x40,%eax
80105d12:	0f 84 f0 00 00 00    	je     80105e08 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105d18:	83 e8 20             	sub    $0x20,%eax
80105d1b:	83 f8 1f             	cmp    $0x1f,%eax
80105d1e:	77 10                	ja     80105d30 <trap+0x30>
80105d20:	ff 24 85 a8 92 10 80 	jmp    *-0x7fef6d58(,%eax,4)
80105d27:	89 f6                	mov    %esi,%esi
80105d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105d30:	e8 ab de ff ff       	call   80103be0 <myproc>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	8b 5f 38             	mov    0x38(%edi),%ebx
80105d3a:	0f 84 14 02 00 00    	je     80105f54 <trap+0x254>
80105d40:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105d44:	0f 84 0a 02 00 00    	je     80105f54 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105d4a:	0f 20 d1             	mov    %cr2,%ecx
80105d4d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d50:	e8 6b de ff ff       	call   80103bc0 <cpuid>
80105d55:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105d58:	8b 47 34             	mov    0x34(%edi),%eax
80105d5b:	8b 77 30             	mov    0x30(%edi),%esi
80105d5e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105d61:	e8 7a de ff ff       	call   80103be0 <myproc>
80105d66:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d69:	e8 72 de ff ff       	call   80103be0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d6e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105d71:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105d74:	51                   	push   %ecx
80105d75:	53                   	push   %ebx
80105d76:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105d77:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d7a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d7d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105d7e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105d81:	52                   	push   %edx
80105d82:	ff 70 10             	pushl  0x10(%eax)
80105d85:	68 64 92 10 80       	push   $0x80109264
80105d8a:	e8 d1 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105d8f:	83 c4 20             	add    $0x20,%esp
80105d92:	e8 49 de ff ff       	call   80103be0 <myproc>
80105d97:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d9e:	e8 3d de ff ff       	call   80103be0 <myproc>
80105da3:	85 c0                	test   %eax,%eax
80105da5:	74 1d                	je     80105dc4 <trap+0xc4>
80105da7:	e8 34 de ff ff       	call   80103be0 <myproc>
80105dac:	8b 50 24             	mov    0x24(%eax),%edx
80105daf:	85 d2                	test   %edx,%edx
80105db1:	74 11                	je     80105dc4 <trap+0xc4>
80105db3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105db7:	83 e0 03             	and    $0x3,%eax
80105dba:	66 83 f8 03          	cmp    $0x3,%ax
80105dbe:	0f 84 4c 01 00 00    	je     80105f10 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105dc4:	e8 17 de ff ff       	call   80103be0 <myproc>
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	74 0b                	je     80105dd8 <trap+0xd8>
80105dcd:	e8 0e de ff ff       	call   80103be0 <myproc>
80105dd2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105dd6:	74 68                	je     80105e40 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105dd8:	e8 03 de ff ff       	call   80103be0 <myproc>
80105ddd:	85 c0                	test   %eax,%eax
80105ddf:	74 19                	je     80105dfa <trap+0xfa>
80105de1:	e8 fa dd ff ff       	call   80103be0 <myproc>
80105de6:	8b 40 24             	mov    0x24(%eax),%eax
80105de9:	85 c0                	test   %eax,%eax
80105deb:	74 0d                	je     80105dfa <trap+0xfa>
80105ded:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105df1:	83 e0 03             	and    $0x3,%eax
80105df4:	66 83 f8 03          	cmp    $0x3,%ax
80105df8:	74 37                	je     80105e31 <trap+0x131>
    exit();
}
80105dfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dfd:	5b                   	pop    %ebx
80105dfe:	5e                   	pop    %esi
80105dff:	5f                   	pop    %edi
80105e00:	5d                   	pop    %ebp
80105e01:	c3                   	ret    
80105e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105e08:	e8 d3 dd ff ff       	call   80103be0 <myproc>
80105e0d:	8b 58 24             	mov    0x24(%eax),%ebx
80105e10:	85 db                	test   %ebx,%ebx
80105e12:	0f 85 e8 00 00 00    	jne    80105f00 <trap+0x200>
    myproc()->tf = tf;
80105e18:	e8 c3 dd ff ff       	call   80103be0 <myproc>
80105e1d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105e20:	e8 bb ef ff ff       	call   80104de0 <syscall>
    if(myproc()->killed)
80105e25:	e8 b6 dd ff ff       	call   80103be0 <myproc>
80105e2a:	8b 48 24             	mov    0x24(%eax),%ecx
80105e2d:	85 c9                	test   %ecx,%ecx
80105e2f:	74 c9                	je     80105dfa <trap+0xfa>
}
80105e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e34:	5b                   	pop    %ebx
80105e35:	5e                   	pop    %esi
80105e36:	5f                   	pop    %edi
80105e37:	5d                   	pop    %ebp
      exit();
80105e38:	e9 c3 e1 ff ff       	jmp    80104000 <exit>
80105e3d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105e40:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105e44:	75 92                	jne    80105dd8 <trap+0xd8>
    yield();
80105e46:	e8 e5 e2 ff ff       	call   80104130 <yield>
80105e4b:	eb 8b                	jmp    80105dd8 <trap+0xd8>
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105e50:	e8 6b dd ff ff       	call   80103bc0 <cpuid>
80105e55:	85 c0                	test   %eax,%eax
80105e57:	0f 84 c3 00 00 00    	je     80105f20 <trap+0x220>
    lapiceoi();
80105e5d:	e8 ee cc ff ff       	call   80102b50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e62:	e8 79 dd ff ff       	call   80103be0 <myproc>
80105e67:	85 c0                	test   %eax,%eax
80105e69:	0f 85 38 ff ff ff    	jne    80105da7 <trap+0xa7>
80105e6f:	e9 50 ff ff ff       	jmp    80105dc4 <trap+0xc4>
80105e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105e78:	e8 93 cb ff ff       	call   80102a10 <kbdintr>
    lapiceoi();
80105e7d:	e8 ce cc ff ff       	call   80102b50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e82:	e8 59 dd ff ff       	call   80103be0 <myproc>
80105e87:	85 c0                	test   %eax,%eax
80105e89:	0f 85 18 ff ff ff    	jne    80105da7 <trap+0xa7>
80105e8f:	e9 30 ff ff ff       	jmp    80105dc4 <trap+0xc4>
80105e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105e98:	e8 53 02 00 00       	call   801060f0 <uartintr>
    lapiceoi();
80105e9d:	e8 ae cc ff ff       	call   80102b50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ea2:	e8 39 dd ff ff       	call   80103be0 <myproc>
80105ea7:	85 c0                	test   %eax,%eax
80105ea9:	0f 85 f8 fe ff ff    	jne    80105da7 <trap+0xa7>
80105eaf:	e9 10 ff ff ff       	jmp    80105dc4 <trap+0xc4>
80105eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105eb8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105ebc:	8b 77 38             	mov    0x38(%edi),%esi
80105ebf:	e8 fc dc ff ff       	call   80103bc0 <cpuid>
80105ec4:	56                   	push   %esi
80105ec5:	53                   	push   %ebx
80105ec6:	50                   	push   %eax
80105ec7:	68 0c 92 10 80       	push   $0x8010920c
80105ecc:	e8 8f a7 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105ed1:	e8 7a cc ff ff       	call   80102b50 <lapiceoi>
    break;
80105ed6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ed9:	e8 02 dd ff ff       	call   80103be0 <myproc>
80105ede:	85 c0                	test   %eax,%eax
80105ee0:	0f 85 c1 fe ff ff    	jne    80105da7 <trap+0xa7>
80105ee6:	e9 d9 fe ff ff       	jmp    80105dc4 <trap+0xc4>
80105eeb:	90                   	nop
80105eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105ef0:	e8 fb c4 ff ff       	call   801023f0 <ideintr>
80105ef5:	e9 63 ff ff ff       	jmp    80105e5d <trap+0x15d>
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105f00:	e8 fb e0 ff ff       	call   80104000 <exit>
80105f05:	e9 0e ff ff ff       	jmp    80105e18 <trap+0x118>
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105f10:	e8 eb e0 ff ff       	call   80104000 <exit>
80105f15:	e9 aa fe ff ff       	jmp    80105dc4 <trap+0xc4>
80105f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	68 c0 6c 11 80       	push   $0x80116cc0
80105f28:	e8 b3 e9 ff ff       	call   801048e0 <acquire>
      wakeup(&ticks);
80105f2d:	c7 04 24 00 75 11 80 	movl   $0x80117500,(%esp)
      ticks++;
80105f34:	83 05 00 75 11 80 01 	addl   $0x1,0x80117500
      wakeup(&ticks);
80105f3b:	e8 f0 e3 ff ff       	call   80104330 <wakeup>
      release(&tickslock);
80105f40:	c7 04 24 c0 6c 11 80 	movl   $0x80116cc0,(%esp)
80105f47:	e8 54 ea ff ff       	call   801049a0 <release>
80105f4c:	83 c4 10             	add    $0x10,%esp
80105f4f:	e9 09 ff ff ff       	jmp    80105e5d <trap+0x15d>
80105f54:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105f57:	e8 64 dc ff ff       	call   80103bc0 <cpuid>
80105f5c:	83 ec 0c             	sub    $0xc,%esp
80105f5f:	56                   	push   %esi
80105f60:	53                   	push   %ebx
80105f61:	50                   	push   %eax
80105f62:	ff 77 30             	pushl  0x30(%edi)
80105f65:	68 30 92 10 80       	push   $0x80109230
80105f6a:	e8 f1 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105f6f:	83 c4 14             	add    $0x14,%esp
80105f72:	68 06 92 10 80       	push   $0x80109206
80105f77:	e8 14 a4 ff ff       	call   80100390 <panic>
80105f7c:	66 90                	xchg   %ax,%ax
80105f7e:	66 90                	xchg   %ax,%ax

80105f80 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105f80:	a1 bc c5 10 80       	mov    0x8010c5bc,%eax
{
80105f85:	55                   	push   %ebp
80105f86:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	74 1c                	je     80105fa8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f8c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f91:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105f92:	a8 01                	test   $0x1,%al
80105f94:	74 12                	je     80105fa8 <uartgetc+0x28>
80105f96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f9b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105f9c:	0f b6 c0             	movzbl %al,%eax
}
80105f9f:	5d                   	pop    %ebp
80105fa0:	c3                   	ret    
80105fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105fa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fad:	5d                   	pop    %ebp
80105fae:	c3                   	ret    
80105faf:	90                   	nop

80105fb0 <uartputc.part.0>:
uartputc(int c)
80105fb0:	55                   	push   %ebp
80105fb1:	89 e5                	mov    %esp,%ebp
80105fb3:	57                   	push   %edi
80105fb4:	56                   	push   %esi
80105fb5:	53                   	push   %ebx
80105fb6:	89 c7                	mov    %eax,%edi
80105fb8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105fbd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105fc2:	83 ec 0c             	sub    $0xc,%esp
80105fc5:	eb 1b                	jmp    80105fe2 <uartputc.part.0+0x32>
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	6a 0a                	push   $0xa
80105fd5:	e8 96 cb ff ff       	call   80102b70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105fda:	83 c4 10             	add    $0x10,%esp
80105fdd:	83 eb 01             	sub    $0x1,%ebx
80105fe0:	74 07                	je     80105fe9 <uartputc.part.0+0x39>
80105fe2:	89 f2                	mov    %esi,%edx
80105fe4:	ec                   	in     (%dx),%al
80105fe5:	a8 20                	test   $0x20,%al
80105fe7:	74 e7                	je     80105fd0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105fe9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105fee:	89 f8                	mov    %edi,%eax
80105ff0:	ee                   	out    %al,(%dx)
}
80105ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ff4:	5b                   	pop    %ebx
80105ff5:	5e                   	pop    %esi
80105ff6:	5f                   	pop    %edi
80105ff7:	5d                   	pop    %ebp
80105ff8:	c3                   	ret    
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <uartinit>:
{
80106000:	55                   	push   %ebp
80106001:	31 c9                	xor    %ecx,%ecx
80106003:	89 c8                	mov    %ecx,%eax
80106005:	89 e5                	mov    %esp,%ebp
80106007:	57                   	push   %edi
80106008:	56                   	push   %esi
80106009:	53                   	push   %ebx
8010600a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010600f:	89 da                	mov    %ebx,%edx
80106011:	83 ec 0c             	sub    $0xc,%esp
80106014:	ee                   	out    %al,(%dx)
80106015:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010601a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010601f:	89 fa                	mov    %edi,%edx
80106021:	ee                   	out    %al,(%dx)
80106022:	b8 0c 00 00 00       	mov    $0xc,%eax
80106027:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010602c:	ee                   	out    %al,(%dx)
8010602d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106032:	89 c8                	mov    %ecx,%eax
80106034:	89 f2                	mov    %esi,%edx
80106036:	ee                   	out    %al,(%dx)
80106037:	b8 03 00 00 00       	mov    $0x3,%eax
8010603c:	89 fa                	mov    %edi,%edx
8010603e:	ee                   	out    %al,(%dx)
8010603f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106044:	89 c8                	mov    %ecx,%eax
80106046:	ee                   	out    %al,(%dx)
80106047:	b8 01 00 00 00       	mov    $0x1,%eax
8010604c:	89 f2                	mov    %esi,%edx
8010604e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010604f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106054:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106055:	3c ff                	cmp    $0xff,%al
80106057:	74 5a                	je     801060b3 <uartinit+0xb3>
  uart = 1;
80106059:	c7 05 bc c5 10 80 01 	movl   $0x1,0x8010c5bc
80106060:	00 00 00 
80106063:	89 da                	mov    %ebx,%edx
80106065:	ec                   	in     (%dx),%al
80106066:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010606b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010606c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010606f:	bb 28 93 10 80       	mov    $0x80109328,%ebx
  ioapicenable(IRQ_COM1, 0);
80106074:	6a 00                	push   $0x0
80106076:	6a 04                	push   $0x4
80106078:	e8 53 c6 ff ff       	call   801026d0 <ioapicenable>
8010607d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106080:	b8 78 00 00 00       	mov    $0x78,%eax
80106085:	eb 13                	jmp    8010609a <uartinit+0x9a>
80106087:	89 f6                	mov    %esi,%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106090:	83 c3 01             	add    $0x1,%ebx
80106093:	0f be 03             	movsbl (%ebx),%eax
80106096:	84 c0                	test   %al,%al
80106098:	74 19                	je     801060b3 <uartinit+0xb3>
  if(!uart)
8010609a:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
801060a0:	85 d2                	test   %edx,%edx
801060a2:	74 ec                	je     80106090 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801060a4:	83 c3 01             	add    $0x1,%ebx
801060a7:	e8 04 ff ff ff       	call   80105fb0 <uartputc.part.0>
801060ac:	0f be 03             	movsbl (%ebx),%eax
801060af:	84 c0                	test   %al,%al
801060b1:	75 e7                	jne    8010609a <uartinit+0x9a>
}
801060b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b6:	5b                   	pop    %ebx
801060b7:	5e                   	pop    %esi
801060b8:	5f                   	pop    %edi
801060b9:	5d                   	pop    %ebp
801060ba:	c3                   	ret    
801060bb:	90                   	nop
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <uartputc>:
  if(!uart)
801060c0:	8b 15 bc c5 10 80    	mov    0x8010c5bc,%edx
{
801060c6:	55                   	push   %ebp
801060c7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801060c9:	85 d2                	test   %edx,%edx
{
801060cb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801060ce:	74 10                	je     801060e0 <uartputc+0x20>
}
801060d0:	5d                   	pop    %ebp
801060d1:	e9 da fe ff ff       	jmp    80105fb0 <uartputc.part.0>
801060d6:	8d 76 00             	lea    0x0(%esi),%esi
801060d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801060e0:	5d                   	pop    %ebp
801060e1:	c3                   	ret    
801060e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060f0 <uartintr>:

void
uartintr(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801060f6:	68 80 5f 10 80       	push   $0x80105f80
801060fb:	e8 10 a7 ff ff       	call   80100810 <consoleintr>
}
80106100:	83 c4 10             	add    $0x10,%esp
80106103:	c9                   	leave  
80106104:	c3                   	ret    

80106105 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106105:	6a 00                	push   $0x0
  pushl $0
80106107:	6a 00                	push   $0x0
  jmp alltraps
80106109:	e9 11 fb ff ff       	jmp    80105c1f <alltraps>

8010610e <vector1>:
.globl vector1
vector1:
  pushl $0
8010610e:	6a 00                	push   $0x0
  pushl $1
80106110:	6a 01                	push   $0x1
  jmp alltraps
80106112:	e9 08 fb ff ff       	jmp    80105c1f <alltraps>

80106117 <vector2>:
.globl vector2
vector2:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $2
80106119:	6a 02                	push   $0x2
  jmp alltraps
8010611b:	e9 ff fa ff ff       	jmp    80105c1f <alltraps>

80106120 <vector3>:
.globl vector3
vector3:
  pushl $0
80106120:	6a 00                	push   $0x0
  pushl $3
80106122:	6a 03                	push   $0x3
  jmp alltraps
80106124:	e9 f6 fa ff ff       	jmp    80105c1f <alltraps>

80106129 <vector4>:
.globl vector4
vector4:
  pushl $0
80106129:	6a 00                	push   $0x0
  pushl $4
8010612b:	6a 04                	push   $0x4
  jmp alltraps
8010612d:	e9 ed fa ff ff       	jmp    80105c1f <alltraps>

80106132 <vector5>:
.globl vector5
vector5:
  pushl $0
80106132:	6a 00                	push   $0x0
  pushl $5
80106134:	6a 05                	push   $0x5
  jmp alltraps
80106136:	e9 e4 fa ff ff       	jmp    80105c1f <alltraps>

8010613b <vector6>:
.globl vector6
vector6:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $6
8010613d:	6a 06                	push   $0x6
  jmp alltraps
8010613f:	e9 db fa ff ff       	jmp    80105c1f <alltraps>

80106144 <vector7>:
.globl vector7
vector7:
  pushl $0
80106144:	6a 00                	push   $0x0
  pushl $7
80106146:	6a 07                	push   $0x7
  jmp alltraps
80106148:	e9 d2 fa ff ff       	jmp    80105c1f <alltraps>

8010614d <vector8>:
.globl vector8
vector8:
  pushl $8
8010614d:	6a 08                	push   $0x8
  jmp alltraps
8010614f:	e9 cb fa ff ff       	jmp    80105c1f <alltraps>

80106154 <vector9>:
.globl vector9
vector9:
  pushl $0
80106154:	6a 00                	push   $0x0
  pushl $9
80106156:	6a 09                	push   $0x9
  jmp alltraps
80106158:	e9 c2 fa ff ff       	jmp    80105c1f <alltraps>

8010615d <vector10>:
.globl vector10
vector10:
  pushl $10
8010615d:	6a 0a                	push   $0xa
  jmp alltraps
8010615f:	e9 bb fa ff ff       	jmp    80105c1f <alltraps>

80106164 <vector11>:
.globl vector11
vector11:
  pushl $11
80106164:	6a 0b                	push   $0xb
  jmp alltraps
80106166:	e9 b4 fa ff ff       	jmp    80105c1f <alltraps>

8010616b <vector12>:
.globl vector12
vector12:
  pushl $12
8010616b:	6a 0c                	push   $0xc
  jmp alltraps
8010616d:	e9 ad fa ff ff       	jmp    80105c1f <alltraps>

80106172 <vector13>:
.globl vector13
vector13:
  pushl $13
80106172:	6a 0d                	push   $0xd
  jmp alltraps
80106174:	e9 a6 fa ff ff       	jmp    80105c1f <alltraps>

80106179 <vector14>:
.globl vector14
vector14:
  pushl $14
80106179:	6a 0e                	push   $0xe
  jmp alltraps
8010617b:	e9 9f fa ff ff       	jmp    80105c1f <alltraps>

80106180 <vector15>:
.globl vector15
vector15:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $15
80106182:	6a 0f                	push   $0xf
  jmp alltraps
80106184:	e9 96 fa ff ff       	jmp    80105c1f <alltraps>

80106189 <vector16>:
.globl vector16
vector16:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $16
8010618b:	6a 10                	push   $0x10
  jmp alltraps
8010618d:	e9 8d fa ff ff       	jmp    80105c1f <alltraps>

80106192 <vector17>:
.globl vector17
vector17:
  pushl $17
80106192:	6a 11                	push   $0x11
  jmp alltraps
80106194:	e9 86 fa ff ff       	jmp    80105c1f <alltraps>

80106199 <vector18>:
.globl vector18
vector18:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $18
8010619b:	6a 12                	push   $0x12
  jmp alltraps
8010619d:	e9 7d fa ff ff       	jmp    80105c1f <alltraps>

801061a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $19
801061a4:	6a 13                	push   $0x13
  jmp alltraps
801061a6:	e9 74 fa ff ff       	jmp    80105c1f <alltraps>

801061ab <vector20>:
.globl vector20
vector20:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $20
801061ad:	6a 14                	push   $0x14
  jmp alltraps
801061af:	e9 6b fa ff ff       	jmp    80105c1f <alltraps>

801061b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $21
801061b6:	6a 15                	push   $0x15
  jmp alltraps
801061b8:	e9 62 fa ff ff       	jmp    80105c1f <alltraps>

801061bd <vector22>:
.globl vector22
vector22:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $22
801061bf:	6a 16                	push   $0x16
  jmp alltraps
801061c1:	e9 59 fa ff ff       	jmp    80105c1f <alltraps>

801061c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $23
801061c8:	6a 17                	push   $0x17
  jmp alltraps
801061ca:	e9 50 fa ff ff       	jmp    80105c1f <alltraps>

801061cf <vector24>:
.globl vector24
vector24:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $24
801061d1:	6a 18                	push   $0x18
  jmp alltraps
801061d3:	e9 47 fa ff ff       	jmp    80105c1f <alltraps>

801061d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $25
801061da:	6a 19                	push   $0x19
  jmp alltraps
801061dc:	e9 3e fa ff ff       	jmp    80105c1f <alltraps>

801061e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $26
801061e3:	6a 1a                	push   $0x1a
  jmp alltraps
801061e5:	e9 35 fa ff ff       	jmp    80105c1f <alltraps>

801061ea <vector27>:
.globl vector27
vector27:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $27
801061ec:	6a 1b                	push   $0x1b
  jmp alltraps
801061ee:	e9 2c fa ff ff       	jmp    80105c1f <alltraps>

801061f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $28
801061f5:	6a 1c                	push   $0x1c
  jmp alltraps
801061f7:	e9 23 fa ff ff       	jmp    80105c1f <alltraps>

801061fc <vector29>:
.globl vector29
vector29:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $29
801061fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106200:	e9 1a fa ff ff       	jmp    80105c1f <alltraps>

80106205 <vector30>:
.globl vector30
vector30:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $30
80106207:	6a 1e                	push   $0x1e
  jmp alltraps
80106209:	e9 11 fa ff ff       	jmp    80105c1f <alltraps>

8010620e <vector31>:
.globl vector31
vector31:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $31
80106210:	6a 1f                	push   $0x1f
  jmp alltraps
80106212:	e9 08 fa ff ff       	jmp    80105c1f <alltraps>

80106217 <vector32>:
.globl vector32
vector32:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $32
80106219:	6a 20                	push   $0x20
  jmp alltraps
8010621b:	e9 ff f9 ff ff       	jmp    80105c1f <alltraps>

80106220 <vector33>:
.globl vector33
vector33:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $33
80106222:	6a 21                	push   $0x21
  jmp alltraps
80106224:	e9 f6 f9 ff ff       	jmp    80105c1f <alltraps>

80106229 <vector34>:
.globl vector34
vector34:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $34
8010622b:	6a 22                	push   $0x22
  jmp alltraps
8010622d:	e9 ed f9 ff ff       	jmp    80105c1f <alltraps>

80106232 <vector35>:
.globl vector35
vector35:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $35
80106234:	6a 23                	push   $0x23
  jmp alltraps
80106236:	e9 e4 f9 ff ff       	jmp    80105c1f <alltraps>

8010623b <vector36>:
.globl vector36
vector36:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $36
8010623d:	6a 24                	push   $0x24
  jmp alltraps
8010623f:	e9 db f9 ff ff       	jmp    80105c1f <alltraps>

80106244 <vector37>:
.globl vector37
vector37:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $37
80106246:	6a 25                	push   $0x25
  jmp alltraps
80106248:	e9 d2 f9 ff ff       	jmp    80105c1f <alltraps>

8010624d <vector38>:
.globl vector38
vector38:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $38
8010624f:	6a 26                	push   $0x26
  jmp alltraps
80106251:	e9 c9 f9 ff ff       	jmp    80105c1f <alltraps>

80106256 <vector39>:
.globl vector39
vector39:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $39
80106258:	6a 27                	push   $0x27
  jmp alltraps
8010625a:	e9 c0 f9 ff ff       	jmp    80105c1f <alltraps>

8010625f <vector40>:
.globl vector40
vector40:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $40
80106261:	6a 28                	push   $0x28
  jmp alltraps
80106263:	e9 b7 f9 ff ff       	jmp    80105c1f <alltraps>

80106268 <vector41>:
.globl vector41
vector41:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $41
8010626a:	6a 29                	push   $0x29
  jmp alltraps
8010626c:	e9 ae f9 ff ff       	jmp    80105c1f <alltraps>

80106271 <vector42>:
.globl vector42
vector42:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $42
80106273:	6a 2a                	push   $0x2a
  jmp alltraps
80106275:	e9 a5 f9 ff ff       	jmp    80105c1f <alltraps>

8010627a <vector43>:
.globl vector43
vector43:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $43
8010627c:	6a 2b                	push   $0x2b
  jmp alltraps
8010627e:	e9 9c f9 ff ff       	jmp    80105c1f <alltraps>

80106283 <vector44>:
.globl vector44
vector44:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $44
80106285:	6a 2c                	push   $0x2c
  jmp alltraps
80106287:	e9 93 f9 ff ff       	jmp    80105c1f <alltraps>

8010628c <vector45>:
.globl vector45
vector45:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $45
8010628e:	6a 2d                	push   $0x2d
  jmp alltraps
80106290:	e9 8a f9 ff ff       	jmp    80105c1f <alltraps>

80106295 <vector46>:
.globl vector46
vector46:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $46
80106297:	6a 2e                	push   $0x2e
  jmp alltraps
80106299:	e9 81 f9 ff ff       	jmp    80105c1f <alltraps>

8010629e <vector47>:
.globl vector47
vector47:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $47
801062a0:	6a 2f                	push   $0x2f
  jmp alltraps
801062a2:	e9 78 f9 ff ff       	jmp    80105c1f <alltraps>

801062a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $48
801062a9:	6a 30                	push   $0x30
  jmp alltraps
801062ab:	e9 6f f9 ff ff       	jmp    80105c1f <alltraps>

801062b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $49
801062b2:	6a 31                	push   $0x31
  jmp alltraps
801062b4:	e9 66 f9 ff ff       	jmp    80105c1f <alltraps>

801062b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $50
801062bb:	6a 32                	push   $0x32
  jmp alltraps
801062bd:	e9 5d f9 ff ff       	jmp    80105c1f <alltraps>

801062c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $51
801062c4:	6a 33                	push   $0x33
  jmp alltraps
801062c6:	e9 54 f9 ff ff       	jmp    80105c1f <alltraps>

801062cb <vector52>:
.globl vector52
vector52:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $52
801062cd:	6a 34                	push   $0x34
  jmp alltraps
801062cf:	e9 4b f9 ff ff       	jmp    80105c1f <alltraps>

801062d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $53
801062d6:	6a 35                	push   $0x35
  jmp alltraps
801062d8:	e9 42 f9 ff ff       	jmp    80105c1f <alltraps>

801062dd <vector54>:
.globl vector54
vector54:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $54
801062df:	6a 36                	push   $0x36
  jmp alltraps
801062e1:	e9 39 f9 ff ff       	jmp    80105c1f <alltraps>

801062e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $55
801062e8:	6a 37                	push   $0x37
  jmp alltraps
801062ea:	e9 30 f9 ff ff       	jmp    80105c1f <alltraps>

801062ef <vector56>:
.globl vector56
vector56:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $56
801062f1:	6a 38                	push   $0x38
  jmp alltraps
801062f3:	e9 27 f9 ff ff       	jmp    80105c1f <alltraps>

801062f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $57
801062fa:	6a 39                	push   $0x39
  jmp alltraps
801062fc:	e9 1e f9 ff ff       	jmp    80105c1f <alltraps>

80106301 <vector58>:
.globl vector58
vector58:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $58
80106303:	6a 3a                	push   $0x3a
  jmp alltraps
80106305:	e9 15 f9 ff ff       	jmp    80105c1f <alltraps>

8010630a <vector59>:
.globl vector59
vector59:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $59
8010630c:	6a 3b                	push   $0x3b
  jmp alltraps
8010630e:	e9 0c f9 ff ff       	jmp    80105c1f <alltraps>

80106313 <vector60>:
.globl vector60
vector60:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $60
80106315:	6a 3c                	push   $0x3c
  jmp alltraps
80106317:	e9 03 f9 ff ff       	jmp    80105c1f <alltraps>

8010631c <vector61>:
.globl vector61
vector61:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $61
8010631e:	6a 3d                	push   $0x3d
  jmp alltraps
80106320:	e9 fa f8 ff ff       	jmp    80105c1f <alltraps>

80106325 <vector62>:
.globl vector62
vector62:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $62
80106327:	6a 3e                	push   $0x3e
  jmp alltraps
80106329:	e9 f1 f8 ff ff       	jmp    80105c1f <alltraps>

8010632e <vector63>:
.globl vector63
vector63:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $63
80106330:	6a 3f                	push   $0x3f
  jmp alltraps
80106332:	e9 e8 f8 ff ff       	jmp    80105c1f <alltraps>

80106337 <vector64>:
.globl vector64
vector64:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $64
80106339:	6a 40                	push   $0x40
  jmp alltraps
8010633b:	e9 df f8 ff ff       	jmp    80105c1f <alltraps>

80106340 <vector65>:
.globl vector65
vector65:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $65
80106342:	6a 41                	push   $0x41
  jmp alltraps
80106344:	e9 d6 f8 ff ff       	jmp    80105c1f <alltraps>

80106349 <vector66>:
.globl vector66
vector66:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $66
8010634b:	6a 42                	push   $0x42
  jmp alltraps
8010634d:	e9 cd f8 ff ff       	jmp    80105c1f <alltraps>

80106352 <vector67>:
.globl vector67
vector67:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $67
80106354:	6a 43                	push   $0x43
  jmp alltraps
80106356:	e9 c4 f8 ff ff       	jmp    80105c1f <alltraps>

8010635b <vector68>:
.globl vector68
vector68:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $68
8010635d:	6a 44                	push   $0x44
  jmp alltraps
8010635f:	e9 bb f8 ff ff       	jmp    80105c1f <alltraps>

80106364 <vector69>:
.globl vector69
vector69:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $69
80106366:	6a 45                	push   $0x45
  jmp alltraps
80106368:	e9 b2 f8 ff ff       	jmp    80105c1f <alltraps>

8010636d <vector70>:
.globl vector70
vector70:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $70
8010636f:	6a 46                	push   $0x46
  jmp alltraps
80106371:	e9 a9 f8 ff ff       	jmp    80105c1f <alltraps>

80106376 <vector71>:
.globl vector71
vector71:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $71
80106378:	6a 47                	push   $0x47
  jmp alltraps
8010637a:	e9 a0 f8 ff ff       	jmp    80105c1f <alltraps>

8010637f <vector72>:
.globl vector72
vector72:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $72
80106381:	6a 48                	push   $0x48
  jmp alltraps
80106383:	e9 97 f8 ff ff       	jmp    80105c1f <alltraps>

80106388 <vector73>:
.globl vector73
vector73:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $73
8010638a:	6a 49                	push   $0x49
  jmp alltraps
8010638c:	e9 8e f8 ff ff       	jmp    80105c1f <alltraps>

80106391 <vector74>:
.globl vector74
vector74:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $74
80106393:	6a 4a                	push   $0x4a
  jmp alltraps
80106395:	e9 85 f8 ff ff       	jmp    80105c1f <alltraps>

8010639a <vector75>:
.globl vector75
vector75:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $75
8010639c:	6a 4b                	push   $0x4b
  jmp alltraps
8010639e:	e9 7c f8 ff ff       	jmp    80105c1f <alltraps>

801063a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $76
801063a5:	6a 4c                	push   $0x4c
  jmp alltraps
801063a7:	e9 73 f8 ff ff       	jmp    80105c1f <alltraps>

801063ac <vector77>:
.globl vector77
vector77:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $77
801063ae:	6a 4d                	push   $0x4d
  jmp alltraps
801063b0:	e9 6a f8 ff ff       	jmp    80105c1f <alltraps>

801063b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $78
801063b7:	6a 4e                	push   $0x4e
  jmp alltraps
801063b9:	e9 61 f8 ff ff       	jmp    80105c1f <alltraps>

801063be <vector79>:
.globl vector79
vector79:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $79
801063c0:	6a 4f                	push   $0x4f
  jmp alltraps
801063c2:	e9 58 f8 ff ff       	jmp    80105c1f <alltraps>

801063c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $80
801063c9:	6a 50                	push   $0x50
  jmp alltraps
801063cb:	e9 4f f8 ff ff       	jmp    80105c1f <alltraps>

801063d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $81
801063d2:	6a 51                	push   $0x51
  jmp alltraps
801063d4:	e9 46 f8 ff ff       	jmp    80105c1f <alltraps>

801063d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $82
801063db:	6a 52                	push   $0x52
  jmp alltraps
801063dd:	e9 3d f8 ff ff       	jmp    80105c1f <alltraps>

801063e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $83
801063e4:	6a 53                	push   $0x53
  jmp alltraps
801063e6:	e9 34 f8 ff ff       	jmp    80105c1f <alltraps>

801063eb <vector84>:
.globl vector84
vector84:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $84
801063ed:	6a 54                	push   $0x54
  jmp alltraps
801063ef:	e9 2b f8 ff ff       	jmp    80105c1f <alltraps>

801063f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $85
801063f6:	6a 55                	push   $0x55
  jmp alltraps
801063f8:	e9 22 f8 ff ff       	jmp    80105c1f <alltraps>

801063fd <vector86>:
.globl vector86
vector86:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $86
801063ff:	6a 56                	push   $0x56
  jmp alltraps
80106401:	e9 19 f8 ff ff       	jmp    80105c1f <alltraps>

80106406 <vector87>:
.globl vector87
vector87:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $87
80106408:	6a 57                	push   $0x57
  jmp alltraps
8010640a:	e9 10 f8 ff ff       	jmp    80105c1f <alltraps>

8010640f <vector88>:
.globl vector88
vector88:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $88
80106411:	6a 58                	push   $0x58
  jmp alltraps
80106413:	e9 07 f8 ff ff       	jmp    80105c1f <alltraps>

80106418 <vector89>:
.globl vector89
vector89:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $89
8010641a:	6a 59                	push   $0x59
  jmp alltraps
8010641c:	e9 fe f7 ff ff       	jmp    80105c1f <alltraps>

80106421 <vector90>:
.globl vector90
vector90:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $90
80106423:	6a 5a                	push   $0x5a
  jmp alltraps
80106425:	e9 f5 f7 ff ff       	jmp    80105c1f <alltraps>

8010642a <vector91>:
.globl vector91
vector91:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $91
8010642c:	6a 5b                	push   $0x5b
  jmp alltraps
8010642e:	e9 ec f7 ff ff       	jmp    80105c1f <alltraps>

80106433 <vector92>:
.globl vector92
vector92:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $92
80106435:	6a 5c                	push   $0x5c
  jmp alltraps
80106437:	e9 e3 f7 ff ff       	jmp    80105c1f <alltraps>

8010643c <vector93>:
.globl vector93
vector93:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $93
8010643e:	6a 5d                	push   $0x5d
  jmp alltraps
80106440:	e9 da f7 ff ff       	jmp    80105c1f <alltraps>

80106445 <vector94>:
.globl vector94
vector94:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $94
80106447:	6a 5e                	push   $0x5e
  jmp alltraps
80106449:	e9 d1 f7 ff ff       	jmp    80105c1f <alltraps>

8010644e <vector95>:
.globl vector95
vector95:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $95
80106450:	6a 5f                	push   $0x5f
  jmp alltraps
80106452:	e9 c8 f7 ff ff       	jmp    80105c1f <alltraps>

80106457 <vector96>:
.globl vector96
vector96:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $96
80106459:	6a 60                	push   $0x60
  jmp alltraps
8010645b:	e9 bf f7 ff ff       	jmp    80105c1f <alltraps>

80106460 <vector97>:
.globl vector97
vector97:
  pushl $0
80106460:	6a 00                	push   $0x0
  pushl $97
80106462:	6a 61                	push   $0x61
  jmp alltraps
80106464:	e9 b6 f7 ff ff       	jmp    80105c1f <alltraps>

80106469 <vector98>:
.globl vector98
vector98:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $98
8010646b:	6a 62                	push   $0x62
  jmp alltraps
8010646d:	e9 ad f7 ff ff       	jmp    80105c1f <alltraps>

80106472 <vector99>:
.globl vector99
vector99:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $99
80106474:	6a 63                	push   $0x63
  jmp alltraps
80106476:	e9 a4 f7 ff ff       	jmp    80105c1f <alltraps>

8010647b <vector100>:
.globl vector100
vector100:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $100
8010647d:	6a 64                	push   $0x64
  jmp alltraps
8010647f:	e9 9b f7 ff ff       	jmp    80105c1f <alltraps>

80106484 <vector101>:
.globl vector101
vector101:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $101
80106486:	6a 65                	push   $0x65
  jmp alltraps
80106488:	e9 92 f7 ff ff       	jmp    80105c1f <alltraps>

8010648d <vector102>:
.globl vector102
vector102:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $102
8010648f:	6a 66                	push   $0x66
  jmp alltraps
80106491:	e9 89 f7 ff ff       	jmp    80105c1f <alltraps>

80106496 <vector103>:
.globl vector103
vector103:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $103
80106498:	6a 67                	push   $0x67
  jmp alltraps
8010649a:	e9 80 f7 ff ff       	jmp    80105c1f <alltraps>

8010649f <vector104>:
.globl vector104
vector104:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $104
801064a1:	6a 68                	push   $0x68
  jmp alltraps
801064a3:	e9 77 f7 ff ff       	jmp    80105c1f <alltraps>

801064a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $105
801064aa:	6a 69                	push   $0x69
  jmp alltraps
801064ac:	e9 6e f7 ff ff       	jmp    80105c1f <alltraps>

801064b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $106
801064b3:	6a 6a                	push   $0x6a
  jmp alltraps
801064b5:	e9 65 f7 ff ff       	jmp    80105c1f <alltraps>

801064ba <vector107>:
.globl vector107
vector107:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $107
801064bc:	6a 6b                	push   $0x6b
  jmp alltraps
801064be:	e9 5c f7 ff ff       	jmp    80105c1f <alltraps>

801064c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $108
801064c5:	6a 6c                	push   $0x6c
  jmp alltraps
801064c7:	e9 53 f7 ff ff       	jmp    80105c1f <alltraps>

801064cc <vector109>:
.globl vector109
vector109:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $109
801064ce:	6a 6d                	push   $0x6d
  jmp alltraps
801064d0:	e9 4a f7 ff ff       	jmp    80105c1f <alltraps>

801064d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $110
801064d7:	6a 6e                	push   $0x6e
  jmp alltraps
801064d9:	e9 41 f7 ff ff       	jmp    80105c1f <alltraps>

801064de <vector111>:
.globl vector111
vector111:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $111
801064e0:	6a 6f                	push   $0x6f
  jmp alltraps
801064e2:	e9 38 f7 ff ff       	jmp    80105c1f <alltraps>

801064e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $112
801064e9:	6a 70                	push   $0x70
  jmp alltraps
801064eb:	e9 2f f7 ff ff       	jmp    80105c1f <alltraps>

801064f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $113
801064f2:	6a 71                	push   $0x71
  jmp alltraps
801064f4:	e9 26 f7 ff ff       	jmp    80105c1f <alltraps>

801064f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $114
801064fb:	6a 72                	push   $0x72
  jmp alltraps
801064fd:	e9 1d f7 ff ff       	jmp    80105c1f <alltraps>

80106502 <vector115>:
.globl vector115
vector115:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $115
80106504:	6a 73                	push   $0x73
  jmp alltraps
80106506:	e9 14 f7 ff ff       	jmp    80105c1f <alltraps>

8010650b <vector116>:
.globl vector116
vector116:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $116
8010650d:	6a 74                	push   $0x74
  jmp alltraps
8010650f:	e9 0b f7 ff ff       	jmp    80105c1f <alltraps>

80106514 <vector117>:
.globl vector117
vector117:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $117
80106516:	6a 75                	push   $0x75
  jmp alltraps
80106518:	e9 02 f7 ff ff       	jmp    80105c1f <alltraps>

8010651d <vector118>:
.globl vector118
vector118:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $118
8010651f:	6a 76                	push   $0x76
  jmp alltraps
80106521:	e9 f9 f6 ff ff       	jmp    80105c1f <alltraps>

80106526 <vector119>:
.globl vector119
vector119:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $119
80106528:	6a 77                	push   $0x77
  jmp alltraps
8010652a:	e9 f0 f6 ff ff       	jmp    80105c1f <alltraps>

8010652f <vector120>:
.globl vector120
vector120:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $120
80106531:	6a 78                	push   $0x78
  jmp alltraps
80106533:	e9 e7 f6 ff ff       	jmp    80105c1f <alltraps>

80106538 <vector121>:
.globl vector121
vector121:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $121
8010653a:	6a 79                	push   $0x79
  jmp alltraps
8010653c:	e9 de f6 ff ff       	jmp    80105c1f <alltraps>

80106541 <vector122>:
.globl vector122
vector122:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $122
80106543:	6a 7a                	push   $0x7a
  jmp alltraps
80106545:	e9 d5 f6 ff ff       	jmp    80105c1f <alltraps>

8010654a <vector123>:
.globl vector123
vector123:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $123
8010654c:	6a 7b                	push   $0x7b
  jmp alltraps
8010654e:	e9 cc f6 ff ff       	jmp    80105c1f <alltraps>

80106553 <vector124>:
.globl vector124
vector124:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $124
80106555:	6a 7c                	push   $0x7c
  jmp alltraps
80106557:	e9 c3 f6 ff ff       	jmp    80105c1f <alltraps>

8010655c <vector125>:
.globl vector125
vector125:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $125
8010655e:	6a 7d                	push   $0x7d
  jmp alltraps
80106560:	e9 ba f6 ff ff       	jmp    80105c1f <alltraps>

80106565 <vector126>:
.globl vector126
vector126:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $126
80106567:	6a 7e                	push   $0x7e
  jmp alltraps
80106569:	e9 b1 f6 ff ff       	jmp    80105c1f <alltraps>

8010656e <vector127>:
.globl vector127
vector127:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $127
80106570:	6a 7f                	push   $0x7f
  jmp alltraps
80106572:	e9 a8 f6 ff ff       	jmp    80105c1f <alltraps>

80106577 <vector128>:
.globl vector128
vector128:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $128
80106579:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010657e:	e9 9c f6 ff ff       	jmp    80105c1f <alltraps>

80106583 <vector129>:
.globl vector129
vector129:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $129
80106585:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010658a:	e9 90 f6 ff ff       	jmp    80105c1f <alltraps>

8010658f <vector130>:
.globl vector130
vector130:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $130
80106591:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106596:	e9 84 f6 ff ff       	jmp    80105c1f <alltraps>

8010659b <vector131>:
.globl vector131
vector131:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $131
8010659d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801065a2:	e9 78 f6 ff ff       	jmp    80105c1f <alltraps>

801065a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $132
801065a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801065ae:	e9 6c f6 ff ff       	jmp    80105c1f <alltraps>

801065b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $133
801065b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801065ba:	e9 60 f6 ff ff       	jmp    80105c1f <alltraps>

801065bf <vector134>:
.globl vector134
vector134:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $134
801065c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801065c6:	e9 54 f6 ff ff       	jmp    80105c1f <alltraps>

801065cb <vector135>:
.globl vector135
vector135:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $135
801065cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801065d2:	e9 48 f6 ff ff       	jmp    80105c1f <alltraps>

801065d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $136
801065d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801065de:	e9 3c f6 ff ff       	jmp    80105c1f <alltraps>

801065e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $137
801065e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801065ea:	e9 30 f6 ff ff       	jmp    80105c1f <alltraps>

801065ef <vector138>:
.globl vector138
vector138:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $138
801065f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801065f6:	e9 24 f6 ff ff       	jmp    80105c1f <alltraps>

801065fb <vector139>:
.globl vector139
vector139:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $139
801065fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106602:	e9 18 f6 ff ff       	jmp    80105c1f <alltraps>

80106607 <vector140>:
.globl vector140
vector140:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $140
80106609:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010660e:	e9 0c f6 ff ff       	jmp    80105c1f <alltraps>

80106613 <vector141>:
.globl vector141
vector141:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $141
80106615:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010661a:	e9 00 f6 ff ff       	jmp    80105c1f <alltraps>

8010661f <vector142>:
.globl vector142
vector142:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $142
80106621:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106626:	e9 f4 f5 ff ff       	jmp    80105c1f <alltraps>

8010662b <vector143>:
.globl vector143
vector143:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $143
8010662d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106632:	e9 e8 f5 ff ff       	jmp    80105c1f <alltraps>

80106637 <vector144>:
.globl vector144
vector144:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $144
80106639:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010663e:	e9 dc f5 ff ff       	jmp    80105c1f <alltraps>

80106643 <vector145>:
.globl vector145
vector145:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $145
80106645:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010664a:	e9 d0 f5 ff ff       	jmp    80105c1f <alltraps>

8010664f <vector146>:
.globl vector146
vector146:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $146
80106651:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106656:	e9 c4 f5 ff ff       	jmp    80105c1f <alltraps>

8010665b <vector147>:
.globl vector147
vector147:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $147
8010665d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106662:	e9 b8 f5 ff ff       	jmp    80105c1f <alltraps>

80106667 <vector148>:
.globl vector148
vector148:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $148
80106669:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010666e:	e9 ac f5 ff ff       	jmp    80105c1f <alltraps>

80106673 <vector149>:
.globl vector149
vector149:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $149
80106675:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010667a:	e9 a0 f5 ff ff       	jmp    80105c1f <alltraps>

8010667f <vector150>:
.globl vector150
vector150:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $150
80106681:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106686:	e9 94 f5 ff ff       	jmp    80105c1f <alltraps>

8010668b <vector151>:
.globl vector151
vector151:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $151
8010668d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106692:	e9 88 f5 ff ff       	jmp    80105c1f <alltraps>

80106697 <vector152>:
.globl vector152
vector152:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $152
80106699:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010669e:	e9 7c f5 ff ff       	jmp    80105c1f <alltraps>

801066a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $153
801066a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801066aa:	e9 70 f5 ff ff       	jmp    80105c1f <alltraps>

801066af <vector154>:
.globl vector154
vector154:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $154
801066b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801066b6:	e9 64 f5 ff ff       	jmp    80105c1f <alltraps>

801066bb <vector155>:
.globl vector155
vector155:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $155
801066bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801066c2:	e9 58 f5 ff ff       	jmp    80105c1f <alltraps>

801066c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $156
801066c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801066ce:	e9 4c f5 ff ff       	jmp    80105c1f <alltraps>

801066d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $157
801066d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801066da:	e9 40 f5 ff ff       	jmp    80105c1f <alltraps>

801066df <vector158>:
.globl vector158
vector158:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $158
801066e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801066e6:	e9 34 f5 ff ff       	jmp    80105c1f <alltraps>

801066eb <vector159>:
.globl vector159
vector159:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $159
801066ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801066f2:	e9 28 f5 ff ff       	jmp    80105c1f <alltraps>

801066f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $160
801066f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801066fe:	e9 1c f5 ff ff       	jmp    80105c1f <alltraps>

80106703 <vector161>:
.globl vector161
vector161:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $161
80106705:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010670a:	e9 10 f5 ff ff       	jmp    80105c1f <alltraps>

8010670f <vector162>:
.globl vector162
vector162:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $162
80106711:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106716:	e9 04 f5 ff ff       	jmp    80105c1f <alltraps>

8010671b <vector163>:
.globl vector163
vector163:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $163
8010671d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106722:	e9 f8 f4 ff ff       	jmp    80105c1f <alltraps>

80106727 <vector164>:
.globl vector164
vector164:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $164
80106729:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010672e:	e9 ec f4 ff ff       	jmp    80105c1f <alltraps>

80106733 <vector165>:
.globl vector165
vector165:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $165
80106735:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010673a:	e9 e0 f4 ff ff       	jmp    80105c1f <alltraps>

8010673f <vector166>:
.globl vector166
vector166:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $166
80106741:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106746:	e9 d4 f4 ff ff       	jmp    80105c1f <alltraps>

8010674b <vector167>:
.globl vector167
vector167:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $167
8010674d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106752:	e9 c8 f4 ff ff       	jmp    80105c1f <alltraps>

80106757 <vector168>:
.globl vector168
vector168:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $168
80106759:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010675e:	e9 bc f4 ff ff       	jmp    80105c1f <alltraps>

80106763 <vector169>:
.globl vector169
vector169:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $169
80106765:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010676a:	e9 b0 f4 ff ff       	jmp    80105c1f <alltraps>

8010676f <vector170>:
.globl vector170
vector170:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $170
80106771:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106776:	e9 a4 f4 ff ff       	jmp    80105c1f <alltraps>

8010677b <vector171>:
.globl vector171
vector171:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $171
8010677d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106782:	e9 98 f4 ff ff       	jmp    80105c1f <alltraps>

80106787 <vector172>:
.globl vector172
vector172:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $172
80106789:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010678e:	e9 8c f4 ff ff       	jmp    80105c1f <alltraps>

80106793 <vector173>:
.globl vector173
vector173:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $173
80106795:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010679a:	e9 80 f4 ff ff       	jmp    80105c1f <alltraps>

8010679f <vector174>:
.globl vector174
vector174:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $174
801067a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801067a6:	e9 74 f4 ff ff       	jmp    80105c1f <alltraps>

801067ab <vector175>:
.globl vector175
vector175:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $175
801067ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801067b2:	e9 68 f4 ff ff       	jmp    80105c1f <alltraps>

801067b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $176
801067b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801067be:	e9 5c f4 ff ff       	jmp    80105c1f <alltraps>

801067c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $177
801067c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801067ca:	e9 50 f4 ff ff       	jmp    80105c1f <alltraps>

801067cf <vector178>:
.globl vector178
vector178:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $178
801067d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801067d6:	e9 44 f4 ff ff       	jmp    80105c1f <alltraps>

801067db <vector179>:
.globl vector179
vector179:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $179
801067dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801067e2:	e9 38 f4 ff ff       	jmp    80105c1f <alltraps>

801067e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $180
801067e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801067ee:	e9 2c f4 ff ff       	jmp    80105c1f <alltraps>

801067f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $181
801067f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801067fa:	e9 20 f4 ff ff       	jmp    80105c1f <alltraps>

801067ff <vector182>:
.globl vector182
vector182:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $182
80106801:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106806:	e9 14 f4 ff ff       	jmp    80105c1f <alltraps>

8010680b <vector183>:
.globl vector183
vector183:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $183
8010680d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106812:	e9 08 f4 ff ff       	jmp    80105c1f <alltraps>

80106817 <vector184>:
.globl vector184
vector184:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $184
80106819:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010681e:	e9 fc f3 ff ff       	jmp    80105c1f <alltraps>

80106823 <vector185>:
.globl vector185
vector185:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $185
80106825:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010682a:	e9 f0 f3 ff ff       	jmp    80105c1f <alltraps>

8010682f <vector186>:
.globl vector186
vector186:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $186
80106831:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106836:	e9 e4 f3 ff ff       	jmp    80105c1f <alltraps>

8010683b <vector187>:
.globl vector187
vector187:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $187
8010683d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106842:	e9 d8 f3 ff ff       	jmp    80105c1f <alltraps>

80106847 <vector188>:
.globl vector188
vector188:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $188
80106849:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010684e:	e9 cc f3 ff ff       	jmp    80105c1f <alltraps>

80106853 <vector189>:
.globl vector189
vector189:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $189
80106855:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010685a:	e9 c0 f3 ff ff       	jmp    80105c1f <alltraps>

8010685f <vector190>:
.globl vector190
vector190:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $190
80106861:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106866:	e9 b4 f3 ff ff       	jmp    80105c1f <alltraps>

8010686b <vector191>:
.globl vector191
vector191:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $191
8010686d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106872:	e9 a8 f3 ff ff       	jmp    80105c1f <alltraps>

80106877 <vector192>:
.globl vector192
vector192:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $192
80106879:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010687e:	e9 9c f3 ff ff       	jmp    80105c1f <alltraps>

80106883 <vector193>:
.globl vector193
vector193:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $193
80106885:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010688a:	e9 90 f3 ff ff       	jmp    80105c1f <alltraps>

8010688f <vector194>:
.globl vector194
vector194:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $194
80106891:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106896:	e9 84 f3 ff ff       	jmp    80105c1f <alltraps>

8010689b <vector195>:
.globl vector195
vector195:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $195
8010689d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801068a2:	e9 78 f3 ff ff       	jmp    80105c1f <alltraps>

801068a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $196
801068a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801068ae:	e9 6c f3 ff ff       	jmp    80105c1f <alltraps>

801068b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $197
801068b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801068ba:	e9 60 f3 ff ff       	jmp    80105c1f <alltraps>

801068bf <vector198>:
.globl vector198
vector198:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $198
801068c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801068c6:	e9 54 f3 ff ff       	jmp    80105c1f <alltraps>

801068cb <vector199>:
.globl vector199
vector199:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $199
801068cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801068d2:	e9 48 f3 ff ff       	jmp    80105c1f <alltraps>

801068d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $200
801068d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801068de:	e9 3c f3 ff ff       	jmp    80105c1f <alltraps>

801068e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $201
801068e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801068ea:	e9 30 f3 ff ff       	jmp    80105c1f <alltraps>

801068ef <vector202>:
.globl vector202
vector202:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $202
801068f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801068f6:	e9 24 f3 ff ff       	jmp    80105c1f <alltraps>

801068fb <vector203>:
.globl vector203
vector203:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $203
801068fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106902:	e9 18 f3 ff ff       	jmp    80105c1f <alltraps>

80106907 <vector204>:
.globl vector204
vector204:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $204
80106909:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010690e:	e9 0c f3 ff ff       	jmp    80105c1f <alltraps>

80106913 <vector205>:
.globl vector205
vector205:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $205
80106915:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010691a:	e9 00 f3 ff ff       	jmp    80105c1f <alltraps>

8010691f <vector206>:
.globl vector206
vector206:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $206
80106921:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106926:	e9 f4 f2 ff ff       	jmp    80105c1f <alltraps>

8010692b <vector207>:
.globl vector207
vector207:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $207
8010692d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106932:	e9 e8 f2 ff ff       	jmp    80105c1f <alltraps>

80106937 <vector208>:
.globl vector208
vector208:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $208
80106939:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010693e:	e9 dc f2 ff ff       	jmp    80105c1f <alltraps>

80106943 <vector209>:
.globl vector209
vector209:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $209
80106945:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010694a:	e9 d0 f2 ff ff       	jmp    80105c1f <alltraps>

8010694f <vector210>:
.globl vector210
vector210:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $210
80106951:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106956:	e9 c4 f2 ff ff       	jmp    80105c1f <alltraps>

8010695b <vector211>:
.globl vector211
vector211:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $211
8010695d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106962:	e9 b8 f2 ff ff       	jmp    80105c1f <alltraps>

80106967 <vector212>:
.globl vector212
vector212:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $212
80106969:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010696e:	e9 ac f2 ff ff       	jmp    80105c1f <alltraps>

80106973 <vector213>:
.globl vector213
vector213:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $213
80106975:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010697a:	e9 a0 f2 ff ff       	jmp    80105c1f <alltraps>

8010697f <vector214>:
.globl vector214
vector214:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $214
80106981:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106986:	e9 94 f2 ff ff       	jmp    80105c1f <alltraps>

8010698b <vector215>:
.globl vector215
vector215:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $215
8010698d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106992:	e9 88 f2 ff ff       	jmp    80105c1f <alltraps>

80106997 <vector216>:
.globl vector216
vector216:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $216
80106999:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010699e:	e9 7c f2 ff ff       	jmp    80105c1f <alltraps>

801069a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $217
801069a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801069aa:	e9 70 f2 ff ff       	jmp    80105c1f <alltraps>

801069af <vector218>:
.globl vector218
vector218:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $218
801069b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801069b6:	e9 64 f2 ff ff       	jmp    80105c1f <alltraps>

801069bb <vector219>:
.globl vector219
vector219:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $219
801069bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801069c2:	e9 58 f2 ff ff       	jmp    80105c1f <alltraps>

801069c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $220
801069c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801069ce:	e9 4c f2 ff ff       	jmp    80105c1f <alltraps>

801069d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $221
801069d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801069da:	e9 40 f2 ff ff       	jmp    80105c1f <alltraps>

801069df <vector222>:
.globl vector222
vector222:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $222
801069e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801069e6:	e9 34 f2 ff ff       	jmp    80105c1f <alltraps>

801069eb <vector223>:
.globl vector223
vector223:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $223
801069ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801069f2:	e9 28 f2 ff ff       	jmp    80105c1f <alltraps>

801069f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $224
801069f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801069fe:	e9 1c f2 ff ff       	jmp    80105c1f <alltraps>

80106a03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $225
80106a05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106a0a:	e9 10 f2 ff ff       	jmp    80105c1f <alltraps>

80106a0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $226
80106a11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106a16:	e9 04 f2 ff ff       	jmp    80105c1f <alltraps>

80106a1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $227
80106a1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106a22:	e9 f8 f1 ff ff       	jmp    80105c1f <alltraps>

80106a27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $228
80106a29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106a2e:	e9 ec f1 ff ff       	jmp    80105c1f <alltraps>

80106a33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $229
80106a35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106a3a:	e9 e0 f1 ff ff       	jmp    80105c1f <alltraps>

80106a3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $230
80106a41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106a46:	e9 d4 f1 ff ff       	jmp    80105c1f <alltraps>

80106a4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $231
80106a4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106a52:	e9 c8 f1 ff ff       	jmp    80105c1f <alltraps>

80106a57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $232
80106a59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106a5e:	e9 bc f1 ff ff       	jmp    80105c1f <alltraps>

80106a63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $233
80106a65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106a6a:	e9 b0 f1 ff ff       	jmp    80105c1f <alltraps>

80106a6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $234
80106a71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106a76:	e9 a4 f1 ff ff       	jmp    80105c1f <alltraps>

80106a7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $235
80106a7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106a82:	e9 98 f1 ff ff       	jmp    80105c1f <alltraps>

80106a87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $236
80106a89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106a8e:	e9 8c f1 ff ff       	jmp    80105c1f <alltraps>

80106a93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $237
80106a95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106a9a:	e9 80 f1 ff ff       	jmp    80105c1f <alltraps>

80106a9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $238
80106aa1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106aa6:	e9 74 f1 ff ff       	jmp    80105c1f <alltraps>

80106aab <vector239>:
.globl vector239
vector239:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $239
80106aad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ab2:	e9 68 f1 ff ff       	jmp    80105c1f <alltraps>

80106ab7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $240
80106ab9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106abe:	e9 5c f1 ff ff       	jmp    80105c1f <alltraps>

80106ac3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $241
80106ac5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106aca:	e9 50 f1 ff ff       	jmp    80105c1f <alltraps>

80106acf <vector242>:
.globl vector242
vector242:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $242
80106ad1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ad6:	e9 44 f1 ff ff       	jmp    80105c1f <alltraps>

80106adb <vector243>:
.globl vector243
vector243:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $243
80106add:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ae2:	e9 38 f1 ff ff       	jmp    80105c1f <alltraps>

80106ae7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $244
80106ae9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106aee:	e9 2c f1 ff ff       	jmp    80105c1f <alltraps>

80106af3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $245
80106af5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106afa:	e9 20 f1 ff ff       	jmp    80105c1f <alltraps>

80106aff <vector246>:
.globl vector246
vector246:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $246
80106b01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106b06:	e9 14 f1 ff ff       	jmp    80105c1f <alltraps>

80106b0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $247
80106b0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106b12:	e9 08 f1 ff ff       	jmp    80105c1f <alltraps>

80106b17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $248
80106b19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106b1e:	e9 fc f0 ff ff       	jmp    80105c1f <alltraps>

80106b23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $249
80106b25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106b2a:	e9 f0 f0 ff ff       	jmp    80105c1f <alltraps>

80106b2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $250
80106b31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106b36:	e9 e4 f0 ff ff       	jmp    80105c1f <alltraps>

80106b3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $251
80106b3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106b42:	e9 d8 f0 ff ff       	jmp    80105c1f <alltraps>

80106b47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $252
80106b49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106b4e:	e9 cc f0 ff ff       	jmp    80105c1f <alltraps>

80106b53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $253
80106b55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106b5a:	e9 c0 f0 ff ff       	jmp    80105c1f <alltraps>

80106b5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $254
80106b61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106b66:	e9 b4 f0 ff ff       	jmp    80105c1f <alltraps>

80106b6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $255
80106b6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106b72:	e9 a8 f0 ff ff       	jmp    80105c1f <alltraps>
80106b77:	66 90                	xchg   %ax,%ax
80106b79:	66 90                	xchg   %ax,%ax
80106b7b:	66 90                	xchg   %ax,%ax
80106b7d:	66 90                	xchg   %ax,%ax
80106b7f:	90                   	nop

80106b80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106b86:	89 d3                	mov    %edx,%ebx
{
80106b88:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106b8a:	c1 eb 16             	shr    $0x16,%ebx
80106b8d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106b90:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106b93:	8b 06                	mov    (%esi),%eax
80106b95:	a8 01                	test   $0x1,%al
80106b97:	74 27                	je     80106bc0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b9e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ba4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ba7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106baa:	89 fa                	mov    %edi,%edx
80106bac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106bb2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
80106bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106bc0:	85 c9                	test   %ecx,%ecx
80106bc2:	74 2c                	je     80106bf0 <walkpgdir+0x70>
80106bc4:	e8 f7 bc ff ff       	call   801028c0 <kalloc>
80106bc9:	85 c0                	test   %eax,%eax
80106bcb:	89 c3                	mov    %eax,%ebx
80106bcd:	74 21                	je     80106bf0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106bcf:	83 ec 04             	sub    $0x4,%esp
80106bd2:	68 00 10 00 00       	push   $0x1000
80106bd7:	6a 00                	push   $0x0
80106bd9:	50                   	push   %eax
80106bda:	e8 11 de ff ff       	call   801049f0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106bdf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106be5:	83 c4 10             	add    $0x10,%esp
80106be8:	83 c8 07             	or     $0x7,%eax
80106beb:	89 06                	mov    %eax,(%esi)
80106bed:	eb b5                	jmp    80106ba4 <walkpgdir+0x24>
80106bef:	90                   	nop
}
80106bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106bf3:	31 c0                	xor    %eax,%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106c06:	89 d3                	mov    %edx,%ebx
80106c08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106c0e:	83 ec 1c             	sub    $0x1c,%esp
80106c11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106c14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106c18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106c1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c20:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106c23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c26:	29 df                	sub    %ebx,%edi
80106c28:	83 c8 01             	or     $0x1,%eax
80106c2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106c2e:	eb 15                	jmp    80106c45 <mappages+0x45>
    if(*pte & PTE_P)
80106c30:	f6 00 01             	testb  $0x1,(%eax)
80106c33:	75 45                	jne    80106c7a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106c35:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106c38:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106c3b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106c3d:	74 31                	je     80106c70 <mappages+0x70>
      break;
    a += PGSIZE;
80106c3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106c45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c48:	b9 01 00 00 00       	mov    $0x1,%ecx
80106c4d:	89 da                	mov    %ebx,%edx
80106c4f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106c52:	e8 29 ff ff ff       	call   80106b80 <walkpgdir>
80106c57:	85 c0                	test   %eax,%eax
80106c59:	75 d5                	jne    80106c30 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106c5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c63:	5b                   	pop    %ebx
80106c64:	5e                   	pop    %esi
80106c65:	5f                   	pop    %edi
80106c66:	5d                   	pop    %ebp
80106c67:	c3                   	ret    
80106c68:	90                   	nop
80106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106c73:	31 c0                	xor    %eax,%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
      panic("remap");
80106c7a:	83 ec 0c             	sub    $0xc,%esp
80106c7d:	68 30 93 10 80       	push   $0x80109330
80106c82:	e8 09 97 ff ff       	call   80100390 <panic>
80106c87:	89 f6                	mov    %esi,%esi
80106c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106c96:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106c9c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106c9e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106ca4:	83 ec 1c             	sub    $0x1c,%esp
80106ca7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106caa:	39 d3                	cmp    %edx,%ebx
80106cac:	73 66                	jae    80106d14 <deallocuvm.part.0+0x84>
80106cae:	89 d6                	mov    %edx,%esi
80106cb0:	eb 3d                	jmp    80106cef <deallocuvm.part.0+0x5f>
80106cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106cb8:	8b 10                	mov    (%eax),%edx
80106cba:	f6 c2 01             	test   $0x1,%dl
80106cbd:	74 26                	je     80106ce5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106cbf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106cc5:	74 58                	je     80106d1f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106cc7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106cca:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106cd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106cd3:	52                   	push   %edx
80106cd4:	e8 37 ba ff ff       	call   80102710 <kfree>
      *pte = 0;
80106cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cdc:	83 c4 10             	add    $0x10,%esp
80106cdf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ce5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ceb:	39 f3                	cmp    %esi,%ebx
80106ced:	73 25                	jae    80106d14 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106cef:	31 c9                	xor    %ecx,%ecx
80106cf1:	89 da                	mov    %ebx,%edx
80106cf3:	89 f8                	mov    %edi,%eax
80106cf5:	e8 86 fe ff ff       	call   80106b80 <walkpgdir>
    if(!pte)
80106cfa:	85 c0                	test   %eax,%eax
80106cfc:	75 ba                	jne    80106cb8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106cfe:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106d04:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d0a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d10:	39 f3                	cmp    %esi,%ebx
80106d12:	72 db                	jb     80106cef <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106d14:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d1a:	5b                   	pop    %ebx
80106d1b:	5e                   	pop    %esi
80106d1c:	5f                   	pop    %edi
80106d1d:	5d                   	pop    %ebp
80106d1e:	c3                   	ret    
        panic("kfree");
80106d1f:	83 ec 0c             	sub    $0xc,%esp
80106d22:	68 c6 8c 10 80       	push   $0x80108cc6
80106d27:	e8 64 96 ff ff       	call   80100390 <panic>
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d30 <seginit>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d36:	e8 85 ce ff ff       	call   80103bc0 <cpuid>
80106d3b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d41:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d4a:	c7 80 58 48 11 80 ff 	movl   $0xffff,-0x7feeb7a8(%eax)
80106d51:	ff 00 00 
80106d54:	c7 80 5c 48 11 80 00 	movl   $0xcf9a00,-0x7feeb7a4(%eax)
80106d5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d5e:	c7 80 60 48 11 80 ff 	movl   $0xffff,-0x7feeb7a0(%eax)
80106d65:	ff 00 00 
80106d68:	c7 80 64 48 11 80 00 	movl   $0xcf9200,-0x7feeb79c(%eax)
80106d6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d72:	c7 80 68 48 11 80 ff 	movl   $0xffff,-0x7feeb798(%eax)
80106d79:	ff 00 00 
80106d7c:	c7 80 6c 48 11 80 00 	movl   $0xcffa00,-0x7feeb794(%eax)
80106d83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106d86:	c7 80 70 48 11 80 ff 	movl   $0xffff,-0x7feeb790(%eax)
80106d8d:	ff 00 00 
80106d90:	c7 80 74 48 11 80 00 	movl   $0xcff200,-0x7feeb78c(%eax)
80106d97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106d9a:	05 50 48 11 80       	add    $0x80114850,%eax
  pd[1] = (uint)p;
80106d9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106da3:	c1 e8 10             	shr    $0x10,%eax
80106da6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106daa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dad:	0f 01 10             	lgdtl  (%eax)
}
80106db0:	c9                   	leave  
80106db1:	c3                   	ret    
80106db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dc0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dc0:	a1 04 75 11 80       	mov    0x80117504,%eax
{
80106dc5:	55                   	push   %ebp
80106dc6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dc8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dcd:	0f 22 d8             	mov    %eax,%cr3
}
80106dd0:	5d                   	pop    %ebp
80106dd1:	c3                   	ret    
80106dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106de0 <switchuvm>:
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
80106de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106dec:	85 db                	test   %ebx,%ebx
80106dee:	0f 84 cb 00 00 00    	je     80106ebf <switchuvm+0xdf>
  if(p->kstack == 0)
80106df4:	8b 43 08             	mov    0x8(%ebx),%eax
80106df7:	85 c0                	test   %eax,%eax
80106df9:	0f 84 da 00 00 00    	je     80106ed9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106dff:	8b 43 04             	mov    0x4(%ebx),%eax
80106e02:	85 c0                	test   %eax,%eax
80106e04:	0f 84 c2 00 00 00    	je     80106ecc <switchuvm+0xec>
  pushcli();
80106e0a:	e8 01 da ff ff       	call   80104810 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e0f:	e8 2c cd ff ff       	call   80103b40 <mycpu>
80106e14:	89 c6                	mov    %eax,%esi
80106e16:	e8 25 cd ff ff       	call   80103b40 <mycpu>
80106e1b:	89 c7                	mov    %eax,%edi
80106e1d:	e8 1e cd ff ff       	call   80103b40 <mycpu>
80106e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e25:	83 c7 08             	add    $0x8,%edi
80106e28:	e8 13 cd ff ff       	call   80103b40 <mycpu>
80106e2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e30:	83 c0 08             	add    $0x8,%eax
80106e33:	ba 67 00 00 00       	mov    $0x67,%edx
80106e38:	c1 e8 18             	shr    $0x18,%eax
80106e3b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e42:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e49:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e4f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e54:	83 c1 08             	add    $0x8,%ecx
80106e57:	c1 e9 10             	shr    $0x10,%ecx
80106e5a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e60:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e65:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e6c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e71:	e8 ca cc ff ff       	call   80103b40 <mycpu>
80106e76:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e7d:	e8 be cc ff ff       	call   80103b40 <mycpu>
80106e82:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106e86:	8b 73 08             	mov    0x8(%ebx),%esi
80106e89:	e8 b2 cc ff ff       	call   80103b40 <mycpu>
80106e8e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e94:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e97:	e8 a4 cc ff ff       	call   80103b40 <mycpu>
80106e9c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ea0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ea5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ea8:	8b 43 04             	mov    0x4(%ebx),%eax
80106eab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106eb0:	0f 22 d8             	mov    %eax,%cr3
}
80106eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106eb6:	5b                   	pop    %ebx
80106eb7:	5e                   	pop    %esi
80106eb8:	5f                   	pop    %edi
80106eb9:	5d                   	pop    %ebp
  popcli();
80106eba:	e9 91 d9 ff ff       	jmp    80104850 <popcli>
    panic("switchuvm: no process");
80106ebf:	83 ec 0c             	sub    $0xc,%esp
80106ec2:	68 36 93 10 80       	push   $0x80109336
80106ec7:	e8 c4 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106ecc:	83 ec 0c             	sub    $0xc,%esp
80106ecf:	68 61 93 10 80       	push   $0x80109361
80106ed4:	e8 b7 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106ed9:	83 ec 0c             	sub    $0xc,%esp
80106edc:	68 4c 93 10 80       	push   $0x8010934c
80106ee1:	e8 aa 94 ff ff       	call   80100390 <panic>
80106ee6:	8d 76 00             	lea    0x0(%esi),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <inituvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 75 10             	mov    0x10(%ebp),%esi
80106efc:	8b 45 08             	mov    0x8(%ebp),%eax
80106eff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106f02:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f0b:	77 49                	ja     80106f56 <inituvm+0x66>
  mem = kalloc();
80106f0d:	e8 ae b9 ff ff       	call   801028c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106f12:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f15:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f17:	68 00 10 00 00       	push   $0x1000
80106f1c:	6a 00                	push   $0x0
80106f1e:	50                   	push   %eax
80106f1f:	e8 cc da ff ff       	call   801049f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f24:	58                   	pop    %eax
80106f25:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f2b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f30:	5a                   	pop    %edx
80106f31:	6a 06                	push   $0x6
80106f33:	50                   	push   %eax
80106f34:	31 d2                	xor    %edx,%edx
80106f36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f39:	e8 c2 fc ff ff       	call   80106c00 <mappages>
  memmove(mem, init, sz);
80106f3e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f41:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f44:	83 c4 10             	add    $0x10,%esp
80106f47:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f4d:	5b                   	pop    %ebx
80106f4e:	5e                   	pop    %esi
80106f4f:	5f                   	pop    %edi
80106f50:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f51:	e9 4a db ff ff       	jmp    80104aa0 <memmove>
    panic("inituvm: more than a page");
80106f56:	83 ec 0c             	sub    $0xc,%esp
80106f59:	68 75 93 10 80       	push   $0x80109375
80106f5e:	e8 2d 94 ff ff       	call   80100390 <panic>
80106f63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f70 <loaduvm>:
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	57                   	push   %edi
80106f74:	56                   	push   %esi
80106f75:	53                   	push   %ebx
80106f76:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106f79:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106f80:	0f 85 91 00 00 00    	jne    80107017 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106f86:	8b 75 18             	mov    0x18(%ebp),%esi
80106f89:	31 db                	xor    %ebx,%ebx
80106f8b:	85 f6                	test   %esi,%esi
80106f8d:	75 1a                	jne    80106fa9 <loaduvm+0x39>
80106f8f:	eb 6f                	jmp    80107000 <loaduvm+0x90>
80106f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f98:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f9e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fa4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fa7:	76 57                	jbe    80107000 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fac:	8b 45 08             	mov    0x8(%ebp),%eax
80106faf:	31 c9                	xor    %ecx,%ecx
80106fb1:	01 da                	add    %ebx,%edx
80106fb3:	e8 c8 fb ff ff       	call   80106b80 <walkpgdir>
80106fb8:	85 c0                	test   %eax,%eax
80106fba:	74 4e                	je     8010700a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106fbc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fbe:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fc1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fc6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106fcb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106fd1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fd4:	01 d9                	add    %ebx,%ecx
80106fd6:	05 00 00 00 80       	add    $0x80000000,%eax
80106fdb:	57                   	push   %edi
80106fdc:	51                   	push   %ecx
80106fdd:	50                   	push   %eax
80106fde:	ff 75 10             	pushl  0x10(%ebp)
80106fe1:	e8 5a ac ff ff       	call   80101c40 <readi>
80106fe6:	83 c4 10             	add    $0x10,%esp
80106fe9:	39 f8                	cmp    %edi,%eax
80106feb:	74 ab                	je     80106f98 <loaduvm+0x28>
}
80106fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ff5:	5b                   	pop    %ebx
80106ff6:	5e                   	pop    %esi
80106ff7:	5f                   	pop    %edi
80106ff8:	5d                   	pop    %ebp
80106ff9:	c3                   	ret    
80106ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107000:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107003:	31 c0                	xor    %eax,%eax
}
80107005:	5b                   	pop    %ebx
80107006:	5e                   	pop    %esi
80107007:	5f                   	pop    %edi
80107008:	5d                   	pop    %ebp
80107009:	c3                   	ret    
      panic("loaduvm: address should exist");
8010700a:	83 ec 0c             	sub    $0xc,%esp
8010700d:	68 8f 93 10 80       	push   $0x8010938f
80107012:	e8 79 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107017:	83 ec 0c             	sub    $0xc,%esp
8010701a:	68 30 94 10 80       	push   $0x80109430
8010701f:	e8 6c 93 ff ff       	call   80100390 <panic>
80107024:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010702a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107030 <allocuvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	57                   	push   %edi
80107034:	56                   	push   %esi
80107035:	53                   	push   %ebx
80107036:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107039:	8b 7d 10             	mov    0x10(%ebp),%edi
8010703c:	85 ff                	test   %edi,%edi
8010703e:	0f 88 8e 00 00 00    	js     801070d2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107044:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107047:	0f 82 93 00 00 00    	jb     801070e0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010704d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107050:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107056:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010705c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010705f:	0f 86 7e 00 00 00    	jbe    801070e3 <allocuvm+0xb3>
80107065:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107068:	8b 7d 08             	mov    0x8(%ebp),%edi
8010706b:	eb 42                	jmp    801070af <allocuvm+0x7f>
8010706d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107070:	83 ec 04             	sub    $0x4,%esp
80107073:	68 00 10 00 00       	push   $0x1000
80107078:	6a 00                	push   $0x0
8010707a:	50                   	push   %eax
8010707b:	e8 70 d9 ff ff       	call   801049f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107080:	58                   	pop    %eax
80107081:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107087:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010708c:	5a                   	pop    %edx
8010708d:	6a 06                	push   $0x6
8010708f:	50                   	push   %eax
80107090:	89 da                	mov    %ebx,%edx
80107092:	89 f8                	mov    %edi,%eax
80107094:	e8 67 fb ff ff       	call   80106c00 <mappages>
80107099:	83 c4 10             	add    $0x10,%esp
8010709c:	85 c0                	test   %eax,%eax
8010709e:	78 50                	js     801070f0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801070a0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070a6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801070a9:	0f 86 81 00 00 00    	jbe    80107130 <allocuvm+0x100>
    mem = kalloc();
801070af:	e8 0c b8 ff ff       	call   801028c0 <kalloc>
    if(mem == 0){
801070b4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801070b6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801070b8:	75 b6                	jne    80107070 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801070ba:	83 ec 0c             	sub    $0xc,%esp
801070bd:	68 ad 93 10 80       	push   $0x801093ad
801070c2:	e8 99 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801070c7:	83 c4 10             	add    $0x10,%esp
801070ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801070cd:	39 45 10             	cmp    %eax,0x10(%ebp)
801070d0:	77 6e                	ja     80107140 <allocuvm+0x110>
}
801070d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801070d5:	31 ff                	xor    %edi,%edi
}
801070d7:	89 f8                	mov    %edi,%eax
801070d9:	5b                   	pop    %ebx
801070da:	5e                   	pop    %esi
801070db:	5f                   	pop    %edi
801070dc:	5d                   	pop    %ebp
801070dd:	c3                   	ret    
801070de:	66 90                	xchg   %ax,%ax
    return oldsz;
801070e0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801070e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e6:	89 f8                	mov    %edi,%eax
801070e8:	5b                   	pop    %ebx
801070e9:	5e                   	pop    %esi
801070ea:	5f                   	pop    %edi
801070eb:	5d                   	pop    %ebp
801070ec:	c3                   	ret    
801070ed:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	68 c5 93 10 80       	push   $0x801093c5
801070f8:	e8 63 95 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801070fd:	83 c4 10             	add    $0x10,%esp
80107100:	8b 45 0c             	mov    0xc(%ebp),%eax
80107103:	39 45 10             	cmp    %eax,0x10(%ebp)
80107106:	76 0d                	jbe    80107115 <allocuvm+0xe5>
80107108:	89 c1                	mov    %eax,%ecx
8010710a:	8b 55 10             	mov    0x10(%ebp),%edx
8010710d:	8b 45 08             	mov    0x8(%ebp),%eax
80107110:	e8 7b fb ff ff       	call   80106c90 <deallocuvm.part.0>
      kfree(mem);
80107115:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107118:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010711a:	56                   	push   %esi
8010711b:	e8 f0 b5 ff ff       	call   80102710 <kfree>
      return 0;
80107120:	83 c4 10             	add    $0x10,%esp
}
80107123:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107126:	89 f8                	mov    %edi,%eax
80107128:	5b                   	pop    %ebx
80107129:	5e                   	pop    %esi
8010712a:	5f                   	pop    %edi
8010712b:	5d                   	pop    %ebp
8010712c:	c3                   	ret    
8010712d:	8d 76 00             	lea    0x0(%esi),%esi
80107130:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107133:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107136:	5b                   	pop    %ebx
80107137:	89 f8                	mov    %edi,%eax
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret    
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
80107140:	89 c1                	mov    %eax,%ecx
80107142:	8b 55 10             	mov    0x10(%ebp),%edx
80107145:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107148:	31 ff                	xor    %edi,%edi
8010714a:	e8 41 fb ff ff       	call   80106c90 <deallocuvm.part.0>
8010714f:	eb 92                	jmp    801070e3 <allocuvm+0xb3>
80107151:	eb 0d                	jmp    80107160 <deallocuvm>
80107153:	90                   	nop
80107154:	90                   	nop
80107155:	90                   	nop
80107156:	90                   	nop
80107157:	90                   	nop
80107158:	90                   	nop
80107159:	90                   	nop
8010715a:	90                   	nop
8010715b:	90                   	nop
8010715c:	90                   	nop
8010715d:	90                   	nop
8010715e:	90                   	nop
8010715f:	90                   	nop

80107160 <deallocuvm>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	8b 55 0c             	mov    0xc(%ebp),%edx
80107166:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107169:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010716c:	39 d1                	cmp    %edx,%ecx
8010716e:	73 10                	jae    80107180 <deallocuvm+0x20>
}
80107170:	5d                   	pop    %ebp
80107171:	e9 1a fb ff ff       	jmp    80106c90 <deallocuvm.part.0>
80107176:	8d 76 00             	lea    0x0(%esi),%esi
80107179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107180:	89 d0                	mov    %edx,%eax
80107182:	5d                   	pop    %ebp
80107183:	c3                   	ret    
80107184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010718a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107190 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
80107196:	83 ec 0c             	sub    $0xc,%esp
80107199:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010719c:	85 f6                	test   %esi,%esi
8010719e:	74 59                	je     801071f9 <freevm+0x69>
801071a0:	31 c9                	xor    %ecx,%ecx
801071a2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801071a7:	89 f0                	mov    %esi,%eax
801071a9:	e8 e2 fa ff ff       	call   80106c90 <deallocuvm.part.0>
801071ae:	89 f3                	mov    %esi,%ebx
801071b0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801071b6:	eb 0f                	jmp    801071c7 <freevm+0x37>
801071b8:	90                   	nop
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801071c3:	39 fb                	cmp    %edi,%ebx
801071c5:	74 23                	je     801071ea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801071c7:	8b 03                	mov    (%ebx),%eax
801071c9:	a8 01                	test   $0x1,%al
801071cb:	74 f3                	je     801071c0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071cd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801071d2:	83 ec 0c             	sub    $0xc,%esp
801071d5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801071d8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801071dd:	50                   	push   %eax
801071de:	e8 2d b5 ff ff       	call   80102710 <kfree>
801071e3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801071e6:	39 fb                	cmp    %edi,%ebx
801071e8:	75 dd                	jne    801071c7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801071ea:	89 75 08             	mov    %esi,0x8(%ebp)
}
801071ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f0:	5b                   	pop    %ebx
801071f1:	5e                   	pop    %esi
801071f2:	5f                   	pop    %edi
801071f3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801071f4:	e9 17 b5 ff ff       	jmp    80102710 <kfree>
    panic("freevm: no pgdir");
801071f9:	83 ec 0c             	sub    $0xc,%esp
801071fc:	68 e1 93 10 80       	push   $0x801093e1
80107201:	e8 8a 91 ff ff       	call   80100390 <panic>
80107206:	8d 76 00             	lea    0x0(%esi),%esi
80107209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107210 <setupkvm>:
{
80107210:	55                   	push   %ebp
80107211:	89 e5                	mov    %esp,%ebp
80107213:	56                   	push   %esi
80107214:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107215:	e8 a6 b6 ff ff       	call   801028c0 <kalloc>
8010721a:	85 c0                	test   %eax,%eax
8010721c:	89 c6                	mov    %eax,%esi
8010721e:	74 42                	je     80107262 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107223:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107228:	68 00 10 00 00       	push   $0x1000
8010722d:	6a 00                	push   $0x0
8010722f:	50                   	push   %eax
80107230:	e8 bb d7 ff ff       	call   801049f0 <memset>
80107235:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107238:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010723b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010723e:	83 ec 08             	sub    $0x8,%esp
80107241:	8b 13                	mov    (%ebx),%edx
80107243:	ff 73 0c             	pushl  0xc(%ebx)
80107246:	50                   	push   %eax
80107247:	29 c1                	sub    %eax,%ecx
80107249:	89 f0                	mov    %esi,%eax
8010724b:	e8 b0 f9 ff ff       	call   80106c00 <mappages>
80107250:	83 c4 10             	add    $0x10,%esp
80107253:	85 c0                	test   %eax,%eax
80107255:	78 19                	js     80107270 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107257:	83 c3 10             	add    $0x10,%ebx
8010725a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107260:	75 d6                	jne    80107238 <setupkvm+0x28>
}
80107262:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107265:	89 f0                	mov    %esi,%eax
80107267:	5b                   	pop    %ebx
80107268:	5e                   	pop    %esi
80107269:	5d                   	pop    %ebp
8010726a:	c3                   	ret    
8010726b:	90                   	nop
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107270:	83 ec 0c             	sub    $0xc,%esp
80107273:	56                   	push   %esi
      return 0;
80107274:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107276:	e8 15 ff ff ff       	call   80107190 <freevm>
      return 0;
8010727b:	83 c4 10             	add    $0x10,%esp
}
8010727e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107281:	89 f0                	mov    %esi,%eax
80107283:	5b                   	pop    %ebx
80107284:	5e                   	pop    %esi
80107285:	5d                   	pop    %ebp
80107286:	c3                   	ret    
80107287:	89 f6                	mov    %esi,%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <kvmalloc>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107296:	e8 75 ff ff ff       	call   80107210 <setupkvm>
8010729b:	a3 04 75 11 80       	mov    %eax,0x80117504
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072a0:	05 00 00 00 80       	add    $0x80000000,%eax
801072a5:	0f 22 d8             	mov    %eax,%cr3
}
801072a8:	c9                   	leave  
801072a9:	c3                   	ret    
801072aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072b0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801072b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072b1:	31 c9                	xor    %ecx,%ecx
{
801072b3:	89 e5                	mov    %esp,%ebp
801072b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072bb:	8b 45 08             	mov    0x8(%ebp),%eax
801072be:	e8 bd f8 ff ff       	call   80106b80 <walkpgdir>
  if(pte == 0)
801072c3:	85 c0                	test   %eax,%eax
801072c5:	74 05                	je     801072cc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801072c7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801072ca:	c9                   	leave  
801072cb:	c3                   	ret    
    panic("clearpteu");
801072cc:	83 ec 0c             	sub    $0xc,%esp
801072cf:	68 f2 93 10 80       	push   $0x801093f2
801072d4:	e8 b7 90 ff ff       	call   80100390 <panic>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801072e9:	e8 22 ff ff ff       	call   80107210 <setupkvm>
801072ee:	85 c0                	test   %eax,%eax
801072f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072f3:	0f 84 9f 00 00 00    	je     80107398 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801072f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801072fc:	85 c9                	test   %ecx,%ecx
801072fe:	0f 84 94 00 00 00    	je     80107398 <copyuvm+0xb8>
80107304:	31 ff                	xor    %edi,%edi
80107306:	eb 4a                	jmp    80107352 <copyuvm+0x72>
80107308:	90                   	nop
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107310:	83 ec 04             	sub    $0x4,%esp
80107313:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107319:	68 00 10 00 00       	push   $0x1000
8010731e:	53                   	push   %ebx
8010731f:	50                   	push   %eax
80107320:	e8 7b d7 ff ff       	call   80104aa0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107325:	58                   	pop    %eax
80107326:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010732c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107331:	5a                   	pop    %edx
80107332:	ff 75 e4             	pushl  -0x1c(%ebp)
80107335:	50                   	push   %eax
80107336:	89 fa                	mov    %edi,%edx
80107338:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010733b:	e8 c0 f8 ff ff       	call   80106c00 <mappages>
80107340:	83 c4 10             	add    $0x10,%esp
80107343:	85 c0                	test   %eax,%eax
80107345:	78 61                	js     801073a8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107347:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010734d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107350:	76 46                	jbe    80107398 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107352:	8b 45 08             	mov    0x8(%ebp),%eax
80107355:	31 c9                	xor    %ecx,%ecx
80107357:	89 fa                	mov    %edi,%edx
80107359:	e8 22 f8 ff ff       	call   80106b80 <walkpgdir>
8010735e:	85 c0                	test   %eax,%eax
80107360:	74 61                	je     801073c3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107362:	8b 00                	mov    (%eax),%eax
80107364:	a8 01                	test   $0x1,%al
80107366:	74 4e                	je     801073b6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107368:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010736a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010736f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107378:	e8 43 b5 ff ff       	call   801028c0 <kalloc>
8010737d:	85 c0                	test   %eax,%eax
8010737f:	89 c6                	mov    %eax,%esi
80107381:	75 8d                	jne    80107310 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107383:	83 ec 0c             	sub    $0xc,%esp
80107386:	ff 75 e0             	pushl  -0x20(%ebp)
80107389:	e8 02 fe ff ff       	call   80107190 <freevm>
  return 0;
8010738e:	83 c4 10             	add    $0x10,%esp
80107391:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107398:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010739b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010739e:	5b                   	pop    %ebx
8010739f:	5e                   	pop    %esi
801073a0:	5f                   	pop    %edi
801073a1:	5d                   	pop    %ebp
801073a2:	c3                   	ret    
801073a3:	90                   	nop
801073a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801073a8:	83 ec 0c             	sub    $0xc,%esp
801073ab:	56                   	push   %esi
801073ac:	e8 5f b3 ff ff       	call   80102710 <kfree>
      goto bad;
801073b1:	83 c4 10             	add    $0x10,%esp
801073b4:	eb cd                	jmp    80107383 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801073b6:	83 ec 0c             	sub    $0xc,%esp
801073b9:	68 16 94 10 80       	push   $0x80109416
801073be:	e8 cd 8f ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801073c3:	83 ec 0c             	sub    $0xc,%esp
801073c6:	68 fc 93 10 80       	push   $0x801093fc
801073cb:	e8 c0 8f ff ff       	call   80100390 <panic>

801073d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801073d0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073d1:	31 c9                	xor    %ecx,%ecx
{
801073d3:	89 e5                	mov    %esp,%ebp
801073d5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073db:	8b 45 08             	mov    0x8(%ebp),%eax
801073de:	e8 9d f7 ff ff       	call   80106b80 <walkpgdir>
  if((*pte & PTE_P) == 0)
801073e3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801073e5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801073e6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073e8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801073ed:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801073f0:	05 00 00 00 80       	add    $0x80000000,%eax
801073f5:	83 fa 05             	cmp    $0x5,%edx
801073f8:	ba 00 00 00 00       	mov    $0x0,%edx
801073fd:	0f 45 c2             	cmovne %edx,%eax
}
80107400:	c3                   	ret    
80107401:	eb 0d                	jmp    80107410 <copyout>
80107403:	90                   	nop
80107404:	90                   	nop
80107405:	90                   	nop
80107406:	90                   	nop
80107407:	90                   	nop
80107408:	90                   	nop
80107409:	90                   	nop
8010740a:	90                   	nop
8010740b:	90                   	nop
8010740c:	90                   	nop
8010740d:	90                   	nop
8010740e:	90                   	nop
8010740f:	90                   	nop

80107410 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107410:	55                   	push   %ebp
80107411:	89 e5                	mov    %esp,%ebp
80107413:	57                   	push   %edi
80107414:	56                   	push   %esi
80107415:	53                   	push   %ebx
80107416:	83 ec 1c             	sub    $0x1c,%esp
80107419:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010741c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010741f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107422:	85 db                	test   %ebx,%ebx
80107424:	75 40                	jne    80107466 <copyout+0x56>
80107426:	eb 70                	jmp    80107498 <copyout+0x88>
80107428:	90                   	nop
80107429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107430:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107433:	89 f1                	mov    %esi,%ecx
80107435:	29 d1                	sub    %edx,%ecx
80107437:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010743d:	39 d9                	cmp    %ebx,%ecx
8010743f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107442:	29 f2                	sub    %esi,%edx
80107444:	83 ec 04             	sub    $0x4,%esp
80107447:	01 d0                	add    %edx,%eax
80107449:	51                   	push   %ecx
8010744a:	57                   	push   %edi
8010744b:	50                   	push   %eax
8010744c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010744f:	e8 4c d6 ff ff       	call   80104aa0 <memmove>
    len -= n;
    buf += n;
80107454:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107457:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010745a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107460:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107462:	29 cb                	sub    %ecx,%ebx
80107464:	74 32                	je     80107498 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107466:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107468:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010746b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010746e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107474:	56                   	push   %esi
80107475:	ff 75 08             	pushl  0x8(%ebp)
80107478:	e8 53 ff ff ff       	call   801073d0 <uva2ka>
    if(pa0 == 0)
8010747d:	83 c4 10             	add    $0x10,%esp
80107480:	85 c0                	test   %eax,%eax
80107482:	75 ac                	jne    80107430 <copyout+0x20>
  }
  return 0;
}
80107484:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010748c:	5b                   	pop    %ebx
8010748d:	5e                   	pop    %esi
8010748e:	5f                   	pop    %edi
8010748f:	5d                   	pop    %ebp
80107490:	c3                   	ret    
80107491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107498:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010749b:	31 c0                	xor    %eax,%eax
}
8010749d:	5b                   	pop    %ebx
8010749e:	5e                   	pop    %esi
8010749f:	5f                   	pop    %edi
801074a0:	5d                   	pop    %ebp
801074a1:	c3                   	ret    
801074a2:	66 90                	xchg   %ax,%ax
801074a4:	66 90                	xchg   %ax,%ax
801074a6:	66 90                	xchg   %ax,%ax
801074a8:	66 90                	xchg   %ax,%ax
801074aa:	66 90                	xchg   %ax,%ax
801074ac:	66 90                	xchg   %ax,%ax
801074ae:	66 90                	xchg   %ax,%ax

801074b0 <procfsiread>:
    return (ip->inum < sbInodes || ip->inum % PROCINODES == 0 || ip->inum == INODEINFO);
//    return (ip->inum < sbInodes || ip->inum % PROCINODES == 0 || ip->inum % PROCINODES == 1|| ip->inum == INODEINFO);
}

void
procfsiread(struct inode *dp, struct inode *ip) {
801074b0:	55                   	push   %ebp
    ip->major = PROCFS;
    ip->valid = VALID;  //todo - maybe need to turn on flag ->  |=0x2
    ip->type = T_DEV;
    ip->nlink = 1;//todo
801074b1:	ba 01 00 00 00       	mov    $0x1,%edx
procfsiread(struct inode *dp, struct inode *ip) {
801074b6:	89 e5                	mov    %esp,%ebp
801074b8:	8b 45 0c             	mov    0xc(%ebp),%eax
    ip->valid = VALID;  //todo - maybe need to turn on flag ->  |=0x2
801074bb:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
801074c2:	c7 40 50 03 00 02 00 	movl   $0x20003,0x50(%eax)
    ip->nlink = 1;//todo
801074c9:	66 89 50 56          	mov    %dx,0x56(%eax)
}
801074cd:	5d                   	pop    %ebp
801074ce:	c3                   	ret    
801074cf:	90                   	nop

801074d0 <procfswrite>:
    else
        return n;
}

int
procfswrite(struct inode *ip, char *buf, int n) {
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	83 ec 14             	sub    $0x14,%esp
    cprintf("ERROR - Cannot write in this system\n");
801074d6:	68 54 94 10 80       	push   $0x80109454
801074db:	e8 80 91 ff ff       	call   80100660 <cprintf>
    return -1;
}
801074e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074e5:	c9                   	leave  
801074e6:	c3                   	ret    
801074e7:	89 f6                	mov    %esi,%esi
801074e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074f0 <initSbInodes.part.0>:
void initSbInodes(struct inode *ip) {
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	83 ec 30             	sub    $0x30,%esp
        readsb(ip->dev, &sb);
801074f6:	8d 55 dc             	lea    -0x24(%ebp),%edx
801074f9:	52                   	push   %edx
801074fa:	ff 30                	pushl  (%eax)
801074fc:	e8 3f a0 ff ff       	call   80101540 <readsb>
        sbInodes = sb.ninodes;
80107501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107504:	83 c4 10             	add    $0x10,%esp
        IDEINFO = sbInodes + 1;
80107507:	8d 50 01             	lea    0x1(%eax),%edx
        sbInodes = sb.ninodes;
8010750a:	a3 d0 c5 10 80       	mov    %eax,0x8010c5d0
        IDEINFO = sbInodes + 1;
8010750f:	89 15 cc c5 10 80    	mov    %edx,0x8010c5cc
        FILESTAT = sbInodes + 2;
80107515:	8d 50 02             	lea    0x2(%eax),%edx
80107518:	89 15 c8 c5 10 80    	mov    %edx,0x8010c5c8
        INODEINFO = sbInodes + 3;
8010751e:	8d 50 03             	lea    0x3(%eax),%edx
        VIRTUALINODEINFO = sbInodes + NPROC * (PROCINODES + 1); //offset for the virtual inodeInfo dirents
80107521:	05 c0 0c 00 00       	add    $0xcc0,%eax
80107526:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
        INODEINFO = sbInodes + 3;
8010752b:	89 15 c4 c5 10 80    	mov    %edx,0x8010c5c4
}
80107531:	c9                   	leave  
80107532:	c3                   	ret    
80107533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107540 <procfsisdir>:
procfsisdir(struct inode *ip) {
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	53                   	push   %ebx
80107544:	83 ec 04             	sub    $0x4,%esp
    if (!sbInodes) {
80107547:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
procfsisdir(struct inode *ip) {
8010754c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (!sbInodes) {
8010754f:	85 c0                	test   %eax,%eax
80107551:	74 5d                	je     801075b0 <procfsisdir+0x70>
        return 0;
80107553:	31 c9                	xor    %ecx,%ecx
    if (ip->type != T_DEV)
80107555:	66 83 7b 50 03       	cmpw   $0x3,0x50(%ebx)
8010755a:	74 0c                	je     80107568 <procfsisdir+0x28>
}
8010755c:	83 c4 04             	add    $0x4,%esp
8010755f:	89 c8                	mov    %ecx,%eax
80107561:	5b                   	pop    %ebx
80107562:	5d                   	pop    %ebp
80107563:	c3                   	ret    
80107564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (ip->major != PROCFS)
80107568:	66 83 7b 52 02       	cmpw   $0x2,0x52(%ebx)
8010756d:	75 ed                	jne    8010755c <procfsisdir+0x1c>
    if (ip->inum == IDEINFO || ip->inum == FILESTAT )//|| ip->inum == INODEINFO)
8010756f:	8b 5b 04             	mov    0x4(%ebx),%ebx
80107572:	3b 1d cc c5 10 80    	cmp    0x8010c5cc,%ebx
80107578:	74 e2                	je     8010755c <procfsisdir+0x1c>
8010757a:	3b 1d c8 c5 10 80    	cmp    0x8010c5c8,%ebx
80107580:	74 da                	je     8010755c <procfsisdir+0x1c>
    return (ip->inum < sbInodes || ip->inum % PROCINODES == 0 || ip->inum == INODEINFO);
80107582:	3b 1d d0 c5 10 80    	cmp    0x8010c5d0,%ebx
80107588:	b9 01 00 00 00       	mov    $0x1,%ecx
8010758d:	72 cd                	jb     8010755c <procfsisdir+0x1c>
8010758f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80107594:	89 d8                	mov    %ebx,%eax
80107596:	f7 e2                	mul    %edx
80107598:	c1 ea 04             	shr    $0x4,%edx
8010759b:	6b d2 32             	imul   $0x32,%edx,%edx
8010759e:	39 d3                	cmp    %edx,%ebx
801075a0:	74 ba                	je     8010755c <procfsisdir+0x1c>
801075a2:	31 c9                	xor    %ecx,%ecx
801075a4:	39 1d c4 c5 10 80    	cmp    %ebx,0x8010c5c4
801075aa:	0f 94 c1             	sete   %cl
801075ad:	eb ad                	jmp    8010755c <procfsisdir+0x1c>
801075af:	90                   	nop
801075b0:	89 d8                	mov    %ebx,%eax
801075b2:	e8 39 ff ff ff       	call   801074f0 <initSbInodes.part.0>
801075b7:	eb 9a                	jmp    80107553 <procfsisdir+0x13>
801075b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075c0 <itoa.part.2>:
char *itoa(int num, char *str) {
801075c0:	55                   	push   %ebp
    while (num != 0) {
801075c1:	85 c0                	test   %eax,%eax
char *itoa(int num, char *str) {
801075c3:	89 e5                	mov    %esp,%ebp
801075c5:	57                   	push   %edi
801075c6:	56                   	push   %esi
801075c7:	89 d6                	mov    %edx,%esi
801075c9:	53                   	push   %ebx
    while (num != 0) {
801075ca:	74 64                	je     80107630 <itoa.part.2+0x70>
801075cc:	89 c1                	mov    %eax,%ecx
    int i = 0;
801075ce:	31 db                	xor    %ebx,%ebx
801075d0:	eb 08                	jmp    801075da <itoa.part.2+0x1a>
801075d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801075d8:	89 fb                	mov    %edi,%ebx
        int rem = num % 10;
801075da:	b8 67 66 66 66       	mov    $0x66666667,%eax
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801075df:	8d 7b 01             	lea    0x1(%ebx),%edi
        int rem = num % 10;
801075e2:	f7 e9                	imul   %ecx
801075e4:	89 c8                	mov    %ecx,%eax
801075e6:	c1 f8 1f             	sar    $0x1f,%eax
801075e9:	c1 fa 02             	sar    $0x2,%edx
801075ec:	29 c2                	sub    %eax,%edx
801075ee:	8d 04 92             	lea    (%edx,%edx,4),%eax
801075f1:	01 c0                	add    %eax,%eax
801075f3:	29 c1                	sub    %eax,%ecx
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801075f5:	83 c1 30             	add    $0x30,%ecx
    while (num != 0) {
801075f8:	85 d2                	test   %edx,%edx
        str[i++] = (rem > 9) ? (rem - 10) + 'a' : rem + '0';
801075fa:	88 4c 3e ff          	mov    %cl,-0x1(%esi,%edi,1)
        num = num / 10;
801075fe:	89 d1                	mov    %edx,%ecx
    while (num != 0) {
80107600:	75 d6                	jne    801075d8 <itoa.part.2+0x18>
    while (start < end)
80107602:	85 db                	test   %ebx,%ebx
    str[i] = '\0'; // Append string terminator
80107604:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
    while (start < end)
80107608:	74 1e                	je     80107628 <itoa.part.2+0x68>
8010760a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        char tmp= str[start];
80107610:	0f b6 14 0e          	movzbl (%esi,%ecx,1),%edx
        str[start]=str[end];
80107614:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80107618:	88 04 0e             	mov    %al,(%esi,%ecx,1)
        str[end]=tmp;
8010761b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
        start++;
8010761e:	83 c1 01             	add    $0x1,%ecx
        end--;
80107621:	83 eb 01             	sub    $0x1,%ebx
    while (start < end)
80107624:	39 d9                	cmp    %ebx,%ecx
80107626:	7c e8                	jl     80107610 <itoa.part.2+0x50>
}
80107628:	5b                   	pop    %ebx
80107629:	5e                   	pop    %esi
8010762a:	5f                   	pop    %edi
8010762b:	5d                   	pop    %ebp
8010762c:	c3                   	ret    
8010762d:	8d 76 00             	lea    0x0(%esi),%esi
    str[i] = '\0'; // Append string terminator
80107630:	c6 02 00             	movb   $0x0,(%edx)
}
80107633:	5b                   	pop    %ebx
80107634:	5e                   	pop    %esi
80107635:	5f                   	pop    %edi
80107636:	5d                   	pop    %ebp
80107637:	c3                   	ret    
80107638:	90                   	nop
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107640 <initSbInodes>:
    if (!sbInodes) {
80107640:	8b 15 d0 c5 10 80    	mov    0x8010c5d0,%edx
void initSbInodes(struct inode *ip) {
80107646:	55                   	push   %ebp
80107647:	89 e5                	mov    %esp,%ebp
    if (!sbInodes) {
80107649:	85 d2                	test   %edx,%edx
void initSbInodes(struct inode *ip) {
8010764b:	8b 45 08             	mov    0x8(%ebp),%eax
    if (!sbInodes) {
8010764e:	74 08                	je     80107658 <initSbInodes+0x18>
}
80107650:	5d                   	pop    %ebp
80107651:	c3                   	ret    
80107652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107658:	5d                   	pop    %ebp
80107659:	e9 92 fe ff ff       	jmp    801074f0 <initSbInodes.part.0>
8010765e:	66 90                	xchg   %ax,%ax

80107660 <itoa>:
char *itoa(int num, char *str) {
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	53                   	push   %ebx
80107664:	8b 45 08             	mov    0x8(%ebp),%eax
80107667:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (num == 0) {
8010766a:	85 c0                	test   %eax,%eax
8010766c:	74 12                	je     80107680 <itoa+0x20>
8010766e:	89 da                	mov    %ebx,%edx
80107670:	e8 4b ff ff ff       	call   801075c0 <itoa.part.2>
}
80107675:	89 d8                	mov    %ebx,%eax
80107677:	5b                   	pop    %ebx
80107678:	5d                   	pop    %ebp
80107679:	c3                   	ret    
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        str[i++] = '0';
80107680:	b8 30 00 00 00       	mov    $0x30,%eax
80107685:	66 89 03             	mov    %ax,(%ebx)
}
80107688:	89 d8                	mov    %ebx,%eax
8010768a:	5b                   	pop    %ebx
8010768b:	5d                   	pop    %ebp
8010768c:	c3                   	ret    
8010768d:	8d 76 00             	lea    0x0(%esi),%esi

80107690 <procInodeIndex>:
void procInodeIndex(int IPinum, int *proc, int *procfd, int flag) {
80107690:	55                   	push   %ebp
    if (IPinum >= sbInodes + PROCINODES) {
80107691:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
void procInodeIndex(int IPinum, int *proc, int *procfd, int flag) {
80107696:	89 e5                	mov    %esp,%ebp
80107698:	56                   	push   %esi
80107699:	53                   	push   %ebx
8010769a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (IPinum >= sbInodes + PROCINODES) {
8010769d:	8d 50 31             	lea    0x31(%eax),%edx
801076a0:	39 da                	cmp    %ebx,%edx
801076a2:	7d 46                	jge    801076ea <procInodeIndex+0x5a>
        *proc = (IPinum - sbInodes) / PROCINODES - 1;
801076a4:	89 de                	mov    %ebx,%esi
801076a6:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
801076ab:	29 c6                	sub    %eax,%esi
801076ad:	89 f0                	mov    %esi,%eax
801076af:	c1 fe 1f             	sar    $0x1f,%esi
801076b2:	f7 e9                	imul   %ecx
801076b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801076b7:	c1 fa 04             	sar    $0x4,%edx
801076ba:	29 f2                	sub    %esi,%edx
801076bc:	83 ea 01             	sub    $0x1,%edx
801076bf:	89 10                	mov    %edx,(%eax)
        if (flag) {
801076c1:	8b 45 14             	mov    0x14(%ebp),%eax
801076c4:	85 c0                	test   %eax,%eax
801076c6:	74 22                	je     801076ea <procInodeIndex+0x5a>
            if ((IPinum % PROCINODES) >= 10)
801076c8:	89 d8                	mov    %ebx,%eax
801076ca:	f7 e9                	imul   %ecx
801076cc:	89 d8                	mov    %ebx,%eax
801076ce:	c1 f8 1f             	sar    $0x1f,%eax
801076d1:	c1 fa 04             	sar    $0x4,%edx
801076d4:	29 c2                	sub    %eax,%edx
801076d6:	6b d2 32             	imul   $0x32,%edx,%edx
801076d9:	29 d3                	sub    %edx,%ebx
801076db:	83 fb 09             	cmp    $0x9,%ebx
801076de:	89 da                	mov    %ebx,%edx
801076e0:	7e 0f                	jle    801076f1 <procInodeIndex+0x61>
                *procfd = (IPinum % PROCINODES) - 10;
801076e2:	8b 45 10             	mov    0x10(%ebp),%eax
801076e5:	83 ea 0a             	sub    $0xa,%edx
801076e8:	89 10                	mov    %edx,(%eax)
}
801076ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076ed:	5b                   	pop    %ebx
801076ee:	5e                   	pop    %esi
801076ef:	5d                   	pop    %ebp
801076f0:	c3                   	ret    
                panic("flag is on while not expected");
801076f1:	83 ec 0c             	sub    $0xc,%esp
801076f4:	68 50 95 10 80       	push   $0x80109550
801076f9:	e8 92 8c ff ff       	call   80100390 <panic>
801076fe:	66 90                	xchg   %ax,%ax

80107700 <writeDirentToBuff>:
void writeDirentToBuff(int currDirent, char *name, int IPinum, char *designBuffer) {
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	53                   	push   %ebx
80107704:	83 ec 20             	sub    $0x20,%esp
80107707:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    newDirent.inum = (ushort) IPinum;
8010770a:	8b 45 10             	mov    0x10(%ebp),%eax
    memmove(&newDirent.name, name, (uint) (strlen(name) + 1));
8010770d:	53                   	push   %ebx
    newDirent.inum = (ushort) IPinum;
8010770e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
    memmove(&newDirent.name, name, (uint) (strlen(name) + 1));
80107712:	e8 f9 d4 ff ff       	call   80104c10 <strlen>
80107717:	83 c4 0c             	add    $0xc,%esp
8010771a:	83 c0 01             	add    $0x1,%eax
8010771d:	50                   	push   %eax
8010771e:	8d 45 ea             	lea    -0x16(%ebp),%eax
80107721:	53                   	push   %ebx
80107722:	8d 5d e8             	lea    -0x18(%ebp),%ebx
80107725:	50                   	push   %eax
80107726:	e8 75 d3 ff ff       	call   80104aa0 <memmove>
    int offset = currDirent * size;
8010772b:	8b 45 08             	mov    0x8(%ebp),%eax
    memmove(designBuffer + offset, &newDirent, (uint) size);
8010772e:	83 c4 0c             	add    $0xc,%esp
80107731:	6a 10                	push   $0x10
80107733:	53                   	push   %ebx
    int offset = currDirent * size;
80107734:	c1 e0 04             	shl    $0x4,%eax
    memmove(designBuffer + offset, &newDirent, (uint) size);
80107737:	03 45 14             	add    0x14(%ebp),%eax
8010773a:	50                   	push   %eax
8010773b:	e8 60 d3 ff ff       	call   80104aa0 <memmove>
}
80107740:	83 c4 10             	add    $0x10,%esp
80107743:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107746:	c9                   	leave  
80107747:	c3                   	ret    
80107748:	90                   	nop
80107749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107750 <writeToBuff>:
void writeToBuff(char *name, char *designBuffer) {
80107750:	55                   	push   %ebp
80107751:	89 e5                	mov    %esp,%ebp
80107753:	57                   	push   %edi
80107754:	56                   	push   %esi
80107755:	53                   	push   %ebx
80107756:	83 ec 0c             	sub    $0xc,%esp
80107759:	8b 75 08             	mov    0x8(%ebp),%esi
8010775c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (!name)
8010775f:	85 f6                	test   %esi,%esi
80107761:	74 2b                	je     8010778e <writeToBuff+0x3e>
    int len = strlen(name);
80107763:	83 ec 0c             	sub    $0xc,%esp
80107766:	56                   	push   %esi
80107767:	e8 a4 d4 ff ff       	call   80104c10 <strlen>
    int sz = strlen(designBuffer);
8010776c:	89 1c 24             	mov    %ebx,(%esp)
    int len = strlen(name);
8010776f:	89 c7                	mov    %eax,%edi
    int sz = strlen(designBuffer);
80107771:	e8 9a d4 ff ff       	call   80104c10 <strlen>
    memmove(designBuffer + sz, name, (uint) len);
80107776:	83 c4 0c             	add    $0xc,%esp
80107779:	01 c3                	add    %eax,%ebx
8010777b:	57                   	push   %edi
8010777c:	56                   	push   %esi
8010777d:	53                   	push   %ebx
8010777e:	e8 1d d3 ff ff       	call   80104aa0 <memmove>
}
80107783:	83 c4 10             	add    $0x10,%esp
80107786:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107789:	5b                   	pop    %ebx
8010778a:	5e                   	pop    %esi
8010778b:	5f                   	pop    %edi
8010778c:	5d                   	pop    %ebp
8010778d:	c3                   	ret    
        panic("ERROR - writeToBuff: NAME IS NULL!");
8010778e:	83 ec 0c             	sub    $0xc,%esp
80107791:	68 7c 94 10 80       	push   $0x8010947c
80107796:	e8 f5 8b ff ff       	call   80100390 <panic>
8010779b:	90                   	nop
8010779c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077a0 <cleanName>:
void cleanName(char *name) {
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	8b 45 08             	mov    0x8(%ebp),%eax
801077a6:	8d 50 0e             	lea    0xe(%eax),%edx
801077a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
801077b0:	c6 00 00             	movb   $0x0,(%eax)
801077b3:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
801077b6:	39 d0                	cmp    %edx,%eax
801077b8:	75 f6                	jne    801077b0 <cleanName+0x10>
}
801077ba:	5d                   	pop    %ebp
801077bb:	c3                   	ret    
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801077c0 <ReadFromMemInodes>:
int ReadFromMemInodes(char *designBuffer, int IPinum) {
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
    int procName[NPROC] = {0}; //array of RUNNING/RUNNABLE/SLEEPING procs
801077c6:	8d bd e8 fe ff ff    	lea    -0x118(%ebp),%edi
    int numProcs = getValidProcs(procName);
801077cc:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
int ReadFromMemInodes(char *designBuffer, int IPinum) {
801077d2:	81 ec 38 01 00 00    	sub    $0x138,%esp
    writeDirentToBuff(currDirent, ".", namei("/proc")->inum, designBuffer);
801077d8:	68 6e 95 10 80       	push   $0x8010956e
801077dd:	e8 6e aa ff ff       	call   80102250 <namei>
801077e2:	ff 75 08             	pushl  0x8(%ebp)
801077e5:	ff 70 04             	pushl  0x4(%eax)
801077e8:	68 bc 91 10 80       	push   $0x801091bc
801077ed:	6a 00                	push   $0x0
801077ef:	e8 0c ff ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "..", namei("")->inum, designBuffer);
801077f4:	83 c4 14             	add    $0x14,%esp
801077f7:	68 c9 96 10 80       	push   $0x801096c9
801077fc:	e8 4f aa ff ff       	call   80102250 <namei>
80107801:	ff 75 08             	pushl  0x8(%ebp)
80107804:	ff 70 04             	pushl  0x4(%eax)
80107807:	68 bb 91 10 80       	push   $0x801091bb
8010780c:	6a 01                	push   $0x1
8010780e:	e8 ed fe ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "ideinfo", IDEINFO, designBuffer);
80107813:	83 c4 20             	add    $0x20,%esp
80107816:	ff 75 08             	pushl  0x8(%ebp)
80107819:	ff 35 cc c5 10 80    	pushl  0x8010c5cc
8010781f:	68 74 95 10 80       	push   $0x80109574
80107824:	6a 02                	push   $0x2
80107826:	e8 d5 fe ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "filestat", FILESTAT, designBuffer);
8010782b:	ff 75 08             	pushl  0x8(%ebp)
8010782e:	ff 35 c8 c5 10 80    	pushl  0x8010c5c8
80107834:	68 7c 95 10 80       	push   $0x8010957c
80107839:	6a 03                	push   $0x3
8010783b:	e8 c0 fe ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "inodeinfo", INODEINFO, designBuffer);
80107840:	83 c4 20             	add    $0x20,%esp
80107843:	ff 75 08             	pushl  0x8(%ebp)
80107846:	ff 35 c4 c5 10 80    	pushl  0x8010c5c4
8010784c:	68 85 95 10 80       	push   $0x80109585
80107851:	6a 04                	push   $0x4
80107853:	e8 a8 fe ff ff       	call   80107700 <writeDirentToBuff>
    int procName[NPROC] = {0}; //array of RUNNING/RUNNABLE/SLEEPING procs
80107858:	31 c0                	xor    %eax,%eax
    char procNameString[DIRSIZ] = {0}; //used to iota the pid to string
8010785a:	31 d2                	xor    %edx,%edx
    int procName[NPROC] = {0}; //array of RUNNING/RUNNABLE/SLEEPING procs
8010785c:	b9 40 00 00 00       	mov    $0x40,%ecx
80107861:	f3 ab                	rep stos %eax,%es:(%edi)
    char procNameString[DIRSIZ] = {0}; //used to iota the pid to string
80107863:	c7 85 da fe ff ff 00 	movl   $0x0,-0x126(%ebp)
8010786a:	00 00 00 
    int numProcs = getValidProcs(procName);
8010786d:	89 1c 24             	mov    %ebx,(%esp)
    char procNameString[DIRSIZ] = {0}; //used to iota the pid to string
80107870:	c7 85 de fe ff ff 00 	movl   $0x0,-0x122(%ebp)
80107877:	00 00 00 
8010787a:	c7 85 e2 fe ff ff 00 	movl   $0x0,-0x11e(%ebp)
80107881:	00 00 00 
80107884:	66 89 95 e6 fe ff ff 	mov    %dx,-0x11a(%ebp)
    int numProcs = getValidProcs(procName);
8010788b:	e8 40 cc ff ff       	call   801044d0 <getValidProcs>
    for (int i = 0; i < numProcs; i++) {
80107890:	83 c4 10             	add    $0x10,%esp
80107893:	85 c0                	test   %eax,%eax
80107895:	0f 8e 8a 00 00 00    	jle    80107925 <ReadFromMemInodes+0x165>
8010789b:	83 c0 05             	add    $0x5,%eax
8010789e:	be 32 00 00 00       	mov    $0x32,%esi
    currDirent++;
801078a3:	bf 05 00 00 00       	mov    $0x5,%edi
801078a8:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
801078ae:	66 90                	xchg   %ax,%ax
801078b0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
801078b6:	8d 76 00             	lea    0x0(%esi),%esi
801078b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        name[i] = 0;
801078c0:	c6 00 00             	movb   $0x0,(%eax)
801078c3:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
801078c6:	39 d8                	cmp    %ebx,%eax
801078c8:	75 f6                	jne    801078c0 <ReadFromMemInodes+0x100>
        char *pidNameInString = itoa(procName[i], procNameString);
801078ca:	8b 44 bb ec          	mov    -0x14(%ebx,%edi,4),%eax
    if (num == 0) {
801078ce:	85 c0                	test   %eax,%eax
801078d0:	75 46                	jne    80107918 <ReadFromMemInodes+0x158>
        str[i++] = '0';
801078d2:	b8 30 00 00 00       	mov    $0x30,%eax
801078d7:	66 89 85 da fe ff ff 	mov    %ax,-0x126(%ebp)
        int currLocation = sbInodes + PROCINODES * (i + 1);
801078de:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
        writeDirentToBuff(currDirent, pidNameInString, currLocation, designBuffer);
801078e3:	ff 75 08             	pushl  0x8(%ebp)
        int currLocation = sbInodes + PROCINODES * (i + 1);
801078e6:	01 f0                	add    %esi,%eax
801078e8:	83 c6 32             	add    $0x32,%esi
        writeDirentToBuff(currDirent, pidNameInString, currLocation, designBuffer);
801078eb:	50                   	push   %eax
801078ec:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
801078f2:	50                   	push   %eax
801078f3:	57                   	push   %edi
        currDirent++;
801078f4:	83 c7 01             	add    $0x1,%edi
        writeDirentToBuff(currDirent, pidNameInString, currLocation, designBuffer);
801078f7:	e8 04 fe ff ff       	call   80107700 <writeDirentToBuff>
    for (int i = 0; i < numProcs; i++) {
801078fc:	83 c4 10             	add    $0x10,%esp
801078ff:	3b bd d4 fe ff ff    	cmp    -0x12c(%ebp),%edi
80107905:	75 a9                	jne    801078b0 <ReadFromMemInodes+0xf0>
}
80107907:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010790a:	89 f8                	mov    %edi,%eax
8010790c:	c1 e0 04             	shl    $0x4,%eax
8010790f:	5b                   	pop    %ebx
80107910:	5e                   	pop    %esi
80107911:	5f                   	pop    %edi
80107912:	5d                   	pop    %ebp
80107913:	c3                   	ret    
80107914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107918:	8d 95 da fe ff ff    	lea    -0x126(%ebp),%edx
8010791e:	e8 9d fc ff ff       	call   801075c0 <itoa.part.2>
80107923:	eb b9                	jmp    801078de <ReadFromMemInodes+0x11e>
80107925:	8d 65 f4             	lea    -0xc(%ebp),%esp
    for (int i = 0; i < numProcs; i++) {
80107928:	b8 50 00 00 00       	mov    $0x50,%eax
}
8010792d:	5b                   	pop    %ebx
8010792e:	5e                   	pop    %esi
8010792f:	5f                   	pop    %edi
80107930:	5d                   	pop    %ebp
80107931:	c3                   	ret    
80107932:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107940 <getPath>:
void getPath(char searchDir, int fileIndex, char *folder) {
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
80107946:	83 ec 18             	sub    $0x18,%esp
80107949:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int currPid = getPid(fileIndex);
8010794c:	ff 75 0c             	pushl  0xc(%ebp)
void getPath(char searchDir, int fileIndex, char *folder) {
8010794f:	8b 7d 10             	mov    0x10(%ebp),%edi
    int currPid = getPid(fileIndex);
80107952:	e8 29 cc ff ff       	call   80104580 <getPid>
    memmove((void *) (searchDir + sizeof(folder)), folder, sizeof(*folder));
80107957:	0f be db             	movsbl %bl,%ebx
    int currPid = getPid(fileIndex);
8010795a:	89 c6                	mov    %eax,%esi
    memmove((void *) (searchDir + sizeof(folder)), folder, sizeof(*folder));
8010795c:	83 c4 0c             	add    $0xc,%esp
8010795f:	8d 43 04             	lea    0x4(%ebx),%eax
80107962:	6a 01                	push   $0x1
80107964:	57                   	push   %edi
80107965:	50                   	push   %eax
80107966:	e8 35 d1 ff ff       	call   80104aa0 <memmove>
    if (num == 0) {
8010796b:	83 c4 10             	add    $0x10,%esp
8010796e:	85 f6                	test   %esi,%esi
80107970:	75 2e                	jne    801079a0 <getPath+0x60>
        str[i++] = '0';
80107972:	b8 30 00 00 00       	mov    $0x30,%eax
80107977:	66 a3 c9 96 10 80    	mov    %ax,0x801096c9
    memmove((void *) (searchDir + sizeof(*pidInString)), pidInString, sizeof(*pidInString));
8010797d:	83 c3 01             	add    $0x1,%ebx
80107980:	c7 45 10 01 00 00 00 	movl   $0x1,0x10(%ebp)
80107987:	c7 45 0c c9 96 10 80 	movl   $0x801096c9,0xc(%ebp)
8010798e:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80107991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107994:	5b                   	pop    %ebx
80107995:	5e                   	pop    %esi
80107996:	5f                   	pop    %edi
80107997:	5d                   	pop    %ebp
    memmove((void *) (searchDir + sizeof(*pidInString)), pidInString, sizeof(*pidInString));
80107998:	e9 03 d1 ff ff       	jmp    80104aa0 <memmove>
8010799d:	8d 76 00             	lea    0x0(%esi),%esi
801079a0:	ba c9 96 10 80       	mov    $0x801096c9,%edx
801079a5:	89 f0                	mov    %esi,%eax
801079a7:	e8 14 fc ff ff       	call   801075c0 <itoa.part.2>
801079ac:	eb cf                	jmp    8010797d <getPath+0x3d>
801079ae:	66 90                	xchg   %ax,%ax

801079b0 <ReadFromFileStat>:
int ReadFromFileStat(char *designBuffer, int IPinum) {
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	57                   	push   %edi
801079b4:	56                   	push   %esi
801079b5:	53                   	push   %ebx
    getFileStat(&free, &total, &ref, &read, &write, &inode);
801079b6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
int ReadFromFileStat(char *designBuffer, int IPinum) {
801079b9:	83 ec 54             	sub    $0x54,%esp
    getFileStat(&free, &total, &ref, &read, &write, &inode);
801079bc:	50                   	push   %eax
801079bd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801079c0:	50                   	push   %eax
801079c1:	8d 45 cc             	lea    -0x34(%ebp),%eax
801079c4:	50                   	push   %eax
801079c5:	8d 45 c8             	lea    -0x38(%ebp),%eax
801079c8:	50                   	push   %eax
801079c9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801079cc:	50                   	push   %eax
801079cd:	8d 45 c0             	lea    -0x40(%ebp),%eax
801079d0:	50                   	push   %eax
801079d1:	e8 3a 94 ff ff       	call   80100e10 <getFileStat>
    writeToBuff("\nFree fds:\t", designBuffer);
801079d6:	83 c4 18             	add    $0x18,%esp
801079d9:	ff 75 08             	pushl  0x8(%ebp)
801079dc:	68 8f 95 10 80       	push   $0x8010958f
801079e1:	e8 6a fd ff ff       	call   80107750 <writeToBuff>
    itoa(free, tmp);
801079e6:	8b 45 c0             	mov    -0x40(%ebp),%eax
    if (num == 0) {
801079e9:	83 c4 10             	add    $0x10,%esp
801079ec:	85 c0                	test   %eax,%eax
801079ee:	0f 85 fc 01 00 00    	jne    80107bf0 <ReadFromFileStat+0x240>
        str[i++] = '0';
801079f4:	b8 30 00 00 00       	mov    $0x30,%eax
801079f9:	66 89 45 da          	mov    %ax,-0x26(%ebp)
801079fd:	8d 45 da             	lea    -0x26(%ebp),%eax
80107a00:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    writeToBuff(tmp, designBuffer);
80107a03:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80107a06:	83 ec 08             	sub    $0x8,%esp
80107a09:	ff 75 08             	pushl  0x8(%ebp)
80107a0c:	56                   	push   %esi
80107a0d:	89 f7                	mov    %esi,%edi
80107a0f:	e8 3c fd ff ff       	call   80107750 <writeToBuff>
80107a14:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107a17:	83 c4 10             	add    $0x10,%esp
80107a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        name[i] = 0;
80107a20:	c6 06 00             	movb   $0x0,(%esi)
80107a23:	83 c6 01             	add    $0x1,%esi
    for (int i = 0; i < DIRSIZ; i++)
80107a26:	39 c6                	cmp    %eax,%esi
80107a28:	75 f6                	jne    80107a20 <ReadFromFileStat+0x70>
    writeToBuff("\nUnique inode fds:\t", designBuffer);
80107a2a:	83 ec 08             	sub    $0x8,%esp
80107a2d:	ff 75 08             	pushl  0x8(%ebp)
80107a30:	68 9b 95 10 80       	push   $0x8010959b
80107a35:	e8 16 fd ff ff       	call   80107750 <writeToBuff>
    itoa(inode, tmp);
80107a3a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    if (num == 0) {
80107a3d:	83 c4 10             	add    $0x10,%esp
80107a40:	85 c0                	test   %eax,%eax
80107a42:	0f 85 00 02 00 00    	jne    80107c48 <ReadFromFileStat+0x298>
        str[i++] = '0';
80107a48:	b8 30 00 00 00       	mov    $0x30,%eax
80107a4d:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107a51:	8b 5d b4             	mov    -0x4c(%ebp),%ebx
80107a54:	83 ec 08             	sub    $0x8,%esp
80107a57:	ff 75 08             	pushl  0x8(%ebp)
80107a5a:	53                   	push   %ebx
80107a5b:	e8 f0 fc ff ff       	call   80107750 <writeToBuff>
80107a60:	83 c4 10             	add    $0x10,%esp
80107a63:	90                   	nop
80107a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
80107a68:	c6 03 00             	movb   $0x0,(%ebx)
80107a6b:	83 c3 01             	add    $0x1,%ebx
    for (int i = 0; i < DIRSIZ; i++)
80107a6e:	39 f3                	cmp    %esi,%ebx
80107a70:	75 f6                	jne    80107a68 <ReadFromFileStat+0xb8>
    writeToBuff("\nWriteable fds:\t", designBuffer);
80107a72:	83 ec 08             	sub    $0x8,%esp
80107a75:	ff 75 08             	pushl  0x8(%ebp)
80107a78:	68 af 95 10 80       	push   $0x801095af
80107a7d:	e8 ce fc ff ff       	call   80107750 <writeToBuff>
    itoa(write, tmp);
80107a82:	8b 45 d0             	mov    -0x30(%ebp),%eax
    if (num == 0) {
80107a85:	83 c4 10             	add    $0x10,%esp
80107a88:	85 c0                	test   %eax,%eax
80107a8a:	0f 85 a8 01 00 00    	jne    80107c38 <ReadFromFileStat+0x288>
        str[i++] = '0';
80107a90:	b8 30 00 00 00       	mov    $0x30,%eax
80107a95:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107a99:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80107a9c:	83 ec 08             	sub    $0x8,%esp
80107a9f:	ff 75 08             	pushl  0x8(%ebp)
80107aa2:	56                   	push   %esi
80107aa3:	e8 a8 fc ff ff       	call   80107750 <writeToBuff>
80107aa8:	83 c4 10             	add    $0x10,%esp
80107aab:	89 f0                	mov    %esi,%eax
80107aad:	8d 76 00             	lea    0x0(%esi),%esi
        name[i] = 0;
80107ab0:	c6 00 00             	movb   $0x0,(%eax)
80107ab3:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107ab6:	39 d8                	cmp    %ebx,%eax
80107ab8:	75 f6                	jne    80107ab0 <ReadFromFileStat+0x100>
    writeToBuff("\nReadable fds:\t", designBuffer);
80107aba:	83 ec 08             	sub    $0x8,%esp
80107abd:	ff 75 08             	pushl  0x8(%ebp)
80107ac0:	68 c0 95 10 80       	push   $0x801095c0
80107ac5:	e8 86 fc ff ff       	call   80107750 <writeToBuff>
    itoa(read, tmp);
80107aca:	8b 45 cc             	mov    -0x34(%ebp),%eax
    if (num == 0) {
80107acd:	83 c4 10             	add    $0x10,%esp
80107ad0:	85 c0                	test   %eax,%eax
80107ad2:	0f 85 50 01 00 00    	jne    80107c28 <ReadFromFileStat+0x278>
        str[i++] = '0';
80107ad8:	b8 30 00 00 00       	mov    $0x30,%eax
80107add:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107ae1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80107ae4:	83 ec 08             	sub    $0x8,%esp
80107ae7:	ff 75 08             	pushl  0x8(%ebp)
80107aea:	56                   	push   %esi
80107aeb:	e8 60 fc ff ff       	call   80107750 <writeToBuff>
80107af0:	83 c4 10             	add    $0x10,%esp
80107af3:	89 f0                	mov    %esi,%eax
80107af5:	8d 76 00             	lea    0x0(%esi),%esi
        name[i] = 0;
80107af8:	c6 00 00             	movb   $0x0,(%eax)
80107afb:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107afe:	39 d8                	cmp    %ebx,%eax
80107b00:	75 f6                	jne    80107af8 <ReadFromFileStat+0x148>
    writeToBuff("\nRefs per fds:\t", designBuffer);
80107b02:	83 ec 08             	sub    $0x8,%esp
80107b05:	ff 75 08             	pushl  0x8(%ebp)
80107b08:	68 d0 95 10 80       	push   $0x801095d0
80107b0d:	e8 3e fc ff ff       	call   80107750 <writeToBuff>
    itoa(ref, tmp);
80107b12:	8b 45 c8             	mov    -0x38(%ebp),%eax
    if (num == 0) {
80107b15:	83 c4 10             	add    $0x10,%esp
80107b18:	85 c0                	test   %eax,%eax
80107b1a:	0f 85 f8 00 00 00    	jne    80107c18 <ReadFromFileStat+0x268>
        str[i++] = '0';
80107b20:	b8 30 00 00 00       	mov    $0x30,%eax
80107b25:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107b29:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80107b2c:	83 ec 08             	sub    $0x8,%esp
80107b2f:	ff 75 08             	pushl  0x8(%ebp)
80107b32:	56                   	push   %esi
80107b33:	e8 18 fc ff ff       	call   80107750 <writeToBuff>
80107b38:	83 c4 10             	add    $0x10,%esp
80107b3b:	89 f0                	mov    %esi,%eax
80107b3d:	8d 76 00             	lea    0x0(%esi),%esi
        name[i] = 0;
80107b40:	c6 00 00             	movb   $0x0,(%eax)
80107b43:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107b46:	39 d8                	cmp    %ebx,%eax
80107b48:	75 f6                	jne    80107b40 <ReadFromFileStat+0x190>
    writeToBuff(" / ", designBuffer);
80107b4a:	83 ec 08             	sub    $0x8,%esp
80107b4d:	ff 75 08             	pushl  0x8(%ebp)
80107b50:	68 e0 95 10 80       	push   $0x801095e0
80107b55:	e8 f6 fb ff ff       	call   80107750 <writeToBuff>
    itoa(total, tmp);
80107b5a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    if (num == 0) {
80107b5d:	83 c4 10             	add    $0x10,%esp
80107b60:	85 c0                	test   %eax,%eax
80107b62:	0f 85 a0 00 00 00    	jne    80107c08 <ReadFromFileStat+0x258>
        str[i++] = '0';
80107b68:	be 30 00 00 00       	mov    $0x30,%esi
80107b6d:	66 89 75 da          	mov    %si,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107b71:	83 ec 08             	sub    $0x8,%esp
80107b74:	ff 75 08             	pushl  0x8(%ebp)
80107b77:	ff 75 b4             	pushl  -0x4c(%ebp)
80107b7a:	e8 d1 fb ff ff       	call   80107750 <writeToBuff>
80107b7f:	83 c4 10             	add    $0x10,%esp
80107b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        name[i] = 0;
80107b88:	c6 07 00             	movb   $0x0,(%edi)
80107b8b:	83 c7 01             	add    $0x1,%edi
    for (int i = 0; i < DIRSIZ; i++)
80107b8e:	39 df                	cmp    %ebx,%edi
80107b90:	75 f6                	jne    80107b88 <ReadFromFileStat+0x1d8>
    writeToBuff(" = ", designBuffer);
80107b92:	83 ec 08             	sub    $0x8,%esp
80107b95:	ff 75 08             	pushl  0x8(%ebp)
80107b98:	68 e4 95 10 80       	push   $0x801095e4
80107b9d:	e8 ae fb ff ff       	call   80107750 <writeToBuff>
    itoa((ref / total), tmp);
80107ba2:	8b 45 c8             	mov    -0x38(%ebp),%eax
    if (num == 0) {
80107ba5:	83 c4 10             	add    $0x10,%esp
    itoa((ref / total), tmp);
80107ba8:	99                   	cltd   
80107ba9:	f7 7d c4             	idivl  -0x3c(%ebp)
    if (num == 0) {
80107bac:	85 c0                	test   %eax,%eax
80107bae:	0f 85 a4 00 00 00    	jne    80107c58 <ReadFromFileStat+0x2a8>
        str[i++] = '0';
80107bb4:	bb 30 00 00 00       	mov    $0x30,%ebx
80107bb9:	66 89 5d da          	mov    %bx,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107bbd:	83 ec 08             	sub    $0x8,%esp
80107bc0:	ff 75 08             	pushl  0x8(%ebp)
80107bc3:	ff 75 b4             	pushl  -0x4c(%ebp)
80107bc6:	e8 85 fb ff ff       	call   80107750 <writeToBuff>
    writeToBuff(" !\n", designBuffer);
80107bcb:	58                   	pop    %eax
80107bcc:	5a                   	pop    %edx
80107bcd:	ff 75 08             	pushl  0x8(%ebp)
80107bd0:	68 e8 95 10 80       	push   $0x801095e8
80107bd5:	e8 76 fb ff ff       	call   80107750 <writeToBuff>
    return strlen(designBuffer);
80107bda:	59                   	pop    %ecx
80107bdb:	ff 75 08             	pushl  0x8(%ebp)
80107bde:	e8 2d d0 ff ff       	call   80104c10 <strlen>
}
80107be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107be6:	5b                   	pop    %ebx
80107be7:	5e                   	pop    %esi
80107be8:	5f                   	pop    %edi
80107be9:	5d                   	pop    %ebp
80107bea:	c3                   	ret    
80107beb:	90                   	nop
80107bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bf0:	8d 4d da             	lea    -0x26(%ebp),%ecx
80107bf3:	89 ca                	mov    %ecx,%edx
80107bf5:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
80107bf8:	e8 c3 f9 ff ff       	call   801075c0 <itoa.part.2>
80107bfd:	e9 01 fe ff ff       	jmp    80107a03 <ReadFromFileStat+0x53>
80107c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c08:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80107c0b:	e8 b0 f9 ff ff       	call   801075c0 <itoa.part.2>
80107c10:	e9 5c ff ff ff       	jmp    80107b71 <ReadFromFileStat+0x1c1>
80107c15:	8d 76 00             	lea    0x0(%esi),%esi
80107c18:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80107c1b:	e8 a0 f9 ff ff       	call   801075c0 <itoa.part.2>
80107c20:	e9 04 ff ff ff       	jmp    80107b29 <ReadFromFileStat+0x179>
80107c25:	8d 76 00             	lea    0x0(%esi),%esi
80107c28:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80107c2b:	e8 90 f9 ff ff       	call   801075c0 <itoa.part.2>
80107c30:	e9 ac fe ff ff       	jmp    80107ae1 <ReadFromFileStat+0x131>
80107c35:	8d 76 00             	lea    0x0(%esi),%esi
80107c38:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80107c3b:	e8 80 f9 ff ff       	call   801075c0 <itoa.part.2>
80107c40:	e9 54 fe ff ff       	jmp    80107a99 <ReadFromFileStat+0xe9>
80107c45:	8d 76 00             	lea    0x0(%esi),%esi
80107c48:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80107c4b:	e8 70 f9 ff ff       	call   801075c0 <itoa.part.2>
80107c50:	e9 fc fd ff ff       	jmp    80107a51 <ReadFromFileStat+0xa1>
80107c55:	8d 76 00             	lea    0x0(%esi),%esi
80107c58:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80107c5b:	e8 60 f9 ff ff       	call   801075c0 <itoa.part.2>
80107c60:	e9 58 ff ff ff       	jmp    80107bbd <ReadFromFileStat+0x20d>
80107c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c70 <ReadFromInodeInfo>:
int ReadFromInodeInfo(char *designBuffer, int IPinum) {
80107c70:	55                   	push   %ebp
    int validInum[NINODE] = {0};
80107c71:	31 c0                	xor    %eax,%eax
80107c73:	b9 32 00 00 00       	mov    $0x32,%ecx
int ReadFromInodeInfo(char *designBuffer, int IPinum) {
80107c78:	89 e5                	mov    %esp,%ebp
80107c7a:	57                   	push   %edi
80107c7b:	56                   	push   %esi
    int validInum[NINODE] = {0};
80107c7c:	8d bd 20 ff ff ff    	lea    -0xe0(%ebp),%edi
int ReadFromInodeInfo(char *designBuffer, int IPinum) {
80107c82:	53                   	push   %ebx
80107c83:	81 ec 08 01 00 00    	sub    $0x108,%esp
    int validInum[NINODE] = {0};
80107c89:	f3 ab                	rep stos %eax,%es:(%edi)
    int count = readIcacheFS(validInum);
80107c8b:	8d 8d 20 ff ff ff    	lea    -0xe0(%ebp),%ecx
80107c91:	51                   	push   %ecx
80107c92:	89 8d 04 ff ff ff    	mov    %ecx,-0xfc(%ebp)
80107c98:	e8 63 99 ff ff       	call   80101600 <readIcacheFS>
    for(int i=0; i<count; i++){
80107c9d:	83 c4 10             	add    $0x10,%esp
80107ca0:	85 c0                	test   %eax,%eax
    int count = readIcacheFS(validInum);
80107ca2:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
    for(int i=0; i<count; i++){
80107ca8:	7e 63                	jle    80107d0d <ReadFromInodeInfo+0x9d>
80107caa:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
80107cb0:	8d bd 12 ff ff ff    	lea    -0xee(%ebp),%edi
80107cb6:	31 f6                	xor    %esi,%esi
80107cb8:	89 cb                	mov    %ecx,%ebx
80107cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (num == 0) {
80107cc0:	85 f6                	test   %esi,%esi
80107cc2:	74 5d                	je     80107d21 <ReadFromInodeInfo+0xb1>
80107cc4:	89 fa                	mov    %edi,%edx
80107cc6:	89 f0                	mov    %esi,%eax
80107cc8:	89 8d 04 ff ff ff    	mov    %ecx,-0xfc(%ebp)
80107cce:	e8 ed f8 ff ff       	call   801075c0 <itoa.part.2>
80107cd3:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
        writeDirentToBuff(i, tmp, VIRTUALINODEINFO + validInum[i], designBuffer);
80107cd9:	ff 75 08             	pushl  0x8(%ebp)
80107cdc:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
80107ce1:	03 04 b1             	add    (%ecx,%esi,4),%eax
80107ce4:	50                   	push   %eax
80107ce5:	57                   	push   %edi
80107ce6:	56                   	push   %esi
80107ce7:	e8 14 fa ff ff       	call   80107700 <writeDirentToBuff>
80107cec:	89 f8                	mov    %edi,%eax
80107cee:	89 d9                	mov    %ebx,%ecx
80107cf0:	83 c4 10             	add    $0x10,%esp
80107cf3:	90                   	nop
80107cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
80107cf8:	c6 00 00             	movb   $0x0,(%eax)
80107cfb:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107cfe:	39 d8                	cmp    %ebx,%eax
80107d00:	75 f6                	jne    80107cf8 <ReadFromInodeInfo+0x88>
    for(int i=0; i<count; i++){
80107d02:	83 c6 01             	add    $0x1,%esi
80107d05:	39 b5 00 ff ff ff    	cmp    %esi,-0x100(%ebp)
80107d0b:	75 b3                	jne    80107cc0 <ReadFromInodeInfo+0x50>
    count--;
80107d0d:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
}
80107d13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d16:	5b                   	pop    %ebx
    count--;
80107d17:	83 e8 01             	sub    $0x1,%eax
}
80107d1a:	5e                   	pop    %esi
    return sizeof(struct dirent) * count;
80107d1b:	c1 e0 04             	shl    $0x4,%eax
}
80107d1e:	5f                   	pop    %edi
80107d1f:	5d                   	pop    %ebp
80107d20:	c3                   	ret    
        str[i++] = '0';
80107d21:	b8 30 00 00 00       	mov    $0x30,%eax
80107d26:	66 89 85 12 ff ff ff 	mov    %ax,-0xee(%ebp)
80107d2d:	eb aa                	jmp    80107cd9 <ReadFromInodeInfo+0x69>
80107d2f:	90                   	nop

80107d30 <ReadVirtInfo>:
int ReadVirtInfo(char *designBuffer, int IPinum) {
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	57                   	push   %edi
80107d34:	56                   	push   %esi
80107d35:	53                   	push   %ebx
80107d36:	83 ec 38             	sub    $0x38,%esp
    int inumIndex = IPinum - VIRTUALINODEINFO;
80107d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d3c:	2b 05 c0 c5 10 80    	sub    0x8010c5c0,%eax
    struct inode *ind = getInodeFromChache(inumIndex);
80107d42:	50                   	push   %eax
80107d43:	e8 18 99 ff ff       	call   80101660 <getInodeFromChache>
    if (!ind) //validation check
80107d48:	83 c4 10             	add    $0x10,%esp
80107d4b:	85 c0                	test   %eax,%eax
    struct inode *ind = getInodeFromChache(inumIndex);
80107d4d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if (!ind) //validation check
80107d50:	0f 84 64 04 00 00    	je     801081ba <ReadVirtInfo+0x48a>
    output=strlen("\nDevice:\t");
80107d56:	83 ec 0c             	sub    $0xc,%esp
80107d59:	68 ec 95 10 80       	push   $0x801095ec
80107d5e:	e8 ad ce ff ff       	call   80104c10 <strlen>
80107d63:	89 c3                	mov    %eax,%ebx
    writeToBuff("\nDevice:\t", designBuffer);
80107d65:	58                   	pop    %eax
80107d66:	5a                   	pop    %edx
80107d67:	ff 75 08             	pushl  0x8(%ebp)
80107d6a:	68 ec 95 10 80       	push   $0x801095ec
80107d6f:	e8 dc f9 ff ff       	call   80107750 <writeToBuff>
    itoa(ind->dev, tmp);
80107d74:	8b 45 d0             	mov    -0x30(%ebp),%eax
    if (num == 0) {
80107d77:	83 c4 10             	add    $0x10,%esp
    itoa(ind->dev, tmp);
80107d7a:	8b 00                	mov    (%eax),%eax
    if (num == 0) {
80107d7c:	85 c0                	test   %eax,%eax
80107d7e:	0f 85 fc 03 00 00    	jne    80108180 <ReadVirtInfo+0x450>
        str[i++] = '0';
80107d84:	b8 30 00 00 00       	mov    $0x30,%eax
80107d89:	66 89 45 da          	mov    %ax,-0x26(%ebp)
80107d8d:	8d 45 da             	lea    -0x26(%ebp),%eax
80107d90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    writeToBuff(tmp, designBuffer);
80107d93:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80107d96:	83 ec 08             	sub    $0x8,%esp
80107d99:	ff 75 08             	pushl  0x8(%ebp)
80107d9c:	57                   	push   %edi
80107d9d:	89 fe                	mov    %edi,%esi
80107d9f:	e8 ac f9 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
80107da4:	89 3c 24             	mov    %edi,(%esp)
80107da7:	e8 64 ce ff ff       	call   80104c10 <strlen>
80107dac:	01 c3                	add    %eax,%ebx
80107dae:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107db1:	83 c4 10             	add    $0x10,%esp
80107db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
80107db8:	c6 07 00             	movb   $0x0,(%edi)
80107dbb:	83 c7 01             	add    $0x1,%edi
    for (int i = 0; i < DIRSIZ; i++)
80107dbe:	39 c7                	cmp    %eax,%edi
80107dc0:	75 f6                	jne    80107db8 <ReadVirtInfo+0x88>
    writeToBuff("\nInode number:\t", designBuffer);
80107dc2:	83 ec 08             	sub    $0x8,%esp
80107dc5:	ff 75 08             	pushl  0x8(%ebp)
80107dc8:	68 f6 95 10 80       	push   $0x801095f6
80107dcd:	e8 7e f9 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\nInode number:\t");
80107dd2:	c7 04 24 f6 95 10 80 	movl   $0x801095f6,(%esp)
80107dd9:	e8 32 ce ff ff       	call   80104c10 <strlen>
80107dde:	01 c3                	add    %eax,%ebx
    itoa(ind->inum, tmp);
80107de0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    if (num == 0) {
80107de3:	83 c4 10             	add    $0x10,%esp
    itoa(ind->inum, tmp);
80107de6:	8b 40 04             	mov    0x4(%eax),%eax
    if (num == 0) {
80107de9:	85 c0                	test   %eax,%eax
80107deb:	0f 85 7f 03 00 00    	jne    80108170 <ReadVirtInfo+0x440>
        str[i++] = '0';
80107df1:	b8 30 00 00 00       	mov    $0x30,%eax
80107df6:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107dfa:	83 ec 08             	sub    $0x8,%esp
80107dfd:	ff 75 08             	pushl  0x8(%ebp)
80107e00:	ff 75 d4             	pushl  -0x2c(%ebp)
80107e03:	e8 48 f9 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
80107e08:	58                   	pop    %eax
80107e09:	ff 75 d4             	pushl  -0x2c(%ebp)
80107e0c:	e8 ff cd ff ff       	call   80104c10 <strlen>
80107e11:	01 d8                	add    %ebx,%eax
80107e13:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
80107e16:	83 c4 10             	add    $0x10,%esp
80107e19:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
80107e20:	c6 03 00             	movb   $0x0,(%ebx)
80107e23:	83 c3 01             	add    $0x1,%ebx
    for (int i = 0; i < DIRSIZ; i++)
80107e26:	39 fb                	cmp    %edi,%ebx
80107e28:	75 f6                	jne    80107e20 <ReadVirtInfo+0xf0>
    writeToBuff("\nis valid:\t", designBuffer);
80107e2a:	83 ec 08             	sub    $0x8,%esp
80107e2d:	ff 75 08             	pushl  0x8(%ebp)
80107e30:	68 06 96 10 80       	push   $0x80109606
80107e35:	e8 16 f9 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\nis valid:\t");
80107e3a:	c7 04 24 06 96 10 80 	movl   $0x80109606,(%esp)
80107e41:	e8 ca cd ff ff       	call   80104c10 <strlen>
80107e46:	8b 7d cc             	mov    -0x34(%ebp),%edi
    if (ind->valid == VALID)
80107e49:	83 c4 10             	add    $0x10,%esp
    output+=strlen("\nis valid:\t");
80107e4c:	01 c7                	add    %eax,%edi
    if (ind->valid == VALID)
80107e4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107e51:	83 78 4c 01          	cmpl   $0x1,0x4c(%eax)
80107e55:	0f 84 4d 03 00 00    	je     801081a8 <ReadVirtInfo+0x478>
        str[i++] = '0';
80107e5b:	b8 30 00 00 00       	mov    $0x30,%eax
80107e60:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107e64:	83 ec 08             	sub    $0x8,%esp
80107e67:	ff 75 08             	pushl  0x8(%ebp)
80107e6a:	ff 75 d4             	pushl  -0x2c(%ebp)
    output++;
80107e6d:	83 c7 01             	add    $0x1,%edi
    writeToBuff(tmp, designBuffer);
80107e70:	e8 db f8 ff ff       	call   80107750 <writeToBuff>
    output++;
80107e75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107e78:	83 c4 10             	add    $0x10,%esp
80107e7b:	90                   	nop
80107e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
80107e80:	c6 00 00             	movb   $0x0,(%eax)
80107e83:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107e86:	39 d8                	cmp    %ebx,%eax
80107e88:	75 f6                	jne    80107e80 <ReadVirtInfo+0x150>
    writeToBuff("\ntype:\t", designBuffer);
80107e8a:	83 ec 08             	sub    $0x8,%esp
80107e8d:	ff 75 08             	pushl  0x8(%ebp)
80107e90:	68 12 96 10 80       	push   $0x80109612
80107e95:	e8 b6 f8 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\ntype:\t");
80107e9a:	c7 04 24 12 96 10 80 	movl   $0x80109612,(%esp)
80107ea1:	e8 6a cd ff ff       	call   80104c10 <strlen>
80107ea6:	01 c7                	add    %eax,%edi
    switch (ind->type) {
80107ea8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107eab:	83 c4 10             	add    $0x10,%esp
80107eae:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80107eb2:	66 83 f8 02          	cmp    $0x2,%ax
80107eb6:	0f 84 64 02 00 00    	je     80108120 <ReadVirtInfo+0x3f0>
80107ebc:	66 83 f8 03          	cmp    $0x3,%ax
80107ec0:	74 1e                	je     80107ee0 <ReadVirtInfo+0x1b0>
80107ec2:	66 83 f8 01          	cmp    $0x1,%ax
80107ec6:	0f 84 3c 02 00 00    	je     80108108 <ReadVirtInfo+0x3d8>
            panic("ERROR - switch (ind->type): UNKNOWN TYPE!");
80107ecc:	83 ec 0c             	sub    $0xc,%esp
80107ecf:	68 cc 94 10 80       	push   $0x801094cc
80107ed4:	e8 b7 84 ff ff       	call   80100390 <panic>
80107ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("DEV",tmp);
80107ee0:	83 ec 08             	sub    $0x8,%esp
80107ee3:	ff 75 d4             	pushl  -0x2c(%ebp)
80107ee6:	68 1f 96 10 80       	push   $0x8010961f
80107eeb:	e8 60 f8 ff ff       	call   80107750 <writeToBuff>
            break;
80107ef0:	83 c4 10             	add    $0x10,%esp
    writeToBuff(tmp, designBuffer);
80107ef3:	83 ec 08             	sub    $0x8,%esp
80107ef6:	ff 75 08             	pushl  0x8(%ebp)
80107ef9:	ff 75 d4             	pushl  -0x2c(%ebp)
80107efc:	e8 4f f8 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
80107f01:	58                   	pop    %eax
80107f02:	ff 75 d4             	pushl  -0x2c(%ebp)
80107f05:	e8 06 cd ff ff       	call   80104c10 <strlen>
80107f0a:	01 c7                	add    %eax,%edi
80107f0c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107f0f:	83 c4 10             	add    $0x10,%esp
80107f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        name[i] = 0;
80107f18:	c6 00 00             	movb   $0x0,(%eax)
80107f1b:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107f1e:	39 d8                	cmp    %ebx,%eax
80107f20:	75 f6                	jne    80107f18 <ReadVirtInfo+0x1e8>
    writeToBuff("\nmajor minor:\t( ", designBuffer);
80107f22:	83 ec 08             	sub    $0x8,%esp
80107f25:	ff 75 08             	pushl  0x8(%ebp)
80107f28:	68 23 96 10 80       	push   $0x80109623
80107f2d:	e8 1e f8 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\nmajor minor:\t( ");
80107f32:	c7 04 24 23 96 10 80 	movl   $0x80109623,(%esp)
80107f39:	e8 d2 cc ff ff       	call   80104c10 <strlen>
80107f3e:	01 c7                	add    %eax,%edi
    itoa(ind->major, tmp);
80107f40:	8b 45 d0             	mov    -0x30(%ebp),%eax
    if (num == 0) {
80107f43:	83 c4 10             	add    $0x10,%esp
    itoa(ind->major, tmp);
80107f46:	0f bf 40 52          	movswl 0x52(%eax),%eax
    if (num == 0) {
80107f4a:	85 c0                	test   %eax,%eax
80107f4c:	0f 85 0e 02 00 00    	jne    80108160 <ReadVirtInfo+0x430>
        str[i++] = '0';
80107f52:	b9 30 00 00 00       	mov    $0x30,%ecx
80107f57:	66 89 4d da          	mov    %cx,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107f5b:	83 ec 08             	sub    $0x8,%esp
80107f5e:	ff 75 08             	pushl  0x8(%ebp)
80107f61:	ff 75 d4             	pushl  -0x2c(%ebp)
80107f64:	e8 e7 f7 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
80107f69:	58                   	pop    %eax
80107f6a:	ff 75 d4             	pushl  -0x2c(%ebp)
80107f6d:	e8 9e cc ff ff       	call   80104c10 <strlen>
80107f72:	01 c7                	add    %eax,%edi
    writeToBuff(" , ", designBuffer);
80107f74:	58                   	pop    %eax
80107f75:	5a                   	pop    %edx
80107f76:	ff 75 08             	pushl  0x8(%ebp)
80107f79:	68 34 96 10 80       	push   $0x80109634
80107f7e:	e8 cd f7 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(" , ");
80107f83:	c7 04 24 34 96 10 80 	movl   $0x80109634,(%esp)
80107f8a:	e8 81 cc ff ff       	call   80104c10 <strlen>
80107f8f:	01 c7                	add    %eax,%edi
80107f91:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107f94:	83 c4 10             	add    $0x10,%esp
80107f97:	89 f6                	mov    %esi,%esi
80107f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        name[i] = 0;
80107fa0:	c6 00 00             	movb   $0x0,(%eax)
80107fa3:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80107fa6:	39 d8                	cmp    %ebx,%eax
80107fa8:	75 f6                	jne    80107fa0 <ReadVirtInfo+0x270>
    itoa(ind->minor, tmp);
80107faa:	8b 45 d0             	mov    -0x30(%ebp),%eax
80107fad:	0f bf 40 54          	movswl 0x54(%eax),%eax
    if (num == 0) {
80107fb1:	85 c0                	test   %eax,%eax
80107fb3:	0f 85 97 01 00 00    	jne    80108150 <ReadVirtInfo+0x420>
        str[i++] = '0';
80107fb9:	b9 30 00 00 00       	mov    $0x30,%ecx
80107fbe:	66 89 4d da          	mov    %cx,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80107fc2:	83 ec 08             	sub    $0x8,%esp
80107fc5:	ff 75 08             	pushl  0x8(%ebp)
80107fc8:	ff 75 d4             	pushl  -0x2c(%ebp)
80107fcb:	e8 80 f7 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
80107fd0:	58                   	pop    %eax
80107fd1:	ff 75 d4             	pushl  -0x2c(%ebp)
80107fd4:	e8 37 cc ff ff       	call   80104c10 <strlen>
80107fd9:	01 c7                	add    %eax,%edi
    writeToBuff(" )", designBuffer);
80107fdb:	58                   	pop    %eax
80107fdc:	5a                   	pop    %edx
80107fdd:	ff 75 08             	pushl  0x8(%ebp)
80107fe0:	68 38 96 10 80       	push   $0x80109638
80107fe5:	e8 66 f7 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(" )");
80107fea:	c7 04 24 38 96 10 80 	movl   $0x80109638,(%esp)
80107ff1:	e8 1a cc ff ff       	call   80104c10 <strlen>
80107ff6:	01 c7                	add    %eax,%edi
80107ff8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80107ffb:	83 c4 10             	add    $0x10,%esp
80107ffe:	66 90                	xchg   %ax,%ax
        name[i] = 0;
80108000:	c6 00 00             	movb   $0x0,(%eax)
80108003:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80108006:	39 d8                	cmp    %ebx,%eax
80108008:	75 f6                	jne    80108000 <ReadVirtInfo+0x2d0>
    writeToBuff("\nhard link:\t", designBuffer);
8010800a:	83 ec 08             	sub    $0x8,%esp
8010800d:	ff 75 08             	pushl  0x8(%ebp)
80108010:	68 3b 96 10 80       	push   $0x8010963b
80108015:	e8 36 f7 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\nhard link:\t");
8010801a:	c7 04 24 3b 96 10 80 	movl   $0x8010963b,(%esp)
80108021:	e8 ea cb ff ff       	call   80104c10 <strlen>
80108026:	01 c7                	add    %eax,%edi
    itoa(ind->nlink, tmp); //TODO - NOT SURE THAT THIS IS THE RELEVANT FIELD
80108028:	8b 45 d0             	mov    -0x30(%ebp),%eax
    if (num == 0) {
8010802b:	83 c4 10             	add    $0x10,%esp
    itoa(ind->nlink, tmp); //TODO - NOT SURE THAT THIS IS THE RELEVANT FIELD
8010802e:	0f bf 40 56          	movswl 0x56(%eax),%eax
    if (num == 0) {
80108032:	85 c0                	test   %eax,%eax
80108034:	0f 85 06 01 00 00    	jne    80108140 <ReadVirtInfo+0x410>
        str[i++] = '0';
8010803a:	b8 30 00 00 00       	mov    $0x30,%eax
8010803f:	66 89 45 da          	mov    %ax,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
80108043:	83 ec 08             	sub    $0x8,%esp
80108046:	ff 75 08             	pushl  0x8(%ebp)
80108049:	ff 75 d4             	pushl  -0x2c(%ebp)
8010804c:	e8 ff f6 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
80108051:	58                   	pop    %eax
80108052:	ff 75 d4             	pushl  -0x2c(%ebp)
80108055:	e8 b6 cb ff ff       	call   80104c10 <strlen>
8010805a:	83 c4 10             	add    $0x10,%esp
8010805d:	01 c7                	add    %eax,%edi
8010805f:	90                   	nop
        name[i] = 0;
80108060:	c6 06 00             	movb   $0x0,(%esi)
80108063:	83 c6 01             	add    $0x1,%esi
    for (int i = 0; i < DIRSIZ; i++)
80108066:	39 de                	cmp    %ebx,%esi
80108068:	75 f6                	jne    80108060 <ReadVirtInfo+0x330>
    if (ind->type == T_DEV)
8010806a:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010806d:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80108072:	74 29                	je     8010809d <ReadVirtInfo+0x36d>
80108074:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108077:	8d 50 5c             	lea    0x5c(%eax),%edx
8010807a:	8d 88 90 00 00 00    	lea    0x90(%eax),%ecx
        int counter = 0;
80108080:	31 c0                	xor    %eax,%eax
80108082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                counter++;
80108088:	83 3a 01             	cmpl   $0x1,(%edx)
8010808b:	83 d8 ff             	sbb    $0xffffffff,%eax
8010808e:	83 c2 04             	add    $0x4,%edx
        for (int i = 0; i < NDIRECT + 1; i++) {
80108091:	39 d1                	cmp    %edx,%ecx
80108093:	75 f3                	jne    80108088 <ReadVirtInfo+0x358>
    if (num == 0) {
80108095:	85 c0                	test   %eax,%eax
80108097:	0f 85 fb 00 00 00    	jne    80108198 <ReadVirtInfo+0x468>
        str[i++] = '0';
8010809d:	be 30 00 00 00       	mov    $0x30,%esi
801080a2:	66 89 75 da          	mov    %si,-0x26(%ebp)
    writeToBuff("\nblock used:\t", designBuffer);
801080a6:	83 ec 08             	sub    $0x8,%esp
801080a9:	ff 75 08             	pushl  0x8(%ebp)
801080ac:	68 48 96 10 80       	push   $0x80109648
801080b1:	e8 9a f6 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\nblock used:\t");
801080b6:	c7 04 24 48 96 10 80 	movl   $0x80109648,(%esp)
801080bd:	e8 4e cb ff ff       	call   80104c10 <strlen>
    writeToBuff(tmp, designBuffer);
801080c2:	8b 75 d4             	mov    -0x2c(%ebp),%esi
    output+=strlen("\nblock used:\t");
801080c5:	01 c7                	add    %eax,%edi
    writeToBuff(tmp, designBuffer);
801080c7:	58                   	pop    %eax
801080c8:	5a                   	pop    %edx
801080c9:	ff 75 08             	pushl  0x8(%ebp)
801080cc:	56                   	push   %esi
801080cd:	e8 7e f6 ff ff       	call   80107750 <writeToBuff>
    output+=strlen(tmp);
801080d2:	89 34 24             	mov    %esi,(%esp)
801080d5:	e8 36 cb ff ff       	call   80104c10 <strlen>
    writeToBuff("\n", designBuffer);
801080da:	59                   	pop    %ecx
801080db:	5b                   	pop    %ebx
801080dc:	ff 75 08             	pushl  0x8(%ebp)
801080df:	68 ea 95 10 80       	push   $0x801095ea
    output+=strlen(tmp);
801080e4:	01 c7                	add    %eax,%edi
    writeToBuff("\n", designBuffer);
801080e6:	e8 65 f6 ff ff       	call   80107750 <writeToBuff>
    output+=strlen("\n");
801080eb:	c7 04 24 ea 95 10 80 	movl   $0x801095ea,(%esp)
801080f2:	e8 19 cb ff ff       	call   80104c10 <strlen>
}
801080f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
    output+=strlen("\n");
801080fa:	01 f8                	add    %edi,%eax
}
801080fc:	5b                   	pop    %ebx
801080fd:	5e                   	pop    %esi
801080fe:	5f                   	pop    %edi
801080ff:	5d                   	pop    %ebp
80108100:	c3                   	ret    
80108101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("DIR",tmp);
80108108:	83 ec 08             	sub    $0x8,%esp
8010810b:	ff 75 d4             	pushl  -0x2c(%ebp)
8010810e:	68 95 8b 10 80       	push   $0x80108b95
80108113:	e8 38 f6 ff ff       	call   80107750 <writeToBuff>
            break;
80108118:	83 c4 10             	add    $0x10,%esp
8010811b:	e9 d3 fd ff ff       	jmp    80107ef3 <ReadVirtInfo+0x1c3>
            writeToBuff("FILE",tmp);
80108120:	83 ec 08             	sub    $0x8,%esp
80108123:	ff 75 d4             	pushl  -0x2c(%ebp)
80108126:	68 1a 96 10 80       	push   $0x8010961a
8010812b:	e8 20 f6 ff ff       	call   80107750 <writeToBuff>
            break;
80108130:	83 c4 10             	add    $0x10,%esp
80108133:	e9 bb fd ff ff       	jmp    80107ef3 <ReadVirtInfo+0x1c3>
80108138:	90                   	nop
80108139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108140:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108143:	e8 78 f4 ff ff       	call   801075c0 <itoa.part.2>
80108148:	e9 f6 fe ff ff       	jmp    80108043 <ReadVirtInfo+0x313>
8010814d:	8d 76 00             	lea    0x0(%esi),%esi
80108150:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108153:	e8 68 f4 ff ff       	call   801075c0 <itoa.part.2>
80108158:	e9 65 fe ff ff       	jmp    80107fc2 <ReadVirtInfo+0x292>
8010815d:	8d 76 00             	lea    0x0(%esi),%esi
80108160:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108163:	e8 58 f4 ff ff       	call   801075c0 <itoa.part.2>
80108168:	e9 ee fd ff ff       	jmp    80107f5b <ReadVirtInfo+0x22b>
8010816d:	8d 76 00             	lea    0x0(%esi),%esi
80108170:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108173:	e8 48 f4 ff ff       	call   801075c0 <itoa.part.2>
80108178:	e9 7d fc ff ff       	jmp    80107dfa <ReadVirtInfo+0xca>
8010817d:	8d 76 00             	lea    0x0(%esi),%esi
80108180:	8d 4d da             	lea    -0x26(%ebp),%ecx
80108183:	89 ca                	mov    %ecx,%edx
80108185:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80108188:	e8 33 f4 ff ff       	call   801075c0 <itoa.part.2>
8010818d:	e9 01 fc ff ff       	jmp    80107d93 <ReadVirtInfo+0x63>
80108192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108198:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010819b:	e8 20 f4 ff ff       	call   801075c0 <itoa.part.2>
801081a0:	e9 01 ff ff ff       	jmp    801080a6 <ReadVirtInfo+0x376>
801081a5:	8d 76 00             	lea    0x0(%esi),%esi
801081a8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801081ab:	b8 01 00 00 00       	mov    $0x1,%eax
801081b0:	e8 0b f4 ff ff       	call   801075c0 <itoa.part.2>
801081b5:	e9 aa fc ff ff       	jmp    80107e64 <ReadVirtInfo+0x134>
        panic("ERROR - ReafFromInodeInfo: INODE IS NULL!");
801081ba:	83 ec 0c             	sub    $0xc,%esp
801081bd:	68 a0 94 10 80       	push   $0x801094a0
801081c2:	e8 c9 81 ff ff       	call   80100390 <panic>
801081c7:	89 f6                	mov    %esi,%esi
801081c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801081d0 <ReadFromIdeInfo>:
int ReadFromIdeInfo(char *designBuffer, int IPinum) {
801081d0:	55                   	push   %ebp
    int *block[50] = {0};
801081d1:	31 c0                	xor    %eax,%eax
801081d3:	b9 32 00 00 00       	mov    $0x32,%ecx
int ReadFromIdeInfo(char *designBuffer, int IPinum) {
801081d8:	89 e5                	mov    %esp,%ebp
801081da:	57                   	push   %edi
801081db:	56                   	push   %esi
    int *block[50] = {0};
801081dc:	8d bd 58 fe ff ff    	lea    -0x1a8(%ebp),%edi
int ReadFromIdeInfo(char *designBuffer, int IPinum) {
801081e2:	53                   	push   %ebx
801081e3:	81 ec d8 01 00 00    	sub    $0x1d8,%esp
801081e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int waitingCounter = 0, readCounter = 0, writeCounter = 0;
801081ec:	c7 85 3c fe ff ff 00 	movl   $0x0,-0x1c4(%ebp)
801081f3:	00 00 00 
    int *block[50] = {0};
801081f6:	f3 ab                	rep stos %eax,%es:(%edi)
    int *dev[50] = {0};
801081f8:	8d bd 20 ff ff ff    	lea    -0xe0(%ebp),%edi
801081fe:	b9 32 00 00 00       	mov    $0x32,%ecx
    int waitingCounter = 0, readCounter = 0, writeCounter = 0;
80108203:	c7 85 40 fe ff ff 00 	movl   $0x0,-0x1c0(%ebp)
8010820a:	00 00 00 
8010820d:	c7 85 44 fe ff ff 00 	movl   $0x0,-0x1bc(%ebp)
80108214:	00 00 00 
    int *dev[50] = {0};
80108217:	f3 ab                	rep stos %eax,%es:(%edi)
    int listSize = getIdeQeueue( &waitingCounter, &readCounter, &writeCounter,
80108219:	8d 85 44 fe ff ff    	lea    -0x1bc(%ebp),%eax
8010821f:	6a 00                	push   $0x0
80108221:	6a 00                	push   $0x0
80108223:	50                   	push   %eax
80108224:	8d 85 40 fe ff ff    	lea    -0x1c0(%ebp),%eax
8010822a:	50                   	push   %eax
8010822b:	8d 85 3c fe ff ff    	lea    -0x1c4(%ebp),%eax
80108231:	50                   	push   %eax
80108232:	e8 59 a3 ff ff       	call   80102590 <getIdeQeueue>
    writeToBuff("\nWaiting operations:\t", designBuffer);
80108237:	83 c4 18             	add    $0x18,%esp
    int listSize = getIdeQeueue( &waitingCounter, &readCounter, &writeCounter,
8010823a:	89 85 2c fe ff ff    	mov    %eax,-0x1d4(%ebp)
    writeToBuff("\nWaiting operations:\t", designBuffer);
80108240:	53                   	push   %ebx
80108241:	68 56 96 10 80       	push   $0x80109656
80108246:	e8 05 f5 ff ff       	call   80107750 <writeToBuff>
    if(waitingCounter == 0 )
8010824b:	8b 85 3c fe ff ff    	mov    -0x1c4(%ebp),%eax
80108251:	83 c4 10             	add    $0x10,%esp
80108254:	85 c0                	test   %eax,%eax
80108256:	0f 85 67 02 00 00    	jne    801084c3 <ReadFromIdeInfo+0x2f3>
        writeToBuff("0", designBuffer);
8010825c:	83 ec 08             	sub    $0x8,%esp
8010825f:	53                   	push   %ebx
80108260:	68 6c 96 10 80       	push   $0x8010966c
80108265:	e8 e6 f4 ff ff       	call   80107750 <writeToBuff>
8010826a:	8d 85 4a fe ff ff    	lea    -0x1b6(%ebp),%eax
80108270:	83 c4 10             	add    $0x10,%esp
80108273:	89 85 34 fe ff ff    	mov    %eax,-0x1cc(%ebp)
int ReadFromIdeInfo(char *designBuffer, int IPinum) {
80108279:	8b b5 34 fe ff ff    	mov    -0x1cc(%ebp),%esi
8010827f:	90                   	nop
    for (int i = 0; i < DIRSIZ; i++)
80108280:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
        name[i] = 0;
80108286:	c6 06 00             	movb   $0x0,(%esi)
80108289:	83 c6 01             	add    $0x1,%esi
    for (int i = 0; i < DIRSIZ; i++)
8010828c:	39 f0                	cmp    %esi,%eax
8010828e:	75 f0                	jne    80108280 <ReadFromIdeInfo+0xb0>
    writeToBuff("\nRead waiting operations:\t", designBuffer);
80108290:	83 ec 08             	sub    $0x8,%esp
80108293:	53                   	push   %ebx
80108294:	68 6e 96 10 80       	push   $0x8010966e
80108299:	e8 b2 f4 ff ff       	call   80107750 <writeToBuff>
    if(readCounter == 0 )
8010829e:	8b 85 40 fe ff ff    	mov    -0x1c0(%ebp),%eax
801082a4:	83 c4 10             	add    $0x10,%esp
801082a7:	85 c0                	test   %eax,%eax
801082a9:	0f 85 f5 01 00 00    	jne    801084a4 <ReadFromIdeInfo+0x2d4>
        writeToBuff("0", designBuffer);
801082af:	83 ec 08             	sub    $0x8,%esp
801082b2:	53                   	push   %ebx
801082b3:	68 6c 96 10 80       	push   $0x8010966c
801082b8:	e8 93 f4 ff ff       	call   80107750 <writeToBuff>
801082bd:	83 c4 10             	add    $0x10,%esp
int ReadFromIdeInfo(char *designBuffer, int IPinum) {
801082c0:	8b bd 34 fe ff ff    	mov    -0x1cc(%ebp),%edi
801082c6:	8d 76 00             	lea    0x0(%esi),%esi
801082c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        name[i] = 0;
801082d0:	c6 07 00             	movb   $0x0,(%edi)
801082d3:	83 c7 01             	add    $0x1,%edi
    for (int i = 0; i < DIRSIZ; i++)
801082d6:	39 f7                	cmp    %esi,%edi
801082d8:	75 f6                	jne    801082d0 <ReadFromIdeInfo+0x100>
    writeToBuff("\nWrite waiting operations:\t", designBuffer);
801082da:	83 ec 08             	sub    $0x8,%esp
801082dd:	53                   	push   %ebx
801082de:	68 89 96 10 80       	push   $0x80109689
801082e3:	e8 68 f4 ff ff       	call   80107750 <writeToBuff>
    if(writeCounter == 0 )
801082e8:	8b 85 44 fe ff ff    	mov    -0x1bc(%ebp),%eax
801082ee:	83 c4 10             	add    $0x10,%esp
801082f1:	85 c0                	test   %eax,%eax
801082f3:	0f 85 8c 01 00 00    	jne    80108485 <ReadFromIdeInfo+0x2b5>
        writeToBuff("0", designBuffer);
801082f9:	83 ec 08             	sub    $0x8,%esp
801082fc:	53                   	push   %ebx
801082fd:	68 6c 96 10 80       	push   $0x8010966c
80108302:	e8 49 f4 ff ff       	call   80107750 <writeToBuff>
80108307:	83 c4 10             	add    $0x10,%esp
int ReadFromIdeInfo(char *designBuffer, int IPinum) {
8010830a:	8b 85 34 fe ff ff    	mov    -0x1cc(%ebp),%eax
        name[i] = 0;
80108310:	c6 00 00             	movb   $0x0,(%eax)
80108313:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
80108316:	39 f8                	cmp    %edi,%eax
80108318:	75 f6                	jne    80108310 <ReadFromIdeInfo+0x140>
    writeToBuff("\nWorking blocks:\t", designBuffer);
8010831a:	83 ec 08             	sub    $0x8,%esp
8010831d:	53                   	push   %ebx
8010831e:	68 a5 96 10 80       	push   $0x801096a5
80108323:	e8 28 f4 ff ff       	call   80107750 <writeToBuff>
    writeToBuff("(", designBuffer);
80108328:	5e                   	pop    %esi
80108329:	58                   	pop    %eax
8010832a:	53                   	push   %ebx
8010832b:	68 b7 96 10 80       	push   $0x801096b7
80108330:	e8 1b f4 ff ff       	call   80107750 <writeToBuff>
    if (listSize == 0) { //IF EMPTY PTR ->EMPTY LIST
80108335:	83 c4 10             	add    $0x10,%esp
80108338:	83 bd 2c fe ff ff 00 	cmpl   $0x0,-0x1d4(%ebp)
8010833f:	0f 84 a5 01 00 00    	je     801084ea <ReadFromIdeInfo+0x31a>
    int count = 0;
80108345:	be 00 00 00 00       	mov    $0x0,%esi
        while( k < listSize ) {
8010834a:	0f 8e 24 01 00 00    	jle    80108474 <ReadFromIdeInfo+0x2a4>
            writeToBuff("( ", designBuffer);
80108350:	83 ec 08             	sub    $0x8,%esp
80108353:	53                   	push   %ebx
80108354:	68 31 96 10 80       	push   $0x80109631
80108359:	e8 f2 f3 ff ff       	call   80107750 <writeToBuff>
            itoa(*dev[k], tmp);
8010835e:	8b 84 b5 20 ff ff ff 	mov    -0xe0(%ebp,%esi,4),%eax
    if (num == 0) {
80108365:	83 c4 10             	add    $0x10,%esp
            itoa(*dev[k], tmp);
80108368:	8b 00                	mov    (%eax),%eax
    if (num == 0) {
8010836a:	85 c0                	test   %eax,%eax
8010836c:	0f 85 be 00 00 00    	jne    80108430 <ReadFromIdeInfo+0x260>
        str[i++] = '0';
80108372:	b9 30 00 00 00       	mov    $0x30,%ecx
80108377:	66 89 8d 4a fe ff ff 	mov    %cx,-0x1b6(%ebp)
            writeToBuff(tmp, designBuffer);
8010837e:	83 ec 08             	sub    $0x8,%esp
80108381:	53                   	push   %ebx
80108382:	ff b5 34 fe ff ff    	pushl  -0x1cc(%ebp)
80108388:	e8 c3 f3 ff ff       	call   80107750 <writeToBuff>
            writeToBuff(" , ", designBuffer);
8010838d:	58                   	pop    %eax
8010838e:	5a                   	pop    %edx
8010838f:	53                   	push   %ebx
80108390:	68 34 96 10 80       	push   $0x80109634
80108395:	e8 b6 f3 ff ff       	call   80107750 <writeToBuff>
8010839a:	8b 85 34 fe ff ff    	mov    -0x1cc(%ebp),%eax
801083a0:	83 c4 10             	add    $0x10,%esp
801083a3:	90                   	nop
801083a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
801083a8:	c6 00 00             	movb   $0x0,(%eax)
801083ab:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
801083ae:	39 c7                	cmp    %eax,%edi
801083b0:	75 f6                	jne    801083a8 <ReadFromIdeInfo+0x1d8>
            itoa(*block[k], tmp);
801083b2:	8b 84 b5 58 fe ff ff 	mov    -0x1a8(%ebp,%esi,4),%eax
801083b9:	8b 00                	mov    (%eax),%eax
    if (num == 0) {
801083bb:	85 c0                	test   %eax,%eax
801083bd:	0f 85 7d 00 00 00    	jne    80108440 <ReadFromIdeInfo+0x270>
        str[i++] = '0';
801083c3:	b9 30 00 00 00       	mov    $0x30,%ecx
801083c8:	66 89 8d 4a fe ff ff 	mov    %cx,-0x1b6(%ebp)
            writeToBuff(tmp, designBuffer);
801083cf:	83 ec 08             	sub    $0x8,%esp
801083d2:	53                   	push   %ebx
801083d3:	ff b5 34 fe ff ff    	pushl  -0x1cc(%ebp)
801083d9:	e8 72 f3 ff ff       	call   80107750 <writeToBuff>
            writeToBuff(" )", designBuffer);
801083de:	58                   	pop    %eax
801083df:	5a                   	pop    %edx
801083e0:	53                   	push   %ebx
801083e1:	68 38 96 10 80       	push   $0x80109638
801083e6:	e8 65 f3 ff ff       	call   80107750 <writeToBuff>
            k++;
801083eb:	8d 46 01             	lea    0x1(%esi),%eax
            if (k < listSize ) { //if last->print without delimiter
801083ee:	83 c4 10             	add    $0x10,%esp
801083f1:	39 85 2c fe ff ff    	cmp    %eax,-0x1d4(%ebp)
            k++;
801083f7:	89 85 30 fe ff ff    	mov    %eax,-0x1d0(%ebp)
            if (k < listSize ) { //if last->print without delimiter
801083fd:	74 64                	je     80108463 <ReadFromIdeInfo+0x293>
                writeToBuff("  ;  ", designBuffer);
801083ff:	83 ec 08             	sub    $0x8,%esp
80108402:	53                   	push   %ebx
80108403:	68 bf 96 10 80       	push   $0x801096bf
80108408:	e8 43 f3 ff ff       	call   80107750 <writeToBuff>
                if (count % 5 == 0)
8010840d:	b8 cd cc cc cc       	mov    $0xcccccccd,%eax
80108412:	83 c4 10             	add    $0x10,%esp
80108415:	f7 e6                	mul    %esi
80108417:	c1 ea 02             	shr    $0x2,%edx
8010841a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010841d:	39 c6                	cmp    %eax,%esi
8010841f:	74 2f                	je     80108450 <ReadFromIdeInfo+0x280>
80108421:	8b b5 30 fe ff ff    	mov    -0x1d0(%ebp),%esi
80108427:	e9 24 ff ff ff       	jmp    80108350 <ReadFromIdeInfo+0x180>
8010842c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108430:	8b 95 34 fe ff ff    	mov    -0x1cc(%ebp),%edx
80108436:	e8 85 f1 ff ff       	call   801075c0 <itoa.part.2>
8010843b:	e9 3e ff ff ff       	jmp    8010837e <ReadFromIdeInfo+0x1ae>
80108440:	8b 95 34 fe ff ff    	mov    -0x1cc(%ebp),%edx
80108446:	e8 75 f1 ff ff       	call   801075c0 <itoa.part.2>
8010844b:	e9 7f ff ff ff       	jmp    801083cf <ReadFromIdeInfo+0x1ff>
                    writeToBuff("\n  \t", designBuffer);
80108450:	83 ec 08             	sub    $0x8,%esp
80108453:	53                   	push   %ebx
80108454:	68 c5 96 10 80       	push   $0x801096c5
80108459:	e8 f2 f2 ff ff       	call   80107750 <writeToBuff>
8010845e:	83 c4 10             	add    $0x10,%esp
80108461:	eb be                	jmp    80108421 <ReadFromIdeInfo+0x251>
                writeToBuff(" )\n", designBuffer);
80108463:	83 ec 08             	sub    $0x8,%esp
80108466:	53                   	push   %ebx
80108467:	68 bb 96 10 80       	push   $0x801096bb
8010846c:	e8 df f2 ff ff       	call   80107750 <writeToBuff>
80108471:	83 c4 10             	add    $0x10,%esp
   return strlen(designBuffer);
80108474:	83 ec 0c             	sub    $0xc,%esp
80108477:	53                   	push   %ebx
80108478:	e8 93 c7 ff ff       	call   80104c10 <strlen>
}
8010847d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108480:	5b                   	pop    %ebx
80108481:	5e                   	pop    %esi
80108482:	5f                   	pop    %edi
80108483:	5d                   	pop    %ebp
80108484:	c3                   	ret    
80108485:	8b b5 34 fe ff ff    	mov    -0x1cc(%ebp),%esi
8010848b:	89 f2                	mov    %esi,%edx
8010848d:	e8 2e f1 ff ff       	call   801075c0 <itoa.part.2>
        writeToBuff(tmp, designBuffer);
80108492:	83 ec 08             	sub    $0x8,%esp
80108495:	53                   	push   %ebx
80108496:	56                   	push   %esi
80108497:	e8 b4 f2 ff ff       	call   80107750 <writeToBuff>
8010849c:	83 c4 10             	add    $0x10,%esp
8010849f:	e9 66 fe ff ff       	jmp    8010830a <ReadFromIdeInfo+0x13a>
801084a4:	8b bd 34 fe ff ff    	mov    -0x1cc(%ebp),%edi
801084aa:	89 fa                	mov    %edi,%edx
801084ac:	e8 0f f1 ff ff       	call   801075c0 <itoa.part.2>
        writeToBuff(tmp, designBuffer);
801084b1:	83 ec 08             	sub    $0x8,%esp
801084b4:	53                   	push   %ebx
801084b5:	57                   	push   %edi
801084b6:	e8 95 f2 ff ff       	call   80107750 <writeToBuff>
801084bb:	83 c4 10             	add    $0x10,%esp
801084be:	e9 fd fd ff ff       	jmp    801082c0 <ReadFromIdeInfo+0xf0>
801084c3:	8d 8d 4a fe ff ff    	lea    -0x1b6(%ebp),%ecx
801084c9:	89 ca                	mov    %ecx,%edx
801084cb:	89 ce                	mov    %ecx,%esi
801084cd:	89 8d 34 fe ff ff    	mov    %ecx,-0x1cc(%ebp)
801084d3:	e8 e8 f0 ff ff       	call   801075c0 <itoa.part.2>
        writeToBuff(tmp, designBuffer);
801084d8:	83 ec 08             	sub    $0x8,%esp
801084db:	53                   	push   %ebx
801084dc:	56                   	push   %esi
801084dd:	e8 6e f2 ff ff       	call   80107750 <writeToBuff>
801084e2:	83 c4 10             	add    $0x10,%esp
801084e5:	e9 8f fd ff ff       	jmp    80108279 <ReadFromIdeInfo+0xa9>
        writeToBuff(" , )\n", designBuffer);
801084ea:	83 ec 08             	sub    $0x8,%esp
801084ed:	53                   	push   %ebx
801084ee:	68 b9 96 10 80       	push   $0x801096b9
801084f3:	e8 58 f2 ff ff       	call   80107750 <writeToBuff>
801084f8:	83 c4 10             	add    $0x10,%esp
801084fb:	e9 74 ff ff ff       	jmp    80108474 <ReadFromIdeInfo+0x2a4>

80108500 <ReadPid>:
int ReadPid(char *designBuffer, int IPinum) {
80108500:	55                   	push   %ebp
    char searchDir[60] = {0};
80108501:	31 c0                	xor    %eax,%eax
80108503:	b9 0f 00 00 00       	mov    $0xf,%ecx
80108508:	ba ff ff ff ff       	mov    $0xffffffff,%edx
int ReadPid(char *designBuffer, int IPinum) {
8010850d:	89 e5                	mov    %esp,%ebp
8010850f:	57                   	push   %edi
80108510:	56                   	push   %esi
80108511:	53                   	push   %ebx
    char searchDir[60] = {0};
80108512:	8d 5d ac             	lea    -0x54(%ebp),%ebx
80108515:	89 df                	mov    %ebx,%edi
int ReadPid(char *designBuffer, int IPinum) {
80108517:	83 ec 5c             	sub    $0x5c,%esp
8010851a:	8b 75 08             	mov    0x8(%ebp),%esi
    char searchDir[60] = {0};
8010851d:	f3 ab                	rep stos %eax,%es:(%edi)
    if (IPinum >= sbInodes + PROCINODES) {
8010851f:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
80108524:	8d 48 31             	lea    0x31(%eax),%ecx
80108527:	3b 4d 0c             	cmp    0xc(%ebp),%ecx
8010852a:	7d 19                	jge    80108545 <ReadPid+0x45>
        proc = ((IPinum - sbInodes) / PROCINODES) - 1;
8010852c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010852f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80108534:	29 c1                	sub    %eax,%ecx
80108536:	89 c8                	mov    %ecx,%eax
80108538:	c1 f9 1f             	sar    $0x1f,%ecx
8010853b:	f7 ea                	imul   %edx
8010853d:	c1 fa 04             	sar    $0x4,%edx
80108540:	29 ca                	sub    %ecx,%edx
80108542:	83 ea 01             	sub    $0x1,%edx
    currproc = getProc(proc);
80108545:	83 ec 0c             	sub    $0xc,%esp
80108548:	52                   	push   %edx
80108549:	e8 d2 c0 ff ff       	call   80104620 <getProc>
    if (!currproc) //validation check
8010854e:	83 c4 10             	add    $0x10,%esp
80108551:	85 c0                	test   %eax,%eax
    currproc = getProc(proc);
80108553:	89 c7                	mov    %eax,%edi
    if (!currproc) //validation check
80108555:	0f 84 a4 00 00 00    	je     801085ff <ReadPid+0xff>
    writeToBuff("/proc/", searchDir);
8010855b:	83 ec 08             	sub    $0x8,%esp
8010855e:	53                   	push   %ebx
8010855f:	68 ca 96 10 80       	push   $0x801096ca
80108564:	e8 e7 f1 ff ff       	call   80107750 <writeToBuff>
    itoa(currproc->pid, tmp);
80108569:	8b 47 10             	mov    0x10(%edi),%eax
    if (num == 0) {
8010856c:	83 c4 10             	add    $0x10,%esp
8010856f:	85 c0                	test   %eax,%eax
80108571:	75 7d                	jne    801085f0 <ReadPid+0xf0>
        str[i++] = '0';
80108573:	b8 30 00 00 00       	mov    $0x30,%eax
80108578:	8d 7d 9e             	lea    -0x62(%ebp),%edi
8010857b:	66 89 45 9e          	mov    %ax,-0x62(%ebp)
    writeToBuff(tmp, searchDir);
8010857f:	83 ec 08             	sub    $0x8,%esp
80108582:	53                   	push   %ebx
80108583:	57                   	push   %edi
80108584:	e8 c7 f1 ff ff       	call   80107750 <writeToBuff>
    writeDirentToBuff(currDirent, ".", IPinum, designBuffer);
80108589:	56                   	push   %esi
8010858a:	ff 75 0c             	pushl  0xc(%ebp)
8010858d:	68 bc 91 10 80       	push   $0x801091bc
80108592:	6a 00                	push   $0x0
80108594:	e8 67 f1 ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "..", namei("/proc")->inum, designBuffer);
80108599:	83 c4 14             	add    $0x14,%esp
8010859c:	68 6e 95 10 80       	push   $0x8010956e
801085a1:	e8 aa 9c ff ff       	call   80102250 <namei>
801085a6:	56                   	push   %esi
801085a7:	ff 70 04             	pushl  0x4(%eax)
801085aa:	68 bb 91 10 80       	push   $0x801091bb
801085af:	6a 01                	push   $0x1
801085b1:	e8 4a f1 ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "name", IPinum + 1, designBuffer);
801085b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801085b9:	83 c4 20             	add    $0x20,%esp
801085bc:	56                   	push   %esi
801085bd:	83 c0 01             	add    $0x1,%eax
801085c0:	50                   	push   %eax
801085c1:	68 d1 96 10 80       	push   $0x801096d1
801085c6:	6a 02                	push   $0x2
801085c8:	e8 33 f1 ff ff       	call   80107700 <writeDirentToBuff>
    writeDirentToBuff(currDirent, "status", IPinum + 2, designBuffer);
801085cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801085d0:	56                   	push   %esi
801085d1:	83 c0 02             	add    $0x2,%eax
801085d4:	50                   	push   %eax
801085d5:	68 d6 96 10 80       	push   $0x801096d6
801085da:	6a 03                	push   $0x3
801085dc:	e8 1f f1 ff ff       	call   80107700 <writeDirentToBuff>
}
801085e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085e4:	b8 40 00 00 00       	mov    $0x40,%eax
801085e9:	5b                   	pop    %ebx
801085ea:	5e                   	pop    %esi
801085eb:	5f                   	pop    %edi
801085ec:	5d                   	pop    %ebp
801085ed:	c3                   	ret    
801085ee:	66 90                	xchg   %ax,%ax
801085f0:	8d 7d 9e             	lea    -0x62(%ebp),%edi
801085f3:	89 fa                	mov    %edi,%edx
801085f5:	e8 c6 ef ff ff       	call   801075c0 <itoa.part.2>
801085fa:	e9 80 ff ff ff       	jmp    8010857f <ReadPid+0x7f>
        panic("ERROR - ReadPidStatus: PROC IS NULL!");
801085ff:	83 ec 0c             	sub    $0xc,%esp
80108602:	68 f8 94 10 80       	push   $0x801094f8
80108607:	e8 84 7d ff ff       	call   80100390 <panic>
8010860c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108610 <ReadPidName>:
int ReadPidName(char *designBuffer, int IPinum) {
80108610:	55                   	push   %ebp
    if (IPinum >= sbInodes + PROCINODES) {
80108611:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
80108616:	ba ff ff ff ff       	mov    $0xffffffff,%edx
int ReadPidName(char *designBuffer, int IPinum) {
8010861b:	89 e5                	mov    %esp,%ebp
8010861d:	56                   	push   %esi
8010861e:	53                   	push   %ebx
8010861f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    if (IPinum >= sbInodes + PROCINODES) {
80108622:	8d 70 31             	lea    0x31(%eax),%esi
int ReadPidName(char *designBuffer, int IPinum) {
80108625:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (IPinum >= sbInodes + PROCINODES) {
80108628:	39 ce                	cmp    %ecx,%esi
8010862a:	7d 16                	jge    80108642 <ReadPidName+0x32>
        proc = ((IPinum - sbInodes) / PROCINODES) - 1;
8010862c:	29 c1                	sub    %eax,%ecx
8010862e:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80108633:	89 c8                	mov    %ecx,%eax
80108635:	c1 f9 1f             	sar    $0x1f,%ecx
80108638:	f7 ea                	imul   %edx
8010863a:	c1 fa 04             	sar    $0x4,%edx
8010863d:	29 ca                	sub    %ecx,%edx
8010863f:	83 ea 01             	sub    $0x1,%edx
   currproc = getProc(proc);
80108642:	83 ec 0c             	sub    $0xc,%esp
80108645:	52                   	push   %edx
80108646:	e8 d5 bf ff ff       	call   80104620 <getProc>
    if (!currproc) //validation check
8010864b:	83 c4 10             	add    $0x10,%esp
8010864e:	85 c0                	test   %eax,%eax
80108650:	74 1e                	je     80108670 <ReadPidName+0x60>
    writeToBuff(currproc->name, designBuffer);
80108652:	83 ec 08             	sub    $0x8,%esp
80108655:	83 c0 6c             	add    $0x6c,%eax
80108658:	53                   	push   %ebx
80108659:	50                   	push   %eax
8010865a:	e8 f1 f0 ff ff       	call   80107750 <writeToBuff>
    return strlen(designBuffer);
8010865f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108662:	83 c4 10             	add    $0x10,%esp
}
80108665:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108668:	5b                   	pop    %ebx
80108669:	5e                   	pop    %esi
8010866a:	5d                   	pop    %ebp
    return strlen(designBuffer);
8010866b:	e9 a0 c5 ff ff       	jmp    80104c10 <strlen>
        panic("ERROR - ReadPidStatus: PROC IS NULL!");
80108670:	83 ec 0c             	sub    $0xc,%esp
80108673:	68 f8 94 10 80       	push   $0x801094f8
80108678:	e8 13 7d ff ff       	call   80100390 <panic>
8010867d:	8d 76 00             	lea    0x0(%esi),%esi

80108680 <ReadPidStatus>:
int ReadPidStatus(char *designBuffer, int IPinum) {
80108680:	55                   	push   %ebp
80108681:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80108686:	89 e5                	mov    %esp,%ebp
80108688:	57                   	push   %edi
80108689:	56                   	push   %esi
8010868a:	53                   	push   %ebx
8010868b:	83 ec 2c             	sub    $0x2c,%esp
    if (IPinum >= sbInodes + PROCINODES) {
8010868e:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
int ReadPidStatus(char *designBuffer, int IPinum) {
80108693:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80108696:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (IPinum >= sbInodes + PROCINODES) {
80108699:	8d 70 31             	lea    0x31(%eax),%esi
8010869c:	39 f1                	cmp    %esi,%ecx
8010869e:	7e 16                	jle    801086b6 <ReadPidStatus+0x36>
        *proc = (IPinum - sbInodes) / PROCINODES - 1;
801086a0:	29 c1                	sub    %eax,%ecx
801086a2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801086a7:	89 c8                	mov    %ecx,%eax
801086a9:	c1 f9 1f             	sar    $0x1f,%ecx
801086ac:	f7 ea                	imul   %edx
801086ae:	c1 fa 04             	sar    $0x4,%edx
801086b1:	29 ca                	sub    %ecx,%edx
801086b3:	83 ea 01             	sub    $0x1,%edx
    currproc = getProc(proc);
801086b6:	83 ec 0c             	sub    $0xc,%esp
801086b9:	52                   	push   %edx
801086ba:	e8 61 bf ff ff       	call   80104620 <getProc>
    if (!currproc) //validation check
801086bf:	83 c4 10             	add    $0x10,%esp
801086c2:	85 c0                	test   %eax,%eax
    currproc = getProc(proc);
801086c4:	89 c7                	mov    %eax,%edi
    if (!currproc) //validation check
801086c6:	0f 84 88 01 00 00    	je     80108854 <ReadPidStatus+0x1d4>
    writeToBuff("run state:\t", designBuffer);
801086cc:	83 ec 08             	sub    $0x8,%esp
801086cf:	8d 75 da             	lea    -0x26(%ebp),%esi
801086d2:	53                   	push   %ebx
801086d3:	68 dd 96 10 80       	push   $0x801096dd
801086d8:	e8 73 f0 ff ff       	call   80107750 <writeToBuff>
801086dd:	8d 4d e8             	lea    -0x18(%ebp),%ecx
801086e0:	89 f2                	mov    %esi,%edx
801086e2:	83 c4 10             	add    $0x10,%esp
801086e5:	89 f0                	mov    %esi,%eax
801086e7:	89 f6                	mov    %esi,%esi
801086e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        name[i] = 0;
801086f0:	c6 00 00             	movb   $0x0,(%eax)
801086f3:	83 c0 01             	add    $0x1,%eax
    for (int i = 0; i < DIRSIZ; i++)
801086f6:	39 c8                	cmp    %ecx,%eax
801086f8:	75 f6                	jne    801086f0 <ReadPidStatus+0x70>
    switch (currproc->state) {
801086fa:	83 7f 0c 05          	cmpl   $0x5,0xc(%edi)
801086fe:	0f 87 5d 01 00 00    	ja     80108861 <ReadPidStatus+0x1e1>
80108704:	8b 4f 0c             	mov    0xc(%edi),%ecx
80108707:	89 45 d0             	mov    %eax,-0x30(%ebp)
8010870a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010870d:	ff 24 8d 40 97 10 80 	jmp    *-0x7fef68c0(,%ecx,4)
80108714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("RUNNING",tmp);
80108718:	83 ec 08             	sub    $0x8,%esp
8010871b:	56                   	push   %esi
8010871c:	68 e9 96 10 80       	push   $0x801096e9
80108721:	e8 2a f0 ff ff       	call   80107750 <writeToBuff>
            break;
80108726:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108729:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010872c:	83 c4 10             	add    $0x10,%esp
8010872f:	90                   	nop
    writeToBuff(tmp, designBuffer);
80108730:	83 ec 08             	sub    $0x8,%esp
80108733:	89 45 d0             	mov    %eax,-0x30(%ebp)
80108736:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80108739:	53                   	push   %ebx
8010873a:	56                   	push   %esi
8010873b:	e8 10 f0 ff ff       	call   80107750 <writeToBuff>
80108740:	8b 45 d0             	mov    -0x30(%ebp),%eax
80108743:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80108746:	83 c4 10             	add    $0x10,%esp
80108749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        name[i] = 0;
80108750:	c6 02 00             	movb   $0x0,(%edx)
80108753:	83 c2 01             	add    $0x1,%edx
    for (int i = 0; i < DIRSIZ; i++)
80108756:	39 c2                	cmp    %eax,%edx
80108758:	75 f6                	jne    80108750 <ReadPidStatus+0xd0>
    writeToBuff("\nsize (in bytes):\t", designBuffer);
8010875a:	83 ec 08             	sub    $0x8,%esp
8010875d:	53                   	push   %ebx
8010875e:	68 2c 97 10 80       	push   $0x8010972c
80108763:	e8 e8 ef ff ff       	call   80107750 <writeToBuff>
    itoa(currproc->sz, tmp);
80108768:	8b 07                	mov    (%edi),%eax
    if (num == 0) {
8010876a:	83 c4 10             	add    $0x10,%esp
8010876d:	85 c0                	test   %eax,%eax
8010876f:	0f 85 d3 00 00 00    	jne    80108848 <ReadPidStatus+0x1c8>
        str[i++] = '0';
80108775:	b9 30 00 00 00       	mov    $0x30,%ecx
8010877a:	66 89 4d da          	mov    %cx,-0x26(%ebp)
    writeToBuff(tmp, designBuffer);
8010877e:	83 ec 08             	sub    $0x8,%esp
80108781:	53                   	push   %ebx
80108782:	56                   	push   %esi
80108783:	e8 c8 ef ff ff       	call   80107750 <writeToBuff>
    writeToBuff("\n", designBuffer);
80108788:	58                   	pop    %eax
80108789:	5a                   	pop    %edx
8010878a:	53                   	push   %ebx
8010878b:	68 ea 95 10 80       	push   $0x801095ea
80108790:	e8 bb ef ff ff       	call   80107750 <writeToBuff>
    return strlen(designBuffer);
80108795:	89 1c 24             	mov    %ebx,(%esp)
80108798:	e8 73 c4 ff ff       	call   80104c10 <strlen>
}
8010879d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087a0:	5b                   	pop    %ebx
801087a1:	5e                   	pop    %esi
801087a2:	5f                   	pop    %edi
801087a3:	5d                   	pop    %ebp
801087a4:	c3                   	ret    
801087a5:	8d 76 00             	lea    0x0(%esi),%esi
            writeToBuff("ZOMBIE",tmp);
801087a8:	83 ec 08             	sub    $0x8,%esp
801087ab:	56                   	push   %esi
801087ac:	68 0a 97 10 80       	push   $0x8010970a
801087b1:	e8 9a ef ff ff       	call   80107750 <writeToBuff>
            break;
801087b6:	83 c4 10             	add    $0x10,%esp
801087b9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801087bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087bf:	e9 6c ff ff ff       	jmp    80108730 <ReadPidStatus+0xb0>
801087c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("UNUSED",tmp);
801087c8:	83 ec 08             	sub    $0x8,%esp
801087cb:	56                   	push   %esi
801087cc:	68 03 97 10 80       	push   $0x80109703
801087d1:	e8 7a ef ff ff       	call   80107750 <writeToBuff>
            break;
801087d6:	83 c4 10             	add    $0x10,%esp
801087d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801087dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087df:	e9 4c ff ff ff       	jmp    80108730 <ReadPidStatus+0xb0>
801087e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("EMBRYO",tmp);
801087e8:	83 ec 08             	sub    $0x8,%esp
801087eb:	56                   	push   %esi
801087ec:	68 11 97 10 80       	push   $0x80109711
801087f1:	e8 5a ef ff ff       	call   80107750 <writeToBuff>
            break;
801087f6:	83 c4 10             	add    $0x10,%esp
801087f9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801087fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
801087ff:	e9 2c ff ff ff       	jmp    80108730 <ReadPidStatus+0xb0>
80108804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("SLEEPING",tmp);
80108808:	83 ec 08             	sub    $0x8,%esp
8010880b:	56                   	push   %esi
8010880c:	68 fa 96 10 80       	push   $0x801096fa
80108811:	e8 3a ef ff ff       	call   80107750 <writeToBuff>
            break;
80108816:	83 c4 10             	add    $0x10,%esp
80108819:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010881c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010881f:	e9 0c ff ff ff       	jmp    80108730 <ReadPidStatus+0xb0>
80108824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            writeToBuff("RUNNABLE",tmp);
80108828:	83 ec 08             	sub    $0x8,%esp
8010882b:	56                   	push   %esi
8010882c:	68 f1 96 10 80       	push   $0x801096f1
80108831:	e8 1a ef ff ff       	call   80107750 <writeToBuff>
            break;
80108836:	83 c4 10             	add    $0x10,%esp
80108839:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010883c:	8b 45 d0             	mov    -0x30(%ebp),%eax
8010883f:	e9 ec fe ff ff       	jmp    80108730 <ReadPidStatus+0xb0>
80108844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108848:	89 f2                	mov    %esi,%edx
8010884a:	e8 71 ed ff ff       	call   801075c0 <itoa.part.2>
8010884f:	e9 2a ff ff ff       	jmp    8010877e <ReadPidStatus+0xfe>
        panic("ERROR - ReadPidStatus: PROC IS NULL!");
80108854:	83 ec 0c             	sub    $0xc,%esp
80108857:	68 f8 94 10 80       	push   $0x801094f8
8010885c:	e8 2f 7b ff ff       	call   80100390 <panic>
            panic("ERROR - WRONG STATE");
80108861:	83 ec 0c             	sub    $0xc,%esp
80108864:	68 18 97 10 80       	push   $0x80109718
80108869:	e8 22 7b ff ff       	call   80100390 <panic>
8010886e:	66 90                	xchg   %ax,%ax

80108870 <procfsread>:
procfsread(struct inode *ip, char *dst, int off, int n) {
80108870:	55                   	push   %ebp
80108871:	89 e5                	mov    %esp,%ebp
80108873:	57                   	push   %edi
80108874:	56                   	push   %esi
80108875:	53                   	push   %ebx
80108876:	81 ec 0c 10 00 00    	sub    $0x100c,%esp
    if (!sbInodes) {
8010887c:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
procfsread(struct inode *ip, char *dst, int off, int n) {
80108881:	8b 75 14             	mov    0x14(%ebp),%esi
    if (!sbInodes) {
80108884:	85 c0                	test   %eax,%eax
80108886:	0f 84 94 00 00 00    	je     80108920 <procfsread+0xb0>
    char designBuffer[PGSIZE] = {0};
8010888c:	8d 9d e8 ef ff ff    	lea    -0x1018(%ebp),%ebx
80108892:	31 c0                	xor    %eax,%eax
80108894:	b9 00 04 00 00       	mov    $0x400,%ecx
80108899:	89 df                	mov    %ebx,%edi
8010889b:	f3 ab                	rep stos %eax,%es:(%edi)
    int answer = 0, IPinum = ip->inum;
8010889d:	8b 45 08             	mov    0x8(%ebp),%eax
801088a0:	8b 48 04             	mov    0x4(%eax),%ecx
    if (IPinum == IDEINFO) {
801088a3:	39 0d cc c5 10 80    	cmp    %ecx,0x8010c5cc
801088a9:	0f 84 81 00 00 00    	je     80108930 <procfsread+0xc0>
    if (IPinum == FILESTAT) {
801088af:	39 0d c8 c5 10 80    	cmp    %ecx,0x8010c5c8
801088b5:	0f 84 c5 00 00 00    	je     80108980 <procfsread+0x110>
    if (IPinum == INODEINFO) {
801088bb:	39 0d c4 c5 10 80    	cmp    %ecx,0x8010c5c4
801088c1:	0f 84 d1 00 00 00    	je     80108998 <procfsread+0x128>
    if (IPinum < sbInodes) {
801088c7:	a1 d0 c5 10 80       	mov    0x8010c5d0,%eax
801088cc:	39 c8                	cmp    %ecx,%eax
801088ce:	0f 8f 94 00 00 00    	jg     80108968 <procfsread+0xf8>
    if ((IPinum - sbInodes) % PROCINODES == 0) {
801088d4:	89 cf                	mov    %ecx,%edi
801088d6:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801088db:	29 c7                	sub    %eax,%edi
801088dd:	89 f8                	mov    %edi,%eax
801088df:	f7 e2                	mul    %edx
801088e1:	c1 ea 04             	shr    $0x4,%edx
801088e4:	6b d2 32             	imul   $0x32,%edx,%edx
801088e7:	29 d7                	sub    %edx,%edi
801088e9:	0f 84 c1 00 00 00    	je     801089b0 <procfsread+0x140>
    if ((IPinum - sbInodes) % PROCINODES == 1) {
801088ef:	83 ff 01             	cmp    $0x1,%edi
801088f2:	0f 84 d0 00 00 00    	je     801089c8 <procfsread+0x158>
    if ((IPinum - sbInodes) % PROCINODES == 2) {
801088f8:	83 ff 02             	cmp    $0x2,%edi
801088fb:	0f 84 df 00 00 00    	je     801089e0 <procfsread+0x170>
    if (IPinum >= VIRTUALINODEINFO) {
80108901:	39 0d c0 c5 10 80    	cmp    %ecx,0x8010c5c0
80108907:	0f 8f e7 00 00 00    	jg     801089f4 <procfsread+0x184>
        answer = ReadVirtInfo(designBuffer, IPinum);
8010890d:	83 ec 08             	sub    $0x8,%esp
80108910:	51                   	push   %ecx
80108911:	53                   	push   %ebx
80108912:	e8 19 f4 ff ff       	call   80107d30 <ReadVirtInfo>
        goto appliedFunc;
80108917:	83 c4 10             	add    $0x10,%esp
        answer = ReadVirtInfo(designBuffer, IPinum);
8010891a:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
8010891c:	eb 21                	jmp    8010893f <procfsread+0xcf>
8010891e:	66 90                	xchg   %ax,%ax
80108920:	8b 45 08             	mov    0x8(%ebp),%eax
80108923:	e8 c8 eb ff ff       	call   801074f0 <initSbInodes.part.0>
80108928:	e9 5f ff ff ff       	jmp    8010888c <procfsread+0x1c>
8010892d:	8d 76 00             	lea    0x0(%esi),%esi
        answer = ReadFromIdeInfo(designBuffer, IPinum);
80108930:	83 ec 08             	sub    $0x8,%esp
80108933:	51                   	push   %ecx
80108934:	53                   	push   %ebx
80108935:	e8 96 f8 ff ff       	call   801081d0 <ReadFromIdeInfo>
        goto appliedFunc;
8010893a:	83 c4 10             	add    $0x10,%esp
        answer = ReadFromIdeInfo(designBuffer, IPinum);
8010893d:	89 c7                	mov    %eax,%edi
    memmove(dst, designBuffer + off, (uint) n);
8010893f:	03 5d 10             	add    0x10(%ebp),%ebx
80108942:	83 ec 04             	sub    $0x4,%esp
80108945:	56                   	push   %esi
80108946:	53                   	push   %ebx
80108947:	ff 75 0c             	pushl  0xc(%ebp)
8010894a:	e8 51 c1 ff ff       	call   80104aa0 <memmove>
    if (answer - off <= n)
8010894f:	2b 7d 10             	sub    0x10(%ebp),%edi
80108952:	83 c4 10             	add    $0x10,%esp
80108955:	89 f0                	mov    %esi,%eax
80108957:	39 f7                	cmp    %esi,%edi
80108959:	0f 4e c7             	cmovle %edi,%eax
}
8010895c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010895f:	5b                   	pop    %ebx
80108960:	5e                   	pop    %esi
80108961:	5f                   	pop    %edi
80108962:	5d                   	pop    %ebp
80108963:	c3                   	ret    
80108964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        answer = ReadFromMemInodes(designBuffer, IPinum);
80108968:	83 ec 08             	sub    $0x8,%esp
8010896b:	51                   	push   %ecx
8010896c:	53                   	push   %ebx
8010896d:	e8 4e ee ff ff       	call   801077c0 <ReadFromMemInodes>
        goto appliedFunc;
80108972:	83 c4 10             	add    $0x10,%esp
        answer = ReadFromMemInodes(designBuffer, IPinum);
80108975:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
80108977:	eb c6                	jmp    8010893f <procfsread+0xcf>
80108979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        answer = ReadFromFileStat(designBuffer, IPinum);
80108980:	83 ec 08             	sub    $0x8,%esp
80108983:	51                   	push   %ecx
80108984:	53                   	push   %ebx
80108985:	e8 26 f0 ff ff       	call   801079b0 <ReadFromFileStat>
        goto appliedFunc;
8010898a:	83 c4 10             	add    $0x10,%esp
        answer = ReadFromFileStat(designBuffer, IPinum);
8010898d:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
8010898f:	eb ae                	jmp    8010893f <procfsread+0xcf>
80108991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        answer = ReadFromInodeInfo(designBuffer, IPinum);
80108998:	83 ec 08             	sub    $0x8,%esp
8010899b:	51                   	push   %ecx
8010899c:	53                   	push   %ebx
8010899d:	e8 ce f2 ff ff       	call   80107c70 <ReadFromInodeInfo>
        goto appliedFunc;
801089a2:	83 c4 10             	add    $0x10,%esp
        answer = ReadFromInodeInfo(designBuffer, IPinum);
801089a5:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
801089a7:	eb 96                	jmp    8010893f <procfsread+0xcf>
801089a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        answer = ReadPid(designBuffer, IPinum);
801089b0:	83 ec 08             	sub    $0x8,%esp
801089b3:	51                   	push   %ecx
801089b4:	53                   	push   %ebx
801089b5:	e8 46 fb ff ff       	call   80108500 <ReadPid>
        goto appliedFunc;
801089ba:	83 c4 10             	add    $0x10,%esp
        answer = ReadPid(designBuffer, IPinum);
801089bd:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
801089bf:	e9 7b ff ff ff       	jmp    8010893f <procfsread+0xcf>
801089c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        answer = ReadPidName(designBuffer, IPinum);
801089c8:	83 ec 08             	sub    $0x8,%esp
801089cb:	51                   	push   %ecx
801089cc:	53                   	push   %ebx
801089cd:	e8 3e fc ff ff       	call   80108610 <ReadPidName>
        goto appliedFunc;
801089d2:	83 c4 10             	add    $0x10,%esp
        answer = ReadPidName(designBuffer, IPinum);
801089d5:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
801089d7:	e9 63 ff ff ff       	jmp    8010893f <procfsread+0xcf>
801089dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        answer = ReadPidStatus(designBuffer, IPinum);
801089e0:	83 ec 08             	sub    $0x8,%esp
801089e3:	51                   	push   %ecx
801089e4:	53                   	push   %ebx
801089e5:	e8 96 fc ff ff       	call   80108680 <ReadPidStatus>
        goto appliedFunc;
801089ea:	83 c4 10             	add    $0x10,%esp
        answer = ReadPidStatus(designBuffer, IPinum);
801089ed:	89 c7                	mov    %eax,%edi
        goto appliedFunc;
801089ef:	e9 4b ff ff ff       	jmp    8010893f <procfsread+0xcf>
    panic(" Wrong IP -> INUM CAUSED THIS TRAP, procfsread");
801089f4:	83 ec 0c             	sub    $0xc,%esp
801089f7:	68 20 95 10 80       	push   $0x80109520
801089fc:	e8 8f 79 ff ff       	call   80100390 <panic>
80108a01:	eb 0d                	jmp    80108a10 <procfsinit>
80108a03:	90                   	nop
80108a04:	90                   	nop
80108a05:	90                   	nop
80108a06:	90                   	nop
80108a07:	90                   	nop
80108a08:	90                   	nop
80108a09:	90                   	nop
80108a0a:	90                   	nop
80108a0b:	90                   	nop
80108a0c:	90                   	nop
80108a0d:	90                   	nop
80108a0e:	90                   	nop
80108a0f:	90                   	nop

80108a10 <procfsinit>:

void
procfsinit(void) {
80108a10:	55                   	push   %ebp
    devsw[PROCFS].isdir = procfsisdir;
80108a11:	c7 05 a0 29 11 80 40 	movl   $0x80107540,0x801129a0
80108a18:	75 10 80 
    devsw[PROCFS].iread = procfsiread;
80108a1b:	c7 05 a4 29 11 80 b0 	movl   $0x801074b0,0x801129a4
80108a22:	74 10 80 
    devsw[PROCFS].write = procfswrite;
80108a25:	c7 05 ac 29 11 80 d0 	movl   $0x801074d0,0x801129ac
80108a2c:	74 10 80 
procfsinit(void) {
80108a2f:	89 e5                	mov    %esp,%ebp
    devsw[PROCFS].read = procfsread;
80108a31:	c7 05 a8 29 11 80 70 	movl   $0x80108870,0x801129a8
80108a38:	88 10 80 
}
80108a3b:	5d                   	pop    %ebp
80108a3c:	c3                   	ret    
