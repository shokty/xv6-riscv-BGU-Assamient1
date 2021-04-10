
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	18010113          	addi	sp,sp,384 # 80009180 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	ra,8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	slliw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	95b2                	add	a1,a1,a2
    80000046:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00269713          	slli	a4,a3,0x2
    8000004c:	9736                	add	a4,a4,a3
    8000004e:	00371693          	slli	a3,a4,0x3
    80000052:	00009717          	auipc	a4,0x9
    80000056:	fee70713          	addi	a4,a4,-18 # 80009040 <timer_scratch>
    8000005a:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005c:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005e:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000060:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000064:	00006797          	auipc	a5,0x6
    80000068:	c0c78793          	addi	a5,a5,-1012 # 80005c70 <timervec>
    8000006c:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000070:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000074:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000078:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007c:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000080:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000084:	30479073          	csrw	mie,a5
}
    80000088:	6422                	ld	s0,8(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	dbe78793          	addi	a5,a5,-578 # 80000e6c <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  timerinit();
    800000d8:	00000097          	auipc	ra,0x0
    800000dc:	f44080e7          	jalr	-188(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000e0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000e4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000e6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e8:	30200073          	mret
}
    800000ec:	60a2                	ld	ra,8(sp)
    800000ee:	6402                	ld	s0,0(sp)
    800000f0:	0141                	addi	sp,sp,16
    800000f2:	8082                	ret

00000000800000f4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000f4:	715d                	addi	sp,sp,-80
    800000f6:	e486                	sd	ra,72(sp)
    800000f8:	e0a2                	sd	s0,64(sp)
    800000fa:	fc26                	sd	s1,56(sp)
    800000fc:	f84a                	sd	s2,48(sp)
    800000fe:	f44e                	sd	s3,40(sp)
    80000100:	f052                	sd	s4,32(sp)
    80000102:	ec56                	sd	s5,24(sp)
    80000104:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80000106:	04c05663          	blez	a2,80000152 <consolewrite+0x5e>
    8000010a:	8a2a                	mv	s4,a0
    8000010c:	84ae                	mv	s1,a1
    8000010e:	89b2                	mv	s3,a2
    80000110:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80000112:	5afd                	li	s5,-1
    80000114:	4685                	li	a3,1
    80000116:	8626                	mv	a2,s1
    80000118:	85d2                	mv	a1,s4
    8000011a:	fbf40513          	addi	a0,s0,-65
    8000011e:	00002097          	auipc	ra,0x2
    80000122:	322080e7          	jalr	802(ra) # 80002440 <either_copyin>
    80000126:	01550c63          	beq	a0,s5,8000013e <consolewrite+0x4a>
      break;
    uartputc(c);
    8000012a:	fbf44503          	lbu	a0,-65(s0)
    8000012e:	00000097          	auipc	ra,0x0
    80000132:	77a080e7          	jalr	1914(ra) # 800008a8 <uartputc>
  for(i = 0; i < n; i++){
    80000136:	2905                	addiw	s2,s2,1
    80000138:	0485                	addi	s1,s1,1
    8000013a:	fd299de3          	bne	s3,s2,80000114 <consolewrite+0x20>
  }

  return i;
}
    8000013e:	854a                	mv	a0,s2
    80000140:	60a6                	ld	ra,72(sp)
    80000142:	6406                	ld	s0,64(sp)
    80000144:	74e2                	ld	s1,56(sp)
    80000146:	7942                	ld	s2,48(sp)
    80000148:	79a2                	ld	s3,40(sp)
    8000014a:	7a02                	ld	s4,32(sp)
    8000014c:	6ae2                	ld	s5,24(sp)
    8000014e:	6161                	addi	sp,sp,80
    80000150:	8082                	ret
  for(i = 0; i < n; i++){
    80000152:	4901                	li	s2,0
    80000154:	b7ed                	j	8000013e <consolewrite+0x4a>

0000000080000156 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000156:	7159                	addi	sp,sp,-112
    80000158:	f486                	sd	ra,104(sp)
    8000015a:	f0a2                	sd	s0,96(sp)
    8000015c:	eca6                	sd	s1,88(sp)
    8000015e:	e8ca                	sd	s2,80(sp)
    80000160:	e4ce                	sd	s3,72(sp)
    80000162:	e0d2                	sd	s4,64(sp)
    80000164:	fc56                	sd	s5,56(sp)
    80000166:	f85a                	sd	s6,48(sp)
    80000168:	f45e                	sd	s7,40(sp)
    8000016a:	f062                	sd	s8,32(sp)
    8000016c:	ec66                	sd	s9,24(sp)
    8000016e:	e86a                	sd	s10,16(sp)
    80000170:	1880                	addi	s0,sp,112
    80000172:	8aaa                	mv	s5,a0
    80000174:	8a2e                	mv	s4,a1
    80000176:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000178:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000017c:	00011517          	auipc	a0,0x11
    80000180:	00450513          	addi	a0,a0,4 # 80011180 <cons>
    80000184:	00001097          	auipc	ra,0x1
    80000188:	a3e080e7          	jalr	-1474(ra) # 80000bc2 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000018c:	00011497          	auipc	s1,0x11
    80000190:	ff448493          	addi	s1,s1,-12 # 80011180 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000194:	00011917          	auipc	s2,0x11
    80000198:	08490913          	addi	s2,s2,132 # 80011218 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    8000019c:	4b91                	li	s7,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000019e:	5c7d                	li	s8,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001a0:	4ca9                	li	s9,10
  while(n > 0){
    800001a2:	07305863          	blez	s3,80000212 <consoleread+0xbc>
    while(cons.r == cons.w){
    800001a6:	0984a783          	lw	a5,152(s1)
    800001aa:	09c4a703          	lw	a4,156(s1)
    800001ae:	02f71463          	bne	a4,a5,800001d6 <consoleread+0x80>
      if(myproc()->killed){
    800001b2:	00001097          	auipc	ra,0x1
    800001b6:	7cc080e7          	jalr	1996(ra) # 8000197e <myproc>
    800001ba:	551c                	lw	a5,40(a0)
    800001bc:	e7b5                	bnez	a5,80000228 <consoleread+0xd2>
      sleep(&cons.r, &cons.lock);
    800001be:	85a6                	mv	a1,s1
    800001c0:	854a                	mv	a0,s2
    800001c2:	00002097          	auipc	ra,0x2
    800001c6:	e84080e7          	jalr	-380(ra) # 80002046 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef700e3          	beq	a4,a5,800001b2 <consoleread+0x5c>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001d6:	0017871b          	addiw	a4,a5,1
    800001da:	08e4ac23          	sw	a4,152(s1)
    800001de:	07f7f713          	andi	a4,a5,127
    800001e2:	9726                	add	a4,a4,s1
    800001e4:	01874703          	lbu	a4,24(a4)
    800001e8:	00070d1b          	sext.w	s10,a4
    if(c == C('D')){  // end-of-file
    800001ec:	077d0563          	beq	s10,s7,80000256 <consoleread+0x100>
    cbuf = c;
    800001f0:	f8e40fa3          	sb	a4,-97(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001f4:	4685                	li	a3,1
    800001f6:	f9f40613          	addi	a2,s0,-97
    800001fa:	85d2                	mv	a1,s4
    800001fc:	8556                	mv	a0,s5
    800001fe:	00002097          	auipc	ra,0x2
    80000202:	1ec080e7          	jalr	492(ra) # 800023ea <either_copyout>
    80000206:	01850663          	beq	a0,s8,80000212 <consoleread+0xbc>
    dst++;
    8000020a:	0a05                	addi	s4,s4,1
    --n;
    8000020c:	39fd                	addiw	s3,s3,-1
    if(c == '\n'){
    8000020e:	f99d1ae3          	bne	s10,s9,800001a2 <consoleread+0x4c>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80000212:	00011517          	auipc	a0,0x11
    80000216:	f6e50513          	addi	a0,a0,-146 # 80011180 <cons>
    8000021a:	00001097          	auipc	ra,0x1
    8000021e:	a5c080e7          	jalr	-1444(ra) # 80000c76 <release>

  return target - n;
    80000222:	413b053b          	subw	a0,s6,s3
    80000226:	a811                	j	8000023a <consoleread+0xe4>
        release(&cons.lock);
    80000228:	00011517          	auipc	a0,0x11
    8000022c:	f5850513          	addi	a0,a0,-168 # 80011180 <cons>
    80000230:	00001097          	auipc	ra,0x1
    80000234:	a46080e7          	jalr	-1466(ra) # 80000c76 <release>
        return -1;
    80000238:	557d                	li	a0,-1
}
    8000023a:	70a6                	ld	ra,104(sp)
    8000023c:	7406                	ld	s0,96(sp)
    8000023e:	64e6                	ld	s1,88(sp)
    80000240:	6946                	ld	s2,80(sp)
    80000242:	69a6                	ld	s3,72(sp)
    80000244:	6a06                	ld	s4,64(sp)
    80000246:	7ae2                	ld	s5,56(sp)
    80000248:	7b42                	ld	s6,48(sp)
    8000024a:	7ba2                	ld	s7,40(sp)
    8000024c:	7c02                	ld	s8,32(sp)
    8000024e:	6ce2                	ld	s9,24(sp)
    80000250:	6d42                	ld	s10,16(sp)
    80000252:	6165                	addi	sp,sp,112
    80000254:	8082                	ret
      if(n < target){
    80000256:	0009871b          	sext.w	a4,s3
    8000025a:	fb677ce3          	bgeu	a4,s6,80000212 <consoleread+0xbc>
        cons.r--;
    8000025e:	00011717          	auipc	a4,0x11
    80000262:	faf72d23          	sw	a5,-70(a4) # 80011218 <cons+0x98>
    80000266:	b775                	j	80000212 <consoleread+0xbc>

0000000080000268 <consputc>:
{
    80000268:	1141                	addi	sp,sp,-16
    8000026a:	e406                	sd	ra,8(sp)
    8000026c:	e022                	sd	s0,0(sp)
    8000026e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000270:	10000793          	li	a5,256
    80000274:	00f50a63          	beq	a0,a5,80000288 <consputc+0x20>
    uartputc_sync(c);
    80000278:	00000097          	auipc	ra,0x0
    8000027c:	55e080e7          	jalr	1374(ra) # 800007d6 <uartputc_sync>
}
    80000280:	60a2                	ld	ra,8(sp)
    80000282:	6402                	ld	s0,0(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000288:	4521                	li	a0,8
    8000028a:	00000097          	auipc	ra,0x0
    8000028e:	54c080e7          	jalr	1356(ra) # 800007d6 <uartputc_sync>
    80000292:	02000513          	li	a0,32
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	540080e7          	jalr	1344(ra) # 800007d6 <uartputc_sync>
    8000029e:	4521                	li	a0,8
    800002a0:	00000097          	auipc	ra,0x0
    800002a4:	536080e7          	jalr	1334(ra) # 800007d6 <uartputc_sync>
    800002a8:	bfe1                	j	80000280 <consputc+0x18>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	e04a                	sd	s2,0(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00011517          	auipc	a0,0x11
    800002bc:	ec850513          	addi	a0,a0,-312 # 80011180 <cons>
    800002c0:	00001097          	auipc	ra,0x1
    800002c4:	902080e7          	jalr	-1790(ra) # 80000bc2 <acquire>

  switch(c){
    800002c8:	47d5                	li	a5,21
    800002ca:	0af48663          	beq	s1,a5,80000376 <consoleintr+0xcc>
    800002ce:	0297ca63          	blt	a5,s1,80000302 <consoleintr+0x58>
    800002d2:	47a1                	li	a5,8
    800002d4:	0ef48763          	beq	s1,a5,800003c2 <consoleintr+0x118>
    800002d8:	47c1                	li	a5,16
    800002da:	10f49a63          	bne	s1,a5,800003ee <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002de:	00002097          	auipc	ra,0x2
    800002e2:	1b8080e7          	jalr	440(ra) # 80002496 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002e6:	00011517          	auipc	a0,0x11
    800002ea:	e9a50513          	addi	a0,a0,-358 # 80011180 <cons>
    800002ee:	00001097          	auipc	ra,0x1
    800002f2:	988080e7          	jalr	-1656(ra) # 80000c76 <release>
}
    800002f6:	60e2                	ld	ra,24(sp)
    800002f8:	6442                	ld	s0,16(sp)
    800002fa:	64a2                	ld	s1,8(sp)
    800002fc:	6902                	ld	s2,0(sp)
    800002fe:	6105                	addi	sp,sp,32
    80000300:	8082                	ret
  switch(c){
    80000302:	07f00793          	li	a5,127
    80000306:	0af48e63          	beq	s1,a5,800003c2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000030a:	00011717          	auipc	a4,0x11
    8000030e:	e7670713          	addi	a4,a4,-394 # 80011180 <cons>
    80000312:	0a072783          	lw	a5,160(a4)
    80000316:	09872703          	lw	a4,152(a4)
    8000031a:	9f99                	subw	a5,a5,a4
    8000031c:	07f00713          	li	a4,127
    80000320:	fcf763e3          	bltu	a4,a5,800002e6 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000324:	47b5                	li	a5,13
    80000326:	0cf48763          	beq	s1,a5,800003f4 <consoleintr+0x14a>
      consputc(c);
    8000032a:	8526                	mv	a0,s1
    8000032c:	00000097          	auipc	ra,0x0
    80000330:	f3c080e7          	jalr	-196(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000334:	00011797          	auipc	a5,0x11
    80000338:	e4c78793          	addi	a5,a5,-436 # 80011180 <cons>
    8000033c:	0a07a703          	lw	a4,160(a5)
    80000340:	0017069b          	addiw	a3,a4,1
    80000344:	0006861b          	sext.w	a2,a3
    80000348:	0ad7a023          	sw	a3,160(a5)
    8000034c:	07f77713          	andi	a4,a4,127
    80000350:	97ba                	add	a5,a5,a4
    80000352:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000356:	47a9                	li	a5,10
    80000358:	0cf48563          	beq	s1,a5,80000422 <consoleintr+0x178>
    8000035c:	4791                	li	a5,4
    8000035e:	0cf48263          	beq	s1,a5,80000422 <consoleintr+0x178>
    80000362:	00011797          	auipc	a5,0x11
    80000366:	eb67a783          	lw	a5,-330(a5) # 80011218 <cons+0x98>
    8000036a:	0807879b          	addiw	a5,a5,128
    8000036e:	f6f61ce3          	bne	a2,a5,800002e6 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000372:	863e                	mv	a2,a5
    80000374:	a07d                	j	80000422 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000376:	00011717          	auipc	a4,0x11
    8000037a:	e0a70713          	addi	a4,a4,-502 # 80011180 <cons>
    8000037e:	0a072783          	lw	a5,160(a4)
    80000382:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000386:	00011497          	auipc	s1,0x11
    8000038a:	dfa48493          	addi	s1,s1,-518 # 80011180 <cons>
    while(cons.e != cons.w &&
    8000038e:	4929                	li	s2,10
    80000390:	f4f70be3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80000394:	37fd                	addiw	a5,a5,-1
    80000396:	07f7f713          	andi	a4,a5,127
    8000039a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000039c:	01874703          	lbu	a4,24(a4)
    800003a0:	f52703e3          	beq	a4,s2,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003a4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003a8:	10000513          	li	a0,256
    800003ac:	00000097          	auipc	ra,0x0
    800003b0:	ebc080e7          	jalr	-324(ra) # 80000268 <consputc>
    while(cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ce3          	bne	a4,a5,80000394 <consoleintr+0xea>
    800003c0:	b71d                	j	800002e6 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003c2:	00011717          	auipc	a4,0x11
    800003c6:	dbe70713          	addi	a4,a4,-578 # 80011180 <cons>
    800003ca:	0a072783          	lw	a5,160(a4)
    800003ce:	09c72703          	lw	a4,156(a4)
    800003d2:	f0f70ae3          	beq	a4,a5,800002e6 <consoleintr+0x3c>
      cons.e--;
    800003d6:	37fd                	addiw	a5,a5,-1
    800003d8:	00011717          	auipc	a4,0x11
    800003dc:	e4f72423          	sw	a5,-440(a4) # 80011220 <cons+0xa0>
      consputc(BACKSPACE);
    800003e0:	10000513          	li	a0,256
    800003e4:	00000097          	auipc	ra,0x0
    800003e8:	e84080e7          	jalr	-380(ra) # 80000268 <consputc>
    800003ec:	bded                	j	800002e6 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    800003ee:	ee048ce3          	beqz	s1,800002e6 <consoleintr+0x3c>
    800003f2:	bf21                	j	8000030a <consoleintr+0x60>
      consputc(c);
    800003f4:	4529                	li	a0,10
    800003f6:	00000097          	auipc	ra,0x0
    800003fa:	e72080e7          	jalr	-398(ra) # 80000268 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003fe:	00011797          	auipc	a5,0x11
    80000402:	d8278793          	addi	a5,a5,-638 # 80011180 <cons>
    80000406:	0a07a703          	lw	a4,160(a5)
    8000040a:	0017069b          	addiw	a3,a4,1
    8000040e:	0006861b          	sext.w	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00011797          	auipc	a5,0x11
    80000426:	dec7ad23          	sw	a2,-518(a5) # 8001121c <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00011517          	auipc	a0,0x11
    8000042e:	dee50513          	addi	a0,a0,-530 # 80011218 <cons+0x98>
    80000432:	00002097          	auipc	ra,0x2
    80000436:	da0080e7          	jalr	-608(ra) # 800021d2 <wakeup>
    8000043a:	b575                	j	800002e6 <consoleintr+0x3c>

000000008000043c <consoleinit>:

void
consoleinit(void)
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e406                	sd	ra,8(sp)
    80000440:	e022                	sd	s0,0(sp)
    80000442:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000444:	00008597          	auipc	a1,0x8
    80000448:	bcc58593          	addi	a1,a1,-1076 # 80008010 <etext+0x10>
    8000044c:	00011517          	auipc	a0,0x11
    80000450:	d3450513          	addi	a0,a0,-716 # 80011180 <cons>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	6de080e7          	jalr	1758(ra) # 80000b32 <initlock>

  uartinit();
    8000045c:	00000097          	auipc	ra,0x0
    80000460:	32a080e7          	jalr	810(ra) # 80000786 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000464:	00021797          	auipc	a5,0x21
    80000468:	eb478793          	addi	a5,a5,-332 # 80021318 <devsw>
    8000046c:	00000717          	auipc	a4,0x0
    80000470:	cea70713          	addi	a4,a4,-790 # 80000156 <consoleread>
    80000474:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000476:	00000717          	auipc	a4,0x0
    8000047a:	c7e70713          	addi	a4,a4,-898 # 800000f4 <consolewrite>
    8000047e:	ef98                	sd	a4,24(a5)
}
    80000480:	60a2                	ld	ra,8(sp)
    80000482:	6402                	ld	s0,0(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80000488:	7179                	addi	sp,sp,-48
    8000048a:	f406                	sd	ra,40(sp)
    8000048c:	f022                	sd	s0,32(sp)
    8000048e:	ec26                	sd	s1,24(sp)
    80000490:	e84a                	sd	s2,16(sp)
    80000492:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000494:	c219                	beqz	a2,8000049a <printint+0x12>
    80000496:	08054663          	bltz	a0,80000522 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    8000049a:	2501                	sext.w	a0,a0
    8000049c:	4881                	li	a7,0
    8000049e:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004a4:	2581                	sext.w	a1,a1
    800004a6:	00008617          	auipc	a2,0x8
    800004aa:	b9a60613          	addi	a2,a2,-1126 # 80008040 <digits>
    800004ae:	883a                	mv	a6,a4
    800004b0:	2705                	addiw	a4,a4,1
    800004b2:	02b577bb          	remuw	a5,a0,a1
    800004b6:	1782                	slli	a5,a5,0x20
    800004b8:	9381                	srli	a5,a5,0x20
    800004ba:	97b2                	add	a5,a5,a2
    800004bc:	0007c783          	lbu	a5,0(a5)
    800004c0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004c4:	0005079b          	sext.w	a5,a0
    800004c8:	02b5553b          	divuw	a0,a0,a1
    800004cc:	0685                	addi	a3,a3,1
    800004ce:	feb7f0e3          	bgeu	a5,a1,800004ae <printint+0x26>

  if(sign)
    800004d2:	00088b63          	beqz	a7,800004e8 <printint+0x60>
    buf[i++] = '-';
    800004d6:	fe040793          	addi	a5,s0,-32
    800004da:	973e                	add	a4,a4,a5
    800004dc:	02d00793          	li	a5,45
    800004e0:	fef70823          	sb	a5,-16(a4)
    800004e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    800004e8:	02e05763          	blez	a4,80000516 <printint+0x8e>
    800004ec:	fd040793          	addi	a5,s0,-48
    800004f0:	00e784b3          	add	s1,a5,a4
    800004f4:	fff78913          	addi	s2,a5,-1
    800004f8:	993a                	add	s2,s2,a4
    800004fa:	377d                	addiw	a4,a4,-1
    800004fc:	1702                	slli	a4,a4,0x20
    800004fe:	9301                	srli	a4,a4,0x20
    80000500:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	00000097          	auipc	ra,0x0
    8000050c:	d60080e7          	jalr	-672(ra) # 80000268 <consputc>
  while(--i >= 0)
    80000510:	14fd                	addi	s1,s1,-1
    80000512:	ff2499e3          	bne	s1,s2,80000504 <printint+0x7c>
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	64e2                	ld	s1,24(sp)
    8000051c:	6942                	ld	s2,16(sp)
    8000051e:	6145                	addi	sp,sp,48
    80000520:	8082                	ret
    x = -xx;
    80000522:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000526:	4885                	li	a7,1
    x = -xx;
    80000528:	bf9d                	j	8000049e <printint+0x16>

000000008000052a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000052a:	1101                	addi	sp,sp,-32
    8000052c:	ec06                	sd	ra,24(sp)
    8000052e:	e822                	sd	s0,16(sp)
    80000530:	e426                	sd	s1,8(sp)
    80000532:	1000                	addi	s0,sp,32
    80000534:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000536:	00011797          	auipc	a5,0x11
    8000053a:	d007a523          	sw	zero,-758(a5) # 80011240 <pr+0x18>
  printf("panic: ");
    8000053e:	00008517          	auipc	a0,0x8
    80000542:	ada50513          	addi	a0,a0,-1318 # 80008018 <etext+0x18>
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	02e080e7          	jalr	46(ra) # 80000574 <printf>
  printf(s);
    8000054e:	8526                	mv	a0,s1
    80000550:	00000097          	auipc	ra,0x0
    80000554:	024080e7          	jalr	36(ra) # 80000574 <printf>
  printf("\n");
    80000558:	00008517          	auipc	a0,0x8
    8000055c:	b7050513          	addi	a0,a0,-1168 # 800080c8 <digits+0x88>
    80000560:	00000097          	auipc	ra,0x0
    80000564:	014080e7          	jalr	20(ra) # 80000574 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000568:	4785                	li	a5,1
    8000056a:	00009717          	auipc	a4,0x9
    8000056e:	a8f72b23          	sw	a5,-1386(a4) # 80009000 <panicked>
  for(;;)
    80000572:	a001                	j	80000572 <panic+0x48>

0000000080000574 <printf>:
{
    80000574:	7131                	addi	sp,sp,-192
    80000576:	fc86                	sd	ra,120(sp)
    80000578:	f8a2                	sd	s0,112(sp)
    8000057a:	f4a6                	sd	s1,104(sp)
    8000057c:	f0ca                	sd	s2,96(sp)
    8000057e:	ecce                	sd	s3,88(sp)
    80000580:	e8d2                	sd	s4,80(sp)
    80000582:	e4d6                	sd	s5,72(sp)
    80000584:	e0da                	sd	s6,64(sp)
    80000586:	fc5e                	sd	s7,56(sp)
    80000588:	f862                	sd	s8,48(sp)
    8000058a:	f466                	sd	s9,40(sp)
    8000058c:	f06a                	sd	s10,32(sp)
    8000058e:	ec6e                	sd	s11,24(sp)
    80000590:	0100                	addi	s0,sp,128
    80000592:	8a2a                	mv	s4,a0
    80000594:	e40c                	sd	a1,8(s0)
    80000596:	e810                	sd	a2,16(s0)
    80000598:	ec14                	sd	a3,24(s0)
    8000059a:	f018                	sd	a4,32(s0)
    8000059c:	f41c                	sd	a5,40(s0)
    8000059e:	03043823          	sd	a6,48(s0)
    800005a2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005a6:	00011d97          	auipc	s11,0x11
    800005aa:	c9adad83          	lw	s11,-870(s11) # 80011240 <pr+0x18>
  if(locking)
    800005ae:	020d9b63          	bnez	s11,800005e4 <printf+0x70>
  if (fmt == 0)
    800005b2:	040a0263          	beqz	s4,800005f6 <printf+0x82>
  va_start(ap, fmt);
    800005b6:	00840793          	addi	a5,s0,8
    800005ba:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005be:	000a4503          	lbu	a0,0(s4)
    800005c2:	14050f63          	beqz	a0,80000720 <printf+0x1ac>
    800005c6:	4981                	li	s3,0
    if(c != '%'){
    800005c8:	02500a93          	li	s5,37
    switch(c){
    800005cc:	07000b93          	li	s7,112
  consputc('x');
    800005d0:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005d2:	00008b17          	auipc	s6,0x8
    800005d6:	a6eb0b13          	addi	s6,s6,-1426 # 80008040 <digits>
    switch(c){
    800005da:	07300c93          	li	s9,115
    800005de:	06400c13          	li	s8,100
    800005e2:	a82d                	j	8000061c <printf+0xa8>
    acquire(&pr.lock);
    800005e4:	00011517          	auipc	a0,0x11
    800005e8:	c4450513          	addi	a0,a0,-956 # 80011228 <pr>
    800005ec:	00000097          	auipc	ra,0x0
    800005f0:	5d6080e7          	jalr	1494(ra) # 80000bc2 <acquire>
    800005f4:	bf7d                	j	800005b2 <printf+0x3e>
    panic("null fmt");
    800005f6:	00008517          	auipc	a0,0x8
    800005fa:	a3250513          	addi	a0,a0,-1486 # 80008028 <etext+0x28>
    800005fe:	00000097          	auipc	ra,0x0
    80000602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      consputc(c);
    80000606:	00000097          	auipc	ra,0x0
    8000060a:	c62080e7          	jalr	-926(ra) # 80000268 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000060e:	2985                	addiw	s3,s3,1
    80000610:	013a07b3          	add	a5,s4,s3
    80000614:	0007c503          	lbu	a0,0(a5)
    80000618:	10050463          	beqz	a0,80000720 <printf+0x1ac>
    if(c != '%'){
    8000061c:	ff5515e3          	bne	a0,s5,80000606 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000620:	2985                	addiw	s3,s3,1
    80000622:	013a07b3          	add	a5,s4,s3
    80000626:	0007c783          	lbu	a5,0(a5)
    8000062a:	0007849b          	sext.w	s1,a5
    if(c == 0)
    8000062e:	cbed                	beqz	a5,80000720 <printf+0x1ac>
    switch(c){
    80000630:	05778a63          	beq	a5,s7,80000684 <printf+0x110>
    80000634:	02fbf663          	bgeu	s7,a5,80000660 <printf+0xec>
    80000638:	09978863          	beq	a5,s9,800006c8 <printf+0x154>
    8000063c:	07800713          	li	a4,120
    80000640:	0ce79563          	bne	a5,a4,8000070a <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	85ea                	mv	a1,s10
    80000654:	4388                	lw	a0,0(a5)
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	e32080e7          	jalr	-462(ra) # 80000488 <printint>
      break;
    8000065e:	bf45                	j	8000060e <printf+0x9a>
    switch(c){
    80000660:	09578f63          	beq	a5,s5,800006fe <printf+0x18a>
    80000664:	0b879363          	bne	a5,s8,8000070a <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80000668:	f8843783          	ld	a5,-120(s0)
    8000066c:	00878713          	addi	a4,a5,8
    80000670:	f8e43423          	sd	a4,-120(s0)
    80000674:	4605                	li	a2,1
    80000676:	45a9                	li	a1,10
    80000678:	4388                	lw	a0,0(a5)
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	e0e080e7          	jalr	-498(ra) # 80000488 <printint>
      break;
    80000682:	b771                	j	8000060e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000694:	03000513          	li	a0,48
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	bd0080e7          	jalr	-1072(ra) # 80000268 <consputc>
  consputc('x');
    800006a0:	07800513          	li	a0,120
    800006a4:	00000097          	auipc	ra,0x0
    800006a8:	bc4080e7          	jalr	-1084(ra) # 80000268 <consputc>
    800006ac:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ae:	03c95793          	srli	a5,s2,0x3c
    800006b2:	97da                	add	a5,a5,s6
    800006b4:	0007c503          	lbu	a0,0(a5)
    800006b8:	00000097          	auipc	ra,0x0
    800006bc:	bb0080e7          	jalr	-1104(ra) # 80000268 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006c0:	0912                	slli	s2,s2,0x4
    800006c2:	34fd                	addiw	s1,s1,-1
    800006c4:	f4ed                	bnez	s1,800006ae <printf+0x13a>
    800006c6:	b7a1                	j	8000060e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006c8:	f8843783          	ld	a5,-120(s0)
    800006cc:	00878713          	addi	a4,a5,8
    800006d0:	f8e43423          	sd	a4,-120(s0)
    800006d4:	6384                	ld	s1,0(a5)
    800006d6:	cc89                	beqz	s1,800006f0 <printf+0x17c>
      for(; *s; s++)
    800006d8:	0004c503          	lbu	a0,0(s1)
    800006dc:	d90d                	beqz	a0,8000060e <printf+0x9a>
        consputc(*s);
    800006de:	00000097          	auipc	ra,0x0
    800006e2:	b8a080e7          	jalr	-1142(ra) # 80000268 <consputc>
      for(; *s; s++)
    800006e6:	0485                	addi	s1,s1,1
    800006e8:	0004c503          	lbu	a0,0(s1)
    800006ec:	f96d                	bnez	a0,800006de <printf+0x16a>
    800006ee:	b705                	j	8000060e <printf+0x9a>
        s = "(null)";
    800006f0:	00008497          	auipc	s1,0x8
    800006f4:	93048493          	addi	s1,s1,-1744 # 80008020 <etext+0x20>
      for(; *s; s++)
    800006f8:	02800513          	li	a0,40
    800006fc:	b7cd                	j	800006de <printf+0x16a>
      consputc('%');
    800006fe:	8556                	mv	a0,s5
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b68080e7          	jalr	-1176(ra) # 80000268 <consputc>
      break;
    80000708:	b719                	j	8000060e <printf+0x9a>
      consputc('%');
    8000070a:	8556                	mv	a0,s5
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	b5c080e7          	jalr	-1188(ra) # 80000268 <consputc>
      consputc(c);
    80000714:	8526                	mv	a0,s1
    80000716:	00000097          	auipc	ra,0x0
    8000071a:	b52080e7          	jalr	-1198(ra) # 80000268 <consputc>
      break;
    8000071e:	bdc5                	j	8000060e <printf+0x9a>
  if(locking)
    80000720:	020d9163          	bnez	s11,80000742 <printf+0x1ce>
}
    80000724:	70e6                	ld	ra,120(sp)
    80000726:	7446                	ld	s0,112(sp)
    80000728:	74a6                	ld	s1,104(sp)
    8000072a:	7906                	ld	s2,96(sp)
    8000072c:	69e6                	ld	s3,88(sp)
    8000072e:	6a46                	ld	s4,80(sp)
    80000730:	6aa6                	ld	s5,72(sp)
    80000732:	6b06                	ld	s6,64(sp)
    80000734:	7be2                	ld	s7,56(sp)
    80000736:	7c42                	ld	s8,48(sp)
    80000738:	7ca2                	ld	s9,40(sp)
    8000073a:	7d02                	ld	s10,32(sp)
    8000073c:	6de2                	ld	s11,24(sp)
    8000073e:	6129                	addi	sp,sp,192
    80000740:	8082                	ret
    release(&pr.lock);
    80000742:	00011517          	auipc	a0,0x11
    80000746:	ae650513          	addi	a0,a0,-1306 # 80011228 <pr>
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	52c080e7          	jalr	1324(ra) # 80000c76 <release>
}
    80000752:	bfc9                	j	80000724 <printf+0x1b0>

0000000080000754 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000754:	1101                	addi	sp,sp,-32
    80000756:	ec06                	sd	ra,24(sp)
    80000758:	e822                	sd	s0,16(sp)
    8000075a:	e426                	sd	s1,8(sp)
    8000075c:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000075e:	00011497          	auipc	s1,0x11
    80000762:	aca48493          	addi	s1,s1,-1334 # 80011228 <pr>
    80000766:	00008597          	auipc	a1,0x8
    8000076a:	8d258593          	addi	a1,a1,-1838 # 80008038 <etext+0x38>
    8000076e:	8526                	mv	a0,s1
    80000770:	00000097          	auipc	ra,0x0
    80000774:	3c2080e7          	jalr	962(ra) # 80000b32 <initlock>
  pr.locking = 1;
    80000778:	4785                	li	a5,1
    8000077a:	cc9c                	sw	a5,24(s1)
}
    8000077c:	60e2                	ld	ra,24(sp)
    8000077e:	6442                	ld	s0,16(sp)
    80000780:	64a2                	ld	s1,8(sp)
    80000782:	6105                	addi	sp,sp,32
    80000784:	8082                	ret

0000000080000786 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000786:	1141                	addi	sp,sp,-16
    80000788:	e406                	sd	ra,8(sp)
    8000078a:	e022                	sd	s0,0(sp)
    8000078c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000078e:	100007b7          	lui	a5,0x10000
    80000792:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000796:	f8000713          	li	a4,-128
    8000079a:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000079e:	470d                	li	a4,3
    800007a0:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007a4:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007a8:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007ac:	469d                	li	a3,7
    800007ae:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007b2:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007b6:	00008597          	auipc	a1,0x8
    800007ba:	8a258593          	addi	a1,a1,-1886 # 80008058 <digits+0x18>
    800007be:	00011517          	auipc	a0,0x11
    800007c2:	a8a50513          	addi	a0,a0,-1398 # 80011248 <uart_tx_lock>
    800007c6:	00000097          	auipc	ra,0x0
    800007ca:	36c080e7          	jalr	876(ra) # 80000b32 <initlock>
}
    800007ce:	60a2                	ld	ra,8(sp)
    800007d0:	6402                	ld	s0,0(sp)
    800007d2:	0141                	addi	sp,sp,16
    800007d4:	8082                	ret

00000000800007d6 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
    800007e0:	84aa                	mv	s1,a0
  push_off();
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	394080e7          	jalr	916(ra) # 80000b76 <push_off>

  if(panicked){
    800007ea:	00009797          	auipc	a5,0x9
    800007ee:	8167a783          	lw	a5,-2026(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007f2:	10000737          	lui	a4,0x10000
  if(panicked){
    800007f6:	c391                	beqz	a5,800007fa <uartputc_sync+0x24>
    for(;;)
    800007f8:	a001                	j	800007f8 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800007fa:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800007fe:	0207f793          	andi	a5,a5,32
    80000802:	dfe5                	beqz	a5,800007fa <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80000804:	0ff4f513          	andi	a0,s1,255
    80000808:	100007b7          	lui	a5,0x10000
    8000080c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	406080e7          	jalr	1030(ra) # 80000c16 <pop_off>
}
    80000818:	60e2                	ld	ra,24(sp)
    8000081a:	6442                	ld	s0,16(sp)
    8000081c:	64a2                	ld	s1,8(sp)
    8000081e:	6105                	addi	sp,sp,32
    80000820:	8082                	ret

0000000080000822 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80000822:	00008797          	auipc	a5,0x8
    80000826:	7e67b783          	ld	a5,2022(a5) # 80009008 <uart_tx_r>
    8000082a:	00008717          	auipc	a4,0x8
    8000082e:	7e673703          	ld	a4,2022(a4) # 80009010 <uart_tx_w>
    80000832:	06f70a63          	beq	a4,a5,800008a6 <uartstart+0x84>
{
    80000836:	7139                	addi	sp,sp,-64
    80000838:	fc06                	sd	ra,56(sp)
    8000083a:	f822                	sd	s0,48(sp)
    8000083c:	f426                	sd	s1,40(sp)
    8000083e:	f04a                	sd	s2,32(sp)
    80000840:	ec4e                	sd	s3,24(sp)
    80000842:	e852                	sd	s4,16(sp)
    80000844:	e456                	sd	s5,8(sp)
    80000846:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000848:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000084c:	00011a17          	auipc	s4,0x11
    80000850:	9fca0a13          	addi	s4,s4,-1540 # 80011248 <uart_tx_lock>
    uart_tx_r += 1;
    80000854:	00008497          	auipc	s1,0x8
    80000858:	7b448493          	addi	s1,s1,1972 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000085c:	00008997          	auipc	s3,0x8
    80000860:	7b498993          	addi	s3,s3,1972 # 80009010 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000864:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000868:	02077713          	andi	a4,a4,32
    8000086c:	c705                	beqz	a4,80000894 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000086e:	01f7f713          	andi	a4,a5,31
    80000872:	9752                	add	a4,a4,s4
    80000874:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80000878:	0785                	addi	a5,a5,1
    8000087a:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000087c:	8526                	mv	a0,s1
    8000087e:	00002097          	auipc	ra,0x2
    80000882:	954080e7          	jalr	-1708(ra) # 800021d2 <wakeup>
    
    WriteReg(THR, c);
    80000886:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000088a:	609c                	ld	a5,0(s1)
    8000088c:	0009b703          	ld	a4,0(s3)
    80000890:	fcf71ae3          	bne	a4,a5,80000864 <uartstart+0x42>
  }
}
    80000894:	70e2                	ld	ra,56(sp)
    80000896:	7442                	ld	s0,48(sp)
    80000898:	74a2                	ld	s1,40(sp)
    8000089a:	7902                	ld	s2,32(sp)
    8000089c:	69e2                	ld	s3,24(sp)
    8000089e:	6a42                	ld	s4,16(sp)
    800008a0:	6aa2                	ld	s5,8(sp)
    800008a2:	6121                	addi	sp,sp,64
    800008a4:	8082                	ret
    800008a6:	8082                	ret

00000000800008a8 <uartputc>:
{
    800008a8:	7179                	addi	sp,sp,-48
    800008aa:	f406                	sd	ra,40(sp)
    800008ac:	f022                	sd	s0,32(sp)
    800008ae:	ec26                	sd	s1,24(sp)
    800008b0:	e84a                	sd	s2,16(sp)
    800008b2:	e44e                	sd	s3,8(sp)
    800008b4:	e052                	sd	s4,0(sp)
    800008b6:	1800                	addi	s0,sp,48
    800008b8:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800008ba:	00011517          	auipc	a0,0x11
    800008be:	98e50513          	addi	a0,a0,-1650 # 80011248 <uart_tx_lock>
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	300080e7          	jalr	768(ra) # 80000bc2 <acquire>
  if(panicked){
    800008ca:	00008797          	auipc	a5,0x8
    800008ce:	7367a783          	lw	a5,1846(a5) # 80009000 <panicked>
    800008d2:	c391                	beqz	a5,800008d6 <uartputc+0x2e>
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc+0x2c>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008d6:	00008717          	auipc	a4,0x8
    800008da:	73a73703          	ld	a4,1850(a4) # 80009010 <uart_tx_w>
    800008de:	00008797          	auipc	a5,0x8
    800008e2:	72a7b783          	ld	a5,1834(a5) # 80009008 <uart_tx_r>
    800008e6:	02078793          	addi	a5,a5,32
    800008ea:	02e79b63          	bne	a5,a4,80000920 <uartputc+0x78>
      sleep(&uart_tx_r, &uart_tx_lock);
    800008ee:	00011997          	auipc	s3,0x11
    800008f2:	95a98993          	addi	s3,s3,-1702 # 80011248 <uart_tx_lock>
    800008f6:	00008497          	auipc	s1,0x8
    800008fa:	71248493          	addi	s1,s1,1810 # 80009008 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800008fe:	00008917          	auipc	s2,0x8
    80000902:	71290913          	addi	s2,s2,1810 # 80009010 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000906:	85ce                	mv	a1,s3
    80000908:	8526                	mv	a0,s1
    8000090a:	00001097          	auipc	ra,0x1
    8000090e:	73c080e7          	jalr	1852(ra) # 80002046 <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000912:	00093703          	ld	a4,0(s2)
    80000916:	609c                	ld	a5,0(s1)
    80000918:	02078793          	addi	a5,a5,32
    8000091c:	fee785e3          	beq	a5,a4,80000906 <uartputc+0x5e>
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000920:	00011497          	auipc	s1,0x11
    80000924:	92848493          	addi	s1,s1,-1752 # 80011248 <uart_tx_lock>
    80000928:	01f77793          	andi	a5,a4,31
    8000092c:	97a6                	add	a5,a5,s1
    8000092e:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80000932:	0705                	addi	a4,a4,1
    80000934:	00008797          	auipc	a5,0x8
    80000938:	6ce7be23          	sd	a4,1756(a5) # 80009010 <uart_tx_w>
      uartstart();
    8000093c:	00000097          	auipc	ra,0x0
    80000940:	ee6080e7          	jalr	-282(ra) # 80000822 <uartstart>
      release(&uart_tx_lock);
    80000944:	8526                	mv	a0,s1
    80000946:	00000097          	auipc	ra,0x0
    8000094a:	330080e7          	jalr	816(ra) # 80000c76 <release>
}
    8000094e:	70a2                	ld	ra,40(sp)
    80000950:	7402                	ld	s0,32(sp)
    80000952:	64e2                	ld	s1,24(sp)
    80000954:	6942                	ld	s2,16(sp)
    80000956:	69a2                	ld	s3,8(sp)
    80000958:	6a02                	ld	s4,0(sp)
    8000095a:	6145                	addi	sp,sp,48
    8000095c:	8082                	ret

000000008000095e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000095e:	1141                	addi	sp,sp,-16
    80000960:	e422                	sd	s0,8(sp)
    80000962:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000964:	100007b7          	lui	a5,0x10000
    80000968:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000096c:	8b85                	andi	a5,a5,1
    8000096e:	cb91                	beqz	a5,80000982 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000970:	100007b7          	lui	a5,0x10000
    80000974:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000978:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000097c:	6422                	ld	s0,8(sp)
    8000097e:	0141                	addi	sp,sp,16
    80000980:	8082                	ret
    return -1;
    80000982:	557d                	li	a0,-1
    80000984:	bfe5                	j	8000097c <uartgetc+0x1e>

0000000080000986 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80000986:	1101                	addi	sp,sp,-32
    80000988:	ec06                	sd	ra,24(sp)
    8000098a:	e822                	sd	s0,16(sp)
    8000098c:	e426                	sd	s1,8(sp)
    8000098e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000990:	54fd                	li	s1,-1
    80000992:	a029                	j	8000099c <uartintr+0x16>
      break;
    consoleintr(c);
    80000994:	00000097          	auipc	ra,0x0
    80000998:	916080e7          	jalr	-1770(ra) # 800002aa <consoleintr>
    int c = uartgetc();
    8000099c:	00000097          	auipc	ra,0x0
    800009a0:	fc2080e7          	jalr	-62(ra) # 8000095e <uartgetc>
    if(c == -1)
    800009a4:	fe9518e3          	bne	a0,s1,80000994 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009a8:	00011497          	auipc	s1,0x11
    800009ac:	8a048493          	addi	s1,s1,-1888 # 80011248 <uart_tx_lock>
    800009b0:	8526                	mv	a0,s1
    800009b2:	00000097          	auipc	ra,0x0
    800009b6:	210080e7          	jalr	528(ra) # 80000bc2 <acquire>
  uartstart();
    800009ba:	00000097          	auipc	ra,0x0
    800009be:	e68080e7          	jalr	-408(ra) # 80000822 <uartstart>
  release(&uart_tx_lock);
    800009c2:	8526                	mv	a0,s1
    800009c4:	00000097          	auipc	ra,0x0
    800009c8:	2b2080e7          	jalr	690(ra) # 80000c76 <release>
}
    800009cc:	60e2                	ld	ra,24(sp)
    800009ce:	6442                	ld	s0,16(sp)
    800009d0:	64a2                	ld	s1,8(sp)
    800009d2:	6105                	addi	sp,sp,32
    800009d4:	8082                	ret

00000000800009d6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    800009d6:	1101                	addi	sp,sp,-32
    800009d8:	ec06                	sd	ra,24(sp)
    800009da:	e822                	sd	s0,16(sp)
    800009dc:	e426                	sd	s1,8(sp)
    800009de:	e04a                	sd	s2,0(sp)
    800009e0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    800009e2:	03451793          	slli	a5,a0,0x34
    800009e6:	ebb9                	bnez	a5,80000a3c <kfree+0x66>
    800009e8:	84aa                	mv	s1,a0
    800009ea:	00025797          	auipc	a5,0x25
    800009ee:	61678793          	addi	a5,a5,1558 # 80026000 <end>
    800009f2:	04f56563          	bltu	a0,a5,80000a3c <kfree+0x66>
    800009f6:	47c5                	li	a5,17
    800009f8:	07ee                	slli	a5,a5,0x1b
    800009fa:	04f57163          	bgeu	a0,a5,80000a3c <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4585                	li	a1,1
    80000a02:	00000097          	auipc	ra,0x0
    80000a06:	2bc080e7          	jalr	700(ra) # 80000cbe <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a0a:	00011917          	auipc	s2,0x11
    80000a0e:	87690913          	addi	s2,s2,-1930 # 80011280 <kmem>
    80000a12:	854a                	mv	a0,s2
    80000a14:	00000097          	auipc	ra,0x0
    80000a18:	1ae080e7          	jalr	430(ra) # 80000bc2 <acquire>
  r->next = kmem.freelist;
    80000a1c:	01893783          	ld	a5,24(s2)
    80000a20:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a22:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a26:	854a                	mv	a0,s2
    80000a28:	00000097          	auipc	ra,0x0
    80000a2c:	24e080e7          	jalr	590(ra) # 80000c76 <release>
}
    80000a30:	60e2                	ld	ra,24(sp)
    80000a32:	6442                	ld	s0,16(sp)
    80000a34:	64a2                	ld	s1,8(sp)
    80000a36:	6902                	ld	s2,0(sp)
    80000a38:	6105                	addi	sp,sp,32
    80000a3a:	8082                	ret
    panic("kfree");
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	62450513          	addi	a0,a0,1572 # 80008060 <digits+0x20>
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	ae6080e7          	jalr	-1306(ra) # 8000052a <panic>

0000000080000a4c <freerange>:
{
    80000a4c:	7179                	addi	sp,sp,-48
    80000a4e:	f406                	sd	ra,40(sp)
    80000a50:	f022                	sd	s0,32(sp)
    80000a52:	ec26                	sd	s1,24(sp)
    80000a54:	e84a                	sd	s2,16(sp)
    80000a56:	e44e                	sd	s3,8(sp)
    80000a58:	e052                	sd	s4,0(sp)
    80000a5a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a5c:	6785                	lui	a5,0x1
    80000a5e:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000a62:	94aa                	add	s1,s1,a0
    80000a64:	757d                	lui	a0,0xfffff
    80000a66:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a68:	94be                	add	s1,s1,a5
    80000a6a:	0095ee63          	bltu	a1,s1,80000a86 <freerange+0x3a>
    80000a6e:	892e                	mv	s2,a1
    kfree(p);
    80000a70:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a72:	6985                	lui	s3,0x1
    kfree(p);
    80000a74:	01448533          	add	a0,s1,s4
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	f5e080e7          	jalr	-162(ra) # 800009d6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a80:	94ce                	add	s1,s1,s3
    80000a82:	fe9979e3          	bgeu	s2,s1,80000a74 <freerange+0x28>
}
    80000a86:	70a2                	ld	ra,40(sp)
    80000a88:	7402                	ld	s0,32(sp)
    80000a8a:	64e2                	ld	s1,24(sp)
    80000a8c:	6942                	ld	s2,16(sp)
    80000a8e:	69a2                	ld	s3,8(sp)
    80000a90:	6a02                	ld	s4,0(sp)
    80000a92:	6145                	addi	sp,sp,48
    80000a94:	8082                	ret

0000000080000a96 <kinit>:
{
    80000a96:	1141                	addi	sp,sp,-16
    80000a98:	e406                	sd	ra,8(sp)
    80000a9a:	e022                	sd	s0,0(sp)
    80000a9c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000a9e:	00007597          	auipc	a1,0x7
    80000aa2:	5ca58593          	addi	a1,a1,1482 # 80008068 <digits+0x28>
    80000aa6:	00010517          	auipc	a0,0x10
    80000aaa:	7da50513          	addi	a0,a0,2010 # 80011280 <kmem>
    80000aae:	00000097          	auipc	ra,0x0
    80000ab2:	084080e7          	jalr	132(ra) # 80000b32 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ab6:	45c5                	li	a1,17
    80000ab8:	05ee                	slli	a1,a1,0x1b
    80000aba:	00025517          	auipc	a0,0x25
    80000abe:	54650513          	addi	a0,a0,1350 # 80026000 <end>
    80000ac2:	00000097          	auipc	ra,0x0
    80000ac6:	f8a080e7          	jalr	-118(ra) # 80000a4c <freerange>
}
    80000aca:	60a2                	ld	ra,8(sp)
    80000acc:	6402                	ld	s0,0(sp)
    80000ace:	0141                	addi	sp,sp,16
    80000ad0:	8082                	ret

0000000080000ad2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ad2:	1101                	addi	sp,sp,-32
    80000ad4:	ec06                	sd	ra,24(sp)
    80000ad6:	e822                	sd	s0,16(sp)
    80000ad8:	e426                	sd	s1,8(sp)
    80000ada:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000adc:	00010497          	auipc	s1,0x10
    80000ae0:	7a448493          	addi	s1,s1,1956 # 80011280 <kmem>
    80000ae4:	8526                	mv	a0,s1
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	0dc080e7          	jalr	220(ra) # 80000bc2 <acquire>
  r = kmem.freelist;
    80000aee:	6c84                	ld	s1,24(s1)
  if(r)
    80000af0:	c885                	beqz	s1,80000b20 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000af2:	609c                	ld	a5,0(s1)
    80000af4:	00010517          	auipc	a0,0x10
    80000af8:	78c50513          	addi	a0,a0,1932 # 80011280 <kmem>
    80000afc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	178080e7          	jalr	376(ra) # 80000c76 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b06:	6605                	lui	a2,0x1
    80000b08:	4595                	li	a1,5
    80000b0a:	8526                	mv	a0,s1
    80000b0c:	00000097          	auipc	ra,0x0
    80000b10:	1b2080e7          	jalr	434(ra) # 80000cbe <memset>
  return (void*)r;
}
    80000b14:	8526                	mv	a0,s1
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret
  release(&kmem.lock);
    80000b20:	00010517          	auipc	a0,0x10
    80000b24:	76050513          	addi	a0,a0,1888 # 80011280 <kmem>
    80000b28:	00000097          	auipc	ra,0x0
    80000b2c:	14e080e7          	jalr	334(ra) # 80000c76 <release>
  if(r)
    80000b30:	b7d5                	j	80000b14 <kalloc+0x42>

0000000080000b32 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b32:	1141                	addi	sp,sp,-16
    80000b34:	e422                	sd	s0,8(sp)
    80000b36:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b38:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b3a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b3e:	00053823          	sd	zero,16(a0)
}
    80000b42:	6422                	ld	s0,8(sp)
    80000b44:	0141                	addi	sp,sp,16
    80000b46:	8082                	ret

0000000080000b48 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b48:	411c                	lw	a5,0(a0)
    80000b4a:	e399                	bnez	a5,80000b50 <holding+0x8>
    80000b4c:	4501                	li	a0,0
  return r;
}
    80000b4e:	8082                	ret
{
    80000b50:	1101                	addi	sp,sp,-32
    80000b52:	ec06                	sd	ra,24(sp)
    80000b54:	e822                	sd	s0,16(sp)
    80000b56:	e426                	sd	s1,8(sp)
    80000b58:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b5a:	6904                	ld	s1,16(a0)
    80000b5c:	00001097          	auipc	ra,0x1
    80000b60:	e06080e7          	jalr	-506(ra) # 80001962 <mycpu>
    80000b64:	40a48533          	sub	a0,s1,a0
    80000b68:	00153513          	seqz	a0,a0
}
    80000b6c:	60e2                	ld	ra,24(sp)
    80000b6e:	6442                	ld	s0,16(sp)
    80000b70:	64a2                	ld	s1,8(sp)
    80000b72:	6105                	addi	sp,sp,32
    80000b74:	8082                	ret

0000000080000b76 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b76:	1101                	addi	sp,sp,-32
    80000b78:	ec06                	sd	ra,24(sp)
    80000b7a:	e822                	sd	s0,16(sp)
    80000b7c:	e426                	sd	s1,8(sp)
    80000b7e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b80:	100024f3          	csrr	s1,sstatus
    80000b84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000b88:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b8a:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000b8e:	00001097          	auipc	ra,0x1
    80000b92:	dd4080e7          	jalr	-556(ra) # 80001962 <mycpu>
    80000b96:	5d3c                	lw	a5,120(a0)
    80000b98:	cf89                	beqz	a5,80000bb2 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000b9a:	00001097          	auipc	ra,0x1
    80000b9e:	dc8080e7          	jalr	-568(ra) # 80001962 <mycpu>
    80000ba2:	5d3c                	lw	a5,120(a0)
    80000ba4:	2785                	addiw	a5,a5,1
    80000ba6:	dd3c                	sw	a5,120(a0)
}
    80000ba8:	60e2                	ld	ra,24(sp)
    80000baa:	6442                	ld	s0,16(sp)
    80000bac:	64a2                	ld	s1,8(sp)
    80000bae:	6105                	addi	sp,sp,32
    80000bb0:	8082                	ret
    mycpu()->intena = old;
    80000bb2:	00001097          	auipc	ra,0x1
    80000bb6:	db0080e7          	jalr	-592(ra) # 80001962 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bba:	8085                	srli	s1,s1,0x1
    80000bbc:	8885                	andi	s1,s1,1
    80000bbe:	dd64                	sw	s1,124(a0)
    80000bc0:	bfe9                	j	80000b9a <push_off+0x24>

0000000080000bc2 <acquire>:
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
    80000bcc:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bce:	00000097          	auipc	ra,0x0
    80000bd2:	fa8080e7          	jalr	-88(ra) # 80000b76 <push_off>
  if(holding(lk))
    80000bd6:	8526                	mv	a0,s1
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	f70080e7          	jalr	-144(ra) # 80000b48 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be0:	4705                	li	a4,1
  if(holding(lk))
    80000be2:	e115                	bnez	a0,80000c06 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	87ba                	mv	a5,a4
    80000be6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bea:	2781                	sext.w	a5,a5
    80000bec:	ffe5                	bnez	a5,80000be4 <acquire+0x22>
  __sync_synchronize();
    80000bee:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	d70080e7          	jalr	-656(ra) # 80001962 <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00007517          	auipc	a0,0x7
    80000c0a:	46a50513          	addi	a0,a0,1130 # 80008070 <digits+0x30>
    80000c0e:	00000097          	auipc	ra,0x0
    80000c12:	91c080e7          	jalr	-1764(ra) # 8000052a <panic>

0000000080000c16 <pop_off>:

void
pop_off(void)
{
    80000c16:	1141                	addi	sp,sp,-16
    80000c18:	e406                	sd	ra,8(sp)
    80000c1a:	e022                	sd	s0,0(sp)
    80000c1c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1e:	00001097          	auipc	ra,0x1
    80000c22:	d44080e7          	jalr	-700(ra) # 80001962 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c26:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c2a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c2c:	e78d                	bnez	a5,80000c56 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	02f05b63          	blez	a5,80000c66 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c34:	37fd                	addiw	a5,a5,-1
    80000c36:	0007871b          	sext.w	a4,a5
    80000c3a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c3c:	eb09                	bnez	a4,80000c4e <pop_off+0x38>
    80000c3e:	5d7c                	lw	a5,124(a0)
    80000c40:	c799                	beqz	a5,80000c4e <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c42:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c46:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c4a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c4e:	60a2                	ld	ra,8(sp)
    80000c50:	6402                	ld	s0,0(sp)
    80000c52:	0141                	addi	sp,sp,16
    80000c54:	8082                	ret
    panic("pop_off - interruptible");
    80000c56:	00007517          	auipc	a0,0x7
    80000c5a:	42250513          	addi	a0,a0,1058 # 80008078 <digits+0x38>
    80000c5e:	00000097          	auipc	ra,0x0
    80000c62:	8cc080e7          	jalr	-1844(ra) # 8000052a <panic>
    panic("pop_off");
    80000c66:	00007517          	auipc	a0,0x7
    80000c6a:	42a50513          	addi	a0,a0,1066 # 80008090 <digits+0x50>
    80000c6e:	00000097          	auipc	ra,0x0
    80000c72:	8bc080e7          	jalr	-1860(ra) # 8000052a <panic>

0000000080000c76 <release>:
{
    80000c76:	1101                	addi	sp,sp,-32
    80000c78:	ec06                	sd	ra,24(sp)
    80000c7a:	e822                	sd	s0,16(sp)
    80000c7c:	e426                	sd	s1,8(sp)
    80000c7e:	1000                	addi	s0,sp,32
    80000c80:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c82:	00000097          	auipc	ra,0x0
    80000c86:	ec6080e7          	jalr	-314(ra) # 80000b48 <holding>
    80000c8a:	c115                	beqz	a0,80000cae <release+0x38>
  lk->cpu = 0;
    80000c8c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c90:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000c94:	0f50000f          	fence	iorw,ow
    80000c98:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000c9c:	00000097          	auipc	ra,0x0
    80000ca0:	f7a080e7          	jalr	-134(ra) # 80000c16 <pop_off>
}
    80000ca4:	60e2                	ld	ra,24(sp)
    80000ca6:	6442                	ld	s0,16(sp)
    80000ca8:	64a2                	ld	s1,8(sp)
    80000caa:	6105                	addi	sp,sp,32
    80000cac:	8082                	ret
    panic("release");
    80000cae:	00007517          	auipc	a0,0x7
    80000cb2:	3ea50513          	addi	a0,a0,1002 # 80008098 <digits+0x58>
    80000cb6:	00000097          	auipc	ra,0x0
    80000cba:	874080e7          	jalr	-1932(ra) # 8000052a <panic>

0000000080000cbe <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cbe:	1141                	addi	sp,sp,-16
    80000cc0:	e422                	sd	s0,8(sp)
    80000cc2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cc4:	ca19                	beqz	a2,80000cda <memset+0x1c>
    80000cc6:	87aa                	mv	a5,a0
    80000cc8:	1602                	slli	a2,a2,0x20
    80000cca:	9201                	srli	a2,a2,0x20
    80000ccc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cd0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cd4:	0785                	addi	a5,a5,1
    80000cd6:	fee79de3          	bne	a5,a4,80000cd0 <memset+0x12>
  }
  return dst;
}
    80000cda:	6422                	ld	s0,8(sp)
    80000cdc:	0141                	addi	sp,sp,16
    80000cde:	8082                	ret

0000000080000ce0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000ce0:	1141                	addi	sp,sp,-16
    80000ce2:	e422                	sd	s0,8(sp)
    80000ce4:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000ce6:	ca05                	beqz	a2,80000d16 <memcmp+0x36>
    80000ce8:	fff6069b          	addiw	a3,a2,-1
    80000cec:	1682                	slli	a3,a3,0x20
    80000cee:	9281                	srli	a3,a3,0x20
    80000cf0:	0685                	addi	a3,a3,1
    80000cf2:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cf4:	00054783          	lbu	a5,0(a0)
    80000cf8:	0005c703          	lbu	a4,0(a1)
    80000cfc:	00e79863          	bne	a5,a4,80000d0c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d00:	0505                	addi	a0,a0,1
    80000d02:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d04:	fed518e3          	bne	a0,a3,80000cf4 <memcmp+0x14>
  }

  return 0;
    80000d08:	4501                	li	a0,0
    80000d0a:	a019                	j	80000d10 <memcmp+0x30>
      return *s1 - *s2;
    80000d0c:	40e7853b          	subw	a0,a5,a4
}
    80000d10:	6422                	ld	s0,8(sp)
    80000d12:	0141                	addi	sp,sp,16
    80000d14:	8082                	ret
  return 0;
    80000d16:	4501                	li	a0,0
    80000d18:	bfe5                	j	80000d10 <memcmp+0x30>

0000000080000d1a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d1a:	1141                	addi	sp,sp,-16
    80000d1c:	e422                	sd	s0,8(sp)
    80000d1e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d20:	02a5e563          	bltu	a1,a0,80000d4a <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d24:	fff6069b          	addiw	a3,a2,-1
    80000d28:	ce11                	beqz	a2,80000d44 <memmove+0x2a>
    80000d2a:	1682                	slli	a3,a3,0x20
    80000d2c:	9281                	srli	a3,a3,0x20
    80000d2e:	0685                	addi	a3,a3,1
    80000d30:	96ae                	add	a3,a3,a1
    80000d32:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d34:	0585                	addi	a1,a1,1
    80000d36:	0785                	addi	a5,a5,1
    80000d38:	fff5c703          	lbu	a4,-1(a1)
    80000d3c:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d40:	fed59ae3          	bne	a1,a3,80000d34 <memmove+0x1a>

  return dst;
}
    80000d44:	6422                	ld	s0,8(sp)
    80000d46:	0141                	addi	sp,sp,16
    80000d48:	8082                	ret
  if(s < d && s + n > d){
    80000d4a:	02061713          	slli	a4,a2,0x20
    80000d4e:	9301                	srli	a4,a4,0x20
    80000d50:	00e587b3          	add	a5,a1,a4
    80000d54:	fcf578e3          	bgeu	a0,a5,80000d24 <memmove+0xa>
    d += n;
    80000d58:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000d5a:	fff6069b          	addiw	a3,a2,-1
    80000d5e:	d27d                	beqz	a2,80000d44 <memmove+0x2a>
    80000d60:	02069613          	slli	a2,a3,0x20
    80000d64:	9201                	srli	a2,a2,0x20
    80000d66:	fff64613          	not	a2,a2
    80000d6a:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000d6c:	17fd                	addi	a5,a5,-1
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	0007c683          	lbu	a3,0(a5)
    80000d74:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000d78:	fef61ae3          	bne	a2,a5,80000d6c <memmove+0x52>
    80000d7c:	b7e1                	j	80000d44 <memmove+0x2a>

0000000080000d7e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d86:	00000097          	auipc	ra,0x0
    80000d8a:	f94080e7          	jalr	-108(ra) # 80000d1a <memmove>
}
    80000d8e:	60a2                	ld	ra,8(sp)
    80000d90:	6402                	ld	s0,0(sp)
    80000d92:	0141                	addi	sp,sp,16
    80000d94:	8082                	ret

0000000080000d96 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d96:	1141                	addi	sp,sp,-16
    80000d98:	e422                	sd	s0,8(sp)
    80000d9a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9c:	ce11                	beqz	a2,80000db8 <strncmp+0x22>
    80000d9e:	00054783          	lbu	a5,0(a0)
    80000da2:	cf89                	beqz	a5,80000dbc <strncmp+0x26>
    80000da4:	0005c703          	lbu	a4,0(a1)
    80000da8:	00f71a63          	bne	a4,a5,80000dbc <strncmp+0x26>
    n--, p++, q++;
    80000dac:	367d                	addiw	a2,a2,-1
    80000dae:	0505                	addi	a0,a0,1
    80000db0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db2:	f675                	bnez	a2,80000d9e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db4:	4501                	li	a0,0
    80000db6:	a809                	j	80000dc8 <strncmp+0x32>
    80000db8:	4501                	li	a0,0
    80000dba:	a039                	j	80000dc8 <strncmp+0x32>
  if(n == 0)
    80000dbc:	ca09                	beqz	a2,80000dce <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000dbe:	00054503          	lbu	a0,0(a0)
    80000dc2:	0005c783          	lbu	a5,0(a1)
    80000dc6:	9d1d                	subw	a0,a0,a5
}
    80000dc8:	6422                	ld	s0,8(sp)
    80000dca:	0141                	addi	sp,sp,16
    80000dcc:	8082                	ret
    return 0;
    80000dce:	4501                	li	a0,0
    80000dd0:	bfe5                	j	80000dc8 <strncmp+0x32>

0000000080000dd2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd2:	1141                	addi	sp,sp,-16
    80000dd4:	e422                	sd	s0,8(sp)
    80000dd6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd8:	872a                	mv	a4,a0
    80000dda:	8832                	mv	a6,a2
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	01005963          	blez	a6,80000df0 <strncpy+0x1e>
    80000de2:	0705                	addi	a4,a4,1
    80000de4:	0005c783          	lbu	a5,0(a1)
    80000de8:	fef70fa3          	sb	a5,-1(a4)
    80000dec:	0585                	addi	a1,a1,1
    80000dee:	f7f5                	bnez	a5,80000dda <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df0:	86ba                	mv	a3,a4
    80000df2:	00c05c63          	blez	a2,80000e0a <strncpy+0x38>
    *s++ = 0;
    80000df6:	0685                	addi	a3,a3,1
    80000df8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000dfc:	fff6c793          	not	a5,a3
    80000e00:	9fb9                	addw	a5,a5,a4
    80000e02:	010787bb          	addw	a5,a5,a6
    80000e06:	fef048e3          	bgtz	a5,80000df6 <strncpy+0x24>
  return os;
}
    80000e0a:	6422                	ld	s0,8(sp)
    80000e0c:	0141                	addi	sp,sp,16
    80000e0e:	8082                	ret

0000000080000e10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e10:	1141                	addi	sp,sp,-16
    80000e12:	e422                	sd	s0,8(sp)
    80000e14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e16:	02c05363          	blez	a2,80000e3c <safestrcpy+0x2c>
    80000e1a:	fff6069b          	addiw	a3,a2,-1
    80000e1e:	1682                	slli	a3,a3,0x20
    80000e20:	9281                	srli	a3,a3,0x20
    80000e22:	96ae                	add	a3,a3,a1
    80000e24:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e26:	00d58963          	beq	a1,a3,80000e38 <safestrcpy+0x28>
    80000e2a:	0585                	addi	a1,a1,1
    80000e2c:	0785                	addi	a5,a5,1
    80000e2e:	fff5c703          	lbu	a4,-1(a1)
    80000e32:	fee78fa3          	sb	a4,-1(a5)
    80000e36:	fb65                	bnez	a4,80000e26 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e38:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e3c:	6422                	ld	s0,8(sp)
    80000e3e:	0141                	addi	sp,sp,16
    80000e40:	8082                	ret

0000000080000e42 <strlen>:

int
strlen(const char *s)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e422                	sd	s0,8(sp)
    80000e46:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e48:	00054783          	lbu	a5,0(a0)
    80000e4c:	cf91                	beqz	a5,80000e68 <strlen+0x26>
    80000e4e:	0505                	addi	a0,a0,1
    80000e50:	87aa                	mv	a5,a0
    80000e52:	4685                	li	a3,1
    80000e54:	9e89                	subw	a3,a3,a0
    80000e56:	00f6853b          	addw	a0,a3,a5
    80000e5a:	0785                	addi	a5,a5,1
    80000e5c:	fff7c703          	lbu	a4,-1(a5)
    80000e60:	fb7d                	bnez	a4,80000e56 <strlen+0x14>
    ;
  return n;
}
    80000e62:	6422                	ld	s0,8(sp)
    80000e64:	0141                	addi	sp,sp,16
    80000e66:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e68:	4501                	li	a0,0
    80000e6a:	bfe5                	j	80000e62 <strlen+0x20>

0000000080000e6c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e6c:	1141                	addi	sp,sp,-16
    80000e6e:	e406                	sd	ra,8(sp)
    80000e70:	e022                	sd	s0,0(sp)
    80000e72:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e74:	00001097          	auipc	ra,0x1
    80000e78:	ade080e7          	jalr	-1314(ra) # 80001952 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	00008717          	auipc	a4,0x8
    80000e80:	19c70713          	addi	a4,a4,412 # 80009018 <started>
  if(cpuid() == 0){
    80000e84:	c139                	beqz	a0,80000eca <main+0x5e>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x1a>
      ;
    __sync_synchronize();
    80000e8c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000e90:	00001097          	auipc	ra,0x1
    80000e94:	ac2080e7          	jalr	-1342(ra) # 80001952 <cpuid>
    80000e98:	85aa                	mv	a1,a0
    80000e9a:	00007517          	auipc	a0,0x7
    80000e9e:	21e50513          	addi	a0,a0,542 # 800080b8 <digits+0x78>
    80000ea2:	fffff097          	auipc	ra,0xfffff
    80000ea6:	6d2080e7          	jalr	1746(ra) # 80000574 <printf>
    kvminithart();    // turn on paging
    80000eaa:	00000097          	auipc	ra,0x0
    80000eae:	0d8080e7          	jalr	216(ra) # 80000f82 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	790080e7          	jalr	1936(ra) # 80002642 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eba:	00005097          	auipc	ra,0x5
    80000ebe:	df6080e7          	jalr	-522(ra) # 80005cb0 <plicinithart>
  }

  scheduler();        
    80000ec2:	00001097          	auipc	ra,0x1
    80000ec6:	fd2080e7          	jalr	-46(ra) # 80001e94 <scheduler>
    consoleinit();
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	572080e7          	jalr	1394(ra) # 8000043c <consoleinit>
    printfinit();
    80000ed2:	00000097          	auipc	ra,0x0
    80000ed6:	882080e7          	jalr	-1918(ra) # 80000754 <printfinit>
    printf("\n");
    80000eda:	00007517          	auipc	a0,0x7
    80000ede:	1ee50513          	addi	a0,a0,494 # 800080c8 <digits+0x88>
    80000ee2:	fffff097          	auipc	ra,0xfffff
    80000ee6:	692080e7          	jalr	1682(ra) # 80000574 <printf>
    printf("xv6 kernel is booting\n");
    80000eea:	00007517          	auipc	a0,0x7
    80000eee:	1b650513          	addi	a0,a0,438 # 800080a0 <digits+0x60>
    80000ef2:	fffff097          	auipc	ra,0xfffff
    80000ef6:	682080e7          	jalr	1666(ra) # 80000574 <printf>
    printf("\n");
    80000efa:	00007517          	auipc	a0,0x7
    80000efe:	1ce50513          	addi	a0,a0,462 # 800080c8 <digits+0x88>
    80000f02:	fffff097          	auipc	ra,0xfffff
    80000f06:	672080e7          	jalr	1650(ra) # 80000574 <printf>
    kinit();         // physical page allocator
    80000f0a:	00000097          	auipc	ra,0x0
    80000f0e:	b8c080e7          	jalr	-1140(ra) # 80000a96 <kinit>
    kvminit();       // create kernel page table
    80000f12:	00000097          	auipc	ra,0x0
    80000f16:	310080e7          	jalr	784(ra) # 80001222 <kvminit>
    kvminithart();   // turn on paging
    80000f1a:	00000097          	auipc	ra,0x0
    80000f1e:	068080e7          	jalr	104(ra) # 80000f82 <kvminithart>
    procinit();      // process table
    80000f22:	00001097          	auipc	ra,0x1
    80000f26:	980080e7          	jalr	-1664(ra) # 800018a2 <procinit>
    trapinit();      // trap vectors
    80000f2a:	00001097          	auipc	ra,0x1
    80000f2e:	6f0080e7          	jalr	1776(ra) # 8000261a <trapinit>
    trapinithart();  // install kernel trap vector
    80000f32:	00001097          	auipc	ra,0x1
    80000f36:	710080e7          	jalr	1808(ra) # 80002642 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f3a:	00005097          	auipc	ra,0x5
    80000f3e:	d60080e7          	jalr	-672(ra) # 80005c9a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f42:	00005097          	auipc	ra,0x5
    80000f46:	d6e080e7          	jalr	-658(ra) # 80005cb0 <plicinithart>
    binit();         // buffer cache
    80000f4a:	00002097          	auipc	ra,0x2
    80000f4e:	f3e080e7          	jalr	-194(ra) # 80002e88 <binit>
    iinit();         // inode cache
    80000f52:	00002097          	auipc	ra,0x2
    80000f56:	5d0080e7          	jalr	1488(ra) # 80003522 <iinit>
    fileinit();      // file table
    80000f5a:	00003097          	auipc	ra,0x3
    80000f5e:	57e080e7          	jalr	1406(ra) # 800044d8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f62:	00005097          	auipc	ra,0x5
    80000f66:	e70080e7          	jalr	-400(ra) # 80005dd2 <virtio_disk_init>
    userinit();      // first user process
    80000f6a:	00001097          	auipc	ra,0x1
    80000f6e:	cec080e7          	jalr	-788(ra) # 80001c56 <userinit>
    __sync_synchronize();
    80000f72:	0ff0000f          	fence
    started = 1;
    80000f76:	4785                	li	a5,1
    80000f78:	00008717          	auipc	a4,0x8
    80000f7c:	0af72023          	sw	a5,160(a4) # 80009018 <started>
    80000f80:	b789                	j	80000ec2 <main+0x56>

0000000080000f82 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f82:	1141                	addi	sp,sp,-16
    80000f84:	e422                	sd	s0,8(sp)
    80000f86:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000f88:	00008797          	auipc	a5,0x8
    80000f8c:	0987b783          	ld	a5,152(a5) # 80009020 <kernel_pagetable>
    80000f90:	83b1                	srli	a5,a5,0xc
    80000f92:	577d                	li	a4,-1
    80000f94:	177e                	slli	a4,a4,0x3f
    80000f96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f98:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f9c:	12000073          	sfence.vma
  sfence_vma();
}
    80000fa0:	6422                	ld	s0,8(sp)
    80000fa2:	0141                	addi	sp,sp,16
    80000fa4:	8082                	ret

0000000080000fa6 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000fa6:	7139                	addi	sp,sp,-64
    80000fa8:	fc06                	sd	ra,56(sp)
    80000faa:	f822                	sd	s0,48(sp)
    80000fac:	f426                	sd	s1,40(sp)
    80000fae:	f04a                	sd	s2,32(sp)
    80000fb0:	ec4e                	sd	s3,24(sp)
    80000fb2:	e852                	sd	s4,16(sp)
    80000fb4:	e456                	sd	s5,8(sp)
    80000fb6:	e05a                	sd	s6,0(sp)
    80000fb8:	0080                	addi	s0,sp,64
    80000fba:	84aa                	mv	s1,a0
    80000fbc:	89ae                	mv	s3,a1
    80000fbe:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000fc0:	57fd                	li	a5,-1
    80000fc2:	83e9                	srli	a5,a5,0x1a
    80000fc4:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000fc6:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000fc8:	04b7f263          	bgeu	a5,a1,8000100c <walk+0x66>
    panic("walk");
    80000fcc:	00007517          	auipc	a0,0x7
    80000fd0:	10450513          	addi	a0,a0,260 # 800080d0 <digits+0x90>
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	556080e7          	jalr	1366(ra) # 8000052a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fdc:	060a8663          	beqz	s5,80001048 <walk+0xa2>
    80000fe0:	00000097          	auipc	ra,0x0
    80000fe4:	af2080e7          	jalr	-1294(ra) # 80000ad2 <kalloc>
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	c529                	beqz	a0,80001034 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fec:	6605                	lui	a2,0x1
    80000fee:	4581                	li	a1,0
    80000ff0:	00000097          	auipc	ra,0x0
    80000ff4:	cce080e7          	jalr	-818(ra) # 80000cbe <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000ff8:	00c4d793          	srli	a5,s1,0xc
    80000ffc:	07aa                	slli	a5,a5,0xa
    80000ffe:	0017e793          	ori	a5,a5,1
    80001002:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001006:	3a5d                	addiw	s4,s4,-9
    80001008:	036a0063          	beq	s4,s6,80001028 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000100c:	0149d933          	srl	s2,s3,s4
    80001010:	1ff97913          	andi	s2,s2,511
    80001014:	090e                	slli	s2,s2,0x3
    80001016:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001018:	00093483          	ld	s1,0(s2)
    8000101c:	0014f793          	andi	a5,s1,1
    80001020:	dfd5                	beqz	a5,80000fdc <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001022:	80a9                	srli	s1,s1,0xa
    80001024:	04b2                	slli	s1,s1,0xc
    80001026:	b7c5                	j	80001006 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80001028:	00c9d513          	srli	a0,s3,0xc
    8000102c:	1ff57513          	andi	a0,a0,511
    80001030:	050e                	slli	a0,a0,0x3
    80001032:	9526                	add	a0,a0,s1
}
    80001034:	70e2                	ld	ra,56(sp)
    80001036:	7442                	ld	s0,48(sp)
    80001038:	74a2                	ld	s1,40(sp)
    8000103a:	7902                	ld	s2,32(sp)
    8000103c:	69e2                	ld	s3,24(sp)
    8000103e:	6a42                	ld	s4,16(sp)
    80001040:	6aa2                	ld	s5,8(sp)
    80001042:	6b02                	ld	s6,0(sp)
    80001044:	6121                	addi	sp,sp,64
    80001046:	8082                	ret
        return 0;
    80001048:	4501                	li	a0,0
    8000104a:	b7ed                	j	80001034 <walk+0x8e>

000000008000104c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000104c:	57fd                	li	a5,-1
    8000104e:	83e9                	srli	a5,a5,0x1a
    80001050:	00b7f463          	bgeu	a5,a1,80001058 <walkaddr+0xc>
    return 0;
    80001054:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001056:	8082                	ret
{
    80001058:	1141                	addi	sp,sp,-16
    8000105a:	e406                	sd	ra,8(sp)
    8000105c:	e022                	sd	s0,0(sp)
    8000105e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001060:	4601                	li	a2,0
    80001062:	00000097          	auipc	ra,0x0
    80001066:	f44080e7          	jalr	-188(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000106a:	c105                	beqz	a0,8000108a <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000106c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000106e:	0117f693          	andi	a3,a5,17
    80001072:	4745                	li	a4,17
    return 0;
    80001074:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001076:	00e68663          	beq	a3,a4,80001082 <walkaddr+0x36>
}
    8000107a:	60a2                	ld	ra,8(sp)
    8000107c:	6402                	ld	s0,0(sp)
    8000107e:	0141                	addi	sp,sp,16
    80001080:	8082                	ret
  pa = PTE2PA(*pte);
    80001082:	00a7d513          	srli	a0,a5,0xa
    80001086:	0532                	slli	a0,a0,0xc
  return pa;
    80001088:	bfcd                	j	8000107a <walkaddr+0x2e>
    return 0;
    8000108a:	4501                	li	a0,0
    8000108c:	b7fd                	j	8000107a <walkaddr+0x2e>

000000008000108e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000108e:	715d                	addi	sp,sp,-80
    80001090:	e486                	sd	ra,72(sp)
    80001092:	e0a2                	sd	s0,64(sp)
    80001094:	fc26                	sd	s1,56(sp)
    80001096:	f84a                	sd	s2,48(sp)
    80001098:	f44e                	sd	s3,40(sp)
    8000109a:	f052                	sd	s4,32(sp)
    8000109c:	ec56                	sd	s5,24(sp)
    8000109e:	e85a                	sd	s6,16(sp)
    800010a0:	e45e                	sd	s7,8(sp)
    800010a2:	0880                	addi	s0,sp,80
    800010a4:	8aaa                	mv	s5,a0
    800010a6:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    800010a8:	777d                	lui	a4,0xfffff
    800010aa:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800010ae:	167d                	addi	a2,a2,-1
    800010b0:	00b609b3          	add	s3,a2,a1
    800010b4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800010b8:	893e                	mv	s2,a5
    800010ba:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800010be:	6b85                	lui	s7,0x1
    800010c0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800010c4:	4605                	li	a2,1
    800010c6:	85ca                	mv	a1,s2
    800010c8:	8556                	mv	a0,s5
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	edc080e7          	jalr	-292(ra) # 80000fa6 <walk>
    800010d2:	c51d                	beqz	a0,80001100 <mappages+0x72>
    if(*pte & PTE_V)
    800010d4:	611c                	ld	a5,0(a0)
    800010d6:	8b85                	andi	a5,a5,1
    800010d8:	ef81                	bnez	a5,800010f0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800010da:	80b1                	srli	s1,s1,0xc
    800010dc:	04aa                	slli	s1,s1,0xa
    800010de:	0164e4b3          	or	s1,s1,s6
    800010e2:	0014e493          	ori	s1,s1,1
    800010e6:	e104                	sd	s1,0(a0)
    if(a == last)
    800010e8:	03390863          	beq	s2,s3,80001118 <mappages+0x8a>
    a += PGSIZE;
    800010ec:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ee:	bfc9                	j	800010c0 <mappages+0x32>
      panic("remap");
    800010f0:	00007517          	auipc	a0,0x7
    800010f4:	fe850513          	addi	a0,a0,-24 # 800080d8 <digits+0x98>
    800010f8:	fffff097          	auipc	ra,0xfffff
    800010fc:	432080e7          	jalr	1074(ra) # 8000052a <panic>
      return -1;
    80001100:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001102:	60a6                	ld	ra,72(sp)
    80001104:	6406                	ld	s0,64(sp)
    80001106:	74e2                	ld	s1,56(sp)
    80001108:	7942                	ld	s2,48(sp)
    8000110a:	79a2                	ld	s3,40(sp)
    8000110c:	7a02                	ld	s4,32(sp)
    8000110e:	6ae2                	ld	s5,24(sp)
    80001110:	6b42                	ld	s6,16(sp)
    80001112:	6ba2                	ld	s7,8(sp)
    80001114:	6161                	addi	sp,sp,80
    80001116:	8082                	ret
  return 0;
    80001118:	4501                	li	a0,0
    8000111a:	b7e5                	j	80001102 <mappages+0x74>

000000008000111c <kvmmap>:
{
    8000111c:	1141                	addi	sp,sp,-16
    8000111e:	e406                	sd	ra,8(sp)
    80001120:	e022                	sd	s0,0(sp)
    80001122:	0800                	addi	s0,sp,16
    80001124:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001126:	86b2                	mv	a3,a2
    80001128:	863e                	mv	a2,a5
    8000112a:	00000097          	auipc	ra,0x0
    8000112e:	f64080e7          	jalr	-156(ra) # 8000108e <mappages>
    80001132:	e509                	bnez	a0,8000113c <kvmmap+0x20>
}
    80001134:	60a2                	ld	ra,8(sp)
    80001136:	6402                	ld	s0,0(sp)
    80001138:	0141                	addi	sp,sp,16
    8000113a:	8082                	ret
    panic("kvmmap");
    8000113c:	00007517          	auipc	a0,0x7
    80001140:	fa450513          	addi	a0,a0,-92 # 800080e0 <digits+0xa0>
    80001144:	fffff097          	auipc	ra,0xfffff
    80001148:	3e6080e7          	jalr	998(ra) # 8000052a <panic>

000000008000114c <kvmmake>:
{
    8000114c:	1101                	addi	sp,sp,-32
    8000114e:	ec06                	sd	ra,24(sp)
    80001150:	e822                	sd	s0,16(sp)
    80001152:	e426                	sd	s1,8(sp)
    80001154:	e04a                	sd	s2,0(sp)
    80001156:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001158:	00000097          	auipc	ra,0x0
    8000115c:	97a080e7          	jalr	-1670(ra) # 80000ad2 <kalloc>
    80001160:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001162:	6605                	lui	a2,0x1
    80001164:	4581                	li	a1,0
    80001166:	00000097          	auipc	ra,0x0
    8000116a:	b58080e7          	jalr	-1192(ra) # 80000cbe <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000116e:	4719                	li	a4,6
    80001170:	6685                	lui	a3,0x1
    80001172:	10000637          	lui	a2,0x10000
    80001176:	100005b7          	lui	a1,0x10000
    8000117a:	8526                	mv	a0,s1
    8000117c:	00000097          	auipc	ra,0x0
    80001180:	fa0080e7          	jalr	-96(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001184:	4719                	li	a4,6
    80001186:	6685                	lui	a3,0x1
    80001188:	10001637          	lui	a2,0x10001
    8000118c:	100015b7          	lui	a1,0x10001
    80001190:	8526                	mv	a0,s1
    80001192:	00000097          	auipc	ra,0x0
    80001196:	f8a080e7          	jalr	-118(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000119a:	4719                	li	a4,6
    8000119c:	004006b7          	lui	a3,0x400
    800011a0:	0c000637          	lui	a2,0xc000
    800011a4:	0c0005b7          	lui	a1,0xc000
    800011a8:	8526                	mv	a0,s1
    800011aa:	00000097          	auipc	ra,0x0
    800011ae:	f72080e7          	jalr	-142(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800011b2:	00007917          	auipc	s2,0x7
    800011b6:	e4e90913          	addi	s2,s2,-434 # 80008000 <etext>
    800011ba:	4729                	li	a4,10
    800011bc:	80007697          	auipc	a3,0x80007
    800011c0:	e4468693          	addi	a3,a3,-444 # 8000 <_entry-0x7fff8000>
    800011c4:	4605                	li	a2,1
    800011c6:	067e                	slli	a2,a2,0x1f
    800011c8:	85b2                	mv	a1,a2
    800011ca:	8526                	mv	a0,s1
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	f50080e7          	jalr	-176(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800011d4:	4719                	li	a4,6
    800011d6:	46c5                	li	a3,17
    800011d8:	06ee                	slli	a3,a3,0x1b
    800011da:	412686b3          	sub	a3,a3,s2
    800011de:	864a                	mv	a2,s2
    800011e0:	85ca                	mv	a1,s2
    800011e2:	8526                	mv	a0,s1
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f38080e7          	jalr	-200(ra) # 8000111c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011ec:	4729                	li	a4,10
    800011ee:	6685                	lui	a3,0x1
    800011f0:	00006617          	auipc	a2,0x6
    800011f4:	e1060613          	addi	a2,a2,-496 # 80007000 <_trampoline>
    800011f8:	040005b7          	lui	a1,0x4000
    800011fc:	15fd                	addi	a1,a1,-1
    800011fe:	05b2                	slli	a1,a1,0xc
    80001200:	8526                	mv	a0,s1
    80001202:	00000097          	auipc	ra,0x0
    80001206:	f1a080e7          	jalr	-230(ra) # 8000111c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000120a:	8526                	mv	a0,s1
    8000120c:	00000097          	auipc	ra,0x0
    80001210:	600080e7          	jalr	1536(ra) # 8000180c <proc_mapstacks>
}
    80001214:	8526                	mv	a0,s1
    80001216:	60e2                	ld	ra,24(sp)
    80001218:	6442                	ld	s0,16(sp)
    8000121a:	64a2                	ld	s1,8(sp)
    8000121c:	6902                	ld	s2,0(sp)
    8000121e:	6105                	addi	sp,sp,32
    80001220:	8082                	ret

0000000080001222 <kvminit>:
{
    80001222:	1141                	addi	sp,sp,-16
    80001224:	e406                	sd	ra,8(sp)
    80001226:	e022                	sd	s0,0(sp)
    80001228:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	f22080e7          	jalr	-222(ra) # 8000114c <kvmmake>
    80001232:	00008797          	auipc	a5,0x8
    80001236:	dea7b723          	sd	a0,-530(a5) # 80009020 <kernel_pagetable>
}
    8000123a:	60a2                	ld	ra,8(sp)
    8000123c:	6402                	ld	s0,0(sp)
    8000123e:	0141                	addi	sp,sp,16
    80001240:	8082                	ret

0000000080001242 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001242:	715d                	addi	sp,sp,-80
    80001244:	e486                	sd	ra,72(sp)
    80001246:	e0a2                	sd	s0,64(sp)
    80001248:	fc26                	sd	s1,56(sp)
    8000124a:	f84a                	sd	s2,48(sp)
    8000124c:	f44e                	sd	s3,40(sp)
    8000124e:	f052                	sd	s4,32(sp)
    80001250:	ec56                	sd	s5,24(sp)
    80001252:	e85a                	sd	s6,16(sp)
    80001254:	e45e                	sd	s7,8(sp)
    80001256:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001258:	03459793          	slli	a5,a1,0x34
    8000125c:	e795                	bnez	a5,80001288 <uvmunmap+0x46>
    8000125e:	8a2a                	mv	s4,a0
    80001260:	892e                	mv	s2,a1
    80001262:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001264:	0632                	slli	a2,a2,0xc
    80001266:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000126c:	6b05                	lui	s6,0x1
    8000126e:	0735e263          	bltu	a1,s3,800012d2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001272:	60a6                	ld	ra,72(sp)
    80001274:	6406                	ld	s0,64(sp)
    80001276:	74e2                	ld	s1,56(sp)
    80001278:	7942                	ld	s2,48(sp)
    8000127a:	79a2                	ld	s3,40(sp)
    8000127c:	7a02                	ld	s4,32(sp)
    8000127e:	6ae2                	ld	s5,24(sp)
    80001280:	6b42                	ld	s6,16(sp)
    80001282:	6ba2                	ld	s7,8(sp)
    80001284:	6161                	addi	sp,sp,80
    80001286:	8082                	ret
    panic("uvmunmap: not aligned");
    80001288:	00007517          	auipc	a0,0x7
    8000128c:	e6050513          	addi	a0,a0,-416 # 800080e8 <digits+0xa8>
    80001290:	fffff097          	auipc	ra,0xfffff
    80001294:	29a080e7          	jalr	666(ra) # 8000052a <panic>
      panic("uvmunmap: walk");
    80001298:	00007517          	auipc	a0,0x7
    8000129c:	e6850513          	addi	a0,a0,-408 # 80008100 <digits+0xc0>
    800012a0:	fffff097          	auipc	ra,0xfffff
    800012a4:	28a080e7          	jalr	650(ra) # 8000052a <panic>
      panic("uvmunmap: not mapped");
    800012a8:	00007517          	auipc	a0,0x7
    800012ac:	e6850513          	addi	a0,a0,-408 # 80008110 <digits+0xd0>
    800012b0:	fffff097          	auipc	ra,0xfffff
    800012b4:	27a080e7          	jalr	634(ra) # 8000052a <panic>
      panic("uvmunmap: not a leaf");
    800012b8:	00007517          	auipc	a0,0x7
    800012bc:	e7050513          	addi	a0,a0,-400 # 80008128 <digits+0xe8>
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	26a080e7          	jalr	618(ra) # 8000052a <panic>
    *pte = 0;
    800012c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012cc:	995a                	add	s2,s2,s6
    800012ce:	fb3972e3          	bgeu	s2,s3,80001272 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800012d2:	4601                	li	a2,0
    800012d4:	85ca                	mv	a1,s2
    800012d6:	8552                	mv	a0,s4
    800012d8:	00000097          	auipc	ra,0x0
    800012dc:	cce080e7          	jalr	-818(ra) # 80000fa6 <walk>
    800012e0:	84aa                	mv	s1,a0
    800012e2:	d95d                	beqz	a0,80001298 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800012e4:	6108                	ld	a0,0(a0)
    800012e6:	00157793          	andi	a5,a0,1
    800012ea:	dfdd                	beqz	a5,800012a8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800012ec:	3ff57793          	andi	a5,a0,1023
    800012f0:	fd7784e3          	beq	a5,s7,800012b8 <uvmunmap+0x76>
    if(do_free){
    800012f4:	fc0a8ae3          	beqz	s5,800012c8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800012f8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800012fa:	0532                	slli	a0,a0,0xc
    800012fc:	fffff097          	auipc	ra,0xfffff
    80001300:	6da080e7          	jalr	1754(ra) # 800009d6 <kfree>
    80001304:	b7d1                	j	800012c8 <uvmunmap+0x86>

0000000080001306 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001306:	1101                	addi	sp,sp,-32
    80001308:	ec06                	sd	ra,24(sp)
    8000130a:	e822                	sd	s0,16(sp)
    8000130c:	e426                	sd	s1,8(sp)
    8000130e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001310:	fffff097          	auipc	ra,0xfffff
    80001314:	7c2080e7          	jalr	1986(ra) # 80000ad2 <kalloc>
    80001318:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000131a:	c519                	beqz	a0,80001328 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000131c:	6605                	lui	a2,0x1
    8000131e:	4581                	li	a1,0
    80001320:	00000097          	auipc	ra,0x0
    80001324:	99e080e7          	jalr	-1634(ra) # 80000cbe <memset>
  return pagetable;
}
    80001328:	8526                	mv	a0,s1
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    80001334:	7179                	addi	sp,sp,-48
    80001336:	f406                	sd	ra,40(sp)
    80001338:	f022                	sd	s0,32(sp)
    8000133a:	ec26                	sd	s1,24(sp)
    8000133c:	e84a                	sd	s2,16(sp)
    8000133e:	e44e                	sd	s3,8(sp)
    80001340:	e052                	sd	s4,0(sp)
    80001342:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001344:	6785                	lui	a5,0x1
    80001346:	04f67863          	bgeu	a2,a5,80001396 <uvminit+0x62>
    8000134a:	8a2a                	mv	s4,a0
    8000134c:	89ae                	mv	s3,a1
    8000134e:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	782080e7          	jalr	1922(ra) # 80000ad2 <kalloc>
    80001358:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000135a:	6605                	lui	a2,0x1
    8000135c:	4581                	li	a1,0
    8000135e:	00000097          	auipc	ra,0x0
    80001362:	960080e7          	jalr	-1696(ra) # 80000cbe <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001366:	4779                	li	a4,30
    80001368:	86ca                	mv	a3,s2
    8000136a:	6605                	lui	a2,0x1
    8000136c:	4581                	li	a1,0
    8000136e:	8552                	mv	a0,s4
    80001370:	00000097          	auipc	ra,0x0
    80001374:	d1e080e7          	jalr	-738(ra) # 8000108e <mappages>
  memmove(mem, src, sz);
    80001378:	8626                	mv	a2,s1
    8000137a:	85ce                	mv	a1,s3
    8000137c:	854a                	mv	a0,s2
    8000137e:	00000097          	auipc	ra,0x0
    80001382:	99c080e7          	jalr	-1636(ra) # 80000d1a <memmove>
}
    80001386:	70a2                	ld	ra,40(sp)
    80001388:	7402                	ld	s0,32(sp)
    8000138a:	64e2                	ld	s1,24(sp)
    8000138c:	6942                	ld	s2,16(sp)
    8000138e:	69a2                	ld	s3,8(sp)
    80001390:	6a02                	ld	s4,0(sp)
    80001392:	6145                	addi	sp,sp,48
    80001394:	8082                	ret
    panic("inituvm: more than a page");
    80001396:	00007517          	auipc	a0,0x7
    8000139a:	daa50513          	addi	a0,a0,-598 # 80008140 <digits+0x100>
    8000139e:	fffff097          	auipc	ra,0xfffff
    800013a2:	18c080e7          	jalr	396(ra) # 8000052a <panic>

00000000800013a6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800013a6:	1101                	addi	sp,sp,-32
    800013a8:	ec06                	sd	ra,24(sp)
    800013aa:	e822                	sd	s0,16(sp)
    800013ac:	e426                	sd	s1,8(sp)
    800013ae:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800013b0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800013b2:	00b67d63          	bgeu	a2,a1,800013cc <uvmdealloc+0x26>
    800013b6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800013b8:	6785                	lui	a5,0x1
    800013ba:	17fd                	addi	a5,a5,-1
    800013bc:	00f60733          	add	a4,a2,a5
    800013c0:	767d                	lui	a2,0xfffff
    800013c2:	8f71                	and	a4,a4,a2
    800013c4:	97ae                	add	a5,a5,a1
    800013c6:	8ff1                	and	a5,a5,a2
    800013c8:	00f76863          	bltu	a4,a5,800013d8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800013cc:	8526                	mv	a0,s1
    800013ce:	60e2                	ld	ra,24(sp)
    800013d0:	6442                	ld	s0,16(sp)
    800013d2:	64a2                	ld	s1,8(sp)
    800013d4:	6105                	addi	sp,sp,32
    800013d6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800013d8:	8f99                	sub	a5,a5,a4
    800013da:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800013dc:	4685                	li	a3,1
    800013de:	0007861b          	sext.w	a2,a5
    800013e2:	85ba                	mv	a1,a4
    800013e4:	00000097          	auipc	ra,0x0
    800013e8:	e5e080e7          	jalr	-418(ra) # 80001242 <uvmunmap>
    800013ec:	b7c5                	j	800013cc <uvmdealloc+0x26>

00000000800013ee <uvmalloc>:
  if(newsz < oldsz)
    800013ee:	0ab66163          	bltu	a2,a1,80001490 <uvmalloc+0xa2>
{
    800013f2:	7139                	addi	sp,sp,-64
    800013f4:	fc06                	sd	ra,56(sp)
    800013f6:	f822                	sd	s0,48(sp)
    800013f8:	f426                	sd	s1,40(sp)
    800013fa:	f04a                	sd	s2,32(sp)
    800013fc:	ec4e                	sd	s3,24(sp)
    800013fe:	e852                	sd	s4,16(sp)
    80001400:	e456                	sd	s5,8(sp)
    80001402:	0080                	addi	s0,sp,64
    80001404:	8aaa                	mv	s5,a0
    80001406:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001408:	6985                	lui	s3,0x1
    8000140a:	19fd                	addi	s3,s3,-1
    8000140c:	95ce                	add	a1,a1,s3
    8000140e:	79fd                	lui	s3,0xfffff
    80001410:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001414:	08c9f063          	bgeu	s3,a2,80001494 <uvmalloc+0xa6>
    80001418:	894e                	mv	s2,s3
    mem = kalloc();
    8000141a:	fffff097          	auipc	ra,0xfffff
    8000141e:	6b8080e7          	jalr	1720(ra) # 80000ad2 <kalloc>
    80001422:	84aa                	mv	s1,a0
    if(mem == 0){
    80001424:	c51d                	beqz	a0,80001452 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001426:	6605                	lui	a2,0x1
    80001428:	4581                	li	a1,0
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	894080e7          	jalr	-1900(ra) # 80000cbe <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    80001432:	4779                	li	a4,30
    80001434:	86a6                	mv	a3,s1
    80001436:	6605                	lui	a2,0x1
    80001438:	85ca                	mv	a1,s2
    8000143a:	8556                	mv	a0,s5
    8000143c:	00000097          	auipc	ra,0x0
    80001440:	c52080e7          	jalr	-942(ra) # 8000108e <mappages>
    80001444:	e905                	bnez	a0,80001474 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001446:	6785                	lui	a5,0x1
    80001448:	993e                	add	s2,s2,a5
    8000144a:	fd4968e3          	bltu	s2,s4,8000141a <uvmalloc+0x2c>
  return newsz;
    8000144e:	8552                	mv	a0,s4
    80001450:	a809                	j	80001462 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    80001452:	864e                	mv	a2,s3
    80001454:	85ca                	mv	a1,s2
    80001456:	8556                	mv	a0,s5
    80001458:	00000097          	auipc	ra,0x0
    8000145c:	f4e080e7          	jalr	-178(ra) # 800013a6 <uvmdealloc>
      return 0;
    80001460:	4501                	li	a0,0
}
    80001462:	70e2                	ld	ra,56(sp)
    80001464:	7442                	ld	s0,48(sp)
    80001466:	74a2                	ld	s1,40(sp)
    80001468:	7902                	ld	s2,32(sp)
    8000146a:	69e2                	ld	s3,24(sp)
    8000146c:	6a42                	ld	s4,16(sp)
    8000146e:	6aa2                	ld	s5,8(sp)
    80001470:	6121                	addi	sp,sp,64
    80001472:	8082                	ret
      kfree(mem);
    80001474:	8526                	mv	a0,s1
    80001476:	fffff097          	auipc	ra,0xfffff
    8000147a:	560080e7          	jalr	1376(ra) # 800009d6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000147e:	864e                	mv	a2,s3
    80001480:	85ca                	mv	a1,s2
    80001482:	8556                	mv	a0,s5
    80001484:	00000097          	auipc	ra,0x0
    80001488:	f22080e7          	jalr	-222(ra) # 800013a6 <uvmdealloc>
      return 0;
    8000148c:	4501                	li	a0,0
    8000148e:	bfd1                	j	80001462 <uvmalloc+0x74>
    return oldsz;
    80001490:	852e                	mv	a0,a1
}
    80001492:	8082                	ret
  return newsz;
    80001494:	8532                	mv	a0,a2
    80001496:	b7f1                	j	80001462 <uvmalloc+0x74>

0000000080001498 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001498:	7179                	addi	sp,sp,-48
    8000149a:	f406                	sd	ra,40(sp)
    8000149c:	f022                	sd	s0,32(sp)
    8000149e:	ec26                	sd	s1,24(sp)
    800014a0:	e84a                	sd	s2,16(sp)
    800014a2:	e44e                	sd	s3,8(sp)
    800014a4:	e052                	sd	s4,0(sp)
    800014a6:	1800                	addi	s0,sp,48
    800014a8:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800014aa:	84aa                	mv	s1,a0
    800014ac:	6905                	lui	s2,0x1
    800014ae:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014b0:	4985                	li	s3,1
    800014b2:	a821                	j	800014ca <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800014b4:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800014b6:	0532                	slli	a0,a0,0xc
    800014b8:	00000097          	auipc	ra,0x0
    800014bc:	fe0080e7          	jalr	-32(ra) # 80001498 <freewalk>
      pagetable[i] = 0;
    800014c0:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800014c4:	04a1                	addi	s1,s1,8
    800014c6:	03248163          	beq	s1,s2,800014e8 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800014ca:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800014cc:	00f57793          	andi	a5,a0,15
    800014d0:	ff3782e3          	beq	a5,s3,800014b4 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800014d4:	8905                	andi	a0,a0,1
    800014d6:	d57d                	beqz	a0,800014c4 <freewalk+0x2c>
      panic("freewalk: leaf");
    800014d8:	00007517          	auipc	a0,0x7
    800014dc:	c8850513          	addi	a0,a0,-888 # 80008160 <digits+0x120>
    800014e0:	fffff097          	auipc	ra,0xfffff
    800014e4:	04a080e7          	jalr	74(ra) # 8000052a <panic>
    }
  }
  kfree((void*)pagetable);
    800014e8:	8552                	mv	a0,s4
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	4ec080e7          	jalr	1260(ra) # 800009d6 <kfree>
}
    800014f2:	70a2                	ld	ra,40(sp)
    800014f4:	7402                	ld	s0,32(sp)
    800014f6:	64e2                	ld	s1,24(sp)
    800014f8:	6942                	ld	s2,16(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	6a02                	ld	s4,0(sp)
    800014fe:	6145                	addi	sp,sp,48
    80001500:	8082                	ret

0000000080001502 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001502:	1101                	addi	sp,sp,-32
    80001504:	ec06                	sd	ra,24(sp)
    80001506:	e822                	sd	s0,16(sp)
    80001508:	e426                	sd	s1,8(sp)
    8000150a:	1000                	addi	s0,sp,32
    8000150c:	84aa                	mv	s1,a0
  if(sz > 0)
    8000150e:	e999                	bnez	a1,80001524 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001510:	8526                	mv	a0,s1
    80001512:	00000097          	auipc	ra,0x0
    80001516:	f86080e7          	jalr	-122(ra) # 80001498 <freewalk>
}
    8000151a:	60e2                	ld	ra,24(sp)
    8000151c:	6442                	ld	s0,16(sp)
    8000151e:	64a2                	ld	s1,8(sp)
    80001520:	6105                	addi	sp,sp,32
    80001522:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001524:	6605                	lui	a2,0x1
    80001526:	167d                	addi	a2,a2,-1
    80001528:	962e                	add	a2,a2,a1
    8000152a:	4685                	li	a3,1
    8000152c:	8231                	srli	a2,a2,0xc
    8000152e:	4581                	li	a1,0
    80001530:	00000097          	auipc	ra,0x0
    80001534:	d12080e7          	jalr	-750(ra) # 80001242 <uvmunmap>
    80001538:	bfe1                	j	80001510 <uvmfree+0xe>

000000008000153a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000153a:	c679                	beqz	a2,80001608 <uvmcopy+0xce>
{
    8000153c:	715d                	addi	sp,sp,-80
    8000153e:	e486                	sd	ra,72(sp)
    80001540:	e0a2                	sd	s0,64(sp)
    80001542:	fc26                	sd	s1,56(sp)
    80001544:	f84a                	sd	s2,48(sp)
    80001546:	f44e                	sd	s3,40(sp)
    80001548:	f052                	sd	s4,32(sp)
    8000154a:	ec56                	sd	s5,24(sp)
    8000154c:	e85a                	sd	s6,16(sp)
    8000154e:	e45e                	sd	s7,8(sp)
    80001550:	0880                	addi	s0,sp,80
    80001552:	8b2a                	mv	s6,a0
    80001554:	8aae                	mv	s5,a1
    80001556:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001558:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000155a:	4601                	li	a2,0
    8000155c:	85ce                	mv	a1,s3
    8000155e:	855a                	mv	a0,s6
    80001560:	00000097          	auipc	ra,0x0
    80001564:	a46080e7          	jalr	-1466(ra) # 80000fa6 <walk>
    80001568:	c531                	beqz	a0,800015b4 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000156a:	6118                	ld	a4,0(a0)
    8000156c:	00177793          	andi	a5,a4,1
    80001570:	cbb1                	beqz	a5,800015c4 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001572:	00a75593          	srli	a1,a4,0xa
    80001576:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000157a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000157e:	fffff097          	auipc	ra,0xfffff
    80001582:	554080e7          	jalr	1364(ra) # 80000ad2 <kalloc>
    80001586:	892a                	mv	s2,a0
    80001588:	c939                	beqz	a0,800015de <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000158a:	6605                	lui	a2,0x1
    8000158c:	85de                	mv	a1,s7
    8000158e:	fffff097          	auipc	ra,0xfffff
    80001592:	78c080e7          	jalr	1932(ra) # 80000d1a <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001596:	8726                	mv	a4,s1
    80001598:	86ca                	mv	a3,s2
    8000159a:	6605                	lui	a2,0x1
    8000159c:	85ce                	mv	a1,s3
    8000159e:	8556                	mv	a0,s5
    800015a0:	00000097          	auipc	ra,0x0
    800015a4:	aee080e7          	jalr	-1298(ra) # 8000108e <mappages>
    800015a8:	e515                	bnez	a0,800015d4 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    800015aa:	6785                	lui	a5,0x1
    800015ac:	99be                	add	s3,s3,a5
    800015ae:	fb49e6e3          	bltu	s3,s4,8000155a <uvmcopy+0x20>
    800015b2:	a081                	j	800015f2 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    800015b4:	00007517          	auipc	a0,0x7
    800015b8:	bbc50513          	addi	a0,a0,-1092 # 80008170 <digits+0x130>
    800015bc:	fffff097          	auipc	ra,0xfffff
    800015c0:	f6e080e7          	jalr	-146(ra) # 8000052a <panic>
      panic("uvmcopy: page not present");
    800015c4:	00007517          	auipc	a0,0x7
    800015c8:	bcc50513          	addi	a0,a0,-1076 # 80008190 <digits+0x150>
    800015cc:	fffff097          	auipc	ra,0xfffff
    800015d0:	f5e080e7          	jalr	-162(ra) # 8000052a <panic>
      kfree(mem);
    800015d4:	854a                	mv	a0,s2
    800015d6:	fffff097          	auipc	ra,0xfffff
    800015da:	400080e7          	jalr	1024(ra) # 800009d6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800015de:	4685                	li	a3,1
    800015e0:	00c9d613          	srli	a2,s3,0xc
    800015e4:	4581                	li	a1,0
    800015e6:	8556                	mv	a0,s5
    800015e8:	00000097          	auipc	ra,0x0
    800015ec:	c5a080e7          	jalr	-934(ra) # 80001242 <uvmunmap>
  return -1;
    800015f0:	557d                	li	a0,-1
}
    800015f2:	60a6                	ld	ra,72(sp)
    800015f4:	6406                	ld	s0,64(sp)
    800015f6:	74e2                	ld	s1,56(sp)
    800015f8:	7942                	ld	s2,48(sp)
    800015fa:	79a2                	ld	s3,40(sp)
    800015fc:	7a02                	ld	s4,32(sp)
    800015fe:	6ae2                	ld	s5,24(sp)
    80001600:	6b42                	ld	s6,16(sp)
    80001602:	6ba2                	ld	s7,8(sp)
    80001604:	6161                	addi	sp,sp,80
    80001606:	8082                	ret
  return 0;
    80001608:	4501                	li	a0,0
}
    8000160a:	8082                	ret

000000008000160c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000160c:	1141                	addi	sp,sp,-16
    8000160e:	e406                	sd	ra,8(sp)
    80001610:	e022                	sd	s0,0(sp)
    80001612:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001614:	4601                	li	a2,0
    80001616:	00000097          	auipc	ra,0x0
    8000161a:	990080e7          	jalr	-1648(ra) # 80000fa6 <walk>
  if(pte == 0)
    8000161e:	c901                	beqz	a0,8000162e <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001620:	611c                	ld	a5,0(a0)
    80001622:	9bbd                	andi	a5,a5,-17
    80001624:	e11c                	sd	a5,0(a0)
}
    80001626:	60a2                	ld	ra,8(sp)
    80001628:	6402                	ld	s0,0(sp)
    8000162a:	0141                	addi	sp,sp,16
    8000162c:	8082                	ret
    panic("uvmclear");
    8000162e:	00007517          	auipc	a0,0x7
    80001632:	b8250513          	addi	a0,a0,-1150 # 800081b0 <digits+0x170>
    80001636:	fffff097          	auipc	ra,0xfffff
    8000163a:	ef4080e7          	jalr	-268(ra) # 8000052a <panic>

000000008000163e <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000163e:	c6bd                	beqz	a3,800016ac <copyout+0x6e>
{
    80001640:	715d                	addi	sp,sp,-80
    80001642:	e486                	sd	ra,72(sp)
    80001644:	e0a2                	sd	s0,64(sp)
    80001646:	fc26                	sd	s1,56(sp)
    80001648:	f84a                	sd	s2,48(sp)
    8000164a:	f44e                	sd	s3,40(sp)
    8000164c:	f052                	sd	s4,32(sp)
    8000164e:	ec56                	sd	s5,24(sp)
    80001650:	e85a                	sd	s6,16(sp)
    80001652:	e45e                	sd	s7,8(sp)
    80001654:	e062                	sd	s8,0(sp)
    80001656:	0880                	addi	s0,sp,80
    80001658:	8b2a                	mv	s6,a0
    8000165a:	8c2e                	mv	s8,a1
    8000165c:	8a32                	mv	s4,a2
    8000165e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001660:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001662:	6a85                	lui	s5,0x1
    80001664:	a015                	j	80001688 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001666:	9562                	add	a0,a0,s8
    80001668:	0004861b          	sext.w	a2,s1
    8000166c:	85d2                	mv	a1,s4
    8000166e:	41250533          	sub	a0,a0,s2
    80001672:	fffff097          	auipc	ra,0xfffff
    80001676:	6a8080e7          	jalr	1704(ra) # 80000d1a <memmove>

    len -= n;
    8000167a:	409989b3          	sub	s3,s3,s1
    src += n;
    8000167e:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001680:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001684:	02098263          	beqz	s3,800016a8 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001688:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000168c:	85ca                	mv	a1,s2
    8000168e:	855a                	mv	a0,s6
    80001690:	00000097          	auipc	ra,0x0
    80001694:	9bc080e7          	jalr	-1604(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    80001698:	cd01                	beqz	a0,800016b0 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000169a:	418904b3          	sub	s1,s2,s8
    8000169e:	94d6                	add	s1,s1,s5
    if(n > len)
    800016a0:	fc99f3e3          	bgeu	s3,s1,80001666 <copyout+0x28>
    800016a4:	84ce                	mv	s1,s3
    800016a6:	b7c1                	j	80001666 <copyout+0x28>
  }
  return 0;
    800016a8:	4501                	li	a0,0
    800016aa:	a021                	j	800016b2 <copyout+0x74>
    800016ac:	4501                	li	a0,0
}
    800016ae:	8082                	ret
      return -1;
    800016b0:	557d                	li	a0,-1
}
    800016b2:	60a6                	ld	ra,72(sp)
    800016b4:	6406                	ld	s0,64(sp)
    800016b6:	74e2                	ld	s1,56(sp)
    800016b8:	7942                	ld	s2,48(sp)
    800016ba:	79a2                	ld	s3,40(sp)
    800016bc:	7a02                	ld	s4,32(sp)
    800016be:	6ae2                	ld	s5,24(sp)
    800016c0:	6b42                	ld	s6,16(sp)
    800016c2:	6ba2                	ld	s7,8(sp)
    800016c4:	6c02                	ld	s8,0(sp)
    800016c6:	6161                	addi	sp,sp,80
    800016c8:	8082                	ret

00000000800016ca <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016ca:	caa5                	beqz	a3,8000173a <copyin+0x70>
{
    800016cc:	715d                	addi	sp,sp,-80
    800016ce:	e486                	sd	ra,72(sp)
    800016d0:	e0a2                	sd	s0,64(sp)
    800016d2:	fc26                	sd	s1,56(sp)
    800016d4:	f84a                	sd	s2,48(sp)
    800016d6:	f44e                	sd	s3,40(sp)
    800016d8:	f052                	sd	s4,32(sp)
    800016da:	ec56                	sd	s5,24(sp)
    800016dc:	e85a                	sd	s6,16(sp)
    800016de:	e45e                	sd	s7,8(sp)
    800016e0:	e062                	sd	s8,0(sp)
    800016e2:	0880                	addi	s0,sp,80
    800016e4:	8b2a                	mv	s6,a0
    800016e6:	8a2e                	mv	s4,a1
    800016e8:	8c32                	mv	s8,a2
    800016ea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016ec:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016ee:	6a85                	lui	s5,0x1
    800016f0:	a01d                	j	80001716 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016f2:	018505b3          	add	a1,a0,s8
    800016f6:	0004861b          	sext.w	a2,s1
    800016fa:	412585b3          	sub	a1,a1,s2
    800016fe:	8552                	mv	a0,s4
    80001700:	fffff097          	auipc	ra,0xfffff
    80001704:	61a080e7          	jalr	1562(ra) # 80000d1a <memmove>

    len -= n;
    80001708:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000170c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000170e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001712:	02098263          	beqz	s3,80001736 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001716:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000171a:	85ca                	mv	a1,s2
    8000171c:	855a                	mv	a0,s6
    8000171e:	00000097          	auipc	ra,0x0
    80001722:	92e080e7          	jalr	-1746(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    80001726:	cd01                	beqz	a0,8000173e <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001728:	418904b3          	sub	s1,s2,s8
    8000172c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000172e:	fc99f2e3          	bgeu	s3,s1,800016f2 <copyin+0x28>
    80001732:	84ce                	mv	s1,s3
    80001734:	bf7d                	j	800016f2 <copyin+0x28>
  }
  return 0;
    80001736:	4501                	li	a0,0
    80001738:	a021                	j	80001740 <copyin+0x76>
    8000173a:	4501                	li	a0,0
}
    8000173c:	8082                	ret
      return -1;
    8000173e:	557d                	li	a0,-1
}
    80001740:	60a6                	ld	ra,72(sp)
    80001742:	6406                	ld	s0,64(sp)
    80001744:	74e2                	ld	s1,56(sp)
    80001746:	7942                	ld	s2,48(sp)
    80001748:	79a2                	ld	s3,40(sp)
    8000174a:	7a02                	ld	s4,32(sp)
    8000174c:	6ae2                	ld	s5,24(sp)
    8000174e:	6b42                	ld	s6,16(sp)
    80001750:	6ba2                	ld	s7,8(sp)
    80001752:	6c02                	ld	s8,0(sp)
    80001754:	6161                	addi	sp,sp,80
    80001756:	8082                	ret

0000000080001758 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001758:	c6c5                	beqz	a3,80001800 <copyinstr+0xa8>
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	0880                	addi	s0,sp,80
    80001770:	8a2a                	mv	s4,a0
    80001772:	8b2e                	mv	s6,a1
    80001774:	8bb2                	mv	s7,a2
    80001776:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001778:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000177a:	6985                	lui	s3,0x1
    8000177c:	a035                	j	800017a8 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000177e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001782:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001784:	0017b793          	seqz	a5,a5
    80001788:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000178c:	60a6                	ld	ra,72(sp)
    8000178e:	6406                	ld	s0,64(sp)
    80001790:	74e2                	ld	s1,56(sp)
    80001792:	7942                	ld	s2,48(sp)
    80001794:	79a2                	ld	s3,40(sp)
    80001796:	7a02                	ld	s4,32(sp)
    80001798:	6ae2                	ld	s5,24(sp)
    8000179a:	6b42                	ld	s6,16(sp)
    8000179c:	6ba2                	ld	s7,8(sp)
    8000179e:	6161                	addi	sp,sp,80
    800017a0:	8082                	ret
    srcva = va0 + PGSIZE;
    800017a2:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    800017a6:	c8a9                	beqz	s1,800017f8 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    800017a8:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800017ac:	85ca                	mv	a1,s2
    800017ae:	8552                	mv	a0,s4
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	89c080e7          	jalr	-1892(ra) # 8000104c <walkaddr>
    if(pa0 == 0)
    800017b8:	c131                	beqz	a0,800017fc <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800017ba:	41790833          	sub	a6,s2,s7
    800017be:	984e                	add	a6,a6,s3
    if(n > max)
    800017c0:	0104f363          	bgeu	s1,a6,800017c6 <copyinstr+0x6e>
    800017c4:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    800017c6:	955e                	add	a0,a0,s7
    800017c8:	41250533          	sub	a0,a0,s2
    while(n > 0){
    800017cc:	fc080be3          	beqz	a6,800017a2 <copyinstr+0x4a>
    800017d0:	985a                	add	a6,a6,s6
    800017d2:	87da                	mv	a5,s6
      if(*p == '\0'){
    800017d4:	41650633          	sub	a2,a0,s6
    800017d8:	14fd                	addi	s1,s1,-1
    800017da:	9b26                	add	s6,s6,s1
    800017dc:	00f60733          	add	a4,a2,a5
    800017e0:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    800017e4:	df49                	beqz	a4,8000177e <copyinstr+0x26>
        *dst = *p;
    800017e6:	00e78023          	sb	a4,0(a5)
      --max;
    800017ea:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800017ee:	0785                	addi	a5,a5,1
    while(n > 0){
    800017f0:	ff0796e3          	bne	a5,a6,800017dc <copyinstr+0x84>
      dst++;
    800017f4:	8b42                	mv	s6,a6
    800017f6:	b775                	j	800017a2 <copyinstr+0x4a>
    800017f8:	4781                	li	a5,0
    800017fa:	b769                	j	80001784 <copyinstr+0x2c>
      return -1;
    800017fc:	557d                	li	a0,-1
    800017fe:	b779                	j	8000178c <copyinstr+0x34>
  int got_null = 0;
    80001800:	4781                	li	a5,0
  if(got_null){
    80001802:	0017b793          	seqz	a5,a5
    80001806:	40f00533          	neg	a0,a5
}
    8000180a:	8082                	ret

000000008000180c <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    8000180c:	7139                	addi	sp,sp,-64
    8000180e:	fc06                	sd	ra,56(sp)
    80001810:	f822                	sd	s0,48(sp)
    80001812:	f426                	sd	s1,40(sp)
    80001814:	f04a                	sd	s2,32(sp)
    80001816:	ec4e                	sd	s3,24(sp)
    80001818:	e852                	sd	s4,16(sp)
    8000181a:	e456                	sd	s5,8(sp)
    8000181c:	e05a                	sd	s6,0(sp)
    8000181e:	0080                	addi	s0,sp,64
    80001820:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001822:	00010497          	auipc	s1,0x10
    80001826:	eae48493          	addi	s1,s1,-338 # 800116d0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000182a:	8b26                	mv	s6,s1
    8000182c:	00006a97          	auipc	s5,0x6
    80001830:	7d4a8a93          	addi	s5,s5,2004 # 80008000 <etext>
    80001834:	04000937          	lui	s2,0x4000
    80001838:	197d                	addi	s2,s2,-1
    8000183a:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000183c:	00016a17          	auipc	s4,0x16
    80001840:	894a0a13          	addi	s4,s4,-1900 # 800170d0 <tickslock>
    char *pa = kalloc();
    80001844:	fffff097          	auipc	ra,0xfffff
    80001848:	28e080e7          	jalr	654(ra) # 80000ad2 <kalloc>
    8000184c:	862a                	mv	a2,a0
    if(pa == 0)
    8000184e:	c131                	beqz	a0,80001892 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80001850:	416485b3          	sub	a1,s1,s6
    80001854:	858d                	srai	a1,a1,0x3
    80001856:	000ab783          	ld	a5,0(s5)
    8000185a:	02f585b3          	mul	a1,a1,a5
    8000185e:	2585                	addiw	a1,a1,1
    80001860:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001864:	4719                	li	a4,6
    80001866:	6685                	lui	a3,0x1
    80001868:	40b905b3          	sub	a1,s2,a1
    8000186c:	854e                	mv	a0,s3
    8000186e:	00000097          	auipc	ra,0x0
    80001872:	8ae080e7          	jalr	-1874(ra) # 8000111c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001876:	16848493          	addi	s1,s1,360
    8000187a:	fd4495e3          	bne	s1,s4,80001844 <proc_mapstacks+0x38>
  }
}
    8000187e:	70e2                	ld	ra,56(sp)
    80001880:	7442                	ld	s0,48(sp)
    80001882:	74a2                	ld	s1,40(sp)
    80001884:	7902                	ld	s2,32(sp)
    80001886:	69e2                	ld	s3,24(sp)
    80001888:	6a42                	ld	s4,16(sp)
    8000188a:	6aa2                	ld	s5,8(sp)
    8000188c:	6b02                	ld	s6,0(sp)
    8000188e:	6121                	addi	sp,sp,64
    80001890:	8082                	ret
      panic("kalloc");
    80001892:	00007517          	auipc	a0,0x7
    80001896:	92e50513          	addi	a0,a0,-1746 # 800081c0 <digits+0x180>
    8000189a:	fffff097          	auipc	ra,0xfffff
    8000189e:	c90080e7          	jalr	-880(ra) # 8000052a <panic>

00000000800018a2 <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    800018a2:	7139                	addi	sp,sp,-64
    800018a4:	fc06                	sd	ra,56(sp)
    800018a6:	f822                	sd	s0,48(sp)
    800018a8:	f426                	sd	s1,40(sp)
    800018aa:	f04a                	sd	s2,32(sp)
    800018ac:	ec4e                	sd	s3,24(sp)
    800018ae:	e852                	sd	s4,16(sp)
    800018b0:	e456                	sd	s5,8(sp)
    800018b2:	e05a                	sd	s6,0(sp)
    800018b4:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800018b6:	00007597          	auipc	a1,0x7
    800018ba:	91258593          	addi	a1,a1,-1774 # 800081c8 <digits+0x188>
    800018be:	00010517          	auipc	a0,0x10
    800018c2:	9e250513          	addi	a0,a0,-1566 # 800112a0 <pid_lock>
    800018c6:	fffff097          	auipc	ra,0xfffff
    800018ca:	26c080e7          	jalr	620(ra) # 80000b32 <initlock>
  initlock(&wait_lock, "wait_lock");
    800018ce:	00007597          	auipc	a1,0x7
    800018d2:	90258593          	addi	a1,a1,-1790 # 800081d0 <digits+0x190>
    800018d6:	00010517          	auipc	a0,0x10
    800018da:	9e250513          	addi	a0,a0,-1566 # 800112b8 <wait_lock>
    800018de:	fffff097          	auipc	ra,0xfffff
    800018e2:	254080e7          	jalr	596(ra) # 80000b32 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018e6:	00010497          	auipc	s1,0x10
    800018ea:	dea48493          	addi	s1,s1,-534 # 800116d0 <proc>
      initlock(&p->lock, "proc");
    800018ee:	00007b17          	auipc	s6,0x7
    800018f2:	8f2b0b13          	addi	s6,s6,-1806 # 800081e0 <digits+0x1a0>
      p->kstack = KSTACK((int) (p - proc));
    800018f6:	8aa6                	mv	s5,s1
    800018f8:	00006a17          	auipc	s4,0x6
    800018fc:	708a0a13          	addi	s4,s4,1800 # 80008000 <etext>
    80001900:	04000937          	lui	s2,0x4000
    80001904:	197d                	addi	s2,s2,-1
    80001906:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001908:	00015997          	auipc	s3,0x15
    8000190c:	7c898993          	addi	s3,s3,1992 # 800170d0 <tickslock>
      initlock(&p->lock, "proc");
    80001910:	85da                	mv	a1,s6
    80001912:	8526                	mv	a0,s1
    80001914:	fffff097          	auipc	ra,0xfffff
    80001918:	21e080e7          	jalr	542(ra) # 80000b32 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000191c:	415487b3          	sub	a5,s1,s5
    80001920:	878d                	srai	a5,a5,0x3
    80001922:	000a3703          	ld	a4,0(s4)
    80001926:	02e787b3          	mul	a5,a5,a4
    8000192a:	2785                	addiw	a5,a5,1
    8000192c:	00d7979b          	slliw	a5,a5,0xd
    80001930:	40f907b3          	sub	a5,s2,a5
    80001934:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001936:	16848493          	addi	s1,s1,360
    8000193a:	fd349be3          	bne	s1,s3,80001910 <procinit+0x6e>
  }
}
    8000193e:	70e2                	ld	ra,56(sp)
    80001940:	7442                	ld	s0,48(sp)
    80001942:	74a2                	ld	s1,40(sp)
    80001944:	7902                	ld	s2,32(sp)
    80001946:	69e2                	ld	s3,24(sp)
    80001948:	6a42                	ld	s4,16(sp)
    8000194a:	6aa2                	ld	s5,8(sp)
    8000194c:	6b02                	ld	s6,0(sp)
    8000194e:	6121                	addi	sp,sp,64
    80001950:	8082                	ret

0000000080001952 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001952:	1141                	addi	sp,sp,-16
    80001954:	e422                	sd	s0,8(sp)
    80001956:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001958:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000195a:	2501                	sext.w	a0,a0
    8000195c:	6422                	ld	s0,8(sp)
    8000195e:	0141                	addi	sp,sp,16
    80001960:	8082                	ret

0000000080001962 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    80001962:	1141                	addi	sp,sp,-16
    80001964:	e422                	sd	s0,8(sp)
    80001966:	0800                	addi	s0,sp,16
    80001968:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000196a:	2781                	sext.w	a5,a5
    8000196c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000196e:	00010517          	auipc	a0,0x10
    80001972:	96250513          	addi	a0,a0,-1694 # 800112d0 <cpus>
    80001976:	953e                	add	a0,a0,a5
    80001978:	6422                	ld	s0,8(sp)
    8000197a:	0141                	addi	sp,sp,16
    8000197c:	8082                	ret

000000008000197e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    8000197e:	1101                	addi	sp,sp,-32
    80001980:	ec06                	sd	ra,24(sp)
    80001982:	e822                	sd	s0,16(sp)
    80001984:	e426                	sd	s1,8(sp)
    80001986:	1000                	addi	s0,sp,32
  push_off();
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	1ee080e7          	jalr	494(ra) # 80000b76 <push_off>
    80001990:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001992:	2781                	sext.w	a5,a5
    80001994:	079e                	slli	a5,a5,0x7
    80001996:	00010717          	auipc	a4,0x10
    8000199a:	90a70713          	addi	a4,a4,-1782 # 800112a0 <pid_lock>
    8000199e:	97ba                	add	a5,a5,a4
    800019a0:	7b84                	ld	s1,48(a5)
  pop_off();
    800019a2:	fffff097          	auipc	ra,0xfffff
    800019a6:	274080e7          	jalr	628(ra) # 80000c16 <pop_off>
  return p;
}
    800019aa:	8526                	mv	a0,s1
    800019ac:	60e2                	ld	ra,24(sp)
    800019ae:	6442                	ld	s0,16(sp)
    800019b0:	64a2                	ld	s1,8(sp)
    800019b2:	6105                	addi	sp,sp,32
    800019b4:	8082                	ret

00000000800019b6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800019b6:	1141                	addi	sp,sp,-16
    800019b8:	e406                	sd	ra,8(sp)
    800019ba:	e022                	sd	s0,0(sp)
    800019bc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800019be:	00000097          	auipc	ra,0x0
    800019c2:	fc0080e7          	jalr	-64(ra) # 8000197e <myproc>
    800019c6:	fffff097          	auipc	ra,0xfffff
    800019ca:	2b0080e7          	jalr	688(ra) # 80000c76 <release>

  if (first) {
    800019ce:	00007797          	auipc	a5,0x7
    800019d2:	fe27a783          	lw	a5,-30(a5) # 800089b0 <first.1>
    800019d6:	eb89                	bnez	a5,800019e8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800019d8:	00001097          	auipc	ra,0x1
    800019dc:	c82080e7          	jalr	-894(ra) # 8000265a <usertrapret>
}
    800019e0:	60a2                	ld	ra,8(sp)
    800019e2:	6402                	ld	s0,0(sp)
    800019e4:	0141                	addi	sp,sp,16
    800019e6:	8082                	ret
    first = 0;
    800019e8:	00007797          	auipc	a5,0x7
    800019ec:	fc07a423          	sw	zero,-56(a5) # 800089b0 <first.1>
    fsinit(ROOTDEV);
    800019f0:	4505                	li	a0,1
    800019f2:	00002097          	auipc	ra,0x2
    800019f6:	ab0080e7          	jalr	-1360(ra) # 800034a2 <fsinit>
    800019fa:	bff9                	j	800019d8 <forkret+0x22>

00000000800019fc <allocpid>:
allocpid() {
    800019fc:	1101                	addi	sp,sp,-32
    800019fe:	ec06                	sd	ra,24(sp)
    80001a00:	e822                	sd	s0,16(sp)
    80001a02:	e426                	sd	s1,8(sp)
    80001a04:	e04a                	sd	s2,0(sp)
    80001a06:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a08:	00010917          	auipc	s2,0x10
    80001a0c:	89890913          	addi	s2,s2,-1896 # 800112a0 <pid_lock>
    80001a10:	854a                	mv	a0,s2
    80001a12:	fffff097          	auipc	ra,0xfffff
    80001a16:	1b0080e7          	jalr	432(ra) # 80000bc2 <acquire>
  pid = nextpid;
    80001a1a:	00007797          	auipc	a5,0x7
    80001a1e:	f9a78793          	addi	a5,a5,-102 # 800089b4 <nextpid>
    80001a22:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a24:	0014871b          	addiw	a4,s1,1
    80001a28:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	fffff097          	auipc	ra,0xfffff
    80001a30:	24a080e7          	jalr	586(ra) # 80000c76 <release>
}
    80001a34:	8526                	mv	a0,s1
    80001a36:	60e2                	ld	ra,24(sp)
    80001a38:	6442                	ld	s0,16(sp)
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	6902                	ld	s2,0(sp)
    80001a3e:	6105                	addi	sp,sp,32
    80001a40:	8082                	ret

0000000080001a42 <proc_pagetable>:
{
    80001a42:	1101                	addi	sp,sp,-32
    80001a44:	ec06                	sd	ra,24(sp)
    80001a46:	e822                	sd	s0,16(sp)
    80001a48:	e426                	sd	s1,8(sp)
    80001a4a:	e04a                	sd	s2,0(sp)
    80001a4c:	1000                	addi	s0,sp,32
    80001a4e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001a50:	00000097          	auipc	ra,0x0
    80001a54:	8b6080e7          	jalr	-1866(ra) # 80001306 <uvmcreate>
    80001a58:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001a5a:	c121                	beqz	a0,80001a9a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001a5c:	4729                	li	a4,10
    80001a5e:	00005697          	auipc	a3,0x5
    80001a62:	5a268693          	addi	a3,a3,1442 # 80007000 <_trampoline>
    80001a66:	6605                	lui	a2,0x1
    80001a68:	040005b7          	lui	a1,0x4000
    80001a6c:	15fd                	addi	a1,a1,-1
    80001a6e:	05b2                	slli	a1,a1,0xc
    80001a70:	fffff097          	auipc	ra,0xfffff
    80001a74:	61e080e7          	jalr	1566(ra) # 8000108e <mappages>
    80001a78:	02054863          	bltz	a0,80001aa8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001a7c:	4719                	li	a4,6
    80001a7e:	05893683          	ld	a3,88(s2)
    80001a82:	6605                	lui	a2,0x1
    80001a84:	020005b7          	lui	a1,0x2000
    80001a88:	15fd                	addi	a1,a1,-1
    80001a8a:	05b6                	slli	a1,a1,0xd
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	600080e7          	jalr	1536(ra) # 8000108e <mappages>
    80001a96:	02054163          	bltz	a0,80001ab8 <proc_pagetable+0x76>
}
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	60e2                	ld	ra,24(sp)
    80001a9e:	6442                	ld	s0,16(sp)
    80001aa0:	64a2                	ld	s1,8(sp)
    80001aa2:	6902                	ld	s2,0(sp)
    80001aa4:	6105                	addi	sp,sp,32
    80001aa6:	8082                	ret
    uvmfree(pagetable, 0);
    80001aa8:	4581                	li	a1,0
    80001aaa:	8526                	mv	a0,s1
    80001aac:	00000097          	auipc	ra,0x0
    80001ab0:	a56080e7          	jalr	-1450(ra) # 80001502 <uvmfree>
    return 0;
    80001ab4:	4481                	li	s1,0
    80001ab6:	b7d5                	j	80001a9a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ab8:	4681                	li	a3,0
    80001aba:	4605                	li	a2,1
    80001abc:	040005b7          	lui	a1,0x4000
    80001ac0:	15fd                	addi	a1,a1,-1
    80001ac2:	05b2                	slli	a1,a1,0xc
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	77c080e7          	jalr	1916(ra) # 80001242 <uvmunmap>
    uvmfree(pagetable, 0);
    80001ace:	4581                	li	a1,0
    80001ad0:	8526                	mv	a0,s1
    80001ad2:	00000097          	auipc	ra,0x0
    80001ad6:	a30080e7          	jalr	-1488(ra) # 80001502 <uvmfree>
    return 0;
    80001ada:	4481                	li	s1,0
    80001adc:	bf7d                	j	80001a9a <proc_pagetable+0x58>

0000000080001ade <proc_freepagetable>:
{
    80001ade:	1101                	addi	sp,sp,-32
    80001ae0:	ec06                	sd	ra,24(sp)
    80001ae2:	e822                	sd	s0,16(sp)
    80001ae4:	e426                	sd	s1,8(sp)
    80001ae6:	e04a                	sd	s2,0(sp)
    80001ae8:	1000                	addi	s0,sp,32
    80001aea:	84aa                	mv	s1,a0
    80001aec:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001aee:	4681                	li	a3,0
    80001af0:	4605                	li	a2,1
    80001af2:	040005b7          	lui	a1,0x4000
    80001af6:	15fd                	addi	a1,a1,-1
    80001af8:	05b2                	slli	a1,a1,0xc
    80001afa:	fffff097          	auipc	ra,0xfffff
    80001afe:	748080e7          	jalr	1864(ra) # 80001242 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b02:	4681                	li	a3,0
    80001b04:	4605                	li	a2,1
    80001b06:	020005b7          	lui	a1,0x2000
    80001b0a:	15fd                	addi	a1,a1,-1
    80001b0c:	05b6                	slli	a1,a1,0xd
    80001b0e:	8526                	mv	a0,s1
    80001b10:	fffff097          	auipc	ra,0xfffff
    80001b14:	732080e7          	jalr	1842(ra) # 80001242 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b18:	85ca                	mv	a1,s2
    80001b1a:	8526                	mv	a0,s1
    80001b1c:	00000097          	auipc	ra,0x0
    80001b20:	9e6080e7          	jalr	-1562(ra) # 80001502 <uvmfree>
}
    80001b24:	60e2                	ld	ra,24(sp)
    80001b26:	6442                	ld	s0,16(sp)
    80001b28:	64a2                	ld	s1,8(sp)
    80001b2a:	6902                	ld	s2,0(sp)
    80001b2c:	6105                	addi	sp,sp,32
    80001b2e:	8082                	ret

0000000080001b30 <freeproc>:
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	1000                	addi	s0,sp,32
    80001b3a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b3c:	6d28                	ld	a0,88(a0)
    80001b3e:	c509                	beqz	a0,80001b48 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	e96080e7          	jalr	-362(ra) # 800009d6 <kfree>
  p->trapframe = 0;
    80001b48:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001b4c:	68a8                	ld	a0,80(s1)
    80001b4e:	c511                	beqz	a0,80001b5a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001b50:	64ac                	ld	a1,72(s1)
    80001b52:	00000097          	auipc	ra,0x0
    80001b56:	f8c080e7          	jalr	-116(ra) # 80001ade <proc_freepagetable>
  p->pagetable = 0;
    80001b5a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001b5e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001b62:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001b66:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001b6a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001b6e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001b72:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001b76:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001b7a:	0004ac23          	sw	zero,24(s1)
}
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6105                	addi	sp,sp,32
    80001b86:	8082                	ret

0000000080001b88 <allocproc>:
{
    80001b88:	1101                	addi	sp,sp,-32
    80001b8a:	ec06                	sd	ra,24(sp)
    80001b8c:	e822                	sd	s0,16(sp)
    80001b8e:	e426                	sd	s1,8(sp)
    80001b90:	e04a                	sd	s2,0(sp)
    80001b92:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b94:	00010497          	auipc	s1,0x10
    80001b98:	b3c48493          	addi	s1,s1,-1220 # 800116d0 <proc>
    80001b9c:	00015917          	auipc	s2,0x15
    80001ba0:	53490913          	addi	s2,s2,1332 # 800170d0 <tickslock>
    acquire(&p->lock);
    80001ba4:	8526                	mv	a0,s1
    80001ba6:	fffff097          	auipc	ra,0xfffff
    80001baa:	01c080e7          	jalr	28(ra) # 80000bc2 <acquire>
    if(p->state == UNUSED) {
    80001bae:	4c9c                	lw	a5,24(s1)
    80001bb0:	cf81                	beqz	a5,80001bc8 <allocproc+0x40>
      release(&p->lock);
    80001bb2:	8526                	mv	a0,s1
    80001bb4:	fffff097          	auipc	ra,0xfffff
    80001bb8:	0c2080e7          	jalr	194(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bbc:	16848493          	addi	s1,s1,360
    80001bc0:	ff2492e3          	bne	s1,s2,80001ba4 <allocproc+0x1c>
  return 0;
    80001bc4:	4481                	li	s1,0
    80001bc6:	a889                	j	80001c18 <allocproc+0x90>
  p->pid = allocpid();
    80001bc8:	00000097          	auipc	ra,0x0
    80001bcc:	e34080e7          	jalr	-460(ra) # 800019fc <allocpid>
    80001bd0:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001bd2:	4785                	li	a5,1
    80001bd4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001bd6:	fffff097          	auipc	ra,0xfffff
    80001bda:	efc080e7          	jalr	-260(ra) # 80000ad2 <kalloc>
    80001bde:	892a                	mv	s2,a0
    80001be0:	eca8                	sd	a0,88(s1)
    80001be2:	c131                	beqz	a0,80001c26 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    80001be4:	8526                	mv	a0,s1
    80001be6:	00000097          	auipc	ra,0x0
    80001bea:	e5c080e7          	jalr	-420(ra) # 80001a42 <proc_pagetable>
    80001bee:	892a                	mv	s2,a0
    80001bf0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001bf2:	c531                	beqz	a0,80001c3e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001bf4:	07000613          	li	a2,112
    80001bf8:	4581                	li	a1,0
    80001bfa:	06048513          	addi	a0,s1,96
    80001bfe:	fffff097          	auipc	ra,0xfffff
    80001c02:	0c0080e7          	jalr	192(ra) # 80000cbe <memset>
  p->context.ra = (uint64)forkret;
    80001c06:	00000797          	auipc	a5,0x0
    80001c0a:	db078793          	addi	a5,a5,-592 # 800019b6 <forkret>
    80001c0e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c10:	60bc                	ld	a5,64(s1)
    80001c12:	6705                	lui	a4,0x1
    80001c14:	97ba                	add	a5,a5,a4
    80001c16:	f4bc                	sd	a5,104(s1)
}
    80001c18:	8526                	mv	a0,s1
    80001c1a:	60e2                	ld	ra,24(sp)
    80001c1c:	6442                	ld	s0,16(sp)
    80001c1e:	64a2                	ld	s1,8(sp)
    80001c20:	6902                	ld	s2,0(sp)
    80001c22:	6105                	addi	sp,sp,32
    80001c24:	8082                	ret
    freeproc(p);
    80001c26:	8526                	mv	a0,s1
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	f08080e7          	jalr	-248(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001c30:	8526                	mv	a0,s1
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	044080e7          	jalr	68(ra) # 80000c76 <release>
    return 0;
    80001c3a:	84ca                	mv	s1,s2
    80001c3c:	bff1                	j	80001c18 <allocproc+0x90>
    freeproc(p);
    80001c3e:	8526                	mv	a0,s1
    80001c40:	00000097          	auipc	ra,0x0
    80001c44:	ef0080e7          	jalr	-272(ra) # 80001b30 <freeproc>
    release(&p->lock);
    80001c48:	8526                	mv	a0,s1
    80001c4a:	fffff097          	auipc	ra,0xfffff
    80001c4e:	02c080e7          	jalr	44(ra) # 80000c76 <release>
    return 0;
    80001c52:	84ca                	mv	s1,s2
    80001c54:	b7d1                	j	80001c18 <allocproc+0x90>

0000000080001c56 <userinit>:
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c60:	00000097          	auipc	ra,0x0
    80001c64:	f28080e7          	jalr	-216(ra) # 80001b88 <allocproc>
    80001c68:	84aa                	mv	s1,a0
  initproc = p;
    80001c6a:	00007797          	auipc	a5,0x7
    80001c6e:	3aa7bf23          	sd	a0,958(a5) # 80009028 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001c72:	03400613          	li	a2,52
    80001c76:	00007597          	auipc	a1,0x7
    80001c7a:	d4a58593          	addi	a1,a1,-694 # 800089c0 <initcode>
    80001c7e:	6928                	ld	a0,80(a0)
    80001c80:	fffff097          	auipc	ra,0xfffff
    80001c84:	6b4080e7          	jalr	1716(ra) # 80001334 <uvminit>
  p->sz = PGSIZE;
    80001c88:	6785                	lui	a5,0x1
    80001c8a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001c8c:	6cb8                	ld	a4,88(s1)
    80001c8e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001c92:	6cb8                	ld	a4,88(s1)
    80001c94:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001c96:	4641                	li	a2,16
    80001c98:	00006597          	auipc	a1,0x6
    80001c9c:	55058593          	addi	a1,a1,1360 # 800081e8 <digits+0x1a8>
    80001ca0:	15848513          	addi	a0,s1,344
    80001ca4:	fffff097          	auipc	ra,0xfffff
    80001ca8:	16c080e7          	jalr	364(ra) # 80000e10 <safestrcpy>
  p->cwd = namei("/");
    80001cac:	00006517          	auipc	a0,0x6
    80001cb0:	54c50513          	addi	a0,a0,1356 # 800081f8 <digits+0x1b8>
    80001cb4:	00002097          	auipc	ra,0x2
    80001cb8:	21c080e7          	jalr	540(ra) # 80003ed0 <namei>
    80001cbc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001cc0:	478d                	li	a5,3
    80001cc2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001cc4:	8526                	mv	a0,s1
    80001cc6:	fffff097          	auipc	ra,0xfffff
    80001cca:	fb0080e7          	jalr	-80(ra) # 80000c76 <release>
}
    80001cce:	60e2                	ld	ra,24(sp)
    80001cd0:	6442                	ld	s0,16(sp)
    80001cd2:	64a2                	ld	s1,8(sp)
    80001cd4:	6105                	addi	sp,sp,32
    80001cd6:	8082                	ret

0000000080001cd8 <growproc>:
{
    80001cd8:	1101                	addi	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	e04a                	sd	s2,0(sp)
    80001ce2:	1000                	addi	s0,sp,32
    80001ce4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ce6:	00000097          	auipc	ra,0x0
    80001cea:	c98080e7          	jalr	-872(ra) # 8000197e <myproc>
    80001cee:	892a                	mv	s2,a0
  sz = p->sz;
    80001cf0:	652c                	ld	a1,72(a0)
    80001cf2:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001cf6:	00904f63          	bgtz	s1,80001d14 <growproc+0x3c>
  } else if(n < 0){
    80001cfa:	0204cc63          	bltz	s1,80001d32 <growproc+0x5a>
  p->sz = sz;
    80001cfe:	1602                	slli	a2,a2,0x20
    80001d00:	9201                	srli	a2,a2,0x20
    80001d02:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d06:	4501                	li	a0,0
}
    80001d08:	60e2                	ld	ra,24(sp)
    80001d0a:	6442                	ld	s0,16(sp)
    80001d0c:	64a2                	ld	s1,8(sp)
    80001d0e:	6902                	ld	s2,0(sp)
    80001d10:	6105                	addi	sp,sp,32
    80001d12:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d14:	9e25                	addw	a2,a2,s1
    80001d16:	1602                	slli	a2,a2,0x20
    80001d18:	9201                	srli	a2,a2,0x20
    80001d1a:	1582                	slli	a1,a1,0x20
    80001d1c:	9181                	srli	a1,a1,0x20
    80001d1e:	6928                	ld	a0,80(a0)
    80001d20:	fffff097          	auipc	ra,0xfffff
    80001d24:	6ce080e7          	jalr	1742(ra) # 800013ee <uvmalloc>
    80001d28:	0005061b          	sext.w	a2,a0
    80001d2c:	fa69                	bnez	a2,80001cfe <growproc+0x26>
      return -1;
    80001d2e:	557d                	li	a0,-1
    80001d30:	bfe1                	j	80001d08 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d32:	9e25                	addw	a2,a2,s1
    80001d34:	1602                	slli	a2,a2,0x20
    80001d36:	9201                	srli	a2,a2,0x20
    80001d38:	1582                	slli	a1,a1,0x20
    80001d3a:	9181                	srli	a1,a1,0x20
    80001d3c:	6928                	ld	a0,80(a0)
    80001d3e:	fffff097          	auipc	ra,0xfffff
    80001d42:	668080e7          	jalr	1640(ra) # 800013a6 <uvmdealloc>
    80001d46:	0005061b          	sext.w	a2,a0
    80001d4a:	bf55                	j	80001cfe <growproc+0x26>

0000000080001d4c <fork>:
{
    80001d4c:	7139                	addi	sp,sp,-64
    80001d4e:	fc06                	sd	ra,56(sp)
    80001d50:	f822                	sd	s0,48(sp)
    80001d52:	f426                	sd	s1,40(sp)
    80001d54:	f04a                	sd	s2,32(sp)
    80001d56:	ec4e                	sd	s3,24(sp)
    80001d58:	e852                	sd	s4,16(sp)
    80001d5a:	e456                	sd	s5,8(sp)
    80001d5c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d5e:	00000097          	auipc	ra,0x0
    80001d62:	c20080e7          	jalr	-992(ra) # 8000197e <myproc>
    80001d66:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001d68:	00000097          	auipc	ra,0x0
    80001d6c:	e20080e7          	jalr	-480(ra) # 80001b88 <allocproc>
    80001d70:	12050063          	beqz	a0,80001e90 <fork+0x144>
    80001d74:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001d76:	048ab603          	ld	a2,72(s5)
    80001d7a:	692c                	ld	a1,80(a0)
    80001d7c:	050ab503          	ld	a0,80(s5)
    80001d80:	fffff097          	auipc	ra,0xfffff
    80001d84:	7ba080e7          	jalr	1978(ra) # 8000153a <uvmcopy>
    80001d88:	04054c63          	bltz	a0,80001de0 <fork+0x94>
  np->sz = p->sz;
    80001d8c:	048ab783          	ld	a5,72(s5)
    80001d90:	04f9b423          	sd	a5,72(s3)
  np->mask_for_trace = p->mask_for_trace; 
    80001d94:	034aa783          	lw	a5,52(s5)
    80001d98:	02f9aa23          	sw	a5,52(s3)
  *(np->trapframe) = *(p->trapframe);
    80001d9c:	058ab683          	ld	a3,88(s5)
    80001da0:	87b6                	mv	a5,a3
    80001da2:	0589b703          	ld	a4,88(s3)
    80001da6:	12068693          	addi	a3,a3,288
    80001daa:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001dae:	6788                	ld	a0,8(a5)
    80001db0:	6b8c                	ld	a1,16(a5)
    80001db2:	6f90                	ld	a2,24(a5)
    80001db4:	01073023          	sd	a6,0(a4)
    80001db8:	e708                	sd	a0,8(a4)
    80001dba:	eb0c                	sd	a1,16(a4)
    80001dbc:	ef10                	sd	a2,24(a4)
    80001dbe:	02078793          	addi	a5,a5,32
    80001dc2:	02070713          	addi	a4,a4,32
    80001dc6:	fed792e3          	bne	a5,a3,80001daa <fork+0x5e>
  np->trapframe->a0 = 0;
    80001dca:	0589b783          	ld	a5,88(s3)
    80001dce:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001dd2:	0d0a8493          	addi	s1,s5,208
    80001dd6:	0d098913          	addi	s2,s3,208
    80001dda:	150a8a13          	addi	s4,s5,336
    80001dde:	a00d                	j	80001e00 <fork+0xb4>
    freeproc(np);
    80001de0:	854e                	mv	a0,s3
    80001de2:	00000097          	auipc	ra,0x0
    80001de6:	d4e080e7          	jalr	-690(ra) # 80001b30 <freeproc>
    release(&np->lock);
    80001dea:	854e                	mv	a0,s3
    80001dec:	fffff097          	auipc	ra,0xfffff
    80001df0:	e8a080e7          	jalr	-374(ra) # 80000c76 <release>
    return -1;
    80001df4:	597d                	li	s2,-1
    80001df6:	a059                	j	80001e7c <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    80001df8:	04a1                	addi	s1,s1,8
    80001dfa:	0921                	addi	s2,s2,8
    80001dfc:	01448b63          	beq	s1,s4,80001e12 <fork+0xc6>
    if(p->ofile[i])
    80001e00:	6088                	ld	a0,0(s1)
    80001e02:	d97d                	beqz	a0,80001df8 <fork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e04:	00002097          	auipc	ra,0x2
    80001e08:	766080e7          	jalr	1894(ra) # 8000456a <filedup>
    80001e0c:	00a93023          	sd	a0,0(s2)
    80001e10:	b7e5                	j	80001df8 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001e12:	150ab503          	ld	a0,336(s5)
    80001e16:	00002097          	auipc	ra,0x2
    80001e1a:	8c6080e7          	jalr	-1850(ra) # 800036dc <idup>
    80001e1e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e22:	4641                	li	a2,16
    80001e24:	158a8593          	addi	a1,s5,344
    80001e28:	15898513          	addi	a0,s3,344
    80001e2c:	fffff097          	auipc	ra,0xfffff
    80001e30:	fe4080e7          	jalr	-28(ra) # 80000e10 <safestrcpy>
  pid = np->pid;
    80001e34:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001e38:	854e                	mv	a0,s3
    80001e3a:	fffff097          	auipc	ra,0xfffff
    80001e3e:	e3c080e7          	jalr	-452(ra) # 80000c76 <release>
  acquire(&wait_lock);
    80001e42:	0000f497          	auipc	s1,0xf
    80001e46:	47648493          	addi	s1,s1,1142 # 800112b8 <wait_lock>
    80001e4a:	8526                	mv	a0,s1
    80001e4c:	fffff097          	auipc	ra,0xfffff
    80001e50:	d76080e7          	jalr	-650(ra) # 80000bc2 <acquire>
  np->parent = p;
    80001e54:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001e58:	8526                	mv	a0,s1
    80001e5a:	fffff097          	auipc	ra,0xfffff
    80001e5e:	e1c080e7          	jalr	-484(ra) # 80000c76 <release>
  acquire(&np->lock);
    80001e62:	854e                	mv	a0,s3
    80001e64:	fffff097          	auipc	ra,0xfffff
    80001e68:	d5e080e7          	jalr	-674(ra) # 80000bc2 <acquire>
  np->state = RUNNABLE;
    80001e6c:	478d                	li	a5,3
    80001e6e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001e72:	854e                	mv	a0,s3
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	e02080e7          	jalr	-510(ra) # 80000c76 <release>
}
    80001e7c:	854a                	mv	a0,s2
    80001e7e:	70e2                	ld	ra,56(sp)
    80001e80:	7442                	ld	s0,48(sp)
    80001e82:	74a2                	ld	s1,40(sp)
    80001e84:	7902                	ld	s2,32(sp)
    80001e86:	69e2                	ld	s3,24(sp)
    80001e88:	6a42                	ld	s4,16(sp)
    80001e8a:	6aa2                	ld	s5,8(sp)
    80001e8c:	6121                	addi	sp,sp,64
    80001e8e:	8082                	ret
    return -1;
    80001e90:	597d                	li	s2,-1
    80001e92:	b7ed                	j	80001e7c <fork+0x130>

0000000080001e94 <scheduler>:
{
    80001e94:	7139                	addi	sp,sp,-64
    80001e96:	fc06                	sd	ra,56(sp)
    80001e98:	f822                	sd	s0,48(sp)
    80001e9a:	f426                	sd	s1,40(sp)
    80001e9c:	f04a                	sd	s2,32(sp)
    80001e9e:	ec4e                	sd	s3,24(sp)
    80001ea0:	e852                	sd	s4,16(sp)
    80001ea2:	e456                	sd	s5,8(sp)
    80001ea4:	e05a                	sd	s6,0(sp)
    80001ea6:	0080                	addi	s0,sp,64
    80001ea8:	8792                	mv	a5,tp
  int id = r_tp();
    80001eaa:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001eac:	00779a93          	slli	s5,a5,0x7
    80001eb0:	0000f717          	auipc	a4,0xf
    80001eb4:	3f070713          	addi	a4,a4,1008 # 800112a0 <pid_lock>
    80001eb8:	9756                	add	a4,a4,s5
    80001eba:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001ebe:	0000f717          	auipc	a4,0xf
    80001ec2:	41a70713          	addi	a4,a4,1050 # 800112d8 <cpus+0x8>
    80001ec6:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001ec8:	498d                	li	s3,3
        p->state = RUNNING;
    80001eca:	4b11                	li	s6,4
        c->proc = p;
    80001ecc:	079e                	slli	a5,a5,0x7
    80001ece:	0000fa17          	auipc	s4,0xf
    80001ed2:	3d2a0a13          	addi	s4,s4,978 # 800112a0 <pid_lock>
    80001ed6:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001ed8:	00015917          	auipc	s2,0x15
    80001edc:	1f890913          	addi	s2,s2,504 # 800170d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ee4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ee8:	10079073          	csrw	sstatus,a5
    80001eec:	0000f497          	auipc	s1,0xf
    80001ef0:	7e448493          	addi	s1,s1,2020 # 800116d0 <proc>
    80001ef4:	a811                	j	80001f08 <scheduler+0x74>
      release(&p->lock);
    80001ef6:	8526                	mv	a0,s1
    80001ef8:	fffff097          	auipc	ra,0xfffff
    80001efc:	d7e080e7          	jalr	-642(ra) # 80000c76 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f00:	16848493          	addi	s1,s1,360
    80001f04:	fd248ee3          	beq	s1,s2,80001ee0 <scheduler+0x4c>
      acquire(&p->lock);
    80001f08:	8526                	mv	a0,s1
    80001f0a:	fffff097          	auipc	ra,0xfffff
    80001f0e:	cb8080e7          	jalr	-840(ra) # 80000bc2 <acquire>
      if(p->state == RUNNABLE) {
    80001f12:	4c9c                	lw	a5,24(s1)
    80001f14:	ff3791e3          	bne	a5,s3,80001ef6 <scheduler+0x62>
        p->state = RUNNING;
    80001f18:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001f1c:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f20:	06048593          	addi	a1,s1,96
    80001f24:	8556                	mv	a0,s5
    80001f26:	00000097          	auipc	ra,0x0
    80001f2a:	68a080e7          	jalr	1674(ra) # 800025b0 <swtch>
        c->proc = 0;
    80001f2e:	020a3823          	sd	zero,48(s4)
    80001f32:	b7d1                	j	80001ef6 <scheduler+0x62>

0000000080001f34 <sched>:
{
    80001f34:	7179                	addi	sp,sp,-48
    80001f36:	f406                	sd	ra,40(sp)
    80001f38:	f022                	sd	s0,32(sp)
    80001f3a:	ec26                	sd	s1,24(sp)
    80001f3c:	e84a                	sd	s2,16(sp)
    80001f3e:	e44e                	sd	s3,8(sp)
    80001f40:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001f42:	00000097          	auipc	ra,0x0
    80001f46:	a3c080e7          	jalr	-1476(ra) # 8000197e <myproc>
    80001f4a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	bfc080e7          	jalr	-1028(ra) # 80000b48 <holding>
    80001f54:	c93d                	beqz	a0,80001fca <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f56:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001f58:	2781                	sext.w	a5,a5
    80001f5a:	079e                	slli	a5,a5,0x7
    80001f5c:	0000f717          	auipc	a4,0xf
    80001f60:	34470713          	addi	a4,a4,836 # 800112a0 <pid_lock>
    80001f64:	97ba                	add	a5,a5,a4
    80001f66:	0a87a703          	lw	a4,168(a5)
    80001f6a:	4785                	li	a5,1
    80001f6c:	06f71763          	bne	a4,a5,80001fda <sched+0xa6>
  if(p->state == RUNNING)
    80001f70:	4c98                	lw	a4,24(s1)
    80001f72:	4791                	li	a5,4
    80001f74:	06f70b63          	beq	a4,a5,80001fea <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001f7e:	efb5                	bnez	a5,80001ffa <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f80:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f82:	0000f917          	auipc	s2,0xf
    80001f86:	31e90913          	addi	s2,s2,798 # 800112a0 <pid_lock>
    80001f8a:	2781                	sext.w	a5,a5
    80001f8c:	079e                	slli	a5,a5,0x7
    80001f8e:	97ca                	add	a5,a5,s2
    80001f90:	0ac7a983          	lw	s3,172(a5)
    80001f94:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f96:	2781                	sext.w	a5,a5
    80001f98:	079e                	slli	a5,a5,0x7
    80001f9a:	0000f597          	auipc	a1,0xf
    80001f9e:	33e58593          	addi	a1,a1,830 # 800112d8 <cpus+0x8>
    80001fa2:	95be                	add	a1,a1,a5
    80001fa4:	06048513          	addi	a0,s1,96
    80001fa8:	00000097          	auipc	ra,0x0
    80001fac:	608080e7          	jalr	1544(ra) # 800025b0 <swtch>
    80001fb0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001fb2:	2781                	sext.w	a5,a5
    80001fb4:	079e                	slli	a5,a5,0x7
    80001fb6:	97ca                	add	a5,a5,s2
    80001fb8:	0b37a623          	sw	s3,172(a5)
}
    80001fbc:	70a2                	ld	ra,40(sp)
    80001fbe:	7402                	ld	s0,32(sp)
    80001fc0:	64e2                	ld	s1,24(sp)
    80001fc2:	6942                	ld	s2,16(sp)
    80001fc4:	69a2                	ld	s3,8(sp)
    80001fc6:	6145                	addi	sp,sp,48
    80001fc8:	8082                	ret
    panic("sched p->lock");
    80001fca:	00006517          	auipc	a0,0x6
    80001fce:	23650513          	addi	a0,a0,566 # 80008200 <digits+0x1c0>
    80001fd2:	ffffe097          	auipc	ra,0xffffe
    80001fd6:	558080e7          	jalr	1368(ra) # 8000052a <panic>
    panic("sched locks");
    80001fda:	00006517          	auipc	a0,0x6
    80001fde:	23650513          	addi	a0,a0,566 # 80008210 <digits+0x1d0>
    80001fe2:	ffffe097          	auipc	ra,0xffffe
    80001fe6:	548080e7          	jalr	1352(ra) # 8000052a <panic>
    panic("sched running");
    80001fea:	00006517          	auipc	a0,0x6
    80001fee:	23650513          	addi	a0,a0,566 # 80008220 <digits+0x1e0>
    80001ff2:	ffffe097          	auipc	ra,0xffffe
    80001ff6:	538080e7          	jalr	1336(ra) # 8000052a <panic>
    panic("sched interruptible");
    80001ffa:	00006517          	auipc	a0,0x6
    80001ffe:	23650513          	addi	a0,a0,566 # 80008230 <digits+0x1f0>
    80002002:	ffffe097          	auipc	ra,0xffffe
    80002006:	528080e7          	jalr	1320(ra) # 8000052a <panic>

000000008000200a <yield>:
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002014:	00000097          	auipc	ra,0x0
    80002018:	96a080e7          	jalr	-1686(ra) # 8000197e <myproc>
    8000201c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	ba4080e7          	jalr	-1116(ra) # 80000bc2 <acquire>
  p->state = RUNNABLE;
    80002026:	478d                	li	a5,3
    80002028:	cc9c                	sw	a5,24(s1)
  sched();
    8000202a:	00000097          	auipc	ra,0x0
    8000202e:	f0a080e7          	jalr	-246(ra) # 80001f34 <sched>
  release(&p->lock);
    80002032:	8526                	mv	a0,s1
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	c42080e7          	jalr	-958(ra) # 80000c76 <release>
}
    8000203c:	60e2                	ld	ra,24(sp)
    8000203e:	6442                	ld	s0,16(sp)
    80002040:	64a2                	ld	s1,8(sp)
    80002042:	6105                	addi	sp,sp,32
    80002044:	8082                	ret

0000000080002046 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002046:	7179                	addi	sp,sp,-48
    80002048:	f406                	sd	ra,40(sp)
    8000204a:	f022                	sd	s0,32(sp)
    8000204c:	ec26                	sd	s1,24(sp)
    8000204e:	e84a                	sd	s2,16(sp)
    80002050:	e44e                	sd	s3,8(sp)
    80002052:	1800                	addi	s0,sp,48
    80002054:	89aa                	mv	s3,a0
    80002056:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002058:	00000097          	auipc	ra,0x0
    8000205c:	926080e7          	jalr	-1754(ra) # 8000197e <myproc>
    80002060:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002062:	fffff097          	auipc	ra,0xfffff
    80002066:	b60080e7          	jalr	-1184(ra) # 80000bc2 <acquire>
  release(lk);
    8000206a:	854a                	mv	a0,s2
    8000206c:	fffff097          	auipc	ra,0xfffff
    80002070:	c0a080e7          	jalr	-1014(ra) # 80000c76 <release>

  // Go to sleep.
  p->chan = chan;
    80002074:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002078:	4789                	li	a5,2
    8000207a:	cc9c                	sw	a5,24(s1)

  sched();
    8000207c:	00000097          	auipc	ra,0x0
    80002080:	eb8080e7          	jalr	-328(ra) # 80001f34 <sched>

  // Tidy up.
  p->chan = 0;
    80002084:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002088:	8526                	mv	a0,s1
    8000208a:	fffff097          	auipc	ra,0xfffff
    8000208e:	bec080e7          	jalr	-1044(ra) # 80000c76 <release>
  acquire(lk);
    80002092:	854a                	mv	a0,s2
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	b2e080e7          	jalr	-1234(ra) # 80000bc2 <acquire>
}
    8000209c:	70a2                	ld	ra,40(sp)
    8000209e:	7402                	ld	s0,32(sp)
    800020a0:	64e2                	ld	s1,24(sp)
    800020a2:	6942                	ld	s2,16(sp)
    800020a4:	69a2                	ld	s3,8(sp)
    800020a6:	6145                	addi	sp,sp,48
    800020a8:	8082                	ret

00000000800020aa <wait>:
{
    800020aa:	715d                	addi	sp,sp,-80
    800020ac:	e486                	sd	ra,72(sp)
    800020ae:	e0a2                	sd	s0,64(sp)
    800020b0:	fc26                	sd	s1,56(sp)
    800020b2:	f84a                	sd	s2,48(sp)
    800020b4:	f44e                	sd	s3,40(sp)
    800020b6:	f052                	sd	s4,32(sp)
    800020b8:	ec56                	sd	s5,24(sp)
    800020ba:	e85a                	sd	s6,16(sp)
    800020bc:	e45e                	sd	s7,8(sp)
    800020be:	e062                	sd	s8,0(sp)
    800020c0:	0880                	addi	s0,sp,80
    800020c2:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800020c4:	00000097          	auipc	ra,0x0
    800020c8:	8ba080e7          	jalr	-1862(ra) # 8000197e <myproc>
    800020cc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800020ce:	0000f517          	auipc	a0,0xf
    800020d2:	1ea50513          	addi	a0,a0,490 # 800112b8 <wait_lock>
    800020d6:	fffff097          	auipc	ra,0xfffff
    800020da:	aec080e7          	jalr	-1300(ra) # 80000bc2 <acquire>
    havekids = 0;
    800020de:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800020e0:	4a15                	li	s4,5
        havekids = 1;
    800020e2:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800020e4:	00015997          	auipc	s3,0x15
    800020e8:	fec98993          	addi	s3,s3,-20 # 800170d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800020ec:	0000fc17          	auipc	s8,0xf
    800020f0:	1ccc0c13          	addi	s8,s8,460 # 800112b8 <wait_lock>
    havekids = 0;
    800020f4:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800020f6:	0000f497          	auipc	s1,0xf
    800020fa:	5da48493          	addi	s1,s1,1498 # 800116d0 <proc>
    800020fe:	a0bd                	j	8000216c <wait+0xc2>
          pid = np->pid;
    80002100:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    80002104:	000b0e63          	beqz	s6,80002120 <wait+0x76>
    80002108:	4691                	li	a3,4
    8000210a:	02c48613          	addi	a2,s1,44
    8000210e:	85da                	mv	a1,s6
    80002110:	05093503          	ld	a0,80(s2)
    80002114:	fffff097          	auipc	ra,0xfffff
    80002118:	52a080e7          	jalr	1322(ra) # 8000163e <copyout>
    8000211c:	02054563          	bltz	a0,80002146 <wait+0x9c>
          freeproc(np);
    80002120:	8526                	mv	a0,s1
    80002122:	00000097          	auipc	ra,0x0
    80002126:	a0e080e7          	jalr	-1522(ra) # 80001b30 <freeproc>
          release(&np->lock);
    8000212a:	8526                	mv	a0,s1
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	b4a080e7          	jalr	-1206(ra) # 80000c76 <release>
          release(&wait_lock);
    80002134:	0000f517          	auipc	a0,0xf
    80002138:	18450513          	addi	a0,a0,388 # 800112b8 <wait_lock>
    8000213c:	fffff097          	auipc	ra,0xfffff
    80002140:	b3a080e7          	jalr	-1222(ra) # 80000c76 <release>
          return pid;
    80002144:	a09d                	j	800021aa <wait+0x100>
            release(&np->lock);
    80002146:	8526                	mv	a0,s1
    80002148:	fffff097          	auipc	ra,0xfffff
    8000214c:	b2e080e7          	jalr	-1234(ra) # 80000c76 <release>
            release(&wait_lock);
    80002150:	0000f517          	auipc	a0,0xf
    80002154:	16850513          	addi	a0,a0,360 # 800112b8 <wait_lock>
    80002158:	fffff097          	auipc	ra,0xfffff
    8000215c:	b1e080e7          	jalr	-1250(ra) # 80000c76 <release>
            return -1;
    80002160:	59fd                	li	s3,-1
    80002162:	a0a1                	j	800021aa <wait+0x100>
    for(np = proc; np < &proc[NPROC]; np++){
    80002164:	16848493          	addi	s1,s1,360
    80002168:	03348463          	beq	s1,s3,80002190 <wait+0xe6>
      if(np->parent == p){
    8000216c:	7c9c                	ld	a5,56(s1)
    8000216e:	ff279be3          	bne	a5,s2,80002164 <wait+0xba>
        acquire(&np->lock);
    80002172:	8526                	mv	a0,s1
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	a4e080e7          	jalr	-1458(ra) # 80000bc2 <acquire>
        if(np->state == ZOMBIE){
    8000217c:	4c9c                	lw	a5,24(s1)
    8000217e:	f94781e3          	beq	a5,s4,80002100 <wait+0x56>
        release(&np->lock);
    80002182:	8526                	mv	a0,s1
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	af2080e7          	jalr	-1294(ra) # 80000c76 <release>
        havekids = 1;
    8000218c:	8756                	mv	a4,s5
    8000218e:	bfd9                	j	80002164 <wait+0xba>
    if(!havekids || p->killed){
    80002190:	c701                	beqz	a4,80002198 <wait+0xee>
    80002192:	02892783          	lw	a5,40(s2)
    80002196:	c79d                	beqz	a5,800021c4 <wait+0x11a>
      release(&wait_lock);
    80002198:	0000f517          	auipc	a0,0xf
    8000219c:	12050513          	addi	a0,a0,288 # 800112b8 <wait_lock>
    800021a0:	fffff097          	auipc	ra,0xfffff
    800021a4:	ad6080e7          	jalr	-1322(ra) # 80000c76 <release>
      return -1;
    800021a8:	59fd                	li	s3,-1
}
    800021aa:	854e                	mv	a0,s3
    800021ac:	60a6                	ld	ra,72(sp)
    800021ae:	6406                	ld	s0,64(sp)
    800021b0:	74e2                	ld	s1,56(sp)
    800021b2:	7942                	ld	s2,48(sp)
    800021b4:	79a2                	ld	s3,40(sp)
    800021b6:	7a02                	ld	s4,32(sp)
    800021b8:	6ae2                	ld	s5,24(sp)
    800021ba:	6b42                	ld	s6,16(sp)
    800021bc:	6ba2                	ld	s7,8(sp)
    800021be:	6c02                	ld	s8,0(sp)
    800021c0:	6161                	addi	sp,sp,80
    800021c2:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800021c4:	85e2                	mv	a1,s8
    800021c6:	854a                	mv	a0,s2
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	e7e080e7          	jalr	-386(ra) # 80002046 <sleep>
    havekids = 0;
    800021d0:	b715                	j	800020f4 <wait+0x4a>

00000000800021d2 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800021d2:	7139                	addi	sp,sp,-64
    800021d4:	fc06                	sd	ra,56(sp)
    800021d6:	f822                	sd	s0,48(sp)
    800021d8:	f426                	sd	s1,40(sp)
    800021da:	f04a                	sd	s2,32(sp)
    800021dc:	ec4e                	sd	s3,24(sp)
    800021de:	e852                	sd	s4,16(sp)
    800021e0:	e456                	sd	s5,8(sp)
    800021e2:	0080                	addi	s0,sp,64
    800021e4:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800021e6:	0000f497          	auipc	s1,0xf
    800021ea:	4ea48493          	addi	s1,s1,1258 # 800116d0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800021ee:	4989                	li	s3,2
        p->state = RUNNABLE;
    800021f0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800021f2:	00015917          	auipc	s2,0x15
    800021f6:	ede90913          	addi	s2,s2,-290 # 800170d0 <tickslock>
    800021fa:	a811                	j	8000220e <wakeup+0x3c>
      }
      release(&p->lock);
    800021fc:	8526                	mv	a0,s1
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	a78080e7          	jalr	-1416(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002206:	16848493          	addi	s1,s1,360
    8000220a:	03248663          	beq	s1,s2,80002236 <wakeup+0x64>
    if(p != myproc()){
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	770080e7          	jalr	1904(ra) # 8000197e <myproc>
    80002216:	fea488e3          	beq	s1,a0,80002206 <wakeup+0x34>
      acquire(&p->lock);
    8000221a:	8526                	mv	a0,s1
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	9a6080e7          	jalr	-1626(ra) # 80000bc2 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002224:	4c9c                	lw	a5,24(s1)
    80002226:	fd379be3          	bne	a5,s3,800021fc <wakeup+0x2a>
    8000222a:	709c                	ld	a5,32(s1)
    8000222c:	fd4798e3          	bne	a5,s4,800021fc <wakeup+0x2a>
        p->state = RUNNABLE;
    80002230:	0154ac23          	sw	s5,24(s1)
    80002234:	b7e1                	j	800021fc <wakeup+0x2a>
    }
  }
}
    80002236:	70e2                	ld	ra,56(sp)
    80002238:	7442                	ld	s0,48(sp)
    8000223a:	74a2                	ld	s1,40(sp)
    8000223c:	7902                	ld	s2,32(sp)
    8000223e:	69e2                	ld	s3,24(sp)
    80002240:	6a42                	ld	s4,16(sp)
    80002242:	6aa2                	ld	s5,8(sp)
    80002244:	6121                	addi	sp,sp,64
    80002246:	8082                	ret

0000000080002248 <reparent>:
{
    80002248:	7179                	addi	sp,sp,-48
    8000224a:	f406                	sd	ra,40(sp)
    8000224c:	f022                	sd	s0,32(sp)
    8000224e:	ec26                	sd	s1,24(sp)
    80002250:	e84a                	sd	s2,16(sp)
    80002252:	e44e                	sd	s3,8(sp)
    80002254:	e052                	sd	s4,0(sp)
    80002256:	1800                	addi	s0,sp,48
    80002258:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000225a:	0000f497          	auipc	s1,0xf
    8000225e:	47648493          	addi	s1,s1,1142 # 800116d0 <proc>
      pp->parent = initproc;
    80002262:	00007a17          	auipc	s4,0x7
    80002266:	dc6a0a13          	addi	s4,s4,-570 # 80009028 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000226a:	00015997          	auipc	s3,0x15
    8000226e:	e6698993          	addi	s3,s3,-410 # 800170d0 <tickslock>
    80002272:	a029                	j	8000227c <reparent+0x34>
    80002274:	16848493          	addi	s1,s1,360
    80002278:	01348d63          	beq	s1,s3,80002292 <reparent+0x4a>
    if(pp->parent == p){
    8000227c:	7c9c                	ld	a5,56(s1)
    8000227e:	ff279be3          	bne	a5,s2,80002274 <reparent+0x2c>
      pp->parent = initproc;
    80002282:	000a3503          	ld	a0,0(s4)
    80002286:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	f4a080e7          	jalr	-182(ra) # 800021d2 <wakeup>
    80002290:	b7d5                	j	80002274 <reparent+0x2c>
}
    80002292:	70a2                	ld	ra,40(sp)
    80002294:	7402                	ld	s0,32(sp)
    80002296:	64e2                	ld	s1,24(sp)
    80002298:	6942                	ld	s2,16(sp)
    8000229a:	69a2                	ld	s3,8(sp)
    8000229c:	6a02                	ld	s4,0(sp)
    8000229e:	6145                	addi	sp,sp,48
    800022a0:	8082                	ret

00000000800022a2 <exit>:
{
    800022a2:	7179                	addi	sp,sp,-48
    800022a4:	f406                	sd	ra,40(sp)
    800022a6:	f022                	sd	s0,32(sp)
    800022a8:	ec26                	sd	s1,24(sp)
    800022aa:	e84a                	sd	s2,16(sp)
    800022ac:	e44e                	sd	s3,8(sp)
    800022ae:	e052                	sd	s4,0(sp)
    800022b0:	1800                	addi	s0,sp,48
    800022b2:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	6ca080e7          	jalr	1738(ra) # 8000197e <myproc>
    800022bc:	89aa                	mv	s3,a0
  if(p == initproc)
    800022be:	00007797          	auipc	a5,0x7
    800022c2:	d6a7b783          	ld	a5,-662(a5) # 80009028 <initproc>
    800022c6:	0d050493          	addi	s1,a0,208
    800022ca:	15050913          	addi	s2,a0,336
    800022ce:	02a79363          	bne	a5,a0,800022f4 <exit+0x52>
    panic("init exiting");
    800022d2:	00006517          	auipc	a0,0x6
    800022d6:	f7650513          	addi	a0,a0,-138 # 80008248 <digits+0x208>
    800022da:	ffffe097          	auipc	ra,0xffffe
    800022de:	250080e7          	jalr	592(ra) # 8000052a <panic>
      fileclose(f);
    800022e2:	00002097          	auipc	ra,0x2
    800022e6:	2da080e7          	jalr	730(ra) # 800045bc <fileclose>
      p->ofile[fd] = 0;
    800022ea:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800022ee:	04a1                	addi	s1,s1,8
    800022f0:	01248563          	beq	s1,s2,800022fa <exit+0x58>
    if(p->ofile[fd]){
    800022f4:	6088                	ld	a0,0(s1)
    800022f6:	f575                	bnez	a0,800022e2 <exit+0x40>
    800022f8:	bfdd                	j	800022ee <exit+0x4c>
  begin_op();
    800022fa:	00002097          	auipc	ra,0x2
    800022fe:	df6080e7          	jalr	-522(ra) # 800040f0 <begin_op>
  iput(p->cwd);
    80002302:	1509b503          	ld	a0,336(s3)
    80002306:	00001097          	auipc	ra,0x1
    8000230a:	5ce080e7          	jalr	1486(ra) # 800038d4 <iput>
  end_op();
    8000230e:	00002097          	auipc	ra,0x2
    80002312:	e62080e7          	jalr	-414(ra) # 80004170 <end_op>
  p->cwd = 0;
    80002316:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000231a:	0000f497          	auipc	s1,0xf
    8000231e:	f9e48493          	addi	s1,s1,-98 # 800112b8 <wait_lock>
    80002322:	8526                	mv	a0,s1
    80002324:	fffff097          	auipc	ra,0xfffff
    80002328:	89e080e7          	jalr	-1890(ra) # 80000bc2 <acquire>
  reparent(p);
    8000232c:	854e                	mv	a0,s3
    8000232e:	00000097          	auipc	ra,0x0
    80002332:	f1a080e7          	jalr	-230(ra) # 80002248 <reparent>
  wakeup(p->parent);
    80002336:	0389b503          	ld	a0,56(s3)
    8000233a:	00000097          	auipc	ra,0x0
    8000233e:	e98080e7          	jalr	-360(ra) # 800021d2 <wakeup>
  acquire(&p->lock);
    80002342:	854e                	mv	a0,s3
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	87e080e7          	jalr	-1922(ra) # 80000bc2 <acquire>
  p->xstate = status;
    8000234c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002350:	4795                	li	a5,5
    80002352:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002356:	8526                	mv	a0,s1
    80002358:	fffff097          	auipc	ra,0xfffff
    8000235c:	91e080e7          	jalr	-1762(ra) # 80000c76 <release>
  sched();
    80002360:	00000097          	auipc	ra,0x0
    80002364:	bd4080e7          	jalr	-1068(ra) # 80001f34 <sched>
  panic("zombie exit");
    80002368:	00006517          	auipc	a0,0x6
    8000236c:	ef050513          	addi	a0,a0,-272 # 80008258 <digits+0x218>
    80002370:	ffffe097          	auipc	ra,0xffffe
    80002374:	1ba080e7          	jalr	442(ra) # 8000052a <panic>

0000000080002378 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002378:	7179                	addi	sp,sp,-48
    8000237a:	f406                	sd	ra,40(sp)
    8000237c:	f022                	sd	s0,32(sp)
    8000237e:	ec26                	sd	s1,24(sp)
    80002380:	e84a                	sd	s2,16(sp)
    80002382:	e44e                	sd	s3,8(sp)
    80002384:	1800                	addi	s0,sp,48
    80002386:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002388:	0000f497          	auipc	s1,0xf
    8000238c:	34848493          	addi	s1,s1,840 # 800116d0 <proc>
    80002390:	00015997          	auipc	s3,0x15
    80002394:	d4098993          	addi	s3,s3,-704 # 800170d0 <tickslock>
    acquire(&p->lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	828080e7          	jalr	-2008(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    800023a2:	589c                	lw	a5,48(s1)
    800023a4:	01278d63          	beq	a5,s2,800023be <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800023a8:	8526                	mv	a0,s1
    800023aa:	fffff097          	auipc	ra,0xfffff
    800023ae:	8cc080e7          	jalr	-1844(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800023b2:	16848493          	addi	s1,s1,360
    800023b6:	ff3491e3          	bne	s1,s3,80002398 <kill+0x20>
  }
  return -1;
    800023ba:	557d                	li	a0,-1
    800023bc:	a829                	j	800023d6 <kill+0x5e>
      p->killed = 1;
    800023be:	4785                	li	a5,1
    800023c0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800023c2:	4c98                	lw	a4,24(s1)
    800023c4:	4789                	li	a5,2
    800023c6:	00f70f63          	beq	a4,a5,800023e4 <kill+0x6c>
      release(&p->lock);
    800023ca:	8526                	mv	a0,s1
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	8aa080e7          	jalr	-1878(ra) # 80000c76 <release>
      return 0;
    800023d4:	4501                	li	a0,0
}
    800023d6:	70a2                	ld	ra,40(sp)
    800023d8:	7402                	ld	s0,32(sp)
    800023da:	64e2                	ld	s1,24(sp)
    800023dc:	6942                	ld	s2,16(sp)
    800023de:	69a2                	ld	s3,8(sp)
    800023e0:	6145                	addi	sp,sp,48
    800023e2:	8082                	ret
        p->state = RUNNABLE;
    800023e4:	478d                	li	a5,3
    800023e6:	cc9c                	sw	a5,24(s1)
    800023e8:	b7cd                	j	800023ca <kill+0x52>

00000000800023ea <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800023ea:	7179                	addi	sp,sp,-48
    800023ec:	f406                	sd	ra,40(sp)
    800023ee:	f022                	sd	s0,32(sp)
    800023f0:	ec26                	sd	s1,24(sp)
    800023f2:	e84a                	sd	s2,16(sp)
    800023f4:	e44e                	sd	s3,8(sp)
    800023f6:	e052                	sd	s4,0(sp)
    800023f8:	1800                	addi	s0,sp,48
    800023fa:	84aa                	mv	s1,a0
    800023fc:	892e                	mv	s2,a1
    800023fe:	89b2                	mv	s3,a2
    80002400:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002402:	fffff097          	auipc	ra,0xfffff
    80002406:	57c080e7          	jalr	1404(ra) # 8000197e <myproc>
  if(user_dst){
    8000240a:	c08d                	beqz	s1,8000242c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000240c:	86d2                	mv	a3,s4
    8000240e:	864e                	mv	a2,s3
    80002410:	85ca                	mv	a1,s2
    80002412:	6928                	ld	a0,80(a0)
    80002414:	fffff097          	auipc	ra,0xfffff
    80002418:	22a080e7          	jalr	554(ra) # 8000163e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000241c:	70a2                	ld	ra,40(sp)
    8000241e:	7402                	ld	s0,32(sp)
    80002420:	64e2                	ld	s1,24(sp)
    80002422:	6942                	ld	s2,16(sp)
    80002424:	69a2                	ld	s3,8(sp)
    80002426:	6a02                	ld	s4,0(sp)
    80002428:	6145                	addi	sp,sp,48
    8000242a:	8082                	ret
    memmove((char *)dst, src, len);
    8000242c:	000a061b          	sext.w	a2,s4
    80002430:	85ce                	mv	a1,s3
    80002432:	854a                	mv	a0,s2
    80002434:	fffff097          	auipc	ra,0xfffff
    80002438:	8e6080e7          	jalr	-1818(ra) # 80000d1a <memmove>
    return 0;
    8000243c:	8526                	mv	a0,s1
    8000243e:	bff9                	j	8000241c <either_copyout+0x32>

0000000080002440 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002440:	7179                	addi	sp,sp,-48
    80002442:	f406                	sd	ra,40(sp)
    80002444:	f022                	sd	s0,32(sp)
    80002446:	ec26                	sd	s1,24(sp)
    80002448:	e84a                	sd	s2,16(sp)
    8000244a:	e44e                	sd	s3,8(sp)
    8000244c:	e052                	sd	s4,0(sp)
    8000244e:	1800                	addi	s0,sp,48
    80002450:	892a                	mv	s2,a0
    80002452:	84ae                	mv	s1,a1
    80002454:	89b2                	mv	s3,a2
    80002456:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002458:	fffff097          	auipc	ra,0xfffff
    8000245c:	526080e7          	jalr	1318(ra) # 8000197e <myproc>
  if(user_src){
    80002460:	c08d                	beqz	s1,80002482 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80002462:	86d2                	mv	a3,s4
    80002464:	864e                	mv	a2,s3
    80002466:	85ca                	mv	a1,s2
    80002468:	6928                	ld	a0,80(a0)
    8000246a:	fffff097          	auipc	ra,0xfffff
    8000246e:	260080e7          	jalr	608(ra) # 800016ca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002472:	70a2                	ld	ra,40(sp)
    80002474:	7402                	ld	s0,32(sp)
    80002476:	64e2                	ld	s1,24(sp)
    80002478:	6942                	ld	s2,16(sp)
    8000247a:	69a2                	ld	s3,8(sp)
    8000247c:	6a02                	ld	s4,0(sp)
    8000247e:	6145                	addi	sp,sp,48
    80002480:	8082                	ret
    memmove(dst, (char*)src, len);
    80002482:	000a061b          	sext.w	a2,s4
    80002486:	85ce                	mv	a1,s3
    80002488:	854a                	mv	a0,s2
    8000248a:	fffff097          	auipc	ra,0xfffff
    8000248e:	890080e7          	jalr	-1904(ra) # 80000d1a <memmove>
    return 0;
    80002492:	8526                	mv	a0,s1
    80002494:	bff9                	j	80002472 <either_copyin+0x32>

0000000080002496 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002496:	715d                	addi	sp,sp,-80
    80002498:	e486                	sd	ra,72(sp)
    8000249a:	e0a2                	sd	s0,64(sp)
    8000249c:	fc26                	sd	s1,56(sp)
    8000249e:	f84a                	sd	s2,48(sp)
    800024a0:	f44e                	sd	s3,40(sp)
    800024a2:	f052                	sd	s4,32(sp)
    800024a4:	ec56                	sd	s5,24(sp)
    800024a6:	e85a                	sd	s6,16(sp)
    800024a8:	e45e                	sd	s7,8(sp)
    800024aa:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800024ac:	00006517          	auipc	a0,0x6
    800024b0:	c1c50513          	addi	a0,a0,-996 # 800080c8 <digits+0x88>
    800024b4:	ffffe097          	auipc	ra,0xffffe
    800024b8:	0c0080e7          	jalr	192(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024bc:	0000f497          	auipc	s1,0xf
    800024c0:	36c48493          	addi	s1,s1,876 # 80011828 <proc+0x158>
    800024c4:	00015917          	auipc	s2,0x15
    800024c8:	d6490913          	addi	s2,s2,-668 # 80017228 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024cc:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800024ce:	00006997          	auipc	s3,0x6
    800024d2:	d9a98993          	addi	s3,s3,-614 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    800024d6:	00006a97          	auipc	s5,0x6
    800024da:	d9aa8a93          	addi	s5,s5,-614 # 80008270 <digits+0x230>
    printf("\n");
    800024de:	00006a17          	auipc	s4,0x6
    800024e2:	beaa0a13          	addi	s4,s4,-1046 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024e6:	00006b97          	auipc	s7,0x6
    800024ea:	dc2b8b93          	addi	s7,s7,-574 # 800082a8 <states.0>
    800024ee:	a00d                	j	80002510 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800024f0:	ed86a583          	lw	a1,-296(a3)
    800024f4:	8556                	mv	a0,s5
    800024f6:	ffffe097          	auipc	ra,0xffffe
    800024fa:	07e080e7          	jalr	126(ra) # 80000574 <printf>
    printf("\n");
    800024fe:	8552                	mv	a0,s4
    80002500:	ffffe097          	auipc	ra,0xffffe
    80002504:	074080e7          	jalr	116(ra) # 80000574 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002508:	16848493          	addi	s1,s1,360
    8000250c:	03248263          	beq	s1,s2,80002530 <procdump+0x9a>
    if(p->state == UNUSED)
    80002510:	86a6                	mv	a3,s1
    80002512:	ec04a783          	lw	a5,-320(s1)
    80002516:	dbed                	beqz	a5,80002508 <procdump+0x72>
      state = "???";
    80002518:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000251a:	fcfb6be3          	bltu	s6,a5,800024f0 <procdump+0x5a>
    8000251e:	02079713          	slli	a4,a5,0x20
    80002522:	01d75793          	srli	a5,a4,0x1d
    80002526:	97de                	add	a5,a5,s7
    80002528:	6390                	ld	a2,0(a5)
    8000252a:	f279                	bnez	a2,800024f0 <procdump+0x5a>
      state = "???";
    8000252c:	864e                	mv	a2,s3
    8000252e:	b7c9                	j	800024f0 <procdump+0x5a>
  }
}
    80002530:	60a6                	ld	ra,72(sp)
    80002532:	6406                	ld	s0,64(sp)
    80002534:	74e2                	ld	s1,56(sp)
    80002536:	7942                	ld	s2,48(sp)
    80002538:	79a2                	ld	s3,40(sp)
    8000253a:	7a02                	ld	s4,32(sp)
    8000253c:	6ae2                	ld	s5,24(sp)
    8000253e:	6b42                	ld	s6,16(sp)
    80002540:	6ba2                	ld	s7,8(sp)
    80002542:	6161                	addi	sp,sp,80
    80002544:	8082                	ret

0000000080002546 <trace>:

// assignment 1 Task 2 , this is where "the magic happend" (this is the function of trace)
// we copyed the struction of "kill" and build on it
int 
trace(int mask, int pid)
{
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	e052                	sd	s4,0(sp)
    80002554:	1800                	addi	s0,sp,48
    80002556:	8a2a                	mv	s4,a0
    80002558:	892e                	mv	s2,a1
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000255a:	0000f497          	auipc	s1,0xf
    8000255e:	17648493          	addi	s1,s1,374 # 800116d0 <proc>
    80002562:	00015997          	auipc	s3,0x15
    80002566:	b6e98993          	addi	s3,s3,-1170 # 800170d0 <tickslock>
    acquire(&p->lock);
    8000256a:	8526                	mv	a0,s1
    8000256c:	ffffe097          	auipc	ra,0xffffe
    80002570:	656080e7          	jalr	1622(ra) # 80000bc2 <acquire>
    if(p->pid == pid){
    80002574:	589c                	lw	a5,48(s1)
    80002576:	01278d63          	beq	a5,s2,80002590 <trace+0x4a>
      p->mask_for_trace = mask; // Here we update the trace
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000257a:	8526                	mv	a0,s1
    8000257c:	ffffe097          	auipc	ra,0xffffe
    80002580:	6fa080e7          	jalr	1786(ra) # 80000c76 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002584:	16848493          	addi	s1,s1,360
    80002588:	ff3491e3          	bne	s1,s3,8000256a <trace+0x24>
  }
  return -1;
    8000258c:	557d                	li	a0,-1
    8000258e:	a809                	j	800025a0 <trace+0x5a>
      p->mask_for_trace = mask; // Here we update the trace
    80002590:	0344aa23          	sw	s4,52(s1)
      release(&p->lock);
    80002594:	8526                	mv	a0,s1
    80002596:	ffffe097          	auipc	ra,0xffffe
    8000259a:	6e0080e7          	jalr	1760(ra) # 80000c76 <release>
      return 0;
    8000259e:	4501                	li	a0,0
}
    800025a0:	70a2                	ld	ra,40(sp)
    800025a2:	7402                	ld	s0,32(sp)
    800025a4:	64e2                	ld	s1,24(sp)
    800025a6:	6942                	ld	s2,16(sp)
    800025a8:	69a2                	ld	s3,8(sp)
    800025aa:	6a02                	ld	s4,0(sp)
    800025ac:	6145                	addi	sp,sp,48
    800025ae:	8082                	ret

00000000800025b0 <swtch>:
    800025b0:	00153023          	sd	ra,0(a0)
    800025b4:	00253423          	sd	sp,8(a0)
    800025b8:	e900                	sd	s0,16(a0)
    800025ba:	ed04                	sd	s1,24(a0)
    800025bc:	03253023          	sd	s2,32(a0)
    800025c0:	03353423          	sd	s3,40(a0)
    800025c4:	03453823          	sd	s4,48(a0)
    800025c8:	03553c23          	sd	s5,56(a0)
    800025cc:	05653023          	sd	s6,64(a0)
    800025d0:	05753423          	sd	s7,72(a0)
    800025d4:	05853823          	sd	s8,80(a0)
    800025d8:	05953c23          	sd	s9,88(a0)
    800025dc:	07a53023          	sd	s10,96(a0)
    800025e0:	07b53423          	sd	s11,104(a0)
    800025e4:	0005b083          	ld	ra,0(a1)
    800025e8:	0085b103          	ld	sp,8(a1)
    800025ec:	6980                	ld	s0,16(a1)
    800025ee:	6d84                	ld	s1,24(a1)
    800025f0:	0205b903          	ld	s2,32(a1)
    800025f4:	0285b983          	ld	s3,40(a1)
    800025f8:	0305ba03          	ld	s4,48(a1)
    800025fc:	0385ba83          	ld	s5,56(a1)
    80002600:	0405bb03          	ld	s6,64(a1)
    80002604:	0485bb83          	ld	s7,72(a1)
    80002608:	0505bc03          	ld	s8,80(a1)
    8000260c:	0585bc83          	ld	s9,88(a1)
    80002610:	0605bd03          	ld	s10,96(a1)
    80002614:	0685bd83          	ld	s11,104(a1)
    80002618:	8082                	ret

000000008000261a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000261a:	1141                	addi	sp,sp,-16
    8000261c:	e406                	sd	ra,8(sp)
    8000261e:	e022                	sd	s0,0(sp)
    80002620:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002622:	00006597          	auipc	a1,0x6
    80002626:	cb658593          	addi	a1,a1,-842 # 800082d8 <states.0+0x30>
    8000262a:	00015517          	auipc	a0,0x15
    8000262e:	aa650513          	addi	a0,a0,-1370 # 800170d0 <tickslock>
    80002632:	ffffe097          	auipc	ra,0xffffe
    80002636:	500080e7          	jalr	1280(ra) # 80000b32 <initlock>
}
    8000263a:	60a2                	ld	ra,8(sp)
    8000263c:	6402                	ld	s0,0(sp)
    8000263e:	0141                	addi	sp,sp,16
    80002640:	8082                	ret

0000000080002642 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002642:	1141                	addi	sp,sp,-16
    80002644:	e422                	sd	s0,8(sp)
    80002646:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002648:	00003797          	auipc	a5,0x3
    8000264c:	59878793          	addi	a5,a5,1432 # 80005be0 <kernelvec>
    80002650:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002654:	6422                	ld	s0,8(sp)
    80002656:	0141                	addi	sp,sp,16
    80002658:	8082                	ret

000000008000265a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000265a:	1141                	addi	sp,sp,-16
    8000265c:	e406                	sd	ra,8(sp)
    8000265e:	e022                	sd	s0,0(sp)
    80002660:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002662:	fffff097          	auipc	ra,0xfffff
    80002666:	31c080e7          	jalr	796(ra) # 8000197e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000266a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000266e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002670:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002674:	00005617          	auipc	a2,0x5
    80002678:	98c60613          	addi	a2,a2,-1652 # 80007000 <_trampoline>
    8000267c:	00005697          	auipc	a3,0x5
    80002680:	98468693          	addi	a3,a3,-1660 # 80007000 <_trampoline>
    80002684:	8e91                	sub	a3,a3,a2
    80002686:	040007b7          	lui	a5,0x4000
    8000268a:	17fd                	addi	a5,a5,-1
    8000268c:	07b2                	slli	a5,a5,0xc
    8000268e:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002690:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002694:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002696:	180026f3          	csrr	a3,satp
    8000269a:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000269c:	6d38                	ld	a4,88(a0)
    8000269e:	6134                	ld	a3,64(a0)
    800026a0:	6585                	lui	a1,0x1
    800026a2:	96ae                	add	a3,a3,a1
    800026a4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800026a6:	6d38                	ld	a4,88(a0)
    800026a8:	00000697          	auipc	a3,0x0
    800026ac:	13868693          	addi	a3,a3,312 # 800027e0 <usertrap>
    800026b0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026b2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026b4:	8692                	mv	a3,tp
    800026b6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026b8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026bc:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026c0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026c4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026c8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026ca:	6f18                	ld	a4,24(a4)
    800026cc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026d0:	692c                	ld	a1,80(a0)
    800026d2:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026d4:	00005717          	auipc	a4,0x5
    800026d8:	9bc70713          	addi	a4,a4,-1604 # 80007090 <userret>
    800026dc:	8f11                	sub	a4,a4,a2
    800026de:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026e0:	577d                	li	a4,-1
    800026e2:	177e                	slli	a4,a4,0x3f
    800026e4:	8dd9                	or	a1,a1,a4
    800026e6:	02000537          	lui	a0,0x2000
    800026ea:	157d                	addi	a0,a0,-1
    800026ec:	0536                	slli	a0,a0,0xd
    800026ee:	9782                	jalr	a5
}
    800026f0:	60a2                	ld	ra,8(sp)
    800026f2:	6402                	ld	s0,0(sp)
    800026f4:	0141                	addi	sp,sp,16
    800026f6:	8082                	ret

00000000800026f8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026f8:	1101                	addi	sp,sp,-32
    800026fa:	ec06                	sd	ra,24(sp)
    800026fc:	e822                	sd	s0,16(sp)
    800026fe:	e426                	sd	s1,8(sp)
    80002700:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002702:	00015497          	auipc	s1,0x15
    80002706:	9ce48493          	addi	s1,s1,-1586 # 800170d0 <tickslock>
    8000270a:	8526                	mv	a0,s1
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	4b6080e7          	jalr	1206(ra) # 80000bc2 <acquire>
  ticks++;
    80002714:	00007517          	auipc	a0,0x7
    80002718:	91c50513          	addi	a0,a0,-1764 # 80009030 <ticks>
    8000271c:	411c                	lw	a5,0(a0)
    8000271e:	2785                	addiw	a5,a5,1
    80002720:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002722:	00000097          	auipc	ra,0x0
    80002726:	ab0080e7          	jalr	-1360(ra) # 800021d2 <wakeup>
  release(&tickslock);
    8000272a:	8526                	mv	a0,s1
    8000272c:	ffffe097          	auipc	ra,0xffffe
    80002730:	54a080e7          	jalr	1354(ra) # 80000c76 <release>
}
    80002734:	60e2                	ld	ra,24(sp)
    80002736:	6442                	ld	s0,16(sp)
    80002738:	64a2                	ld	s1,8(sp)
    8000273a:	6105                	addi	sp,sp,32
    8000273c:	8082                	ret

000000008000273e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000273e:	1101                	addi	sp,sp,-32
    80002740:	ec06                	sd	ra,24(sp)
    80002742:	e822                	sd	s0,16(sp)
    80002744:	e426                	sd	s1,8(sp)
    80002746:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002748:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    8000274c:	00074d63          	bltz	a4,80002766 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002750:	57fd                	li	a5,-1
    80002752:	17fe                	slli	a5,a5,0x3f
    80002754:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002756:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002758:	06f70363          	beq	a4,a5,800027be <devintr+0x80>
  }
}
    8000275c:	60e2                	ld	ra,24(sp)
    8000275e:	6442                	ld	s0,16(sp)
    80002760:	64a2                	ld	s1,8(sp)
    80002762:	6105                	addi	sp,sp,32
    80002764:	8082                	ret
     (scause & 0xff) == 9){
    80002766:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000276a:	46a5                	li	a3,9
    8000276c:	fed792e3          	bne	a5,a3,80002750 <devintr+0x12>
    int irq = plic_claim();
    80002770:	00003097          	auipc	ra,0x3
    80002774:	578080e7          	jalr	1400(ra) # 80005ce8 <plic_claim>
    80002778:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000277a:	47a9                	li	a5,10
    8000277c:	02f50763          	beq	a0,a5,800027aa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002780:	4785                	li	a5,1
    80002782:	02f50963          	beq	a0,a5,800027b4 <devintr+0x76>
    return 1;
    80002786:	4505                	li	a0,1
    } else if(irq){
    80002788:	d8f1                	beqz	s1,8000275c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000278a:	85a6                	mv	a1,s1
    8000278c:	00006517          	auipc	a0,0x6
    80002790:	b5450513          	addi	a0,a0,-1196 # 800082e0 <states.0+0x38>
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	de0080e7          	jalr	-544(ra) # 80000574 <printf>
      plic_complete(irq);
    8000279c:	8526                	mv	a0,s1
    8000279e:	00003097          	auipc	ra,0x3
    800027a2:	56e080e7          	jalr	1390(ra) # 80005d0c <plic_complete>
    return 1;
    800027a6:	4505                	li	a0,1
    800027a8:	bf55                	j	8000275c <devintr+0x1e>
      uartintr();
    800027aa:	ffffe097          	auipc	ra,0xffffe
    800027ae:	1dc080e7          	jalr	476(ra) # 80000986 <uartintr>
    800027b2:	b7ed                	j	8000279c <devintr+0x5e>
      virtio_disk_intr();
    800027b4:	00004097          	auipc	ra,0x4
    800027b8:	9ea080e7          	jalr	-1558(ra) # 8000619e <virtio_disk_intr>
    800027bc:	b7c5                	j	8000279c <devintr+0x5e>
    if(cpuid() == 0){
    800027be:	fffff097          	auipc	ra,0xfffff
    800027c2:	194080e7          	jalr	404(ra) # 80001952 <cpuid>
    800027c6:	c901                	beqz	a0,800027d6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027c8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027cc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027ce:	14479073          	csrw	sip,a5
    return 2;
    800027d2:	4509                	li	a0,2
    800027d4:	b761                	j	8000275c <devintr+0x1e>
      clockintr();
    800027d6:	00000097          	auipc	ra,0x0
    800027da:	f22080e7          	jalr	-222(ra) # 800026f8 <clockintr>
    800027de:	b7ed                	j	800027c8 <devintr+0x8a>

00000000800027e0 <usertrap>:
{
    800027e0:	1101                	addi	sp,sp,-32
    800027e2:	ec06                	sd	ra,24(sp)
    800027e4:	e822                	sd	s0,16(sp)
    800027e6:	e426                	sd	s1,8(sp)
    800027e8:	e04a                	sd	s2,0(sp)
    800027ea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027f0:	1007f793          	andi	a5,a5,256
    800027f4:	e3ad                	bnez	a5,80002856 <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027f6:	00003797          	auipc	a5,0x3
    800027fa:	3ea78793          	addi	a5,a5,1002 # 80005be0 <kernelvec>
    800027fe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002802:	fffff097          	auipc	ra,0xfffff
    80002806:	17c080e7          	jalr	380(ra) # 8000197e <myproc>
    8000280a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000280c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000280e:	14102773          	csrr	a4,sepc
    80002812:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002814:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002818:	47a1                	li	a5,8
    8000281a:	04f71c63          	bne	a4,a5,80002872 <usertrap+0x92>
    if(p->killed)
    8000281e:	551c                	lw	a5,40(a0)
    80002820:	e3b9                	bnez	a5,80002866 <usertrap+0x86>
    p->trapframe->epc += 4;
    80002822:	6cb8                	ld	a4,88(s1)
    80002824:	6f1c                	ld	a5,24(a4)
    80002826:	0791                	addi	a5,a5,4
    80002828:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000282a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000282e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002832:	10079073          	csrw	sstatus,a5
    syscall();
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	2e0080e7          	jalr	736(ra) # 80002b16 <syscall>
  if(p->killed)
    8000283e:	549c                	lw	a5,40(s1)
    80002840:	ebc1                	bnez	a5,800028d0 <usertrap+0xf0>
  usertrapret();
    80002842:	00000097          	auipc	ra,0x0
    80002846:	e18080e7          	jalr	-488(ra) # 8000265a <usertrapret>
}
    8000284a:	60e2                	ld	ra,24(sp)
    8000284c:	6442                	ld	s0,16(sp)
    8000284e:	64a2                	ld	s1,8(sp)
    80002850:	6902                	ld	s2,0(sp)
    80002852:	6105                	addi	sp,sp,32
    80002854:	8082                	ret
    panic("usertrap: not from user mode");
    80002856:	00006517          	auipc	a0,0x6
    8000285a:	aaa50513          	addi	a0,a0,-1366 # 80008300 <states.0+0x58>
    8000285e:	ffffe097          	auipc	ra,0xffffe
    80002862:	ccc080e7          	jalr	-820(ra) # 8000052a <panic>
      exit(-1);
    80002866:	557d                	li	a0,-1
    80002868:	00000097          	auipc	ra,0x0
    8000286c:	a3a080e7          	jalr	-1478(ra) # 800022a2 <exit>
    80002870:	bf4d                	j	80002822 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002872:	00000097          	auipc	ra,0x0
    80002876:	ecc080e7          	jalr	-308(ra) # 8000273e <devintr>
    8000287a:	892a                	mv	s2,a0
    8000287c:	c501                	beqz	a0,80002884 <usertrap+0xa4>
  if(p->killed)
    8000287e:	549c                	lw	a5,40(s1)
    80002880:	c3a1                	beqz	a5,800028c0 <usertrap+0xe0>
    80002882:	a815                	j	800028b6 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002884:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002888:	5890                	lw	a2,48(s1)
    8000288a:	00006517          	auipc	a0,0x6
    8000288e:	a9650513          	addi	a0,a0,-1386 # 80008320 <states.0+0x78>
    80002892:	ffffe097          	auipc	ra,0xffffe
    80002896:	ce2080e7          	jalr	-798(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000289a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000289e:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    800028a2:	00006517          	auipc	a0,0x6
    800028a6:	aae50513          	addi	a0,a0,-1362 # 80008350 <states.0+0xa8>
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	cca080e7          	jalr	-822(ra) # 80000574 <printf>
    p->killed = 1;
    800028b2:	4785                	li	a5,1
    800028b4:	d49c                	sw	a5,40(s1)
    exit(-1);
    800028b6:	557d                	li	a0,-1
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	9ea080e7          	jalr	-1558(ra) # 800022a2 <exit>
  if(which_dev == 2)
    800028c0:	4789                	li	a5,2
    800028c2:	f8f910e3          	bne	s2,a5,80002842 <usertrap+0x62>
    yield();
    800028c6:	fffff097          	auipc	ra,0xfffff
    800028ca:	744080e7          	jalr	1860(ra) # 8000200a <yield>
    800028ce:	bf95                	j	80002842 <usertrap+0x62>
  int which_dev = 0;
    800028d0:	4901                	li	s2,0
    800028d2:	b7d5                	j	800028b6 <usertrap+0xd6>

00000000800028d4 <kerneltrap>:
{
    800028d4:	7179                	addi	sp,sp,-48
    800028d6:	f406                	sd	ra,40(sp)
    800028d8:	f022                	sd	s0,32(sp)
    800028da:	ec26                	sd	s1,24(sp)
    800028dc:	e84a                	sd	s2,16(sp)
    800028de:	e44e                	sd	s3,8(sp)
    800028e0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028e2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028e6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028ea:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028ee:	1004f793          	andi	a5,s1,256
    800028f2:	cb85                	beqz	a5,80002922 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028f8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028fa:	ef85                	bnez	a5,80002932 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028fc:	00000097          	auipc	ra,0x0
    80002900:	e42080e7          	jalr	-446(ra) # 8000273e <devintr>
    80002904:	cd1d                	beqz	a0,80002942 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002906:	4789                	li	a5,2
    80002908:	06f50a63          	beq	a0,a5,8000297c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000290c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002910:	10049073          	csrw	sstatus,s1
}
    80002914:	70a2                	ld	ra,40(sp)
    80002916:	7402                	ld	s0,32(sp)
    80002918:	64e2                	ld	s1,24(sp)
    8000291a:	6942                	ld	s2,16(sp)
    8000291c:	69a2                	ld	s3,8(sp)
    8000291e:	6145                	addi	sp,sp,48
    80002920:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002922:	00006517          	auipc	a0,0x6
    80002926:	a4e50513          	addi	a0,a0,-1458 # 80008370 <states.0+0xc8>
    8000292a:	ffffe097          	auipc	ra,0xffffe
    8000292e:	c00080e7          	jalr	-1024(ra) # 8000052a <panic>
    panic("kerneltrap: interrupts enabled");
    80002932:	00006517          	auipc	a0,0x6
    80002936:	a6650513          	addi	a0,a0,-1434 # 80008398 <states.0+0xf0>
    8000293a:	ffffe097          	auipc	ra,0xffffe
    8000293e:	bf0080e7          	jalr	-1040(ra) # 8000052a <panic>
    printf("scause %p\n", scause);
    80002942:	85ce                	mv	a1,s3
    80002944:	00006517          	auipc	a0,0x6
    80002948:	a7450513          	addi	a0,a0,-1420 # 800083b8 <states.0+0x110>
    8000294c:	ffffe097          	auipc	ra,0xffffe
    80002950:	c28080e7          	jalr	-984(ra) # 80000574 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002954:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002958:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000295c:	00006517          	auipc	a0,0x6
    80002960:	a6c50513          	addi	a0,a0,-1428 # 800083c8 <states.0+0x120>
    80002964:	ffffe097          	auipc	ra,0xffffe
    80002968:	c10080e7          	jalr	-1008(ra) # 80000574 <printf>
    panic("kerneltrap");
    8000296c:	00006517          	auipc	a0,0x6
    80002970:	a7450513          	addi	a0,a0,-1420 # 800083e0 <states.0+0x138>
    80002974:	ffffe097          	auipc	ra,0xffffe
    80002978:	bb6080e7          	jalr	-1098(ra) # 8000052a <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000297c:	fffff097          	auipc	ra,0xfffff
    80002980:	002080e7          	jalr	2(ra) # 8000197e <myproc>
    80002984:	d541                	beqz	a0,8000290c <kerneltrap+0x38>
    80002986:	fffff097          	auipc	ra,0xfffff
    8000298a:	ff8080e7          	jalr	-8(ra) # 8000197e <myproc>
    8000298e:	4d18                	lw	a4,24(a0)
    80002990:	4791                	li	a5,4
    80002992:	f6f71de3          	bne	a4,a5,8000290c <kerneltrap+0x38>
    yield();
    80002996:	fffff097          	auipc	ra,0xfffff
    8000299a:	674080e7          	jalr	1652(ra) # 8000200a <yield>
    8000299e:	b7bd                	j	8000290c <kerneltrap+0x38>

00000000800029a0 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800029a0:	1101                	addi	sp,sp,-32
    800029a2:	ec06                	sd	ra,24(sp)
    800029a4:	e822                	sd	s0,16(sp)
    800029a6:	e426                	sd	s1,8(sp)
    800029a8:	1000                	addi	s0,sp,32
    800029aa:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029ac:	fffff097          	auipc	ra,0xfffff
    800029b0:	fd2080e7          	jalr	-46(ra) # 8000197e <myproc>
  switch (n) {
    800029b4:	4795                	li	a5,5
    800029b6:	0497e163          	bltu	a5,s1,800029f8 <argraw+0x58>
    800029ba:	048a                	slli	s1,s1,0x2
    800029bc:	00006717          	auipc	a4,0x6
    800029c0:	b5c70713          	addi	a4,a4,-1188 # 80008518 <states.0+0x270>
    800029c4:	94ba                	add	s1,s1,a4
    800029c6:	409c                	lw	a5,0(s1)
    800029c8:	97ba                	add	a5,a5,a4
    800029ca:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029cc:	6d3c                	ld	a5,88(a0)
    800029ce:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029d0:	60e2                	ld	ra,24(sp)
    800029d2:	6442                	ld	s0,16(sp)
    800029d4:	64a2                	ld	s1,8(sp)
    800029d6:	6105                	addi	sp,sp,32
    800029d8:	8082                	ret
    return p->trapframe->a1;
    800029da:	6d3c                	ld	a5,88(a0)
    800029dc:	7fa8                	ld	a0,120(a5)
    800029de:	bfcd                	j	800029d0 <argraw+0x30>
    return p->trapframe->a2;
    800029e0:	6d3c                	ld	a5,88(a0)
    800029e2:	63c8                	ld	a0,128(a5)
    800029e4:	b7f5                	j	800029d0 <argraw+0x30>
    return p->trapframe->a3;
    800029e6:	6d3c                	ld	a5,88(a0)
    800029e8:	67c8                	ld	a0,136(a5)
    800029ea:	b7dd                	j	800029d0 <argraw+0x30>
    return p->trapframe->a4;
    800029ec:	6d3c                	ld	a5,88(a0)
    800029ee:	6bc8                	ld	a0,144(a5)
    800029f0:	b7c5                	j	800029d0 <argraw+0x30>
    return p->trapframe->a5;
    800029f2:	6d3c                	ld	a5,88(a0)
    800029f4:	6fc8                	ld	a0,152(a5)
    800029f6:	bfe9                	j	800029d0 <argraw+0x30>
  panic("argraw");
    800029f8:	00006517          	auipc	a0,0x6
    800029fc:	9f850513          	addi	a0,a0,-1544 # 800083f0 <states.0+0x148>
    80002a00:	ffffe097          	auipc	ra,0xffffe
    80002a04:	b2a080e7          	jalr	-1238(ra) # 8000052a <panic>

0000000080002a08 <fetchaddr>:
{
    80002a08:	1101                	addi	sp,sp,-32
    80002a0a:	ec06                	sd	ra,24(sp)
    80002a0c:	e822                	sd	s0,16(sp)
    80002a0e:	e426                	sd	s1,8(sp)
    80002a10:	e04a                	sd	s2,0(sp)
    80002a12:	1000                	addi	s0,sp,32
    80002a14:	84aa                	mv	s1,a0
    80002a16:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a18:	fffff097          	auipc	ra,0xfffff
    80002a1c:	f66080e7          	jalr	-154(ra) # 8000197e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a20:	653c                	ld	a5,72(a0)
    80002a22:	02f4f863          	bgeu	s1,a5,80002a52 <fetchaddr+0x4a>
    80002a26:	00848713          	addi	a4,s1,8
    80002a2a:	02e7e663          	bltu	a5,a4,80002a56 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a2e:	46a1                	li	a3,8
    80002a30:	8626                	mv	a2,s1
    80002a32:	85ca                	mv	a1,s2
    80002a34:	6928                	ld	a0,80(a0)
    80002a36:	fffff097          	auipc	ra,0xfffff
    80002a3a:	c94080e7          	jalr	-876(ra) # 800016ca <copyin>
    80002a3e:	00a03533          	snez	a0,a0
    80002a42:	40a00533          	neg	a0,a0
}
    80002a46:	60e2                	ld	ra,24(sp)
    80002a48:	6442                	ld	s0,16(sp)
    80002a4a:	64a2                	ld	s1,8(sp)
    80002a4c:	6902                	ld	s2,0(sp)
    80002a4e:	6105                	addi	sp,sp,32
    80002a50:	8082                	ret
    return -1;
    80002a52:	557d                	li	a0,-1
    80002a54:	bfcd                	j	80002a46 <fetchaddr+0x3e>
    80002a56:	557d                	li	a0,-1
    80002a58:	b7fd                	j	80002a46 <fetchaddr+0x3e>

0000000080002a5a <fetchstr>:
{
    80002a5a:	7179                	addi	sp,sp,-48
    80002a5c:	f406                	sd	ra,40(sp)
    80002a5e:	f022                	sd	s0,32(sp)
    80002a60:	ec26                	sd	s1,24(sp)
    80002a62:	e84a                	sd	s2,16(sp)
    80002a64:	e44e                	sd	s3,8(sp)
    80002a66:	1800                	addi	s0,sp,48
    80002a68:	892a                	mv	s2,a0
    80002a6a:	84ae                	mv	s1,a1
    80002a6c:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a6e:	fffff097          	auipc	ra,0xfffff
    80002a72:	f10080e7          	jalr	-240(ra) # 8000197e <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a76:	86ce                	mv	a3,s3
    80002a78:	864a                	mv	a2,s2
    80002a7a:	85a6                	mv	a1,s1
    80002a7c:	6928                	ld	a0,80(a0)
    80002a7e:	fffff097          	auipc	ra,0xfffff
    80002a82:	cda080e7          	jalr	-806(ra) # 80001758 <copyinstr>
  if(err < 0)
    80002a86:	00054763          	bltz	a0,80002a94 <fetchstr+0x3a>
  return strlen(buf);
    80002a8a:	8526                	mv	a0,s1
    80002a8c:	ffffe097          	auipc	ra,0xffffe
    80002a90:	3b6080e7          	jalr	950(ra) # 80000e42 <strlen>
}
    80002a94:	70a2                	ld	ra,40(sp)
    80002a96:	7402                	ld	s0,32(sp)
    80002a98:	64e2                	ld	s1,24(sp)
    80002a9a:	6942                	ld	s2,16(sp)
    80002a9c:	69a2                	ld	s3,8(sp)
    80002a9e:	6145                	addi	sp,sp,48
    80002aa0:	8082                	ret

0000000080002aa2 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002aa2:	1101                	addi	sp,sp,-32
    80002aa4:	ec06                	sd	ra,24(sp)
    80002aa6:	e822                	sd	s0,16(sp)
    80002aa8:	e426                	sd	s1,8(sp)
    80002aaa:	1000                	addi	s0,sp,32
    80002aac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002aae:	00000097          	auipc	ra,0x0
    80002ab2:	ef2080e7          	jalr	-270(ra) # 800029a0 <argraw>
    80002ab6:	c088                	sw	a0,0(s1)
  return 0;
}
    80002ab8:	4501                	li	a0,0
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret

0000000080002ac4 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002ac4:	1101                	addi	sp,sp,-32
    80002ac6:	ec06                	sd	ra,24(sp)
    80002ac8:	e822                	sd	s0,16(sp)
    80002aca:	e426                	sd	s1,8(sp)
    80002acc:	1000                	addi	s0,sp,32
    80002ace:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	ed0080e7          	jalr	-304(ra) # 800029a0 <argraw>
    80002ad8:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ada:	4501                	li	a0,0
    80002adc:	60e2                	ld	ra,24(sp)
    80002ade:	6442                	ld	s0,16(sp)
    80002ae0:	64a2                	ld	s1,8(sp)
    80002ae2:	6105                	addi	sp,sp,32
    80002ae4:	8082                	ret

0000000080002ae6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ae6:	1101                	addi	sp,sp,-32
    80002ae8:	ec06                	sd	ra,24(sp)
    80002aea:	e822                	sd	s0,16(sp)
    80002aec:	e426                	sd	s1,8(sp)
    80002aee:	e04a                	sd	s2,0(sp)
    80002af0:	1000                	addi	s0,sp,32
    80002af2:	84ae                	mv	s1,a1
    80002af4:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	eaa080e7          	jalr	-342(ra) # 800029a0 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002afe:	864a                	mv	a2,s2
    80002b00:	85a6                	mv	a1,s1
    80002b02:	00000097          	auipc	ra,0x0
    80002b06:	f58080e7          	jalr	-168(ra) # 80002a5a <fetchstr>
}
    80002b0a:	60e2                	ld	ra,24(sp)
    80002b0c:	6442                	ld	s0,16(sp)
    80002b0e:	64a2                	ld	s1,8(sp)
    80002b10:	6902                	ld	s2,0(sp)
    80002b12:	6105                	addi	sp,sp,32
    80002b14:	8082                	ret

0000000080002b16 <syscall>:
[SYS_trace]   sys_trace,    // Task 2 additions
};

void
syscall(void)
{
    80002b16:	7139                	addi	sp,sp,-64
    80002b18:	fc06                	sd	ra,56(sp)
    80002b1a:	f822                	sd	s0,48(sp)
    80002b1c:	f426                	sd	s1,40(sp)
    80002b1e:	f04a                	sd	s2,32(sp)
    80002b20:	ec4e                	sd	s3,24(sp)
    80002b22:	e852                	sd	s4,16(sp)
    80002b24:	e456                	sd	s5,8(sp)
    80002b26:	0080                	addi	s0,sp,64
  int num;
  struct proc *p = myproc();
    80002b28:	fffff097          	auipc	ra,0xfffff
    80002b2c:	e56080e7          	jalr	-426(ra) # 8000197e <myproc>
    80002b30:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b32:	6d38                	ld	a4,88(a0)
    80002b34:	775c                	ld	a5,168(a4)
    80002b36:	0007869b          	sext.w	a3,a5
  int trace_is_on = 1 << num;
  trace_is_on = trace_is_on & p -> mask_for_trace;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b3a:	37fd                	addiw	a5,a5,-1
    80002b3c:	4655                	li	a2,21
    80002b3e:	0cf66563          	bltu	a2,a5,80002c08 <syscall+0xf2>
    80002b42:	00369613          	slli	a2,a3,0x3
    80002b46:	00006797          	auipc	a5,0x6
    80002b4a:	9ea78793          	addi	a5,a5,-1558 # 80008530 <syscalls>
    80002b4e:	97b2                	add	a5,a5,a2
    80002b50:	0007b903          	ld	s2,0(a5)
    80002b54:	0a090a63          	beqz	s2,80002c08 <syscall+0xf2>
  int trace_is_on = 1 << num;
    80002b58:	4785                	li	a5,1
    80002b5a:	00d797bb          	sllw	a5,a5,a3
  trace_is_on = trace_is_on & p -> mask_for_trace;
    80002b5e:	5950                	lw	a2,52(a0)
    if (trace_is_on){
    80002b60:	8ff1                	and	a5,a5,a2
    80002b62:	cfd9                	beqz	a5,80002c00 <syscall+0xea>
      if (num == SYS_fork)
    80002b64:	4785                	li	a5,1
    80002b66:	02f68f63          	beq	a3,a5,80002ba4 <syscall+0x8e>
        printf("%d: syscall %s NULL -> %d\n",p->pid, syscalls_strings[num], syscalls[num]()); // If fork
      else if (num == SYS_kill || num == SYS_sbrk)
    80002b6a:	4799                	li	a5,6
    80002b6c:	06f68163          	beq	a3,a5,80002bce <syscall+0xb8>
    80002b70:	47b1                	li	a5,12
    80002b72:	04f68e63          	beq	a3,a5,80002bce <syscall+0xb8>
        printf("%d: syscall %s %d -> %d\n", p->pid, syscalls_strings[num],  p->trapframe->a0, syscalls[num]()); // kill or skrb
      else
        printf("%d: syscall %s -> %d\n",p->pid, syscalls_strings[num], syscalls[num]()); 
    80002b76:	03052983          	lw	s3,48(a0)
    80002b7a:	068e                	slli	a3,a3,0x3
    80002b7c:	00006797          	auipc	a5,0x6
    80002b80:	9b478793          	addi	a5,a5,-1612 # 80008530 <syscalls>
    80002b84:	96be                	add	a3,a3,a5
    80002b86:	0b86ba03          	ld	s4,184(a3)
    80002b8a:	9902                	jalr	s2
    80002b8c:	86aa                	mv	a3,a0
    80002b8e:	8652                	mv	a2,s4
    80002b90:	85ce                	mv	a1,s3
    80002b92:	00006517          	auipc	a0,0x6
    80002b96:	8ae50513          	addi	a0,a0,-1874 # 80008440 <states.0+0x198>
    80002b9a:	ffffe097          	auipc	ra,0xffffe
    80002b9e:	9da080e7          	jalr	-1574(ra) # 80000574 <printf>
    80002ba2:	a8b9                	j	80002c00 <syscall+0xea>
        printf("%d: syscall %s NULL -> %d\n",p->pid, syscalls_strings[num], syscalls[num]()); // If fork
    80002ba4:	03052983          	lw	s3,48(a0)
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	0dc080e7          	jalr	220(ra) # 80002c84 <sys_fork>
    80002bb0:	86aa                	mv	a3,a0
    80002bb2:	00006617          	auipc	a2,0x6
    80002bb6:	84660613          	addi	a2,a2,-1978 # 800083f8 <states.0+0x150>
    80002bba:	85ce                	mv	a1,s3
    80002bbc:	00006517          	auipc	a0,0x6
    80002bc0:	84450513          	addi	a0,a0,-1980 # 80008400 <states.0+0x158>
    80002bc4:	ffffe097          	auipc	ra,0xffffe
    80002bc8:	9b0080e7          	jalr	-1616(ra) # 80000574 <printf>
    80002bcc:	a815                	j	80002c00 <syscall+0xea>
        printf("%d: syscall %s %d -> %d\n", p->pid, syscalls_strings[num],  p->trapframe->a0, syscalls[num]()); // kill or skrb
    80002bce:	0304a983          	lw	s3,48(s1)
    80002bd2:	068e                	slli	a3,a3,0x3
    80002bd4:	00006797          	auipc	a5,0x6
    80002bd8:	95c78793          	addi	a5,a5,-1700 # 80008530 <syscalls>
    80002bdc:	96be                	add	a3,a3,a5
    80002bde:	0b86ba03          	ld	s4,184(a3)
    80002be2:	07073a83          	ld	s5,112(a4)
    80002be6:	9902                	jalr	s2
    80002be8:	872a                	mv	a4,a0
    80002bea:	86d6                	mv	a3,s5
    80002bec:	8652                	mv	a2,s4
    80002bee:	85ce                	mv	a1,s3
    80002bf0:	00006517          	auipc	a0,0x6
    80002bf4:	83050513          	addi	a0,a0,-2000 # 80008420 <states.0+0x178>
    80002bf8:	ffffe097          	auipc	ra,0xffffe
    80002bfc:	97c080e7          	jalr	-1668(ra) # 80000574 <printf>
    }
    p->trapframe->a0 = syscalls[num]();
    80002c00:	6ca4                	ld	s1,88(s1)
    80002c02:	9902                	jalr	s2
    80002c04:	f8a8                	sd	a0,112(s1)
    80002c06:	a839                	j	80002c24 <syscall+0x10e>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c08:	15848613          	addi	a2,s1,344
    80002c0c:	588c                	lw	a1,48(s1)
    80002c0e:	00006517          	auipc	a0,0x6
    80002c12:	84a50513          	addi	a0,a0,-1974 # 80008458 <states.0+0x1b0>
    80002c16:	ffffe097          	auipc	ra,0xffffe
    80002c1a:	95e080e7          	jalr	-1698(ra) # 80000574 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c1e:	6cbc                	ld	a5,88(s1)
    80002c20:	577d                	li	a4,-1
    80002c22:	fbb8                	sd	a4,112(a5)
  }
}
    80002c24:	70e2                	ld	ra,56(sp)
    80002c26:	7442                	ld	s0,48(sp)
    80002c28:	74a2                	ld	s1,40(sp)
    80002c2a:	7902                	ld	s2,32(sp)
    80002c2c:	69e2                	ld	s3,24(sp)
    80002c2e:	6a42                	ld	s4,16(sp)
    80002c30:	6aa2                	ld	s5,8(sp)
    80002c32:	6121                	addi	sp,sp,64
    80002c34:	8082                	ret

0000000080002c36 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c36:	1101                	addi	sp,sp,-32
    80002c38:	ec06                	sd	ra,24(sp)
    80002c3a:	e822                	sd	s0,16(sp)
    80002c3c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002c3e:	fec40593          	addi	a1,s0,-20
    80002c42:	4501                	li	a0,0
    80002c44:	00000097          	auipc	ra,0x0
    80002c48:	e5e080e7          	jalr	-418(ra) # 80002aa2 <argint>
    return -1;
    80002c4c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c4e:	00054963          	bltz	a0,80002c60 <sys_exit+0x2a>
  exit(n);
    80002c52:	fec42503          	lw	a0,-20(s0)
    80002c56:	fffff097          	auipc	ra,0xfffff
    80002c5a:	64c080e7          	jalr	1612(ra) # 800022a2 <exit>
  return 0;  // not reached
    80002c5e:	4781                	li	a5,0
}
    80002c60:	853e                	mv	a0,a5
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	6105                	addi	sp,sp,32
    80002c68:	8082                	ret

0000000080002c6a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c6a:	1141                	addi	sp,sp,-16
    80002c6c:	e406                	sd	ra,8(sp)
    80002c6e:	e022                	sd	s0,0(sp)
    80002c70:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	d0c080e7          	jalr	-756(ra) # 8000197e <myproc>
}
    80002c7a:	5908                	lw	a0,48(a0)
    80002c7c:	60a2                	ld	ra,8(sp)
    80002c7e:	6402                	ld	s0,0(sp)
    80002c80:	0141                	addi	sp,sp,16
    80002c82:	8082                	ret

0000000080002c84 <sys_fork>:

uint64
sys_fork(void)
{
    80002c84:	1141                	addi	sp,sp,-16
    80002c86:	e406                	sd	ra,8(sp)
    80002c88:	e022                	sd	s0,0(sp)
    80002c8a:	0800                	addi	s0,sp,16
  return fork();
    80002c8c:	fffff097          	auipc	ra,0xfffff
    80002c90:	0c0080e7          	jalr	192(ra) # 80001d4c <fork>
}
    80002c94:	60a2                	ld	ra,8(sp)
    80002c96:	6402                	ld	s0,0(sp)
    80002c98:	0141                	addi	sp,sp,16
    80002c9a:	8082                	ret

0000000080002c9c <sys_wait>:

uint64
sys_wait(void)
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002ca4:	fe840593          	addi	a1,s0,-24
    80002ca8:	4501                	li	a0,0
    80002caa:	00000097          	auipc	ra,0x0
    80002cae:	e1a080e7          	jalr	-486(ra) # 80002ac4 <argaddr>
    80002cb2:	87aa                	mv	a5,a0
    return -1;
    80002cb4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002cb6:	0007c863          	bltz	a5,80002cc6 <sys_wait+0x2a>
  return wait(p);
    80002cba:	fe843503          	ld	a0,-24(s0)
    80002cbe:	fffff097          	auipc	ra,0xfffff
    80002cc2:	3ec080e7          	jalr	1004(ra) # 800020aa <wait>
}
    80002cc6:	60e2                	ld	ra,24(sp)
    80002cc8:	6442                	ld	s0,16(sp)
    80002cca:	6105                	addi	sp,sp,32
    80002ccc:	8082                	ret

0000000080002cce <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cce:	7179                	addi	sp,sp,-48
    80002cd0:	f406                	sd	ra,40(sp)
    80002cd2:	f022                	sd	s0,32(sp)
    80002cd4:	ec26                	sd	s1,24(sp)
    80002cd6:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002cd8:	fdc40593          	addi	a1,s0,-36
    80002cdc:	4501                	li	a0,0
    80002cde:	00000097          	auipc	ra,0x0
    80002ce2:	dc4080e7          	jalr	-572(ra) # 80002aa2 <argint>
    return -1;
    80002ce6:	54fd                	li	s1,-1
  if(argint(0, &n) < 0)
    80002ce8:	00054f63          	bltz	a0,80002d06 <sys_sbrk+0x38>
  addr = myproc()->sz;
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	c92080e7          	jalr	-878(ra) # 8000197e <myproc>
    80002cf4:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002cf6:	fdc42503          	lw	a0,-36(s0)
    80002cfa:	fffff097          	auipc	ra,0xfffff
    80002cfe:	fde080e7          	jalr	-34(ra) # 80001cd8 <growproc>
    80002d02:	00054863          	bltz	a0,80002d12 <sys_sbrk+0x44>
    return -1;
  return addr;
}
    80002d06:	8526                	mv	a0,s1
    80002d08:	70a2                	ld	ra,40(sp)
    80002d0a:	7402                	ld	s0,32(sp)
    80002d0c:	64e2                	ld	s1,24(sp)
    80002d0e:	6145                	addi	sp,sp,48
    80002d10:	8082                	ret
    return -1;
    80002d12:	54fd                	li	s1,-1
    80002d14:	bfcd                	j	80002d06 <sys_sbrk+0x38>

0000000080002d16 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d16:	7139                	addi	sp,sp,-64
    80002d18:	fc06                	sd	ra,56(sp)
    80002d1a:	f822                	sd	s0,48(sp)
    80002d1c:	f426                	sd	s1,40(sp)
    80002d1e:	f04a                	sd	s2,32(sp)
    80002d20:	ec4e                	sd	s3,24(sp)
    80002d22:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002d24:	fcc40593          	addi	a1,s0,-52
    80002d28:	4501                	li	a0,0
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	d78080e7          	jalr	-648(ra) # 80002aa2 <argint>
    return -1;
    80002d32:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002d34:	06054563          	bltz	a0,80002d9e <sys_sleep+0x88>
  acquire(&tickslock);
    80002d38:	00014517          	auipc	a0,0x14
    80002d3c:	39850513          	addi	a0,a0,920 # 800170d0 <tickslock>
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	e82080e7          	jalr	-382(ra) # 80000bc2 <acquire>
  ticks0 = ticks;
    80002d48:	00006917          	auipc	s2,0x6
    80002d4c:	2e892903          	lw	s2,744(s2) # 80009030 <ticks>
  while(ticks - ticks0 < n){
    80002d50:	fcc42783          	lw	a5,-52(s0)
    80002d54:	cf85                	beqz	a5,80002d8c <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d56:	00014997          	auipc	s3,0x14
    80002d5a:	37a98993          	addi	s3,s3,890 # 800170d0 <tickslock>
    80002d5e:	00006497          	auipc	s1,0x6
    80002d62:	2d248493          	addi	s1,s1,722 # 80009030 <ticks>
    if(myproc()->killed){
    80002d66:	fffff097          	auipc	ra,0xfffff
    80002d6a:	c18080e7          	jalr	-1000(ra) # 8000197e <myproc>
    80002d6e:	551c                	lw	a5,40(a0)
    80002d70:	ef9d                	bnez	a5,80002dae <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002d72:	85ce                	mv	a1,s3
    80002d74:	8526                	mv	a0,s1
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	2d0080e7          	jalr	720(ra) # 80002046 <sleep>
  while(ticks - ticks0 < n){
    80002d7e:	409c                	lw	a5,0(s1)
    80002d80:	412787bb          	subw	a5,a5,s2
    80002d84:	fcc42703          	lw	a4,-52(s0)
    80002d88:	fce7efe3          	bltu	a5,a4,80002d66 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002d8c:	00014517          	auipc	a0,0x14
    80002d90:	34450513          	addi	a0,a0,836 # 800170d0 <tickslock>
    80002d94:	ffffe097          	auipc	ra,0xffffe
    80002d98:	ee2080e7          	jalr	-286(ra) # 80000c76 <release>
  return 0;
    80002d9c:	4781                	li	a5,0
}
    80002d9e:	853e                	mv	a0,a5
    80002da0:	70e2                	ld	ra,56(sp)
    80002da2:	7442                	ld	s0,48(sp)
    80002da4:	74a2                	ld	s1,40(sp)
    80002da6:	7902                	ld	s2,32(sp)
    80002da8:	69e2                	ld	s3,24(sp)
    80002daa:	6121                	addi	sp,sp,64
    80002dac:	8082                	ret
      release(&tickslock);
    80002dae:	00014517          	auipc	a0,0x14
    80002db2:	32250513          	addi	a0,a0,802 # 800170d0 <tickslock>
    80002db6:	ffffe097          	auipc	ra,0xffffe
    80002dba:	ec0080e7          	jalr	-320(ra) # 80000c76 <release>
      return -1;
    80002dbe:	57fd                	li	a5,-1
    80002dc0:	bff9                	j	80002d9e <sys_sleep+0x88>

0000000080002dc2 <sys_kill>:

uint64
sys_kill(void)
{
    80002dc2:	1101                	addi	sp,sp,-32
    80002dc4:	ec06                	sd	ra,24(sp)
    80002dc6:	e822                	sd	s0,16(sp)
    80002dc8:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002dca:	fec40593          	addi	a1,s0,-20
    80002dce:	4501                	li	a0,0
    80002dd0:	00000097          	auipc	ra,0x0
    80002dd4:	cd2080e7          	jalr	-814(ra) # 80002aa2 <argint>
    80002dd8:	87aa                	mv	a5,a0
    return -1;
    80002dda:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002ddc:	0007c863          	bltz	a5,80002dec <sys_kill+0x2a>
  return kill(pid);
    80002de0:	fec42503          	lw	a0,-20(s0)
    80002de4:	fffff097          	auipc	ra,0xfffff
    80002de8:	594080e7          	jalr	1428(ra) # 80002378 <kill>
}
    80002dec:	60e2                	ld	ra,24(sp)
    80002dee:	6442                	ld	s0,16(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret

0000000080002df4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002dfe:	00014517          	auipc	a0,0x14
    80002e02:	2d250513          	addi	a0,a0,722 # 800170d0 <tickslock>
    80002e06:	ffffe097          	auipc	ra,0xffffe
    80002e0a:	dbc080e7          	jalr	-580(ra) # 80000bc2 <acquire>
  xticks = ticks;
    80002e0e:	00006497          	auipc	s1,0x6
    80002e12:	2224a483          	lw	s1,546(s1) # 80009030 <ticks>
  release(&tickslock);
    80002e16:	00014517          	auipc	a0,0x14
    80002e1a:	2ba50513          	addi	a0,a0,698 # 800170d0 <tickslock>
    80002e1e:	ffffe097          	auipc	ra,0xffffe
    80002e22:	e58080e7          	jalr	-424(ra) # 80000c76 <release>
  return xticks;
}
    80002e26:	02049513          	slli	a0,s1,0x20
    80002e2a:	9101                	srli	a0,a0,0x20
    80002e2c:	60e2                	ld	ra,24(sp)
    80002e2e:	6442                	ld	s0,16(sp)
    80002e30:	64a2                	ld	s1,8(sp)
    80002e32:	6105                	addi	sp,sp,32
    80002e34:	8082                	ret

0000000080002e36 <sys_trace>:
// assignment 1 Task 2 , this is where "the magic happend" (this is the function of trace)
// we copyed the struction of "kill" and build on it
uint64
sys_trace(void)
{
    80002e36:	7179                	addi	sp,sp,-48
    80002e38:	f406                	sd	ra,40(sp)
    80002e3a:	f022                	sd	s0,32(sp)
    80002e3c:	ec26                	sd	s1,24(sp)
    80002e3e:	1800                	addi	s0,sp,48
    int mask;
    int pid;
    return (argint(1 , &pid) < 0) | (argint(0, &mask) < 0 ) ? -1 : trace(mask , pid);
    80002e40:	fd840593          	addi	a1,s0,-40
    80002e44:	4505                	li	a0,1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	c5c080e7          	jalr	-932(ra) # 80002aa2 <argint>
    80002e4e:	84aa                	mv	s1,a0
    80002e50:	fdc40593          	addi	a1,s0,-36
    80002e54:	4501                	li	a0,0
    80002e56:	00000097          	auipc	ra,0x0
    80002e5a:	c4c080e7          	jalr	-948(ra) # 80002aa2 <argint>
    80002e5e:	01f4d49b          	srliw	s1,s1,0x1f
    80002e62:	ec89                	bnez	s1,80002e7c <sys_trace+0x46>
    80002e64:	01f5551b          	srliw	a0,a0,0x1f
    80002e68:	e911                	bnez	a0,80002e7c <sys_trace+0x46>
    80002e6a:	fd842583          	lw	a1,-40(s0)
    80002e6e:	fdc42503          	lw	a0,-36(s0)
    80002e72:	fffff097          	auipc	ra,0xfffff
    80002e76:	6d4080e7          	jalr	1748(ra) # 80002546 <trace>
    80002e7a:	a011                	j	80002e7e <sys_trace+0x48>
    80002e7c:	557d                	li	a0,-1
    80002e7e:	70a2                	ld	ra,40(sp)
    80002e80:	7402                	ld	s0,32(sp)
    80002e82:	64e2                	ld	s1,24(sp)
    80002e84:	6145                	addi	sp,sp,48
    80002e86:	8082                	ret

0000000080002e88 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e88:	7179                	addi	sp,sp,-48
    80002e8a:	f406                	sd	ra,40(sp)
    80002e8c:	f022                	sd	s0,32(sp)
    80002e8e:	ec26                	sd	s1,24(sp)
    80002e90:	e84a                	sd	s2,16(sp)
    80002e92:	e44e                	sd	s3,8(sp)
    80002e94:	e052                	sd	s4,0(sp)
    80002e96:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e98:	00006597          	auipc	a1,0x6
    80002e9c:	80858593          	addi	a1,a1,-2040 # 800086a0 <syscalls_strings+0xb8>
    80002ea0:	00014517          	auipc	a0,0x14
    80002ea4:	24850513          	addi	a0,a0,584 # 800170e8 <bcache>
    80002ea8:	ffffe097          	auipc	ra,0xffffe
    80002eac:	c8a080e7          	jalr	-886(ra) # 80000b32 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002eb0:	0001c797          	auipc	a5,0x1c
    80002eb4:	23878793          	addi	a5,a5,568 # 8001f0e8 <bcache+0x8000>
    80002eb8:	0001c717          	auipc	a4,0x1c
    80002ebc:	49870713          	addi	a4,a4,1176 # 8001f350 <bcache+0x8268>
    80002ec0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ec4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ec8:	00014497          	auipc	s1,0x14
    80002ecc:	23848493          	addi	s1,s1,568 # 80017100 <bcache+0x18>
    b->next = bcache.head.next;
    80002ed0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002ed2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ed4:	00005a17          	auipc	s4,0x5
    80002ed8:	7d4a0a13          	addi	s4,s4,2004 # 800086a8 <syscalls_strings+0xc0>
    b->next = bcache.head.next;
    80002edc:	2b893783          	ld	a5,696(s2)
    80002ee0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ee2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ee6:	85d2                	mv	a1,s4
    80002ee8:	01048513          	addi	a0,s1,16
    80002eec:	00001097          	auipc	ra,0x1
    80002ef0:	4c2080e7          	jalr	1218(ra) # 800043ae <initsleeplock>
    bcache.head.next->prev = b;
    80002ef4:	2b893783          	ld	a5,696(s2)
    80002ef8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002efa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002efe:	45848493          	addi	s1,s1,1112
    80002f02:	fd349de3          	bne	s1,s3,80002edc <binit+0x54>
  }
}
    80002f06:	70a2                	ld	ra,40(sp)
    80002f08:	7402                	ld	s0,32(sp)
    80002f0a:	64e2                	ld	s1,24(sp)
    80002f0c:	6942                	ld	s2,16(sp)
    80002f0e:	69a2                	ld	s3,8(sp)
    80002f10:	6a02                	ld	s4,0(sp)
    80002f12:	6145                	addi	sp,sp,48
    80002f14:	8082                	ret

0000000080002f16 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002f16:	7179                	addi	sp,sp,-48
    80002f18:	f406                	sd	ra,40(sp)
    80002f1a:	f022                	sd	s0,32(sp)
    80002f1c:	ec26                	sd	s1,24(sp)
    80002f1e:	e84a                	sd	s2,16(sp)
    80002f20:	e44e                	sd	s3,8(sp)
    80002f22:	1800                	addi	s0,sp,48
    80002f24:	892a                	mv	s2,a0
    80002f26:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002f28:	00014517          	auipc	a0,0x14
    80002f2c:	1c050513          	addi	a0,a0,448 # 800170e8 <bcache>
    80002f30:	ffffe097          	auipc	ra,0xffffe
    80002f34:	c92080e7          	jalr	-878(ra) # 80000bc2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002f38:	0001c497          	auipc	s1,0x1c
    80002f3c:	4684b483          	ld	s1,1128(s1) # 8001f3a0 <bcache+0x82b8>
    80002f40:	0001c797          	auipc	a5,0x1c
    80002f44:	41078793          	addi	a5,a5,1040 # 8001f350 <bcache+0x8268>
    80002f48:	02f48f63          	beq	s1,a5,80002f86 <bread+0x70>
    80002f4c:	873e                	mv	a4,a5
    80002f4e:	a021                	j	80002f56 <bread+0x40>
    80002f50:	68a4                	ld	s1,80(s1)
    80002f52:	02e48a63          	beq	s1,a4,80002f86 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002f56:	449c                	lw	a5,8(s1)
    80002f58:	ff279ce3          	bne	a5,s2,80002f50 <bread+0x3a>
    80002f5c:	44dc                	lw	a5,12(s1)
    80002f5e:	ff3799e3          	bne	a5,s3,80002f50 <bread+0x3a>
      b->refcnt++;
    80002f62:	40bc                	lw	a5,64(s1)
    80002f64:	2785                	addiw	a5,a5,1
    80002f66:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f68:	00014517          	auipc	a0,0x14
    80002f6c:	18050513          	addi	a0,a0,384 # 800170e8 <bcache>
    80002f70:	ffffe097          	auipc	ra,0xffffe
    80002f74:	d06080e7          	jalr	-762(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80002f78:	01048513          	addi	a0,s1,16
    80002f7c:	00001097          	auipc	ra,0x1
    80002f80:	46c080e7          	jalr	1132(ra) # 800043e8 <acquiresleep>
      return b;
    80002f84:	a8b9                	j	80002fe2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f86:	0001c497          	auipc	s1,0x1c
    80002f8a:	4124b483          	ld	s1,1042(s1) # 8001f398 <bcache+0x82b0>
    80002f8e:	0001c797          	auipc	a5,0x1c
    80002f92:	3c278793          	addi	a5,a5,962 # 8001f350 <bcache+0x8268>
    80002f96:	00f48863          	beq	s1,a5,80002fa6 <bread+0x90>
    80002f9a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f9c:	40bc                	lw	a5,64(s1)
    80002f9e:	cf81                	beqz	a5,80002fb6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002fa0:	64a4                	ld	s1,72(s1)
    80002fa2:	fee49de3          	bne	s1,a4,80002f9c <bread+0x86>
  panic("bget: no buffers");
    80002fa6:	00005517          	auipc	a0,0x5
    80002faa:	70a50513          	addi	a0,a0,1802 # 800086b0 <syscalls_strings+0xc8>
    80002fae:	ffffd097          	auipc	ra,0xffffd
    80002fb2:	57c080e7          	jalr	1404(ra) # 8000052a <panic>
      b->dev = dev;
    80002fb6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002fba:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002fbe:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002fc2:	4785                	li	a5,1
    80002fc4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002fc6:	00014517          	auipc	a0,0x14
    80002fca:	12250513          	addi	a0,a0,290 # 800170e8 <bcache>
    80002fce:	ffffe097          	auipc	ra,0xffffe
    80002fd2:	ca8080e7          	jalr	-856(ra) # 80000c76 <release>
      acquiresleep(&b->lock);
    80002fd6:	01048513          	addi	a0,s1,16
    80002fda:	00001097          	auipc	ra,0x1
    80002fde:	40e080e7          	jalr	1038(ra) # 800043e8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002fe2:	409c                	lw	a5,0(s1)
    80002fe4:	cb89                	beqz	a5,80002ff6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002fe6:	8526                	mv	a0,s1
    80002fe8:	70a2                	ld	ra,40(sp)
    80002fea:	7402                	ld	s0,32(sp)
    80002fec:	64e2                	ld	s1,24(sp)
    80002fee:	6942                	ld	s2,16(sp)
    80002ff0:	69a2                	ld	s3,8(sp)
    80002ff2:	6145                	addi	sp,sp,48
    80002ff4:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ff6:	4581                	li	a1,0
    80002ff8:	8526                	mv	a0,s1
    80002ffa:	00003097          	auipc	ra,0x3
    80002ffe:	f1c080e7          	jalr	-228(ra) # 80005f16 <virtio_disk_rw>
    b->valid = 1;
    80003002:	4785                	li	a5,1
    80003004:	c09c                	sw	a5,0(s1)
  return b;
    80003006:	b7c5                	j	80002fe6 <bread+0xd0>

0000000080003008 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003008:	1101                	addi	sp,sp,-32
    8000300a:	ec06                	sd	ra,24(sp)
    8000300c:	e822                	sd	s0,16(sp)
    8000300e:	e426                	sd	s1,8(sp)
    80003010:	1000                	addi	s0,sp,32
    80003012:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003014:	0541                	addi	a0,a0,16
    80003016:	00001097          	auipc	ra,0x1
    8000301a:	46c080e7          	jalr	1132(ra) # 80004482 <holdingsleep>
    8000301e:	cd01                	beqz	a0,80003036 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003020:	4585                	li	a1,1
    80003022:	8526                	mv	a0,s1
    80003024:	00003097          	auipc	ra,0x3
    80003028:	ef2080e7          	jalr	-270(ra) # 80005f16 <virtio_disk_rw>
}
    8000302c:	60e2                	ld	ra,24(sp)
    8000302e:	6442                	ld	s0,16(sp)
    80003030:	64a2                	ld	s1,8(sp)
    80003032:	6105                	addi	sp,sp,32
    80003034:	8082                	ret
    panic("bwrite");
    80003036:	00005517          	auipc	a0,0x5
    8000303a:	69250513          	addi	a0,a0,1682 # 800086c8 <syscalls_strings+0xe0>
    8000303e:	ffffd097          	auipc	ra,0xffffd
    80003042:	4ec080e7          	jalr	1260(ra) # 8000052a <panic>

0000000080003046 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003046:	1101                	addi	sp,sp,-32
    80003048:	ec06                	sd	ra,24(sp)
    8000304a:	e822                	sd	s0,16(sp)
    8000304c:	e426                	sd	s1,8(sp)
    8000304e:	e04a                	sd	s2,0(sp)
    80003050:	1000                	addi	s0,sp,32
    80003052:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003054:	01050913          	addi	s2,a0,16
    80003058:	854a                	mv	a0,s2
    8000305a:	00001097          	auipc	ra,0x1
    8000305e:	428080e7          	jalr	1064(ra) # 80004482 <holdingsleep>
    80003062:	c92d                	beqz	a0,800030d4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80003064:	854a                	mv	a0,s2
    80003066:	00001097          	auipc	ra,0x1
    8000306a:	3d8080e7          	jalr	984(ra) # 8000443e <releasesleep>

  acquire(&bcache.lock);
    8000306e:	00014517          	auipc	a0,0x14
    80003072:	07a50513          	addi	a0,a0,122 # 800170e8 <bcache>
    80003076:	ffffe097          	auipc	ra,0xffffe
    8000307a:	b4c080e7          	jalr	-1204(ra) # 80000bc2 <acquire>
  b->refcnt--;
    8000307e:	40bc                	lw	a5,64(s1)
    80003080:	37fd                	addiw	a5,a5,-1
    80003082:	0007871b          	sext.w	a4,a5
    80003086:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003088:	eb05                	bnez	a4,800030b8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000308a:	68bc                	ld	a5,80(s1)
    8000308c:	64b8                	ld	a4,72(s1)
    8000308e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80003090:	64bc                	ld	a5,72(s1)
    80003092:	68b8                	ld	a4,80(s1)
    80003094:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003096:	0001c797          	auipc	a5,0x1c
    8000309a:	05278793          	addi	a5,a5,82 # 8001f0e8 <bcache+0x8000>
    8000309e:	2b87b703          	ld	a4,696(a5)
    800030a2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800030a4:	0001c717          	auipc	a4,0x1c
    800030a8:	2ac70713          	addi	a4,a4,684 # 8001f350 <bcache+0x8268>
    800030ac:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800030ae:	2b87b703          	ld	a4,696(a5)
    800030b2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800030b4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800030b8:	00014517          	auipc	a0,0x14
    800030bc:	03050513          	addi	a0,a0,48 # 800170e8 <bcache>
    800030c0:	ffffe097          	auipc	ra,0xffffe
    800030c4:	bb6080e7          	jalr	-1098(ra) # 80000c76 <release>
}
    800030c8:	60e2                	ld	ra,24(sp)
    800030ca:	6442                	ld	s0,16(sp)
    800030cc:	64a2                	ld	s1,8(sp)
    800030ce:	6902                	ld	s2,0(sp)
    800030d0:	6105                	addi	sp,sp,32
    800030d2:	8082                	ret
    panic("brelse");
    800030d4:	00005517          	auipc	a0,0x5
    800030d8:	5fc50513          	addi	a0,a0,1532 # 800086d0 <syscalls_strings+0xe8>
    800030dc:	ffffd097          	auipc	ra,0xffffd
    800030e0:	44e080e7          	jalr	1102(ra) # 8000052a <panic>

00000000800030e4 <bpin>:

void
bpin(struct buf *b) {
    800030e4:	1101                	addi	sp,sp,-32
    800030e6:	ec06                	sd	ra,24(sp)
    800030e8:	e822                	sd	s0,16(sp)
    800030ea:	e426                	sd	s1,8(sp)
    800030ec:	1000                	addi	s0,sp,32
    800030ee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030f0:	00014517          	auipc	a0,0x14
    800030f4:	ff850513          	addi	a0,a0,-8 # 800170e8 <bcache>
    800030f8:	ffffe097          	auipc	ra,0xffffe
    800030fc:	aca080e7          	jalr	-1334(ra) # 80000bc2 <acquire>
  b->refcnt++;
    80003100:	40bc                	lw	a5,64(s1)
    80003102:	2785                	addiw	a5,a5,1
    80003104:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003106:	00014517          	auipc	a0,0x14
    8000310a:	fe250513          	addi	a0,a0,-30 # 800170e8 <bcache>
    8000310e:	ffffe097          	auipc	ra,0xffffe
    80003112:	b68080e7          	jalr	-1176(ra) # 80000c76 <release>
}
    80003116:	60e2                	ld	ra,24(sp)
    80003118:	6442                	ld	s0,16(sp)
    8000311a:	64a2                	ld	s1,8(sp)
    8000311c:	6105                	addi	sp,sp,32
    8000311e:	8082                	ret

0000000080003120 <bunpin>:

void
bunpin(struct buf *b) {
    80003120:	1101                	addi	sp,sp,-32
    80003122:	ec06                	sd	ra,24(sp)
    80003124:	e822                	sd	s0,16(sp)
    80003126:	e426                	sd	s1,8(sp)
    80003128:	1000                	addi	s0,sp,32
    8000312a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000312c:	00014517          	auipc	a0,0x14
    80003130:	fbc50513          	addi	a0,a0,-68 # 800170e8 <bcache>
    80003134:	ffffe097          	auipc	ra,0xffffe
    80003138:	a8e080e7          	jalr	-1394(ra) # 80000bc2 <acquire>
  b->refcnt--;
    8000313c:	40bc                	lw	a5,64(s1)
    8000313e:	37fd                	addiw	a5,a5,-1
    80003140:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003142:	00014517          	auipc	a0,0x14
    80003146:	fa650513          	addi	a0,a0,-90 # 800170e8 <bcache>
    8000314a:	ffffe097          	auipc	ra,0xffffe
    8000314e:	b2c080e7          	jalr	-1236(ra) # 80000c76 <release>
}
    80003152:	60e2                	ld	ra,24(sp)
    80003154:	6442                	ld	s0,16(sp)
    80003156:	64a2                	ld	s1,8(sp)
    80003158:	6105                	addi	sp,sp,32
    8000315a:	8082                	ret

000000008000315c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000315c:	1101                	addi	sp,sp,-32
    8000315e:	ec06                	sd	ra,24(sp)
    80003160:	e822                	sd	s0,16(sp)
    80003162:	e426                	sd	s1,8(sp)
    80003164:	e04a                	sd	s2,0(sp)
    80003166:	1000                	addi	s0,sp,32
    80003168:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000316a:	00d5d59b          	srliw	a1,a1,0xd
    8000316e:	0001c797          	auipc	a5,0x1c
    80003172:	6567a783          	lw	a5,1622(a5) # 8001f7c4 <sb+0x1c>
    80003176:	9dbd                	addw	a1,a1,a5
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	d9e080e7          	jalr	-610(ra) # 80002f16 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003180:	0074f713          	andi	a4,s1,7
    80003184:	4785                	li	a5,1
    80003186:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000318a:	14ce                	slli	s1,s1,0x33
    8000318c:	90d9                	srli	s1,s1,0x36
    8000318e:	00950733          	add	a4,a0,s1
    80003192:	05874703          	lbu	a4,88(a4)
    80003196:	00e7f6b3          	and	a3,a5,a4
    8000319a:	c69d                	beqz	a3,800031c8 <bfree+0x6c>
    8000319c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000319e:	94aa                	add	s1,s1,a0
    800031a0:	fff7c793          	not	a5,a5
    800031a4:	8ff9                	and	a5,a5,a4
    800031a6:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800031aa:	00001097          	auipc	ra,0x1
    800031ae:	11e080e7          	jalr	286(ra) # 800042c8 <log_write>
  brelse(bp);
    800031b2:	854a                	mv	a0,s2
    800031b4:	00000097          	auipc	ra,0x0
    800031b8:	e92080e7          	jalr	-366(ra) # 80003046 <brelse>
}
    800031bc:	60e2                	ld	ra,24(sp)
    800031be:	6442                	ld	s0,16(sp)
    800031c0:	64a2                	ld	s1,8(sp)
    800031c2:	6902                	ld	s2,0(sp)
    800031c4:	6105                	addi	sp,sp,32
    800031c6:	8082                	ret
    panic("freeing free block");
    800031c8:	00005517          	auipc	a0,0x5
    800031cc:	51050513          	addi	a0,a0,1296 # 800086d8 <syscalls_strings+0xf0>
    800031d0:	ffffd097          	auipc	ra,0xffffd
    800031d4:	35a080e7          	jalr	858(ra) # 8000052a <panic>

00000000800031d8 <balloc>:
{
    800031d8:	711d                	addi	sp,sp,-96
    800031da:	ec86                	sd	ra,88(sp)
    800031dc:	e8a2                	sd	s0,80(sp)
    800031de:	e4a6                	sd	s1,72(sp)
    800031e0:	e0ca                	sd	s2,64(sp)
    800031e2:	fc4e                	sd	s3,56(sp)
    800031e4:	f852                	sd	s4,48(sp)
    800031e6:	f456                	sd	s5,40(sp)
    800031e8:	f05a                	sd	s6,32(sp)
    800031ea:	ec5e                	sd	s7,24(sp)
    800031ec:	e862                	sd	s8,16(sp)
    800031ee:	e466                	sd	s9,8(sp)
    800031f0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800031f2:	0001c797          	auipc	a5,0x1c
    800031f6:	5ba7a783          	lw	a5,1466(a5) # 8001f7ac <sb+0x4>
    800031fa:	cbd1                	beqz	a5,8000328e <balloc+0xb6>
    800031fc:	8baa                	mv	s7,a0
    800031fe:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003200:	0001cb17          	auipc	s6,0x1c
    80003204:	5a8b0b13          	addi	s6,s6,1448 # 8001f7a8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003208:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    8000320a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000320c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000320e:	6c89                	lui	s9,0x2
    80003210:	a831                	j	8000322c <balloc+0x54>
    brelse(bp);
    80003212:	854a                	mv	a0,s2
    80003214:	00000097          	auipc	ra,0x0
    80003218:	e32080e7          	jalr	-462(ra) # 80003046 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000321c:	015c87bb          	addw	a5,s9,s5
    80003220:	00078a9b          	sext.w	s5,a5
    80003224:	004b2703          	lw	a4,4(s6)
    80003228:	06eaf363          	bgeu	s5,a4,8000328e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000322c:	41fad79b          	sraiw	a5,s5,0x1f
    80003230:	0137d79b          	srliw	a5,a5,0x13
    80003234:	015787bb          	addw	a5,a5,s5
    80003238:	40d7d79b          	sraiw	a5,a5,0xd
    8000323c:	01cb2583          	lw	a1,28(s6)
    80003240:	9dbd                	addw	a1,a1,a5
    80003242:	855e                	mv	a0,s7
    80003244:	00000097          	auipc	ra,0x0
    80003248:	cd2080e7          	jalr	-814(ra) # 80002f16 <bread>
    8000324c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000324e:	004b2503          	lw	a0,4(s6)
    80003252:	000a849b          	sext.w	s1,s5
    80003256:	8662                	mv	a2,s8
    80003258:	faa4fde3          	bgeu	s1,a0,80003212 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000325c:	41f6579b          	sraiw	a5,a2,0x1f
    80003260:	01d7d69b          	srliw	a3,a5,0x1d
    80003264:	00c6873b          	addw	a4,a3,a2
    80003268:	00777793          	andi	a5,a4,7
    8000326c:	9f95                	subw	a5,a5,a3
    8000326e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003272:	4037571b          	sraiw	a4,a4,0x3
    80003276:	00e906b3          	add	a3,s2,a4
    8000327a:	0586c683          	lbu	a3,88(a3)
    8000327e:	00d7f5b3          	and	a1,a5,a3
    80003282:	cd91                	beqz	a1,8000329e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003284:	2605                	addiw	a2,a2,1
    80003286:	2485                	addiw	s1,s1,1
    80003288:	fd4618e3          	bne	a2,s4,80003258 <balloc+0x80>
    8000328c:	b759                	j	80003212 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000328e:	00005517          	auipc	a0,0x5
    80003292:	46250513          	addi	a0,a0,1122 # 800086f0 <syscalls_strings+0x108>
    80003296:	ffffd097          	auipc	ra,0xffffd
    8000329a:	294080e7          	jalr	660(ra) # 8000052a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000329e:	974a                	add	a4,a4,s2
    800032a0:	8fd5                	or	a5,a5,a3
    800032a2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800032a6:	854a                	mv	a0,s2
    800032a8:	00001097          	auipc	ra,0x1
    800032ac:	020080e7          	jalr	32(ra) # 800042c8 <log_write>
        brelse(bp);
    800032b0:	854a                	mv	a0,s2
    800032b2:	00000097          	auipc	ra,0x0
    800032b6:	d94080e7          	jalr	-620(ra) # 80003046 <brelse>
  bp = bread(dev, bno);
    800032ba:	85a6                	mv	a1,s1
    800032bc:	855e                	mv	a0,s7
    800032be:	00000097          	auipc	ra,0x0
    800032c2:	c58080e7          	jalr	-936(ra) # 80002f16 <bread>
    800032c6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800032c8:	40000613          	li	a2,1024
    800032cc:	4581                	li	a1,0
    800032ce:	05850513          	addi	a0,a0,88
    800032d2:	ffffe097          	auipc	ra,0xffffe
    800032d6:	9ec080e7          	jalr	-1556(ra) # 80000cbe <memset>
  log_write(bp);
    800032da:	854a                	mv	a0,s2
    800032dc:	00001097          	auipc	ra,0x1
    800032e0:	fec080e7          	jalr	-20(ra) # 800042c8 <log_write>
  brelse(bp);
    800032e4:	854a                	mv	a0,s2
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	d60080e7          	jalr	-672(ra) # 80003046 <brelse>
}
    800032ee:	8526                	mv	a0,s1
    800032f0:	60e6                	ld	ra,88(sp)
    800032f2:	6446                	ld	s0,80(sp)
    800032f4:	64a6                	ld	s1,72(sp)
    800032f6:	6906                	ld	s2,64(sp)
    800032f8:	79e2                	ld	s3,56(sp)
    800032fa:	7a42                	ld	s4,48(sp)
    800032fc:	7aa2                	ld	s5,40(sp)
    800032fe:	7b02                	ld	s6,32(sp)
    80003300:	6be2                	ld	s7,24(sp)
    80003302:	6c42                	ld	s8,16(sp)
    80003304:	6ca2                	ld	s9,8(sp)
    80003306:	6125                	addi	sp,sp,96
    80003308:	8082                	ret

000000008000330a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000330a:	7179                	addi	sp,sp,-48
    8000330c:	f406                	sd	ra,40(sp)
    8000330e:	f022                	sd	s0,32(sp)
    80003310:	ec26                	sd	s1,24(sp)
    80003312:	e84a                	sd	s2,16(sp)
    80003314:	e44e                	sd	s3,8(sp)
    80003316:	e052                	sd	s4,0(sp)
    80003318:	1800                	addi	s0,sp,48
    8000331a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000331c:	47ad                	li	a5,11
    8000331e:	04b7fe63          	bgeu	a5,a1,8000337a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003322:	ff45849b          	addiw	s1,a1,-12
    80003326:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000332a:	0ff00793          	li	a5,255
    8000332e:	0ae7e463          	bltu	a5,a4,800033d6 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003332:	08052583          	lw	a1,128(a0)
    80003336:	c5b5                	beqz	a1,800033a2 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003338:	00092503          	lw	a0,0(s2)
    8000333c:	00000097          	auipc	ra,0x0
    80003340:	bda080e7          	jalr	-1062(ra) # 80002f16 <bread>
    80003344:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003346:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000334a:	02049713          	slli	a4,s1,0x20
    8000334e:	01e75593          	srli	a1,a4,0x1e
    80003352:	00b784b3          	add	s1,a5,a1
    80003356:	0004a983          	lw	s3,0(s1)
    8000335a:	04098e63          	beqz	s3,800033b6 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000335e:	8552                	mv	a0,s4
    80003360:	00000097          	auipc	ra,0x0
    80003364:	ce6080e7          	jalr	-794(ra) # 80003046 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003368:	854e                	mv	a0,s3
    8000336a:	70a2                	ld	ra,40(sp)
    8000336c:	7402                	ld	s0,32(sp)
    8000336e:	64e2                	ld	s1,24(sp)
    80003370:	6942                	ld	s2,16(sp)
    80003372:	69a2                	ld	s3,8(sp)
    80003374:	6a02                	ld	s4,0(sp)
    80003376:	6145                	addi	sp,sp,48
    80003378:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000337a:	02059793          	slli	a5,a1,0x20
    8000337e:	01e7d593          	srli	a1,a5,0x1e
    80003382:	00b504b3          	add	s1,a0,a1
    80003386:	0504a983          	lw	s3,80(s1)
    8000338a:	fc099fe3          	bnez	s3,80003368 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000338e:	4108                	lw	a0,0(a0)
    80003390:	00000097          	auipc	ra,0x0
    80003394:	e48080e7          	jalr	-440(ra) # 800031d8 <balloc>
    80003398:	0005099b          	sext.w	s3,a0
    8000339c:	0534a823          	sw	s3,80(s1)
    800033a0:	b7e1                	j	80003368 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800033a2:	4108                	lw	a0,0(a0)
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	e34080e7          	jalr	-460(ra) # 800031d8 <balloc>
    800033ac:	0005059b          	sext.w	a1,a0
    800033b0:	08b92023          	sw	a1,128(s2)
    800033b4:	b751                	j	80003338 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800033b6:	00092503          	lw	a0,0(s2)
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	e1e080e7          	jalr	-482(ra) # 800031d8 <balloc>
    800033c2:	0005099b          	sext.w	s3,a0
    800033c6:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800033ca:	8552                	mv	a0,s4
    800033cc:	00001097          	auipc	ra,0x1
    800033d0:	efc080e7          	jalr	-260(ra) # 800042c8 <log_write>
    800033d4:	b769                	j	8000335e <bmap+0x54>
  panic("bmap: out of range");
    800033d6:	00005517          	auipc	a0,0x5
    800033da:	33250513          	addi	a0,a0,818 # 80008708 <syscalls_strings+0x120>
    800033de:	ffffd097          	auipc	ra,0xffffd
    800033e2:	14c080e7          	jalr	332(ra) # 8000052a <panic>

00000000800033e6 <iget>:
{
    800033e6:	7179                	addi	sp,sp,-48
    800033e8:	f406                	sd	ra,40(sp)
    800033ea:	f022                	sd	s0,32(sp)
    800033ec:	ec26                	sd	s1,24(sp)
    800033ee:	e84a                	sd	s2,16(sp)
    800033f0:	e44e                	sd	s3,8(sp)
    800033f2:	e052                	sd	s4,0(sp)
    800033f4:	1800                	addi	s0,sp,48
    800033f6:	89aa                	mv	s3,a0
    800033f8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800033fa:	0001c517          	auipc	a0,0x1c
    800033fe:	3ce50513          	addi	a0,a0,974 # 8001f7c8 <itable>
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	7c0080e7          	jalr	1984(ra) # 80000bc2 <acquire>
  empty = 0;
    8000340a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000340c:	0001c497          	auipc	s1,0x1c
    80003410:	3d448493          	addi	s1,s1,980 # 8001f7e0 <itable+0x18>
    80003414:	0001e697          	auipc	a3,0x1e
    80003418:	e5c68693          	addi	a3,a3,-420 # 80021270 <log>
    8000341c:	a039                	j	8000342a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000341e:	02090b63          	beqz	s2,80003454 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003422:	08848493          	addi	s1,s1,136
    80003426:	02d48a63          	beq	s1,a3,8000345a <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000342a:	449c                	lw	a5,8(s1)
    8000342c:	fef059e3          	blez	a5,8000341e <iget+0x38>
    80003430:	4098                	lw	a4,0(s1)
    80003432:	ff3716e3          	bne	a4,s3,8000341e <iget+0x38>
    80003436:	40d8                	lw	a4,4(s1)
    80003438:	ff4713e3          	bne	a4,s4,8000341e <iget+0x38>
      ip->ref++;
    8000343c:	2785                	addiw	a5,a5,1
    8000343e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003440:	0001c517          	auipc	a0,0x1c
    80003444:	38850513          	addi	a0,a0,904 # 8001f7c8 <itable>
    80003448:	ffffe097          	auipc	ra,0xffffe
    8000344c:	82e080e7          	jalr	-2002(ra) # 80000c76 <release>
      return ip;
    80003450:	8926                	mv	s2,s1
    80003452:	a03d                	j	80003480 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003454:	f7f9                	bnez	a5,80003422 <iget+0x3c>
    80003456:	8926                	mv	s2,s1
    80003458:	b7e9                	j	80003422 <iget+0x3c>
  if(empty == 0)
    8000345a:	02090c63          	beqz	s2,80003492 <iget+0xac>
  ip->dev = dev;
    8000345e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003462:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003466:	4785                	li	a5,1
    80003468:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000346c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003470:	0001c517          	auipc	a0,0x1c
    80003474:	35850513          	addi	a0,a0,856 # 8001f7c8 <itable>
    80003478:	ffffd097          	auipc	ra,0xffffd
    8000347c:	7fe080e7          	jalr	2046(ra) # 80000c76 <release>
}
    80003480:	854a                	mv	a0,s2
    80003482:	70a2                	ld	ra,40(sp)
    80003484:	7402                	ld	s0,32(sp)
    80003486:	64e2                	ld	s1,24(sp)
    80003488:	6942                	ld	s2,16(sp)
    8000348a:	69a2                	ld	s3,8(sp)
    8000348c:	6a02                	ld	s4,0(sp)
    8000348e:	6145                	addi	sp,sp,48
    80003490:	8082                	ret
    panic("iget: no inodes");
    80003492:	00005517          	auipc	a0,0x5
    80003496:	28e50513          	addi	a0,a0,654 # 80008720 <syscalls_strings+0x138>
    8000349a:	ffffd097          	auipc	ra,0xffffd
    8000349e:	090080e7          	jalr	144(ra) # 8000052a <panic>

00000000800034a2 <fsinit>:
fsinit(int dev) {
    800034a2:	7179                	addi	sp,sp,-48
    800034a4:	f406                	sd	ra,40(sp)
    800034a6:	f022                	sd	s0,32(sp)
    800034a8:	ec26                	sd	s1,24(sp)
    800034aa:	e84a                	sd	s2,16(sp)
    800034ac:	e44e                	sd	s3,8(sp)
    800034ae:	1800                	addi	s0,sp,48
    800034b0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800034b2:	4585                	li	a1,1
    800034b4:	00000097          	auipc	ra,0x0
    800034b8:	a62080e7          	jalr	-1438(ra) # 80002f16 <bread>
    800034bc:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800034be:	0001c997          	auipc	s3,0x1c
    800034c2:	2ea98993          	addi	s3,s3,746 # 8001f7a8 <sb>
    800034c6:	02000613          	li	a2,32
    800034ca:	05850593          	addi	a1,a0,88
    800034ce:	854e                	mv	a0,s3
    800034d0:	ffffe097          	auipc	ra,0xffffe
    800034d4:	84a080e7          	jalr	-1974(ra) # 80000d1a <memmove>
  brelse(bp);
    800034d8:	8526                	mv	a0,s1
    800034da:	00000097          	auipc	ra,0x0
    800034de:	b6c080e7          	jalr	-1172(ra) # 80003046 <brelse>
  if(sb.magic != FSMAGIC)
    800034e2:	0009a703          	lw	a4,0(s3)
    800034e6:	102037b7          	lui	a5,0x10203
    800034ea:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800034ee:	02f71263          	bne	a4,a5,80003512 <fsinit+0x70>
  initlog(dev, &sb);
    800034f2:	0001c597          	auipc	a1,0x1c
    800034f6:	2b658593          	addi	a1,a1,694 # 8001f7a8 <sb>
    800034fa:	854a                	mv	a0,s2
    800034fc:	00001097          	auipc	ra,0x1
    80003500:	b4e080e7          	jalr	-1202(ra) # 8000404a <initlog>
}
    80003504:	70a2                	ld	ra,40(sp)
    80003506:	7402                	ld	s0,32(sp)
    80003508:	64e2                	ld	s1,24(sp)
    8000350a:	6942                	ld	s2,16(sp)
    8000350c:	69a2                	ld	s3,8(sp)
    8000350e:	6145                	addi	sp,sp,48
    80003510:	8082                	ret
    panic("invalid file system");
    80003512:	00005517          	auipc	a0,0x5
    80003516:	21e50513          	addi	a0,a0,542 # 80008730 <syscalls_strings+0x148>
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	010080e7          	jalr	16(ra) # 8000052a <panic>

0000000080003522 <iinit>:
{
    80003522:	7179                	addi	sp,sp,-48
    80003524:	f406                	sd	ra,40(sp)
    80003526:	f022                	sd	s0,32(sp)
    80003528:	ec26                	sd	s1,24(sp)
    8000352a:	e84a                	sd	s2,16(sp)
    8000352c:	e44e                	sd	s3,8(sp)
    8000352e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003530:	00005597          	auipc	a1,0x5
    80003534:	21858593          	addi	a1,a1,536 # 80008748 <syscalls_strings+0x160>
    80003538:	0001c517          	auipc	a0,0x1c
    8000353c:	29050513          	addi	a0,a0,656 # 8001f7c8 <itable>
    80003540:	ffffd097          	auipc	ra,0xffffd
    80003544:	5f2080e7          	jalr	1522(ra) # 80000b32 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003548:	0001c497          	auipc	s1,0x1c
    8000354c:	2a848493          	addi	s1,s1,680 # 8001f7f0 <itable+0x28>
    80003550:	0001e997          	auipc	s3,0x1e
    80003554:	d3098993          	addi	s3,s3,-720 # 80021280 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003558:	00005917          	auipc	s2,0x5
    8000355c:	1f890913          	addi	s2,s2,504 # 80008750 <syscalls_strings+0x168>
    80003560:	85ca                	mv	a1,s2
    80003562:	8526                	mv	a0,s1
    80003564:	00001097          	auipc	ra,0x1
    80003568:	e4a080e7          	jalr	-438(ra) # 800043ae <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000356c:	08848493          	addi	s1,s1,136
    80003570:	ff3498e3          	bne	s1,s3,80003560 <iinit+0x3e>
}
    80003574:	70a2                	ld	ra,40(sp)
    80003576:	7402                	ld	s0,32(sp)
    80003578:	64e2                	ld	s1,24(sp)
    8000357a:	6942                	ld	s2,16(sp)
    8000357c:	69a2                	ld	s3,8(sp)
    8000357e:	6145                	addi	sp,sp,48
    80003580:	8082                	ret

0000000080003582 <ialloc>:
{
    80003582:	715d                	addi	sp,sp,-80
    80003584:	e486                	sd	ra,72(sp)
    80003586:	e0a2                	sd	s0,64(sp)
    80003588:	fc26                	sd	s1,56(sp)
    8000358a:	f84a                	sd	s2,48(sp)
    8000358c:	f44e                	sd	s3,40(sp)
    8000358e:	f052                	sd	s4,32(sp)
    80003590:	ec56                	sd	s5,24(sp)
    80003592:	e85a                	sd	s6,16(sp)
    80003594:	e45e                	sd	s7,8(sp)
    80003596:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003598:	0001c717          	auipc	a4,0x1c
    8000359c:	21c72703          	lw	a4,540(a4) # 8001f7b4 <sb+0xc>
    800035a0:	4785                	li	a5,1
    800035a2:	04e7fa63          	bgeu	a5,a4,800035f6 <ialloc+0x74>
    800035a6:	8aaa                	mv	s5,a0
    800035a8:	8bae                	mv	s7,a1
    800035aa:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    800035ac:	0001ca17          	auipc	s4,0x1c
    800035b0:	1fca0a13          	addi	s4,s4,508 # 8001f7a8 <sb>
    800035b4:	00048b1b          	sext.w	s6,s1
    800035b8:	0044d793          	srli	a5,s1,0x4
    800035bc:	018a2583          	lw	a1,24(s4)
    800035c0:	9dbd                	addw	a1,a1,a5
    800035c2:	8556                	mv	a0,s5
    800035c4:	00000097          	auipc	ra,0x0
    800035c8:	952080e7          	jalr	-1710(ra) # 80002f16 <bread>
    800035cc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800035ce:	05850993          	addi	s3,a0,88
    800035d2:	00f4f793          	andi	a5,s1,15
    800035d6:	079a                	slli	a5,a5,0x6
    800035d8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800035da:	00099783          	lh	a5,0(s3)
    800035de:	c785                	beqz	a5,80003606 <ialloc+0x84>
    brelse(bp);
    800035e0:	00000097          	auipc	ra,0x0
    800035e4:	a66080e7          	jalr	-1434(ra) # 80003046 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800035e8:	0485                	addi	s1,s1,1
    800035ea:	00ca2703          	lw	a4,12(s4)
    800035ee:	0004879b          	sext.w	a5,s1
    800035f2:	fce7e1e3          	bltu	a5,a4,800035b4 <ialloc+0x32>
  panic("ialloc: no inodes");
    800035f6:	00005517          	auipc	a0,0x5
    800035fa:	16250513          	addi	a0,a0,354 # 80008758 <syscalls_strings+0x170>
    800035fe:	ffffd097          	auipc	ra,0xffffd
    80003602:	f2c080e7          	jalr	-212(ra) # 8000052a <panic>
      memset(dip, 0, sizeof(*dip));
    80003606:	04000613          	li	a2,64
    8000360a:	4581                	li	a1,0
    8000360c:	854e                	mv	a0,s3
    8000360e:	ffffd097          	auipc	ra,0xffffd
    80003612:	6b0080e7          	jalr	1712(ra) # 80000cbe <memset>
      dip->type = type;
    80003616:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000361a:	854a                	mv	a0,s2
    8000361c:	00001097          	auipc	ra,0x1
    80003620:	cac080e7          	jalr	-852(ra) # 800042c8 <log_write>
      brelse(bp);
    80003624:	854a                	mv	a0,s2
    80003626:	00000097          	auipc	ra,0x0
    8000362a:	a20080e7          	jalr	-1504(ra) # 80003046 <brelse>
      return iget(dev, inum);
    8000362e:	85da                	mv	a1,s6
    80003630:	8556                	mv	a0,s5
    80003632:	00000097          	auipc	ra,0x0
    80003636:	db4080e7          	jalr	-588(ra) # 800033e6 <iget>
}
    8000363a:	60a6                	ld	ra,72(sp)
    8000363c:	6406                	ld	s0,64(sp)
    8000363e:	74e2                	ld	s1,56(sp)
    80003640:	7942                	ld	s2,48(sp)
    80003642:	79a2                	ld	s3,40(sp)
    80003644:	7a02                	ld	s4,32(sp)
    80003646:	6ae2                	ld	s5,24(sp)
    80003648:	6b42                	ld	s6,16(sp)
    8000364a:	6ba2                	ld	s7,8(sp)
    8000364c:	6161                	addi	sp,sp,80
    8000364e:	8082                	ret

0000000080003650 <iupdate>:
{
    80003650:	1101                	addi	sp,sp,-32
    80003652:	ec06                	sd	ra,24(sp)
    80003654:	e822                	sd	s0,16(sp)
    80003656:	e426                	sd	s1,8(sp)
    80003658:	e04a                	sd	s2,0(sp)
    8000365a:	1000                	addi	s0,sp,32
    8000365c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000365e:	415c                	lw	a5,4(a0)
    80003660:	0047d79b          	srliw	a5,a5,0x4
    80003664:	0001c597          	auipc	a1,0x1c
    80003668:	15c5a583          	lw	a1,348(a1) # 8001f7c0 <sb+0x18>
    8000366c:	9dbd                	addw	a1,a1,a5
    8000366e:	4108                	lw	a0,0(a0)
    80003670:	00000097          	auipc	ra,0x0
    80003674:	8a6080e7          	jalr	-1882(ra) # 80002f16 <bread>
    80003678:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000367a:	05850793          	addi	a5,a0,88
    8000367e:	40c8                	lw	a0,4(s1)
    80003680:	893d                	andi	a0,a0,15
    80003682:	051a                	slli	a0,a0,0x6
    80003684:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003686:	04449703          	lh	a4,68(s1)
    8000368a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000368e:	04649703          	lh	a4,70(s1)
    80003692:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003696:	04849703          	lh	a4,72(s1)
    8000369a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000369e:	04a49703          	lh	a4,74(s1)
    800036a2:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    800036a6:	44f8                	lw	a4,76(s1)
    800036a8:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800036aa:	03400613          	li	a2,52
    800036ae:	05048593          	addi	a1,s1,80
    800036b2:	0531                	addi	a0,a0,12
    800036b4:	ffffd097          	auipc	ra,0xffffd
    800036b8:	666080e7          	jalr	1638(ra) # 80000d1a <memmove>
  log_write(bp);
    800036bc:	854a                	mv	a0,s2
    800036be:	00001097          	auipc	ra,0x1
    800036c2:	c0a080e7          	jalr	-1014(ra) # 800042c8 <log_write>
  brelse(bp);
    800036c6:	854a                	mv	a0,s2
    800036c8:	00000097          	auipc	ra,0x0
    800036cc:	97e080e7          	jalr	-1666(ra) # 80003046 <brelse>
}
    800036d0:	60e2                	ld	ra,24(sp)
    800036d2:	6442                	ld	s0,16(sp)
    800036d4:	64a2                	ld	s1,8(sp)
    800036d6:	6902                	ld	s2,0(sp)
    800036d8:	6105                	addi	sp,sp,32
    800036da:	8082                	ret

00000000800036dc <idup>:
{
    800036dc:	1101                	addi	sp,sp,-32
    800036de:	ec06                	sd	ra,24(sp)
    800036e0:	e822                	sd	s0,16(sp)
    800036e2:	e426                	sd	s1,8(sp)
    800036e4:	1000                	addi	s0,sp,32
    800036e6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800036e8:	0001c517          	auipc	a0,0x1c
    800036ec:	0e050513          	addi	a0,a0,224 # 8001f7c8 <itable>
    800036f0:	ffffd097          	auipc	ra,0xffffd
    800036f4:	4d2080e7          	jalr	1234(ra) # 80000bc2 <acquire>
  ip->ref++;
    800036f8:	449c                	lw	a5,8(s1)
    800036fa:	2785                	addiw	a5,a5,1
    800036fc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800036fe:	0001c517          	auipc	a0,0x1c
    80003702:	0ca50513          	addi	a0,a0,202 # 8001f7c8 <itable>
    80003706:	ffffd097          	auipc	ra,0xffffd
    8000370a:	570080e7          	jalr	1392(ra) # 80000c76 <release>
}
    8000370e:	8526                	mv	a0,s1
    80003710:	60e2                	ld	ra,24(sp)
    80003712:	6442                	ld	s0,16(sp)
    80003714:	64a2                	ld	s1,8(sp)
    80003716:	6105                	addi	sp,sp,32
    80003718:	8082                	ret

000000008000371a <ilock>:
{
    8000371a:	1101                	addi	sp,sp,-32
    8000371c:	ec06                	sd	ra,24(sp)
    8000371e:	e822                	sd	s0,16(sp)
    80003720:	e426                	sd	s1,8(sp)
    80003722:	e04a                	sd	s2,0(sp)
    80003724:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003726:	c115                	beqz	a0,8000374a <ilock+0x30>
    80003728:	84aa                	mv	s1,a0
    8000372a:	451c                	lw	a5,8(a0)
    8000372c:	00f05f63          	blez	a5,8000374a <ilock+0x30>
  acquiresleep(&ip->lock);
    80003730:	0541                	addi	a0,a0,16
    80003732:	00001097          	auipc	ra,0x1
    80003736:	cb6080e7          	jalr	-842(ra) # 800043e8 <acquiresleep>
  if(ip->valid == 0){
    8000373a:	40bc                	lw	a5,64(s1)
    8000373c:	cf99                	beqz	a5,8000375a <ilock+0x40>
}
    8000373e:	60e2                	ld	ra,24(sp)
    80003740:	6442                	ld	s0,16(sp)
    80003742:	64a2                	ld	s1,8(sp)
    80003744:	6902                	ld	s2,0(sp)
    80003746:	6105                	addi	sp,sp,32
    80003748:	8082                	ret
    panic("ilock");
    8000374a:	00005517          	auipc	a0,0x5
    8000374e:	02650513          	addi	a0,a0,38 # 80008770 <syscalls_strings+0x188>
    80003752:	ffffd097          	auipc	ra,0xffffd
    80003756:	dd8080e7          	jalr	-552(ra) # 8000052a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000375a:	40dc                	lw	a5,4(s1)
    8000375c:	0047d79b          	srliw	a5,a5,0x4
    80003760:	0001c597          	auipc	a1,0x1c
    80003764:	0605a583          	lw	a1,96(a1) # 8001f7c0 <sb+0x18>
    80003768:	9dbd                	addw	a1,a1,a5
    8000376a:	4088                	lw	a0,0(s1)
    8000376c:	fffff097          	auipc	ra,0xfffff
    80003770:	7aa080e7          	jalr	1962(ra) # 80002f16 <bread>
    80003774:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003776:	05850593          	addi	a1,a0,88
    8000377a:	40dc                	lw	a5,4(s1)
    8000377c:	8bbd                	andi	a5,a5,15
    8000377e:	079a                	slli	a5,a5,0x6
    80003780:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003782:	00059783          	lh	a5,0(a1)
    80003786:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000378a:	00259783          	lh	a5,2(a1)
    8000378e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003792:	00459783          	lh	a5,4(a1)
    80003796:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000379a:	00659783          	lh	a5,6(a1)
    8000379e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800037a2:	459c                	lw	a5,8(a1)
    800037a4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800037a6:	03400613          	li	a2,52
    800037aa:	05b1                	addi	a1,a1,12
    800037ac:	05048513          	addi	a0,s1,80
    800037b0:	ffffd097          	auipc	ra,0xffffd
    800037b4:	56a080e7          	jalr	1386(ra) # 80000d1a <memmove>
    brelse(bp);
    800037b8:	854a                	mv	a0,s2
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	88c080e7          	jalr	-1908(ra) # 80003046 <brelse>
    ip->valid = 1;
    800037c2:	4785                	li	a5,1
    800037c4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800037c6:	04449783          	lh	a5,68(s1)
    800037ca:	fbb5                	bnez	a5,8000373e <ilock+0x24>
      panic("ilock: no type");
    800037cc:	00005517          	auipc	a0,0x5
    800037d0:	fac50513          	addi	a0,a0,-84 # 80008778 <syscalls_strings+0x190>
    800037d4:	ffffd097          	auipc	ra,0xffffd
    800037d8:	d56080e7          	jalr	-682(ra) # 8000052a <panic>

00000000800037dc <iunlock>:
{
    800037dc:	1101                	addi	sp,sp,-32
    800037de:	ec06                	sd	ra,24(sp)
    800037e0:	e822                	sd	s0,16(sp)
    800037e2:	e426                	sd	s1,8(sp)
    800037e4:	e04a                	sd	s2,0(sp)
    800037e6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800037e8:	c905                	beqz	a0,80003818 <iunlock+0x3c>
    800037ea:	84aa                	mv	s1,a0
    800037ec:	01050913          	addi	s2,a0,16
    800037f0:	854a                	mv	a0,s2
    800037f2:	00001097          	auipc	ra,0x1
    800037f6:	c90080e7          	jalr	-880(ra) # 80004482 <holdingsleep>
    800037fa:	cd19                	beqz	a0,80003818 <iunlock+0x3c>
    800037fc:	449c                	lw	a5,8(s1)
    800037fe:	00f05d63          	blez	a5,80003818 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003802:	854a                	mv	a0,s2
    80003804:	00001097          	auipc	ra,0x1
    80003808:	c3a080e7          	jalr	-966(ra) # 8000443e <releasesleep>
}
    8000380c:	60e2                	ld	ra,24(sp)
    8000380e:	6442                	ld	s0,16(sp)
    80003810:	64a2                	ld	s1,8(sp)
    80003812:	6902                	ld	s2,0(sp)
    80003814:	6105                	addi	sp,sp,32
    80003816:	8082                	ret
    panic("iunlock");
    80003818:	00005517          	auipc	a0,0x5
    8000381c:	f7050513          	addi	a0,a0,-144 # 80008788 <syscalls_strings+0x1a0>
    80003820:	ffffd097          	auipc	ra,0xffffd
    80003824:	d0a080e7          	jalr	-758(ra) # 8000052a <panic>

0000000080003828 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003828:	7179                	addi	sp,sp,-48
    8000382a:	f406                	sd	ra,40(sp)
    8000382c:	f022                	sd	s0,32(sp)
    8000382e:	ec26                	sd	s1,24(sp)
    80003830:	e84a                	sd	s2,16(sp)
    80003832:	e44e                	sd	s3,8(sp)
    80003834:	e052                	sd	s4,0(sp)
    80003836:	1800                	addi	s0,sp,48
    80003838:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000383a:	05050493          	addi	s1,a0,80
    8000383e:	08050913          	addi	s2,a0,128
    80003842:	a021                	j	8000384a <itrunc+0x22>
    80003844:	0491                	addi	s1,s1,4
    80003846:	01248d63          	beq	s1,s2,80003860 <itrunc+0x38>
    if(ip->addrs[i]){
    8000384a:	408c                	lw	a1,0(s1)
    8000384c:	dde5                	beqz	a1,80003844 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000384e:	0009a503          	lw	a0,0(s3)
    80003852:	00000097          	auipc	ra,0x0
    80003856:	90a080e7          	jalr	-1782(ra) # 8000315c <bfree>
      ip->addrs[i] = 0;
    8000385a:	0004a023          	sw	zero,0(s1)
    8000385e:	b7dd                	j	80003844 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003860:	0809a583          	lw	a1,128(s3)
    80003864:	e185                	bnez	a1,80003884 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003866:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000386a:	854e                	mv	a0,s3
    8000386c:	00000097          	auipc	ra,0x0
    80003870:	de4080e7          	jalr	-540(ra) # 80003650 <iupdate>
}
    80003874:	70a2                	ld	ra,40(sp)
    80003876:	7402                	ld	s0,32(sp)
    80003878:	64e2                	ld	s1,24(sp)
    8000387a:	6942                	ld	s2,16(sp)
    8000387c:	69a2                	ld	s3,8(sp)
    8000387e:	6a02                	ld	s4,0(sp)
    80003880:	6145                	addi	sp,sp,48
    80003882:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003884:	0009a503          	lw	a0,0(s3)
    80003888:	fffff097          	auipc	ra,0xfffff
    8000388c:	68e080e7          	jalr	1678(ra) # 80002f16 <bread>
    80003890:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003892:	05850493          	addi	s1,a0,88
    80003896:	45850913          	addi	s2,a0,1112
    8000389a:	a021                	j	800038a2 <itrunc+0x7a>
    8000389c:	0491                	addi	s1,s1,4
    8000389e:	01248b63          	beq	s1,s2,800038b4 <itrunc+0x8c>
      if(a[j])
    800038a2:	408c                	lw	a1,0(s1)
    800038a4:	dde5                	beqz	a1,8000389c <itrunc+0x74>
        bfree(ip->dev, a[j]);
    800038a6:	0009a503          	lw	a0,0(s3)
    800038aa:	00000097          	auipc	ra,0x0
    800038ae:	8b2080e7          	jalr	-1870(ra) # 8000315c <bfree>
    800038b2:	b7ed                	j	8000389c <itrunc+0x74>
    brelse(bp);
    800038b4:	8552                	mv	a0,s4
    800038b6:	fffff097          	auipc	ra,0xfffff
    800038ba:	790080e7          	jalr	1936(ra) # 80003046 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800038be:	0809a583          	lw	a1,128(s3)
    800038c2:	0009a503          	lw	a0,0(s3)
    800038c6:	00000097          	auipc	ra,0x0
    800038ca:	896080e7          	jalr	-1898(ra) # 8000315c <bfree>
    ip->addrs[NDIRECT] = 0;
    800038ce:	0809a023          	sw	zero,128(s3)
    800038d2:	bf51                	j	80003866 <itrunc+0x3e>

00000000800038d4 <iput>:
{
    800038d4:	1101                	addi	sp,sp,-32
    800038d6:	ec06                	sd	ra,24(sp)
    800038d8:	e822                	sd	s0,16(sp)
    800038da:	e426                	sd	s1,8(sp)
    800038dc:	e04a                	sd	s2,0(sp)
    800038de:	1000                	addi	s0,sp,32
    800038e0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800038e2:	0001c517          	auipc	a0,0x1c
    800038e6:	ee650513          	addi	a0,a0,-282 # 8001f7c8 <itable>
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	2d8080e7          	jalr	728(ra) # 80000bc2 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800038f2:	4498                	lw	a4,8(s1)
    800038f4:	4785                	li	a5,1
    800038f6:	02f70363          	beq	a4,a5,8000391c <iput+0x48>
  ip->ref--;
    800038fa:	449c                	lw	a5,8(s1)
    800038fc:	37fd                	addiw	a5,a5,-1
    800038fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003900:	0001c517          	auipc	a0,0x1c
    80003904:	ec850513          	addi	a0,a0,-312 # 8001f7c8 <itable>
    80003908:	ffffd097          	auipc	ra,0xffffd
    8000390c:	36e080e7          	jalr	878(ra) # 80000c76 <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000391c:	40bc                	lw	a5,64(s1)
    8000391e:	dff1                	beqz	a5,800038fa <iput+0x26>
    80003920:	04a49783          	lh	a5,74(s1)
    80003924:	fbf9                	bnez	a5,800038fa <iput+0x26>
    acquiresleep(&ip->lock);
    80003926:	01048913          	addi	s2,s1,16
    8000392a:	854a                	mv	a0,s2
    8000392c:	00001097          	auipc	ra,0x1
    80003930:	abc080e7          	jalr	-1348(ra) # 800043e8 <acquiresleep>
    release(&itable.lock);
    80003934:	0001c517          	auipc	a0,0x1c
    80003938:	e9450513          	addi	a0,a0,-364 # 8001f7c8 <itable>
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	33a080e7          	jalr	826(ra) # 80000c76 <release>
    itrunc(ip);
    80003944:	8526                	mv	a0,s1
    80003946:	00000097          	auipc	ra,0x0
    8000394a:	ee2080e7          	jalr	-286(ra) # 80003828 <itrunc>
    ip->type = 0;
    8000394e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003952:	8526                	mv	a0,s1
    80003954:	00000097          	auipc	ra,0x0
    80003958:	cfc080e7          	jalr	-772(ra) # 80003650 <iupdate>
    ip->valid = 0;
    8000395c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003960:	854a                	mv	a0,s2
    80003962:	00001097          	auipc	ra,0x1
    80003966:	adc080e7          	jalr	-1316(ra) # 8000443e <releasesleep>
    acquire(&itable.lock);
    8000396a:	0001c517          	auipc	a0,0x1c
    8000396e:	e5e50513          	addi	a0,a0,-418 # 8001f7c8 <itable>
    80003972:	ffffd097          	auipc	ra,0xffffd
    80003976:	250080e7          	jalr	592(ra) # 80000bc2 <acquire>
    8000397a:	b741                	j	800038fa <iput+0x26>

000000008000397c <iunlockput>:
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	e426                	sd	s1,8(sp)
    80003984:	1000                	addi	s0,sp,32
    80003986:	84aa                	mv	s1,a0
  iunlock(ip);
    80003988:	00000097          	auipc	ra,0x0
    8000398c:	e54080e7          	jalr	-428(ra) # 800037dc <iunlock>
  iput(ip);
    80003990:	8526                	mv	a0,s1
    80003992:	00000097          	auipc	ra,0x0
    80003996:	f42080e7          	jalr	-190(ra) # 800038d4 <iput>
}
    8000399a:	60e2                	ld	ra,24(sp)
    8000399c:	6442                	ld	s0,16(sp)
    8000399e:	64a2                	ld	s1,8(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800039a4:	1141                	addi	sp,sp,-16
    800039a6:	e422                	sd	s0,8(sp)
    800039a8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800039aa:	411c                	lw	a5,0(a0)
    800039ac:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800039ae:	415c                	lw	a5,4(a0)
    800039b0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800039b2:	04451783          	lh	a5,68(a0)
    800039b6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800039ba:	04a51783          	lh	a5,74(a0)
    800039be:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800039c2:	04c56783          	lwu	a5,76(a0)
    800039c6:	e99c                	sd	a5,16(a1)
}
    800039c8:	6422                	ld	s0,8(sp)
    800039ca:	0141                	addi	sp,sp,16
    800039cc:	8082                	ret

00000000800039ce <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039ce:	457c                	lw	a5,76(a0)
    800039d0:	0ed7e963          	bltu	a5,a3,80003ac2 <readi+0xf4>
{
    800039d4:	7159                	addi	sp,sp,-112
    800039d6:	f486                	sd	ra,104(sp)
    800039d8:	f0a2                	sd	s0,96(sp)
    800039da:	eca6                	sd	s1,88(sp)
    800039dc:	e8ca                	sd	s2,80(sp)
    800039de:	e4ce                	sd	s3,72(sp)
    800039e0:	e0d2                	sd	s4,64(sp)
    800039e2:	fc56                	sd	s5,56(sp)
    800039e4:	f85a                	sd	s6,48(sp)
    800039e6:	f45e                	sd	s7,40(sp)
    800039e8:	f062                	sd	s8,32(sp)
    800039ea:	ec66                	sd	s9,24(sp)
    800039ec:	e86a                	sd	s10,16(sp)
    800039ee:	e46e                	sd	s11,8(sp)
    800039f0:	1880                	addi	s0,sp,112
    800039f2:	8baa                	mv	s7,a0
    800039f4:	8c2e                	mv	s8,a1
    800039f6:	8ab2                	mv	s5,a2
    800039f8:	84b6                	mv	s1,a3
    800039fa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039fc:	9f35                	addw	a4,a4,a3
    return 0;
    800039fe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a00:	0ad76063          	bltu	a4,a3,80003aa0 <readi+0xd2>
  if(off + n > ip->size)
    80003a04:	00e7f463          	bgeu	a5,a4,80003a0c <readi+0x3e>
    n = ip->size - off;
    80003a08:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a0c:	0a0b0963          	beqz	s6,80003abe <readi+0xf0>
    80003a10:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a12:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003a16:	5cfd                	li	s9,-1
    80003a18:	a82d                	j	80003a52 <readi+0x84>
    80003a1a:	020a1d93          	slli	s11,s4,0x20
    80003a1e:	020ddd93          	srli	s11,s11,0x20
    80003a22:	05890793          	addi	a5,s2,88
    80003a26:	86ee                	mv	a3,s11
    80003a28:	963e                	add	a2,a2,a5
    80003a2a:	85d6                	mv	a1,s5
    80003a2c:	8562                	mv	a0,s8
    80003a2e:	fffff097          	auipc	ra,0xfffff
    80003a32:	9bc080e7          	jalr	-1604(ra) # 800023ea <either_copyout>
    80003a36:	05950d63          	beq	a0,s9,80003a90 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003a3a:	854a                	mv	a0,s2
    80003a3c:	fffff097          	auipc	ra,0xfffff
    80003a40:	60a080e7          	jalr	1546(ra) # 80003046 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003a44:	013a09bb          	addw	s3,s4,s3
    80003a48:	009a04bb          	addw	s1,s4,s1
    80003a4c:	9aee                	add	s5,s5,s11
    80003a4e:	0569f763          	bgeu	s3,s6,80003a9c <readi+0xce>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a52:	000ba903          	lw	s2,0(s7)
    80003a56:	00a4d59b          	srliw	a1,s1,0xa
    80003a5a:	855e                	mv	a0,s7
    80003a5c:	00000097          	auipc	ra,0x0
    80003a60:	8ae080e7          	jalr	-1874(ra) # 8000330a <bmap>
    80003a64:	0005059b          	sext.w	a1,a0
    80003a68:	854a                	mv	a0,s2
    80003a6a:	fffff097          	auipc	ra,0xfffff
    80003a6e:	4ac080e7          	jalr	1196(ra) # 80002f16 <bread>
    80003a72:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a74:	3ff4f613          	andi	a2,s1,1023
    80003a78:	40cd07bb          	subw	a5,s10,a2
    80003a7c:	413b073b          	subw	a4,s6,s3
    80003a80:	8a3e                	mv	s4,a5
    80003a82:	2781                	sext.w	a5,a5
    80003a84:	0007069b          	sext.w	a3,a4
    80003a88:	f8f6f9e3          	bgeu	a3,a5,80003a1a <readi+0x4c>
    80003a8c:	8a3a                	mv	s4,a4
    80003a8e:	b771                	j	80003a1a <readi+0x4c>
      brelse(bp);
    80003a90:	854a                	mv	a0,s2
    80003a92:	fffff097          	auipc	ra,0xfffff
    80003a96:	5b4080e7          	jalr	1460(ra) # 80003046 <brelse>
      tot = -1;
    80003a9a:	59fd                	li	s3,-1
  }
  return tot;
    80003a9c:	0009851b          	sext.w	a0,s3
}
    80003aa0:	70a6                	ld	ra,104(sp)
    80003aa2:	7406                	ld	s0,96(sp)
    80003aa4:	64e6                	ld	s1,88(sp)
    80003aa6:	6946                	ld	s2,80(sp)
    80003aa8:	69a6                	ld	s3,72(sp)
    80003aaa:	6a06                	ld	s4,64(sp)
    80003aac:	7ae2                	ld	s5,56(sp)
    80003aae:	7b42                	ld	s6,48(sp)
    80003ab0:	7ba2                	ld	s7,40(sp)
    80003ab2:	7c02                	ld	s8,32(sp)
    80003ab4:	6ce2                	ld	s9,24(sp)
    80003ab6:	6d42                	ld	s10,16(sp)
    80003ab8:	6da2                	ld	s11,8(sp)
    80003aba:	6165                	addi	sp,sp,112
    80003abc:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003abe:	89da                	mv	s3,s6
    80003ac0:	bff1                	j	80003a9c <readi+0xce>
    return 0;
    80003ac2:	4501                	li	a0,0
}
    80003ac4:	8082                	ret

0000000080003ac6 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003ac6:	457c                	lw	a5,76(a0)
    80003ac8:	10d7e863          	bltu	a5,a3,80003bd8 <writei+0x112>
{
    80003acc:	7159                	addi	sp,sp,-112
    80003ace:	f486                	sd	ra,104(sp)
    80003ad0:	f0a2                	sd	s0,96(sp)
    80003ad2:	eca6                	sd	s1,88(sp)
    80003ad4:	e8ca                	sd	s2,80(sp)
    80003ad6:	e4ce                	sd	s3,72(sp)
    80003ad8:	e0d2                	sd	s4,64(sp)
    80003ada:	fc56                	sd	s5,56(sp)
    80003adc:	f85a                	sd	s6,48(sp)
    80003ade:	f45e                	sd	s7,40(sp)
    80003ae0:	f062                	sd	s8,32(sp)
    80003ae2:	ec66                	sd	s9,24(sp)
    80003ae4:	e86a                	sd	s10,16(sp)
    80003ae6:	e46e                	sd	s11,8(sp)
    80003ae8:	1880                	addi	s0,sp,112
    80003aea:	8b2a                	mv	s6,a0
    80003aec:	8c2e                	mv	s8,a1
    80003aee:	8ab2                	mv	s5,a2
    80003af0:	8936                	mv	s2,a3
    80003af2:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003af4:	00e687bb          	addw	a5,a3,a4
    80003af8:	0ed7e263          	bltu	a5,a3,80003bdc <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003afc:	00043737          	lui	a4,0x43
    80003b00:	0ef76063          	bltu	a4,a5,80003be0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b04:	0c0b8863          	beqz	s7,80003bd4 <writei+0x10e>
    80003b08:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b0a:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003b0e:	5cfd                	li	s9,-1
    80003b10:	a091                	j	80003b54 <writei+0x8e>
    80003b12:	02099d93          	slli	s11,s3,0x20
    80003b16:	020ddd93          	srli	s11,s11,0x20
    80003b1a:	05848793          	addi	a5,s1,88
    80003b1e:	86ee                	mv	a3,s11
    80003b20:	8656                	mv	a2,s5
    80003b22:	85e2                	mv	a1,s8
    80003b24:	953e                	add	a0,a0,a5
    80003b26:	fffff097          	auipc	ra,0xfffff
    80003b2a:	91a080e7          	jalr	-1766(ra) # 80002440 <either_copyin>
    80003b2e:	07950263          	beq	a0,s9,80003b92 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003b32:	8526                	mv	a0,s1
    80003b34:	00000097          	auipc	ra,0x0
    80003b38:	794080e7          	jalr	1940(ra) # 800042c8 <log_write>
    brelse(bp);
    80003b3c:	8526                	mv	a0,s1
    80003b3e:	fffff097          	auipc	ra,0xfffff
    80003b42:	508080e7          	jalr	1288(ra) # 80003046 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b46:	01498a3b          	addw	s4,s3,s4
    80003b4a:	0129893b          	addw	s2,s3,s2
    80003b4e:	9aee                	add	s5,s5,s11
    80003b50:	057a7663          	bgeu	s4,s7,80003b9c <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b54:	000b2483          	lw	s1,0(s6)
    80003b58:	00a9559b          	srliw	a1,s2,0xa
    80003b5c:	855a                	mv	a0,s6
    80003b5e:	fffff097          	auipc	ra,0xfffff
    80003b62:	7ac080e7          	jalr	1964(ra) # 8000330a <bmap>
    80003b66:	0005059b          	sext.w	a1,a0
    80003b6a:	8526                	mv	a0,s1
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	3aa080e7          	jalr	938(ra) # 80002f16 <bread>
    80003b74:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b76:	3ff97513          	andi	a0,s2,1023
    80003b7a:	40ad07bb          	subw	a5,s10,a0
    80003b7e:	414b873b          	subw	a4,s7,s4
    80003b82:	89be                	mv	s3,a5
    80003b84:	2781                	sext.w	a5,a5
    80003b86:	0007069b          	sext.w	a3,a4
    80003b8a:	f8f6f4e3          	bgeu	a3,a5,80003b12 <writei+0x4c>
    80003b8e:	89ba                	mv	s3,a4
    80003b90:	b749                	j	80003b12 <writei+0x4c>
      brelse(bp);
    80003b92:	8526                	mv	a0,s1
    80003b94:	fffff097          	auipc	ra,0xfffff
    80003b98:	4b2080e7          	jalr	1202(ra) # 80003046 <brelse>
  }

  if(off > ip->size)
    80003b9c:	04cb2783          	lw	a5,76(s6)
    80003ba0:	0127f463          	bgeu	a5,s2,80003ba8 <writei+0xe2>
    ip->size = off;
    80003ba4:	052b2623          	sw	s2,76(s6)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003ba8:	855a                	mv	a0,s6
    80003baa:	00000097          	auipc	ra,0x0
    80003bae:	aa6080e7          	jalr	-1370(ra) # 80003650 <iupdate>

  return tot;
    80003bb2:	000a051b          	sext.w	a0,s4
}
    80003bb6:	70a6                	ld	ra,104(sp)
    80003bb8:	7406                	ld	s0,96(sp)
    80003bba:	64e6                	ld	s1,88(sp)
    80003bbc:	6946                	ld	s2,80(sp)
    80003bbe:	69a6                	ld	s3,72(sp)
    80003bc0:	6a06                	ld	s4,64(sp)
    80003bc2:	7ae2                	ld	s5,56(sp)
    80003bc4:	7b42                	ld	s6,48(sp)
    80003bc6:	7ba2                	ld	s7,40(sp)
    80003bc8:	7c02                	ld	s8,32(sp)
    80003bca:	6ce2                	ld	s9,24(sp)
    80003bcc:	6d42                	ld	s10,16(sp)
    80003bce:	6da2                	ld	s11,8(sp)
    80003bd0:	6165                	addi	sp,sp,112
    80003bd2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bd4:	8a5e                	mv	s4,s7
    80003bd6:	bfc9                	j	80003ba8 <writei+0xe2>
    return -1;
    80003bd8:	557d                	li	a0,-1
}
    80003bda:	8082                	ret
    return -1;
    80003bdc:	557d                	li	a0,-1
    80003bde:	bfe1                	j	80003bb6 <writei+0xf0>
    return -1;
    80003be0:	557d                	li	a0,-1
    80003be2:	bfd1                	j	80003bb6 <writei+0xf0>

0000000080003be4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003be4:	1141                	addi	sp,sp,-16
    80003be6:	e406                	sd	ra,8(sp)
    80003be8:	e022                	sd	s0,0(sp)
    80003bea:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003bec:	4639                	li	a2,14
    80003bee:	ffffd097          	auipc	ra,0xffffd
    80003bf2:	1a8080e7          	jalr	424(ra) # 80000d96 <strncmp>
}
    80003bf6:	60a2                	ld	ra,8(sp)
    80003bf8:	6402                	ld	s0,0(sp)
    80003bfa:	0141                	addi	sp,sp,16
    80003bfc:	8082                	ret

0000000080003bfe <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003bfe:	7139                	addi	sp,sp,-64
    80003c00:	fc06                	sd	ra,56(sp)
    80003c02:	f822                	sd	s0,48(sp)
    80003c04:	f426                	sd	s1,40(sp)
    80003c06:	f04a                	sd	s2,32(sp)
    80003c08:	ec4e                	sd	s3,24(sp)
    80003c0a:	e852                	sd	s4,16(sp)
    80003c0c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c0e:	04451703          	lh	a4,68(a0)
    80003c12:	4785                	li	a5,1
    80003c14:	00f71a63          	bne	a4,a5,80003c28 <dirlookup+0x2a>
    80003c18:	892a                	mv	s2,a0
    80003c1a:	89ae                	mv	s3,a1
    80003c1c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c1e:	457c                	lw	a5,76(a0)
    80003c20:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003c22:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c24:	e79d                	bnez	a5,80003c52 <dirlookup+0x54>
    80003c26:	a8a5                	j	80003c9e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003c28:	00005517          	auipc	a0,0x5
    80003c2c:	b6850513          	addi	a0,a0,-1176 # 80008790 <syscalls_strings+0x1a8>
    80003c30:	ffffd097          	auipc	ra,0xffffd
    80003c34:	8fa080e7          	jalr	-1798(ra) # 8000052a <panic>
      panic("dirlookup read");
    80003c38:	00005517          	auipc	a0,0x5
    80003c3c:	b7050513          	addi	a0,a0,-1168 # 800087a8 <syscalls_strings+0x1c0>
    80003c40:	ffffd097          	auipc	ra,0xffffd
    80003c44:	8ea080e7          	jalr	-1814(ra) # 8000052a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c48:	24c1                	addiw	s1,s1,16
    80003c4a:	04c92783          	lw	a5,76(s2)
    80003c4e:	04f4f763          	bgeu	s1,a5,80003c9c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c52:	4741                	li	a4,16
    80003c54:	86a6                	mv	a3,s1
    80003c56:	fc040613          	addi	a2,s0,-64
    80003c5a:	4581                	li	a1,0
    80003c5c:	854a                	mv	a0,s2
    80003c5e:	00000097          	auipc	ra,0x0
    80003c62:	d70080e7          	jalr	-656(ra) # 800039ce <readi>
    80003c66:	47c1                	li	a5,16
    80003c68:	fcf518e3          	bne	a0,a5,80003c38 <dirlookup+0x3a>
    if(de.inum == 0)
    80003c6c:	fc045783          	lhu	a5,-64(s0)
    80003c70:	dfe1                	beqz	a5,80003c48 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003c72:	fc240593          	addi	a1,s0,-62
    80003c76:	854e                	mv	a0,s3
    80003c78:	00000097          	auipc	ra,0x0
    80003c7c:	f6c080e7          	jalr	-148(ra) # 80003be4 <namecmp>
    80003c80:	f561                	bnez	a0,80003c48 <dirlookup+0x4a>
      if(poff)
    80003c82:	000a0463          	beqz	s4,80003c8a <dirlookup+0x8c>
        *poff = off;
    80003c86:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003c8a:	fc045583          	lhu	a1,-64(s0)
    80003c8e:	00092503          	lw	a0,0(s2)
    80003c92:	fffff097          	auipc	ra,0xfffff
    80003c96:	754080e7          	jalr	1876(ra) # 800033e6 <iget>
    80003c9a:	a011                	j	80003c9e <dirlookup+0xa0>
  return 0;
    80003c9c:	4501                	li	a0,0
}
    80003c9e:	70e2                	ld	ra,56(sp)
    80003ca0:	7442                	ld	s0,48(sp)
    80003ca2:	74a2                	ld	s1,40(sp)
    80003ca4:	7902                	ld	s2,32(sp)
    80003ca6:	69e2                	ld	s3,24(sp)
    80003ca8:	6a42                	ld	s4,16(sp)
    80003caa:	6121                	addi	sp,sp,64
    80003cac:	8082                	ret

0000000080003cae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003cae:	711d                	addi	sp,sp,-96
    80003cb0:	ec86                	sd	ra,88(sp)
    80003cb2:	e8a2                	sd	s0,80(sp)
    80003cb4:	e4a6                	sd	s1,72(sp)
    80003cb6:	e0ca                	sd	s2,64(sp)
    80003cb8:	fc4e                	sd	s3,56(sp)
    80003cba:	f852                	sd	s4,48(sp)
    80003cbc:	f456                	sd	s5,40(sp)
    80003cbe:	f05a                	sd	s6,32(sp)
    80003cc0:	ec5e                	sd	s7,24(sp)
    80003cc2:	e862                	sd	s8,16(sp)
    80003cc4:	e466                	sd	s9,8(sp)
    80003cc6:	1080                	addi	s0,sp,96
    80003cc8:	84aa                	mv	s1,a0
    80003cca:	8aae                	mv	s5,a1
    80003ccc:	8a32                	mv	s4,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003cce:	00054703          	lbu	a4,0(a0)
    80003cd2:	02f00793          	li	a5,47
    80003cd6:	02f70363          	beq	a4,a5,80003cfc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003cda:	ffffe097          	auipc	ra,0xffffe
    80003cde:	ca4080e7          	jalr	-860(ra) # 8000197e <myproc>
    80003ce2:	15053503          	ld	a0,336(a0)
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	9f6080e7          	jalr	-1546(ra) # 800036dc <idup>
    80003cee:	89aa                	mv	s3,a0
  while(*path == '/')
    80003cf0:	02f00913          	li	s2,47
  len = path - s;
    80003cf4:	4b01                	li	s6,0
  if(len >= DIRSIZ)
    80003cf6:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003cf8:	4b85                	li	s7,1
    80003cfa:	a865                	j	80003db2 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003cfc:	4585                	li	a1,1
    80003cfe:	4505                	li	a0,1
    80003d00:	fffff097          	auipc	ra,0xfffff
    80003d04:	6e6080e7          	jalr	1766(ra) # 800033e6 <iget>
    80003d08:	89aa                	mv	s3,a0
    80003d0a:	b7dd                	j	80003cf0 <namex+0x42>
      iunlockput(ip);
    80003d0c:	854e                	mv	a0,s3
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	c6e080e7          	jalr	-914(ra) # 8000397c <iunlockput>
      return 0;
    80003d16:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d18:	854e                	mv	a0,s3
    80003d1a:	60e6                	ld	ra,88(sp)
    80003d1c:	6446                	ld	s0,80(sp)
    80003d1e:	64a6                	ld	s1,72(sp)
    80003d20:	6906                	ld	s2,64(sp)
    80003d22:	79e2                	ld	s3,56(sp)
    80003d24:	7a42                	ld	s4,48(sp)
    80003d26:	7aa2                	ld	s5,40(sp)
    80003d28:	7b02                	ld	s6,32(sp)
    80003d2a:	6be2                	ld	s7,24(sp)
    80003d2c:	6c42                	ld	s8,16(sp)
    80003d2e:	6ca2                	ld	s9,8(sp)
    80003d30:	6125                	addi	sp,sp,96
    80003d32:	8082                	ret
      iunlock(ip);
    80003d34:	854e                	mv	a0,s3
    80003d36:	00000097          	auipc	ra,0x0
    80003d3a:	aa6080e7          	jalr	-1370(ra) # 800037dc <iunlock>
      return ip;
    80003d3e:	bfe9                	j	80003d18 <namex+0x6a>
      iunlockput(ip);
    80003d40:	854e                	mv	a0,s3
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	c3a080e7          	jalr	-966(ra) # 8000397c <iunlockput>
      return 0;
    80003d4a:	89e6                	mv	s3,s9
    80003d4c:	b7f1                	j	80003d18 <namex+0x6a>
  len = path - s;
    80003d4e:	40b48633          	sub	a2,s1,a1
    80003d52:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003d56:	099c5463          	bge	s8,s9,80003dde <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003d5a:	4639                	li	a2,14
    80003d5c:	8552                	mv	a0,s4
    80003d5e:	ffffd097          	auipc	ra,0xffffd
    80003d62:	fbc080e7          	jalr	-68(ra) # 80000d1a <memmove>
  while(*path == '/')
    80003d66:	0004c783          	lbu	a5,0(s1)
    80003d6a:	01279763          	bne	a5,s2,80003d78 <namex+0xca>
    path++;
    80003d6e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003d70:	0004c783          	lbu	a5,0(s1)
    80003d74:	ff278de3          	beq	a5,s2,80003d6e <namex+0xc0>
    ilock(ip);
    80003d78:	854e                	mv	a0,s3
    80003d7a:	00000097          	auipc	ra,0x0
    80003d7e:	9a0080e7          	jalr	-1632(ra) # 8000371a <ilock>
    if(ip->type != T_DIR){
    80003d82:	04499783          	lh	a5,68(s3)
    80003d86:	f97793e3          	bne	a5,s7,80003d0c <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003d8a:	000a8563          	beqz	s5,80003d94 <namex+0xe6>
    80003d8e:	0004c783          	lbu	a5,0(s1)
    80003d92:	d3cd                	beqz	a5,80003d34 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003d94:	865a                	mv	a2,s6
    80003d96:	85d2                	mv	a1,s4
    80003d98:	854e                	mv	a0,s3
    80003d9a:	00000097          	auipc	ra,0x0
    80003d9e:	e64080e7          	jalr	-412(ra) # 80003bfe <dirlookup>
    80003da2:	8caa                	mv	s9,a0
    80003da4:	dd51                	beqz	a0,80003d40 <namex+0x92>
    iunlockput(ip);
    80003da6:	854e                	mv	a0,s3
    80003da8:	00000097          	auipc	ra,0x0
    80003dac:	bd4080e7          	jalr	-1068(ra) # 8000397c <iunlockput>
    ip = next;
    80003db0:	89e6                	mv	s3,s9
  while(*path == '/')
    80003db2:	0004c783          	lbu	a5,0(s1)
    80003db6:	05279763          	bne	a5,s2,80003e04 <namex+0x156>
    path++;
    80003dba:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dbc:	0004c783          	lbu	a5,0(s1)
    80003dc0:	ff278de3          	beq	a5,s2,80003dba <namex+0x10c>
  if(*path == 0)
    80003dc4:	c79d                	beqz	a5,80003df2 <namex+0x144>
    path++;
    80003dc6:	85a6                	mv	a1,s1
  len = path - s;
    80003dc8:	8cda                	mv	s9,s6
    80003dca:	865a                	mv	a2,s6
  while(*path != '/' && *path != 0)
    80003dcc:	01278963          	beq	a5,s2,80003dde <namex+0x130>
    80003dd0:	dfbd                	beqz	a5,80003d4e <namex+0xa0>
    path++;
    80003dd2:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003dd4:	0004c783          	lbu	a5,0(s1)
    80003dd8:	ff279ce3          	bne	a5,s2,80003dd0 <namex+0x122>
    80003ddc:	bf8d                	j	80003d4e <namex+0xa0>
    memmove(name, s, len);
    80003dde:	2601                	sext.w	a2,a2
    80003de0:	8552                	mv	a0,s4
    80003de2:	ffffd097          	auipc	ra,0xffffd
    80003de6:	f38080e7          	jalr	-200(ra) # 80000d1a <memmove>
    name[len] = 0;
    80003dea:	9cd2                	add	s9,s9,s4
    80003dec:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003df0:	bf9d                	j	80003d66 <namex+0xb8>
  if(nameiparent){
    80003df2:	f20a83e3          	beqz	s5,80003d18 <namex+0x6a>
    iput(ip);
    80003df6:	854e                	mv	a0,s3
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	adc080e7          	jalr	-1316(ra) # 800038d4 <iput>
    return 0;
    80003e00:	4981                	li	s3,0
    80003e02:	bf19                	j	80003d18 <namex+0x6a>
  if(*path == 0)
    80003e04:	d7fd                	beqz	a5,80003df2 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003e06:	0004c783          	lbu	a5,0(s1)
    80003e0a:	85a6                	mv	a1,s1
    80003e0c:	b7d1                	j	80003dd0 <namex+0x122>

0000000080003e0e <dirlink>:
{
    80003e0e:	7139                	addi	sp,sp,-64
    80003e10:	fc06                	sd	ra,56(sp)
    80003e12:	f822                	sd	s0,48(sp)
    80003e14:	f426                	sd	s1,40(sp)
    80003e16:	f04a                	sd	s2,32(sp)
    80003e18:	ec4e                	sd	s3,24(sp)
    80003e1a:	e852                	sd	s4,16(sp)
    80003e1c:	0080                	addi	s0,sp,64
    80003e1e:	892a                	mv	s2,a0
    80003e20:	8a2e                	mv	s4,a1
    80003e22:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e24:	4601                	li	a2,0
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	dd8080e7          	jalr	-552(ra) # 80003bfe <dirlookup>
    80003e2e:	e93d                	bnez	a0,80003ea4 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e30:	04c92483          	lw	s1,76(s2)
    80003e34:	c49d                	beqz	s1,80003e62 <dirlink+0x54>
    80003e36:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e38:	4741                	li	a4,16
    80003e3a:	86a6                	mv	a3,s1
    80003e3c:	fc040613          	addi	a2,s0,-64
    80003e40:	4581                	li	a1,0
    80003e42:	854a                	mv	a0,s2
    80003e44:	00000097          	auipc	ra,0x0
    80003e48:	b8a080e7          	jalr	-1142(ra) # 800039ce <readi>
    80003e4c:	47c1                	li	a5,16
    80003e4e:	06f51163          	bne	a0,a5,80003eb0 <dirlink+0xa2>
    if(de.inum == 0)
    80003e52:	fc045783          	lhu	a5,-64(s0)
    80003e56:	c791                	beqz	a5,80003e62 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e58:	24c1                	addiw	s1,s1,16
    80003e5a:	04c92783          	lw	a5,76(s2)
    80003e5e:	fcf4ede3          	bltu	s1,a5,80003e38 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003e62:	4639                	li	a2,14
    80003e64:	85d2                	mv	a1,s4
    80003e66:	fc240513          	addi	a0,s0,-62
    80003e6a:	ffffd097          	auipc	ra,0xffffd
    80003e6e:	f68080e7          	jalr	-152(ra) # 80000dd2 <strncpy>
  de.inum = inum;
    80003e72:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e76:	4741                	li	a4,16
    80003e78:	86a6                	mv	a3,s1
    80003e7a:	fc040613          	addi	a2,s0,-64
    80003e7e:	4581                	li	a1,0
    80003e80:	854a                	mv	a0,s2
    80003e82:	00000097          	auipc	ra,0x0
    80003e86:	c44080e7          	jalr	-956(ra) # 80003ac6 <writei>
    80003e8a:	872a                	mv	a4,a0
    80003e8c:	47c1                	li	a5,16
  return 0;
    80003e8e:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e90:	02f71863          	bne	a4,a5,80003ec0 <dirlink+0xb2>
}
    80003e94:	70e2                	ld	ra,56(sp)
    80003e96:	7442                	ld	s0,48(sp)
    80003e98:	74a2                	ld	s1,40(sp)
    80003e9a:	7902                	ld	s2,32(sp)
    80003e9c:	69e2                	ld	s3,24(sp)
    80003e9e:	6a42                	ld	s4,16(sp)
    80003ea0:	6121                	addi	sp,sp,64
    80003ea2:	8082                	ret
    iput(ip);
    80003ea4:	00000097          	auipc	ra,0x0
    80003ea8:	a30080e7          	jalr	-1488(ra) # 800038d4 <iput>
    return -1;
    80003eac:	557d                	li	a0,-1
    80003eae:	b7dd                	j	80003e94 <dirlink+0x86>
      panic("dirlink read");
    80003eb0:	00005517          	auipc	a0,0x5
    80003eb4:	90850513          	addi	a0,a0,-1784 # 800087b8 <syscalls_strings+0x1d0>
    80003eb8:	ffffc097          	auipc	ra,0xffffc
    80003ebc:	672080e7          	jalr	1650(ra) # 8000052a <panic>
    panic("dirlink");
    80003ec0:	00005517          	auipc	a0,0x5
    80003ec4:	a0050513          	addi	a0,a0,-1536 # 800088c0 <syscalls_strings+0x2d8>
    80003ec8:	ffffc097          	auipc	ra,0xffffc
    80003ecc:	662080e7          	jalr	1634(ra) # 8000052a <panic>

0000000080003ed0 <namei>:

struct inode*
namei(char *path)
{
    80003ed0:	1101                	addi	sp,sp,-32
    80003ed2:	ec06                	sd	ra,24(sp)
    80003ed4:	e822                	sd	s0,16(sp)
    80003ed6:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003ed8:	fe040613          	addi	a2,s0,-32
    80003edc:	4581                	li	a1,0
    80003ede:	00000097          	auipc	ra,0x0
    80003ee2:	dd0080e7          	jalr	-560(ra) # 80003cae <namex>
}
    80003ee6:	60e2                	ld	ra,24(sp)
    80003ee8:	6442                	ld	s0,16(sp)
    80003eea:	6105                	addi	sp,sp,32
    80003eec:	8082                	ret

0000000080003eee <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003eee:	1141                	addi	sp,sp,-16
    80003ef0:	e406                	sd	ra,8(sp)
    80003ef2:	e022                	sd	s0,0(sp)
    80003ef4:	0800                	addi	s0,sp,16
    80003ef6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ef8:	4585                	li	a1,1
    80003efa:	00000097          	auipc	ra,0x0
    80003efe:	db4080e7          	jalr	-588(ra) # 80003cae <namex>
}
    80003f02:	60a2                	ld	ra,8(sp)
    80003f04:	6402                	ld	s0,0(sp)
    80003f06:	0141                	addi	sp,sp,16
    80003f08:	8082                	ret

0000000080003f0a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f0a:	1101                	addi	sp,sp,-32
    80003f0c:	ec06                	sd	ra,24(sp)
    80003f0e:	e822                	sd	s0,16(sp)
    80003f10:	e426                	sd	s1,8(sp)
    80003f12:	e04a                	sd	s2,0(sp)
    80003f14:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f16:	0001d917          	auipc	s2,0x1d
    80003f1a:	35a90913          	addi	s2,s2,858 # 80021270 <log>
    80003f1e:	01892583          	lw	a1,24(s2)
    80003f22:	02892503          	lw	a0,40(s2)
    80003f26:	fffff097          	auipc	ra,0xfffff
    80003f2a:	ff0080e7          	jalr	-16(ra) # 80002f16 <bread>
    80003f2e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f30:	02c92683          	lw	a3,44(s2)
    80003f34:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f36:	02d05863          	blez	a3,80003f66 <write_head+0x5c>
    80003f3a:	0001d797          	auipc	a5,0x1d
    80003f3e:	36678793          	addi	a5,a5,870 # 800212a0 <log+0x30>
    80003f42:	05c50713          	addi	a4,a0,92
    80003f46:	36fd                	addiw	a3,a3,-1
    80003f48:	02069613          	slli	a2,a3,0x20
    80003f4c:	01e65693          	srli	a3,a2,0x1e
    80003f50:	0001d617          	auipc	a2,0x1d
    80003f54:	35460613          	addi	a2,a2,852 # 800212a4 <log+0x34>
    80003f58:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003f5a:	4390                	lw	a2,0(a5)
    80003f5c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003f5e:	0791                	addi	a5,a5,4
    80003f60:	0711                	addi	a4,a4,4
    80003f62:	fed79ce3          	bne	a5,a3,80003f5a <write_head+0x50>
  }
  bwrite(buf);
    80003f66:	8526                	mv	a0,s1
    80003f68:	fffff097          	auipc	ra,0xfffff
    80003f6c:	0a0080e7          	jalr	160(ra) # 80003008 <bwrite>
  brelse(buf);
    80003f70:	8526                	mv	a0,s1
    80003f72:	fffff097          	auipc	ra,0xfffff
    80003f76:	0d4080e7          	jalr	212(ra) # 80003046 <brelse>
}
    80003f7a:	60e2                	ld	ra,24(sp)
    80003f7c:	6442                	ld	s0,16(sp)
    80003f7e:	64a2                	ld	s1,8(sp)
    80003f80:	6902                	ld	s2,0(sp)
    80003f82:	6105                	addi	sp,sp,32
    80003f84:	8082                	ret

0000000080003f86 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f86:	0001d797          	auipc	a5,0x1d
    80003f8a:	3167a783          	lw	a5,790(a5) # 8002129c <log+0x2c>
    80003f8e:	0af05d63          	blez	a5,80004048 <install_trans+0xc2>
{
    80003f92:	7139                	addi	sp,sp,-64
    80003f94:	fc06                	sd	ra,56(sp)
    80003f96:	f822                	sd	s0,48(sp)
    80003f98:	f426                	sd	s1,40(sp)
    80003f9a:	f04a                	sd	s2,32(sp)
    80003f9c:	ec4e                	sd	s3,24(sp)
    80003f9e:	e852                	sd	s4,16(sp)
    80003fa0:	e456                	sd	s5,8(sp)
    80003fa2:	e05a                	sd	s6,0(sp)
    80003fa4:	0080                	addi	s0,sp,64
    80003fa6:	8b2a                	mv	s6,a0
    80003fa8:	0001da97          	auipc	s5,0x1d
    80003fac:	2f8a8a93          	addi	s5,s5,760 # 800212a0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fb0:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fb2:	0001d997          	auipc	s3,0x1d
    80003fb6:	2be98993          	addi	s3,s3,702 # 80021270 <log>
    80003fba:	a00d                	j	80003fdc <install_trans+0x56>
    brelse(lbuf);
    80003fbc:	854a                	mv	a0,s2
    80003fbe:	fffff097          	auipc	ra,0xfffff
    80003fc2:	088080e7          	jalr	136(ra) # 80003046 <brelse>
    brelse(dbuf);
    80003fc6:	8526                	mv	a0,s1
    80003fc8:	fffff097          	auipc	ra,0xfffff
    80003fcc:	07e080e7          	jalr	126(ra) # 80003046 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fd0:	2a05                	addiw	s4,s4,1
    80003fd2:	0a91                	addi	s5,s5,4
    80003fd4:	02c9a783          	lw	a5,44(s3)
    80003fd8:	04fa5e63          	bge	s4,a5,80004034 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fdc:	0189a583          	lw	a1,24(s3)
    80003fe0:	014585bb          	addw	a1,a1,s4
    80003fe4:	2585                	addiw	a1,a1,1
    80003fe6:	0289a503          	lw	a0,40(s3)
    80003fea:	fffff097          	auipc	ra,0xfffff
    80003fee:	f2c080e7          	jalr	-212(ra) # 80002f16 <bread>
    80003ff2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003ff4:	000aa583          	lw	a1,0(s5)
    80003ff8:	0289a503          	lw	a0,40(s3)
    80003ffc:	fffff097          	auipc	ra,0xfffff
    80004000:	f1a080e7          	jalr	-230(ra) # 80002f16 <bread>
    80004004:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004006:	40000613          	li	a2,1024
    8000400a:	05890593          	addi	a1,s2,88
    8000400e:	05850513          	addi	a0,a0,88
    80004012:	ffffd097          	auipc	ra,0xffffd
    80004016:	d08080e7          	jalr	-760(ra) # 80000d1a <memmove>
    bwrite(dbuf);  // write dst to disk
    8000401a:	8526                	mv	a0,s1
    8000401c:	fffff097          	auipc	ra,0xfffff
    80004020:	fec080e7          	jalr	-20(ra) # 80003008 <bwrite>
    if(recovering == 0)
    80004024:	f80b1ce3          	bnez	s6,80003fbc <install_trans+0x36>
      bunpin(dbuf);
    80004028:	8526                	mv	a0,s1
    8000402a:	fffff097          	auipc	ra,0xfffff
    8000402e:	0f6080e7          	jalr	246(ra) # 80003120 <bunpin>
    80004032:	b769                	j	80003fbc <install_trans+0x36>
}
    80004034:	70e2                	ld	ra,56(sp)
    80004036:	7442                	ld	s0,48(sp)
    80004038:	74a2                	ld	s1,40(sp)
    8000403a:	7902                	ld	s2,32(sp)
    8000403c:	69e2                	ld	s3,24(sp)
    8000403e:	6a42                	ld	s4,16(sp)
    80004040:	6aa2                	ld	s5,8(sp)
    80004042:	6b02                	ld	s6,0(sp)
    80004044:	6121                	addi	sp,sp,64
    80004046:	8082                	ret
    80004048:	8082                	ret

000000008000404a <initlog>:
{
    8000404a:	7179                	addi	sp,sp,-48
    8000404c:	f406                	sd	ra,40(sp)
    8000404e:	f022                	sd	s0,32(sp)
    80004050:	ec26                	sd	s1,24(sp)
    80004052:	e84a                	sd	s2,16(sp)
    80004054:	e44e                	sd	s3,8(sp)
    80004056:	1800                	addi	s0,sp,48
    80004058:	892a                	mv	s2,a0
    8000405a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000405c:	0001d497          	auipc	s1,0x1d
    80004060:	21448493          	addi	s1,s1,532 # 80021270 <log>
    80004064:	00004597          	auipc	a1,0x4
    80004068:	76458593          	addi	a1,a1,1892 # 800087c8 <syscalls_strings+0x1e0>
    8000406c:	8526                	mv	a0,s1
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	ac4080e7          	jalr	-1340(ra) # 80000b32 <initlock>
  log.start = sb->logstart;
    80004076:	0149a583          	lw	a1,20(s3)
    8000407a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000407c:	0109a783          	lw	a5,16(s3)
    80004080:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004082:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004086:	854a                	mv	a0,s2
    80004088:	fffff097          	auipc	ra,0xfffff
    8000408c:	e8e080e7          	jalr	-370(ra) # 80002f16 <bread>
  log.lh.n = lh->n;
    80004090:	4d34                	lw	a3,88(a0)
    80004092:	d4d4                	sw	a3,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004094:	02d05663          	blez	a3,800040c0 <initlog+0x76>
    80004098:	05c50793          	addi	a5,a0,92
    8000409c:	0001d717          	auipc	a4,0x1d
    800040a0:	20470713          	addi	a4,a4,516 # 800212a0 <log+0x30>
    800040a4:	36fd                	addiw	a3,a3,-1
    800040a6:	02069613          	slli	a2,a3,0x20
    800040aa:	01e65693          	srli	a3,a2,0x1e
    800040ae:	06050613          	addi	a2,a0,96
    800040b2:	96b2                	add	a3,a3,a2
    log.lh.block[i] = lh->block[i];
    800040b4:	4390                	lw	a2,0(a5)
    800040b6:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800040b8:	0791                	addi	a5,a5,4
    800040ba:	0711                	addi	a4,a4,4
    800040bc:	fed79ce3          	bne	a5,a3,800040b4 <initlog+0x6a>
  brelse(buf);
    800040c0:	fffff097          	auipc	ra,0xfffff
    800040c4:	f86080e7          	jalr	-122(ra) # 80003046 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800040c8:	4505                	li	a0,1
    800040ca:	00000097          	auipc	ra,0x0
    800040ce:	ebc080e7          	jalr	-324(ra) # 80003f86 <install_trans>
  log.lh.n = 0;
    800040d2:	0001d797          	auipc	a5,0x1d
    800040d6:	1c07a523          	sw	zero,458(a5) # 8002129c <log+0x2c>
  write_head(); // clear the log
    800040da:	00000097          	auipc	ra,0x0
    800040de:	e30080e7          	jalr	-464(ra) # 80003f0a <write_head>
}
    800040e2:	70a2                	ld	ra,40(sp)
    800040e4:	7402                	ld	s0,32(sp)
    800040e6:	64e2                	ld	s1,24(sp)
    800040e8:	6942                	ld	s2,16(sp)
    800040ea:	69a2                	ld	s3,8(sp)
    800040ec:	6145                	addi	sp,sp,48
    800040ee:	8082                	ret

00000000800040f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040f0:	1101                	addi	sp,sp,-32
    800040f2:	ec06                	sd	ra,24(sp)
    800040f4:	e822                	sd	s0,16(sp)
    800040f6:	e426                	sd	s1,8(sp)
    800040f8:	e04a                	sd	s2,0(sp)
    800040fa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040fc:	0001d517          	auipc	a0,0x1d
    80004100:	17450513          	addi	a0,a0,372 # 80021270 <log>
    80004104:	ffffd097          	auipc	ra,0xffffd
    80004108:	abe080e7          	jalr	-1346(ra) # 80000bc2 <acquire>
  while(1){
    if(log.committing){
    8000410c:	0001d497          	auipc	s1,0x1d
    80004110:	16448493          	addi	s1,s1,356 # 80021270 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004114:	4979                	li	s2,30
    80004116:	a039                	j	80004124 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004118:	85a6                	mv	a1,s1
    8000411a:	8526                	mv	a0,s1
    8000411c:	ffffe097          	auipc	ra,0xffffe
    80004120:	f2a080e7          	jalr	-214(ra) # 80002046 <sleep>
    if(log.committing){
    80004124:	50dc                	lw	a5,36(s1)
    80004126:	fbed                	bnez	a5,80004118 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004128:	509c                	lw	a5,32(s1)
    8000412a:	0017871b          	addiw	a4,a5,1
    8000412e:	0007069b          	sext.w	a3,a4
    80004132:	0027179b          	slliw	a5,a4,0x2
    80004136:	9fb9                	addw	a5,a5,a4
    80004138:	0017979b          	slliw	a5,a5,0x1
    8000413c:	54d8                	lw	a4,44(s1)
    8000413e:	9fb9                	addw	a5,a5,a4
    80004140:	00f95963          	bge	s2,a5,80004152 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004144:	85a6                	mv	a1,s1
    80004146:	8526                	mv	a0,s1
    80004148:	ffffe097          	auipc	ra,0xffffe
    8000414c:	efe080e7          	jalr	-258(ra) # 80002046 <sleep>
    80004150:	bfd1                	j	80004124 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004152:	0001d517          	auipc	a0,0x1d
    80004156:	11e50513          	addi	a0,a0,286 # 80021270 <log>
    8000415a:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000415c:	ffffd097          	auipc	ra,0xffffd
    80004160:	b1a080e7          	jalr	-1254(ra) # 80000c76 <release>
      break;
    }
  }
}
    80004164:	60e2                	ld	ra,24(sp)
    80004166:	6442                	ld	s0,16(sp)
    80004168:	64a2                	ld	s1,8(sp)
    8000416a:	6902                	ld	s2,0(sp)
    8000416c:	6105                	addi	sp,sp,32
    8000416e:	8082                	ret

0000000080004170 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004170:	7139                	addi	sp,sp,-64
    80004172:	fc06                	sd	ra,56(sp)
    80004174:	f822                	sd	s0,48(sp)
    80004176:	f426                	sd	s1,40(sp)
    80004178:	f04a                	sd	s2,32(sp)
    8000417a:	ec4e                	sd	s3,24(sp)
    8000417c:	e852                	sd	s4,16(sp)
    8000417e:	e456                	sd	s5,8(sp)
    80004180:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004182:	0001d497          	auipc	s1,0x1d
    80004186:	0ee48493          	addi	s1,s1,238 # 80021270 <log>
    8000418a:	8526                	mv	a0,s1
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	a36080e7          	jalr	-1482(ra) # 80000bc2 <acquire>
  log.outstanding -= 1;
    80004194:	509c                	lw	a5,32(s1)
    80004196:	37fd                	addiw	a5,a5,-1
    80004198:	0007891b          	sext.w	s2,a5
    8000419c:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000419e:	50dc                	lw	a5,36(s1)
    800041a0:	e7b9                	bnez	a5,800041ee <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    800041a2:	04091e63          	bnez	s2,800041fe <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800041a6:	0001d497          	auipc	s1,0x1d
    800041aa:	0ca48493          	addi	s1,s1,202 # 80021270 <log>
    800041ae:	4785                	li	a5,1
    800041b0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800041b2:	8526                	mv	a0,s1
    800041b4:	ffffd097          	auipc	ra,0xffffd
    800041b8:	ac2080e7          	jalr	-1342(ra) # 80000c76 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800041bc:	54dc                	lw	a5,44(s1)
    800041be:	06f04763          	bgtz	a5,8000422c <end_op+0xbc>
    acquire(&log.lock);
    800041c2:	0001d497          	auipc	s1,0x1d
    800041c6:	0ae48493          	addi	s1,s1,174 # 80021270 <log>
    800041ca:	8526                	mv	a0,s1
    800041cc:	ffffd097          	auipc	ra,0xffffd
    800041d0:	9f6080e7          	jalr	-1546(ra) # 80000bc2 <acquire>
    log.committing = 0;
    800041d4:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800041d8:	8526                	mv	a0,s1
    800041da:	ffffe097          	auipc	ra,0xffffe
    800041de:	ff8080e7          	jalr	-8(ra) # 800021d2 <wakeup>
    release(&log.lock);
    800041e2:	8526                	mv	a0,s1
    800041e4:	ffffd097          	auipc	ra,0xffffd
    800041e8:	a92080e7          	jalr	-1390(ra) # 80000c76 <release>
}
    800041ec:	a03d                	j	8000421a <end_op+0xaa>
    panic("log.committing");
    800041ee:	00004517          	auipc	a0,0x4
    800041f2:	5e250513          	addi	a0,a0,1506 # 800087d0 <syscalls_strings+0x1e8>
    800041f6:	ffffc097          	auipc	ra,0xffffc
    800041fa:	334080e7          	jalr	820(ra) # 8000052a <panic>
    wakeup(&log);
    800041fe:	0001d497          	auipc	s1,0x1d
    80004202:	07248493          	addi	s1,s1,114 # 80021270 <log>
    80004206:	8526                	mv	a0,s1
    80004208:	ffffe097          	auipc	ra,0xffffe
    8000420c:	fca080e7          	jalr	-54(ra) # 800021d2 <wakeup>
  release(&log.lock);
    80004210:	8526                	mv	a0,s1
    80004212:	ffffd097          	auipc	ra,0xffffd
    80004216:	a64080e7          	jalr	-1436(ra) # 80000c76 <release>
}
    8000421a:	70e2                	ld	ra,56(sp)
    8000421c:	7442                	ld	s0,48(sp)
    8000421e:	74a2                	ld	s1,40(sp)
    80004220:	7902                	ld	s2,32(sp)
    80004222:	69e2                	ld	s3,24(sp)
    80004224:	6a42                	ld	s4,16(sp)
    80004226:	6aa2                	ld	s5,8(sp)
    80004228:	6121                	addi	sp,sp,64
    8000422a:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    8000422c:	0001da97          	auipc	s5,0x1d
    80004230:	074a8a93          	addi	s5,s5,116 # 800212a0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004234:	0001da17          	auipc	s4,0x1d
    80004238:	03ca0a13          	addi	s4,s4,60 # 80021270 <log>
    8000423c:	018a2583          	lw	a1,24(s4)
    80004240:	012585bb          	addw	a1,a1,s2
    80004244:	2585                	addiw	a1,a1,1
    80004246:	028a2503          	lw	a0,40(s4)
    8000424a:	fffff097          	auipc	ra,0xfffff
    8000424e:	ccc080e7          	jalr	-820(ra) # 80002f16 <bread>
    80004252:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004254:	000aa583          	lw	a1,0(s5)
    80004258:	028a2503          	lw	a0,40(s4)
    8000425c:	fffff097          	auipc	ra,0xfffff
    80004260:	cba080e7          	jalr	-838(ra) # 80002f16 <bread>
    80004264:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004266:	40000613          	li	a2,1024
    8000426a:	05850593          	addi	a1,a0,88
    8000426e:	05848513          	addi	a0,s1,88
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	aa8080e7          	jalr	-1368(ra) # 80000d1a <memmove>
    bwrite(to);  // write the log
    8000427a:	8526                	mv	a0,s1
    8000427c:	fffff097          	auipc	ra,0xfffff
    80004280:	d8c080e7          	jalr	-628(ra) # 80003008 <bwrite>
    brelse(from);
    80004284:	854e                	mv	a0,s3
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	dc0080e7          	jalr	-576(ra) # 80003046 <brelse>
    brelse(to);
    8000428e:	8526                	mv	a0,s1
    80004290:	fffff097          	auipc	ra,0xfffff
    80004294:	db6080e7          	jalr	-586(ra) # 80003046 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004298:	2905                	addiw	s2,s2,1
    8000429a:	0a91                	addi	s5,s5,4
    8000429c:	02ca2783          	lw	a5,44(s4)
    800042a0:	f8f94ee3          	blt	s2,a5,8000423c <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800042a4:	00000097          	auipc	ra,0x0
    800042a8:	c66080e7          	jalr	-922(ra) # 80003f0a <write_head>
    install_trans(0); // Now install writes to home locations
    800042ac:	4501                	li	a0,0
    800042ae:	00000097          	auipc	ra,0x0
    800042b2:	cd8080e7          	jalr	-808(ra) # 80003f86 <install_trans>
    log.lh.n = 0;
    800042b6:	0001d797          	auipc	a5,0x1d
    800042ba:	fe07a323          	sw	zero,-26(a5) # 8002129c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800042be:	00000097          	auipc	ra,0x0
    800042c2:	c4c080e7          	jalr	-948(ra) # 80003f0a <write_head>
    800042c6:	bdf5                	j	800041c2 <end_op+0x52>

00000000800042c8 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800042c8:	1101                	addi	sp,sp,-32
    800042ca:	ec06                	sd	ra,24(sp)
    800042cc:	e822                	sd	s0,16(sp)
    800042ce:	e426                	sd	s1,8(sp)
    800042d0:	e04a                	sd	s2,0(sp)
    800042d2:	1000                	addi	s0,sp,32
    800042d4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800042d6:	0001d917          	auipc	s2,0x1d
    800042da:	f9a90913          	addi	s2,s2,-102 # 80021270 <log>
    800042de:	854a                	mv	a0,s2
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	8e2080e7          	jalr	-1822(ra) # 80000bc2 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800042e8:	02c92603          	lw	a2,44(s2)
    800042ec:	47f5                	li	a5,29
    800042ee:	06c7c563          	blt	a5,a2,80004358 <log_write+0x90>
    800042f2:	0001d797          	auipc	a5,0x1d
    800042f6:	f9a7a783          	lw	a5,-102(a5) # 8002128c <log+0x1c>
    800042fa:	37fd                	addiw	a5,a5,-1
    800042fc:	04f65e63          	bge	a2,a5,80004358 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004300:	0001d797          	auipc	a5,0x1d
    80004304:	f907a783          	lw	a5,-112(a5) # 80021290 <log+0x20>
    80004308:	06f05063          	blez	a5,80004368 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000430c:	4781                	li	a5,0
    8000430e:	06c05563          	blez	a2,80004378 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    80004312:	44cc                	lw	a1,12(s1)
    80004314:	0001d717          	auipc	a4,0x1d
    80004318:	f8c70713          	addi	a4,a4,-116 # 800212a0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000431c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    8000431e:	4314                	lw	a3,0(a4)
    80004320:	04b68c63          	beq	a3,a1,80004378 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80004324:	2785                	addiw	a5,a5,1
    80004326:	0711                	addi	a4,a4,4
    80004328:	fef61be3          	bne	a2,a5,8000431e <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000432c:	0621                	addi	a2,a2,8
    8000432e:	060a                	slli	a2,a2,0x2
    80004330:	0001d797          	auipc	a5,0x1d
    80004334:	f4078793          	addi	a5,a5,-192 # 80021270 <log>
    80004338:	963e                	add	a2,a2,a5
    8000433a:	44dc                	lw	a5,12(s1)
    8000433c:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000433e:	8526                	mv	a0,s1
    80004340:	fffff097          	auipc	ra,0xfffff
    80004344:	da4080e7          	jalr	-604(ra) # 800030e4 <bpin>
    log.lh.n++;
    80004348:	0001d717          	auipc	a4,0x1d
    8000434c:	f2870713          	addi	a4,a4,-216 # 80021270 <log>
    80004350:	575c                	lw	a5,44(a4)
    80004352:	2785                	addiw	a5,a5,1
    80004354:	d75c                	sw	a5,44(a4)
    80004356:	a835                	j	80004392 <log_write+0xca>
    panic("too big a transaction");
    80004358:	00004517          	auipc	a0,0x4
    8000435c:	48850513          	addi	a0,a0,1160 # 800087e0 <syscalls_strings+0x1f8>
    80004360:	ffffc097          	auipc	ra,0xffffc
    80004364:	1ca080e7          	jalr	458(ra) # 8000052a <panic>
    panic("log_write outside of trans");
    80004368:	00004517          	auipc	a0,0x4
    8000436c:	49050513          	addi	a0,a0,1168 # 800087f8 <syscalls_strings+0x210>
    80004370:	ffffc097          	auipc	ra,0xffffc
    80004374:	1ba080e7          	jalr	442(ra) # 8000052a <panic>
  log.lh.block[i] = b->blockno;
    80004378:	00878713          	addi	a4,a5,8
    8000437c:	00271693          	slli	a3,a4,0x2
    80004380:	0001d717          	auipc	a4,0x1d
    80004384:	ef070713          	addi	a4,a4,-272 # 80021270 <log>
    80004388:	9736                	add	a4,a4,a3
    8000438a:	44d4                	lw	a3,12(s1)
    8000438c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000438e:	faf608e3          	beq	a2,a5,8000433e <log_write+0x76>
  }
  release(&log.lock);
    80004392:	0001d517          	auipc	a0,0x1d
    80004396:	ede50513          	addi	a0,a0,-290 # 80021270 <log>
    8000439a:	ffffd097          	auipc	ra,0xffffd
    8000439e:	8dc080e7          	jalr	-1828(ra) # 80000c76 <release>
}
    800043a2:	60e2                	ld	ra,24(sp)
    800043a4:	6442                	ld	s0,16(sp)
    800043a6:	64a2                	ld	s1,8(sp)
    800043a8:	6902                	ld	s2,0(sp)
    800043aa:	6105                	addi	sp,sp,32
    800043ac:	8082                	ret

00000000800043ae <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800043ae:	1101                	addi	sp,sp,-32
    800043b0:	ec06                	sd	ra,24(sp)
    800043b2:	e822                	sd	s0,16(sp)
    800043b4:	e426                	sd	s1,8(sp)
    800043b6:	e04a                	sd	s2,0(sp)
    800043b8:	1000                	addi	s0,sp,32
    800043ba:	84aa                	mv	s1,a0
    800043bc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800043be:	00004597          	auipc	a1,0x4
    800043c2:	45a58593          	addi	a1,a1,1114 # 80008818 <syscalls_strings+0x230>
    800043c6:	0521                	addi	a0,a0,8
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	76a080e7          	jalr	1898(ra) # 80000b32 <initlock>
  lk->name = name;
    800043d0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800043d4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800043d8:	0204a423          	sw	zero,40(s1)
}
    800043dc:	60e2                	ld	ra,24(sp)
    800043de:	6442                	ld	s0,16(sp)
    800043e0:	64a2                	ld	s1,8(sp)
    800043e2:	6902                	ld	s2,0(sp)
    800043e4:	6105                	addi	sp,sp,32
    800043e6:	8082                	ret

00000000800043e8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800043e8:	1101                	addi	sp,sp,-32
    800043ea:	ec06                	sd	ra,24(sp)
    800043ec:	e822                	sd	s0,16(sp)
    800043ee:	e426                	sd	s1,8(sp)
    800043f0:	e04a                	sd	s2,0(sp)
    800043f2:	1000                	addi	s0,sp,32
    800043f4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800043f6:	00850913          	addi	s2,a0,8
    800043fa:	854a                	mv	a0,s2
    800043fc:	ffffc097          	auipc	ra,0xffffc
    80004400:	7c6080e7          	jalr	1990(ra) # 80000bc2 <acquire>
  while (lk->locked) {
    80004404:	409c                	lw	a5,0(s1)
    80004406:	cb89                	beqz	a5,80004418 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004408:	85ca                	mv	a1,s2
    8000440a:	8526                	mv	a0,s1
    8000440c:	ffffe097          	auipc	ra,0xffffe
    80004410:	c3a080e7          	jalr	-966(ra) # 80002046 <sleep>
  while (lk->locked) {
    80004414:	409c                	lw	a5,0(s1)
    80004416:	fbed                	bnez	a5,80004408 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004418:	4785                	li	a5,1
    8000441a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000441c:	ffffd097          	auipc	ra,0xffffd
    80004420:	562080e7          	jalr	1378(ra) # 8000197e <myproc>
    80004424:	591c                	lw	a5,48(a0)
    80004426:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004428:	854a                	mv	a0,s2
    8000442a:	ffffd097          	auipc	ra,0xffffd
    8000442e:	84c080e7          	jalr	-1972(ra) # 80000c76 <release>
}
    80004432:	60e2                	ld	ra,24(sp)
    80004434:	6442                	ld	s0,16(sp)
    80004436:	64a2                	ld	s1,8(sp)
    80004438:	6902                	ld	s2,0(sp)
    8000443a:	6105                	addi	sp,sp,32
    8000443c:	8082                	ret

000000008000443e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000443e:	1101                	addi	sp,sp,-32
    80004440:	ec06                	sd	ra,24(sp)
    80004442:	e822                	sd	s0,16(sp)
    80004444:	e426                	sd	s1,8(sp)
    80004446:	e04a                	sd	s2,0(sp)
    80004448:	1000                	addi	s0,sp,32
    8000444a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000444c:	00850913          	addi	s2,a0,8
    80004450:	854a                	mv	a0,s2
    80004452:	ffffc097          	auipc	ra,0xffffc
    80004456:	770080e7          	jalr	1904(ra) # 80000bc2 <acquire>
  lk->locked = 0;
    8000445a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000445e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004462:	8526                	mv	a0,s1
    80004464:	ffffe097          	auipc	ra,0xffffe
    80004468:	d6e080e7          	jalr	-658(ra) # 800021d2 <wakeup>
  release(&lk->lk);
    8000446c:	854a                	mv	a0,s2
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	808080e7          	jalr	-2040(ra) # 80000c76 <release>
}
    80004476:	60e2                	ld	ra,24(sp)
    80004478:	6442                	ld	s0,16(sp)
    8000447a:	64a2                	ld	s1,8(sp)
    8000447c:	6902                	ld	s2,0(sp)
    8000447e:	6105                	addi	sp,sp,32
    80004480:	8082                	ret

0000000080004482 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004482:	7179                	addi	sp,sp,-48
    80004484:	f406                	sd	ra,40(sp)
    80004486:	f022                	sd	s0,32(sp)
    80004488:	ec26                	sd	s1,24(sp)
    8000448a:	e84a                	sd	s2,16(sp)
    8000448c:	e44e                	sd	s3,8(sp)
    8000448e:	1800                	addi	s0,sp,48
    80004490:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004492:	00850913          	addi	s2,a0,8
    80004496:	854a                	mv	a0,s2
    80004498:	ffffc097          	auipc	ra,0xffffc
    8000449c:	72a080e7          	jalr	1834(ra) # 80000bc2 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800044a0:	409c                	lw	a5,0(s1)
    800044a2:	ef99                	bnez	a5,800044c0 <holdingsleep+0x3e>
    800044a4:	4481                	li	s1,0
  release(&lk->lk);
    800044a6:	854a                	mv	a0,s2
    800044a8:	ffffc097          	auipc	ra,0xffffc
    800044ac:	7ce080e7          	jalr	1998(ra) # 80000c76 <release>
  return r;
}
    800044b0:	8526                	mv	a0,s1
    800044b2:	70a2                	ld	ra,40(sp)
    800044b4:	7402                	ld	s0,32(sp)
    800044b6:	64e2                	ld	s1,24(sp)
    800044b8:	6942                	ld	s2,16(sp)
    800044ba:	69a2                	ld	s3,8(sp)
    800044bc:	6145                	addi	sp,sp,48
    800044be:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800044c0:	0284a983          	lw	s3,40(s1)
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	4ba080e7          	jalr	1210(ra) # 8000197e <myproc>
    800044cc:	5904                	lw	s1,48(a0)
    800044ce:	413484b3          	sub	s1,s1,s3
    800044d2:	0014b493          	seqz	s1,s1
    800044d6:	bfc1                	j	800044a6 <holdingsleep+0x24>

00000000800044d8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800044d8:	1141                	addi	sp,sp,-16
    800044da:	e406                	sd	ra,8(sp)
    800044dc:	e022                	sd	s0,0(sp)
    800044de:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800044e0:	00004597          	auipc	a1,0x4
    800044e4:	34858593          	addi	a1,a1,840 # 80008828 <syscalls_strings+0x240>
    800044e8:	0001d517          	auipc	a0,0x1d
    800044ec:	ed050513          	addi	a0,a0,-304 # 800213b8 <ftable>
    800044f0:	ffffc097          	auipc	ra,0xffffc
    800044f4:	642080e7          	jalr	1602(ra) # 80000b32 <initlock>
}
    800044f8:	60a2                	ld	ra,8(sp)
    800044fa:	6402                	ld	s0,0(sp)
    800044fc:	0141                	addi	sp,sp,16
    800044fe:	8082                	ret

0000000080004500 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004500:	1101                	addi	sp,sp,-32
    80004502:	ec06                	sd	ra,24(sp)
    80004504:	e822                	sd	s0,16(sp)
    80004506:	e426                	sd	s1,8(sp)
    80004508:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000450a:	0001d517          	auipc	a0,0x1d
    8000450e:	eae50513          	addi	a0,a0,-338 # 800213b8 <ftable>
    80004512:	ffffc097          	auipc	ra,0xffffc
    80004516:	6b0080e7          	jalr	1712(ra) # 80000bc2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000451a:	0001d497          	auipc	s1,0x1d
    8000451e:	eb648493          	addi	s1,s1,-330 # 800213d0 <ftable+0x18>
    80004522:	0001e717          	auipc	a4,0x1e
    80004526:	e4e70713          	addi	a4,a4,-434 # 80022370 <ftable+0xfb8>
    if(f->ref == 0){
    8000452a:	40dc                	lw	a5,4(s1)
    8000452c:	cf99                	beqz	a5,8000454a <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000452e:	02848493          	addi	s1,s1,40
    80004532:	fee49ce3          	bne	s1,a4,8000452a <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004536:	0001d517          	auipc	a0,0x1d
    8000453a:	e8250513          	addi	a0,a0,-382 # 800213b8 <ftable>
    8000453e:	ffffc097          	auipc	ra,0xffffc
    80004542:	738080e7          	jalr	1848(ra) # 80000c76 <release>
  return 0;
    80004546:	4481                	li	s1,0
    80004548:	a819                	j	8000455e <filealloc+0x5e>
      f->ref = 1;
    8000454a:	4785                	li	a5,1
    8000454c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000454e:	0001d517          	auipc	a0,0x1d
    80004552:	e6a50513          	addi	a0,a0,-406 # 800213b8 <ftable>
    80004556:	ffffc097          	auipc	ra,0xffffc
    8000455a:	720080e7          	jalr	1824(ra) # 80000c76 <release>
}
    8000455e:	8526                	mv	a0,s1
    80004560:	60e2                	ld	ra,24(sp)
    80004562:	6442                	ld	s0,16(sp)
    80004564:	64a2                	ld	s1,8(sp)
    80004566:	6105                	addi	sp,sp,32
    80004568:	8082                	ret

000000008000456a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000456a:	1101                	addi	sp,sp,-32
    8000456c:	ec06                	sd	ra,24(sp)
    8000456e:	e822                	sd	s0,16(sp)
    80004570:	e426                	sd	s1,8(sp)
    80004572:	1000                	addi	s0,sp,32
    80004574:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004576:	0001d517          	auipc	a0,0x1d
    8000457a:	e4250513          	addi	a0,a0,-446 # 800213b8 <ftable>
    8000457e:	ffffc097          	auipc	ra,0xffffc
    80004582:	644080e7          	jalr	1604(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    80004586:	40dc                	lw	a5,4(s1)
    80004588:	02f05263          	blez	a5,800045ac <filedup+0x42>
    panic("filedup");
  f->ref++;
    8000458c:	2785                	addiw	a5,a5,1
    8000458e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004590:	0001d517          	auipc	a0,0x1d
    80004594:	e2850513          	addi	a0,a0,-472 # 800213b8 <ftable>
    80004598:	ffffc097          	auipc	ra,0xffffc
    8000459c:	6de080e7          	jalr	1758(ra) # 80000c76 <release>
  return f;
}
    800045a0:	8526                	mv	a0,s1
    800045a2:	60e2                	ld	ra,24(sp)
    800045a4:	6442                	ld	s0,16(sp)
    800045a6:	64a2                	ld	s1,8(sp)
    800045a8:	6105                	addi	sp,sp,32
    800045aa:	8082                	ret
    panic("filedup");
    800045ac:	00004517          	auipc	a0,0x4
    800045b0:	28450513          	addi	a0,a0,644 # 80008830 <syscalls_strings+0x248>
    800045b4:	ffffc097          	auipc	ra,0xffffc
    800045b8:	f76080e7          	jalr	-138(ra) # 8000052a <panic>

00000000800045bc <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800045bc:	7139                	addi	sp,sp,-64
    800045be:	fc06                	sd	ra,56(sp)
    800045c0:	f822                	sd	s0,48(sp)
    800045c2:	f426                	sd	s1,40(sp)
    800045c4:	f04a                	sd	s2,32(sp)
    800045c6:	ec4e                	sd	s3,24(sp)
    800045c8:	e852                	sd	s4,16(sp)
    800045ca:	e456                	sd	s5,8(sp)
    800045cc:	0080                	addi	s0,sp,64
    800045ce:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800045d0:	0001d517          	auipc	a0,0x1d
    800045d4:	de850513          	addi	a0,a0,-536 # 800213b8 <ftable>
    800045d8:	ffffc097          	auipc	ra,0xffffc
    800045dc:	5ea080e7          	jalr	1514(ra) # 80000bc2 <acquire>
  if(f->ref < 1)
    800045e0:	40dc                	lw	a5,4(s1)
    800045e2:	06f05163          	blez	a5,80004644 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800045e6:	37fd                	addiw	a5,a5,-1
    800045e8:	0007871b          	sext.w	a4,a5
    800045ec:	c0dc                	sw	a5,4(s1)
    800045ee:	06e04363          	bgtz	a4,80004654 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800045f2:	0004a903          	lw	s2,0(s1)
    800045f6:	0094ca83          	lbu	s5,9(s1)
    800045fa:	0104ba03          	ld	s4,16(s1)
    800045fe:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004602:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004606:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000460a:	0001d517          	auipc	a0,0x1d
    8000460e:	dae50513          	addi	a0,a0,-594 # 800213b8 <ftable>
    80004612:	ffffc097          	auipc	ra,0xffffc
    80004616:	664080e7          	jalr	1636(ra) # 80000c76 <release>

  if(ff.type == FD_PIPE){
    8000461a:	4785                	li	a5,1
    8000461c:	04f90d63          	beq	s2,a5,80004676 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004620:	3979                	addiw	s2,s2,-2
    80004622:	4785                	li	a5,1
    80004624:	0527e063          	bltu	a5,s2,80004664 <fileclose+0xa8>
    begin_op();
    80004628:	00000097          	auipc	ra,0x0
    8000462c:	ac8080e7          	jalr	-1336(ra) # 800040f0 <begin_op>
    iput(ff.ip);
    80004630:	854e                	mv	a0,s3
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	2a2080e7          	jalr	674(ra) # 800038d4 <iput>
    end_op();
    8000463a:	00000097          	auipc	ra,0x0
    8000463e:	b36080e7          	jalr	-1226(ra) # 80004170 <end_op>
    80004642:	a00d                	j	80004664 <fileclose+0xa8>
    panic("fileclose");
    80004644:	00004517          	auipc	a0,0x4
    80004648:	1f450513          	addi	a0,a0,500 # 80008838 <syscalls_strings+0x250>
    8000464c:	ffffc097          	auipc	ra,0xffffc
    80004650:	ede080e7          	jalr	-290(ra) # 8000052a <panic>
    release(&ftable.lock);
    80004654:	0001d517          	auipc	a0,0x1d
    80004658:	d6450513          	addi	a0,a0,-668 # 800213b8 <ftable>
    8000465c:	ffffc097          	auipc	ra,0xffffc
    80004660:	61a080e7          	jalr	1562(ra) # 80000c76 <release>
  }
}
    80004664:	70e2                	ld	ra,56(sp)
    80004666:	7442                	ld	s0,48(sp)
    80004668:	74a2                	ld	s1,40(sp)
    8000466a:	7902                	ld	s2,32(sp)
    8000466c:	69e2                	ld	s3,24(sp)
    8000466e:	6a42                	ld	s4,16(sp)
    80004670:	6aa2                	ld	s5,8(sp)
    80004672:	6121                	addi	sp,sp,64
    80004674:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004676:	85d6                	mv	a1,s5
    80004678:	8552                	mv	a0,s4
    8000467a:	00000097          	auipc	ra,0x0
    8000467e:	34c080e7          	jalr	844(ra) # 800049c6 <pipeclose>
    80004682:	b7cd                	j	80004664 <fileclose+0xa8>

0000000080004684 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004684:	715d                	addi	sp,sp,-80
    80004686:	e486                	sd	ra,72(sp)
    80004688:	e0a2                	sd	s0,64(sp)
    8000468a:	fc26                	sd	s1,56(sp)
    8000468c:	f84a                	sd	s2,48(sp)
    8000468e:	f44e                	sd	s3,40(sp)
    80004690:	0880                	addi	s0,sp,80
    80004692:	84aa                	mv	s1,a0
    80004694:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004696:	ffffd097          	auipc	ra,0xffffd
    8000469a:	2e8080e7          	jalr	744(ra) # 8000197e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000469e:	409c                	lw	a5,0(s1)
    800046a0:	37f9                	addiw	a5,a5,-2
    800046a2:	4705                	li	a4,1
    800046a4:	04f76763          	bltu	a4,a5,800046f2 <filestat+0x6e>
    800046a8:	892a                	mv	s2,a0
    ilock(f->ip);
    800046aa:	6c88                	ld	a0,24(s1)
    800046ac:	fffff097          	auipc	ra,0xfffff
    800046b0:	06e080e7          	jalr	110(ra) # 8000371a <ilock>
    stati(f->ip, &st);
    800046b4:	fb840593          	addi	a1,s0,-72
    800046b8:	6c88                	ld	a0,24(s1)
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	2ea080e7          	jalr	746(ra) # 800039a4 <stati>
    iunlock(f->ip);
    800046c2:	6c88                	ld	a0,24(s1)
    800046c4:	fffff097          	auipc	ra,0xfffff
    800046c8:	118080e7          	jalr	280(ra) # 800037dc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800046cc:	46e1                	li	a3,24
    800046ce:	fb840613          	addi	a2,s0,-72
    800046d2:	85ce                	mv	a1,s3
    800046d4:	05093503          	ld	a0,80(s2)
    800046d8:	ffffd097          	auipc	ra,0xffffd
    800046dc:	f66080e7          	jalr	-154(ra) # 8000163e <copyout>
    800046e0:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800046e4:	60a6                	ld	ra,72(sp)
    800046e6:	6406                	ld	s0,64(sp)
    800046e8:	74e2                	ld	s1,56(sp)
    800046ea:	7942                	ld	s2,48(sp)
    800046ec:	79a2                	ld	s3,40(sp)
    800046ee:	6161                	addi	sp,sp,80
    800046f0:	8082                	ret
  return -1;
    800046f2:	557d                	li	a0,-1
    800046f4:	bfc5                	j	800046e4 <filestat+0x60>

00000000800046f6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800046f6:	7179                	addi	sp,sp,-48
    800046f8:	f406                	sd	ra,40(sp)
    800046fa:	f022                	sd	s0,32(sp)
    800046fc:	ec26                	sd	s1,24(sp)
    800046fe:	e84a                	sd	s2,16(sp)
    80004700:	e44e                	sd	s3,8(sp)
    80004702:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004704:	00854783          	lbu	a5,8(a0)
    80004708:	c3d5                	beqz	a5,800047ac <fileread+0xb6>
    8000470a:	84aa                	mv	s1,a0
    8000470c:	89ae                	mv	s3,a1
    8000470e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004710:	411c                	lw	a5,0(a0)
    80004712:	4705                	li	a4,1
    80004714:	04e78963          	beq	a5,a4,80004766 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004718:	470d                	li	a4,3
    8000471a:	04e78d63          	beq	a5,a4,80004774 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000471e:	4709                	li	a4,2
    80004720:	06e79e63          	bne	a5,a4,8000479c <fileread+0xa6>
    ilock(f->ip);
    80004724:	6d08                	ld	a0,24(a0)
    80004726:	fffff097          	auipc	ra,0xfffff
    8000472a:	ff4080e7          	jalr	-12(ra) # 8000371a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000472e:	874a                	mv	a4,s2
    80004730:	5094                	lw	a3,32(s1)
    80004732:	864e                	mv	a2,s3
    80004734:	4585                	li	a1,1
    80004736:	6c88                	ld	a0,24(s1)
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	296080e7          	jalr	662(ra) # 800039ce <readi>
    80004740:	892a                	mv	s2,a0
    80004742:	00a05563          	blez	a0,8000474c <fileread+0x56>
      f->off += r;
    80004746:	509c                	lw	a5,32(s1)
    80004748:	9fa9                	addw	a5,a5,a0
    8000474a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000474c:	6c88                	ld	a0,24(s1)
    8000474e:	fffff097          	auipc	ra,0xfffff
    80004752:	08e080e7          	jalr	142(ra) # 800037dc <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004756:	854a                	mv	a0,s2
    80004758:	70a2                	ld	ra,40(sp)
    8000475a:	7402                	ld	s0,32(sp)
    8000475c:	64e2                	ld	s1,24(sp)
    8000475e:	6942                	ld	s2,16(sp)
    80004760:	69a2                	ld	s3,8(sp)
    80004762:	6145                	addi	sp,sp,48
    80004764:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004766:	6908                	ld	a0,16(a0)
    80004768:	00000097          	auipc	ra,0x0
    8000476c:	3c0080e7          	jalr	960(ra) # 80004b28 <piperead>
    80004770:	892a                	mv	s2,a0
    80004772:	b7d5                	j	80004756 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004774:	02451783          	lh	a5,36(a0)
    80004778:	03079693          	slli	a3,a5,0x30
    8000477c:	92c1                	srli	a3,a3,0x30
    8000477e:	4725                	li	a4,9
    80004780:	02d76863          	bltu	a4,a3,800047b0 <fileread+0xba>
    80004784:	0792                	slli	a5,a5,0x4
    80004786:	0001d717          	auipc	a4,0x1d
    8000478a:	b9270713          	addi	a4,a4,-1134 # 80021318 <devsw>
    8000478e:	97ba                	add	a5,a5,a4
    80004790:	639c                	ld	a5,0(a5)
    80004792:	c38d                	beqz	a5,800047b4 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80004794:	4505                	li	a0,1
    80004796:	9782                	jalr	a5
    80004798:	892a                	mv	s2,a0
    8000479a:	bf75                	j	80004756 <fileread+0x60>
    panic("fileread");
    8000479c:	00004517          	auipc	a0,0x4
    800047a0:	0ac50513          	addi	a0,a0,172 # 80008848 <syscalls_strings+0x260>
    800047a4:	ffffc097          	auipc	ra,0xffffc
    800047a8:	d86080e7          	jalr	-634(ra) # 8000052a <panic>
    return -1;
    800047ac:	597d                	li	s2,-1
    800047ae:	b765                	j	80004756 <fileread+0x60>
      return -1;
    800047b0:	597d                	li	s2,-1
    800047b2:	b755                	j	80004756 <fileread+0x60>
    800047b4:	597d                	li	s2,-1
    800047b6:	b745                	j	80004756 <fileread+0x60>

00000000800047b8 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    800047b8:	715d                	addi	sp,sp,-80
    800047ba:	e486                	sd	ra,72(sp)
    800047bc:	e0a2                	sd	s0,64(sp)
    800047be:	fc26                	sd	s1,56(sp)
    800047c0:	f84a                	sd	s2,48(sp)
    800047c2:	f44e                	sd	s3,40(sp)
    800047c4:	f052                	sd	s4,32(sp)
    800047c6:	ec56                	sd	s5,24(sp)
    800047c8:	e85a                	sd	s6,16(sp)
    800047ca:	e45e                	sd	s7,8(sp)
    800047cc:	e062                	sd	s8,0(sp)
    800047ce:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    800047d0:	00954783          	lbu	a5,9(a0)
    800047d4:	10078663          	beqz	a5,800048e0 <filewrite+0x128>
    800047d8:	892a                	mv	s2,a0
    800047da:	8aae                	mv	s5,a1
    800047dc:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800047de:	411c                	lw	a5,0(a0)
    800047e0:	4705                	li	a4,1
    800047e2:	02e78263          	beq	a5,a4,80004806 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800047e6:	470d                	li	a4,3
    800047e8:	02e78663          	beq	a5,a4,80004814 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800047ec:	4709                	li	a4,2
    800047ee:	0ee79163          	bne	a5,a4,800048d0 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800047f2:	0ac05d63          	blez	a2,800048ac <filewrite+0xf4>
    int i = 0;
    800047f6:	4981                	li	s3,0
    800047f8:	6b05                	lui	s6,0x1
    800047fa:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800047fe:	6b85                	lui	s7,0x1
    80004800:	c00b8b9b          	addiw	s7,s7,-1024
    80004804:	a861                	j	8000489c <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004806:	6908                	ld	a0,16(a0)
    80004808:	00000097          	auipc	ra,0x0
    8000480c:	22e080e7          	jalr	558(ra) # 80004a36 <pipewrite>
    80004810:	8a2a                	mv	s4,a0
    80004812:	a045                	j	800048b2 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004814:	02451783          	lh	a5,36(a0)
    80004818:	03079693          	slli	a3,a5,0x30
    8000481c:	92c1                	srli	a3,a3,0x30
    8000481e:	4725                	li	a4,9
    80004820:	0cd76263          	bltu	a4,a3,800048e4 <filewrite+0x12c>
    80004824:	0792                	slli	a5,a5,0x4
    80004826:	0001d717          	auipc	a4,0x1d
    8000482a:	af270713          	addi	a4,a4,-1294 # 80021318 <devsw>
    8000482e:	97ba                	add	a5,a5,a4
    80004830:	679c                	ld	a5,8(a5)
    80004832:	cbdd                	beqz	a5,800048e8 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80004834:	4505                	li	a0,1
    80004836:	9782                	jalr	a5
    80004838:	8a2a                	mv	s4,a0
    8000483a:	a8a5                	j	800048b2 <filewrite+0xfa>
    8000483c:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004840:	00000097          	auipc	ra,0x0
    80004844:	8b0080e7          	jalr	-1872(ra) # 800040f0 <begin_op>
      ilock(f->ip);
    80004848:	01893503          	ld	a0,24(s2)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	ece080e7          	jalr	-306(ra) # 8000371a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004854:	8762                	mv	a4,s8
    80004856:	02092683          	lw	a3,32(s2)
    8000485a:	01598633          	add	a2,s3,s5
    8000485e:	4585                	li	a1,1
    80004860:	01893503          	ld	a0,24(s2)
    80004864:	fffff097          	auipc	ra,0xfffff
    80004868:	262080e7          	jalr	610(ra) # 80003ac6 <writei>
    8000486c:	84aa                	mv	s1,a0
    8000486e:	00a05763          	blez	a0,8000487c <filewrite+0xc4>
        f->off += r;
    80004872:	02092783          	lw	a5,32(s2)
    80004876:	9fa9                	addw	a5,a5,a0
    80004878:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000487c:	01893503          	ld	a0,24(s2)
    80004880:	fffff097          	auipc	ra,0xfffff
    80004884:	f5c080e7          	jalr	-164(ra) # 800037dc <iunlock>
      end_op();
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	8e8080e7          	jalr	-1816(ra) # 80004170 <end_op>

      if(r != n1){
    80004890:	009c1f63          	bne	s8,s1,800048ae <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80004894:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004898:	0149db63          	bge	s3,s4,800048ae <filewrite+0xf6>
      int n1 = n - i;
    8000489c:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    800048a0:	84be                	mv	s1,a5
    800048a2:	2781                	sext.w	a5,a5
    800048a4:	f8fb5ce3          	bge	s6,a5,8000483c <filewrite+0x84>
    800048a8:	84de                	mv	s1,s7
    800048aa:	bf49                	j	8000483c <filewrite+0x84>
    int i = 0;
    800048ac:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    800048ae:	013a1f63          	bne	s4,s3,800048cc <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800048b2:	8552                	mv	a0,s4
    800048b4:	60a6                	ld	ra,72(sp)
    800048b6:	6406                	ld	s0,64(sp)
    800048b8:	74e2                	ld	s1,56(sp)
    800048ba:	7942                	ld	s2,48(sp)
    800048bc:	79a2                	ld	s3,40(sp)
    800048be:	7a02                	ld	s4,32(sp)
    800048c0:	6ae2                	ld	s5,24(sp)
    800048c2:	6b42                	ld	s6,16(sp)
    800048c4:	6ba2                	ld	s7,8(sp)
    800048c6:	6c02                	ld	s8,0(sp)
    800048c8:	6161                	addi	sp,sp,80
    800048ca:	8082                	ret
    ret = (i == n ? n : -1);
    800048cc:	5a7d                	li	s4,-1
    800048ce:	b7d5                	j	800048b2 <filewrite+0xfa>
    panic("filewrite");
    800048d0:	00004517          	auipc	a0,0x4
    800048d4:	f8850513          	addi	a0,a0,-120 # 80008858 <syscalls_strings+0x270>
    800048d8:	ffffc097          	auipc	ra,0xffffc
    800048dc:	c52080e7          	jalr	-942(ra) # 8000052a <panic>
    return -1;
    800048e0:	5a7d                	li	s4,-1
    800048e2:	bfc1                	j	800048b2 <filewrite+0xfa>
      return -1;
    800048e4:	5a7d                	li	s4,-1
    800048e6:	b7f1                	j	800048b2 <filewrite+0xfa>
    800048e8:	5a7d                	li	s4,-1
    800048ea:	b7e1                	j	800048b2 <filewrite+0xfa>

00000000800048ec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800048ec:	7179                	addi	sp,sp,-48
    800048ee:	f406                	sd	ra,40(sp)
    800048f0:	f022                	sd	s0,32(sp)
    800048f2:	ec26                	sd	s1,24(sp)
    800048f4:	e84a                	sd	s2,16(sp)
    800048f6:	e44e                	sd	s3,8(sp)
    800048f8:	e052                	sd	s4,0(sp)
    800048fa:	1800                	addi	s0,sp,48
    800048fc:	84aa                	mv	s1,a0
    800048fe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004900:	0005b023          	sd	zero,0(a1)
    80004904:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004908:	00000097          	auipc	ra,0x0
    8000490c:	bf8080e7          	jalr	-1032(ra) # 80004500 <filealloc>
    80004910:	e088                	sd	a0,0(s1)
    80004912:	c551                	beqz	a0,8000499e <pipealloc+0xb2>
    80004914:	00000097          	auipc	ra,0x0
    80004918:	bec080e7          	jalr	-1044(ra) # 80004500 <filealloc>
    8000491c:	00aa3023          	sd	a0,0(s4)
    80004920:	c92d                	beqz	a0,80004992 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004922:	ffffc097          	auipc	ra,0xffffc
    80004926:	1b0080e7          	jalr	432(ra) # 80000ad2 <kalloc>
    8000492a:	892a                	mv	s2,a0
    8000492c:	c125                	beqz	a0,8000498c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000492e:	4985                	li	s3,1
    80004930:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004934:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004938:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000493c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004940:	00004597          	auipc	a1,0x4
    80004944:	b4858593          	addi	a1,a1,-1208 # 80008488 <states.0+0x1e0>
    80004948:	ffffc097          	auipc	ra,0xffffc
    8000494c:	1ea080e7          	jalr	490(ra) # 80000b32 <initlock>
  (*f0)->type = FD_PIPE;
    80004950:	609c                	ld	a5,0(s1)
    80004952:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004956:	609c                	ld	a5,0(s1)
    80004958:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000495c:	609c                	ld	a5,0(s1)
    8000495e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004962:	609c                	ld	a5,0(s1)
    80004964:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004968:	000a3783          	ld	a5,0(s4)
    8000496c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004970:	000a3783          	ld	a5,0(s4)
    80004974:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004978:	000a3783          	ld	a5,0(s4)
    8000497c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004980:	000a3783          	ld	a5,0(s4)
    80004984:	0127b823          	sd	s2,16(a5)
  return 0;
    80004988:	4501                	li	a0,0
    8000498a:	a025                	j	800049b2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000498c:	6088                	ld	a0,0(s1)
    8000498e:	e501                	bnez	a0,80004996 <pipealloc+0xaa>
    80004990:	a039                	j	8000499e <pipealloc+0xb2>
    80004992:	6088                	ld	a0,0(s1)
    80004994:	c51d                	beqz	a0,800049c2 <pipealloc+0xd6>
    fileclose(*f0);
    80004996:	00000097          	auipc	ra,0x0
    8000499a:	c26080e7          	jalr	-986(ra) # 800045bc <fileclose>
  if(*f1)
    8000499e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800049a2:	557d                	li	a0,-1
  if(*f1)
    800049a4:	c799                	beqz	a5,800049b2 <pipealloc+0xc6>
    fileclose(*f1);
    800049a6:	853e                	mv	a0,a5
    800049a8:	00000097          	auipc	ra,0x0
    800049ac:	c14080e7          	jalr	-1004(ra) # 800045bc <fileclose>
  return -1;
    800049b0:	557d                	li	a0,-1
}
    800049b2:	70a2                	ld	ra,40(sp)
    800049b4:	7402                	ld	s0,32(sp)
    800049b6:	64e2                	ld	s1,24(sp)
    800049b8:	6942                	ld	s2,16(sp)
    800049ba:	69a2                	ld	s3,8(sp)
    800049bc:	6a02                	ld	s4,0(sp)
    800049be:	6145                	addi	sp,sp,48
    800049c0:	8082                	ret
  return -1;
    800049c2:	557d                	li	a0,-1
    800049c4:	b7fd                	j	800049b2 <pipealloc+0xc6>

00000000800049c6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800049c6:	1101                	addi	sp,sp,-32
    800049c8:	ec06                	sd	ra,24(sp)
    800049ca:	e822                	sd	s0,16(sp)
    800049cc:	e426                	sd	s1,8(sp)
    800049ce:	e04a                	sd	s2,0(sp)
    800049d0:	1000                	addi	s0,sp,32
    800049d2:	84aa                	mv	s1,a0
    800049d4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800049d6:	ffffc097          	auipc	ra,0xffffc
    800049da:	1ec080e7          	jalr	492(ra) # 80000bc2 <acquire>
  if(writable){
    800049de:	02090d63          	beqz	s2,80004a18 <pipeclose+0x52>
    pi->writeopen = 0;
    800049e2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800049e6:	21848513          	addi	a0,s1,536
    800049ea:	ffffd097          	auipc	ra,0xffffd
    800049ee:	7e8080e7          	jalr	2024(ra) # 800021d2 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800049f2:	2204b783          	ld	a5,544(s1)
    800049f6:	eb95                	bnez	a5,80004a2a <pipeclose+0x64>
    release(&pi->lock);
    800049f8:	8526                	mv	a0,s1
    800049fa:	ffffc097          	auipc	ra,0xffffc
    800049fe:	27c080e7          	jalr	636(ra) # 80000c76 <release>
    kfree((char*)pi);
    80004a02:	8526                	mv	a0,s1
    80004a04:	ffffc097          	auipc	ra,0xffffc
    80004a08:	fd2080e7          	jalr	-46(ra) # 800009d6 <kfree>
  } else
    release(&pi->lock);
}
    80004a0c:	60e2                	ld	ra,24(sp)
    80004a0e:	6442                	ld	s0,16(sp)
    80004a10:	64a2                	ld	s1,8(sp)
    80004a12:	6902                	ld	s2,0(sp)
    80004a14:	6105                	addi	sp,sp,32
    80004a16:	8082                	ret
    pi->readopen = 0;
    80004a18:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004a1c:	21c48513          	addi	a0,s1,540
    80004a20:	ffffd097          	auipc	ra,0xffffd
    80004a24:	7b2080e7          	jalr	1970(ra) # 800021d2 <wakeup>
    80004a28:	b7e9                	j	800049f2 <pipeclose+0x2c>
    release(&pi->lock);
    80004a2a:	8526                	mv	a0,s1
    80004a2c:	ffffc097          	auipc	ra,0xffffc
    80004a30:	24a080e7          	jalr	586(ra) # 80000c76 <release>
}
    80004a34:	bfe1                	j	80004a0c <pipeclose+0x46>

0000000080004a36 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004a36:	711d                	addi	sp,sp,-96
    80004a38:	ec86                	sd	ra,88(sp)
    80004a3a:	e8a2                	sd	s0,80(sp)
    80004a3c:	e4a6                	sd	s1,72(sp)
    80004a3e:	e0ca                	sd	s2,64(sp)
    80004a40:	fc4e                	sd	s3,56(sp)
    80004a42:	f852                	sd	s4,48(sp)
    80004a44:	f456                	sd	s5,40(sp)
    80004a46:	f05a                	sd	s6,32(sp)
    80004a48:	ec5e                	sd	s7,24(sp)
    80004a4a:	e862                	sd	s8,16(sp)
    80004a4c:	1080                	addi	s0,sp,96
    80004a4e:	84aa                	mv	s1,a0
    80004a50:	8aae                	mv	s5,a1
    80004a52:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004a54:	ffffd097          	auipc	ra,0xffffd
    80004a58:	f2a080e7          	jalr	-214(ra) # 8000197e <myproc>
    80004a5c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004a5e:	8526                	mv	a0,s1
    80004a60:	ffffc097          	auipc	ra,0xffffc
    80004a64:	162080e7          	jalr	354(ra) # 80000bc2 <acquire>
  while(i < n){
    80004a68:	0b405363          	blez	s4,80004b0e <pipewrite+0xd8>
  int i = 0;
    80004a6c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004a6e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004a70:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004a74:	21c48b93          	addi	s7,s1,540
    80004a78:	a089                	j	80004aba <pipewrite+0x84>
      release(&pi->lock);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffc097          	auipc	ra,0xffffc
    80004a80:	1fa080e7          	jalr	506(ra) # 80000c76 <release>
      return -1;
    80004a84:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004a86:	854a                	mv	a0,s2
    80004a88:	60e6                	ld	ra,88(sp)
    80004a8a:	6446                	ld	s0,80(sp)
    80004a8c:	64a6                	ld	s1,72(sp)
    80004a8e:	6906                	ld	s2,64(sp)
    80004a90:	79e2                	ld	s3,56(sp)
    80004a92:	7a42                	ld	s4,48(sp)
    80004a94:	7aa2                	ld	s5,40(sp)
    80004a96:	7b02                	ld	s6,32(sp)
    80004a98:	6be2                	ld	s7,24(sp)
    80004a9a:	6c42                	ld	s8,16(sp)
    80004a9c:	6125                	addi	sp,sp,96
    80004a9e:	8082                	ret
      wakeup(&pi->nread);
    80004aa0:	8562                	mv	a0,s8
    80004aa2:	ffffd097          	auipc	ra,0xffffd
    80004aa6:	730080e7          	jalr	1840(ra) # 800021d2 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004aaa:	85a6                	mv	a1,s1
    80004aac:	855e                	mv	a0,s7
    80004aae:	ffffd097          	auipc	ra,0xffffd
    80004ab2:	598080e7          	jalr	1432(ra) # 80002046 <sleep>
  while(i < n){
    80004ab6:	05495d63          	bge	s2,s4,80004b10 <pipewrite+0xda>
    if(pi->readopen == 0 || pr->killed){
    80004aba:	2204a783          	lw	a5,544(s1)
    80004abe:	dfd5                	beqz	a5,80004a7a <pipewrite+0x44>
    80004ac0:	0289a783          	lw	a5,40(s3)
    80004ac4:	fbdd                	bnez	a5,80004a7a <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ac6:	2184a783          	lw	a5,536(s1)
    80004aca:	21c4a703          	lw	a4,540(s1)
    80004ace:	2007879b          	addiw	a5,a5,512
    80004ad2:	fcf707e3          	beq	a4,a5,80004aa0 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ad6:	4685                	li	a3,1
    80004ad8:	01590633          	add	a2,s2,s5
    80004adc:	faf40593          	addi	a1,s0,-81
    80004ae0:	0509b503          	ld	a0,80(s3)
    80004ae4:	ffffd097          	auipc	ra,0xffffd
    80004ae8:	be6080e7          	jalr	-1050(ra) # 800016ca <copyin>
    80004aec:	03650263          	beq	a0,s6,80004b10 <pipewrite+0xda>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004af0:	21c4a783          	lw	a5,540(s1)
    80004af4:	0017871b          	addiw	a4,a5,1
    80004af8:	20e4ae23          	sw	a4,540(s1)
    80004afc:	1ff7f793          	andi	a5,a5,511
    80004b00:	97a6                	add	a5,a5,s1
    80004b02:	faf44703          	lbu	a4,-81(s0)
    80004b06:	00e78c23          	sb	a4,24(a5)
      i++;
    80004b0a:	2905                	addiw	s2,s2,1
    80004b0c:	b76d                	j	80004ab6 <pipewrite+0x80>
  int i = 0;
    80004b0e:	4901                	li	s2,0
  wakeup(&pi->nread);
    80004b10:	21848513          	addi	a0,s1,536
    80004b14:	ffffd097          	auipc	ra,0xffffd
    80004b18:	6be080e7          	jalr	1726(ra) # 800021d2 <wakeup>
  release(&pi->lock);
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffc097          	auipc	ra,0xffffc
    80004b22:	158080e7          	jalr	344(ra) # 80000c76 <release>
  return i;
    80004b26:	b785                	j	80004a86 <pipewrite+0x50>

0000000080004b28 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004b28:	715d                	addi	sp,sp,-80
    80004b2a:	e486                	sd	ra,72(sp)
    80004b2c:	e0a2                	sd	s0,64(sp)
    80004b2e:	fc26                	sd	s1,56(sp)
    80004b30:	f84a                	sd	s2,48(sp)
    80004b32:	f44e                	sd	s3,40(sp)
    80004b34:	f052                	sd	s4,32(sp)
    80004b36:	ec56                	sd	s5,24(sp)
    80004b38:	e85a                	sd	s6,16(sp)
    80004b3a:	0880                	addi	s0,sp,80
    80004b3c:	84aa                	mv	s1,a0
    80004b3e:	892e                	mv	s2,a1
    80004b40:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004b42:	ffffd097          	auipc	ra,0xffffd
    80004b46:	e3c080e7          	jalr	-452(ra) # 8000197e <myproc>
    80004b4a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	ffffc097          	auipc	ra,0xffffc
    80004b52:	074080e7          	jalr	116(ra) # 80000bc2 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b56:	2184a703          	lw	a4,536(s1)
    80004b5a:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b5e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b62:	02f71463          	bne	a4,a5,80004b8a <piperead+0x62>
    80004b66:	2244a783          	lw	a5,548(s1)
    80004b6a:	c385                	beqz	a5,80004b8a <piperead+0x62>
    if(pr->killed){
    80004b6c:	028a2783          	lw	a5,40(s4)
    80004b70:	ebc1                	bnez	a5,80004c00 <piperead+0xd8>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004b72:	85a6                	mv	a1,s1
    80004b74:	854e                	mv	a0,s3
    80004b76:	ffffd097          	auipc	ra,0xffffd
    80004b7a:	4d0080e7          	jalr	1232(ra) # 80002046 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004b7e:	2184a703          	lw	a4,536(s1)
    80004b82:	21c4a783          	lw	a5,540(s1)
    80004b86:	fef700e3          	beq	a4,a5,80004b66 <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b8a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004b8c:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b8e:	05505363          	blez	s5,80004bd4 <piperead+0xac>
    if(pi->nread == pi->nwrite)
    80004b92:	2184a783          	lw	a5,536(s1)
    80004b96:	21c4a703          	lw	a4,540(s1)
    80004b9a:	02f70d63          	beq	a4,a5,80004bd4 <piperead+0xac>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004b9e:	0017871b          	addiw	a4,a5,1
    80004ba2:	20e4ac23          	sw	a4,536(s1)
    80004ba6:	1ff7f793          	andi	a5,a5,511
    80004baa:	97a6                	add	a5,a5,s1
    80004bac:	0187c783          	lbu	a5,24(a5)
    80004bb0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004bb4:	4685                	li	a3,1
    80004bb6:	fbf40613          	addi	a2,s0,-65
    80004bba:	85ca                	mv	a1,s2
    80004bbc:	050a3503          	ld	a0,80(s4)
    80004bc0:	ffffd097          	auipc	ra,0xffffd
    80004bc4:	a7e080e7          	jalr	-1410(ra) # 8000163e <copyout>
    80004bc8:	01650663          	beq	a0,s6,80004bd4 <piperead+0xac>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004bcc:	2985                	addiw	s3,s3,1
    80004bce:	0905                	addi	s2,s2,1
    80004bd0:	fd3a91e3          	bne	s5,s3,80004b92 <piperead+0x6a>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004bd4:	21c48513          	addi	a0,s1,540
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	5fa080e7          	jalr	1530(ra) # 800021d2 <wakeup>
  release(&pi->lock);
    80004be0:	8526                	mv	a0,s1
    80004be2:	ffffc097          	auipc	ra,0xffffc
    80004be6:	094080e7          	jalr	148(ra) # 80000c76 <release>
  return i;
}
    80004bea:	854e                	mv	a0,s3
    80004bec:	60a6                	ld	ra,72(sp)
    80004bee:	6406                	ld	s0,64(sp)
    80004bf0:	74e2                	ld	s1,56(sp)
    80004bf2:	7942                	ld	s2,48(sp)
    80004bf4:	79a2                	ld	s3,40(sp)
    80004bf6:	7a02                	ld	s4,32(sp)
    80004bf8:	6ae2                	ld	s5,24(sp)
    80004bfa:	6b42                	ld	s6,16(sp)
    80004bfc:	6161                	addi	sp,sp,80
    80004bfe:	8082                	ret
      release(&pi->lock);
    80004c00:	8526                	mv	a0,s1
    80004c02:	ffffc097          	auipc	ra,0xffffc
    80004c06:	074080e7          	jalr	116(ra) # 80000c76 <release>
      return -1;
    80004c0a:	59fd                	li	s3,-1
    80004c0c:	bff9                	j	80004bea <piperead+0xc2>

0000000080004c0e <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004c0e:	de010113          	addi	sp,sp,-544
    80004c12:	20113c23          	sd	ra,536(sp)
    80004c16:	20813823          	sd	s0,528(sp)
    80004c1a:	20913423          	sd	s1,520(sp)
    80004c1e:	21213023          	sd	s2,512(sp)
    80004c22:	ffce                	sd	s3,504(sp)
    80004c24:	fbd2                	sd	s4,496(sp)
    80004c26:	f7d6                	sd	s5,488(sp)
    80004c28:	f3da                	sd	s6,480(sp)
    80004c2a:	efde                	sd	s7,472(sp)
    80004c2c:	ebe2                	sd	s8,464(sp)
    80004c2e:	e7e6                	sd	s9,456(sp)
    80004c30:	e3ea                	sd	s10,448(sp)
    80004c32:	ff6e                	sd	s11,440(sp)
    80004c34:	1400                	addi	s0,sp,544
    80004c36:	892a                	mv	s2,a0
    80004c38:	dea43423          	sd	a0,-536(s0)
    80004c3c:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004c40:	ffffd097          	auipc	ra,0xffffd
    80004c44:	d3e080e7          	jalr	-706(ra) # 8000197e <myproc>
    80004c48:	84aa                	mv	s1,a0

  begin_op();
    80004c4a:	fffff097          	auipc	ra,0xfffff
    80004c4e:	4a6080e7          	jalr	1190(ra) # 800040f0 <begin_op>

  if((ip = namei(path)) == 0){
    80004c52:	854a                	mv	a0,s2
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	27c080e7          	jalr	636(ra) # 80003ed0 <namei>
    80004c5c:	c93d                	beqz	a0,80004cd2 <exec+0xc4>
    80004c5e:	8aaa                	mv	s5,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	aba080e7          	jalr	-1350(ra) # 8000371a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004c68:	04000713          	li	a4,64
    80004c6c:	4681                	li	a3,0
    80004c6e:	e4840613          	addi	a2,s0,-440
    80004c72:	4581                	li	a1,0
    80004c74:	8556                	mv	a0,s5
    80004c76:	fffff097          	auipc	ra,0xfffff
    80004c7a:	d58080e7          	jalr	-680(ra) # 800039ce <readi>
    80004c7e:	04000793          	li	a5,64
    80004c82:	00f51a63          	bne	a0,a5,80004c96 <exec+0x88>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004c86:	e4842703          	lw	a4,-440(s0)
    80004c8a:	464c47b7          	lui	a5,0x464c4
    80004c8e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004c92:	04f70663          	beq	a4,a5,80004cde <exec+0xd0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004c96:	8556                	mv	a0,s5
    80004c98:	fffff097          	auipc	ra,0xfffff
    80004c9c:	ce4080e7          	jalr	-796(ra) # 8000397c <iunlockput>
    end_op();
    80004ca0:	fffff097          	auipc	ra,0xfffff
    80004ca4:	4d0080e7          	jalr	1232(ra) # 80004170 <end_op>
  }
  return -1;
    80004ca8:	557d                	li	a0,-1
}
    80004caa:	21813083          	ld	ra,536(sp)
    80004cae:	21013403          	ld	s0,528(sp)
    80004cb2:	20813483          	ld	s1,520(sp)
    80004cb6:	20013903          	ld	s2,512(sp)
    80004cba:	79fe                	ld	s3,504(sp)
    80004cbc:	7a5e                	ld	s4,496(sp)
    80004cbe:	7abe                	ld	s5,488(sp)
    80004cc0:	7b1e                	ld	s6,480(sp)
    80004cc2:	6bfe                	ld	s7,472(sp)
    80004cc4:	6c5e                	ld	s8,464(sp)
    80004cc6:	6cbe                	ld	s9,456(sp)
    80004cc8:	6d1e                	ld	s10,448(sp)
    80004cca:	7dfa                	ld	s11,440(sp)
    80004ccc:	22010113          	addi	sp,sp,544
    80004cd0:	8082                	ret
    end_op();
    80004cd2:	fffff097          	auipc	ra,0xfffff
    80004cd6:	49e080e7          	jalr	1182(ra) # 80004170 <end_op>
    return -1;
    80004cda:	557d                	li	a0,-1
    80004cdc:	b7f9                	j	80004caa <exec+0x9c>
  if((pagetable = proc_pagetable(p)) == 0)
    80004cde:	8526                	mv	a0,s1
    80004ce0:	ffffd097          	auipc	ra,0xffffd
    80004ce4:	d62080e7          	jalr	-670(ra) # 80001a42 <proc_pagetable>
    80004ce8:	8b2a                	mv	s6,a0
    80004cea:	d555                	beqz	a0,80004c96 <exec+0x88>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cec:	e6842783          	lw	a5,-408(s0)
    80004cf0:	e8045703          	lhu	a4,-384(s0)
    80004cf4:	c735                	beqz	a4,80004d60 <exec+0x152>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004cf6:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004cf8:	e0043423          	sd	zero,-504(s0)
    if(ph.vaddr % PGSIZE != 0)
    80004cfc:	6a05                	lui	s4,0x1
    80004cfe:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    80004d02:	dee43023          	sd	a4,-544(s0)
  uint64 pa;

  if((va % PGSIZE) != 0)
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    80004d06:	6d85                	lui	s11,0x1
    80004d08:	7d7d                	lui	s10,0xfffff
    80004d0a:	ac1d                	j	80004f40 <exec+0x332>
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004d0c:	00004517          	auipc	a0,0x4
    80004d10:	b5c50513          	addi	a0,a0,-1188 # 80008868 <syscalls_strings+0x280>
    80004d14:	ffffc097          	auipc	ra,0xffffc
    80004d18:	816080e7          	jalr	-2026(ra) # 8000052a <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004d1c:	874a                	mv	a4,s2
    80004d1e:	009c86bb          	addw	a3,s9,s1
    80004d22:	4581                	li	a1,0
    80004d24:	8556                	mv	a0,s5
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	ca8080e7          	jalr	-856(ra) # 800039ce <readi>
    80004d2e:	2501                	sext.w	a0,a0
    80004d30:	1aa91863          	bne	s2,a0,80004ee0 <exec+0x2d2>
  for(i = 0; i < sz; i += PGSIZE){
    80004d34:	009d84bb          	addw	s1,s11,s1
    80004d38:	013d09bb          	addw	s3,s10,s3
    80004d3c:	1f74f263          	bgeu	s1,s7,80004f20 <exec+0x312>
    pa = walkaddr(pagetable, va + i);
    80004d40:	02049593          	slli	a1,s1,0x20
    80004d44:	9181                	srli	a1,a1,0x20
    80004d46:	95e2                	add	a1,a1,s8
    80004d48:	855a                	mv	a0,s6
    80004d4a:	ffffc097          	auipc	ra,0xffffc
    80004d4e:	302080e7          	jalr	770(ra) # 8000104c <walkaddr>
    80004d52:	862a                	mv	a2,a0
    if(pa == 0)
    80004d54:	dd45                	beqz	a0,80004d0c <exec+0xfe>
      n = PGSIZE;
    80004d56:	8952                	mv	s2,s4
    if(sz - i < PGSIZE)
    80004d58:	fd49f2e3          	bgeu	s3,s4,80004d1c <exec+0x10e>
      n = sz - i;
    80004d5c:	894e                	mv	s2,s3
    80004d5e:	bf7d                	j	80004d1c <exec+0x10e>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004d60:	4481                	li	s1,0
  iunlockput(ip);
    80004d62:	8556                	mv	a0,s5
    80004d64:	fffff097          	auipc	ra,0xfffff
    80004d68:	c18080e7          	jalr	-1000(ra) # 8000397c <iunlockput>
  end_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	404080e7          	jalr	1028(ra) # 80004170 <end_op>
  p = myproc();
    80004d74:	ffffd097          	auipc	ra,0xffffd
    80004d78:	c0a080e7          	jalr	-1014(ra) # 8000197e <myproc>
    80004d7c:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    80004d7e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004d82:	6785                	lui	a5,0x1
    80004d84:	17fd                	addi	a5,a5,-1
    80004d86:	94be                	add	s1,s1,a5
    80004d88:	77fd                	lui	a5,0xfffff
    80004d8a:	8fe5                	and	a5,a5,s1
    80004d8c:	def43c23          	sd	a5,-520(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004d90:	6609                	lui	a2,0x2
    80004d92:	963e                	add	a2,a2,a5
    80004d94:	85be                	mv	a1,a5
    80004d96:	855a                	mv	a0,s6
    80004d98:	ffffc097          	auipc	ra,0xffffc
    80004d9c:	656080e7          	jalr	1622(ra) # 800013ee <uvmalloc>
    80004da0:	8c2a                	mv	s8,a0
  ip = 0;
    80004da2:	4a81                	li	s5,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004da4:	12050e63          	beqz	a0,80004ee0 <exec+0x2d2>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004da8:	75f9                	lui	a1,0xffffe
    80004daa:	95aa                	add	a1,a1,a0
    80004dac:	855a                	mv	a0,s6
    80004dae:	ffffd097          	auipc	ra,0xffffd
    80004db2:	85e080e7          	jalr	-1954(ra) # 8000160c <uvmclear>
  stackbase = sp - PGSIZE;
    80004db6:	7afd                	lui	s5,0xfffff
    80004db8:	9ae2                	add	s5,s5,s8
  for(argc = 0; argv[argc]; argc++) {
    80004dba:	df043783          	ld	a5,-528(s0)
    80004dbe:	6388                	ld	a0,0(a5)
    80004dc0:	c925                	beqz	a0,80004e30 <exec+0x222>
    80004dc2:	e8840993          	addi	s3,s0,-376
    80004dc6:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004dca:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004dcc:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004dce:	ffffc097          	auipc	ra,0xffffc
    80004dd2:	074080e7          	jalr	116(ra) # 80000e42 <strlen>
    80004dd6:	0015079b          	addiw	a5,a0,1
    80004dda:	40f90933          	sub	s2,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004dde:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004de2:	13596363          	bltu	s2,s5,80004f08 <exec+0x2fa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004de6:	df043d83          	ld	s11,-528(s0)
    80004dea:	000dba03          	ld	s4,0(s11) # 1000 <_entry-0x7ffff000>
    80004dee:	8552                	mv	a0,s4
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	052080e7          	jalr	82(ra) # 80000e42 <strlen>
    80004df8:	0015069b          	addiw	a3,a0,1
    80004dfc:	8652                	mv	a2,s4
    80004dfe:	85ca                	mv	a1,s2
    80004e00:	855a                	mv	a0,s6
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	83c080e7          	jalr	-1988(ra) # 8000163e <copyout>
    80004e0a:	10054363          	bltz	a0,80004f10 <exec+0x302>
    ustack[argc] = sp;
    80004e0e:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004e12:	0485                	addi	s1,s1,1
    80004e14:	008d8793          	addi	a5,s11,8
    80004e18:	def43823          	sd	a5,-528(s0)
    80004e1c:	008db503          	ld	a0,8(s11)
    80004e20:	c911                	beqz	a0,80004e34 <exec+0x226>
    if(argc >= MAXARG)
    80004e22:	09a1                	addi	s3,s3,8
    80004e24:	fb3c95e3          	bne	s9,s3,80004dce <exec+0x1c0>
  sz = sz1;
    80004e28:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e2c:	4a81                	li	s5,0
    80004e2e:	a84d                	j	80004ee0 <exec+0x2d2>
  sp = sz;
    80004e30:	8962                	mv	s2,s8
  for(argc = 0; argv[argc]; argc++) {
    80004e32:	4481                	li	s1,0
  ustack[argc] = 0;
    80004e34:	00349793          	slli	a5,s1,0x3
    80004e38:	f9040713          	addi	a4,s0,-112
    80004e3c:	97ba                	add	a5,a5,a4
    80004e3e:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd8ef8>
  sp -= (argc+1) * sizeof(uint64);
    80004e42:	00148693          	addi	a3,s1,1
    80004e46:	068e                	slli	a3,a3,0x3
    80004e48:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004e4c:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004e50:	01597663          	bgeu	s2,s5,80004e5c <exec+0x24e>
  sz = sz1;
    80004e54:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004e58:	4a81                	li	s5,0
    80004e5a:	a059                	j	80004ee0 <exec+0x2d2>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004e5c:	e8840613          	addi	a2,s0,-376
    80004e60:	85ca                	mv	a1,s2
    80004e62:	855a                	mv	a0,s6
    80004e64:	ffffc097          	auipc	ra,0xffffc
    80004e68:	7da080e7          	jalr	2010(ra) # 8000163e <copyout>
    80004e6c:	0a054663          	bltz	a0,80004f18 <exec+0x30a>
  p->trapframe->a1 = sp;
    80004e70:	058bb783          	ld	a5,88(s7) # 1058 <_entry-0x7fffefa8>
    80004e74:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004e78:	de843783          	ld	a5,-536(s0)
    80004e7c:	0007c703          	lbu	a4,0(a5)
    80004e80:	cf11                	beqz	a4,80004e9c <exec+0x28e>
    80004e82:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004e84:	02f00693          	li	a3,47
    80004e88:	a039                	j	80004e96 <exec+0x288>
      last = s+1;
    80004e8a:	def43423          	sd	a5,-536(s0)
  for(last=s=path; *s; s++)
    80004e8e:	0785                	addi	a5,a5,1
    80004e90:	fff7c703          	lbu	a4,-1(a5)
    80004e94:	c701                	beqz	a4,80004e9c <exec+0x28e>
    if(*s == '/')
    80004e96:	fed71ce3          	bne	a4,a3,80004e8e <exec+0x280>
    80004e9a:	bfc5                	j	80004e8a <exec+0x27c>
  safestrcpy(p->name, last, sizeof(p->name));
    80004e9c:	4641                	li	a2,16
    80004e9e:	de843583          	ld	a1,-536(s0)
    80004ea2:	158b8513          	addi	a0,s7,344
    80004ea6:	ffffc097          	auipc	ra,0xffffc
    80004eaa:	f6a080e7          	jalr	-150(ra) # 80000e10 <safestrcpy>
  oldpagetable = p->pagetable;
    80004eae:	050bb503          	ld	a0,80(s7)
  p->pagetable = pagetable;
    80004eb2:	056bb823          	sd	s6,80(s7)
  p->sz = sz;
    80004eb6:	058bb423          	sd	s8,72(s7)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004eba:	058bb783          	ld	a5,88(s7)
    80004ebe:	e6043703          	ld	a4,-416(s0)
    80004ec2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004ec4:	058bb783          	ld	a5,88(s7)
    80004ec8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004ecc:	85ea                	mv	a1,s10
    80004ece:	ffffd097          	auipc	ra,0xffffd
    80004ed2:	c10080e7          	jalr	-1008(ra) # 80001ade <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004ed6:	0004851b          	sext.w	a0,s1
    80004eda:	bbc1                	j	80004caa <exec+0x9c>
    80004edc:	de943c23          	sd	s1,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004ee0:	df843583          	ld	a1,-520(s0)
    80004ee4:	855a                	mv	a0,s6
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	bf8080e7          	jalr	-1032(ra) # 80001ade <proc_freepagetable>
  if(ip){
    80004eee:	da0a94e3          	bnez	s5,80004c96 <exec+0x88>
  return -1;
    80004ef2:	557d                	li	a0,-1
    80004ef4:	bb5d                	j	80004caa <exec+0x9c>
    80004ef6:	de943c23          	sd	s1,-520(s0)
    80004efa:	b7dd                	j	80004ee0 <exec+0x2d2>
    80004efc:	de943c23          	sd	s1,-520(s0)
    80004f00:	b7c5                	j	80004ee0 <exec+0x2d2>
    80004f02:	de943c23          	sd	s1,-520(s0)
    80004f06:	bfe9                	j	80004ee0 <exec+0x2d2>
  sz = sz1;
    80004f08:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f0c:	4a81                	li	s5,0
    80004f0e:	bfc9                	j	80004ee0 <exec+0x2d2>
  sz = sz1;
    80004f10:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f14:	4a81                	li	s5,0
    80004f16:	b7e9                	j	80004ee0 <exec+0x2d2>
  sz = sz1;
    80004f18:	df843c23          	sd	s8,-520(s0)
  ip = 0;
    80004f1c:	4a81                	li	s5,0
    80004f1e:	b7c9                	j	80004ee0 <exec+0x2d2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f20:	df843483          	ld	s1,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004f24:	e0843783          	ld	a5,-504(s0)
    80004f28:	0017869b          	addiw	a3,a5,1
    80004f2c:	e0d43423          	sd	a3,-504(s0)
    80004f30:	e0043783          	ld	a5,-512(s0)
    80004f34:	0387879b          	addiw	a5,a5,56
    80004f38:	e8045703          	lhu	a4,-384(s0)
    80004f3c:	e2e6d3e3          	bge	a3,a4,80004d62 <exec+0x154>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004f40:	2781                	sext.w	a5,a5
    80004f42:	e0f43023          	sd	a5,-512(s0)
    80004f46:	03800713          	li	a4,56
    80004f4a:	86be                	mv	a3,a5
    80004f4c:	e1040613          	addi	a2,s0,-496
    80004f50:	4581                	li	a1,0
    80004f52:	8556                	mv	a0,s5
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	a7a080e7          	jalr	-1414(ra) # 800039ce <readi>
    80004f5c:	03800793          	li	a5,56
    80004f60:	f6f51ee3          	bne	a0,a5,80004edc <exec+0x2ce>
    if(ph.type != ELF_PROG_LOAD)
    80004f64:	e1042783          	lw	a5,-496(s0)
    80004f68:	4705                	li	a4,1
    80004f6a:	fae79de3          	bne	a5,a4,80004f24 <exec+0x316>
    if(ph.memsz < ph.filesz)
    80004f6e:	e3843603          	ld	a2,-456(s0)
    80004f72:	e3043783          	ld	a5,-464(s0)
    80004f76:	f8f660e3          	bltu	a2,a5,80004ef6 <exec+0x2e8>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004f7a:	e2043783          	ld	a5,-480(s0)
    80004f7e:	963e                	add	a2,a2,a5
    80004f80:	f6f66ee3          	bltu	a2,a5,80004efc <exec+0x2ee>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004f84:	85a6                	mv	a1,s1
    80004f86:	855a                	mv	a0,s6
    80004f88:	ffffc097          	auipc	ra,0xffffc
    80004f8c:	466080e7          	jalr	1126(ra) # 800013ee <uvmalloc>
    80004f90:	dea43c23          	sd	a0,-520(s0)
    80004f94:	d53d                	beqz	a0,80004f02 <exec+0x2f4>
    if(ph.vaddr % PGSIZE != 0)
    80004f96:	e2043c03          	ld	s8,-480(s0)
    80004f9a:	de043783          	ld	a5,-544(s0)
    80004f9e:	00fc77b3          	and	a5,s8,a5
    80004fa2:	ff9d                	bnez	a5,80004ee0 <exec+0x2d2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004fa4:	e1842c83          	lw	s9,-488(s0)
    80004fa8:	e3042b83          	lw	s7,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004fac:	f60b8ae3          	beqz	s7,80004f20 <exec+0x312>
    80004fb0:	89de                	mv	s3,s7
    80004fb2:	4481                	li	s1,0
    80004fb4:	b371                	j	80004d40 <exec+0x132>

0000000080004fb6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004fb6:	7179                	addi	sp,sp,-48
    80004fb8:	f406                	sd	ra,40(sp)
    80004fba:	f022                	sd	s0,32(sp)
    80004fbc:	ec26                	sd	s1,24(sp)
    80004fbe:	e84a                	sd	s2,16(sp)
    80004fc0:	1800                	addi	s0,sp,48
    80004fc2:	892e                	mv	s2,a1
    80004fc4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004fc6:	fdc40593          	addi	a1,s0,-36
    80004fca:	ffffe097          	auipc	ra,0xffffe
    80004fce:	ad8080e7          	jalr	-1320(ra) # 80002aa2 <argint>
    80004fd2:	04054063          	bltz	a0,80005012 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004fd6:	fdc42703          	lw	a4,-36(s0)
    80004fda:	47bd                	li	a5,15
    80004fdc:	02e7ed63          	bltu	a5,a4,80005016 <argfd+0x60>
    80004fe0:	ffffd097          	auipc	ra,0xffffd
    80004fe4:	99e080e7          	jalr	-1634(ra) # 8000197e <myproc>
    80004fe8:	fdc42703          	lw	a4,-36(s0)
    80004fec:	01a70793          	addi	a5,a4,26
    80004ff0:	078e                	slli	a5,a5,0x3
    80004ff2:	953e                	add	a0,a0,a5
    80004ff4:	611c                	ld	a5,0(a0)
    80004ff6:	c395                	beqz	a5,8000501a <argfd+0x64>
    return -1;
  if(pfd)
    80004ff8:	00090463          	beqz	s2,80005000 <argfd+0x4a>
    *pfd = fd;
    80004ffc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005000:	4501                	li	a0,0
  if(pf)
    80005002:	c091                	beqz	s1,80005006 <argfd+0x50>
    *pf = f;
    80005004:	e09c                	sd	a5,0(s1)
}
    80005006:	70a2                	ld	ra,40(sp)
    80005008:	7402                	ld	s0,32(sp)
    8000500a:	64e2                	ld	s1,24(sp)
    8000500c:	6942                	ld	s2,16(sp)
    8000500e:	6145                	addi	sp,sp,48
    80005010:	8082                	ret
    return -1;
    80005012:	557d                	li	a0,-1
    80005014:	bfcd                	j	80005006 <argfd+0x50>
    return -1;
    80005016:	557d                	li	a0,-1
    80005018:	b7fd                	j	80005006 <argfd+0x50>
    8000501a:	557d                	li	a0,-1
    8000501c:	b7ed                	j	80005006 <argfd+0x50>

000000008000501e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000501e:	1101                	addi	sp,sp,-32
    80005020:	ec06                	sd	ra,24(sp)
    80005022:	e822                	sd	s0,16(sp)
    80005024:	e426                	sd	s1,8(sp)
    80005026:	1000                	addi	s0,sp,32
    80005028:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000502a:	ffffd097          	auipc	ra,0xffffd
    8000502e:	954080e7          	jalr	-1708(ra) # 8000197e <myproc>
    80005032:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005034:	0d050793          	addi	a5,a0,208
    80005038:	4501                	li	a0,0
    8000503a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000503c:	6398                	ld	a4,0(a5)
    8000503e:	cb19                	beqz	a4,80005054 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005040:	2505                	addiw	a0,a0,1
    80005042:	07a1                	addi	a5,a5,8
    80005044:	fed51ce3          	bne	a0,a3,8000503c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005048:	557d                	li	a0,-1
}
    8000504a:	60e2                	ld	ra,24(sp)
    8000504c:	6442                	ld	s0,16(sp)
    8000504e:	64a2                	ld	s1,8(sp)
    80005050:	6105                	addi	sp,sp,32
    80005052:	8082                	ret
      p->ofile[fd] = f;
    80005054:	01a50793          	addi	a5,a0,26
    80005058:	078e                	slli	a5,a5,0x3
    8000505a:	963e                	add	a2,a2,a5
    8000505c:	e204                	sd	s1,0(a2)
      return fd;
    8000505e:	b7f5                	j	8000504a <fdalloc+0x2c>

0000000080005060 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005060:	715d                	addi	sp,sp,-80
    80005062:	e486                	sd	ra,72(sp)
    80005064:	e0a2                	sd	s0,64(sp)
    80005066:	fc26                	sd	s1,56(sp)
    80005068:	f84a                	sd	s2,48(sp)
    8000506a:	f44e                	sd	s3,40(sp)
    8000506c:	f052                	sd	s4,32(sp)
    8000506e:	ec56                	sd	s5,24(sp)
    80005070:	0880                	addi	s0,sp,80
    80005072:	89ae                	mv	s3,a1
    80005074:	8ab2                	mv	s5,a2
    80005076:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005078:	fb040593          	addi	a1,s0,-80
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	e72080e7          	jalr	-398(ra) # 80003eee <nameiparent>
    80005084:	892a                	mv	s2,a0
    80005086:	12050e63          	beqz	a0,800051c2 <create+0x162>
    return 0;

  ilock(dp);
    8000508a:	ffffe097          	auipc	ra,0xffffe
    8000508e:	690080e7          	jalr	1680(ra) # 8000371a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005092:	4601                	li	a2,0
    80005094:	fb040593          	addi	a1,s0,-80
    80005098:	854a                	mv	a0,s2
    8000509a:	fffff097          	auipc	ra,0xfffff
    8000509e:	b64080e7          	jalr	-1180(ra) # 80003bfe <dirlookup>
    800050a2:	84aa                	mv	s1,a0
    800050a4:	c921                	beqz	a0,800050f4 <create+0x94>
    iunlockput(dp);
    800050a6:	854a                	mv	a0,s2
    800050a8:	fffff097          	auipc	ra,0xfffff
    800050ac:	8d4080e7          	jalr	-1836(ra) # 8000397c <iunlockput>
    ilock(ip);
    800050b0:	8526                	mv	a0,s1
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	668080e7          	jalr	1640(ra) # 8000371a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800050ba:	2981                	sext.w	s3,s3
    800050bc:	4789                	li	a5,2
    800050be:	02f99463          	bne	s3,a5,800050e6 <create+0x86>
    800050c2:	0444d783          	lhu	a5,68(s1)
    800050c6:	37f9                	addiw	a5,a5,-2
    800050c8:	17c2                	slli	a5,a5,0x30
    800050ca:	93c1                	srli	a5,a5,0x30
    800050cc:	4705                	li	a4,1
    800050ce:	00f76c63          	bltu	a4,a5,800050e6 <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    800050d2:	8526                	mv	a0,s1
    800050d4:	60a6                	ld	ra,72(sp)
    800050d6:	6406                	ld	s0,64(sp)
    800050d8:	74e2                	ld	s1,56(sp)
    800050da:	7942                	ld	s2,48(sp)
    800050dc:	79a2                	ld	s3,40(sp)
    800050de:	7a02                	ld	s4,32(sp)
    800050e0:	6ae2                	ld	s5,24(sp)
    800050e2:	6161                	addi	sp,sp,80
    800050e4:	8082                	ret
    iunlockput(ip);
    800050e6:	8526                	mv	a0,s1
    800050e8:	fffff097          	auipc	ra,0xfffff
    800050ec:	894080e7          	jalr	-1900(ra) # 8000397c <iunlockput>
    return 0;
    800050f0:	4481                	li	s1,0
    800050f2:	b7c5                	j	800050d2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    800050f4:	85ce                	mv	a1,s3
    800050f6:	00092503          	lw	a0,0(s2)
    800050fa:	ffffe097          	auipc	ra,0xffffe
    800050fe:	488080e7          	jalr	1160(ra) # 80003582 <ialloc>
    80005102:	84aa                	mv	s1,a0
    80005104:	c521                	beqz	a0,8000514c <create+0xec>
  ilock(ip);
    80005106:	ffffe097          	auipc	ra,0xffffe
    8000510a:	614080e7          	jalr	1556(ra) # 8000371a <ilock>
  ip->major = major;
    8000510e:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005112:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    80005116:	4a05                	li	s4,1
    80005118:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    8000511c:	8526                	mv	a0,s1
    8000511e:	ffffe097          	auipc	ra,0xffffe
    80005122:	532080e7          	jalr	1330(ra) # 80003650 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005126:	2981                	sext.w	s3,s3
    80005128:	03498a63          	beq	s3,s4,8000515c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    8000512c:	40d0                	lw	a2,4(s1)
    8000512e:	fb040593          	addi	a1,s0,-80
    80005132:	854a                	mv	a0,s2
    80005134:	fffff097          	auipc	ra,0xfffff
    80005138:	cda080e7          	jalr	-806(ra) # 80003e0e <dirlink>
    8000513c:	06054b63          	bltz	a0,800051b2 <create+0x152>
  iunlockput(dp);
    80005140:	854a                	mv	a0,s2
    80005142:	fffff097          	auipc	ra,0xfffff
    80005146:	83a080e7          	jalr	-1990(ra) # 8000397c <iunlockput>
  return ip;
    8000514a:	b761                	j	800050d2 <create+0x72>
    panic("create: ialloc");
    8000514c:	00003517          	auipc	a0,0x3
    80005150:	73c50513          	addi	a0,a0,1852 # 80008888 <syscalls_strings+0x2a0>
    80005154:	ffffb097          	auipc	ra,0xffffb
    80005158:	3d6080e7          	jalr	982(ra) # 8000052a <panic>
    dp->nlink++;  // for ".."
    8000515c:	04a95783          	lhu	a5,74(s2)
    80005160:	2785                	addiw	a5,a5,1
    80005162:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    80005166:	854a                	mv	a0,s2
    80005168:	ffffe097          	auipc	ra,0xffffe
    8000516c:	4e8080e7          	jalr	1256(ra) # 80003650 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005170:	40d0                	lw	a2,4(s1)
    80005172:	00003597          	auipc	a1,0x3
    80005176:	72658593          	addi	a1,a1,1830 # 80008898 <syscalls_strings+0x2b0>
    8000517a:	8526                	mv	a0,s1
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	c92080e7          	jalr	-878(ra) # 80003e0e <dirlink>
    80005184:	00054f63          	bltz	a0,800051a2 <create+0x142>
    80005188:	00492603          	lw	a2,4(s2)
    8000518c:	00003597          	auipc	a1,0x3
    80005190:	71458593          	addi	a1,a1,1812 # 800088a0 <syscalls_strings+0x2b8>
    80005194:	8526                	mv	a0,s1
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	c78080e7          	jalr	-904(ra) # 80003e0e <dirlink>
    8000519e:	f80557e3          	bgez	a0,8000512c <create+0xcc>
      panic("create dots");
    800051a2:	00003517          	auipc	a0,0x3
    800051a6:	70650513          	addi	a0,a0,1798 # 800088a8 <syscalls_strings+0x2c0>
    800051aa:	ffffb097          	auipc	ra,0xffffb
    800051ae:	380080e7          	jalr	896(ra) # 8000052a <panic>
    panic("create: dirlink");
    800051b2:	00003517          	auipc	a0,0x3
    800051b6:	70650513          	addi	a0,a0,1798 # 800088b8 <syscalls_strings+0x2d0>
    800051ba:	ffffb097          	auipc	ra,0xffffb
    800051be:	370080e7          	jalr	880(ra) # 8000052a <panic>
    return 0;
    800051c2:	84aa                	mv	s1,a0
    800051c4:	b739                	j	800050d2 <create+0x72>

00000000800051c6 <sys_dup>:
{
    800051c6:	7179                	addi	sp,sp,-48
    800051c8:	f406                	sd	ra,40(sp)
    800051ca:	f022                	sd	s0,32(sp)
    800051cc:	ec26                	sd	s1,24(sp)
    800051ce:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800051d0:	fd840613          	addi	a2,s0,-40
    800051d4:	4581                	li	a1,0
    800051d6:	4501                	li	a0,0
    800051d8:	00000097          	auipc	ra,0x0
    800051dc:	dde080e7          	jalr	-546(ra) # 80004fb6 <argfd>
    return -1;
    800051e0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800051e2:	02054363          	bltz	a0,80005208 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800051e6:	fd843503          	ld	a0,-40(s0)
    800051ea:	00000097          	auipc	ra,0x0
    800051ee:	e34080e7          	jalr	-460(ra) # 8000501e <fdalloc>
    800051f2:	84aa                	mv	s1,a0
    return -1;
    800051f4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800051f6:	00054963          	bltz	a0,80005208 <sys_dup+0x42>
  filedup(f);
    800051fa:	fd843503          	ld	a0,-40(s0)
    800051fe:	fffff097          	auipc	ra,0xfffff
    80005202:	36c080e7          	jalr	876(ra) # 8000456a <filedup>
  return fd;
    80005206:	87a6                	mv	a5,s1
}
    80005208:	853e                	mv	a0,a5
    8000520a:	70a2                	ld	ra,40(sp)
    8000520c:	7402                	ld	s0,32(sp)
    8000520e:	64e2                	ld	s1,24(sp)
    80005210:	6145                	addi	sp,sp,48
    80005212:	8082                	ret

0000000080005214 <sys_read>:
{
    80005214:	7179                	addi	sp,sp,-48
    80005216:	f406                	sd	ra,40(sp)
    80005218:	f022                	sd	s0,32(sp)
    8000521a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000521c:	fe840613          	addi	a2,s0,-24
    80005220:	4581                	li	a1,0
    80005222:	4501                	li	a0,0
    80005224:	00000097          	auipc	ra,0x0
    80005228:	d92080e7          	jalr	-622(ra) # 80004fb6 <argfd>
    return -1;
    8000522c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000522e:	04054163          	bltz	a0,80005270 <sys_read+0x5c>
    80005232:	fe440593          	addi	a1,s0,-28
    80005236:	4509                	li	a0,2
    80005238:	ffffe097          	auipc	ra,0xffffe
    8000523c:	86a080e7          	jalr	-1942(ra) # 80002aa2 <argint>
    return -1;
    80005240:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005242:	02054763          	bltz	a0,80005270 <sys_read+0x5c>
    80005246:	fd840593          	addi	a1,s0,-40
    8000524a:	4505                	li	a0,1
    8000524c:	ffffe097          	auipc	ra,0xffffe
    80005250:	878080e7          	jalr	-1928(ra) # 80002ac4 <argaddr>
    return -1;
    80005254:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005256:	00054d63          	bltz	a0,80005270 <sys_read+0x5c>
  return fileread(f, p, n);
    8000525a:	fe442603          	lw	a2,-28(s0)
    8000525e:	fd843583          	ld	a1,-40(s0)
    80005262:	fe843503          	ld	a0,-24(s0)
    80005266:	fffff097          	auipc	ra,0xfffff
    8000526a:	490080e7          	jalr	1168(ra) # 800046f6 <fileread>
    8000526e:	87aa                	mv	a5,a0
}
    80005270:	853e                	mv	a0,a5
    80005272:	70a2                	ld	ra,40(sp)
    80005274:	7402                	ld	s0,32(sp)
    80005276:	6145                	addi	sp,sp,48
    80005278:	8082                	ret

000000008000527a <sys_write>:
{
    8000527a:	7179                	addi	sp,sp,-48
    8000527c:	f406                	sd	ra,40(sp)
    8000527e:	f022                	sd	s0,32(sp)
    80005280:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005282:	fe840613          	addi	a2,s0,-24
    80005286:	4581                	li	a1,0
    80005288:	4501                	li	a0,0
    8000528a:	00000097          	auipc	ra,0x0
    8000528e:	d2c080e7          	jalr	-724(ra) # 80004fb6 <argfd>
    return -1;
    80005292:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005294:	04054163          	bltz	a0,800052d6 <sys_write+0x5c>
    80005298:	fe440593          	addi	a1,s0,-28
    8000529c:	4509                	li	a0,2
    8000529e:	ffffe097          	auipc	ra,0xffffe
    800052a2:	804080e7          	jalr	-2044(ra) # 80002aa2 <argint>
    return -1;
    800052a6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052a8:	02054763          	bltz	a0,800052d6 <sys_write+0x5c>
    800052ac:	fd840593          	addi	a1,s0,-40
    800052b0:	4505                	li	a0,1
    800052b2:	ffffe097          	auipc	ra,0xffffe
    800052b6:	812080e7          	jalr	-2030(ra) # 80002ac4 <argaddr>
    return -1;
    800052ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800052bc:	00054d63          	bltz	a0,800052d6 <sys_write+0x5c>
  return filewrite(f, p, n);
    800052c0:	fe442603          	lw	a2,-28(s0)
    800052c4:	fd843583          	ld	a1,-40(s0)
    800052c8:	fe843503          	ld	a0,-24(s0)
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	4ec080e7          	jalr	1260(ra) # 800047b8 <filewrite>
    800052d4:	87aa                	mv	a5,a0
}
    800052d6:	853e                	mv	a0,a5
    800052d8:	70a2                	ld	ra,40(sp)
    800052da:	7402                	ld	s0,32(sp)
    800052dc:	6145                	addi	sp,sp,48
    800052de:	8082                	ret

00000000800052e0 <sys_close>:
{
    800052e0:	1101                	addi	sp,sp,-32
    800052e2:	ec06                	sd	ra,24(sp)
    800052e4:	e822                	sd	s0,16(sp)
    800052e6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800052e8:	fe040613          	addi	a2,s0,-32
    800052ec:	fec40593          	addi	a1,s0,-20
    800052f0:	4501                	li	a0,0
    800052f2:	00000097          	auipc	ra,0x0
    800052f6:	cc4080e7          	jalr	-828(ra) # 80004fb6 <argfd>
    return -1;
    800052fa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800052fc:	02054463          	bltz	a0,80005324 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005300:	ffffc097          	auipc	ra,0xffffc
    80005304:	67e080e7          	jalr	1662(ra) # 8000197e <myproc>
    80005308:	fec42783          	lw	a5,-20(s0)
    8000530c:	07e9                	addi	a5,a5,26
    8000530e:	078e                	slli	a5,a5,0x3
    80005310:	97aa                	add	a5,a5,a0
    80005312:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80005316:	fe043503          	ld	a0,-32(s0)
    8000531a:	fffff097          	auipc	ra,0xfffff
    8000531e:	2a2080e7          	jalr	674(ra) # 800045bc <fileclose>
  return 0;
    80005322:	4781                	li	a5,0
}
    80005324:	853e                	mv	a0,a5
    80005326:	60e2                	ld	ra,24(sp)
    80005328:	6442                	ld	s0,16(sp)
    8000532a:	6105                	addi	sp,sp,32
    8000532c:	8082                	ret

000000008000532e <sys_fstat>:
{
    8000532e:	1101                	addi	sp,sp,-32
    80005330:	ec06                	sd	ra,24(sp)
    80005332:	e822                	sd	s0,16(sp)
    80005334:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005336:	fe840613          	addi	a2,s0,-24
    8000533a:	4581                	li	a1,0
    8000533c:	4501                	li	a0,0
    8000533e:	00000097          	auipc	ra,0x0
    80005342:	c78080e7          	jalr	-904(ra) # 80004fb6 <argfd>
    return -1;
    80005346:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005348:	02054563          	bltz	a0,80005372 <sys_fstat+0x44>
    8000534c:	fe040593          	addi	a1,s0,-32
    80005350:	4505                	li	a0,1
    80005352:	ffffd097          	auipc	ra,0xffffd
    80005356:	772080e7          	jalr	1906(ra) # 80002ac4 <argaddr>
    return -1;
    8000535a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000535c:	00054b63          	bltz	a0,80005372 <sys_fstat+0x44>
  return filestat(f, st);
    80005360:	fe043583          	ld	a1,-32(s0)
    80005364:	fe843503          	ld	a0,-24(s0)
    80005368:	fffff097          	auipc	ra,0xfffff
    8000536c:	31c080e7          	jalr	796(ra) # 80004684 <filestat>
    80005370:	87aa                	mv	a5,a0
}
    80005372:	853e                	mv	a0,a5
    80005374:	60e2                	ld	ra,24(sp)
    80005376:	6442                	ld	s0,16(sp)
    80005378:	6105                	addi	sp,sp,32
    8000537a:	8082                	ret

000000008000537c <sys_link>:
{
    8000537c:	7169                	addi	sp,sp,-304
    8000537e:	f606                	sd	ra,296(sp)
    80005380:	f222                	sd	s0,288(sp)
    80005382:	ee26                	sd	s1,280(sp)
    80005384:	ea4a                	sd	s2,272(sp)
    80005386:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005388:	08000613          	li	a2,128
    8000538c:	ed040593          	addi	a1,s0,-304
    80005390:	4501                	li	a0,0
    80005392:	ffffd097          	auipc	ra,0xffffd
    80005396:	754080e7          	jalr	1876(ra) # 80002ae6 <argstr>
    return -1;
    8000539a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000539c:	10054e63          	bltz	a0,800054b8 <sys_link+0x13c>
    800053a0:	08000613          	li	a2,128
    800053a4:	f5040593          	addi	a1,s0,-176
    800053a8:	4505                	li	a0,1
    800053aa:	ffffd097          	auipc	ra,0xffffd
    800053ae:	73c080e7          	jalr	1852(ra) # 80002ae6 <argstr>
    return -1;
    800053b2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800053b4:	10054263          	bltz	a0,800054b8 <sys_link+0x13c>
  begin_op();
    800053b8:	fffff097          	auipc	ra,0xfffff
    800053bc:	d38080e7          	jalr	-712(ra) # 800040f0 <begin_op>
  if((ip = namei(old)) == 0){
    800053c0:	ed040513          	addi	a0,s0,-304
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	b0c080e7          	jalr	-1268(ra) # 80003ed0 <namei>
    800053cc:	84aa                	mv	s1,a0
    800053ce:	c551                	beqz	a0,8000545a <sys_link+0xde>
  ilock(ip);
    800053d0:	ffffe097          	auipc	ra,0xffffe
    800053d4:	34a080e7          	jalr	842(ra) # 8000371a <ilock>
  if(ip->type == T_DIR){
    800053d8:	04449703          	lh	a4,68(s1)
    800053dc:	4785                	li	a5,1
    800053de:	08f70463          	beq	a4,a5,80005466 <sys_link+0xea>
  ip->nlink++;
    800053e2:	04a4d783          	lhu	a5,74(s1)
    800053e6:	2785                	addiw	a5,a5,1
    800053e8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053ec:	8526                	mv	a0,s1
    800053ee:	ffffe097          	auipc	ra,0xffffe
    800053f2:	262080e7          	jalr	610(ra) # 80003650 <iupdate>
  iunlock(ip);
    800053f6:	8526                	mv	a0,s1
    800053f8:	ffffe097          	auipc	ra,0xffffe
    800053fc:	3e4080e7          	jalr	996(ra) # 800037dc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005400:	fd040593          	addi	a1,s0,-48
    80005404:	f5040513          	addi	a0,s0,-176
    80005408:	fffff097          	auipc	ra,0xfffff
    8000540c:	ae6080e7          	jalr	-1306(ra) # 80003eee <nameiparent>
    80005410:	892a                	mv	s2,a0
    80005412:	c935                	beqz	a0,80005486 <sys_link+0x10a>
  ilock(dp);
    80005414:	ffffe097          	auipc	ra,0xffffe
    80005418:	306080e7          	jalr	774(ra) # 8000371a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000541c:	00092703          	lw	a4,0(s2)
    80005420:	409c                	lw	a5,0(s1)
    80005422:	04f71d63          	bne	a4,a5,8000547c <sys_link+0x100>
    80005426:	40d0                	lw	a2,4(s1)
    80005428:	fd040593          	addi	a1,s0,-48
    8000542c:	854a                	mv	a0,s2
    8000542e:	fffff097          	auipc	ra,0xfffff
    80005432:	9e0080e7          	jalr	-1568(ra) # 80003e0e <dirlink>
    80005436:	04054363          	bltz	a0,8000547c <sys_link+0x100>
  iunlockput(dp);
    8000543a:	854a                	mv	a0,s2
    8000543c:	ffffe097          	auipc	ra,0xffffe
    80005440:	540080e7          	jalr	1344(ra) # 8000397c <iunlockput>
  iput(ip);
    80005444:	8526                	mv	a0,s1
    80005446:	ffffe097          	auipc	ra,0xffffe
    8000544a:	48e080e7          	jalr	1166(ra) # 800038d4 <iput>
  end_op();
    8000544e:	fffff097          	auipc	ra,0xfffff
    80005452:	d22080e7          	jalr	-734(ra) # 80004170 <end_op>
  return 0;
    80005456:	4781                	li	a5,0
    80005458:	a085                	j	800054b8 <sys_link+0x13c>
    end_op();
    8000545a:	fffff097          	auipc	ra,0xfffff
    8000545e:	d16080e7          	jalr	-746(ra) # 80004170 <end_op>
    return -1;
    80005462:	57fd                	li	a5,-1
    80005464:	a891                	j	800054b8 <sys_link+0x13c>
    iunlockput(ip);
    80005466:	8526                	mv	a0,s1
    80005468:	ffffe097          	auipc	ra,0xffffe
    8000546c:	514080e7          	jalr	1300(ra) # 8000397c <iunlockput>
    end_op();
    80005470:	fffff097          	auipc	ra,0xfffff
    80005474:	d00080e7          	jalr	-768(ra) # 80004170 <end_op>
    return -1;
    80005478:	57fd                	li	a5,-1
    8000547a:	a83d                	j	800054b8 <sys_link+0x13c>
    iunlockput(dp);
    8000547c:	854a                	mv	a0,s2
    8000547e:	ffffe097          	auipc	ra,0xffffe
    80005482:	4fe080e7          	jalr	1278(ra) # 8000397c <iunlockput>
  ilock(ip);
    80005486:	8526                	mv	a0,s1
    80005488:	ffffe097          	auipc	ra,0xffffe
    8000548c:	292080e7          	jalr	658(ra) # 8000371a <ilock>
  ip->nlink--;
    80005490:	04a4d783          	lhu	a5,74(s1)
    80005494:	37fd                	addiw	a5,a5,-1
    80005496:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000549a:	8526                	mv	a0,s1
    8000549c:	ffffe097          	auipc	ra,0xffffe
    800054a0:	1b4080e7          	jalr	436(ra) # 80003650 <iupdate>
  iunlockput(ip);
    800054a4:	8526                	mv	a0,s1
    800054a6:	ffffe097          	auipc	ra,0xffffe
    800054aa:	4d6080e7          	jalr	1238(ra) # 8000397c <iunlockput>
  end_op();
    800054ae:	fffff097          	auipc	ra,0xfffff
    800054b2:	cc2080e7          	jalr	-830(ra) # 80004170 <end_op>
  return -1;
    800054b6:	57fd                	li	a5,-1
}
    800054b8:	853e                	mv	a0,a5
    800054ba:	70b2                	ld	ra,296(sp)
    800054bc:	7412                	ld	s0,288(sp)
    800054be:	64f2                	ld	s1,280(sp)
    800054c0:	6952                	ld	s2,272(sp)
    800054c2:	6155                	addi	sp,sp,304
    800054c4:	8082                	ret

00000000800054c6 <sys_unlink>:
{
    800054c6:	7151                	addi	sp,sp,-240
    800054c8:	f586                	sd	ra,232(sp)
    800054ca:	f1a2                	sd	s0,224(sp)
    800054cc:	eda6                	sd	s1,216(sp)
    800054ce:	e9ca                	sd	s2,208(sp)
    800054d0:	e5ce                	sd	s3,200(sp)
    800054d2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800054d4:	08000613          	li	a2,128
    800054d8:	f3040593          	addi	a1,s0,-208
    800054dc:	4501                	li	a0,0
    800054de:	ffffd097          	auipc	ra,0xffffd
    800054e2:	608080e7          	jalr	1544(ra) # 80002ae6 <argstr>
    800054e6:	18054163          	bltz	a0,80005668 <sys_unlink+0x1a2>
  begin_op();
    800054ea:	fffff097          	auipc	ra,0xfffff
    800054ee:	c06080e7          	jalr	-1018(ra) # 800040f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800054f2:	fb040593          	addi	a1,s0,-80
    800054f6:	f3040513          	addi	a0,s0,-208
    800054fa:	fffff097          	auipc	ra,0xfffff
    800054fe:	9f4080e7          	jalr	-1548(ra) # 80003eee <nameiparent>
    80005502:	84aa                	mv	s1,a0
    80005504:	c979                	beqz	a0,800055da <sys_unlink+0x114>
  ilock(dp);
    80005506:	ffffe097          	auipc	ra,0xffffe
    8000550a:	214080e7          	jalr	532(ra) # 8000371a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000550e:	00003597          	auipc	a1,0x3
    80005512:	38a58593          	addi	a1,a1,906 # 80008898 <syscalls_strings+0x2b0>
    80005516:	fb040513          	addi	a0,s0,-80
    8000551a:	ffffe097          	auipc	ra,0xffffe
    8000551e:	6ca080e7          	jalr	1738(ra) # 80003be4 <namecmp>
    80005522:	14050a63          	beqz	a0,80005676 <sys_unlink+0x1b0>
    80005526:	00003597          	auipc	a1,0x3
    8000552a:	37a58593          	addi	a1,a1,890 # 800088a0 <syscalls_strings+0x2b8>
    8000552e:	fb040513          	addi	a0,s0,-80
    80005532:	ffffe097          	auipc	ra,0xffffe
    80005536:	6b2080e7          	jalr	1714(ra) # 80003be4 <namecmp>
    8000553a:	12050e63          	beqz	a0,80005676 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000553e:	f2c40613          	addi	a2,s0,-212
    80005542:	fb040593          	addi	a1,s0,-80
    80005546:	8526                	mv	a0,s1
    80005548:	ffffe097          	auipc	ra,0xffffe
    8000554c:	6b6080e7          	jalr	1718(ra) # 80003bfe <dirlookup>
    80005550:	892a                	mv	s2,a0
    80005552:	12050263          	beqz	a0,80005676 <sys_unlink+0x1b0>
  ilock(ip);
    80005556:	ffffe097          	auipc	ra,0xffffe
    8000555a:	1c4080e7          	jalr	452(ra) # 8000371a <ilock>
  if(ip->nlink < 1)
    8000555e:	04a91783          	lh	a5,74(s2)
    80005562:	08f05263          	blez	a5,800055e6 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005566:	04491703          	lh	a4,68(s2)
    8000556a:	4785                	li	a5,1
    8000556c:	08f70563          	beq	a4,a5,800055f6 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005570:	4641                	li	a2,16
    80005572:	4581                	li	a1,0
    80005574:	fc040513          	addi	a0,s0,-64
    80005578:	ffffb097          	auipc	ra,0xffffb
    8000557c:	746080e7          	jalr	1862(ra) # 80000cbe <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005580:	4741                	li	a4,16
    80005582:	f2c42683          	lw	a3,-212(s0)
    80005586:	fc040613          	addi	a2,s0,-64
    8000558a:	4581                	li	a1,0
    8000558c:	8526                	mv	a0,s1
    8000558e:	ffffe097          	auipc	ra,0xffffe
    80005592:	538080e7          	jalr	1336(ra) # 80003ac6 <writei>
    80005596:	47c1                	li	a5,16
    80005598:	0af51563          	bne	a0,a5,80005642 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    8000559c:	04491703          	lh	a4,68(s2)
    800055a0:	4785                	li	a5,1
    800055a2:	0af70863          	beq	a4,a5,80005652 <sys_unlink+0x18c>
  iunlockput(dp);
    800055a6:	8526                	mv	a0,s1
    800055a8:	ffffe097          	auipc	ra,0xffffe
    800055ac:	3d4080e7          	jalr	980(ra) # 8000397c <iunlockput>
  ip->nlink--;
    800055b0:	04a95783          	lhu	a5,74(s2)
    800055b4:	37fd                	addiw	a5,a5,-1
    800055b6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800055ba:	854a                	mv	a0,s2
    800055bc:	ffffe097          	auipc	ra,0xffffe
    800055c0:	094080e7          	jalr	148(ra) # 80003650 <iupdate>
  iunlockput(ip);
    800055c4:	854a                	mv	a0,s2
    800055c6:	ffffe097          	auipc	ra,0xffffe
    800055ca:	3b6080e7          	jalr	950(ra) # 8000397c <iunlockput>
  end_op();
    800055ce:	fffff097          	auipc	ra,0xfffff
    800055d2:	ba2080e7          	jalr	-1118(ra) # 80004170 <end_op>
  return 0;
    800055d6:	4501                	li	a0,0
    800055d8:	a84d                	j	8000568a <sys_unlink+0x1c4>
    end_op();
    800055da:	fffff097          	auipc	ra,0xfffff
    800055de:	b96080e7          	jalr	-1130(ra) # 80004170 <end_op>
    return -1;
    800055e2:	557d                	li	a0,-1
    800055e4:	a05d                	j	8000568a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800055e6:	00003517          	auipc	a0,0x3
    800055ea:	2e250513          	addi	a0,a0,738 # 800088c8 <syscalls_strings+0x2e0>
    800055ee:	ffffb097          	auipc	ra,0xffffb
    800055f2:	f3c080e7          	jalr	-196(ra) # 8000052a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800055f6:	04c92703          	lw	a4,76(s2)
    800055fa:	02000793          	li	a5,32
    800055fe:	f6e7f9e3          	bgeu	a5,a4,80005570 <sys_unlink+0xaa>
    80005602:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005606:	4741                	li	a4,16
    80005608:	86ce                	mv	a3,s3
    8000560a:	f1840613          	addi	a2,s0,-232
    8000560e:	4581                	li	a1,0
    80005610:	854a                	mv	a0,s2
    80005612:	ffffe097          	auipc	ra,0xffffe
    80005616:	3bc080e7          	jalr	956(ra) # 800039ce <readi>
    8000561a:	47c1                	li	a5,16
    8000561c:	00f51b63          	bne	a0,a5,80005632 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005620:	f1845783          	lhu	a5,-232(s0)
    80005624:	e7a1                	bnez	a5,8000566c <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005626:	29c1                	addiw	s3,s3,16
    80005628:	04c92783          	lw	a5,76(s2)
    8000562c:	fcf9ede3          	bltu	s3,a5,80005606 <sys_unlink+0x140>
    80005630:	b781                	j	80005570 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	2ae50513          	addi	a0,a0,686 # 800088e0 <syscalls_strings+0x2f8>
    8000563a:	ffffb097          	auipc	ra,0xffffb
    8000563e:	ef0080e7          	jalr	-272(ra) # 8000052a <panic>
    panic("unlink: writei");
    80005642:	00003517          	auipc	a0,0x3
    80005646:	2b650513          	addi	a0,a0,694 # 800088f8 <syscalls_strings+0x310>
    8000564a:	ffffb097          	auipc	ra,0xffffb
    8000564e:	ee0080e7          	jalr	-288(ra) # 8000052a <panic>
    dp->nlink--;
    80005652:	04a4d783          	lhu	a5,74(s1)
    80005656:	37fd                	addiw	a5,a5,-1
    80005658:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000565c:	8526                	mv	a0,s1
    8000565e:	ffffe097          	auipc	ra,0xffffe
    80005662:	ff2080e7          	jalr	-14(ra) # 80003650 <iupdate>
    80005666:	b781                	j	800055a6 <sys_unlink+0xe0>
    return -1;
    80005668:	557d                	li	a0,-1
    8000566a:	a005                	j	8000568a <sys_unlink+0x1c4>
    iunlockput(ip);
    8000566c:	854a                	mv	a0,s2
    8000566e:	ffffe097          	auipc	ra,0xffffe
    80005672:	30e080e7          	jalr	782(ra) # 8000397c <iunlockput>
  iunlockput(dp);
    80005676:	8526                	mv	a0,s1
    80005678:	ffffe097          	auipc	ra,0xffffe
    8000567c:	304080e7          	jalr	772(ra) # 8000397c <iunlockput>
  end_op();
    80005680:	fffff097          	auipc	ra,0xfffff
    80005684:	af0080e7          	jalr	-1296(ra) # 80004170 <end_op>
  return -1;
    80005688:	557d                	li	a0,-1
}
    8000568a:	70ae                	ld	ra,232(sp)
    8000568c:	740e                	ld	s0,224(sp)
    8000568e:	64ee                	ld	s1,216(sp)
    80005690:	694e                	ld	s2,208(sp)
    80005692:	69ae                	ld	s3,200(sp)
    80005694:	616d                	addi	sp,sp,240
    80005696:	8082                	ret

0000000080005698 <sys_open>:

uint64
sys_open(void)
{
    80005698:	7131                	addi	sp,sp,-192
    8000569a:	fd06                	sd	ra,184(sp)
    8000569c:	f922                	sd	s0,176(sp)
    8000569e:	f526                	sd	s1,168(sp)
    800056a0:	f14a                	sd	s2,160(sp)
    800056a2:	ed4e                	sd	s3,152(sp)
    800056a4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056a6:	08000613          	li	a2,128
    800056aa:	f5040593          	addi	a1,s0,-176
    800056ae:	4501                	li	a0,0
    800056b0:	ffffd097          	auipc	ra,0xffffd
    800056b4:	436080e7          	jalr	1078(ra) # 80002ae6 <argstr>
    return -1;
    800056b8:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800056ba:	0c054163          	bltz	a0,8000577c <sys_open+0xe4>
    800056be:	f4c40593          	addi	a1,s0,-180
    800056c2:	4505                	li	a0,1
    800056c4:	ffffd097          	auipc	ra,0xffffd
    800056c8:	3de080e7          	jalr	990(ra) # 80002aa2 <argint>
    800056cc:	0a054863          	bltz	a0,8000577c <sys_open+0xe4>

  begin_op();
    800056d0:	fffff097          	auipc	ra,0xfffff
    800056d4:	a20080e7          	jalr	-1504(ra) # 800040f0 <begin_op>

  if(omode & O_CREATE){
    800056d8:	f4c42783          	lw	a5,-180(s0)
    800056dc:	2007f793          	andi	a5,a5,512
    800056e0:	cbdd                	beqz	a5,80005796 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800056e2:	4681                	li	a3,0
    800056e4:	4601                	li	a2,0
    800056e6:	4589                	li	a1,2
    800056e8:	f5040513          	addi	a0,s0,-176
    800056ec:	00000097          	auipc	ra,0x0
    800056f0:	974080e7          	jalr	-1676(ra) # 80005060 <create>
    800056f4:	892a                	mv	s2,a0
    if(ip == 0){
    800056f6:	c959                	beqz	a0,8000578c <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800056f8:	04491703          	lh	a4,68(s2)
    800056fc:	478d                	li	a5,3
    800056fe:	00f71763          	bne	a4,a5,8000570c <sys_open+0x74>
    80005702:	04695703          	lhu	a4,70(s2)
    80005706:	47a5                	li	a5,9
    80005708:	0ce7ec63          	bltu	a5,a4,800057e0 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000570c:	fffff097          	auipc	ra,0xfffff
    80005710:	df4080e7          	jalr	-524(ra) # 80004500 <filealloc>
    80005714:	89aa                	mv	s3,a0
    80005716:	10050263          	beqz	a0,8000581a <sys_open+0x182>
    8000571a:	00000097          	auipc	ra,0x0
    8000571e:	904080e7          	jalr	-1788(ra) # 8000501e <fdalloc>
    80005722:	84aa                	mv	s1,a0
    80005724:	0e054663          	bltz	a0,80005810 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005728:	04491703          	lh	a4,68(s2)
    8000572c:	478d                	li	a5,3
    8000572e:	0cf70463          	beq	a4,a5,800057f6 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005732:	4789                	li	a5,2
    80005734:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005738:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    8000573c:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005740:	f4c42783          	lw	a5,-180(s0)
    80005744:	0017c713          	xori	a4,a5,1
    80005748:	8b05                	andi	a4,a4,1
    8000574a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000574e:	0037f713          	andi	a4,a5,3
    80005752:	00e03733          	snez	a4,a4
    80005756:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000575a:	4007f793          	andi	a5,a5,1024
    8000575e:	c791                	beqz	a5,8000576a <sys_open+0xd2>
    80005760:	04491703          	lh	a4,68(s2)
    80005764:	4789                	li	a5,2
    80005766:	08f70f63          	beq	a4,a5,80005804 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    8000576a:	854a                	mv	a0,s2
    8000576c:	ffffe097          	auipc	ra,0xffffe
    80005770:	070080e7          	jalr	112(ra) # 800037dc <iunlock>
  end_op();
    80005774:	fffff097          	auipc	ra,0xfffff
    80005778:	9fc080e7          	jalr	-1540(ra) # 80004170 <end_op>

  return fd;
}
    8000577c:	8526                	mv	a0,s1
    8000577e:	70ea                	ld	ra,184(sp)
    80005780:	744a                	ld	s0,176(sp)
    80005782:	74aa                	ld	s1,168(sp)
    80005784:	790a                	ld	s2,160(sp)
    80005786:	69ea                	ld	s3,152(sp)
    80005788:	6129                	addi	sp,sp,192
    8000578a:	8082                	ret
      end_op();
    8000578c:	fffff097          	auipc	ra,0xfffff
    80005790:	9e4080e7          	jalr	-1564(ra) # 80004170 <end_op>
      return -1;
    80005794:	b7e5                	j	8000577c <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80005796:	f5040513          	addi	a0,s0,-176
    8000579a:	ffffe097          	auipc	ra,0xffffe
    8000579e:	736080e7          	jalr	1846(ra) # 80003ed0 <namei>
    800057a2:	892a                	mv	s2,a0
    800057a4:	c905                	beqz	a0,800057d4 <sys_open+0x13c>
    ilock(ip);
    800057a6:	ffffe097          	auipc	ra,0xffffe
    800057aa:	f74080e7          	jalr	-140(ra) # 8000371a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800057ae:	04491703          	lh	a4,68(s2)
    800057b2:	4785                	li	a5,1
    800057b4:	f4f712e3          	bne	a4,a5,800056f8 <sys_open+0x60>
    800057b8:	f4c42783          	lw	a5,-180(s0)
    800057bc:	dba1                	beqz	a5,8000570c <sys_open+0x74>
      iunlockput(ip);
    800057be:	854a                	mv	a0,s2
    800057c0:	ffffe097          	auipc	ra,0xffffe
    800057c4:	1bc080e7          	jalr	444(ra) # 8000397c <iunlockput>
      end_op();
    800057c8:	fffff097          	auipc	ra,0xfffff
    800057cc:	9a8080e7          	jalr	-1624(ra) # 80004170 <end_op>
      return -1;
    800057d0:	54fd                	li	s1,-1
    800057d2:	b76d                	j	8000577c <sys_open+0xe4>
      end_op();
    800057d4:	fffff097          	auipc	ra,0xfffff
    800057d8:	99c080e7          	jalr	-1636(ra) # 80004170 <end_op>
      return -1;
    800057dc:	54fd                	li	s1,-1
    800057de:	bf79                	j	8000577c <sys_open+0xe4>
    iunlockput(ip);
    800057e0:	854a                	mv	a0,s2
    800057e2:	ffffe097          	auipc	ra,0xffffe
    800057e6:	19a080e7          	jalr	410(ra) # 8000397c <iunlockput>
    end_op();
    800057ea:	fffff097          	auipc	ra,0xfffff
    800057ee:	986080e7          	jalr	-1658(ra) # 80004170 <end_op>
    return -1;
    800057f2:	54fd                	li	s1,-1
    800057f4:	b761                	j	8000577c <sys_open+0xe4>
    f->type = FD_DEVICE;
    800057f6:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    800057fa:	04691783          	lh	a5,70(s2)
    800057fe:	02f99223          	sh	a5,36(s3)
    80005802:	bf2d                	j	8000573c <sys_open+0xa4>
    itrunc(ip);
    80005804:	854a                	mv	a0,s2
    80005806:	ffffe097          	auipc	ra,0xffffe
    8000580a:	022080e7          	jalr	34(ra) # 80003828 <itrunc>
    8000580e:	bfb1                	j	8000576a <sys_open+0xd2>
      fileclose(f);
    80005810:	854e                	mv	a0,s3
    80005812:	fffff097          	auipc	ra,0xfffff
    80005816:	daa080e7          	jalr	-598(ra) # 800045bc <fileclose>
    iunlockput(ip);
    8000581a:	854a                	mv	a0,s2
    8000581c:	ffffe097          	auipc	ra,0xffffe
    80005820:	160080e7          	jalr	352(ra) # 8000397c <iunlockput>
    end_op();
    80005824:	fffff097          	auipc	ra,0xfffff
    80005828:	94c080e7          	jalr	-1716(ra) # 80004170 <end_op>
    return -1;
    8000582c:	54fd                	li	s1,-1
    8000582e:	b7b9                	j	8000577c <sys_open+0xe4>

0000000080005830 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005830:	7175                	addi	sp,sp,-144
    80005832:	e506                	sd	ra,136(sp)
    80005834:	e122                	sd	s0,128(sp)
    80005836:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005838:	fffff097          	auipc	ra,0xfffff
    8000583c:	8b8080e7          	jalr	-1864(ra) # 800040f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005840:	08000613          	li	a2,128
    80005844:	f7040593          	addi	a1,s0,-144
    80005848:	4501                	li	a0,0
    8000584a:	ffffd097          	auipc	ra,0xffffd
    8000584e:	29c080e7          	jalr	668(ra) # 80002ae6 <argstr>
    80005852:	02054963          	bltz	a0,80005884 <sys_mkdir+0x54>
    80005856:	4681                	li	a3,0
    80005858:	4601                	li	a2,0
    8000585a:	4585                	li	a1,1
    8000585c:	f7040513          	addi	a0,s0,-144
    80005860:	00000097          	auipc	ra,0x0
    80005864:	800080e7          	jalr	-2048(ra) # 80005060 <create>
    80005868:	cd11                	beqz	a0,80005884 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000586a:	ffffe097          	auipc	ra,0xffffe
    8000586e:	112080e7          	jalr	274(ra) # 8000397c <iunlockput>
  end_op();
    80005872:	fffff097          	auipc	ra,0xfffff
    80005876:	8fe080e7          	jalr	-1794(ra) # 80004170 <end_op>
  return 0;
    8000587a:	4501                	li	a0,0
}
    8000587c:	60aa                	ld	ra,136(sp)
    8000587e:	640a                	ld	s0,128(sp)
    80005880:	6149                	addi	sp,sp,144
    80005882:	8082                	ret
    end_op();
    80005884:	fffff097          	auipc	ra,0xfffff
    80005888:	8ec080e7          	jalr	-1812(ra) # 80004170 <end_op>
    return -1;
    8000588c:	557d                	li	a0,-1
    8000588e:	b7fd                	j	8000587c <sys_mkdir+0x4c>

0000000080005890 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005890:	7135                	addi	sp,sp,-160
    80005892:	ed06                	sd	ra,152(sp)
    80005894:	e922                	sd	s0,144(sp)
    80005896:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005898:	fffff097          	auipc	ra,0xfffff
    8000589c:	858080e7          	jalr	-1960(ra) # 800040f0 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058a0:	08000613          	li	a2,128
    800058a4:	f7040593          	addi	a1,s0,-144
    800058a8:	4501                	li	a0,0
    800058aa:	ffffd097          	auipc	ra,0xffffd
    800058ae:	23c080e7          	jalr	572(ra) # 80002ae6 <argstr>
    800058b2:	04054a63          	bltz	a0,80005906 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800058b6:	f6c40593          	addi	a1,s0,-148
    800058ba:	4505                	li	a0,1
    800058bc:	ffffd097          	auipc	ra,0xffffd
    800058c0:	1e6080e7          	jalr	486(ra) # 80002aa2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800058c4:	04054163          	bltz	a0,80005906 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800058c8:	f6840593          	addi	a1,s0,-152
    800058cc:	4509                	li	a0,2
    800058ce:	ffffd097          	auipc	ra,0xffffd
    800058d2:	1d4080e7          	jalr	468(ra) # 80002aa2 <argint>
     argint(1, &major) < 0 ||
    800058d6:	02054863          	bltz	a0,80005906 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800058da:	f6841683          	lh	a3,-152(s0)
    800058de:	f6c41603          	lh	a2,-148(s0)
    800058e2:	458d                	li	a1,3
    800058e4:	f7040513          	addi	a0,s0,-144
    800058e8:	fffff097          	auipc	ra,0xfffff
    800058ec:	778080e7          	jalr	1912(ra) # 80005060 <create>
     argint(2, &minor) < 0 ||
    800058f0:	c919                	beqz	a0,80005906 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800058f2:	ffffe097          	auipc	ra,0xffffe
    800058f6:	08a080e7          	jalr	138(ra) # 8000397c <iunlockput>
  end_op();
    800058fa:	fffff097          	auipc	ra,0xfffff
    800058fe:	876080e7          	jalr	-1930(ra) # 80004170 <end_op>
  return 0;
    80005902:	4501                	li	a0,0
    80005904:	a031                	j	80005910 <sys_mknod+0x80>
    end_op();
    80005906:	fffff097          	auipc	ra,0xfffff
    8000590a:	86a080e7          	jalr	-1942(ra) # 80004170 <end_op>
    return -1;
    8000590e:	557d                	li	a0,-1
}
    80005910:	60ea                	ld	ra,152(sp)
    80005912:	644a                	ld	s0,144(sp)
    80005914:	610d                	addi	sp,sp,160
    80005916:	8082                	ret

0000000080005918 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005918:	7135                	addi	sp,sp,-160
    8000591a:	ed06                	sd	ra,152(sp)
    8000591c:	e922                	sd	s0,144(sp)
    8000591e:	e526                	sd	s1,136(sp)
    80005920:	e14a                	sd	s2,128(sp)
    80005922:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005924:	ffffc097          	auipc	ra,0xffffc
    80005928:	05a080e7          	jalr	90(ra) # 8000197e <myproc>
    8000592c:	892a                	mv	s2,a0
  
  begin_op();
    8000592e:	ffffe097          	auipc	ra,0xffffe
    80005932:	7c2080e7          	jalr	1986(ra) # 800040f0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005936:	08000613          	li	a2,128
    8000593a:	f6040593          	addi	a1,s0,-160
    8000593e:	4501                	li	a0,0
    80005940:	ffffd097          	auipc	ra,0xffffd
    80005944:	1a6080e7          	jalr	422(ra) # 80002ae6 <argstr>
    80005948:	04054b63          	bltz	a0,8000599e <sys_chdir+0x86>
    8000594c:	f6040513          	addi	a0,s0,-160
    80005950:	ffffe097          	auipc	ra,0xffffe
    80005954:	580080e7          	jalr	1408(ra) # 80003ed0 <namei>
    80005958:	84aa                	mv	s1,a0
    8000595a:	c131                	beqz	a0,8000599e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000595c:	ffffe097          	auipc	ra,0xffffe
    80005960:	dbe080e7          	jalr	-578(ra) # 8000371a <ilock>
  if(ip->type != T_DIR){
    80005964:	04449703          	lh	a4,68(s1)
    80005968:	4785                	li	a5,1
    8000596a:	04f71063          	bne	a4,a5,800059aa <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000596e:	8526                	mv	a0,s1
    80005970:	ffffe097          	auipc	ra,0xffffe
    80005974:	e6c080e7          	jalr	-404(ra) # 800037dc <iunlock>
  iput(p->cwd);
    80005978:	15093503          	ld	a0,336(s2)
    8000597c:	ffffe097          	auipc	ra,0xffffe
    80005980:	f58080e7          	jalr	-168(ra) # 800038d4 <iput>
  end_op();
    80005984:	ffffe097          	auipc	ra,0xffffe
    80005988:	7ec080e7          	jalr	2028(ra) # 80004170 <end_op>
  p->cwd = ip;
    8000598c:	14993823          	sd	s1,336(s2)
  return 0;
    80005990:	4501                	li	a0,0
}
    80005992:	60ea                	ld	ra,152(sp)
    80005994:	644a                	ld	s0,144(sp)
    80005996:	64aa                	ld	s1,136(sp)
    80005998:	690a                	ld	s2,128(sp)
    8000599a:	610d                	addi	sp,sp,160
    8000599c:	8082                	ret
    end_op();
    8000599e:	ffffe097          	auipc	ra,0xffffe
    800059a2:	7d2080e7          	jalr	2002(ra) # 80004170 <end_op>
    return -1;
    800059a6:	557d                	li	a0,-1
    800059a8:	b7ed                	j	80005992 <sys_chdir+0x7a>
    iunlockput(ip);
    800059aa:	8526                	mv	a0,s1
    800059ac:	ffffe097          	auipc	ra,0xffffe
    800059b0:	fd0080e7          	jalr	-48(ra) # 8000397c <iunlockput>
    end_op();
    800059b4:	ffffe097          	auipc	ra,0xffffe
    800059b8:	7bc080e7          	jalr	1980(ra) # 80004170 <end_op>
    return -1;
    800059bc:	557d                	li	a0,-1
    800059be:	bfd1                	j	80005992 <sys_chdir+0x7a>

00000000800059c0 <sys_exec>:

uint64
sys_exec(void)
{
    800059c0:	7145                	addi	sp,sp,-464
    800059c2:	e786                	sd	ra,456(sp)
    800059c4:	e3a2                	sd	s0,448(sp)
    800059c6:	ff26                	sd	s1,440(sp)
    800059c8:	fb4a                	sd	s2,432(sp)
    800059ca:	f74e                	sd	s3,424(sp)
    800059cc:	f352                	sd	s4,416(sp)
    800059ce:	ef56                	sd	s5,408(sp)
    800059d0:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059d2:	08000613          	li	a2,128
    800059d6:	f4040593          	addi	a1,s0,-192
    800059da:	4501                	li	a0,0
    800059dc:	ffffd097          	auipc	ra,0xffffd
    800059e0:	10a080e7          	jalr	266(ra) # 80002ae6 <argstr>
    return -1;
    800059e4:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800059e6:	0c054a63          	bltz	a0,80005aba <sys_exec+0xfa>
    800059ea:	e3840593          	addi	a1,s0,-456
    800059ee:	4505                	li	a0,1
    800059f0:	ffffd097          	auipc	ra,0xffffd
    800059f4:	0d4080e7          	jalr	212(ra) # 80002ac4 <argaddr>
    800059f8:	0c054163          	bltz	a0,80005aba <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    800059fc:	10000613          	li	a2,256
    80005a00:	4581                	li	a1,0
    80005a02:	e4040513          	addi	a0,s0,-448
    80005a06:	ffffb097          	auipc	ra,0xffffb
    80005a0a:	2b8080e7          	jalr	696(ra) # 80000cbe <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005a0e:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005a12:	89a6                	mv	s3,s1
    80005a14:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005a16:	02000a13          	li	s4,32
    80005a1a:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005a1e:	00391793          	slli	a5,s2,0x3
    80005a22:	e3040593          	addi	a1,s0,-464
    80005a26:	e3843503          	ld	a0,-456(s0)
    80005a2a:	953e                	add	a0,a0,a5
    80005a2c:	ffffd097          	auipc	ra,0xffffd
    80005a30:	fdc080e7          	jalr	-36(ra) # 80002a08 <fetchaddr>
    80005a34:	02054a63          	bltz	a0,80005a68 <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    80005a38:	e3043783          	ld	a5,-464(s0)
    80005a3c:	c3b9                	beqz	a5,80005a82 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005a3e:	ffffb097          	auipc	ra,0xffffb
    80005a42:	094080e7          	jalr	148(ra) # 80000ad2 <kalloc>
    80005a46:	85aa                	mv	a1,a0
    80005a48:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005a4c:	cd11                	beqz	a0,80005a68 <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005a4e:	6605                	lui	a2,0x1
    80005a50:	e3043503          	ld	a0,-464(s0)
    80005a54:	ffffd097          	auipc	ra,0xffffd
    80005a58:	006080e7          	jalr	6(ra) # 80002a5a <fetchstr>
    80005a5c:	00054663          	bltz	a0,80005a68 <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005a60:	0905                	addi	s2,s2,1
    80005a62:	09a1                	addi	s3,s3,8
    80005a64:	fb491be3          	bne	s2,s4,80005a1a <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a68:	10048913          	addi	s2,s1,256
    80005a6c:	6088                	ld	a0,0(s1)
    80005a6e:	c529                	beqz	a0,80005ab8 <sys_exec+0xf8>
    kfree(argv[i]);
    80005a70:	ffffb097          	auipc	ra,0xffffb
    80005a74:	f66080e7          	jalr	-154(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005a78:	04a1                	addi	s1,s1,8
    80005a7a:	ff2499e3          	bne	s1,s2,80005a6c <sys_exec+0xac>
  return -1;
    80005a7e:	597d                	li	s2,-1
    80005a80:	a82d                	j	80005aba <sys_exec+0xfa>
      argv[i] = 0;
    80005a82:	0a8e                	slli	s5,s5,0x3
    80005a84:	fc040793          	addi	a5,s0,-64
    80005a88:	9abe                	add	s5,s5,a5
    80005a8a:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd8e80>
  int ret = exec(path, argv);
    80005a8e:	e4040593          	addi	a1,s0,-448
    80005a92:	f4040513          	addi	a0,s0,-192
    80005a96:	fffff097          	auipc	ra,0xfffff
    80005a9a:	178080e7          	jalr	376(ra) # 80004c0e <exec>
    80005a9e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005aa0:	10048993          	addi	s3,s1,256
    80005aa4:	6088                	ld	a0,0(s1)
    80005aa6:	c911                	beqz	a0,80005aba <sys_exec+0xfa>
    kfree(argv[i]);
    80005aa8:	ffffb097          	auipc	ra,0xffffb
    80005aac:	f2e080e7          	jalr	-210(ra) # 800009d6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ab0:	04a1                	addi	s1,s1,8
    80005ab2:	ff3499e3          	bne	s1,s3,80005aa4 <sys_exec+0xe4>
    80005ab6:	a011                	j	80005aba <sys_exec+0xfa>
  return -1;
    80005ab8:	597d                	li	s2,-1
}
    80005aba:	854a                	mv	a0,s2
    80005abc:	60be                	ld	ra,456(sp)
    80005abe:	641e                	ld	s0,448(sp)
    80005ac0:	74fa                	ld	s1,440(sp)
    80005ac2:	795a                	ld	s2,432(sp)
    80005ac4:	79ba                	ld	s3,424(sp)
    80005ac6:	7a1a                	ld	s4,416(sp)
    80005ac8:	6afa                	ld	s5,408(sp)
    80005aca:	6179                	addi	sp,sp,464
    80005acc:	8082                	ret

0000000080005ace <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ace:	7139                	addi	sp,sp,-64
    80005ad0:	fc06                	sd	ra,56(sp)
    80005ad2:	f822                	sd	s0,48(sp)
    80005ad4:	f426                	sd	s1,40(sp)
    80005ad6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005ad8:	ffffc097          	auipc	ra,0xffffc
    80005adc:	ea6080e7          	jalr	-346(ra) # 8000197e <myproc>
    80005ae0:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005ae2:	fd840593          	addi	a1,s0,-40
    80005ae6:	4501                	li	a0,0
    80005ae8:	ffffd097          	auipc	ra,0xffffd
    80005aec:	fdc080e7          	jalr	-36(ra) # 80002ac4 <argaddr>
    return -1;
    80005af0:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005af2:	0e054063          	bltz	a0,80005bd2 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005af6:	fc840593          	addi	a1,s0,-56
    80005afa:	fd040513          	addi	a0,s0,-48
    80005afe:	fffff097          	auipc	ra,0xfffff
    80005b02:	dee080e7          	jalr	-530(ra) # 800048ec <pipealloc>
    return -1;
    80005b06:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005b08:	0c054563          	bltz	a0,80005bd2 <sys_pipe+0x104>
  fd0 = -1;
    80005b0c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005b10:	fd043503          	ld	a0,-48(s0)
    80005b14:	fffff097          	auipc	ra,0xfffff
    80005b18:	50a080e7          	jalr	1290(ra) # 8000501e <fdalloc>
    80005b1c:	fca42223          	sw	a0,-60(s0)
    80005b20:	08054c63          	bltz	a0,80005bb8 <sys_pipe+0xea>
    80005b24:	fc843503          	ld	a0,-56(s0)
    80005b28:	fffff097          	auipc	ra,0xfffff
    80005b2c:	4f6080e7          	jalr	1270(ra) # 8000501e <fdalloc>
    80005b30:	fca42023          	sw	a0,-64(s0)
    80005b34:	06054863          	bltz	a0,80005ba4 <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b38:	4691                	li	a3,4
    80005b3a:	fc440613          	addi	a2,s0,-60
    80005b3e:	fd843583          	ld	a1,-40(s0)
    80005b42:	68a8                	ld	a0,80(s1)
    80005b44:	ffffc097          	auipc	ra,0xffffc
    80005b48:	afa080e7          	jalr	-1286(ra) # 8000163e <copyout>
    80005b4c:	02054063          	bltz	a0,80005b6c <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005b50:	4691                	li	a3,4
    80005b52:	fc040613          	addi	a2,s0,-64
    80005b56:	fd843583          	ld	a1,-40(s0)
    80005b5a:	0591                	addi	a1,a1,4
    80005b5c:	68a8                	ld	a0,80(s1)
    80005b5e:	ffffc097          	auipc	ra,0xffffc
    80005b62:	ae0080e7          	jalr	-1312(ra) # 8000163e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005b66:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005b68:	06055563          	bgez	a0,80005bd2 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005b6c:	fc442783          	lw	a5,-60(s0)
    80005b70:	07e9                	addi	a5,a5,26
    80005b72:	078e                	slli	a5,a5,0x3
    80005b74:	97a6                	add	a5,a5,s1
    80005b76:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005b7a:	fc042503          	lw	a0,-64(s0)
    80005b7e:	0569                	addi	a0,a0,26
    80005b80:	050e                	slli	a0,a0,0x3
    80005b82:	9526                	add	a0,a0,s1
    80005b84:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005b88:	fd043503          	ld	a0,-48(s0)
    80005b8c:	fffff097          	auipc	ra,0xfffff
    80005b90:	a30080e7          	jalr	-1488(ra) # 800045bc <fileclose>
    fileclose(wf);
    80005b94:	fc843503          	ld	a0,-56(s0)
    80005b98:	fffff097          	auipc	ra,0xfffff
    80005b9c:	a24080e7          	jalr	-1500(ra) # 800045bc <fileclose>
    return -1;
    80005ba0:	57fd                	li	a5,-1
    80005ba2:	a805                	j	80005bd2 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005ba4:	fc442783          	lw	a5,-60(s0)
    80005ba8:	0007c863          	bltz	a5,80005bb8 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005bac:	01a78513          	addi	a0,a5,26
    80005bb0:	050e                	slli	a0,a0,0x3
    80005bb2:	9526                	add	a0,a0,s1
    80005bb4:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005bb8:	fd043503          	ld	a0,-48(s0)
    80005bbc:	fffff097          	auipc	ra,0xfffff
    80005bc0:	a00080e7          	jalr	-1536(ra) # 800045bc <fileclose>
    fileclose(wf);
    80005bc4:	fc843503          	ld	a0,-56(s0)
    80005bc8:	fffff097          	auipc	ra,0xfffff
    80005bcc:	9f4080e7          	jalr	-1548(ra) # 800045bc <fileclose>
    return -1;
    80005bd0:	57fd                	li	a5,-1
}
    80005bd2:	853e                	mv	a0,a5
    80005bd4:	70e2                	ld	ra,56(sp)
    80005bd6:	7442                	ld	s0,48(sp)
    80005bd8:	74a2                	ld	s1,40(sp)
    80005bda:	6121                	addi	sp,sp,64
    80005bdc:	8082                	ret
	...

0000000080005be0 <kernelvec>:
    80005be0:	7111                	addi	sp,sp,-256
    80005be2:	e006                	sd	ra,0(sp)
    80005be4:	e40a                	sd	sp,8(sp)
    80005be6:	e80e                	sd	gp,16(sp)
    80005be8:	ec12                	sd	tp,24(sp)
    80005bea:	f016                	sd	t0,32(sp)
    80005bec:	f41a                	sd	t1,40(sp)
    80005bee:	f81e                	sd	t2,48(sp)
    80005bf0:	fc22                	sd	s0,56(sp)
    80005bf2:	e0a6                	sd	s1,64(sp)
    80005bf4:	e4aa                	sd	a0,72(sp)
    80005bf6:	e8ae                	sd	a1,80(sp)
    80005bf8:	ecb2                	sd	a2,88(sp)
    80005bfa:	f0b6                	sd	a3,96(sp)
    80005bfc:	f4ba                	sd	a4,104(sp)
    80005bfe:	f8be                	sd	a5,112(sp)
    80005c00:	fcc2                	sd	a6,120(sp)
    80005c02:	e146                	sd	a7,128(sp)
    80005c04:	e54a                	sd	s2,136(sp)
    80005c06:	e94e                	sd	s3,144(sp)
    80005c08:	ed52                	sd	s4,152(sp)
    80005c0a:	f156                	sd	s5,160(sp)
    80005c0c:	f55a                	sd	s6,168(sp)
    80005c0e:	f95e                	sd	s7,176(sp)
    80005c10:	fd62                	sd	s8,184(sp)
    80005c12:	e1e6                	sd	s9,192(sp)
    80005c14:	e5ea                	sd	s10,200(sp)
    80005c16:	e9ee                	sd	s11,208(sp)
    80005c18:	edf2                	sd	t3,216(sp)
    80005c1a:	f1f6                	sd	t4,224(sp)
    80005c1c:	f5fa                	sd	t5,232(sp)
    80005c1e:	f9fe                	sd	t6,240(sp)
    80005c20:	cb5fc0ef          	jal	ra,800028d4 <kerneltrap>
    80005c24:	6082                	ld	ra,0(sp)
    80005c26:	6122                	ld	sp,8(sp)
    80005c28:	61c2                	ld	gp,16(sp)
    80005c2a:	7282                	ld	t0,32(sp)
    80005c2c:	7322                	ld	t1,40(sp)
    80005c2e:	73c2                	ld	t2,48(sp)
    80005c30:	7462                	ld	s0,56(sp)
    80005c32:	6486                	ld	s1,64(sp)
    80005c34:	6526                	ld	a0,72(sp)
    80005c36:	65c6                	ld	a1,80(sp)
    80005c38:	6666                	ld	a2,88(sp)
    80005c3a:	7686                	ld	a3,96(sp)
    80005c3c:	7726                	ld	a4,104(sp)
    80005c3e:	77c6                	ld	a5,112(sp)
    80005c40:	7866                	ld	a6,120(sp)
    80005c42:	688a                	ld	a7,128(sp)
    80005c44:	692a                	ld	s2,136(sp)
    80005c46:	69ca                	ld	s3,144(sp)
    80005c48:	6a6a                	ld	s4,152(sp)
    80005c4a:	7a8a                	ld	s5,160(sp)
    80005c4c:	7b2a                	ld	s6,168(sp)
    80005c4e:	7bca                	ld	s7,176(sp)
    80005c50:	7c6a                	ld	s8,184(sp)
    80005c52:	6c8e                	ld	s9,192(sp)
    80005c54:	6d2e                	ld	s10,200(sp)
    80005c56:	6dce                	ld	s11,208(sp)
    80005c58:	6e6e                	ld	t3,216(sp)
    80005c5a:	7e8e                	ld	t4,224(sp)
    80005c5c:	7f2e                	ld	t5,232(sp)
    80005c5e:	7fce                	ld	t6,240(sp)
    80005c60:	6111                	addi	sp,sp,256
    80005c62:	10200073          	sret
    80005c66:	00000013          	nop
    80005c6a:	00000013          	nop
    80005c6e:	0001                	nop

0000000080005c70 <timervec>:
    80005c70:	34051573          	csrrw	a0,mscratch,a0
    80005c74:	e10c                	sd	a1,0(a0)
    80005c76:	e510                	sd	a2,8(a0)
    80005c78:	e914                	sd	a3,16(a0)
    80005c7a:	6d0c                	ld	a1,24(a0)
    80005c7c:	7110                	ld	a2,32(a0)
    80005c7e:	6194                	ld	a3,0(a1)
    80005c80:	96b2                	add	a3,a3,a2
    80005c82:	e194                	sd	a3,0(a1)
    80005c84:	4589                	li	a1,2
    80005c86:	14459073          	csrw	sip,a1
    80005c8a:	6914                	ld	a3,16(a0)
    80005c8c:	6510                	ld	a2,8(a0)
    80005c8e:	610c                	ld	a1,0(a0)
    80005c90:	34051573          	csrrw	a0,mscratch,a0
    80005c94:	30200073          	mret
	...

0000000080005c9a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005c9a:	1141                	addi	sp,sp,-16
    80005c9c:	e422                	sd	s0,8(sp)
    80005c9e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005ca0:	0c0007b7          	lui	a5,0xc000
    80005ca4:	4705                	li	a4,1
    80005ca6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005ca8:	c3d8                	sw	a4,4(a5)
}
    80005caa:	6422                	ld	s0,8(sp)
    80005cac:	0141                	addi	sp,sp,16
    80005cae:	8082                	ret

0000000080005cb0 <plicinithart>:

void
plicinithart(void)
{
    80005cb0:	1141                	addi	sp,sp,-16
    80005cb2:	e406                	sd	ra,8(sp)
    80005cb4:	e022                	sd	s0,0(sp)
    80005cb6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cb8:	ffffc097          	auipc	ra,0xffffc
    80005cbc:	c9a080e7          	jalr	-870(ra) # 80001952 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005cc0:	0085171b          	slliw	a4,a0,0x8
    80005cc4:	0c0027b7          	lui	a5,0xc002
    80005cc8:	97ba                	add	a5,a5,a4
    80005cca:	40200713          	li	a4,1026
    80005cce:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005cd2:	00d5151b          	slliw	a0,a0,0xd
    80005cd6:	0c2017b7          	lui	a5,0xc201
    80005cda:	953e                	add	a0,a0,a5
    80005cdc:	00052023          	sw	zero,0(a0)
}
    80005ce0:	60a2                	ld	ra,8(sp)
    80005ce2:	6402                	ld	s0,0(sp)
    80005ce4:	0141                	addi	sp,sp,16
    80005ce6:	8082                	ret

0000000080005ce8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005ce8:	1141                	addi	sp,sp,-16
    80005cea:	e406                	sd	ra,8(sp)
    80005cec:	e022                	sd	s0,0(sp)
    80005cee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005cf0:	ffffc097          	auipc	ra,0xffffc
    80005cf4:	c62080e7          	jalr	-926(ra) # 80001952 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005cf8:	00d5179b          	slliw	a5,a0,0xd
    80005cfc:	0c201537          	lui	a0,0xc201
    80005d00:	953e                	add	a0,a0,a5
  return irq;
}
    80005d02:	4148                	lw	a0,4(a0)
    80005d04:	60a2                	ld	ra,8(sp)
    80005d06:	6402                	ld	s0,0(sp)
    80005d08:	0141                	addi	sp,sp,16
    80005d0a:	8082                	ret

0000000080005d0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005d0c:	1101                	addi	sp,sp,-32
    80005d0e:	ec06                	sd	ra,24(sp)
    80005d10:	e822                	sd	s0,16(sp)
    80005d12:	e426                	sd	s1,8(sp)
    80005d14:	1000                	addi	s0,sp,32
    80005d16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005d18:	ffffc097          	auipc	ra,0xffffc
    80005d1c:	c3a080e7          	jalr	-966(ra) # 80001952 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005d20:	00d5151b          	slliw	a0,a0,0xd
    80005d24:	0c2017b7          	lui	a5,0xc201
    80005d28:	97aa                	add	a5,a5,a0
    80005d2a:	c3c4                	sw	s1,4(a5)
}
    80005d2c:	60e2                	ld	ra,24(sp)
    80005d2e:	6442                	ld	s0,16(sp)
    80005d30:	64a2                	ld	s1,8(sp)
    80005d32:	6105                	addi	sp,sp,32
    80005d34:	8082                	ret

0000000080005d36 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005d36:	1141                	addi	sp,sp,-16
    80005d38:	e406                	sd	ra,8(sp)
    80005d3a:	e022                	sd	s0,0(sp)
    80005d3c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005d3e:	479d                	li	a5,7
    80005d40:	06a7c963          	blt	a5,a0,80005db2 <free_desc+0x7c>
    panic("free_desc 1");
  if(disk.free[i])
    80005d44:	0001d797          	auipc	a5,0x1d
    80005d48:	2bc78793          	addi	a5,a5,700 # 80023000 <disk>
    80005d4c:	00a78733          	add	a4,a5,a0
    80005d50:	6789                	lui	a5,0x2
    80005d52:	97ba                	add	a5,a5,a4
    80005d54:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005d58:	e7ad                	bnez	a5,80005dc2 <free_desc+0x8c>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005d5a:	00451793          	slli	a5,a0,0x4
    80005d5e:	0001f717          	auipc	a4,0x1f
    80005d62:	2a270713          	addi	a4,a4,674 # 80025000 <disk+0x2000>
    80005d66:	6314                	ld	a3,0(a4)
    80005d68:	96be                	add	a3,a3,a5
    80005d6a:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005d6e:	6314                	ld	a3,0(a4)
    80005d70:	96be                	add	a3,a3,a5
    80005d72:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005d76:	6314                	ld	a3,0(a4)
    80005d78:	96be                	add	a3,a3,a5
    80005d7a:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005d7e:	6318                	ld	a4,0(a4)
    80005d80:	97ba                	add	a5,a5,a4
    80005d82:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005d86:	0001d797          	auipc	a5,0x1d
    80005d8a:	27a78793          	addi	a5,a5,634 # 80023000 <disk>
    80005d8e:	97aa                	add	a5,a5,a0
    80005d90:	6509                	lui	a0,0x2
    80005d92:	953e                	add	a0,a0,a5
    80005d94:	4785                	li	a5,1
    80005d96:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005d9a:	0001f517          	auipc	a0,0x1f
    80005d9e:	27e50513          	addi	a0,a0,638 # 80025018 <disk+0x2018>
    80005da2:	ffffc097          	auipc	ra,0xffffc
    80005da6:	430080e7          	jalr	1072(ra) # 800021d2 <wakeup>
}
    80005daa:	60a2                	ld	ra,8(sp)
    80005dac:	6402                	ld	s0,0(sp)
    80005dae:	0141                	addi	sp,sp,16
    80005db0:	8082                	ret
    panic("free_desc 1");
    80005db2:	00003517          	auipc	a0,0x3
    80005db6:	b5650513          	addi	a0,a0,-1194 # 80008908 <syscalls_strings+0x320>
    80005dba:	ffffa097          	auipc	ra,0xffffa
    80005dbe:	770080e7          	jalr	1904(ra) # 8000052a <panic>
    panic("free_desc 2");
    80005dc2:	00003517          	auipc	a0,0x3
    80005dc6:	b5650513          	addi	a0,a0,-1194 # 80008918 <syscalls_strings+0x330>
    80005dca:	ffffa097          	auipc	ra,0xffffa
    80005dce:	760080e7          	jalr	1888(ra) # 8000052a <panic>

0000000080005dd2 <virtio_disk_init>:
{
    80005dd2:	1101                	addi	sp,sp,-32
    80005dd4:	ec06                	sd	ra,24(sp)
    80005dd6:	e822                	sd	s0,16(sp)
    80005dd8:	e426                	sd	s1,8(sp)
    80005dda:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005ddc:	00003597          	auipc	a1,0x3
    80005de0:	b4c58593          	addi	a1,a1,-1204 # 80008928 <syscalls_strings+0x340>
    80005de4:	0001f517          	auipc	a0,0x1f
    80005de8:	34450513          	addi	a0,a0,836 # 80025128 <disk+0x2128>
    80005dec:	ffffb097          	auipc	ra,0xffffb
    80005df0:	d46080e7          	jalr	-698(ra) # 80000b32 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005df4:	100017b7          	lui	a5,0x10001
    80005df8:	4398                	lw	a4,0(a5)
    80005dfa:	2701                	sext.w	a4,a4
    80005dfc:	747277b7          	lui	a5,0x74727
    80005e00:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005e04:	0ef71163          	bne	a4,a5,80005ee6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e08:	100017b7          	lui	a5,0x10001
    80005e0c:	43dc                	lw	a5,4(a5)
    80005e0e:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005e10:	4705                	li	a4,1
    80005e12:	0ce79a63          	bne	a5,a4,80005ee6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e16:	100017b7          	lui	a5,0x10001
    80005e1a:	479c                	lw	a5,8(a5)
    80005e1c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005e1e:	4709                	li	a4,2
    80005e20:	0ce79363          	bne	a5,a4,80005ee6 <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005e24:	100017b7          	lui	a5,0x10001
    80005e28:	47d8                	lw	a4,12(a5)
    80005e2a:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005e2c:	554d47b7          	lui	a5,0x554d4
    80005e30:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005e34:	0af71963          	bne	a4,a5,80005ee6 <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e38:	100017b7          	lui	a5,0x10001
    80005e3c:	4705                	li	a4,1
    80005e3e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e40:	470d                	li	a4,3
    80005e42:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005e44:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005e46:	c7ffe737          	lui	a4,0xc7ffe
    80005e4a:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005e4e:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005e50:	2701                	sext.w	a4,a4
    80005e52:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e54:	472d                	li	a4,11
    80005e56:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005e58:	473d                	li	a4,15
    80005e5a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005e5c:	6705                	lui	a4,0x1
    80005e5e:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005e60:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005e64:	5bdc                	lw	a5,52(a5)
    80005e66:	2781                	sext.w	a5,a5
  if(max == 0)
    80005e68:	c7d9                	beqz	a5,80005ef6 <virtio_disk_init+0x124>
  if(max < NUM)
    80005e6a:	471d                	li	a4,7
    80005e6c:	08f77d63          	bgeu	a4,a5,80005f06 <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005e70:	100014b7          	lui	s1,0x10001
    80005e74:	47a1                	li	a5,8
    80005e76:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005e78:	6609                	lui	a2,0x2
    80005e7a:	4581                	li	a1,0
    80005e7c:	0001d517          	auipc	a0,0x1d
    80005e80:	18450513          	addi	a0,a0,388 # 80023000 <disk>
    80005e84:	ffffb097          	auipc	ra,0xffffb
    80005e88:	e3a080e7          	jalr	-454(ra) # 80000cbe <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005e8c:	0001d717          	auipc	a4,0x1d
    80005e90:	17470713          	addi	a4,a4,372 # 80023000 <disk>
    80005e94:	00c75793          	srli	a5,a4,0xc
    80005e98:	2781                	sext.w	a5,a5
    80005e9a:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct virtq_desc *) disk.pages;
    80005e9c:	0001f797          	auipc	a5,0x1f
    80005ea0:	16478793          	addi	a5,a5,356 # 80025000 <disk+0x2000>
    80005ea4:	e398                	sd	a4,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    80005ea6:	0001d717          	auipc	a4,0x1d
    80005eaa:	1da70713          	addi	a4,a4,474 # 80023080 <disk+0x80>
    80005eae:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    80005eb0:	0001e717          	auipc	a4,0x1e
    80005eb4:	15070713          	addi	a4,a4,336 # 80024000 <disk+0x1000>
    80005eb8:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005eba:	4705                	li	a4,1
    80005ebc:	00e78c23          	sb	a4,24(a5)
    80005ec0:	00e78ca3          	sb	a4,25(a5)
    80005ec4:	00e78d23          	sb	a4,26(a5)
    80005ec8:	00e78da3          	sb	a4,27(a5)
    80005ecc:	00e78e23          	sb	a4,28(a5)
    80005ed0:	00e78ea3          	sb	a4,29(a5)
    80005ed4:	00e78f23          	sb	a4,30(a5)
    80005ed8:	00e78fa3          	sb	a4,31(a5)
}
    80005edc:	60e2                	ld	ra,24(sp)
    80005ede:	6442                	ld	s0,16(sp)
    80005ee0:	64a2                	ld	s1,8(sp)
    80005ee2:	6105                	addi	sp,sp,32
    80005ee4:	8082                	ret
    panic("could not find virtio disk");
    80005ee6:	00003517          	auipc	a0,0x3
    80005eea:	a5250513          	addi	a0,a0,-1454 # 80008938 <syscalls_strings+0x350>
    80005eee:	ffffa097          	auipc	ra,0xffffa
    80005ef2:	63c080e7          	jalr	1596(ra) # 8000052a <panic>
    panic("virtio disk has no queue 0");
    80005ef6:	00003517          	auipc	a0,0x3
    80005efa:	a6250513          	addi	a0,a0,-1438 # 80008958 <syscalls_strings+0x370>
    80005efe:	ffffa097          	auipc	ra,0xffffa
    80005f02:	62c080e7          	jalr	1580(ra) # 8000052a <panic>
    panic("virtio disk max queue too short");
    80005f06:	00003517          	auipc	a0,0x3
    80005f0a:	a7250513          	addi	a0,a0,-1422 # 80008978 <syscalls_strings+0x390>
    80005f0e:	ffffa097          	auipc	ra,0xffffa
    80005f12:	61c080e7          	jalr	1564(ra) # 8000052a <panic>

0000000080005f16 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005f16:	7119                	addi	sp,sp,-128
    80005f18:	fc86                	sd	ra,120(sp)
    80005f1a:	f8a2                	sd	s0,112(sp)
    80005f1c:	f4a6                	sd	s1,104(sp)
    80005f1e:	f0ca                	sd	s2,96(sp)
    80005f20:	ecce                	sd	s3,88(sp)
    80005f22:	e8d2                	sd	s4,80(sp)
    80005f24:	e4d6                	sd	s5,72(sp)
    80005f26:	e0da                	sd	s6,64(sp)
    80005f28:	fc5e                	sd	s7,56(sp)
    80005f2a:	f862                	sd	s8,48(sp)
    80005f2c:	f466                	sd	s9,40(sp)
    80005f2e:	f06a                	sd	s10,32(sp)
    80005f30:	ec6e                	sd	s11,24(sp)
    80005f32:	0100                	addi	s0,sp,128
    80005f34:	8aaa                	mv	s5,a0
    80005f36:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005f38:	00c52c83          	lw	s9,12(a0)
    80005f3c:	001c9c9b          	slliw	s9,s9,0x1
    80005f40:	1c82                	slli	s9,s9,0x20
    80005f42:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005f46:	0001f517          	auipc	a0,0x1f
    80005f4a:	1e250513          	addi	a0,a0,482 # 80025128 <disk+0x2128>
    80005f4e:	ffffb097          	auipc	ra,0xffffb
    80005f52:	c74080e7          	jalr	-908(ra) # 80000bc2 <acquire>
  for(int i = 0; i < 3; i++){
    80005f56:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005f58:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005f5a:	0001dc17          	auipc	s8,0x1d
    80005f5e:	0a6c0c13          	addi	s8,s8,166 # 80023000 <disk>
    80005f62:	6b89                	lui	s7,0x2
  for(int i = 0; i < 3; i++){
    80005f64:	4b0d                	li	s6,3
    80005f66:	a0ad                	j	80005fd0 <virtio_disk_rw+0xba>
      disk.free[i] = 0;
    80005f68:	00fc0733          	add	a4,s8,a5
    80005f6c:	975e                	add	a4,a4,s7
    80005f6e:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005f72:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005f74:	0207c563          	bltz	a5,80005f9e <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005f78:	2905                	addiw	s2,s2,1
    80005f7a:	0611                	addi	a2,a2,4
    80005f7c:	19690d63          	beq	s2,s6,80006116 <virtio_disk_rw+0x200>
    idx[i] = alloc_desc();
    80005f80:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005f82:	0001f717          	auipc	a4,0x1f
    80005f86:	09670713          	addi	a4,a4,150 # 80025018 <disk+0x2018>
    80005f8a:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005f8c:	00074683          	lbu	a3,0(a4)
    80005f90:	fee1                	bnez	a3,80005f68 <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005f92:	2785                	addiw	a5,a5,1
    80005f94:	0705                	addi	a4,a4,1
    80005f96:	fe979be3          	bne	a5,s1,80005f8c <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005f9a:	57fd                	li	a5,-1
    80005f9c:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005f9e:	01205d63          	blez	s2,80005fb8 <virtio_disk_rw+0xa2>
    80005fa2:	8dce                	mv	s11,s3
        free_desc(idx[j]);
    80005fa4:	000a2503          	lw	a0,0(s4)
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	d8e080e7          	jalr	-626(ra) # 80005d36 <free_desc>
      for(int j = 0; j < i; j++)
    80005fb0:	2d85                	addiw	s11,s11,1
    80005fb2:	0a11                	addi	s4,s4,4
    80005fb4:	ffb918e3          	bne	s2,s11,80005fa4 <virtio_disk_rw+0x8e>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005fb8:	0001f597          	auipc	a1,0x1f
    80005fbc:	17058593          	addi	a1,a1,368 # 80025128 <disk+0x2128>
    80005fc0:	0001f517          	auipc	a0,0x1f
    80005fc4:	05850513          	addi	a0,a0,88 # 80025018 <disk+0x2018>
    80005fc8:	ffffc097          	auipc	ra,0xffffc
    80005fcc:	07e080e7          	jalr	126(ra) # 80002046 <sleep>
  for(int i = 0; i < 3; i++){
    80005fd0:	f8040a13          	addi	s4,s0,-128
{
    80005fd4:	8652                	mv	a2,s4
  for(int i = 0; i < 3; i++){
    80005fd6:	894e                	mv	s2,s3
    80005fd8:	b765                	j	80005f80 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005fda:	0001f697          	auipc	a3,0x1f
    80005fde:	0266b683          	ld	a3,38(a3) # 80025000 <disk+0x2000>
    80005fe2:	96ba                	add	a3,a3,a4
    80005fe4:	00069623          	sh	zero,12(a3)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005fe8:	0001d817          	auipc	a6,0x1d
    80005fec:	01880813          	addi	a6,a6,24 # 80023000 <disk>
    80005ff0:	0001f697          	auipc	a3,0x1f
    80005ff4:	01068693          	addi	a3,a3,16 # 80025000 <disk+0x2000>
    80005ff8:	6290                	ld	a2,0(a3)
    80005ffa:	963a                	add	a2,a2,a4
    80005ffc:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80006000:	0015e593          	ori	a1,a1,1
    80006004:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80006008:	f8842603          	lw	a2,-120(s0)
    8000600c:	628c                	ld	a1,0(a3)
    8000600e:	972e                	add	a4,a4,a1
    80006010:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006014:	20050593          	addi	a1,a0,512
    80006018:	0592                	slli	a1,a1,0x4
    8000601a:	95c2                	add	a1,a1,a6
    8000601c:	577d                	li	a4,-1
    8000601e:	02e58823          	sb	a4,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006022:	00461713          	slli	a4,a2,0x4
    80006026:	6290                	ld	a2,0(a3)
    80006028:	963a                	add	a2,a2,a4
    8000602a:	03078793          	addi	a5,a5,48
    8000602e:	97c2                	add	a5,a5,a6
    80006030:	e21c                	sd	a5,0(a2)
  disk.desc[idx[2]].len = 1;
    80006032:	629c                	ld	a5,0(a3)
    80006034:	97ba                	add	a5,a5,a4
    80006036:	4605                	li	a2,1
    80006038:	c790                	sw	a2,8(a5)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000603a:	629c                	ld	a5,0(a3)
    8000603c:	97ba                	add	a5,a5,a4
    8000603e:	4809                	li	a6,2
    80006040:	01079623          	sh	a6,12(a5)
  disk.desc[idx[2]].next = 0;
    80006044:	629c                	ld	a5,0(a3)
    80006046:	973e                	add	a4,a4,a5
    80006048:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000604c:	00caa223          	sw	a2,4(s5)
  disk.info[idx[0]].b = b;
    80006050:	0355b423          	sd	s5,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006054:	6698                	ld	a4,8(a3)
    80006056:	00275783          	lhu	a5,2(a4)
    8000605a:	8b9d                	andi	a5,a5,7
    8000605c:	0786                	slli	a5,a5,0x1
    8000605e:	97ba                	add	a5,a5,a4
    80006060:	00a79223          	sh	a0,4(a5)

  __sync_synchronize();
    80006064:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006068:	6698                	ld	a4,8(a3)
    8000606a:	00275783          	lhu	a5,2(a4)
    8000606e:	2785                	addiw	a5,a5,1
    80006070:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006074:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006078:	100017b7          	lui	a5,0x10001
    8000607c:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006080:	004aa783          	lw	a5,4(s5)
    80006084:	02c79163          	bne	a5,a2,800060a6 <virtio_disk_rw+0x190>
    sleep(b, &disk.vdisk_lock);
    80006088:	0001f917          	auipc	s2,0x1f
    8000608c:	0a090913          	addi	s2,s2,160 # 80025128 <disk+0x2128>
  while(b->disk == 1) {
    80006090:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80006092:	85ca                	mv	a1,s2
    80006094:	8556                	mv	a0,s5
    80006096:	ffffc097          	auipc	ra,0xffffc
    8000609a:	fb0080e7          	jalr	-80(ra) # 80002046 <sleep>
  while(b->disk == 1) {
    8000609e:	004aa783          	lw	a5,4(s5)
    800060a2:	fe9788e3          	beq	a5,s1,80006092 <virtio_disk_rw+0x17c>
  }

  disk.info[idx[0]].b = 0;
    800060a6:	f8042903          	lw	s2,-128(s0)
    800060aa:	20090793          	addi	a5,s2,512
    800060ae:	00479713          	slli	a4,a5,0x4
    800060b2:	0001d797          	auipc	a5,0x1d
    800060b6:	f4e78793          	addi	a5,a5,-178 # 80023000 <disk>
    800060ba:	97ba                	add	a5,a5,a4
    800060bc:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800060c0:	0001f997          	auipc	s3,0x1f
    800060c4:	f4098993          	addi	s3,s3,-192 # 80025000 <disk+0x2000>
    800060c8:	00491713          	slli	a4,s2,0x4
    800060cc:	0009b783          	ld	a5,0(s3)
    800060d0:	97ba                	add	a5,a5,a4
    800060d2:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800060d6:	854a                	mv	a0,s2
    800060d8:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	c5a080e7          	jalr	-934(ra) # 80005d36 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800060e4:	8885                	andi	s1,s1,1
    800060e6:	f0ed                	bnez	s1,800060c8 <virtio_disk_rw+0x1b2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800060e8:	0001f517          	auipc	a0,0x1f
    800060ec:	04050513          	addi	a0,a0,64 # 80025128 <disk+0x2128>
    800060f0:	ffffb097          	auipc	ra,0xffffb
    800060f4:	b86080e7          	jalr	-1146(ra) # 80000c76 <release>
}
    800060f8:	70e6                	ld	ra,120(sp)
    800060fa:	7446                	ld	s0,112(sp)
    800060fc:	74a6                	ld	s1,104(sp)
    800060fe:	7906                	ld	s2,96(sp)
    80006100:	69e6                	ld	s3,88(sp)
    80006102:	6a46                	ld	s4,80(sp)
    80006104:	6aa6                	ld	s5,72(sp)
    80006106:	6b06                	ld	s6,64(sp)
    80006108:	7be2                	ld	s7,56(sp)
    8000610a:	7c42                	ld	s8,48(sp)
    8000610c:	7ca2                	ld	s9,40(sp)
    8000610e:	7d02                	ld	s10,32(sp)
    80006110:	6de2                	ld	s11,24(sp)
    80006112:	6109                	addi	sp,sp,128
    80006114:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006116:	f8042503          	lw	a0,-128(s0)
    8000611a:	20050793          	addi	a5,a0,512
    8000611e:	0792                	slli	a5,a5,0x4
  if(write)
    80006120:	0001d817          	auipc	a6,0x1d
    80006124:	ee080813          	addi	a6,a6,-288 # 80023000 <disk>
    80006128:	00f80733          	add	a4,a6,a5
    8000612c:	01a036b3          	snez	a3,s10
    80006130:	0ad72423          	sw	a3,168(a4)
  buf0->reserved = 0;
    80006134:	0a072623          	sw	zero,172(a4)
  buf0->sector = sector;
    80006138:	0b973823          	sd	s9,176(a4)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000613c:	7679                	lui	a2,0xffffe
    8000613e:	963e                	add	a2,a2,a5
    80006140:	0001f697          	auipc	a3,0x1f
    80006144:	ec068693          	addi	a3,a3,-320 # 80025000 <disk+0x2000>
    80006148:	6298                	ld	a4,0(a3)
    8000614a:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000614c:	0a878593          	addi	a1,a5,168
    80006150:	95c2                	add	a1,a1,a6
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006152:	e30c                	sd	a1,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006154:	6298                	ld	a4,0(a3)
    80006156:	9732                	add	a4,a4,a2
    80006158:	45c1                	li	a1,16
    8000615a:	c70c                	sw	a1,8(a4)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000615c:	6298                	ld	a4,0(a3)
    8000615e:	9732                	add	a4,a4,a2
    80006160:	4585                	li	a1,1
    80006162:	00b71623          	sh	a1,12(a4)
  disk.desc[idx[0]].next = idx[1];
    80006166:	f8442703          	lw	a4,-124(s0)
    8000616a:	628c                	ld	a1,0(a3)
    8000616c:	962e                	add	a2,a2,a1
    8000616e:	00e61723          	sh	a4,14(a2) # ffffffffffffe00e <end+0xffffffff7ffd800e>
  disk.desc[idx[1]].addr = (uint64) b->data;
    80006172:	0712                	slli	a4,a4,0x4
    80006174:	6290                	ld	a2,0(a3)
    80006176:	963a                	add	a2,a2,a4
    80006178:	058a8593          	addi	a1,s5,88
    8000617c:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000617e:	6294                	ld	a3,0(a3)
    80006180:	96ba                	add	a3,a3,a4
    80006182:	40000613          	li	a2,1024
    80006186:	c690                	sw	a2,8(a3)
  if(write)
    80006188:	e40d19e3          	bnez	s10,80005fda <virtio_disk_rw+0xc4>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000618c:	0001f697          	auipc	a3,0x1f
    80006190:	e746b683          	ld	a3,-396(a3) # 80025000 <disk+0x2000>
    80006194:	96ba                	add	a3,a3,a4
    80006196:	4609                	li	a2,2
    80006198:	00c69623          	sh	a2,12(a3)
    8000619c:	b5b1                	j	80005fe8 <virtio_disk_rw+0xd2>

000000008000619e <virtio_disk_intr>:

void
virtio_disk_intr()
{
    8000619e:	1101                	addi	sp,sp,-32
    800061a0:	ec06                	sd	ra,24(sp)
    800061a2:	e822                	sd	s0,16(sp)
    800061a4:	e426                	sd	s1,8(sp)
    800061a6:	e04a                	sd	s2,0(sp)
    800061a8:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800061aa:	0001f517          	auipc	a0,0x1f
    800061ae:	f7e50513          	addi	a0,a0,-130 # 80025128 <disk+0x2128>
    800061b2:	ffffb097          	auipc	ra,0xffffb
    800061b6:	a10080e7          	jalr	-1520(ra) # 80000bc2 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800061ba:	10001737          	lui	a4,0x10001
    800061be:	533c                	lw	a5,96(a4)
    800061c0:	8b8d                	andi	a5,a5,3
    800061c2:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800061c4:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800061c8:	0001f797          	auipc	a5,0x1f
    800061cc:	e3878793          	addi	a5,a5,-456 # 80025000 <disk+0x2000>
    800061d0:	6b94                	ld	a3,16(a5)
    800061d2:	0207d703          	lhu	a4,32(a5)
    800061d6:	0026d783          	lhu	a5,2(a3)
    800061da:	06f70163          	beq	a4,a5,8000623c <virtio_disk_intr+0x9e>
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800061de:	0001d917          	auipc	s2,0x1d
    800061e2:	e2290913          	addi	s2,s2,-478 # 80023000 <disk>
    800061e6:	0001f497          	auipc	s1,0x1f
    800061ea:	e1a48493          	addi	s1,s1,-486 # 80025000 <disk+0x2000>
    __sync_synchronize();
    800061ee:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800061f2:	6898                	ld	a4,16(s1)
    800061f4:	0204d783          	lhu	a5,32(s1)
    800061f8:	8b9d                	andi	a5,a5,7
    800061fa:	078e                	slli	a5,a5,0x3
    800061fc:	97ba                	add	a5,a5,a4
    800061fe:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006200:	20078713          	addi	a4,a5,512
    80006204:	0712                	slli	a4,a4,0x4
    80006206:	974a                	add	a4,a4,s2
    80006208:	03074703          	lbu	a4,48(a4) # 10001030 <_entry-0x6fffefd0>
    8000620c:	e731                	bnez	a4,80006258 <virtio_disk_intr+0xba>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000620e:	20078793          	addi	a5,a5,512
    80006212:	0792                	slli	a5,a5,0x4
    80006214:	97ca                	add	a5,a5,s2
    80006216:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    80006218:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000621c:	ffffc097          	auipc	ra,0xffffc
    80006220:	fb6080e7          	jalr	-74(ra) # 800021d2 <wakeup>

    disk.used_idx += 1;
    80006224:	0204d783          	lhu	a5,32(s1)
    80006228:	2785                	addiw	a5,a5,1
    8000622a:	17c2                	slli	a5,a5,0x30
    8000622c:	93c1                	srli	a5,a5,0x30
    8000622e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006232:	6898                	ld	a4,16(s1)
    80006234:	00275703          	lhu	a4,2(a4)
    80006238:	faf71be3          	bne	a4,a5,800061ee <virtio_disk_intr+0x50>
  }

  release(&disk.vdisk_lock);
    8000623c:	0001f517          	auipc	a0,0x1f
    80006240:	eec50513          	addi	a0,a0,-276 # 80025128 <disk+0x2128>
    80006244:	ffffb097          	auipc	ra,0xffffb
    80006248:	a32080e7          	jalr	-1486(ra) # 80000c76 <release>
}
    8000624c:	60e2                	ld	ra,24(sp)
    8000624e:	6442                	ld	s0,16(sp)
    80006250:	64a2                	ld	s1,8(sp)
    80006252:	6902                	ld	s2,0(sp)
    80006254:	6105                	addi	sp,sp,32
    80006256:	8082                	ret
      panic("virtio_disk_intr status");
    80006258:	00002517          	auipc	a0,0x2
    8000625c:	74050513          	addi	a0,a0,1856 # 80008998 <syscalls_strings+0x3b0>
    80006260:	ffffa097          	auipc	ra,0xffffa
    80006264:	2ca080e7          	jalr	714(ra) # 8000052a <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
