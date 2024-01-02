
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xorg on boot processor, with paging off.
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 2f 10 80       	mov    $0x80102ff0,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 a0 70 10 80       	push   $0x801070a0
80100055:	68 c0 b5 10 80       	push   $0x8010b5c0
8010005a:	e8 31 43 00 00       	call   80104390 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc fc 10 80       	mov    $0x8010fcbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006e:	fc 10 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100078:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 70 10 80       	push   $0x801070a7
80100097:	50                   	push   %eax
80100098:	e8 b3 41 00 00       	call   80104250 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 fa 10 80    	cmp    $0x8010fa60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e8:	e8 23 44 00 00       	call   80104510 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 69 44 00 00       	call   801045d0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 41 00 00       	call   80104290 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 af 20 00 00       	call   80102240 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ae 70 10 80       	push   $0x801070ae
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 69 41 00 00       	call   80104330 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 63 20 00 00       	jmp    80102240 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 70 10 80       	push   $0x801070bf
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 28 41 00 00       	call   80104330 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 d8 40 00 00       	call   801042f0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021f:	e8 ec 42 00 00       	call   80104510 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 5b 43 00 00       	jmp    801045d0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 70 10 80       	push   $0x801070c6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 56 15 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002b1:	e8 5a 42 00 00       	call   80104510 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cb:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 a5 10 80       	push   $0x8010a520
801002e0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002e5:	e8 e6 3b 00 00       	call   80103ed0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 11 36 00 00       	call   80103910 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 a5 10 80       	push   $0x8010a520
8010030e:	e8 bd 42 00 00       	call   801045d0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 04 14 00 00       	call   80101720 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 a5 10 80       	push   $0x8010a520
80100365:	e8 66 42 00 00       	call   801045d0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ad 13 00 00       	call   80101720 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 ae 24 00 00       	call   80102860 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 70 10 80       	push   $0x801070cd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 98 79 10 80 	movl   $0x80107998,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 cf 3f 00 00       	call   801043b0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 70 10 80       	push   $0x801070e1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 61 58 00 00       	call   80105c90 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 76 57 00 00       	call   80105c90 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 57 00 00       	call   80105c90 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 57 00 00       	call   80105c90 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 5a 41 00 00       	call   801046c0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 a5 40 00 00       	call   80104620 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 70 10 80       	push   $0x801070e5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 10 71 10 80 	movzbl -0x7fef8ef0(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 a8 11 00 00       	call   80101800 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010065f:	e8 ac 3e 00 00       	call   80104510 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 a5 10 80       	push   $0x8010a520
80100697:	e8 34 3f 00 00       	call   801045d0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 7b 10 00 00       	call   80101720 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb f8 70 10 80       	mov    $0x801070f8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 a5 10 80       	push   $0x8010a520
801007bd:	e8 4e 3d 00 00       	call   80104510 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 a5 10 80    	mov    0x8010a558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 a3 3d 00 00       	call   801045d0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 70 10 80       	push   $0x801070ff
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 a5 10 80       	push   $0x8010a520
80100877:	e8 94 3c 00 00       	call   80104510 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100925:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
8010094c:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010096f:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100985:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
80100999:	a1 58 a5 10 80       	mov    0x8010a558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 a5 10 80       	push   $0x8010a520
801009cf:	e8 fc 3b 00 00       	call   801045d0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 7c 37 00 00       	jmp    80104180 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a1b:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a20:	e8 6b 36 00 00       	call   80104090 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 08 71 10 80       	push   $0x80107108
80100a3f:	68 20 a5 10 80       	push   $0x8010a520
80100a44:	e8 47 39 00 00       	call   80104390 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 09 11 80 40 	movl   $0x80100640,0x8011096c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 09 11 80 90 	movl   $0x80100290,0x80110968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 7e 19 00 00       	call   801023f0 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 7b 2e 00 00       	call   80103910 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 50 22 00 00       	call   80102cf0 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 45 15 00 00       	call   80101ff0 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 5f 0c 00 00       	call   80101720 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 4e 0f 00 00       	call   80101a20 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 dd 0e 00 00       	call   801019c0 <iunlockput>
    end_op();
80100ae3:	e8 78 22 00 00       	call   80102d60 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 ef 62 00 00       	call   80106e00 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 a8 60 00 00       	call   80106c20 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 a2 5f 00 00       	call   80106b50 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 4a 0e 00 00       	call   80101a20 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 90 61 00 00       	call   80106d80 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 9f 0d 00 00       	call   801019c0 <iunlockput>
  end_op();
80100c21:	e8 3a 21 00 00       	call   80102d60 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 e9 5f 00 00       	call   80106c20 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 48 62 00 00       	call   80106ea0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 78 3b 00 00       	call   80104820 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 65 3b 00 00       	call   80104820 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 34 63 00 00       	call   80107000 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 9a 60 00 00       	call   80106d80 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 c8 62 00 00       	call   80107000 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 6a 3a 00 00       	call   801047e0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 1e 5c 00 00       	call   801069c0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 d6 5f 00 00       	call   80106d80 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 a7 1f 00 00       	call   80102d60 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 21 71 10 80       	push   $0x80107121
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 2d 71 10 80       	push   $0x8010712d
80100def:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df4:	e8 97 35 00 00       	call   80104390 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e15:	e8 f6 36 00 00       	call   80104510 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 8a 37 00 00       	call   801045d0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 71 37 00 00       	call   801045d0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e83:	e8 88 36 00 00       	call   80104510 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ea0:	e8 2b 37 00 00       	call   801045d0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 34 71 10 80       	push   $0x80107134
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed5:	e8 36 36 00 00       	call   80104510 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 bb 36 00 00       	call   801045d0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 8d 36 00 00       	jmp    801045d0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 a3 1d 00 00       	call   80102cf0 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 f8 08 00 00       	call   80101850 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 f9 1d 00 00       	jmp    80102d60 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 32 25 00 00       	call   801034b0 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 3c 71 10 80       	push   $0x8010713c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 62 07 00 00       	call   80101720 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 25 0a 00 00       	call   801019f0 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 2c 08 00 00       	call   80101800 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 fd 06 00 00       	call   80101720 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 f0 09 00 00       	call   80101a20 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 b9 07 00 00       	call   80101800 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 e6 25 00 00       	jmp    80103650 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 46 71 10 80       	push   $0x80107146
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 0f 07 00 00       	call   80101800 <iunlock>
      end_op();
801010f1:	e8 6a 1c 00 00       	call   80102d60 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 d1 1b 00 00       	call   80102cf0 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 f6 05 00 00       	call   80101720 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 e4 09 00 00       	call   80101b20 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 af 06 00 00       	call   80101800 <iunlock>
      end_op();
80101151:	e8 0a 1c 00 00       	call   80102d60 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 4f 71 10 80       	push   $0x8010714f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 ba 23 00 00       	jmp    80103550 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 55 71 10 80       	push   $0x80107155
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 ce 1c 00 00       	call   80102ed0 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 5f 71 10 80       	push   $0x8010715f
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 72 71 10 80       	push   $0x80107172
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 de 1b 00 00       	call   80102ed0 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 06 33 00 00       	call   80104620 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ae 1b 00 00       	call   80102ed0 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 09 11 80       	push   $0x801109e0
8010135a:	e8 b1 31 00 00       	call   80104510 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 09 11 80       	push   $0x801109e0
801013c7:	e8 04 32 00 00       	call   801045d0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 d6 31 00 00       	call   801045d0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 88 71 10 80       	push   $0x80107188
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 26 1a 00 00       	call   80102ed0 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 98 71 10 80       	push   $0x80107198
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 96 31 00 00       	call   801046c0 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 ab 71 10 80       	push   $0x801071ab
80101555:	68 e0 09 11 80       	push   $0x801109e0
8010155a:	e8 31 2e 00 00       	call   80104390 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 b2 71 10 80       	push   $0x801071b2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 d4 2c 00 00       	call   80104250 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 09 11 80       	push   $0x801109c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
}
80101597:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010159a:	83 c4 10             	add    $0x10,%esp
8010159d:	c9                   	leave  
8010159e:	c3                   	ret    
8010159f:	90                   	nop

801015a0 <ialloc>:
{
801015a0:	f3 0f 1e fb          	endbr32 
801015a4:	55                   	push   %ebp
801015a5:	89 e5                	mov    %esp,%ebp
801015a7:	57                   	push   %edi
801015a8:	56                   	push   %esi
801015a9:	53                   	push   %ebx
801015aa:	83 ec 1c             	sub    $0x1c,%esp
801015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015b0:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015b7:	8b 75 08             	mov    0x8(%ebp),%esi
801015ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015bd:	0f 86 8d 00 00 00    	jbe    80101650 <ialloc+0xb0>
801015c3:	bf 01 00 00 00       	mov    $0x1,%edi
801015c8:	eb 1d                	jmp    801015e7 <ialloc+0x47>
801015ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801015d6:	53                   	push   %ebx
801015d7:	e8 14 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	3b 3d c8 09 11 80    	cmp    0x801109c8,%edi
801015e5:	73 69                	jae    80101650 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015e7:	89 f8                	mov    %edi,%eax
801015e9:	83 ec 08             	sub    $0x8,%esp
801015ec:	c1 e8 03             	shr    $0x3,%eax
801015ef:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015f5:	50                   	push   %eax
801015f6:	56                   	push   %esi
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801015fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801015ff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101601:	89 f8                	mov    %edi,%eax
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010160d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101611:	75 bd                	jne    801015d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101613:	83 ec 04             	sub    $0x4,%esp
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	6a 40                	push   $0x40
8010161b:	6a 00                	push   $0x0
8010161d:	51                   	push   %ecx
8010161e:	e8 fd 2f 00 00       	call   80104620 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 1c 24             	mov    %ebx,(%esp)
80101630:	e8 9b 18 00 00       	call   80102ed0 <log_write>
      brelse(bp);
80101635:	89 1c 24             	mov    %ebx,(%esp)
80101638:	e8 b3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010163d:	83 c4 10             	add    $0x10,%esp
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101643:	89 fa                	mov    %edi,%edx
}
80101645:	5b                   	pop    %ebx
      return iget(dev, inum);
80101646:	89 f0                	mov    %esi,%eax
}
80101648:	5e                   	pop    %esi
80101649:	5f                   	pop    %edi
8010164a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010164b:	e9 f0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 b8 71 10 80       	push   $0x801071b8
80101658:	e8 33 ed ff ff       	call   80100390 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
{
80101660:	f3 0f 1e fb          	endbr32 
80101664:	55                   	push   %ebp
80101665:	89 e5                	mov    %esp,%ebp
80101667:	56                   	push   %esi
80101668:	53                   	push   %ebx
80101669:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010166c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101672:	83 ec 08             	sub    $0x8,%esp
80101675:	c1 e8 03             	shr    $0x3,%eax
80101678:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010167e:	50                   	push   %eax
8010167f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101682:	e8 49 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101687:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010168e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101690:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010169d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016a0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016a7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016ab:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016af:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016b3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016b7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016bb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016be:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016c1:	6a 34                	push   $0x34
801016c3:	53                   	push   %ebx
801016c4:	50                   	push   %eax
801016c5:	e8 f6 2f 00 00       	call   801046c0 <memmove>
  log_write(bp);
801016ca:	89 34 24             	mov    %esi,(%esp)
801016cd:	e8 fe 17 00 00       	call   80102ed0 <log_write>
  brelse(bp);
801016d2:	89 75 08             	mov    %esi,0x8(%ebp)
801016d5:	83 c4 10             	add    $0x10,%esp
}
801016d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016db:	5b                   	pop    %ebx
801016dc:	5e                   	pop    %esi
801016dd:	5d                   	pop    %ebp
  brelse(bp);
801016de:	e9 0d eb ff ff       	jmp    801001f0 <brelse>
801016e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801016f0 <idup>:
{
801016f0:	f3 0f 1e fb          	endbr32 
801016f4:	55                   	push   %ebp
801016f5:	89 e5                	mov    %esp,%ebp
801016f7:	53                   	push   %ebx
801016f8:	83 ec 10             	sub    $0x10,%esp
801016fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016fe:	68 e0 09 11 80       	push   $0x801109e0
80101703:	e8 08 2e 00 00       	call   80104510 <acquire>
  ip->ref++;
80101708:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010170c:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101713:	e8 b8 2e 00 00       	call   801045d0 <release>
}
80101718:	89 d8                	mov    %ebx,%eax
8010171a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010171d:	c9                   	leave  
8010171e:	c3                   	ret    
8010171f:	90                   	nop

80101720 <ilock>:
{
80101720:	f3 0f 1e fb          	endbr32 
80101724:	55                   	push   %ebp
80101725:	89 e5                	mov    %esp,%ebp
80101727:	56                   	push   %esi
80101728:	53                   	push   %ebx
80101729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010172c:	85 db                	test   %ebx,%ebx
8010172e:	0f 84 b3 00 00 00    	je     801017e7 <ilock+0xc7>
80101734:	8b 53 08             	mov    0x8(%ebx),%edx
80101737:	85 d2                	test   %edx,%edx
80101739:	0f 8e a8 00 00 00    	jle    801017e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010173f:	83 ec 0c             	sub    $0xc,%esp
80101742:	8d 43 0c             	lea    0xc(%ebx),%eax
80101745:	50                   	push   %eax
80101746:	e8 45 2b 00 00       	call   80104290 <acquiresleep>
  if(ip->valid == 0){
8010174b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010174e:	83 c4 10             	add    $0x10,%esp
80101751:	85 c0                	test   %eax,%eax
80101753:	74 0b                	je     80101760 <ilock+0x40>
}
80101755:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101758:	5b                   	pop    %ebx
80101759:	5e                   	pop    %esi
8010175a:	5d                   	pop    %ebp
8010175b:	c3                   	ret    
8010175c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101760:	8b 43 04             	mov    0x4(%ebx),%eax
80101763:	83 ec 08             	sub    $0x8,%esp
80101766:	c1 e8 03             	shr    $0x3,%eax
80101769:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010176f:	50                   	push   %eax
80101770:	ff 33                	pushl  (%ebx)
80101772:	e8 59 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101777:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010177c:	8b 43 04             	mov    0x4(%ebx),%eax
8010177f:	83 e0 07             	and    $0x7,%eax
80101782:	c1 e0 06             	shl    $0x6,%eax
80101785:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101789:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010178c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010178f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101793:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101797:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010179b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010179f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b1:	6a 34                	push   $0x34
801017b3:	50                   	push   %eax
801017b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017b7:	50                   	push   %eax
801017b8:	e8 03 2f 00 00       	call   801046c0 <memmove>
    brelse(bp);
801017bd:	89 34 24             	mov    %esi,(%esp)
801017c0:	e8 2b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017c5:	83 c4 10             	add    $0x10,%esp
801017c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017d4:	0f 85 7b ff ff ff    	jne    80101755 <ilock+0x35>
      panic("ilock: no type");
801017da:	83 ec 0c             	sub    $0xc,%esp
801017dd:	68 d0 71 10 80       	push   $0x801071d0
801017e2:	e8 a9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017e7:	83 ec 0c             	sub    $0xc,%esp
801017ea:	68 ca 71 10 80       	push   $0x801071ca
801017ef:	e8 9c eb ff ff       	call   80100390 <panic>
801017f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ff:	90                   	nop

80101800 <iunlock>:
{
80101800:	f3 0f 1e fb          	endbr32 
80101804:	55                   	push   %ebp
80101805:	89 e5                	mov    %esp,%ebp
80101807:	56                   	push   %esi
80101808:	53                   	push   %ebx
80101809:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010180c:	85 db                	test   %ebx,%ebx
8010180e:	74 28                	je     80101838 <iunlock+0x38>
80101810:	83 ec 0c             	sub    $0xc,%esp
80101813:	8d 73 0c             	lea    0xc(%ebx),%esi
80101816:	56                   	push   %esi
80101817:	e8 14 2b 00 00       	call   80104330 <holdingsleep>
8010181c:	83 c4 10             	add    $0x10,%esp
8010181f:	85 c0                	test   %eax,%eax
80101821:	74 15                	je     80101838 <iunlock+0x38>
80101823:	8b 43 08             	mov    0x8(%ebx),%eax
80101826:	85 c0                	test   %eax,%eax
80101828:	7e 0e                	jle    80101838 <iunlock+0x38>
  releasesleep(&ip->lock);
8010182a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010182d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101830:	5b                   	pop    %ebx
80101831:	5e                   	pop    %esi
80101832:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101833:	e9 b8 2a 00 00       	jmp    801042f0 <releasesleep>
    panic("iunlock");
80101838:	83 ec 0c             	sub    $0xc,%esp
8010183b:	68 df 71 10 80       	push   $0x801071df
80101840:	e8 4b eb ff ff       	call   80100390 <panic>
80101845:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101850 <iput>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	57                   	push   %edi
80101858:	56                   	push   %esi
80101859:	53                   	push   %ebx
8010185a:	83 ec 28             	sub    $0x28,%esp
8010185d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101860:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101863:	57                   	push   %edi
80101864:	e8 27 2a 00 00       	call   80104290 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101869:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 d2                	test   %edx,%edx
80101871:	74 07                	je     8010187a <iput+0x2a>
80101873:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101878:	74 36                	je     801018b0 <iput+0x60>
  releasesleep(&ip->lock);
8010187a:	83 ec 0c             	sub    $0xc,%esp
8010187d:	57                   	push   %edi
8010187e:	e8 6d 2a 00 00       	call   801042f0 <releasesleep>
  acquire(&icache.lock);
80101883:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010188a:	e8 81 2c 00 00       	call   80104510 <acquire>
  ip->ref--;
8010188f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101893:	83 c4 10             	add    $0x10,%esp
80101896:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
8010189d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018a0:	5b                   	pop    %ebx
801018a1:	5e                   	pop    %esi
801018a2:	5f                   	pop    %edi
801018a3:	5d                   	pop    %ebp
  release(&icache.lock);
801018a4:	e9 27 2d 00 00       	jmp    801045d0 <release>
801018a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	68 e0 09 11 80       	push   $0x801109e0
801018b8:	e8 53 2c 00 00       	call   80104510 <acquire>
    int r = ip->ref;
801018bd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018c0:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018c7:	e8 04 2d 00 00       	call   801045d0 <release>
    if(r == 1){
801018cc:	83 c4 10             	add    $0x10,%esp
801018cf:	83 fe 01             	cmp    $0x1,%esi
801018d2:	75 a6                	jne    8010187a <iput+0x2a>
801018d4:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018da:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018dd:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018e0:	89 cf                	mov    %ecx,%edi
801018e2:	eb 0b                	jmp    801018ef <iput+0x9f>
801018e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018e8:	83 c6 04             	add    $0x4,%esi
801018eb:	39 fe                	cmp    %edi,%esi
801018ed:	74 19                	je     80101908 <iput+0xb8>
    if(ip->addrs[i]){
801018ef:	8b 16                	mov    (%esi),%edx
801018f1:	85 d2                	test   %edx,%edx
801018f3:	74 f3                	je     801018e8 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
801018f5:	8b 03                	mov    (%ebx),%eax
801018f7:	e8 b4 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
801018fc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101902:	eb e4                	jmp    801018e8 <iput+0x98>
80101904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101908:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010190e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101911:	85 c0                	test   %eax,%eax
80101913:	75 33                	jne    80101948 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101915:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101918:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010191f:	53                   	push   %ebx
80101920:	e8 3b fd ff ff       	call   80101660 <iupdate>
      ip->type = 0;
80101925:	31 c0                	xor    %eax,%eax
80101927:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010192b:	89 1c 24             	mov    %ebx,(%esp)
8010192e:	e8 2d fd ff ff       	call   80101660 <iupdate>
      ip->valid = 0;
80101933:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010193a:	83 c4 10             	add    $0x10,%esp
8010193d:	e9 38 ff ff ff       	jmp    8010187a <iput+0x2a>
80101942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101948:	83 ec 08             	sub    $0x8,%esp
8010194b:	50                   	push   %eax
8010194c:	ff 33                	pushl  (%ebx)
8010194e:	e8 7d e7 ff ff       	call   801000d0 <bread>
80101953:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101956:	83 c4 10             	add    $0x10,%esp
80101959:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010195f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101962:	8d 70 5c             	lea    0x5c(%eax),%esi
80101965:	89 cf                	mov    %ecx,%edi
80101967:	eb 0e                	jmp    80101977 <iput+0x127>
80101969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101970:	83 c6 04             	add    $0x4,%esi
80101973:	39 f7                	cmp    %esi,%edi
80101975:	74 19                	je     80101990 <iput+0x140>
      if(a[j])
80101977:	8b 16                	mov    (%esi),%edx
80101979:	85 d2                	test   %edx,%edx
8010197b:	74 f3                	je     80101970 <iput+0x120>
        bfree(ip->dev, a[j]);
8010197d:	8b 03                	mov    (%ebx),%eax
8010197f:	e8 2c f8 ff ff       	call   801011b0 <bfree>
80101984:	eb ea                	jmp    80101970 <iput+0x120>
80101986:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010198d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101990:	83 ec 0c             	sub    $0xc,%esp
80101993:	ff 75 e4             	pushl  -0x1c(%ebp)
80101996:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101999:	e8 52 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010199e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019a4:	8b 03                	mov    (%ebx),%eax
801019a6:	e8 05 f8 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019ab:	83 c4 10             	add    $0x10,%esp
801019ae:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019b5:	00 00 00 
801019b8:	e9 58 ff ff ff       	jmp    80101915 <iput+0xc5>
801019bd:	8d 76 00             	lea    0x0(%esi),%esi

801019c0 <iunlockput>:
{
801019c0:	f3 0f 1e fb          	endbr32 
801019c4:	55                   	push   %ebp
801019c5:	89 e5                	mov    %esp,%ebp
801019c7:	53                   	push   %ebx
801019c8:	83 ec 10             	sub    $0x10,%esp
801019cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ce:	53                   	push   %ebx
801019cf:	e8 2c fe ff ff       	call   80101800 <iunlock>
  iput(ip);
801019d4:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019d7:	83 c4 10             	add    $0x10,%esp
}
801019da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019dd:	c9                   	leave  
  iput(ip);
801019de:	e9 6d fe ff ff       	jmp    80101850 <iput>
801019e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801019f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019f0:	f3 0f 1e fb          	endbr32 
801019f4:	55                   	push   %ebp
801019f5:	89 e5                	mov    %esp,%ebp
801019f7:	8b 55 08             	mov    0x8(%ebp),%edx
801019fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019fd:	8b 0a                	mov    (%edx),%ecx
801019ff:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a02:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a05:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a08:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a0c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a0f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a13:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a17:	8b 52 58             	mov    0x58(%edx),%edx
80101a1a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a1d:	5d                   	pop    %ebp
80101a1e:	c3                   	ret    
80101a1f:	90                   	nop

80101a20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a20:	f3 0f 1e fb          	endbr32 
80101a24:	55                   	push   %ebp
80101a25:	89 e5                	mov    %esp,%ebp
80101a27:	57                   	push   %edi
80101a28:	56                   	push   %esi
80101a29:	53                   	push   %ebx
80101a2a:	83 ec 1c             	sub    $0x1c,%esp
80101a2d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a30:	8b 45 08             	mov    0x8(%ebp),%eax
80101a33:	8b 75 10             	mov    0x10(%ebp),%esi
80101a36:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a39:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a3c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a41:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a44:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a47:	0f 84 a3 00 00 00    	je     80101af0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a50:	8b 40 58             	mov    0x58(%eax),%eax
80101a53:	39 c6                	cmp    %eax,%esi
80101a55:	0f 87 b6 00 00 00    	ja     80101b11 <readi+0xf1>
80101a5b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a5e:	31 c9                	xor    %ecx,%ecx
80101a60:	89 da                	mov    %ebx,%edx
80101a62:	01 f2                	add    %esi,%edx
80101a64:	0f 92 c1             	setb   %cl
80101a67:	89 cf                	mov    %ecx,%edi
80101a69:	0f 82 a2 00 00 00    	jb     80101b11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a6f:	89 c1                	mov    %eax,%ecx
80101a71:	29 f1                	sub    %esi,%ecx
80101a73:	39 d0                	cmp    %edx,%eax
80101a75:	0f 43 cb             	cmovae %ebx,%ecx
80101a78:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a7b:	85 c9                	test   %ecx,%ecx
80101a7d:	74 63                	je     80101ae2 <readi+0xc2>
80101a7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a83:	89 f2                	mov    %esi,%edx
80101a85:	c1 ea 09             	shr    $0x9,%edx
80101a88:	89 d8                	mov    %ebx,%eax
80101a8a:	e8 a1 f9 ff ff       	call   80101430 <bmap>
80101a8f:	83 ec 08             	sub    $0x8,%esp
80101a92:	50                   	push   %eax
80101a93:	ff 33                	pushl  (%ebx)
80101a95:	e8 36 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101aa2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aa5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa7:	89 f0                	mov    %esi,%eax
80101aa9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aae:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101ab0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ab5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab9:	39 d9                	cmp    %ebx,%ecx
80101abb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101abe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abf:	01 df                	add    %ebx,%edi
80101ac1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ac3:	50                   	push   %eax
80101ac4:	ff 75 e0             	pushl  -0x20(%ebp)
80101ac7:	e8 f4 2b 00 00       	call   801046c0 <memmove>
    brelse(bp);
80101acc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101acf:	89 14 24             	mov    %edx,(%esp)
80101ad2:	e8 19 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101ada:	83 c4 10             	add    $0x10,%esp
80101add:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ae0:	77 9e                	ja     80101a80 <readi+0x60>
  }
  return n;
80101ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5f                   	pop    %edi
80101aeb:	5d                   	pop    %ebp
80101aec:	c3                   	ret    
80101aed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101af0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 17                	ja     80101b11 <readi+0xf1>
80101afa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 0c                	je     80101b11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0b:	5b                   	pop    %ebx
80101b0c:	5e                   	pop    %esi
80101b0d:	5f                   	pop    %edi
80101b0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b0f:	ff e0                	jmp    *%eax
      return -1;
80101b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b16:	eb cd                	jmp    80101ae5 <readi+0xc5>
80101b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b1f:	90                   	nop

80101b20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b20:	f3 0f 1e fb          	endbr32 
80101b24:	55                   	push   %ebp
80101b25:	89 e5                	mov    %esp,%ebp
80101b27:	57                   	push   %edi
80101b28:	56                   	push   %esi
80101b29:	53                   	push   %ebx
80101b2a:	83 ec 1c             	sub    $0x1c,%esp
80101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b30:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b33:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b36:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b3b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b41:	8b 75 10             	mov    0x10(%ebp),%esi
80101b44:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b47:	0f 84 b3 00 00 00    	je     80101c00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b50:	39 70 58             	cmp    %esi,0x58(%eax)
80101b53:	0f 82 e3 00 00 00    	jb     80101c3c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b59:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b5c:	89 f8                	mov    %edi,%eax
80101b5e:	01 f0                	add    %esi,%eax
80101b60:	0f 82 d6 00 00 00    	jb     80101c3c <writei+0x11c>
80101b66:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b6b:	0f 87 cb 00 00 00    	ja     80101c3c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b78:	85 ff                	test   %edi,%edi
80101b7a:	74 75                	je     80101bf1 <writei+0xd1>
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b83:	89 f2                	mov    %esi,%edx
80101b85:	c1 ea 09             	shr    $0x9,%edx
80101b88:	89 f8                	mov    %edi,%eax
80101b8a:	e8 a1 f8 ff ff       	call   80101430 <bmap>
80101b8f:	83 ec 08             	sub    $0x8,%esp
80101b92:	50                   	push   %eax
80101b93:	ff 37                	pushl  (%edi)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b9f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ba2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	89 f0                	mov    %esi,%eax
80101ba9:	83 c4 0c             	add    $0xc,%esp
80101bac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bb1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb7:	39 d9                	cmp    %ebx,%ecx
80101bb9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bbc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bbd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bbf:	ff 75 dc             	pushl  -0x24(%ebp)
80101bc2:	50                   	push   %eax
80101bc3:	e8 f8 2a 00 00       	call   801046c0 <memmove>
    log_write(bp);
80101bc8:	89 3c 24             	mov    %edi,(%esp)
80101bcb:	e8 00 13 00 00       	call   80102ed0 <log_write>
    brelse(bp);
80101bd0:	89 3c 24             	mov    %edi,(%esp)
80101bd3:	e8 18 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bdb:	83 c4 10             	add    $0x10,%esp
80101bde:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101be1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101be4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101be7:	77 97                	ja     80101b80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	3b 70 58             	cmp    0x58(%eax),%esi
80101bef:	77 37                	ja     80101c28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf7:	5b                   	pop    %ebx
80101bf8:	5e                   	pop    %esi
80101bf9:	5f                   	pop    %edi
80101bfa:	5d                   	pop    %ebp
80101bfb:	c3                   	ret    
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 32                	ja     80101c3c <writei+0x11c>
80101c0a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 27                	je     80101c3c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c1f:	ff e0                	jmp    *%eax
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c31:	50                   	push   %eax
80101c32:	e8 29 fa ff ff       	call   80101660 <iupdate>
80101c37:	83 c4 10             	add    $0x10,%esp
80101c3a:	eb b5                	jmp    80101bf1 <writei+0xd1>
      return -1;
80101c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c41:	eb b1                	jmp    80101bf4 <writei+0xd4>
80101c43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c50:	f3 0f 1e fb          	endbr32 
80101c54:	55                   	push   %ebp
80101c55:	89 e5                	mov    %esp,%ebp
80101c57:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c5a:	6a 0e                	push   $0xe
80101c5c:	ff 75 0c             	pushl  0xc(%ebp)
80101c5f:	ff 75 08             	pushl  0x8(%ebp)
80101c62:	e8 c9 2a 00 00       	call   80104730 <strncmp>
}
80101c67:	c9                   	leave  
80101c68:	c3                   	ret    
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c70:	f3 0f 1e fb          	endbr32 
80101c74:	55                   	push   %ebp
80101c75:	89 e5                	mov    %esp,%ebp
80101c77:	57                   	push   %edi
80101c78:	56                   	push   %esi
80101c79:	53                   	push   %ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
80101c7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c80:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c85:	0f 85 89 00 00 00    	jne    80101d14 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c8b:	8b 53 58             	mov    0x58(%ebx),%edx
80101c8e:	31 ff                	xor    %edi,%edi
80101c90:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c93:	85 d2                	test   %edx,%edx
80101c95:	74 42                	je     80101cd9 <dirlookup+0x69>
80101c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ca0:	6a 10                	push   $0x10
80101ca2:	57                   	push   %edi
80101ca3:	56                   	push   %esi
80101ca4:	53                   	push   %ebx
80101ca5:	e8 76 fd ff ff       	call   80101a20 <readi>
80101caa:	83 c4 10             	add    $0x10,%esp
80101cad:	83 f8 10             	cmp    $0x10,%eax
80101cb0:	75 55                	jne    80101d07 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cb2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cb7:	74 18                	je     80101cd1 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cb9:	83 ec 04             	sub    $0x4,%esp
80101cbc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cbf:	6a 0e                	push   $0xe
80101cc1:	50                   	push   %eax
80101cc2:	ff 75 0c             	pushl  0xc(%ebp)
80101cc5:	e8 66 2a 00 00       	call   80104730 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cca:	83 c4 10             	add    $0x10,%esp
80101ccd:	85 c0                	test   %eax,%eax
80101ccf:	74 17                	je     80101ce8 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cd1:	83 c7 10             	add    $0x10,%edi
80101cd4:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cd7:	72 c7                	jb     80101ca0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cdc:	31 c0                	xor    %eax,%eax
}
80101cde:	5b                   	pop    %ebx
80101cdf:	5e                   	pop    %esi
80101ce0:	5f                   	pop    %edi
80101ce1:	5d                   	pop    %ebp
80101ce2:	c3                   	ret    
80101ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ce7:	90                   	nop
      if(poff)
80101ce8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ceb:	85 c0                	test   %eax,%eax
80101ced:	74 05                	je     80101cf4 <dirlookup+0x84>
        *poff = off;
80101cef:	8b 45 10             	mov    0x10(%ebp),%eax
80101cf2:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cf4:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cf8:	8b 03                	mov    (%ebx),%eax
80101cfa:	e8 41 f6 ff ff       	call   80101340 <iget>
}
80101cff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d02:	5b                   	pop    %ebx
80101d03:	5e                   	pop    %esi
80101d04:	5f                   	pop    %edi
80101d05:	5d                   	pop    %ebp
80101d06:	c3                   	ret    
      panic("dirlookup read");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 f9 71 10 80       	push   $0x801071f9
80101d0f:	e8 7c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d14:	83 ec 0c             	sub    $0xc,%esp
80101d17:	68 e7 71 10 80       	push   $0x801071e7
80101d1c:	e8 6f e6 ff ff       	call   80100390 <panic>
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2f:	90                   	nop

80101d30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	89 c3                	mov    %eax,%ebx
80101d38:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d3b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d3e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d41:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d44:	0f 84 86 01 00 00    	je     80101ed0 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d4a:	e8 c1 1b 00 00       	call   80103910 <myproc>
  acquire(&icache.lock);
80101d4f:	83 ec 0c             	sub    $0xc,%esp
80101d52:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d54:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d57:	68 e0 09 11 80       	push   $0x801109e0
80101d5c:	e8 af 27 00 00       	call   80104510 <acquire>
  ip->ref++;
80101d61:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d65:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d6c:	e8 5f 28 00 00       	call   801045d0 <release>
80101d71:	83 c4 10             	add    $0x10,%esp
80101d74:	eb 0d                	jmp    80101d83 <namex+0x53>
80101d76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d80:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d83:	0f b6 07             	movzbl (%edi),%eax
80101d86:	3c 2f                	cmp    $0x2f,%al
80101d88:	74 f6                	je     80101d80 <namex+0x50>
  if(*path == 0)
80101d8a:	84 c0                	test   %al,%al
80101d8c:	0f 84 ee 00 00 00    	je     80101e80 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d92:	0f b6 07             	movzbl (%edi),%eax
80101d95:	84 c0                	test   %al,%al
80101d97:	0f 84 fb 00 00 00    	je     80101e98 <namex+0x168>
80101d9d:	89 fb                	mov    %edi,%ebx
80101d9f:	3c 2f                	cmp    $0x2f,%al
80101da1:	0f 84 f1 00 00 00    	je     80101e98 <namex+0x168>
80101da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dae:	66 90                	xchg   %ax,%ax
80101db0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101db4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101db7:	3c 2f                	cmp    $0x2f,%al
80101db9:	74 04                	je     80101dbf <namex+0x8f>
80101dbb:	84 c0                	test   %al,%al
80101dbd:	75 f1                	jne    80101db0 <namex+0x80>
  len = path - s;
80101dbf:	89 d8                	mov    %ebx,%eax
80101dc1:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101dc3:	83 f8 0d             	cmp    $0xd,%eax
80101dc6:	0f 8e 84 00 00 00    	jle    80101e50 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101dcc:	83 ec 04             	sub    $0x4,%esp
80101dcf:	6a 0e                	push   $0xe
80101dd1:	57                   	push   %edi
    path++;
80101dd2:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101dd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80101dd7:	e8 e4 28 00 00       	call   801046c0 <memmove>
80101ddc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ddf:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101de2:	75 0c                	jne    80101df0 <namex+0xc0>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101deb:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dee:	74 f8                	je     80101de8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101df0:	83 ec 0c             	sub    $0xc,%esp
80101df3:	56                   	push   %esi
80101df4:	e8 27 f9 ff ff       	call   80101720 <ilock>
    if(ip->type != T_DIR){
80101df9:	83 c4 10             	add    $0x10,%esp
80101dfc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e01:	0f 85 a1 00 00 00    	jne    80101ea8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e07:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e0a:	85 d2                	test   %edx,%edx
80101e0c:	74 09                	je     80101e17 <namex+0xe7>
80101e0e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e11:	0f 84 d9 00 00 00    	je     80101ef0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e17:	83 ec 04             	sub    $0x4,%esp
80101e1a:	6a 00                	push   $0x0
80101e1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e1f:	56                   	push   %esi
80101e20:	e8 4b fe ff ff       	call   80101c70 <dirlookup>
80101e25:	83 c4 10             	add    $0x10,%esp
80101e28:	89 c3                	mov    %eax,%ebx
80101e2a:	85 c0                	test   %eax,%eax
80101e2c:	74 7a                	je     80101ea8 <namex+0x178>
  iunlock(ip);
80101e2e:	83 ec 0c             	sub    $0xc,%esp
80101e31:	56                   	push   %esi
80101e32:	e8 c9 f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101e37:	89 34 24             	mov    %esi,(%esp)
80101e3a:	89 de                	mov    %ebx,%esi
80101e3c:	e8 0f fa ff ff       	call   80101850 <iput>
80101e41:	83 c4 10             	add    $0x10,%esp
80101e44:	e9 3a ff ff ff       	jmp    80101d83 <namex+0x53>
80101e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e53:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e56:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e59:	83 ec 04             	sub    $0x4,%esp
80101e5c:	50                   	push   %eax
80101e5d:	57                   	push   %edi
    name[len] = 0;
80101e5e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e60:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e63:	e8 58 28 00 00       	call   801046c0 <memmove>
    name[len] = 0;
80101e68:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6b:	83 c4 10             	add    $0x10,%esp
80101e6e:	c6 00 00             	movb   $0x0,(%eax)
80101e71:	e9 69 ff ff ff       	jmp    80101ddf <namex+0xaf>
80101e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e7d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e83:	85 c0                	test   %eax,%eax
80101e85:	0f 85 85 00 00 00    	jne    80101f10 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e8e:	89 f0                	mov    %esi,%eax
80101e90:	5b                   	pop    %ebx
80101e91:	5e                   	pop    %esi
80101e92:	5f                   	pop    %edi
80101e93:	5d                   	pop    %ebp
80101e94:	c3                   	ret    
80101e95:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e9b:	89 fb                	mov    %edi,%ebx
80101e9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ea0:	31 c0                	xor    %eax,%eax
80101ea2:	eb b5                	jmp    80101e59 <namex+0x129>
80101ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ea8:	83 ec 0c             	sub    $0xc,%esp
80101eab:	56                   	push   %esi
80101eac:	e8 4f f9 ff ff       	call   80101800 <iunlock>
  iput(ip);
80101eb1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101eb4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101eb6:	e8 95 f9 ff ff       	call   80101850 <iput>
      return 0;
80101ebb:	83 c4 10             	add    $0x10,%esp
}
80101ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec1:	89 f0                	mov    %esi,%eax
80101ec3:	5b                   	pop    %ebx
80101ec4:	5e                   	pop    %esi
80101ec5:	5f                   	pop    %edi
80101ec6:	5d                   	pop    %ebp
80101ec7:	c3                   	ret    
80101ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecf:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101ed0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ed5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eda:	89 df                	mov    %ebx,%edi
80101edc:	e8 5f f4 ff ff       	call   80101340 <iget>
80101ee1:	89 c6                	mov    %eax,%esi
80101ee3:	e9 9b fe ff ff       	jmp    80101d83 <namex+0x53>
80101ee8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eef:	90                   	nop
      iunlock(ip);
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	56                   	push   %esi
80101ef4:	e8 07 f9 ff ff       	call   80101800 <iunlock>
      return ip;
80101ef9:	83 c4 10             	add    $0x10,%esp
}
80101efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eff:	89 f0                	mov    %esi,%eax
80101f01:	5b                   	pop    %ebx
80101f02:	5e                   	pop    %esi
80101f03:	5f                   	pop    %edi
80101f04:	5d                   	pop    %ebp
80101f05:	c3                   	ret    
80101f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f10:	83 ec 0c             	sub    $0xc,%esp
80101f13:	56                   	push   %esi
    return 0;
80101f14:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f16:	e8 35 f9 ff ff       	call   80101850 <iput>
    return 0;
80101f1b:	83 c4 10             	add    $0x10,%esp
80101f1e:	e9 68 ff ff ff       	jmp    80101e8b <namex+0x15b>
80101f23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f30 <dirlink>:
{
80101f30:	f3 0f 1e fb          	endbr32 
80101f34:	55                   	push   %ebp
80101f35:	89 e5                	mov    %esp,%ebp
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
80101f3a:	83 ec 20             	sub    $0x20,%esp
80101f3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f40:	6a 00                	push   $0x0
80101f42:	ff 75 0c             	pushl  0xc(%ebp)
80101f45:	53                   	push   %ebx
80101f46:	e8 25 fd ff ff       	call   80101c70 <dirlookup>
80101f4b:	83 c4 10             	add    $0x10,%esp
80101f4e:	85 c0                	test   %eax,%eax
80101f50:	75 6b                	jne    80101fbd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f52:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f55:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f58:	85 ff                	test   %edi,%edi
80101f5a:	74 2d                	je     80101f89 <dirlink+0x59>
80101f5c:	31 ff                	xor    %edi,%edi
80101f5e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f61:	eb 0d                	jmp    80101f70 <dirlink+0x40>
80101f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f67:	90                   	nop
80101f68:	83 c7 10             	add    $0x10,%edi
80101f6b:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f6e:	73 19                	jae    80101f89 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f70:	6a 10                	push   $0x10
80101f72:	57                   	push   %edi
80101f73:	56                   	push   %esi
80101f74:	53                   	push   %ebx
80101f75:	e8 a6 fa ff ff       	call   80101a20 <readi>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	83 f8 10             	cmp    $0x10,%eax
80101f80:	75 4e                	jne    80101fd0 <dirlink+0xa0>
    if(de.inum == 0)
80101f82:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f87:	75 df                	jne    80101f68 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101f89:	83 ec 04             	sub    $0x4,%esp
80101f8c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f8f:	6a 0e                	push   $0xe
80101f91:	ff 75 0c             	pushl  0xc(%ebp)
80101f94:	50                   	push   %eax
80101f95:	e8 e6 27 00 00       	call   80104780 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f9a:	6a 10                	push   $0x10
  de.inum = inum;
80101f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f9f:	57                   	push   %edi
80101fa0:	56                   	push   %esi
80101fa1:	53                   	push   %ebx
  de.inum = inum;
80101fa2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fa6:	e8 75 fb ff ff       	call   80101b20 <writei>
80101fab:	83 c4 20             	add    $0x20,%esp
80101fae:	83 f8 10             	cmp    $0x10,%eax
80101fb1:	75 2a                	jne    80101fdd <dirlink+0xad>
  return 0;
80101fb3:	31 c0                	xor    %eax,%eax
}
80101fb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb8:	5b                   	pop    %ebx
80101fb9:	5e                   	pop    %esi
80101fba:	5f                   	pop    %edi
80101fbb:	5d                   	pop    %ebp
80101fbc:	c3                   	ret    
    iput(ip);
80101fbd:	83 ec 0c             	sub    $0xc,%esp
80101fc0:	50                   	push   %eax
80101fc1:	e8 8a f8 ff ff       	call   80101850 <iput>
    return -1;
80101fc6:	83 c4 10             	add    $0x10,%esp
80101fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fce:	eb e5                	jmp    80101fb5 <dirlink+0x85>
      panic("dirlink read");
80101fd0:	83 ec 0c             	sub    $0xc,%esp
80101fd3:	68 08 72 10 80       	push   $0x80107208
80101fd8:	e8 b3 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101fdd:	83 ec 0c             	sub    $0xc,%esp
80101fe0:	68 7e 77 10 80       	push   $0x8010777e
80101fe5:	e8 a6 e3 ff ff       	call   80100390 <panic>
80101fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ff0 <namei>:

struct inode*
namei(char *path)
{
80101ff0:	f3 0f 1e fb          	endbr32 
80101ff4:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ff5:	31 d2                	xor    %edx,%edx
{
80101ff7:	89 e5                	mov    %esp,%ebp
80101ff9:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ffc:	8b 45 08             	mov    0x8(%ebp),%eax
80101fff:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102002:	e8 29 fd ff ff       	call   80101d30 <namex>
}
80102007:	c9                   	leave  
80102008:	c3                   	ret    
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102010 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102010:	f3 0f 1e fb          	endbr32 
80102014:	55                   	push   %ebp
  return namex(path, 1, name);
80102015:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010201a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010201c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010201f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102022:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102023:	e9 08 fd ff ff       	jmp    80101d30 <namex>
80102028:	66 90                	xchg   %ax,%ax
8010202a:	66 90                	xchg   %ax,%ax
8010202c:	66 90                	xchg   %ax,%ax
8010202e:	66 90                	xchg   %ax,%ax

80102030 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102039:	85 c0                	test   %eax,%eax
8010203b:	0f 84 b4 00 00 00    	je     801020f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102041:	8b 70 08             	mov    0x8(%eax),%esi
80102044:	89 c3                	mov    %eax,%ebx
80102046:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010204c:	0f 87 96 00 00 00    	ja     801020e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102052:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010205e:	66 90                	xchg   %ax,%ax
80102060:	89 ca                	mov    %ecx,%edx
80102062:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102063:	83 e0 c0             	and    $0xffffffc0,%eax
80102066:	3c 40                	cmp    $0x40,%al
80102068:	75 f6                	jne    80102060 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010206a:	31 ff                	xor    %edi,%edi
8010206c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102071:	89 f8                	mov    %edi,%eax
80102073:	ee                   	out    %al,(%dx)
80102074:	b8 01 00 00 00       	mov    $0x1,%eax
80102079:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010207e:	ee                   	out    %al,(%dx)
8010207f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102084:	89 f0                	mov    %esi,%eax
80102086:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102087:	89 f0                	mov    %esi,%eax
80102089:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010208e:	c1 f8 08             	sar    $0x8,%eax
80102091:	ee                   	out    %al,(%dx)
80102092:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102097:	89 f8                	mov    %edi,%eax
80102099:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010209a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010209e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a3:	c1 e0 04             	shl    $0x4,%eax
801020a6:	83 e0 10             	and    $0x10,%eax
801020a9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ad:	f6 03 04             	testb  $0x4,(%ebx)
801020b0:	75 16                	jne    801020c8 <idestart+0x98>
801020b2:	b8 20 00 00 00       	mov    $0x20,%eax
801020b7:	89 ca                	mov    %ecx,%edx
801020b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020bd:	5b                   	pop    %ebx
801020be:	5e                   	pop    %esi
801020bf:	5f                   	pop    %edi
801020c0:	5d                   	pop    %ebp
801020c1:	c3                   	ret    
801020c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801020c8:	b8 30 00 00 00       	mov    $0x30,%eax
801020cd:	89 ca                	mov    %ecx,%edx
801020cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801020d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801020d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801020d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020dd:	fc                   	cld    
801020de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e3:	5b                   	pop    %ebx
801020e4:	5e                   	pop    %esi
801020e5:	5f                   	pop    %edi
801020e6:	5d                   	pop    %ebp
801020e7:	c3                   	ret    
    panic("incorrect blockno");
801020e8:	83 ec 0c             	sub    $0xc,%esp
801020eb:	68 1e 72 10 80       	push   $0x8010721e
801020f0:	e8 9b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020f5:	83 ec 0c             	sub    $0xc,%esp
801020f8:	68 15 72 10 80       	push   $0x80107215
801020fd:	e8 8e e2 ff ff       	call   80100390 <panic>
80102102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102110 <ideinit>:
{
80102110:	f3 0f 1e fb          	endbr32 
80102114:	55                   	push   %ebp
80102115:	89 e5                	mov    %esp,%ebp
80102117:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010211a:	68 30 72 10 80       	push   $0x80107230
8010211f:	68 80 a5 10 80       	push   $0x8010a580
80102124:	e8 67 22 00 00       	call   80104390 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102129:	58                   	pop    %eax
8010212a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010212f:	5a                   	pop    %edx
80102130:	83 e8 01             	sub    $0x1,%eax
80102133:	50                   	push   %eax
80102134:	6a 0e                	push   $0xe
80102136:	e8 b5 02 00 00       	call   801023f0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010213b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010213e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102143:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102147:	90                   	nop
80102148:	ec                   	in     (%dx),%al
80102149:	83 e0 c0             	and    $0xffffffc0,%eax
8010214c:	3c 40                	cmp    $0x40,%al
8010214e:	75 f8                	jne    80102148 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102150:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102155:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010215a:	ee                   	out    %al,(%dx)
8010215b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102160:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102165:	eb 0e                	jmp    80102175 <ideinit+0x65>
80102167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102170:	83 e9 01             	sub    $0x1,%ecx
80102173:	74 0f                	je     80102184 <ideinit+0x74>
80102175:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102176:	84 c0                	test   %al,%al
80102178:	74 f6                	je     80102170 <ideinit+0x60>
      havedisk1 = 1;
8010217a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102181:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102184:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102189:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010218e:	ee                   	out    %al,(%dx)
}
8010218f:	c9                   	leave  
80102190:	c3                   	ret    
80102191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219f:	90                   	nop

801021a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021a0:	f3 0f 1e fb          	endbr32 
801021a4:	55                   	push   %ebp
801021a5:	89 e5                	mov    %esp,%ebp
801021a7:	57                   	push   %edi
801021a8:	56                   	push   %esi
801021a9:	53                   	push   %ebx
801021aa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ad:	68 80 a5 10 80       	push   $0x8010a580
801021b2:	e8 59 23 00 00       	call   80104510 <acquire>

  if((b = idequeue) == 0){
801021b7:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801021bd:	83 c4 10             	add    $0x10,%esp
801021c0:	85 db                	test   %ebx,%ebx
801021c2:	74 5f                	je     80102223 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801021c4:	8b 43 58             	mov    0x58(%ebx),%eax
801021c7:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801021cc:	8b 33                	mov    (%ebx),%esi
801021ce:	f7 c6 04 00 00 00    	test   $0x4,%esi
801021d4:	75 2b                	jne    80102201 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021d6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop
801021e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e1:	89 c1                	mov    %eax,%ecx
801021e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801021e6:	80 f9 40             	cmp    $0x40,%cl
801021e9:	75 f5                	jne    801021e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021eb:	a8 21                	test   $0x21,%al
801021ed:	75 12                	jne    80102201 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801021ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021fc:	fc                   	cld    
801021fd:	f3 6d                	rep insl (%dx),%es:(%edi)
801021ff:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102201:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102204:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102207:	83 ce 02             	or     $0x2,%esi
8010220a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010220c:	53                   	push   %ebx
8010220d:	e8 7e 1e 00 00       	call   80104090 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102212:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102217:	83 c4 10             	add    $0x10,%esp
8010221a:	85 c0                	test   %eax,%eax
8010221c:	74 05                	je     80102223 <ideintr+0x83>
    idestart(idequeue);
8010221e:	e8 0d fe ff ff       	call   80102030 <idestart>
    release(&idelock);
80102223:	83 ec 0c             	sub    $0xc,%esp
80102226:	68 80 a5 10 80       	push   $0x8010a580
8010222b:	e8 a0 23 00 00       	call   801045d0 <release>

  release(&idelock);
}
80102230:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102233:	5b                   	pop    %ebx
80102234:	5e                   	pop    %esi
80102235:	5f                   	pop    %edi
80102236:	5d                   	pop    %ebp
80102237:	c3                   	ret    
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102240:	f3 0f 1e fb          	endbr32 
80102244:	55                   	push   %ebp
80102245:	89 e5                	mov    %esp,%ebp
80102247:	53                   	push   %ebx
80102248:	83 ec 10             	sub    $0x10,%esp
8010224b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010224e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102251:	50                   	push   %eax
80102252:	e8 d9 20 00 00       	call   80104330 <holdingsleep>
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	0f 84 cf 00 00 00    	je     80102331 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102262:	8b 03                	mov    (%ebx),%eax
80102264:	83 e0 06             	and    $0x6,%eax
80102267:	83 f8 02             	cmp    $0x2,%eax
8010226a:	0f 84 b4 00 00 00    	je     80102324 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102270:	8b 53 04             	mov    0x4(%ebx),%edx
80102273:	85 d2                	test   %edx,%edx
80102275:	74 0d                	je     80102284 <iderw+0x44>
80102277:	a1 60 a5 10 80       	mov    0x8010a560,%eax
8010227c:	85 c0                	test   %eax,%eax
8010227e:	0f 84 93 00 00 00    	je     80102317 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102284:	83 ec 0c             	sub    $0xc,%esp
80102287:	68 80 a5 10 80       	push   $0x8010a580
8010228c:	e8 7f 22 00 00       	call   80104510 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102291:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102296:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010229d:	83 c4 10             	add    $0x10,%esp
801022a0:	85 c0                	test   %eax,%eax
801022a2:	74 6c                	je     80102310 <iderw+0xd0>
801022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022a8:	89 c2                	mov    %eax,%edx
801022aa:	8b 40 58             	mov    0x58(%eax),%eax
801022ad:	85 c0                	test   %eax,%eax
801022af:	75 f7                	jne    801022a8 <iderw+0x68>
801022b1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022b4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022b6:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801022bc:	74 42                	je     80102300 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022be:	8b 03                	mov    (%ebx),%eax
801022c0:	83 e0 06             	and    $0x6,%eax
801022c3:	83 f8 02             	cmp    $0x2,%eax
801022c6:	74 23                	je     801022eb <iderw+0xab>
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop
    sleep(b, &idelock);
801022d0:	83 ec 08             	sub    $0x8,%esp
801022d3:	68 80 a5 10 80       	push   $0x8010a580
801022d8:	53                   	push   %ebx
801022d9:	e8 f2 1b 00 00       	call   80103ed0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022de:	8b 03                	mov    (%ebx),%eax
801022e0:	83 c4 10             	add    $0x10,%esp
801022e3:	83 e0 06             	and    $0x6,%eax
801022e6:	83 f8 02             	cmp    $0x2,%eax
801022e9:	75 e5                	jne    801022d0 <iderw+0x90>
  }


  release(&idelock);
801022eb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022f5:	c9                   	leave  
  release(&idelock);
801022f6:	e9 d5 22 00 00       	jmp    801045d0 <release>
801022fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022ff:	90                   	nop
    idestart(b);
80102300:	89 d8                	mov    %ebx,%eax
80102302:	e8 29 fd ff ff       	call   80102030 <idestart>
80102307:	eb b5                	jmp    801022be <iderw+0x7e>
80102309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102310:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102315:	eb 9d                	jmp    801022b4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102317:	83 ec 0c             	sub    $0xc,%esp
8010231a:	68 5f 72 10 80       	push   $0x8010725f
8010231f:	e8 6c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102324:	83 ec 0c             	sub    $0xc,%esp
80102327:	68 4a 72 10 80       	push   $0x8010724a
8010232c:	e8 5f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102331:	83 ec 0c             	sub    $0xc,%esp
80102334:	68 34 72 10 80       	push   $0x80107234
80102339:	e8 52 e0 ff ff       	call   80100390 <panic>
8010233e:	66 90                	xchg   %ax,%ax

80102340 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102340:	f3 0f 1e fb          	endbr32 
80102344:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102345:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010234c:	00 c0 fe 
{
8010234f:	89 e5                	mov    %esp,%ebp
80102351:	56                   	push   %esi
80102352:	53                   	push   %ebx
  ioapic->reg = reg;
80102353:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010235a:	00 00 00 
  return ioapic->data;
8010235d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102363:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102366:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010236c:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102372:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102379:	c1 ee 10             	shr    $0x10,%esi
8010237c:	89 f0                	mov    %esi,%eax
8010237e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102381:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102384:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102387:	39 c2                	cmp    %eax,%edx
80102389:	74 16                	je     801023a1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010238b:	83 ec 0c             	sub    $0xc,%esp
8010238e:	68 80 72 10 80       	push   $0x80107280
80102393:	e8 18 e3 ff ff       	call   801006b0 <cprintf>
80102398:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010239e:	83 c4 10             	add    $0x10,%esp
801023a1:	83 c6 21             	add    $0x21,%esi
{
801023a4:	ba 10 00 00 00       	mov    $0x10,%edx
801023a9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ae:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023b0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023b2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023b4:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023ba:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023bd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
801023c3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
801023c6:	8d 5a 01             	lea    0x1(%edx),%ebx
801023c9:	83 c2 02             	add    $0x2,%edx
801023cc:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
801023ce:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801023d4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801023db:	39 f0                	cmp    %esi,%eax
801023dd:	75 d1                	jne    801023b0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801023df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023e2:	5b                   	pop    %ebx
801023e3:	5e                   	pop    %esi
801023e4:	5d                   	pop    %ebp
801023e5:	c3                   	ret    
801023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ed:	8d 76 00             	lea    0x0(%esi),%esi

801023f0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023f0:	f3 0f 1e fb          	endbr32 
801023f4:	55                   	push   %ebp
  ioapic->reg = reg;
801023f5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102400:	8d 50 20             	lea    0x20(%eax),%edx
80102403:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102407:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102409:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010240f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102412:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102415:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102418:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010241a:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010241f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102422:	89 50 10             	mov    %edx,0x10(%eax)
}
80102425:	5d                   	pop    %ebp
80102426:	c3                   	ret    
80102427:	66 90                	xchg   %ax,%ax
80102429:	66 90                	xchg   %ax,%ax
8010242b:	66 90                	xchg   %ax,%ax
8010242d:	66 90                	xchg   %ax,%ax
8010242f:	90                   	nop

80102430 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
80102435:	89 e5                	mov    %esp,%ebp
80102437:	53                   	push   %ebx
80102438:	83 ec 04             	sub    $0x4,%esp
8010243b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010243e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102444:	75 7a                	jne    801024c0 <kfree+0x90>
80102446:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
8010244c:	72 72                	jb     801024c0 <kfree+0x90>
8010244e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102454:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102459:	77 65                	ja     801024c0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010245b:	83 ec 04             	sub    $0x4,%esp
8010245e:	68 00 10 00 00       	push   $0x1000
80102463:	6a 01                	push   $0x1
80102465:	53                   	push   %ebx
80102466:	e8 b5 21 00 00       	call   80104620 <memset>

  if(kmem.use_lock)
8010246b:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102471:	83 c4 10             	add    $0x10,%esp
80102474:	85 d2                	test   %edx,%edx
80102476:	75 20                	jne    80102498 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102478:	a1 78 26 11 80       	mov    0x80112678,%eax
8010247d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010247f:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102484:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010248a:	85 c0                	test   %eax,%eax
8010248c:	75 22                	jne    801024b0 <kfree+0x80>
    release(&kmem.lock);
}
8010248e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102491:	c9                   	leave  
80102492:	c3                   	ret    
80102493:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102497:	90                   	nop
    acquire(&kmem.lock);
80102498:	83 ec 0c             	sub    $0xc,%esp
8010249b:	68 40 26 11 80       	push   $0x80112640
801024a0:	e8 6b 20 00 00       	call   80104510 <acquire>
801024a5:	83 c4 10             	add    $0x10,%esp
801024a8:	eb ce                	jmp    80102478 <kfree+0x48>
801024aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024b0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801024b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ba:	c9                   	leave  
    release(&kmem.lock);
801024bb:	e9 10 21 00 00       	jmp    801045d0 <release>
    panic("kfree");
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	68 b2 72 10 80       	push   $0x801072b2
801024c8:	e8 c3 de ff ff       	call   80100390 <panic>
801024cd:	8d 76 00             	lea    0x0(%esi),%esi

801024d0 <freerange>:
{
801024d0:	f3 0f 1e fb          	endbr32 
801024d4:	55                   	push   %ebp
801024d5:	89 e5                	mov    %esp,%ebp
801024d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801024d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024db:	8b 75 0c             	mov    0xc(%ebp),%esi
801024de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024f1:	39 de                	cmp    %ebx,%esi
801024f3:	72 1f                	jb     80102514 <freerange+0x44>
801024f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801024f8:	83 ec 0c             	sub    $0xc,%esp
801024fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102501:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102507:	50                   	push   %eax
80102508:	e8 23 ff ff ff       	call   80102430 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	39 f3                	cmp    %esi,%ebx
80102512:	76 e4                	jbe    801024f8 <freerange+0x28>
}
80102514:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102517:	5b                   	pop    %ebx
80102518:	5e                   	pop    %esi
80102519:	5d                   	pop    %ebp
8010251a:	c3                   	ret    
8010251b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010251f:	90                   	nop

80102520 <kinit1>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
80102528:	53                   	push   %ebx
80102529:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010252c:	83 ec 08             	sub    $0x8,%esp
8010252f:	68 b8 72 10 80       	push   $0x801072b8
80102534:	68 40 26 11 80       	push   $0x80112640
80102539:	e8 52 1e 00 00       	call   80104390 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010253e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102544:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
8010254b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010254e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102554:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102560:	39 de                	cmp    %ebx,%esi
80102562:	72 20                	jb     80102584 <kinit1+0x64>
80102564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 b3 fe ff ff       	call   80102430 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <kinit1+0x48>
}
80102584:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102587:	5b                   	pop    %ebx
80102588:	5e                   	pop    %esi
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010258f:	90                   	nop

80102590 <kinit2>:
{
80102590:	f3 0f 1e fb          	endbr32 
80102594:	55                   	push   %ebp
80102595:	89 e5                	mov    %esp,%ebp
80102597:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102598:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010259b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010259e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010259f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b1:	39 de                	cmp    %ebx,%esi
801025b3:	72 1f                	jb     801025d4 <kinit2+0x44>
801025b5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 63 fe ff ff       	call   80102430 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit2+0x28>
  kmem.use_lock = 1;
801025d4:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801025db:	00 00 00 
}
801025de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e1:	5b                   	pop    %ebx
801025e2:	5e                   	pop    %esi
801025e3:	5d                   	pop    %ebp
801025e4:	c3                   	ret    
801025e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025f0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025f0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
801025f4:	a1 74 26 11 80       	mov    0x80112674,%eax
801025f9:	85 c0                	test   %eax,%eax
801025fb:	75 1b                	jne    80102618 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025fd:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102602:	85 c0                	test   %eax,%eax
80102604:	74 0a                	je     80102610 <kalloc+0x20>
    kmem.freelist = r->next;
80102606:	8b 10                	mov    (%eax),%edx
80102608:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
8010260e:	c3                   	ret    
8010260f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102610:	c3                   	ret    
80102611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102618:	55                   	push   %ebp
80102619:	89 e5                	mov    %esp,%ebp
8010261b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010261e:	68 40 26 11 80       	push   $0x80112640
80102623:	e8 e8 1e 00 00       	call   80104510 <acquire>
  r = kmem.freelist;
80102628:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010262d:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102633:	83 c4 10             	add    $0x10,%esp
80102636:	85 c0                	test   %eax,%eax
80102638:	74 08                	je     80102642 <kalloc+0x52>
    kmem.freelist = r->next;
8010263a:	8b 08                	mov    (%eax),%ecx
8010263c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102642:	85 d2                	test   %edx,%edx
80102644:	74 16                	je     8010265c <kalloc+0x6c>
    release(&kmem.lock);
80102646:	83 ec 0c             	sub    $0xc,%esp
80102649:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010264c:	68 40 26 11 80       	push   $0x80112640
80102651:	e8 7a 1f 00 00       	call   801045d0 <release>
  return (char*)r;
80102656:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102659:	83 c4 10             	add    $0x10,%esp
}
8010265c:	c9                   	leave  
8010265d:	c3                   	ret    
8010265e:	66 90                	xchg   %ax,%ax

80102660 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102660:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102664:	ba 64 00 00 00       	mov    $0x64,%edx
80102669:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010266a:	a8 01                	test   $0x1,%al
8010266c:	0f 84 be 00 00 00    	je     80102730 <kbdgetc+0xd0>
{
80102672:	55                   	push   %ebp
80102673:	ba 60 00 00 00       	mov    $0x60,%edx
80102678:	89 e5                	mov    %esp,%ebp
8010267a:	53                   	push   %ebx
8010267b:	ec                   	in     (%dx),%al
  return data;
8010267c:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102682:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102685:	3c e0                	cmp    $0xe0,%al
80102687:	74 57                	je     801026e0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102689:	89 d9                	mov    %ebx,%ecx
8010268b:	83 e1 40             	and    $0x40,%ecx
8010268e:	84 c0                	test   %al,%al
80102690:	78 5e                	js     801026f0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102692:	85 c9                	test   %ecx,%ecx
80102694:	74 09                	je     8010269f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102696:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102699:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010269c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010269f:	0f b6 8a e0 73 10 80 	movzbl -0x7fef8c20(%edx),%ecx
  shift ^= togglecode[data];
801026a6:	0f b6 82 e0 72 10 80 	movzbl -0x7fef8d20(%edx),%eax
  shift |= shiftcode[data];
801026ad:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026af:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026b1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026b3:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026b9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026bc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026bf:	8b 04 85 c0 72 10 80 	mov    -0x7fef8d40(,%eax,4),%eax
801026c6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801026ca:	74 0b                	je     801026d7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801026cc:	8d 50 9f             	lea    -0x61(%eax),%edx
801026cf:	83 fa 19             	cmp    $0x19,%edx
801026d2:	77 44                	ja     80102718 <kbdgetc+0xb8>
      c += 'A' - 'a';
801026d4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026d7:	5b                   	pop    %ebx
801026d8:	5d                   	pop    %ebp
801026d9:	c3                   	ret    
801026da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026e0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026e3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026e5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026eb:	5b                   	pop    %ebx
801026ec:	5d                   	pop    %ebp
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026f0:	83 e0 7f             	and    $0x7f,%eax
801026f3:	85 c9                	test   %ecx,%ecx
801026f5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026f8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026fa:	0f b6 8a e0 73 10 80 	movzbl -0x7fef8c20(%edx),%ecx
80102701:	83 c9 40             	or     $0x40,%ecx
80102704:	0f b6 c9             	movzbl %cl,%ecx
80102707:	f7 d1                	not    %ecx
80102709:	21 d9                	and    %ebx,%ecx
}
8010270b:	5b                   	pop    %ebx
8010270c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010270d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102713:	c3                   	ret    
80102714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102718:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010271b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010271e:	5b                   	pop    %ebx
8010271f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102720:	83 f9 1a             	cmp    $0x1a,%ecx
80102723:	0f 42 c2             	cmovb  %edx,%eax
}
80102726:	c3                   	ret    
80102727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272e:	66 90                	xchg   %ax,%ax
    return -1;
80102730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102735:	c3                   	ret    
80102736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010273d:	8d 76 00             	lea    0x0(%esi),%esi

80102740 <kbdintr>:

void
kbdintr(void)
{
80102740:	f3 0f 1e fb          	endbr32 
80102744:	55                   	push   %ebp
80102745:	89 e5                	mov    %esp,%ebp
80102747:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010274a:	68 60 26 10 80       	push   $0x80102660
8010274f:	e8 0c e1 ff ff       	call   80100860 <consoleintr>
}
80102754:	83 c4 10             	add    $0x10,%esp
80102757:	c9                   	leave  
80102758:	c3                   	ret    
80102759:	66 90                	xchg   %ax,%ax
8010275b:	66 90                	xchg   %ax,%ax
8010275d:	66 90                	xchg   %ax,%ax
8010275f:	90                   	nop

80102760 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102760:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102764:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102769:	85 c0                	test   %eax,%eax
8010276b:	0f 84 c7 00 00 00    	je     80102838 <lapicinit+0xd8>
  lapic[index] = value;
80102771:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102778:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102785:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102788:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010278b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102792:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102795:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102798:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010279f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027a2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ac:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027af:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027b9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027bc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027bf:	8b 50 30             	mov    0x30(%eax),%edx
801027c2:	c1 ea 10             	shr    $0x10,%edx
801027c5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801027cb:	75 73                	jne    80102840 <lapicinit+0xe0>
  lapic[index] = value;
801027cd:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801027d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027da:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027e1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027e4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027ee:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027fb:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102801:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102808:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102815:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102818:	8b 50 20             	mov    0x20(%eax),%edx
8010281b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102820:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102826:	80 e6 10             	and    $0x10,%dh
80102829:	75 f5                	jne    80102820 <lapicinit+0xc0>
  lapic[index] = value;
8010282b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102832:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102838:	c3                   	ret    
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102840:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102847:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010284d:	e9 7b ff ff ff       	jmp    801027cd <lapicinit+0x6d>
80102852:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102860 <lapicid>:

int
lapicid(void)
{
80102860:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102864:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102869:	85 c0                	test   %eax,%eax
8010286b:	74 0b                	je     80102878 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010286d:	8b 40 20             	mov    0x20(%eax),%eax
80102870:	c1 e8 18             	shr    $0x18,%eax
80102873:	c3                   	ret    
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102878:	31 c0                	xor    %eax,%eax
}
8010287a:	c3                   	ret    
8010287b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop

80102880 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102880:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102884:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102889:	85 c0                	test   %eax,%eax
8010288b:	74 0d                	je     8010289a <lapiceoi+0x1a>
  lapic[index] = value;
8010288d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102894:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010289a:	c3                   	ret    
8010289b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010289f:	90                   	nop

801028a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028a0:	f3 0f 1e fb          	endbr32 
}
801028a4:	c3                   	ret    
801028a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028b0:	f3 0f 1e fb          	endbr32 
801028b4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028ba:	ba 70 00 00 00       	mov    $0x70,%edx
801028bf:	89 e5                	mov    %esp,%ebp
801028c1:	53                   	push   %ebx
801028c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028c8:	ee                   	out    %al,(%dx)
801028c9:	b8 0a 00 00 00       	mov    $0xa,%eax
801028ce:	ba 71 00 00 00       	mov    $0x71,%edx
801028d3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028d4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801028d6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801028d9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028df:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028e1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028e4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028e6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028e9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028ec:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028f2:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028f7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028fd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102900:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102907:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010290a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010290d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102914:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010291a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102920:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102923:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102929:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010292c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102932:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102935:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010293b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010293c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010293f:	5d                   	pop    %ebp
80102940:	c3                   	ret    
80102941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102948:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294f:	90                   	nop

80102950 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
80102955:	b8 0b 00 00 00       	mov    $0xb,%eax
8010295a:	ba 70 00 00 00       	mov    $0x70,%edx
8010295f:	89 e5                	mov    %esp,%ebp
80102961:	57                   	push   %edi
80102962:	56                   	push   %esi
80102963:	53                   	push   %ebx
80102964:	83 ec 4c             	sub    $0x4c,%esp
80102967:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102968:	ba 71 00 00 00       	mov    $0x71,%edx
8010296d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010296e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102971:	bb 70 00 00 00       	mov    $0x70,%ebx
80102976:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102980:	31 c0                	xor    %eax,%eax
80102982:	89 da                	mov    %ebx,%edx
80102984:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102985:	b9 71 00 00 00       	mov    $0x71,%ecx
8010298a:	89 ca                	mov    %ecx,%edx
8010298c:	ec                   	in     (%dx),%al
8010298d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102990:	89 da                	mov    %ebx,%edx
80102992:	b8 02 00 00 00       	mov    $0x2,%eax
80102997:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102998:	89 ca                	mov    %ecx,%edx
8010299a:	ec                   	in     (%dx),%al
8010299b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010299e:	89 da                	mov    %ebx,%edx
801029a0:	b8 04 00 00 00       	mov    $0x4,%eax
801029a5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a6:	89 ca                	mov    %ecx,%edx
801029a8:	ec                   	in     (%dx),%al
801029a9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ac:	89 da                	mov    %ebx,%edx
801029ae:	b8 07 00 00 00       	mov    $0x7,%eax
801029b3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b4:	89 ca                	mov    %ecx,%edx
801029b6:	ec                   	in     (%dx),%al
801029b7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ba:	89 da                	mov    %ebx,%edx
801029bc:	b8 08 00 00 00       	mov    $0x8,%eax
801029c1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c2:	89 ca                	mov    %ecx,%edx
801029c4:	ec                   	in     (%dx),%al
801029c5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c7:	89 da                	mov    %ebx,%edx
801029c9:	b8 09 00 00 00       	mov    $0x9,%eax
801029ce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cf:	89 ca                	mov    %ecx,%edx
801029d1:	ec                   	in     (%dx),%al
801029d2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d4:	89 da                	mov    %ebx,%edx
801029d6:	b8 0a 00 00 00       	mov    $0xa,%eax
801029db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029dc:	89 ca                	mov    %ecx,%edx
801029de:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029df:	84 c0                	test   %al,%al
801029e1:	78 9d                	js     80102980 <cmostime+0x30>
  return inb(CMOS_RETURN);
801029e3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801029e7:	89 fa                	mov    %edi,%edx
801029e9:	0f b6 fa             	movzbl %dl,%edi
801029ec:	89 f2                	mov    %esi,%edx
801029ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
801029f1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801029f5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f8:	89 da                	mov    %ebx,%edx
801029fa:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029fd:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a00:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a04:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a07:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a0a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a0e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a11:	31 c0                	xor    %eax,%eax
80102a13:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a14:	89 ca                	mov    %ecx,%edx
80102a16:	ec                   	in     (%dx),%al
80102a17:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a1a:	89 da                	mov    %ebx,%edx
80102a1c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a1f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a25:	89 ca                	mov    %ecx,%edx
80102a27:	ec                   	in     (%dx),%al
80102a28:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2b:	89 da                	mov    %ebx,%edx
80102a2d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a30:	b8 04 00 00 00       	mov    $0x4,%eax
80102a35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a36:	89 ca                	mov    %ecx,%edx
80102a38:	ec                   	in     (%dx),%al
80102a39:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3c:	89 da                	mov    %ebx,%edx
80102a3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a41:	b8 07 00 00 00       	mov    $0x7,%eax
80102a46:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a47:	89 ca                	mov    %ecx,%edx
80102a49:	ec                   	in     (%dx),%al
80102a4a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4d:	89 da                	mov    %ebx,%edx
80102a4f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a52:	b8 08 00 00 00       	mov    $0x8,%eax
80102a57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a58:	89 ca                	mov    %ecx,%edx
80102a5a:	ec                   	in     (%dx),%al
80102a5b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5e:	89 da                	mov    %ebx,%edx
80102a60:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a63:	b8 09 00 00 00       	mov    $0x9,%eax
80102a68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a69:	89 ca                	mov    %ecx,%edx
80102a6b:	ec                   	in     (%dx),%al
80102a6c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a6f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a75:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a78:	6a 18                	push   $0x18
80102a7a:	50                   	push   %eax
80102a7b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a7e:	50                   	push   %eax
80102a7f:	e8 ec 1b 00 00       	call   80104670 <memcmp>
80102a84:	83 c4 10             	add    $0x10,%esp
80102a87:	85 c0                	test   %eax,%eax
80102a89:	0f 85 f1 fe ff ff    	jne    80102980 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102a8f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a93:	75 78                	jne    80102b0d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a95:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a98:	89 c2                	mov    %eax,%edx
80102a9a:	83 e0 0f             	and    $0xf,%eax
80102a9d:	c1 ea 04             	shr    $0x4,%edx
80102aa0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aa3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aa6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102aa9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aac:	89 c2                	mov    %eax,%edx
80102aae:	83 e0 0f             	and    $0xf,%eax
80102ab1:	c1 ea 04             	shr    $0x4,%edx
80102ab4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ab7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aba:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102abd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ac0:	89 c2                	mov    %eax,%edx
80102ac2:	83 e0 0f             	and    $0xf,%eax
80102ac5:	c1 ea 04             	shr    $0x4,%edx
80102ac8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102acb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ace:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102ad1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ad4:	89 c2                	mov    %eax,%edx
80102ad6:	83 e0 0f             	and    $0xf,%eax
80102ad9:	c1 ea 04             	shr    $0x4,%edx
80102adc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102ae5:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102af9:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b0d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b10:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b13:	89 06                	mov    %eax,(%esi)
80102b15:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b18:	89 46 04             	mov    %eax,0x4(%esi)
80102b1b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b1e:	89 46 08             	mov    %eax,0x8(%esi)
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 46 0c             	mov    %eax,0xc(%esi)
80102b27:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b2a:	89 46 10             	mov    %eax,0x10(%esi)
80102b2d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b30:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b33:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b3d:	5b                   	pop    %ebx
80102b3e:	5e                   	pop    %esi
80102b3f:	5f                   	pop    %edi
80102b40:	5d                   	pop    %ebp
80102b41:	c3                   	ret    
80102b42:	66 90                	xchg   %ax,%ax
80102b44:	66 90                	xchg   %ax,%ax
80102b46:	66 90                	xchg   %ax,%ax
80102b48:	66 90                	xchg   %ax,%ax
80102b4a:	66 90                	xchg   %ax,%ax
80102b4c:	66 90                	xchg   %ax,%ax
80102b4e:	66 90                	xchg   %ax,%ax

80102b50 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b50:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102b56:	85 c9                	test   %ecx,%ecx
80102b58:	0f 8e 8a 00 00 00    	jle    80102be8 <install_trans+0x98>
{
80102b5e:	55                   	push   %ebp
80102b5f:	89 e5                	mov    %esp,%ebp
80102b61:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102b62:	31 ff                	xor    %edi,%edi
{
80102b64:	56                   	push   %esi
80102b65:	53                   	push   %ebx
80102b66:	83 ec 0c             	sub    $0xc,%esp
80102b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b70:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b75:	83 ec 08             	sub    $0x8,%esp
80102b78:	01 f8                	add    %edi,%eax
80102b7a:	83 c0 01             	add    $0x1,%eax
80102b7d:	50                   	push   %eax
80102b7e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b84:	e8 47 d5 ff ff       	call   801000d0 <bread>
80102b89:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b8b:	58                   	pop    %eax
80102b8c:	5a                   	pop    %edx
80102b8d:	ff 34 bd cc 26 11 80 	pushl  -0x7feed934(,%edi,4)
80102b94:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b9a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b9d:	e8 2e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ba2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ba5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ba7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102baa:	68 00 02 00 00       	push   $0x200
80102baf:	50                   	push   %eax
80102bb0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bb3:	50                   	push   %eax
80102bb4:	e8 07 1b 00 00       	call   801046c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bb9:	89 1c 24             	mov    %ebx,(%esp)
80102bbc:	e8 ef d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102bc1:	89 34 24             	mov    %esi,(%esp)
80102bc4:	e8 27 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102bc9:	89 1c 24             	mov    %ebx,(%esp)
80102bcc:	e8 1f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102bd1:	83 c4 10             	add    $0x10,%esp
80102bd4:	39 3d c8 26 11 80    	cmp    %edi,0x801126c8
80102bda:	7f 94                	jg     80102b70 <install_trans+0x20>
  }
}
80102bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdf:	5b                   	pop    %ebx
80102be0:	5e                   	pop    %esi
80102be1:	5f                   	pop    %edi
80102be2:	5d                   	pop    %ebp
80102be3:	c3                   	ret    
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102be8:	c3                   	ret    
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bf7:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102bfd:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c03:	e8 c8 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c08:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c0b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c0d:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c12:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c15:	85 c0                	test   %eax,%eax
80102c17:	7e 19                	jle    80102c32 <write_head+0x42>
80102c19:	31 d2                	xor    %edx,%edx
80102c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c1f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c20:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102c27:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c2b:	83 c2 01             	add    $0x1,%edx
80102c2e:	39 d0                	cmp    %edx,%eax
80102c30:	75 ee                	jne    80102c20 <write_head+0x30>
  }
  bwrite(buf);
80102c32:	83 ec 0c             	sub    $0xc,%esp
80102c35:	53                   	push   %ebx
80102c36:	e8 75 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c3b:	89 1c 24             	mov    %ebx,(%esp)
80102c3e:	e8 ad d5 ff ff       	call   801001f0 <brelse>
}
80102c43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c46:	83 c4 10             	add    $0x10,%esp
80102c49:	c9                   	leave  
80102c4a:	c3                   	ret    
80102c4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c4f:	90                   	nop

80102c50 <initlog>:
{
80102c50:	f3 0f 1e fb          	endbr32 
80102c54:	55                   	push   %ebp
80102c55:	89 e5                	mov    %esp,%ebp
80102c57:	53                   	push   %ebx
80102c58:	83 ec 2c             	sub    $0x2c,%esp
80102c5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c5e:	68 e0 74 10 80       	push   $0x801074e0
80102c63:	68 80 26 11 80       	push   $0x80112680
80102c68:	e8 23 17 00 00       	call   80104390 <initlock>
  readsb(dev, &sb);
80102c6d:	58                   	pop    %eax
80102c6e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c71:	5a                   	pop    %edx
80102c72:	50                   	push   %eax
80102c73:	53                   	push   %ebx
80102c74:	e8 87 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102c79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c7c:	59                   	pop    %ecx
  log.dev = dev;
80102c7d:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c83:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c86:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c8b:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c91:	5a                   	pop    %edx
80102c92:	50                   	push   %eax
80102c93:	53                   	push   %ebx
80102c94:	e8 37 d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c99:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c9c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c9f:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c9                	test   %ecx,%ecx
80102ca7:	7e 19                	jle    80102cc2 <initlog+0x72>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cb0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cb4:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d1                	cmp    %edx,%ecx
80102cc0:	75 ee                	jne    80102cb0 <initlog+0x60>
  brelse(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	50                   	push   %eax
80102cc6:	e8 25 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ccb:	e8 80 fe ff ff       	call   80102b50 <install_trans>
  log.lh.n = 0;
80102cd0:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102cd7:	00 00 00 
  write_head(); // clear the log
80102cda:	e8 11 ff ff ff       	call   80102bf0 <write_head>
}
80102cdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce2:	83 c4 10             	add    $0x10,%esp
80102ce5:	c9                   	leave  
80102ce6:	c3                   	ret    
80102ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cee:	66 90                	xchg   %ax,%ax

80102cf0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cfa:	68 80 26 11 80       	push   $0x80112680
80102cff:	e8 0c 18 00 00       	call   80104510 <acquire>
80102d04:	83 c4 10             	add    $0x10,%esp
80102d07:	eb 1c                	jmp    80102d25 <begin_op+0x35>
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d10:	83 ec 08             	sub    $0x8,%esp
80102d13:	68 80 26 11 80       	push   $0x80112680
80102d18:	68 80 26 11 80       	push   $0x80112680
80102d1d:	e8 ae 11 00 00       	call   80103ed0 <sleep>
80102d22:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d25:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102d2a:	85 c0                	test   %eax,%eax
80102d2c:	75 e2                	jne    80102d10 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d2e:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d33:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d39:	83 c0 01             	add    $0x1,%eax
80102d3c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d3f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d42:	83 fa 1e             	cmp    $0x1e,%edx
80102d45:	7f c9                	jg     80102d10 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d47:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d4a:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102d4f:	68 80 26 11 80       	push   $0x80112680
80102d54:	e8 77 18 00 00       	call   801045d0 <release>
      break;
    }
  }
}
80102d59:	83 c4 10             	add    $0x10,%esp
80102d5c:	c9                   	leave  
80102d5d:	c3                   	ret    
80102d5e:	66 90                	xchg   %ax,%ax

80102d60 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d60:	f3 0f 1e fb          	endbr32 
80102d64:	55                   	push   %ebp
80102d65:	89 e5                	mov    %esp,%ebp
80102d67:	57                   	push   %edi
80102d68:	56                   	push   %esi
80102d69:	53                   	push   %ebx
80102d6a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d6d:	68 80 26 11 80       	push   $0x80112680
80102d72:	e8 99 17 00 00       	call   80104510 <acquire>
  log.outstanding -= 1;
80102d77:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d7c:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d82:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d85:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d88:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d8e:	85 f6                	test   %esi,%esi
80102d90:	0f 85 1e 01 00 00    	jne    80102eb4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d96:	85 db                	test   %ebx,%ebx
80102d98:	0f 85 f2 00 00 00    	jne    80102e90 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d9e:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102da5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	68 80 26 11 80       	push   $0x80112680
80102db0:	e8 1b 18 00 00       	call   801045d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102db5:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102dbb:	83 c4 10             	add    $0x10,%esp
80102dbe:	85 c9                	test   %ecx,%ecx
80102dc0:	7f 3e                	jg     80102e00 <end_op+0xa0>
    acquire(&log.lock);
80102dc2:	83 ec 0c             	sub    $0xc,%esp
80102dc5:	68 80 26 11 80       	push   $0x80112680
80102dca:	e8 41 17 00 00       	call   80104510 <acquire>
    wakeup(&log);
80102dcf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102dd6:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102ddd:	00 00 00 
    wakeup(&log);
80102de0:	e8 ab 12 00 00       	call   80104090 <wakeup>
    release(&log.lock);
80102de5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dec:	e8 df 17 00 00       	call   801045d0 <release>
80102df1:	83 c4 10             	add    $0x10,%esp
}
80102df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df7:	5b                   	pop    %ebx
80102df8:	5e                   	pop    %esi
80102df9:	5f                   	pop    %edi
80102dfa:	5d                   	pop    %ebp
80102dfb:	c3                   	ret    
80102dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e00:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102e05:	83 ec 08             	sub    $0x8,%esp
80102e08:	01 d8                	add    %ebx,%eax
80102e0a:	83 c0 01             	add    $0x1,%eax
80102e0d:	50                   	push   %eax
80102e0e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e14:	e8 b7 d2 ff ff       	call   801000d0 <bread>
80102e19:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e1b:	58                   	pop    %eax
80102e1c:	5a                   	pop    %edx
80102e1d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102e24:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e2a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e2d:	e8 9e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e32:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e35:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e37:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e3a:	68 00 02 00 00       	push   $0x200
80102e3f:	50                   	push   %eax
80102e40:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e43:	50                   	push   %eax
80102e44:	e8 77 18 00 00       	call   801046c0 <memmove>
    bwrite(to);  // write the log
80102e49:	89 34 24             	mov    %esi,(%esp)
80102e4c:	e8 5f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e51:	89 3c 24             	mov    %edi,(%esp)
80102e54:	e8 97 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e59:	89 34 24             	mov    %esi,(%esp)
80102e5c:	e8 8f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e61:	83 c4 10             	add    $0x10,%esp
80102e64:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e6a:	7c 94                	jl     80102e00 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e6c:	e8 7f fd ff ff       	call   80102bf0 <write_head>
    install_trans(); // Now install writes to home locations
80102e71:	e8 da fc ff ff       	call   80102b50 <install_trans>
    log.lh.n = 0;
80102e76:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e7d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e80:	e8 6b fd ff ff       	call   80102bf0 <write_head>
80102e85:	e9 38 ff ff ff       	jmp    80102dc2 <end_op+0x62>
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e90:	83 ec 0c             	sub    $0xc,%esp
80102e93:	68 80 26 11 80       	push   $0x80112680
80102e98:	e8 f3 11 00 00       	call   80104090 <wakeup>
  release(&log.lock);
80102e9d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ea4:	e8 27 17 00 00       	call   801045d0 <release>
80102ea9:	83 c4 10             	add    $0x10,%esp
}
80102eac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaf:	5b                   	pop    %ebx
80102eb0:	5e                   	pop    %esi
80102eb1:	5f                   	pop    %edi
80102eb2:	5d                   	pop    %ebp
80102eb3:	c3                   	ret    
    panic("log.committing");
80102eb4:	83 ec 0c             	sub    $0xc,%esp
80102eb7:	68 e4 74 10 80       	push   $0x801074e4
80102ebc:	e8 cf d4 ff ff       	call   80100390 <panic>
80102ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ec8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ecf:	90                   	nop

80102ed0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ed0:	f3 0f 1e fb          	endbr32 
80102ed4:	55                   	push   %ebp
80102ed5:	89 e5                	mov    %esp,%ebp
80102ed7:	53                   	push   %ebx
80102ed8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102edb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102ee1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ee4:	83 fa 1d             	cmp    $0x1d,%edx
80102ee7:	0f 8f 91 00 00 00    	jg     80102f7e <log_write+0xae>
80102eed:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102ef2:	83 e8 01             	sub    $0x1,%eax
80102ef5:	39 c2                	cmp    %eax,%edx
80102ef7:	0f 8d 81 00 00 00    	jge    80102f7e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102efd:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f02:	85 c0                	test   %eax,%eax
80102f04:	0f 8e 81 00 00 00    	jle    80102f8b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f0a:	83 ec 0c             	sub    $0xc,%esp
80102f0d:	68 80 26 11 80       	push   $0x80112680
80102f12:	e8 f9 15 00 00       	call   80104510 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f17:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f1d:	83 c4 10             	add    $0x10,%esp
80102f20:	85 d2                	test   %edx,%edx
80102f22:	7e 4e                	jle    80102f72 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f24:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f27:	31 c0                	xor    %eax,%eax
80102f29:	eb 0c                	jmp    80102f37 <log_write+0x67>
80102f2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f2f:	90                   	nop
80102f30:	83 c0 01             	add    $0x1,%eax
80102f33:	39 c2                	cmp    %eax,%edx
80102f35:	74 29                	je     80102f60 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f37:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102f3e:	75 f0                	jne    80102f30 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f40:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f47:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f4d:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102f54:	c9                   	leave  
  release(&log.lock);
80102f55:	e9 76 16 00 00       	jmp    801045d0 <release>
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102f60:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
    log.lh.n++;
80102f67:	83 c2 01             	add    $0x1,%edx
80102f6a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102f70:	eb d5                	jmp    80102f47 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102f72:	8b 43 08             	mov    0x8(%ebx),%eax
80102f75:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f7a:	75 cb                	jne    80102f47 <log_write+0x77>
80102f7c:	eb e9                	jmp    80102f67 <log_write+0x97>
    panic("too big a transaction");
80102f7e:	83 ec 0c             	sub    $0xc,%esp
80102f81:	68 f3 74 10 80       	push   $0x801074f3
80102f86:	e8 05 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f8b:	83 ec 0c             	sub    $0xc,%esp
80102f8e:	68 09 75 10 80       	push   $0x80107509
80102f93:	e8 f8 d3 ff ff       	call   80100390 <panic>
80102f98:	66 90                	xchg   %ax,%ax
80102f9a:	66 90                	xchg   %ax,%ax
80102f9c:	66 90                	xchg   %ax,%ax
80102f9e:	66 90                	xchg   %ax,%ax

80102fa0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 08             	sub    $0x8,%esp
  //cprintf("cpu %d: starting %d\n", cpuid(), cpuid());
  idtinit();       // load idt register
80102fa6:	e8 25 29 00 00       	call   801058d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102fab:	e8 d0 08 00 00       	call   80103880 <mycpu>
80102fb0:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102fb2:	b8 01 00 00 00       	mov    $0x1,%eax
80102fb7:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102fbe:	e8 1d 0c 00 00       	call   80103be0 <scheduler>
80102fc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102fd0 <mpenter>:
{
80102fd0:	f3 0f 1e fb          	endbr32 
80102fd4:	55                   	push   %ebp
80102fd5:	89 e5                	mov    %esp,%ebp
80102fd7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fda:	e8 c1 39 00 00       	call   801069a0 <switchkvm>
  seginit();
80102fdf:	e8 2c 39 00 00       	call   80106910 <seginit>
  lapicinit();
80102fe4:	e8 77 f7 ff ff       	call   80102760 <lapicinit>
  mpmain();
80102fe9:	e8 b2 ff ff ff       	call   80102fa0 <mpmain>
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <main>:
{
80102ff0:	f3 0f 1e fb          	endbr32 
80102ff4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ff8:	83 e4 f0             	and    $0xfffffff0,%esp
80102ffb:	ff 71 fc             	pushl  -0x4(%ecx)
80102ffe:	55                   	push   %ebp
80102fff:	89 e5                	mov    %esp,%ebp
80103001:	53                   	push   %ebx
80103002:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103003:	83 ec 08             	sub    $0x8,%esp
80103006:	68 00 00 40 80       	push   $0x80400000
8010300b:	68 a8 54 11 80       	push   $0x801154a8
80103010:	e8 0b f5 ff ff       	call   80102520 <kinit1>
  kvmalloc();      // kernel page table
80103015:	e8 66 3e 00 00       	call   80106e80 <kvmalloc>
  mpinit();        // detect other processors
8010301a:	e8 81 01 00 00       	call   801031a0 <mpinit>
  lapicinit();     // interrupt controller
8010301f:	e8 3c f7 ff ff       	call   80102760 <lapicinit>
  seginit();       // segment descriptors
80103024:	e8 e7 38 00 00       	call   80106910 <seginit>
  picinit();       // disable pic
80103029:	e8 52 03 00 00       	call   80103380 <picinit>
  ioapicinit();    // another interrupt controller
8010302e:	e8 0d f3 ff ff       	call   80102340 <ioapicinit>
  consoleinit();   // console hardware
80103033:	e8 f8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103038:	e8 93 2b 00 00       	call   80105bd0 <uartinit>
  pinit();         // process table
8010303d:	e8 1e 08 00 00       	call   80103860 <pinit>
  tvinit();        // trap vectors
80103042:	e8 09 28 00 00       	call   80105850 <tvinit>
  binit();         // buffer cache
80103047:	e8 f4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010304c:	e8 8f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103051:	e8 ba f0 ff ff       	call   80102110 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103056:	83 c4 0c             	add    $0xc,%esp
80103059:	68 8a 00 00 00       	push   $0x8a
8010305e:	68 8c a4 10 80       	push   $0x8010a48c
80103063:	68 00 70 00 80       	push   $0x80007000
80103068:	e8 53 16 00 00       	call   801046c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010306d:	83 c4 10             	add    $0x10,%esp
80103070:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103077:	00 00 00 
8010307a:	05 80 27 11 80       	add    $0x80112780,%eax
8010307f:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103084:	76 7a                	jbe    80103100 <main+0x110>
80103086:	bb 80 27 11 80       	mov    $0x80112780,%ebx
8010308b:	eb 1c                	jmp    801030a9 <main+0xb9>
8010308d:	8d 76 00             	lea    0x0(%esi),%esi
80103090:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103097:	00 00 00 
8010309a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030a0:	05 80 27 11 80       	add    $0x80112780,%eax
801030a5:	39 c3                	cmp    %eax,%ebx
801030a7:	73 57                	jae    80103100 <main+0x110>
    if(c == mycpu())  // We've started already.
801030a9:	e8 d2 07 00 00       	call   80103880 <mycpu>
801030ae:	39 c3                	cmp    %eax,%ebx
801030b0:	74 de                	je     80103090 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030b2:	e8 39 f5 ff ff       	call   801025f0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030b7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801030ba:	c7 05 f8 6f 00 80 d0 	movl   $0x80102fd0,0x80006ff8
801030c1:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030c4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801030cb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ce:	05 00 10 00 00       	add    $0x1000,%eax
801030d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801030d8:	0f b6 03             	movzbl (%ebx),%eax
801030db:	68 00 70 00 00       	push   $0x7000
801030e0:	50                   	push   %eax
801030e1:	e8 ca f7 ff ff       	call   801028b0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030e6:	83 c4 10             	add    $0x10,%esp
801030e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030f6:	85 c0                	test   %eax,%eax
801030f8:	74 f6                	je     801030f0 <main+0x100>
801030fa:	eb 94                	jmp    80103090 <main+0xa0>
801030fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103100:	83 ec 08             	sub    $0x8,%esp
80103103:	68 00 00 00 8e       	push   $0x8e000000
80103108:	68 00 00 40 80       	push   $0x80400000
8010310d:	e8 7e f4 ff ff       	call   80102590 <kinit2>
  userinit();      // first user process
80103112:	e8 29 08 00 00       	call   80103940 <userinit>
  mpmain();        // finish this processor's setup
80103117:	e8 84 fe ff ff       	call   80102fa0 <mpmain>
8010311c:	66 90                	xchg   %ax,%ax
8010311e:	66 90                	xchg   %ax,%ax

80103120 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
80103123:	57                   	push   %edi
80103124:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103125:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010312b:	53                   	push   %ebx
  e = addr+len;
8010312c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010312f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103132:	39 de                	cmp    %ebx,%esi
80103134:	72 10                	jb     80103146 <mpsearch1+0x26>
80103136:	eb 50                	jmp    80103188 <mpsearch1+0x68>
80103138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010313f:	90                   	nop
80103140:	89 fe                	mov    %edi,%esi
80103142:	39 fb                	cmp    %edi,%ebx
80103144:	76 42                	jbe    80103188 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103146:	83 ec 04             	sub    $0x4,%esp
80103149:	8d 7e 10             	lea    0x10(%esi),%edi
8010314c:	6a 04                	push   $0x4
8010314e:	68 24 75 10 80       	push   $0x80107524
80103153:	56                   	push   %esi
80103154:	e8 17 15 00 00       	call   80104670 <memcmp>
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	85 c0                	test   %eax,%eax
8010315e:	75 e0                	jne    80103140 <mpsearch1+0x20>
80103160:	89 f2                	mov    %esi,%edx
80103162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103168:	0f b6 0a             	movzbl (%edx),%ecx
8010316b:	83 c2 01             	add    $0x1,%edx
8010316e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103170:	39 fa                	cmp    %edi,%edx
80103172:	75 f4                	jne    80103168 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103174:	84 c0                	test   %al,%al
80103176:	75 c8                	jne    80103140 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010317b:	89 f0                	mov    %esi,%eax
8010317d:	5b                   	pop    %ebx
8010317e:	5e                   	pop    %esi
8010317f:	5f                   	pop    %edi
80103180:	5d                   	pop    %ebp
80103181:	c3                   	ret    
80103182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010318b:	31 f6                	xor    %esi,%esi
}
8010318d:	5b                   	pop    %ebx
8010318e:	89 f0                	mov    %esi,%eax
80103190:	5e                   	pop    %esi
80103191:	5f                   	pop    %edi
80103192:	5d                   	pop    %ebp
80103193:	c3                   	ret    
80103194:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop

801031a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031a0:	f3 0f 1e fb          	endbr32 
801031a4:	55                   	push   %ebp
801031a5:	89 e5                	mov    %esp,%ebp
801031a7:	57                   	push   %edi
801031a8:	56                   	push   %esi
801031a9:	53                   	push   %ebx
801031aa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031ad:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031b4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031bb:	c1 e0 08             	shl    $0x8,%eax
801031be:	09 d0                	or     %edx,%eax
801031c0:	c1 e0 04             	shl    $0x4,%eax
801031c3:	75 1b                	jne    801031e0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801031c5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031cc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031d3:	c1 e0 08             	shl    $0x8,%eax
801031d6:	09 d0                	or     %edx,%eax
801031d8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801031db:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801031e0:	ba 00 04 00 00       	mov    $0x400,%edx
801031e5:	e8 36 ff ff ff       	call   80103120 <mpsearch1>
801031ea:	89 c6                	mov    %eax,%esi
801031ec:	85 c0                	test   %eax,%eax
801031ee:	0f 84 4c 01 00 00    	je     80103340 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031f4:	8b 5e 04             	mov    0x4(%esi),%ebx
801031f7:	85 db                	test   %ebx,%ebx
801031f9:	0f 84 61 01 00 00    	je     80103360 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801031ff:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103202:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103208:	6a 04                	push   $0x4
8010320a:	68 29 75 10 80       	push   $0x80107529
8010320f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103210:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103213:	e8 58 14 00 00       	call   80104670 <memcmp>
80103218:	83 c4 10             	add    $0x10,%esp
8010321b:	85 c0                	test   %eax,%eax
8010321d:	0f 85 3d 01 00 00    	jne    80103360 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103223:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010322a:	3c 01                	cmp    $0x1,%al
8010322c:	74 08                	je     80103236 <mpinit+0x96>
8010322e:	3c 04                	cmp    $0x4,%al
80103230:	0f 85 2a 01 00 00    	jne    80103360 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103236:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010323d:	66 85 d2             	test   %dx,%dx
80103240:	74 26                	je     80103268 <mpinit+0xc8>
80103242:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103245:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103247:	31 d2                	xor    %edx,%edx
80103249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103250:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103257:	83 c0 01             	add    $0x1,%eax
8010325a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010325c:	39 f8                	cmp    %edi,%eax
8010325e:	75 f0                	jne    80103250 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103260:	84 d2                	test   %dl,%dl
80103262:	0f 85 f8 00 00 00    	jne    80103360 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103268:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010326e:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103273:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103279:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103280:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103285:	03 55 e4             	add    -0x1c(%ebp),%edx
80103288:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010328b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010328f:	90                   	nop
80103290:	39 c2                	cmp    %eax,%edx
80103292:	76 15                	jbe    801032a9 <mpinit+0x109>
    switch(*p){
80103294:	0f b6 08             	movzbl (%eax),%ecx
80103297:	80 f9 02             	cmp    $0x2,%cl
8010329a:	74 5c                	je     801032f8 <mpinit+0x158>
8010329c:	77 42                	ja     801032e0 <mpinit+0x140>
8010329e:	84 c9                	test   %cl,%cl
801032a0:	74 6e                	je     80103310 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032a2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032a5:	39 c2                	cmp    %eax,%edx
801032a7:	77 eb                	ja     80103294 <mpinit+0xf4>
801032a9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032ac:	85 db                	test   %ebx,%ebx
801032ae:	0f 84 b9 00 00 00    	je     8010336d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801032b4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
801032b8:	74 15                	je     801032cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ba:	b8 70 00 00 00       	mov    $0x70,%eax
801032bf:	ba 22 00 00 00       	mov    $0x22,%edx
801032c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c5:	ba 23 00 00 00       	mov    $0x23,%edx
801032ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032ce:	ee                   	out    %al,(%dx)
  }
}
801032cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032d2:	5b                   	pop    %ebx
801032d3:	5e                   	pop    %esi
801032d4:	5f                   	pop    %edi
801032d5:	5d                   	pop    %ebp
801032d6:	c3                   	ret    
801032d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032de:	66 90                	xchg   %ax,%ax
    switch(*p){
801032e0:	83 e9 03             	sub    $0x3,%ecx
801032e3:	80 f9 01             	cmp    $0x1,%cl
801032e6:	76 ba                	jbe    801032a2 <mpinit+0x102>
801032e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801032ef:	eb 9f                	jmp    80103290 <mpinit+0xf0>
801032f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801032f8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801032fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801032ff:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
80103305:	eb 89                	jmp    80103290 <mpinit+0xf0>
80103307:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010330e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103310:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
80103316:	83 f9 07             	cmp    $0x7,%ecx
80103319:	7f 19                	jg     80103334 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010331b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103321:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103325:	83 c1 01             	add    $0x1,%ecx
80103328:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010332e:	88 9f 80 27 11 80    	mov    %bl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
80103334:	83 c0 14             	add    $0x14,%eax
      continue;
80103337:	e9 54 ff ff ff       	jmp    80103290 <mpinit+0xf0>
8010333c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103340:	ba 00 00 01 00       	mov    $0x10000,%edx
80103345:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010334a:	e8 d1 fd ff ff       	call   80103120 <mpsearch1>
8010334f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103351:	85 c0                	test   %eax,%eax
80103353:	0f 85 9b fe ff ff    	jne    801031f4 <mpinit+0x54>
80103359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103360:	83 ec 0c             	sub    $0xc,%esp
80103363:	68 2e 75 10 80       	push   $0x8010752e
80103368:	e8 23 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010336d:	83 ec 0c             	sub    $0xc,%esp
80103370:	68 48 75 10 80       	push   $0x80107548
80103375:	e8 16 d0 ff ff       	call   80100390 <panic>
8010337a:	66 90                	xchg   %ax,%ax
8010337c:	66 90                	xchg   %ax,%ax
8010337e:	66 90                	xchg   %ax,%ax

80103380 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  xorg assumes SMP hardware.
void
picinit(void)
{
80103380:	f3 0f 1e fb          	endbr32 
80103384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103389:	ba 21 00 00 00       	mov    $0x21,%edx
8010338e:	ee                   	out    %al,(%dx)
8010338f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103394:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103395:	c3                   	ret    
80103396:	66 90                	xchg   %ax,%ax
80103398:	66 90                	xchg   %ax,%ax
8010339a:	66 90                	xchg   %ax,%ax
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033a0:	f3 0f 1e fb          	endbr32 
801033a4:	55                   	push   %ebp
801033a5:	89 e5                	mov    %esp,%ebp
801033a7:	57                   	push   %edi
801033a8:	56                   	push   %esi
801033a9:	53                   	push   %ebx
801033aa:	83 ec 0c             	sub    $0xc,%esp
801033ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033b3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801033b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801033bf:	e8 3c da ff ff       	call   80100e00 <filealloc>
801033c4:	89 03                	mov    %eax,(%ebx)
801033c6:	85 c0                	test   %eax,%eax
801033c8:	0f 84 ac 00 00 00    	je     8010347a <pipealloc+0xda>
801033ce:	e8 2d da ff ff       	call   80100e00 <filealloc>
801033d3:	89 06                	mov    %eax,(%esi)
801033d5:	85 c0                	test   %eax,%eax
801033d7:	0f 84 8b 00 00 00    	je     80103468 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801033dd:	e8 0e f2 ff ff       	call   801025f0 <kalloc>
801033e2:	89 c7                	mov    %eax,%edi
801033e4:	85 c0                	test   %eax,%eax
801033e6:	0f 84 b4 00 00 00    	je     801034a0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
801033ec:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033f3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033f6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801033f9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103400:	00 00 00 
  p->nwrite = 0;
80103403:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010340a:	00 00 00 
  p->nread = 0;
8010340d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103414:	00 00 00 
  initlock(&p->lock, "pipe");
80103417:	68 67 75 10 80       	push   $0x80107567
8010341c:	50                   	push   %eax
8010341d:	e8 6e 0f 00 00       	call   80104390 <initlock>
  (*f0)->type = FD_PIPE;
80103422:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103424:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103427:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010342d:	8b 03                	mov    (%ebx),%eax
8010342f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103433:	8b 03                	mov    (%ebx),%eax
80103435:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103439:	8b 03                	mov    (%ebx),%eax
8010343b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010343e:	8b 06                	mov    (%esi),%eax
80103440:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103446:	8b 06                	mov    (%esi),%eax
80103448:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010344c:	8b 06                	mov    (%esi),%eax
8010344e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103452:	8b 06                	mov    (%esi),%eax
80103454:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103457:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010345a:	31 c0                	xor    %eax,%eax
}
8010345c:	5b                   	pop    %ebx
8010345d:	5e                   	pop    %esi
8010345e:	5f                   	pop    %edi
8010345f:	5d                   	pop    %ebp
80103460:	c3                   	ret    
80103461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103468:	8b 03                	mov    (%ebx),%eax
8010346a:	85 c0                	test   %eax,%eax
8010346c:	74 1e                	je     8010348c <pipealloc+0xec>
    fileclose(*f0);
8010346e:	83 ec 0c             	sub    $0xc,%esp
80103471:	50                   	push   %eax
80103472:	e8 49 da ff ff       	call   80100ec0 <fileclose>
80103477:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010347a:	8b 06                	mov    (%esi),%eax
8010347c:	85 c0                	test   %eax,%eax
8010347e:	74 0c                	je     8010348c <pipealloc+0xec>
    fileclose(*f1);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	50                   	push   %eax
80103484:	e8 37 da ff ff       	call   80100ec0 <fileclose>
80103489:	83 c4 10             	add    $0x10,%esp
}
8010348c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010348f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103494:	5b                   	pop    %ebx
80103495:	5e                   	pop    %esi
80103496:	5f                   	pop    %edi
80103497:	5d                   	pop    %ebp
80103498:	c3                   	ret    
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034a0:	8b 03                	mov    (%ebx),%eax
801034a2:	85 c0                	test   %eax,%eax
801034a4:	75 c8                	jne    8010346e <pipealloc+0xce>
801034a6:	eb d2                	jmp    8010347a <pipealloc+0xda>
801034a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034af:	90                   	nop

801034b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801034b0:	f3 0f 1e fb          	endbr32 
801034b4:	55                   	push   %ebp
801034b5:	89 e5                	mov    %esp,%ebp
801034b7:	56                   	push   %esi
801034b8:	53                   	push   %ebx
801034b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801034bf:	83 ec 0c             	sub    $0xc,%esp
801034c2:	53                   	push   %ebx
801034c3:	e8 48 10 00 00       	call   80104510 <acquire>
  if(writable){
801034c8:	83 c4 10             	add    $0x10,%esp
801034cb:	85 f6                	test   %esi,%esi
801034cd:	74 41                	je     80103510 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801034cf:	83 ec 0c             	sub    $0xc,%esp
801034d2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801034d8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801034df:	00 00 00 
    wakeup(&p->nread);
801034e2:	50                   	push   %eax
801034e3:	e8 a8 0b 00 00       	call   80104090 <wakeup>
801034e8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801034eb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801034f1:	85 d2                	test   %edx,%edx
801034f3:	75 0a                	jne    801034ff <pipeclose+0x4f>
801034f5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034fb:	85 c0                	test   %eax,%eax
801034fd:	74 31                	je     80103530 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034ff:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103502:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103505:	5b                   	pop    %ebx
80103506:	5e                   	pop    %esi
80103507:	5d                   	pop    %ebp
    release(&p->lock);
80103508:	e9 c3 10 00 00       	jmp    801045d0 <release>
8010350d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103510:	83 ec 0c             	sub    $0xc,%esp
80103513:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103519:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103520:	00 00 00 
    wakeup(&p->nwrite);
80103523:	50                   	push   %eax
80103524:	e8 67 0b 00 00       	call   80104090 <wakeup>
80103529:	83 c4 10             	add    $0x10,%esp
8010352c:	eb bd                	jmp    801034eb <pipeclose+0x3b>
8010352e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	53                   	push   %ebx
80103534:	e8 97 10 00 00       	call   801045d0 <release>
    kfree((char*)p);
80103539:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010353c:	83 c4 10             	add    $0x10,%esp
}
8010353f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103542:	5b                   	pop    %ebx
80103543:	5e                   	pop    %esi
80103544:	5d                   	pop    %ebp
    kfree((char*)p);
80103545:	e9 e6 ee ff ff       	jmp    80102430 <kfree>
8010354a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103550 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	57                   	push   %edi
80103558:	56                   	push   %esi
80103559:	53                   	push   %ebx
8010355a:	83 ec 28             	sub    $0x28,%esp
8010355d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103560:	53                   	push   %ebx
80103561:	e8 aa 0f 00 00       	call   80104510 <acquire>
  for(i = 0; i < n; i++){
80103566:	8b 45 10             	mov    0x10(%ebp),%eax
80103569:	83 c4 10             	add    $0x10,%esp
8010356c:	85 c0                	test   %eax,%eax
8010356e:	0f 8e bc 00 00 00    	jle    80103630 <pipewrite+0xe0>
80103574:	8b 45 0c             	mov    0xc(%ebp),%eax
80103577:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010357d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103586:	03 45 10             	add    0x10(%ebp),%eax
80103589:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010358c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103592:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103598:	89 ca                	mov    %ecx,%edx
8010359a:	05 00 02 00 00       	add    $0x200,%eax
8010359f:	39 c1                	cmp    %eax,%ecx
801035a1:	74 3b                	je     801035de <pipewrite+0x8e>
801035a3:	eb 63                	jmp    80103608 <pipewrite+0xb8>
801035a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035a8:	e8 63 03 00 00       	call   80103910 <myproc>
801035ad:	8b 48 24             	mov    0x24(%eax),%ecx
801035b0:	85 c9                	test   %ecx,%ecx
801035b2:	75 34                	jne    801035e8 <pipewrite+0x98>
      wakeup(&p->nread);
801035b4:	83 ec 0c             	sub    $0xc,%esp
801035b7:	57                   	push   %edi
801035b8:	e8 d3 0a 00 00       	call   80104090 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035bd:	58                   	pop    %eax
801035be:	5a                   	pop    %edx
801035bf:	53                   	push   %ebx
801035c0:	56                   	push   %esi
801035c1:	e8 0a 09 00 00       	call   80103ed0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035c6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035cc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801035d2:	83 c4 10             	add    $0x10,%esp
801035d5:	05 00 02 00 00       	add    $0x200,%eax
801035da:	39 c2                	cmp    %eax,%edx
801035dc:	75 2a                	jne    80103608 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801035de:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035e4:	85 c0                	test   %eax,%eax
801035e6:	75 c0                	jne    801035a8 <pipewrite+0x58>
        release(&p->lock);
801035e8:	83 ec 0c             	sub    $0xc,%esp
801035eb:	53                   	push   %ebx
801035ec:	e8 df 0f 00 00       	call   801045d0 <release>
        return -1;
801035f1:	83 c4 10             	add    $0x10,%esp
801035f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801035f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035fc:	5b                   	pop    %ebx
801035fd:	5e                   	pop    %esi
801035fe:	5f                   	pop    %edi
801035ff:	5d                   	pop    %ebp
80103600:	c3                   	ret    
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103608:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010360b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010360e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103614:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010361a:	0f b6 06             	movzbl (%esi),%eax
8010361d:	83 c6 01             	add    $0x1,%esi
80103620:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103623:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103627:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010362a:	0f 85 5c ff ff ff    	jne    8010358c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103630:	83 ec 0c             	sub    $0xc,%esp
80103633:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103639:	50                   	push   %eax
8010363a:	e8 51 0a 00 00       	call   80104090 <wakeup>
  release(&p->lock);
8010363f:	89 1c 24             	mov    %ebx,(%esp)
80103642:	e8 89 0f 00 00       	call   801045d0 <release>
  return n;
80103647:	8b 45 10             	mov    0x10(%ebp),%eax
8010364a:	83 c4 10             	add    $0x10,%esp
8010364d:	eb aa                	jmp    801035f9 <pipewrite+0xa9>
8010364f:	90                   	nop

80103650 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103650:	f3 0f 1e fb          	endbr32 
80103654:	55                   	push   %ebp
80103655:	89 e5                	mov    %esp,%ebp
80103657:	57                   	push   %edi
80103658:	56                   	push   %esi
80103659:	53                   	push   %ebx
8010365a:	83 ec 18             	sub    $0x18,%esp
8010365d:	8b 75 08             	mov    0x8(%ebp),%esi
80103660:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103663:	56                   	push   %esi
80103664:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010366a:	e8 a1 0e 00 00       	call   80104510 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010366f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010367e:	74 33                	je     801036b3 <piperead+0x63>
80103680:	eb 3b                	jmp    801036bd <piperead+0x6d>
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103688:	e8 83 02 00 00       	call   80103910 <myproc>
8010368d:	8b 48 24             	mov    0x24(%eax),%ecx
80103690:	85 c9                	test   %ecx,%ecx
80103692:	0f 85 88 00 00 00    	jne    80103720 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103698:	83 ec 08             	sub    $0x8,%esp
8010369b:	56                   	push   %esi
8010369c:	53                   	push   %ebx
8010369d:	e8 2e 08 00 00       	call   80103ed0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036a2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036a8:	83 c4 10             	add    $0x10,%esp
801036ab:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801036b1:	75 0a                	jne    801036bd <piperead+0x6d>
801036b3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801036b9:	85 c0                	test   %eax,%eax
801036bb:	75 cb                	jne    80103688 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036bd:	8b 55 10             	mov    0x10(%ebp),%edx
801036c0:	31 db                	xor    %ebx,%ebx
801036c2:	85 d2                	test   %edx,%edx
801036c4:	7f 28                	jg     801036ee <piperead+0x9e>
801036c6:	eb 34                	jmp    801036fc <piperead+0xac>
801036c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036cf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036d0:	8d 48 01             	lea    0x1(%eax),%ecx
801036d3:	25 ff 01 00 00       	and    $0x1ff,%eax
801036d8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801036de:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801036e3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036e6:	83 c3 01             	add    $0x1,%ebx
801036e9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036ec:	74 0e                	je     801036fc <piperead+0xac>
    if(p->nread == p->nwrite)
801036ee:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036f4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801036fa:	75 d4                	jne    801036d0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036fc:	83 ec 0c             	sub    $0xc,%esp
801036ff:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103705:	50                   	push   %eax
80103706:	e8 85 09 00 00       	call   80104090 <wakeup>
  release(&p->lock);
8010370b:	89 34 24             	mov    %esi,(%esp)
8010370e:	e8 bd 0e 00 00       	call   801045d0 <release>
  return i;
80103713:	83 c4 10             	add    $0x10,%esp
}
80103716:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103719:	89 d8                	mov    %ebx,%eax
8010371b:	5b                   	pop    %ebx
8010371c:	5e                   	pop    %esi
8010371d:	5f                   	pop    %edi
8010371e:	5d                   	pop    %ebp
8010371f:	c3                   	ret    
      release(&p->lock);
80103720:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103723:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103728:	56                   	push   %esi
80103729:	e8 a2 0e 00 00       	call   801045d0 <release>
      return -1;
8010372e:	83 c4 10             	add    $0x10,%esp
}
80103731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103734:	89 d8                	mov    %ebx,%eax
80103736:	5b                   	pop    %ebx
80103737:	5e                   	pop    %esi
80103738:	5f                   	pop    %edi
80103739:	5d                   	pop    %ebp
8010373a:	c3                   	ret    
8010373b:	66 90                	xchg   %ax,%ax
8010373d:	66 90                	xchg   %ax,%ax
8010373f:	90                   	nop

80103740 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103744:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103749:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010374c:	68 20 2d 11 80       	push   $0x80112d20
80103751:	e8 ba 0d 00 00       	call   80104510 <acquire>
80103756:	83 c4 10             	add    $0x10,%esp
80103759:	eb 10                	jmp    8010376b <allocproc+0x2b>
8010375b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010375f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103760:	83 c3 7c             	add    $0x7c,%ebx
80103763:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103769:	74 75                	je     801037e0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010376b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010376e:	85 c0                	test   %eax,%eax
80103770:	75 ee                	jne    80103760 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103772:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103777:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010377a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103781:	89 43 10             	mov    %eax,0x10(%ebx)
80103784:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103787:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010378c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103792:	e8 39 0e 00 00       	call   801045d0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103797:	e8 54 ee ff ff       	call   801025f0 <kalloc>
8010379c:	83 c4 10             	add    $0x10,%esp
8010379f:	89 43 08             	mov    %eax,0x8(%ebx)
801037a2:	85 c0                	test   %eax,%eax
801037a4:	74 53                	je     801037f9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037a6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ac:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801037af:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801037b4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801037b7:	c7 40 14 36 58 10 80 	movl   $0x80105836,0x14(%eax)
  p->context = (struct context*)sp;
801037be:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037c1:	6a 14                	push   $0x14
801037c3:	6a 00                	push   $0x0
801037c5:	50                   	push   %eax
801037c6:	e8 55 0e 00 00       	call   80104620 <memset>
  p->context->eip = (uint)forkret;
801037cb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037ce:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801037d1:	c7 40 10 10 38 10 80 	movl   $0x80103810,0x10(%eax)
}
801037d8:	89 d8                	mov    %ebx,%eax
801037da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037dd:	c9                   	leave  
801037de:	c3                   	ret    
801037df:	90                   	nop
  release(&ptable.lock);
801037e0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801037e3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801037e5:	68 20 2d 11 80       	push   $0x80112d20
801037ea:	e8 e1 0d 00 00       	call   801045d0 <release>
}
801037ef:	89 d8                	mov    %ebx,%eax
  return 0;
801037f1:	83 c4 10             	add    $0x10,%esp
}
801037f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037f7:	c9                   	leave  
801037f8:	c3                   	ret    
    p->state = UNUSED;
801037f9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103800:	31 db                	xor    %ebx,%ebx
}
80103802:	89 d8                	mov    %ebx,%eax
80103804:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103807:	c9                   	leave  
80103808:	c3                   	ret    
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103810 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103810:	f3 0f 1e fb          	endbr32 
80103814:	55                   	push   %ebp
80103815:	89 e5                	mov    %esp,%ebp
80103817:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010381a:	68 20 2d 11 80       	push   $0x80112d20
8010381f:	e8 ac 0d 00 00       	call   801045d0 <release>

  if (first) {
80103824:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	85 c0                	test   %eax,%eax
8010382e:	75 08                	jne    80103838 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103830:	c9                   	leave  
80103831:	c3                   	ret    
80103832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103838:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010383f:	00 00 00 
    iinit(ROOTDEV);
80103842:	83 ec 0c             	sub    $0xc,%esp
80103845:	6a 01                	push   $0x1
80103847:	e8 f4 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010384c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103853:	e8 f8 f3 ff ff       	call   80102c50 <initlog>
}
80103858:	83 c4 10             	add    $0x10,%esp
8010385b:	c9                   	leave  
8010385c:	c3                   	ret    
8010385d:	8d 76 00             	lea    0x0(%esi),%esi

80103860 <pinit>:
{
80103860:	f3 0f 1e fb          	endbr32 
80103864:	55                   	push   %ebp
80103865:	89 e5                	mov    %esp,%ebp
80103867:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010386a:	68 6c 75 10 80       	push   $0x8010756c
8010386f:	68 20 2d 11 80       	push   $0x80112d20
80103874:	e8 17 0b 00 00       	call   80104390 <initlock>
}
80103879:	83 c4 10             	add    $0x10,%esp
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    
8010387e:	66 90                	xchg   %ax,%ax

80103880 <mycpu>:
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	56                   	push   %esi
80103888:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103889:	9c                   	pushf  
8010388a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010388b:	f6 c4 02             	test   $0x2,%ah
8010388e:	75 4a                	jne    801038da <mycpu+0x5a>
  apicid = lapicid();
80103890:	e8 cb ef ff ff       	call   80102860 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103895:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
  apicid = lapicid();
8010389b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010389d:	85 f6                	test   %esi,%esi
8010389f:	7e 2c                	jle    801038cd <mycpu+0x4d>
801038a1:	31 d2                	xor    %edx,%edx
801038a3:	eb 0a                	jmp    801038af <mycpu+0x2f>
801038a5:	8d 76 00             	lea    0x0(%esi),%esi
801038a8:	83 c2 01             	add    $0x1,%edx
801038ab:	39 f2                	cmp    %esi,%edx
801038ad:	74 1e                	je     801038cd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801038af:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801038b5:	0f b6 81 80 27 11 80 	movzbl -0x7feed880(%ecx),%eax
801038bc:	39 d8                	cmp    %ebx,%eax
801038be:	75 e8                	jne    801038a8 <mycpu+0x28>
}
801038c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801038c3:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
801038c9:	5b                   	pop    %ebx
801038ca:	5e                   	pop    %esi
801038cb:	5d                   	pop    %ebp
801038cc:	c3                   	ret    
  panic("unknown apicid\n");
801038cd:	83 ec 0c             	sub    $0xc,%esp
801038d0:	68 73 75 10 80       	push   $0x80107573
801038d5:	e8 b6 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801038da:	83 ec 0c             	sub    $0xc,%esp
801038dd:	68 50 76 10 80       	push   $0x80107650
801038e2:	e8 a9 ca ff ff       	call   80100390 <panic>
801038e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <cpuid>:
cpuid() {
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038fa:	e8 81 ff ff ff       	call   80103880 <mycpu>
}
801038ff:	c9                   	leave  
  return mycpu()-cpus;
80103900:	2d 80 27 11 80       	sub    $0x80112780,%eax
80103905:	c1 f8 04             	sar    $0x4,%eax
80103908:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010390e:	c3                   	ret    
8010390f:	90                   	nop

80103910 <myproc>:
myproc(void) {
80103910:	f3 0f 1e fb          	endbr32 
80103914:	55                   	push   %ebp
80103915:	89 e5                	mov    %esp,%ebp
80103917:	53                   	push   %ebx
80103918:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010391b:	e8 f0 0a 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103920:	e8 5b ff ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103925:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010392b:	e8 30 0b 00 00       	call   80104460 <popcli>
}
80103930:	83 c4 04             	add    $0x4,%esp
80103933:	89 d8                	mov    %ebx,%eax
80103935:	5b                   	pop    %ebx
80103936:	5d                   	pop    %ebp
80103937:	c3                   	ret    
80103938:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010393f:	90                   	nop

80103940 <userinit>:
{
80103940:	f3 0f 1e fb          	endbr32 
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	53                   	push   %ebx
80103948:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010394b:	e8 f0 fd ff ff       	call   80103740 <allocproc>
80103950:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103952:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103957:	e8 a4 34 00 00       	call   80106e00 <setupkvm>
8010395c:	89 43 04             	mov    %eax,0x4(%ebx)
8010395f:	85 c0                	test   %eax,%eax
80103961:	0f 84 bd 00 00 00    	je     80103a24 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103967:	83 ec 04             	sub    $0x4,%esp
8010396a:	68 2c 00 00 00       	push   $0x2c
8010396f:	68 60 a4 10 80       	push   $0x8010a460
80103974:	50                   	push   %eax
80103975:	e8 56 31 00 00       	call   80106ad0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010397a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010397d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103983:	6a 4c                	push   $0x4c
80103985:	6a 00                	push   $0x0
80103987:	ff 73 18             	pushl  0x18(%ebx)
8010398a:	e8 91 0c 00 00       	call   80104620 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010398f:	8b 43 18             	mov    0x18(%ebx),%eax
80103992:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103997:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010399a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010399f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039a3:	8b 43 18             	mov    0x18(%ebx),%eax
801039a6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039aa:	8b 43 18             	mov    0x18(%ebx),%eax
801039ad:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039b1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039b5:	8b 43 18             	mov    0x18(%ebx),%eax
801039b8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039bc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039c0:	8b 43 18             	mov    0x18(%ebx),%eax
801039c3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801039ca:	8b 43 18             	mov    0x18(%ebx),%eax
801039cd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801039d4:	8b 43 18             	mov    0x18(%ebx),%eax
801039d7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801039de:	8d 43 6c             	lea    0x6c(%ebx),%eax
801039e1:	6a 10                	push   $0x10
801039e3:	68 9c 75 10 80       	push   $0x8010759c
801039e8:	50                   	push   %eax
801039e9:	e8 f2 0d 00 00       	call   801047e0 <safestrcpy>
  p->cwd = namei("/");
801039ee:	c7 04 24 a5 75 10 80 	movl   $0x801075a5,(%esp)
801039f5:	e8 f6 e5 ff ff       	call   80101ff0 <namei>
801039fa:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039fd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a04:	e8 07 0b 00 00       	call   80104510 <acquire>
  p->state = RUNNABLE;
80103a09:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a10:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a17:	e8 b4 0b 00 00       	call   801045d0 <release>
}
80103a1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a1f:	83 c4 10             	add    $0x10,%esp
80103a22:	c9                   	leave  
80103a23:	c3                   	ret    
    panic("userinit: out of memory?");
80103a24:	83 ec 0c             	sub    $0xc,%esp
80103a27:	68 83 75 10 80       	push   $0x80107583
80103a2c:	e8 5f c9 ff ff       	call   80100390 <panic>
80103a31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3f:	90                   	nop

80103a40 <growproc>:
{
80103a40:	f3 0f 1e fb          	endbr32 
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	56                   	push   %esi
80103a48:	53                   	push   %ebx
80103a49:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103a4c:	e8 bf 09 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103a51:	e8 2a fe ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103a56:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a5c:	e8 ff 09 00 00       	call   80104460 <popcli>
  sz = curproc->sz;
80103a61:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a63:	85 f6                	test   %esi,%esi
80103a65:	7f 19                	jg     80103a80 <growproc+0x40>
  } else if(n < 0){
80103a67:	75 37                	jne    80103aa0 <growproc+0x60>
  switchuvm(curproc);
80103a69:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a6c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a6e:	53                   	push   %ebx
80103a6f:	e8 4c 2f 00 00       	call   801069c0 <switchuvm>
  return 0;
80103a74:	83 c4 10             	add    $0x10,%esp
80103a77:	31 c0                	xor    %eax,%eax
}
80103a79:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a7c:	5b                   	pop    %ebx
80103a7d:	5e                   	pop    %esi
80103a7e:	5d                   	pop    %ebp
80103a7f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a80:	83 ec 04             	sub    $0x4,%esp
80103a83:	01 c6                	add    %eax,%esi
80103a85:	56                   	push   %esi
80103a86:	50                   	push   %eax
80103a87:	ff 73 04             	pushl  0x4(%ebx)
80103a8a:	e8 91 31 00 00       	call   80106c20 <allocuvm>
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	85 c0                	test   %eax,%eax
80103a94:	75 d3                	jne    80103a69 <growproc+0x29>
      return -1;
80103a96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a9b:	eb dc                	jmp    80103a79 <growproc+0x39>
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103aa0:	83 ec 04             	sub    $0x4,%esp
80103aa3:	01 c6                	add    %eax,%esi
80103aa5:	56                   	push   %esi
80103aa6:	50                   	push   %eax
80103aa7:	ff 73 04             	pushl  0x4(%ebx)
80103aaa:	e8 a1 32 00 00       	call   80106d50 <deallocuvm>
80103aaf:	83 c4 10             	add    $0x10,%esp
80103ab2:	85 c0                	test   %eax,%eax
80103ab4:	75 b3                	jne    80103a69 <growproc+0x29>
80103ab6:	eb de                	jmp    80103a96 <growproc+0x56>
80103ab8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103abf:	90                   	nop

80103ac0 <fork>:
{
80103ac0:	f3 0f 1e fb          	endbr32 
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	57                   	push   %edi
80103ac8:	56                   	push   %esi
80103ac9:	53                   	push   %ebx
80103aca:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103acd:	e8 3e 09 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103ad2:	e8 a9 fd ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103ad7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103add:	e8 7e 09 00 00       	call   80104460 <popcli>
  if((np = allocproc()) == 0){
80103ae2:	e8 59 fc ff ff       	call   80103740 <allocproc>
80103ae7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103aea:	85 c0                	test   %eax,%eax
80103aec:	0f 84 bb 00 00 00    	je     80103bad <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103af2:	83 ec 08             	sub    $0x8,%esp
80103af5:	ff 33                	pushl  (%ebx)
80103af7:	89 c7                	mov    %eax,%edi
80103af9:	ff 73 04             	pushl  0x4(%ebx)
80103afc:	e8 cf 33 00 00       	call   80106ed0 <copyuvm>
80103b01:	83 c4 10             	add    $0x10,%esp
80103b04:	89 47 04             	mov    %eax,0x4(%edi)
80103b07:	85 c0                	test   %eax,%eax
80103b09:	0f 84 a5 00 00 00    	je     80103bb4 <fork+0xf4>
  np->sz = curproc->sz;
80103b0f:	8b 03                	mov    (%ebx),%eax
80103b11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b14:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b16:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b19:	89 c8                	mov    %ecx,%eax
80103b1b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b1e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b23:	8b 73 18             	mov    0x18(%ebx),%esi
80103b26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b28:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b2a:	8b 40 18             	mov    0x18(%eax),%eax
80103b2d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103b38:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b3c:	85 c0                	test   %eax,%eax
80103b3e:	74 13                	je     80103b53 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103b40:	83 ec 0c             	sub    $0xc,%esp
80103b43:	50                   	push   %eax
80103b44:	e8 27 d3 ff ff       	call   80100e70 <filedup>
80103b49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103b4c:	83 c4 10             	add    $0x10,%esp
80103b4f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103b53:	83 c6 01             	add    $0x1,%esi
80103b56:	83 fe 10             	cmp    $0x10,%esi
80103b59:	75 dd                	jne    80103b38 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103b5b:	83 ec 0c             	sub    $0xc,%esp
80103b5e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b61:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b64:	e8 87 db ff ff       	call   801016f0 <idup>
80103b69:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b6c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b6f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b72:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b75:	6a 10                	push   $0x10
80103b77:	53                   	push   %ebx
80103b78:	50                   	push   %eax
80103b79:	e8 62 0c 00 00       	call   801047e0 <safestrcpy>
  pid = np->pid;
80103b7e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b81:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b88:	e8 83 09 00 00       	call   80104510 <acquire>
  np->state = RUNNABLE;
80103b8d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b94:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b9b:	e8 30 0a 00 00       	call   801045d0 <release>
  return pid;
80103ba0:	83 c4 10             	add    $0x10,%esp
}
80103ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ba6:	89 d8                	mov    %ebx,%eax
80103ba8:	5b                   	pop    %ebx
80103ba9:	5e                   	pop    %esi
80103baa:	5f                   	pop    %edi
80103bab:	5d                   	pop    %ebp
80103bac:	c3                   	ret    
    return -1;
80103bad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bb2:	eb ef                	jmp    80103ba3 <fork+0xe3>
    kfree(np->kstack);
80103bb4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103bb7:	83 ec 0c             	sub    $0xc,%esp
80103bba:	ff 73 08             	pushl  0x8(%ebx)
80103bbd:	e8 6e e8 ff ff       	call   80102430 <kfree>
    np->kstack = 0;
80103bc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103bc9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103bcc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103bd3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103bd8:	eb c9                	jmp    80103ba3 <fork+0xe3>
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <scheduler>:
{
80103be0:	f3 0f 1e fb          	endbr32 
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	57                   	push   %edi
80103be8:	56                   	push   %esi
80103be9:	53                   	push   %ebx
80103bea:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103bed:	e8 8e fc ff ff       	call   80103880 <mycpu>
  c->proc = 0;
80103bf2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103bf9:	00 00 00 
  struct cpu *c = mycpu();
80103bfc:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103bfe:	8d 78 04             	lea    0x4(%eax),%edi
80103c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c08:	fb                   	sti    
    acquire(&ptable.lock);
80103c09:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c0c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103c11:	68 20 2d 11 80       	push   $0x80112d20
80103c16:	e8 f5 08 00 00       	call   80104510 <acquire>
80103c1b:	83 c4 10             	add    $0x10,%esp
80103c1e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c20:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c24:	75 33                	jne    80103c59 <scheduler+0x79>
      switchuvm(p);
80103c26:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c29:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c2f:	53                   	push   %ebx
80103c30:	e8 8b 2d 00 00       	call   801069c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103c35:	58                   	pop    %eax
80103c36:	5a                   	pop    %edx
80103c37:	ff 73 1c             	pushl  0x1c(%ebx)
80103c3a:	57                   	push   %edi
      p->state = RUNNING;
80103c3b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103c42:	e8 fc 0b 00 00       	call   80104843 <swtch>
      switchkvm();
80103c47:	e8 54 2d 00 00       	call   801069a0 <switchkvm>
      c->proc = 0;
80103c4c:	83 c4 10             	add    $0x10,%esp
80103c4f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c56:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c59:	83 c3 7c             	add    $0x7c,%ebx
80103c5c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c62:	75 bc                	jne    80103c20 <scheduler+0x40>
    release(&ptable.lock);
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	68 20 2d 11 80       	push   $0x80112d20
80103c6c:	e8 5f 09 00 00       	call   801045d0 <release>
    sti();
80103c71:	83 c4 10             	add    $0x10,%esp
80103c74:	eb 92                	jmp    80103c08 <scheduler+0x28>
80103c76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi

80103c80 <sched>:
{
80103c80:	f3 0f 1e fb          	endbr32 
80103c84:	55                   	push   %ebp
80103c85:	89 e5                	mov    %esp,%ebp
80103c87:	56                   	push   %esi
80103c88:	53                   	push   %ebx
  pushcli();
80103c89:	e8 82 07 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103c8e:	e8 ed fb ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103c93:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c99:	e8 c2 07 00 00       	call   80104460 <popcli>
  if(!holding(&ptable.lock))
80103c9e:	83 ec 0c             	sub    $0xc,%esp
80103ca1:	68 20 2d 11 80       	push   $0x80112d20
80103ca6:	e8 15 08 00 00       	call   801044c0 <holding>
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	85 c0                	test   %eax,%eax
80103cb0:	74 4f                	je     80103d01 <sched+0x81>
  if(mycpu()->ncli != 1)
80103cb2:	e8 c9 fb ff ff       	call   80103880 <mycpu>
80103cb7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103cbe:	75 68                	jne    80103d28 <sched+0xa8>
  if(p->state == RUNNING)
80103cc0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103cc4:	74 55                	je     80103d1b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cc6:	9c                   	pushf  
80103cc7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cc8:	f6 c4 02             	test   $0x2,%ah
80103ccb:	75 41                	jne    80103d0e <sched+0x8e>
  intena = mycpu()->intena;
80103ccd:	e8 ae fb ff ff       	call   80103880 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103cd2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103cd5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103cdb:	e8 a0 fb ff ff       	call   80103880 <mycpu>
80103ce0:	83 ec 08             	sub    $0x8,%esp
80103ce3:	ff 70 04             	pushl  0x4(%eax)
80103ce6:	53                   	push   %ebx
80103ce7:	e8 57 0b 00 00       	call   80104843 <swtch>
  mycpu()->intena = intena;
80103cec:	e8 8f fb ff ff       	call   80103880 <mycpu>
}
80103cf1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cf4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cfa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cfd:	5b                   	pop    %ebx
80103cfe:	5e                   	pop    %esi
80103cff:	5d                   	pop    %ebp
80103d00:	c3                   	ret    
    panic("sched ptable.lock");
80103d01:	83 ec 0c             	sub    $0xc,%esp
80103d04:	68 a7 75 10 80       	push   $0x801075a7
80103d09:	e8 82 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d0e:	83 ec 0c             	sub    $0xc,%esp
80103d11:	68 d3 75 10 80       	push   $0x801075d3
80103d16:	e8 75 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d1b:	83 ec 0c             	sub    $0xc,%esp
80103d1e:	68 c5 75 10 80       	push   $0x801075c5
80103d23:	e8 68 c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d28:	83 ec 0c             	sub    $0xc,%esp
80103d2b:	68 b9 75 10 80       	push   $0x801075b9
80103d30:	e8 5b c6 ff ff       	call   80100390 <panic>
80103d35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103d40 <exit>:
{
80103d40:	f3 0f 1e fb          	endbr32 
80103d44:	55                   	push   %ebp
80103d45:	89 e5                	mov    %esp,%ebp
80103d47:	57                   	push   %edi
80103d48:	56                   	push   %esi
80103d49:	53                   	push   %ebx
80103d4a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d4d:	e8 be 06 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103d52:	e8 29 fb ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103d57:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d5d:	e8 fe 06 00 00       	call   80104460 <popcli>
  if(curproc == initproc)
80103d62:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d65:	8d 7e 68             	lea    0x68(%esi),%edi
80103d68:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d6e:	0f 84 f3 00 00 00    	je     80103e67 <exit+0x127>
80103d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103d78:	8b 03                	mov    (%ebx),%eax
80103d7a:	85 c0                	test   %eax,%eax
80103d7c:	74 12                	je     80103d90 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	50                   	push   %eax
80103d82:	e8 39 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103d87:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d8d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103d90:	83 c3 04             	add    $0x4,%ebx
80103d93:	39 df                	cmp    %ebx,%edi
80103d95:	75 e1                	jne    80103d78 <exit+0x38>
  begin_op();
80103d97:	e8 54 ef ff ff       	call   80102cf0 <begin_op>
  iput(curproc->cwd);
80103d9c:	83 ec 0c             	sub    $0xc,%esp
80103d9f:	ff 76 68             	pushl  0x68(%esi)
80103da2:	e8 a9 da ff ff       	call   80101850 <iput>
  end_op();
80103da7:	e8 b4 ef ff ff       	call   80102d60 <end_op>
  curproc->cwd = 0;
80103dac:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103db3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103dba:	e8 51 07 00 00       	call   80104510 <acquire>
  wakeup1(curproc->parent);
80103dbf:	8b 56 14             	mov    0x14(%esi),%edx
80103dc2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dca:	eb 0e                	jmp    80103dda <exit+0x9a>
80103dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103dd0:	83 c0 7c             	add    $0x7c,%eax
80103dd3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dd8:	74 1c                	je     80103df6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
80103dda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dde:	75 f0                	jne    80103dd0 <exit+0x90>
80103de0:	3b 50 20             	cmp    0x20(%eax),%edx
80103de3:	75 eb                	jne    80103dd0 <exit+0x90>
      p->state = RUNNABLE;
80103de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dec:	83 c0 7c             	add    $0x7c,%eax
80103def:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103df4:	75 e4                	jne    80103dda <exit+0x9a>
      p->parent = initproc;
80103df6:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dfc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e01:	eb 10                	jmp    80103e13 <exit+0xd3>
80103e03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e07:	90                   	nop
80103e08:	83 c2 7c             	add    $0x7c,%edx
80103e0b:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103e11:	74 3b                	je     80103e4e <exit+0x10e>
    if(p->parent == curproc){
80103e13:	39 72 14             	cmp    %esi,0x14(%edx)
80103e16:	75 f0                	jne    80103e08 <exit+0xc8>
      if(p->state == ZOMBIE)
80103e18:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e1c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e1f:	75 e7                	jne    80103e08 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e21:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e26:	eb 12                	jmp    80103e3a <exit+0xfa>
80103e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e2f:	90                   	nop
80103e30:	83 c0 7c             	add    $0x7c,%eax
80103e33:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103e38:	74 ce                	je     80103e08 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
80103e3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e3e:	75 f0                	jne    80103e30 <exit+0xf0>
80103e40:	3b 48 20             	cmp    0x20(%eax),%ecx
80103e43:	75 eb                	jne    80103e30 <exit+0xf0>
      p->state = RUNNABLE;
80103e45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e4c:	eb e2                	jmp    80103e30 <exit+0xf0>
  curproc->state = ZOMBIE;
80103e4e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e55:	e8 26 fe ff ff       	call   80103c80 <sched>
  panic("zombie exit");
80103e5a:	83 ec 0c             	sub    $0xc,%esp
80103e5d:	68 f4 75 10 80       	push   $0x801075f4
80103e62:	e8 29 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e67:	83 ec 0c             	sub    $0xc,%esp
80103e6a:	68 e7 75 10 80       	push   $0x801075e7
80103e6f:	e8 1c c5 ff ff       	call   80100390 <panic>
80103e74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e7f:	90                   	nop

80103e80 <yield>:
{
80103e80:	f3 0f 1e fb          	endbr32 
80103e84:	55                   	push   %ebp
80103e85:	89 e5                	mov    %esp,%ebp
80103e87:	53                   	push   %ebx
80103e88:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e8b:	68 20 2d 11 80       	push   $0x80112d20
80103e90:	e8 7b 06 00 00       	call   80104510 <acquire>
  pushcli();
80103e95:	e8 76 05 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103e9a:	e8 e1 f9 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103e9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ea5:	e8 b6 05 00 00       	call   80104460 <popcli>
  myproc()->state = RUNNABLE;
80103eaa:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103eb1:	e8 ca fd ff ff       	call   80103c80 <sched>
  release(&ptable.lock);
80103eb6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ebd:	e8 0e 07 00 00       	call   801045d0 <release>
}
80103ec2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ec5:	83 c4 10             	add    $0x10,%esp
80103ec8:	c9                   	leave  
80103ec9:	c3                   	ret    
80103eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ed0 <sleep>:
{
80103ed0:	f3 0f 1e fb          	endbr32 
80103ed4:	55                   	push   %ebp
80103ed5:	89 e5                	mov    %esp,%ebp
80103ed7:	57                   	push   %edi
80103ed8:	56                   	push   %esi
80103ed9:	53                   	push   %ebx
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ee0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103ee3:	e8 28 05 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103ee8:	e8 93 f9 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103eed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef3:	e8 68 05 00 00       	call   80104460 <popcli>
  if(p == 0)
80103ef8:	85 db                	test   %ebx,%ebx
80103efa:	0f 84 83 00 00 00    	je     80103f83 <sleep+0xb3>
  if(lk == 0)
80103f00:	85 f6                	test   %esi,%esi
80103f02:	74 72                	je     80103f76 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f04:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f0a:	74 4c                	je     80103f58 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f0c:	83 ec 0c             	sub    $0xc,%esp
80103f0f:	68 20 2d 11 80       	push   $0x80112d20
80103f14:	e8 f7 05 00 00       	call   80104510 <acquire>
    release(lk);
80103f19:	89 34 24             	mov    %esi,(%esp)
80103f1c:	e8 af 06 00 00       	call   801045d0 <release>
  p->chan = chan;
80103f21:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f24:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f2b:	e8 50 fd ff ff       	call   80103c80 <sched>
  p->chan = 0;
80103f30:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103f37:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f3e:	e8 8d 06 00 00       	call   801045d0 <release>
    acquire(lk);
80103f43:	89 75 08             	mov    %esi,0x8(%ebp)
80103f46:	83 c4 10             	add    $0x10,%esp
}
80103f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f4c:	5b                   	pop    %ebx
80103f4d:	5e                   	pop    %esi
80103f4e:	5f                   	pop    %edi
80103f4f:	5d                   	pop    %ebp
    acquire(lk);
80103f50:	e9 bb 05 00 00       	jmp    80104510 <acquire>
80103f55:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103f58:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f62:	e8 19 fd ff ff       	call   80103c80 <sched>
  p->chan = 0;
80103f67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f71:	5b                   	pop    %ebx
80103f72:	5e                   	pop    %esi
80103f73:	5f                   	pop    %edi
80103f74:	5d                   	pop    %ebp
80103f75:	c3                   	ret    
    panic("sleep without lk");
80103f76:	83 ec 0c             	sub    $0xc,%esp
80103f79:	68 06 76 10 80       	push   $0x80107606
80103f7e:	e8 0d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f83:	83 ec 0c             	sub    $0xc,%esp
80103f86:	68 00 76 10 80       	push   $0x80107600
80103f8b:	e8 00 c4 ff ff       	call   80100390 <panic>

80103f90 <wait>:
{
80103f90:	f3 0f 1e fb          	endbr32 
80103f94:	55                   	push   %ebp
80103f95:	89 e5                	mov    %esp,%ebp
80103f97:	56                   	push   %esi
80103f98:	53                   	push   %ebx
  pushcli();
80103f99:	e8 72 04 00 00       	call   80104410 <pushcli>
  c = mycpu();
80103f9e:	e8 dd f8 ff ff       	call   80103880 <mycpu>
  p = c->proc;
80103fa3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fa9:	e8 b2 04 00 00       	call   80104460 <popcli>
  acquire(&ptable.lock);
80103fae:	83 ec 0c             	sub    $0xc,%esp
80103fb1:	68 20 2d 11 80       	push   $0x80112d20
80103fb6:	e8 55 05 00 00       	call   80104510 <acquire>
80103fbb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fbe:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc0:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103fc5:	eb 14                	jmp    80103fdb <wait+0x4b>
80103fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fce:	66 90                	xchg   %ax,%ax
80103fd0:	83 c3 7c             	add    $0x7c,%ebx
80103fd3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103fd9:	74 1b                	je     80103ff6 <wait+0x66>
      if(p->parent != curproc)
80103fdb:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fde:	75 f0                	jne    80103fd0 <wait+0x40>
      if(p->state == ZOMBIE){
80103fe0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fe4:	74 32                	je     80104018 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fe9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fee:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103ff4:	75 e5                	jne    80103fdb <wait+0x4b>
    if(!havekids || curproc->killed){
80103ff6:	85 c0                	test   %eax,%eax
80103ff8:	74 74                	je     8010406e <wait+0xde>
80103ffa:	8b 46 24             	mov    0x24(%esi),%eax
80103ffd:	85 c0                	test   %eax,%eax
80103fff:	75 6d                	jne    8010406e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104001:	83 ec 08             	sub    $0x8,%esp
80104004:	68 20 2d 11 80       	push   $0x80112d20
80104009:	56                   	push   %esi
8010400a:	e8 c1 fe ff ff       	call   80103ed0 <sleep>
    havekids = 0;
8010400f:	83 c4 10             	add    $0x10,%esp
80104012:	eb aa                	jmp    80103fbe <wait+0x2e>
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104018:	83 ec 0c             	sub    $0xc,%esp
8010401b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010401e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104021:	e8 0a e4 ff ff       	call   80102430 <kfree>
        freevm(p->pgdir);
80104026:	5a                   	pop    %edx
80104027:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010402a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104031:	e8 4a 2d 00 00       	call   80106d80 <freevm>
        release(&ptable.lock);
80104036:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010403d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104044:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010404b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010404f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104056:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010405d:	e8 6e 05 00 00       	call   801045d0 <release>
        return pid;
80104062:	83 c4 10             	add    $0x10,%esp
}
80104065:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104068:	89 f0                	mov    %esi,%eax
8010406a:	5b                   	pop    %ebx
8010406b:	5e                   	pop    %esi
8010406c:	5d                   	pop    %ebp
8010406d:	c3                   	ret    
      release(&ptable.lock);
8010406e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104071:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104076:	68 20 2d 11 80       	push   $0x80112d20
8010407b:	e8 50 05 00 00       	call   801045d0 <release>
      return -1;
80104080:	83 c4 10             	add    $0x10,%esp
80104083:	eb e0                	jmp    80104065 <wait+0xd5>
80104085:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104090 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	53                   	push   %ebx
80104098:	83 ec 10             	sub    $0x10,%esp
8010409b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010409e:	68 20 2d 11 80       	push   $0x80112d20
801040a3:	e8 68 04 00 00       	call   80104510 <acquire>
801040a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ab:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040b0:	eb 10                	jmp    801040c2 <wakeup+0x32>
801040b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040b8:	83 c0 7c             	add    $0x7c,%eax
801040bb:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040c0:	74 1c                	je     801040de <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
801040c2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040c6:	75 f0                	jne    801040b8 <wakeup+0x28>
801040c8:	3b 58 20             	cmp    0x20(%eax),%ebx
801040cb:	75 eb                	jne    801040b8 <wakeup+0x28>
      p->state = RUNNABLE;
801040cd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040d4:	83 c0 7c             	add    $0x7c,%eax
801040d7:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040dc:	75 e4                	jne    801040c2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
801040de:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801040e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040e8:	c9                   	leave  
  release(&ptable.lock);
801040e9:	e9 e2 04 00 00       	jmp    801045d0 <release>
801040ee:	66 90                	xchg   %ax,%ax

801040f0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040f0:	f3 0f 1e fb          	endbr32 
801040f4:	55                   	push   %ebp
801040f5:	89 e5                	mov    %esp,%ebp
801040f7:	53                   	push   %ebx
801040f8:	83 ec 10             	sub    $0x10,%esp
801040fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040fe:	68 20 2d 11 80       	push   $0x80112d20
80104103:	e8 08 04 00 00       	call   80104510 <acquire>
80104108:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010410b:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104110:	eb 10                	jmp    80104122 <kill+0x32>
80104112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104118:	83 c0 7c             	add    $0x7c,%eax
8010411b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104120:	74 36                	je     80104158 <kill+0x68>
    if(p->pid == pid){
80104122:	39 58 10             	cmp    %ebx,0x10(%eax)
80104125:	75 f1                	jne    80104118 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104127:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010412b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104132:	75 07                	jne    8010413b <kill+0x4b>
        p->state = RUNNABLE;
80104134:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010413b:	83 ec 0c             	sub    $0xc,%esp
8010413e:	68 20 2d 11 80       	push   $0x80112d20
80104143:	e8 88 04 00 00       	call   801045d0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104148:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010414b:	83 c4 10             	add    $0x10,%esp
8010414e:	31 c0                	xor    %eax,%eax
}
80104150:	c9                   	leave  
80104151:	c3                   	ret    
80104152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 20 2d 11 80       	push   $0x80112d20
80104160:	e8 6b 04 00 00       	call   801045d0 <release>
}
80104165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104168:	83 c4 10             	add    $0x10,%esp
8010416b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104170:	c9                   	leave  
80104171:	c3                   	ret    
80104172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104180 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104180:	f3 0f 1e fb          	endbr32 
80104184:	55                   	push   %ebp
80104185:	89 e5                	mov    %esp,%ebp
80104187:	57                   	push   %edi
80104188:	56                   	push   %esi
80104189:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010418c:	53                   	push   %ebx
8010418d:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104192:	83 ec 3c             	sub    $0x3c,%esp
80104195:	eb 28                	jmp    801041bf <procdump+0x3f>
80104197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010419e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	68 98 79 10 80       	push   $0x80107998
801041a8:	e8 03 c5 ff ff       	call   801006b0 <cprintf>
801041ad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041b0:	83 c3 7c             	add    $0x7c,%ebx
801041b3:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
801041b9:	0f 84 81 00 00 00    	je     80104240 <procdump+0xc0>
    if(p->state == UNUSED)
801041bf:	8b 43 a0             	mov    -0x60(%ebx),%eax
801041c2:	85 c0                	test   %eax,%eax
801041c4:	74 ea                	je     801041b0 <procdump+0x30>
      state = "???";
801041c6:	ba 17 76 10 80       	mov    $0x80107617,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041cb:	83 f8 05             	cmp    $0x5,%eax
801041ce:	77 11                	ja     801041e1 <procdump+0x61>
801041d0:	8b 14 85 78 76 10 80 	mov    -0x7fef8988(,%eax,4),%edx
      state = "???";
801041d7:	b8 17 76 10 80       	mov    $0x80107617,%eax
801041dc:	85 d2                	test   %edx,%edx
801041de:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801041e1:	53                   	push   %ebx
801041e2:	52                   	push   %edx
801041e3:	ff 73 a4             	pushl  -0x5c(%ebx)
801041e6:	68 1b 76 10 80       	push   $0x8010761b
801041eb:	e8 c0 c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801041f7:	75 a7                	jne    801041a0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801041f9:	83 ec 08             	sub    $0x8,%esp
801041fc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801041ff:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104202:	50                   	push   %eax
80104203:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104206:	8b 40 0c             	mov    0xc(%eax),%eax
80104209:	83 c0 08             	add    $0x8,%eax
8010420c:	50                   	push   %eax
8010420d:	e8 9e 01 00 00       	call   801043b0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104212:	83 c4 10             	add    $0x10,%esp
80104215:	8d 76 00             	lea    0x0(%esi),%esi
80104218:	8b 17                	mov    (%edi),%edx
8010421a:	85 d2                	test   %edx,%edx
8010421c:	74 82                	je     801041a0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010421e:	83 ec 08             	sub    $0x8,%esp
80104221:	83 c7 04             	add    $0x4,%edi
80104224:	52                   	push   %edx
80104225:	68 e1 70 10 80       	push   $0x801070e1
8010422a:	e8 81 c4 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010422f:	83 c4 10             	add    $0x10,%esp
80104232:	39 fe                	cmp    %edi,%esi
80104234:	75 e2                	jne    80104218 <procdump+0x98>
80104236:	e9 65 ff ff ff       	jmp    801041a0 <procdump+0x20>
8010423b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010423f:	90                   	nop
  }
}
80104240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104243:	5b                   	pop    %ebx
80104244:	5e                   	pop    %esi
80104245:	5f                   	pop    %edi
80104246:	5d                   	pop    %ebp
80104247:	c3                   	ret    
80104248:	66 90                	xchg   %ax,%ax
8010424a:	66 90                	xchg   %ax,%ax
8010424c:	66 90                	xchg   %ax,%ax
8010424e:	66 90                	xchg   %ax,%ax

80104250 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104250:	f3 0f 1e fb          	endbr32 
80104254:	55                   	push   %ebp
80104255:	89 e5                	mov    %esp,%ebp
80104257:	53                   	push   %ebx
80104258:	83 ec 0c             	sub    $0xc,%esp
8010425b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010425e:	68 90 76 10 80       	push   $0x80107690
80104263:	8d 43 04             	lea    0x4(%ebx),%eax
80104266:	50                   	push   %eax
80104267:	e8 24 01 00 00       	call   80104390 <initlock>
  lk->name = name;
8010426c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010426f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104275:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104278:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010427f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104285:	c9                   	leave  
80104286:	c3                   	ret    
80104287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010428e:	66 90                	xchg   %ax,%ax

80104290 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104290:	f3 0f 1e fb          	endbr32 
80104294:	55                   	push   %ebp
80104295:	89 e5                	mov    %esp,%ebp
80104297:	56                   	push   %esi
80104298:	53                   	push   %ebx
80104299:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010429c:	8d 73 04             	lea    0x4(%ebx),%esi
8010429f:	83 ec 0c             	sub    $0xc,%esp
801042a2:	56                   	push   %esi
801042a3:	e8 68 02 00 00       	call   80104510 <acquire>
  while (lk->locked) {
801042a8:	8b 13                	mov    (%ebx),%edx
801042aa:	83 c4 10             	add    $0x10,%esp
801042ad:	85 d2                	test   %edx,%edx
801042af:	74 1a                	je     801042cb <acquiresleep+0x3b>
801042b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801042b8:	83 ec 08             	sub    $0x8,%esp
801042bb:	56                   	push   %esi
801042bc:	53                   	push   %ebx
801042bd:	e8 0e fc ff ff       	call   80103ed0 <sleep>
  while (lk->locked) {
801042c2:	8b 03                	mov    (%ebx),%eax
801042c4:	83 c4 10             	add    $0x10,%esp
801042c7:	85 c0                	test   %eax,%eax
801042c9:	75 ed                	jne    801042b8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801042cb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801042d1:	e8 3a f6 ff ff       	call   80103910 <myproc>
801042d6:	8b 40 10             	mov    0x10(%eax),%eax
801042d9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801042dc:	89 75 08             	mov    %esi,0x8(%ebp)
}
801042df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e2:	5b                   	pop    %ebx
801042e3:	5e                   	pop    %esi
801042e4:	5d                   	pop    %ebp
  release(&lk->lk);
801042e5:	e9 e6 02 00 00       	jmp    801045d0 <release>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042f0:	f3 0f 1e fb          	endbr32 
801042f4:	55                   	push   %ebp
801042f5:	89 e5                	mov    %esp,%ebp
801042f7:	56                   	push   %esi
801042f8:	53                   	push   %ebx
801042f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042fc:	8d 73 04             	lea    0x4(%ebx),%esi
801042ff:	83 ec 0c             	sub    $0xc,%esp
80104302:	56                   	push   %esi
80104303:	e8 08 02 00 00       	call   80104510 <acquire>
  lk->locked = 0;
80104308:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010430e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104315:	89 1c 24             	mov    %ebx,(%esp)
80104318:	e8 73 fd ff ff       	call   80104090 <wakeup>
  release(&lk->lk);
8010431d:	89 75 08             	mov    %esi,0x8(%ebp)
80104320:	83 c4 10             	add    $0x10,%esp
}
80104323:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104326:	5b                   	pop    %ebx
80104327:	5e                   	pop    %esi
80104328:	5d                   	pop    %ebp
  release(&lk->lk);
80104329:	e9 a2 02 00 00       	jmp    801045d0 <release>
8010432e:	66 90                	xchg   %ax,%ax

80104330 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	57                   	push   %edi
80104338:	31 ff                	xor    %edi,%edi
8010433a:	56                   	push   %esi
8010433b:	53                   	push   %ebx
8010433c:	83 ec 18             	sub    $0x18,%esp
8010433f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104342:	8d 73 04             	lea    0x4(%ebx),%esi
80104345:	56                   	push   %esi
80104346:	e8 c5 01 00 00       	call   80104510 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010434b:	8b 03                	mov    (%ebx),%eax
8010434d:	83 c4 10             	add    $0x10,%esp
80104350:	85 c0                	test   %eax,%eax
80104352:	75 1c                	jne    80104370 <holdingsleep+0x40>
  release(&lk->lk);
80104354:	83 ec 0c             	sub    $0xc,%esp
80104357:	56                   	push   %esi
80104358:	e8 73 02 00 00       	call   801045d0 <release>
  return r;
}
8010435d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104360:	89 f8                	mov    %edi,%eax
80104362:	5b                   	pop    %ebx
80104363:	5e                   	pop    %esi
80104364:	5f                   	pop    %edi
80104365:	5d                   	pop    %ebp
80104366:	c3                   	ret    
80104367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104370:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104373:	e8 98 f5 ff ff       	call   80103910 <myproc>
80104378:	39 58 10             	cmp    %ebx,0x10(%eax)
8010437b:	0f 94 c0             	sete   %al
8010437e:	0f b6 c0             	movzbl %al,%eax
80104381:	89 c7                	mov    %eax,%edi
80104383:	eb cf                	jmp    80104354 <holdingsleep+0x24>
80104385:	66 90                	xchg   %ax,%ax
80104387:	66 90                	xchg   %ax,%ax
80104389:	66 90                	xchg   %ax,%ax
8010438b:	66 90                	xchg   %ax,%ax
8010438d:	66 90                	xchg   %ax,%ax
8010438f:	90                   	nop

80104390 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104390:	f3 0f 1e fb          	endbr32 
80104394:	55                   	push   %ebp
80104395:	89 e5                	mov    %esp,%ebp
80104397:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010439a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010439d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801043a3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801043a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801043ad:	5d                   	pop    %ebp
801043ae:	c3                   	ret    
801043af:	90                   	nop

801043b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801043b0:	f3 0f 1e fb          	endbr32 
801043b4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043b5:	31 d2                	xor    %edx,%edx
{
801043b7:	89 e5                	mov    %esp,%ebp
801043b9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801043ba:	8b 45 08             	mov    0x8(%ebp),%eax
{
801043bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801043c0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801043c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043c8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801043ce:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043d4:	77 1a                	ja     801043f0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043d6:	8b 58 04             	mov    0x4(%eax),%ebx
801043d9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801043dc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801043df:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801043e1:	83 fa 0a             	cmp    $0xa,%edx
801043e4:	75 e2                	jne    801043c8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043e6:	5b                   	pop    %ebx
801043e7:	5d                   	pop    %ebp
801043e8:	c3                   	ret    
801043e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801043f0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801043f3:	8d 51 28             	lea    0x28(%ecx),%edx
801043f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104406:	83 c0 04             	add    $0x4,%eax
80104409:	39 d0                	cmp    %edx,%eax
8010440b:	75 f3                	jne    80104400 <getcallerpcs+0x50>
}
8010440d:	5b                   	pop    %ebx
8010440e:	5d                   	pop    %ebp
8010440f:	c3                   	ret    

80104410 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	53                   	push   %ebx
80104418:	83 ec 04             	sub    $0x4,%esp
8010441b:	9c                   	pushf  
8010441c:	5b                   	pop    %ebx
  asm volatile("cli");
8010441d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010441e:	e8 5d f4 ff ff       	call   80103880 <mycpu>
80104423:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104429:	85 c0                	test   %eax,%eax
8010442b:	74 13                	je     80104440 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010442d:	e8 4e f4 ff ff       	call   80103880 <mycpu>
80104432:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104439:	83 c4 04             	add    $0x4,%esp
8010443c:	5b                   	pop    %ebx
8010443d:	5d                   	pop    %ebp
8010443e:	c3                   	ret    
8010443f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104440:	e8 3b f4 ff ff       	call   80103880 <mycpu>
80104445:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010444b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104451:	eb da                	jmp    8010442d <pushcli+0x1d>
80104453:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010445a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104460 <popcli>:

void
popcli(void)
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
80104465:	89 e5                	mov    %esp,%ebp
80104467:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010446a:	9c                   	pushf  
8010446b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010446c:	f6 c4 02             	test   $0x2,%ah
8010446f:	75 31                	jne    801044a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104471:	e8 0a f4 ff ff       	call   80103880 <mycpu>
80104476:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010447d:	78 30                	js     801044af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010447f:	e8 fc f3 ff ff       	call   80103880 <mycpu>
80104484:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010448a:	85 d2                	test   %edx,%edx
8010448c:	74 02                	je     80104490 <popcli+0x30>
    sti();
}
8010448e:	c9                   	leave  
8010448f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104490:	e8 eb f3 ff ff       	call   80103880 <mycpu>
80104495:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010449b:	85 c0                	test   %eax,%eax
8010449d:	74 ef                	je     8010448e <popcli+0x2e>
  asm volatile("sti");
8010449f:	fb                   	sti    
}
801044a0:	c9                   	leave  
801044a1:	c3                   	ret    
    panic("popcli - interruptible");
801044a2:	83 ec 0c             	sub    $0xc,%esp
801044a5:	68 9b 76 10 80       	push   $0x8010769b
801044aa:	e8 e1 be ff ff       	call   80100390 <panic>
    panic("popcli");
801044af:	83 ec 0c             	sub    $0xc,%esp
801044b2:	68 b2 76 10 80       	push   $0x801076b2
801044b7:	e8 d4 be ff ff       	call   80100390 <panic>
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044c0 <holding>:
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	56                   	push   %esi
801044c8:	53                   	push   %ebx
801044c9:	8b 75 08             	mov    0x8(%ebp),%esi
801044cc:	31 db                	xor    %ebx,%ebx
  pushcli();
801044ce:	e8 3d ff ff ff       	call   80104410 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801044d3:	8b 06                	mov    (%esi),%eax
801044d5:	85 c0                	test   %eax,%eax
801044d7:	75 0f                	jne    801044e8 <holding+0x28>
  popcli();
801044d9:	e8 82 ff ff ff       	call   80104460 <popcli>
}
801044de:	89 d8                	mov    %ebx,%eax
801044e0:	5b                   	pop    %ebx
801044e1:	5e                   	pop    %esi
801044e2:	5d                   	pop    %ebp
801044e3:	c3                   	ret    
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
801044e8:	8b 5e 08             	mov    0x8(%esi),%ebx
801044eb:	e8 90 f3 ff ff       	call   80103880 <mycpu>
801044f0:	39 c3                	cmp    %eax,%ebx
801044f2:	0f 94 c3             	sete   %bl
  popcli();
801044f5:	e8 66 ff ff ff       	call   80104460 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801044fa:	0f b6 db             	movzbl %bl,%ebx
}
801044fd:	89 d8                	mov    %ebx,%eax
801044ff:	5b                   	pop    %ebx
80104500:	5e                   	pop    %esi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <acquire>:
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	56                   	push   %esi
80104518:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104519:	e8 f2 fe ff ff       	call   80104410 <pushcli>
  if(holding(lk))
8010451e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	53                   	push   %ebx
80104525:	e8 96 ff ff ff       	call   801044c0 <holding>
8010452a:	83 c4 10             	add    $0x10,%esp
8010452d:	85 c0                	test   %eax,%eax
8010452f:	0f 85 7f 00 00 00    	jne    801045b4 <acquire+0xa4>
80104535:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104537:	ba 01 00 00 00       	mov    $0x1,%edx
8010453c:	eb 05                	jmp    80104543 <acquire+0x33>
8010453e:	66 90                	xchg   %ax,%ax
80104540:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104543:	89 d0                	mov    %edx,%eax
80104545:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104548:	85 c0                	test   %eax,%eax
8010454a:	75 f4                	jne    80104540 <acquire+0x30>
  __sync_synchronize();
8010454c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104551:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104554:	e8 27 f3 ff ff       	call   80103880 <mycpu>
80104559:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010455c:	89 e8                	mov    %ebp,%eax
8010455e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104560:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104566:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010456c:	77 22                	ja     80104590 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010456e:	8b 50 04             	mov    0x4(%eax),%edx
80104571:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104575:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104578:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010457a:	83 fe 0a             	cmp    $0xa,%esi
8010457d:	75 e1                	jne    80104560 <acquire+0x50>
}
8010457f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104582:	5b                   	pop    %ebx
80104583:	5e                   	pop    %esi
80104584:	5d                   	pop    %ebp
80104585:	c3                   	ret    
80104586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104590:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104594:	83 c3 34             	add    $0x34,%ebx
80104597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801045a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801045a6:	83 c0 04             	add    $0x4,%eax
801045a9:	39 d8                	cmp    %ebx,%eax
801045ab:	75 f3                	jne    801045a0 <acquire+0x90>
}
801045ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045b0:	5b                   	pop    %ebx
801045b1:	5e                   	pop    %esi
801045b2:	5d                   	pop    %ebp
801045b3:	c3                   	ret    
    panic("acquire");
801045b4:	83 ec 0c             	sub    $0xc,%esp
801045b7:	68 b9 76 10 80       	push   $0x801076b9
801045bc:	e8 cf bd ff ff       	call   80100390 <panic>
801045c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop

801045d0 <release>:
{
801045d0:	f3 0f 1e fb          	endbr32 
801045d4:	55                   	push   %ebp
801045d5:	89 e5                	mov    %esp,%ebp
801045d7:	53                   	push   %ebx
801045d8:	83 ec 10             	sub    $0x10,%esp
801045db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801045de:	53                   	push   %ebx
801045df:	e8 dc fe ff ff       	call   801044c0 <holding>
801045e4:	83 c4 10             	add    $0x10,%esp
801045e7:	85 c0                	test   %eax,%eax
801045e9:	74 22                	je     8010460d <release+0x3d>
  lk->pcs[0] = 0;
801045eb:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801045f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801045f9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801045fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104604:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104607:	c9                   	leave  
  popcli();
80104608:	e9 53 fe ff ff       	jmp    80104460 <popcli>
    panic("release");
8010460d:	83 ec 0c             	sub    $0xc,%esp
80104610:	68 c1 76 10 80       	push   $0x801076c1
80104615:	e8 76 bd ff ff       	call   80100390 <panic>
8010461a:	66 90                	xchg   %ax,%ax
8010461c:	66 90                	xchg   %ax,%ax
8010461e:	66 90                	xchg   %ax,%ax

80104620 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104620:	f3 0f 1e fb          	endbr32 
80104624:	55                   	push   %ebp
80104625:	89 e5                	mov    %esp,%ebp
80104627:	57                   	push   %edi
80104628:	8b 55 08             	mov    0x8(%ebp),%edx
8010462b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010462e:	53                   	push   %ebx
8010462f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104632:	89 d7                	mov    %edx,%edi
80104634:	09 cf                	or     %ecx,%edi
80104636:	83 e7 03             	and    $0x3,%edi
80104639:	75 25                	jne    80104660 <memset+0x40>
    c &= 0xFF;
8010463b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010463e:	c1 e0 18             	shl    $0x18,%eax
80104641:	89 fb                	mov    %edi,%ebx
80104643:	c1 e9 02             	shr    $0x2,%ecx
80104646:	c1 e3 10             	shl    $0x10,%ebx
80104649:	09 d8                	or     %ebx,%eax
8010464b:	09 f8                	or     %edi,%eax
8010464d:	c1 e7 08             	shl    $0x8,%edi
80104650:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104652:	89 d7                	mov    %edx,%edi
80104654:	fc                   	cld    
80104655:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104657:	5b                   	pop    %ebx
80104658:	89 d0                	mov    %edx,%eax
8010465a:	5f                   	pop    %edi
8010465b:	5d                   	pop    %ebp
8010465c:	c3                   	ret    
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104660:	89 d7                	mov    %edx,%edi
80104662:	fc                   	cld    
80104663:	f3 aa                	rep stos %al,%es:(%edi)
80104665:	5b                   	pop    %ebx
80104666:	89 d0                	mov    %edx,%eax
80104668:	5f                   	pop    %edi
80104669:	5d                   	pop    %ebp
8010466a:	c3                   	ret    
8010466b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010466f:	90                   	nop

80104670 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104670:	f3 0f 1e fb          	endbr32 
80104674:	55                   	push   %ebp
80104675:	89 e5                	mov    %esp,%ebp
80104677:	56                   	push   %esi
80104678:	8b 75 10             	mov    0x10(%ebp),%esi
8010467b:	8b 55 08             	mov    0x8(%ebp),%edx
8010467e:	53                   	push   %ebx
8010467f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104682:	85 f6                	test   %esi,%esi
80104684:	74 2a                	je     801046b0 <memcmp+0x40>
80104686:	01 c6                	add    %eax,%esi
80104688:	eb 10                	jmp    8010469a <memcmp+0x2a>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104690:	83 c0 01             	add    $0x1,%eax
80104693:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104696:	39 f0                	cmp    %esi,%eax
80104698:	74 16                	je     801046b0 <memcmp+0x40>
    if(*s1 != *s2)
8010469a:	0f b6 0a             	movzbl (%edx),%ecx
8010469d:	0f b6 18             	movzbl (%eax),%ebx
801046a0:	38 d9                	cmp    %bl,%cl
801046a2:	74 ec                	je     80104690 <memcmp+0x20>
      return *s1 - *s2;
801046a4:	0f b6 c1             	movzbl %cl,%eax
801046a7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801046a9:	5b                   	pop    %ebx
801046aa:	5e                   	pop    %esi
801046ab:	5d                   	pop    %ebp
801046ac:	c3                   	ret    
801046ad:	8d 76 00             	lea    0x0(%esi),%esi
801046b0:	5b                   	pop    %ebx
  return 0;
801046b1:	31 c0                	xor    %eax,%eax
}
801046b3:	5e                   	pop    %esi
801046b4:	5d                   	pop    %ebp
801046b5:	c3                   	ret    
801046b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046bd:	8d 76 00             	lea    0x0(%esi),%esi

801046c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801046c0:	f3 0f 1e fb          	endbr32 
801046c4:	55                   	push   %ebp
801046c5:	89 e5                	mov    %esp,%ebp
801046c7:	57                   	push   %edi
801046c8:	8b 55 08             	mov    0x8(%ebp),%edx
801046cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046ce:	56                   	push   %esi
801046cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801046d2:	39 d6                	cmp    %edx,%esi
801046d4:	73 2a                	jae    80104700 <memmove+0x40>
801046d6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801046d9:	39 fa                	cmp    %edi,%edx
801046db:	73 23                	jae    80104700 <memmove+0x40>
801046dd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801046e0:	85 c9                	test   %ecx,%ecx
801046e2:	74 13                	je     801046f7 <memmove+0x37>
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801046e8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801046ec:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801046ef:	83 e8 01             	sub    $0x1,%eax
801046f2:	83 f8 ff             	cmp    $0xffffffff,%eax
801046f5:	75 f1                	jne    801046e8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801046f7:	5e                   	pop    %esi
801046f8:	89 d0                	mov    %edx,%eax
801046fa:	5f                   	pop    %edi
801046fb:	5d                   	pop    %ebp
801046fc:	c3                   	ret    
801046fd:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104700:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104703:	89 d7                	mov    %edx,%edi
80104705:	85 c9                	test   %ecx,%ecx
80104707:	74 ee                	je     801046f7 <memmove+0x37>
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104710:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104711:	39 f0                	cmp    %esi,%eax
80104713:	75 fb                	jne    80104710 <memmove+0x50>
}
80104715:	5e                   	pop    %esi
80104716:	89 d0                	mov    %edx,%eax
80104718:	5f                   	pop    %edi
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop

80104720 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104720:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104724:	eb 9a                	jmp    801046c0 <memmove>
80104726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010472d:	8d 76 00             	lea    0x0(%esi),%esi

80104730 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104730:	f3 0f 1e fb          	endbr32 
80104734:	55                   	push   %ebp
80104735:	89 e5                	mov    %esp,%ebp
80104737:	56                   	push   %esi
80104738:	8b 75 10             	mov    0x10(%ebp),%esi
8010473b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010473e:	53                   	push   %ebx
8010473f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104742:	85 f6                	test   %esi,%esi
80104744:	74 32                	je     80104778 <strncmp+0x48>
80104746:	01 c6                	add    %eax,%esi
80104748:	eb 14                	jmp    8010475e <strncmp+0x2e>
8010474a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104750:	38 da                	cmp    %bl,%dl
80104752:	75 14                	jne    80104768 <strncmp+0x38>
    n--, p++, q++;
80104754:	83 c0 01             	add    $0x1,%eax
80104757:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010475a:	39 f0                	cmp    %esi,%eax
8010475c:	74 1a                	je     80104778 <strncmp+0x48>
8010475e:	0f b6 11             	movzbl (%ecx),%edx
80104761:	0f b6 18             	movzbl (%eax),%ebx
80104764:	84 d2                	test   %dl,%dl
80104766:	75 e8                	jne    80104750 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104768:	0f b6 c2             	movzbl %dl,%eax
8010476b:	29 d8                	sub    %ebx,%eax
}
8010476d:	5b                   	pop    %ebx
8010476e:	5e                   	pop    %esi
8010476f:	5d                   	pop    %ebp
80104770:	c3                   	ret    
80104771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104778:	5b                   	pop    %ebx
    return 0;
80104779:	31 c0                	xor    %eax,%eax
}
8010477b:	5e                   	pop    %esi
8010477c:	5d                   	pop    %ebp
8010477d:	c3                   	ret    
8010477e:	66 90                	xchg   %ax,%ax

80104780 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104780:	f3 0f 1e fb          	endbr32 
80104784:	55                   	push   %ebp
80104785:	89 e5                	mov    %esp,%ebp
80104787:	57                   	push   %edi
80104788:	56                   	push   %esi
80104789:	8b 75 08             	mov    0x8(%ebp),%esi
8010478c:	53                   	push   %ebx
8010478d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104790:	89 f2                	mov    %esi,%edx
80104792:	eb 1b                	jmp    801047af <strncpy+0x2f>
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104798:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010479c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010479f:	83 c2 01             	add    $0x1,%edx
801047a2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801047a6:	89 f9                	mov    %edi,%ecx
801047a8:	88 4a ff             	mov    %cl,-0x1(%edx)
801047ab:	84 c9                	test   %cl,%cl
801047ad:	74 09                	je     801047b8 <strncpy+0x38>
801047af:	89 c3                	mov    %eax,%ebx
801047b1:	83 e8 01             	sub    $0x1,%eax
801047b4:	85 db                	test   %ebx,%ebx
801047b6:	7f e0                	jg     80104798 <strncpy+0x18>
    ;
  while(n-- > 0)
801047b8:	89 d1                	mov    %edx,%ecx
801047ba:	85 c0                	test   %eax,%eax
801047bc:	7e 15                	jle    801047d3 <strncpy+0x53>
801047be:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801047c0:	83 c1 01             	add    $0x1,%ecx
801047c3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801047c7:	89 c8                	mov    %ecx,%eax
801047c9:	f7 d0                	not    %eax
801047cb:	01 d0                	add    %edx,%eax
801047cd:	01 d8                	add    %ebx,%eax
801047cf:	85 c0                	test   %eax,%eax
801047d1:	7f ed                	jg     801047c0 <strncpy+0x40>
  return os;
}
801047d3:	5b                   	pop    %ebx
801047d4:	89 f0                	mov    %esi,%eax
801047d6:	5e                   	pop    %esi
801047d7:	5f                   	pop    %edi
801047d8:	5d                   	pop    %ebp
801047d9:	c3                   	ret    
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	8b 55 10             	mov    0x10(%ebp),%edx
801047eb:	8b 75 08             	mov    0x8(%ebp),%esi
801047ee:	53                   	push   %ebx
801047ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801047f2:	85 d2                	test   %edx,%edx
801047f4:	7e 21                	jle    80104817 <safestrcpy+0x37>
801047f6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801047fa:	89 f2                	mov    %esi,%edx
801047fc:	eb 12                	jmp    80104810 <safestrcpy+0x30>
801047fe:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104800:	0f b6 08             	movzbl (%eax),%ecx
80104803:	83 c0 01             	add    $0x1,%eax
80104806:	83 c2 01             	add    $0x1,%edx
80104809:	88 4a ff             	mov    %cl,-0x1(%edx)
8010480c:	84 c9                	test   %cl,%cl
8010480e:	74 04                	je     80104814 <safestrcpy+0x34>
80104810:	39 d8                	cmp    %ebx,%eax
80104812:	75 ec                	jne    80104800 <safestrcpy+0x20>
    ;
  *s = 0;
80104814:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104817:	89 f0                	mov    %esi,%eax
80104819:	5b                   	pop    %ebx
8010481a:	5e                   	pop    %esi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi

80104820 <strlen>:

int
strlen(const char *s)
{
80104820:	f3 0f 1e fb          	endbr32 
80104824:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104825:	31 c0                	xor    %eax,%eax
{
80104827:	89 e5                	mov    %esp,%ebp
80104829:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010482c:	80 3a 00             	cmpb   $0x0,(%edx)
8010482f:	74 10                	je     80104841 <strlen+0x21>
80104831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104838:	83 c0 01             	add    $0x1,%eax
8010483b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010483f:	75 f7                	jne    80104838 <strlen+0x18>
    ;
  return n;
}
80104841:	5d                   	pop    %ebp
80104842:	c3                   	ret    

80104843 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104843:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104847:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010484b:	55                   	push   %ebp
  pushl %ebx
8010484c:	53                   	push   %ebx
  pushl %esi
8010484d:	56                   	push   %esi
  pushl %edi
8010484e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010484f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104851:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104853:	5f                   	pop    %edi
  popl %esi
80104854:	5e                   	pop    %esi
  popl %ebx
80104855:	5b                   	pop    %ebx
  popl %ebp
80104856:	5d                   	pop    %ebp
  ret
80104857:	c3                   	ret    
80104858:	66 90                	xchg   %ax,%ax
8010485a:	66 90                	xchg   %ax,%ax
8010485c:	66 90                	xchg   %ax,%ax
8010485e:	66 90                	xchg   %ax,%ax

80104860 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104860:	f3 0f 1e fb          	endbr32 
80104864:	55                   	push   %ebp
80104865:	89 e5                	mov    %esp,%ebp
80104867:	53                   	push   %ebx
80104868:	83 ec 04             	sub    $0x4,%esp
8010486b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010486e:	e8 9d f0 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104873:	8b 00                	mov    (%eax),%eax
80104875:	39 d8                	cmp    %ebx,%eax
80104877:	76 17                	jbe    80104890 <fetchint+0x30>
80104879:	8d 53 04             	lea    0x4(%ebx),%edx
8010487c:	39 d0                	cmp    %edx,%eax
8010487e:	72 10                	jb     80104890 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104880:	8b 45 0c             	mov    0xc(%ebp),%eax
80104883:	8b 13                	mov    (%ebx),%edx
80104885:	89 10                	mov    %edx,(%eax)
  return 0;
80104887:	31 c0                	xor    %eax,%eax
}
80104889:	83 c4 04             	add    $0x4,%esp
8010488c:	5b                   	pop    %ebx
8010488d:	5d                   	pop    %ebp
8010488e:	c3                   	ret    
8010488f:	90                   	nop
    return -1;
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104895:	eb f2                	jmp    80104889 <fetchint+0x29>
80104897:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010489e:	66 90                	xchg   %ax,%ax

801048a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	53                   	push   %ebx
801048a8:	83 ec 04             	sub    $0x4,%esp
801048ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801048ae:	e8 5d f0 ff ff       	call   80103910 <myproc>

  if(addr >= curproc->sz)
801048b3:	39 18                	cmp    %ebx,(%eax)
801048b5:	76 31                	jbe    801048e8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801048b7:	8b 55 0c             	mov    0xc(%ebp),%edx
801048ba:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801048bc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801048be:	39 d3                	cmp    %edx,%ebx
801048c0:	73 26                	jae    801048e8 <fetchstr+0x48>
801048c2:	89 d8                	mov    %ebx,%eax
801048c4:	eb 11                	jmp    801048d7 <fetchstr+0x37>
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
801048d0:	83 c0 01             	add    $0x1,%eax
801048d3:	39 c2                	cmp    %eax,%edx
801048d5:	76 11                	jbe    801048e8 <fetchstr+0x48>
    if(*s == 0)
801048d7:	80 38 00             	cmpb   $0x0,(%eax)
801048da:	75 f4                	jne    801048d0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801048dc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801048df:	29 d8                	sub    %ebx,%eax
}
801048e1:	5b                   	pop    %ebx
801048e2:	5d                   	pop    %ebp
801048e3:	c3                   	ret    
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e8:	83 c4 04             	add    $0x4,%esp
    return -1;
801048eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048f0:	5b                   	pop    %ebx
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104900 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104900:	f3 0f 1e fb          	endbr32 
80104904:	55                   	push   %ebp
80104905:	89 e5                	mov    %esp,%ebp
80104907:	56                   	push   %esi
80104908:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104909:	e8 02 f0 ff ff       	call   80103910 <myproc>
8010490e:	8b 55 08             	mov    0x8(%ebp),%edx
80104911:	8b 40 18             	mov    0x18(%eax),%eax
80104914:	8b 40 44             	mov    0x44(%eax),%eax
80104917:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010491a:	e8 f1 ef ff ff       	call   80103910 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010491f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104922:	8b 00                	mov    (%eax),%eax
80104924:	39 c6                	cmp    %eax,%esi
80104926:	73 18                	jae    80104940 <argint+0x40>
80104928:	8d 53 08             	lea    0x8(%ebx),%edx
8010492b:	39 d0                	cmp    %edx,%eax
8010492d:	72 11                	jb     80104940 <argint+0x40>
  *ip = *(int*)(addr);
8010492f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104932:	8b 53 04             	mov    0x4(%ebx),%edx
80104935:	89 10                	mov    %edx,(%eax)
  return 0;
80104937:	31 c0                	xor    %eax,%eax
}
80104939:	5b                   	pop    %ebx
8010493a:	5e                   	pop    %esi
8010493b:	5d                   	pop    %ebp
8010493c:	c3                   	ret    
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104945:	eb f2                	jmp    80104939 <argint+0x39>
80104947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494e:	66 90                	xchg   %ax,%ax

80104950 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	56                   	push   %esi
80104958:	53                   	push   %ebx
80104959:	83 ec 10             	sub    $0x10,%esp
8010495c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010495f:	e8 ac ef ff ff       	call   80103910 <myproc>
 
  if(argint(n, &i) < 0)
80104964:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104967:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104969:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010496c:	50                   	push   %eax
8010496d:	ff 75 08             	pushl  0x8(%ebp)
80104970:	e8 8b ff ff ff       	call   80104900 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104975:	83 c4 10             	add    $0x10,%esp
80104978:	85 c0                	test   %eax,%eax
8010497a:	78 24                	js     801049a0 <argptr+0x50>
8010497c:	85 db                	test   %ebx,%ebx
8010497e:	78 20                	js     801049a0 <argptr+0x50>
80104980:	8b 16                	mov    (%esi),%edx
80104982:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104985:	39 c2                	cmp    %eax,%edx
80104987:	76 17                	jbe    801049a0 <argptr+0x50>
80104989:	01 c3                	add    %eax,%ebx
8010498b:	39 da                	cmp    %ebx,%edx
8010498d:	72 11                	jb     801049a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010498f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104992:	89 02                	mov    %eax,(%edx)
  return 0;
80104994:	31 c0                	xor    %eax,%eax
}
80104996:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104999:	5b                   	pop    %ebx
8010499a:	5e                   	pop    %esi
8010499b:	5d                   	pop    %ebp
8010499c:	c3                   	ret    
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049a5:	eb ef                	jmp    80104996 <argptr+0x46>
801049a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801049ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049bd:	50                   	push   %eax
801049be:	ff 75 08             	pushl  0x8(%ebp)
801049c1:	e8 3a ff ff ff       	call   80104900 <argint>
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	85 c0                	test   %eax,%eax
801049cb:	78 13                	js     801049e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801049cd:	83 ec 08             	sub    $0x8,%esp
801049d0:	ff 75 0c             	pushl  0xc(%ebp)
801049d3:	ff 75 f4             	pushl  -0xc(%ebp)
801049d6:	e8 c5 fe ff ff       	call   801048a0 <fetchstr>
801049db:	83 c4 10             	add    $0x10,%esp
}
801049de:	c9                   	leave  
801049df:	c3                   	ret    
801049e0:	c9                   	leave  
    return -1;
801049e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e6:	c3                   	ret    
801049e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049ee:	66 90                	xchg   %ax,%ax

801049f0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801049f0:	f3 0f 1e fb          	endbr32 
801049f4:	55                   	push   %ebp
801049f5:	89 e5                	mov    %esp,%ebp
801049f7:	53                   	push   %ebx
801049f8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801049fb:	e8 10 ef ff ff       	call   80103910 <myproc>
80104a00:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a02:	8b 40 18             	mov    0x18(%eax),%eax
80104a05:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a08:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a0b:	83 fa 14             	cmp    $0x14,%edx
80104a0e:	77 20                	ja     80104a30 <syscall+0x40>
80104a10:	8b 14 85 00 77 10 80 	mov    -0x7fef8900(,%eax,4),%edx
80104a17:	85 d2                	test   %edx,%edx
80104a19:	74 15                	je     80104a30 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104a1b:	ff d2                	call   *%edx
80104a1d:	89 c2                	mov    %eax,%edx
80104a1f:	8b 43 18             	mov    0x18(%ebx),%eax
80104a22:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a28:	c9                   	leave  
80104a29:	c3                   	ret    
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104a30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104a31:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104a34:	50                   	push   %eax
80104a35:	ff 73 10             	pushl  0x10(%ebx)
80104a38:	68 c9 76 10 80       	push   $0x801076c9
80104a3d:	e8 6e bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104a42:	8b 43 18             	mov    0x18(%ebx),%eax
80104a45:	83 c4 10             	add    $0x10,%esp
80104a48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104a4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a52:	c9                   	leave  
80104a53:	c3                   	ret    
80104a54:	66 90                	xchg   %ax,%ax
80104a56:	66 90                	xchg   %ax,%ax
80104a58:	66 90                	xchg   %ax,%ax
80104a5a:	66 90                	xchg   %ax,%ax
80104a5c:	66 90                	xchg   %ax,%ax
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104a65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104a68:	53                   	push   %ebx
80104a69:	83 ec 34             	sub    $0x34,%esp
80104a6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104a6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104a72:	57                   	push   %edi
80104a73:	50                   	push   %eax
{
80104a74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104a77:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104a7a:	e8 91 d5 ff ff       	call   80102010 <nameiparent>
80104a7f:	83 c4 10             	add    $0x10,%esp
80104a82:	85 c0                	test   %eax,%eax
80104a84:	0f 84 46 01 00 00    	je     80104bd0 <create+0x170>
    return 0;
  ilock(dp);
80104a8a:	83 ec 0c             	sub    $0xc,%esp
80104a8d:	89 c3                	mov    %eax,%ebx
80104a8f:	50                   	push   %eax
80104a90:	e8 8b cc ff ff       	call   80101720 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a95:	83 c4 0c             	add    $0xc,%esp
80104a98:	6a 00                	push   $0x0
80104a9a:	57                   	push   %edi
80104a9b:	53                   	push   %ebx
80104a9c:	e8 cf d1 ff ff       	call   80101c70 <dirlookup>
80104aa1:	83 c4 10             	add    $0x10,%esp
80104aa4:	89 c6                	mov    %eax,%esi
80104aa6:	85 c0                	test   %eax,%eax
80104aa8:	74 56                	je     80104b00 <create+0xa0>
    iunlockput(dp);
80104aaa:	83 ec 0c             	sub    $0xc,%esp
80104aad:	53                   	push   %ebx
80104aae:	e8 0d cf ff ff       	call   801019c0 <iunlockput>
    ilock(ip);
80104ab3:	89 34 24             	mov    %esi,(%esp)
80104ab6:	e8 65 cc ff ff       	call   80101720 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104abb:	83 c4 10             	add    $0x10,%esp
80104abe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ac3:	75 1b                	jne    80104ae0 <create+0x80>
80104ac5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104aca:	75 14                	jne    80104ae0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104acf:	89 f0                	mov    %esi,%eax
80104ad1:	5b                   	pop    %ebx
80104ad2:	5e                   	pop    %esi
80104ad3:	5f                   	pop    %edi
80104ad4:	5d                   	pop    %ebp
80104ad5:	c3                   	ret    
80104ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104add:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ae0:	83 ec 0c             	sub    $0xc,%esp
80104ae3:	56                   	push   %esi
    return 0;
80104ae4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ae6:	e8 d5 ce ff ff       	call   801019c0 <iunlockput>
    return 0;
80104aeb:	83 c4 10             	add    $0x10,%esp
}
80104aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af1:	89 f0                	mov    %esi,%eax
80104af3:	5b                   	pop    %ebx
80104af4:	5e                   	pop    %esi
80104af5:	5f                   	pop    %edi
80104af6:	5d                   	pop    %ebp
80104af7:	c3                   	ret    
80104af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104b00:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104b04:	83 ec 08             	sub    $0x8,%esp
80104b07:	50                   	push   %eax
80104b08:	ff 33                	pushl  (%ebx)
80104b0a:	e8 91 ca ff ff       	call   801015a0 <ialloc>
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	89 c6                	mov    %eax,%esi
80104b14:	85 c0                	test   %eax,%eax
80104b16:	0f 84 cd 00 00 00    	je     80104be9 <create+0x189>
  ilock(ip);
80104b1c:	83 ec 0c             	sub    $0xc,%esp
80104b1f:	50                   	push   %eax
80104b20:	e8 fb cb ff ff       	call   80101720 <ilock>
  ip->major = major;
80104b25:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104b29:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104b2d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104b31:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104b35:	b8 01 00 00 00       	mov    $0x1,%eax
80104b3a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104b3e:	89 34 24             	mov    %esi,(%esp)
80104b41:	e8 1a cb ff ff       	call   80101660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104b46:	83 c4 10             	add    $0x10,%esp
80104b49:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104b4e:	74 30                	je     80104b80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104b50:	83 ec 04             	sub    $0x4,%esp
80104b53:	ff 76 04             	pushl  0x4(%esi)
80104b56:	57                   	push   %edi
80104b57:	53                   	push   %ebx
80104b58:	e8 d3 d3 ff ff       	call   80101f30 <dirlink>
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	85 c0                	test   %eax,%eax
80104b62:	78 78                	js     80104bdc <create+0x17c>
  iunlockput(dp);
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	53                   	push   %ebx
80104b68:	e8 53 ce ff ff       	call   801019c0 <iunlockput>
  return ip;
80104b6d:	83 c4 10             	add    $0x10,%esp
}
80104b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b73:	89 f0                	mov    %esi,%eax
80104b75:	5b                   	pop    %ebx
80104b76:	5e                   	pop    %esi
80104b77:	5f                   	pop    %edi
80104b78:	5d                   	pop    %ebp
80104b79:	c3                   	ret    
80104b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b80:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b83:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104b88:	53                   	push   %ebx
80104b89:	e8 d2 ca ff ff       	call   80101660 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b8e:	83 c4 0c             	add    $0xc,%esp
80104b91:	ff 76 04             	pushl  0x4(%esi)
80104b94:	68 74 77 10 80       	push   $0x80107774
80104b99:	56                   	push   %esi
80104b9a:	e8 91 d3 ff ff       	call   80101f30 <dirlink>
80104b9f:	83 c4 10             	add    $0x10,%esp
80104ba2:	85 c0                	test   %eax,%eax
80104ba4:	78 18                	js     80104bbe <create+0x15e>
80104ba6:	83 ec 04             	sub    $0x4,%esp
80104ba9:	ff 73 04             	pushl  0x4(%ebx)
80104bac:	68 73 77 10 80       	push   $0x80107773
80104bb1:	56                   	push   %esi
80104bb2:	e8 79 d3 ff ff       	call   80101f30 <dirlink>
80104bb7:	83 c4 10             	add    $0x10,%esp
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	79 92                	jns    80104b50 <create+0xf0>
      panic("create dots");
80104bbe:	83 ec 0c             	sub    $0xc,%esp
80104bc1:	68 67 77 10 80       	push   $0x80107767
80104bc6:	e8 c5 b7 ff ff       	call   80100390 <panic>
80104bcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bcf:	90                   	nop
}
80104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104bd3:	31 f6                	xor    %esi,%esi
}
80104bd5:	5b                   	pop    %ebx
80104bd6:	89 f0                	mov    %esi,%eax
80104bd8:	5e                   	pop    %esi
80104bd9:	5f                   	pop    %edi
80104bda:	5d                   	pop    %ebp
80104bdb:	c3                   	ret    
    panic("create: dirlink");
80104bdc:	83 ec 0c             	sub    $0xc,%esp
80104bdf:	68 76 77 10 80       	push   $0x80107776
80104be4:	e8 a7 b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104be9:	83 ec 0c             	sub    $0xc,%esp
80104bec:	68 58 77 10 80       	push   $0x80107758
80104bf1:	e8 9a b7 ff ff       	call   80100390 <panic>
80104bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bfd:	8d 76 00             	lea    0x0(%esi),%esi

80104c00 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	89 d6                	mov    %edx,%esi
80104c06:	53                   	push   %ebx
80104c07:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c09:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c0c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c0f:	50                   	push   %eax
80104c10:	6a 00                	push   $0x0
80104c12:	e8 e9 fc ff ff       	call   80104900 <argint>
80104c17:	83 c4 10             	add    $0x10,%esp
80104c1a:	85 c0                	test   %eax,%eax
80104c1c:	78 2a                	js     80104c48 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c1e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104c22:	77 24                	ja     80104c48 <argfd.constprop.0+0x48>
80104c24:	e8 e7 ec ff ff       	call   80103910 <myproc>
80104c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c2c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104c30:	85 c0                	test   %eax,%eax
80104c32:	74 14                	je     80104c48 <argfd.constprop.0+0x48>
  if(pfd)
80104c34:	85 db                	test   %ebx,%ebx
80104c36:	74 02                	je     80104c3a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104c38:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104c3a:	89 06                	mov    %eax,(%esi)
  return 0;
80104c3c:	31 c0                	xor    %eax,%eax
}
80104c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c41:	5b                   	pop    %ebx
80104c42:	5e                   	pop    %esi
80104c43:	5d                   	pop    %ebp
80104c44:	c3                   	ret    
80104c45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104c48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c4d:	eb ef                	jmp    80104c3e <argfd.constprop.0+0x3e>
80104c4f:	90                   	nop

80104c50 <sys_dup>:
{
80104c50:	f3 0f 1e fb          	endbr32 
80104c54:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104c55:	31 c0                	xor    %eax,%eax
{
80104c57:	89 e5                	mov    %esp,%ebp
80104c59:	56                   	push   %esi
80104c5a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104c5b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104c5e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104c61:	e8 9a ff ff ff       	call   80104c00 <argfd.constprop.0>
80104c66:	85 c0                	test   %eax,%eax
80104c68:	78 1e                	js     80104c88 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104c6a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104c6d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104c6f:	e8 9c ec ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104c78:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104c7c:	85 d2                	test   %edx,%edx
80104c7e:	74 20                	je     80104ca0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104c80:	83 c3 01             	add    $0x1,%ebx
80104c83:	83 fb 10             	cmp    $0x10,%ebx
80104c86:	75 f0                	jne    80104c78 <sys_dup+0x28>
}
80104c88:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c8b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c90:	89 d8                	mov    %ebx,%eax
80104c92:	5b                   	pop    %ebx
80104c93:	5e                   	pop    %esi
80104c94:	5d                   	pop    %ebp
80104c95:	c3                   	ret    
80104c96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104ca0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ca4:	83 ec 0c             	sub    $0xc,%esp
80104ca7:	ff 75 f4             	pushl  -0xc(%ebp)
80104caa:	e8 c1 c1 ff ff       	call   80100e70 <filedup>
  return fd;
80104caf:	83 c4 10             	add    $0x10,%esp
}
80104cb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb5:	89 d8                	mov    %ebx,%eax
80104cb7:	5b                   	pop    %ebx
80104cb8:	5e                   	pop    %esi
80104cb9:	5d                   	pop    %ebp
80104cba:	c3                   	ret    
80104cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104cbf:	90                   	nop

80104cc0 <sys_read>:
{
80104cc0:	f3 0f 1e fb          	endbr32 
80104cc4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104cc5:	31 c0                	xor    %eax,%eax
{
80104cc7:	89 e5                	mov    %esp,%ebp
80104cc9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ccc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ccf:	e8 2c ff ff ff       	call   80104c00 <argfd.constprop.0>
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	78 48                	js     80104d20 <sys_read+0x60>
80104cd8:	83 ec 08             	sub    $0x8,%esp
80104cdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cde:	50                   	push   %eax
80104cdf:	6a 02                	push   $0x2
80104ce1:	e8 1a fc ff ff       	call   80104900 <argint>
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	85 c0                	test   %eax,%eax
80104ceb:	78 33                	js     80104d20 <sys_read+0x60>
80104ced:	83 ec 04             	sub    $0x4,%esp
80104cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf3:	ff 75 f0             	pushl  -0x10(%ebp)
80104cf6:	50                   	push   %eax
80104cf7:	6a 01                	push   $0x1
80104cf9:	e8 52 fc ff ff       	call   80104950 <argptr>
80104cfe:	83 c4 10             	add    $0x10,%esp
80104d01:	85 c0                	test   %eax,%eax
80104d03:	78 1b                	js     80104d20 <sys_read+0x60>
  return fileread(f, p, n);
80104d05:	83 ec 04             	sub    $0x4,%esp
80104d08:	ff 75 f0             	pushl  -0x10(%ebp)
80104d0b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d0e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d11:	e8 da c2 ff ff       	call   80100ff0 <fileread>
80104d16:	83 c4 10             	add    $0x10,%esp
}
80104d19:	c9                   	leave  
80104d1a:	c3                   	ret    
80104d1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d1f:	90                   	nop
80104d20:	c9                   	leave  
    return -1;
80104d21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d26:	c3                   	ret    
80104d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <sys_write>:
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d35:	31 c0                	xor    %eax,%eax
{
80104d37:	89 e5                	mov    %esp,%ebp
80104d39:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d3c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d3f:	e8 bc fe ff ff       	call   80104c00 <argfd.constprop.0>
80104d44:	85 c0                	test   %eax,%eax
80104d46:	78 48                	js     80104d90 <sys_write+0x60>
80104d48:	83 ec 08             	sub    $0x8,%esp
80104d4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d4e:	50                   	push   %eax
80104d4f:	6a 02                	push   $0x2
80104d51:	e8 aa fb ff ff       	call   80104900 <argint>
80104d56:	83 c4 10             	add    $0x10,%esp
80104d59:	85 c0                	test   %eax,%eax
80104d5b:	78 33                	js     80104d90 <sys_write+0x60>
80104d5d:	83 ec 04             	sub    $0x4,%esp
80104d60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d63:	ff 75 f0             	pushl  -0x10(%ebp)
80104d66:	50                   	push   %eax
80104d67:	6a 01                	push   $0x1
80104d69:	e8 e2 fb ff ff       	call   80104950 <argptr>
80104d6e:	83 c4 10             	add    $0x10,%esp
80104d71:	85 c0                	test   %eax,%eax
80104d73:	78 1b                	js     80104d90 <sys_write+0x60>
  return filewrite(f, p, n);
80104d75:	83 ec 04             	sub    $0x4,%esp
80104d78:	ff 75 f0             	pushl  -0x10(%ebp)
80104d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80104d7e:	ff 75 ec             	pushl  -0x14(%ebp)
80104d81:	e8 0a c3 ff ff       	call   80101090 <filewrite>
80104d86:	83 c4 10             	add    $0x10,%esp
}
80104d89:	c9                   	leave  
80104d8a:	c3                   	ret    
80104d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d8f:	90                   	nop
80104d90:	c9                   	leave  
    return -1;
80104d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d96:	c3                   	ret    
80104d97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9e:	66 90                	xchg   %ax,%ax

80104da0 <sys_close>:
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104daa:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104dad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104db0:	e8 4b fe ff ff       	call   80104c00 <argfd.constprop.0>
80104db5:	85 c0                	test   %eax,%eax
80104db7:	78 27                	js     80104de0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104db9:	e8 52 eb ff ff       	call   80103910 <myproc>
80104dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104dc1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104dc4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104dcb:	00 
  fileclose(f);
80104dcc:	ff 75 f4             	pushl  -0xc(%ebp)
80104dcf:	e8 ec c0 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104dd4:	83 c4 10             	add    $0x10,%esp
80104dd7:	31 c0                	xor    %eax,%eax
}
80104dd9:	c9                   	leave  
80104dda:	c3                   	ret    
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop
80104de0:	c9                   	leave  
    return -1;
80104de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de6:	c3                   	ret    
80104de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dee:	66 90                	xchg   %ax,%ax

80104df0 <sys_fstat>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104df5:	31 c0                	xor    %eax,%eax
{
80104df7:	89 e5                	mov    %esp,%ebp
80104df9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104dfc:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104dff:	e8 fc fd ff ff       	call   80104c00 <argfd.constprop.0>
80104e04:	85 c0                	test   %eax,%eax
80104e06:	78 30                	js     80104e38 <sys_fstat+0x48>
80104e08:	83 ec 04             	sub    $0x4,%esp
80104e0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e0e:	6a 14                	push   $0x14
80104e10:	50                   	push   %eax
80104e11:	6a 01                	push   $0x1
80104e13:	e8 38 fb ff ff       	call   80104950 <argptr>
80104e18:	83 c4 10             	add    $0x10,%esp
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	78 19                	js     80104e38 <sys_fstat+0x48>
  return filestat(f, st);
80104e1f:	83 ec 08             	sub    $0x8,%esp
80104e22:	ff 75 f4             	pushl  -0xc(%ebp)
80104e25:	ff 75 f0             	pushl  -0x10(%ebp)
80104e28:	e8 73 c1 ff ff       	call   80100fa0 <filestat>
80104e2d:	83 c4 10             	add    $0x10,%esp
}
80104e30:	c9                   	leave  
80104e31:	c3                   	ret    
80104e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e38:	c9                   	leave  
    return -1;
80104e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e3e:	c3                   	ret    
80104e3f:	90                   	nop

80104e40 <sys_link>:
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	57                   	push   %edi
80104e48:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e49:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104e4c:	53                   	push   %ebx
80104e4d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104e50:	50                   	push   %eax
80104e51:	6a 00                	push   $0x0
80104e53:	e8 58 fb ff ff       	call   801049b0 <argstr>
80104e58:	83 c4 10             	add    $0x10,%esp
80104e5b:	85 c0                	test   %eax,%eax
80104e5d:	0f 88 ff 00 00 00    	js     80104f62 <sys_link+0x122>
80104e63:	83 ec 08             	sub    $0x8,%esp
80104e66:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104e69:	50                   	push   %eax
80104e6a:	6a 01                	push   $0x1
80104e6c:	e8 3f fb ff ff       	call   801049b0 <argstr>
80104e71:	83 c4 10             	add    $0x10,%esp
80104e74:	85 c0                	test   %eax,%eax
80104e76:	0f 88 e6 00 00 00    	js     80104f62 <sys_link+0x122>
  begin_op();
80104e7c:	e8 6f de ff ff       	call   80102cf0 <begin_op>
  if((ip = namei(old)) == 0){
80104e81:	83 ec 0c             	sub    $0xc,%esp
80104e84:	ff 75 d4             	pushl  -0x2c(%ebp)
80104e87:	e8 64 d1 ff ff       	call   80101ff0 <namei>
80104e8c:	83 c4 10             	add    $0x10,%esp
80104e8f:	89 c3                	mov    %eax,%ebx
80104e91:	85 c0                	test   %eax,%eax
80104e93:	0f 84 e8 00 00 00    	je     80104f81 <sys_link+0x141>
  ilock(ip);
80104e99:	83 ec 0c             	sub    $0xc,%esp
80104e9c:	50                   	push   %eax
80104e9d:	e8 7e c8 ff ff       	call   80101720 <ilock>
  if(ip->type == T_DIR){
80104ea2:	83 c4 10             	add    $0x10,%esp
80104ea5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104eaa:	0f 84 b9 00 00 00    	je     80104f69 <sys_link+0x129>
  iupdate(ip);
80104eb0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104eb3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104eb8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104ebb:	53                   	push   %ebx
80104ebc:	e8 9f c7 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104ec1:	89 1c 24             	mov    %ebx,(%esp)
80104ec4:	e8 37 c9 ff ff       	call   80101800 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104ec9:	58                   	pop    %eax
80104eca:	5a                   	pop    %edx
80104ecb:	57                   	push   %edi
80104ecc:	ff 75 d0             	pushl  -0x30(%ebp)
80104ecf:	e8 3c d1 ff ff       	call   80102010 <nameiparent>
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	89 c6                	mov    %eax,%esi
80104ed9:	85 c0                	test   %eax,%eax
80104edb:	74 5f                	je     80104f3c <sys_link+0xfc>
  ilock(dp);
80104edd:	83 ec 0c             	sub    $0xc,%esp
80104ee0:	50                   	push   %eax
80104ee1:	e8 3a c8 ff ff       	call   80101720 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ee6:	8b 03                	mov    (%ebx),%eax
80104ee8:	83 c4 10             	add    $0x10,%esp
80104eeb:	39 06                	cmp    %eax,(%esi)
80104eed:	75 41                	jne    80104f30 <sys_link+0xf0>
80104eef:	83 ec 04             	sub    $0x4,%esp
80104ef2:	ff 73 04             	pushl  0x4(%ebx)
80104ef5:	57                   	push   %edi
80104ef6:	56                   	push   %esi
80104ef7:	e8 34 d0 ff ff       	call   80101f30 <dirlink>
80104efc:	83 c4 10             	add    $0x10,%esp
80104eff:	85 c0                	test   %eax,%eax
80104f01:	78 2d                	js     80104f30 <sys_link+0xf0>
  iunlockput(dp);
80104f03:	83 ec 0c             	sub    $0xc,%esp
80104f06:	56                   	push   %esi
80104f07:	e8 b4 ca ff ff       	call   801019c0 <iunlockput>
  iput(ip);
80104f0c:	89 1c 24             	mov    %ebx,(%esp)
80104f0f:	e8 3c c9 ff ff       	call   80101850 <iput>
  end_op();
80104f14:	e8 47 de ff ff       	call   80102d60 <end_op>
  return 0;
80104f19:	83 c4 10             	add    $0x10,%esp
80104f1c:	31 c0                	xor    %eax,%eax
}
80104f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f21:	5b                   	pop    %ebx
80104f22:	5e                   	pop    %esi
80104f23:	5f                   	pop    %edi
80104f24:	5d                   	pop    %ebp
80104f25:	c3                   	ret    
80104f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f2d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104f30:	83 ec 0c             	sub    $0xc,%esp
80104f33:	56                   	push   %esi
80104f34:	e8 87 ca ff ff       	call   801019c0 <iunlockput>
    goto bad;
80104f39:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	53                   	push   %ebx
80104f40:	e8 db c7 ff ff       	call   80101720 <ilock>
  ip->nlink--;
80104f45:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f4a:	89 1c 24             	mov    %ebx,(%esp)
80104f4d:	e8 0e c7 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104f52:	89 1c 24             	mov    %ebx,(%esp)
80104f55:	e8 66 ca ff ff       	call   801019c0 <iunlockput>
  end_op();
80104f5a:	e8 01 de ff ff       	call   80102d60 <end_op>
  return -1;
80104f5f:	83 c4 10             	add    $0x10,%esp
80104f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f67:	eb b5                	jmp    80104f1e <sys_link+0xde>
    iunlockput(ip);
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	53                   	push   %ebx
80104f6d:	e8 4e ca ff ff       	call   801019c0 <iunlockput>
    end_op();
80104f72:	e8 e9 dd ff ff       	call   80102d60 <end_op>
    return -1;
80104f77:	83 c4 10             	add    $0x10,%esp
80104f7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f7f:	eb 9d                	jmp    80104f1e <sys_link+0xde>
    end_op();
80104f81:	e8 da dd ff ff       	call   80102d60 <end_op>
    return -1;
80104f86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f8b:	eb 91                	jmp    80104f1e <sys_link+0xde>
80104f8d:	8d 76 00             	lea    0x0(%esi),%esi

80104f90 <sys_unlink>:
{
80104f90:	f3 0f 1e fb          	endbr32 
80104f94:	55                   	push   %ebp
80104f95:	89 e5                	mov    %esp,%ebp
80104f97:	57                   	push   %edi
80104f98:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f99:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f9c:	53                   	push   %ebx
80104f9d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104fa0:	50                   	push   %eax
80104fa1:	6a 00                	push   $0x0
80104fa3:	e8 08 fa ff ff       	call   801049b0 <argstr>
80104fa8:	83 c4 10             	add    $0x10,%esp
80104fab:	85 c0                	test   %eax,%eax
80104fad:	0f 88 7d 01 00 00    	js     80105130 <sys_unlink+0x1a0>
  begin_op();
80104fb3:	e8 38 dd ff ff       	call   80102cf0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104fb8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104fbb:	83 ec 08             	sub    $0x8,%esp
80104fbe:	53                   	push   %ebx
80104fbf:	ff 75 c0             	pushl  -0x40(%ebp)
80104fc2:	e8 49 d0 ff ff       	call   80102010 <nameiparent>
80104fc7:	83 c4 10             	add    $0x10,%esp
80104fca:	89 c6                	mov    %eax,%esi
80104fcc:	85 c0                	test   %eax,%eax
80104fce:	0f 84 66 01 00 00    	je     8010513a <sys_unlink+0x1aa>
  ilock(dp);
80104fd4:	83 ec 0c             	sub    $0xc,%esp
80104fd7:	50                   	push   %eax
80104fd8:	e8 43 c7 ff ff       	call   80101720 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104fdd:	58                   	pop    %eax
80104fde:	5a                   	pop    %edx
80104fdf:	68 74 77 10 80       	push   $0x80107774
80104fe4:	53                   	push   %ebx
80104fe5:	e8 66 cc ff ff       	call   80101c50 <namecmp>
80104fea:	83 c4 10             	add    $0x10,%esp
80104fed:	85 c0                	test   %eax,%eax
80104fef:	0f 84 03 01 00 00    	je     801050f8 <sys_unlink+0x168>
80104ff5:	83 ec 08             	sub    $0x8,%esp
80104ff8:	68 73 77 10 80       	push   $0x80107773
80104ffd:	53                   	push   %ebx
80104ffe:	e8 4d cc ff ff       	call   80101c50 <namecmp>
80105003:	83 c4 10             	add    $0x10,%esp
80105006:	85 c0                	test   %eax,%eax
80105008:	0f 84 ea 00 00 00    	je     801050f8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010500e:	83 ec 04             	sub    $0x4,%esp
80105011:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105014:	50                   	push   %eax
80105015:	53                   	push   %ebx
80105016:	56                   	push   %esi
80105017:	e8 54 cc ff ff       	call   80101c70 <dirlookup>
8010501c:	83 c4 10             	add    $0x10,%esp
8010501f:	89 c3                	mov    %eax,%ebx
80105021:	85 c0                	test   %eax,%eax
80105023:	0f 84 cf 00 00 00    	je     801050f8 <sys_unlink+0x168>
  ilock(ip);
80105029:	83 ec 0c             	sub    $0xc,%esp
8010502c:	50                   	push   %eax
8010502d:	e8 ee c6 ff ff       	call   80101720 <ilock>
  if(ip->nlink < 1)
80105032:	83 c4 10             	add    $0x10,%esp
80105035:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010503a:	0f 8e 23 01 00 00    	jle    80105163 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105040:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105045:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105048:	74 66                	je     801050b0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010504a:	83 ec 04             	sub    $0x4,%esp
8010504d:	6a 10                	push   $0x10
8010504f:	6a 00                	push   $0x0
80105051:	57                   	push   %edi
80105052:	e8 c9 f5 ff ff       	call   80104620 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105057:	6a 10                	push   $0x10
80105059:	ff 75 c4             	pushl  -0x3c(%ebp)
8010505c:	57                   	push   %edi
8010505d:	56                   	push   %esi
8010505e:	e8 bd ca ff ff       	call   80101b20 <writei>
80105063:	83 c4 20             	add    $0x20,%esp
80105066:	83 f8 10             	cmp    $0x10,%eax
80105069:	0f 85 e7 00 00 00    	jne    80105156 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010506f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105074:	0f 84 96 00 00 00    	je     80105110 <sys_unlink+0x180>
  iunlockput(dp);
8010507a:	83 ec 0c             	sub    $0xc,%esp
8010507d:	56                   	push   %esi
8010507e:	e8 3d c9 ff ff       	call   801019c0 <iunlockput>
  ip->nlink--;
80105083:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105088:	89 1c 24             	mov    %ebx,(%esp)
8010508b:	e8 d0 c5 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80105090:	89 1c 24             	mov    %ebx,(%esp)
80105093:	e8 28 c9 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105098:	e8 c3 dc ff ff       	call   80102d60 <end_op>
  return 0;
8010509d:	83 c4 10             	add    $0x10,%esp
801050a0:	31 c0                	xor    %eax,%eax
}
801050a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050a5:	5b                   	pop    %ebx
801050a6:	5e                   	pop    %esi
801050a7:	5f                   	pop    %edi
801050a8:	5d                   	pop    %ebp
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050b0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801050b4:	76 94                	jbe    8010504a <sys_unlink+0xba>
801050b6:	ba 20 00 00 00       	mov    $0x20,%edx
801050bb:	eb 0b                	jmp    801050c8 <sys_unlink+0x138>
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
801050c0:	83 c2 10             	add    $0x10,%edx
801050c3:	39 53 58             	cmp    %edx,0x58(%ebx)
801050c6:	76 82                	jbe    8010504a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050c8:	6a 10                	push   $0x10
801050ca:	52                   	push   %edx
801050cb:	57                   	push   %edi
801050cc:	53                   	push   %ebx
801050cd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801050d0:	e8 4b c9 ff ff       	call   80101a20 <readi>
801050d5:	83 c4 10             	add    $0x10,%esp
801050d8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801050db:	83 f8 10             	cmp    $0x10,%eax
801050de:	75 69                	jne    80105149 <sys_unlink+0x1b9>
    if(de.inum != 0)
801050e0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050e5:	74 d9                	je     801050c0 <sys_unlink+0x130>
    iunlockput(ip);
801050e7:	83 ec 0c             	sub    $0xc,%esp
801050ea:	53                   	push   %ebx
801050eb:	e8 d0 c8 ff ff       	call   801019c0 <iunlockput>
    goto bad;
801050f0:	83 c4 10             	add    $0x10,%esp
801050f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f7:	90                   	nop
  iunlockput(dp);
801050f8:	83 ec 0c             	sub    $0xc,%esp
801050fb:	56                   	push   %esi
801050fc:	e8 bf c8 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105101:	e8 5a dc ff ff       	call   80102d60 <end_op>
  return -1;
80105106:	83 c4 10             	add    $0x10,%esp
80105109:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010510e:	eb 92                	jmp    801050a2 <sys_unlink+0x112>
    iupdate(dp);
80105110:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105113:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105118:	56                   	push   %esi
80105119:	e8 42 c5 ff ff       	call   80101660 <iupdate>
8010511e:	83 c4 10             	add    $0x10,%esp
80105121:	e9 54 ff ff ff       	jmp    8010507a <sys_unlink+0xea>
80105126:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010512d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105135:	e9 68 ff ff ff       	jmp    801050a2 <sys_unlink+0x112>
    end_op();
8010513a:	e8 21 dc ff ff       	call   80102d60 <end_op>
    return -1;
8010513f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105144:	e9 59 ff ff ff       	jmp    801050a2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	68 98 77 10 80       	push   $0x80107798
80105151:	e8 3a b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105156:	83 ec 0c             	sub    $0xc,%esp
80105159:	68 aa 77 10 80       	push   $0x801077aa
8010515e:	e8 2d b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105163:	83 ec 0c             	sub    $0xc,%esp
80105166:	68 86 77 10 80       	push   $0x80107786
8010516b:	e8 20 b2 ff ff       	call   80100390 <panic>

80105170 <sys_open>:

int
sys_open(void)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	57                   	push   %edi
80105178:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105179:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010517c:	53                   	push   %ebx
8010517d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105180:	50                   	push   %eax
80105181:	6a 00                	push   $0x0
80105183:	e8 28 f8 ff ff       	call   801049b0 <argstr>
80105188:	83 c4 10             	add    $0x10,%esp
8010518b:	85 c0                	test   %eax,%eax
8010518d:	0f 88 8a 00 00 00    	js     8010521d <sys_open+0xad>
80105193:	83 ec 08             	sub    $0x8,%esp
80105196:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105199:	50                   	push   %eax
8010519a:	6a 01                	push   $0x1
8010519c:	e8 5f f7 ff ff       	call   80104900 <argint>
801051a1:	83 c4 10             	add    $0x10,%esp
801051a4:	85 c0                	test   %eax,%eax
801051a6:	78 75                	js     8010521d <sys_open+0xad>
    return -1;

  begin_op();
801051a8:	e8 43 db ff ff       	call   80102cf0 <begin_op>

  if(omode & O_CREATE){
801051ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801051b1:	75 75                	jne    80105228 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801051b3:	83 ec 0c             	sub    $0xc,%esp
801051b6:	ff 75 e0             	pushl  -0x20(%ebp)
801051b9:	e8 32 ce ff ff       	call   80101ff0 <namei>
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	89 c6                	mov    %eax,%esi
801051c3:	85 c0                	test   %eax,%eax
801051c5:	74 7e                	je     80105245 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801051c7:	83 ec 0c             	sub    $0xc,%esp
801051ca:	50                   	push   %eax
801051cb:	e8 50 c5 ff ff       	call   80101720 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801051d0:	83 c4 10             	add    $0x10,%esp
801051d3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801051d8:	0f 84 c2 00 00 00    	je     801052a0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801051de:	e8 1d bc ff ff       	call   80100e00 <filealloc>
801051e3:	89 c7                	mov    %eax,%edi
801051e5:	85 c0                	test   %eax,%eax
801051e7:	74 23                	je     8010520c <sys_open+0x9c>
  struct proc *curproc = myproc();
801051e9:	e8 22 e7 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801051ee:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801051f0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051f4:	85 d2                	test   %edx,%edx
801051f6:	74 60                	je     80105258 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801051f8:	83 c3 01             	add    $0x1,%ebx
801051fb:	83 fb 10             	cmp    $0x10,%ebx
801051fe:	75 f0                	jne    801051f0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105200:	83 ec 0c             	sub    $0xc,%esp
80105203:	57                   	push   %edi
80105204:	e8 b7 bc ff ff       	call   80100ec0 <fileclose>
80105209:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010520c:	83 ec 0c             	sub    $0xc,%esp
8010520f:	56                   	push   %esi
80105210:	e8 ab c7 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105215:	e8 46 db ff ff       	call   80102d60 <end_op>
    return -1;
8010521a:	83 c4 10             	add    $0x10,%esp
8010521d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105222:	eb 6d                	jmp    80105291 <sys_open+0x121>
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105228:	83 ec 0c             	sub    $0xc,%esp
8010522b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010522e:	31 c9                	xor    %ecx,%ecx
80105230:	ba 02 00 00 00       	mov    $0x2,%edx
80105235:	6a 00                	push   $0x0
80105237:	e8 24 f8 ff ff       	call   80104a60 <create>
    if(ip == 0){
8010523c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010523f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105241:	85 c0                	test   %eax,%eax
80105243:	75 99                	jne    801051de <sys_open+0x6e>
      end_op();
80105245:	e8 16 db ff ff       	call   80102d60 <end_op>
      return -1;
8010524a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010524f:	eb 40                	jmp    80105291 <sys_open+0x121>
80105251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105258:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010525b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010525f:	56                   	push   %esi
80105260:	e8 9b c5 ff ff       	call   80101800 <iunlock>
  end_op();
80105265:	e8 f6 da ff ff       	call   80102d60 <end_op>

  f->type = FD_INODE;
8010526a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105270:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105273:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105276:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105279:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010527b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105282:	f7 d0                	not    %eax
80105284:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105287:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010528a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010528d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105291:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105294:	89 d8                	mov    %ebx,%eax
80105296:	5b                   	pop    %ebx
80105297:	5e                   	pop    %esi
80105298:	5f                   	pop    %edi
80105299:	5d                   	pop    %ebp
8010529a:	c3                   	ret    
8010529b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010529f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801052a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801052a3:	85 c9                	test   %ecx,%ecx
801052a5:	0f 84 33 ff ff ff    	je     801051de <sys_open+0x6e>
801052ab:	e9 5c ff ff ff       	jmp    8010520c <sys_open+0x9c>

801052b0 <sys_mkdir>:

int
sys_mkdir(void)
{
801052b0:	f3 0f 1e fb          	endbr32 
801052b4:	55                   	push   %ebp
801052b5:	89 e5                	mov    %esp,%ebp
801052b7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052ba:	e8 31 da ff ff       	call   80102cf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801052bf:	83 ec 08             	sub    $0x8,%esp
801052c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052c5:	50                   	push   %eax
801052c6:	6a 00                	push   $0x0
801052c8:	e8 e3 f6 ff ff       	call   801049b0 <argstr>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	78 34                	js     80105308 <sys_mkdir+0x58>
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052da:	31 c9                	xor    %ecx,%ecx
801052dc:	ba 01 00 00 00       	mov    $0x1,%edx
801052e1:	6a 00                	push   $0x0
801052e3:	e8 78 f7 ff ff       	call   80104a60 <create>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	74 19                	je     80105308 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ef:	83 ec 0c             	sub    $0xc,%esp
801052f2:	50                   	push   %eax
801052f3:	e8 c8 c6 ff ff       	call   801019c0 <iunlockput>
  end_op();
801052f8:	e8 63 da ff ff       	call   80102d60 <end_op>
  return 0;
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	31 c0                	xor    %eax,%eax
}
80105302:	c9                   	leave  
80105303:	c3                   	ret    
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105308:	e8 53 da ff ff       	call   80102d60 <end_op>
    return -1;
8010530d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105312:	c9                   	leave  
80105313:	c3                   	ret    
80105314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop

80105320 <sys_mknod>:

int
sys_mknod(void)
{
80105320:	f3 0f 1e fb          	endbr32 
80105324:	55                   	push   %ebp
80105325:	89 e5                	mov    %esp,%ebp
80105327:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010532a:	e8 c1 d9 ff ff       	call   80102cf0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010532f:	83 ec 08             	sub    $0x8,%esp
80105332:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105335:	50                   	push   %eax
80105336:	6a 00                	push   $0x0
80105338:	e8 73 f6 ff ff       	call   801049b0 <argstr>
8010533d:	83 c4 10             	add    $0x10,%esp
80105340:	85 c0                	test   %eax,%eax
80105342:	78 64                	js     801053a8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105344:	83 ec 08             	sub    $0x8,%esp
80105347:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010534a:	50                   	push   %eax
8010534b:	6a 01                	push   $0x1
8010534d:	e8 ae f5 ff ff       	call   80104900 <argint>
  if((argstr(0, &path)) < 0 ||
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 4f                	js     801053a8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105359:	83 ec 08             	sub    $0x8,%esp
8010535c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535f:	50                   	push   %eax
80105360:	6a 02                	push   $0x2
80105362:	e8 99 f5 ff ff       	call   80104900 <argint>
     argint(1, &major) < 0 ||
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	85 c0                	test   %eax,%eax
8010536c:	78 3a                	js     801053a8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010536e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105372:	83 ec 0c             	sub    $0xc,%esp
80105375:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105379:	ba 03 00 00 00       	mov    $0x3,%edx
8010537e:	50                   	push   %eax
8010537f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105382:	e8 d9 f6 ff ff       	call   80104a60 <create>
     argint(2, &minor) < 0 ||
80105387:	83 c4 10             	add    $0x10,%esp
8010538a:	85 c0                	test   %eax,%eax
8010538c:	74 1a                	je     801053a8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538e:	83 ec 0c             	sub    $0xc,%esp
80105391:	50                   	push   %eax
80105392:	e8 29 c6 ff ff       	call   801019c0 <iunlockput>
  end_op();
80105397:	e8 c4 d9 ff ff       	call   80102d60 <end_op>
  return 0;
8010539c:	83 c4 10             	add    $0x10,%esp
8010539f:	31 c0                	xor    %eax,%eax
}
801053a1:	c9                   	leave  
801053a2:	c3                   	ret    
801053a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053a7:	90                   	nop
    end_op();
801053a8:	e8 b3 d9 ff ff       	call   80102d60 <end_op>
    return -1;
801053ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    
801053b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop

801053c0 <sys_chdir>:

int
sys_chdir(void)
{
801053c0:	f3 0f 1e fb          	endbr32 
801053c4:	55                   	push   %ebp
801053c5:	89 e5                	mov    %esp,%ebp
801053c7:	56                   	push   %esi
801053c8:	53                   	push   %ebx
801053c9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801053cc:	e8 3f e5 ff ff       	call   80103910 <myproc>
801053d1:	89 c6                	mov    %eax,%esi
  
  begin_op();
801053d3:	e8 18 d9 ff ff       	call   80102cf0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801053d8:	83 ec 08             	sub    $0x8,%esp
801053db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053de:	50                   	push   %eax
801053df:	6a 00                	push   $0x0
801053e1:	e8 ca f5 ff ff       	call   801049b0 <argstr>
801053e6:	83 c4 10             	add    $0x10,%esp
801053e9:	85 c0                	test   %eax,%eax
801053eb:	78 73                	js     80105460 <sys_chdir+0xa0>
801053ed:	83 ec 0c             	sub    $0xc,%esp
801053f0:	ff 75 f4             	pushl  -0xc(%ebp)
801053f3:	e8 f8 cb ff ff       	call   80101ff0 <namei>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	89 c3                	mov    %eax,%ebx
801053fd:	85 c0                	test   %eax,%eax
801053ff:	74 5f                	je     80105460 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105401:	83 ec 0c             	sub    $0xc,%esp
80105404:	50                   	push   %eax
80105405:	e8 16 c3 ff ff       	call   80101720 <ilock>
  if(ip->type != T_DIR){
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105412:	75 2c                	jne    80105440 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105414:	83 ec 0c             	sub    $0xc,%esp
80105417:	53                   	push   %ebx
80105418:	e8 e3 c3 ff ff       	call   80101800 <iunlock>
  iput(curproc->cwd);
8010541d:	58                   	pop    %eax
8010541e:	ff 76 68             	pushl  0x68(%esi)
80105421:	e8 2a c4 ff ff       	call   80101850 <iput>
  end_op();
80105426:	e8 35 d9 ff ff       	call   80102d60 <end_op>
  curproc->cwd = ip;
8010542b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010542e:	83 c4 10             	add    $0x10,%esp
80105431:	31 c0                	xor    %eax,%eax
}
80105433:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105436:	5b                   	pop    %ebx
80105437:	5e                   	pop    %esi
80105438:	5d                   	pop    %ebp
80105439:	c3                   	ret    
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	53                   	push   %ebx
80105444:	e8 77 c5 ff ff       	call   801019c0 <iunlockput>
    end_op();
80105449:	e8 12 d9 ff ff       	call   80102d60 <end_op>
    return -1;
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105456:	eb db                	jmp    80105433 <sys_chdir+0x73>
80105458:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545f:	90                   	nop
    end_op();
80105460:	e8 fb d8 ff ff       	call   80102d60 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546a:	eb c7                	jmp    80105433 <sys_chdir+0x73>
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_exec>:

int
sys_exec(void)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	57                   	push   %edi
80105478:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105479:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010547f:	53                   	push   %ebx
80105480:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105486:	50                   	push   %eax
80105487:	6a 00                	push   $0x0
80105489:	e8 22 f5 ff ff       	call   801049b0 <argstr>
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	85 c0                	test   %eax,%eax
80105493:	0f 88 8b 00 00 00    	js     80105524 <sys_exec+0xb4>
80105499:	83 ec 08             	sub    $0x8,%esp
8010549c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801054a2:	50                   	push   %eax
801054a3:	6a 01                	push   $0x1
801054a5:	e8 56 f4 ff ff       	call   80104900 <argint>
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	85 c0                	test   %eax,%eax
801054af:	78 73                	js     80105524 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801054b1:	83 ec 04             	sub    $0x4,%esp
801054b4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801054ba:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801054bc:	68 80 00 00 00       	push   $0x80
801054c1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801054c7:	6a 00                	push   $0x0
801054c9:	50                   	push   %eax
801054ca:	e8 51 f1 ff ff       	call   80104620 <memset>
801054cf:	83 c4 10             	add    $0x10,%esp
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801054d8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801054de:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801054e5:	83 ec 08             	sub    $0x8,%esp
801054e8:	57                   	push   %edi
801054e9:	01 f0                	add    %esi,%eax
801054eb:	50                   	push   %eax
801054ec:	e8 6f f3 ff ff       	call   80104860 <fetchint>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	85 c0                	test   %eax,%eax
801054f6:	78 2c                	js     80105524 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801054f8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801054fe:	85 c0                	test   %eax,%eax
80105500:	74 36                	je     80105538 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105502:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105508:	83 ec 08             	sub    $0x8,%esp
8010550b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010550e:	52                   	push   %edx
8010550f:	50                   	push   %eax
80105510:	e8 8b f3 ff ff       	call   801048a0 <fetchstr>
80105515:	83 c4 10             	add    $0x10,%esp
80105518:	85 c0                	test   %eax,%eax
8010551a:	78 08                	js     80105524 <sys_exec+0xb4>
  for(i=0;; i++){
8010551c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010551f:	83 fb 20             	cmp    $0x20,%ebx
80105522:	75 b4                	jne    801054d8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105524:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010552c:	5b                   	pop    %ebx
8010552d:	5e                   	pop    %esi
8010552e:	5f                   	pop    %edi
8010552f:	5d                   	pop    %ebp
80105530:	c3                   	ret    
80105531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105538:	83 ec 08             	sub    $0x8,%esp
8010553b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105541:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105548:	00 00 00 00 
  return exec(path, argv);
8010554c:	50                   	push   %eax
8010554d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105553:	e8 28 b5 ff ff       	call   80100a80 <exec>
80105558:	83 c4 10             	add    $0x10,%esp
}
8010555b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010555e:	5b                   	pop    %ebx
8010555f:	5e                   	pop    %esi
80105560:	5f                   	pop    %edi
80105561:	5d                   	pop    %ebp
80105562:	c3                   	ret    
80105563:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105570 <sys_pipe>:

int
sys_pipe(void)
{
80105570:	f3 0f 1e fb          	endbr32 
80105574:	55                   	push   %ebp
80105575:	89 e5                	mov    %esp,%ebp
80105577:	57                   	push   %edi
80105578:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105579:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010557c:	53                   	push   %ebx
8010557d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105580:	6a 08                	push   $0x8
80105582:	50                   	push   %eax
80105583:	6a 00                	push   $0x0
80105585:	e8 c6 f3 ff ff       	call   80104950 <argptr>
8010558a:	83 c4 10             	add    $0x10,%esp
8010558d:	85 c0                	test   %eax,%eax
8010558f:	78 4e                	js     801055df <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105591:	83 ec 08             	sub    $0x8,%esp
80105594:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105597:	50                   	push   %eax
80105598:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010559b:	50                   	push   %eax
8010559c:	e8 ff dd ff ff       	call   801033a0 <pipealloc>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 37                	js     801055df <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055a8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801055ab:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055ad:	e8 5e e3 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801055b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801055bc:	85 f6                	test   %esi,%esi
801055be:	74 30                	je     801055f0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801055c0:	83 c3 01             	add    $0x1,%ebx
801055c3:	83 fb 10             	cmp    $0x10,%ebx
801055c6:	75 f0                	jne    801055b8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801055c8:	83 ec 0c             	sub    $0xc,%esp
801055cb:	ff 75 e0             	pushl  -0x20(%ebp)
801055ce:	e8 ed b8 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801055d3:	58                   	pop    %eax
801055d4:	ff 75 e4             	pushl  -0x1c(%ebp)
801055d7:	e8 e4 b8 ff ff       	call   80100ec0 <fileclose>
    return -1;
801055dc:	83 c4 10             	add    $0x10,%esp
801055df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e4:	eb 5b                	jmp    80105641 <sys_pipe+0xd1>
801055e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ed:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055f0:	8d 73 08             	lea    0x8(%ebx),%esi
801055f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801055f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801055fa:	e8 11 e3 ff ff       	call   80103910 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055ff:	31 d2                	xor    %edx,%edx
80105601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105608:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010560c:	85 c9                	test   %ecx,%ecx
8010560e:	74 20                	je     80105630 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105610:	83 c2 01             	add    $0x1,%edx
80105613:	83 fa 10             	cmp    $0x10,%edx
80105616:	75 f0                	jne    80105608 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105618:	e8 f3 e2 ff ff       	call   80103910 <myproc>
8010561d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105624:	00 
80105625:	eb a1                	jmp    801055c8 <sys_pipe+0x58>
80105627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010562e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105630:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105634:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105637:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105639:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010563c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010563f:	31 c0                	xor    %eax,%eax
}
80105641:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105644:	5b                   	pop    %ebx
80105645:	5e                   	pop    %esi
80105646:	5f                   	pop    %edi
80105647:	5d                   	pop    %ebp
80105648:	c3                   	ret    
80105649:	66 90                	xchg   %ax,%ax
8010564b:	66 90                	xchg   %ax,%ax
8010564d:	66 90                	xchg   %ax,%ax
8010564f:	90                   	nop

80105650 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105650:	f3 0f 1e fb          	endbr32 
  return fork();
80105654:	e9 67 e4 ff ff       	jmp    80103ac0 <fork>
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105660 <sys_exit>:
}

int
sys_exit(void)
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	83 ec 08             	sub    $0x8,%esp
  exit();
8010566a:	e8 d1 e6 ff ff       	call   80103d40 <exit>
  return 0;  // not reached
}
8010566f:	31 c0                	xor    %eax,%eax
80105671:	c9                   	leave  
80105672:	c3                   	ret    
80105673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010567a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105680 <sys_wait>:

int
sys_wait(void)
{
80105680:	f3 0f 1e fb          	endbr32 
  return wait();
80105684:	e9 07 e9 ff ff       	jmp    80103f90 <wait>
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105690 <sys_kill>:
}

int
sys_kill(void)
{
80105690:	f3 0f 1e fb          	endbr32 
80105694:	55                   	push   %ebp
80105695:	89 e5                	mov    %esp,%ebp
80105697:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010569a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010569d:	50                   	push   %eax
8010569e:	6a 00                	push   $0x0
801056a0:	e8 5b f2 ff ff       	call   80104900 <argint>
801056a5:	83 c4 10             	add    $0x10,%esp
801056a8:	85 c0                	test   %eax,%eax
801056aa:	78 14                	js     801056c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801056ac:	83 ec 0c             	sub    $0xc,%esp
801056af:	ff 75 f4             	pushl  -0xc(%ebp)
801056b2:	e8 39 ea ff ff       	call   801040f0 <kill>
801056b7:	83 c4 10             	add    $0x10,%esp
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056c0:	c9                   	leave  
    return -1;
801056c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c6:	c3                   	ret    
801056c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ce:	66 90                	xchg   %ax,%ax

801056d0 <sys_getpid>:

int
sys_getpid(void)
{
801056d0:	f3 0f 1e fb          	endbr32 
801056d4:	55                   	push   %ebp
801056d5:	89 e5                	mov    %esp,%ebp
801056d7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801056da:	e8 31 e2 ff ff       	call   80103910 <myproc>
801056df:	8b 40 10             	mov    0x10(%eax),%eax
}
801056e2:	c9                   	leave  
801056e3:	c3                   	ret    
801056e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop

801056f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801056f0:	f3 0f 1e fb          	endbr32 
801056f4:	55                   	push   %ebp
801056f5:	89 e5                	mov    %esp,%ebp
801056f7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801056f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801056fb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801056fe:	50                   	push   %eax
801056ff:	6a 00                	push   $0x0
80105701:	e8 fa f1 ff ff       	call   80104900 <argint>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	85 c0                	test   %eax,%eax
8010570b:	78 23                	js     80105730 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010570d:	e8 fe e1 ff ff       	call   80103910 <myproc>
  if(growproc(n) < 0)
80105712:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105715:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105717:	ff 75 f4             	pushl  -0xc(%ebp)
8010571a:	e8 21 e3 ff ff       	call   80103a40 <growproc>
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	85 c0                	test   %eax,%eax
80105724:	78 0a                	js     80105730 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105726:	89 d8                	mov    %ebx,%eax
80105728:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010572b:	c9                   	leave  
8010572c:	c3                   	ret    
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105730:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105735:	eb ef                	jmp    80105726 <sys_sbrk+0x36>
80105737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010573e:	66 90                	xchg   %ax,%ax

80105740 <sys_sleep>:

int
sys_sleep(void)
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
80105745:	89 e5                	mov    %esp,%ebp
80105747:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105748:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010574b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010574e:	50                   	push   %eax
8010574f:	6a 00                	push   $0x0
80105751:	e8 aa f1 ff ff       	call   80104900 <argint>
80105756:	83 c4 10             	add    $0x10,%esp
80105759:	85 c0                	test   %eax,%eax
8010575b:	0f 88 86 00 00 00    	js     801057e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105761:	83 ec 0c             	sub    $0xc,%esp
80105764:	68 60 4c 11 80       	push   $0x80114c60
80105769:	e8 a2 ed ff ff       	call   80104510 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010576e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105771:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105777:	83 c4 10             	add    $0x10,%esp
8010577a:	85 d2                	test   %edx,%edx
8010577c:	75 23                	jne    801057a1 <sys_sleep+0x61>
8010577e:	eb 50                	jmp    801057d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105780:	83 ec 08             	sub    $0x8,%esp
80105783:	68 60 4c 11 80       	push   $0x80114c60
80105788:	68 a0 54 11 80       	push   $0x801154a0
8010578d:	e8 3e e7 ff ff       	call   80103ed0 <sleep>
  while(ticks - ticks0 < n){
80105792:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	29 d8                	sub    %ebx,%eax
8010579c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010579f:	73 2f                	jae    801057d0 <sys_sleep+0x90>
    if(myproc()->killed){
801057a1:	e8 6a e1 ff ff       	call   80103910 <myproc>
801057a6:	8b 40 24             	mov    0x24(%eax),%eax
801057a9:	85 c0                	test   %eax,%eax
801057ab:	74 d3                	je     80105780 <sys_sleep+0x40>
      release(&tickslock);
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	68 60 4c 11 80       	push   $0x80114c60
801057b5:	e8 16 ee ff ff       	call   801045d0 <release>
  }
  release(&tickslock);
  return 0;
}
801057ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057c5:	c9                   	leave  
801057c6:	c3                   	ret    
801057c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	68 60 4c 11 80       	push   $0x80114c60
801057d8:	e8 f3 ed ff ff       	call   801045d0 <release>
  return 0;
801057dd:	83 c4 10             	add    $0x10,%esp
801057e0:	31 c0                	xor    %eax,%eax
}
801057e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
    return -1;
801057e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ec:	eb f4                	jmp    801057e2 <sys_sleep+0xa2>
801057ee:	66 90                	xchg   %ax,%ax

801057f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801057f0:	f3 0f 1e fb          	endbr32 
801057f4:	55                   	push   %ebp
801057f5:	89 e5                	mov    %esp,%ebp
801057f7:	53                   	push   %ebx
801057f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801057fb:	68 60 4c 11 80       	push   $0x80114c60
80105800:	e8 0b ed ff ff       	call   80104510 <acquire>
  xticks = ticks;
80105805:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
8010580b:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105812:	e8 b9 ed ff ff       	call   801045d0 <release>
  return xticks;
}
80105817:	89 d8                	mov    %ebx,%eax
80105819:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010581c:	c9                   	leave  
8010581d:	c3                   	ret    

8010581e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010581e:	1e                   	push   %ds
  pushl %es
8010581f:	06                   	push   %es
  pushl %fs
80105820:	0f a0                	push   %fs
  pushl %gs
80105822:	0f a8                	push   %gs
  pushal
80105824:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105825:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105829:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010582b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010582d:	54                   	push   %esp
  call trap
8010582e:	e8 cd 00 00 00       	call   80105900 <trap>
  addl $4, %esp
80105833:	83 c4 04             	add    $0x4,%esp

80105836 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105836:	61                   	popa   
  popl %gs
80105837:	0f a9                	pop    %gs
  popl %fs
80105839:	0f a1                	pop    %fs
  popl %es
8010583b:	07                   	pop    %es
  popl %ds
8010583c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010583d:	83 c4 08             	add    $0x8,%esp
  iret
80105840:	cf                   	iret   
80105841:	66 90                	xchg   %ax,%ax
80105843:	66 90                	xchg   %ax,%ax
80105845:	66 90                	xchg   %ax,%ax
80105847:	66 90                	xchg   %ax,%ax
80105849:	66 90                	xchg   %ax,%ax
8010584b:	66 90                	xchg   %ax,%ax
8010584d:	66 90                	xchg   %ax,%ax
8010584f:	90                   	nop

80105850 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105850:	f3 0f 1e fb          	endbr32 
80105854:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105855:	31 c0                	xor    %eax,%eax
{
80105857:	89 e5                	mov    %esp,%ebp
80105859:	83 ec 08             	sub    $0x8,%esp
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105860:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105867:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010586e:	08 00 00 8e 
80105872:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105879:	80 
8010587a:	c1 ea 10             	shr    $0x10,%edx
8010587d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105884:	80 
  for(i = 0; i < 256; i++)
80105885:	83 c0 01             	add    $0x1,%eax
80105888:	3d 00 01 00 00       	cmp    $0x100,%eax
8010588d:	75 d1                	jne    80105860 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010588f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105892:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105897:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010589e:	00 00 ef 
  initlock(&tickslock, "time");
801058a1:	68 b9 77 10 80       	push   $0x801077b9
801058a6:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058ab:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801058b1:	c1 e8 10             	shr    $0x10,%eax
801058b4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801058ba:	e8 d1 ea ff ff       	call   80104390 <initlock>
}
801058bf:	83 c4 10             	add    $0x10,%esp
801058c2:	c9                   	leave  
801058c3:	c3                   	ret    
801058c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop

801058d0 <idtinit>:

void
idtinit(void)
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
  pd[0] = size-1;
801058d5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058da:	89 e5                	mov    %esp,%ebp
801058dc:	83 ec 10             	sub    $0x10,%esp
801058df:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058e3:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801058e8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801058ec:	c1 e8 10             	shr    $0x10,%eax
801058ef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801058f3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801058f6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801058f9:	c9                   	leave  
801058fa:	c3                   	ret    
801058fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058ff:	90                   	nop

80105900 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105900:	f3 0f 1e fb          	endbr32 
80105904:	55                   	push   %ebp
80105905:	89 e5                	mov    %esp,%ebp
80105907:	57                   	push   %edi
80105908:	56                   	push   %esi
80105909:	53                   	push   %ebx
8010590a:	83 ec 1c             	sub    $0x1c,%esp
8010590d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105910:	8b 43 30             	mov    0x30(%ebx),%eax
80105913:	83 f8 40             	cmp    $0x40,%eax
80105916:	0f 84 bc 01 00 00    	je     80105ad8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010591c:	83 e8 20             	sub    $0x20,%eax
8010591f:	83 f8 1f             	cmp    $0x1f,%eax
80105922:	77 08                	ja     8010592c <trap+0x2c>
80105924:	3e ff 24 85 60 78 10 	notrack jmp *-0x7fef87a0(,%eax,4)
8010592b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010592c:	e8 df df ff ff       	call   80103910 <myproc>
80105931:	8b 7b 38             	mov    0x38(%ebx),%edi
80105934:	85 c0                	test   %eax,%eax
80105936:	0f 84 eb 01 00 00    	je     80105b27 <trap+0x227>
8010593c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105940:	0f 84 e1 01 00 00    	je     80105b27 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105946:	0f 20 d1             	mov    %cr2,%ecx
80105949:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010594c:	e8 9f df ff ff       	call   801038f0 <cpuid>
80105951:	8b 73 30             	mov    0x30(%ebx),%esi
80105954:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105957:	8b 43 34             	mov    0x34(%ebx),%eax
8010595a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010595d:	e8 ae df ff ff       	call   80103910 <myproc>
80105962:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105965:	e8 a6 df ff ff       	call   80103910 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010596a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010596d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105970:	51                   	push   %ecx
80105971:	57                   	push   %edi
80105972:	52                   	push   %edx
80105973:	ff 75 e4             	pushl  -0x1c(%ebp)
80105976:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105977:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010597a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010597d:	56                   	push   %esi
8010597e:	ff 70 10             	pushl  0x10(%eax)
80105981:	68 1c 78 10 80       	push   $0x8010781c
80105986:	e8 25 ad ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010598b:	83 c4 20             	add    $0x20,%esp
8010598e:	e8 7d df ff ff       	call   80103910 <myproc>
80105993:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010599a:	e8 71 df ff ff       	call   80103910 <myproc>
8010599f:	85 c0                	test   %eax,%eax
801059a1:	74 1d                	je     801059c0 <trap+0xc0>
801059a3:	e8 68 df ff ff       	call   80103910 <myproc>
801059a8:	8b 50 24             	mov    0x24(%eax),%edx
801059ab:	85 d2                	test   %edx,%edx
801059ad:	74 11                	je     801059c0 <trap+0xc0>
801059af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059b3:	83 e0 03             	and    $0x3,%eax
801059b6:	66 83 f8 03          	cmp    $0x3,%ax
801059ba:	0f 84 50 01 00 00    	je     80105b10 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059c0:	e8 4b df ff ff       	call   80103910 <myproc>
801059c5:	85 c0                	test   %eax,%eax
801059c7:	74 0f                	je     801059d8 <trap+0xd8>
801059c9:	e8 42 df ff ff       	call   80103910 <myproc>
801059ce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059d2:	0f 84 e8 00 00 00    	je     80105ac0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d8:	e8 33 df ff ff       	call   80103910 <myproc>
801059dd:	85 c0                	test   %eax,%eax
801059df:	74 1d                	je     801059fe <trap+0xfe>
801059e1:	e8 2a df ff ff       	call   80103910 <myproc>
801059e6:	8b 40 24             	mov    0x24(%eax),%eax
801059e9:	85 c0                	test   %eax,%eax
801059eb:	74 11                	je     801059fe <trap+0xfe>
801059ed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801059f1:	83 e0 03             	and    $0x3,%eax
801059f4:	66 83 f8 03          	cmp    $0x3,%ax
801059f8:	0f 84 03 01 00 00    	je     80105b01 <trap+0x201>
    exit();
}
801059fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a01:	5b                   	pop    %ebx
80105a02:	5e                   	pop    %esi
80105a03:	5f                   	pop    %edi
80105a04:	5d                   	pop    %ebp
80105a05:	c3                   	ret    
    ideintr();
80105a06:	e8 95 c7 ff ff       	call   801021a0 <ideintr>
    lapiceoi();
80105a0b:	e8 70 ce ff ff       	call   80102880 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a10:	e8 fb de ff ff       	call   80103910 <myproc>
80105a15:	85 c0                	test   %eax,%eax
80105a17:	75 8a                	jne    801059a3 <trap+0xa3>
80105a19:	eb a5                	jmp    801059c0 <trap+0xc0>
    if(cpuid() == 0){
80105a1b:	e8 d0 de ff ff       	call   801038f0 <cpuid>
80105a20:	85 c0                	test   %eax,%eax
80105a22:	75 e7                	jne    80105a0b <trap+0x10b>
      acquire(&tickslock);
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	68 60 4c 11 80       	push   $0x80114c60
80105a2c:	e8 df ea ff ff       	call   80104510 <acquire>
      wakeup(&ticks);
80105a31:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a38:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a3f:	e8 4c e6 ff ff       	call   80104090 <wakeup>
      release(&tickslock);
80105a44:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a4b:	e8 80 eb ff ff       	call   801045d0 <release>
80105a50:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a53:	eb b6                	jmp    80105a0b <trap+0x10b>
    kbdintr();
80105a55:	e8 e6 cc ff ff       	call   80102740 <kbdintr>
    lapiceoi();
80105a5a:	e8 21 ce ff ff       	call   80102880 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a5f:	e8 ac de ff ff       	call   80103910 <myproc>
80105a64:	85 c0                	test   %eax,%eax
80105a66:	0f 85 37 ff ff ff    	jne    801059a3 <trap+0xa3>
80105a6c:	e9 4f ff ff ff       	jmp    801059c0 <trap+0xc0>
    uartintr();
80105a71:	e8 4a 02 00 00       	call   80105cc0 <uartintr>
    lapiceoi();
80105a76:	e8 05 ce ff ff       	call   80102880 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a7b:	e8 90 de ff ff       	call   80103910 <myproc>
80105a80:	85 c0                	test   %eax,%eax
80105a82:	0f 85 1b ff ff ff    	jne    801059a3 <trap+0xa3>
80105a88:	e9 33 ff ff ff       	jmp    801059c0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a8d:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a90:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105a94:	e8 57 de ff ff       	call   801038f0 <cpuid>
80105a99:	57                   	push   %edi
80105a9a:	56                   	push   %esi
80105a9b:	50                   	push   %eax
80105a9c:	68 c4 77 10 80       	push   $0x801077c4
80105aa1:	e8 0a ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105aa6:	e8 d5 cd ff ff       	call   80102880 <lapiceoi>
    break;
80105aab:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105aae:	e8 5d de ff ff       	call   80103910 <myproc>
80105ab3:	85 c0                	test   %eax,%eax
80105ab5:	0f 85 e8 fe ff ff    	jne    801059a3 <trap+0xa3>
80105abb:	e9 00 ff ff ff       	jmp    801059c0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
80105ac0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105ac4:	0f 85 0e ff ff ff    	jne    801059d8 <trap+0xd8>
    yield();
80105aca:	e8 b1 e3 ff ff       	call   80103e80 <yield>
80105acf:	e9 04 ff ff ff       	jmp    801059d8 <trap+0xd8>
80105ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105ad8:	e8 33 de ff ff       	call   80103910 <myproc>
80105add:	8b 70 24             	mov    0x24(%eax),%esi
80105ae0:	85 f6                	test   %esi,%esi
80105ae2:	75 3c                	jne    80105b20 <trap+0x220>
    myproc()->tf = tf;
80105ae4:	e8 27 de ff ff       	call   80103910 <myproc>
80105ae9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105aec:	e8 ff ee ff ff       	call   801049f0 <syscall>
    if(myproc()->killed)
80105af1:	e8 1a de ff ff       	call   80103910 <myproc>
80105af6:	8b 48 24             	mov    0x24(%eax),%ecx
80105af9:	85 c9                	test   %ecx,%ecx
80105afb:	0f 84 fd fe ff ff    	je     801059fe <trap+0xfe>
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b04:	5b                   	pop    %ebx
80105b05:	5e                   	pop    %esi
80105b06:	5f                   	pop    %edi
80105b07:	5d                   	pop    %ebp
      exit();
80105b08:	e9 33 e2 ff ff       	jmp    80103d40 <exit>
80105b0d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105b10:	e8 2b e2 ff ff       	call   80103d40 <exit>
80105b15:	e9 a6 fe ff ff       	jmp    801059c0 <trap+0xc0>
80105b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105b20:	e8 1b e2 ff ff       	call   80103d40 <exit>
80105b25:	eb bd                	jmp    80105ae4 <trap+0x1e4>
80105b27:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b2a:	e8 c1 dd ff ff       	call   801038f0 <cpuid>
80105b2f:	83 ec 0c             	sub    $0xc,%esp
80105b32:	56                   	push   %esi
80105b33:	57                   	push   %edi
80105b34:	50                   	push   %eax
80105b35:	ff 73 30             	pushl  0x30(%ebx)
80105b38:	68 e8 77 10 80       	push   $0x801077e8
80105b3d:	e8 6e ab ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105b42:	83 c4 14             	add    $0x14,%esp
80105b45:	68 be 77 10 80       	push   $0x801077be
80105b4a:	e8 41 a8 ff ff       	call   80100390 <panic>
80105b4f:	90                   	nop

80105b50 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105b50:	f3 0f 1e fb          	endbr32 
  if(!uart)
80105b54:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 1b                	je     80105b78 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b5d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b62:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b63:	a8 01                	test   $0x1,%al
80105b65:	74 11                	je     80105b78 <uartgetc+0x28>
80105b67:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b6c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b6d:	0f b6 c0             	movzbl %al,%eax
80105b70:	c3                   	ret    
80105b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b7d:	c3                   	ret    
80105b7e:	66 90                	xchg   %ax,%ax

80105b80 <uartputc.part.0>:
uartputc(int c)
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	89 c7                	mov    %eax,%edi
80105b86:	56                   	push   %esi
80105b87:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b8c:	53                   	push   %ebx
80105b8d:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b92:	83 ec 0c             	sub    $0xc,%esp
80105b95:	eb 1b                	jmp    80105bb2 <uartputc.part.0+0x32>
80105b97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	6a 0a                	push   $0xa
80105ba5:	e8 f6 cc ff ff       	call   801028a0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	83 eb 01             	sub    $0x1,%ebx
80105bb0:	74 07                	je     80105bb9 <uartputc.part.0+0x39>
80105bb2:	89 f2                	mov    %esi,%edx
80105bb4:	ec                   	in     (%dx),%al
80105bb5:	a8 20                	test   $0x20,%al
80105bb7:	74 e7                	je     80105ba0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bb9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bbe:	89 f8                	mov    %edi,%eax
80105bc0:	ee                   	out    %al,(%dx)
}
80105bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc4:	5b                   	pop    %ebx
80105bc5:	5e                   	pop    %esi
80105bc6:	5f                   	pop    %edi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <uartinit>:
{
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	31 c9                	xor    %ecx,%ecx
80105bd7:	89 c8                	mov    %ecx,%eax
80105bd9:	89 e5                	mov    %esp,%ebp
80105bdb:	57                   	push   %edi
80105bdc:	56                   	push   %esi
80105bdd:	53                   	push   %ebx
80105bde:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105be3:	89 da                	mov    %ebx,%edx
80105be5:	83 ec 0c             	sub    $0xc,%esp
80105be8:	ee                   	out    %al,(%dx)
80105be9:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bf3:	89 fa                	mov    %edi,%edx
80105bf5:	ee                   	out    %al,(%dx)
80105bf6:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bfb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c00:	ee                   	out    %al,(%dx)
80105c01:	be f9 03 00 00       	mov    $0x3f9,%esi
80105c06:	89 c8                	mov    %ecx,%eax
80105c08:	89 f2                	mov    %esi,%edx
80105c0a:	ee                   	out    %al,(%dx)
80105c0b:	b8 03 00 00 00       	mov    $0x3,%eax
80105c10:	89 fa                	mov    %edi,%edx
80105c12:	ee                   	out    %al,(%dx)
80105c13:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c18:	89 c8                	mov    %ecx,%eax
80105c1a:	ee                   	out    %al,(%dx)
80105c1b:	b8 01 00 00 00       	mov    $0x1,%eax
80105c20:	89 f2                	mov    %esi,%edx
80105c22:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c23:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c28:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105c29:	3c ff                	cmp    $0xff,%al
80105c2b:	74 52                	je     80105c7f <uartinit+0xaf>
  uart = 1;
80105c2d:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105c34:	00 00 00 
80105c37:	89 da                	mov    %ebx,%edx
80105c39:	ec                   	in     (%dx),%al
80105c3a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c3f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105c40:	83 ec 08             	sub    $0x8,%esp
80105c43:	be 6f 00 00 00       	mov    $0x6f,%esi
  for(p="xorg...\n"; *p; p++)
80105c48:	bb e0 78 10 80       	mov    $0x801078e0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105c4d:	6a 00                	push   $0x0
80105c4f:	6a 04                	push   $0x4
80105c51:	e8 9a c7 ff ff       	call   801023f0 <ioapicenable>
80105c56:	83 c4 10             	add    $0x10,%esp
  for(p="xorg...\n"; *p; p++)
80105c59:	b8 78 00 00 00       	mov    $0x78,%eax
80105c5e:	eb 04                	jmp    80105c64 <uartinit+0x94>
80105c60:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105c64:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105c6a:	85 d2                	test   %edx,%edx
80105c6c:	74 08                	je     80105c76 <uartinit+0xa6>
    uartputc(*p);
80105c6e:	0f be c0             	movsbl %al,%eax
80105c71:	e8 0a ff ff ff       	call   80105b80 <uartputc.part.0>
  for(p="xorg...\n"; *p; p++)
80105c76:	89 f0                	mov    %esi,%eax
80105c78:	83 c3 01             	add    $0x1,%ebx
80105c7b:	84 c0                	test   %al,%al
80105c7d:	75 e1                	jne    80105c60 <uartinit+0x90>
}
80105c7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c82:	5b                   	pop    %ebx
80105c83:	5e                   	pop    %esi
80105c84:	5f                   	pop    %edi
80105c85:	5d                   	pop    %ebp
80105c86:	c3                   	ret    
80105c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8e:	66 90                	xchg   %ax,%ax

80105c90 <uartputc>:
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
  if(!uart)
80105c95:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105c9b:	89 e5                	mov    %esp,%ebp
80105c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105ca0:	85 d2                	test   %edx,%edx
80105ca2:	74 0c                	je     80105cb0 <uartputc+0x20>
}
80105ca4:	5d                   	pop    %ebp
80105ca5:	e9 d6 fe ff ff       	jmp    80105b80 <uartputc.part.0>
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cb0:	5d                   	pop    %ebp
80105cb1:	c3                   	ret    
80105cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <uartintr>:

void
uartintr(void)
{
80105cc0:	f3 0f 1e fb          	endbr32 
80105cc4:	55                   	push   %ebp
80105cc5:	89 e5                	mov    %esp,%ebp
80105cc7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105cca:	68 50 5b 10 80       	push   $0x80105b50
80105ccf:	e8 8c ab ff ff       	call   80100860 <consoleintr>
}
80105cd4:	83 c4 10             	add    $0x10,%esp
80105cd7:	c9                   	leave  
80105cd8:	c3                   	ret    

80105cd9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cd9:	6a 00                	push   $0x0
  pushl $0
80105cdb:	6a 00                	push   $0x0
  jmp alltraps
80105cdd:	e9 3c fb ff ff       	jmp    8010581e <alltraps>

80105ce2 <vector1>:
.globl vector1
vector1:
  pushl $0
80105ce2:	6a 00                	push   $0x0
  pushl $1
80105ce4:	6a 01                	push   $0x1
  jmp alltraps
80105ce6:	e9 33 fb ff ff       	jmp    8010581e <alltraps>

80105ceb <vector2>:
.globl vector2
vector2:
  pushl $0
80105ceb:	6a 00                	push   $0x0
  pushl $2
80105ced:	6a 02                	push   $0x2
  jmp alltraps
80105cef:	e9 2a fb ff ff       	jmp    8010581e <alltraps>

80105cf4 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cf4:	6a 00                	push   $0x0
  pushl $3
80105cf6:	6a 03                	push   $0x3
  jmp alltraps
80105cf8:	e9 21 fb ff ff       	jmp    8010581e <alltraps>

80105cfd <vector4>:
.globl vector4
vector4:
  pushl $0
80105cfd:	6a 00                	push   $0x0
  pushl $4
80105cff:	6a 04                	push   $0x4
  jmp alltraps
80105d01:	e9 18 fb ff ff       	jmp    8010581e <alltraps>

80105d06 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d06:	6a 00                	push   $0x0
  pushl $5
80105d08:	6a 05                	push   $0x5
  jmp alltraps
80105d0a:	e9 0f fb ff ff       	jmp    8010581e <alltraps>

80105d0f <vector6>:
.globl vector6
vector6:
  pushl $0
80105d0f:	6a 00                	push   $0x0
  pushl $6
80105d11:	6a 06                	push   $0x6
  jmp alltraps
80105d13:	e9 06 fb ff ff       	jmp    8010581e <alltraps>

80105d18 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d18:	6a 00                	push   $0x0
  pushl $7
80105d1a:	6a 07                	push   $0x7
  jmp alltraps
80105d1c:	e9 fd fa ff ff       	jmp    8010581e <alltraps>

80105d21 <vector8>:
.globl vector8
vector8:
  pushl $8
80105d21:	6a 08                	push   $0x8
  jmp alltraps
80105d23:	e9 f6 fa ff ff       	jmp    8010581e <alltraps>

80105d28 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $9
80105d2a:	6a 09                	push   $0x9
  jmp alltraps
80105d2c:	e9 ed fa ff ff       	jmp    8010581e <alltraps>

80105d31 <vector10>:
.globl vector10
vector10:
  pushl $10
80105d31:	6a 0a                	push   $0xa
  jmp alltraps
80105d33:	e9 e6 fa ff ff       	jmp    8010581e <alltraps>

80105d38 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d38:	6a 0b                	push   $0xb
  jmp alltraps
80105d3a:	e9 df fa ff ff       	jmp    8010581e <alltraps>

80105d3f <vector12>:
.globl vector12
vector12:
  pushl $12
80105d3f:	6a 0c                	push   $0xc
  jmp alltraps
80105d41:	e9 d8 fa ff ff       	jmp    8010581e <alltraps>

80105d46 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d46:	6a 0d                	push   $0xd
  jmp alltraps
80105d48:	e9 d1 fa ff ff       	jmp    8010581e <alltraps>

80105d4d <vector14>:
.globl vector14
vector14:
  pushl $14
80105d4d:	6a 0e                	push   $0xe
  jmp alltraps
80105d4f:	e9 ca fa ff ff       	jmp    8010581e <alltraps>

80105d54 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d54:	6a 00                	push   $0x0
  pushl $15
80105d56:	6a 0f                	push   $0xf
  jmp alltraps
80105d58:	e9 c1 fa ff ff       	jmp    8010581e <alltraps>

80105d5d <vector16>:
.globl vector16
vector16:
  pushl $0
80105d5d:	6a 00                	push   $0x0
  pushl $16
80105d5f:	6a 10                	push   $0x10
  jmp alltraps
80105d61:	e9 b8 fa ff ff       	jmp    8010581e <alltraps>

80105d66 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d66:	6a 11                	push   $0x11
  jmp alltraps
80105d68:	e9 b1 fa ff ff       	jmp    8010581e <alltraps>

80105d6d <vector18>:
.globl vector18
vector18:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $18
80105d6f:	6a 12                	push   $0x12
  jmp alltraps
80105d71:	e9 a8 fa ff ff       	jmp    8010581e <alltraps>

80105d76 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $19
80105d78:	6a 13                	push   $0x13
  jmp alltraps
80105d7a:	e9 9f fa ff ff       	jmp    8010581e <alltraps>

80105d7f <vector20>:
.globl vector20
vector20:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $20
80105d81:	6a 14                	push   $0x14
  jmp alltraps
80105d83:	e9 96 fa ff ff       	jmp    8010581e <alltraps>

80105d88 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $21
80105d8a:	6a 15                	push   $0x15
  jmp alltraps
80105d8c:	e9 8d fa ff ff       	jmp    8010581e <alltraps>

80105d91 <vector22>:
.globl vector22
vector22:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $22
80105d93:	6a 16                	push   $0x16
  jmp alltraps
80105d95:	e9 84 fa ff ff       	jmp    8010581e <alltraps>

80105d9a <vector23>:
.globl vector23
vector23:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $23
80105d9c:	6a 17                	push   $0x17
  jmp alltraps
80105d9e:	e9 7b fa ff ff       	jmp    8010581e <alltraps>

80105da3 <vector24>:
.globl vector24
vector24:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $24
80105da5:	6a 18                	push   $0x18
  jmp alltraps
80105da7:	e9 72 fa ff ff       	jmp    8010581e <alltraps>

80105dac <vector25>:
.globl vector25
vector25:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $25
80105dae:	6a 19                	push   $0x19
  jmp alltraps
80105db0:	e9 69 fa ff ff       	jmp    8010581e <alltraps>

80105db5 <vector26>:
.globl vector26
vector26:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $26
80105db7:	6a 1a                	push   $0x1a
  jmp alltraps
80105db9:	e9 60 fa ff ff       	jmp    8010581e <alltraps>

80105dbe <vector27>:
.globl vector27
vector27:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $27
80105dc0:	6a 1b                	push   $0x1b
  jmp alltraps
80105dc2:	e9 57 fa ff ff       	jmp    8010581e <alltraps>

80105dc7 <vector28>:
.globl vector28
vector28:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $28
80105dc9:	6a 1c                	push   $0x1c
  jmp alltraps
80105dcb:	e9 4e fa ff ff       	jmp    8010581e <alltraps>

80105dd0 <vector29>:
.globl vector29
vector29:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $29
80105dd2:	6a 1d                	push   $0x1d
  jmp alltraps
80105dd4:	e9 45 fa ff ff       	jmp    8010581e <alltraps>

80105dd9 <vector30>:
.globl vector30
vector30:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $30
80105ddb:	6a 1e                	push   $0x1e
  jmp alltraps
80105ddd:	e9 3c fa ff ff       	jmp    8010581e <alltraps>

80105de2 <vector31>:
.globl vector31
vector31:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $31
80105de4:	6a 1f                	push   $0x1f
  jmp alltraps
80105de6:	e9 33 fa ff ff       	jmp    8010581e <alltraps>

80105deb <vector32>:
.globl vector32
vector32:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $32
80105ded:	6a 20                	push   $0x20
  jmp alltraps
80105def:	e9 2a fa ff ff       	jmp    8010581e <alltraps>

80105df4 <vector33>:
.globl vector33
vector33:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $33
80105df6:	6a 21                	push   $0x21
  jmp alltraps
80105df8:	e9 21 fa ff ff       	jmp    8010581e <alltraps>

80105dfd <vector34>:
.globl vector34
vector34:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $34
80105dff:	6a 22                	push   $0x22
  jmp alltraps
80105e01:	e9 18 fa ff ff       	jmp    8010581e <alltraps>

80105e06 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $35
80105e08:	6a 23                	push   $0x23
  jmp alltraps
80105e0a:	e9 0f fa ff ff       	jmp    8010581e <alltraps>

80105e0f <vector36>:
.globl vector36
vector36:
  pushl $0
80105e0f:	6a 00                	push   $0x0
  pushl $36
80105e11:	6a 24                	push   $0x24
  jmp alltraps
80105e13:	e9 06 fa ff ff       	jmp    8010581e <alltraps>

80105e18 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e18:	6a 00                	push   $0x0
  pushl $37
80105e1a:	6a 25                	push   $0x25
  jmp alltraps
80105e1c:	e9 fd f9 ff ff       	jmp    8010581e <alltraps>

80105e21 <vector38>:
.globl vector38
vector38:
  pushl $0
80105e21:	6a 00                	push   $0x0
  pushl $38
80105e23:	6a 26                	push   $0x26
  jmp alltraps
80105e25:	e9 f4 f9 ff ff       	jmp    8010581e <alltraps>

80105e2a <vector39>:
.globl vector39
vector39:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $39
80105e2c:	6a 27                	push   $0x27
  jmp alltraps
80105e2e:	e9 eb f9 ff ff       	jmp    8010581e <alltraps>

80105e33 <vector40>:
.globl vector40
vector40:
  pushl $0
80105e33:	6a 00                	push   $0x0
  pushl $40
80105e35:	6a 28                	push   $0x28
  jmp alltraps
80105e37:	e9 e2 f9 ff ff       	jmp    8010581e <alltraps>

80105e3c <vector41>:
.globl vector41
vector41:
  pushl $0
80105e3c:	6a 00                	push   $0x0
  pushl $41
80105e3e:	6a 29                	push   $0x29
  jmp alltraps
80105e40:	e9 d9 f9 ff ff       	jmp    8010581e <alltraps>

80105e45 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e45:	6a 00                	push   $0x0
  pushl $42
80105e47:	6a 2a                	push   $0x2a
  jmp alltraps
80105e49:	e9 d0 f9 ff ff       	jmp    8010581e <alltraps>

80105e4e <vector43>:
.globl vector43
vector43:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $43
80105e50:	6a 2b                	push   $0x2b
  jmp alltraps
80105e52:	e9 c7 f9 ff ff       	jmp    8010581e <alltraps>

80105e57 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e57:	6a 00                	push   $0x0
  pushl $44
80105e59:	6a 2c                	push   $0x2c
  jmp alltraps
80105e5b:	e9 be f9 ff ff       	jmp    8010581e <alltraps>

80105e60 <vector45>:
.globl vector45
vector45:
  pushl $0
80105e60:	6a 00                	push   $0x0
  pushl $45
80105e62:	6a 2d                	push   $0x2d
  jmp alltraps
80105e64:	e9 b5 f9 ff ff       	jmp    8010581e <alltraps>

80105e69 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e69:	6a 00                	push   $0x0
  pushl $46
80105e6b:	6a 2e                	push   $0x2e
  jmp alltraps
80105e6d:	e9 ac f9 ff ff       	jmp    8010581e <alltraps>

80105e72 <vector47>:
.globl vector47
vector47:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $47
80105e74:	6a 2f                	push   $0x2f
  jmp alltraps
80105e76:	e9 a3 f9 ff ff       	jmp    8010581e <alltraps>

80105e7b <vector48>:
.globl vector48
vector48:
  pushl $0
80105e7b:	6a 00                	push   $0x0
  pushl $48
80105e7d:	6a 30                	push   $0x30
  jmp alltraps
80105e7f:	e9 9a f9 ff ff       	jmp    8010581e <alltraps>

80105e84 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e84:	6a 00                	push   $0x0
  pushl $49
80105e86:	6a 31                	push   $0x31
  jmp alltraps
80105e88:	e9 91 f9 ff ff       	jmp    8010581e <alltraps>

80105e8d <vector50>:
.globl vector50
vector50:
  pushl $0
80105e8d:	6a 00                	push   $0x0
  pushl $50
80105e8f:	6a 32                	push   $0x32
  jmp alltraps
80105e91:	e9 88 f9 ff ff       	jmp    8010581e <alltraps>

80105e96 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $51
80105e98:	6a 33                	push   $0x33
  jmp alltraps
80105e9a:	e9 7f f9 ff ff       	jmp    8010581e <alltraps>

80105e9f <vector52>:
.globl vector52
vector52:
  pushl $0
80105e9f:	6a 00                	push   $0x0
  pushl $52
80105ea1:	6a 34                	push   $0x34
  jmp alltraps
80105ea3:	e9 76 f9 ff ff       	jmp    8010581e <alltraps>

80105ea8 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ea8:	6a 00                	push   $0x0
  pushl $53
80105eaa:	6a 35                	push   $0x35
  jmp alltraps
80105eac:	e9 6d f9 ff ff       	jmp    8010581e <alltraps>

80105eb1 <vector54>:
.globl vector54
vector54:
  pushl $0
80105eb1:	6a 00                	push   $0x0
  pushl $54
80105eb3:	6a 36                	push   $0x36
  jmp alltraps
80105eb5:	e9 64 f9 ff ff       	jmp    8010581e <alltraps>

80105eba <vector55>:
.globl vector55
vector55:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $55
80105ebc:	6a 37                	push   $0x37
  jmp alltraps
80105ebe:	e9 5b f9 ff ff       	jmp    8010581e <alltraps>

80105ec3 <vector56>:
.globl vector56
vector56:
  pushl $0
80105ec3:	6a 00                	push   $0x0
  pushl $56
80105ec5:	6a 38                	push   $0x38
  jmp alltraps
80105ec7:	e9 52 f9 ff ff       	jmp    8010581e <alltraps>

80105ecc <vector57>:
.globl vector57
vector57:
  pushl $0
80105ecc:	6a 00                	push   $0x0
  pushl $57
80105ece:	6a 39                	push   $0x39
  jmp alltraps
80105ed0:	e9 49 f9 ff ff       	jmp    8010581e <alltraps>

80105ed5 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ed5:	6a 00                	push   $0x0
  pushl $58
80105ed7:	6a 3a                	push   $0x3a
  jmp alltraps
80105ed9:	e9 40 f9 ff ff       	jmp    8010581e <alltraps>

80105ede <vector59>:
.globl vector59
vector59:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $59
80105ee0:	6a 3b                	push   $0x3b
  jmp alltraps
80105ee2:	e9 37 f9 ff ff       	jmp    8010581e <alltraps>

80105ee7 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ee7:	6a 00                	push   $0x0
  pushl $60
80105ee9:	6a 3c                	push   $0x3c
  jmp alltraps
80105eeb:	e9 2e f9 ff ff       	jmp    8010581e <alltraps>

80105ef0 <vector61>:
.globl vector61
vector61:
  pushl $0
80105ef0:	6a 00                	push   $0x0
  pushl $61
80105ef2:	6a 3d                	push   $0x3d
  jmp alltraps
80105ef4:	e9 25 f9 ff ff       	jmp    8010581e <alltraps>

80105ef9 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ef9:	6a 00                	push   $0x0
  pushl $62
80105efb:	6a 3e                	push   $0x3e
  jmp alltraps
80105efd:	e9 1c f9 ff ff       	jmp    8010581e <alltraps>

80105f02 <vector63>:
.globl vector63
vector63:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $63
80105f04:	6a 3f                	push   $0x3f
  jmp alltraps
80105f06:	e9 13 f9 ff ff       	jmp    8010581e <alltraps>

80105f0b <vector64>:
.globl vector64
vector64:
  pushl $0
80105f0b:	6a 00                	push   $0x0
  pushl $64
80105f0d:	6a 40                	push   $0x40
  jmp alltraps
80105f0f:	e9 0a f9 ff ff       	jmp    8010581e <alltraps>

80105f14 <vector65>:
.globl vector65
vector65:
  pushl $0
80105f14:	6a 00                	push   $0x0
  pushl $65
80105f16:	6a 41                	push   $0x41
  jmp alltraps
80105f18:	e9 01 f9 ff ff       	jmp    8010581e <alltraps>

80105f1d <vector66>:
.globl vector66
vector66:
  pushl $0
80105f1d:	6a 00                	push   $0x0
  pushl $66
80105f1f:	6a 42                	push   $0x42
  jmp alltraps
80105f21:	e9 f8 f8 ff ff       	jmp    8010581e <alltraps>

80105f26 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $67
80105f28:	6a 43                	push   $0x43
  jmp alltraps
80105f2a:	e9 ef f8 ff ff       	jmp    8010581e <alltraps>

80105f2f <vector68>:
.globl vector68
vector68:
  pushl $0
80105f2f:	6a 00                	push   $0x0
  pushl $68
80105f31:	6a 44                	push   $0x44
  jmp alltraps
80105f33:	e9 e6 f8 ff ff       	jmp    8010581e <alltraps>

80105f38 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f38:	6a 00                	push   $0x0
  pushl $69
80105f3a:	6a 45                	push   $0x45
  jmp alltraps
80105f3c:	e9 dd f8 ff ff       	jmp    8010581e <alltraps>

80105f41 <vector70>:
.globl vector70
vector70:
  pushl $0
80105f41:	6a 00                	push   $0x0
  pushl $70
80105f43:	6a 46                	push   $0x46
  jmp alltraps
80105f45:	e9 d4 f8 ff ff       	jmp    8010581e <alltraps>

80105f4a <vector71>:
.globl vector71
vector71:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $71
80105f4c:	6a 47                	push   $0x47
  jmp alltraps
80105f4e:	e9 cb f8 ff ff       	jmp    8010581e <alltraps>

80105f53 <vector72>:
.globl vector72
vector72:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $72
80105f55:	6a 48                	push   $0x48
  jmp alltraps
80105f57:	e9 c2 f8 ff ff       	jmp    8010581e <alltraps>

80105f5c <vector73>:
.globl vector73
vector73:
  pushl $0
80105f5c:	6a 00                	push   $0x0
  pushl $73
80105f5e:	6a 49                	push   $0x49
  jmp alltraps
80105f60:	e9 b9 f8 ff ff       	jmp    8010581e <alltraps>

80105f65 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f65:	6a 00                	push   $0x0
  pushl $74
80105f67:	6a 4a                	push   $0x4a
  jmp alltraps
80105f69:	e9 b0 f8 ff ff       	jmp    8010581e <alltraps>

80105f6e <vector75>:
.globl vector75
vector75:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $75
80105f70:	6a 4b                	push   $0x4b
  jmp alltraps
80105f72:	e9 a7 f8 ff ff       	jmp    8010581e <alltraps>

80105f77 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f77:	6a 00                	push   $0x0
  pushl $76
80105f79:	6a 4c                	push   $0x4c
  jmp alltraps
80105f7b:	e9 9e f8 ff ff       	jmp    8010581e <alltraps>

80105f80 <vector77>:
.globl vector77
vector77:
  pushl $0
80105f80:	6a 00                	push   $0x0
  pushl $77
80105f82:	6a 4d                	push   $0x4d
  jmp alltraps
80105f84:	e9 95 f8 ff ff       	jmp    8010581e <alltraps>

80105f89 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f89:	6a 00                	push   $0x0
  pushl $78
80105f8b:	6a 4e                	push   $0x4e
  jmp alltraps
80105f8d:	e9 8c f8 ff ff       	jmp    8010581e <alltraps>

80105f92 <vector79>:
.globl vector79
vector79:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $79
80105f94:	6a 4f                	push   $0x4f
  jmp alltraps
80105f96:	e9 83 f8 ff ff       	jmp    8010581e <alltraps>

80105f9b <vector80>:
.globl vector80
vector80:
  pushl $0
80105f9b:	6a 00                	push   $0x0
  pushl $80
80105f9d:	6a 50                	push   $0x50
  jmp alltraps
80105f9f:	e9 7a f8 ff ff       	jmp    8010581e <alltraps>

80105fa4 <vector81>:
.globl vector81
vector81:
  pushl $0
80105fa4:	6a 00                	push   $0x0
  pushl $81
80105fa6:	6a 51                	push   $0x51
  jmp alltraps
80105fa8:	e9 71 f8 ff ff       	jmp    8010581e <alltraps>

80105fad <vector82>:
.globl vector82
vector82:
  pushl $0
80105fad:	6a 00                	push   $0x0
  pushl $82
80105faf:	6a 52                	push   $0x52
  jmp alltraps
80105fb1:	e9 68 f8 ff ff       	jmp    8010581e <alltraps>

80105fb6 <vector83>:
.globl vector83
vector83:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $83
80105fb8:	6a 53                	push   $0x53
  jmp alltraps
80105fba:	e9 5f f8 ff ff       	jmp    8010581e <alltraps>

80105fbf <vector84>:
.globl vector84
vector84:
  pushl $0
80105fbf:	6a 00                	push   $0x0
  pushl $84
80105fc1:	6a 54                	push   $0x54
  jmp alltraps
80105fc3:	e9 56 f8 ff ff       	jmp    8010581e <alltraps>

80105fc8 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fc8:	6a 00                	push   $0x0
  pushl $85
80105fca:	6a 55                	push   $0x55
  jmp alltraps
80105fcc:	e9 4d f8 ff ff       	jmp    8010581e <alltraps>

80105fd1 <vector86>:
.globl vector86
vector86:
  pushl $0
80105fd1:	6a 00                	push   $0x0
  pushl $86
80105fd3:	6a 56                	push   $0x56
  jmp alltraps
80105fd5:	e9 44 f8 ff ff       	jmp    8010581e <alltraps>

80105fda <vector87>:
.globl vector87
vector87:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $87
80105fdc:	6a 57                	push   $0x57
  jmp alltraps
80105fde:	e9 3b f8 ff ff       	jmp    8010581e <alltraps>

80105fe3 <vector88>:
.globl vector88
vector88:
  pushl $0
80105fe3:	6a 00                	push   $0x0
  pushl $88
80105fe5:	6a 58                	push   $0x58
  jmp alltraps
80105fe7:	e9 32 f8 ff ff       	jmp    8010581e <alltraps>

80105fec <vector89>:
.globl vector89
vector89:
  pushl $0
80105fec:	6a 00                	push   $0x0
  pushl $89
80105fee:	6a 59                	push   $0x59
  jmp alltraps
80105ff0:	e9 29 f8 ff ff       	jmp    8010581e <alltraps>

80105ff5 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ff5:	6a 00                	push   $0x0
  pushl $90
80105ff7:	6a 5a                	push   $0x5a
  jmp alltraps
80105ff9:	e9 20 f8 ff ff       	jmp    8010581e <alltraps>

80105ffe <vector91>:
.globl vector91
vector91:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $91
80106000:	6a 5b                	push   $0x5b
  jmp alltraps
80106002:	e9 17 f8 ff ff       	jmp    8010581e <alltraps>

80106007 <vector92>:
.globl vector92
vector92:
  pushl $0
80106007:	6a 00                	push   $0x0
  pushl $92
80106009:	6a 5c                	push   $0x5c
  jmp alltraps
8010600b:	e9 0e f8 ff ff       	jmp    8010581e <alltraps>

80106010 <vector93>:
.globl vector93
vector93:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $93
80106012:	6a 5d                	push   $0x5d
  jmp alltraps
80106014:	e9 05 f8 ff ff       	jmp    8010581e <alltraps>

80106019 <vector94>:
.globl vector94
vector94:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $94
8010601b:	6a 5e                	push   $0x5e
  jmp alltraps
8010601d:	e9 fc f7 ff ff       	jmp    8010581e <alltraps>

80106022 <vector95>:
.globl vector95
vector95:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $95
80106024:	6a 5f                	push   $0x5f
  jmp alltraps
80106026:	e9 f3 f7 ff ff       	jmp    8010581e <alltraps>

8010602b <vector96>:
.globl vector96
vector96:
  pushl $0
8010602b:	6a 00                	push   $0x0
  pushl $96
8010602d:	6a 60                	push   $0x60
  jmp alltraps
8010602f:	e9 ea f7 ff ff       	jmp    8010581e <alltraps>

80106034 <vector97>:
.globl vector97
vector97:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $97
80106036:	6a 61                	push   $0x61
  jmp alltraps
80106038:	e9 e1 f7 ff ff       	jmp    8010581e <alltraps>

8010603d <vector98>:
.globl vector98
vector98:
  pushl $0
8010603d:	6a 00                	push   $0x0
  pushl $98
8010603f:	6a 62                	push   $0x62
  jmp alltraps
80106041:	e9 d8 f7 ff ff       	jmp    8010581e <alltraps>

80106046 <vector99>:
.globl vector99
vector99:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $99
80106048:	6a 63                	push   $0x63
  jmp alltraps
8010604a:	e9 cf f7 ff ff       	jmp    8010581e <alltraps>

8010604f <vector100>:
.globl vector100
vector100:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $100
80106051:	6a 64                	push   $0x64
  jmp alltraps
80106053:	e9 c6 f7 ff ff       	jmp    8010581e <alltraps>

80106058 <vector101>:
.globl vector101
vector101:
  pushl $0
80106058:	6a 00                	push   $0x0
  pushl $101
8010605a:	6a 65                	push   $0x65
  jmp alltraps
8010605c:	e9 bd f7 ff ff       	jmp    8010581e <alltraps>

80106061 <vector102>:
.globl vector102
vector102:
  pushl $0
80106061:	6a 00                	push   $0x0
  pushl $102
80106063:	6a 66                	push   $0x66
  jmp alltraps
80106065:	e9 b4 f7 ff ff       	jmp    8010581e <alltraps>

8010606a <vector103>:
.globl vector103
vector103:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $103
8010606c:	6a 67                	push   $0x67
  jmp alltraps
8010606e:	e9 ab f7 ff ff       	jmp    8010581e <alltraps>

80106073 <vector104>:
.globl vector104
vector104:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $104
80106075:	6a 68                	push   $0x68
  jmp alltraps
80106077:	e9 a2 f7 ff ff       	jmp    8010581e <alltraps>

8010607c <vector105>:
.globl vector105
vector105:
  pushl $0
8010607c:	6a 00                	push   $0x0
  pushl $105
8010607e:	6a 69                	push   $0x69
  jmp alltraps
80106080:	e9 99 f7 ff ff       	jmp    8010581e <alltraps>

80106085 <vector106>:
.globl vector106
vector106:
  pushl $0
80106085:	6a 00                	push   $0x0
  pushl $106
80106087:	6a 6a                	push   $0x6a
  jmp alltraps
80106089:	e9 90 f7 ff ff       	jmp    8010581e <alltraps>

8010608e <vector107>:
.globl vector107
vector107:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $107
80106090:	6a 6b                	push   $0x6b
  jmp alltraps
80106092:	e9 87 f7 ff ff       	jmp    8010581e <alltraps>

80106097 <vector108>:
.globl vector108
vector108:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $108
80106099:	6a 6c                	push   $0x6c
  jmp alltraps
8010609b:	e9 7e f7 ff ff       	jmp    8010581e <alltraps>

801060a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801060a0:	6a 00                	push   $0x0
  pushl $109
801060a2:	6a 6d                	push   $0x6d
  jmp alltraps
801060a4:	e9 75 f7 ff ff       	jmp    8010581e <alltraps>

801060a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801060a9:	6a 00                	push   $0x0
  pushl $110
801060ab:	6a 6e                	push   $0x6e
  jmp alltraps
801060ad:	e9 6c f7 ff ff       	jmp    8010581e <alltraps>

801060b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $111
801060b4:	6a 6f                	push   $0x6f
  jmp alltraps
801060b6:	e9 63 f7 ff ff       	jmp    8010581e <alltraps>

801060bb <vector112>:
.globl vector112
vector112:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $112
801060bd:	6a 70                	push   $0x70
  jmp alltraps
801060bf:	e9 5a f7 ff ff       	jmp    8010581e <alltraps>

801060c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801060c4:	6a 00                	push   $0x0
  pushl $113
801060c6:	6a 71                	push   $0x71
  jmp alltraps
801060c8:	e9 51 f7 ff ff       	jmp    8010581e <alltraps>

801060cd <vector114>:
.globl vector114
vector114:
  pushl $0
801060cd:	6a 00                	push   $0x0
  pushl $114
801060cf:	6a 72                	push   $0x72
  jmp alltraps
801060d1:	e9 48 f7 ff ff       	jmp    8010581e <alltraps>

801060d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $115
801060d8:	6a 73                	push   $0x73
  jmp alltraps
801060da:	e9 3f f7 ff ff       	jmp    8010581e <alltraps>

801060df <vector116>:
.globl vector116
vector116:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $116
801060e1:	6a 74                	push   $0x74
  jmp alltraps
801060e3:	e9 36 f7 ff ff       	jmp    8010581e <alltraps>

801060e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801060e8:	6a 00                	push   $0x0
  pushl $117
801060ea:	6a 75                	push   $0x75
  jmp alltraps
801060ec:	e9 2d f7 ff ff       	jmp    8010581e <alltraps>

801060f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801060f1:	6a 00                	push   $0x0
  pushl $118
801060f3:	6a 76                	push   $0x76
  jmp alltraps
801060f5:	e9 24 f7 ff ff       	jmp    8010581e <alltraps>

801060fa <vector119>:
.globl vector119
vector119:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $119
801060fc:	6a 77                	push   $0x77
  jmp alltraps
801060fe:	e9 1b f7 ff ff       	jmp    8010581e <alltraps>

80106103 <vector120>:
.globl vector120
vector120:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $120
80106105:	6a 78                	push   $0x78
  jmp alltraps
80106107:	e9 12 f7 ff ff       	jmp    8010581e <alltraps>

8010610c <vector121>:
.globl vector121
vector121:
  pushl $0
8010610c:	6a 00                	push   $0x0
  pushl $121
8010610e:	6a 79                	push   $0x79
  jmp alltraps
80106110:	e9 09 f7 ff ff       	jmp    8010581e <alltraps>

80106115 <vector122>:
.globl vector122
vector122:
  pushl $0
80106115:	6a 00                	push   $0x0
  pushl $122
80106117:	6a 7a                	push   $0x7a
  jmp alltraps
80106119:	e9 00 f7 ff ff       	jmp    8010581e <alltraps>

8010611e <vector123>:
.globl vector123
vector123:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $123
80106120:	6a 7b                	push   $0x7b
  jmp alltraps
80106122:	e9 f7 f6 ff ff       	jmp    8010581e <alltraps>

80106127 <vector124>:
.globl vector124
vector124:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $124
80106129:	6a 7c                	push   $0x7c
  jmp alltraps
8010612b:	e9 ee f6 ff ff       	jmp    8010581e <alltraps>

80106130 <vector125>:
.globl vector125
vector125:
  pushl $0
80106130:	6a 00                	push   $0x0
  pushl $125
80106132:	6a 7d                	push   $0x7d
  jmp alltraps
80106134:	e9 e5 f6 ff ff       	jmp    8010581e <alltraps>

80106139 <vector126>:
.globl vector126
vector126:
  pushl $0
80106139:	6a 00                	push   $0x0
  pushl $126
8010613b:	6a 7e                	push   $0x7e
  jmp alltraps
8010613d:	e9 dc f6 ff ff       	jmp    8010581e <alltraps>

80106142 <vector127>:
.globl vector127
vector127:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $127
80106144:	6a 7f                	push   $0x7f
  jmp alltraps
80106146:	e9 d3 f6 ff ff       	jmp    8010581e <alltraps>

8010614b <vector128>:
.globl vector128
vector128:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $128
8010614d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106152:	e9 c7 f6 ff ff       	jmp    8010581e <alltraps>

80106157 <vector129>:
.globl vector129
vector129:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $129
80106159:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010615e:	e9 bb f6 ff ff       	jmp    8010581e <alltraps>

80106163 <vector130>:
.globl vector130
vector130:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $130
80106165:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010616a:	e9 af f6 ff ff       	jmp    8010581e <alltraps>

8010616f <vector131>:
.globl vector131
vector131:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $131
80106171:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106176:	e9 a3 f6 ff ff       	jmp    8010581e <alltraps>

8010617b <vector132>:
.globl vector132
vector132:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $132
8010617d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106182:	e9 97 f6 ff ff       	jmp    8010581e <alltraps>

80106187 <vector133>:
.globl vector133
vector133:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $133
80106189:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010618e:	e9 8b f6 ff ff       	jmp    8010581e <alltraps>

80106193 <vector134>:
.globl vector134
vector134:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $134
80106195:	68 86 00 00 00       	push   $0x86
  jmp alltraps
8010619a:	e9 7f f6 ff ff       	jmp    8010581e <alltraps>

8010619f <vector135>:
.globl vector135
vector135:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $135
801061a1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801061a6:	e9 73 f6 ff ff       	jmp    8010581e <alltraps>

801061ab <vector136>:
.globl vector136
vector136:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $136
801061ad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801061b2:	e9 67 f6 ff ff       	jmp    8010581e <alltraps>

801061b7 <vector137>:
.globl vector137
vector137:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $137
801061b9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801061be:	e9 5b f6 ff ff       	jmp    8010581e <alltraps>

801061c3 <vector138>:
.globl vector138
vector138:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $138
801061c5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061ca:	e9 4f f6 ff ff       	jmp    8010581e <alltraps>

801061cf <vector139>:
.globl vector139
vector139:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $139
801061d1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061d6:	e9 43 f6 ff ff       	jmp    8010581e <alltraps>

801061db <vector140>:
.globl vector140
vector140:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $140
801061dd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061e2:	e9 37 f6 ff ff       	jmp    8010581e <alltraps>

801061e7 <vector141>:
.globl vector141
vector141:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $141
801061e9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061ee:	e9 2b f6 ff ff       	jmp    8010581e <alltraps>

801061f3 <vector142>:
.globl vector142
vector142:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $142
801061f5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061fa:	e9 1f f6 ff ff       	jmp    8010581e <alltraps>

801061ff <vector143>:
.globl vector143
vector143:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $143
80106201:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106206:	e9 13 f6 ff ff       	jmp    8010581e <alltraps>

8010620b <vector144>:
.globl vector144
vector144:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $144
8010620d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106212:	e9 07 f6 ff ff       	jmp    8010581e <alltraps>

80106217 <vector145>:
.globl vector145
vector145:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $145
80106219:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010621e:	e9 fb f5 ff ff       	jmp    8010581e <alltraps>

80106223 <vector146>:
.globl vector146
vector146:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $146
80106225:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010622a:	e9 ef f5 ff ff       	jmp    8010581e <alltraps>

8010622f <vector147>:
.globl vector147
vector147:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $147
80106231:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106236:	e9 e3 f5 ff ff       	jmp    8010581e <alltraps>

8010623b <vector148>:
.globl vector148
vector148:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $148
8010623d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106242:	e9 d7 f5 ff ff       	jmp    8010581e <alltraps>

80106247 <vector149>:
.globl vector149
vector149:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $149
80106249:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010624e:	e9 cb f5 ff ff       	jmp    8010581e <alltraps>

80106253 <vector150>:
.globl vector150
vector150:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $150
80106255:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010625a:	e9 bf f5 ff ff       	jmp    8010581e <alltraps>

8010625f <vector151>:
.globl vector151
vector151:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $151
80106261:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106266:	e9 b3 f5 ff ff       	jmp    8010581e <alltraps>

8010626b <vector152>:
.globl vector152
vector152:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $152
8010626d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106272:	e9 a7 f5 ff ff       	jmp    8010581e <alltraps>

80106277 <vector153>:
.globl vector153
vector153:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $153
80106279:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010627e:	e9 9b f5 ff ff       	jmp    8010581e <alltraps>

80106283 <vector154>:
.globl vector154
vector154:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $154
80106285:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010628a:	e9 8f f5 ff ff       	jmp    8010581e <alltraps>

8010628f <vector155>:
.globl vector155
vector155:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $155
80106291:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106296:	e9 83 f5 ff ff       	jmp    8010581e <alltraps>

8010629b <vector156>:
.globl vector156
vector156:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $156
8010629d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801062a2:	e9 77 f5 ff ff       	jmp    8010581e <alltraps>

801062a7 <vector157>:
.globl vector157
vector157:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $157
801062a9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801062ae:	e9 6b f5 ff ff       	jmp    8010581e <alltraps>

801062b3 <vector158>:
.globl vector158
vector158:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $158
801062b5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801062ba:	e9 5f f5 ff ff       	jmp    8010581e <alltraps>

801062bf <vector159>:
.globl vector159
vector159:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $159
801062c1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062c6:	e9 53 f5 ff ff       	jmp    8010581e <alltraps>

801062cb <vector160>:
.globl vector160
vector160:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $160
801062cd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062d2:	e9 47 f5 ff ff       	jmp    8010581e <alltraps>

801062d7 <vector161>:
.globl vector161
vector161:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $161
801062d9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062de:	e9 3b f5 ff ff       	jmp    8010581e <alltraps>

801062e3 <vector162>:
.globl vector162
vector162:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $162
801062e5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062ea:	e9 2f f5 ff ff       	jmp    8010581e <alltraps>

801062ef <vector163>:
.globl vector163
vector163:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $163
801062f1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062f6:	e9 23 f5 ff ff       	jmp    8010581e <alltraps>

801062fb <vector164>:
.globl vector164
vector164:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $164
801062fd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106302:	e9 17 f5 ff ff       	jmp    8010581e <alltraps>

80106307 <vector165>:
.globl vector165
vector165:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $165
80106309:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010630e:	e9 0b f5 ff ff       	jmp    8010581e <alltraps>

80106313 <vector166>:
.globl vector166
vector166:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $166
80106315:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010631a:	e9 ff f4 ff ff       	jmp    8010581e <alltraps>

8010631f <vector167>:
.globl vector167
vector167:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $167
80106321:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106326:	e9 f3 f4 ff ff       	jmp    8010581e <alltraps>

8010632b <vector168>:
.globl vector168
vector168:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $168
8010632d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106332:	e9 e7 f4 ff ff       	jmp    8010581e <alltraps>

80106337 <vector169>:
.globl vector169
vector169:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $169
80106339:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010633e:	e9 db f4 ff ff       	jmp    8010581e <alltraps>

80106343 <vector170>:
.globl vector170
vector170:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $170
80106345:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010634a:	e9 cf f4 ff ff       	jmp    8010581e <alltraps>

8010634f <vector171>:
.globl vector171
vector171:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $171
80106351:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106356:	e9 c3 f4 ff ff       	jmp    8010581e <alltraps>

8010635b <vector172>:
.globl vector172
vector172:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $172
8010635d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106362:	e9 b7 f4 ff ff       	jmp    8010581e <alltraps>

80106367 <vector173>:
.globl vector173
vector173:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $173
80106369:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010636e:	e9 ab f4 ff ff       	jmp    8010581e <alltraps>

80106373 <vector174>:
.globl vector174
vector174:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $174
80106375:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010637a:	e9 9f f4 ff ff       	jmp    8010581e <alltraps>

8010637f <vector175>:
.globl vector175
vector175:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $175
80106381:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106386:	e9 93 f4 ff ff       	jmp    8010581e <alltraps>

8010638b <vector176>:
.globl vector176
vector176:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $176
8010638d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106392:	e9 87 f4 ff ff       	jmp    8010581e <alltraps>

80106397 <vector177>:
.globl vector177
vector177:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $177
80106399:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010639e:	e9 7b f4 ff ff       	jmp    8010581e <alltraps>

801063a3 <vector178>:
.globl vector178
vector178:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $178
801063a5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801063aa:	e9 6f f4 ff ff       	jmp    8010581e <alltraps>

801063af <vector179>:
.globl vector179
vector179:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $179
801063b1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801063b6:	e9 63 f4 ff ff       	jmp    8010581e <alltraps>

801063bb <vector180>:
.globl vector180
vector180:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $180
801063bd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801063c2:	e9 57 f4 ff ff       	jmp    8010581e <alltraps>

801063c7 <vector181>:
.globl vector181
vector181:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $181
801063c9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063ce:	e9 4b f4 ff ff       	jmp    8010581e <alltraps>

801063d3 <vector182>:
.globl vector182
vector182:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $182
801063d5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063da:	e9 3f f4 ff ff       	jmp    8010581e <alltraps>

801063df <vector183>:
.globl vector183
vector183:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $183
801063e1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063e6:	e9 33 f4 ff ff       	jmp    8010581e <alltraps>

801063eb <vector184>:
.globl vector184
vector184:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $184
801063ed:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063f2:	e9 27 f4 ff ff       	jmp    8010581e <alltraps>

801063f7 <vector185>:
.globl vector185
vector185:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $185
801063f9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063fe:	e9 1b f4 ff ff       	jmp    8010581e <alltraps>

80106403 <vector186>:
.globl vector186
vector186:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $186
80106405:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010640a:	e9 0f f4 ff ff       	jmp    8010581e <alltraps>

8010640f <vector187>:
.globl vector187
vector187:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $187
80106411:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106416:	e9 03 f4 ff ff       	jmp    8010581e <alltraps>

8010641b <vector188>:
.globl vector188
vector188:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $188
8010641d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106422:	e9 f7 f3 ff ff       	jmp    8010581e <alltraps>

80106427 <vector189>:
.globl vector189
vector189:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $189
80106429:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010642e:	e9 eb f3 ff ff       	jmp    8010581e <alltraps>

80106433 <vector190>:
.globl vector190
vector190:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $190
80106435:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010643a:	e9 df f3 ff ff       	jmp    8010581e <alltraps>

8010643f <vector191>:
.globl vector191
vector191:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $191
80106441:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106446:	e9 d3 f3 ff ff       	jmp    8010581e <alltraps>

8010644b <vector192>:
.globl vector192
vector192:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $192
8010644d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106452:	e9 c7 f3 ff ff       	jmp    8010581e <alltraps>

80106457 <vector193>:
.globl vector193
vector193:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $193
80106459:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010645e:	e9 bb f3 ff ff       	jmp    8010581e <alltraps>

80106463 <vector194>:
.globl vector194
vector194:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $194
80106465:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010646a:	e9 af f3 ff ff       	jmp    8010581e <alltraps>

8010646f <vector195>:
.globl vector195
vector195:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $195
80106471:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106476:	e9 a3 f3 ff ff       	jmp    8010581e <alltraps>

8010647b <vector196>:
.globl vector196
vector196:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $196
8010647d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106482:	e9 97 f3 ff ff       	jmp    8010581e <alltraps>

80106487 <vector197>:
.globl vector197
vector197:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $197
80106489:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010648e:	e9 8b f3 ff ff       	jmp    8010581e <alltraps>

80106493 <vector198>:
.globl vector198
vector198:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $198
80106495:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010649a:	e9 7f f3 ff ff       	jmp    8010581e <alltraps>

8010649f <vector199>:
.globl vector199
vector199:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $199
801064a1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801064a6:	e9 73 f3 ff ff       	jmp    8010581e <alltraps>

801064ab <vector200>:
.globl vector200
vector200:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $200
801064ad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801064b2:	e9 67 f3 ff ff       	jmp    8010581e <alltraps>

801064b7 <vector201>:
.globl vector201
vector201:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $201
801064b9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801064be:	e9 5b f3 ff ff       	jmp    8010581e <alltraps>

801064c3 <vector202>:
.globl vector202
vector202:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $202
801064c5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064ca:	e9 4f f3 ff ff       	jmp    8010581e <alltraps>

801064cf <vector203>:
.globl vector203
vector203:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $203
801064d1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064d6:	e9 43 f3 ff ff       	jmp    8010581e <alltraps>

801064db <vector204>:
.globl vector204
vector204:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $204
801064dd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064e2:	e9 37 f3 ff ff       	jmp    8010581e <alltraps>

801064e7 <vector205>:
.globl vector205
vector205:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $205
801064e9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064ee:	e9 2b f3 ff ff       	jmp    8010581e <alltraps>

801064f3 <vector206>:
.globl vector206
vector206:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $206
801064f5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064fa:	e9 1f f3 ff ff       	jmp    8010581e <alltraps>

801064ff <vector207>:
.globl vector207
vector207:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $207
80106501:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106506:	e9 13 f3 ff ff       	jmp    8010581e <alltraps>

8010650b <vector208>:
.globl vector208
vector208:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $208
8010650d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106512:	e9 07 f3 ff ff       	jmp    8010581e <alltraps>

80106517 <vector209>:
.globl vector209
vector209:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $209
80106519:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010651e:	e9 fb f2 ff ff       	jmp    8010581e <alltraps>

80106523 <vector210>:
.globl vector210
vector210:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $210
80106525:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010652a:	e9 ef f2 ff ff       	jmp    8010581e <alltraps>

8010652f <vector211>:
.globl vector211
vector211:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $211
80106531:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106536:	e9 e3 f2 ff ff       	jmp    8010581e <alltraps>

8010653b <vector212>:
.globl vector212
vector212:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $212
8010653d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106542:	e9 d7 f2 ff ff       	jmp    8010581e <alltraps>

80106547 <vector213>:
.globl vector213
vector213:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $213
80106549:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010654e:	e9 cb f2 ff ff       	jmp    8010581e <alltraps>

80106553 <vector214>:
.globl vector214
vector214:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $214
80106555:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010655a:	e9 bf f2 ff ff       	jmp    8010581e <alltraps>

8010655f <vector215>:
.globl vector215
vector215:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $215
80106561:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106566:	e9 b3 f2 ff ff       	jmp    8010581e <alltraps>

8010656b <vector216>:
.globl vector216
vector216:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $216
8010656d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106572:	e9 a7 f2 ff ff       	jmp    8010581e <alltraps>

80106577 <vector217>:
.globl vector217
vector217:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $217
80106579:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010657e:	e9 9b f2 ff ff       	jmp    8010581e <alltraps>

80106583 <vector218>:
.globl vector218
vector218:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $218
80106585:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010658a:	e9 8f f2 ff ff       	jmp    8010581e <alltraps>

8010658f <vector219>:
.globl vector219
vector219:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $219
80106591:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106596:	e9 83 f2 ff ff       	jmp    8010581e <alltraps>

8010659b <vector220>:
.globl vector220
vector220:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $220
8010659d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801065a2:	e9 77 f2 ff ff       	jmp    8010581e <alltraps>

801065a7 <vector221>:
.globl vector221
vector221:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $221
801065a9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801065ae:	e9 6b f2 ff ff       	jmp    8010581e <alltraps>

801065b3 <vector222>:
.globl vector222
vector222:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $222
801065b5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801065ba:	e9 5f f2 ff ff       	jmp    8010581e <alltraps>

801065bf <vector223>:
.globl vector223
vector223:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $223
801065c1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065c6:	e9 53 f2 ff ff       	jmp    8010581e <alltraps>

801065cb <vector224>:
.globl vector224
vector224:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $224
801065cd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065d2:	e9 47 f2 ff ff       	jmp    8010581e <alltraps>

801065d7 <vector225>:
.globl vector225
vector225:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $225
801065d9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065de:	e9 3b f2 ff ff       	jmp    8010581e <alltraps>

801065e3 <vector226>:
.globl vector226
vector226:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $226
801065e5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065ea:	e9 2f f2 ff ff       	jmp    8010581e <alltraps>

801065ef <vector227>:
.globl vector227
vector227:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $227
801065f1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065f6:	e9 23 f2 ff ff       	jmp    8010581e <alltraps>

801065fb <vector228>:
.globl vector228
vector228:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $228
801065fd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106602:	e9 17 f2 ff ff       	jmp    8010581e <alltraps>

80106607 <vector229>:
.globl vector229
vector229:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $229
80106609:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010660e:	e9 0b f2 ff ff       	jmp    8010581e <alltraps>

80106613 <vector230>:
.globl vector230
vector230:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $230
80106615:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010661a:	e9 ff f1 ff ff       	jmp    8010581e <alltraps>

8010661f <vector231>:
.globl vector231
vector231:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $231
80106621:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106626:	e9 f3 f1 ff ff       	jmp    8010581e <alltraps>

8010662b <vector232>:
.globl vector232
vector232:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $232
8010662d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106632:	e9 e7 f1 ff ff       	jmp    8010581e <alltraps>

80106637 <vector233>:
.globl vector233
vector233:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $233
80106639:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010663e:	e9 db f1 ff ff       	jmp    8010581e <alltraps>

80106643 <vector234>:
.globl vector234
vector234:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $234
80106645:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010664a:	e9 cf f1 ff ff       	jmp    8010581e <alltraps>

8010664f <vector235>:
.globl vector235
vector235:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $235
80106651:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106656:	e9 c3 f1 ff ff       	jmp    8010581e <alltraps>

8010665b <vector236>:
.globl vector236
vector236:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $236
8010665d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106662:	e9 b7 f1 ff ff       	jmp    8010581e <alltraps>

80106667 <vector237>:
.globl vector237
vector237:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $237
80106669:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010666e:	e9 ab f1 ff ff       	jmp    8010581e <alltraps>

80106673 <vector238>:
.globl vector238
vector238:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $238
80106675:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010667a:	e9 9f f1 ff ff       	jmp    8010581e <alltraps>

8010667f <vector239>:
.globl vector239
vector239:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $239
80106681:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106686:	e9 93 f1 ff ff       	jmp    8010581e <alltraps>

8010668b <vector240>:
.globl vector240
vector240:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $240
8010668d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106692:	e9 87 f1 ff ff       	jmp    8010581e <alltraps>

80106697 <vector241>:
.globl vector241
vector241:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $241
80106699:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010669e:	e9 7b f1 ff ff       	jmp    8010581e <alltraps>

801066a3 <vector242>:
.globl vector242
vector242:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $242
801066a5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801066aa:	e9 6f f1 ff ff       	jmp    8010581e <alltraps>

801066af <vector243>:
.globl vector243
vector243:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $243
801066b1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801066b6:	e9 63 f1 ff ff       	jmp    8010581e <alltraps>

801066bb <vector244>:
.globl vector244
vector244:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $244
801066bd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801066c2:	e9 57 f1 ff ff       	jmp    8010581e <alltraps>

801066c7 <vector245>:
.globl vector245
vector245:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $245
801066c9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066ce:	e9 4b f1 ff ff       	jmp    8010581e <alltraps>

801066d3 <vector246>:
.globl vector246
vector246:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $246
801066d5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066da:	e9 3f f1 ff ff       	jmp    8010581e <alltraps>

801066df <vector247>:
.globl vector247
vector247:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $247
801066e1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066e6:	e9 33 f1 ff ff       	jmp    8010581e <alltraps>

801066eb <vector248>:
.globl vector248
vector248:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $248
801066ed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066f2:	e9 27 f1 ff ff       	jmp    8010581e <alltraps>

801066f7 <vector249>:
.globl vector249
vector249:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $249
801066f9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066fe:	e9 1b f1 ff ff       	jmp    8010581e <alltraps>

80106703 <vector250>:
.globl vector250
vector250:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $250
80106705:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010670a:	e9 0f f1 ff ff       	jmp    8010581e <alltraps>

8010670f <vector251>:
.globl vector251
vector251:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $251
80106711:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106716:	e9 03 f1 ff ff       	jmp    8010581e <alltraps>

8010671b <vector252>:
.globl vector252
vector252:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $252
8010671d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106722:	e9 f7 f0 ff ff       	jmp    8010581e <alltraps>

80106727 <vector253>:
.globl vector253
vector253:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $253
80106729:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010672e:	e9 eb f0 ff ff       	jmp    8010581e <alltraps>

80106733 <vector254>:
.globl vector254
vector254:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $254
80106735:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010673a:	e9 df f0 ff ff       	jmp    8010581e <alltraps>

8010673f <vector255>:
.globl vector255
vector255:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $255
80106741:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106746:	e9 d3 f0 ff ff       	jmp    8010581e <alltraps>
8010674b:	66 90                	xchg   %ax,%ax
8010674d:	66 90                	xchg   %ax,%ax
8010674f:	90                   	nop

80106750 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106757:	c1 ea 16             	shr    $0x16,%edx
{
8010675a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010675b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010675e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106761:	8b 1f                	mov    (%edi),%ebx
80106763:	f6 c3 01             	test   $0x1,%bl
80106766:	74 28                	je     80106790 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106768:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010676e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106774:	89 f0                	mov    %esi,%eax
}
80106776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106779:	c1 e8 0a             	shr    $0xa,%eax
8010677c:	25 fc 0f 00 00       	and    $0xffc,%eax
80106781:	01 d8                	add    %ebx,%eax
}
80106783:	5b                   	pop    %ebx
80106784:	5e                   	pop    %esi
80106785:	5f                   	pop    %edi
80106786:	5d                   	pop    %ebp
80106787:	c3                   	ret    
80106788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010678f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106790:	85 c9                	test   %ecx,%ecx
80106792:	74 2c                	je     801067c0 <walkpgdir+0x70>
80106794:	e8 57 be ff ff       	call   801025f0 <kalloc>
80106799:	89 c3                	mov    %eax,%ebx
8010679b:	85 c0                	test   %eax,%eax
8010679d:	74 21                	je     801067c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010679f:	83 ec 04             	sub    $0x4,%esp
801067a2:	68 00 10 00 00       	push   $0x1000
801067a7:	6a 00                	push   $0x0
801067a9:	50                   	push   %eax
801067aa:	e8 71 de ff ff       	call   80104620 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801067af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067b5:	83 c4 10             	add    $0x10,%esp
801067b8:	83 c8 07             	or     $0x7,%eax
801067bb:	89 07                	mov    %eax,(%edi)
801067bd:	eb b5                	jmp    80106774 <walkpgdir+0x24>
801067bf:	90                   	nop
}
801067c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801067c3:	31 c0                	xor    %eax,%eax
}
801067c5:	5b                   	pop    %ebx
801067c6:	5e                   	pop    %esi
801067c7:	5f                   	pop    %edi
801067c8:	5d                   	pop    %ebp
801067c9:	c3                   	ret    
801067ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067d6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801067da:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801067e0:	89 d6                	mov    %edx,%esi
{
801067e2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801067e3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801067e9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
801067ef:	8b 45 08             	mov    0x8(%ebp),%eax
801067f2:	29 f0                	sub    %esi,%eax
801067f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067f7:	eb 1f                	jmp    80106818 <mappages+0x48>
801067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106800:	f6 00 01             	testb  $0x1,(%eax)
80106803:	75 45                	jne    8010684a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106805:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106808:	83 cb 01             	or     $0x1,%ebx
8010680b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010680d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106810:	74 2e                	je     80106840 <mappages+0x70>
      break;
    a += PGSIZE;
80106812:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80106818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010681b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106820:	89 f2                	mov    %esi,%edx
80106822:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80106825:	89 f8                	mov    %edi,%eax
80106827:	e8 24 ff ff ff       	call   80106750 <walkpgdir>
8010682c:	85 c0                	test   %eax,%eax
8010682e:	75 d0                	jne    80106800 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106830:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106838:	5b                   	pop    %ebx
80106839:	5e                   	pop    %esi
8010683a:	5f                   	pop    %edi
8010683b:	5d                   	pop    %ebp
8010683c:	c3                   	ret    
8010683d:	8d 76 00             	lea    0x0(%esi),%esi
80106840:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106843:	31 c0                	xor    %eax,%eax
}
80106845:	5b                   	pop    %ebx
80106846:	5e                   	pop    %esi
80106847:	5f                   	pop    %edi
80106848:	5d                   	pop    %ebp
80106849:	c3                   	ret    
      panic("remap");
8010684a:	83 ec 0c             	sub    $0xc,%esp
8010684d:	68 e9 78 10 80       	push   $0x801078e9
80106852:	e8 39 9b ff ff       	call   80100390 <panic>
80106857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010685e:	66 90                	xchg   %ax,%ax

80106860 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	89 c6                	mov    %eax,%esi
80106867:	53                   	push   %ebx
80106868:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010686a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80106870:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106876:	83 ec 1c             	sub    $0x1c,%esp
80106879:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010687c:	39 da                	cmp    %ebx,%edx
8010687e:	73 5b                	jae    801068db <deallocuvm.part.0+0x7b>
80106880:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80106883:	89 d7                	mov    %edx,%edi
80106885:	eb 14                	jmp    8010689b <deallocuvm.part.0+0x3b>
80106887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010688e:	66 90                	xchg   %ax,%ax
80106890:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106896:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80106899:	76 40                	jbe    801068db <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010689b:	31 c9                	xor    %ecx,%ecx
8010689d:	89 fa                	mov    %edi,%edx
8010689f:	89 f0                	mov    %esi,%eax
801068a1:	e8 aa fe ff ff       	call   80106750 <walkpgdir>
801068a6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801068a8:	85 c0                	test   %eax,%eax
801068aa:	74 44                	je     801068f0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801068ac:	8b 00                	mov    (%eax),%eax
801068ae:	a8 01                	test   $0x1,%al
801068b0:	74 de                	je     80106890 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801068b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068b7:	74 47                	je     80106900 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801068b9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801068bc:	05 00 00 00 80       	add    $0x80000000,%eax
801068c1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801068c7:	50                   	push   %eax
801068c8:	e8 63 bb ff ff       	call   80102430 <kfree>
      *pte = 0;
801068cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801068d3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801068d6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801068d9:	77 c0                	ja     8010689b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801068db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068e1:	5b                   	pop    %ebx
801068e2:	5e                   	pop    %esi
801068e3:	5f                   	pop    %edi
801068e4:	5d                   	pop    %ebp
801068e5:	c3                   	ret    
801068e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068ed:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068f0:	89 fa                	mov    %edi,%edx
801068f2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801068f8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801068fe:	eb 96                	jmp    80106896 <deallocuvm.part.0+0x36>
        panic("kfree");
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	68 b2 72 10 80       	push   $0x801072b2
80106908:	e8 83 9a ff ff       	call   80100390 <panic>
8010690d:	8d 76 00             	lea    0x0(%esi),%esi

80106910 <seginit>:
{
80106910:	f3 0f 1e fb          	endbr32 
80106914:	55                   	push   %ebp
80106915:	89 e5                	mov    %esp,%ebp
80106917:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010691a:	e8 d1 cf ff ff       	call   801038f0 <cpuid>
  pd[0] = size-1;
8010691f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106924:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010692a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010692e:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106935:	ff 00 00 
80106938:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010693f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106942:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106949:	ff 00 00 
8010694c:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106953:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106956:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
8010695d:	ff 00 00 
80106960:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106967:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010696a:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106971:	ff 00 00 
80106974:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
8010697b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010697e:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106983:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106987:	c1 e8 10             	shr    $0x10,%eax
8010698a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010698e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106991:	0f 01 10             	lgdtl  (%eax)
}
80106994:	c9                   	leave  
80106995:	c3                   	ret    
80106996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010699d:	8d 76 00             	lea    0x0(%esi),%esi

801069a0 <switchkvm>:
{
801069a0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069a4:	a1 a4 54 11 80       	mov    0x801154a4,%eax
801069a9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069ae:	0f 22 d8             	mov    %eax,%cr3
}
801069b1:	c3                   	ret    
801069b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069c0 <switchuvm>:
{
801069c0:	f3 0f 1e fb          	endbr32 
801069c4:	55                   	push   %ebp
801069c5:	89 e5                	mov    %esp,%ebp
801069c7:	57                   	push   %edi
801069c8:	56                   	push   %esi
801069c9:	53                   	push   %ebx
801069ca:	83 ec 1c             	sub    $0x1c,%esp
801069cd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801069d0:	85 f6                	test   %esi,%esi
801069d2:	0f 84 cb 00 00 00    	je     80106aa3 <switchuvm+0xe3>
  if(p->kstack == 0)
801069d8:	8b 46 08             	mov    0x8(%esi),%eax
801069db:	85 c0                	test   %eax,%eax
801069dd:	0f 84 da 00 00 00    	je     80106abd <switchuvm+0xfd>
  if(p->pgdir == 0)
801069e3:	8b 46 04             	mov    0x4(%esi),%eax
801069e6:	85 c0                	test   %eax,%eax
801069e8:	0f 84 c2 00 00 00    	je     80106ab0 <switchuvm+0xf0>
  pushcli();
801069ee:	e8 1d da ff ff       	call   80104410 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069f3:	e8 88 ce ff ff       	call   80103880 <mycpu>
801069f8:	89 c3                	mov    %eax,%ebx
801069fa:	e8 81 ce ff ff       	call   80103880 <mycpu>
801069ff:	89 c7                	mov    %eax,%edi
80106a01:	e8 7a ce ff ff       	call   80103880 <mycpu>
80106a06:	83 c7 08             	add    $0x8,%edi
80106a09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a0c:	e8 6f ce ff ff       	call   80103880 <mycpu>
80106a11:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a14:	ba 67 00 00 00       	mov    $0x67,%edx
80106a19:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a20:	83 c0 08             	add    $0x8,%eax
80106a23:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a2a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106a2f:	83 c1 08             	add    $0x8,%ecx
80106a32:	c1 e8 18             	shr    $0x18,%eax
80106a35:	c1 e9 10             	shr    $0x10,%ecx
80106a38:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106a3e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106a44:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106a49:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a50:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106a55:	e8 26 ce ff ff       	call   80103880 <mycpu>
80106a5a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a61:	e8 1a ce ff ff       	call   80103880 <mycpu>
80106a66:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a6a:	8b 5e 08             	mov    0x8(%esi),%ebx
80106a6d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a73:	e8 08 ce ff ff       	call   80103880 <mycpu>
80106a78:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a7b:	e8 00 ce ff ff       	call   80103880 <mycpu>
80106a80:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106a84:	b8 28 00 00 00       	mov    $0x28,%eax
80106a89:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a8c:	8b 46 04             	mov    0x4(%esi),%eax
80106a8f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a94:	0f 22 d8             	mov    %eax,%cr3
}
80106a97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a9a:	5b                   	pop    %ebx
80106a9b:	5e                   	pop    %esi
80106a9c:	5f                   	pop    %edi
80106a9d:	5d                   	pop    %ebp
  popcli();
80106a9e:	e9 bd d9 ff ff       	jmp    80104460 <popcli>
    panic("switchuvm: no process");
80106aa3:	83 ec 0c             	sub    $0xc,%esp
80106aa6:	68 ef 78 10 80       	push   $0x801078ef
80106aab:	e8 e0 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106ab0:	83 ec 0c             	sub    $0xc,%esp
80106ab3:	68 1a 79 10 80       	push   $0x8010791a
80106ab8:	e8 d3 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106abd:	83 ec 0c             	sub    $0xc,%esp
80106ac0:	68 05 79 10 80       	push   $0x80107905
80106ac5:	e8 c6 98 ff ff       	call   80100390 <panic>
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <inituvm>:
{
80106ad0:	f3 0f 1e fb          	endbr32 
80106ad4:	55                   	push   %ebp
80106ad5:	89 e5                	mov    %esp,%ebp
80106ad7:	57                   	push   %edi
80106ad8:	56                   	push   %esi
80106ad9:	53                   	push   %ebx
80106ada:	83 ec 1c             	sub    $0x1c,%esp
80106add:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ae0:	8b 75 10             	mov    0x10(%ebp),%esi
80106ae3:	8b 7d 08             	mov    0x8(%ebp),%edi
80106ae6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ae9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106aef:	77 4b                	ja     80106b3c <inituvm+0x6c>
  mem = kalloc();
80106af1:	e8 fa ba ff ff       	call   801025f0 <kalloc>
  memset(mem, 0, PGSIZE);
80106af6:	83 ec 04             	sub    $0x4,%esp
80106af9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106afe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b00:	6a 00                	push   $0x0
80106b02:	50                   	push   %eax
80106b03:	e8 18 db ff ff       	call   80104620 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b08:	58                   	pop    %eax
80106b09:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b0f:	5a                   	pop    %edx
80106b10:	6a 06                	push   $0x6
80106b12:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b17:	31 d2                	xor    %edx,%edx
80106b19:	50                   	push   %eax
80106b1a:	89 f8                	mov    %edi,%eax
80106b1c:	e8 af fc ff ff       	call   801067d0 <mappages>
  memmove(mem, init, sz);
80106b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b24:	89 75 10             	mov    %esi,0x10(%ebp)
80106b27:	83 c4 10             	add    $0x10,%esp
80106b2a:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106b2d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b33:	5b                   	pop    %ebx
80106b34:	5e                   	pop    %esi
80106b35:	5f                   	pop    %edi
80106b36:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106b37:	e9 84 db ff ff       	jmp    801046c0 <memmove>
    panic("inituvm: more than a page");
80106b3c:	83 ec 0c             	sub    $0xc,%esp
80106b3f:	68 2e 79 10 80       	push   $0x8010792e
80106b44:	e8 47 98 ff ff       	call   80100390 <panic>
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b50 <loaduvm>:
{
80106b50:	f3 0f 1e fb          	endbr32 
80106b54:	55                   	push   %ebp
80106b55:	89 e5                	mov    %esp,%ebp
80106b57:	57                   	push   %edi
80106b58:	56                   	push   %esi
80106b59:	53                   	push   %ebx
80106b5a:	83 ec 1c             	sub    $0x1c,%esp
80106b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b60:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106b63:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106b68:	0f 85 99 00 00 00    	jne    80106c07 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
80106b6e:	01 f0                	add    %esi,%eax
80106b70:	89 f3                	mov    %esi,%ebx
80106b72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b75:	8b 45 14             	mov    0x14(%ebp),%eax
80106b78:	01 f0                	add    %esi,%eax
80106b7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106b7d:	85 f6                	test   %esi,%esi
80106b7f:	75 15                	jne    80106b96 <loaduvm+0x46>
80106b81:	eb 6d                	jmp    80106bf0 <loaduvm+0xa0>
80106b83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b87:	90                   	nop
80106b88:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106b8e:	89 f0                	mov    %esi,%eax
80106b90:	29 d8                	sub    %ebx,%eax
80106b92:	39 c6                	cmp    %eax,%esi
80106b94:	76 5a                	jbe    80106bf0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106b99:	8b 45 08             	mov    0x8(%ebp),%eax
80106b9c:	31 c9                	xor    %ecx,%ecx
80106b9e:	29 da                	sub    %ebx,%edx
80106ba0:	e8 ab fb ff ff       	call   80106750 <walkpgdir>
80106ba5:	85 c0                	test   %eax,%eax
80106ba7:	74 51                	je     80106bfa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80106ba9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106bae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106bb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106bb8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106bbe:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bc1:	29 d9                	sub    %ebx,%ecx
80106bc3:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc8:	57                   	push   %edi
80106bc9:	51                   	push   %ecx
80106bca:	50                   	push   %eax
80106bcb:	ff 75 10             	pushl  0x10(%ebp)
80106bce:	e8 4d ae ff ff       	call   80101a20 <readi>
80106bd3:	83 c4 10             	add    $0x10,%esp
80106bd6:	39 f8                	cmp    %edi,%eax
80106bd8:	74 ae                	je     80106b88 <loaduvm+0x38>
}
80106bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106be2:	5b                   	pop    %ebx
80106be3:	5e                   	pop    %esi
80106be4:	5f                   	pop    %edi
80106be5:	5d                   	pop    %ebp
80106be6:	c3                   	ret    
80106be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bee:	66 90                	xchg   %ax,%ax
80106bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106bf3:	31 c0                	xor    %eax,%eax
}
80106bf5:	5b                   	pop    %ebx
80106bf6:	5e                   	pop    %esi
80106bf7:	5f                   	pop    %edi
80106bf8:	5d                   	pop    %ebp
80106bf9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106bfa:	83 ec 0c             	sub    $0xc,%esp
80106bfd:	68 48 79 10 80       	push   $0x80107948
80106c02:	e8 89 97 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106c07:	83 ec 0c             	sub    $0xc,%esp
80106c0a:	68 ec 79 10 80       	push   $0x801079ec
80106c0f:	e8 7c 97 ff ff       	call   80100390 <panic>
80106c14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c1f:	90                   	nop

80106c20 <allocuvm>:
{
80106c20:	f3 0f 1e fb          	endbr32 
80106c24:	55                   	push   %ebp
80106c25:	89 e5                	mov    %esp,%ebp
80106c27:	57                   	push   %edi
80106c28:	56                   	push   %esi
80106c29:	53                   	push   %ebx
80106c2a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106c2d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80106c30:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80106c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c36:	85 c0                	test   %eax,%eax
80106c38:	0f 88 b2 00 00 00    	js     80106cf0 <allocuvm+0xd0>
  if(newsz < oldsz)
80106c3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80106c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106c44:	0f 82 96 00 00 00    	jb     80106ce0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106c4a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80106c50:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106c56:	39 75 10             	cmp    %esi,0x10(%ebp)
80106c59:	77 40                	ja     80106c9b <allocuvm+0x7b>
80106c5b:	e9 83 00 00 00       	jmp    80106ce3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80106c60:	83 ec 04             	sub    $0x4,%esp
80106c63:	68 00 10 00 00       	push   $0x1000
80106c68:	6a 00                	push   $0x0
80106c6a:	50                   	push   %eax
80106c6b:	e8 b0 d9 ff ff       	call   80104620 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c70:	58                   	pop    %eax
80106c71:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c77:	5a                   	pop    %edx
80106c78:	6a 06                	push   $0x6
80106c7a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c7f:	89 f2                	mov    %esi,%edx
80106c81:	50                   	push   %eax
80106c82:	89 f8                	mov    %edi,%eax
80106c84:	e8 47 fb ff ff       	call   801067d0 <mappages>
80106c89:	83 c4 10             	add    $0x10,%esp
80106c8c:	85 c0                	test   %eax,%eax
80106c8e:	78 78                	js     80106d08 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80106c90:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106c96:	39 75 10             	cmp    %esi,0x10(%ebp)
80106c99:	76 48                	jbe    80106ce3 <allocuvm+0xc3>
    mem = kalloc();
80106c9b:	e8 50 b9 ff ff       	call   801025f0 <kalloc>
80106ca0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106ca2:	85 c0                	test   %eax,%eax
80106ca4:	75 ba                	jne    80106c60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106ca6:	83 ec 0c             	sub    $0xc,%esp
80106ca9:	68 66 79 10 80       	push   $0x80107966
80106cae:	e8 fd 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cb6:	83 c4 10             	add    $0x10,%esp
80106cb9:	39 45 10             	cmp    %eax,0x10(%ebp)
80106cbc:	74 32                	je     80106cf0 <allocuvm+0xd0>
80106cbe:	8b 55 10             	mov    0x10(%ebp),%edx
80106cc1:	89 c1                	mov    %eax,%ecx
80106cc3:	89 f8                	mov    %edi,%eax
80106cc5:	e8 96 fb ff ff       	call   80106860 <deallocuvm.part.0>
      return 0;
80106cca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cd7:	5b                   	pop    %ebx
80106cd8:	5e                   	pop    %esi
80106cd9:	5f                   	pop    %edi
80106cda:	5d                   	pop    %ebp
80106cdb:	c3                   	ret    
80106cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80106ce0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80106ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ce6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce9:	5b                   	pop    %ebx
80106cea:	5e                   	pop    %esi
80106ceb:	5f                   	pop    %edi
80106cec:	5d                   	pop    %ebp
80106ced:	c3                   	ret    
80106cee:	66 90                	xchg   %ax,%ax
    return 0;
80106cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80106cf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cfd:	5b                   	pop    %ebx
80106cfe:	5e                   	pop    %esi
80106cff:	5f                   	pop    %edi
80106d00:	5d                   	pop    %ebp
80106d01:	c3                   	ret    
80106d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106d08:	83 ec 0c             	sub    $0xc,%esp
80106d0b:	68 7e 79 10 80       	push   $0x8010797e
80106d10:	e8 9b 99 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106d15:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d18:	83 c4 10             	add    $0x10,%esp
80106d1b:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d1e:	74 0c                	je     80106d2c <allocuvm+0x10c>
80106d20:	8b 55 10             	mov    0x10(%ebp),%edx
80106d23:	89 c1                	mov    %eax,%ecx
80106d25:	89 f8                	mov    %edi,%eax
80106d27:	e8 34 fb ff ff       	call   80106860 <deallocuvm.part.0>
      kfree(mem);
80106d2c:	83 ec 0c             	sub    $0xc,%esp
80106d2f:	53                   	push   %ebx
80106d30:	e8 fb b6 ff ff       	call   80102430 <kfree>
      return 0;
80106d35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106d3c:	83 c4 10             	add    $0x10,%esp
}
80106d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d45:	5b                   	pop    %ebx
80106d46:	5e                   	pop    %esi
80106d47:	5f                   	pop    %edi
80106d48:	5d                   	pop    %ebp
80106d49:	c3                   	ret    
80106d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d50 <deallocuvm>:
{
80106d50:	f3 0f 1e fb          	endbr32 
80106d54:	55                   	push   %ebp
80106d55:	89 e5                	mov    %esp,%ebp
80106d57:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d5a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106d60:	39 d1                	cmp    %edx,%ecx
80106d62:	73 0c                	jae    80106d70 <deallocuvm+0x20>
}
80106d64:	5d                   	pop    %ebp
80106d65:	e9 f6 fa ff ff       	jmp    80106860 <deallocuvm.part.0>
80106d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d70:	89 d0                	mov    %edx,%eax
80106d72:	5d                   	pop    %ebp
80106d73:	c3                   	ret    
80106d74:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d7f:	90                   	nop

80106d80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d80:	f3 0f 1e fb          	endbr32 
80106d84:	55                   	push   %ebp
80106d85:	89 e5                	mov    %esp,%ebp
80106d87:	57                   	push   %edi
80106d88:	56                   	push   %esi
80106d89:	53                   	push   %ebx
80106d8a:	83 ec 0c             	sub    $0xc,%esp
80106d8d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d90:	85 f6                	test   %esi,%esi
80106d92:	74 55                	je     80106de9 <freevm+0x69>
  if(newsz >= oldsz)
80106d94:	31 c9                	xor    %ecx,%ecx
80106d96:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d9b:	89 f0                	mov    %esi,%eax
80106d9d:	89 f3                	mov    %esi,%ebx
80106d9f:	e8 bc fa ff ff       	call   80106860 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106da4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106daa:	eb 0b                	jmp    80106db7 <freevm+0x37>
80106dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106db0:	83 c3 04             	add    $0x4,%ebx
80106db3:	39 df                	cmp    %ebx,%edi
80106db5:	74 23                	je     80106dda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106db7:	8b 03                	mov    (%ebx),%eax
80106db9:	a8 01                	test   $0x1,%al
80106dbb:	74 f3                	je     80106db0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106dbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106dc2:	83 ec 0c             	sub    $0xc,%esp
80106dc5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106dc8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106dcd:	50                   	push   %eax
80106dce:	e8 5d b6 ff ff       	call   80102430 <kfree>
80106dd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106dd6:	39 df                	cmp    %ebx,%edi
80106dd8:	75 dd                	jne    80106db7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106dda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de0:	5b                   	pop    %ebx
80106de1:	5e                   	pop    %esi
80106de2:	5f                   	pop    %edi
80106de3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106de4:	e9 47 b6 ff ff       	jmp    80102430 <kfree>
    panic("freevm: no pgdir");
80106de9:	83 ec 0c             	sub    $0xc,%esp
80106dec:	68 9a 79 10 80       	push   $0x8010799a
80106df1:	e8 9a 95 ff ff       	call   80100390 <panic>
80106df6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi

80106e00 <setupkvm>:
{
80106e00:	f3 0f 1e fb          	endbr32 
80106e04:	55                   	push   %ebp
80106e05:	89 e5                	mov    %esp,%ebp
80106e07:	56                   	push   %esi
80106e08:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106e09:	e8 e2 b7 ff ff       	call   801025f0 <kalloc>
80106e0e:	89 c6                	mov    %eax,%esi
80106e10:	85 c0                	test   %eax,%eax
80106e12:	74 42                	je     80106e56 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80106e14:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e17:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106e1c:	68 00 10 00 00       	push   $0x1000
80106e21:	6a 00                	push   $0x0
80106e23:	50                   	push   %eax
80106e24:	e8 f7 d7 ff ff       	call   80104620 <memset>
80106e29:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106e2c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106e2f:	83 ec 08             	sub    $0x8,%esp
80106e32:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106e35:	ff 73 0c             	pushl  0xc(%ebx)
80106e38:	8b 13                	mov    (%ebx),%edx
80106e3a:	50                   	push   %eax
80106e3b:	29 c1                	sub    %eax,%ecx
80106e3d:	89 f0                	mov    %esi,%eax
80106e3f:	e8 8c f9 ff ff       	call   801067d0 <mappages>
80106e44:	83 c4 10             	add    $0x10,%esp
80106e47:	85 c0                	test   %eax,%eax
80106e49:	78 15                	js     80106e60 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106e4b:	83 c3 10             	add    $0x10,%ebx
80106e4e:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e54:	75 d6                	jne    80106e2c <setupkvm+0x2c>
}
80106e56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e59:	89 f0                	mov    %esi,%eax
80106e5b:	5b                   	pop    %ebx
80106e5c:	5e                   	pop    %esi
80106e5d:	5d                   	pop    %ebp
80106e5e:	c3                   	ret    
80106e5f:	90                   	nop
      freevm(pgdir);
80106e60:	83 ec 0c             	sub    $0xc,%esp
80106e63:	56                   	push   %esi
      return 0;
80106e64:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106e66:	e8 15 ff ff ff       	call   80106d80 <freevm>
      return 0;
80106e6b:	83 c4 10             	add    $0x10,%esp
}
80106e6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e71:	89 f0                	mov    %esi,%eax
80106e73:	5b                   	pop    %ebx
80106e74:	5e                   	pop    %esi
80106e75:	5d                   	pop    %ebp
80106e76:	c3                   	ret    
80106e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e7e:	66 90                	xchg   %ax,%ax

80106e80 <kvmalloc>:
{
80106e80:	f3 0f 1e fb          	endbr32 
80106e84:	55                   	push   %ebp
80106e85:	89 e5                	mov    %esp,%ebp
80106e87:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e8a:	e8 71 ff ff ff       	call   80106e00 <setupkvm>
80106e8f:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e94:	05 00 00 00 80       	add    $0x80000000,%eax
80106e99:	0f 22 d8             	mov    %eax,%cr3
}
80106e9c:	c9                   	leave  
80106e9d:	c3                   	ret    
80106e9e:	66 90                	xchg   %ax,%ax

80106ea0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ea0:	f3 0f 1e fb          	endbr32 
80106ea4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ea5:	31 c9                	xor    %ecx,%ecx
{
80106ea7:	89 e5                	mov    %esp,%ebp
80106ea9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106eac:	8b 55 0c             	mov    0xc(%ebp),%edx
80106eaf:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb2:	e8 99 f8 ff ff       	call   80106750 <walkpgdir>
  if(pte == 0)
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	74 05                	je     80106ec0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ebb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106ebe:	c9                   	leave  
80106ebf:	c3                   	ret    
    panic("clearpteu");
80106ec0:	83 ec 0c             	sub    $0xc,%esp
80106ec3:	68 ab 79 10 80       	push   $0x801079ab
80106ec8:	e8 c3 94 ff ff       	call   80100390 <panic>
80106ecd:	8d 76 00             	lea    0x0(%esi),%esi

80106ed0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ed0:	f3 0f 1e fb          	endbr32 
80106ed4:	55                   	push   %ebp
80106ed5:	89 e5                	mov    %esp,%ebp
80106ed7:	57                   	push   %edi
80106ed8:	56                   	push   %esi
80106ed9:	53                   	push   %ebx
80106eda:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106edd:	e8 1e ff ff ff       	call   80106e00 <setupkvm>
80106ee2:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ee5:	85 c0                	test   %eax,%eax
80106ee7:	0f 84 9b 00 00 00    	je     80106f88 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ef0:	85 c9                	test   %ecx,%ecx
80106ef2:	0f 84 90 00 00 00    	je     80106f88 <copyuvm+0xb8>
80106ef8:	31 f6                	xor    %esi,%esi
80106efa:	eb 46                	jmp    80106f42 <copyuvm+0x72>
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f00:	83 ec 04             	sub    $0x4,%esp
80106f03:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106f09:	68 00 10 00 00       	push   $0x1000
80106f0e:	57                   	push   %edi
80106f0f:	50                   	push   %eax
80106f10:	e8 ab d7 ff ff       	call   801046c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106f15:	58                   	pop    %eax
80106f16:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f1c:	5a                   	pop    %edx
80106f1d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f20:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f25:	89 f2                	mov    %esi,%edx
80106f27:	50                   	push   %eax
80106f28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f2b:	e8 a0 f8 ff ff       	call   801067d0 <mappages>
80106f30:	83 c4 10             	add    $0x10,%esp
80106f33:	85 c0                	test   %eax,%eax
80106f35:	78 61                	js     80106f98 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106f37:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f3d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106f40:	76 46                	jbe    80106f88 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f42:	8b 45 08             	mov    0x8(%ebp),%eax
80106f45:	31 c9                	xor    %ecx,%ecx
80106f47:	89 f2                	mov    %esi,%edx
80106f49:	e8 02 f8 ff ff       	call   80106750 <walkpgdir>
80106f4e:	85 c0                	test   %eax,%eax
80106f50:	74 61                	je     80106fb3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106f52:	8b 00                	mov    (%eax),%eax
80106f54:	a8 01                	test   $0x1,%al
80106f56:	74 4e                	je     80106fa6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106f58:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80106f5a:	25 ff 0f 00 00       	and    $0xfff,%eax
80106f5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106f62:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80106f68:	e8 83 b6 ff ff       	call   801025f0 <kalloc>
80106f6d:	89 c3                	mov    %eax,%ebx
80106f6f:	85 c0                	test   %eax,%eax
80106f71:	75 8d                	jne    80106f00 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106f73:	83 ec 0c             	sub    $0xc,%esp
80106f76:	ff 75 e0             	pushl  -0x20(%ebp)
80106f79:	e8 02 fe ff ff       	call   80106d80 <freevm>
  return 0;
80106f7e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106f85:	83 c4 10             	add    $0x10,%esp
}
80106f88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f8e:	5b                   	pop    %ebx
80106f8f:	5e                   	pop    %esi
80106f90:	5f                   	pop    %edi
80106f91:	5d                   	pop    %ebp
80106f92:	c3                   	ret    
80106f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f97:	90                   	nop
      kfree(mem);
80106f98:	83 ec 0c             	sub    $0xc,%esp
80106f9b:	53                   	push   %ebx
80106f9c:	e8 8f b4 ff ff       	call   80102430 <kfree>
      goto bad;
80106fa1:	83 c4 10             	add    $0x10,%esp
80106fa4:	eb cd                	jmp    80106f73 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106fa6:	83 ec 0c             	sub    $0xc,%esp
80106fa9:	68 cf 79 10 80       	push   $0x801079cf
80106fae:	e8 dd 93 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106fb3:	83 ec 0c             	sub    $0xc,%esp
80106fb6:	68 b5 79 10 80       	push   $0x801079b5
80106fbb:	e8 d0 93 ff ff       	call   80100390 <panic>

80106fc0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fc0:	f3 0f 1e fb          	endbr32 
80106fc4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fc5:	31 c9                	xor    %ecx,%ecx
{
80106fc7:	89 e5                	mov    %esp,%ebp
80106fc9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcf:	8b 45 08             	mov    0x8(%ebp),%eax
80106fd2:	e8 79 f7 ff ff       	call   80106750 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106fd7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fd9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106fda:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106fdc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106fe1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106fe4:	05 00 00 00 80       	add    $0x80000000,%eax
80106fe9:	83 fa 05             	cmp    $0x5,%edx
80106fec:	ba 00 00 00 00       	mov    $0x0,%edx
80106ff1:	0f 45 c2             	cmovne %edx,%eax
}
80106ff4:	c3                   	ret    
80106ff5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107000 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107000:	f3 0f 1e fb          	endbr32 
80107004:	55                   	push   %ebp
80107005:	89 e5                	mov    %esp,%ebp
80107007:	57                   	push   %edi
80107008:	56                   	push   %esi
80107009:	53                   	push   %ebx
8010700a:	83 ec 0c             	sub    $0xc,%esp
8010700d:	8b 75 14             	mov    0x14(%ebp),%esi
80107010:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107013:	85 f6                	test   %esi,%esi
80107015:	75 3c                	jne    80107053 <copyout+0x53>
80107017:	eb 67                	jmp    80107080 <copyout+0x80>
80107019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107020:	8b 55 0c             	mov    0xc(%ebp),%edx
80107023:	89 fb                	mov    %edi,%ebx
80107025:	29 d3                	sub    %edx,%ebx
80107027:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010702d:	39 f3                	cmp    %esi,%ebx
8010702f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107032:	29 fa                	sub    %edi,%edx
80107034:	83 ec 04             	sub    $0x4,%esp
80107037:	01 c2                	add    %eax,%edx
80107039:	53                   	push   %ebx
8010703a:	ff 75 10             	pushl  0x10(%ebp)
8010703d:	52                   	push   %edx
8010703e:	e8 7d d6 ff ff       	call   801046c0 <memmove>
    len -= n;
    buf += n;
80107043:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107046:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010704c:	83 c4 10             	add    $0x10,%esp
8010704f:	29 de                	sub    %ebx,%esi
80107051:	74 2d                	je     80107080 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107053:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107055:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107058:	89 55 0c             	mov    %edx,0xc(%ebp)
8010705b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107061:	57                   	push   %edi
80107062:	ff 75 08             	pushl  0x8(%ebp)
80107065:	e8 56 ff ff ff       	call   80106fc0 <uva2ka>
    if(pa0 == 0)
8010706a:	83 c4 10             	add    $0x10,%esp
8010706d:	85 c0                	test   %eax,%eax
8010706f:	75 af                	jne    80107020 <copyout+0x20>
  }
  return 0;
}
80107071:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107079:	5b                   	pop    %ebx
8010707a:	5e                   	pop    %esi
8010707b:	5f                   	pop    %edi
8010707c:	5d                   	pop    %ebp
8010707d:	c3                   	ret    
8010707e:	66 90                	xchg   %ax,%ax
80107080:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107083:	31 c0                	xor    %eax,%eax
}
80107085:	5b                   	pop    %ebx
80107086:	5e                   	pop    %esi
80107087:	5f                   	pop    %edi
80107088:	5d                   	pop    %ebp
80107089:	c3                   	ret    
