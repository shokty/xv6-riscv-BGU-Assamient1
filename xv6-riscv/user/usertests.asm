
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	794080e7          	jalr	1940(ra) # 57a4 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	782080e7          	jalr	1922(ra) # 57a4 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	f8a50513          	addi	a0,a0,-118 # 5fc8 <malloc+0x426>
      46:	00006097          	auipc	ra,0x6
      4a:	a9e080e7          	jalr	-1378(ra) # 5ae4 <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	714080e7          	jalr	1812(ra) # 5764 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	52078793          	addi	a5,a5,1312 # 9578 <uninit>
      60:	0000c697          	auipc	a3,0xc
      64:	c2868693          	addi	a3,a3,-984 # bc88 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	f6850513          	addi	a0,a0,-152 # 5fe8 <malloc+0x446>
      88:	00006097          	auipc	ra,0x6
      8c:	a5c080e7          	jalr	-1444(ra) # 5ae4 <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	6d2080e7          	jalr	1746(ra) # 5764 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	f5850513          	addi	a0,a0,-168 # 6000 <malloc+0x45e>
      b0:	00005097          	auipc	ra,0x5
      b4:	6f4080e7          	jalr	1780(ra) # 57a4 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	6d0080e7          	jalr	1744(ra) # 578c <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	f5a50513          	addi	a0,a0,-166 # 6020 <malloc+0x47e>
      ce:	00005097          	auipc	ra,0x5
      d2:	6d6080e7          	jalr	1750(ra) # 57a4 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	f2250513          	addi	a0,a0,-222 # 6008 <malloc+0x466>
      ee:	00006097          	auipc	ra,0x6
      f2:	9f6080e7          	jalr	-1546(ra) # 5ae4 <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	66c080e7          	jalr	1644(ra) # 5764 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	f2e50513          	addi	a0,a0,-210 # 6030 <malloc+0x48e>
     10a:	00006097          	auipc	ra,0x6
     10e:	9da080e7          	jalr	-1574(ra) # 5ae4 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	650080e7          	jalr	1616(ra) # 5764 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	f2c50513          	addi	a0,a0,-212 # 6058 <malloc+0x4b6>
     134:	00005097          	auipc	ra,0x5
     138:	680080e7          	jalr	1664(ra) # 57b4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	f1850513          	addi	a0,a0,-232 # 6058 <malloc+0x4b6>
     148:	00005097          	auipc	ra,0x5
     14c:	65c080e7          	jalr	1628(ra) # 57a4 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	f1458593          	addi	a1,a1,-236 # 6068 <malloc+0x4c6>
     15c:	00005097          	auipc	ra,0x5
     160:	628080e7          	jalr	1576(ra) # 5784 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ef050513          	addi	a0,a0,-272 # 6058 <malloc+0x4b6>
     170:	00005097          	auipc	ra,0x5
     174:	634080e7          	jalr	1588(ra) # 57a4 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	ef458593          	addi	a1,a1,-268 # 6070 <malloc+0x4ce>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	5fe080e7          	jalr	1534(ra) # 5784 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	ec450513          	addi	a0,a0,-316 # 6058 <malloc+0x4b6>
     19c:	00005097          	auipc	ra,0x5
     1a0:	618080e7          	jalr	1560(ra) # 57b4 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	5e6080e7          	jalr	1510(ra) # 578c <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	5dc080e7          	jalr	1500(ra) # 578c <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	eae50513          	addi	a0,a0,-338 # 6078 <malloc+0x4d6>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	912080e7          	jalr	-1774(ra) # 5ae4 <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	588080e7          	jalr	1416(ra) # 5764 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00005097          	auipc	ra,0x5
     214:	594080e7          	jalr	1428(ra) # 57a4 <open>
    close(fd);
     218:	00005097          	auipc	ra,0x5
     21c:	574080e7          	jalr	1396(ra) # 578c <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00005097          	auipc	ra,0x5
     24a:	56e080e7          	jalr	1390(ra) # 57b4 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	bdc50513          	addi	a0,a0,-1060 # 5e58 <malloc+0x2b6>
     284:	00005097          	auipc	ra,0x5
     288:	530080e7          	jalr	1328(ra) # 57b4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	bc8a8a93          	addi	s5,s5,-1080 # 5e58 <malloc+0x2b6>
      int cc = write(fd, buf, sz);
     298:	0000ca17          	auipc	s4,0xc
     29c:	9f0a0a13          	addi	s4,s4,-1552 # bc88 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x173>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00005097          	auipc	ra,0x5
     2b0:	4f8080e7          	jalr	1272(ra) # 57a4 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00005097          	auipc	ra,0x5
     2c2:	4c6080e7          	jalr	1222(ra) # 5784 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00005097          	auipc	ra,0x5
     2d6:	4b2080e7          	jalr	1202(ra) # 5784 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00005097          	auipc	ra,0x5
     2e4:	4ac080e7          	jalr	1196(ra) # 578c <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00005097          	auipc	ra,0x5
     2ee:	4ca080e7          	jalr	1226(ra) # 57b4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	d8e50513          	addi	a0,a0,-626 # 60a0 <malloc+0x4fe>
     31a:	00005097          	auipc	ra,0x5
     31e:	7ca080e7          	jalr	1994(ra) # 5ae4 <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00005097          	auipc	ra,0x5
     328:	440080e7          	jalr	1088(ra) # 5764 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	d8a50513          	addi	a0,a0,-630 # 60c0 <malloc+0x51e>
     33e:	00005097          	auipc	ra,0x5
     342:	7a6080e7          	jalr	1958(ra) # 5ae4 <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00005097          	auipc	ra,0x5
     34c:	41c080e7          	jalr	1052(ra) # 5764 <exit>

0000000000000350 <copyin>:
{
     350:	715d                	addi	sp,sp,-80
     352:	e486                	sd	ra,72(sp)
     354:	e0a2                	sd	s0,64(sp)
     356:	fc26                	sd	s1,56(sp)
     358:	f84a                	sd	s2,48(sp)
     35a:	f44e                	sd	s3,40(sp)
     35c:	f052                	sd	s4,32(sp)
     35e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     360:	4785                	li	a5,1
     362:	07fe                	slli	a5,a5,0x1f
     364:	fcf43023          	sd	a5,-64(s0)
     368:	57fd                	li	a5,-1
     36a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     36e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     372:	00006a17          	auipc	s4,0x6
     376:	d66a0a13          	addi	s4,s4,-666 # 60d8 <malloc+0x536>
    uint64 addr = addrs[ai];
     37a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     37e:	20100593          	li	a1,513
     382:	8552                	mv	a0,s4
     384:	00005097          	auipc	ra,0x5
     388:	420080e7          	jalr	1056(ra) # 57a4 <open>
     38c:	84aa                	mv	s1,a0
    if(fd < 0){
     38e:	08054863          	bltz	a0,41e <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     392:	6609                	lui	a2,0x2
     394:	85ce                	mv	a1,s3
     396:	00005097          	auipc	ra,0x5
     39a:	3ee080e7          	jalr	1006(ra) # 5784 <write>
    if(n >= 0){
     39e:	08055d63          	bgez	a0,438 <copyin+0xe8>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00005097          	auipc	ra,0x5
     3a8:	3e8080e7          	jalr	1000(ra) # 578c <close>
    unlink("copyin1");
     3ac:	8552                	mv	a0,s4
     3ae:	00005097          	auipc	ra,0x5
     3b2:	406080e7          	jalr	1030(ra) # 57b4 <unlink>
    n = write(1, (char*)addr, 8192);
     3b6:	6609                	lui	a2,0x2
     3b8:	85ce                	mv	a1,s3
     3ba:	4505                	li	a0,1
     3bc:	00005097          	auipc	ra,0x5
     3c0:	3c8080e7          	jalr	968(ra) # 5784 <write>
    if(n > 0){
     3c4:	08a04963          	bgtz	a0,456 <copyin+0x106>
    if(pipe(fds) < 0){
     3c8:	fb840513          	addi	a0,s0,-72
     3cc:	00005097          	auipc	ra,0x5
     3d0:	3a8080e7          	jalr	936(ra) # 5774 <pipe>
     3d4:	0a054063          	bltz	a0,474 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3d8:	6609                	lui	a2,0x2
     3da:	85ce                	mv	a1,s3
     3dc:	fbc42503          	lw	a0,-68(s0)
     3e0:	00005097          	auipc	ra,0x5
     3e4:	3a4080e7          	jalr	932(ra) # 5784 <write>
    if(n > 0){
     3e8:	0aa04363          	bgtz	a0,48e <copyin+0x13e>
    close(fds[0]);
     3ec:	fb842503          	lw	a0,-72(s0)
     3f0:	00005097          	auipc	ra,0x5
     3f4:	39c080e7          	jalr	924(ra) # 578c <close>
    close(fds[1]);
     3f8:	fbc42503          	lw	a0,-68(s0)
     3fc:	00005097          	auipc	ra,0x5
     400:	390080e7          	jalr	912(ra) # 578c <close>
  for(int ai = 0; ai < 2; ai++){
     404:	0921                	addi	s2,s2,8
     406:	fd040793          	addi	a5,s0,-48
     40a:	f6f918e3          	bne	s2,a5,37a <copyin+0x2a>
}
     40e:	60a6                	ld	ra,72(sp)
     410:	6406                	ld	s0,64(sp)
     412:	74e2                	ld	s1,56(sp)
     414:	7942                	ld	s2,48(sp)
     416:	79a2                	ld	s3,40(sp)
     418:	7a02                	ld	s4,32(sp)
     41a:	6161                	addi	sp,sp,80
     41c:	8082                	ret
      printf("open(copyin1) failed\n");
     41e:	00006517          	auipc	a0,0x6
     422:	cc250513          	addi	a0,a0,-830 # 60e0 <malloc+0x53e>
     426:	00005097          	auipc	ra,0x5
     42a:	6be080e7          	jalr	1726(ra) # 5ae4 <printf>
      exit(1);
     42e:	4505                	li	a0,1
     430:	00005097          	auipc	ra,0x5
     434:	334080e7          	jalr	820(ra) # 5764 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     438:	862a                	mv	a2,a0
     43a:	85ce                	mv	a1,s3
     43c:	00006517          	auipc	a0,0x6
     440:	cbc50513          	addi	a0,a0,-836 # 60f8 <malloc+0x556>
     444:	00005097          	auipc	ra,0x5
     448:	6a0080e7          	jalr	1696(ra) # 5ae4 <printf>
      exit(1);
     44c:	4505                	li	a0,1
     44e:	00005097          	auipc	ra,0x5
     452:	316080e7          	jalr	790(ra) # 5764 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     456:	862a                	mv	a2,a0
     458:	85ce                	mv	a1,s3
     45a:	00006517          	auipc	a0,0x6
     45e:	cce50513          	addi	a0,a0,-818 # 6128 <malloc+0x586>
     462:	00005097          	auipc	ra,0x5
     466:	682080e7          	jalr	1666(ra) # 5ae4 <printf>
      exit(1);
     46a:	4505                	li	a0,1
     46c:	00005097          	auipc	ra,0x5
     470:	2f8080e7          	jalr	760(ra) # 5764 <exit>
      printf("pipe() failed\n");
     474:	00006517          	auipc	a0,0x6
     478:	ce450513          	addi	a0,a0,-796 # 6158 <malloc+0x5b6>
     47c:	00005097          	auipc	ra,0x5
     480:	668080e7          	jalr	1640(ra) # 5ae4 <printf>
      exit(1);
     484:	4505                	li	a0,1
     486:	00005097          	auipc	ra,0x5
     48a:	2de080e7          	jalr	734(ra) # 5764 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     48e:	862a                	mv	a2,a0
     490:	85ce                	mv	a1,s3
     492:	00006517          	auipc	a0,0x6
     496:	cd650513          	addi	a0,a0,-810 # 6168 <malloc+0x5c6>
     49a:	00005097          	auipc	ra,0x5
     49e:	64a080e7          	jalr	1610(ra) # 5ae4 <printf>
      exit(1);
     4a2:	4505                	li	a0,1
     4a4:	00005097          	auipc	ra,0x5
     4a8:	2c0080e7          	jalr	704(ra) # 5764 <exit>

00000000000004ac <copyout>:
{
     4ac:	711d                	addi	sp,sp,-96
     4ae:	ec86                	sd	ra,88(sp)
     4b0:	e8a2                	sd	s0,80(sp)
     4b2:	e4a6                	sd	s1,72(sp)
     4b4:	e0ca                	sd	s2,64(sp)
     4b6:	fc4e                	sd	s3,56(sp)
     4b8:	f852                	sd	s4,48(sp)
     4ba:	f456                	sd	s5,40(sp)
     4bc:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4be:	4785                	li	a5,1
     4c0:	07fe                	slli	a5,a5,0x1f
     4c2:	faf43823          	sd	a5,-80(s0)
     4c6:	57fd                	li	a5,-1
     4c8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4cc:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4d0:	00006a17          	auipc	s4,0x6
     4d4:	cc8a0a13          	addi	s4,s4,-824 # 6198 <malloc+0x5f6>
    n = write(fds[1], "x", 1);
     4d8:	00006a97          	auipc	s5,0x6
     4dc:	b98a8a93          	addi	s5,s5,-1128 # 6070 <malloc+0x4ce>
    uint64 addr = addrs[ai];
     4e0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4e4:	4581                	li	a1,0
     4e6:	8552                	mv	a0,s4
     4e8:	00005097          	auipc	ra,0x5
     4ec:	2bc080e7          	jalr	700(ra) # 57a4 <open>
     4f0:	84aa                	mv	s1,a0
    if(fd < 0){
     4f2:	08054663          	bltz	a0,57e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     4f6:	6609                	lui	a2,0x2
     4f8:	85ce                	mv	a1,s3
     4fa:	00005097          	auipc	ra,0x5
     4fe:	282080e7          	jalr	642(ra) # 577c <read>
    if(n > 0){
     502:	08a04b63          	bgtz	a0,598 <copyout+0xec>
    close(fd);
     506:	8526                	mv	a0,s1
     508:	00005097          	auipc	ra,0x5
     50c:	284080e7          	jalr	644(ra) # 578c <close>
    if(pipe(fds) < 0){
     510:	fa840513          	addi	a0,s0,-88
     514:	00005097          	auipc	ra,0x5
     518:	260080e7          	jalr	608(ra) # 5774 <pipe>
     51c:	08054d63          	bltz	a0,5b6 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     520:	4605                	li	a2,1
     522:	85d6                	mv	a1,s5
     524:	fac42503          	lw	a0,-84(s0)
     528:	00005097          	auipc	ra,0x5
     52c:	25c080e7          	jalr	604(ra) # 5784 <write>
    if(n != 1){
     530:	4785                	li	a5,1
     532:	08f51f63          	bne	a0,a5,5d0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     536:	6609                	lui	a2,0x2
     538:	85ce                	mv	a1,s3
     53a:	fa842503          	lw	a0,-88(s0)
     53e:	00005097          	auipc	ra,0x5
     542:	23e080e7          	jalr	574(ra) # 577c <read>
    if(n > 0){
     546:	0aa04263          	bgtz	a0,5ea <copyout+0x13e>
    close(fds[0]);
     54a:	fa842503          	lw	a0,-88(s0)
     54e:	00005097          	auipc	ra,0x5
     552:	23e080e7          	jalr	574(ra) # 578c <close>
    close(fds[1]);
     556:	fac42503          	lw	a0,-84(s0)
     55a:	00005097          	auipc	ra,0x5
     55e:	232080e7          	jalr	562(ra) # 578c <close>
  for(int ai = 0; ai < 2; ai++){
     562:	0921                	addi	s2,s2,8
     564:	fc040793          	addi	a5,s0,-64
     568:	f6f91ce3          	bne	s2,a5,4e0 <copyout+0x34>
}
     56c:	60e6                	ld	ra,88(sp)
     56e:	6446                	ld	s0,80(sp)
     570:	64a6                	ld	s1,72(sp)
     572:	6906                	ld	s2,64(sp)
     574:	79e2                	ld	s3,56(sp)
     576:	7a42                	ld	s4,48(sp)
     578:	7aa2                	ld	s5,40(sp)
     57a:	6125                	addi	sp,sp,96
     57c:	8082                	ret
      printf("open(README) failed\n");
     57e:	00006517          	auipc	a0,0x6
     582:	c2250513          	addi	a0,a0,-990 # 61a0 <malloc+0x5fe>
     586:	00005097          	auipc	ra,0x5
     58a:	55e080e7          	jalr	1374(ra) # 5ae4 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	00005097          	auipc	ra,0x5
     594:	1d4080e7          	jalr	468(ra) # 5764 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     598:	862a                	mv	a2,a0
     59a:	85ce                	mv	a1,s3
     59c:	00006517          	auipc	a0,0x6
     5a0:	c1c50513          	addi	a0,a0,-996 # 61b8 <malloc+0x616>
     5a4:	00005097          	auipc	ra,0x5
     5a8:	540080e7          	jalr	1344(ra) # 5ae4 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00005097          	auipc	ra,0x5
     5b2:	1b6080e7          	jalr	438(ra) # 5764 <exit>
      printf("pipe() failed\n");
     5b6:	00006517          	auipc	a0,0x6
     5ba:	ba250513          	addi	a0,a0,-1118 # 6158 <malloc+0x5b6>
     5be:	00005097          	auipc	ra,0x5
     5c2:	526080e7          	jalr	1318(ra) # 5ae4 <printf>
      exit(1);
     5c6:	4505                	li	a0,1
     5c8:	00005097          	auipc	ra,0x5
     5cc:	19c080e7          	jalr	412(ra) # 5764 <exit>
      printf("pipe write failed\n");
     5d0:	00006517          	auipc	a0,0x6
     5d4:	c1850513          	addi	a0,a0,-1000 # 61e8 <malloc+0x646>
     5d8:	00005097          	auipc	ra,0x5
     5dc:	50c080e7          	jalr	1292(ra) # 5ae4 <printf>
      exit(1);
     5e0:	4505                	li	a0,1
     5e2:	00005097          	auipc	ra,0x5
     5e6:	182080e7          	jalr	386(ra) # 5764 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ea:	862a                	mv	a2,a0
     5ec:	85ce                	mv	a1,s3
     5ee:	00006517          	auipc	a0,0x6
     5f2:	c1250513          	addi	a0,a0,-1006 # 6200 <malloc+0x65e>
     5f6:	00005097          	auipc	ra,0x5
     5fa:	4ee080e7          	jalr	1262(ra) # 5ae4 <printf>
      exit(1);
     5fe:	4505                	li	a0,1
     600:	00005097          	auipc	ra,0x5
     604:	164080e7          	jalr	356(ra) # 5764 <exit>

0000000000000608 <truncate1>:
{
     608:	711d                	addi	sp,sp,-96
     60a:	ec86                	sd	ra,88(sp)
     60c:	e8a2                	sd	s0,80(sp)
     60e:	e4a6                	sd	s1,72(sp)
     610:	e0ca                	sd	s2,64(sp)
     612:	fc4e                	sd	s3,56(sp)
     614:	f852                	sd	s4,48(sp)
     616:	f456                	sd	s5,40(sp)
     618:	1080                	addi	s0,sp,96
     61a:	8aaa                	mv	s5,a0
  unlink("truncfile");
     61c:	00006517          	auipc	a0,0x6
     620:	a3c50513          	addi	a0,a0,-1476 # 6058 <malloc+0x4b6>
     624:	00005097          	auipc	ra,0x5
     628:	190080e7          	jalr	400(ra) # 57b4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     62c:	60100593          	li	a1,1537
     630:	00006517          	auipc	a0,0x6
     634:	a2850513          	addi	a0,a0,-1496 # 6058 <malloc+0x4b6>
     638:	00005097          	auipc	ra,0x5
     63c:	16c080e7          	jalr	364(ra) # 57a4 <open>
     640:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     642:	4611                	li	a2,4
     644:	00006597          	auipc	a1,0x6
     648:	a2458593          	addi	a1,a1,-1500 # 6068 <malloc+0x4c6>
     64c:	00005097          	auipc	ra,0x5
     650:	138080e7          	jalr	312(ra) # 5784 <write>
  close(fd1);
     654:	8526                	mv	a0,s1
     656:	00005097          	auipc	ra,0x5
     65a:	136080e7          	jalr	310(ra) # 578c <close>
  int fd2 = open("truncfile", O_RDONLY);
     65e:	4581                	li	a1,0
     660:	00006517          	auipc	a0,0x6
     664:	9f850513          	addi	a0,a0,-1544 # 6058 <malloc+0x4b6>
     668:	00005097          	auipc	ra,0x5
     66c:	13c080e7          	jalr	316(ra) # 57a4 <open>
     670:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     672:	02000613          	li	a2,32
     676:	fa040593          	addi	a1,s0,-96
     67a:	00005097          	auipc	ra,0x5
     67e:	102080e7          	jalr	258(ra) # 577c <read>
  if(n != 4){
     682:	4791                	li	a5,4
     684:	0cf51e63          	bne	a0,a5,760 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     688:	40100593          	li	a1,1025
     68c:	00006517          	auipc	a0,0x6
     690:	9cc50513          	addi	a0,a0,-1588 # 6058 <malloc+0x4b6>
     694:	00005097          	auipc	ra,0x5
     698:	110080e7          	jalr	272(ra) # 57a4 <open>
     69c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     69e:	4581                	li	a1,0
     6a0:	00006517          	auipc	a0,0x6
     6a4:	9b850513          	addi	a0,a0,-1608 # 6058 <malloc+0x4b6>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	0fc080e7          	jalr	252(ra) # 57a4 <open>
     6b0:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6b2:	02000613          	li	a2,32
     6b6:	fa040593          	addi	a1,s0,-96
     6ba:	00005097          	auipc	ra,0x5
     6be:	0c2080e7          	jalr	194(ra) # 577c <read>
     6c2:	8a2a                	mv	s4,a0
  if(n != 0){
     6c4:	ed4d                	bnez	a0,77e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	8526                	mv	a0,s1
     6d0:	00005097          	auipc	ra,0x5
     6d4:	0ac080e7          	jalr	172(ra) # 577c <read>
     6d8:	8a2a                	mv	s4,a0
  if(n != 0){
     6da:	e971                	bnez	a0,7ae <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6dc:	4619                	li	a2,6
     6de:	00006597          	auipc	a1,0x6
     6e2:	bb258593          	addi	a1,a1,-1102 # 6290 <malloc+0x6ee>
     6e6:	854e                	mv	a0,s3
     6e8:	00005097          	auipc	ra,0x5
     6ec:	09c080e7          	jalr	156(ra) # 5784 <write>
  n = read(fd3, buf, sizeof(buf));
     6f0:	02000613          	li	a2,32
     6f4:	fa040593          	addi	a1,s0,-96
     6f8:	854a                	mv	a0,s2
     6fa:	00005097          	auipc	ra,0x5
     6fe:	082080e7          	jalr	130(ra) # 577c <read>
  if(n != 6){
     702:	4799                	li	a5,6
     704:	0cf51d63          	bne	a0,a5,7de <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     708:	02000613          	li	a2,32
     70c:	fa040593          	addi	a1,s0,-96
     710:	8526                	mv	a0,s1
     712:	00005097          	auipc	ra,0x5
     716:	06a080e7          	jalr	106(ra) # 577c <read>
  if(n != 2){
     71a:	4789                	li	a5,2
     71c:	0ef51063          	bne	a0,a5,7fc <truncate1+0x1f4>
  unlink("truncfile");
     720:	00006517          	auipc	a0,0x6
     724:	93850513          	addi	a0,a0,-1736 # 6058 <malloc+0x4b6>
     728:	00005097          	auipc	ra,0x5
     72c:	08c080e7          	jalr	140(ra) # 57b4 <unlink>
  close(fd1);
     730:	854e                	mv	a0,s3
     732:	00005097          	auipc	ra,0x5
     736:	05a080e7          	jalr	90(ra) # 578c <close>
  close(fd2);
     73a:	8526                	mv	a0,s1
     73c:	00005097          	auipc	ra,0x5
     740:	050080e7          	jalr	80(ra) # 578c <close>
  close(fd3);
     744:	854a                	mv	a0,s2
     746:	00005097          	auipc	ra,0x5
     74a:	046080e7          	jalr	70(ra) # 578c <close>
}
     74e:	60e6                	ld	ra,88(sp)
     750:	6446                	ld	s0,80(sp)
     752:	64a6                	ld	s1,72(sp)
     754:	6906                	ld	s2,64(sp)
     756:	79e2                	ld	s3,56(sp)
     758:	7a42                	ld	s4,48(sp)
     75a:	7aa2                	ld	s5,40(sp)
     75c:	6125                	addi	sp,sp,96
     75e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     760:	862a                	mv	a2,a0
     762:	85d6                	mv	a1,s5
     764:	00006517          	auipc	a0,0x6
     768:	acc50513          	addi	a0,a0,-1332 # 6230 <malloc+0x68e>
     76c:	00005097          	auipc	ra,0x5
     770:	378080e7          	jalr	888(ra) # 5ae4 <printf>
    exit(1);
     774:	4505                	li	a0,1
     776:	00005097          	auipc	ra,0x5
     77a:	fee080e7          	jalr	-18(ra) # 5764 <exit>
    printf("aaa fd3=%d\n", fd3);
     77e:	85ca                	mv	a1,s2
     780:	00006517          	auipc	a0,0x6
     784:	ad050513          	addi	a0,a0,-1328 # 6250 <malloc+0x6ae>
     788:	00005097          	auipc	ra,0x5
     78c:	35c080e7          	jalr	860(ra) # 5ae4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     790:	8652                	mv	a2,s4
     792:	85d6                	mv	a1,s5
     794:	00006517          	auipc	a0,0x6
     798:	acc50513          	addi	a0,a0,-1332 # 6260 <malloc+0x6be>
     79c:	00005097          	auipc	ra,0x5
     7a0:	348080e7          	jalr	840(ra) # 5ae4 <printf>
    exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	fbe080e7          	jalr	-66(ra) # 5764 <exit>
    printf("bbb fd2=%d\n", fd2);
     7ae:	85a6                	mv	a1,s1
     7b0:	00006517          	auipc	a0,0x6
     7b4:	ad050513          	addi	a0,a0,-1328 # 6280 <malloc+0x6de>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	32c080e7          	jalr	812(ra) # 5ae4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7c0:	8652                	mv	a2,s4
     7c2:	85d6                	mv	a1,s5
     7c4:	00006517          	auipc	a0,0x6
     7c8:	a9c50513          	addi	a0,a0,-1380 # 6260 <malloc+0x6be>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	318080e7          	jalr	792(ra) # 5ae4 <printf>
    exit(1);
     7d4:	4505                	li	a0,1
     7d6:	00005097          	auipc	ra,0x5
     7da:	f8e080e7          	jalr	-114(ra) # 5764 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7de:	862a                	mv	a2,a0
     7e0:	85d6                	mv	a1,s5
     7e2:	00006517          	auipc	a0,0x6
     7e6:	ab650513          	addi	a0,a0,-1354 # 6298 <malloc+0x6f6>
     7ea:	00005097          	auipc	ra,0x5
     7ee:	2fa080e7          	jalr	762(ra) # 5ae4 <printf>
    exit(1);
     7f2:	4505                	li	a0,1
     7f4:	00005097          	auipc	ra,0x5
     7f8:	f70080e7          	jalr	-144(ra) # 5764 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     7fc:	862a                	mv	a2,a0
     7fe:	85d6                	mv	a1,s5
     800:	00006517          	auipc	a0,0x6
     804:	ab850513          	addi	a0,a0,-1352 # 62b8 <malloc+0x716>
     808:	00005097          	auipc	ra,0x5
     80c:	2dc080e7          	jalr	732(ra) # 5ae4 <printf>
    exit(1);
     810:	4505                	li	a0,1
     812:	00005097          	auipc	ra,0x5
     816:	f52080e7          	jalr	-174(ra) # 5764 <exit>

000000000000081a <writetest>:
{
     81a:	7139                	addi	sp,sp,-64
     81c:	fc06                	sd	ra,56(sp)
     81e:	f822                	sd	s0,48(sp)
     820:	f426                	sd	s1,40(sp)
     822:	f04a                	sd	s2,32(sp)
     824:	ec4e                	sd	s3,24(sp)
     826:	e852                	sd	s4,16(sp)
     828:	e456                	sd	s5,8(sp)
     82a:	e05a                	sd	s6,0(sp)
     82c:	0080                	addi	s0,sp,64
     82e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     830:	20200593          	li	a1,514
     834:	00006517          	auipc	a0,0x6
     838:	aa450513          	addi	a0,a0,-1372 # 62d8 <malloc+0x736>
     83c:	00005097          	auipc	ra,0x5
     840:	f68080e7          	jalr	-152(ra) # 57a4 <open>
  if(fd < 0){
     844:	0a054d63          	bltz	a0,8fe <writetest+0xe4>
     848:	892a                	mv	s2,a0
     84a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     84c:	00006997          	auipc	s3,0x6
     850:	ab498993          	addi	s3,s3,-1356 # 6300 <malloc+0x75e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     854:	00006a97          	auipc	s5,0x6
     858:	ae4a8a93          	addi	s5,s5,-1308 # 6338 <malloc+0x796>
  for(i = 0; i < N; i++){
     85c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	4629                	li	a2,10
     862:	85ce                	mv	a1,s3
     864:	854a                	mv	a0,s2
     866:	00005097          	auipc	ra,0x5
     86a:	f1e080e7          	jalr	-226(ra) # 5784 <write>
     86e:	47a9                	li	a5,10
     870:	0af51563          	bne	a0,a5,91a <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85d6                	mv	a1,s5
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	f0a080e7          	jalr	-246(ra) # 5784 <write>
     882:	47a9                	li	a5,10
     884:	0af51a63          	bne	a0,a5,938 <writetest+0x11e>
  for(i = 0; i < N; i++){
     888:	2485                	addiw	s1,s1,1
     88a:	fd449be3          	bne	s1,s4,860 <writetest+0x46>
  close(fd);
     88e:	854a                	mv	a0,s2
     890:	00005097          	auipc	ra,0x5
     894:	efc080e7          	jalr	-260(ra) # 578c <close>
  fd = open("small", O_RDONLY);
     898:	4581                	li	a1,0
     89a:	00006517          	auipc	a0,0x6
     89e:	a3e50513          	addi	a0,a0,-1474 # 62d8 <malloc+0x736>
     8a2:	00005097          	auipc	ra,0x5
     8a6:	f02080e7          	jalr	-254(ra) # 57a4 <open>
     8aa:	84aa                	mv	s1,a0
  if(fd < 0){
     8ac:	0a054563          	bltz	a0,956 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     8b0:	7d000613          	li	a2,2000
     8b4:	0000b597          	auipc	a1,0xb
     8b8:	3d458593          	addi	a1,a1,980 # bc88 <buf>
     8bc:	00005097          	auipc	ra,0x5
     8c0:	ec0080e7          	jalr	-320(ra) # 577c <read>
  if(i != N*SZ*2){
     8c4:	7d000793          	li	a5,2000
     8c8:	0af51563          	bne	a0,a5,972 <writetest+0x158>
  close(fd);
     8cc:	8526                	mv	a0,s1
     8ce:	00005097          	auipc	ra,0x5
     8d2:	ebe080e7          	jalr	-322(ra) # 578c <close>
  if(unlink("small") < 0){
     8d6:	00006517          	auipc	a0,0x6
     8da:	a0250513          	addi	a0,a0,-1534 # 62d8 <malloc+0x736>
     8de:	00005097          	auipc	ra,0x5
     8e2:	ed6080e7          	jalr	-298(ra) # 57b4 <unlink>
     8e6:	0a054463          	bltz	a0,98e <writetest+0x174>
}
     8ea:	70e2                	ld	ra,56(sp)
     8ec:	7442                	ld	s0,48(sp)
     8ee:	74a2                	ld	s1,40(sp)
     8f0:	7902                	ld	s2,32(sp)
     8f2:	69e2                	ld	s3,24(sp)
     8f4:	6a42                	ld	s4,16(sp)
     8f6:	6aa2                	ld	s5,8(sp)
     8f8:	6b02                	ld	s6,0(sp)
     8fa:	6121                	addi	sp,sp,64
     8fc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     8fe:	85da                	mv	a1,s6
     900:	00006517          	auipc	a0,0x6
     904:	9e050513          	addi	a0,a0,-1568 # 62e0 <malloc+0x73e>
     908:	00005097          	auipc	ra,0x5
     90c:	1dc080e7          	jalr	476(ra) # 5ae4 <printf>
    exit(1);
     910:	4505                	li	a0,1
     912:	00005097          	auipc	ra,0x5
     916:	e52080e7          	jalr	-430(ra) # 5764 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     91a:	8626                	mv	a2,s1
     91c:	85da                	mv	a1,s6
     91e:	00006517          	auipc	a0,0x6
     922:	9f250513          	addi	a0,a0,-1550 # 6310 <malloc+0x76e>
     926:	00005097          	auipc	ra,0x5
     92a:	1be080e7          	jalr	446(ra) # 5ae4 <printf>
      exit(1);
     92e:	4505                	li	a0,1
     930:	00005097          	auipc	ra,0x5
     934:	e34080e7          	jalr	-460(ra) # 5764 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     938:	8626                	mv	a2,s1
     93a:	85da                	mv	a1,s6
     93c:	00006517          	auipc	a0,0x6
     940:	a0c50513          	addi	a0,a0,-1524 # 6348 <malloc+0x7a6>
     944:	00005097          	auipc	ra,0x5
     948:	1a0080e7          	jalr	416(ra) # 5ae4 <printf>
      exit(1);
     94c:	4505                	li	a0,1
     94e:	00005097          	auipc	ra,0x5
     952:	e16080e7          	jalr	-490(ra) # 5764 <exit>
    printf("%s: error: open small failed!\n", s);
     956:	85da                	mv	a1,s6
     958:	00006517          	auipc	a0,0x6
     95c:	a1850513          	addi	a0,a0,-1512 # 6370 <malloc+0x7ce>
     960:	00005097          	auipc	ra,0x5
     964:	184080e7          	jalr	388(ra) # 5ae4 <printf>
    exit(1);
     968:	4505                	li	a0,1
     96a:	00005097          	auipc	ra,0x5
     96e:	dfa080e7          	jalr	-518(ra) # 5764 <exit>
    printf("%s: read failed\n", s);
     972:	85da                	mv	a1,s6
     974:	00006517          	auipc	a0,0x6
     978:	a1c50513          	addi	a0,a0,-1508 # 6390 <malloc+0x7ee>
     97c:	00005097          	auipc	ra,0x5
     980:	168080e7          	jalr	360(ra) # 5ae4 <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	dde080e7          	jalr	-546(ra) # 5764 <exit>
    printf("%s: unlink small failed\n", s);
     98e:	85da                	mv	a1,s6
     990:	00006517          	auipc	a0,0x6
     994:	a1850513          	addi	a0,a0,-1512 # 63a8 <malloc+0x806>
     998:	00005097          	auipc	ra,0x5
     99c:	14c080e7          	jalr	332(ra) # 5ae4 <printf>
    exit(1);
     9a0:	4505                	li	a0,1
     9a2:	00005097          	auipc	ra,0x5
     9a6:	dc2080e7          	jalr	-574(ra) # 5764 <exit>

00000000000009aa <writebig>:
{
     9aa:	7139                	addi	sp,sp,-64
     9ac:	fc06                	sd	ra,56(sp)
     9ae:	f822                	sd	s0,48(sp)
     9b0:	f426                	sd	s1,40(sp)
     9b2:	f04a                	sd	s2,32(sp)
     9b4:	ec4e                	sd	s3,24(sp)
     9b6:	e852                	sd	s4,16(sp)
     9b8:	e456                	sd	s5,8(sp)
     9ba:	0080                	addi	s0,sp,64
     9bc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9be:	20200593          	li	a1,514
     9c2:	00006517          	auipc	a0,0x6
     9c6:	a0650513          	addi	a0,a0,-1530 # 63c8 <malloc+0x826>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	dda080e7          	jalr	-550(ra) # 57a4 <open>
     9d2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9d4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9d6:	0000b917          	auipc	s2,0xb
     9da:	2b290913          	addi	s2,s2,690 # bc88 <buf>
  for(i = 0; i < MAXFILE; i++){
     9de:	10c00a13          	li	s4,268
  if(fd < 0){
     9e2:	06054c63          	bltz	a0,a5a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9e6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9ea:	40000613          	li	a2,1024
     9ee:	85ca                	mv	a1,s2
     9f0:	854e                	mv	a0,s3
     9f2:	00005097          	auipc	ra,0x5
     9f6:	d92080e7          	jalr	-622(ra) # 5784 <write>
     9fa:	40000793          	li	a5,1024
     9fe:	06f51c63          	bne	a0,a5,a76 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	ff4491e3          	bne	s1,s4,9e6 <writebig+0x3c>
  close(fd);
     a08:	854e                	mv	a0,s3
     a0a:	00005097          	auipc	ra,0x5
     a0e:	d82080e7          	jalr	-638(ra) # 578c <close>
  fd = open("big", O_RDONLY);
     a12:	4581                	li	a1,0
     a14:	00006517          	auipc	a0,0x6
     a18:	9b450513          	addi	a0,a0,-1612 # 63c8 <malloc+0x826>
     a1c:	00005097          	auipc	ra,0x5
     a20:	d88080e7          	jalr	-632(ra) # 57a4 <open>
     a24:	89aa                	mv	s3,a0
  n = 0;
     a26:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a28:	0000b917          	auipc	s2,0xb
     a2c:	26090913          	addi	s2,s2,608 # bc88 <buf>
  if(fd < 0){
     a30:	06054263          	bltz	a0,a94 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     a34:	40000613          	li	a2,1024
     a38:	85ca                	mv	a1,s2
     a3a:	854e                	mv	a0,s3
     a3c:	00005097          	auipc	ra,0x5
     a40:	d40080e7          	jalr	-704(ra) # 577c <read>
    if(i == 0){
     a44:	c535                	beqz	a0,ab0 <writebig+0x106>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	0af51f63          	bne	a0,a5,b08 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0c969a63          	bne	a3,s1,b26 <writebig+0x17c>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	bff1                	j	a34 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00006517          	auipc	a0,0x6
     a60:	97450513          	addi	a0,a0,-1676 # 63d0 <malloc+0x82e>
     a64:	00005097          	auipc	ra,0x5
     a68:	080080e7          	jalr	128(ra) # 5ae4 <printf>
    exit(1);
     a6c:	4505                	li	a0,1
     a6e:	00005097          	auipc	ra,0x5
     a72:	cf6080e7          	jalr	-778(ra) # 5764 <exit>
      printf("%s: error: write big file failed\n", s, i);
     a76:	8626                	mv	a2,s1
     a78:	85d6                	mv	a1,s5
     a7a:	00006517          	auipc	a0,0x6
     a7e:	97650513          	addi	a0,a0,-1674 # 63f0 <malloc+0x84e>
     a82:	00005097          	auipc	ra,0x5
     a86:	062080e7          	jalr	98(ra) # 5ae4 <printf>
      exit(1);
     a8a:	4505                	li	a0,1
     a8c:	00005097          	auipc	ra,0x5
     a90:	cd8080e7          	jalr	-808(ra) # 5764 <exit>
    printf("%s: error: open big failed!\n", s);
     a94:	85d6                	mv	a1,s5
     a96:	00006517          	auipc	a0,0x6
     a9a:	98250513          	addi	a0,a0,-1662 # 6418 <malloc+0x876>
     a9e:	00005097          	auipc	ra,0x5
     aa2:	046080e7          	jalr	70(ra) # 5ae4 <printf>
    exit(1);
     aa6:	4505                	li	a0,1
     aa8:	00005097          	auipc	ra,0x5
     aac:	cbc080e7          	jalr	-836(ra) # 5764 <exit>
      if(n == MAXFILE - 1){
     ab0:	10b00793          	li	a5,267
     ab4:	02f48a63          	beq	s1,a5,ae8 <writebig+0x13e>
  close(fd);
     ab8:	854e                	mv	a0,s3
     aba:	00005097          	auipc	ra,0x5
     abe:	cd2080e7          	jalr	-814(ra) # 578c <close>
  if(unlink("big") < 0){
     ac2:	00006517          	auipc	a0,0x6
     ac6:	90650513          	addi	a0,a0,-1786 # 63c8 <malloc+0x826>
     aca:	00005097          	auipc	ra,0x5
     ace:	cea080e7          	jalr	-790(ra) # 57b4 <unlink>
     ad2:	06054963          	bltz	a0,b44 <writebig+0x19a>
}
     ad6:	70e2                	ld	ra,56(sp)
     ad8:	7442                	ld	s0,48(sp)
     ada:	74a2                	ld	s1,40(sp)
     adc:	7902                	ld	s2,32(sp)
     ade:	69e2                	ld	s3,24(sp)
     ae0:	6a42                	ld	s4,16(sp)
     ae2:	6aa2                	ld	s5,8(sp)
     ae4:	6121                	addi	sp,sp,64
     ae6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ae8:	10b00613          	li	a2,267
     aec:	85d6                	mv	a1,s5
     aee:	00006517          	auipc	a0,0x6
     af2:	94a50513          	addi	a0,a0,-1718 # 6438 <malloc+0x896>
     af6:	00005097          	auipc	ra,0x5
     afa:	fee080e7          	jalr	-18(ra) # 5ae4 <printf>
        exit(1);
     afe:	4505                	li	a0,1
     b00:	00005097          	auipc	ra,0x5
     b04:	c64080e7          	jalr	-924(ra) # 5764 <exit>
      printf("%s: read failed %d\n", s, i);
     b08:	862a                	mv	a2,a0
     b0a:	85d6                	mv	a1,s5
     b0c:	00006517          	auipc	a0,0x6
     b10:	95450513          	addi	a0,a0,-1708 # 6460 <malloc+0x8be>
     b14:	00005097          	auipc	ra,0x5
     b18:	fd0080e7          	jalr	-48(ra) # 5ae4 <printf>
      exit(1);
     b1c:	4505                	li	a0,1
     b1e:	00005097          	auipc	ra,0x5
     b22:	c46080e7          	jalr	-954(ra) # 5764 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b26:	8626                	mv	a2,s1
     b28:	85d6                	mv	a1,s5
     b2a:	00006517          	auipc	a0,0x6
     b2e:	94e50513          	addi	a0,a0,-1714 # 6478 <malloc+0x8d6>
     b32:	00005097          	auipc	ra,0x5
     b36:	fb2080e7          	jalr	-78(ra) # 5ae4 <printf>
      exit(1);
     b3a:	4505                	li	a0,1
     b3c:	00005097          	auipc	ra,0x5
     b40:	c28080e7          	jalr	-984(ra) # 5764 <exit>
    printf("%s: unlink big failed\n", s);
     b44:	85d6                	mv	a1,s5
     b46:	00006517          	auipc	a0,0x6
     b4a:	95a50513          	addi	a0,a0,-1702 # 64a0 <malloc+0x8fe>
     b4e:	00005097          	auipc	ra,0x5
     b52:	f96080e7          	jalr	-106(ra) # 5ae4 <printf>
    exit(1);
     b56:	4505                	li	a0,1
     b58:	00005097          	auipc	ra,0x5
     b5c:	c0c080e7          	jalr	-1012(ra) # 5764 <exit>

0000000000000b60 <unlinkread>:
{
     b60:	7179                	addi	sp,sp,-48
     b62:	f406                	sd	ra,40(sp)
     b64:	f022                	sd	s0,32(sp)
     b66:	ec26                	sd	s1,24(sp)
     b68:	e84a                	sd	s2,16(sp)
     b6a:	e44e                	sd	s3,8(sp)
     b6c:	1800                	addi	s0,sp,48
     b6e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b70:	20200593          	li	a1,514
     b74:	00005517          	auipc	a0,0x5
     b78:	27450513          	addi	a0,a0,628 # 5de8 <malloc+0x246>
     b7c:	00005097          	auipc	ra,0x5
     b80:	c28080e7          	jalr	-984(ra) # 57a4 <open>
  if(fd < 0){
     b84:	0e054563          	bltz	a0,c6e <unlinkread+0x10e>
     b88:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b8a:	4615                	li	a2,5
     b8c:	00006597          	auipc	a1,0x6
     b90:	94c58593          	addi	a1,a1,-1716 # 64d8 <malloc+0x936>
     b94:	00005097          	auipc	ra,0x5
     b98:	bf0080e7          	jalr	-1040(ra) # 5784 <write>
  close(fd);
     b9c:	8526                	mv	a0,s1
     b9e:	00005097          	auipc	ra,0x5
     ba2:	bee080e7          	jalr	-1042(ra) # 578c <close>
  fd = open("unlinkread", O_RDWR);
     ba6:	4589                	li	a1,2
     ba8:	00005517          	auipc	a0,0x5
     bac:	24050513          	addi	a0,a0,576 # 5de8 <malloc+0x246>
     bb0:	00005097          	auipc	ra,0x5
     bb4:	bf4080e7          	jalr	-1036(ra) # 57a4 <open>
     bb8:	84aa                	mv	s1,a0
  if(fd < 0){
     bba:	0c054863          	bltz	a0,c8a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bbe:	00005517          	auipc	a0,0x5
     bc2:	22a50513          	addi	a0,a0,554 # 5de8 <malloc+0x246>
     bc6:	00005097          	auipc	ra,0x5
     bca:	bee080e7          	jalr	-1042(ra) # 57b4 <unlink>
     bce:	ed61                	bnez	a0,ca6 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	21450513          	addi	a0,a0,532 # 5de8 <malloc+0x246>
     bdc:	00005097          	auipc	ra,0x5
     be0:	bc8080e7          	jalr	-1080(ra) # 57a4 <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00006597          	auipc	a1,0x6
     bec:	93858593          	addi	a1,a1,-1736 # 6520 <malloc+0x97e>
     bf0:	00005097          	auipc	ra,0x5
     bf4:	b94080e7          	jalr	-1132(ra) # 5784 <write>
  close(fd1);
     bf8:	854a                	mv	a0,s2
     bfa:	00005097          	auipc	ra,0x5
     bfe:	b92080e7          	jalr	-1134(ra) # 578c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c02:	660d                	lui	a2,0x3
     c04:	0000b597          	auipc	a1,0xb
     c08:	08458593          	addi	a1,a1,132 # bc88 <buf>
     c0c:	8526                	mv	a0,s1
     c0e:	00005097          	auipc	ra,0x5
     c12:	b6e080e7          	jalr	-1170(ra) # 577c <read>
     c16:	4795                	li	a5,5
     c18:	0af51563          	bne	a0,a5,cc2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     c1c:	0000b717          	auipc	a4,0xb
     c20:	06c74703          	lbu	a4,108(a4) # bc88 <buf>
     c24:	06800793          	li	a5,104
     c28:	0af71b63          	bne	a4,a5,cde <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c2c:	4629                	li	a2,10
     c2e:	0000b597          	auipc	a1,0xb
     c32:	05a58593          	addi	a1,a1,90 # bc88 <buf>
     c36:	8526                	mv	a0,s1
     c38:	00005097          	auipc	ra,0x5
     c3c:	b4c080e7          	jalr	-1204(ra) # 5784 <write>
     c40:	47a9                	li	a5,10
     c42:	0af51c63          	bne	a0,a5,cfa <unlinkread+0x19a>
  close(fd);
     c46:	8526                	mv	a0,s1
     c48:	00005097          	auipc	ra,0x5
     c4c:	b44080e7          	jalr	-1212(ra) # 578c <close>
  unlink("unlinkread");
     c50:	00005517          	auipc	a0,0x5
     c54:	19850513          	addi	a0,a0,408 # 5de8 <malloc+0x246>
     c58:	00005097          	auipc	ra,0x5
     c5c:	b5c080e7          	jalr	-1188(ra) # 57b4 <unlink>
}
     c60:	70a2                	ld	ra,40(sp)
     c62:	7402                	ld	s0,32(sp)
     c64:	64e2                	ld	s1,24(sp)
     c66:	6942                	ld	s2,16(sp)
     c68:	69a2                	ld	s3,8(sp)
     c6a:	6145                	addi	sp,sp,48
     c6c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c6e:	85ce                	mv	a1,s3
     c70:	00006517          	auipc	a0,0x6
     c74:	84850513          	addi	a0,a0,-1976 # 64b8 <malloc+0x916>
     c78:	00005097          	auipc	ra,0x5
     c7c:	e6c080e7          	jalr	-404(ra) # 5ae4 <printf>
    exit(1);
     c80:	4505                	li	a0,1
     c82:	00005097          	auipc	ra,0x5
     c86:	ae2080e7          	jalr	-1310(ra) # 5764 <exit>
    printf("%s: open unlinkread failed\n", s);
     c8a:	85ce                	mv	a1,s3
     c8c:	00006517          	auipc	a0,0x6
     c90:	85450513          	addi	a0,a0,-1964 # 64e0 <malloc+0x93e>
     c94:	00005097          	auipc	ra,0x5
     c98:	e50080e7          	jalr	-432(ra) # 5ae4 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00005097          	auipc	ra,0x5
     ca2:	ac6080e7          	jalr	-1338(ra) # 5764 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00006517          	auipc	a0,0x6
     cac:	85850513          	addi	a0,a0,-1960 # 6500 <malloc+0x95e>
     cb0:	00005097          	auipc	ra,0x5
     cb4:	e34080e7          	jalr	-460(ra) # 5ae4 <printf>
    exit(1);
     cb8:	4505                	li	a0,1
     cba:	00005097          	auipc	ra,0x5
     cbe:	aaa080e7          	jalr	-1366(ra) # 5764 <exit>
    printf("%s: unlinkread read failed", s);
     cc2:	85ce                	mv	a1,s3
     cc4:	00006517          	auipc	a0,0x6
     cc8:	86450513          	addi	a0,a0,-1948 # 6528 <malloc+0x986>
     ccc:	00005097          	auipc	ra,0x5
     cd0:	e18080e7          	jalr	-488(ra) # 5ae4 <printf>
    exit(1);
     cd4:	4505                	li	a0,1
     cd6:	00005097          	auipc	ra,0x5
     cda:	a8e080e7          	jalr	-1394(ra) # 5764 <exit>
    printf("%s: unlinkread wrong data\n", s);
     cde:	85ce                	mv	a1,s3
     ce0:	00006517          	auipc	a0,0x6
     ce4:	86850513          	addi	a0,a0,-1944 # 6548 <malloc+0x9a6>
     ce8:	00005097          	auipc	ra,0x5
     cec:	dfc080e7          	jalr	-516(ra) # 5ae4 <printf>
    exit(1);
     cf0:	4505                	li	a0,1
     cf2:	00005097          	auipc	ra,0x5
     cf6:	a72080e7          	jalr	-1422(ra) # 5764 <exit>
    printf("%s: unlinkread write failed\n", s);
     cfa:	85ce                	mv	a1,s3
     cfc:	00006517          	auipc	a0,0x6
     d00:	86c50513          	addi	a0,a0,-1940 # 6568 <malloc+0x9c6>
     d04:	00005097          	auipc	ra,0x5
     d08:	de0080e7          	jalr	-544(ra) # 5ae4 <printf>
    exit(1);
     d0c:	4505                	li	a0,1
     d0e:	00005097          	auipc	ra,0x5
     d12:	a56080e7          	jalr	-1450(ra) # 5764 <exit>

0000000000000d16 <linktest>:
{
     d16:	1101                	addi	sp,sp,-32
     d18:	ec06                	sd	ra,24(sp)
     d1a:	e822                	sd	s0,16(sp)
     d1c:	e426                	sd	s1,8(sp)
     d1e:	e04a                	sd	s2,0(sp)
     d20:	1000                	addi	s0,sp,32
     d22:	892a                	mv	s2,a0
  unlink("lf1");
     d24:	00006517          	auipc	a0,0x6
     d28:	86450513          	addi	a0,a0,-1948 # 6588 <malloc+0x9e6>
     d2c:	00005097          	auipc	ra,0x5
     d30:	a88080e7          	jalr	-1400(ra) # 57b4 <unlink>
  unlink("lf2");
     d34:	00006517          	auipc	a0,0x6
     d38:	85c50513          	addi	a0,a0,-1956 # 6590 <malloc+0x9ee>
     d3c:	00005097          	auipc	ra,0x5
     d40:	a78080e7          	jalr	-1416(ra) # 57b4 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d44:	20200593          	li	a1,514
     d48:	00006517          	auipc	a0,0x6
     d4c:	84050513          	addi	a0,a0,-1984 # 6588 <malloc+0x9e6>
     d50:	00005097          	auipc	ra,0x5
     d54:	a54080e7          	jalr	-1452(ra) # 57a4 <open>
  if(fd < 0){
     d58:	10054763          	bltz	a0,e66 <linktest+0x150>
     d5c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d5e:	4615                	li	a2,5
     d60:	00005597          	auipc	a1,0x5
     d64:	77858593          	addi	a1,a1,1912 # 64d8 <malloc+0x936>
     d68:	00005097          	auipc	ra,0x5
     d6c:	a1c080e7          	jalr	-1508(ra) # 5784 <write>
     d70:	4795                	li	a5,5
     d72:	10f51863          	bne	a0,a5,e82 <linktest+0x16c>
  close(fd);
     d76:	8526                	mv	a0,s1
     d78:	00005097          	auipc	ra,0x5
     d7c:	a14080e7          	jalr	-1516(ra) # 578c <close>
  if(link("lf1", "lf2") < 0){
     d80:	00006597          	auipc	a1,0x6
     d84:	81058593          	addi	a1,a1,-2032 # 6590 <malloc+0x9ee>
     d88:	00006517          	auipc	a0,0x6
     d8c:	80050513          	addi	a0,a0,-2048 # 6588 <malloc+0x9e6>
     d90:	00005097          	auipc	ra,0x5
     d94:	a34080e7          	jalr	-1484(ra) # 57c4 <link>
     d98:	10054363          	bltz	a0,e9e <linktest+0x188>
  unlink("lf1");
     d9c:	00005517          	auipc	a0,0x5
     da0:	7ec50513          	addi	a0,a0,2028 # 6588 <malloc+0x9e6>
     da4:	00005097          	auipc	ra,0x5
     da8:	a10080e7          	jalr	-1520(ra) # 57b4 <unlink>
  if(open("lf1", 0) >= 0){
     dac:	4581                	li	a1,0
     dae:	00005517          	auipc	a0,0x5
     db2:	7da50513          	addi	a0,a0,2010 # 6588 <malloc+0x9e6>
     db6:	00005097          	auipc	ra,0x5
     dba:	9ee080e7          	jalr	-1554(ra) # 57a4 <open>
     dbe:	0e055e63          	bgez	a0,eba <linktest+0x1a4>
  fd = open("lf2", 0);
     dc2:	4581                	li	a1,0
     dc4:	00005517          	auipc	a0,0x5
     dc8:	7cc50513          	addi	a0,a0,1996 # 6590 <malloc+0x9ee>
     dcc:	00005097          	auipc	ra,0x5
     dd0:	9d8080e7          	jalr	-1576(ra) # 57a4 <open>
     dd4:	84aa                	mv	s1,a0
  if(fd < 0){
     dd6:	10054063          	bltz	a0,ed6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     dda:	660d                	lui	a2,0x3
     ddc:	0000b597          	auipc	a1,0xb
     de0:	eac58593          	addi	a1,a1,-340 # bc88 <buf>
     de4:	00005097          	auipc	ra,0x5
     de8:	998080e7          	jalr	-1640(ra) # 577c <read>
     dec:	4795                	li	a5,5
     dee:	10f51263          	bne	a0,a5,ef2 <linktest+0x1dc>
  close(fd);
     df2:	8526                	mv	a0,s1
     df4:	00005097          	auipc	ra,0x5
     df8:	998080e7          	jalr	-1640(ra) # 578c <close>
  if(link("lf2", "lf2") >= 0){
     dfc:	00005597          	auipc	a1,0x5
     e00:	79458593          	addi	a1,a1,1940 # 6590 <malloc+0x9ee>
     e04:	852e                	mv	a0,a1
     e06:	00005097          	auipc	ra,0x5
     e0a:	9be080e7          	jalr	-1602(ra) # 57c4 <link>
     e0e:	10055063          	bgez	a0,f0e <linktest+0x1f8>
  unlink("lf2");
     e12:	00005517          	auipc	a0,0x5
     e16:	77e50513          	addi	a0,a0,1918 # 6590 <malloc+0x9ee>
     e1a:	00005097          	auipc	ra,0x5
     e1e:	99a080e7          	jalr	-1638(ra) # 57b4 <unlink>
  if(link("lf2", "lf1") >= 0){
     e22:	00005597          	auipc	a1,0x5
     e26:	76658593          	addi	a1,a1,1894 # 6588 <malloc+0x9e6>
     e2a:	00005517          	auipc	a0,0x5
     e2e:	76650513          	addi	a0,a0,1894 # 6590 <malloc+0x9ee>
     e32:	00005097          	auipc	ra,0x5
     e36:	992080e7          	jalr	-1646(ra) # 57c4 <link>
     e3a:	0e055863          	bgez	a0,f2a <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e3e:	00005597          	auipc	a1,0x5
     e42:	74a58593          	addi	a1,a1,1866 # 6588 <malloc+0x9e6>
     e46:	00006517          	auipc	a0,0x6
     e4a:	85250513          	addi	a0,a0,-1966 # 6698 <malloc+0xaf6>
     e4e:	00005097          	auipc	ra,0x5
     e52:	976080e7          	jalr	-1674(ra) # 57c4 <link>
     e56:	0e055863          	bgez	a0,f46 <linktest+0x230>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	64a2                	ld	s1,8(sp)
     e60:	6902                	ld	s2,0(sp)
     e62:	6105                	addi	sp,sp,32
     e64:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e66:	85ca                	mv	a1,s2
     e68:	00005517          	auipc	a0,0x5
     e6c:	73050513          	addi	a0,a0,1840 # 6598 <malloc+0x9f6>
     e70:	00005097          	auipc	ra,0x5
     e74:	c74080e7          	jalr	-908(ra) # 5ae4 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	00005097          	auipc	ra,0x5
     e7e:	8ea080e7          	jalr	-1814(ra) # 5764 <exit>
    printf("%s: write lf1 failed\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	72c50513          	addi	a0,a0,1836 # 65b0 <malloc+0xa0e>
     e8c:	00005097          	auipc	ra,0x5
     e90:	c58080e7          	jalr	-936(ra) # 5ae4 <printf>
    exit(1);
     e94:	4505                	li	a0,1
     e96:	00005097          	auipc	ra,0x5
     e9a:	8ce080e7          	jalr	-1842(ra) # 5764 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e9e:	85ca                	mv	a1,s2
     ea0:	00005517          	auipc	a0,0x5
     ea4:	72850513          	addi	a0,a0,1832 # 65c8 <malloc+0xa26>
     ea8:	00005097          	auipc	ra,0x5
     eac:	c3c080e7          	jalr	-964(ra) # 5ae4 <printf>
    exit(1);
     eb0:	4505                	li	a0,1
     eb2:	00005097          	auipc	ra,0x5
     eb6:	8b2080e7          	jalr	-1870(ra) # 5764 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     eba:	85ca                	mv	a1,s2
     ebc:	00005517          	auipc	a0,0x5
     ec0:	72c50513          	addi	a0,a0,1836 # 65e8 <malloc+0xa46>
     ec4:	00005097          	auipc	ra,0x5
     ec8:	c20080e7          	jalr	-992(ra) # 5ae4 <printf>
    exit(1);
     ecc:	4505                	li	a0,1
     ece:	00005097          	auipc	ra,0x5
     ed2:	896080e7          	jalr	-1898(ra) # 5764 <exit>
    printf("%s: open lf2 failed\n", s);
     ed6:	85ca                	mv	a1,s2
     ed8:	00005517          	auipc	a0,0x5
     edc:	74050513          	addi	a0,a0,1856 # 6618 <malloc+0xa76>
     ee0:	00005097          	auipc	ra,0x5
     ee4:	c04080e7          	jalr	-1020(ra) # 5ae4 <printf>
    exit(1);
     ee8:	4505                	li	a0,1
     eea:	00005097          	auipc	ra,0x5
     eee:	87a080e7          	jalr	-1926(ra) # 5764 <exit>
    printf("%s: read lf2 failed\n", s);
     ef2:	85ca                	mv	a1,s2
     ef4:	00005517          	auipc	a0,0x5
     ef8:	73c50513          	addi	a0,a0,1852 # 6630 <malloc+0xa8e>
     efc:	00005097          	auipc	ra,0x5
     f00:	be8080e7          	jalr	-1048(ra) # 5ae4 <printf>
    exit(1);
     f04:	4505                	li	a0,1
     f06:	00005097          	auipc	ra,0x5
     f0a:	85e080e7          	jalr	-1954(ra) # 5764 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f0e:	85ca                	mv	a1,s2
     f10:	00005517          	auipc	a0,0x5
     f14:	73850513          	addi	a0,a0,1848 # 6648 <malloc+0xaa6>
     f18:	00005097          	auipc	ra,0x5
     f1c:	bcc080e7          	jalr	-1076(ra) # 5ae4 <printf>
    exit(1);
     f20:	4505                	li	a0,1
     f22:	00005097          	auipc	ra,0x5
     f26:	842080e7          	jalr	-1982(ra) # 5764 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f2a:	85ca                	mv	a1,s2
     f2c:	00005517          	auipc	a0,0x5
     f30:	74450513          	addi	a0,a0,1860 # 6670 <malloc+0xace>
     f34:	00005097          	auipc	ra,0x5
     f38:	bb0080e7          	jalr	-1104(ra) # 5ae4 <printf>
    exit(1);
     f3c:	4505                	li	a0,1
     f3e:	00005097          	auipc	ra,0x5
     f42:	826080e7          	jalr	-2010(ra) # 5764 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f46:	85ca                	mv	a1,s2
     f48:	00005517          	auipc	a0,0x5
     f4c:	75850513          	addi	a0,a0,1880 # 66a0 <malloc+0xafe>
     f50:	00005097          	auipc	ra,0x5
     f54:	b94080e7          	jalr	-1132(ra) # 5ae4 <printf>
    exit(1);
     f58:	4505                	li	a0,1
     f5a:	00005097          	auipc	ra,0x5
     f5e:	80a080e7          	jalr	-2038(ra) # 5764 <exit>

0000000000000f62 <bigdir>:
{
     f62:	715d                	addi	sp,sp,-80
     f64:	e486                	sd	ra,72(sp)
     f66:	e0a2                	sd	s0,64(sp)
     f68:	fc26                	sd	s1,56(sp)
     f6a:	f84a                	sd	s2,48(sp)
     f6c:	f44e                	sd	s3,40(sp)
     f6e:	f052                	sd	s4,32(sp)
     f70:	ec56                	sd	s5,24(sp)
     f72:	e85a                	sd	s6,16(sp)
     f74:	0880                	addi	s0,sp,80
     f76:	89aa                	mv	s3,a0
  unlink("bd");
     f78:	00005517          	auipc	a0,0x5
     f7c:	74850513          	addi	a0,a0,1864 # 66c0 <malloc+0xb1e>
     f80:	00005097          	auipc	ra,0x5
     f84:	834080e7          	jalr	-1996(ra) # 57b4 <unlink>
  fd = open("bd", O_CREATE);
     f88:	20000593          	li	a1,512
     f8c:	00005517          	auipc	a0,0x5
     f90:	73450513          	addi	a0,a0,1844 # 66c0 <malloc+0xb1e>
     f94:	00005097          	auipc	ra,0x5
     f98:	810080e7          	jalr	-2032(ra) # 57a4 <open>
  if(fd < 0){
     f9c:	0c054963          	bltz	a0,106e <bigdir+0x10c>
  close(fd);
     fa0:	00004097          	auipc	ra,0x4
     fa4:	7ec080e7          	jalr	2028(ra) # 578c <close>
  for(i = 0; i < N; i++){
     fa8:	4901                	li	s2,0
    name[0] = 'x';
     faa:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fae:	00005a17          	auipc	s4,0x5
     fb2:	712a0a13          	addi	s4,s4,1810 # 66c0 <malloc+0xb1e>
  for(i = 0; i < N; i++){
     fb6:	1f400b13          	li	s6,500
    name[0] = 'x';
     fba:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fbe:	41f9579b          	sraiw	a5,s2,0x1f
     fc2:	01a7d71b          	srliw	a4,a5,0x1a
     fc6:	012707bb          	addw	a5,a4,s2
     fca:	4067d69b          	sraiw	a3,a5,0x6
     fce:	0306869b          	addiw	a3,a3,48
     fd2:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fd6:	03f7f793          	andi	a5,a5,63
     fda:	9f99                	subw	a5,a5,a4
     fdc:	0307879b          	addiw	a5,a5,48
     fe0:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fe4:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     fe8:	fb040593          	addi	a1,s0,-80
     fec:	8552                	mv	a0,s4
     fee:	00004097          	auipc	ra,0x4
     ff2:	7d6080e7          	jalr	2006(ra) # 57c4 <link>
     ff6:	84aa                	mv	s1,a0
     ff8:	e949                	bnez	a0,108a <bigdir+0x128>
  for(i = 0; i < N; i++){
     ffa:	2905                	addiw	s2,s2,1
     ffc:	fb691fe3          	bne	s2,s6,fba <bigdir+0x58>
  unlink("bd");
    1000:	00005517          	auipc	a0,0x5
    1004:	6c050513          	addi	a0,a0,1728 # 66c0 <malloc+0xb1e>
    1008:	00004097          	auipc	ra,0x4
    100c:	7ac080e7          	jalr	1964(ra) # 57b4 <unlink>
    name[0] = 'x';
    1010:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1014:	1f400a13          	li	s4,500
    name[0] = 'x';
    1018:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    101c:	41f4d79b          	sraiw	a5,s1,0x1f
    1020:	01a7d71b          	srliw	a4,a5,0x1a
    1024:	009707bb          	addw	a5,a4,s1
    1028:	4067d69b          	sraiw	a3,a5,0x6
    102c:	0306869b          	addiw	a3,a3,48
    1030:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1034:	03f7f793          	andi	a5,a5,63
    1038:	9f99                	subw	a5,a5,a4
    103a:	0307879b          	addiw	a5,a5,48
    103e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1042:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1046:	fb040513          	addi	a0,s0,-80
    104a:	00004097          	auipc	ra,0x4
    104e:	76a080e7          	jalr	1898(ra) # 57b4 <unlink>
    1052:	ed21                	bnez	a0,10aa <bigdir+0x148>
  for(i = 0; i < N; i++){
    1054:	2485                	addiw	s1,s1,1
    1056:	fd4491e3          	bne	s1,s4,1018 <bigdir+0xb6>
}
    105a:	60a6                	ld	ra,72(sp)
    105c:	6406                	ld	s0,64(sp)
    105e:	74e2                	ld	s1,56(sp)
    1060:	7942                	ld	s2,48(sp)
    1062:	79a2                	ld	s3,40(sp)
    1064:	7a02                	ld	s4,32(sp)
    1066:	6ae2                	ld	s5,24(sp)
    1068:	6b42                	ld	s6,16(sp)
    106a:	6161                	addi	sp,sp,80
    106c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    106e:	85ce                	mv	a1,s3
    1070:	00005517          	auipc	a0,0x5
    1074:	65850513          	addi	a0,a0,1624 # 66c8 <malloc+0xb26>
    1078:	00005097          	auipc	ra,0x5
    107c:	a6c080e7          	jalr	-1428(ra) # 5ae4 <printf>
    exit(1);
    1080:	4505                	li	a0,1
    1082:	00004097          	auipc	ra,0x4
    1086:	6e2080e7          	jalr	1762(ra) # 5764 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    108a:	fb040613          	addi	a2,s0,-80
    108e:	85ce                	mv	a1,s3
    1090:	00005517          	auipc	a0,0x5
    1094:	65850513          	addi	a0,a0,1624 # 66e8 <malloc+0xb46>
    1098:	00005097          	auipc	ra,0x5
    109c:	a4c080e7          	jalr	-1460(ra) # 5ae4 <printf>
      exit(1);
    10a0:	4505                	li	a0,1
    10a2:	00004097          	auipc	ra,0x4
    10a6:	6c2080e7          	jalr	1730(ra) # 5764 <exit>
      printf("%s: bigdir unlink failed", s);
    10aa:	85ce                	mv	a1,s3
    10ac:	00005517          	auipc	a0,0x5
    10b0:	65c50513          	addi	a0,a0,1628 # 6708 <malloc+0xb66>
    10b4:	00005097          	auipc	ra,0x5
    10b8:	a30080e7          	jalr	-1488(ra) # 5ae4 <printf>
      exit(1);
    10bc:	4505                	li	a0,1
    10be:	00004097          	auipc	ra,0x4
    10c2:	6a6080e7          	jalr	1702(ra) # 5764 <exit>

00000000000010c6 <validatetest>:
{
    10c6:	7139                	addi	sp,sp,-64
    10c8:	fc06                	sd	ra,56(sp)
    10ca:	f822                	sd	s0,48(sp)
    10cc:	f426                	sd	s1,40(sp)
    10ce:	f04a                	sd	s2,32(sp)
    10d0:	ec4e                	sd	s3,24(sp)
    10d2:	e852                	sd	s4,16(sp)
    10d4:	e456                	sd	s5,8(sp)
    10d6:	e05a                	sd	s6,0(sp)
    10d8:	0080                	addi	s0,sp,64
    10da:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10dc:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10de:	00005997          	auipc	s3,0x5
    10e2:	64a98993          	addi	s3,s3,1610 # 6728 <malloc+0xb86>
    10e6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e8:	6a85                	lui	s5,0x1
    10ea:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10ee:	85a6                	mv	a1,s1
    10f0:	854e                	mv	a0,s3
    10f2:	00004097          	auipc	ra,0x4
    10f6:	6d2080e7          	jalr	1746(ra) # 57c4 <link>
    10fa:	01251f63          	bne	a0,s2,1118 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10fe:	94d6                	add	s1,s1,s5
    1100:	ff4497e3          	bne	s1,s4,10ee <validatetest+0x28>
}
    1104:	70e2                	ld	ra,56(sp)
    1106:	7442                	ld	s0,48(sp)
    1108:	74a2                	ld	s1,40(sp)
    110a:	7902                	ld	s2,32(sp)
    110c:	69e2                	ld	s3,24(sp)
    110e:	6a42                	ld	s4,16(sp)
    1110:	6aa2                	ld	s5,8(sp)
    1112:	6b02                	ld	s6,0(sp)
    1114:	6121                	addi	sp,sp,64
    1116:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1118:	85da                	mv	a1,s6
    111a:	00005517          	auipc	a0,0x5
    111e:	61e50513          	addi	a0,a0,1566 # 6738 <malloc+0xb96>
    1122:	00005097          	auipc	ra,0x5
    1126:	9c2080e7          	jalr	-1598(ra) # 5ae4 <printf>
      exit(1);
    112a:	4505                	li	a0,1
    112c:	00004097          	auipc	ra,0x4
    1130:	638080e7          	jalr	1592(ra) # 5764 <exit>

0000000000001134 <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    1134:	7179                	addi	sp,sp,-48
    1136:	f406                	sd	ra,40(sp)
    1138:	f022                	sd	s0,32(sp)
    113a:	ec26                	sd	s1,24(sp)
    113c:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    113e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1142:	00007497          	auipc	s1,0x7
    1146:	3164b483          	ld	s1,790(s1) # 8458 <__SDATA_BEGIN__>
    114a:	fd840593          	addi	a1,s0,-40
    114e:	8526                	mv	a0,s1
    1150:	00004097          	auipc	ra,0x4
    1154:	64c080e7          	jalr	1612(ra) # 579c <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1158:	8526                	mv	a0,s1
    115a:	00004097          	auipc	ra,0x4
    115e:	61a080e7          	jalr	1562(ra) # 5774 <pipe>

  exit(0);
    1162:	4501                	li	a0,0
    1164:	00004097          	auipc	ra,0x4
    1168:	600080e7          	jalr	1536(ra) # 5764 <exit>

000000000000116c <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    116c:	7139                	addi	sp,sp,-64
    116e:	fc06                	sd	ra,56(sp)
    1170:	f822                	sd	s0,48(sp)
    1172:	f426                	sd	s1,40(sp)
    1174:	f04a                	sd	s2,32(sp)
    1176:	ec4e                	sd	s3,24(sp)
    1178:	0080                	addi	s0,sp,64
    117a:	64b1                	lui	s1,0xc
    117c:	35048493          	addi	s1,s1,848 # c350 <buf+0x6c8>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1180:	597d                	li	s2,-1
    1182:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    1186:	00005997          	auipc	s3,0x5
    118a:	e7a98993          	addi	s3,s3,-390 # 6000 <malloc+0x45e>
    argv[0] = (char*)0xffffffff;
    118e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1192:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1196:	fc040593          	addi	a1,s0,-64
    119a:	854e                	mv	a0,s3
    119c:	00004097          	auipc	ra,0x4
    11a0:	600080e7          	jalr	1536(ra) # 579c <exec>
  for(int i = 0; i < 50000; i++){
    11a4:	34fd                	addiw	s1,s1,-1
    11a6:	f4e5                	bnez	s1,118e <badarg+0x22>
  }
  
  exit(0);
    11a8:	4501                	li	a0,0
    11aa:	00004097          	auipc	ra,0x4
    11ae:	5ba080e7          	jalr	1466(ra) # 5764 <exit>

00000000000011b2 <copyinstr2>:
{
    11b2:	7155                	addi	sp,sp,-208
    11b4:	e586                	sd	ra,200(sp)
    11b6:	e1a2                	sd	s0,192(sp)
    11b8:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11ba:	f6840793          	addi	a5,s0,-152
    11be:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11c2:	07800713          	li	a4,120
    11c6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11ca:	0785                	addi	a5,a5,1
    11cc:	fed79de3          	bne	a5,a3,11c6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11d4:	f6840513          	addi	a0,s0,-152
    11d8:	00004097          	auipc	ra,0x4
    11dc:	5dc080e7          	jalr	1500(ra) # 57b4 <unlink>
  if(ret != -1){
    11e0:	57fd                	li	a5,-1
    11e2:	0ef51063          	bne	a0,a5,12c2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11e6:	20100593          	li	a1,513
    11ea:	f6840513          	addi	a0,s0,-152
    11ee:	00004097          	auipc	ra,0x4
    11f2:	5b6080e7          	jalr	1462(ra) # 57a4 <open>
  if(fd != -1){
    11f6:	57fd                	li	a5,-1
    11f8:	0ef51563          	bne	a0,a5,12e2 <copyinstr2+0x130>
  ret = link(b, b);
    11fc:	f6840593          	addi	a1,s0,-152
    1200:	852e                	mv	a0,a1
    1202:	00004097          	auipc	ra,0x4
    1206:	5c2080e7          	jalr	1474(ra) # 57c4 <link>
  if(ret != -1){
    120a:	57fd                	li	a5,-1
    120c:	0ef51b63          	bne	a0,a5,1302 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1210:	00006797          	auipc	a5,0x6
    1214:	6f878793          	addi	a5,a5,1784 # 7908 <malloc+0x1d66>
    1218:	f4f43c23          	sd	a5,-168(s0)
    121c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1220:	f5840593          	addi	a1,s0,-168
    1224:	f6840513          	addi	a0,s0,-152
    1228:	00004097          	auipc	ra,0x4
    122c:	574080e7          	jalr	1396(ra) # 579c <exec>
  if(ret != -1){
    1230:	57fd                	li	a5,-1
    1232:	0ef51963          	bne	a0,a5,1324 <copyinstr2+0x172>
  int pid = fork();
    1236:	00004097          	auipc	ra,0x4
    123a:	526080e7          	jalr	1318(ra) # 575c <fork>
  if(pid < 0){
    123e:	10054363          	bltz	a0,1344 <copyinstr2+0x192>
  if(pid == 0){
    1242:	12051463          	bnez	a0,136a <copyinstr2+0x1b8>
    1246:	00007797          	auipc	a5,0x7
    124a:	32a78793          	addi	a5,a5,810 # 8570 <big.0>
    124e:	00008697          	auipc	a3,0x8
    1252:	32268693          	addi	a3,a3,802 # 9570 <__global_pointer$+0x918>
      big[i] = 'x';
    1256:	07800713          	li	a4,120
    125a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    125e:	0785                	addi	a5,a5,1
    1260:	fed79de3          	bne	a5,a3,125a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1264:	00008797          	auipc	a5,0x8
    1268:	30078623          	sb	zero,780(a5) # 9570 <__global_pointer$+0x918>
    char *args2[] = { big, big, big, 0 };
    126c:	00007797          	auipc	a5,0x7
    1270:	ddc78793          	addi	a5,a5,-548 # 8048 <malloc+0x24a6>
    1274:	6390                	ld	a2,0(a5)
    1276:	6794                	ld	a3,8(a5)
    1278:	6b98                	ld	a4,16(a5)
    127a:	6f9c                	ld	a5,24(a5)
    127c:	f2c43823          	sd	a2,-208(s0)
    1280:	f2d43c23          	sd	a3,-200(s0)
    1284:	f4e43023          	sd	a4,-192(s0)
    1288:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    128c:	f3040593          	addi	a1,s0,-208
    1290:	00005517          	auipc	a0,0x5
    1294:	d7050513          	addi	a0,a0,-656 # 6000 <malloc+0x45e>
    1298:	00004097          	auipc	ra,0x4
    129c:	504080e7          	jalr	1284(ra) # 579c <exec>
    if(ret != -1){
    12a0:	57fd                	li	a5,-1
    12a2:	0af50e63          	beq	a0,a5,135e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12a6:	55fd                	li	a1,-1
    12a8:	00005517          	auipc	a0,0x5
    12ac:	53850513          	addi	a0,a0,1336 # 67e0 <malloc+0xc3e>
    12b0:	00005097          	auipc	ra,0x5
    12b4:	834080e7          	jalr	-1996(ra) # 5ae4 <printf>
      exit(1);
    12b8:	4505                	li	a0,1
    12ba:	00004097          	auipc	ra,0x4
    12be:	4aa080e7          	jalr	1194(ra) # 5764 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12c2:	862a                	mv	a2,a0
    12c4:	f6840593          	addi	a1,s0,-152
    12c8:	00005517          	auipc	a0,0x5
    12cc:	49050513          	addi	a0,a0,1168 # 6758 <malloc+0xbb6>
    12d0:	00005097          	auipc	ra,0x5
    12d4:	814080e7          	jalr	-2028(ra) # 5ae4 <printf>
    exit(1);
    12d8:	4505                	li	a0,1
    12da:	00004097          	auipc	ra,0x4
    12de:	48a080e7          	jalr	1162(ra) # 5764 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12e2:	862a                	mv	a2,a0
    12e4:	f6840593          	addi	a1,s0,-152
    12e8:	00005517          	auipc	a0,0x5
    12ec:	49050513          	addi	a0,a0,1168 # 6778 <malloc+0xbd6>
    12f0:	00004097          	auipc	ra,0x4
    12f4:	7f4080e7          	jalr	2036(ra) # 5ae4 <printf>
    exit(1);
    12f8:	4505                	li	a0,1
    12fa:	00004097          	auipc	ra,0x4
    12fe:	46a080e7          	jalr	1130(ra) # 5764 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1302:	86aa                	mv	a3,a0
    1304:	f6840613          	addi	a2,s0,-152
    1308:	85b2                	mv	a1,a2
    130a:	00005517          	auipc	a0,0x5
    130e:	48e50513          	addi	a0,a0,1166 # 6798 <malloc+0xbf6>
    1312:	00004097          	auipc	ra,0x4
    1316:	7d2080e7          	jalr	2002(ra) # 5ae4 <printf>
    exit(1);
    131a:	4505                	li	a0,1
    131c:	00004097          	auipc	ra,0x4
    1320:	448080e7          	jalr	1096(ra) # 5764 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1324:	567d                	li	a2,-1
    1326:	f6840593          	addi	a1,s0,-152
    132a:	00005517          	auipc	a0,0x5
    132e:	49650513          	addi	a0,a0,1174 # 67c0 <malloc+0xc1e>
    1332:	00004097          	auipc	ra,0x4
    1336:	7b2080e7          	jalr	1970(ra) # 5ae4 <printf>
    exit(1);
    133a:	4505                	li	a0,1
    133c:	00004097          	auipc	ra,0x4
    1340:	428080e7          	jalr	1064(ra) # 5764 <exit>
    printf("fork failed\n");
    1344:	00006517          	auipc	a0,0x6
    1348:	8fc50513          	addi	a0,a0,-1796 # 6c40 <malloc+0x109e>
    134c:	00004097          	auipc	ra,0x4
    1350:	798080e7          	jalr	1944(ra) # 5ae4 <printf>
    exit(1);
    1354:	4505                	li	a0,1
    1356:	00004097          	auipc	ra,0x4
    135a:	40e080e7          	jalr	1038(ra) # 5764 <exit>
    exit(747); // OK
    135e:	2eb00513          	li	a0,747
    1362:	00004097          	auipc	ra,0x4
    1366:	402080e7          	jalr	1026(ra) # 5764 <exit>
  int st = 0;
    136a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    136e:	f5440513          	addi	a0,s0,-172
    1372:	00004097          	auipc	ra,0x4
    1376:	3fa080e7          	jalr	1018(ra) # 576c <wait>
  if(st != 747){
    137a:	f5442703          	lw	a4,-172(s0)
    137e:	2eb00793          	li	a5,747
    1382:	00f71663          	bne	a4,a5,138e <copyinstr2+0x1dc>
}
    1386:	60ae                	ld	ra,200(sp)
    1388:	640e                	ld	s0,192(sp)
    138a:	6169                	addi	sp,sp,208
    138c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    138e:	00005517          	auipc	a0,0x5
    1392:	47a50513          	addi	a0,a0,1146 # 6808 <malloc+0xc66>
    1396:	00004097          	auipc	ra,0x4
    139a:	74e080e7          	jalr	1870(ra) # 5ae4 <printf>
    exit(1);
    139e:	4505                	li	a0,1
    13a0:	00004097          	auipc	ra,0x4
    13a4:	3c4080e7          	jalr	964(ra) # 5764 <exit>

00000000000013a8 <truncate3>:
{
    13a8:	7159                	addi	sp,sp,-112
    13aa:	f486                	sd	ra,104(sp)
    13ac:	f0a2                	sd	s0,96(sp)
    13ae:	eca6                	sd	s1,88(sp)
    13b0:	e8ca                	sd	s2,80(sp)
    13b2:	e4ce                	sd	s3,72(sp)
    13b4:	e0d2                	sd	s4,64(sp)
    13b6:	fc56                	sd	s5,56(sp)
    13b8:	1880                	addi	s0,sp,112
    13ba:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13bc:	60100593          	li	a1,1537
    13c0:	00005517          	auipc	a0,0x5
    13c4:	c9850513          	addi	a0,a0,-872 # 6058 <malloc+0x4b6>
    13c8:	00004097          	auipc	ra,0x4
    13cc:	3dc080e7          	jalr	988(ra) # 57a4 <open>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	3bc080e7          	jalr	956(ra) # 578c <close>
  pid = fork();
    13d8:	00004097          	auipc	ra,0x4
    13dc:	384080e7          	jalr	900(ra) # 575c <fork>
  if(pid < 0){
    13e0:	08054063          	bltz	a0,1460 <truncate3+0xb8>
  if(pid == 0){
    13e4:	e969                	bnez	a0,14b6 <truncate3+0x10e>
    13e6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13ea:	00005a17          	auipc	s4,0x5
    13ee:	c6ea0a13          	addi	s4,s4,-914 # 6058 <malloc+0x4b6>
      int n = write(fd, "1234567890", 10);
    13f2:	00005a97          	auipc	s5,0x5
    13f6:	476a8a93          	addi	s5,s5,1142 # 6868 <malloc+0xcc6>
      int fd = open("truncfile", O_WRONLY);
    13fa:	4585                	li	a1,1
    13fc:	8552                	mv	a0,s4
    13fe:	00004097          	auipc	ra,0x4
    1402:	3a6080e7          	jalr	934(ra) # 57a4 <open>
    1406:	84aa                	mv	s1,a0
      if(fd < 0){
    1408:	06054a63          	bltz	a0,147c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    140c:	4629                	li	a2,10
    140e:	85d6                	mv	a1,s5
    1410:	00004097          	auipc	ra,0x4
    1414:	374080e7          	jalr	884(ra) # 5784 <write>
      if(n != 10){
    1418:	47a9                	li	a5,10
    141a:	06f51f63          	bne	a0,a5,1498 <truncate3+0xf0>
      close(fd);
    141e:	8526                	mv	a0,s1
    1420:	00004097          	auipc	ra,0x4
    1424:	36c080e7          	jalr	876(ra) # 578c <close>
      fd = open("truncfile", O_RDONLY);
    1428:	4581                	li	a1,0
    142a:	8552                	mv	a0,s4
    142c:	00004097          	auipc	ra,0x4
    1430:	378080e7          	jalr	888(ra) # 57a4 <open>
    1434:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1436:	02000613          	li	a2,32
    143a:	f9840593          	addi	a1,s0,-104
    143e:	00004097          	auipc	ra,0x4
    1442:	33e080e7          	jalr	830(ra) # 577c <read>
      close(fd);
    1446:	8526                	mv	a0,s1
    1448:	00004097          	auipc	ra,0x4
    144c:	344080e7          	jalr	836(ra) # 578c <close>
    for(int i = 0; i < 100; i++){
    1450:	39fd                	addiw	s3,s3,-1
    1452:	fa0994e3          	bnez	s3,13fa <truncate3+0x52>
    exit(0);
    1456:	4501                	li	a0,0
    1458:	00004097          	auipc	ra,0x4
    145c:	30c080e7          	jalr	780(ra) # 5764 <exit>
    printf("%s: fork failed\n", s);
    1460:	85ca                	mv	a1,s2
    1462:	00005517          	auipc	a0,0x5
    1466:	3d650513          	addi	a0,a0,982 # 6838 <malloc+0xc96>
    146a:	00004097          	auipc	ra,0x4
    146e:	67a080e7          	jalr	1658(ra) # 5ae4 <printf>
    exit(1);
    1472:	4505                	li	a0,1
    1474:	00004097          	auipc	ra,0x4
    1478:	2f0080e7          	jalr	752(ra) # 5764 <exit>
        printf("%s: open failed\n", s);
    147c:	85ca                	mv	a1,s2
    147e:	00005517          	auipc	a0,0x5
    1482:	3d250513          	addi	a0,a0,978 # 6850 <malloc+0xcae>
    1486:	00004097          	auipc	ra,0x4
    148a:	65e080e7          	jalr	1630(ra) # 5ae4 <printf>
        exit(1);
    148e:	4505                	li	a0,1
    1490:	00004097          	auipc	ra,0x4
    1494:	2d4080e7          	jalr	724(ra) # 5764 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1498:	862a                	mv	a2,a0
    149a:	85ca                	mv	a1,s2
    149c:	00005517          	auipc	a0,0x5
    14a0:	3dc50513          	addi	a0,a0,988 # 6878 <malloc+0xcd6>
    14a4:	00004097          	auipc	ra,0x4
    14a8:	640080e7          	jalr	1600(ra) # 5ae4 <printf>
        exit(1);
    14ac:	4505                	li	a0,1
    14ae:	00004097          	auipc	ra,0x4
    14b2:	2b6080e7          	jalr	694(ra) # 5764 <exit>
    14b6:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ba:	00005a17          	auipc	s4,0x5
    14be:	b9ea0a13          	addi	s4,s4,-1122 # 6058 <malloc+0x4b6>
    int n = write(fd, "xxx", 3);
    14c2:	00005a97          	auipc	s5,0x5
    14c6:	3d6a8a93          	addi	s5,s5,982 # 6898 <malloc+0xcf6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14ca:	60100593          	li	a1,1537
    14ce:	8552                	mv	a0,s4
    14d0:	00004097          	auipc	ra,0x4
    14d4:	2d4080e7          	jalr	724(ra) # 57a4 <open>
    14d8:	84aa                	mv	s1,a0
    if(fd < 0){
    14da:	04054763          	bltz	a0,1528 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14de:	460d                	li	a2,3
    14e0:	85d6                	mv	a1,s5
    14e2:	00004097          	auipc	ra,0x4
    14e6:	2a2080e7          	jalr	674(ra) # 5784 <write>
    if(n != 3){
    14ea:	478d                	li	a5,3
    14ec:	04f51c63          	bne	a0,a5,1544 <truncate3+0x19c>
    close(fd);
    14f0:	8526                	mv	a0,s1
    14f2:	00004097          	auipc	ra,0x4
    14f6:	29a080e7          	jalr	666(ra) # 578c <close>
  for(int i = 0; i < 150; i++){
    14fa:	39fd                	addiw	s3,s3,-1
    14fc:	fc0997e3          	bnez	s3,14ca <truncate3+0x122>
  wait(&xstatus);
    1500:	fbc40513          	addi	a0,s0,-68
    1504:	00004097          	auipc	ra,0x4
    1508:	268080e7          	jalr	616(ra) # 576c <wait>
  unlink("truncfile");
    150c:	00005517          	auipc	a0,0x5
    1510:	b4c50513          	addi	a0,a0,-1204 # 6058 <malloc+0x4b6>
    1514:	00004097          	auipc	ra,0x4
    1518:	2a0080e7          	jalr	672(ra) # 57b4 <unlink>
  exit(xstatus);
    151c:	fbc42503          	lw	a0,-68(s0)
    1520:	00004097          	auipc	ra,0x4
    1524:	244080e7          	jalr	580(ra) # 5764 <exit>
      printf("%s: open failed\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	32650513          	addi	a0,a0,806 # 6850 <malloc+0xcae>
    1532:	00004097          	auipc	ra,0x4
    1536:	5b2080e7          	jalr	1458(ra) # 5ae4 <printf>
      exit(1);
    153a:	4505                	li	a0,1
    153c:	00004097          	auipc	ra,0x4
    1540:	228080e7          	jalr	552(ra) # 5764 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1544:	862a                	mv	a2,a0
    1546:	85ca                	mv	a1,s2
    1548:	00005517          	auipc	a0,0x5
    154c:	35850513          	addi	a0,a0,856 # 68a0 <malloc+0xcfe>
    1550:	00004097          	auipc	ra,0x4
    1554:	594080e7          	jalr	1428(ra) # 5ae4 <printf>
      exit(1);
    1558:	4505                	li	a0,1
    155a:	00004097          	auipc	ra,0x4
    155e:	20a080e7          	jalr	522(ra) # 5764 <exit>

0000000000001562 <exectest>:
{
    1562:	715d                	addi	sp,sp,-80
    1564:	e486                	sd	ra,72(sp)
    1566:	e0a2                	sd	s0,64(sp)
    1568:	fc26                	sd	s1,56(sp)
    156a:	f84a                	sd	s2,48(sp)
    156c:	0880                	addi	s0,sp,80
    156e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1570:	00005797          	auipc	a5,0x5
    1574:	a9078793          	addi	a5,a5,-1392 # 6000 <malloc+0x45e>
    1578:	fcf43023          	sd	a5,-64(s0)
    157c:	00005797          	auipc	a5,0x5
    1580:	34478793          	addi	a5,a5,836 # 68c0 <malloc+0xd1e>
    1584:	fcf43423          	sd	a5,-56(s0)
    1588:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    158c:	00005517          	auipc	a0,0x5
    1590:	33c50513          	addi	a0,a0,828 # 68c8 <malloc+0xd26>
    1594:	00004097          	auipc	ra,0x4
    1598:	220080e7          	jalr	544(ra) # 57b4 <unlink>
  pid = fork();
    159c:	00004097          	auipc	ra,0x4
    15a0:	1c0080e7          	jalr	448(ra) # 575c <fork>
  if(pid < 0) {
    15a4:	04054663          	bltz	a0,15f0 <exectest+0x8e>
    15a8:	84aa                	mv	s1,a0
  if(pid == 0) {
    15aa:	e959                	bnez	a0,1640 <exectest+0xde>
    close(1);
    15ac:	4505                	li	a0,1
    15ae:	00004097          	auipc	ra,0x4
    15b2:	1de080e7          	jalr	478(ra) # 578c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15b6:	20100593          	li	a1,513
    15ba:	00005517          	auipc	a0,0x5
    15be:	30e50513          	addi	a0,a0,782 # 68c8 <malloc+0xd26>
    15c2:	00004097          	auipc	ra,0x4
    15c6:	1e2080e7          	jalr	482(ra) # 57a4 <open>
    if(fd < 0) {
    15ca:	04054163          	bltz	a0,160c <exectest+0xaa>
    if(fd != 1) {
    15ce:	4785                	li	a5,1
    15d0:	04f50c63          	beq	a0,a5,1628 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00005517          	auipc	a0,0x5
    15da:	31250513          	addi	a0,a0,786 # 68e8 <malloc+0xd46>
    15de:	00004097          	auipc	ra,0x4
    15e2:	506080e7          	jalr	1286(ra) # 5ae4 <printf>
      exit(1);
    15e6:	4505                	li	a0,1
    15e8:	00004097          	auipc	ra,0x4
    15ec:	17c080e7          	jalr	380(ra) # 5764 <exit>
     printf("%s: fork failed\n", s);
    15f0:	85ca                	mv	a1,s2
    15f2:	00005517          	auipc	a0,0x5
    15f6:	24650513          	addi	a0,a0,582 # 6838 <malloc+0xc96>
    15fa:	00004097          	auipc	ra,0x4
    15fe:	4ea080e7          	jalr	1258(ra) # 5ae4 <printf>
     exit(1);
    1602:	4505                	li	a0,1
    1604:	00004097          	auipc	ra,0x4
    1608:	160080e7          	jalr	352(ra) # 5764 <exit>
      printf("%s: create failed\n", s);
    160c:	85ca                	mv	a1,s2
    160e:	00005517          	auipc	a0,0x5
    1612:	2c250513          	addi	a0,a0,706 # 68d0 <malloc+0xd2e>
    1616:	00004097          	auipc	ra,0x4
    161a:	4ce080e7          	jalr	1230(ra) # 5ae4 <printf>
      exit(1);
    161e:	4505                	li	a0,1
    1620:	00004097          	auipc	ra,0x4
    1624:	144080e7          	jalr	324(ra) # 5764 <exit>
    if(exec("echo", echoargv) < 0){
    1628:	fc040593          	addi	a1,s0,-64
    162c:	00005517          	auipc	a0,0x5
    1630:	9d450513          	addi	a0,a0,-1580 # 6000 <malloc+0x45e>
    1634:	00004097          	auipc	ra,0x4
    1638:	168080e7          	jalr	360(ra) # 579c <exec>
    163c:	02054163          	bltz	a0,165e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1640:	fdc40513          	addi	a0,s0,-36
    1644:	00004097          	auipc	ra,0x4
    1648:	128080e7          	jalr	296(ra) # 576c <wait>
    164c:	02951763          	bne	a0,s1,167a <exectest+0x118>
  if(xstatus != 0)
    1650:	fdc42503          	lw	a0,-36(s0)
    1654:	cd0d                	beqz	a0,168e <exectest+0x12c>
    exit(xstatus);
    1656:	00004097          	auipc	ra,0x4
    165a:	10e080e7          	jalr	270(ra) # 5764 <exit>
      printf("%s: exec echo failed\n", s);
    165e:	85ca                	mv	a1,s2
    1660:	00005517          	auipc	a0,0x5
    1664:	29850513          	addi	a0,a0,664 # 68f8 <malloc+0xd56>
    1668:	00004097          	auipc	ra,0x4
    166c:	47c080e7          	jalr	1148(ra) # 5ae4 <printf>
      exit(1);
    1670:	4505                	li	a0,1
    1672:	00004097          	auipc	ra,0x4
    1676:	0f2080e7          	jalr	242(ra) # 5764 <exit>
    printf("%s: wait failed!\n", s);
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	29450513          	addi	a0,a0,660 # 6910 <malloc+0xd6e>
    1684:	00004097          	auipc	ra,0x4
    1688:	460080e7          	jalr	1120(ra) # 5ae4 <printf>
    168c:	b7d1                	j	1650 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    168e:	4581                	li	a1,0
    1690:	00005517          	auipc	a0,0x5
    1694:	23850513          	addi	a0,a0,568 # 68c8 <malloc+0xd26>
    1698:	00004097          	auipc	ra,0x4
    169c:	10c080e7          	jalr	268(ra) # 57a4 <open>
  if(fd < 0) {
    16a0:	02054a63          	bltz	a0,16d4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16a4:	4609                	li	a2,2
    16a6:	fb840593          	addi	a1,s0,-72
    16aa:	00004097          	auipc	ra,0x4
    16ae:	0d2080e7          	jalr	210(ra) # 577c <read>
    16b2:	4789                	li	a5,2
    16b4:	02f50e63          	beq	a0,a5,16f0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16b8:	85ca                	mv	a1,s2
    16ba:	00005517          	auipc	a0,0x5
    16be:	cd650513          	addi	a0,a0,-810 # 6390 <malloc+0x7ee>
    16c2:	00004097          	auipc	ra,0x4
    16c6:	422080e7          	jalr	1058(ra) # 5ae4 <printf>
    exit(1);
    16ca:	4505                	li	a0,1
    16cc:	00004097          	auipc	ra,0x4
    16d0:	098080e7          	jalr	152(ra) # 5764 <exit>
    printf("%s: open failed\n", s);
    16d4:	85ca                	mv	a1,s2
    16d6:	00005517          	auipc	a0,0x5
    16da:	17a50513          	addi	a0,a0,378 # 6850 <malloc+0xcae>
    16de:	00004097          	auipc	ra,0x4
    16e2:	406080e7          	jalr	1030(ra) # 5ae4 <printf>
    exit(1);
    16e6:	4505                	li	a0,1
    16e8:	00004097          	auipc	ra,0x4
    16ec:	07c080e7          	jalr	124(ra) # 5764 <exit>
  unlink("echo-ok");
    16f0:	00005517          	auipc	a0,0x5
    16f4:	1d850513          	addi	a0,a0,472 # 68c8 <malloc+0xd26>
    16f8:	00004097          	auipc	ra,0x4
    16fc:	0bc080e7          	jalr	188(ra) # 57b4 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1700:	fb844703          	lbu	a4,-72(s0)
    1704:	04f00793          	li	a5,79
    1708:	00f71863          	bne	a4,a5,1718 <exectest+0x1b6>
    170c:	fb944703          	lbu	a4,-71(s0)
    1710:	04b00793          	li	a5,75
    1714:	02f70063          	beq	a4,a5,1734 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1718:	85ca                	mv	a1,s2
    171a:	00005517          	auipc	a0,0x5
    171e:	20e50513          	addi	a0,a0,526 # 6928 <malloc+0xd86>
    1722:	00004097          	auipc	ra,0x4
    1726:	3c2080e7          	jalr	962(ra) # 5ae4 <printf>
    exit(1);
    172a:	4505                	li	a0,1
    172c:	00004097          	auipc	ra,0x4
    1730:	038080e7          	jalr	56(ra) # 5764 <exit>
    exit(0);
    1734:	4501                	li	a0,0
    1736:	00004097          	auipc	ra,0x4
    173a:	02e080e7          	jalr	46(ra) # 5764 <exit>

000000000000173e <pipe1>:
{
    173e:	711d                	addi	sp,sp,-96
    1740:	ec86                	sd	ra,88(sp)
    1742:	e8a2                	sd	s0,80(sp)
    1744:	e4a6                	sd	s1,72(sp)
    1746:	e0ca                	sd	s2,64(sp)
    1748:	fc4e                	sd	s3,56(sp)
    174a:	f852                	sd	s4,48(sp)
    174c:	f456                	sd	s5,40(sp)
    174e:	f05a                	sd	s6,32(sp)
    1750:	ec5e                	sd	s7,24(sp)
    1752:	1080                	addi	s0,sp,96
    1754:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1756:	fa840513          	addi	a0,s0,-88
    175a:	00004097          	auipc	ra,0x4
    175e:	01a080e7          	jalr	26(ra) # 5774 <pipe>
    1762:	ed25                	bnez	a0,17da <pipe1+0x9c>
    1764:	84aa                	mv	s1,a0
  pid = fork();
    1766:	00004097          	auipc	ra,0x4
    176a:	ff6080e7          	jalr	-10(ra) # 575c <fork>
    176e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1770:	c159                	beqz	a0,17f6 <pipe1+0xb8>
  } else if(pid > 0){
    1772:	16a05e63          	blez	a0,18ee <pipe1+0x1b0>
    close(fds[1]);
    1776:	fac42503          	lw	a0,-84(s0)
    177a:	00004097          	auipc	ra,0x4
    177e:	012080e7          	jalr	18(ra) # 578c <close>
    total = 0;
    1782:	8a26                	mv	s4,s1
    cc = 1;
    1784:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1786:	0000aa97          	auipc	s5,0xa
    178a:	502a8a93          	addi	s5,s5,1282 # bc88 <buf>
      if(cc > sizeof(buf))
    178e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1790:	864e                	mv	a2,s3
    1792:	85d6                	mv	a1,s5
    1794:	fa842503          	lw	a0,-88(s0)
    1798:	00004097          	auipc	ra,0x4
    179c:	fe4080e7          	jalr	-28(ra) # 577c <read>
    17a0:	10a05263          	blez	a0,18a4 <pipe1+0x166>
      for(i = 0; i < n; i++){
    17a4:	0000a717          	auipc	a4,0xa
    17a8:	4e470713          	addi	a4,a4,1252 # bc88 <buf>
    17ac:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b0:	00074683          	lbu	a3,0(a4)
    17b4:	0ff4f793          	andi	a5,s1,255
    17b8:	2485                	addiw	s1,s1,1
    17ba:	0cf69163          	bne	a3,a5,187c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17be:	0705                	addi	a4,a4,1
    17c0:	fec498e3          	bne	s1,a2,17b0 <pipe1+0x72>
      total += n;
    17c4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17c8:	0019979b          	slliw	a5,s3,0x1
    17cc:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d0:	013b7363          	bgeu	s6,s3,17d6 <pipe1+0x98>
        cc = sizeof(buf);
    17d4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17d6:	84b2                	mv	s1,a2
    17d8:	bf65                	j	1790 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17da:	85ca                	mv	a1,s2
    17dc:	00005517          	auipc	a0,0x5
    17e0:	16450513          	addi	a0,a0,356 # 6940 <malloc+0xd9e>
    17e4:	00004097          	auipc	ra,0x4
    17e8:	300080e7          	jalr	768(ra) # 5ae4 <printf>
    exit(1);
    17ec:	4505                	li	a0,1
    17ee:	00004097          	auipc	ra,0x4
    17f2:	f76080e7          	jalr	-138(ra) # 5764 <exit>
    close(fds[0]);
    17f6:	fa842503          	lw	a0,-88(s0)
    17fa:	00004097          	auipc	ra,0x4
    17fe:	f92080e7          	jalr	-110(ra) # 578c <close>
    for(n = 0; n < N; n++){
    1802:	0000ab17          	auipc	s6,0xa
    1806:	486b0b13          	addi	s6,s6,1158 # bc88 <buf>
    180a:	416004bb          	negw	s1,s6
    180e:	0ff4f493          	andi	s1,s1,255
    1812:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1816:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1818:	6a85                	lui	s5,0x1
    181a:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x85>
{
    181e:	87da                	mv	a5,s6
        buf[i] = seq++;
    1820:	0097873b          	addw	a4,a5,s1
    1824:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1828:	0785                	addi	a5,a5,1
    182a:	fef99be3          	bne	s3,a5,1820 <pipe1+0xe2>
        buf[i] = seq++;
    182e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1832:	40900613          	li	a2,1033
    1836:	85de                	mv	a1,s7
    1838:	fac42503          	lw	a0,-84(s0)
    183c:	00004097          	auipc	ra,0x4
    1840:	f48080e7          	jalr	-184(ra) # 5784 <write>
    1844:	40900793          	li	a5,1033
    1848:	00f51c63          	bne	a0,a5,1860 <pipe1+0x122>
    for(n = 0; n < N; n++){
    184c:	24a5                	addiw	s1,s1,9
    184e:	0ff4f493          	andi	s1,s1,255
    1852:	fd5a16e3          	bne	s4,s5,181e <pipe1+0xe0>
    exit(0);
    1856:	4501                	li	a0,0
    1858:	00004097          	auipc	ra,0x4
    185c:	f0c080e7          	jalr	-244(ra) # 5764 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1860:	85ca                	mv	a1,s2
    1862:	00005517          	auipc	a0,0x5
    1866:	0f650513          	addi	a0,a0,246 # 6958 <malloc+0xdb6>
    186a:	00004097          	auipc	ra,0x4
    186e:	27a080e7          	jalr	634(ra) # 5ae4 <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	00004097          	auipc	ra,0x4
    1878:	ef0080e7          	jalr	-272(ra) # 5764 <exit>
          printf("%s: pipe1 oops 2\n", s);
    187c:	85ca                	mv	a1,s2
    187e:	00005517          	auipc	a0,0x5
    1882:	0f250513          	addi	a0,a0,242 # 6970 <malloc+0xdce>
    1886:	00004097          	auipc	ra,0x4
    188a:	25e080e7          	jalr	606(ra) # 5ae4 <printf>
}
    188e:	60e6                	ld	ra,88(sp)
    1890:	6446                	ld	s0,80(sp)
    1892:	64a6                	ld	s1,72(sp)
    1894:	6906                	ld	s2,64(sp)
    1896:	79e2                	ld	s3,56(sp)
    1898:	7a42                	ld	s4,48(sp)
    189a:	7aa2                	ld	s5,40(sp)
    189c:	7b02                	ld	s6,32(sp)
    189e:	6be2                	ld	s7,24(sp)
    18a0:	6125                	addi	sp,sp,96
    18a2:	8082                	ret
    if(total != N * SZ){
    18a4:	6785                	lui	a5,0x1
    18a6:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x85>
    18aa:	02fa0063          	beq	s4,a5,18ca <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18ae:	85d2                	mv	a1,s4
    18b0:	00005517          	auipc	a0,0x5
    18b4:	0d850513          	addi	a0,a0,216 # 6988 <malloc+0xde6>
    18b8:	00004097          	auipc	ra,0x4
    18bc:	22c080e7          	jalr	556(ra) # 5ae4 <printf>
      exit(1);
    18c0:	4505                	li	a0,1
    18c2:	00004097          	auipc	ra,0x4
    18c6:	ea2080e7          	jalr	-350(ra) # 5764 <exit>
    close(fds[0]);
    18ca:	fa842503          	lw	a0,-88(s0)
    18ce:	00004097          	auipc	ra,0x4
    18d2:	ebe080e7          	jalr	-322(ra) # 578c <close>
    wait(&xstatus);
    18d6:	fa440513          	addi	a0,s0,-92
    18da:	00004097          	auipc	ra,0x4
    18de:	e92080e7          	jalr	-366(ra) # 576c <wait>
    exit(xstatus);
    18e2:	fa442503          	lw	a0,-92(s0)
    18e6:	00004097          	auipc	ra,0x4
    18ea:	e7e080e7          	jalr	-386(ra) # 5764 <exit>
    printf("%s: fork() failed\n", s);
    18ee:	85ca                	mv	a1,s2
    18f0:	00005517          	auipc	a0,0x5
    18f4:	0b850513          	addi	a0,a0,184 # 69a8 <malloc+0xe06>
    18f8:	00004097          	auipc	ra,0x4
    18fc:	1ec080e7          	jalr	492(ra) # 5ae4 <printf>
    exit(1);
    1900:	4505                	li	a0,1
    1902:	00004097          	auipc	ra,0x4
    1906:	e62080e7          	jalr	-414(ra) # 5764 <exit>

000000000000190a <exitwait>:
{
    190a:	7139                	addi	sp,sp,-64
    190c:	fc06                	sd	ra,56(sp)
    190e:	f822                	sd	s0,48(sp)
    1910:	f426                	sd	s1,40(sp)
    1912:	f04a                	sd	s2,32(sp)
    1914:	ec4e                	sd	s3,24(sp)
    1916:	e852                	sd	s4,16(sp)
    1918:	0080                	addi	s0,sp,64
    191a:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    191c:	4901                	li	s2,0
    191e:	06400993          	li	s3,100
    pid = fork();
    1922:	00004097          	auipc	ra,0x4
    1926:	e3a080e7          	jalr	-454(ra) # 575c <fork>
    192a:	84aa                	mv	s1,a0
    if(pid < 0){
    192c:	02054a63          	bltz	a0,1960 <exitwait+0x56>
    if(pid){
    1930:	c151                	beqz	a0,19b4 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1932:	fcc40513          	addi	a0,s0,-52
    1936:	00004097          	auipc	ra,0x4
    193a:	e36080e7          	jalr	-458(ra) # 576c <wait>
    193e:	02951f63          	bne	a0,s1,197c <exitwait+0x72>
      if(i != xstate) {
    1942:	fcc42783          	lw	a5,-52(s0)
    1946:	05279963          	bne	a5,s2,1998 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    194a:	2905                	addiw	s2,s2,1
    194c:	fd391be3          	bne	s2,s3,1922 <exitwait+0x18>
}
    1950:	70e2                	ld	ra,56(sp)
    1952:	7442                	ld	s0,48(sp)
    1954:	74a2                	ld	s1,40(sp)
    1956:	7902                	ld	s2,32(sp)
    1958:	69e2                	ld	s3,24(sp)
    195a:	6a42                	ld	s4,16(sp)
    195c:	6121                	addi	sp,sp,64
    195e:	8082                	ret
      printf("%s: fork failed\n", s);
    1960:	85d2                	mv	a1,s4
    1962:	00005517          	auipc	a0,0x5
    1966:	ed650513          	addi	a0,a0,-298 # 6838 <malloc+0xc96>
    196a:	00004097          	auipc	ra,0x4
    196e:	17a080e7          	jalr	378(ra) # 5ae4 <printf>
      exit(1);
    1972:	4505                	li	a0,1
    1974:	00004097          	auipc	ra,0x4
    1978:	df0080e7          	jalr	-528(ra) # 5764 <exit>
        printf("%s: wait wrong pid\n", s);
    197c:	85d2                	mv	a1,s4
    197e:	00005517          	auipc	a0,0x5
    1982:	04250513          	addi	a0,a0,66 # 69c0 <malloc+0xe1e>
    1986:	00004097          	auipc	ra,0x4
    198a:	15e080e7          	jalr	350(ra) # 5ae4 <printf>
        exit(1);
    198e:	4505                	li	a0,1
    1990:	00004097          	auipc	ra,0x4
    1994:	dd4080e7          	jalr	-556(ra) # 5764 <exit>
        printf("%s: wait wrong exit status\n", s);
    1998:	85d2                	mv	a1,s4
    199a:	00005517          	auipc	a0,0x5
    199e:	03e50513          	addi	a0,a0,62 # 69d8 <malloc+0xe36>
    19a2:	00004097          	auipc	ra,0x4
    19a6:	142080e7          	jalr	322(ra) # 5ae4 <printf>
        exit(1);
    19aa:	4505                	li	a0,1
    19ac:	00004097          	auipc	ra,0x4
    19b0:	db8080e7          	jalr	-584(ra) # 5764 <exit>
      exit(i);
    19b4:	854a                	mv	a0,s2
    19b6:	00004097          	auipc	ra,0x4
    19ba:	dae080e7          	jalr	-594(ra) # 5764 <exit>

00000000000019be <twochildren>:
{
    19be:	1101                	addi	sp,sp,-32
    19c0:	ec06                	sd	ra,24(sp)
    19c2:	e822                	sd	s0,16(sp)
    19c4:	e426                	sd	s1,8(sp)
    19c6:	e04a                	sd	s2,0(sp)
    19c8:	1000                	addi	s0,sp,32
    19ca:	892a                	mv	s2,a0
    19cc:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d0:	00004097          	auipc	ra,0x4
    19d4:	d8c080e7          	jalr	-628(ra) # 575c <fork>
    if(pid1 < 0){
    19d8:	02054c63          	bltz	a0,1a10 <twochildren+0x52>
    if(pid1 == 0){
    19dc:	c921                	beqz	a0,1a2c <twochildren+0x6e>
      int pid2 = fork();
    19de:	00004097          	auipc	ra,0x4
    19e2:	d7e080e7          	jalr	-642(ra) # 575c <fork>
      if(pid2 < 0){
    19e6:	04054763          	bltz	a0,1a34 <twochildren+0x76>
      if(pid2 == 0){
    19ea:	c13d                	beqz	a0,1a50 <twochildren+0x92>
        wait(0);
    19ec:	4501                	li	a0,0
    19ee:	00004097          	auipc	ra,0x4
    19f2:	d7e080e7          	jalr	-642(ra) # 576c <wait>
        wait(0);
    19f6:	4501                	li	a0,0
    19f8:	00004097          	auipc	ra,0x4
    19fc:	d74080e7          	jalr	-652(ra) # 576c <wait>
  for(int i = 0; i < 1000; i++){
    1a00:	34fd                	addiw	s1,s1,-1
    1a02:	f4f9                	bnez	s1,19d0 <twochildren+0x12>
}
    1a04:	60e2                	ld	ra,24(sp)
    1a06:	6442                	ld	s0,16(sp)
    1a08:	64a2                	ld	s1,8(sp)
    1a0a:	6902                	ld	s2,0(sp)
    1a0c:	6105                	addi	sp,sp,32
    1a0e:	8082                	ret
      printf("%s: fork failed\n", s);
    1a10:	85ca                	mv	a1,s2
    1a12:	00005517          	auipc	a0,0x5
    1a16:	e2650513          	addi	a0,a0,-474 # 6838 <malloc+0xc96>
    1a1a:	00004097          	auipc	ra,0x4
    1a1e:	0ca080e7          	jalr	202(ra) # 5ae4 <printf>
      exit(1);
    1a22:	4505                	li	a0,1
    1a24:	00004097          	auipc	ra,0x4
    1a28:	d40080e7          	jalr	-704(ra) # 5764 <exit>
      exit(0);
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	d38080e7          	jalr	-712(ra) # 5764 <exit>
        printf("%s: fork failed\n", s);
    1a34:	85ca                	mv	a1,s2
    1a36:	00005517          	auipc	a0,0x5
    1a3a:	e0250513          	addi	a0,a0,-510 # 6838 <malloc+0xc96>
    1a3e:	00004097          	auipc	ra,0x4
    1a42:	0a6080e7          	jalr	166(ra) # 5ae4 <printf>
        exit(1);
    1a46:	4505                	li	a0,1
    1a48:	00004097          	auipc	ra,0x4
    1a4c:	d1c080e7          	jalr	-740(ra) # 5764 <exit>
        exit(0);
    1a50:	00004097          	auipc	ra,0x4
    1a54:	d14080e7          	jalr	-748(ra) # 5764 <exit>

0000000000001a58 <forkfork>:
{
    1a58:	7179                	addi	sp,sp,-48
    1a5a:	f406                	sd	ra,40(sp)
    1a5c:	f022                	sd	s0,32(sp)
    1a5e:	ec26                	sd	s1,24(sp)
    1a60:	1800                	addi	s0,sp,48
    1a62:	84aa                	mv	s1,a0
    int pid = fork();
    1a64:	00004097          	auipc	ra,0x4
    1a68:	cf8080e7          	jalr	-776(ra) # 575c <fork>
    if(pid < 0){
    1a6c:	04054163          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a70:	cd29                	beqz	a0,1aca <forkfork+0x72>
    int pid = fork();
    1a72:	00004097          	auipc	ra,0x4
    1a76:	cea080e7          	jalr	-790(ra) # 575c <fork>
    if(pid < 0){
    1a7a:	02054a63          	bltz	a0,1aae <forkfork+0x56>
    if(pid == 0){
    1a7e:	c531                	beqz	a0,1aca <forkfork+0x72>
    wait(&xstatus);
    1a80:	fdc40513          	addi	a0,s0,-36
    1a84:	00004097          	auipc	ra,0x4
    1a88:	ce8080e7          	jalr	-792(ra) # 576c <wait>
    if(xstatus != 0) {
    1a8c:	fdc42783          	lw	a5,-36(s0)
    1a90:	ebbd                	bnez	a5,1b06 <forkfork+0xae>
    wait(&xstatus);
    1a92:	fdc40513          	addi	a0,s0,-36
    1a96:	00004097          	auipc	ra,0x4
    1a9a:	cd6080e7          	jalr	-810(ra) # 576c <wait>
    if(xstatus != 0) {
    1a9e:	fdc42783          	lw	a5,-36(s0)
    1aa2:	e3b5                	bnez	a5,1b06 <forkfork+0xae>
}
    1aa4:	70a2                	ld	ra,40(sp)
    1aa6:	7402                	ld	s0,32(sp)
    1aa8:	64e2                	ld	s1,24(sp)
    1aaa:	6145                	addi	sp,sp,48
    1aac:	8082                	ret
      printf("%s: fork failed", s);
    1aae:	85a6                	mv	a1,s1
    1ab0:	00005517          	auipc	a0,0x5
    1ab4:	f4850513          	addi	a0,a0,-184 # 69f8 <malloc+0xe56>
    1ab8:	00004097          	auipc	ra,0x4
    1abc:	02c080e7          	jalr	44(ra) # 5ae4 <printf>
      exit(1);
    1ac0:	4505                	li	a0,1
    1ac2:	00004097          	auipc	ra,0x4
    1ac6:	ca2080e7          	jalr	-862(ra) # 5764 <exit>
{
    1aca:	0c800493          	li	s1,200
        int pid1 = fork();
    1ace:	00004097          	auipc	ra,0x4
    1ad2:	c8e080e7          	jalr	-882(ra) # 575c <fork>
        if(pid1 < 0){
    1ad6:	00054f63          	bltz	a0,1af4 <forkfork+0x9c>
        if(pid1 == 0){
    1ada:	c115                	beqz	a0,1afe <forkfork+0xa6>
        wait(0);
    1adc:	4501                	li	a0,0
    1ade:	00004097          	auipc	ra,0x4
    1ae2:	c8e080e7          	jalr	-882(ra) # 576c <wait>
      for(int j = 0; j < 200; j++){
    1ae6:	34fd                	addiw	s1,s1,-1
    1ae8:	f0fd                	bnez	s1,1ace <forkfork+0x76>
      exit(0);
    1aea:	4501                	li	a0,0
    1aec:	00004097          	auipc	ra,0x4
    1af0:	c78080e7          	jalr	-904(ra) # 5764 <exit>
          exit(1);
    1af4:	4505                	li	a0,1
    1af6:	00004097          	auipc	ra,0x4
    1afa:	c6e080e7          	jalr	-914(ra) # 5764 <exit>
          exit(0);
    1afe:	00004097          	auipc	ra,0x4
    1b02:	c66080e7          	jalr	-922(ra) # 5764 <exit>
      printf("%s: fork in child failed", s);
    1b06:	85a6                	mv	a1,s1
    1b08:	00005517          	auipc	a0,0x5
    1b0c:	f0050513          	addi	a0,a0,-256 # 6a08 <malloc+0xe66>
    1b10:	00004097          	auipc	ra,0x4
    1b14:	fd4080e7          	jalr	-44(ra) # 5ae4 <printf>
      exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	00004097          	auipc	ra,0x4
    1b1e:	c4a080e7          	jalr	-950(ra) # 5764 <exit>

0000000000001b22 <reparent2>:
{
    1b22:	1101                	addi	sp,sp,-32
    1b24:	ec06                	sd	ra,24(sp)
    1b26:	e822                	sd	s0,16(sp)
    1b28:	e426                	sd	s1,8(sp)
    1b2a:	1000                	addi	s0,sp,32
    1b2c:	32000493          	li	s1,800
    int pid1 = fork();
    1b30:	00004097          	auipc	ra,0x4
    1b34:	c2c080e7          	jalr	-980(ra) # 575c <fork>
    if(pid1 < 0){
    1b38:	00054f63          	bltz	a0,1b56 <reparent2+0x34>
    if(pid1 == 0){
    1b3c:	c915                	beqz	a0,1b70 <reparent2+0x4e>
    wait(0);
    1b3e:	4501                	li	a0,0
    1b40:	00004097          	auipc	ra,0x4
    1b44:	c2c080e7          	jalr	-980(ra) # 576c <wait>
  for(int i = 0; i < 800; i++){
    1b48:	34fd                	addiw	s1,s1,-1
    1b4a:	f0fd                	bnez	s1,1b30 <reparent2+0xe>
  exit(0);
    1b4c:	4501                	li	a0,0
    1b4e:	00004097          	auipc	ra,0x4
    1b52:	c16080e7          	jalr	-1002(ra) # 5764 <exit>
      printf("fork failed\n");
    1b56:	00005517          	auipc	a0,0x5
    1b5a:	0ea50513          	addi	a0,a0,234 # 6c40 <malloc+0x109e>
    1b5e:	00004097          	auipc	ra,0x4
    1b62:	f86080e7          	jalr	-122(ra) # 5ae4 <printf>
      exit(1);
    1b66:	4505                	li	a0,1
    1b68:	00004097          	auipc	ra,0x4
    1b6c:	bfc080e7          	jalr	-1028(ra) # 5764 <exit>
      fork();
    1b70:	00004097          	auipc	ra,0x4
    1b74:	bec080e7          	jalr	-1044(ra) # 575c <fork>
      fork();
    1b78:	00004097          	auipc	ra,0x4
    1b7c:	be4080e7          	jalr	-1052(ra) # 575c <fork>
      exit(0);
    1b80:	4501                	li	a0,0
    1b82:	00004097          	auipc	ra,0x4
    1b86:	be2080e7          	jalr	-1054(ra) # 5764 <exit>

0000000000001b8a <createdelete>:
{
    1b8a:	7175                	addi	sp,sp,-144
    1b8c:	e506                	sd	ra,136(sp)
    1b8e:	e122                	sd	s0,128(sp)
    1b90:	fca6                	sd	s1,120(sp)
    1b92:	f8ca                	sd	s2,112(sp)
    1b94:	f4ce                	sd	s3,104(sp)
    1b96:	f0d2                	sd	s4,96(sp)
    1b98:	ecd6                	sd	s5,88(sp)
    1b9a:	e8da                	sd	s6,80(sp)
    1b9c:	e4de                	sd	s7,72(sp)
    1b9e:	e0e2                	sd	s8,64(sp)
    1ba0:	fc66                	sd	s9,56(sp)
    1ba2:	0900                	addi	s0,sp,144
    1ba4:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1ba6:	4901                	li	s2,0
    1ba8:	4991                	li	s3,4
    pid = fork();
    1baa:	00004097          	auipc	ra,0x4
    1bae:	bb2080e7          	jalr	-1102(ra) # 575c <fork>
    1bb2:	84aa                	mv	s1,a0
    if(pid < 0){
    1bb4:	02054f63          	bltz	a0,1bf2 <createdelete+0x68>
    if(pid == 0){
    1bb8:	c939                	beqz	a0,1c0e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bba:	2905                	addiw	s2,s2,1
    1bbc:	ff3917e3          	bne	s2,s3,1baa <createdelete+0x20>
    1bc0:	4491                	li	s1,4
    wait(&xstatus);
    1bc2:	f7c40513          	addi	a0,s0,-132
    1bc6:	00004097          	auipc	ra,0x4
    1bca:	ba6080e7          	jalr	-1114(ra) # 576c <wait>
    if(xstatus != 0)
    1bce:	f7c42903          	lw	s2,-132(s0)
    1bd2:	0e091263          	bnez	s2,1cb6 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bd6:	34fd                	addiw	s1,s1,-1
    1bd8:	f4ed                	bnez	s1,1bc2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1bda:	f8040123          	sb	zero,-126(s0)
    1bde:	03000993          	li	s3,48
    1be2:	5a7d                	li	s4,-1
    1be4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1be8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bea:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bec:	07400a93          	li	s5,116
    1bf0:	a29d                	j	1d56 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bf2:	85e6                	mv	a1,s9
    1bf4:	00005517          	auipc	a0,0x5
    1bf8:	04c50513          	addi	a0,a0,76 # 6c40 <malloc+0x109e>
    1bfc:	00004097          	auipc	ra,0x4
    1c00:	ee8080e7          	jalr	-280(ra) # 5ae4 <printf>
      exit(1);
    1c04:	4505                	li	a0,1
    1c06:	00004097          	auipc	ra,0x4
    1c0a:	b5e080e7          	jalr	-1186(ra) # 5764 <exit>
      name[0] = 'p' + pi;
    1c0e:	0709091b          	addiw	s2,s2,112
    1c12:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c16:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c1a:	4951                	li	s2,20
    1c1c:	a015                	j	1c40 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c1e:	85e6                	mv	a1,s9
    1c20:	00005517          	auipc	a0,0x5
    1c24:	cb050513          	addi	a0,a0,-848 # 68d0 <malloc+0xd2e>
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	ebc080e7          	jalr	-324(ra) # 5ae4 <printf>
          exit(1);
    1c30:	4505                	li	a0,1
    1c32:	00004097          	auipc	ra,0x4
    1c36:	b32080e7          	jalr	-1230(ra) # 5764 <exit>
      for(i = 0; i < N; i++){
    1c3a:	2485                	addiw	s1,s1,1
    1c3c:	07248863          	beq	s1,s2,1cac <createdelete+0x122>
        name[1] = '0' + i;
    1c40:	0304879b          	addiw	a5,s1,48
    1c44:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c48:	20200593          	li	a1,514
    1c4c:	f8040513          	addi	a0,s0,-128
    1c50:	00004097          	auipc	ra,0x4
    1c54:	b54080e7          	jalr	-1196(ra) # 57a4 <open>
        if(fd < 0){
    1c58:	fc0543e3          	bltz	a0,1c1e <createdelete+0x94>
        close(fd);
    1c5c:	00004097          	auipc	ra,0x4
    1c60:	b30080e7          	jalr	-1232(ra) # 578c <close>
        if(i > 0 && (i % 2 ) == 0){
    1c64:	fc905be3          	blez	s1,1c3a <createdelete+0xb0>
    1c68:	0014f793          	andi	a5,s1,1
    1c6c:	f7f9                	bnez	a5,1c3a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c6e:	01f4d79b          	srliw	a5,s1,0x1f
    1c72:	9fa5                	addw	a5,a5,s1
    1c74:	4017d79b          	sraiw	a5,a5,0x1
    1c78:	0307879b          	addiw	a5,a5,48
    1c7c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c80:	f8040513          	addi	a0,s0,-128
    1c84:	00004097          	auipc	ra,0x4
    1c88:	b30080e7          	jalr	-1232(ra) # 57b4 <unlink>
    1c8c:	fa0557e3          	bgez	a0,1c3a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c90:	85e6                	mv	a1,s9
    1c92:	00005517          	auipc	a0,0x5
    1c96:	d9650513          	addi	a0,a0,-618 # 6a28 <malloc+0xe86>
    1c9a:	00004097          	auipc	ra,0x4
    1c9e:	e4a080e7          	jalr	-438(ra) # 5ae4 <printf>
            exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	00004097          	auipc	ra,0x4
    1ca8:	ac0080e7          	jalr	-1344(ra) # 5764 <exit>
      exit(0);
    1cac:	4501                	li	a0,0
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	ab6080e7          	jalr	-1354(ra) # 5764 <exit>
      exit(1);
    1cb6:	4505                	li	a0,1
    1cb8:	00004097          	auipc	ra,0x4
    1cbc:	aac080e7          	jalr	-1364(ra) # 5764 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc0:	f8040613          	addi	a2,s0,-128
    1cc4:	85e6                	mv	a1,s9
    1cc6:	00005517          	auipc	a0,0x5
    1cca:	d7a50513          	addi	a0,a0,-646 # 6a40 <malloc+0xe9e>
    1cce:	00004097          	auipc	ra,0x4
    1cd2:	e16080e7          	jalr	-490(ra) # 5ae4 <printf>
        exit(1);
    1cd6:	4505                	li	a0,1
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	a8c080e7          	jalr	-1396(ra) # 5764 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce0:	054b7163          	bgeu	s6,s4,1d22 <createdelete+0x198>
      if(fd >= 0)
    1ce4:	02055a63          	bgez	a0,1d18 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ce8:	2485                	addiw	s1,s1,1
    1cea:	0ff4f493          	andi	s1,s1,255
    1cee:	05548c63          	beq	s1,s5,1d46 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cf2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cf6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1cfa:	4581                	li	a1,0
    1cfc:	f8040513          	addi	a0,s0,-128
    1d00:	00004097          	auipc	ra,0x4
    1d04:	aa4080e7          	jalr	-1372(ra) # 57a4 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d08:	00090463          	beqz	s2,1d10 <createdelete+0x186>
    1d0c:	fd2bdae3          	bge	s7,s2,1ce0 <createdelete+0x156>
    1d10:	fa0548e3          	bltz	a0,1cc0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d14:	014b7963          	bgeu	s6,s4,1d26 <createdelete+0x19c>
        close(fd);
    1d18:	00004097          	auipc	ra,0x4
    1d1c:	a74080e7          	jalr	-1420(ra) # 578c <close>
    1d20:	b7e1                	j	1ce8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d22:	fc0543e3          	bltz	a0,1ce8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d26:	f8040613          	addi	a2,s0,-128
    1d2a:	85e6                	mv	a1,s9
    1d2c:	00005517          	auipc	a0,0x5
    1d30:	d3c50513          	addi	a0,a0,-708 # 6a68 <malloc+0xec6>
    1d34:	00004097          	auipc	ra,0x4
    1d38:	db0080e7          	jalr	-592(ra) # 5ae4 <printf>
        exit(1);
    1d3c:	4505                	li	a0,1
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	a26080e7          	jalr	-1498(ra) # 5764 <exit>
  for(i = 0; i < N; i++){
    1d46:	2905                	addiw	s2,s2,1
    1d48:	2a05                	addiw	s4,s4,1
    1d4a:	2985                	addiw	s3,s3,1
    1d4c:	0ff9f993          	andi	s3,s3,255
    1d50:	47d1                	li	a5,20
    1d52:	02f90a63          	beq	s2,a5,1d86 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d56:	84e2                	mv	s1,s8
    1d58:	bf69                	j	1cf2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d5a:	2905                	addiw	s2,s2,1
    1d5c:	0ff97913          	andi	s2,s2,255
    1d60:	2985                	addiw	s3,s3,1
    1d62:	0ff9f993          	andi	s3,s3,255
    1d66:	03490863          	beq	s2,s4,1d96 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d6a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d6c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d70:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d74:	f8040513          	addi	a0,s0,-128
    1d78:	00004097          	auipc	ra,0x4
    1d7c:	a3c080e7          	jalr	-1476(ra) # 57b4 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d80:	34fd                	addiw	s1,s1,-1
    1d82:	f4ed                	bnez	s1,1d6c <createdelete+0x1e2>
    1d84:	bfd9                	j	1d5a <createdelete+0x1d0>
    1d86:	03000993          	li	s3,48
    1d8a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d8e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d90:	08400a13          	li	s4,132
    1d94:	bfd9                	j	1d6a <createdelete+0x1e0>
}
    1d96:	60aa                	ld	ra,136(sp)
    1d98:	640a                	ld	s0,128(sp)
    1d9a:	74e6                	ld	s1,120(sp)
    1d9c:	7946                	ld	s2,112(sp)
    1d9e:	79a6                	ld	s3,104(sp)
    1da0:	7a06                	ld	s4,96(sp)
    1da2:	6ae6                	ld	s5,88(sp)
    1da4:	6b46                	ld	s6,80(sp)
    1da6:	6ba6                	ld	s7,72(sp)
    1da8:	6c06                	ld	s8,64(sp)
    1daa:	7ce2                	ld	s9,56(sp)
    1dac:	6149                	addi	sp,sp,144
    1dae:	8082                	ret

0000000000001db0 <linkunlink>:
{
    1db0:	711d                	addi	sp,sp,-96
    1db2:	ec86                	sd	ra,88(sp)
    1db4:	e8a2                	sd	s0,80(sp)
    1db6:	e4a6                	sd	s1,72(sp)
    1db8:	e0ca                	sd	s2,64(sp)
    1dba:	fc4e                	sd	s3,56(sp)
    1dbc:	f852                	sd	s4,48(sp)
    1dbe:	f456                	sd	s5,40(sp)
    1dc0:	f05a                	sd	s6,32(sp)
    1dc2:	ec5e                	sd	s7,24(sp)
    1dc4:	e862                	sd	s8,16(sp)
    1dc6:	e466                	sd	s9,8(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	84aa                	mv	s1,a0
  unlink("x");
    1dcc:	00004517          	auipc	a0,0x4
    1dd0:	2a450513          	addi	a0,a0,676 # 6070 <malloc+0x4ce>
    1dd4:	00004097          	auipc	ra,0x4
    1dd8:	9e0080e7          	jalr	-1568(ra) # 57b4 <unlink>
  pid = fork();
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	980080e7          	jalr	-1664(ra) # 575c <fork>
  if(pid < 0){
    1de4:	02054b63          	bltz	a0,1e1a <linkunlink+0x6a>
    1de8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1dea:	4c85                	li	s9,1
    1dec:	e119                	bnez	a0,1df2 <linkunlink+0x42>
    1dee:	06100c93          	li	s9,97
    1df2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1df6:	41c659b7          	lui	s3,0x41c65
    1dfa:	e6d9899b          	addiw	s3,s3,-403
    1dfe:	690d                	lui	s2,0x3
    1e00:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e04:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e06:	4b05                	li	s6,1
      unlink("x");
    1e08:	00004a97          	auipc	s5,0x4
    1e0c:	268a8a93          	addi	s5,s5,616 # 6070 <malloc+0x4ce>
      link("cat", "x");
    1e10:	00005b97          	auipc	s7,0x5
    1e14:	c80b8b93          	addi	s7,s7,-896 # 6a90 <malloc+0xeee>
    1e18:	a825                	j	1e50 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1e1a:	85a6                	mv	a1,s1
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	a1c50513          	addi	a0,a0,-1508 # 6838 <malloc+0xc96>
    1e24:	00004097          	auipc	ra,0x4
    1e28:	cc0080e7          	jalr	-832(ra) # 5ae4 <printf>
    exit(1);
    1e2c:	4505                	li	a0,1
    1e2e:	00004097          	auipc	ra,0x4
    1e32:	936080e7          	jalr	-1738(ra) # 5764 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e36:	20200593          	li	a1,514
    1e3a:	8556                	mv	a0,s5
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	968080e7          	jalr	-1688(ra) # 57a4 <open>
    1e44:	00004097          	auipc	ra,0x4
    1e48:	948080e7          	jalr	-1720(ra) # 578c <close>
  for(i = 0; i < 100; i++){
    1e4c:	34fd                	addiw	s1,s1,-1
    1e4e:	c88d                	beqz	s1,1e80 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e50:	033c87bb          	mulw	a5,s9,s3
    1e54:	012787bb          	addw	a5,a5,s2
    1e58:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e5c:	0347f7bb          	remuw	a5,a5,s4
    1e60:	dbf9                	beqz	a5,1e36 <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e62:	01678863          	beq	a5,s6,1e72 <linkunlink+0xc2>
      unlink("x");
    1e66:	8556                	mv	a0,s5
    1e68:	00004097          	auipc	ra,0x4
    1e6c:	94c080e7          	jalr	-1716(ra) # 57b4 <unlink>
    1e70:	bff1                	j	1e4c <linkunlink+0x9c>
      link("cat", "x");
    1e72:	85d6                	mv	a1,s5
    1e74:	855e                	mv	a0,s7
    1e76:	00004097          	auipc	ra,0x4
    1e7a:	94e080e7          	jalr	-1714(ra) # 57c4 <link>
    1e7e:	b7f9                	j	1e4c <linkunlink+0x9c>
  if(pid)
    1e80:	020c0463          	beqz	s8,1ea8 <linkunlink+0xf8>
    wait(0);
    1e84:	4501                	li	a0,0
    1e86:	00004097          	auipc	ra,0x4
    1e8a:	8e6080e7          	jalr	-1818(ra) # 576c <wait>
}
    1e8e:	60e6                	ld	ra,88(sp)
    1e90:	6446                	ld	s0,80(sp)
    1e92:	64a6                	ld	s1,72(sp)
    1e94:	6906                	ld	s2,64(sp)
    1e96:	79e2                	ld	s3,56(sp)
    1e98:	7a42                	ld	s4,48(sp)
    1e9a:	7aa2                	ld	s5,40(sp)
    1e9c:	7b02                	ld	s6,32(sp)
    1e9e:	6be2                	ld	s7,24(sp)
    1ea0:	6c42                	ld	s8,16(sp)
    1ea2:	6ca2                	ld	s9,8(sp)
    1ea4:	6125                	addi	sp,sp,96
    1ea6:	8082                	ret
    exit(0);
    1ea8:	4501                	li	a0,0
    1eaa:	00004097          	auipc	ra,0x4
    1eae:	8ba080e7          	jalr	-1862(ra) # 5764 <exit>

0000000000001eb2 <manywrites>:
{
    1eb2:	711d                	addi	sp,sp,-96
    1eb4:	ec86                	sd	ra,88(sp)
    1eb6:	e8a2                	sd	s0,80(sp)
    1eb8:	e4a6                	sd	s1,72(sp)
    1eba:	e0ca                	sd	s2,64(sp)
    1ebc:	fc4e                	sd	s3,56(sp)
    1ebe:	f852                	sd	s4,48(sp)
    1ec0:	f456                	sd	s5,40(sp)
    1ec2:	f05a                	sd	s6,32(sp)
    1ec4:	ec5e                	sd	s7,24(sp)
    1ec6:	1080                	addi	s0,sp,96
    1ec8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1eca:	4981                	li	s3,0
    1ecc:	4911                	li	s2,4
    int pid = fork();
    1ece:	00004097          	auipc	ra,0x4
    1ed2:	88e080e7          	jalr	-1906(ra) # 575c <fork>
    1ed6:	84aa                	mv	s1,a0
    if(pid < 0){
    1ed8:	02054963          	bltz	a0,1f0a <manywrites+0x58>
    if(pid == 0){
    1edc:	c521                	beqz	a0,1f24 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1ede:	2985                	addiw	s3,s3,1
    1ee0:	ff2997e3          	bne	s3,s2,1ece <manywrites+0x1c>
    1ee4:	4491                	li	s1,4
    int st = 0;
    1ee6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1eea:	fa840513          	addi	a0,s0,-88
    1eee:	00004097          	auipc	ra,0x4
    1ef2:	87e080e7          	jalr	-1922(ra) # 576c <wait>
    if(st != 0)
    1ef6:	fa842503          	lw	a0,-88(s0)
    1efa:	ed6d                	bnez	a0,1ff4 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    1efc:	34fd                	addiw	s1,s1,-1
    1efe:	f4e5                	bnez	s1,1ee6 <manywrites+0x34>
  exit(0);
    1f00:	4501                	li	a0,0
    1f02:	00004097          	auipc	ra,0x4
    1f06:	862080e7          	jalr	-1950(ra) # 5764 <exit>
      printf("fork failed\n");
    1f0a:	00005517          	auipc	a0,0x5
    1f0e:	d3650513          	addi	a0,a0,-714 # 6c40 <malloc+0x109e>
    1f12:	00004097          	auipc	ra,0x4
    1f16:	bd2080e7          	jalr	-1070(ra) # 5ae4 <printf>
      exit(1);
    1f1a:	4505                	li	a0,1
    1f1c:	00004097          	auipc	ra,0x4
    1f20:	848080e7          	jalr	-1976(ra) # 5764 <exit>
      name[0] = 'b';
    1f24:	06200793          	li	a5,98
    1f28:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1f2c:	0619879b          	addiw	a5,s3,97
    1f30:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1f34:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1f38:	fa840513          	addi	a0,s0,-88
    1f3c:	00004097          	auipc	ra,0x4
    1f40:	878080e7          	jalr	-1928(ra) # 57b4 <unlink>
    1f44:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1f46:	0000ab17          	auipc	s6,0xa
    1f4a:	d42b0b13          	addi	s6,s6,-702 # bc88 <buf>
        for(int i = 0; i < ci+1; i++){
    1f4e:	8a26                	mv	s4,s1
    1f50:	0209ce63          	bltz	s3,1f8c <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    1f54:	20200593          	li	a1,514
    1f58:	fa840513          	addi	a0,s0,-88
    1f5c:	00004097          	auipc	ra,0x4
    1f60:	848080e7          	jalr	-1976(ra) # 57a4 <open>
    1f64:	892a                	mv	s2,a0
          if(fd < 0){
    1f66:	04054763          	bltz	a0,1fb4 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    1f6a:	660d                	lui	a2,0x3
    1f6c:	85da                	mv	a1,s6
    1f6e:	00004097          	auipc	ra,0x4
    1f72:	816080e7          	jalr	-2026(ra) # 5784 <write>
          if(cc != sz){
    1f76:	678d                	lui	a5,0x3
    1f78:	04f51e63          	bne	a0,a5,1fd4 <manywrites+0x122>
          close(fd);
    1f7c:	854a                	mv	a0,s2
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	80e080e7          	jalr	-2034(ra) # 578c <close>
        for(int i = 0; i < ci+1; i++){
    1f86:	2a05                	addiw	s4,s4,1
    1f88:	fd49d6e3          	bge	s3,s4,1f54 <manywrites+0xa2>
        unlink(name);
    1f8c:	fa840513          	addi	a0,s0,-88
    1f90:	00004097          	auipc	ra,0x4
    1f94:	824080e7          	jalr	-2012(ra) # 57b4 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f98:	3bfd                	addiw	s7,s7,-1
    1f9a:	fa0b9ae3          	bnez	s7,1f4e <manywrites+0x9c>
      unlink(name);
    1f9e:	fa840513          	addi	a0,s0,-88
    1fa2:	00004097          	auipc	ra,0x4
    1fa6:	812080e7          	jalr	-2030(ra) # 57b4 <unlink>
      exit(0);
    1faa:	4501                	li	a0,0
    1fac:	00003097          	auipc	ra,0x3
    1fb0:	7b8080e7          	jalr	1976(ra) # 5764 <exit>
            printf("%s: cannot create %s\n", s, name);
    1fb4:	fa840613          	addi	a2,s0,-88
    1fb8:	85d6                	mv	a1,s5
    1fba:	00005517          	auipc	a0,0x5
    1fbe:	ade50513          	addi	a0,a0,-1314 # 6a98 <malloc+0xef6>
    1fc2:	00004097          	auipc	ra,0x4
    1fc6:	b22080e7          	jalr	-1246(ra) # 5ae4 <printf>
            exit(1);
    1fca:	4505                	li	a0,1
    1fcc:	00003097          	auipc	ra,0x3
    1fd0:	798080e7          	jalr	1944(ra) # 5764 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fd4:	86aa                	mv	a3,a0
    1fd6:	660d                	lui	a2,0x3
    1fd8:	85d6                	mv	a1,s5
    1fda:	00004517          	auipc	a0,0x4
    1fde:	0e650513          	addi	a0,a0,230 # 60c0 <malloc+0x51e>
    1fe2:	00004097          	auipc	ra,0x4
    1fe6:	b02080e7          	jalr	-1278(ra) # 5ae4 <printf>
            exit(1);
    1fea:	4505                	li	a0,1
    1fec:	00003097          	auipc	ra,0x3
    1ff0:	778080e7          	jalr	1912(ra) # 5764 <exit>
      exit(st);
    1ff4:	00003097          	auipc	ra,0x3
    1ff8:	770080e7          	jalr	1904(ra) # 5764 <exit>

0000000000001ffc <forktest>:
{
    1ffc:	7179                	addi	sp,sp,-48
    1ffe:	f406                	sd	ra,40(sp)
    2000:	f022                	sd	s0,32(sp)
    2002:	ec26                	sd	s1,24(sp)
    2004:	e84a                	sd	s2,16(sp)
    2006:	e44e                	sd	s3,8(sp)
    2008:	1800                	addi	s0,sp,48
    200a:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    200c:	4481                	li	s1,0
    200e:	3e800913          	li	s2,1000
    pid = fork();
    2012:	00003097          	auipc	ra,0x3
    2016:	74a080e7          	jalr	1866(ra) # 575c <fork>
    if(pid < 0)
    201a:	02054863          	bltz	a0,204a <forktest+0x4e>
    if(pid == 0)
    201e:	c115                	beqz	a0,2042 <forktest+0x46>
  for(n=0; n<N; n++){
    2020:	2485                	addiw	s1,s1,1
    2022:	ff2498e3          	bne	s1,s2,2012 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2026:	85ce                	mv	a1,s3
    2028:	00005517          	auipc	a0,0x5
    202c:	aa050513          	addi	a0,a0,-1376 # 6ac8 <malloc+0xf26>
    2030:	00004097          	auipc	ra,0x4
    2034:	ab4080e7          	jalr	-1356(ra) # 5ae4 <printf>
    exit(1);
    2038:	4505                	li	a0,1
    203a:	00003097          	auipc	ra,0x3
    203e:	72a080e7          	jalr	1834(ra) # 5764 <exit>
      exit(0);
    2042:	00003097          	auipc	ra,0x3
    2046:	722080e7          	jalr	1826(ra) # 5764 <exit>
  if (n == 0) {
    204a:	cc9d                	beqz	s1,2088 <forktest+0x8c>
  if(n == N){
    204c:	3e800793          	li	a5,1000
    2050:	fcf48be3          	beq	s1,a5,2026 <forktest+0x2a>
  for(; n > 0; n--){
    2054:	00905b63          	blez	s1,206a <forktest+0x6e>
    if(wait(0) < 0){
    2058:	4501                	li	a0,0
    205a:	00003097          	auipc	ra,0x3
    205e:	712080e7          	jalr	1810(ra) # 576c <wait>
    2062:	04054163          	bltz	a0,20a4 <forktest+0xa8>
  for(; n > 0; n--){
    2066:	34fd                	addiw	s1,s1,-1
    2068:	f8e5                	bnez	s1,2058 <forktest+0x5c>
  if(wait(0) != -1){
    206a:	4501                	li	a0,0
    206c:	00003097          	auipc	ra,0x3
    2070:	700080e7          	jalr	1792(ra) # 576c <wait>
    2074:	57fd                	li	a5,-1
    2076:	04f51563          	bne	a0,a5,20c0 <forktest+0xc4>
}
    207a:	70a2                	ld	ra,40(sp)
    207c:	7402                	ld	s0,32(sp)
    207e:	64e2                	ld	s1,24(sp)
    2080:	6942                	ld	s2,16(sp)
    2082:	69a2                	ld	s3,8(sp)
    2084:	6145                	addi	sp,sp,48
    2086:	8082                	ret
    printf("%s: no fork at all!\n", s);
    2088:	85ce                	mv	a1,s3
    208a:	00005517          	auipc	a0,0x5
    208e:	a2650513          	addi	a0,a0,-1498 # 6ab0 <malloc+0xf0e>
    2092:	00004097          	auipc	ra,0x4
    2096:	a52080e7          	jalr	-1454(ra) # 5ae4 <printf>
    exit(1);
    209a:	4505                	li	a0,1
    209c:	00003097          	auipc	ra,0x3
    20a0:	6c8080e7          	jalr	1736(ra) # 5764 <exit>
      printf("%s: wait stopped early\n", s);
    20a4:	85ce                	mv	a1,s3
    20a6:	00005517          	auipc	a0,0x5
    20aa:	a4a50513          	addi	a0,a0,-1462 # 6af0 <malloc+0xf4e>
    20ae:	00004097          	auipc	ra,0x4
    20b2:	a36080e7          	jalr	-1482(ra) # 5ae4 <printf>
      exit(1);
    20b6:	4505                	li	a0,1
    20b8:	00003097          	auipc	ra,0x3
    20bc:	6ac080e7          	jalr	1708(ra) # 5764 <exit>
    printf("%s: wait got too many\n", s);
    20c0:	85ce                	mv	a1,s3
    20c2:	00005517          	auipc	a0,0x5
    20c6:	a4650513          	addi	a0,a0,-1466 # 6b08 <malloc+0xf66>
    20ca:	00004097          	auipc	ra,0x4
    20ce:	a1a080e7          	jalr	-1510(ra) # 5ae4 <printf>
    exit(1);
    20d2:	4505                	li	a0,1
    20d4:	00003097          	auipc	ra,0x3
    20d8:	690080e7          	jalr	1680(ra) # 5764 <exit>

00000000000020dc <kernmem>:
{
    20dc:	715d                	addi	sp,sp,-80
    20de:	e486                	sd	ra,72(sp)
    20e0:	e0a2                	sd	s0,64(sp)
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
    20ea:	ec56                	sd	s5,24(sp)
    20ec:	0880                	addi	s0,sp,80
    20ee:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f0:	4485                	li	s1,1
    20f2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    20f4:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    20f6:	69b1                	lui	s3,0xc
    20f8:	35098993          	addi	s3,s3,848 # c350 <buf+0x6c8>
    20fc:	1003d937          	lui	s2,0x1003d
    2100:	090e                	slli	s2,s2,0x3
    2102:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002e7e8>
    pid = fork();
    2106:	00003097          	auipc	ra,0x3
    210a:	656080e7          	jalr	1622(ra) # 575c <fork>
    if(pid < 0){
    210e:	02054963          	bltz	a0,2140 <kernmem+0x64>
    if(pid == 0){
    2112:	c529                	beqz	a0,215c <kernmem+0x80>
    wait(&xstatus);
    2114:	fbc40513          	addi	a0,s0,-68
    2118:	00003097          	auipc	ra,0x3
    211c:	654080e7          	jalr	1620(ra) # 576c <wait>
    if(xstatus != -1)  // did kernel kill child?
    2120:	fbc42783          	lw	a5,-68(s0)
    2124:	05579d63          	bne	a5,s5,217e <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2128:	94ce                	add	s1,s1,s3
    212a:	fd249ee3          	bne	s1,s2,2106 <kernmem+0x2a>
}
    212e:	60a6                	ld	ra,72(sp)
    2130:	6406                	ld	s0,64(sp)
    2132:	74e2                	ld	s1,56(sp)
    2134:	7942                	ld	s2,48(sp)
    2136:	79a2                	ld	s3,40(sp)
    2138:	7a02                	ld	s4,32(sp)
    213a:	6ae2                	ld	s5,24(sp)
    213c:	6161                	addi	sp,sp,80
    213e:	8082                	ret
      printf("%s: fork failed\n", s);
    2140:	85d2                	mv	a1,s4
    2142:	00004517          	auipc	a0,0x4
    2146:	6f650513          	addi	a0,a0,1782 # 6838 <malloc+0xc96>
    214a:	00004097          	auipc	ra,0x4
    214e:	99a080e7          	jalr	-1638(ra) # 5ae4 <printf>
      exit(1);
    2152:	4505                	li	a0,1
    2154:	00003097          	auipc	ra,0x3
    2158:	610080e7          	jalr	1552(ra) # 5764 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    215c:	0004c683          	lbu	a3,0(s1)
    2160:	8626                	mv	a2,s1
    2162:	85d2                	mv	a1,s4
    2164:	00005517          	auipc	a0,0x5
    2168:	9bc50513          	addi	a0,a0,-1604 # 6b20 <malloc+0xf7e>
    216c:	00004097          	auipc	ra,0x4
    2170:	978080e7          	jalr	-1672(ra) # 5ae4 <printf>
      exit(1);
    2174:	4505                	li	a0,1
    2176:	00003097          	auipc	ra,0x3
    217a:	5ee080e7          	jalr	1518(ra) # 5764 <exit>
      exit(1);
    217e:	4505                	li	a0,1
    2180:	00003097          	auipc	ra,0x3
    2184:	5e4080e7          	jalr	1508(ra) # 5764 <exit>

0000000000002188 <bigargtest>:
{
    2188:	7179                	addi	sp,sp,-48
    218a:	f406                	sd	ra,40(sp)
    218c:	f022                	sd	s0,32(sp)
    218e:	ec26                	sd	s1,24(sp)
    2190:	1800                	addi	s0,sp,48
    2192:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2194:	00005517          	auipc	a0,0x5
    2198:	9ac50513          	addi	a0,a0,-1620 # 6b40 <malloc+0xf9e>
    219c:	00003097          	auipc	ra,0x3
    21a0:	618080e7          	jalr	1560(ra) # 57b4 <unlink>
  pid = fork();
    21a4:	00003097          	auipc	ra,0x3
    21a8:	5b8080e7          	jalr	1464(ra) # 575c <fork>
  if(pid == 0){
    21ac:	c121                	beqz	a0,21ec <bigargtest+0x64>
  } else if(pid < 0){
    21ae:	0a054063          	bltz	a0,224e <bigargtest+0xc6>
  wait(&xstatus);
    21b2:	fdc40513          	addi	a0,s0,-36
    21b6:	00003097          	auipc	ra,0x3
    21ba:	5b6080e7          	jalr	1462(ra) # 576c <wait>
  if(xstatus != 0)
    21be:	fdc42503          	lw	a0,-36(s0)
    21c2:	e545                	bnez	a0,226a <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    21c4:	4581                	li	a1,0
    21c6:	00005517          	auipc	a0,0x5
    21ca:	97a50513          	addi	a0,a0,-1670 # 6b40 <malloc+0xf9e>
    21ce:	00003097          	auipc	ra,0x3
    21d2:	5d6080e7          	jalr	1494(ra) # 57a4 <open>
  if(fd < 0){
    21d6:	08054e63          	bltz	a0,2272 <bigargtest+0xea>
  close(fd);
    21da:	00003097          	auipc	ra,0x3
    21de:	5b2080e7          	jalr	1458(ra) # 578c <close>
}
    21e2:	70a2                	ld	ra,40(sp)
    21e4:	7402                	ld	s0,32(sp)
    21e6:	64e2                	ld	s1,24(sp)
    21e8:	6145                	addi	sp,sp,48
    21ea:	8082                	ret
    21ec:	00006797          	auipc	a5,0x6
    21f0:	28478793          	addi	a5,a5,644 # 8470 <args.1>
    21f4:	00006697          	auipc	a3,0x6
    21f8:	37468693          	addi	a3,a3,884 # 8568 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    21fc:	00005717          	auipc	a4,0x5
    2200:	95470713          	addi	a4,a4,-1708 # 6b50 <malloc+0xfae>
    2204:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    2206:	07a1                	addi	a5,a5,8
    2208:	fed79ee3          	bne	a5,a3,2204 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    220c:	00006597          	auipc	a1,0x6
    2210:	26458593          	addi	a1,a1,612 # 8470 <args.1>
    2214:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2218:	00004517          	auipc	a0,0x4
    221c:	de850513          	addi	a0,a0,-536 # 6000 <malloc+0x45e>
    2220:	00003097          	auipc	ra,0x3
    2224:	57c080e7          	jalr	1404(ra) # 579c <exec>
    fd = open("bigarg-ok", O_CREATE);
    2228:	20000593          	li	a1,512
    222c:	00005517          	auipc	a0,0x5
    2230:	91450513          	addi	a0,a0,-1772 # 6b40 <malloc+0xf9e>
    2234:	00003097          	auipc	ra,0x3
    2238:	570080e7          	jalr	1392(ra) # 57a4 <open>
    close(fd);
    223c:	00003097          	auipc	ra,0x3
    2240:	550080e7          	jalr	1360(ra) # 578c <close>
    exit(0);
    2244:	4501                	li	a0,0
    2246:	00003097          	auipc	ra,0x3
    224a:	51e080e7          	jalr	1310(ra) # 5764 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    224e:	85a6                	mv	a1,s1
    2250:	00005517          	auipc	a0,0x5
    2254:	9e050513          	addi	a0,a0,-1568 # 6c30 <malloc+0x108e>
    2258:	00004097          	auipc	ra,0x4
    225c:	88c080e7          	jalr	-1908(ra) # 5ae4 <printf>
    exit(1);
    2260:	4505                	li	a0,1
    2262:	00003097          	auipc	ra,0x3
    2266:	502080e7          	jalr	1282(ra) # 5764 <exit>
    exit(xstatus);
    226a:	00003097          	auipc	ra,0x3
    226e:	4fa080e7          	jalr	1274(ra) # 5764 <exit>
    printf("%s: bigarg test failed!\n", s);
    2272:	85a6                	mv	a1,s1
    2274:	00005517          	auipc	a0,0x5
    2278:	9dc50513          	addi	a0,a0,-1572 # 6c50 <malloc+0x10ae>
    227c:	00004097          	auipc	ra,0x4
    2280:	868080e7          	jalr	-1944(ra) # 5ae4 <printf>
    exit(1);
    2284:	4505                	li	a0,1
    2286:	00003097          	auipc	ra,0x3
    228a:	4de080e7          	jalr	1246(ra) # 5764 <exit>

000000000000228e <stacktest>:
{
    228e:	7179                	addi	sp,sp,-48
    2290:	f406                	sd	ra,40(sp)
    2292:	f022                	sd	s0,32(sp)
    2294:	ec26                	sd	s1,24(sp)
    2296:	1800                	addi	s0,sp,48
    2298:	84aa                	mv	s1,a0
  pid = fork();
    229a:	00003097          	auipc	ra,0x3
    229e:	4c2080e7          	jalr	1218(ra) # 575c <fork>
  if(pid == 0) {
    22a2:	c115                	beqz	a0,22c6 <stacktest+0x38>
  } else if(pid < 0){
    22a4:	04054463          	bltz	a0,22ec <stacktest+0x5e>
  wait(&xstatus);
    22a8:	fdc40513          	addi	a0,s0,-36
    22ac:	00003097          	auipc	ra,0x3
    22b0:	4c0080e7          	jalr	1216(ra) # 576c <wait>
  if(xstatus == -1)  // kernel killed child?
    22b4:	fdc42503          	lw	a0,-36(s0)
    22b8:	57fd                	li	a5,-1
    22ba:	04f50763          	beq	a0,a5,2308 <stacktest+0x7a>
    exit(xstatus);
    22be:	00003097          	auipc	ra,0x3
    22c2:	4a6080e7          	jalr	1190(ra) # 5764 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    22c6:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    22c8:	77fd                	lui	a5,0xfffff
    22ca:	97ba                	add	a5,a5,a4
    22cc:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff0368>
    22d0:	85a6                	mv	a1,s1
    22d2:	00005517          	auipc	a0,0x5
    22d6:	99e50513          	addi	a0,a0,-1634 # 6c70 <malloc+0x10ce>
    22da:	00004097          	auipc	ra,0x4
    22de:	80a080e7          	jalr	-2038(ra) # 5ae4 <printf>
    exit(1);
    22e2:	4505                	li	a0,1
    22e4:	00003097          	auipc	ra,0x3
    22e8:	480080e7          	jalr	1152(ra) # 5764 <exit>
    printf("%s: fork failed\n", s);
    22ec:	85a6                	mv	a1,s1
    22ee:	00004517          	auipc	a0,0x4
    22f2:	54a50513          	addi	a0,a0,1354 # 6838 <malloc+0xc96>
    22f6:	00003097          	auipc	ra,0x3
    22fa:	7ee080e7          	jalr	2030(ra) # 5ae4 <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	00003097          	auipc	ra,0x3
    2304:	464080e7          	jalr	1124(ra) # 5764 <exit>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	00003097          	auipc	ra,0x3
    230e:	45a080e7          	jalr	1114(ra) # 5764 <exit>

0000000000002312 <copyinstr3>:
{
    2312:	7179                	addi	sp,sp,-48
    2314:	f406                	sd	ra,40(sp)
    2316:	f022                	sd	s0,32(sp)
    2318:	ec26                	sd	s1,24(sp)
    231a:	1800                	addi	s0,sp,48
  sbrk(8192);
    231c:	6509                	lui	a0,0x2
    231e:	00003097          	auipc	ra,0x3
    2322:	4ce080e7          	jalr	1230(ra) # 57ec <sbrk>
  uint64 top = (uint64) sbrk(0);
    2326:	4501                	li	a0,0
    2328:	00003097          	auipc	ra,0x3
    232c:	4c4080e7          	jalr	1220(ra) # 57ec <sbrk>
  if((top % PGSIZE) != 0){
    2330:	03451793          	slli	a5,a0,0x34
    2334:	e3c9                	bnez	a5,23b6 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2336:	4501                	li	a0,0
    2338:	00003097          	auipc	ra,0x3
    233c:	4b4080e7          	jalr	1204(ra) # 57ec <sbrk>
  if(top % PGSIZE){
    2340:	03451793          	slli	a5,a0,0x34
    2344:	e3d9                	bnez	a5,23ca <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2346:	fff50493          	addi	s1,a0,-1 # 1fff <forktest+0x3>
  *b = 'x';
    234a:	07800793          	li	a5,120
    234e:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2352:	8526                	mv	a0,s1
    2354:	00003097          	auipc	ra,0x3
    2358:	460080e7          	jalr	1120(ra) # 57b4 <unlink>
  if(ret != -1){
    235c:	57fd                	li	a5,-1
    235e:	08f51363          	bne	a0,a5,23e4 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2362:	20100593          	li	a1,513
    2366:	8526                	mv	a0,s1
    2368:	00003097          	auipc	ra,0x3
    236c:	43c080e7          	jalr	1084(ra) # 57a4 <open>
  if(fd != -1){
    2370:	57fd                	li	a5,-1
    2372:	08f51863          	bne	a0,a5,2402 <copyinstr3+0xf0>
  ret = link(b, b);
    2376:	85a6                	mv	a1,s1
    2378:	8526                	mv	a0,s1
    237a:	00003097          	auipc	ra,0x3
    237e:	44a080e7          	jalr	1098(ra) # 57c4 <link>
  if(ret != -1){
    2382:	57fd                	li	a5,-1
    2384:	08f51e63          	bne	a0,a5,2420 <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2388:	00005797          	auipc	a5,0x5
    238c:	58078793          	addi	a5,a5,1408 # 7908 <malloc+0x1d66>
    2390:	fcf43823          	sd	a5,-48(s0)
    2394:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2398:	fd040593          	addi	a1,s0,-48
    239c:	8526                	mv	a0,s1
    239e:	00003097          	auipc	ra,0x3
    23a2:	3fe080e7          	jalr	1022(ra) # 579c <exec>
  if(ret != -1){
    23a6:	57fd                	li	a5,-1
    23a8:	08f51c63          	bne	a0,a5,2440 <copyinstr3+0x12e>
}
    23ac:	70a2                	ld	ra,40(sp)
    23ae:	7402                	ld	s0,32(sp)
    23b0:	64e2                	ld	s1,24(sp)
    23b2:	6145                	addi	sp,sp,48
    23b4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    23b6:	0347d513          	srli	a0,a5,0x34
    23ba:	6785                	lui	a5,0x1
    23bc:	40a7853b          	subw	a0,a5,a0
    23c0:	00003097          	auipc	ra,0x3
    23c4:	42c080e7          	jalr	1068(ra) # 57ec <sbrk>
    23c8:	b7bd                	j	2336 <copyinstr3+0x24>
    printf("oops\n");
    23ca:	00005517          	auipc	a0,0x5
    23ce:	8ce50513          	addi	a0,a0,-1842 # 6c98 <malloc+0x10f6>
    23d2:	00003097          	auipc	ra,0x3
    23d6:	712080e7          	jalr	1810(ra) # 5ae4 <printf>
    exit(1);
    23da:	4505                	li	a0,1
    23dc:	00003097          	auipc	ra,0x3
    23e0:	388080e7          	jalr	904(ra) # 5764 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    23e4:	862a                	mv	a2,a0
    23e6:	85a6                	mv	a1,s1
    23e8:	00004517          	auipc	a0,0x4
    23ec:	37050513          	addi	a0,a0,880 # 6758 <malloc+0xbb6>
    23f0:	00003097          	auipc	ra,0x3
    23f4:	6f4080e7          	jalr	1780(ra) # 5ae4 <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	00003097          	auipc	ra,0x3
    23fe:	36a080e7          	jalr	874(ra) # 5764 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2402:	862a                	mv	a2,a0
    2404:	85a6                	mv	a1,s1
    2406:	00004517          	auipc	a0,0x4
    240a:	37250513          	addi	a0,a0,882 # 6778 <malloc+0xbd6>
    240e:	00003097          	auipc	ra,0x3
    2412:	6d6080e7          	jalr	1750(ra) # 5ae4 <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	00003097          	auipc	ra,0x3
    241c:	34c080e7          	jalr	844(ra) # 5764 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2420:	86aa                	mv	a3,a0
    2422:	8626                	mv	a2,s1
    2424:	85a6                	mv	a1,s1
    2426:	00004517          	auipc	a0,0x4
    242a:	37250513          	addi	a0,a0,882 # 6798 <malloc+0xbf6>
    242e:	00003097          	auipc	ra,0x3
    2432:	6b6080e7          	jalr	1718(ra) # 5ae4 <printf>
    exit(1);
    2436:	4505                	li	a0,1
    2438:	00003097          	auipc	ra,0x3
    243c:	32c080e7          	jalr	812(ra) # 5764 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2440:	567d                	li	a2,-1
    2442:	85a6                	mv	a1,s1
    2444:	00004517          	auipc	a0,0x4
    2448:	37c50513          	addi	a0,a0,892 # 67c0 <malloc+0xc1e>
    244c:	00003097          	auipc	ra,0x3
    2450:	698080e7          	jalr	1688(ra) # 5ae4 <printf>
    exit(1);
    2454:	4505                	li	a0,1
    2456:	00003097          	auipc	ra,0x3
    245a:	30e080e7          	jalr	782(ra) # 5764 <exit>

000000000000245e <rwsbrk>:
{
    245e:	1101                	addi	sp,sp,-32
    2460:	ec06                	sd	ra,24(sp)
    2462:	e822                	sd	s0,16(sp)
    2464:	e426                	sd	s1,8(sp)
    2466:	e04a                	sd	s2,0(sp)
    2468:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    246a:	6509                	lui	a0,0x2
    246c:	00003097          	auipc	ra,0x3
    2470:	380080e7          	jalr	896(ra) # 57ec <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2474:	57fd                	li	a5,-1
    2476:	06f50363          	beq	a0,a5,24dc <rwsbrk+0x7e>
    247a:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    247c:	7579                	lui	a0,0xffffe
    247e:	00003097          	auipc	ra,0x3
    2482:	36e080e7          	jalr	878(ra) # 57ec <sbrk>
    2486:	57fd                	li	a5,-1
    2488:	06f50763          	beq	a0,a5,24f6 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    248c:	20100593          	li	a1,513
    2490:	00004517          	auipc	a0,0x4
    2494:	87050513          	addi	a0,a0,-1936 # 5d00 <malloc+0x15e>
    2498:	00003097          	auipc	ra,0x3
    249c:	30c080e7          	jalr	780(ra) # 57a4 <open>
    24a0:	892a                	mv	s2,a0
  if(fd < 0){
    24a2:	06054763          	bltz	a0,2510 <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    24a6:	6505                	lui	a0,0x1
    24a8:	94aa                	add	s1,s1,a0
    24aa:	40000613          	li	a2,1024
    24ae:	85a6                	mv	a1,s1
    24b0:	854a                	mv	a0,s2
    24b2:	00003097          	auipc	ra,0x3
    24b6:	2d2080e7          	jalr	722(ra) # 5784 <write>
    24ba:	862a                	mv	a2,a0
  if(n >= 0){
    24bc:	06054763          	bltz	a0,252a <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    24c0:	85a6                	mv	a1,s1
    24c2:	00005517          	auipc	a0,0x5
    24c6:	82e50513          	addi	a0,a0,-2002 # 6cf0 <malloc+0x114e>
    24ca:	00003097          	auipc	ra,0x3
    24ce:	61a080e7          	jalr	1562(ra) # 5ae4 <printf>
    exit(1);
    24d2:	4505                	li	a0,1
    24d4:	00003097          	auipc	ra,0x3
    24d8:	290080e7          	jalr	656(ra) # 5764 <exit>
    printf("sbrk(rwsbrk) failed\n");
    24dc:	00004517          	auipc	a0,0x4
    24e0:	7c450513          	addi	a0,a0,1988 # 6ca0 <malloc+0x10fe>
    24e4:	00003097          	auipc	ra,0x3
    24e8:	600080e7          	jalr	1536(ra) # 5ae4 <printf>
    exit(1);
    24ec:	4505                	li	a0,1
    24ee:	00003097          	auipc	ra,0x3
    24f2:	276080e7          	jalr	630(ra) # 5764 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    24f6:	00004517          	auipc	a0,0x4
    24fa:	7c250513          	addi	a0,a0,1986 # 6cb8 <malloc+0x1116>
    24fe:	00003097          	auipc	ra,0x3
    2502:	5e6080e7          	jalr	1510(ra) # 5ae4 <printf>
    exit(1);
    2506:	4505                	li	a0,1
    2508:	00003097          	auipc	ra,0x3
    250c:	25c080e7          	jalr	604(ra) # 5764 <exit>
    printf("open(rwsbrk) failed\n");
    2510:	00004517          	auipc	a0,0x4
    2514:	7c850513          	addi	a0,a0,1992 # 6cd8 <malloc+0x1136>
    2518:	00003097          	auipc	ra,0x3
    251c:	5cc080e7          	jalr	1484(ra) # 5ae4 <printf>
    exit(1);
    2520:	4505                	li	a0,1
    2522:	00003097          	auipc	ra,0x3
    2526:	242080e7          	jalr	578(ra) # 5764 <exit>
  close(fd);
    252a:	854a                	mv	a0,s2
    252c:	00003097          	auipc	ra,0x3
    2530:	260080e7          	jalr	608(ra) # 578c <close>
  unlink("rwsbrk");
    2534:	00003517          	auipc	a0,0x3
    2538:	7cc50513          	addi	a0,a0,1996 # 5d00 <malloc+0x15e>
    253c:	00003097          	auipc	ra,0x3
    2540:	278080e7          	jalr	632(ra) # 57b4 <unlink>
  fd = open("README", O_RDONLY);
    2544:	4581                	li	a1,0
    2546:	00004517          	auipc	a0,0x4
    254a:	c5250513          	addi	a0,a0,-942 # 6198 <malloc+0x5f6>
    254e:	00003097          	auipc	ra,0x3
    2552:	256080e7          	jalr	598(ra) # 57a4 <open>
    2556:	892a                	mv	s2,a0
  if(fd < 0){
    2558:	02054963          	bltz	a0,258a <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    255c:	4629                	li	a2,10
    255e:	85a6                	mv	a1,s1
    2560:	00003097          	auipc	ra,0x3
    2564:	21c080e7          	jalr	540(ra) # 577c <read>
    2568:	862a                	mv	a2,a0
  if(n >= 0){
    256a:	02054d63          	bltz	a0,25a4 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    256e:	85a6                	mv	a1,s1
    2570:	00004517          	auipc	a0,0x4
    2574:	7b050513          	addi	a0,a0,1968 # 6d20 <malloc+0x117e>
    2578:	00003097          	auipc	ra,0x3
    257c:	56c080e7          	jalr	1388(ra) # 5ae4 <printf>
    exit(1);
    2580:	4505                	li	a0,1
    2582:	00003097          	auipc	ra,0x3
    2586:	1e2080e7          	jalr	482(ra) # 5764 <exit>
    printf("open(rwsbrk) failed\n");
    258a:	00004517          	auipc	a0,0x4
    258e:	74e50513          	addi	a0,a0,1870 # 6cd8 <malloc+0x1136>
    2592:	00003097          	auipc	ra,0x3
    2596:	552080e7          	jalr	1362(ra) # 5ae4 <printf>
    exit(1);
    259a:	4505                	li	a0,1
    259c:	00003097          	auipc	ra,0x3
    25a0:	1c8080e7          	jalr	456(ra) # 5764 <exit>
  close(fd);
    25a4:	854a                	mv	a0,s2
    25a6:	00003097          	auipc	ra,0x3
    25aa:	1e6080e7          	jalr	486(ra) # 578c <close>
  exit(0);
    25ae:	4501                	li	a0,0
    25b0:	00003097          	auipc	ra,0x3
    25b4:	1b4080e7          	jalr	436(ra) # 5764 <exit>

00000000000025b8 <sbrkbasic>:
{
    25b8:	7139                	addi	sp,sp,-64
    25ba:	fc06                	sd	ra,56(sp)
    25bc:	f822                	sd	s0,48(sp)
    25be:	f426                	sd	s1,40(sp)
    25c0:	f04a                	sd	s2,32(sp)
    25c2:	ec4e                	sd	s3,24(sp)
    25c4:	e852                	sd	s4,16(sp)
    25c6:	0080                	addi	s0,sp,64
    25c8:	8a2a                	mv	s4,a0
  pid = fork();
    25ca:	00003097          	auipc	ra,0x3
    25ce:	192080e7          	jalr	402(ra) # 575c <fork>
  if(pid < 0){
    25d2:	02054c63          	bltz	a0,260a <sbrkbasic+0x52>
  if(pid == 0){
    25d6:	ed21                	bnez	a0,262e <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    25d8:	40000537          	lui	a0,0x40000
    25dc:	00003097          	auipc	ra,0x3
    25e0:	210080e7          	jalr	528(ra) # 57ec <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    25e4:	57fd                	li	a5,-1
    25e6:	02f50f63          	beq	a0,a5,2624 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25ea:	400007b7          	lui	a5,0x40000
    25ee:	97aa                	add	a5,a5,a0
      *b = 99;
    25f0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    25f4:	6705                	lui	a4,0x1
      *b = 99;
    25f6:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff1368>
    for(b = a; b < a+TOOMUCH; b += 4096){
    25fa:	953a                	add	a0,a0,a4
    25fc:	fef51de3          	bne	a0,a5,25f6 <sbrkbasic+0x3e>
    exit(1);
    2600:	4505                	li	a0,1
    2602:	00003097          	auipc	ra,0x3
    2606:	162080e7          	jalr	354(ra) # 5764 <exit>
    printf("fork failed in sbrkbasic\n");
    260a:	00004517          	auipc	a0,0x4
    260e:	73e50513          	addi	a0,a0,1854 # 6d48 <malloc+0x11a6>
    2612:	00003097          	auipc	ra,0x3
    2616:	4d2080e7          	jalr	1234(ra) # 5ae4 <printf>
    exit(1);
    261a:	4505                	li	a0,1
    261c:	00003097          	auipc	ra,0x3
    2620:	148080e7          	jalr	328(ra) # 5764 <exit>
      exit(0);
    2624:	4501                	li	a0,0
    2626:	00003097          	auipc	ra,0x3
    262a:	13e080e7          	jalr	318(ra) # 5764 <exit>
  wait(&xstatus);
    262e:	fcc40513          	addi	a0,s0,-52
    2632:	00003097          	auipc	ra,0x3
    2636:	13a080e7          	jalr	314(ra) # 576c <wait>
  if(xstatus == 1){
    263a:	fcc42703          	lw	a4,-52(s0)
    263e:	4785                	li	a5,1
    2640:	00f70d63          	beq	a4,a5,265a <sbrkbasic+0xa2>
  a = sbrk(0);
    2644:	4501                	li	a0,0
    2646:	00003097          	auipc	ra,0x3
    264a:	1a6080e7          	jalr	422(ra) # 57ec <sbrk>
    264e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2650:	4901                	li	s2,0
    2652:	6985                	lui	s3,0x1
    2654:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1d6>
    2658:	a005                	j	2678 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    265a:	85d2                	mv	a1,s4
    265c:	00004517          	auipc	a0,0x4
    2660:	70c50513          	addi	a0,a0,1804 # 6d68 <malloc+0x11c6>
    2664:	00003097          	auipc	ra,0x3
    2668:	480080e7          	jalr	1152(ra) # 5ae4 <printf>
    exit(1);
    266c:	4505                	li	a0,1
    266e:	00003097          	auipc	ra,0x3
    2672:	0f6080e7          	jalr	246(ra) # 5764 <exit>
    a = b + 1;
    2676:	84be                	mv	s1,a5
    b = sbrk(1);
    2678:	4505                	li	a0,1
    267a:	00003097          	auipc	ra,0x3
    267e:	172080e7          	jalr	370(ra) # 57ec <sbrk>
    if(b != a){
    2682:	04951c63          	bne	a0,s1,26da <sbrkbasic+0x122>
    *b = 1;
    2686:	4785                	li	a5,1
    2688:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    268c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2690:	2905                	addiw	s2,s2,1
    2692:	ff3912e3          	bne	s2,s3,2676 <sbrkbasic+0xbe>
  pid = fork();
    2696:	00003097          	auipc	ra,0x3
    269a:	0c6080e7          	jalr	198(ra) # 575c <fork>
    269e:	892a                	mv	s2,a0
  if(pid < 0){
    26a0:	04054d63          	bltz	a0,26fa <sbrkbasic+0x142>
  c = sbrk(1);
    26a4:	4505                	li	a0,1
    26a6:	00003097          	auipc	ra,0x3
    26aa:	146080e7          	jalr	326(ra) # 57ec <sbrk>
  c = sbrk(1);
    26ae:	4505                	li	a0,1
    26b0:	00003097          	auipc	ra,0x3
    26b4:	13c080e7          	jalr	316(ra) # 57ec <sbrk>
  if(c != a + 1){
    26b8:	0489                	addi	s1,s1,2
    26ba:	04a48e63          	beq	s1,a0,2716 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    26be:	85d2                	mv	a1,s4
    26c0:	00004517          	auipc	a0,0x4
    26c4:	70850513          	addi	a0,a0,1800 # 6dc8 <malloc+0x1226>
    26c8:	00003097          	auipc	ra,0x3
    26cc:	41c080e7          	jalr	1052(ra) # 5ae4 <printf>
    exit(1);
    26d0:	4505                	li	a0,1
    26d2:	00003097          	auipc	ra,0x3
    26d6:	092080e7          	jalr	146(ra) # 5764 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    26da:	86aa                	mv	a3,a0
    26dc:	8626                	mv	a2,s1
    26de:	85ca                	mv	a1,s2
    26e0:	00004517          	auipc	a0,0x4
    26e4:	6a850513          	addi	a0,a0,1704 # 6d88 <malloc+0x11e6>
    26e8:	00003097          	auipc	ra,0x3
    26ec:	3fc080e7          	jalr	1020(ra) # 5ae4 <printf>
      exit(1);
    26f0:	4505                	li	a0,1
    26f2:	00003097          	auipc	ra,0x3
    26f6:	072080e7          	jalr	114(ra) # 5764 <exit>
    printf("%s: sbrk test fork failed\n", s);
    26fa:	85d2                	mv	a1,s4
    26fc:	00004517          	auipc	a0,0x4
    2700:	6ac50513          	addi	a0,a0,1708 # 6da8 <malloc+0x1206>
    2704:	00003097          	auipc	ra,0x3
    2708:	3e0080e7          	jalr	992(ra) # 5ae4 <printf>
    exit(1);
    270c:	4505                	li	a0,1
    270e:	00003097          	auipc	ra,0x3
    2712:	056080e7          	jalr	86(ra) # 5764 <exit>
  if(pid == 0)
    2716:	00091763          	bnez	s2,2724 <sbrkbasic+0x16c>
    exit(0);
    271a:	4501                	li	a0,0
    271c:	00003097          	auipc	ra,0x3
    2720:	048080e7          	jalr	72(ra) # 5764 <exit>
  wait(&xstatus);
    2724:	fcc40513          	addi	a0,s0,-52
    2728:	00003097          	auipc	ra,0x3
    272c:	044080e7          	jalr	68(ra) # 576c <wait>
  exit(xstatus);
    2730:	fcc42503          	lw	a0,-52(s0)
    2734:	00003097          	auipc	ra,0x3
    2738:	030080e7          	jalr	48(ra) # 5764 <exit>

000000000000273c <sbrkmuch>:
{
    273c:	7179                	addi	sp,sp,-48
    273e:	f406                	sd	ra,40(sp)
    2740:	f022                	sd	s0,32(sp)
    2742:	ec26                	sd	s1,24(sp)
    2744:	e84a                	sd	s2,16(sp)
    2746:	e44e                	sd	s3,8(sp)
    2748:	e052                	sd	s4,0(sp)
    274a:	1800                	addi	s0,sp,48
    274c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    274e:	4501                	li	a0,0
    2750:	00003097          	auipc	ra,0x3
    2754:	09c080e7          	jalr	156(ra) # 57ec <sbrk>
    2758:	892a                	mv	s2,a0
  a = sbrk(0);
    275a:	4501                	li	a0,0
    275c:	00003097          	auipc	ra,0x3
    2760:	090080e7          	jalr	144(ra) # 57ec <sbrk>
    2764:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2766:	06400537          	lui	a0,0x6400
    276a:	9d05                	subw	a0,a0,s1
    276c:	00003097          	auipc	ra,0x3
    2770:	080080e7          	jalr	128(ra) # 57ec <sbrk>
  if (p != a) {
    2774:	0ca49863          	bne	s1,a0,2844 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2778:	4501                	li	a0,0
    277a:	00003097          	auipc	ra,0x3
    277e:	072080e7          	jalr	114(ra) # 57ec <sbrk>
    2782:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2784:	00a4f963          	bgeu	s1,a0,2796 <sbrkmuch+0x5a>
    *pp = 1;
    2788:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    278a:	6705                	lui	a4,0x1
    *pp = 1;
    278c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2790:	94ba                	add	s1,s1,a4
    2792:	fef4ede3          	bltu	s1,a5,278c <sbrkmuch+0x50>
  *lastaddr = 99;
    2796:	064007b7          	lui	a5,0x6400
    279a:	06300713          	li	a4,99
    279e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1367>
  a = sbrk(0);
    27a2:	4501                	li	a0,0
    27a4:	00003097          	auipc	ra,0x3
    27a8:	048080e7          	jalr	72(ra) # 57ec <sbrk>
    27ac:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    27ae:	757d                	lui	a0,0xfffff
    27b0:	00003097          	auipc	ra,0x3
    27b4:	03c080e7          	jalr	60(ra) # 57ec <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    27b8:	57fd                	li	a5,-1
    27ba:	0af50363          	beq	a0,a5,2860 <sbrkmuch+0x124>
  c = sbrk(0);
    27be:	4501                	li	a0,0
    27c0:	00003097          	auipc	ra,0x3
    27c4:	02c080e7          	jalr	44(ra) # 57ec <sbrk>
  if(c != a - PGSIZE){
    27c8:	77fd                	lui	a5,0xfffff
    27ca:	97a6                	add	a5,a5,s1
    27cc:	0af51863          	bne	a0,a5,287c <sbrkmuch+0x140>
  a = sbrk(0);
    27d0:	4501                	li	a0,0
    27d2:	00003097          	auipc	ra,0x3
    27d6:	01a080e7          	jalr	26(ra) # 57ec <sbrk>
    27da:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    27dc:	6505                	lui	a0,0x1
    27de:	00003097          	auipc	ra,0x3
    27e2:	00e080e7          	jalr	14(ra) # 57ec <sbrk>
    27e6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    27e8:	0aa49a63          	bne	s1,a0,289c <sbrkmuch+0x160>
    27ec:	4501                	li	a0,0
    27ee:	00003097          	auipc	ra,0x3
    27f2:	ffe080e7          	jalr	-2(ra) # 57ec <sbrk>
    27f6:	6785                	lui	a5,0x1
    27f8:	97a6                	add	a5,a5,s1
    27fa:	0af51163          	bne	a0,a5,289c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    27fe:	064007b7          	lui	a5,0x6400
    2802:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f1367>
    2806:	06300793          	li	a5,99
    280a:	0af70963          	beq	a4,a5,28bc <sbrkmuch+0x180>
  a = sbrk(0);
    280e:	4501                	li	a0,0
    2810:	00003097          	auipc	ra,0x3
    2814:	fdc080e7          	jalr	-36(ra) # 57ec <sbrk>
    2818:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    281a:	4501                	li	a0,0
    281c:	00003097          	auipc	ra,0x3
    2820:	fd0080e7          	jalr	-48(ra) # 57ec <sbrk>
    2824:	40a9053b          	subw	a0,s2,a0
    2828:	00003097          	auipc	ra,0x3
    282c:	fc4080e7          	jalr	-60(ra) # 57ec <sbrk>
  if(c != a){
    2830:	0aa49463          	bne	s1,a0,28d8 <sbrkmuch+0x19c>
}
    2834:	70a2                	ld	ra,40(sp)
    2836:	7402                	ld	s0,32(sp)
    2838:	64e2                	ld	s1,24(sp)
    283a:	6942                	ld	s2,16(sp)
    283c:	69a2                	ld	s3,8(sp)
    283e:	6a02                	ld	s4,0(sp)
    2840:	6145                	addi	sp,sp,48
    2842:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2844:	85ce                	mv	a1,s3
    2846:	00004517          	auipc	a0,0x4
    284a:	5a250513          	addi	a0,a0,1442 # 6de8 <malloc+0x1246>
    284e:	00003097          	auipc	ra,0x3
    2852:	296080e7          	jalr	662(ra) # 5ae4 <printf>
    exit(1);
    2856:	4505                	li	a0,1
    2858:	00003097          	auipc	ra,0x3
    285c:	f0c080e7          	jalr	-244(ra) # 5764 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2860:	85ce                	mv	a1,s3
    2862:	00004517          	auipc	a0,0x4
    2866:	5ce50513          	addi	a0,a0,1486 # 6e30 <malloc+0x128e>
    286a:	00003097          	auipc	ra,0x3
    286e:	27a080e7          	jalr	634(ra) # 5ae4 <printf>
    exit(1);
    2872:	4505                	li	a0,1
    2874:	00003097          	auipc	ra,0x3
    2878:	ef0080e7          	jalr	-272(ra) # 5764 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    287c:	86aa                	mv	a3,a0
    287e:	8626                	mv	a2,s1
    2880:	85ce                	mv	a1,s3
    2882:	00004517          	auipc	a0,0x4
    2886:	5ce50513          	addi	a0,a0,1486 # 6e50 <malloc+0x12ae>
    288a:	00003097          	auipc	ra,0x3
    288e:	25a080e7          	jalr	602(ra) # 5ae4 <printf>
    exit(1);
    2892:	4505                	li	a0,1
    2894:	00003097          	auipc	ra,0x3
    2898:	ed0080e7          	jalr	-304(ra) # 5764 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    289c:	86d2                	mv	a3,s4
    289e:	8626                	mv	a2,s1
    28a0:	85ce                	mv	a1,s3
    28a2:	00004517          	auipc	a0,0x4
    28a6:	5ee50513          	addi	a0,a0,1518 # 6e90 <malloc+0x12ee>
    28aa:	00003097          	auipc	ra,0x3
    28ae:	23a080e7          	jalr	570(ra) # 5ae4 <printf>
    exit(1);
    28b2:	4505                	li	a0,1
    28b4:	00003097          	auipc	ra,0x3
    28b8:	eb0080e7          	jalr	-336(ra) # 5764 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    28bc:	85ce                	mv	a1,s3
    28be:	00004517          	auipc	a0,0x4
    28c2:	60250513          	addi	a0,a0,1538 # 6ec0 <malloc+0x131e>
    28c6:	00003097          	auipc	ra,0x3
    28ca:	21e080e7          	jalr	542(ra) # 5ae4 <printf>
    exit(1);
    28ce:	4505                	li	a0,1
    28d0:	00003097          	auipc	ra,0x3
    28d4:	e94080e7          	jalr	-364(ra) # 5764 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    28d8:	86aa                	mv	a3,a0
    28da:	8626                	mv	a2,s1
    28dc:	85ce                	mv	a1,s3
    28de:	00004517          	auipc	a0,0x4
    28e2:	61a50513          	addi	a0,a0,1562 # 6ef8 <malloc+0x1356>
    28e6:	00003097          	auipc	ra,0x3
    28ea:	1fe080e7          	jalr	510(ra) # 5ae4 <printf>
    exit(1);
    28ee:	4505                	li	a0,1
    28f0:	00003097          	auipc	ra,0x3
    28f4:	e74080e7          	jalr	-396(ra) # 5764 <exit>

00000000000028f8 <sbrkarg>:
{
    28f8:	7179                	addi	sp,sp,-48
    28fa:	f406                	sd	ra,40(sp)
    28fc:	f022                	sd	s0,32(sp)
    28fe:	ec26                	sd	s1,24(sp)
    2900:	e84a                	sd	s2,16(sp)
    2902:	e44e                	sd	s3,8(sp)
    2904:	1800                	addi	s0,sp,48
    2906:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2908:	6505                	lui	a0,0x1
    290a:	00003097          	auipc	ra,0x3
    290e:	ee2080e7          	jalr	-286(ra) # 57ec <sbrk>
    2912:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2914:	20100593          	li	a1,513
    2918:	00004517          	auipc	a0,0x4
    291c:	60850513          	addi	a0,a0,1544 # 6f20 <malloc+0x137e>
    2920:	00003097          	auipc	ra,0x3
    2924:	e84080e7          	jalr	-380(ra) # 57a4 <open>
    2928:	84aa                	mv	s1,a0
  unlink("sbrk");
    292a:	00004517          	auipc	a0,0x4
    292e:	5f650513          	addi	a0,a0,1526 # 6f20 <malloc+0x137e>
    2932:	00003097          	auipc	ra,0x3
    2936:	e82080e7          	jalr	-382(ra) # 57b4 <unlink>
  if(fd < 0)  {
    293a:	0404c163          	bltz	s1,297c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    293e:	6605                	lui	a2,0x1
    2940:	85ca                	mv	a1,s2
    2942:	8526                	mv	a0,s1
    2944:	00003097          	auipc	ra,0x3
    2948:	e40080e7          	jalr	-448(ra) # 5784 <write>
    294c:	04054663          	bltz	a0,2998 <sbrkarg+0xa0>
  close(fd);
    2950:	8526                	mv	a0,s1
    2952:	00003097          	auipc	ra,0x3
    2956:	e3a080e7          	jalr	-454(ra) # 578c <close>
  a = sbrk(PGSIZE);
    295a:	6505                	lui	a0,0x1
    295c:	00003097          	auipc	ra,0x3
    2960:	e90080e7          	jalr	-368(ra) # 57ec <sbrk>
  if(pipe((int *) a) != 0){
    2964:	00003097          	auipc	ra,0x3
    2968:	e10080e7          	jalr	-496(ra) # 5774 <pipe>
    296c:	e521                	bnez	a0,29b4 <sbrkarg+0xbc>
}
    296e:	70a2                	ld	ra,40(sp)
    2970:	7402                	ld	s0,32(sp)
    2972:	64e2                	ld	s1,24(sp)
    2974:	6942                	ld	s2,16(sp)
    2976:	69a2                	ld	s3,8(sp)
    2978:	6145                	addi	sp,sp,48
    297a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    297c:	85ce                	mv	a1,s3
    297e:	00004517          	auipc	a0,0x4
    2982:	5aa50513          	addi	a0,a0,1450 # 6f28 <malloc+0x1386>
    2986:	00003097          	auipc	ra,0x3
    298a:	15e080e7          	jalr	350(ra) # 5ae4 <printf>
    exit(1);
    298e:	4505                	li	a0,1
    2990:	00003097          	auipc	ra,0x3
    2994:	dd4080e7          	jalr	-556(ra) # 5764 <exit>
    printf("%s: write sbrk failed\n", s);
    2998:	85ce                	mv	a1,s3
    299a:	00004517          	auipc	a0,0x4
    299e:	5a650513          	addi	a0,a0,1446 # 6f40 <malloc+0x139e>
    29a2:	00003097          	auipc	ra,0x3
    29a6:	142080e7          	jalr	322(ra) # 5ae4 <printf>
    exit(1);
    29aa:	4505                	li	a0,1
    29ac:	00003097          	auipc	ra,0x3
    29b0:	db8080e7          	jalr	-584(ra) # 5764 <exit>
    printf("%s: pipe() failed\n", s);
    29b4:	85ce                	mv	a1,s3
    29b6:	00004517          	auipc	a0,0x4
    29ba:	f8a50513          	addi	a0,a0,-118 # 6940 <malloc+0xd9e>
    29be:	00003097          	auipc	ra,0x3
    29c2:	126080e7          	jalr	294(ra) # 5ae4 <printf>
    exit(1);
    29c6:	4505                	li	a0,1
    29c8:	00003097          	auipc	ra,0x3
    29cc:	d9c080e7          	jalr	-612(ra) # 5764 <exit>

00000000000029d0 <argptest>:
{
    29d0:	1101                	addi	sp,sp,-32
    29d2:	ec06                	sd	ra,24(sp)
    29d4:	e822                	sd	s0,16(sp)
    29d6:	e426                	sd	s1,8(sp)
    29d8:	e04a                	sd	s2,0(sp)
    29da:	1000                	addi	s0,sp,32
    29dc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    29de:	4581                	li	a1,0
    29e0:	00004517          	auipc	a0,0x4
    29e4:	57850513          	addi	a0,a0,1400 # 6f58 <malloc+0x13b6>
    29e8:	00003097          	auipc	ra,0x3
    29ec:	dbc080e7          	jalr	-580(ra) # 57a4 <open>
  if (fd < 0) {
    29f0:	02054b63          	bltz	a0,2a26 <argptest+0x56>
    29f4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    29f6:	4501                	li	a0,0
    29f8:	00003097          	auipc	ra,0x3
    29fc:	df4080e7          	jalr	-524(ra) # 57ec <sbrk>
    2a00:	567d                	li	a2,-1
    2a02:	fff50593          	addi	a1,a0,-1
    2a06:	8526                	mv	a0,s1
    2a08:	00003097          	auipc	ra,0x3
    2a0c:	d74080e7          	jalr	-652(ra) # 577c <read>
  close(fd);
    2a10:	8526                	mv	a0,s1
    2a12:	00003097          	auipc	ra,0x3
    2a16:	d7a080e7          	jalr	-646(ra) # 578c <close>
}
    2a1a:	60e2                	ld	ra,24(sp)
    2a1c:	6442                	ld	s0,16(sp)
    2a1e:	64a2                	ld	s1,8(sp)
    2a20:	6902                	ld	s2,0(sp)
    2a22:	6105                	addi	sp,sp,32
    2a24:	8082                	ret
    printf("%s: open failed\n", s);
    2a26:	85ca                	mv	a1,s2
    2a28:	00004517          	auipc	a0,0x4
    2a2c:	e2850513          	addi	a0,a0,-472 # 6850 <malloc+0xcae>
    2a30:	00003097          	auipc	ra,0x3
    2a34:	0b4080e7          	jalr	180(ra) # 5ae4 <printf>
    exit(1);
    2a38:	4505                	li	a0,1
    2a3a:	00003097          	auipc	ra,0x3
    2a3e:	d2a080e7          	jalr	-726(ra) # 5764 <exit>

0000000000002a42 <sbrkbugs>:
{
    2a42:	1141                	addi	sp,sp,-16
    2a44:	e406                	sd	ra,8(sp)
    2a46:	e022                	sd	s0,0(sp)
    2a48:	0800                	addi	s0,sp,16
  int pid = fork();
    2a4a:	00003097          	auipc	ra,0x3
    2a4e:	d12080e7          	jalr	-750(ra) # 575c <fork>
  if(pid < 0){
    2a52:	02054263          	bltz	a0,2a76 <sbrkbugs+0x34>
  if(pid == 0){
    2a56:	ed0d                	bnez	a0,2a90 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2a58:	00003097          	auipc	ra,0x3
    2a5c:	d94080e7          	jalr	-620(ra) # 57ec <sbrk>
    sbrk(-sz);
    2a60:	40a0053b          	negw	a0,a0
    2a64:	00003097          	auipc	ra,0x3
    2a68:	d88080e7          	jalr	-632(ra) # 57ec <sbrk>
    exit(0);
    2a6c:	4501                	li	a0,0
    2a6e:	00003097          	auipc	ra,0x3
    2a72:	cf6080e7          	jalr	-778(ra) # 5764 <exit>
    printf("fork failed\n");
    2a76:	00004517          	auipc	a0,0x4
    2a7a:	1ca50513          	addi	a0,a0,458 # 6c40 <malloc+0x109e>
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	066080e7          	jalr	102(ra) # 5ae4 <printf>
    exit(1);
    2a86:	4505                	li	a0,1
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	cdc080e7          	jalr	-804(ra) # 5764 <exit>
  wait(0);
    2a90:	4501                	li	a0,0
    2a92:	00003097          	auipc	ra,0x3
    2a96:	cda080e7          	jalr	-806(ra) # 576c <wait>
  pid = fork();
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	cc2080e7          	jalr	-830(ra) # 575c <fork>
  if(pid < 0){
    2aa2:	02054563          	bltz	a0,2acc <sbrkbugs+0x8a>
  if(pid == 0){
    2aa6:	e121                	bnez	a0,2ae6 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	d44080e7          	jalr	-700(ra) # 57ec <sbrk>
    sbrk(-(sz - 3500));
    2ab0:	6785                	lui	a5,0x1
    2ab2:	dac7879b          	addiw	a5,a5,-596
    2ab6:	40a7853b          	subw	a0,a5,a0
    2aba:	00003097          	auipc	ra,0x3
    2abe:	d32080e7          	jalr	-718(ra) # 57ec <sbrk>
    exit(0);
    2ac2:	4501                	li	a0,0
    2ac4:	00003097          	auipc	ra,0x3
    2ac8:	ca0080e7          	jalr	-864(ra) # 5764 <exit>
    printf("fork failed\n");
    2acc:	00004517          	auipc	a0,0x4
    2ad0:	17450513          	addi	a0,a0,372 # 6c40 <malloc+0x109e>
    2ad4:	00003097          	auipc	ra,0x3
    2ad8:	010080e7          	jalr	16(ra) # 5ae4 <printf>
    exit(1);
    2adc:	4505                	li	a0,1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	c86080e7          	jalr	-890(ra) # 5764 <exit>
  wait(0);
    2ae6:	4501                	li	a0,0
    2ae8:	00003097          	auipc	ra,0x3
    2aec:	c84080e7          	jalr	-892(ra) # 576c <wait>
  pid = fork();
    2af0:	00003097          	auipc	ra,0x3
    2af4:	c6c080e7          	jalr	-916(ra) # 575c <fork>
  if(pid < 0){
    2af8:	02054a63          	bltz	a0,2b2c <sbrkbugs+0xea>
  if(pid == 0){
    2afc:	e529                	bnez	a0,2b46 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2afe:	00003097          	auipc	ra,0x3
    2b02:	cee080e7          	jalr	-786(ra) # 57ec <sbrk>
    2b06:	67ad                	lui	a5,0xb
    2b08:	8007879b          	addiw	a5,a5,-2048
    2b0c:	40a7853b          	subw	a0,a5,a0
    2b10:	00003097          	auipc	ra,0x3
    2b14:	cdc080e7          	jalr	-804(ra) # 57ec <sbrk>
    sbrk(-10);
    2b18:	5559                	li	a0,-10
    2b1a:	00003097          	auipc	ra,0x3
    2b1e:	cd2080e7          	jalr	-814(ra) # 57ec <sbrk>
    exit(0);
    2b22:	4501                	li	a0,0
    2b24:	00003097          	auipc	ra,0x3
    2b28:	c40080e7          	jalr	-960(ra) # 5764 <exit>
    printf("fork failed\n");
    2b2c:	00004517          	auipc	a0,0x4
    2b30:	11450513          	addi	a0,a0,276 # 6c40 <malloc+0x109e>
    2b34:	00003097          	auipc	ra,0x3
    2b38:	fb0080e7          	jalr	-80(ra) # 5ae4 <printf>
    exit(1);
    2b3c:	4505                	li	a0,1
    2b3e:	00003097          	auipc	ra,0x3
    2b42:	c26080e7          	jalr	-986(ra) # 5764 <exit>
  wait(0);
    2b46:	4501                	li	a0,0
    2b48:	00003097          	auipc	ra,0x3
    2b4c:	c24080e7          	jalr	-988(ra) # 576c <wait>
  exit(0);
    2b50:	4501                	li	a0,0
    2b52:	00003097          	auipc	ra,0x3
    2b56:	c12080e7          	jalr	-1006(ra) # 5764 <exit>

0000000000002b5a <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    2b5a:	715d                	addi	sp,sp,-80
    2b5c:	e486                	sd	ra,72(sp)
    2b5e:	e0a2                	sd	s0,64(sp)
    2b60:	fc26                	sd	s1,56(sp)
    2b62:	f84a                	sd	s2,48(sp)
    2b64:	f44e                	sd	s3,40(sp)
    2b66:	f052                	sd	s4,32(sp)
    2b68:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2b6a:	4901                	li	s2,0
    2b6c:	49bd                	li	s3,15
    int pid = fork();
    2b6e:	00003097          	auipc	ra,0x3
    2b72:	bee080e7          	jalr	-1042(ra) # 575c <fork>
    2b76:	84aa                	mv	s1,a0
    if(pid < 0){
    2b78:	02054063          	bltz	a0,2b98 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    2b7c:	c91d                	beqz	a0,2bb2 <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    2b7e:	4501                	li	a0,0
    2b80:	00003097          	auipc	ra,0x3
    2b84:	bec080e7          	jalr	-1044(ra) # 576c <wait>
  for(int avail = 0; avail < 15; avail++){
    2b88:	2905                	addiw	s2,s2,1
    2b8a:	ff3912e3          	bne	s2,s3,2b6e <execout+0x14>
    }
  }

  exit(0);
    2b8e:	4501                	li	a0,0
    2b90:	00003097          	auipc	ra,0x3
    2b94:	bd4080e7          	jalr	-1068(ra) # 5764 <exit>
      printf("fork failed\n");
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	0a850513          	addi	a0,a0,168 # 6c40 <malloc+0x109e>
    2ba0:	00003097          	auipc	ra,0x3
    2ba4:	f44080e7          	jalr	-188(ra) # 5ae4 <printf>
      exit(1);
    2ba8:	4505                	li	a0,1
    2baa:	00003097          	auipc	ra,0x3
    2bae:	bba080e7          	jalr	-1094(ra) # 5764 <exit>
        if(a == 0xffffffffffffffffLL)
    2bb2:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2bb4:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2bb6:	6505                	lui	a0,0x1
    2bb8:	00003097          	auipc	ra,0x3
    2bbc:	c34080e7          	jalr	-972(ra) # 57ec <sbrk>
        if(a == 0xffffffffffffffffLL)
    2bc0:	01350763          	beq	a0,s3,2bce <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2bc4:	6785                	lui	a5,0x1
    2bc6:	953e                	add	a0,a0,a5
    2bc8:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x9d>
      while(1){
    2bcc:	b7ed                	j	2bb6 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2bce:	01205a63          	blez	s2,2be2 <execout+0x88>
        sbrk(-4096);
    2bd2:	757d                	lui	a0,0xfffff
    2bd4:	00003097          	auipc	ra,0x3
    2bd8:	c18080e7          	jalr	-1000(ra) # 57ec <sbrk>
      for(int i = 0; i < avail; i++)
    2bdc:	2485                	addiw	s1,s1,1
    2bde:	ff249ae3          	bne	s1,s2,2bd2 <execout+0x78>
      close(1);
    2be2:	4505                	li	a0,1
    2be4:	00003097          	auipc	ra,0x3
    2be8:	ba8080e7          	jalr	-1112(ra) # 578c <close>
      char *args[] = { "echo", "x", 0 };
    2bec:	00003517          	auipc	a0,0x3
    2bf0:	41450513          	addi	a0,a0,1044 # 6000 <malloc+0x45e>
    2bf4:	faa43c23          	sd	a0,-72(s0)
    2bf8:	00003797          	auipc	a5,0x3
    2bfc:	47878793          	addi	a5,a5,1144 # 6070 <malloc+0x4ce>
    2c00:	fcf43023          	sd	a5,-64(s0)
    2c04:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2c08:	fb840593          	addi	a1,s0,-72
    2c0c:	00003097          	auipc	ra,0x3
    2c10:	b90080e7          	jalr	-1136(ra) # 579c <exec>
      exit(0);
    2c14:	4501                	li	a0,0
    2c16:	00003097          	auipc	ra,0x3
    2c1a:	b4e080e7          	jalr	-1202(ra) # 5764 <exit>

0000000000002c1e <fourteen>:
{
    2c1e:	1101                	addi	sp,sp,-32
    2c20:	ec06                	sd	ra,24(sp)
    2c22:	e822                	sd	s0,16(sp)
    2c24:	e426                	sd	s1,8(sp)
    2c26:	1000                	addi	s0,sp,32
    2c28:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	50650513          	addi	a0,a0,1286 # 7130 <malloc+0x158e>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	b9a080e7          	jalr	-1126(ra) # 57cc <mkdir>
    2c3a:	e165                	bnez	a0,2d1a <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2c3c:	00004517          	auipc	a0,0x4
    2c40:	34c50513          	addi	a0,a0,844 # 6f88 <malloc+0x13e6>
    2c44:	00003097          	auipc	ra,0x3
    2c48:	b88080e7          	jalr	-1144(ra) # 57cc <mkdir>
    2c4c:	e56d                	bnez	a0,2d36 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2c4e:	20000593          	li	a1,512
    2c52:	00004517          	auipc	a0,0x4
    2c56:	38e50513          	addi	a0,a0,910 # 6fe0 <malloc+0x143e>
    2c5a:	00003097          	auipc	ra,0x3
    2c5e:	b4a080e7          	jalr	-1206(ra) # 57a4 <open>
  if(fd < 0){
    2c62:	0e054863          	bltz	a0,2d52 <fourteen+0x134>
  close(fd);
    2c66:	00003097          	auipc	ra,0x3
    2c6a:	b26080e7          	jalr	-1242(ra) # 578c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2c6e:	4581                	li	a1,0
    2c70:	00004517          	auipc	a0,0x4
    2c74:	3e850513          	addi	a0,a0,1000 # 7058 <malloc+0x14b6>
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	b2c080e7          	jalr	-1236(ra) # 57a4 <open>
  if(fd < 0){
    2c80:	0e054763          	bltz	a0,2d6e <fourteen+0x150>
  close(fd);
    2c84:	00003097          	auipc	ra,0x3
    2c88:	b08080e7          	jalr	-1272(ra) # 578c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	43c50513          	addi	a0,a0,1084 # 70c8 <malloc+0x1526>
    2c94:	00003097          	auipc	ra,0x3
    2c98:	b38080e7          	jalr	-1224(ra) # 57cc <mkdir>
    2c9c:	c57d                	beqz	a0,2d8a <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    2c9e:	00004517          	auipc	a0,0x4
    2ca2:	48250513          	addi	a0,a0,1154 # 7120 <malloc+0x157e>
    2ca6:	00003097          	auipc	ra,0x3
    2caa:	b26080e7          	jalr	-1242(ra) # 57cc <mkdir>
    2cae:	cd65                	beqz	a0,2da6 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2cb0:	00004517          	auipc	a0,0x4
    2cb4:	47050513          	addi	a0,a0,1136 # 7120 <malloc+0x157e>
    2cb8:	00003097          	auipc	ra,0x3
    2cbc:	afc080e7          	jalr	-1284(ra) # 57b4 <unlink>
  unlink("12345678901234/12345678901234");
    2cc0:	00004517          	auipc	a0,0x4
    2cc4:	40850513          	addi	a0,a0,1032 # 70c8 <malloc+0x1526>
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	aec080e7          	jalr	-1300(ra) # 57b4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2cd0:	00004517          	auipc	a0,0x4
    2cd4:	38850513          	addi	a0,a0,904 # 7058 <malloc+0x14b6>
    2cd8:	00003097          	auipc	ra,0x3
    2cdc:	adc080e7          	jalr	-1316(ra) # 57b4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	30050513          	addi	a0,a0,768 # 6fe0 <malloc+0x143e>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	acc080e7          	jalr	-1332(ra) # 57b4 <unlink>
  unlink("12345678901234/123456789012345");
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	29850513          	addi	a0,a0,664 # 6f88 <malloc+0x13e6>
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	abc080e7          	jalr	-1348(ra) # 57b4 <unlink>
  unlink("12345678901234");
    2d00:	00004517          	auipc	a0,0x4
    2d04:	43050513          	addi	a0,a0,1072 # 7130 <malloc+0x158e>
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	aac080e7          	jalr	-1364(ra) # 57b4 <unlink>
}
    2d10:	60e2                	ld	ra,24(sp)
    2d12:	6442                	ld	s0,16(sp)
    2d14:	64a2                	ld	s1,8(sp)
    2d16:	6105                	addi	sp,sp,32
    2d18:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2d1a:	85a6                	mv	a1,s1
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	24450513          	addi	a0,a0,580 # 6f60 <malloc+0x13be>
    2d24:	00003097          	auipc	ra,0x3
    2d28:	dc0080e7          	jalr	-576(ra) # 5ae4 <printf>
    exit(1);
    2d2c:	4505                	li	a0,1
    2d2e:	00003097          	auipc	ra,0x3
    2d32:	a36080e7          	jalr	-1482(ra) # 5764 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2d36:	85a6                	mv	a1,s1
    2d38:	00004517          	auipc	a0,0x4
    2d3c:	27050513          	addi	a0,a0,624 # 6fa8 <malloc+0x1406>
    2d40:	00003097          	auipc	ra,0x3
    2d44:	da4080e7          	jalr	-604(ra) # 5ae4 <printf>
    exit(1);
    2d48:	4505                	li	a0,1
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	a1a080e7          	jalr	-1510(ra) # 5764 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2d52:	85a6                	mv	a1,s1
    2d54:	00004517          	auipc	a0,0x4
    2d58:	2bc50513          	addi	a0,a0,700 # 7010 <malloc+0x146e>
    2d5c:	00003097          	auipc	ra,0x3
    2d60:	d88080e7          	jalr	-632(ra) # 5ae4 <printf>
    exit(1);
    2d64:	4505                	li	a0,1
    2d66:	00003097          	auipc	ra,0x3
    2d6a:	9fe080e7          	jalr	-1538(ra) # 5764 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2d6e:	85a6                	mv	a1,s1
    2d70:	00004517          	auipc	a0,0x4
    2d74:	31850513          	addi	a0,a0,792 # 7088 <malloc+0x14e6>
    2d78:	00003097          	auipc	ra,0x3
    2d7c:	d6c080e7          	jalr	-660(ra) # 5ae4 <printf>
    exit(1);
    2d80:	4505                	li	a0,1
    2d82:	00003097          	auipc	ra,0x3
    2d86:	9e2080e7          	jalr	-1566(ra) # 5764 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2d8a:	85a6                	mv	a1,s1
    2d8c:	00004517          	auipc	a0,0x4
    2d90:	35c50513          	addi	a0,a0,860 # 70e8 <malloc+0x1546>
    2d94:	00003097          	auipc	ra,0x3
    2d98:	d50080e7          	jalr	-688(ra) # 5ae4 <printf>
    exit(1);
    2d9c:	4505                	li	a0,1
    2d9e:	00003097          	auipc	ra,0x3
    2da2:	9c6080e7          	jalr	-1594(ra) # 5764 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2da6:	85a6                	mv	a1,s1
    2da8:	00004517          	auipc	a0,0x4
    2dac:	39850513          	addi	a0,a0,920 # 7140 <malloc+0x159e>
    2db0:	00003097          	auipc	ra,0x3
    2db4:	d34080e7          	jalr	-716(ra) # 5ae4 <printf>
    exit(1);
    2db8:	4505                	li	a0,1
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	9aa080e7          	jalr	-1622(ra) # 5764 <exit>

0000000000002dc2 <iputtest>:
{
    2dc2:	1101                	addi	sp,sp,-32
    2dc4:	ec06                	sd	ra,24(sp)
    2dc6:	e822                	sd	s0,16(sp)
    2dc8:	e426                	sd	s1,8(sp)
    2dca:	1000                	addi	s0,sp,32
    2dcc:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2dce:	00004517          	auipc	a0,0x4
    2dd2:	3aa50513          	addi	a0,a0,938 # 7178 <malloc+0x15d6>
    2dd6:	00003097          	auipc	ra,0x3
    2dda:	9f6080e7          	jalr	-1546(ra) # 57cc <mkdir>
    2dde:	04054563          	bltz	a0,2e28 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2de2:	00004517          	auipc	a0,0x4
    2de6:	39650513          	addi	a0,a0,918 # 7178 <malloc+0x15d6>
    2dea:	00003097          	auipc	ra,0x3
    2dee:	9ea080e7          	jalr	-1558(ra) # 57d4 <chdir>
    2df2:	04054963          	bltz	a0,2e44 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2df6:	00004517          	auipc	a0,0x4
    2dfa:	3c250513          	addi	a0,a0,962 # 71b8 <malloc+0x1616>
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	9b6080e7          	jalr	-1610(ra) # 57b4 <unlink>
    2e06:	04054d63          	bltz	a0,2e60 <iputtest+0x9e>
  if(chdir("/") < 0){
    2e0a:	00004517          	auipc	a0,0x4
    2e0e:	3de50513          	addi	a0,a0,990 # 71e8 <malloc+0x1646>
    2e12:	00003097          	auipc	ra,0x3
    2e16:	9c2080e7          	jalr	-1598(ra) # 57d4 <chdir>
    2e1a:	06054163          	bltz	a0,2e7c <iputtest+0xba>
}
    2e1e:	60e2                	ld	ra,24(sp)
    2e20:	6442                	ld	s0,16(sp)
    2e22:	64a2                	ld	s1,8(sp)
    2e24:	6105                	addi	sp,sp,32
    2e26:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2e28:	85a6                	mv	a1,s1
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	35650513          	addi	a0,a0,854 # 7180 <malloc+0x15de>
    2e32:	00003097          	auipc	ra,0x3
    2e36:	cb2080e7          	jalr	-846(ra) # 5ae4 <printf>
    exit(1);
    2e3a:	4505                	li	a0,1
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	928080e7          	jalr	-1752(ra) # 5764 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2e44:	85a6                	mv	a1,s1
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	35250513          	addi	a0,a0,850 # 7198 <malloc+0x15f6>
    2e4e:	00003097          	auipc	ra,0x3
    2e52:	c96080e7          	jalr	-874(ra) # 5ae4 <printf>
    exit(1);
    2e56:	4505                	li	a0,1
    2e58:	00003097          	auipc	ra,0x3
    2e5c:	90c080e7          	jalr	-1780(ra) # 5764 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2e60:	85a6                	mv	a1,s1
    2e62:	00004517          	auipc	a0,0x4
    2e66:	36650513          	addi	a0,a0,870 # 71c8 <malloc+0x1626>
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	c7a080e7          	jalr	-902(ra) # 5ae4 <printf>
    exit(1);
    2e72:	4505                	li	a0,1
    2e74:	00003097          	auipc	ra,0x3
    2e78:	8f0080e7          	jalr	-1808(ra) # 5764 <exit>
    printf("%s: chdir / failed\n", s);
    2e7c:	85a6                	mv	a1,s1
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	37250513          	addi	a0,a0,882 # 71f0 <malloc+0x164e>
    2e86:	00003097          	auipc	ra,0x3
    2e8a:	c5e080e7          	jalr	-930(ra) # 5ae4 <printf>
    exit(1);
    2e8e:	4505                	li	a0,1
    2e90:	00003097          	auipc	ra,0x3
    2e94:	8d4080e7          	jalr	-1836(ra) # 5764 <exit>

0000000000002e98 <exitiputtest>:
{
    2e98:	7179                	addi	sp,sp,-48
    2e9a:	f406                	sd	ra,40(sp)
    2e9c:	f022                	sd	s0,32(sp)
    2e9e:	ec26                	sd	s1,24(sp)
    2ea0:	1800                	addi	s0,sp,48
    2ea2:	84aa                	mv	s1,a0
  pid = fork();
    2ea4:	00003097          	auipc	ra,0x3
    2ea8:	8b8080e7          	jalr	-1864(ra) # 575c <fork>
  if(pid < 0){
    2eac:	04054663          	bltz	a0,2ef8 <exitiputtest+0x60>
  if(pid == 0){
    2eb0:	ed45                	bnez	a0,2f68 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2eb2:	00004517          	auipc	a0,0x4
    2eb6:	2c650513          	addi	a0,a0,710 # 7178 <malloc+0x15d6>
    2eba:	00003097          	auipc	ra,0x3
    2ebe:	912080e7          	jalr	-1774(ra) # 57cc <mkdir>
    2ec2:	04054963          	bltz	a0,2f14 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2ec6:	00004517          	auipc	a0,0x4
    2eca:	2b250513          	addi	a0,a0,690 # 7178 <malloc+0x15d6>
    2ece:	00003097          	auipc	ra,0x3
    2ed2:	906080e7          	jalr	-1786(ra) # 57d4 <chdir>
    2ed6:	04054d63          	bltz	a0,2f30 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2eda:	00004517          	auipc	a0,0x4
    2ede:	2de50513          	addi	a0,a0,734 # 71b8 <malloc+0x1616>
    2ee2:	00003097          	auipc	ra,0x3
    2ee6:	8d2080e7          	jalr	-1838(ra) # 57b4 <unlink>
    2eea:	06054163          	bltz	a0,2f4c <exitiputtest+0xb4>
    exit(0);
    2eee:	4501                	li	a0,0
    2ef0:	00003097          	auipc	ra,0x3
    2ef4:	874080e7          	jalr	-1932(ra) # 5764 <exit>
    printf("%s: fork failed\n", s);
    2ef8:	85a6                	mv	a1,s1
    2efa:	00004517          	auipc	a0,0x4
    2efe:	93e50513          	addi	a0,a0,-1730 # 6838 <malloc+0xc96>
    2f02:	00003097          	auipc	ra,0x3
    2f06:	be2080e7          	jalr	-1054(ra) # 5ae4 <printf>
    exit(1);
    2f0a:	4505                	li	a0,1
    2f0c:	00003097          	auipc	ra,0x3
    2f10:	858080e7          	jalr	-1960(ra) # 5764 <exit>
      printf("%s: mkdir failed\n", s);
    2f14:	85a6                	mv	a1,s1
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	26a50513          	addi	a0,a0,618 # 7180 <malloc+0x15de>
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	bc6080e7          	jalr	-1082(ra) # 5ae4 <printf>
      exit(1);
    2f26:	4505                	li	a0,1
    2f28:	00003097          	auipc	ra,0x3
    2f2c:	83c080e7          	jalr	-1988(ra) # 5764 <exit>
      printf("%s: child chdir failed\n", s);
    2f30:	85a6                	mv	a1,s1
    2f32:	00004517          	auipc	a0,0x4
    2f36:	2d650513          	addi	a0,a0,726 # 7208 <malloc+0x1666>
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	baa080e7          	jalr	-1110(ra) # 5ae4 <printf>
      exit(1);
    2f42:	4505                	li	a0,1
    2f44:	00003097          	auipc	ra,0x3
    2f48:	820080e7          	jalr	-2016(ra) # 5764 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2f4c:	85a6                	mv	a1,s1
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	27a50513          	addi	a0,a0,634 # 71c8 <malloc+0x1626>
    2f56:	00003097          	auipc	ra,0x3
    2f5a:	b8e080e7          	jalr	-1138(ra) # 5ae4 <printf>
      exit(1);
    2f5e:	4505                	li	a0,1
    2f60:	00003097          	auipc	ra,0x3
    2f64:	804080e7          	jalr	-2044(ra) # 5764 <exit>
  wait(&xstatus);
    2f68:	fdc40513          	addi	a0,s0,-36
    2f6c:	00003097          	auipc	ra,0x3
    2f70:	800080e7          	jalr	-2048(ra) # 576c <wait>
  exit(xstatus);
    2f74:	fdc42503          	lw	a0,-36(s0)
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	7ec080e7          	jalr	2028(ra) # 5764 <exit>

0000000000002f80 <dirtest>:
{
    2f80:	1101                	addi	sp,sp,-32
    2f82:	ec06                	sd	ra,24(sp)
    2f84:	e822                	sd	s0,16(sp)
    2f86:	e426                	sd	s1,8(sp)
    2f88:	1000                	addi	s0,sp,32
    2f8a:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2f8c:	00004517          	auipc	a0,0x4
    2f90:	29450513          	addi	a0,a0,660 # 7220 <malloc+0x167e>
    2f94:	00003097          	auipc	ra,0x3
    2f98:	838080e7          	jalr	-1992(ra) # 57cc <mkdir>
    2f9c:	04054563          	bltz	a0,2fe6 <dirtest+0x66>
  if(chdir("dir0") < 0){
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	28050513          	addi	a0,a0,640 # 7220 <malloc+0x167e>
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	82c080e7          	jalr	-2004(ra) # 57d4 <chdir>
    2fb0:	04054963          	bltz	a0,3002 <dirtest+0x82>
  if(chdir("..") < 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	28c50513          	addi	a0,a0,652 # 7240 <malloc+0x169e>
    2fbc:	00003097          	auipc	ra,0x3
    2fc0:	818080e7          	jalr	-2024(ra) # 57d4 <chdir>
    2fc4:	04054d63          	bltz	a0,301e <dirtest+0x9e>
  if(unlink("dir0") < 0){
    2fc8:	00004517          	auipc	a0,0x4
    2fcc:	25850513          	addi	a0,a0,600 # 7220 <malloc+0x167e>
    2fd0:	00002097          	auipc	ra,0x2
    2fd4:	7e4080e7          	jalr	2020(ra) # 57b4 <unlink>
    2fd8:	06054163          	bltz	a0,303a <dirtest+0xba>
}
    2fdc:	60e2                	ld	ra,24(sp)
    2fde:	6442                	ld	s0,16(sp)
    2fe0:	64a2                	ld	s1,8(sp)
    2fe2:	6105                	addi	sp,sp,32
    2fe4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2fe6:	85a6                	mv	a1,s1
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	19850513          	addi	a0,a0,408 # 7180 <malloc+0x15de>
    2ff0:	00003097          	auipc	ra,0x3
    2ff4:	af4080e7          	jalr	-1292(ra) # 5ae4 <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	00002097          	auipc	ra,0x2
    2ffe:	76a080e7          	jalr	1898(ra) # 5764 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3002:	85a6                	mv	a1,s1
    3004:	00004517          	auipc	a0,0x4
    3008:	22450513          	addi	a0,a0,548 # 7228 <malloc+0x1686>
    300c:	00003097          	auipc	ra,0x3
    3010:	ad8080e7          	jalr	-1320(ra) # 5ae4 <printf>
    exit(1);
    3014:	4505                	li	a0,1
    3016:	00002097          	auipc	ra,0x2
    301a:	74e080e7          	jalr	1870(ra) # 5764 <exit>
    printf("%s: chdir .. failed\n", s);
    301e:	85a6                	mv	a1,s1
    3020:	00004517          	auipc	a0,0x4
    3024:	22850513          	addi	a0,a0,552 # 7248 <malloc+0x16a6>
    3028:	00003097          	auipc	ra,0x3
    302c:	abc080e7          	jalr	-1348(ra) # 5ae4 <printf>
    exit(1);
    3030:	4505                	li	a0,1
    3032:	00002097          	auipc	ra,0x2
    3036:	732080e7          	jalr	1842(ra) # 5764 <exit>
    printf("%s: unlink dir0 failed\n", s);
    303a:	85a6                	mv	a1,s1
    303c:	00004517          	auipc	a0,0x4
    3040:	22450513          	addi	a0,a0,548 # 7260 <malloc+0x16be>
    3044:	00003097          	auipc	ra,0x3
    3048:	aa0080e7          	jalr	-1376(ra) # 5ae4 <printf>
    exit(1);
    304c:	4505                	li	a0,1
    304e:	00002097          	auipc	ra,0x2
    3052:	716080e7          	jalr	1814(ra) # 5764 <exit>

0000000000003056 <subdir>:
{
    3056:	1101                	addi	sp,sp,-32
    3058:	ec06                	sd	ra,24(sp)
    305a:	e822                	sd	s0,16(sp)
    305c:	e426                	sd	s1,8(sp)
    305e:	e04a                	sd	s2,0(sp)
    3060:	1000                	addi	s0,sp,32
    3062:	892a                	mv	s2,a0
  unlink("ff");
    3064:	00004517          	auipc	a0,0x4
    3068:	34450513          	addi	a0,a0,836 # 73a8 <malloc+0x1806>
    306c:	00002097          	auipc	ra,0x2
    3070:	748080e7          	jalr	1864(ra) # 57b4 <unlink>
  if(mkdir("dd") != 0){
    3074:	00004517          	auipc	a0,0x4
    3078:	20450513          	addi	a0,a0,516 # 7278 <malloc+0x16d6>
    307c:	00002097          	auipc	ra,0x2
    3080:	750080e7          	jalr	1872(ra) # 57cc <mkdir>
    3084:	38051663          	bnez	a0,3410 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3088:	20200593          	li	a1,514
    308c:	00004517          	auipc	a0,0x4
    3090:	20c50513          	addi	a0,a0,524 # 7298 <malloc+0x16f6>
    3094:	00002097          	auipc	ra,0x2
    3098:	710080e7          	jalr	1808(ra) # 57a4 <open>
    309c:	84aa                	mv	s1,a0
  if(fd < 0){
    309e:	38054763          	bltz	a0,342c <subdir+0x3d6>
  write(fd, "ff", 2);
    30a2:	4609                	li	a2,2
    30a4:	00004597          	auipc	a1,0x4
    30a8:	30458593          	addi	a1,a1,772 # 73a8 <malloc+0x1806>
    30ac:	00002097          	auipc	ra,0x2
    30b0:	6d8080e7          	jalr	1752(ra) # 5784 <write>
  close(fd);
    30b4:	8526                	mv	a0,s1
    30b6:	00002097          	auipc	ra,0x2
    30ba:	6d6080e7          	jalr	1750(ra) # 578c <close>
  if(unlink("dd") >= 0){
    30be:	00004517          	auipc	a0,0x4
    30c2:	1ba50513          	addi	a0,a0,442 # 7278 <malloc+0x16d6>
    30c6:	00002097          	auipc	ra,0x2
    30ca:	6ee080e7          	jalr	1774(ra) # 57b4 <unlink>
    30ce:	36055d63          	bgez	a0,3448 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    30d2:	00004517          	auipc	a0,0x4
    30d6:	21e50513          	addi	a0,a0,542 # 72f0 <malloc+0x174e>
    30da:	00002097          	auipc	ra,0x2
    30de:	6f2080e7          	jalr	1778(ra) # 57cc <mkdir>
    30e2:	38051163          	bnez	a0,3464 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    30e6:	20200593          	li	a1,514
    30ea:	00004517          	auipc	a0,0x4
    30ee:	22e50513          	addi	a0,a0,558 # 7318 <malloc+0x1776>
    30f2:	00002097          	auipc	ra,0x2
    30f6:	6b2080e7          	jalr	1714(ra) # 57a4 <open>
    30fa:	84aa                	mv	s1,a0
  if(fd < 0){
    30fc:	38054263          	bltz	a0,3480 <subdir+0x42a>
  write(fd, "FF", 2);
    3100:	4609                	li	a2,2
    3102:	00004597          	auipc	a1,0x4
    3106:	24658593          	addi	a1,a1,582 # 7348 <malloc+0x17a6>
    310a:	00002097          	auipc	ra,0x2
    310e:	67a080e7          	jalr	1658(ra) # 5784 <write>
  close(fd);
    3112:	8526                	mv	a0,s1
    3114:	00002097          	auipc	ra,0x2
    3118:	678080e7          	jalr	1656(ra) # 578c <close>
  fd = open("dd/dd/../ff", 0);
    311c:	4581                	li	a1,0
    311e:	00004517          	auipc	a0,0x4
    3122:	23250513          	addi	a0,a0,562 # 7350 <malloc+0x17ae>
    3126:	00002097          	auipc	ra,0x2
    312a:	67e080e7          	jalr	1662(ra) # 57a4 <open>
    312e:	84aa                	mv	s1,a0
  if(fd < 0){
    3130:	36054663          	bltz	a0,349c <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    3134:	660d                	lui	a2,0x3
    3136:	00009597          	auipc	a1,0x9
    313a:	b5258593          	addi	a1,a1,-1198 # bc88 <buf>
    313e:	00002097          	auipc	ra,0x2
    3142:	63e080e7          	jalr	1598(ra) # 577c <read>
  if(cc != 2 || buf[0] != 'f'){
    3146:	4789                	li	a5,2
    3148:	36f51863          	bne	a0,a5,34b8 <subdir+0x462>
    314c:	00009717          	auipc	a4,0x9
    3150:	b3c74703          	lbu	a4,-1220(a4) # bc88 <buf>
    3154:	06600793          	li	a5,102
    3158:	36f71063          	bne	a4,a5,34b8 <subdir+0x462>
  close(fd);
    315c:	8526                	mv	a0,s1
    315e:	00002097          	auipc	ra,0x2
    3162:	62e080e7          	jalr	1582(ra) # 578c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3166:	00004597          	auipc	a1,0x4
    316a:	23a58593          	addi	a1,a1,570 # 73a0 <malloc+0x17fe>
    316e:	00004517          	auipc	a0,0x4
    3172:	1aa50513          	addi	a0,a0,426 # 7318 <malloc+0x1776>
    3176:	00002097          	auipc	ra,0x2
    317a:	64e080e7          	jalr	1614(ra) # 57c4 <link>
    317e:	34051b63          	bnez	a0,34d4 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3182:	00004517          	auipc	a0,0x4
    3186:	19650513          	addi	a0,a0,406 # 7318 <malloc+0x1776>
    318a:	00002097          	auipc	ra,0x2
    318e:	62a080e7          	jalr	1578(ra) # 57b4 <unlink>
    3192:	34051f63          	bnez	a0,34f0 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3196:	4581                	li	a1,0
    3198:	00004517          	auipc	a0,0x4
    319c:	18050513          	addi	a0,a0,384 # 7318 <malloc+0x1776>
    31a0:	00002097          	auipc	ra,0x2
    31a4:	604080e7          	jalr	1540(ra) # 57a4 <open>
    31a8:	36055263          	bgez	a0,350c <subdir+0x4b6>
  if(chdir("dd") != 0){
    31ac:	00004517          	auipc	a0,0x4
    31b0:	0cc50513          	addi	a0,a0,204 # 7278 <malloc+0x16d6>
    31b4:	00002097          	auipc	ra,0x2
    31b8:	620080e7          	jalr	1568(ra) # 57d4 <chdir>
    31bc:	36051663          	bnez	a0,3528 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    31c0:	00004517          	auipc	a0,0x4
    31c4:	27850513          	addi	a0,a0,632 # 7438 <malloc+0x1896>
    31c8:	00002097          	auipc	ra,0x2
    31cc:	60c080e7          	jalr	1548(ra) # 57d4 <chdir>
    31d0:	36051a63          	bnez	a0,3544 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    31d4:	00004517          	auipc	a0,0x4
    31d8:	29450513          	addi	a0,a0,660 # 7468 <malloc+0x18c6>
    31dc:	00002097          	auipc	ra,0x2
    31e0:	5f8080e7          	jalr	1528(ra) # 57d4 <chdir>
    31e4:	36051e63          	bnez	a0,3560 <subdir+0x50a>
  if(chdir("./..") != 0){
    31e8:	00004517          	auipc	a0,0x4
    31ec:	2b050513          	addi	a0,a0,688 # 7498 <malloc+0x18f6>
    31f0:	00002097          	auipc	ra,0x2
    31f4:	5e4080e7          	jalr	1508(ra) # 57d4 <chdir>
    31f8:	38051263          	bnez	a0,357c <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    31fc:	4581                	li	a1,0
    31fe:	00004517          	auipc	a0,0x4
    3202:	1a250513          	addi	a0,a0,418 # 73a0 <malloc+0x17fe>
    3206:	00002097          	auipc	ra,0x2
    320a:	59e080e7          	jalr	1438(ra) # 57a4 <open>
    320e:	84aa                	mv	s1,a0
  if(fd < 0){
    3210:	38054463          	bltz	a0,3598 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    3214:	660d                	lui	a2,0x3
    3216:	00009597          	auipc	a1,0x9
    321a:	a7258593          	addi	a1,a1,-1422 # bc88 <buf>
    321e:	00002097          	auipc	ra,0x2
    3222:	55e080e7          	jalr	1374(ra) # 577c <read>
    3226:	4789                	li	a5,2
    3228:	38f51663          	bne	a0,a5,35b4 <subdir+0x55e>
  close(fd);
    322c:	8526                	mv	a0,s1
    322e:	00002097          	auipc	ra,0x2
    3232:	55e080e7          	jalr	1374(ra) # 578c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3236:	4581                	li	a1,0
    3238:	00004517          	auipc	a0,0x4
    323c:	0e050513          	addi	a0,a0,224 # 7318 <malloc+0x1776>
    3240:	00002097          	auipc	ra,0x2
    3244:	564080e7          	jalr	1380(ra) # 57a4 <open>
    3248:	38055463          	bgez	a0,35d0 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    324c:	20200593          	li	a1,514
    3250:	00004517          	auipc	a0,0x4
    3254:	2d850513          	addi	a0,a0,728 # 7528 <malloc+0x1986>
    3258:	00002097          	auipc	ra,0x2
    325c:	54c080e7          	jalr	1356(ra) # 57a4 <open>
    3260:	38055663          	bgez	a0,35ec <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3264:	20200593          	li	a1,514
    3268:	00004517          	auipc	a0,0x4
    326c:	2f050513          	addi	a0,a0,752 # 7558 <malloc+0x19b6>
    3270:	00002097          	auipc	ra,0x2
    3274:	534080e7          	jalr	1332(ra) # 57a4 <open>
    3278:	38055863          	bgez	a0,3608 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    327c:	20000593          	li	a1,512
    3280:	00004517          	auipc	a0,0x4
    3284:	ff850513          	addi	a0,a0,-8 # 7278 <malloc+0x16d6>
    3288:	00002097          	auipc	ra,0x2
    328c:	51c080e7          	jalr	1308(ra) # 57a4 <open>
    3290:	38055a63          	bgez	a0,3624 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3294:	4589                	li	a1,2
    3296:	00004517          	auipc	a0,0x4
    329a:	fe250513          	addi	a0,a0,-30 # 7278 <malloc+0x16d6>
    329e:	00002097          	auipc	ra,0x2
    32a2:	506080e7          	jalr	1286(ra) # 57a4 <open>
    32a6:	38055d63          	bgez	a0,3640 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    32aa:	4585                	li	a1,1
    32ac:	00004517          	auipc	a0,0x4
    32b0:	fcc50513          	addi	a0,a0,-52 # 7278 <malloc+0x16d6>
    32b4:	00002097          	auipc	ra,0x2
    32b8:	4f0080e7          	jalr	1264(ra) # 57a4 <open>
    32bc:	3a055063          	bgez	a0,365c <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    32c0:	00004597          	auipc	a1,0x4
    32c4:	32858593          	addi	a1,a1,808 # 75e8 <malloc+0x1a46>
    32c8:	00004517          	auipc	a0,0x4
    32cc:	26050513          	addi	a0,a0,608 # 7528 <malloc+0x1986>
    32d0:	00002097          	auipc	ra,0x2
    32d4:	4f4080e7          	jalr	1268(ra) # 57c4 <link>
    32d8:	3a050063          	beqz	a0,3678 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    32dc:	00004597          	auipc	a1,0x4
    32e0:	30c58593          	addi	a1,a1,780 # 75e8 <malloc+0x1a46>
    32e4:	00004517          	auipc	a0,0x4
    32e8:	27450513          	addi	a0,a0,628 # 7558 <malloc+0x19b6>
    32ec:	00002097          	auipc	ra,0x2
    32f0:	4d8080e7          	jalr	1240(ra) # 57c4 <link>
    32f4:	3a050063          	beqz	a0,3694 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    32f8:	00004597          	auipc	a1,0x4
    32fc:	0a858593          	addi	a1,a1,168 # 73a0 <malloc+0x17fe>
    3300:	00004517          	auipc	a0,0x4
    3304:	f9850513          	addi	a0,a0,-104 # 7298 <malloc+0x16f6>
    3308:	00002097          	auipc	ra,0x2
    330c:	4bc080e7          	jalr	1212(ra) # 57c4 <link>
    3310:	3a050063          	beqz	a0,36b0 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    3314:	00004517          	auipc	a0,0x4
    3318:	21450513          	addi	a0,a0,532 # 7528 <malloc+0x1986>
    331c:	00002097          	auipc	ra,0x2
    3320:	4b0080e7          	jalr	1200(ra) # 57cc <mkdir>
    3324:	3a050463          	beqz	a0,36cc <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3328:	00004517          	auipc	a0,0x4
    332c:	23050513          	addi	a0,a0,560 # 7558 <malloc+0x19b6>
    3330:	00002097          	auipc	ra,0x2
    3334:	49c080e7          	jalr	1180(ra) # 57cc <mkdir>
    3338:	3a050863          	beqz	a0,36e8 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    333c:	00004517          	auipc	a0,0x4
    3340:	06450513          	addi	a0,a0,100 # 73a0 <malloc+0x17fe>
    3344:	00002097          	auipc	ra,0x2
    3348:	488080e7          	jalr	1160(ra) # 57cc <mkdir>
    334c:	3a050c63          	beqz	a0,3704 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3350:	00004517          	auipc	a0,0x4
    3354:	20850513          	addi	a0,a0,520 # 7558 <malloc+0x19b6>
    3358:	00002097          	auipc	ra,0x2
    335c:	45c080e7          	jalr	1116(ra) # 57b4 <unlink>
    3360:	3c050063          	beqz	a0,3720 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    3364:	00004517          	auipc	a0,0x4
    3368:	1c450513          	addi	a0,a0,452 # 7528 <malloc+0x1986>
    336c:	00002097          	auipc	ra,0x2
    3370:	448080e7          	jalr	1096(ra) # 57b4 <unlink>
    3374:	3c050463          	beqz	a0,373c <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3378:	00004517          	auipc	a0,0x4
    337c:	f2050513          	addi	a0,a0,-224 # 7298 <malloc+0x16f6>
    3380:	00002097          	auipc	ra,0x2
    3384:	454080e7          	jalr	1108(ra) # 57d4 <chdir>
    3388:	3c050863          	beqz	a0,3758 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    338c:	00004517          	auipc	a0,0x4
    3390:	3ac50513          	addi	a0,a0,940 # 7738 <malloc+0x1b96>
    3394:	00002097          	auipc	ra,0x2
    3398:	440080e7          	jalr	1088(ra) # 57d4 <chdir>
    339c:	3c050c63          	beqz	a0,3774 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    33a0:	00004517          	auipc	a0,0x4
    33a4:	00050513          	mv	a0,a0
    33a8:	00002097          	auipc	ra,0x2
    33ac:	40c080e7          	jalr	1036(ra) # 57b4 <unlink>
    33b0:	3e051063          	bnez	a0,3790 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    33b4:	00004517          	auipc	a0,0x4
    33b8:	ee450513          	addi	a0,a0,-284 # 7298 <malloc+0x16f6>
    33bc:	00002097          	auipc	ra,0x2
    33c0:	3f8080e7          	jalr	1016(ra) # 57b4 <unlink>
    33c4:	3e051463          	bnez	a0,37ac <subdir+0x756>
  if(unlink("dd") == 0){
    33c8:	00004517          	auipc	a0,0x4
    33cc:	eb050513          	addi	a0,a0,-336 # 7278 <malloc+0x16d6>
    33d0:	00002097          	auipc	ra,0x2
    33d4:	3e4080e7          	jalr	996(ra) # 57b4 <unlink>
    33d8:	3e050863          	beqz	a0,37c8 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    33dc:	00004517          	auipc	a0,0x4
    33e0:	3cc50513          	addi	a0,a0,972 # 77a8 <malloc+0x1c06>
    33e4:	00002097          	auipc	ra,0x2
    33e8:	3d0080e7          	jalr	976(ra) # 57b4 <unlink>
    33ec:	3e054c63          	bltz	a0,37e4 <subdir+0x78e>
  if(unlink("dd") < 0){
    33f0:	00004517          	auipc	a0,0x4
    33f4:	e8850513          	addi	a0,a0,-376 # 7278 <malloc+0x16d6>
    33f8:	00002097          	auipc	ra,0x2
    33fc:	3bc080e7          	jalr	956(ra) # 57b4 <unlink>
    3400:	40054063          	bltz	a0,3800 <subdir+0x7aa>
}
    3404:	60e2                	ld	ra,24(sp)
    3406:	6442                	ld	s0,16(sp)
    3408:	64a2                	ld	s1,8(sp)
    340a:	6902                	ld	s2,0(sp)
    340c:	6105                	addi	sp,sp,32
    340e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3410:	85ca                	mv	a1,s2
    3412:	00004517          	auipc	a0,0x4
    3416:	e6e50513          	addi	a0,a0,-402 # 7280 <malloc+0x16de>
    341a:	00002097          	auipc	ra,0x2
    341e:	6ca080e7          	jalr	1738(ra) # 5ae4 <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	00002097          	auipc	ra,0x2
    3428:	340080e7          	jalr	832(ra) # 5764 <exit>
    printf("%s: create dd/ff failed\n", s);
    342c:	85ca                	mv	a1,s2
    342e:	00004517          	auipc	a0,0x4
    3432:	e7250513          	addi	a0,a0,-398 # 72a0 <malloc+0x16fe>
    3436:	00002097          	auipc	ra,0x2
    343a:	6ae080e7          	jalr	1710(ra) # 5ae4 <printf>
    exit(1);
    343e:	4505                	li	a0,1
    3440:	00002097          	auipc	ra,0x2
    3444:	324080e7          	jalr	804(ra) # 5764 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3448:	85ca                	mv	a1,s2
    344a:	00004517          	auipc	a0,0x4
    344e:	e7650513          	addi	a0,a0,-394 # 72c0 <malloc+0x171e>
    3452:	00002097          	auipc	ra,0x2
    3456:	692080e7          	jalr	1682(ra) # 5ae4 <printf>
    exit(1);
    345a:	4505                	li	a0,1
    345c:	00002097          	auipc	ra,0x2
    3460:	308080e7          	jalr	776(ra) # 5764 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	e9250513          	addi	a0,a0,-366 # 72f8 <malloc+0x1756>
    346e:	00002097          	auipc	ra,0x2
    3472:	676080e7          	jalr	1654(ra) # 5ae4 <printf>
    exit(1);
    3476:	4505                	li	a0,1
    3478:	00002097          	auipc	ra,0x2
    347c:	2ec080e7          	jalr	748(ra) # 5764 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3480:	85ca                	mv	a1,s2
    3482:	00004517          	auipc	a0,0x4
    3486:	ea650513          	addi	a0,a0,-346 # 7328 <malloc+0x1786>
    348a:	00002097          	auipc	ra,0x2
    348e:	65a080e7          	jalr	1626(ra) # 5ae4 <printf>
    exit(1);
    3492:	4505                	li	a0,1
    3494:	00002097          	auipc	ra,0x2
    3498:	2d0080e7          	jalr	720(ra) # 5764 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    349c:	85ca                	mv	a1,s2
    349e:	00004517          	auipc	a0,0x4
    34a2:	ec250513          	addi	a0,a0,-318 # 7360 <malloc+0x17be>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	63e080e7          	jalr	1598(ra) # 5ae4 <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	00002097          	auipc	ra,0x2
    34b4:	2b4080e7          	jalr	692(ra) # 5764 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    34b8:	85ca                	mv	a1,s2
    34ba:	00004517          	auipc	a0,0x4
    34be:	ec650513          	addi	a0,a0,-314 # 7380 <malloc+0x17de>
    34c2:	00002097          	auipc	ra,0x2
    34c6:	622080e7          	jalr	1570(ra) # 5ae4 <printf>
    exit(1);
    34ca:	4505                	li	a0,1
    34cc:	00002097          	auipc	ra,0x2
    34d0:	298080e7          	jalr	664(ra) # 5764 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    34d4:	85ca                	mv	a1,s2
    34d6:	00004517          	auipc	a0,0x4
    34da:	eda50513          	addi	a0,a0,-294 # 73b0 <malloc+0x180e>
    34de:	00002097          	auipc	ra,0x2
    34e2:	606080e7          	jalr	1542(ra) # 5ae4 <printf>
    exit(1);
    34e6:	4505                	li	a0,1
    34e8:	00002097          	auipc	ra,0x2
    34ec:	27c080e7          	jalr	636(ra) # 5764 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    34f0:	85ca                	mv	a1,s2
    34f2:	00004517          	auipc	a0,0x4
    34f6:	ee650513          	addi	a0,a0,-282 # 73d8 <malloc+0x1836>
    34fa:	00002097          	auipc	ra,0x2
    34fe:	5ea080e7          	jalr	1514(ra) # 5ae4 <printf>
    exit(1);
    3502:	4505                	li	a0,1
    3504:	00002097          	auipc	ra,0x2
    3508:	260080e7          	jalr	608(ra) # 5764 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    350c:	85ca                	mv	a1,s2
    350e:	00004517          	auipc	a0,0x4
    3512:	eea50513          	addi	a0,a0,-278 # 73f8 <malloc+0x1856>
    3516:	00002097          	auipc	ra,0x2
    351a:	5ce080e7          	jalr	1486(ra) # 5ae4 <printf>
    exit(1);
    351e:	4505                	li	a0,1
    3520:	00002097          	auipc	ra,0x2
    3524:	244080e7          	jalr	580(ra) # 5764 <exit>
    printf("%s: chdir dd failed\n", s);
    3528:	85ca                	mv	a1,s2
    352a:	00004517          	auipc	a0,0x4
    352e:	ef650513          	addi	a0,a0,-266 # 7420 <malloc+0x187e>
    3532:	00002097          	auipc	ra,0x2
    3536:	5b2080e7          	jalr	1458(ra) # 5ae4 <printf>
    exit(1);
    353a:	4505                	li	a0,1
    353c:	00002097          	auipc	ra,0x2
    3540:	228080e7          	jalr	552(ra) # 5764 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3544:	85ca                	mv	a1,s2
    3546:	00004517          	auipc	a0,0x4
    354a:	f0250513          	addi	a0,a0,-254 # 7448 <malloc+0x18a6>
    354e:	00002097          	auipc	ra,0x2
    3552:	596080e7          	jalr	1430(ra) # 5ae4 <printf>
    exit(1);
    3556:	4505                	li	a0,1
    3558:	00002097          	auipc	ra,0x2
    355c:	20c080e7          	jalr	524(ra) # 5764 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3560:	85ca                	mv	a1,s2
    3562:	00004517          	auipc	a0,0x4
    3566:	f1650513          	addi	a0,a0,-234 # 7478 <malloc+0x18d6>
    356a:	00002097          	auipc	ra,0x2
    356e:	57a080e7          	jalr	1402(ra) # 5ae4 <printf>
    exit(1);
    3572:	4505                	li	a0,1
    3574:	00002097          	auipc	ra,0x2
    3578:	1f0080e7          	jalr	496(ra) # 5764 <exit>
    printf("%s: chdir ./.. failed\n", s);
    357c:	85ca                	mv	a1,s2
    357e:	00004517          	auipc	a0,0x4
    3582:	f2250513          	addi	a0,a0,-222 # 74a0 <malloc+0x18fe>
    3586:	00002097          	auipc	ra,0x2
    358a:	55e080e7          	jalr	1374(ra) # 5ae4 <printf>
    exit(1);
    358e:	4505                	li	a0,1
    3590:	00002097          	auipc	ra,0x2
    3594:	1d4080e7          	jalr	468(ra) # 5764 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3598:	85ca                	mv	a1,s2
    359a:	00004517          	auipc	a0,0x4
    359e:	f1e50513          	addi	a0,a0,-226 # 74b8 <malloc+0x1916>
    35a2:	00002097          	auipc	ra,0x2
    35a6:	542080e7          	jalr	1346(ra) # 5ae4 <printf>
    exit(1);
    35aa:	4505                	li	a0,1
    35ac:	00002097          	auipc	ra,0x2
    35b0:	1b8080e7          	jalr	440(ra) # 5764 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    35b4:	85ca                	mv	a1,s2
    35b6:	00004517          	auipc	a0,0x4
    35ba:	f2250513          	addi	a0,a0,-222 # 74d8 <malloc+0x1936>
    35be:	00002097          	auipc	ra,0x2
    35c2:	526080e7          	jalr	1318(ra) # 5ae4 <printf>
    exit(1);
    35c6:	4505                	li	a0,1
    35c8:	00002097          	auipc	ra,0x2
    35cc:	19c080e7          	jalr	412(ra) # 5764 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    35d0:	85ca                	mv	a1,s2
    35d2:	00004517          	auipc	a0,0x4
    35d6:	f2650513          	addi	a0,a0,-218 # 74f8 <malloc+0x1956>
    35da:	00002097          	auipc	ra,0x2
    35de:	50a080e7          	jalr	1290(ra) # 5ae4 <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	00002097          	auipc	ra,0x2
    35e8:	180080e7          	jalr	384(ra) # 5764 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    35ec:	85ca                	mv	a1,s2
    35ee:	00004517          	auipc	a0,0x4
    35f2:	f4a50513          	addi	a0,a0,-182 # 7538 <malloc+0x1996>
    35f6:	00002097          	auipc	ra,0x2
    35fa:	4ee080e7          	jalr	1262(ra) # 5ae4 <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00002097          	auipc	ra,0x2
    3604:	164080e7          	jalr	356(ra) # 5764 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3608:	85ca                	mv	a1,s2
    360a:	00004517          	auipc	a0,0x4
    360e:	f5e50513          	addi	a0,a0,-162 # 7568 <malloc+0x19c6>
    3612:	00002097          	auipc	ra,0x2
    3616:	4d2080e7          	jalr	1234(ra) # 5ae4 <printf>
    exit(1);
    361a:	4505                	li	a0,1
    361c:	00002097          	auipc	ra,0x2
    3620:	148080e7          	jalr	328(ra) # 5764 <exit>
    printf("%s: create dd succeeded!\n", s);
    3624:	85ca                	mv	a1,s2
    3626:	00004517          	auipc	a0,0x4
    362a:	f6250513          	addi	a0,a0,-158 # 7588 <malloc+0x19e6>
    362e:	00002097          	auipc	ra,0x2
    3632:	4b6080e7          	jalr	1206(ra) # 5ae4 <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	00002097          	auipc	ra,0x2
    363c:	12c080e7          	jalr	300(ra) # 5764 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3640:	85ca                	mv	a1,s2
    3642:	00004517          	auipc	a0,0x4
    3646:	f6650513          	addi	a0,a0,-154 # 75a8 <malloc+0x1a06>
    364a:	00002097          	auipc	ra,0x2
    364e:	49a080e7          	jalr	1178(ra) # 5ae4 <printf>
    exit(1);
    3652:	4505                	li	a0,1
    3654:	00002097          	auipc	ra,0x2
    3658:	110080e7          	jalr	272(ra) # 5764 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    365c:	85ca                	mv	a1,s2
    365e:	00004517          	auipc	a0,0x4
    3662:	f6a50513          	addi	a0,a0,-150 # 75c8 <malloc+0x1a26>
    3666:	00002097          	auipc	ra,0x2
    366a:	47e080e7          	jalr	1150(ra) # 5ae4 <printf>
    exit(1);
    366e:	4505                	li	a0,1
    3670:	00002097          	auipc	ra,0x2
    3674:	0f4080e7          	jalr	244(ra) # 5764 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3678:	85ca                	mv	a1,s2
    367a:	00004517          	auipc	a0,0x4
    367e:	f7e50513          	addi	a0,a0,-130 # 75f8 <malloc+0x1a56>
    3682:	00002097          	auipc	ra,0x2
    3686:	462080e7          	jalr	1122(ra) # 5ae4 <printf>
    exit(1);
    368a:	4505                	li	a0,1
    368c:	00002097          	auipc	ra,0x2
    3690:	0d8080e7          	jalr	216(ra) # 5764 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3694:	85ca                	mv	a1,s2
    3696:	00004517          	auipc	a0,0x4
    369a:	f8a50513          	addi	a0,a0,-118 # 7620 <malloc+0x1a7e>
    369e:	00002097          	auipc	ra,0x2
    36a2:	446080e7          	jalr	1094(ra) # 5ae4 <printf>
    exit(1);
    36a6:	4505                	li	a0,1
    36a8:	00002097          	auipc	ra,0x2
    36ac:	0bc080e7          	jalr	188(ra) # 5764 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    36b0:	85ca                	mv	a1,s2
    36b2:	00004517          	auipc	a0,0x4
    36b6:	f9650513          	addi	a0,a0,-106 # 7648 <malloc+0x1aa6>
    36ba:	00002097          	auipc	ra,0x2
    36be:	42a080e7          	jalr	1066(ra) # 5ae4 <printf>
    exit(1);
    36c2:	4505                	li	a0,1
    36c4:	00002097          	auipc	ra,0x2
    36c8:	0a0080e7          	jalr	160(ra) # 5764 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    36cc:	85ca                	mv	a1,s2
    36ce:	00004517          	auipc	a0,0x4
    36d2:	fa250513          	addi	a0,a0,-94 # 7670 <malloc+0x1ace>
    36d6:	00002097          	auipc	ra,0x2
    36da:	40e080e7          	jalr	1038(ra) # 5ae4 <printf>
    exit(1);
    36de:	4505                	li	a0,1
    36e0:	00002097          	auipc	ra,0x2
    36e4:	084080e7          	jalr	132(ra) # 5764 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    36e8:	85ca                	mv	a1,s2
    36ea:	00004517          	auipc	a0,0x4
    36ee:	fa650513          	addi	a0,a0,-90 # 7690 <malloc+0x1aee>
    36f2:	00002097          	auipc	ra,0x2
    36f6:	3f2080e7          	jalr	1010(ra) # 5ae4 <printf>
    exit(1);
    36fa:	4505                	li	a0,1
    36fc:	00002097          	auipc	ra,0x2
    3700:	068080e7          	jalr	104(ra) # 5764 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3704:	85ca                	mv	a1,s2
    3706:	00004517          	auipc	a0,0x4
    370a:	faa50513          	addi	a0,a0,-86 # 76b0 <malloc+0x1b0e>
    370e:	00002097          	auipc	ra,0x2
    3712:	3d6080e7          	jalr	982(ra) # 5ae4 <printf>
    exit(1);
    3716:	4505                	li	a0,1
    3718:	00002097          	auipc	ra,0x2
    371c:	04c080e7          	jalr	76(ra) # 5764 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3720:	85ca                	mv	a1,s2
    3722:	00004517          	auipc	a0,0x4
    3726:	fb650513          	addi	a0,a0,-74 # 76d8 <malloc+0x1b36>
    372a:	00002097          	auipc	ra,0x2
    372e:	3ba080e7          	jalr	954(ra) # 5ae4 <printf>
    exit(1);
    3732:	4505                	li	a0,1
    3734:	00002097          	auipc	ra,0x2
    3738:	030080e7          	jalr	48(ra) # 5764 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    373c:	85ca                	mv	a1,s2
    373e:	00004517          	auipc	a0,0x4
    3742:	fba50513          	addi	a0,a0,-70 # 76f8 <malloc+0x1b56>
    3746:	00002097          	auipc	ra,0x2
    374a:	39e080e7          	jalr	926(ra) # 5ae4 <printf>
    exit(1);
    374e:	4505                	li	a0,1
    3750:	00002097          	auipc	ra,0x2
    3754:	014080e7          	jalr	20(ra) # 5764 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3758:	85ca                	mv	a1,s2
    375a:	00004517          	auipc	a0,0x4
    375e:	fbe50513          	addi	a0,a0,-66 # 7718 <malloc+0x1b76>
    3762:	00002097          	auipc	ra,0x2
    3766:	382080e7          	jalr	898(ra) # 5ae4 <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	00002097          	auipc	ra,0x2
    3770:	ff8080e7          	jalr	-8(ra) # 5764 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3774:	85ca                	mv	a1,s2
    3776:	00004517          	auipc	a0,0x4
    377a:	fca50513          	addi	a0,a0,-54 # 7740 <malloc+0x1b9e>
    377e:	00002097          	auipc	ra,0x2
    3782:	366080e7          	jalr	870(ra) # 5ae4 <printf>
    exit(1);
    3786:	4505                	li	a0,1
    3788:	00002097          	auipc	ra,0x2
    378c:	fdc080e7          	jalr	-36(ra) # 5764 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3790:	85ca                	mv	a1,s2
    3792:	00004517          	auipc	a0,0x4
    3796:	c4650513          	addi	a0,a0,-954 # 73d8 <malloc+0x1836>
    379a:	00002097          	auipc	ra,0x2
    379e:	34a080e7          	jalr	842(ra) # 5ae4 <printf>
    exit(1);
    37a2:	4505                	li	a0,1
    37a4:	00002097          	auipc	ra,0x2
    37a8:	fc0080e7          	jalr	-64(ra) # 5764 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    37ac:	85ca                	mv	a1,s2
    37ae:	00004517          	auipc	a0,0x4
    37b2:	fb250513          	addi	a0,a0,-78 # 7760 <malloc+0x1bbe>
    37b6:	00002097          	auipc	ra,0x2
    37ba:	32e080e7          	jalr	814(ra) # 5ae4 <printf>
    exit(1);
    37be:	4505                	li	a0,1
    37c0:	00002097          	auipc	ra,0x2
    37c4:	fa4080e7          	jalr	-92(ra) # 5764 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    37c8:	85ca                	mv	a1,s2
    37ca:	00004517          	auipc	a0,0x4
    37ce:	fb650513          	addi	a0,a0,-74 # 7780 <malloc+0x1bde>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	312080e7          	jalr	786(ra) # 5ae4 <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	00002097          	auipc	ra,0x2
    37e0:	f88080e7          	jalr	-120(ra) # 5764 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    37e4:	85ca                	mv	a1,s2
    37e6:	00004517          	auipc	a0,0x4
    37ea:	fca50513          	addi	a0,a0,-54 # 77b0 <malloc+0x1c0e>
    37ee:	00002097          	auipc	ra,0x2
    37f2:	2f6080e7          	jalr	758(ra) # 5ae4 <printf>
    exit(1);
    37f6:	4505                	li	a0,1
    37f8:	00002097          	auipc	ra,0x2
    37fc:	f6c080e7          	jalr	-148(ra) # 5764 <exit>
    printf("%s: unlink dd failed\n", s);
    3800:	85ca                	mv	a1,s2
    3802:	00004517          	auipc	a0,0x4
    3806:	fce50513          	addi	a0,a0,-50 # 77d0 <malloc+0x1c2e>
    380a:	00002097          	auipc	ra,0x2
    380e:	2da080e7          	jalr	730(ra) # 5ae4 <printf>
    exit(1);
    3812:	4505                	li	a0,1
    3814:	00002097          	auipc	ra,0x2
    3818:	f50080e7          	jalr	-176(ra) # 5764 <exit>

000000000000381c <rmdot>:
{
    381c:	1101                	addi	sp,sp,-32
    381e:	ec06                	sd	ra,24(sp)
    3820:	e822                	sd	s0,16(sp)
    3822:	e426                	sd	s1,8(sp)
    3824:	1000                	addi	s0,sp,32
    3826:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3828:	00004517          	auipc	a0,0x4
    382c:	fc050513          	addi	a0,a0,-64 # 77e8 <malloc+0x1c46>
    3830:	00002097          	auipc	ra,0x2
    3834:	f9c080e7          	jalr	-100(ra) # 57cc <mkdir>
    3838:	e549                	bnez	a0,38c2 <rmdot+0xa6>
  if(chdir("dots") != 0){
    383a:	00004517          	auipc	a0,0x4
    383e:	fae50513          	addi	a0,a0,-82 # 77e8 <malloc+0x1c46>
    3842:	00002097          	auipc	ra,0x2
    3846:	f92080e7          	jalr	-110(ra) # 57d4 <chdir>
    384a:	e951                	bnez	a0,38de <rmdot+0xc2>
  if(unlink(".") == 0){
    384c:	00003517          	auipc	a0,0x3
    3850:	e4c50513          	addi	a0,a0,-436 # 6698 <malloc+0xaf6>
    3854:	00002097          	auipc	ra,0x2
    3858:	f60080e7          	jalr	-160(ra) # 57b4 <unlink>
    385c:	cd59                	beqz	a0,38fa <rmdot+0xde>
  if(unlink("..") == 0){
    385e:	00004517          	auipc	a0,0x4
    3862:	9e250513          	addi	a0,a0,-1566 # 7240 <malloc+0x169e>
    3866:	00002097          	auipc	ra,0x2
    386a:	f4e080e7          	jalr	-178(ra) # 57b4 <unlink>
    386e:	c545                	beqz	a0,3916 <rmdot+0xfa>
  if(chdir("/") != 0){
    3870:	00004517          	auipc	a0,0x4
    3874:	97850513          	addi	a0,a0,-1672 # 71e8 <malloc+0x1646>
    3878:	00002097          	auipc	ra,0x2
    387c:	f5c080e7          	jalr	-164(ra) # 57d4 <chdir>
    3880:	e94d                	bnez	a0,3932 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3882:	00004517          	auipc	a0,0x4
    3886:	fce50513          	addi	a0,a0,-50 # 7850 <malloc+0x1cae>
    388a:	00002097          	auipc	ra,0x2
    388e:	f2a080e7          	jalr	-214(ra) # 57b4 <unlink>
    3892:	cd55                	beqz	a0,394e <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3894:	00004517          	auipc	a0,0x4
    3898:	fe450513          	addi	a0,a0,-28 # 7878 <malloc+0x1cd6>
    389c:	00002097          	auipc	ra,0x2
    38a0:	f18080e7          	jalr	-232(ra) # 57b4 <unlink>
    38a4:	c179                	beqz	a0,396a <rmdot+0x14e>
  if(unlink("dots") != 0){
    38a6:	00004517          	auipc	a0,0x4
    38aa:	f4250513          	addi	a0,a0,-190 # 77e8 <malloc+0x1c46>
    38ae:	00002097          	auipc	ra,0x2
    38b2:	f06080e7          	jalr	-250(ra) # 57b4 <unlink>
    38b6:	e961                	bnez	a0,3986 <rmdot+0x16a>
}
    38b8:	60e2                	ld	ra,24(sp)
    38ba:	6442                	ld	s0,16(sp)
    38bc:	64a2                	ld	s1,8(sp)
    38be:	6105                	addi	sp,sp,32
    38c0:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    38c2:	85a6                	mv	a1,s1
    38c4:	00004517          	auipc	a0,0x4
    38c8:	f2c50513          	addi	a0,a0,-212 # 77f0 <malloc+0x1c4e>
    38cc:	00002097          	auipc	ra,0x2
    38d0:	218080e7          	jalr	536(ra) # 5ae4 <printf>
    exit(1);
    38d4:	4505                	li	a0,1
    38d6:	00002097          	auipc	ra,0x2
    38da:	e8e080e7          	jalr	-370(ra) # 5764 <exit>
    printf("%s: chdir dots failed\n", s);
    38de:	85a6                	mv	a1,s1
    38e0:	00004517          	auipc	a0,0x4
    38e4:	f2850513          	addi	a0,a0,-216 # 7808 <malloc+0x1c66>
    38e8:	00002097          	auipc	ra,0x2
    38ec:	1fc080e7          	jalr	508(ra) # 5ae4 <printf>
    exit(1);
    38f0:	4505                	li	a0,1
    38f2:	00002097          	auipc	ra,0x2
    38f6:	e72080e7          	jalr	-398(ra) # 5764 <exit>
    printf("%s: rm . worked!\n", s);
    38fa:	85a6                	mv	a1,s1
    38fc:	00004517          	auipc	a0,0x4
    3900:	f2450513          	addi	a0,a0,-220 # 7820 <malloc+0x1c7e>
    3904:	00002097          	auipc	ra,0x2
    3908:	1e0080e7          	jalr	480(ra) # 5ae4 <printf>
    exit(1);
    390c:	4505                	li	a0,1
    390e:	00002097          	auipc	ra,0x2
    3912:	e56080e7          	jalr	-426(ra) # 5764 <exit>
    printf("%s: rm .. worked!\n", s);
    3916:	85a6                	mv	a1,s1
    3918:	00004517          	auipc	a0,0x4
    391c:	f2050513          	addi	a0,a0,-224 # 7838 <malloc+0x1c96>
    3920:	00002097          	auipc	ra,0x2
    3924:	1c4080e7          	jalr	452(ra) # 5ae4 <printf>
    exit(1);
    3928:	4505                	li	a0,1
    392a:	00002097          	auipc	ra,0x2
    392e:	e3a080e7          	jalr	-454(ra) # 5764 <exit>
    printf("%s: chdir / failed\n", s);
    3932:	85a6                	mv	a1,s1
    3934:	00004517          	auipc	a0,0x4
    3938:	8bc50513          	addi	a0,a0,-1860 # 71f0 <malloc+0x164e>
    393c:	00002097          	auipc	ra,0x2
    3940:	1a8080e7          	jalr	424(ra) # 5ae4 <printf>
    exit(1);
    3944:	4505                	li	a0,1
    3946:	00002097          	auipc	ra,0x2
    394a:	e1e080e7          	jalr	-482(ra) # 5764 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    394e:	85a6                	mv	a1,s1
    3950:	00004517          	auipc	a0,0x4
    3954:	f0850513          	addi	a0,a0,-248 # 7858 <malloc+0x1cb6>
    3958:	00002097          	auipc	ra,0x2
    395c:	18c080e7          	jalr	396(ra) # 5ae4 <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	00002097          	auipc	ra,0x2
    3966:	e02080e7          	jalr	-510(ra) # 5764 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    396a:	85a6                	mv	a1,s1
    396c:	00004517          	auipc	a0,0x4
    3970:	f1450513          	addi	a0,a0,-236 # 7880 <malloc+0x1cde>
    3974:	00002097          	auipc	ra,0x2
    3978:	170080e7          	jalr	368(ra) # 5ae4 <printf>
    exit(1);
    397c:	4505                	li	a0,1
    397e:	00002097          	auipc	ra,0x2
    3982:	de6080e7          	jalr	-538(ra) # 5764 <exit>
    printf("%s: unlink dots failed!\n", s);
    3986:	85a6                	mv	a1,s1
    3988:	00004517          	auipc	a0,0x4
    398c:	f1850513          	addi	a0,a0,-232 # 78a0 <malloc+0x1cfe>
    3990:	00002097          	auipc	ra,0x2
    3994:	154080e7          	jalr	340(ra) # 5ae4 <printf>
    exit(1);
    3998:	4505                	li	a0,1
    399a:	00002097          	auipc	ra,0x2
    399e:	dca080e7          	jalr	-566(ra) # 5764 <exit>

00000000000039a2 <dirfile>:
{
    39a2:	1101                	addi	sp,sp,-32
    39a4:	ec06                	sd	ra,24(sp)
    39a6:	e822                	sd	s0,16(sp)
    39a8:	e426                	sd	s1,8(sp)
    39aa:	e04a                	sd	s2,0(sp)
    39ac:	1000                	addi	s0,sp,32
    39ae:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    39b0:	20000593          	li	a1,512
    39b4:	00002517          	auipc	a0,0x2
    39b8:	5dc50513          	addi	a0,a0,1500 # 5f90 <malloc+0x3ee>
    39bc:	00002097          	auipc	ra,0x2
    39c0:	de8080e7          	jalr	-536(ra) # 57a4 <open>
  if(fd < 0){
    39c4:	0e054d63          	bltz	a0,3abe <dirfile+0x11c>
  close(fd);
    39c8:	00002097          	auipc	ra,0x2
    39cc:	dc4080e7          	jalr	-572(ra) # 578c <close>
  if(chdir("dirfile") == 0){
    39d0:	00002517          	auipc	a0,0x2
    39d4:	5c050513          	addi	a0,a0,1472 # 5f90 <malloc+0x3ee>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	dfc080e7          	jalr	-516(ra) # 57d4 <chdir>
    39e0:	cd6d                	beqz	a0,3ada <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    39e2:	4581                	li	a1,0
    39e4:	00004517          	auipc	a0,0x4
    39e8:	f1c50513          	addi	a0,a0,-228 # 7900 <malloc+0x1d5e>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	db8080e7          	jalr	-584(ra) # 57a4 <open>
  if(fd >= 0){
    39f4:	10055163          	bgez	a0,3af6 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    39f8:	20000593          	li	a1,512
    39fc:	00004517          	auipc	a0,0x4
    3a00:	f0450513          	addi	a0,a0,-252 # 7900 <malloc+0x1d5e>
    3a04:	00002097          	auipc	ra,0x2
    3a08:	da0080e7          	jalr	-608(ra) # 57a4 <open>
  if(fd >= 0){
    3a0c:	10055363          	bgez	a0,3b12 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	ef050513          	addi	a0,a0,-272 # 7900 <malloc+0x1d5e>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	db4080e7          	jalr	-588(ra) # 57cc <mkdir>
    3a20:	10050763          	beqz	a0,3b2e <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3a24:	00004517          	auipc	a0,0x4
    3a28:	edc50513          	addi	a0,a0,-292 # 7900 <malloc+0x1d5e>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	d88080e7          	jalr	-632(ra) # 57b4 <unlink>
    3a34:	10050b63          	beqz	a0,3b4a <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3a38:	00004597          	auipc	a1,0x4
    3a3c:	ec858593          	addi	a1,a1,-312 # 7900 <malloc+0x1d5e>
    3a40:	00002517          	auipc	a0,0x2
    3a44:	75850513          	addi	a0,a0,1880 # 6198 <malloc+0x5f6>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	d7c080e7          	jalr	-644(ra) # 57c4 <link>
    3a50:	10050b63          	beqz	a0,3b66 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3a54:	00002517          	auipc	a0,0x2
    3a58:	53c50513          	addi	a0,a0,1340 # 5f90 <malloc+0x3ee>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	d58080e7          	jalr	-680(ra) # 57b4 <unlink>
    3a64:	10051f63          	bnez	a0,3b82 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3a68:	4589                	li	a1,2
    3a6a:	00003517          	auipc	a0,0x3
    3a6e:	c2e50513          	addi	a0,a0,-978 # 6698 <malloc+0xaf6>
    3a72:	00002097          	auipc	ra,0x2
    3a76:	d32080e7          	jalr	-718(ra) # 57a4 <open>
  if(fd >= 0){
    3a7a:	12055263          	bgez	a0,3b9e <dirfile+0x1fc>
  fd = open(".", 0);
    3a7e:	4581                	li	a1,0
    3a80:	00003517          	auipc	a0,0x3
    3a84:	c1850513          	addi	a0,a0,-1000 # 6698 <malloc+0xaf6>
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	d1c080e7          	jalr	-740(ra) # 57a4 <open>
    3a90:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3a92:	4605                	li	a2,1
    3a94:	00002597          	auipc	a1,0x2
    3a98:	5dc58593          	addi	a1,a1,1500 # 6070 <malloc+0x4ce>
    3a9c:	00002097          	auipc	ra,0x2
    3aa0:	ce8080e7          	jalr	-792(ra) # 5784 <write>
    3aa4:	10a04b63          	bgtz	a0,3bba <dirfile+0x218>
  close(fd);
    3aa8:	8526                	mv	a0,s1
    3aaa:	00002097          	auipc	ra,0x2
    3aae:	ce2080e7          	jalr	-798(ra) # 578c <close>
}
    3ab2:	60e2                	ld	ra,24(sp)
    3ab4:	6442                	ld	s0,16(sp)
    3ab6:	64a2                	ld	s1,8(sp)
    3ab8:	6902                	ld	s2,0(sp)
    3aba:	6105                	addi	sp,sp,32
    3abc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3abe:	85ca                	mv	a1,s2
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	e0050513          	addi	a0,a0,-512 # 78c0 <malloc+0x1d1e>
    3ac8:	00002097          	auipc	ra,0x2
    3acc:	01c080e7          	jalr	28(ra) # 5ae4 <printf>
    exit(1);
    3ad0:	4505                	li	a0,1
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	c92080e7          	jalr	-878(ra) # 5764 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3ada:	85ca                	mv	a1,s2
    3adc:	00004517          	auipc	a0,0x4
    3ae0:	e0450513          	addi	a0,a0,-508 # 78e0 <malloc+0x1d3e>
    3ae4:	00002097          	auipc	ra,0x2
    3ae8:	000080e7          	jalr	ra # 5ae4 <printf>
    exit(1);
    3aec:	4505                	li	a0,1
    3aee:	00002097          	auipc	ra,0x2
    3af2:	c76080e7          	jalr	-906(ra) # 5764 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3af6:	85ca                	mv	a1,s2
    3af8:	00004517          	auipc	a0,0x4
    3afc:	e1850513          	addi	a0,a0,-488 # 7910 <malloc+0x1d6e>
    3b00:	00002097          	auipc	ra,0x2
    3b04:	fe4080e7          	jalr	-28(ra) # 5ae4 <printf>
    exit(1);
    3b08:	4505                	li	a0,1
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	c5a080e7          	jalr	-934(ra) # 5764 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3b12:	85ca                	mv	a1,s2
    3b14:	00004517          	auipc	a0,0x4
    3b18:	dfc50513          	addi	a0,a0,-516 # 7910 <malloc+0x1d6e>
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	fc8080e7          	jalr	-56(ra) # 5ae4 <printf>
    exit(1);
    3b24:	4505                	li	a0,1
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	c3e080e7          	jalr	-962(ra) # 5764 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3b2e:	85ca                	mv	a1,s2
    3b30:	00004517          	auipc	a0,0x4
    3b34:	e0850513          	addi	a0,a0,-504 # 7938 <malloc+0x1d96>
    3b38:	00002097          	auipc	ra,0x2
    3b3c:	fac080e7          	jalr	-84(ra) # 5ae4 <printf>
    exit(1);
    3b40:	4505                	li	a0,1
    3b42:	00002097          	auipc	ra,0x2
    3b46:	c22080e7          	jalr	-990(ra) # 5764 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3b4a:	85ca                	mv	a1,s2
    3b4c:	00004517          	auipc	a0,0x4
    3b50:	e1450513          	addi	a0,a0,-492 # 7960 <malloc+0x1dbe>
    3b54:	00002097          	auipc	ra,0x2
    3b58:	f90080e7          	jalr	-112(ra) # 5ae4 <printf>
    exit(1);
    3b5c:	4505                	li	a0,1
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	c06080e7          	jalr	-1018(ra) # 5764 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3b66:	85ca                	mv	a1,s2
    3b68:	00004517          	auipc	a0,0x4
    3b6c:	e2050513          	addi	a0,a0,-480 # 7988 <malloc+0x1de6>
    3b70:	00002097          	auipc	ra,0x2
    3b74:	f74080e7          	jalr	-140(ra) # 5ae4 <printf>
    exit(1);
    3b78:	4505                	li	a0,1
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	bea080e7          	jalr	-1046(ra) # 5764 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3b82:	85ca                	mv	a1,s2
    3b84:	00004517          	auipc	a0,0x4
    3b88:	e2c50513          	addi	a0,a0,-468 # 79b0 <malloc+0x1e0e>
    3b8c:	00002097          	auipc	ra,0x2
    3b90:	f58080e7          	jalr	-168(ra) # 5ae4 <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	bce080e7          	jalr	-1074(ra) # 5764 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3b9e:	85ca                	mv	a1,s2
    3ba0:	00004517          	auipc	a0,0x4
    3ba4:	e3050513          	addi	a0,a0,-464 # 79d0 <malloc+0x1e2e>
    3ba8:	00002097          	auipc	ra,0x2
    3bac:	f3c080e7          	jalr	-196(ra) # 5ae4 <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	bb2080e7          	jalr	-1102(ra) # 5764 <exit>
    printf("%s: write . succeeded!\n", s);
    3bba:	85ca                	mv	a1,s2
    3bbc:	00004517          	auipc	a0,0x4
    3bc0:	e3c50513          	addi	a0,a0,-452 # 79f8 <malloc+0x1e56>
    3bc4:	00002097          	auipc	ra,0x2
    3bc8:	f20080e7          	jalr	-224(ra) # 5ae4 <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	b96080e7          	jalr	-1130(ra) # 5764 <exit>

0000000000003bd6 <iref>:
{
    3bd6:	7139                	addi	sp,sp,-64
    3bd8:	fc06                	sd	ra,56(sp)
    3bda:	f822                	sd	s0,48(sp)
    3bdc:	f426                	sd	s1,40(sp)
    3bde:	f04a                	sd	s2,32(sp)
    3be0:	ec4e                	sd	s3,24(sp)
    3be2:	e852                	sd	s4,16(sp)
    3be4:	e456                	sd	s5,8(sp)
    3be6:	e05a                	sd	s6,0(sp)
    3be8:	0080                	addi	s0,sp,64
    3bea:	8b2a                	mv	s6,a0
    3bec:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3bf0:	00004a17          	auipc	s4,0x4
    3bf4:	e20a0a13          	addi	s4,s4,-480 # 7a10 <malloc+0x1e6e>
    mkdir("");
    3bf8:	00004497          	auipc	s1,0x4
    3bfc:	92848493          	addi	s1,s1,-1752 # 7520 <malloc+0x197e>
    link("README", "");
    3c00:	00002a97          	auipc	s5,0x2
    3c04:	598a8a93          	addi	s5,s5,1432 # 6198 <malloc+0x5f6>
    fd = open("xx", O_CREATE);
    3c08:	00004997          	auipc	s3,0x4
    3c0c:	d0098993          	addi	s3,s3,-768 # 7908 <malloc+0x1d66>
    3c10:	a891                	j	3c64 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3c12:	85da                	mv	a1,s6
    3c14:	00004517          	auipc	a0,0x4
    3c18:	e0450513          	addi	a0,a0,-508 # 7a18 <malloc+0x1e76>
    3c1c:	00002097          	auipc	ra,0x2
    3c20:	ec8080e7          	jalr	-312(ra) # 5ae4 <printf>
      exit(1);
    3c24:	4505                	li	a0,1
    3c26:	00002097          	auipc	ra,0x2
    3c2a:	b3e080e7          	jalr	-1218(ra) # 5764 <exit>
      printf("%s: chdir irefd failed\n", s);
    3c2e:	85da                	mv	a1,s6
    3c30:	00004517          	auipc	a0,0x4
    3c34:	e0050513          	addi	a0,a0,-512 # 7a30 <malloc+0x1e8e>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	eac080e7          	jalr	-340(ra) # 5ae4 <printf>
      exit(1);
    3c40:	4505                	li	a0,1
    3c42:	00002097          	auipc	ra,0x2
    3c46:	b22080e7          	jalr	-1246(ra) # 5764 <exit>
      close(fd);
    3c4a:	00002097          	auipc	ra,0x2
    3c4e:	b42080e7          	jalr	-1214(ra) # 578c <close>
    3c52:	a889                	j	3ca4 <iref+0xce>
    unlink("xx");
    3c54:	854e                	mv	a0,s3
    3c56:	00002097          	auipc	ra,0x2
    3c5a:	b5e080e7          	jalr	-1186(ra) # 57b4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3c5e:	397d                	addiw	s2,s2,-1
    3c60:	06090063          	beqz	s2,3cc0 <iref+0xea>
    if(mkdir("irefd") != 0){
    3c64:	8552                	mv	a0,s4
    3c66:	00002097          	auipc	ra,0x2
    3c6a:	b66080e7          	jalr	-1178(ra) # 57cc <mkdir>
    3c6e:	f155                	bnez	a0,3c12 <iref+0x3c>
    if(chdir("irefd") != 0){
    3c70:	8552                	mv	a0,s4
    3c72:	00002097          	auipc	ra,0x2
    3c76:	b62080e7          	jalr	-1182(ra) # 57d4 <chdir>
    3c7a:	f955                	bnez	a0,3c2e <iref+0x58>
    mkdir("");
    3c7c:	8526                	mv	a0,s1
    3c7e:	00002097          	auipc	ra,0x2
    3c82:	b4e080e7          	jalr	-1202(ra) # 57cc <mkdir>
    link("README", "");
    3c86:	85a6                	mv	a1,s1
    3c88:	8556                	mv	a0,s5
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	b3a080e7          	jalr	-1222(ra) # 57c4 <link>
    fd = open("", O_CREATE);
    3c92:	20000593          	li	a1,512
    3c96:	8526                	mv	a0,s1
    3c98:	00002097          	auipc	ra,0x2
    3c9c:	b0c080e7          	jalr	-1268(ra) # 57a4 <open>
    if(fd >= 0)
    3ca0:	fa0555e3          	bgez	a0,3c4a <iref+0x74>
    fd = open("xx", O_CREATE);
    3ca4:	20000593          	li	a1,512
    3ca8:	854e                	mv	a0,s3
    3caa:	00002097          	auipc	ra,0x2
    3cae:	afa080e7          	jalr	-1286(ra) # 57a4 <open>
    if(fd >= 0)
    3cb2:	fa0541e3          	bltz	a0,3c54 <iref+0x7e>
      close(fd);
    3cb6:	00002097          	auipc	ra,0x2
    3cba:	ad6080e7          	jalr	-1322(ra) # 578c <close>
    3cbe:	bf59                	j	3c54 <iref+0x7e>
    3cc0:	03300493          	li	s1,51
    chdir("..");
    3cc4:	00003997          	auipc	s3,0x3
    3cc8:	57c98993          	addi	s3,s3,1404 # 7240 <malloc+0x169e>
    unlink("irefd");
    3ccc:	00004917          	auipc	s2,0x4
    3cd0:	d4490913          	addi	s2,s2,-700 # 7a10 <malloc+0x1e6e>
    chdir("..");
    3cd4:	854e                	mv	a0,s3
    3cd6:	00002097          	auipc	ra,0x2
    3cda:	afe080e7          	jalr	-1282(ra) # 57d4 <chdir>
    unlink("irefd");
    3cde:	854a                	mv	a0,s2
    3ce0:	00002097          	auipc	ra,0x2
    3ce4:	ad4080e7          	jalr	-1324(ra) # 57b4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3ce8:	34fd                	addiw	s1,s1,-1
    3cea:	f4ed                	bnez	s1,3cd4 <iref+0xfe>
  chdir("/");
    3cec:	00003517          	auipc	a0,0x3
    3cf0:	4fc50513          	addi	a0,a0,1276 # 71e8 <malloc+0x1646>
    3cf4:	00002097          	auipc	ra,0x2
    3cf8:	ae0080e7          	jalr	-1312(ra) # 57d4 <chdir>
}
    3cfc:	70e2                	ld	ra,56(sp)
    3cfe:	7442                	ld	s0,48(sp)
    3d00:	74a2                	ld	s1,40(sp)
    3d02:	7902                	ld	s2,32(sp)
    3d04:	69e2                	ld	s3,24(sp)
    3d06:	6a42                	ld	s4,16(sp)
    3d08:	6aa2                	ld	s5,8(sp)
    3d0a:	6b02                	ld	s6,0(sp)
    3d0c:	6121                	addi	sp,sp,64
    3d0e:	8082                	ret

0000000000003d10 <openiputtest>:
{
    3d10:	7179                	addi	sp,sp,-48
    3d12:	f406                	sd	ra,40(sp)
    3d14:	f022                	sd	s0,32(sp)
    3d16:	ec26                	sd	s1,24(sp)
    3d18:	1800                	addi	s0,sp,48
    3d1a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    3d1c:	00004517          	auipc	a0,0x4
    3d20:	d2c50513          	addi	a0,a0,-724 # 7a48 <malloc+0x1ea6>
    3d24:	00002097          	auipc	ra,0x2
    3d28:	aa8080e7          	jalr	-1368(ra) # 57cc <mkdir>
    3d2c:	04054263          	bltz	a0,3d70 <openiputtest+0x60>
  pid = fork();
    3d30:	00002097          	auipc	ra,0x2
    3d34:	a2c080e7          	jalr	-1492(ra) # 575c <fork>
  if(pid < 0){
    3d38:	04054a63          	bltz	a0,3d8c <openiputtest+0x7c>
  if(pid == 0){
    3d3c:	e93d                	bnez	a0,3db2 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    3d3e:	4589                	li	a1,2
    3d40:	00004517          	auipc	a0,0x4
    3d44:	d0850513          	addi	a0,a0,-760 # 7a48 <malloc+0x1ea6>
    3d48:	00002097          	auipc	ra,0x2
    3d4c:	a5c080e7          	jalr	-1444(ra) # 57a4 <open>
    if(fd >= 0){
    3d50:	04054c63          	bltz	a0,3da8 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    3d54:	85a6                	mv	a1,s1
    3d56:	00004517          	auipc	a0,0x4
    3d5a:	d1250513          	addi	a0,a0,-750 # 7a68 <malloc+0x1ec6>
    3d5e:	00002097          	auipc	ra,0x2
    3d62:	d86080e7          	jalr	-634(ra) # 5ae4 <printf>
      exit(1);
    3d66:	4505                	li	a0,1
    3d68:	00002097          	auipc	ra,0x2
    3d6c:	9fc080e7          	jalr	-1540(ra) # 5764 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3d70:	85a6                	mv	a1,s1
    3d72:	00004517          	auipc	a0,0x4
    3d76:	cde50513          	addi	a0,a0,-802 # 7a50 <malloc+0x1eae>
    3d7a:	00002097          	auipc	ra,0x2
    3d7e:	d6a080e7          	jalr	-662(ra) # 5ae4 <printf>
    exit(1);
    3d82:	4505                	li	a0,1
    3d84:	00002097          	auipc	ra,0x2
    3d88:	9e0080e7          	jalr	-1568(ra) # 5764 <exit>
    printf("%s: fork failed\n", s);
    3d8c:	85a6                	mv	a1,s1
    3d8e:	00003517          	auipc	a0,0x3
    3d92:	aaa50513          	addi	a0,a0,-1366 # 6838 <malloc+0xc96>
    3d96:	00002097          	auipc	ra,0x2
    3d9a:	d4e080e7          	jalr	-690(ra) # 5ae4 <printf>
    exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	00002097          	auipc	ra,0x2
    3da4:	9c4080e7          	jalr	-1596(ra) # 5764 <exit>
    exit(0);
    3da8:	4501                	li	a0,0
    3daa:	00002097          	auipc	ra,0x2
    3dae:	9ba080e7          	jalr	-1606(ra) # 5764 <exit>
  sleep(1);
    3db2:	4505                	li	a0,1
    3db4:	00002097          	auipc	ra,0x2
    3db8:	a40080e7          	jalr	-1472(ra) # 57f4 <sleep>
  if(unlink("oidir") != 0){
    3dbc:	00004517          	auipc	a0,0x4
    3dc0:	c8c50513          	addi	a0,a0,-884 # 7a48 <malloc+0x1ea6>
    3dc4:	00002097          	auipc	ra,0x2
    3dc8:	9f0080e7          	jalr	-1552(ra) # 57b4 <unlink>
    3dcc:	cd19                	beqz	a0,3dea <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3dce:	85a6                	mv	a1,s1
    3dd0:	00003517          	auipc	a0,0x3
    3dd4:	c5850513          	addi	a0,a0,-936 # 6a28 <malloc+0xe86>
    3dd8:	00002097          	auipc	ra,0x2
    3ddc:	d0c080e7          	jalr	-756(ra) # 5ae4 <printf>
    exit(1);
    3de0:	4505                	li	a0,1
    3de2:	00002097          	auipc	ra,0x2
    3de6:	982080e7          	jalr	-1662(ra) # 5764 <exit>
  wait(&xstatus);
    3dea:	fdc40513          	addi	a0,s0,-36
    3dee:	00002097          	auipc	ra,0x2
    3df2:	97e080e7          	jalr	-1666(ra) # 576c <wait>
  exit(xstatus);
    3df6:	fdc42503          	lw	a0,-36(s0)
    3dfa:	00002097          	auipc	ra,0x2
    3dfe:	96a080e7          	jalr	-1686(ra) # 5764 <exit>

0000000000003e02 <forkforkfork>:
{
    3e02:	1101                	addi	sp,sp,-32
    3e04:	ec06                	sd	ra,24(sp)
    3e06:	e822                	sd	s0,16(sp)
    3e08:	e426                	sd	s1,8(sp)
    3e0a:	1000                	addi	s0,sp,32
    3e0c:	84aa                	mv	s1,a0
  unlink("stopforking");
    3e0e:	00004517          	auipc	a0,0x4
    3e12:	c8250513          	addi	a0,a0,-894 # 7a90 <malloc+0x1eee>
    3e16:	00002097          	auipc	ra,0x2
    3e1a:	99e080e7          	jalr	-1634(ra) # 57b4 <unlink>
  int pid = fork();
    3e1e:	00002097          	auipc	ra,0x2
    3e22:	93e080e7          	jalr	-1730(ra) # 575c <fork>
  if(pid < 0){
    3e26:	04054563          	bltz	a0,3e70 <forkforkfork+0x6e>
  if(pid == 0){
    3e2a:	c12d                	beqz	a0,3e8c <forkforkfork+0x8a>
  sleep(20); // two seconds
    3e2c:	4551                	li	a0,20
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	9c6080e7          	jalr	-1594(ra) # 57f4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3e36:	20200593          	li	a1,514
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	c5650513          	addi	a0,a0,-938 # 7a90 <malloc+0x1eee>
    3e42:	00002097          	auipc	ra,0x2
    3e46:	962080e7          	jalr	-1694(ra) # 57a4 <open>
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	942080e7          	jalr	-1726(ra) # 578c <close>
  wait(0);
    3e52:	4501                	li	a0,0
    3e54:	00002097          	auipc	ra,0x2
    3e58:	918080e7          	jalr	-1768(ra) # 576c <wait>
  sleep(10); // one second
    3e5c:	4529                	li	a0,10
    3e5e:	00002097          	auipc	ra,0x2
    3e62:	996080e7          	jalr	-1642(ra) # 57f4 <sleep>
}
    3e66:	60e2                	ld	ra,24(sp)
    3e68:	6442                	ld	s0,16(sp)
    3e6a:	64a2                	ld	s1,8(sp)
    3e6c:	6105                	addi	sp,sp,32
    3e6e:	8082                	ret
    printf("%s: fork failed", s);
    3e70:	85a6                	mv	a1,s1
    3e72:	00003517          	auipc	a0,0x3
    3e76:	b8650513          	addi	a0,a0,-1146 # 69f8 <malloc+0xe56>
    3e7a:	00002097          	auipc	ra,0x2
    3e7e:	c6a080e7          	jalr	-918(ra) # 5ae4 <printf>
    exit(1);
    3e82:	4505                	li	a0,1
    3e84:	00002097          	auipc	ra,0x2
    3e88:	8e0080e7          	jalr	-1824(ra) # 5764 <exit>
      int fd = open("stopforking", 0);
    3e8c:	00004497          	auipc	s1,0x4
    3e90:	c0448493          	addi	s1,s1,-1020 # 7a90 <malloc+0x1eee>
    3e94:	4581                	li	a1,0
    3e96:	8526                	mv	a0,s1
    3e98:	00002097          	auipc	ra,0x2
    3e9c:	90c080e7          	jalr	-1780(ra) # 57a4 <open>
      if(fd >= 0){
    3ea0:	02055463          	bgez	a0,3ec8 <forkforkfork+0xc6>
      if(fork() < 0){
    3ea4:	00002097          	auipc	ra,0x2
    3ea8:	8b8080e7          	jalr	-1864(ra) # 575c <fork>
    3eac:	fe0554e3          	bgez	a0,3e94 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3eb0:	20200593          	li	a1,514
    3eb4:	8526                	mv	a0,s1
    3eb6:	00002097          	auipc	ra,0x2
    3eba:	8ee080e7          	jalr	-1810(ra) # 57a4 <open>
    3ebe:	00002097          	auipc	ra,0x2
    3ec2:	8ce080e7          	jalr	-1842(ra) # 578c <close>
    3ec6:	b7f9                	j	3e94 <forkforkfork+0x92>
        exit(0);
    3ec8:	4501                	li	a0,0
    3eca:	00002097          	auipc	ra,0x2
    3ece:	89a080e7          	jalr	-1894(ra) # 5764 <exit>

0000000000003ed2 <killstatus>:
{
    3ed2:	7139                	addi	sp,sp,-64
    3ed4:	fc06                	sd	ra,56(sp)
    3ed6:	f822                	sd	s0,48(sp)
    3ed8:	f426                	sd	s1,40(sp)
    3eda:	f04a                	sd	s2,32(sp)
    3edc:	ec4e                	sd	s3,24(sp)
    3ede:	e852                	sd	s4,16(sp)
    3ee0:	0080                	addi	s0,sp,64
    3ee2:	8a2a                	mv	s4,a0
    3ee4:	06400913          	li	s2,100
    if(xst != -1) {
    3ee8:	59fd                	li	s3,-1
    int pid1 = fork();
    3eea:	00002097          	auipc	ra,0x2
    3eee:	872080e7          	jalr	-1934(ra) # 575c <fork>
    3ef2:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3ef4:	02054f63          	bltz	a0,3f32 <killstatus+0x60>
    if(pid1 == 0){
    3ef8:	c939                	beqz	a0,3f4e <killstatus+0x7c>
    sleep(1);
    3efa:	4505                	li	a0,1
    3efc:	00002097          	auipc	ra,0x2
    3f00:	8f8080e7          	jalr	-1800(ra) # 57f4 <sleep>
    kill(pid1);
    3f04:	8526                	mv	a0,s1
    3f06:	00002097          	auipc	ra,0x2
    3f0a:	88e080e7          	jalr	-1906(ra) # 5794 <kill>
    wait(&xst);
    3f0e:	fcc40513          	addi	a0,s0,-52
    3f12:	00002097          	auipc	ra,0x2
    3f16:	85a080e7          	jalr	-1958(ra) # 576c <wait>
    if(xst != -1) {
    3f1a:	fcc42783          	lw	a5,-52(s0)
    3f1e:	03379d63          	bne	a5,s3,3f58 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    3f22:	397d                	addiw	s2,s2,-1
    3f24:	fc0913e3          	bnez	s2,3eea <killstatus+0x18>
  exit(0);
    3f28:	4501                	li	a0,0
    3f2a:	00002097          	auipc	ra,0x2
    3f2e:	83a080e7          	jalr	-1990(ra) # 5764 <exit>
      printf("%s: fork failed\n", s);
    3f32:	85d2                	mv	a1,s4
    3f34:	00003517          	auipc	a0,0x3
    3f38:	90450513          	addi	a0,a0,-1788 # 6838 <malloc+0xc96>
    3f3c:	00002097          	auipc	ra,0x2
    3f40:	ba8080e7          	jalr	-1112(ra) # 5ae4 <printf>
      exit(1);
    3f44:	4505                	li	a0,1
    3f46:	00002097          	auipc	ra,0x2
    3f4a:	81e080e7          	jalr	-2018(ra) # 5764 <exit>
        getpid();
    3f4e:	00002097          	auipc	ra,0x2
    3f52:	896080e7          	jalr	-1898(ra) # 57e4 <getpid>
      while(1) {
    3f56:	bfe5                	j	3f4e <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    3f58:	85d2                	mv	a1,s4
    3f5a:	00004517          	auipc	a0,0x4
    3f5e:	b4650513          	addi	a0,a0,-1210 # 7aa0 <malloc+0x1efe>
    3f62:	00002097          	auipc	ra,0x2
    3f66:	b82080e7          	jalr	-1150(ra) # 5ae4 <printf>
       exit(1);
    3f6a:	4505                	li	a0,1
    3f6c:	00001097          	auipc	ra,0x1
    3f70:	7f8080e7          	jalr	2040(ra) # 5764 <exit>

0000000000003f74 <preempt>:
{
    3f74:	7139                	addi	sp,sp,-64
    3f76:	fc06                	sd	ra,56(sp)
    3f78:	f822                	sd	s0,48(sp)
    3f7a:	f426                	sd	s1,40(sp)
    3f7c:	f04a                	sd	s2,32(sp)
    3f7e:	ec4e                	sd	s3,24(sp)
    3f80:	e852                	sd	s4,16(sp)
    3f82:	0080                	addi	s0,sp,64
    3f84:	892a                	mv	s2,a0
  pid1 = fork();
    3f86:	00001097          	auipc	ra,0x1
    3f8a:	7d6080e7          	jalr	2006(ra) # 575c <fork>
  if(pid1 < 0) {
    3f8e:	00054563          	bltz	a0,3f98 <preempt+0x24>
    3f92:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3f94:	e105                	bnez	a0,3fb4 <preempt+0x40>
    for(;;)
    3f96:	a001                	j	3f96 <preempt+0x22>
    printf("%s: fork failed", s);
    3f98:	85ca                	mv	a1,s2
    3f9a:	00003517          	auipc	a0,0x3
    3f9e:	a5e50513          	addi	a0,a0,-1442 # 69f8 <malloc+0xe56>
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	b42080e7          	jalr	-1214(ra) # 5ae4 <printf>
    exit(1);
    3faa:	4505                	li	a0,1
    3fac:	00001097          	auipc	ra,0x1
    3fb0:	7b8080e7          	jalr	1976(ra) # 5764 <exit>
  pid2 = fork();
    3fb4:	00001097          	auipc	ra,0x1
    3fb8:	7a8080e7          	jalr	1960(ra) # 575c <fork>
    3fbc:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3fbe:	00054463          	bltz	a0,3fc6 <preempt+0x52>
  if(pid2 == 0)
    3fc2:	e105                	bnez	a0,3fe2 <preempt+0x6e>
    for(;;)
    3fc4:	a001                	j	3fc4 <preempt+0x50>
    printf("%s: fork failed\n", s);
    3fc6:	85ca                	mv	a1,s2
    3fc8:	00003517          	auipc	a0,0x3
    3fcc:	87050513          	addi	a0,a0,-1936 # 6838 <malloc+0xc96>
    3fd0:	00002097          	auipc	ra,0x2
    3fd4:	b14080e7          	jalr	-1260(ra) # 5ae4 <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00001097          	auipc	ra,0x1
    3fde:	78a080e7          	jalr	1930(ra) # 5764 <exit>
  pipe(pfds);
    3fe2:	fc840513          	addi	a0,s0,-56
    3fe6:	00001097          	auipc	ra,0x1
    3fea:	78e080e7          	jalr	1934(ra) # 5774 <pipe>
  pid3 = fork();
    3fee:	00001097          	auipc	ra,0x1
    3ff2:	76e080e7          	jalr	1902(ra) # 575c <fork>
    3ff6:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3ff8:	02054e63          	bltz	a0,4034 <preempt+0xc0>
  if(pid3 == 0){
    3ffc:	e525                	bnez	a0,4064 <preempt+0xf0>
    close(pfds[0]);
    3ffe:	fc842503          	lw	a0,-56(s0)
    4002:	00001097          	auipc	ra,0x1
    4006:	78a080e7          	jalr	1930(ra) # 578c <close>
    if(write(pfds[1], "x", 1) != 1)
    400a:	4605                	li	a2,1
    400c:	00002597          	auipc	a1,0x2
    4010:	06458593          	addi	a1,a1,100 # 6070 <malloc+0x4ce>
    4014:	fcc42503          	lw	a0,-52(s0)
    4018:	00001097          	auipc	ra,0x1
    401c:	76c080e7          	jalr	1900(ra) # 5784 <write>
    4020:	4785                	li	a5,1
    4022:	02f51763          	bne	a0,a5,4050 <preempt+0xdc>
    close(pfds[1]);
    4026:	fcc42503          	lw	a0,-52(s0)
    402a:	00001097          	auipc	ra,0x1
    402e:	762080e7          	jalr	1890(ra) # 578c <close>
    for(;;)
    4032:	a001                	j	4032 <preempt+0xbe>
     printf("%s: fork failed\n", s);
    4034:	85ca                	mv	a1,s2
    4036:	00003517          	auipc	a0,0x3
    403a:	80250513          	addi	a0,a0,-2046 # 6838 <malloc+0xc96>
    403e:	00002097          	auipc	ra,0x2
    4042:	aa6080e7          	jalr	-1370(ra) # 5ae4 <printf>
     exit(1);
    4046:	4505                	li	a0,1
    4048:	00001097          	auipc	ra,0x1
    404c:	71c080e7          	jalr	1820(ra) # 5764 <exit>
      printf("%s: preempt write error", s);
    4050:	85ca                	mv	a1,s2
    4052:	00004517          	auipc	a0,0x4
    4056:	a6e50513          	addi	a0,a0,-1426 # 7ac0 <malloc+0x1f1e>
    405a:	00002097          	auipc	ra,0x2
    405e:	a8a080e7          	jalr	-1398(ra) # 5ae4 <printf>
    4062:	b7d1                	j	4026 <preempt+0xb2>
  close(pfds[1]);
    4064:	fcc42503          	lw	a0,-52(s0)
    4068:	00001097          	auipc	ra,0x1
    406c:	724080e7          	jalr	1828(ra) # 578c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4070:	660d                	lui	a2,0x3
    4072:	00008597          	auipc	a1,0x8
    4076:	c1658593          	addi	a1,a1,-1002 # bc88 <buf>
    407a:	fc842503          	lw	a0,-56(s0)
    407e:	00001097          	auipc	ra,0x1
    4082:	6fe080e7          	jalr	1790(ra) # 577c <read>
    4086:	4785                	li	a5,1
    4088:	02f50363          	beq	a0,a5,40ae <preempt+0x13a>
    printf("%s: preempt read error", s);
    408c:	85ca                	mv	a1,s2
    408e:	00004517          	auipc	a0,0x4
    4092:	a4a50513          	addi	a0,a0,-1462 # 7ad8 <malloc+0x1f36>
    4096:	00002097          	auipc	ra,0x2
    409a:	a4e080e7          	jalr	-1458(ra) # 5ae4 <printf>
}
    409e:	70e2                	ld	ra,56(sp)
    40a0:	7442                	ld	s0,48(sp)
    40a2:	74a2                	ld	s1,40(sp)
    40a4:	7902                	ld	s2,32(sp)
    40a6:	69e2                	ld	s3,24(sp)
    40a8:	6a42                	ld	s4,16(sp)
    40aa:	6121                	addi	sp,sp,64
    40ac:	8082                	ret
  close(pfds[0]);
    40ae:	fc842503          	lw	a0,-56(s0)
    40b2:	00001097          	auipc	ra,0x1
    40b6:	6da080e7          	jalr	1754(ra) # 578c <close>
  printf("kill... ");
    40ba:	00004517          	auipc	a0,0x4
    40be:	a3650513          	addi	a0,a0,-1482 # 7af0 <malloc+0x1f4e>
    40c2:	00002097          	auipc	ra,0x2
    40c6:	a22080e7          	jalr	-1502(ra) # 5ae4 <printf>
  kill(pid1);
    40ca:	8526                	mv	a0,s1
    40cc:	00001097          	auipc	ra,0x1
    40d0:	6c8080e7          	jalr	1736(ra) # 5794 <kill>
  kill(pid2);
    40d4:	854e                	mv	a0,s3
    40d6:	00001097          	auipc	ra,0x1
    40da:	6be080e7          	jalr	1726(ra) # 5794 <kill>
  kill(pid3);
    40de:	8552                	mv	a0,s4
    40e0:	00001097          	auipc	ra,0x1
    40e4:	6b4080e7          	jalr	1716(ra) # 5794 <kill>
  printf("wait... ");
    40e8:	00004517          	auipc	a0,0x4
    40ec:	a1850513          	addi	a0,a0,-1512 # 7b00 <malloc+0x1f5e>
    40f0:	00002097          	auipc	ra,0x2
    40f4:	9f4080e7          	jalr	-1548(ra) # 5ae4 <printf>
  wait(0);
    40f8:	4501                	li	a0,0
    40fa:	00001097          	auipc	ra,0x1
    40fe:	672080e7          	jalr	1650(ra) # 576c <wait>
  wait(0);
    4102:	4501                	li	a0,0
    4104:	00001097          	auipc	ra,0x1
    4108:	668080e7          	jalr	1640(ra) # 576c <wait>
  wait(0);
    410c:	4501                	li	a0,0
    410e:	00001097          	auipc	ra,0x1
    4112:	65e080e7          	jalr	1630(ra) # 576c <wait>
    4116:	b761                	j	409e <preempt+0x12a>

0000000000004118 <reparent>:
{
    4118:	7179                	addi	sp,sp,-48
    411a:	f406                	sd	ra,40(sp)
    411c:	f022                	sd	s0,32(sp)
    411e:	ec26                	sd	s1,24(sp)
    4120:	e84a                	sd	s2,16(sp)
    4122:	e44e                	sd	s3,8(sp)
    4124:	e052                	sd	s4,0(sp)
    4126:	1800                	addi	s0,sp,48
    4128:	89aa                	mv	s3,a0
  int master_pid = getpid();
    412a:	00001097          	auipc	ra,0x1
    412e:	6ba080e7          	jalr	1722(ra) # 57e4 <getpid>
    4132:	8a2a                	mv	s4,a0
    4134:	0c800913          	li	s2,200
    int pid = fork();
    4138:	00001097          	auipc	ra,0x1
    413c:	624080e7          	jalr	1572(ra) # 575c <fork>
    4140:	84aa                	mv	s1,a0
    if(pid < 0){
    4142:	02054263          	bltz	a0,4166 <reparent+0x4e>
    if(pid){
    4146:	cd21                	beqz	a0,419e <reparent+0x86>
      if(wait(0) != pid){
    4148:	4501                	li	a0,0
    414a:	00001097          	auipc	ra,0x1
    414e:	622080e7          	jalr	1570(ra) # 576c <wait>
    4152:	02951863          	bne	a0,s1,4182 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    4156:	397d                	addiw	s2,s2,-1
    4158:	fe0910e3          	bnez	s2,4138 <reparent+0x20>
  exit(0);
    415c:	4501                	li	a0,0
    415e:	00001097          	auipc	ra,0x1
    4162:	606080e7          	jalr	1542(ra) # 5764 <exit>
      printf("%s: fork failed\n", s);
    4166:	85ce                	mv	a1,s3
    4168:	00002517          	auipc	a0,0x2
    416c:	6d050513          	addi	a0,a0,1744 # 6838 <malloc+0xc96>
    4170:	00002097          	auipc	ra,0x2
    4174:	974080e7          	jalr	-1676(ra) # 5ae4 <printf>
      exit(1);
    4178:	4505                	li	a0,1
    417a:	00001097          	auipc	ra,0x1
    417e:	5ea080e7          	jalr	1514(ra) # 5764 <exit>
        printf("%s: wait wrong pid\n", s);
    4182:	85ce                	mv	a1,s3
    4184:	00003517          	auipc	a0,0x3
    4188:	83c50513          	addi	a0,a0,-1988 # 69c0 <malloc+0xe1e>
    418c:	00002097          	auipc	ra,0x2
    4190:	958080e7          	jalr	-1704(ra) # 5ae4 <printf>
        exit(1);
    4194:	4505                	li	a0,1
    4196:	00001097          	auipc	ra,0x1
    419a:	5ce080e7          	jalr	1486(ra) # 5764 <exit>
      int pid2 = fork();
    419e:	00001097          	auipc	ra,0x1
    41a2:	5be080e7          	jalr	1470(ra) # 575c <fork>
      if(pid2 < 0){
    41a6:	00054763          	bltz	a0,41b4 <reparent+0x9c>
      exit(0);
    41aa:	4501                	li	a0,0
    41ac:	00001097          	auipc	ra,0x1
    41b0:	5b8080e7          	jalr	1464(ra) # 5764 <exit>
        kill(master_pid);
    41b4:	8552                	mv	a0,s4
    41b6:	00001097          	auipc	ra,0x1
    41ba:	5de080e7          	jalr	1502(ra) # 5794 <kill>
        exit(1);
    41be:	4505                	li	a0,1
    41c0:	00001097          	auipc	ra,0x1
    41c4:	5a4080e7          	jalr	1444(ra) # 5764 <exit>

00000000000041c8 <sbrkfail>:
{
    41c8:	7119                	addi	sp,sp,-128
    41ca:	fc86                	sd	ra,120(sp)
    41cc:	f8a2                	sd	s0,112(sp)
    41ce:	f4a6                	sd	s1,104(sp)
    41d0:	f0ca                	sd	s2,96(sp)
    41d2:	ecce                	sd	s3,88(sp)
    41d4:	e8d2                	sd	s4,80(sp)
    41d6:	e4d6                	sd	s5,72(sp)
    41d8:	0100                	addi	s0,sp,128
    41da:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    41dc:	fb040513          	addi	a0,s0,-80
    41e0:	00001097          	auipc	ra,0x1
    41e4:	594080e7          	jalr	1428(ra) # 5774 <pipe>
    41e8:	e901                	bnez	a0,41f8 <sbrkfail+0x30>
    41ea:	f8040493          	addi	s1,s0,-128
    41ee:	fa840993          	addi	s3,s0,-88
    41f2:	8926                	mv	s2,s1
    if(pids[i] != -1)
    41f4:	5a7d                	li	s4,-1
    41f6:	a085                	j	4256 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    41f8:	85d6                	mv	a1,s5
    41fa:	00002517          	auipc	a0,0x2
    41fe:	74650513          	addi	a0,a0,1862 # 6940 <malloc+0xd9e>
    4202:	00002097          	auipc	ra,0x2
    4206:	8e2080e7          	jalr	-1822(ra) # 5ae4 <printf>
    exit(1);
    420a:	4505                	li	a0,1
    420c:	00001097          	auipc	ra,0x1
    4210:	558080e7          	jalr	1368(ra) # 5764 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4214:	00001097          	auipc	ra,0x1
    4218:	5d8080e7          	jalr	1496(ra) # 57ec <sbrk>
    421c:	064007b7          	lui	a5,0x6400
    4220:	40a7853b          	subw	a0,a5,a0
    4224:	00001097          	auipc	ra,0x1
    4228:	5c8080e7          	jalr	1480(ra) # 57ec <sbrk>
      write(fds[1], "x", 1);
    422c:	4605                	li	a2,1
    422e:	00002597          	auipc	a1,0x2
    4232:	e4258593          	addi	a1,a1,-446 # 6070 <malloc+0x4ce>
    4236:	fb442503          	lw	a0,-76(s0)
    423a:	00001097          	auipc	ra,0x1
    423e:	54a080e7          	jalr	1354(ra) # 5784 <write>
      for(;;) sleep(1000);
    4242:	3e800513          	li	a0,1000
    4246:	00001097          	auipc	ra,0x1
    424a:	5ae080e7          	jalr	1454(ra) # 57f4 <sleep>
    424e:	bfd5                	j	4242 <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4250:	0911                	addi	s2,s2,4
    4252:	03390563          	beq	s2,s3,427c <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    4256:	00001097          	auipc	ra,0x1
    425a:	506080e7          	jalr	1286(ra) # 575c <fork>
    425e:	00a92023          	sw	a0,0(s2)
    4262:	d94d                	beqz	a0,4214 <sbrkfail+0x4c>
    if(pids[i] != -1)
    4264:	ff4506e3          	beq	a0,s4,4250 <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4268:	4605                	li	a2,1
    426a:	faf40593          	addi	a1,s0,-81
    426e:	fb042503          	lw	a0,-80(s0)
    4272:	00001097          	auipc	ra,0x1
    4276:	50a080e7          	jalr	1290(ra) # 577c <read>
    427a:	bfd9                	j	4250 <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    427c:	6505                	lui	a0,0x1
    427e:	00001097          	auipc	ra,0x1
    4282:	56e080e7          	jalr	1390(ra) # 57ec <sbrk>
    4286:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4288:	597d                	li	s2,-1
    428a:	a021                	j	4292 <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    428c:	0491                	addi	s1,s1,4
    428e:	01348f63          	beq	s1,s3,42ac <sbrkfail+0xe4>
    if(pids[i] == -1)
    4292:	4088                	lw	a0,0(s1)
    4294:	ff250ce3          	beq	a0,s2,428c <sbrkfail+0xc4>
    kill(pids[i]);
    4298:	00001097          	auipc	ra,0x1
    429c:	4fc080e7          	jalr	1276(ra) # 5794 <kill>
    wait(0);
    42a0:	4501                	li	a0,0
    42a2:	00001097          	auipc	ra,0x1
    42a6:	4ca080e7          	jalr	1226(ra) # 576c <wait>
    42aa:	b7cd                	j	428c <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    42ac:	57fd                	li	a5,-1
    42ae:	04fa0163          	beq	s4,a5,42f0 <sbrkfail+0x128>
  pid = fork();
    42b2:	00001097          	auipc	ra,0x1
    42b6:	4aa080e7          	jalr	1194(ra) # 575c <fork>
    42ba:	84aa                	mv	s1,a0
  if(pid < 0){
    42bc:	04054863          	bltz	a0,430c <sbrkfail+0x144>
  if(pid == 0){
    42c0:	c525                	beqz	a0,4328 <sbrkfail+0x160>
  wait(&xstatus);
    42c2:	fbc40513          	addi	a0,s0,-68
    42c6:	00001097          	auipc	ra,0x1
    42ca:	4a6080e7          	jalr	1190(ra) # 576c <wait>
  if(xstatus != -1 && xstatus != 2)
    42ce:	fbc42783          	lw	a5,-68(s0)
    42d2:	577d                	li	a4,-1
    42d4:	00e78563          	beq	a5,a4,42de <sbrkfail+0x116>
    42d8:	4709                	li	a4,2
    42da:	08e79d63          	bne	a5,a4,4374 <sbrkfail+0x1ac>
}
    42de:	70e6                	ld	ra,120(sp)
    42e0:	7446                	ld	s0,112(sp)
    42e2:	74a6                	ld	s1,104(sp)
    42e4:	7906                	ld	s2,96(sp)
    42e6:	69e6                	ld	s3,88(sp)
    42e8:	6a46                	ld	s4,80(sp)
    42ea:	6aa6                	ld	s5,72(sp)
    42ec:	6109                	addi	sp,sp,128
    42ee:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    42f0:	85d6                	mv	a1,s5
    42f2:	00004517          	auipc	a0,0x4
    42f6:	81e50513          	addi	a0,a0,-2018 # 7b10 <malloc+0x1f6e>
    42fa:	00001097          	auipc	ra,0x1
    42fe:	7ea080e7          	jalr	2026(ra) # 5ae4 <printf>
    exit(1);
    4302:	4505                	li	a0,1
    4304:	00001097          	auipc	ra,0x1
    4308:	460080e7          	jalr	1120(ra) # 5764 <exit>
    printf("%s: fork failed\n", s);
    430c:	85d6                	mv	a1,s5
    430e:	00002517          	auipc	a0,0x2
    4312:	52a50513          	addi	a0,a0,1322 # 6838 <malloc+0xc96>
    4316:	00001097          	auipc	ra,0x1
    431a:	7ce080e7          	jalr	1998(ra) # 5ae4 <printf>
    exit(1);
    431e:	4505                	li	a0,1
    4320:	00001097          	auipc	ra,0x1
    4324:	444080e7          	jalr	1092(ra) # 5764 <exit>
    a = sbrk(0);
    4328:	4501                	li	a0,0
    432a:	00001097          	auipc	ra,0x1
    432e:	4c2080e7          	jalr	1218(ra) # 57ec <sbrk>
    4332:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4334:	3e800537          	lui	a0,0x3e800
    4338:	00001097          	auipc	ra,0x1
    433c:	4b4080e7          	jalr	1204(ra) # 57ec <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4340:	87ca                	mv	a5,s2
    4342:	3e800737          	lui	a4,0x3e800
    4346:	993a                	add	s2,s2,a4
    4348:	6705                	lui	a4,0x1
      n += *(a+i);
    434a:	0007c683          	lbu	a3,0(a5) # 6400000 <__BSS_END__+0x63f1368>
    434e:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4350:	97ba                	add	a5,a5,a4
    4352:	ff279ce3          	bne	a5,s2,434a <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4356:	8626                	mv	a2,s1
    4358:	85d6                	mv	a1,s5
    435a:	00003517          	auipc	a0,0x3
    435e:	7d650513          	addi	a0,a0,2006 # 7b30 <malloc+0x1f8e>
    4362:	00001097          	auipc	ra,0x1
    4366:	782080e7          	jalr	1922(ra) # 5ae4 <printf>
    exit(1);
    436a:	4505                	li	a0,1
    436c:	00001097          	auipc	ra,0x1
    4370:	3f8080e7          	jalr	1016(ra) # 5764 <exit>
    exit(1);
    4374:	4505                	li	a0,1
    4376:	00001097          	auipc	ra,0x1
    437a:	3ee080e7          	jalr	1006(ra) # 5764 <exit>

000000000000437e <test_trace>:
void test_trace() {
    437e:	1141                	addi	sp,sp,-16
    4380:	e406                	sd	ra,8(sp)
    4382:	e022                	sd	s0,0(sp)
    4384:	0800                	addi	s0,sp,16
  trace((1 << SYS_getpid) | (1 << SYS_fork) | (1 << SYS_sbrk), getpid());
    4386:	00001097          	auipc	ra,0x1
    438a:	45e080e7          	jalr	1118(ra) # 57e4 <getpid>
    438e:	85aa                	mv	a1,a0
    4390:	6509                	lui	a0,0x2
    4392:	80250513          	addi	a0,a0,-2046 # 1802 <pipe1+0xc4>
    4396:	00001097          	auipc	ra,0x1
    439a:	46e080e7          	jalr	1134(ra) # 5804 <trace>
  if(fork() == 0){
    439e:	00001097          	auipc	ra,0x1
    43a2:	3be080e7          	jalr	958(ra) # 575c <fork>
    43a6:	e139                	bnez	a0,43ec <test_trace+0x6e>
    trace((1 << SYS_sbrk), getpid());
    43a8:	00001097          	auipc	ra,0x1
    43ac:	43c080e7          	jalr	1084(ra) # 57e4 <getpid>
    43b0:	85aa                	mv	a1,a0
    43b2:	6505                	lui	a0,0x1
    43b4:	00001097          	auipc	ra,0x1
    43b8:	450080e7          	jalr	1104(ra) # 5804 <trace>
    fprintf(2, "child process id: %d\n", getpid());
    43bc:	00001097          	auipc	ra,0x1
    43c0:	428080e7          	jalr	1064(ra) # 57e4 <getpid>
    43c4:	862a                	mv	a2,a0
    43c6:	00003597          	auipc	a1,0x3
    43ca:	79a58593          	addi	a1,a1,1946 # 7b60 <malloc+0x1fbe>
    43ce:	4509                	li	a0,2
    43d0:	00001097          	auipc	ra,0x1
    43d4:	6e6080e7          	jalr	1766(ra) # 5ab6 <fprintf>
    str = malloc(1024);
    43d8:	40000513          	li	a0,1024
    43dc:	00001097          	auipc	ra,0x1
    43e0:	7c6080e7          	jalr	1990(ra) # 5ba2 <malloc>
}
    43e4:	60a2                	ld	ra,8(sp)
    43e6:	6402                	ld	s0,0(sp)
    43e8:	0141                	addi	sp,sp,16
    43ea:	8082                	ret
    wait(0);
    43ec:	4501                	li	a0,0
    43ee:	00001097          	auipc	ra,0x1
    43f2:	37e080e7          	jalr	894(ra) # 576c <wait>
    fprintf(2, "parent process id: %d\n", getpid());
    43f6:	00001097          	auipc	ra,0x1
    43fa:	3ee080e7          	jalr	1006(ra) # 57e4 <getpid>
    43fe:	862a                	mv	a2,a0
    4400:	00003597          	auipc	a1,0x3
    4404:	77858593          	addi	a1,a1,1912 # 7b78 <malloc+0x1fd6>
    4408:	4509                	li	a0,2
    440a:	00001097          	auipc	ra,0x1
    440e:	6ac080e7          	jalr	1708(ra) # 5ab6 <fprintf>
    str = malloc(1024);
    4412:	40000513          	li	a0,1024
    4416:	00001097          	auipc	ra,0x1
    441a:	78c080e7          	jalr	1932(ra) # 5ba2 <malloc>
    memcpy(str, "hello", 6);
    441e:	4619                	li	a2,6
    4420:	00002597          	auipc	a1,0x2
    4424:	0b858593          	addi	a1,a1,184 # 64d8 <malloc+0x936>
    4428:	00001097          	auipc	ra,0x1
    442c:	31c080e7          	jalr	796(ra) # 5744 <memcpy>
}
    4430:	bf55                	j	43e4 <test_trace+0x66>

0000000000004432 <mem>:
{
    4432:	7139                	addi	sp,sp,-64
    4434:	fc06                	sd	ra,56(sp)
    4436:	f822                	sd	s0,48(sp)
    4438:	f426                	sd	s1,40(sp)
    443a:	f04a                	sd	s2,32(sp)
    443c:	ec4e                	sd	s3,24(sp)
    443e:	0080                	addi	s0,sp,64
    4440:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4442:	00001097          	auipc	ra,0x1
    4446:	31a080e7          	jalr	794(ra) # 575c <fork>
    m1 = 0;
    444a:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    444c:	6909                	lui	s2,0x2
    444e:	71190913          	addi	s2,s2,1809 # 2711 <sbrkbasic+0x159>
  if((pid = fork()) == 0){
    4452:	c115                	beqz	a0,4476 <mem+0x44>
    wait(&xstatus);
    4454:	fcc40513          	addi	a0,s0,-52
    4458:	00001097          	auipc	ra,0x1
    445c:	314080e7          	jalr	788(ra) # 576c <wait>
    if(xstatus == -1){
    4460:	fcc42503          	lw	a0,-52(s0)
    4464:	57fd                	li	a5,-1
    4466:	06f50363          	beq	a0,a5,44cc <mem+0x9a>
    exit(xstatus);
    446a:	00001097          	auipc	ra,0x1
    446e:	2fa080e7          	jalr	762(ra) # 5764 <exit>
      *(char**)m2 = m1;
    4472:	e104                	sd	s1,0(a0)
      m1 = m2;
    4474:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4476:	854a                	mv	a0,s2
    4478:	00001097          	auipc	ra,0x1
    447c:	72a080e7          	jalr	1834(ra) # 5ba2 <malloc>
    4480:	f96d                	bnez	a0,4472 <mem+0x40>
    while(m1){
    4482:	c881                	beqz	s1,4492 <mem+0x60>
      m2 = *(char**)m1;
    4484:	8526                	mv	a0,s1
    4486:	6084                	ld	s1,0(s1)
      free(m1);
    4488:	00001097          	auipc	ra,0x1
    448c:	692080e7          	jalr	1682(ra) # 5b1a <free>
    while(m1){
    4490:	f8f5                	bnez	s1,4484 <mem+0x52>
    m1 = malloc(1024*20);
    4492:	6515                	lui	a0,0x5
    4494:	00001097          	auipc	ra,0x1
    4498:	70e080e7          	jalr	1806(ra) # 5ba2 <malloc>
    if(m1 == 0){
    449c:	c911                	beqz	a0,44b0 <mem+0x7e>
    free(m1);
    449e:	00001097          	auipc	ra,0x1
    44a2:	67c080e7          	jalr	1660(ra) # 5b1a <free>
    exit(0);
    44a6:	4501                	li	a0,0
    44a8:	00001097          	auipc	ra,0x1
    44ac:	2bc080e7          	jalr	700(ra) # 5764 <exit>
      printf("couldn't allocate mem?!!\n", s);
    44b0:	85ce                	mv	a1,s3
    44b2:	00003517          	auipc	a0,0x3
    44b6:	6de50513          	addi	a0,a0,1758 # 7b90 <malloc+0x1fee>
    44ba:	00001097          	auipc	ra,0x1
    44be:	62a080e7          	jalr	1578(ra) # 5ae4 <printf>
      exit(1);
    44c2:	4505                	li	a0,1
    44c4:	00001097          	auipc	ra,0x1
    44c8:	2a0080e7          	jalr	672(ra) # 5764 <exit>
      exit(0);
    44cc:	4501                	li	a0,0
    44ce:	00001097          	auipc	ra,0x1
    44d2:	296080e7          	jalr	662(ra) # 5764 <exit>

00000000000044d6 <sharedfd>:
{
    44d6:	7159                	addi	sp,sp,-112
    44d8:	f486                	sd	ra,104(sp)
    44da:	f0a2                	sd	s0,96(sp)
    44dc:	eca6                	sd	s1,88(sp)
    44de:	e8ca                	sd	s2,80(sp)
    44e0:	e4ce                	sd	s3,72(sp)
    44e2:	e0d2                	sd	s4,64(sp)
    44e4:	fc56                	sd	s5,56(sp)
    44e6:	f85a                	sd	s6,48(sp)
    44e8:	f45e                	sd	s7,40(sp)
    44ea:	1880                	addi	s0,sp,112
    44ec:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    44ee:	00002517          	auipc	a0,0x2
    44f2:	93250513          	addi	a0,a0,-1742 # 5e20 <malloc+0x27e>
    44f6:	00001097          	auipc	ra,0x1
    44fa:	2be080e7          	jalr	702(ra) # 57b4 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    44fe:	20200593          	li	a1,514
    4502:	00002517          	auipc	a0,0x2
    4506:	91e50513          	addi	a0,a0,-1762 # 5e20 <malloc+0x27e>
    450a:	00001097          	auipc	ra,0x1
    450e:	29a080e7          	jalr	666(ra) # 57a4 <open>
  if(fd < 0){
    4512:	04054a63          	bltz	a0,4566 <sharedfd+0x90>
    4516:	892a                	mv	s2,a0
  pid = fork();
    4518:	00001097          	auipc	ra,0x1
    451c:	244080e7          	jalr	580(ra) # 575c <fork>
    4520:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4522:	06300593          	li	a1,99
    4526:	c119                	beqz	a0,452c <sharedfd+0x56>
    4528:	07000593          	li	a1,112
    452c:	4629                	li	a2,10
    452e:	fa040513          	addi	a0,s0,-96
    4532:	00001097          	auipc	ra,0x1
    4536:	036080e7          	jalr	54(ra) # 5568 <memset>
    453a:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    453e:	4629                	li	a2,10
    4540:	fa040593          	addi	a1,s0,-96
    4544:	854a                	mv	a0,s2
    4546:	00001097          	auipc	ra,0x1
    454a:	23e080e7          	jalr	574(ra) # 5784 <write>
    454e:	47a9                	li	a5,10
    4550:	02f51963          	bne	a0,a5,4582 <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4554:	34fd                	addiw	s1,s1,-1
    4556:	f4e5                	bnez	s1,453e <sharedfd+0x68>
  if(pid == 0) {
    4558:	04099363          	bnez	s3,459e <sharedfd+0xc8>
    exit(0);
    455c:	4501                	li	a0,0
    455e:	00001097          	auipc	ra,0x1
    4562:	206080e7          	jalr	518(ra) # 5764 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4566:	85d2                	mv	a1,s4
    4568:	00003517          	auipc	a0,0x3
    456c:	64850513          	addi	a0,a0,1608 # 7bb0 <malloc+0x200e>
    4570:	00001097          	auipc	ra,0x1
    4574:	574080e7          	jalr	1396(ra) # 5ae4 <printf>
    exit(1);
    4578:	4505                	li	a0,1
    457a:	00001097          	auipc	ra,0x1
    457e:	1ea080e7          	jalr	490(ra) # 5764 <exit>
      printf("%s: write sharedfd failed\n", s);
    4582:	85d2                	mv	a1,s4
    4584:	00003517          	auipc	a0,0x3
    4588:	65450513          	addi	a0,a0,1620 # 7bd8 <malloc+0x2036>
    458c:	00001097          	auipc	ra,0x1
    4590:	558080e7          	jalr	1368(ra) # 5ae4 <printf>
      exit(1);
    4594:	4505                	li	a0,1
    4596:	00001097          	auipc	ra,0x1
    459a:	1ce080e7          	jalr	462(ra) # 5764 <exit>
    wait(&xstatus);
    459e:	f9c40513          	addi	a0,s0,-100
    45a2:	00001097          	auipc	ra,0x1
    45a6:	1ca080e7          	jalr	458(ra) # 576c <wait>
    if(xstatus != 0)
    45aa:	f9c42983          	lw	s3,-100(s0)
    45ae:	00098763          	beqz	s3,45bc <sharedfd+0xe6>
      exit(xstatus);
    45b2:	854e                	mv	a0,s3
    45b4:	00001097          	auipc	ra,0x1
    45b8:	1b0080e7          	jalr	432(ra) # 5764 <exit>
  close(fd);
    45bc:	854a                	mv	a0,s2
    45be:	00001097          	auipc	ra,0x1
    45c2:	1ce080e7          	jalr	462(ra) # 578c <close>
  fd = open("sharedfd", 0);
    45c6:	4581                	li	a1,0
    45c8:	00002517          	auipc	a0,0x2
    45cc:	85850513          	addi	a0,a0,-1960 # 5e20 <malloc+0x27e>
    45d0:	00001097          	auipc	ra,0x1
    45d4:	1d4080e7          	jalr	468(ra) # 57a4 <open>
    45d8:	8baa                	mv	s7,a0
  nc = np = 0;
    45da:	8ace                	mv	s5,s3
  if(fd < 0){
    45dc:	02054563          	bltz	a0,4606 <sharedfd+0x130>
    45e0:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    45e4:	06300493          	li	s1,99
      if(buf[i] == 'p')
    45e8:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    45ec:	4629                	li	a2,10
    45ee:	fa040593          	addi	a1,s0,-96
    45f2:	855e                	mv	a0,s7
    45f4:	00001097          	auipc	ra,0x1
    45f8:	188080e7          	jalr	392(ra) # 577c <read>
    45fc:	02a05f63          	blez	a0,463a <sharedfd+0x164>
    4600:	fa040793          	addi	a5,s0,-96
    4604:	a01d                	j	462a <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4606:	85d2                	mv	a1,s4
    4608:	00003517          	auipc	a0,0x3
    460c:	5f050513          	addi	a0,a0,1520 # 7bf8 <malloc+0x2056>
    4610:	00001097          	auipc	ra,0x1
    4614:	4d4080e7          	jalr	1236(ra) # 5ae4 <printf>
    exit(1);
    4618:	4505                	li	a0,1
    461a:	00001097          	auipc	ra,0x1
    461e:	14a080e7          	jalr	330(ra) # 5764 <exit>
        nc++;
    4622:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4624:	0785                	addi	a5,a5,1
    4626:	fd2783e3          	beq	a5,s2,45ec <sharedfd+0x116>
      if(buf[i] == 'c')
    462a:	0007c703          	lbu	a4,0(a5)
    462e:	fe970ae3          	beq	a4,s1,4622 <sharedfd+0x14c>
      if(buf[i] == 'p')
    4632:	ff6719e3          	bne	a4,s6,4624 <sharedfd+0x14e>
        np++;
    4636:	2a85                	addiw	s5,s5,1
    4638:	b7f5                	j	4624 <sharedfd+0x14e>
  close(fd);
    463a:	855e                	mv	a0,s7
    463c:	00001097          	auipc	ra,0x1
    4640:	150080e7          	jalr	336(ra) # 578c <close>
  unlink("sharedfd");
    4644:	00001517          	auipc	a0,0x1
    4648:	7dc50513          	addi	a0,a0,2012 # 5e20 <malloc+0x27e>
    464c:	00001097          	auipc	ra,0x1
    4650:	168080e7          	jalr	360(ra) # 57b4 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4654:	6789                	lui	a5,0x2
    4656:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    465a:	00f99763          	bne	s3,a5,4668 <sharedfd+0x192>
    465e:	6789                	lui	a5,0x2
    4660:	71078793          	addi	a5,a5,1808 # 2710 <sbrkbasic+0x158>
    4664:	02fa8063          	beq	s5,a5,4684 <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4668:	85d2                	mv	a1,s4
    466a:	00003517          	auipc	a0,0x3
    466e:	5b650513          	addi	a0,a0,1462 # 7c20 <malloc+0x207e>
    4672:	00001097          	auipc	ra,0x1
    4676:	472080e7          	jalr	1138(ra) # 5ae4 <printf>
    exit(1);
    467a:	4505                	li	a0,1
    467c:	00001097          	auipc	ra,0x1
    4680:	0e8080e7          	jalr	232(ra) # 5764 <exit>
    exit(0);
    4684:	4501                	li	a0,0
    4686:	00001097          	auipc	ra,0x1
    468a:	0de080e7          	jalr	222(ra) # 5764 <exit>

000000000000468e <fourfiles>:
{
    468e:	7171                	addi	sp,sp,-176
    4690:	f506                	sd	ra,168(sp)
    4692:	f122                	sd	s0,160(sp)
    4694:	ed26                	sd	s1,152(sp)
    4696:	e94a                	sd	s2,144(sp)
    4698:	e54e                	sd	s3,136(sp)
    469a:	e152                	sd	s4,128(sp)
    469c:	fcd6                	sd	s5,120(sp)
    469e:	f8da                	sd	s6,112(sp)
    46a0:	f4de                	sd	s7,104(sp)
    46a2:	f0e2                	sd	s8,96(sp)
    46a4:	ece6                	sd	s9,88(sp)
    46a6:	e8ea                	sd	s10,80(sp)
    46a8:	e4ee                	sd	s11,72(sp)
    46aa:	1900                	addi	s0,sp,176
    46ac:	f4a43c23          	sd	a0,-168(s0)
  char *names[] = { "f0", "f1", "f2", "f3" };
    46b0:	00001797          	auipc	a5,0x1
    46b4:	5d878793          	addi	a5,a5,1496 # 5c88 <malloc+0xe6>
    46b8:	f6f43823          	sd	a5,-144(s0)
    46bc:	00001797          	auipc	a5,0x1
    46c0:	5d478793          	addi	a5,a5,1492 # 5c90 <malloc+0xee>
    46c4:	f6f43c23          	sd	a5,-136(s0)
    46c8:	00001797          	auipc	a5,0x1
    46cc:	5d078793          	addi	a5,a5,1488 # 5c98 <malloc+0xf6>
    46d0:	f8f43023          	sd	a5,-128(s0)
    46d4:	00001797          	auipc	a5,0x1
    46d8:	5cc78793          	addi	a5,a5,1484 # 5ca0 <malloc+0xfe>
    46dc:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    46e0:	f7040c13          	addi	s8,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    46e4:	8962                	mv	s2,s8
  for(pi = 0; pi < NCHILD; pi++){
    46e6:	4481                	li	s1,0
    46e8:	4a11                	li	s4,4
    fname = names[pi];
    46ea:	00093983          	ld	s3,0(s2)
    unlink(fname);
    46ee:	854e                	mv	a0,s3
    46f0:	00001097          	auipc	ra,0x1
    46f4:	0c4080e7          	jalr	196(ra) # 57b4 <unlink>
    pid = fork();
    46f8:	00001097          	auipc	ra,0x1
    46fc:	064080e7          	jalr	100(ra) # 575c <fork>
    if(pid < 0){
    4700:	04054463          	bltz	a0,4748 <fourfiles+0xba>
    if(pid == 0){
    4704:	c12d                	beqz	a0,4766 <fourfiles+0xd8>
  for(pi = 0; pi < NCHILD; pi++){
    4706:	2485                	addiw	s1,s1,1
    4708:	0921                	addi	s2,s2,8
    470a:	ff4490e3          	bne	s1,s4,46ea <fourfiles+0x5c>
    470e:	4491                	li	s1,4
    wait(&xstatus);
    4710:	f6c40513          	addi	a0,s0,-148
    4714:	00001097          	auipc	ra,0x1
    4718:	058080e7          	jalr	88(ra) # 576c <wait>
    if(xstatus != 0)
    471c:	f6c42b03          	lw	s6,-148(s0)
    4720:	0c0b1e63          	bnez	s6,47fc <fourfiles+0x16e>
  for(pi = 0; pi < NCHILD; pi++){
    4724:	34fd                	addiw	s1,s1,-1
    4726:	f4ed                	bnez	s1,4710 <fourfiles+0x82>
    4728:	03000b93          	li	s7,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    472c:	00007a17          	auipc	s4,0x7
    4730:	55ca0a13          	addi	s4,s4,1372 # bc88 <buf>
    4734:	00007a97          	auipc	s5,0x7
    4738:	555a8a93          	addi	s5,s5,1365 # bc89 <buf+0x1>
    if(total != N*SZ){
    473c:	6d85                	lui	s11,0x1
    473e:	770d8d93          	addi	s11,s11,1904 # 1770 <pipe1+0x32>
  for(i = 0; i < NCHILD; i++){
    4742:	03400d13          	li	s10,52
    4746:	aa1d                	j	487c <fourfiles+0x1ee>
      printf("fork failed\n", s);
    4748:	f5843583          	ld	a1,-168(s0)
    474c:	00002517          	auipc	a0,0x2
    4750:	4f450513          	addi	a0,a0,1268 # 6c40 <malloc+0x109e>
    4754:	00001097          	auipc	ra,0x1
    4758:	390080e7          	jalr	912(ra) # 5ae4 <printf>
      exit(1);
    475c:	4505                	li	a0,1
    475e:	00001097          	auipc	ra,0x1
    4762:	006080e7          	jalr	6(ra) # 5764 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4766:	20200593          	li	a1,514
    476a:	854e                	mv	a0,s3
    476c:	00001097          	auipc	ra,0x1
    4770:	038080e7          	jalr	56(ra) # 57a4 <open>
    4774:	892a                	mv	s2,a0
      if(fd < 0){
    4776:	04054763          	bltz	a0,47c4 <fourfiles+0x136>
      memset(buf, '0'+pi, SZ);
    477a:	1f400613          	li	a2,500
    477e:	0304859b          	addiw	a1,s1,48
    4782:	00007517          	auipc	a0,0x7
    4786:	50650513          	addi	a0,a0,1286 # bc88 <buf>
    478a:	00001097          	auipc	ra,0x1
    478e:	dde080e7          	jalr	-546(ra) # 5568 <memset>
    4792:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4794:	00007997          	auipc	s3,0x7
    4798:	4f498993          	addi	s3,s3,1268 # bc88 <buf>
    479c:	1f400613          	li	a2,500
    47a0:	85ce                	mv	a1,s3
    47a2:	854a                	mv	a0,s2
    47a4:	00001097          	auipc	ra,0x1
    47a8:	fe0080e7          	jalr	-32(ra) # 5784 <write>
    47ac:	85aa                	mv	a1,a0
    47ae:	1f400793          	li	a5,500
    47b2:	02f51863          	bne	a0,a5,47e2 <fourfiles+0x154>
      for(i = 0; i < N; i++){
    47b6:	34fd                	addiw	s1,s1,-1
    47b8:	f0f5                	bnez	s1,479c <fourfiles+0x10e>
      exit(0);
    47ba:	4501                	li	a0,0
    47bc:	00001097          	auipc	ra,0x1
    47c0:	fa8080e7          	jalr	-88(ra) # 5764 <exit>
        printf("create failed\n", s);
    47c4:	f5843583          	ld	a1,-168(s0)
    47c8:	00003517          	auipc	a0,0x3
    47cc:	47050513          	addi	a0,a0,1136 # 7c38 <malloc+0x2096>
    47d0:	00001097          	auipc	ra,0x1
    47d4:	314080e7          	jalr	788(ra) # 5ae4 <printf>
        exit(1);
    47d8:	4505                	li	a0,1
    47da:	00001097          	auipc	ra,0x1
    47de:	f8a080e7          	jalr	-118(ra) # 5764 <exit>
          printf("write failed %d\n", n);
    47e2:	00003517          	auipc	a0,0x3
    47e6:	46650513          	addi	a0,a0,1126 # 7c48 <malloc+0x20a6>
    47ea:	00001097          	auipc	ra,0x1
    47ee:	2fa080e7          	jalr	762(ra) # 5ae4 <printf>
          exit(1);
    47f2:	4505                	li	a0,1
    47f4:	00001097          	auipc	ra,0x1
    47f8:	f70080e7          	jalr	-144(ra) # 5764 <exit>
      exit(xstatus);
    47fc:	855a                	mv	a0,s6
    47fe:	00001097          	auipc	ra,0x1
    4802:	f66080e7          	jalr	-154(ra) # 5764 <exit>
          printf("wrong char\n", s);
    4806:	f5843583          	ld	a1,-168(s0)
    480a:	00003517          	auipc	a0,0x3
    480e:	45650513          	addi	a0,a0,1110 # 7c60 <malloc+0x20be>
    4812:	00001097          	auipc	ra,0x1
    4816:	2d2080e7          	jalr	722(ra) # 5ae4 <printf>
          exit(1);
    481a:	4505                	li	a0,1
    481c:	00001097          	auipc	ra,0x1
    4820:	f48080e7          	jalr	-184(ra) # 5764 <exit>
      total += n;
    4824:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4828:	660d                	lui	a2,0x3
    482a:	85d2                	mv	a1,s4
    482c:	854e                	mv	a0,s3
    482e:	00001097          	auipc	ra,0x1
    4832:	f4e080e7          	jalr	-178(ra) # 577c <read>
    4836:	02a05363          	blez	a0,485c <fourfiles+0x1ce>
    483a:	00007797          	auipc	a5,0x7
    483e:	44e78793          	addi	a5,a5,1102 # bc88 <buf>
    4842:	fff5069b          	addiw	a3,a0,-1
    4846:	1682                	slli	a3,a3,0x20
    4848:	9281                	srli	a3,a3,0x20
    484a:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    484c:	0007c703          	lbu	a4,0(a5)
    4850:	fa971be3          	bne	a4,s1,4806 <fourfiles+0x178>
      for(j = 0; j < n; j++){
    4854:	0785                	addi	a5,a5,1
    4856:	fed79be3          	bne	a5,a3,484c <fourfiles+0x1be>
    485a:	b7e9                	j	4824 <fourfiles+0x196>
    close(fd);
    485c:	854e                	mv	a0,s3
    485e:	00001097          	auipc	ra,0x1
    4862:	f2e080e7          	jalr	-210(ra) # 578c <close>
    if(total != N*SZ){
    4866:	03b91863          	bne	s2,s11,4896 <fourfiles+0x208>
    unlink(fname);
    486a:	8566                	mv	a0,s9
    486c:	00001097          	auipc	ra,0x1
    4870:	f48080e7          	jalr	-184(ra) # 57b4 <unlink>
  for(i = 0; i < NCHILD; i++){
    4874:	0c21                	addi	s8,s8,8
    4876:	2b85                	addiw	s7,s7,1
    4878:	03ab8d63          	beq	s7,s10,48b2 <fourfiles+0x224>
    fname = names[i];
    487c:	000c3c83          	ld	s9,0(s8)
    fd = open(fname, 0);
    4880:	4581                	li	a1,0
    4882:	8566                	mv	a0,s9
    4884:	00001097          	auipc	ra,0x1
    4888:	f20080e7          	jalr	-224(ra) # 57a4 <open>
    488c:	89aa                	mv	s3,a0
    total = 0;
    488e:	895a                	mv	s2,s6
        if(buf[j] != '0'+i){
    4890:	000b849b          	sext.w	s1,s7
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4894:	bf51                	j	4828 <fourfiles+0x19a>
      printf("wrong length %d\n", total);
    4896:	85ca                	mv	a1,s2
    4898:	00003517          	auipc	a0,0x3
    489c:	3d850513          	addi	a0,a0,984 # 7c70 <malloc+0x20ce>
    48a0:	00001097          	auipc	ra,0x1
    48a4:	244080e7          	jalr	580(ra) # 5ae4 <printf>
      exit(1);
    48a8:	4505                	li	a0,1
    48aa:	00001097          	auipc	ra,0x1
    48ae:	eba080e7          	jalr	-326(ra) # 5764 <exit>
}
    48b2:	70aa                	ld	ra,168(sp)
    48b4:	740a                	ld	s0,160(sp)
    48b6:	64ea                	ld	s1,152(sp)
    48b8:	694a                	ld	s2,144(sp)
    48ba:	69aa                	ld	s3,136(sp)
    48bc:	6a0a                	ld	s4,128(sp)
    48be:	7ae6                	ld	s5,120(sp)
    48c0:	7b46                	ld	s6,112(sp)
    48c2:	7ba6                	ld	s7,104(sp)
    48c4:	7c06                	ld	s8,96(sp)
    48c6:	6ce6                	ld	s9,88(sp)
    48c8:	6d46                	ld	s10,80(sp)
    48ca:	6da6                	ld	s11,72(sp)
    48cc:	614d                	addi	sp,sp,176
    48ce:	8082                	ret

00000000000048d0 <concreate>:
{
    48d0:	7135                	addi	sp,sp,-160
    48d2:	ed06                	sd	ra,152(sp)
    48d4:	e922                	sd	s0,144(sp)
    48d6:	e526                	sd	s1,136(sp)
    48d8:	e14a                	sd	s2,128(sp)
    48da:	fcce                	sd	s3,120(sp)
    48dc:	f8d2                	sd	s4,112(sp)
    48de:	f4d6                	sd	s5,104(sp)
    48e0:	f0da                	sd	s6,96(sp)
    48e2:	ecde                	sd	s7,88(sp)
    48e4:	1100                	addi	s0,sp,160
    48e6:	89aa                	mv	s3,a0
  file[0] = 'C';
    48e8:	04300793          	li	a5,67
    48ec:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    48f0:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    48f4:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    48f6:	4b0d                	li	s6,3
    48f8:	4a85                	li	s5,1
      link("C0", file);
    48fa:	00003b97          	auipc	s7,0x3
    48fe:	38eb8b93          	addi	s7,s7,910 # 7c88 <malloc+0x20e6>
  for(i = 0; i < N; i++){
    4902:	02800a13          	li	s4,40
    4906:	acc1                	j	4bd6 <concreate+0x306>
      link("C0", file);
    4908:	fa840593          	addi	a1,s0,-88
    490c:	855e                	mv	a0,s7
    490e:	00001097          	auipc	ra,0x1
    4912:	eb6080e7          	jalr	-330(ra) # 57c4 <link>
    if(pid == 0) {
    4916:	a45d                	j	4bbc <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4918:	4795                	li	a5,5
    491a:	02f9693b          	remw	s2,s2,a5
    491e:	4785                	li	a5,1
    4920:	02f90b63          	beq	s2,a5,4956 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4924:	20200593          	li	a1,514
    4928:	fa840513          	addi	a0,s0,-88
    492c:	00001097          	auipc	ra,0x1
    4930:	e78080e7          	jalr	-392(ra) # 57a4 <open>
      if(fd < 0){
    4934:	26055b63          	bgez	a0,4baa <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4938:	fa840593          	addi	a1,s0,-88
    493c:	00003517          	auipc	a0,0x3
    4940:	35450513          	addi	a0,a0,852 # 7c90 <malloc+0x20ee>
    4944:	00001097          	auipc	ra,0x1
    4948:	1a0080e7          	jalr	416(ra) # 5ae4 <printf>
        exit(1);
    494c:	4505                	li	a0,1
    494e:	00001097          	auipc	ra,0x1
    4952:	e16080e7          	jalr	-490(ra) # 5764 <exit>
      link("C0", file);
    4956:	fa840593          	addi	a1,s0,-88
    495a:	00003517          	auipc	a0,0x3
    495e:	32e50513          	addi	a0,a0,814 # 7c88 <malloc+0x20e6>
    4962:	00001097          	auipc	ra,0x1
    4966:	e62080e7          	jalr	-414(ra) # 57c4 <link>
      exit(0);
    496a:	4501                	li	a0,0
    496c:	00001097          	auipc	ra,0x1
    4970:	df8080e7          	jalr	-520(ra) # 5764 <exit>
        exit(1);
    4974:	4505                	li	a0,1
    4976:	00001097          	auipc	ra,0x1
    497a:	dee080e7          	jalr	-530(ra) # 5764 <exit>
  memset(fa, 0, sizeof(fa));
    497e:	02800613          	li	a2,40
    4982:	4581                	li	a1,0
    4984:	f8040513          	addi	a0,s0,-128
    4988:	00001097          	auipc	ra,0x1
    498c:	be0080e7          	jalr	-1056(ra) # 5568 <memset>
  fd = open(".", 0);
    4990:	4581                	li	a1,0
    4992:	00002517          	auipc	a0,0x2
    4996:	d0650513          	addi	a0,a0,-762 # 6698 <malloc+0xaf6>
    499a:	00001097          	auipc	ra,0x1
    499e:	e0a080e7          	jalr	-502(ra) # 57a4 <open>
    49a2:	892a                	mv	s2,a0
  n = 0;
    49a4:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    49a6:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    49aa:	02700b13          	li	s6,39
      fa[i] = 1;
    49ae:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    49b0:	4641                	li	a2,16
    49b2:	f7040593          	addi	a1,s0,-144
    49b6:	854a                	mv	a0,s2
    49b8:	00001097          	auipc	ra,0x1
    49bc:	dc4080e7          	jalr	-572(ra) # 577c <read>
    49c0:	08a05163          	blez	a0,4a42 <concreate+0x172>
    if(de.inum == 0)
    49c4:	f7045783          	lhu	a5,-144(s0)
    49c8:	d7e5                	beqz	a5,49b0 <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    49ca:	f7244783          	lbu	a5,-142(s0)
    49ce:	ff4791e3          	bne	a5,s4,49b0 <concreate+0xe0>
    49d2:	f7444783          	lbu	a5,-140(s0)
    49d6:	ffe9                	bnez	a5,49b0 <concreate+0xe0>
      i = de.name[1] - '0';
    49d8:	f7344783          	lbu	a5,-141(s0)
    49dc:	fd07879b          	addiw	a5,a5,-48
    49e0:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    49e4:	00eb6f63          	bltu	s6,a4,4a02 <concreate+0x132>
      if(fa[i]){
    49e8:	fb040793          	addi	a5,s0,-80
    49ec:	97ba                	add	a5,a5,a4
    49ee:	fd07c783          	lbu	a5,-48(a5)
    49f2:	eb85                	bnez	a5,4a22 <concreate+0x152>
      fa[i] = 1;
    49f4:	fb040793          	addi	a5,s0,-80
    49f8:	973e                	add	a4,a4,a5
    49fa:	fd770823          	sb	s7,-48(a4) # fd0 <bigdir+0x6e>
      n++;
    49fe:	2a85                	addiw	s5,s5,1
    4a00:	bf45                	j	49b0 <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4a02:	f7240613          	addi	a2,s0,-142
    4a06:	85ce                	mv	a1,s3
    4a08:	00003517          	auipc	a0,0x3
    4a0c:	2a850513          	addi	a0,a0,680 # 7cb0 <malloc+0x210e>
    4a10:	00001097          	auipc	ra,0x1
    4a14:	0d4080e7          	jalr	212(ra) # 5ae4 <printf>
        exit(1);
    4a18:	4505                	li	a0,1
    4a1a:	00001097          	auipc	ra,0x1
    4a1e:	d4a080e7          	jalr	-694(ra) # 5764 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4a22:	f7240613          	addi	a2,s0,-142
    4a26:	85ce                	mv	a1,s3
    4a28:	00003517          	auipc	a0,0x3
    4a2c:	2a850513          	addi	a0,a0,680 # 7cd0 <malloc+0x212e>
    4a30:	00001097          	auipc	ra,0x1
    4a34:	0b4080e7          	jalr	180(ra) # 5ae4 <printf>
        exit(1);
    4a38:	4505                	li	a0,1
    4a3a:	00001097          	auipc	ra,0x1
    4a3e:	d2a080e7          	jalr	-726(ra) # 5764 <exit>
  close(fd);
    4a42:	854a                	mv	a0,s2
    4a44:	00001097          	auipc	ra,0x1
    4a48:	d48080e7          	jalr	-696(ra) # 578c <close>
  if(n != N){
    4a4c:	02800793          	li	a5,40
    4a50:	00fa9763          	bne	s5,a5,4a5e <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4a54:	4a8d                	li	s5,3
    4a56:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4a58:	02800a13          	li	s4,40
    4a5c:	a8c9                	j	4b2e <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4a5e:	85ce                	mv	a1,s3
    4a60:	00003517          	auipc	a0,0x3
    4a64:	29850513          	addi	a0,a0,664 # 7cf8 <malloc+0x2156>
    4a68:	00001097          	auipc	ra,0x1
    4a6c:	07c080e7          	jalr	124(ra) # 5ae4 <printf>
    exit(1);
    4a70:	4505                	li	a0,1
    4a72:	00001097          	auipc	ra,0x1
    4a76:	cf2080e7          	jalr	-782(ra) # 5764 <exit>
      printf("%s: fork failed\n", s);
    4a7a:	85ce                	mv	a1,s3
    4a7c:	00002517          	auipc	a0,0x2
    4a80:	dbc50513          	addi	a0,a0,-580 # 6838 <malloc+0xc96>
    4a84:	00001097          	auipc	ra,0x1
    4a88:	060080e7          	jalr	96(ra) # 5ae4 <printf>
      exit(1);
    4a8c:	4505                	li	a0,1
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	cd6080e7          	jalr	-810(ra) # 5764 <exit>
      close(open(file, 0));
    4a96:	4581                	li	a1,0
    4a98:	fa840513          	addi	a0,s0,-88
    4a9c:	00001097          	auipc	ra,0x1
    4aa0:	d08080e7          	jalr	-760(ra) # 57a4 <open>
    4aa4:	00001097          	auipc	ra,0x1
    4aa8:	ce8080e7          	jalr	-792(ra) # 578c <close>
      close(open(file, 0));
    4aac:	4581                	li	a1,0
    4aae:	fa840513          	addi	a0,s0,-88
    4ab2:	00001097          	auipc	ra,0x1
    4ab6:	cf2080e7          	jalr	-782(ra) # 57a4 <open>
    4aba:	00001097          	auipc	ra,0x1
    4abe:	cd2080e7          	jalr	-814(ra) # 578c <close>
      close(open(file, 0));
    4ac2:	4581                	li	a1,0
    4ac4:	fa840513          	addi	a0,s0,-88
    4ac8:	00001097          	auipc	ra,0x1
    4acc:	cdc080e7          	jalr	-804(ra) # 57a4 <open>
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	cbc080e7          	jalr	-836(ra) # 578c <close>
      close(open(file, 0));
    4ad8:	4581                	li	a1,0
    4ada:	fa840513          	addi	a0,s0,-88
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	cc6080e7          	jalr	-826(ra) # 57a4 <open>
    4ae6:	00001097          	auipc	ra,0x1
    4aea:	ca6080e7          	jalr	-858(ra) # 578c <close>
      close(open(file, 0));
    4aee:	4581                	li	a1,0
    4af0:	fa840513          	addi	a0,s0,-88
    4af4:	00001097          	auipc	ra,0x1
    4af8:	cb0080e7          	jalr	-848(ra) # 57a4 <open>
    4afc:	00001097          	auipc	ra,0x1
    4b00:	c90080e7          	jalr	-880(ra) # 578c <close>
      close(open(file, 0));
    4b04:	4581                	li	a1,0
    4b06:	fa840513          	addi	a0,s0,-88
    4b0a:	00001097          	auipc	ra,0x1
    4b0e:	c9a080e7          	jalr	-870(ra) # 57a4 <open>
    4b12:	00001097          	auipc	ra,0x1
    4b16:	c7a080e7          	jalr	-902(ra) # 578c <close>
    if(pid == 0)
    4b1a:	08090363          	beqz	s2,4ba0 <concreate+0x2d0>
      wait(0);
    4b1e:	4501                	li	a0,0
    4b20:	00001097          	auipc	ra,0x1
    4b24:	c4c080e7          	jalr	-948(ra) # 576c <wait>
  for(i = 0; i < N; i++){
    4b28:	2485                	addiw	s1,s1,1
    4b2a:	0f448563          	beq	s1,s4,4c14 <concreate+0x344>
    file[1] = '0' + i;
    4b2e:	0304879b          	addiw	a5,s1,48
    4b32:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4b36:	00001097          	auipc	ra,0x1
    4b3a:	c26080e7          	jalr	-986(ra) # 575c <fork>
    4b3e:	892a                	mv	s2,a0
    if(pid < 0){
    4b40:	f2054de3          	bltz	a0,4a7a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4b44:	0354e73b          	remw	a4,s1,s5
    4b48:	00a767b3          	or	a5,a4,a0
    4b4c:	2781                	sext.w	a5,a5
    4b4e:	d7a1                	beqz	a5,4a96 <concreate+0x1c6>
    4b50:	01671363          	bne	a4,s6,4b56 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4b54:	f129                	bnez	a0,4a96 <concreate+0x1c6>
      unlink(file);
    4b56:	fa840513          	addi	a0,s0,-88
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	c5a080e7          	jalr	-934(ra) # 57b4 <unlink>
      unlink(file);
    4b62:	fa840513          	addi	a0,s0,-88
    4b66:	00001097          	auipc	ra,0x1
    4b6a:	c4e080e7          	jalr	-946(ra) # 57b4 <unlink>
      unlink(file);
    4b6e:	fa840513          	addi	a0,s0,-88
    4b72:	00001097          	auipc	ra,0x1
    4b76:	c42080e7          	jalr	-958(ra) # 57b4 <unlink>
      unlink(file);
    4b7a:	fa840513          	addi	a0,s0,-88
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	c36080e7          	jalr	-970(ra) # 57b4 <unlink>
      unlink(file);
    4b86:	fa840513          	addi	a0,s0,-88
    4b8a:	00001097          	auipc	ra,0x1
    4b8e:	c2a080e7          	jalr	-982(ra) # 57b4 <unlink>
      unlink(file);
    4b92:	fa840513          	addi	a0,s0,-88
    4b96:	00001097          	auipc	ra,0x1
    4b9a:	c1e080e7          	jalr	-994(ra) # 57b4 <unlink>
    4b9e:	bfb5                	j	4b1a <concreate+0x24a>
      exit(0);
    4ba0:	4501                	li	a0,0
    4ba2:	00001097          	auipc	ra,0x1
    4ba6:	bc2080e7          	jalr	-1086(ra) # 5764 <exit>
      close(fd);
    4baa:	00001097          	auipc	ra,0x1
    4bae:	be2080e7          	jalr	-1054(ra) # 578c <close>
    if(pid == 0) {
    4bb2:	bb65                	j	496a <concreate+0x9a>
      close(fd);
    4bb4:	00001097          	auipc	ra,0x1
    4bb8:	bd8080e7          	jalr	-1064(ra) # 578c <close>
      wait(&xstatus);
    4bbc:	f6c40513          	addi	a0,s0,-148
    4bc0:	00001097          	auipc	ra,0x1
    4bc4:	bac080e7          	jalr	-1108(ra) # 576c <wait>
      if(xstatus != 0)
    4bc8:	f6c42483          	lw	s1,-148(s0)
    4bcc:	da0494e3          	bnez	s1,4974 <concreate+0xa4>
  for(i = 0; i < N; i++){
    4bd0:	2905                	addiw	s2,s2,1
    4bd2:	db4906e3          	beq	s2,s4,497e <concreate+0xae>
    file[1] = '0' + i;
    4bd6:	0309079b          	addiw	a5,s2,48
    4bda:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4bde:	fa840513          	addi	a0,s0,-88
    4be2:	00001097          	auipc	ra,0x1
    4be6:	bd2080e7          	jalr	-1070(ra) # 57b4 <unlink>
    pid = fork();
    4bea:	00001097          	auipc	ra,0x1
    4bee:	b72080e7          	jalr	-1166(ra) # 575c <fork>
    if(pid && (i % 3) == 1){
    4bf2:	d20503e3          	beqz	a0,4918 <concreate+0x48>
    4bf6:	036967bb          	remw	a5,s2,s6
    4bfa:	d15787e3          	beq	a5,s5,4908 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4bfe:	20200593          	li	a1,514
    4c02:	fa840513          	addi	a0,s0,-88
    4c06:	00001097          	auipc	ra,0x1
    4c0a:	b9e080e7          	jalr	-1122(ra) # 57a4 <open>
      if(fd < 0){
    4c0e:	fa0553e3          	bgez	a0,4bb4 <concreate+0x2e4>
    4c12:	b31d                	j	4938 <concreate+0x68>
}
    4c14:	60ea                	ld	ra,152(sp)
    4c16:	644a                	ld	s0,144(sp)
    4c18:	64aa                	ld	s1,136(sp)
    4c1a:	690a                	ld	s2,128(sp)
    4c1c:	79e6                	ld	s3,120(sp)
    4c1e:	7a46                	ld	s4,112(sp)
    4c20:	7aa6                	ld	s5,104(sp)
    4c22:	7b06                	ld	s6,96(sp)
    4c24:	6be6                	ld	s7,88(sp)
    4c26:	610d                	addi	sp,sp,160
    4c28:	8082                	ret

0000000000004c2a <bigfile>:
{
    4c2a:	7139                	addi	sp,sp,-64
    4c2c:	fc06                	sd	ra,56(sp)
    4c2e:	f822                	sd	s0,48(sp)
    4c30:	f426                	sd	s1,40(sp)
    4c32:	f04a                	sd	s2,32(sp)
    4c34:	ec4e                	sd	s3,24(sp)
    4c36:	e852                	sd	s4,16(sp)
    4c38:	e456                	sd	s5,8(sp)
    4c3a:	0080                	addi	s0,sp,64
    4c3c:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4c3e:	00003517          	auipc	a0,0x3
    4c42:	0f250513          	addi	a0,a0,242 # 7d30 <malloc+0x218e>
    4c46:	00001097          	auipc	ra,0x1
    4c4a:	b6e080e7          	jalr	-1170(ra) # 57b4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4c4e:	20200593          	li	a1,514
    4c52:	00003517          	auipc	a0,0x3
    4c56:	0de50513          	addi	a0,a0,222 # 7d30 <malloc+0x218e>
    4c5a:	00001097          	auipc	ra,0x1
    4c5e:	b4a080e7          	jalr	-1206(ra) # 57a4 <open>
    4c62:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4c64:	4481                	li	s1,0
    memset(buf, i, SZ);
    4c66:	00007917          	auipc	s2,0x7
    4c6a:	02290913          	addi	s2,s2,34 # bc88 <buf>
  for(i = 0; i < N; i++){
    4c6e:	4a51                	li	s4,20
  if(fd < 0){
    4c70:	0a054063          	bltz	a0,4d10 <bigfile+0xe6>
    memset(buf, i, SZ);
    4c74:	25800613          	li	a2,600
    4c78:	85a6                	mv	a1,s1
    4c7a:	854a                	mv	a0,s2
    4c7c:	00001097          	auipc	ra,0x1
    4c80:	8ec080e7          	jalr	-1812(ra) # 5568 <memset>
    if(write(fd, buf, SZ) != SZ){
    4c84:	25800613          	li	a2,600
    4c88:	85ca                	mv	a1,s2
    4c8a:	854e                	mv	a0,s3
    4c8c:	00001097          	auipc	ra,0x1
    4c90:	af8080e7          	jalr	-1288(ra) # 5784 <write>
    4c94:	25800793          	li	a5,600
    4c98:	08f51a63          	bne	a0,a5,4d2c <bigfile+0x102>
  for(i = 0; i < N; i++){
    4c9c:	2485                	addiw	s1,s1,1
    4c9e:	fd449be3          	bne	s1,s4,4c74 <bigfile+0x4a>
  close(fd);
    4ca2:	854e                	mv	a0,s3
    4ca4:	00001097          	auipc	ra,0x1
    4ca8:	ae8080e7          	jalr	-1304(ra) # 578c <close>
  fd = open("bigfile.dat", 0);
    4cac:	4581                	li	a1,0
    4cae:	00003517          	auipc	a0,0x3
    4cb2:	08250513          	addi	a0,a0,130 # 7d30 <malloc+0x218e>
    4cb6:	00001097          	auipc	ra,0x1
    4cba:	aee080e7          	jalr	-1298(ra) # 57a4 <open>
    4cbe:	8a2a                	mv	s4,a0
  total = 0;
    4cc0:	4981                	li	s3,0
  for(i = 0; ; i++){
    4cc2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4cc4:	00007917          	auipc	s2,0x7
    4cc8:	fc490913          	addi	s2,s2,-60 # bc88 <buf>
  if(fd < 0){
    4ccc:	06054e63          	bltz	a0,4d48 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    4cd0:	12c00613          	li	a2,300
    4cd4:	85ca                	mv	a1,s2
    4cd6:	8552                	mv	a0,s4
    4cd8:	00001097          	auipc	ra,0x1
    4cdc:	aa4080e7          	jalr	-1372(ra) # 577c <read>
    if(cc < 0){
    4ce0:	08054263          	bltz	a0,4d64 <bigfile+0x13a>
    if(cc == 0)
    4ce4:	c971                	beqz	a0,4db8 <bigfile+0x18e>
    if(cc != SZ/2){
    4ce6:	12c00793          	li	a5,300
    4cea:	08f51b63          	bne	a0,a5,4d80 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4cee:	01f4d79b          	srliw	a5,s1,0x1f
    4cf2:	9fa5                	addw	a5,a5,s1
    4cf4:	4017d79b          	sraiw	a5,a5,0x1
    4cf8:	00094703          	lbu	a4,0(s2)
    4cfc:	0af71063          	bne	a4,a5,4d9c <bigfile+0x172>
    4d00:	12b94703          	lbu	a4,299(s2)
    4d04:	08f71c63          	bne	a4,a5,4d9c <bigfile+0x172>
    total += cc;
    4d08:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4d0c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4d0e:	b7c9                	j	4cd0 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4d10:	85d6                	mv	a1,s5
    4d12:	00003517          	auipc	a0,0x3
    4d16:	02e50513          	addi	a0,a0,46 # 7d40 <malloc+0x219e>
    4d1a:	00001097          	auipc	ra,0x1
    4d1e:	dca080e7          	jalr	-566(ra) # 5ae4 <printf>
    exit(1);
    4d22:	4505                	li	a0,1
    4d24:	00001097          	auipc	ra,0x1
    4d28:	a40080e7          	jalr	-1472(ra) # 5764 <exit>
      printf("%s: write bigfile failed\n", s);
    4d2c:	85d6                	mv	a1,s5
    4d2e:	00003517          	auipc	a0,0x3
    4d32:	03250513          	addi	a0,a0,50 # 7d60 <malloc+0x21be>
    4d36:	00001097          	auipc	ra,0x1
    4d3a:	dae080e7          	jalr	-594(ra) # 5ae4 <printf>
      exit(1);
    4d3e:	4505                	li	a0,1
    4d40:	00001097          	auipc	ra,0x1
    4d44:	a24080e7          	jalr	-1500(ra) # 5764 <exit>
    printf("%s: cannot open bigfile\n", s);
    4d48:	85d6                	mv	a1,s5
    4d4a:	00003517          	auipc	a0,0x3
    4d4e:	03650513          	addi	a0,a0,54 # 7d80 <malloc+0x21de>
    4d52:	00001097          	auipc	ra,0x1
    4d56:	d92080e7          	jalr	-622(ra) # 5ae4 <printf>
    exit(1);
    4d5a:	4505                	li	a0,1
    4d5c:	00001097          	auipc	ra,0x1
    4d60:	a08080e7          	jalr	-1528(ra) # 5764 <exit>
      printf("%s: read bigfile failed\n", s);
    4d64:	85d6                	mv	a1,s5
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	03a50513          	addi	a0,a0,58 # 7da0 <malloc+0x21fe>
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	d76080e7          	jalr	-650(ra) # 5ae4 <printf>
      exit(1);
    4d76:	4505                	li	a0,1
    4d78:	00001097          	auipc	ra,0x1
    4d7c:	9ec080e7          	jalr	-1556(ra) # 5764 <exit>
      printf("%s: short read bigfile\n", s);
    4d80:	85d6                	mv	a1,s5
    4d82:	00003517          	auipc	a0,0x3
    4d86:	03e50513          	addi	a0,a0,62 # 7dc0 <malloc+0x221e>
    4d8a:	00001097          	auipc	ra,0x1
    4d8e:	d5a080e7          	jalr	-678(ra) # 5ae4 <printf>
      exit(1);
    4d92:	4505                	li	a0,1
    4d94:	00001097          	auipc	ra,0x1
    4d98:	9d0080e7          	jalr	-1584(ra) # 5764 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4d9c:	85d6                	mv	a1,s5
    4d9e:	00003517          	auipc	a0,0x3
    4da2:	03a50513          	addi	a0,a0,58 # 7dd8 <malloc+0x2236>
    4da6:	00001097          	auipc	ra,0x1
    4daa:	d3e080e7          	jalr	-706(ra) # 5ae4 <printf>
      exit(1);
    4dae:	4505                	li	a0,1
    4db0:	00001097          	auipc	ra,0x1
    4db4:	9b4080e7          	jalr	-1612(ra) # 5764 <exit>
  close(fd);
    4db8:	8552                	mv	a0,s4
    4dba:	00001097          	auipc	ra,0x1
    4dbe:	9d2080e7          	jalr	-1582(ra) # 578c <close>
  if(total != N*SZ){
    4dc2:	678d                	lui	a5,0x3
    4dc4:	ee078793          	addi	a5,a5,-288 # 2ee0 <exitiputtest+0x48>
    4dc8:	02f99363          	bne	s3,a5,4dee <bigfile+0x1c4>
  unlink("bigfile.dat");
    4dcc:	00003517          	auipc	a0,0x3
    4dd0:	f6450513          	addi	a0,a0,-156 # 7d30 <malloc+0x218e>
    4dd4:	00001097          	auipc	ra,0x1
    4dd8:	9e0080e7          	jalr	-1568(ra) # 57b4 <unlink>
}
    4ddc:	70e2                	ld	ra,56(sp)
    4dde:	7442                	ld	s0,48(sp)
    4de0:	74a2                	ld	s1,40(sp)
    4de2:	7902                	ld	s2,32(sp)
    4de4:	69e2                	ld	s3,24(sp)
    4de6:	6a42                	ld	s4,16(sp)
    4de8:	6aa2                	ld	s5,8(sp)
    4dea:	6121                	addi	sp,sp,64
    4dec:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4dee:	85d6                	mv	a1,s5
    4df0:	00003517          	auipc	a0,0x3
    4df4:	00850513          	addi	a0,a0,8 # 7df8 <malloc+0x2256>
    4df8:	00001097          	auipc	ra,0x1
    4dfc:	cec080e7          	jalr	-788(ra) # 5ae4 <printf>
    exit(1);
    4e00:	4505                	li	a0,1
    4e02:	00001097          	auipc	ra,0x1
    4e06:	962080e7          	jalr	-1694(ra) # 5764 <exit>

0000000000004e0a <fsfull>:
{
    4e0a:	7171                	addi	sp,sp,-176
    4e0c:	f506                	sd	ra,168(sp)
    4e0e:	f122                	sd	s0,160(sp)
    4e10:	ed26                	sd	s1,152(sp)
    4e12:	e94a                	sd	s2,144(sp)
    4e14:	e54e                	sd	s3,136(sp)
    4e16:	e152                	sd	s4,128(sp)
    4e18:	fcd6                	sd	s5,120(sp)
    4e1a:	f8da                	sd	s6,112(sp)
    4e1c:	f4de                	sd	s7,104(sp)
    4e1e:	f0e2                	sd	s8,96(sp)
    4e20:	ece6                	sd	s9,88(sp)
    4e22:	e8ea                	sd	s10,80(sp)
    4e24:	e4ee                	sd	s11,72(sp)
    4e26:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4e28:	00003517          	auipc	a0,0x3
    4e2c:	ff050513          	addi	a0,a0,-16 # 7e18 <malloc+0x2276>
    4e30:	00001097          	auipc	ra,0x1
    4e34:	cb4080e7          	jalr	-844(ra) # 5ae4 <printf>
  for(nfiles = 0; ; nfiles++){
    4e38:	4481                	li	s1,0
    name[0] = 'f';
    4e3a:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4e3e:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4e42:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4e46:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4e48:	00003c97          	auipc	s9,0x3
    4e4c:	fe0c8c93          	addi	s9,s9,-32 # 7e28 <malloc+0x2286>
    int total = 0;
    4e50:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4e52:	00007a17          	auipc	s4,0x7
    4e56:	e36a0a13          	addi	s4,s4,-458 # bc88 <buf>
    name[0] = 'f';
    4e5a:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e5e:	0384c7bb          	divw	a5,s1,s8
    4e62:	0307879b          	addiw	a5,a5,48
    4e66:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e6a:	0384e7bb          	remw	a5,s1,s8
    4e6e:	0377c7bb          	divw	a5,a5,s7
    4e72:	0307879b          	addiw	a5,a5,48
    4e76:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4e7a:	0374e7bb          	remw	a5,s1,s7
    4e7e:	0367c7bb          	divw	a5,a5,s6
    4e82:	0307879b          	addiw	a5,a5,48
    4e86:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e8a:	0364e7bb          	remw	a5,s1,s6
    4e8e:	0307879b          	addiw	a5,a5,48
    4e92:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e96:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4e9a:	f5040593          	addi	a1,s0,-176
    4e9e:	8566                	mv	a0,s9
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	c44080e7          	jalr	-956(ra) # 5ae4 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ea8:	20200593          	li	a1,514
    4eac:	f5040513          	addi	a0,s0,-176
    4eb0:	00001097          	auipc	ra,0x1
    4eb4:	8f4080e7          	jalr	-1804(ra) # 57a4 <open>
    4eb8:	892a                	mv	s2,a0
    if(fd < 0){
    4eba:	0a055663          	bgez	a0,4f66 <fsfull+0x15c>
      printf("open %s failed\n", name);
    4ebe:	f5040593          	addi	a1,s0,-176
    4ec2:	00003517          	auipc	a0,0x3
    4ec6:	f7650513          	addi	a0,a0,-138 # 7e38 <malloc+0x2296>
    4eca:	00001097          	auipc	ra,0x1
    4ece:	c1a080e7          	jalr	-998(ra) # 5ae4 <printf>
  while(nfiles >= 0){
    4ed2:	0604c363          	bltz	s1,4f38 <fsfull+0x12e>
    name[0] = 'f';
    4ed6:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4eda:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4ede:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4ee2:	4929                	li	s2,10
  while(nfiles >= 0){
    4ee4:	5afd                	li	s5,-1
    name[0] = 'f';
    4ee6:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4eea:	0344c7bb          	divw	a5,s1,s4
    4eee:	0307879b          	addiw	a5,a5,48
    4ef2:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4ef6:	0344e7bb          	remw	a5,s1,s4
    4efa:	0337c7bb          	divw	a5,a5,s3
    4efe:	0307879b          	addiw	a5,a5,48
    4f02:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4f06:	0334e7bb          	remw	a5,s1,s3
    4f0a:	0327c7bb          	divw	a5,a5,s2
    4f0e:	0307879b          	addiw	a5,a5,48
    4f12:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4f16:	0324e7bb          	remw	a5,s1,s2
    4f1a:	0307879b          	addiw	a5,a5,48
    4f1e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4f22:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f26:	f5040513          	addi	a0,s0,-176
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	88a080e7          	jalr	-1910(ra) # 57b4 <unlink>
    nfiles--;
    4f32:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4f34:	fb5499e3          	bne	s1,s5,4ee6 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	f2050513          	addi	a0,a0,-224 # 7e58 <malloc+0x22b6>
    4f40:	00001097          	auipc	ra,0x1
    4f44:	ba4080e7          	jalr	-1116(ra) # 5ae4 <printf>
}
    4f48:	70aa                	ld	ra,168(sp)
    4f4a:	740a                	ld	s0,160(sp)
    4f4c:	64ea                	ld	s1,152(sp)
    4f4e:	694a                	ld	s2,144(sp)
    4f50:	69aa                	ld	s3,136(sp)
    4f52:	6a0a                	ld	s4,128(sp)
    4f54:	7ae6                	ld	s5,120(sp)
    4f56:	7b46                	ld	s6,112(sp)
    4f58:	7ba6                	ld	s7,104(sp)
    4f5a:	7c06                	ld	s8,96(sp)
    4f5c:	6ce6                	ld	s9,88(sp)
    4f5e:	6d46                	ld	s10,80(sp)
    4f60:	6da6                	ld	s11,72(sp)
    4f62:	614d                	addi	sp,sp,176
    4f64:	8082                	ret
    int total = 0;
    4f66:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4f68:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4f6c:	40000613          	li	a2,1024
    4f70:	85d2                	mv	a1,s4
    4f72:	854a                	mv	a0,s2
    4f74:	00001097          	auipc	ra,0x1
    4f78:	810080e7          	jalr	-2032(ra) # 5784 <write>
      if(cc < BSIZE)
    4f7c:	00aad563          	bge	s5,a0,4f86 <fsfull+0x17c>
      total += cc;
    4f80:	00a989bb          	addw	s3,s3,a0
    while(1){
    4f84:	b7e5                	j	4f6c <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    4f86:	85ce                	mv	a1,s3
    4f88:	00003517          	auipc	a0,0x3
    4f8c:	ec050513          	addi	a0,a0,-320 # 7e48 <malloc+0x22a6>
    4f90:	00001097          	auipc	ra,0x1
    4f94:	b54080e7          	jalr	-1196(ra) # 5ae4 <printf>
    close(fd);
    4f98:	854a                	mv	a0,s2
    4f9a:	00000097          	auipc	ra,0x0
    4f9e:	7f2080e7          	jalr	2034(ra) # 578c <close>
    if(total == 0)
    4fa2:	f20988e3          	beqz	s3,4ed2 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4fa6:	2485                	addiw	s1,s1,1
    4fa8:	bd4d                	j	4e5a <fsfull+0x50>

0000000000004faa <rand>:
{
    4faa:	1141                	addi	sp,sp,-16
    4fac:	e422                	sd	s0,8(sp)
    4fae:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4fb0:	00003717          	auipc	a4,0x3
    4fb4:	4b070713          	addi	a4,a4,1200 # 8460 <randstate>
    4fb8:	6308                	ld	a0,0(a4)
    4fba:	001967b7          	lui	a5,0x196
    4fbe:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187975>
    4fc2:	02f50533          	mul	a0,a0,a5
    4fc6:	3c6ef7b7          	lui	a5,0x3c6ef
    4fca:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e06c7>
    4fce:	953e                	add	a0,a0,a5
    4fd0:	e308                	sd	a0,0(a4)
}
    4fd2:	2501                	sext.w	a0,a0
    4fd4:	6422                	ld	s0,8(sp)
    4fd6:	0141                	addi	sp,sp,16
    4fd8:	8082                	ret

0000000000004fda <badwrite>:
{
    4fda:	7179                	addi	sp,sp,-48
    4fdc:	f406                	sd	ra,40(sp)
    4fde:	f022                	sd	s0,32(sp)
    4fe0:	ec26                	sd	s1,24(sp)
    4fe2:	e84a                	sd	s2,16(sp)
    4fe4:	e44e                	sd	s3,8(sp)
    4fe6:	e052                	sd	s4,0(sp)
    4fe8:	1800                	addi	s0,sp,48
  unlink("junk");
    4fea:	00003517          	auipc	a0,0x3
    4fee:	e8650513          	addi	a0,a0,-378 # 7e70 <malloc+0x22ce>
    4ff2:	00000097          	auipc	ra,0x0
    4ff6:	7c2080e7          	jalr	1986(ra) # 57b4 <unlink>
    4ffa:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4ffe:	00003997          	auipc	s3,0x3
    5002:	e7298993          	addi	s3,s3,-398 # 7e70 <malloc+0x22ce>
    write(fd, (char*)0xffffffffffL, 1);
    5006:	5a7d                	li	s4,-1
    5008:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    500c:	20100593          	li	a1,513
    5010:	854e                	mv	a0,s3
    5012:	00000097          	auipc	ra,0x0
    5016:	792080e7          	jalr	1938(ra) # 57a4 <open>
    501a:	84aa                	mv	s1,a0
    if(fd < 0){
    501c:	06054b63          	bltz	a0,5092 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    5020:	4605                	li	a2,1
    5022:	85d2                	mv	a1,s4
    5024:	00000097          	auipc	ra,0x0
    5028:	760080e7          	jalr	1888(ra) # 5784 <write>
    close(fd);
    502c:	8526                	mv	a0,s1
    502e:	00000097          	auipc	ra,0x0
    5032:	75e080e7          	jalr	1886(ra) # 578c <close>
    unlink("junk");
    5036:	854e                	mv	a0,s3
    5038:	00000097          	auipc	ra,0x0
    503c:	77c080e7          	jalr	1916(ra) # 57b4 <unlink>
  for(int i = 0; i < assumed_free; i++){
    5040:	397d                	addiw	s2,s2,-1
    5042:	fc0915e3          	bnez	s2,500c <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    5046:	20100593          	li	a1,513
    504a:	00003517          	auipc	a0,0x3
    504e:	e2650513          	addi	a0,a0,-474 # 7e70 <malloc+0x22ce>
    5052:	00000097          	auipc	ra,0x0
    5056:	752080e7          	jalr	1874(ra) # 57a4 <open>
    505a:	84aa                	mv	s1,a0
  if(fd < 0){
    505c:	04054863          	bltz	a0,50ac <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    5060:	4605                	li	a2,1
    5062:	00001597          	auipc	a1,0x1
    5066:	00e58593          	addi	a1,a1,14 # 6070 <malloc+0x4ce>
    506a:	00000097          	auipc	ra,0x0
    506e:	71a080e7          	jalr	1818(ra) # 5784 <write>
    5072:	4785                	li	a5,1
    5074:	04f50963          	beq	a0,a5,50c6 <badwrite+0xec>
    printf("write failed\n");
    5078:	00003517          	auipc	a0,0x3
    507c:	e1850513          	addi	a0,a0,-488 # 7e90 <malloc+0x22ee>
    5080:	00001097          	auipc	ra,0x1
    5084:	a64080e7          	jalr	-1436(ra) # 5ae4 <printf>
    exit(1);
    5088:	4505                	li	a0,1
    508a:	00000097          	auipc	ra,0x0
    508e:	6da080e7          	jalr	1754(ra) # 5764 <exit>
      printf("open junk failed\n");
    5092:	00003517          	auipc	a0,0x3
    5096:	de650513          	addi	a0,a0,-538 # 7e78 <malloc+0x22d6>
    509a:	00001097          	auipc	ra,0x1
    509e:	a4a080e7          	jalr	-1462(ra) # 5ae4 <printf>
      exit(1);
    50a2:	4505                	li	a0,1
    50a4:	00000097          	auipc	ra,0x0
    50a8:	6c0080e7          	jalr	1728(ra) # 5764 <exit>
    printf("open junk failed\n");
    50ac:	00003517          	auipc	a0,0x3
    50b0:	dcc50513          	addi	a0,a0,-564 # 7e78 <malloc+0x22d6>
    50b4:	00001097          	auipc	ra,0x1
    50b8:	a30080e7          	jalr	-1488(ra) # 5ae4 <printf>
    exit(1);
    50bc:	4505                	li	a0,1
    50be:	00000097          	auipc	ra,0x0
    50c2:	6a6080e7          	jalr	1702(ra) # 5764 <exit>
  close(fd);
    50c6:	8526                	mv	a0,s1
    50c8:	00000097          	auipc	ra,0x0
    50cc:	6c4080e7          	jalr	1732(ra) # 578c <close>
  unlink("junk");
    50d0:	00003517          	auipc	a0,0x3
    50d4:	da050513          	addi	a0,a0,-608 # 7e70 <malloc+0x22ce>
    50d8:	00000097          	auipc	ra,0x0
    50dc:	6dc080e7          	jalr	1756(ra) # 57b4 <unlink>
  exit(0);
    50e0:	4501                	li	a0,0
    50e2:	00000097          	auipc	ra,0x0
    50e6:	682080e7          	jalr	1666(ra) # 5764 <exit>

00000000000050ea <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    50ea:	7139                	addi	sp,sp,-64
    50ec:	fc06                	sd	ra,56(sp)
    50ee:	f822                	sd	s0,48(sp)
    50f0:	f426                	sd	s1,40(sp)
    50f2:	f04a                	sd	s2,32(sp)
    50f4:	ec4e                	sd	s3,24(sp)
    50f6:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    50f8:	fc840513          	addi	a0,s0,-56
    50fc:	00000097          	auipc	ra,0x0
    5100:	678080e7          	jalr	1656(ra) # 5774 <pipe>
    5104:	06054763          	bltz	a0,5172 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5108:	00000097          	auipc	ra,0x0
    510c:	654080e7          	jalr	1620(ra) # 575c <fork>

  if(pid < 0){
    5110:	06054e63          	bltz	a0,518c <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5114:	ed51                	bnez	a0,51b0 <countfree+0xc6>
    close(fds[0]);
    5116:	fc842503          	lw	a0,-56(s0)
    511a:	00000097          	auipc	ra,0x0
    511e:	672080e7          	jalr	1650(ra) # 578c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    5122:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5124:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5126:	00001997          	auipc	s3,0x1
    512a:	f4a98993          	addi	s3,s3,-182 # 6070 <malloc+0x4ce>
      uint64 a = (uint64) sbrk(4096);
    512e:	6505                	lui	a0,0x1
    5130:	00000097          	auipc	ra,0x0
    5134:	6bc080e7          	jalr	1724(ra) # 57ec <sbrk>
      if(a == 0xffffffffffffffff){
    5138:	07250763          	beq	a0,s2,51a6 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    513c:	6785                	lui	a5,0x1
    513e:	953e                	add	a0,a0,a5
    5140:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x9d>
      if(write(fds[1], "x", 1) != 1){
    5144:	8626                	mv	a2,s1
    5146:	85ce                	mv	a1,s3
    5148:	fcc42503          	lw	a0,-52(s0)
    514c:	00000097          	auipc	ra,0x0
    5150:	638080e7          	jalr	1592(ra) # 5784 <write>
    5154:	fc950de3          	beq	a0,s1,512e <countfree+0x44>
        printf("write() failed in countfree()\n");
    5158:	00003517          	auipc	a0,0x3
    515c:	d8850513          	addi	a0,a0,-632 # 7ee0 <malloc+0x233e>
    5160:	00001097          	auipc	ra,0x1
    5164:	984080e7          	jalr	-1660(ra) # 5ae4 <printf>
        exit(1);
    5168:	4505                	li	a0,1
    516a:	00000097          	auipc	ra,0x0
    516e:	5fa080e7          	jalr	1530(ra) # 5764 <exit>
    printf("pipe() failed in countfree()\n");
    5172:	00003517          	auipc	a0,0x3
    5176:	d2e50513          	addi	a0,a0,-722 # 7ea0 <malloc+0x22fe>
    517a:	00001097          	auipc	ra,0x1
    517e:	96a080e7          	jalr	-1686(ra) # 5ae4 <printf>
    exit(1);
    5182:	4505                	li	a0,1
    5184:	00000097          	auipc	ra,0x0
    5188:	5e0080e7          	jalr	1504(ra) # 5764 <exit>
    printf("fork failed in countfree()\n");
    518c:	00003517          	auipc	a0,0x3
    5190:	d3450513          	addi	a0,a0,-716 # 7ec0 <malloc+0x231e>
    5194:	00001097          	auipc	ra,0x1
    5198:	950080e7          	jalr	-1712(ra) # 5ae4 <printf>
    exit(1);
    519c:	4505                	li	a0,1
    519e:	00000097          	auipc	ra,0x0
    51a2:	5c6080e7          	jalr	1478(ra) # 5764 <exit>
      }
    }

    exit(0);
    51a6:	4501                	li	a0,0
    51a8:	00000097          	auipc	ra,0x0
    51ac:	5bc080e7          	jalr	1468(ra) # 5764 <exit>
  }

  close(fds[1]);
    51b0:	fcc42503          	lw	a0,-52(s0)
    51b4:	00000097          	auipc	ra,0x0
    51b8:	5d8080e7          	jalr	1496(ra) # 578c <close>

  int n = 0;
    51bc:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    51be:	4605                	li	a2,1
    51c0:	fc740593          	addi	a1,s0,-57
    51c4:	fc842503          	lw	a0,-56(s0)
    51c8:	00000097          	auipc	ra,0x0
    51cc:	5b4080e7          	jalr	1460(ra) # 577c <read>
    if(cc < 0){
    51d0:	00054563          	bltz	a0,51da <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    51d4:	c105                	beqz	a0,51f4 <countfree+0x10a>
      break;
    n += 1;
    51d6:	2485                	addiw	s1,s1,1
  while(1){
    51d8:	b7dd                	j	51be <countfree+0xd4>
      printf("read() failed in countfree()\n");
    51da:	00003517          	auipc	a0,0x3
    51de:	d2650513          	addi	a0,a0,-730 # 7f00 <malloc+0x235e>
    51e2:	00001097          	auipc	ra,0x1
    51e6:	902080e7          	jalr	-1790(ra) # 5ae4 <printf>
      exit(1);
    51ea:	4505                	li	a0,1
    51ec:	00000097          	auipc	ra,0x0
    51f0:	578080e7          	jalr	1400(ra) # 5764 <exit>
  }

  close(fds[0]);
    51f4:	fc842503          	lw	a0,-56(s0)
    51f8:	00000097          	auipc	ra,0x0
    51fc:	594080e7          	jalr	1428(ra) # 578c <close>
  wait((int*)0);
    5200:	4501                	li	a0,0
    5202:	00000097          	auipc	ra,0x0
    5206:	56a080e7          	jalr	1386(ra) # 576c <wait>
  
  return n;
}
    520a:	8526                	mv	a0,s1
    520c:	70e2                	ld	ra,56(sp)
    520e:	7442                	ld	s0,48(sp)
    5210:	74a2                	ld	s1,40(sp)
    5212:	7902                	ld	s2,32(sp)
    5214:	69e2                	ld	s3,24(sp)
    5216:	6121                	addi	sp,sp,64
    5218:	8082                	ret

000000000000521a <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    521a:	7179                	addi	sp,sp,-48
    521c:	f406                	sd	ra,40(sp)
    521e:	f022                	sd	s0,32(sp)
    5220:	ec26                	sd	s1,24(sp)
    5222:	e84a                	sd	s2,16(sp)
    5224:	1800                	addi	s0,sp,48
    5226:	84aa                	mv	s1,a0
    5228:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    522a:	00003517          	auipc	a0,0x3
    522e:	cf650513          	addi	a0,a0,-778 # 7f20 <malloc+0x237e>
    5232:	00001097          	auipc	ra,0x1
    5236:	8b2080e7          	jalr	-1870(ra) # 5ae4 <printf>
  if((pid = fork()) < 0) {
    523a:	00000097          	auipc	ra,0x0
    523e:	522080e7          	jalr	1314(ra) # 575c <fork>
    5242:	02054e63          	bltz	a0,527e <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5246:	c929                	beqz	a0,5298 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    5248:	fdc40513          	addi	a0,s0,-36
    524c:	00000097          	auipc	ra,0x0
    5250:	520080e7          	jalr	1312(ra) # 576c <wait>
    if(xstatus != 0) 
    5254:	fdc42783          	lw	a5,-36(s0)
    5258:	c7b9                	beqz	a5,52a6 <run+0x8c>
      printf("FAILED\n");
    525a:	00003517          	auipc	a0,0x3
    525e:	cee50513          	addi	a0,a0,-786 # 7f48 <malloc+0x23a6>
    5262:	00001097          	auipc	ra,0x1
    5266:	882080e7          	jalr	-1918(ra) # 5ae4 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    526a:	fdc42503          	lw	a0,-36(s0)
  }
}
    526e:	00153513          	seqz	a0,a0
    5272:	70a2                	ld	ra,40(sp)
    5274:	7402                	ld	s0,32(sp)
    5276:	64e2                	ld	s1,24(sp)
    5278:	6942                	ld	s2,16(sp)
    527a:	6145                	addi	sp,sp,48
    527c:	8082                	ret
    printf("runtest: fork error\n");
    527e:	00003517          	auipc	a0,0x3
    5282:	cb250513          	addi	a0,a0,-846 # 7f30 <malloc+0x238e>
    5286:	00001097          	auipc	ra,0x1
    528a:	85e080e7          	jalr	-1954(ra) # 5ae4 <printf>
    exit(1);
    528e:	4505                	li	a0,1
    5290:	00000097          	auipc	ra,0x0
    5294:	4d4080e7          	jalr	1236(ra) # 5764 <exit>
    f(s);
    5298:	854a                	mv	a0,s2
    529a:	9482                	jalr	s1
    exit(0);
    529c:	4501                	li	a0,0
    529e:	00000097          	auipc	ra,0x0
    52a2:	4c6080e7          	jalr	1222(ra) # 5764 <exit>
      printf("OK\n");
    52a6:	00003517          	auipc	a0,0x3
    52aa:	caa50513          	addi	a0,a0,-854 # 7f50 <malloc+0x23ae>
    52ae:	00001097          	auipc	ra,0x1
    52b2:	836080e7          	jalr	-1994(ra) # 5ae4 <printf>
    52b6:	bf55                	j	526a <run+0x50>

00000000000052b8 <main>:

int
main(int argc, char *argv[])
{
    52b8:	bf010113          	addi	sp,sp,-1040
    52bc:	40113423          	sd	ra,1032(sp)
    52c0:	40813023          	sd	s0,1024(sp)
    52c4:	3e913c23          	sd	s1,1016(sp)
    52c8:	3f213823          	sd	s2,1008(sp)
    52cc:	3f313423          	sd	s3,1000(sp)
    52d0:	3f413023          	sd	s4,992(sp)
    52d4:	3d513c23          	sd	s5,984(sp)
    52d8:	3d613823          	sd	s6,976(sp)
    52dc:	41010413          	addi	s0,sp,1040
    52e0:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    52e2:	4789                	li	a5,2
    52e4:	08f50b63          	beq	a0,a5,537a <main+0xc2>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    52e8:	4785                	li	a5,1
  char *justone = 0;
    52ea:	4901                	li	s2,0
  } else if(argc > 1){
    52ec:	0ca7c563          	blt	a5,a0,53b6 <main+0xfe>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    52f0:	00003797          	auipc	a5,0x3
    52f4:	d7878793          	addi	a5,a5,-648 # 8068 <malloc+0x24c6>
    52f8:	bf040713          	addi	a4,s0,-1040
    52fc:	00003817          	auipc	a6,0x3
    5300:	12c80813          	addi	a6,a6,300 # 8428 <malloc+0x2886>
    5304:	6388                	ld	a0,0(a5)
    5306:	678c                	ld	a1,8(a5)
    5308:	6b90                	ld	a2,16(a5)
    530a:	6f94                	ld	a3,24(a5)
    530c:	e308                	sd	a0,0(a4)
    530e:	e70c                	sd	a1,8(a4)
    5310:	eb10                	sd	a2,16(a4)
    5312:	ef14                	sd	a3,24(a4)
    5314:	02078793          	addi	a5,a5,32
    5318:	02070713          	addi	a4,a4,32
    531c:	ff0794e3          	bne	a5,a6,5304 <main+0x4c>
    5320:	6394                	ld	a3,0(a5)
    5322:	679c                	ld	a5,8(a5)
    5324:	e314                	sd	a3,0(a4)
    5326:	e71c                	sd	a5,8(a4)
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    5328:	00003517          	auipc	a0,0x3
    532c:	ce050513          	addi	a0,a0,-800 # 8008 <malloc+0x2466>
    5330:	00000097          	auipc	ra,0x0
    5334:	7b4080e7          	jalr	1972(ra) # 5ae4 <printf>
  int free0 = countfree();
    5338:	00000097          	auipc	ra,0x0
    533c:	db2080e7          	jalr	-590(ra) # 50ea <countfree>
    5340:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5342:	bf843503          	ld	a0,-1032(s0)
    5346:	bf040493          	addi	s1,s0,-1040
  int fail = 0;
    534a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    534c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    534e:	e55d                	bnez	a0,53fc <main+0x144>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    5350:	00000097          	auipc	ra,0x0
    5354:	d9a080e7          	jalr	-614(ra) # 50ea <countfree>
    5358:	85aa                	mv	a1,a0
    535a:	0f455163          	bge	a0,s4,543c <main+0x184>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    535e:	8652                	mv	a2,s4
    5360:	00003517          	auipc	a0,0x3
    5364:	c6050513          	addi	a0,a0,-928 # 7fc0 <malloc+0x241e>
    5368:	00000097          	auipc	ra,0x0
    536c:	77c080e7          	jalr	1916(ra) # 5ae4 <printf>
    exit(1);
    5370:	4505                	li	a0,1
    5372:	00000097          	auipc	ra,0x0
    5376:	3f2080e7          	jalr	1010(ra) # 5764 <exit>
    537a:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    537c:	00003597          	auipc	a1,0x3
    5380:	bdc58593          	addi	a1,a1,-1060 # 7f58 <malloc+0x23b6>
    5384:	6488                	ld	a0,8(s1)
    5386:	00000097          	auipc	ra,0x0
    538a:	18c080e7          	jalr	396(ra) # 5512 <strcmp>
    538e:	10050563          	beqz	a0,5498 <main+0x1e0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    5392:	00003597          	auipc	a1,0x3
    5396:	cae58593          	addi	a1,a1,-850 # 8040 <malloc+0x249e>
    539a:	6488                	ld	a0,8(s1)
    539c:	00000097          	auipc	ra,0x0
    53a0:	176080e7          	jalr	374(ra) # 5512 <strcmp>
    53a4:	c97d                	beqz	a0,549a <main+0x1e2>
  } else if(argc == 2 && argv[1][0] != '-'){
    53a6:	0084b903          	ld	s2,8(s1)
    53aa:	00094703          	lbu	a4,0(s2)
    53ae:	02d00793          	li	a5,45
    53b2:	f2f71fe3          	bne	a4,a5,52f0 <main+0x38>
    printf("Usage: usertests [-c] [testname]\n");
    53b6:	00003517          	auipc	a0,0x3
    53ba:	baa50513          	addi	a0,a0,-1110 # 7f60 <malloc+0x23be>
    53be:	00000097          	auipc	ra,0x0
    53c2:	726080e7          	jalr	1830(ra) # 5ae4 <printf>
    exit(1);
    53c6:	4505                	li	a0,1
    53c8:	00000097          	auipc	ra,0x0
    53cc:	39c080e7          	jalr	924(ra) # 5764 <exit>
          exit(1);
    53d0:	4505                	li	a0,1
    53d2:	00000097          	auipc	ra,0x0
    53d6:	392080e7          	jalr	914(ra) # 5764 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    53da:	40a905bb          	subw	a1,s2,a0
    53de:	855a                	mv	a0,s6
    53e0:	00000097          	auipc	ra,0x0
    53e4:	704080e7          	jalr	1796(ra) # 5ae4 <printf>
        if(continuous != 2)
    53e8:	09498463          	beq	s3,s4,5470 <main+0x1b8>
          exit(1);
    53ec:	4505                	li	a0,1
    53ee:	00000097          	auipc	ra,0x0
    53f2:	376080e7          	jalr	886(ra) # 5764 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    53f6:	04c1                	addi	s1,s1,16
    53f8:	6488                	ld	a0,8(s1)
    53fa:	c115                	beqz	a0,541e <main+0x166>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    53fc:	00090863          	beqz	s2,540c <main+0x154>
    5400:	85ca                	mv	a1,s2
    5402:	00000097          	auipc	ra,0x0
    5406:	110080e7          	jalr	272(ra) # 5512 <strcmp>
    540a:	f575                	bnez	a0,53f6 <main+0x13e>
      if(!run(t->f, t->s))
    540c:	648c                	ld	a1,8(s1)
    540e:	6088                	ld	a0,0(s1)
    5410:	00000097          	auipc	ra,0x0
    5414:	e0a080e7          	jalr	-502(ra) # 521a <run>
    5418:	fd79                	bnez	a0,53f6 <main+0x13e>
        fail = 1;
    541a:	89d6                	mv	s3,s5
    541c:	bfe9                	j	53f6 <main+0x13e>
  if(fail){
    541e:	f20989e3          	beqz	s3,5350 <main+0x98>
    printf("SOME TESTS FAILED\n");
    5422:	00003517          	auipc	a0,0x3
    5426:	b8650513          	addi	a0,a0,-1146 # 7fa8 <malloc+0x2406>
    542a:	00000097          	auipc	ra,0x0
    542e:	6ba080e7          	jalr	1722(ra) # 5ae4 <printf>
    exit(1);
    5432:	4505                	li	a0,1
    5434:	00000097          	auipc	ra,0x0
    5438:	330080e7          	jalr	816(ra) # 5764 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    543c:	00003517          	auipc	a0,0x3
    5440:	bb450513          	addi	a0,a0,-1100 # 7ff0 <malloc+0x244e>
    5444:	00000097          	auipc	ra,0x0
    5448:	6a0080e7          	jalr	1696(ra) # 5ae4 <printf>
    exit(0);
    544c:	4501                	li	a0,0
    544e:	00000097          	auipc	ra,0x0
    5452:	316080e7          	jalr	790(ra) # 5764 <exit>
        printf("SOME TESTS FAILED\n");
    5456:	8556                	mv	a0,s5
    5458:	00000097          	auipc	ra,0x0
    545c:	68c080e7          	jalr	1676(ra) # 5ae4 <printf>
        if(continuous != 2)
    5460:	f74998e3          	bne	s3,s4,53d0 <main+0x118>
      int free1 = countfree();
    5464:	00000097          	auipc	ra,0x0
    5468:	c86080e7          	jalr	-890(ra) # 50ea <countfree>
      if(free1 < free0){
    546c:	f72547e3          	blt	a0,s2,53da <main+0x122>
      int free0 = countfree();
    5470:	00000097          	auipc	ra,0x0
    5474:	c7a080e7          	jalr	-902(ra) # 50ea <countfree>
    5478:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    547a:	bf843583          	ld	a1,-1032(s0)
    547e:	d1fd                	beqz	a1,5464 <main+0x1ac>
    5480:	bf040493          	addi	s1,s0,-1040
        if(!run(t->f, t->s)){
    5484:	6088                	ld	a0,0(s1)
    5486:	00000097          	auipc	ra,0x0
    548a:	d94080e7          	jalr	-620(ra) # 521a <run>
    548e:	d561                	beqz	a0,5456 <main+0x19e>
      for (struct test *t = tests; t->s != 0; t++) {
    5490:	04c1                	addi	s1,s1,16
    5492:	648c                	ld	a1,8(s1)
    5494:	f9e5                	bnez	a1,5484 <main+0x1cc>
    5496:	b7f9                	j	5464 <main+0x1ac>
    continuous = 1;
    5498:	4985                	li	s3,1
  } tests[] = {
    549a:	00003797          	auipc	a5,0x3
    549e:	bce78793          	addi	a5,a5,-1074 # 8068 <malloc+0x24c6>
    54a2:	bf040713          	addi	a4,s0,-1040
    54a6:	00003817          	auipc	a6,0x3
    54aa:	f8280813          	addi	a6,a6,-126 # 8428 <malloc+0x2886>
    54ae:	6388                	ld	a0,0(a5)
    54b0:	678c                	ld	a1,8(a5)
    54b2:	6b90                	ld	a2,16(a5)
    54b4:	6f94                	ld	a3,24(a5)
    54b6:	e308                	sd	a0,0(a4)
    54b8:	e70c                	sd	a1,8(a4)
    54ba:	eb10                	sd	a2,16(a4)
    54bc:	ef14                	sd	a3,24(a4)
    54be:	02078793          	addi	a5,a5,32
    54c2:	02070713          	addi	a4,a4,32
    54c6:	ff0794e3          	bne	a5,a6,54ae <main+0x1f6>
    54ca:	6394                	ld	a3,0(a5)
    54cc:	679c                	ld	a5,8(a5)
    54ce:	e314                	sd	a3,0(a4)
    54d0:	e71c                	sd	a5,8(a4)
    printf("continuous usertests starting\n");
    54d2:	00003517          	auipc	a0,0x3
    54d6:	b4e50513          	addi	a0,a0,-1202 # 8020 <malloc+0x247e>
    54da:	00000097          	auipc	ra,0x0
    54de:	60a080e7          	jalr	1546(ra) # 5ae4 <printf>
        printf("SOME TESTS FAILED\n");
    54e2:	00003a97          	auipc	s5,0x3
    54e6:	ac6a8a93          	addi	s5,s5,-1338 # 7fa8 <malloc+0x2406>
        if(continuous != 2)
    54ea:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    54ec:	00003b17          	auipc	s6,0x3
    54f0:	a9cb0b13          	addi	s6,s6,-1380 # 7f88 <malloc+0x23e6>
    54f4:	bfb5                	j	5470 <main+0x1b8>

00000000000054f6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    54f6:	1141                	addi	sp,sp,-16
    54f8:	e422                	sd	s0,8(sp)
    54fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    54fc:	87aa                	mv	a5,a0
    54fe:	0585                	addi	a1,a1,1
    5500:	0785                	addi	a5,a5,1
    5502:	fff5c703          	lbu	a4,-1(a1)
    5506:	fee78fa3          	sb	a4,-1(a5)
    550a:	fb75                	bnez	a4,54fe <strcpy+0x8>
    ;
  return os;
}
    550c:	6422                	ld	s0,8(sp)
    550e:	0141                	addi	sp,sp,16
    5510:	8082                	ret

0000000000005512 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5512:	1141                	addi	sp,sp,-16
    5514:	e422                	sd	s0,8(sp)
    5516:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5518:	00054783          	lbu	a5,0(a0)
    551c:	cb91                	beqz	a5,5530 <strcmp+0x1e>
    551e:	0005c703          	lbu	a4,0(a1)
    5522:	00f71763          	bne	a4,a5,5530 <strcmp+0x1e>
    p++, q++;
    5526:	0505                	addi	a0,a0,1
    5528:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    552a:	00054783          	lbu	a5,0(a0)
    552e:	fbe5                	bnez	a5,551e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5530:	0005c503          	lbu	a0,0(a1)
}
    5534:	40a7853b          	subw	a0,a5,a0
    5538:	6422                	ld	s0,8(sp)
    553a:	0141                	addi	sp,sp,16
    553c:	8082                	ret

000000000000553e <strlen>:

uint
strlen(const char *s)
{
    553e:	1141                	addi	sp,sp,-16
    5540:	e422                	sd	s0,8(sp)
    5542:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5544:	00054783          	lbu	a5,0(a0)
    5548:	cf91                	beqz	a5,5564 <strlen+0x26>
    554a:	0505                	addi	a0,a0,1
    554c:	87aa                	mv	a5,a0
    554e:	4685                	li	a3,1
    5550:	9e89                	subw	a3,a3,a0
    5552:	00f6853b          	addw	a0,a3,a5
    5556:	0785                	addi	a5,a5,1
    5558:	fff7c703          	lbu	a4,-1(a5)
    555c:	fb7d                	bnez	a4,5552 <strlen+0x14>
    ;
  return n;
}
    555e:	6422                	ld	s0,8(sp)
    5560:	0141                	addi	sp,sp,16
    5562:	8082                	ret
  for(n = 0; s[n]; n++)
    5564:	4501                	li	a0,0
    5566:	bfe5                	j	555e <strlen+0x20>

0000000000005568 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5568:	1141                	addi	sp,sp,-16
    556a:	e422                	sd	s0,8(sp)
    556c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    556e:	ca19                	beqz	a2,5584 <memset+0x1c>
    5570:	87aa                	mv	a5,a0
    5572:	1602                	slli	a2,a2,0x20
    5574:	9201                	srli	a2,a2,0x20
    5576:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    557a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    557e:	0785                	addi	a5,a5,1
    5580:	fee79de3          	bne	a5,a4,557a <memset+0x12>
  }
  return dst;
}
    5584:	6422                	ld	s0,8(sp)
    5586:	0141                	addi	sp,sp,16
    5588:	8082                	ret

000000000000558a <strchr>:

char*
strchr(const char *s, char c)
{
    558a:	1141                	addi	sp,sp,-16
    558c:	e422                	sd	s0,8(sp)
    558e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    5590:	00054783          	lbu	a5,0(a0)
    5594:	cb99                	beqz	a5,55aa <strchr+0x20>
    if(*s == c)
    5596:	00f58763          	beq	a1,a5,55a4 <strchr+0x1a>
  for(; *s; s++)
    559a:	0505                	addi	a0,a0,1
    559c:	00054783          	lbu	a5,0(a0)
    55a0:	fbfd                	bnez	a5,5596 <strchr+0xc>
      return (char*)s;
  return 0;
    55a2:	4501                	li	a0,0
}
    55a4:	6422                	ld	s0,8(sp)
    55a6:	0141                	addi	sp,sp,16
    55a8:	8082                	ret
  return 0;
    55aa:	4501                	li	a0,0
    55ac:	bfe5                	j	55a4 <strchr+0x1a>

00000000000055ae <gets>:

char*
gets(char *buf, int max)
{
    55ae:	711d                	addi	sp,sp,-96
    55b0:	ec86                	sd	ra,88(sp)
    55b2:	e8a2                	sd	s0,80(sp)
    55b4:	e4a6                	sd	s1,72(sp)
    55b6:	e0ca                	sd	s2,64(sp)
    55b8:	fc4e                	sd	s3,56(sp)
    55ba:	f852                	sd	s4,48(sp)
    55bc:	f456                	sd	s5,40(sp)
    55be:	f05a                	sd	s6,32(sp)
    55c0:	ec5e                	sd	s7,24(sp)
    55c2:	1080                	addi	s0,sp,96
    55c4:	8baa                	mv	s7,a0
    55c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    55c8:	892a                	mv	s2,a0
    55ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    55cc:	4aa9                	li	s5,10
    55ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    55d0:	89a6                	mv	s3,s1
    55d2:	2485                	addiw	s1,s1,1
    55d4:	0344d863          	bge	s1,s4,5604 <gets+0x56>
    cc = read(0, &c, 1);
    55d8:	4605                	li	a2,1
    55da:	faf40593          	addi	a1,s0,-81
    55de:	4501                	li	a0,0
    55e0:	00000097          	auipc	ra,0x0
    55e4:	19c080e7          	jalr	412(ra) # 577c <read>
    if(cc < 1)
    55e8:	00a05e63          	blez	a0,5604 <gets+0x56>
    buf[i++] = c;
    55ec:	faf44783          	lbu	a5,-81(s0)
    55f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    55f4:	01578763          	beq	a5,s5,5602 <gets+0x54>
    55f8:	0905                	addi	s2,s2,1
    55fa:	fd679be3          	bne	a5,s6,55d0 <gets+0x22>
  for(i=0; i+1 < max; ){
    55fe:	89a6                	mv	s3,s1
    5600:	a011                	j	5604 <gets+0x56>
    5602:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5604:	99de                	add	s3,s3,s7
    5606:	00098023          	sb	zero,0(s3)
  return buf;
}
    560a:	855e                	mv	a0,s7
    560c:	60e6                	ld	ra,88(sp)
    560e:	6446                	ld	s0,80(sp)
    5610:	64a6                	ld	s1,72(sp)
    5612:	6906                	ld	s2,64(sp)
    5614:	79e2                	ld	s3,56(sp)
    5616:	7a42                	ld	s4,48(sp)
    5618:	7aa2                	ld	s5,40(sp)
    561a:	7b02                	ld	s6,32(sp)
    561c:	6be2                	ld	s7,24(sp)
    561e:	6125                	addi	sp,sp,96
    5620:	8082                	ret

0000000000005622 <stat>:

int
stat(const char *n, struct stat *st)
{
    5622:	1101                	addi	sp,sp,-32
    5624:	ec06                	sd	ra,24(sp)
    5626:	e822                	sd	s0,16(sp)
    5628:	e426                	sd	s1,8(sp)
    562a:	e04a                	sd	s2,0(sp)
    562c:	1000                	addi	s0,sp,32
    562e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5630:	4581                	li	a1,0
    5632:	00000097          	auipc	ra,0x0
    5636:	172080e7          	jalr	370(ra) # 57a4 <open>
  if(fd < 0)
    563a:	02054563          	bltz	a0,5664 <stat+0x42>
    563e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5640:	85ca                	mv	a1,s2
    5642:	00000097          	auipc	ra,0x0
    5646:	17a080e7          	jalr	378(ra) # 57bc <fstat>
    564a:	892a                	mv	s2,a0
  close(fd);
    564c:	8526                	mv	a0,s1
    564e:	00000097          	auipc	ra,0x0
    5652:	13e080e7          	jalr	318(ra) # 578c <close>
  return r;
}
    5656:	854a                	mv	a0,s2
    5658:	60e2                	ld	ra,24(sp)
    565a:	6442                	ld	s0,16(sp)
    565c:	64a2                	ld	s1,8(sp)
    565e:	6902                	ld	s2,0(sp)
    5660:	6105                	addi	sp,sp,32
    5662:	8082                	ret
    return -1;
    5664:	597d                	li	s2,-1
    5666:	bfc5                	j	5656 <stat+0x34>

0000000000005668 <atoi>:

int
atoi(const char *s)
{
    5668:	1141                	addi	sp,sp,-16
    566a:	e422                	sd	s0,8(sp)
    566c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    566e:	00054603          	lbu	a2,0(a0)
    5672:	fd06079b          	addiw	a5,a2,-48
    5676:	0ff7f793          	andi	a5,a5,255
    567a:	4725                	li	a4,9
    567c:	02f76963          	bltu	a4,a5,56ae <atoi+0x46>
    5680:	86aa                	mv	a3,a0
  n = 0;
    5682:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5684:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5686:	0685                	addi	a3,a3,1
    5688:	0025179b          	slliw	a5,a0,0x2
    568c:	9fa9                	addw	a5,a5,a0
    568e:	0017979b          	slliw	a5,a5,0x1
    5692:	9fb1                	addw	a5,a5,a2
    5694:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5698:	0006c603          	lbu	a2,0(a3)
    569c:	fd06071b          	addiw	a4,a2,-48
    56a0:	0ff77713          	andi	a4,a4,255
    56a4:	fee5f1e3          	bgeu	a1,a4,5686 <atoi+0x1e>
  return n;
}
    56a8:	6422                	ld	s0,8(sp)
    56aa:	0141                	addi	sp,sp,16
    56ac:	8082                	ret
  n = 0;
    56ae:	4501                	li	a0,0
    56b0:	bfe5                	j	56a8 <atoi+0x40>

00000000000056b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    56b2:	1141                	addi	sp,sp,-16
    56b4:	e422                	sd	s0,8(sp)
    56b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    56b8:	02b57463          	bgeu	a0,a1,56e0 <memmove+0x2e>
    while(n-- > 0)
    56bc:	00c05f63          	blez	a2,56da <memmove+0x28>
    56c0:	1602                	slli	a2,a2,0x20
    56c2:	9201                	srli	a2,a2,0x20
    56c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    56c8:	872a                	mv	a4,a0
      *dst++ = *src++;
    56ca:	0585                	addi	a1,a1,1
    56cc:	0705                	addi	a4,a4,1
    56ce:	fff5c683          	lbu	a3,-1(a1)
    56d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    56d6:	fee79ae3          	bne	a5,a4,56ca <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    56da:	6422                	ld	s0,8(sp)
    56dc:	0141                	addi	sp,sp,16
    56de:	8082                	ret
    dst += n;
    56e0:	00c50733          	add	a4,a0,a2
    src += n;
    56e4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    56e6:	fec05ae3          	blez	a2,56da <memmove+0x28>
    56ea:	fff6079b          	addiw	a5,a2,-1
    56ee:	1782                	slli	a5,a5,0x20
    56f0:	9381                	srli	a5,a5,0x20
    56f2:	fff7c793          	not	a5,a5
    56f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    56f8:	15fd                	addi	a1,a1,-1
    56fa:	177d                	addi	a4,a4,-1
    56fc:	0005c683          	lbu	a3,0(a1)
    5700:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5704:	fee79ae3          	bne	a5,a4,56f8 <memmove+0x46>
    5708:	bfc9                	j	56da <memmove+0x28>

000000000000570a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    570a:	1141                	addi	sp,sp,-16
    570c:	e422                	sd	s0,8(sp)
    570e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5710:	ca05                	beqz	a2,5740 <memcmp+0x36>
    5712:	fff6069b          	addiw	a3,a2,-1
    5716:	1682                	slli	a3,a3,0x20
    5718:	9281                	srli	a3,a3,0x20
    571a:	0685                	addi	a3,a3,1
    571c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    571e:	00054783          	lbu	a5,0(a0)
    5722:	0005c703          	lbu	a4,0(a1)
    5726:	00e79863          	bne	a5,a4,5736 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    572a:	0505                	addi	a0,a0,1
    p2++;
    572c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    572e:	fed518e3          	bne	a0,a3,571e <memcmp+0x14>
  }
  return 0;
    5732:	4501                	li	a0,0
    5734:	a019                	j	573a <memcmp+0x30>
      return *p1 - *p2;
    5736:	40e7853b          	subw	a0,a5,a4
}
    573a:	6422                	ld	s0,8(sp)
    573c:	0141                	addi	sp,sp,16
    573e:	8082                	ret
  return 0;
    5740:	4501                	li	a0,0
    5742:	bfe5                	j	573a <memcmp+0x30>

0000000000005744 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5744:	1141                	addi	sp,sp,-16
    5746:	e406                	sd	ra,8(sp)
    5748:	e022                	sd	s0,0(sp)
    574a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    574c:	00000097          	auipc	ra,0x0
    5750:	f66080e7          	jalr	-154(ra) # 56b2 <memmove>
}
    5754:	60a2                	ld	ra,8(sp)
    5756:	6402                	ld	s0,0(sp)
    5758:	0141                	addi	sp,sp,16
    575a:	8082                	ret

000000000000575c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    575c:	4885                	li	a7,1
 ecall
    575e:	00000073          	ecall
 ret
    5762:	8082                	ret

0000000000005764 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5764:	4889                	li	a7,2
 ecall
    5766:	00000073          	ecall
 ret
    576a:	8082                	ret

000000000000576c <wait>:
.global wait
wait:
 li a7, SYS_wait
    576c:	488d                	li	a7,3
 ecall
    576e:	00000073          	ecall
 ret
    5772:	8082                	ret

0000000000005774 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5774:	4891                	li	a7,4
 ecall
    5776:	00000073          	ecall
 ret
    577a:	8082                	ret

000000000000577c <read>:
.global read
read:
 li a7, SYS_read
    577c:	4895                	li	a7,5
 ecall
    577e:	00000073          	ecall
 ret
    5782:	8082                	ret

0000000000005784 <write>:
.global write
write:
 li a7, SYS_write
    5784:	48c1                	li	a7,16
 ecall
    5786:	00000073          	ecall
 ret
    578a:	8082                	ret

000000000000578c <close>:
.global close
close:
 li a7, SYS_close
    578c:	48d5                	li	a7,21
 ecall
    578e:	00000073          	ecall
 ret
    5792:	8082                	ret

0000000000005794 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5794:	4899                	li	a7,6
 ecall
    5796:	00000073          	ecall
 ret
    579a:	8082                	ret

000000000000579c <exec>:
.global exec
exec:
 li a7, SYS_exec
    579c:	489d                	li	a7,7
 ecall
    579e:	00000073          	ecall
 ret
    57a2:	8082                	ret

00000000000057a4 <open>:
.global open
open:
 li a7, SYS_open
    57a4:	48bd                	li	a7,15
 ecall
    57a6:	00000073          	ecall
 ret
    57aa:	8082                	ret

00000000000057ac <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    57ac:	48c5                	li	a7,17
 ecall
    57ae:	00000073          	ecall
 ret
    57b2:	8082                	ret

00000000000057b4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    57b4:	48c9                	li	a7,18
 ecall
    57b6:	00000073          	ecall
 ret
    57ba:	8082                	ret

00000000000057bc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    57bc:	48a1                	li	a7,8
 ecall
    57be:	00000073          	ecall
 ret
    57c2:	8082                	ret

00000000000057c4 <link>:
.global link
link:
 li a7, SYS_link
    57c4:	48cd                	li	a7,19
 ecall
    57c6:	00000073          	ecall
 ret
    57ca:	8082                	ret

00000000000057cc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    57cc:	48d1                	li	a7,20
 ecall
    57ce:	00000073          	ecall
 ret
    57d2:	8082                	ret

00000000000057d4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    57d4:	48a5                	li	a7,9
 ecall
    57d6:	00000073          	ecall
 ret
    57da:	8082                	ret

00000000000057dc <dup>:
.global dup
dup:
 li a7, SYS_dup
    57dc:	48a9                	li	a7,10
 ecall
    57de:	00000073          	ecall
 ret
    57e2:	8082                	ret

00000000000057e4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    57e4:	48ad                	li	a7,11
 ecall
    57e6:	00000073          	ecall
 ret
    57ea:	8082                	ret

00000000000057ec <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    57ec:	48b1                	li	a7,12
 ecall
    57ee:	00000073          	ecall
 ret
    57f2:	8082                	ret

00000000000057f4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    57f4:	48b5                	li	a7,13
 ecall
    57f6:	00000073          	ecall
 ret
    57fa:	8082                	ret

00000000000057fc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    57fc:	48b9                	li	a7,14
 ecall
    57fe:	00000073          	ecall
 ret
    5802:	8082                	ret

0000000000005804 <trace>:
.global trace
trace:
 li a7, SYS_trace
    5804:	48d9                	li	a7,22
 ecall
    5806:	00000073          	ecall
 ret
    580a:	8082                	ret

000000000000580c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    580c:	1101                	addi	sp,sp,-32
    580e:	ec06                	sd	ra,24(sp)
    5810:	e822                	sd	s0,16(sp)
    5812:	1000                	addi	s0,sp,32
    5814:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5818:	4605                	li	a2,1
    581a:	fef40593          	addi	a1,s0,-17
    581e:	00000097          	auipc	ra,0x0
    5822:	f66080e7          	jalr	-154(ra) # 5784 <write>
}
    5826:	60e2                	ld	ra,24(sp)
    5828:	6442                	ld	s0,16(sp)
    582a:	6105                	addi	sp,sp,32
    582c:	8082                	ret

000000000000582e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    582e:	7139                	addi	sp,sp,-64
    5830:	fc06                	sd	ra,56(sp)
    5832:	f822                	sd	s0,48(sp)
    5834:	f426                	sd	s1,40(sp)
    5836:	f04a                	sd	s2,32(sp)
    5838:	ec4e                	sd	s3,24(sp)
    583a:	0080                	addi	s0,sp,64
    583c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    583e:	c299                	beqz	a3,5844 <printint+0x16>
    5840:	0805c863          	bltz	a1,58d0 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5844:	2581                	sext.w	a1,a1
  neg = 0;
    5846:	4881                	li	a7,0
    5848:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    584c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    584e:	2601                	sext.w	a2,a2
    5850:	00003517          	auipc	a0,0x3
    5854:	bf050513          	addi	a0,a0,-1040 # 8440 <digits>
    5858:	883a                	mv	a6,a4
    585a:	2705                	addiw	a4,a4,1
    585c:	02c5f7bb          	remuw	a5,a1,a2
    5860:	1782                	slli	a5,a5,0x20
    5862:	9381                	srli	a5,a5,0x20
    5864:	97aa                	add	a5,a5,a0
    5866:	0007c783          	lbu	a5,0(a5)
    586a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    586e:	0005879b          	sext.w	a5,a1
    5872:	02c5d5bb          	divuw	a1,a1,a2
    5876:	0685                	addi	a3,a3,1
    5878:	fec7f0e3          	bgeu	a5,a2,5858 <printint+0x2a>
  if(neg)
    587c:	00088b63          	beqz	a7,5892 <printint+0x64>
    buf[i++] = '-';
    5880:	fd040793          	addi	a5,s0,-48
    5884:	973e                	add	a4,a4,a5
    5886:	02d00793          	li	a5,45
    588a:	fef70823          	sb	a5,-16(a4)
    588e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5892:	02e05863          	blez	a4,58c2 <printint+0x94>
    5896:	fc040793          	addi	a5,s0,-64
    589a:	00e78933          	add	s2,a5,a4
    589e:	fff78993          	addi	s3,a5,-1
    58a2:	99ba                	add	s3,s3,a4
    58a4:	377d                	addiw	a4,a4,-1
    58a6:	1702                	slli	a4,a4,0x20
    58a8:	9301                	srli	a4,a4,0x20
    58aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    58ae:	fff94583          	lbu	a1,-1(s2)
    58b2:	8526                	mv	a0,s1
    58b4:	00000097          	auipc	ra,0x0
    58b8:	f58080e7          	jalr	-168(ra) # 580c <putc>
  while(--i >= 0)
    58bc:	197d                	addi	s2,s2,-1
    58be:	ff3918e3          	bne	s2,s3,58ae <printint+0x80>
}
    58c2:	70e2                	ld	ra,56(sp)
    58c4:	7442                	ld	s0,48(sp)
    58c6:	74a2                	ld	s1,40(sp)
    58c8:	7902                	ld	s2,32(sp)
    58ca:	69e2                	ld	s3,24(sp)
    58cc:	6121                	addi	sp,sp,64
    58ce:	8082                	ret
    x = -xx;
    58d0:	40b005bb          	negw	a1,a1
    neg = 1;
    58d4:	4885                	li	a7,1
    x = -xx;
    58d6:	bf8d                	j	5848 <printint+0x1a>

00000000000058d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    58d8:	7119                	addi	sp,sp,-128
    58da:	fc86                	sd	ra,120(sp)
    58dc:	f8a2                	sd	s0,112(sp)
    58de:	f4a6                	sd	s1,104(sp)
    58e0:	f0ca                	sd	s2,96(sp)
    58e2:	ecce                	sd	s3,88(sp)
    58e4:	e8d2                	sd	s4,80(sp)
    58e6:	e4d6                	sd	s5,72(sp)
    58e8:	e0da                	sd	s6,64(sp)
    58ea:	fc5e                	sd	s7,56(sp)
    58ec:	f862                	sd	s8,48(sp)
    58ee:	f466                	sd	s9,40(sp)
    58f0:	f06a                	sd	s10,32(sp)
    58f2:	ec6e                	sd	s11,24(sp)
    58f4:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    58f6:	0005c903          	lbu	s2,0(a1)
    58fa:	18090f63          	beqz	s2,5a98 <vprintf+0x1c0>
    58fe:	8aaa                	mv	s5,a0
    5900:	8b32                	mv	s6,a2
    5902:	00158493          	addi	s1,a1,1
  state = 0;
    5906:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5908:	02500a13          	li	s4,37
      if(c == 'd'){
    590c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5910:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5914:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5918:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    591c:	00003b97          	auipc	s7,0x3
    5920:	b24b8b93          	addi	s7,s7,-1244 # 8440 <digits>
    5924:	a839                	j	5942 <vprintf+0x6a>
        putc(fd, c);
    5926:	85ca                	mv	a1,s2
    5928:	8556                	mv	a0,s5
    592a:	00000097          	auipc	ra,0x0
    592e:	ee2080e7          	jalr	-286(ra) # 580c <putc>
    5932:	a019                	j	5938 <vprintf+0x60>
    } else if(state == '%'){
    5934:	01498f63          	beq	s3,s4,5952 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5938:	0485                	addi	s1,s1,1
    593a:	fff4c903          	lbu	s2,-1(s1)
    593e:	14090d63          	beqz	s2,5a98 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5942:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5946:	fe0997e3          	bnez	s3,5934 <vprintf+0x5c>
      if(c == '%'){
    594a:	fd479ee3          	bne	a5,s4,5926 <vprintf+0x4e>
        state = '%';
    594e:	89be                	mv	s3,a5
    5950:	b7e5                	j	5938 <vprintf+0x60>
      if(c == 'd'){
    5952:	05878063          	beq	a5,s8,5992 <vprintf+0xba>
      } else if(c == 'l') {
    5956:	05978c63          	beq	a5,s9,59ae <vprintf+0xd6>
      } else if(c == 'x') {
    595a:	07a78863          	beq	a5,s10,59ca <vprintf+0xf2>
      } else if(c == 'p') {
    595e:	09b78463          	beq	a5,s11,59e6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5962:	07300713          	li	a4,115
    5966:	0ce78663          	beq	a5,a4,5a32 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    596a:	06300713          	li	a4,99
    596e:	0ee78e63          	beq	a5,a4,5a6a <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5972:	11478863          	beq	a5,s4,5a82 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5976:	85d2                	mv	a1,s4
    5978:	8556                	mv	a0,s5
    597a:	00000097          	auipc	ra,0x0
    597e:	e92080e7          	jalr	-366(ra) # 580c <putc>
        putc(fd, c);
    5982:	85ca                	mv	a1,s2
    5984:	8556                	mv	a0,s5
    5986:	00000097          	auipc	ra,0x0
    598a:	e86080e7          	jalr	-378(ra) # 580c <putc>
      }
      state = 0;
    598e:	4981                	li	s3,0
    5990:	b765                	j	5938 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5992:	008b0913          	addi	s2,s6,8
    5996:	4685                	li	a3,1
    5998:	4629                	li	a2,10
    599a:	000b2583          	lw	a1,0(s6)
    599e:	8556                	mv	a0,s5
    59a0:	00000097          	auipc	ra,0x0
    59a4:	e8e080e7          	jalr	-370(ra) # 582e <printint>
    59a8:	8b4a                	mv	s6,s2
      state = 0;
    59aa:	4981                	li	s3,0
    59ac:	b771                	j	5938 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    59ae:	008b0913          	addi	s2,s6,8
    59b2:	4681                	li	a3,0
    59b4:	4629                	li	a2,10
    59b6:	000b2583          	lw	a1,0(s6)
    59ba:	8556                	mv	a0,s5
    59bc:	00000097          	auipc	ra,0x0
    59c0:	e72080e7          	jalr	-398(ra) # 582e <printint>
    59c4:	8b4a                	mv	s6,s2
      state = 0;
    59c6:	4981                	li	s3,0
    59c8:	bf85                	j	5938 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    59ca:	008b0913          	addi	s2,s6,8
    59ce:	4681                	li	a3,0
    59d0:	4641                	li	a2,16
    59d2:	000b2583          	lw	a1,0(s6)
    59d6:	8556                	mv	a0,s5
    59d8:	00000097          	auipc	ra,0x0
    59dc:	e56080e7          	jalr	-426(ra) # 582e <printint>
    59e0:	8b4a                	mv	s6,s2
      state = 0;
    59e2:	4981                	li	s3,0
    59e4:	bf91                	j	5938 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    59e6:	008b0793          	addi	a5,s6,8
    59ea:	f8f43423          	sd	a5,-120(s0)
    59ee:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    59f2:	03000593          	li	a1,48
    59f6:	8556                	mv	a0,s5
    59f8:	00000097          	auipc	ra,0x0
    59fc:	e14080e7          	jalr	-492(ra) # 580c <putc>
  putc(fd, 'x');
    5a00:	85ea                	mv	a1,s10
    5a02:	8556                	mv	a0,s5
    5a04:	00000097          	auipc	ra,0x0
    5a08:	e08080e7          	jalr	-504(ra) # 580c <putc>
    5a0c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5a0e:	03c9d793          	srli	a5,s3,0x3c
    5a12:	97de                	add	a5,a5,s7
    5a14:	0007c583          	lbu	a1,0(a5)
    5a18:	8556                	mv	a0,s5
    5a1a:	00000097          	auipc	ra,0x0
    5a1e:	df2080e7          	jalr	-526(ra) # 580c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5a22:	0992                	slli	s3,s3,0x4
    5a24:	397d                	addiw	s2,s2,-1
    5a26:	fe0914e3          	bnez	s2,5a0e <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5a2a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5a2e:	4981                	li	s3,0
    5a30:	b721                	j	5938 <vprintf+0x60>
        s = va_arg(ap, char*);
    5a32:	008b0993          	addi	s3,s6,8
    5a36:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5a3a:	02090163          	beqz	s2,5a5c <vprintf+0x184>
        while(*s != 0){
    5a3e:	00094583          	lbu	a1,0(s2)
    5a42:	c9a1                	beqz	a1,5a92 <vprintf+0x1ba>
          putc(fd, *s);
    5a44:	8556                	mv	a0,s5
    5a46:	00000097          	auipc	ra,0x0
    5a4a:	dc6080e7          	jalr	-570(ra) # 580c <putc>
          s++;
    5a4e:	0905                	addi	s2,s2,1
        while(*s != 0){
    5a50:	00094583          	lbu	a1,0(s2)
    5a54:	f9e5                	bnez	a1,5a44 <vprintf+0x16c>
        s = va_arg(ap, char*);
    5a56:	8b4e                	mv	s6,s3
      state = 0;
    5a58:	4981                	li	s3,0
    5a5a:	bdf9                	j	5938 <vprintf+0x60>
          s = "(null)";
    5a5c:	00003917          	auipc	s2,0x3
    5a60:	9dc90913          	addi	s2,s2,-1572 # 8438 <malloc+0x2896>
        while(*s != 0){
    5a64:	02800593          	li	a1,40
    5a68:	bff1                	j	5a44 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5a6a:	008b0913          	addi	s2,s6,8
    5a6e:	000b4583          	lbu	a1,0(s6)
    5a72:	8556                	mv	a0,s5
    5a74:	00000097          	auipc	ra,0x0
    5a78:	d98080e7          	jalr	-616(ra) # 580c <putc>
    5a7c:	8b4a                	mv	s6,s2
      state = 0;
    5a7e:	4981                	li	s3,0
    5a80:	bd65                	j	5938 <vprintf+0x60>
        putc(fd, c);
    5a82:	85d2                	mv	a1,s4
    5a84:	8556                	mv	a0,s5
    5a86:	00000097          	auipc	ra,0x0
    5a8a:	d86080e7          	jalr	-634(ra) # 580c <putc>
      state = 0;
    5a8e:	4981                	li	s3,0
    5a90:	b565                	j	5938 <vprintf+0x60>
        s = va_arg(ap, char*);
    5a92:	8b4e                	mv	s6,s3
      state = 0;
    5a94:	4981                	li	s3,0
    5a96:	b54d                	j	5938 <vprintf+0x60>
    }
  }
}
    5a98:	70e6                	ld	ra,120(sp)
    5a9a:	7446                	ld	s0,112(sp)
    5a9c:	74a6                	ld	s1,104(sp)
    5a9e:	7906                	ld	s2,96(sp)
    5aa0:	69e6                	ld	s3,88(sp)
    5aa2:	6a46                	ld	s4,80(sp)
    5aa4:	6aa6                	ld	s5,72(sp)
    5aa6:	6b06                	ld	s6,64(sp)
    5aa8:	7be2                	ld	s7,56(sp)
    5aaa:	7c42                	ld	s8,48(sp)
    5aac:	7ca2                	ld	s9,40(sp)
    5aae:	7d02                	ld	s10,32(sp)
    5ab0:	6de2                	ld	s11,24(sp)
    5ab2:	6109                	addi	sp,sp,128
    5ab4:	8082                	ret

0000000000005ab6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5ab6:	715d                	addi	sp,sp,-80
    5ab8:	ec06                	sd	ra,24(sp)
    5aba:	e822                	sd	s0,16(sp)
    5abc:	1000                	addi	s0,sp,32
    5abe:	e010                	sd	a2,0(s0)
    5ac0:	e414                	sd	a3,8(s0)
    5ac2:	e818                	sd	a4,16(s0)
    5ac4:	ec1c                	sd	a5,24(s0)
    5ac6:	03043023          	sd	a6,32(s0)
    5aca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5ace:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5ad2:	8622                	mv	a2,s0
    5ad4:	00000097          	auipc	ra,0x0
    5ad8:	e04080e7          	jalr	-508(ra) # 58d8 <vprintf>
}
    5adc:	60e2                	ld	ra,24(sp)
    5ade:	6442                	ld	s0,16(sp)
    5ae0:	6161                	addi	sp,sp,80
    5ae2:	8082                	ret

0000000000005ae4 <printf>:

void
printf(const char *fmt, ...)
{
    5ae4:	711d                	addi	sp,sp,-96
    5ae6:	ec06                	sd	ra,24(sp)
    5ae8:	e822                	sd	s0,16(sp)
    5aea:	1000                	addi	s0,sp,32
    5aec:	e40c                	sd	a1,8(s0)
    5aee:	e810                	sd	a2,16(s0)
    5af0:	ec14                	sd	a3,24(s0)
    5af2:	f018                	sd	a4,32(s0)
    5af4:	f41c                	sd	a5,40(s0)
    5af6:	03043823          	sd	a6,48(s0)
    5afa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5afe:	00840613          	addi	a2,s0,8
    5b02:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5b06:	85aa                	mv	a1,a0
    5b08:	4505                	li	a0,1
    5b0a:	00000097          	auipc	ra,0x0
    5b0e:	dce080e7          	jalr	-562(ra) # 58d8 <vprintf>
}
    5b12:	60e2                	ld	ra,24(sp)
    5b14:	6442                	ld	s0,16(sp)
    5b16:	6125                	addi	sp,sp,96
    5b18:	8082                	ret

0000000000005b1a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5b1a:	1141                	addi	sp,sp,-16
    5b1c:	e422                	sd	s0,8(sp)
    5b1e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5b20:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b24:	00003797          	auipc	a5,0x3
    5b28:	9447b783          	ld	a5,-1724(a5) # 8468 <freep>
    5b2c:	a805                	j	5b5c <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5b2e:	4618                	lw	a4,8(a2)
    5b30:	9db9                	addw	a1,a1,a4
    5b32:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5b36:	6398                	ld	a4,0(a5)
    5b38:	6318                	ld	a4,0(a4)
    5b3a:	fee53823          	sd	a4,-16(a0)
    5b3e:	a091                	j	5b82 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5b40:	ff852703          	lw	a4,-8(a0)
    5b44:	9e39                	addw	a2,a2,a4
    5b46:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5b48:	ff053703          	ld	a4,-16(a0)
    5b4c:	e398                	sd	a4,0(a5)
    5b4e:	a099                	j	5b94 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b50:	6398                	ld	a4,0(a5)
    5b52:	00e7e463          	bltu	a5,a4,5b5a <free+0x40>
    5b56:	00e6ea63          	bltu	a3,a4,5b6a <free+0x50>
{
    5b5a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5b5c:	fed7fae3          	bgeu	a5,a3,5b50 <free+0x36>
    5b60:	6398                	ld	a4,0(a5)
    5b62:	00e6e463          	bltu	a3,a4,5b6a <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5b66:	fee7eae3          	bltu	a5,a4,5b5a <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5b6a:	ff852583          	lw	a1,-8(a0)
    5b6e:	6390                	ld	a2,0(a5)
    5b70:	02059813          	slli	a6,a1,0x20
    5b74:	01c85713          	srli	a4,a6,0x1c
    5b78:	9736                	add	a4,a4,a3
    5b7a:	fae60ae3          	beq	a2,a4,5b2e <free+0x14>
    bp->s.ptr = p->s.ptr;
    5b7e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5b82:	4790                	lw	a2,8(a5)
    5b84:	02061593          	slli	a1,a2,0x20
    5b88:	01c5d713          	srli	a4,a1,0x1c
    5b8c:	973e                	add	a4,a4,a5
    5b8e:	fae689e3          	beq	a3,a4,5b40 <free+0x26>
  } else
    p->s.ptr = bp;
    5b92:	e394                	sd	a3,0(a5)
  freep = p;
    5b94:	00003717          	auipc	a4,0x3
    5b98:	8cf73a23          	sd	a5,-1836(a4) # 8468 <freep>
}
    5b9c:	6422                	ld	s0,8(sp)
    5b9e:	0141                	addi	sp,sp,16
    5ba0:	8082                	ret

0000000000005ba2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5ba2:	7139                	addi	sp,sp,-64
    5ba4:	fc06                	sd	ra,56(sp)
    5ba6:	f822                	sd	s0,48(sp)
    5ba8:	f426                	sd	s1,40(sp)
    5baa:	f04a                	sd	s2,32(sp)
    5bac:	ec4e                	sd	s3,24(sp)
    5bae:	e852                	sd	s4,16(sp)
    5bb0:	e456                	sd	s5,8(sp)
    5bb2:	e05a                	sd	s6,0(sp)
    5bb4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5bb6:	02051493          	slli	s1,a0,0x20
    5bba:	9081                	srli	s1,s1,0x20
    5bbc:	04bd                	addi	s1,s1,15
    5bbe:	8091                	srli	s1,s1,0x4
    5bc0:	0014899b          	addiw	s3,s1,1
    5bc4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5bc6:	00003517          	auipc	a0,0x3
    5bca:	8a253503          	ld	a0,-1886(a0) # 8468 <freep>
    5bce:	c515                	beqz	a0,5bfa <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5bd0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5bd2:	4798                	lw	a4,8(a5)
    5bd4:	02977f63          	bgeu	a4,s1,5c12 <malloc+0x70>
    5bd8:	8a4e                	mv	s4,s3
    5bda:	0009871b          	sext.w	a4,s3
    5bde:	6685                	lui	a3,0x1
    5be0:	00d77363          	bgeu	a4,a3,5be6 <malloc+0x44>
    5be4:	6a05                	lui	s4,0x1
    5be6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5bea:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5bee:	00003917          	auipc	s2,0x3
    5bf2:	87a90913          	addi	s2,s2,-1926 # 8468 <freep>
  if(p == (char*)-1)
    5bf6:	5afd                	li	s5,-1
    5bf8:	a895                	j	5c6c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    5bfa:	00009797          	auipc	a5,0x9
    5bfe:	08e78793          	addi	a5,a5,142 # ec88 <base>
    5c02:	00003717          	auipc	a4,0x3
    5c06:	86f73323          	sd	a5,-1946(a4) # 8468 <freep>
    5c0a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5c0c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5c10:	b7e1                	j	5bd8 <malloc+0x36>
      if(p->s.size == nunits)
    5c12:	02e48c63          	beq	s1,a4,5c4a <malloc+0xa8>
        p->s.size -= nunits;
    5c16:	4137073b          	subw	a4,a4,s3
    5c1a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5c1c:	02071693          	slli	a3,a4,0x20
    5c20:	01c6d713          	srli	a4,a3,0x1c
    5c24:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5c26:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5c2a:	00003717          	auipc	a4,0x3
    5c2e:	82a73f23          	sd	a0,-1986(a4) # 8468 <freep>
      return (void*)(p + 1);
    5c32:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    5c36:	70e2                	ld	ra,56(sp)
    5c38:	7442                	ld	s0,48(sp)
    5c3a:	74a2                	ld	s1,40(sp)
    5c3c:	7902                	ld	s2,32(sp)
    5c3e:	69e2                	ld	s3,24(sp)
    5c40:	6a42                	ld	s4,16(sp)
    5c42:	6aa2                	ld	s5,8(sp)
    5c44:	6b02                	ld	s6,0(sp)
    5c46:	6121                	addi	sp,sp,64
    5c48:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5c4a:	6398                	ld	a4,0(a5)
    5c4c:	e118                	sd	a4,0(a0)
    5c4e:	bff1                	j	5c2a <malloc+0x88>
  hp->s.size = nu;
    5c50:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5c54:	0541                	addi	a0,a0,16
    5c56:	00000097          	auipc	ra,0x0
    5c5a:	ec4080e7          	jalr	-316(ra) # 5b1a <free>
  return freep;
    5c5e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5c62:	d971                	beqz	a0,5c36 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5c64:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5c66:	4798                	lw	a4,8(a5)
    5c68:	fa9775e3          	bgeu	a4,s1,5c12 <malloc+0x70>
    if(p == freep)
    5c6c:	00093703          	ld	a4,0(s2)
    5c70:	853e                	mv	a0,a5
    5c72:	fef719e3          	bne	a4,a5,5c64 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    5c76:	8552                	mv	a0,s4
    5c78:	00000097          	auipc	ra,0x0
    5c7c:	b74080e7          	jalr	-1164(ra) # 57ec <sbrk>
  if(p == (char*)-1)
    5c80:	fd5518e3          	bne	a0,s5,5c50 <malloc+0xae>
        return 0;
    5c84:	4501                	li	a0,0
    5c86:	bf45                	j	5c36 <malloc+0x94>
