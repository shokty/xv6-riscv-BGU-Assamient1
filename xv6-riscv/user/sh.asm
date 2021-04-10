
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  fprintf(2, "$ ");
      10:	00001597          	auipc	a1,0x1
      14:	39858593          	addi	a1,a1,920 # 13a8 <malloc+0xe8>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	1ba080e7          	jalr	442(ra) # 11d4 <fprintf>
  memset(buf, 0, nbuf);
      22:	864a                	mv	a2,s2
      24:	4581                	li	a1,0
      26:	8526                	mv	a0,s1
      28:	00001097          	auipc	ra,0x1
      2c:	c5e080e7          	jalr	-930(ra) # c86 <memset>
  gets(buf, nbuf);
      30:	85ca                	mv	a1,s2
      32:	8526                	mv	a0,s1
      34:	00001097          	auipc	ra,0x1
      38:	c98080e7          	jalr	-872(ra) # ccc <gets>
  if(buf[0] == 0) // EOF
      3c:	0004c503          	lbu	a0,0(s1)
      40:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      44:	40a00533          	neg	a0,a0
      48:	60e2                	ld	ra,24(sp)
      4a:	6442                	ld	s0,16(sp)
      4c:	64a2                	ld	s1,8(sp)
      4e:	6902                	ld	s2,0(sp)
      50:	6105                	addi	sp,sp,32
      52:	8082                	ret

0000000000000054 <panic>:
  exit(0);
}

void
panic(char *s)
{
      54:	1141                	addi	sp,sp,-16
      56:	e406                	sd	ra,8(sp)
      58:	e022                	sd	s0,0(sp)
      5a:	0800                	addi	s0,sp,16
      5c:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      5e:	00001597          	auipc	a1,0x1
      62:	35258593          	addi	a1,a1,850 # 13b0 <malloc+0xf0>
      66:	4509                	li	a0,2
      68:	00001097          	auipc	ra,0x1
      6c:	16c080e7          	jalr	364(ra) # 11d4 <fprintf>
  exit(1);
      70:	4505                	li	a0,1
      72:	00001097          	auipc	ra,0x1
      76:	e10080e7          	jalr	-496(ra) # e82 <exit>

000000000000007a <fork1>:
}

int
fork1(void)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      82:	00001097          	auipc	ra,0x1
      86:	df8080e7          	jalr	-520(ra) # e7a <fork>
  if(pid == -1)
      8a:	57fd                	li	a5,-1
      8c:	00f50663          	beq	a0,a5,98 <fork1+0x1e>
    panic("fork");
  return pid;
}
      90:	60a2                	ld	ra,8(sp)
      92:	6402                	ld	s0,0(sp)
      94:	0141                	addi	sp,sp,16
      96:	8082                	ret
    panic("fork");
      98:	00001517          	auipc	a0,0x1
      9c:	32050513          	addi	a0,a0,800 # 13b8 <malloc+0xf8>
      a0:	00000097          	auipc	ra,0x0
      a4:	fb4080e7          	jalr	-76(ra) # 54 <panic>

00000000000000a8 <runcmd>:
{
      a8:	bb010113          	addi	sp,sp,-1104
      ac:	44113423          	sd	ra,1096(sp)
      b0:	44813023          	sd	s0,1088(sp)
      b4:	42913c23          	sd	s1,1080(sp)
      b8:	43213823          	sd	s2,1072(sp)
      bc:	43313423          	sd	s3,1064(sp)
      c0:	43413023          	sd	s4,1056(sp)
      c4:	41513c23          	sd	s5,1048(sp)
      c8:	41613823          	sd	s6,1040(sp)
      cc:	45010413          	addi	s0,sp,1104
  if(cmd == 0)
      d0:	c10d                	beqz	a0,f2 <runcmd+0x4a>
      d2:	84aa                	mv	s1,a0
  switch(cmd->type){
      d4:	4118                	lw	a4,0(a0)
      d6:	4795                	li	a5,5
      d8:	02e7e263          	bltu	a5,a4,fc <runcmd+0x54>
      dc:	00056783          	lwu	a5,0(a0)
      e0:	078a                	slli	a5,a5,0x2
      e2:	00001717          	auipc	a4,0x1
      e6:	3de70713          	addi	a4,a4,990 # 14c0 <malloc+0x200>
      ea:	97ba                	add	a5,a5,a4
      ec:	439c                	lw	a5,0(a5)
      ee:	97ba                	add	a5,a5,a4
      f0:	8782                	jr	a5
    exit(1);
      f2:	4505                	li	a0,1
      f4:	00001097          	auipc	ra,0x1
      f8:	d8e080e7          	jalr	-626(ra) # e82 <exit>
    panic("runcmd");
      fc:	00001517          	auipc	a0,0x1
     100:	2c450513          	addi	a0,a0,708 # 13c0 <malloc+0x100>
     104:	00000097          	auipc	ra,0x0
     108:	f50080e7          	jalr	-176(ra) # 54 <panic>
    if(ecmd->argv[0] == 0)
     10c:	6508                	ld	a0,8(a0)
     10e:	cd1d                	beqz	a0,14c <runcmd+0xa4>
    exec(ecmd->argv[0], ecmd->argv);
     110:	00848a93          	addi	s5,s1,8
     114:	85d6                	mv	a1,s5
     116:	00001097          	auipc	ra,0x1
     11a:	da4080e7          	jalr	-604(ra) # eba <exec>
    int path_file = open("/path", O_RDONLY | O_CREATE);
     11e:	20000593          	li	a1,512
     122:	00001517          	auipc	a0,0x1
     126:	2a650513          	addi	a0,a0,678 # 13c8 <malloc+0x108>
     12a:	00001097          	auipc	ra,0x1
     12e:	d98080e7          	jalr	-616(ra) # ec2 <open>
     132:	89aa                	mv	s3,a0
    if (ecmd->argv[0][0] != '/') {
     134:	649c                	ld	a5,8(s1)
     136:	0007c703          	lbu	a4,0(a5)
     13a:	02f00793          	li	a5,47
    int path_index = 0;
     13e:	4901                	li	s2,0
    if (ecmd->argv[0][0] != '/') {
     140:	06f70f63          	beq	a4,a5,1be <runcmd+0x116>
        if (ch[0] != ':'){
     144:	03a00a13          	li	s4,58
          path_index = 0;
     148:	4b01                	li	s6,0
     14a:	a0a9                	j	194 <runcmd+0xec>
      exit(1);
     14c:	4505                	li	a0,1
     14e:	00001097          	auipc	ra,0x1
     152:	d34080e7          	jalr	-716(ra) # e82 <exit>
          while (ecmd->argv[0][commend_index] > 0) // copying the commend Line
     156:	6498                	ld	a4,8(s1)
     158:	00074683          	lbu	a3,0(a4)
     15c:	87ca                	mv	a5,s2
     15e:	0705                	addi	a4,a4,1
     160:	ce89                	beqz	a3,17a <runcmd+0xd2>
            curr_path[path_index] = ecmd->argv[0][commend_index];
     162:	bb840613          	addi	a2,s0,-1096
     166:	963e                	add	a2,a2,a5
     168:	00d60023          	sb	a3,0(a2)
            path_index++;
     16c:	0017891b          	addiw	s2,a5,1
          while (ecmd->argv[0][commend_index] > 0) // copying the commend Line
     170:	00074683          	lbu	a3,0(a4)
     174:	0785                	addi	a5,a5,1
     176:	0705                	addi	a4,a4,1
     178:	f6ed                	bnez	a3,162 <runcmd+0xba>
          curr_path[path_index] = 0;
     17a:	fc040793          	addi	a5,s0,-64
     17e:	993e                	add	s2,s2,a5
     180:	be090c23          	sb	zero,-1032(s2)
          exec(curr_path, ecmd->argv);
     184:	85d6                	mv	a1,s5
     186:	bb840513          	addi	a0,s0,-1096
     18a:	00001097          	auipc	ra,0x1
     18e:	d30080e7          	jalr	-720(ra) # eba <exec>
          path_index = 0;
     192:	895a                	mv	s2,s6
      while (read(path_file, ch, 1) > 0){
     194:	4605                	li	a2,1
     196:	bb040593          	addi	a1,s0,-1104
     19a:	854e                	mv	a0,s3
     19c:	00001097          	auipc	ra,0x1
     1a0:	cfe080e7          	jalr	-770(ra) # e9a <read>
     1a4:	00a05d63          	blez	a0,1be <runcmd+0x116>
        if (ch[0] != ':'){
     1a8:	bb044783          	lbu	a5,-1104(s0)
     1ac:	fb4785e3          	beq	a5,s4,156 <runcmd+0xae>
          curr_path[path_index] = ch[0];
     1b0:	fc040713          	addi	a4,s0,-64
     1b4:	974a                	add	a4,a4,s2
     1b6:	bef70c23          	sb	a5,-1032(a4)
          path_index ++;
     1ba:	2905                	addiw	s2,s2,1
     1bc:	bfe1                	j	194 <runcmd+0xec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     1be:	6490                	ld	a2,8(s1)
     1c0:	00001597          	auipc	a1,0x1
     1c4:	21058593          	addi	a1,a1,528 # 13d0 <malloc+0x110>
     1c8:	4509                	li	a0,2
     1ca:	00001097          	auipc	ra,0x1
     1ce:	00a080e7          	jalr	10(ra) # 11d4 <fprintf>
    close(path_file);
     1d2:	854e                	mv	a0,s3
     1d4:	00001097          	auipc	ra,0x1
     1d8:	cd6080e7          	jalr	-810(ra) # eaa <close>
  exit(0);
     1dc:	4501                	li	a0,0
     1de:	00001097          	auipc	ra,0x1
     1e2:	ca4080e7          	jalr	-860(ra) # e82 <exit>
    close(rcmd->fd);
     1e6:	5148                	lw	a0,36(a0)
     1e8:	00001097          	auipc	ra,0x1
     1ec:	cc2080e7          	jalr	-830(ra) # eaa <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     1f0:	508c                	lw	a1,32(s1)
     1f2:	6888                	ld	a0,16(s1)
     1f4:	00001097          	auipc	ra,0x1
     1f8:	cce080e7          	jalr	-818(ra) # ec2 <open>
     1fc:	00054763          	bltz	a0,20a <runcmd+0x162>
    runcmd(rcmd->cmd);
     200:	6488                	ld	a0,8(s1)
     202:	00000097          	auipc	ra,0x0
     206:	ea6080e7          	jalr	-346(ra) # a8 <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     20a:	6890                	ld	a2,16(s1)
     20c:	00001597          	auipc	a1,0x1
     210:	1d458593          	addi	a1,a1,468 # 13e0 <malloc+0x120>
     214:	4509                	li	a0,2
     216:	00001097          	auipc	ra,0x1
     21a:	fbe080e7          	jalr	-66(ra) # 11d4 <fprintf>
      exit(1);
     21e:	4505                	li	a0,1
     220:	00001097          	auipc	ra,0x1
     224:	c62080e7          	jalr	-926(ra) # e82 <exit>
    if(fork1() == 0)
     228:	00000097          	auipc	ra,0x0
     22c:	e52080e7          	jalr	-430(ra) # 7a <fork1>
     230:	c919                	beqz	a0,246 <runcmd+0x19e>
    wait(0);
     232:	4501                	li	a0,0
     234:	00001097          	auipc	ra,0x1
     238:	c56080e7          	jalr	-938(ra) # e8a <wait>
    runcmd(lcmd->right);
     23c:	6888                	ld	a0,16(s1)
     23e:	00000097          	auipc	ra,0x0
     242:	e6a080e7          	jalr	-406(ra) # a8 <runcmd>
      runcmd(lcmd->left);
     246:	6488                	ld	a0,8(s1)
     248:	00000097          	auipc	ra,0x0
     24c:	e60080e7          	jalr	-416(ra) # a8 <runcmd>
    if(pipe(p) < 0)
     250:	fb840513          	addi	a0,s0,-72
     254:	00001097          	auipc	ra,0x1
     258:	c3e080e7          	jalr	-962(ra) # e92 <pipe>
     25c:	04054363          	bltz	a0,2a2 <runcmd+0x1fa>
    if(fork1() == 0){
     260:	00000097          	auipc	ra,0x0
     264:	e1a080e7          	jalr	-486(ra) # 7a <fork1>
     268:	c529                	beqz	a0,2b2 <runcmd+0x20a>
    if(fork1() == 0){
     26a:	00000097          	auipc	ra,0x0
     26e:	e10080e7          	jalr	-496(ra) # 7a <fork1>
     272:	cd25                	beqz	a0,2ea <runcmd+0x242>
    close(p[0]);
     274:	fb842503          	lw	a0,-72(s0)
     278:	00001097          	auipc	ra,0x1
     27c:	c32080e7          	jalr	-974(ra) # eaa <close>
    close(p[1]);
     280:	fbc42503          	lw	a0,-68(s0)
     284:	00001097          	auipc	ra,0x1
     288:	c26080e7          	jalr	-986(ra) # eaa <close>
    wait(0);
     28c:	4501                	li	a0,0
     28e:	00001097          	auipc	ra,0x1
     292:	bfc080e7          	jalr	-1028(ra) # e8a <wait>
    wait(0);
     296:	4501                	li	a0,0
     298:	00001097          	auipc	ra,0x1
     29c:	bf2080e7          	jalr	-1038(ra) # e8a <wait>
    break;
     2a0:	bf35                	j	1dc <runcmd+0x134>
      panic("pipe");
     2a2:	00001517          	auipc	a0,0x1
     2a6:	14e50513          	addi	a0,a0,334 # 13f0 <malloc+0x130>
     2aa:	00000097          	auipc	ra,0x0
     2ae:	daa080e7          	jalr	-598(ra) # 54 <panic>
      close(1);
     2b2:	4505                	li	a0,1
     2b4:	00001097          	auipc	ra,0x1
     2b8:	bf6080e7          	jalr	-1034(ra) # eaa <close>
      dup(p[1]);
     2bc:	fbc42503          	lw	a0,-68(s0)
     2c0:	00001097          	auipc	ra,0x1
     2c4:	c3a080e7          	jalr	-966(ra) # efa <dup>
      close(p[0]);
     2c8:	fb842503          	lw	a0,-72(s0)
     2cc:	00001097          	auipc	ra,0x1
     2d0:	bde080e7          	jalr	-1058(ra) # eaa <close>
      close(p[1]);
     2d4:	fbc42503          	lw	a0,-68(s0)
     2d8:	00001097          	auipc	ra,0x1
     2dc:	bd2080e7          	jalr	-1070(ra) # eaa <close>
      runcmd(pcmd->left);
     2e0:	6488                	ld	a0,8(s1)
     2e2:	00000097          	auipc	ra,0x0
     2e6:	dc6080e7          	jalr	-570(ra) # a8 <runcmd>
      close(0);
     2ea:	00001097          	auipc	ra,0x1
     2ee:	bc0080e7          	jalr	-1088(ra) # eaa <close>
      dup(p[0]);
     2f2:	fb842503          	lw	a0,-72(s0)
     2f6:	00001097          	auipc	ra,0x1
     2fa:	c04080e7          	jalr	-1020(ra) # efa <dup>
      close(p[0]);
     2fe:	fb842503          	lw	a0,-72(s0)
     302:	00001097          	auipc	ra,0x1
     306:	ba8080e7          	jalr	-1112(ra) # eaa <close>
      close(p[1]);
     30a:	fbc42503          	lw	a0,-68(s0)
     30e:	00001097          	auipc	ra,0x1
     312:	b9c080e7          	jalr	-1124(ra) # eaa <close>
      runcmd(pcmd->right);
     316:	6888                	ld	a0,16(s1)
     318:	00000097          	auipc	ra,0x0
     31c:	d90080e7          	jalr	-624(ra) # a8 <runcmd>
    if(fork1() == 0)
     320:	00000097          	auipc	ra,0x0
     324:	d5a080e7          	jalr	-678(ra) # 7a <fork1>
     328:	ea051ae3          	bnez	a0,1dc <runcmd+0x134>
      runcmd(bcmd->cmd);
     32c:	6488                	ld	a0,8(s1)
     32e:	00000097          	auipc	ra,0x0
     332:	d7a080e7          	jalr	-646(ra) # a8 <runcmd>

0000000000000336 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     336:	1101                	addi	sp,sp,-32
     338:	ec06                	sd	ra,24(sp)
     33a:	e822                	sd	s0,16(sp)
     33c:	e426                	sd	s1,8(sp)
     33e:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     340:	0a800513          	li	a0,168
     344:	00001097          	auipc	ra,0x1
     348:	f7c080e7          	jalr	-132(ra) # 12c0 <malloc>
     34c:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     34e:	0a800613          	li	a2,168
     352:	4581                	li	a1,0
     354:	00001097          	auipc	ra,0x1
     358:	932080e7          	jalr	-1742(ra) # c86 <memset>
  cmd->type = EXEC;
     35c:	4785                	li	a5,1
     35e:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     360:	8526                	mv	a0,s1
     362:	60e2                	ld	ra,24(sp)
     364:	6442                	ld	s0,16(sp)
     366:	64a2                	ld	s1,8(sp)
     368:	6105                	addi	sp,sp,32
     36a:	8082                	ret

000000000000036c <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     36c:	7139                	addi	sp,sp,-64
     36e:	fc06                	sd	ra,56(sp)
     370:	f822                	sd	s0,48(sp)
     372:	f426                	sd	s1,40(sp)
     374:	f04a                	sd	s2,32(sp)
     376:	ec4e                	sd	s3,24(sp)
     378:	e852                	sd	s4,16(sp)
     37a:	e456                	sd	s5,8(sp)
     37c:	e05a                	sd	s6,0(sp)
     37e:	0080                	addi	s0,sp,64
     380:	8b2a                	mv	s6,a0
     382:	8aae                	mv	s5,a1
     384:	8a32                	mv	s4,a2
     386:	89b6                	mv	s3,a3
     388:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     38a:	02800513          	li	a0,40
     38e:	00001097          	auipc	ra,0x1
     392:	f32080e7          	jalr	-206(ra) # 12c0 <malloc>
     396:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     398:	02800613          	li	a2,40
     39c:	4581                	li	a1,0
     39e:	00001097          	auipc	ra,0x1
     3a2:	8e8080e7          	jalr	-1816(ra) # c86 <memset>
  cmd->type = REDIR;
     3a6:	4789                	li	a5,2
     3a8:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3aa:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     3ae:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     3b2:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     3b6:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     3ba:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     3be:	8526                	mv	a0,s1
     3c0:	70e2                	ld	ra,56(sp)
     3c2:	7442                	ld	s0,48(sp)
     3c4:	74a2                	ld	s1,40(sp)
     3c6:	7902                	ld	s2,32(sp)
     3c8:	69e2                	ld	s3,24(sp)
     3ca:	6a42                	ld	s4,16(sp)
     3cc:	6aa2                	ld	s5,8(sp)
     3ce:	6b02                	ld	s6,0(sp)
     3d0:	6121                	addi	sp,sp,64
     3d2:	8082                	ret

00000000000003d4 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     3d4:	7179                	addi	sp,sp,-48
     3d6:	f406                	sd	ra,40(sp)
     3d8:	f022                	sd	s0,32(sp)
     3da:	ec26                	sd	s1,24(sp)
     3dc:	e84a                	sd	s2,16(sp)
     3de:	e44e                	sd	s3,8(sp)
     3e0:	1800                	addi	s0,sp,48
     3e2:	89aa                	mv	s3,a0
     3e4:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3e6:	4561                	li	a0,24
     3e8:	00001097          	auipc	ra,0x1
     3ec:	ed8080e7          	jalr	-296(ra) # 12c0 <malloc>
     3f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3f2:	4661                	li	a2,24
     3f4:	4581                	li	a1,0
     3f6:	00001097          	auipc	ra,0x1
     3fa:	890080e7          	jalr	-1904(ra) # c86 <memset>
  cmd->type = PIPE;
     3fe:	478d                	li	a5,3
     400:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     402:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     406:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     40a:	8526                	mv	a0,s1
     40c:	70a2                	ld	ra,40(sp)
     40e:	7402                	ld	s0,32(sp)
     410:	64e2                	ld	s1,24(sp)
     412:	6942                	ld	s2,16(sp)
     414:	69a2                	ld	s3,8(sp)
     416:	6145                	addi	sp,sp,48
     418:	8082                	ret

000000000000041a <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     41a:	7179                	addi	sp,sp,-48
     41c:	f406                	sd	ra,40(sp)
     41e:	f022                	sd	s0,32(sp)
     420:	ec26                	sd	s1,24(sp)
     422:	e84a                	sd	s2,16(sp)
     424:	e44e                	sd	s3,8(sp)
     426:	1800                	addi	s0,sp,48
     428:	89aa                	mv	s3,a0
     42a:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     42c:	4561                	li	a0,24
     42e:	00001097          	auipc	ra,0x1
     432:	e92080e7          	jalr	-366(ra) # 12c0 <malloc>
     436:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     438:	4661                	li	a2,24
     43a:	4581                	li	a1,0
     43c:	00001097          	auipc	ra,0x1
     440:	84a080e7          	jalr	-1974(ra) # c86 <memset>
  cmd->type = LIST;
     444:	4791                	li	a5,4
     446:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     448:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     44c:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     450:	8526                	mv	a0,s1
     452:	70a2                	ld	ra,40(sp)
     454:	7402                	ld	s0,32(sp)
     456:	64e2                	ld	s1,24(sp)
     458:	6942                	ld	s2,16(sp)
     45a:	69a2                	ld	s3,8(sp)
     45c:	6145                	addi	sp,sp,48
     45e:	8082                	ret

0000000000000460 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     460:	1101                	addi	sp,sp,-32
     462:	ec06                	sd	ra,24(sp)
     464:	e822                	sd	s0,16(sp)
     466:	e426                	sd	s1,8(sp)
     468:	e04a                	sd	s2,0(sp)
     46a:	1000                	addi	s0,sp,32
     46c:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     46e:	4541                	li	a0,16
     470:	00001097          	auipc	ra,0x1
     474:	e50080e7          	jalr	-432(ra) # 12c0 <malloc>
     478:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     47a:	4641                	li	a2,16
     47c:	4581                	li	a1,0
     47e:	00001097          	auipc	ra,0x1
     482:	808080e7          	jalr	-2040(ra) # c86 <memset>
  cmd->type = BACK;
     486:	4795                	li	a5,5
     488:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     48a:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     48e:	8526                	mv	a0,s1
     490:	60e2                	ld	ra,24(sp)
     492:	6442                	ld	s0,16(sp)
     494:	64a2                	ld	s1,8(sp)
     496:	6902                	ld	s2,0(sp)
     498:	6105                	addi	sp,sp,32
     49a:	8082                	ret

000000000000049c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     49c:	7139                	addi	sp,sp,-64
     49e:	fc06                	sd	ra,56(sp)
     4a0:	f822                	sd	s0,48(sp)
     4a2:	f426                	sd	s1,40(sp)
     4a4:	f04a                	sd	s2,32(sp)
     4a6:	ec4e                	sd	s3,24(sp)
     4a8:	e852                	sd	s4,16(sp)
     4aa:	e456                	sd	s5,8(sp)
     4ac:	e05a                	sd	s6,0(sp)
     4ae:	0080                	addi	s0,sp,64
     4b0:	8a2a                	mv	s4,a0
     4b2:	892e                	mv	s2,a1
     4b4:	8ab2                	mv	s5,a2
     4b6:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     4b8:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     4ba:	00001997          	auipc	s3,0x1
     4be:	05e98993          	addi	s3,s3,94 # 1518 <whitespace>
     4c2:	00b4fd63          	bgeu	s1,a1,4dc <gettoken+0x40>
     4c6:	0004c583          	lbu	a1,0(s1)
     4ca:	854e                	mv	a0,s3
     4cc:	00000097          	auipc	ra,0x0
     4d0:	7dc080e7          	jalr	2012(ra) # ca8 <strchr>
     4d4:	c501                	beqz	a0,4dc <gettoken+0x40>
    s++;
     4d6:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     4d8:	fe9917e3          	bne	s2,s1,4c6 <gettoken+0x2a>
  if(q)
     4dc:	000a8463          	beqz	s5,4e4 <gettoken+0x48>
    *q = s;
     4e0:	009ab023          	sd	s1,0(s5)
  ret = *s;
     4e4:	0004c783          	lbu	a5,0(s1)
     4e8:	00078a9b          	sext.w	s5,a5
  switch(*s){
     4ec:	03c00713          	li	a4,60
     4f0:	06f76563          	bltu	a4,a5,55a <gettoken+0xbe>
     4f4:	03a00713          	li	a4,58
     4f8:	00f76e63          	bltu	a4,a5,514 <gettoken+0x78>
     4fc:	cf89                	beqz	a5,516 <gettoken+0x7a>
     4fe:	02600713          	li	a4,38
     502:	00e78963          	beq	a5,a4,514 <gettoken+0x78>
     506:	fd87879b          	addiw	a5,a5,-40
     50a:	0ff7f793          	andi	a5,a5,255
     50e:	4705                	li	a4,1
     510:	06f76c63          	bltu	a4,a5,588 <gettoken+0xec>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     514:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     516:	000b0463          	beqz	s6,51e <gettoken+0x82>
    *eq = s;
     51a:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     51e:	00001997          	auipc	s3,0x1
     522:	ffa98993          	addi	s3,s3,-6 # 1518 <whitespace>
     526:	0124fd63          	bgeu	s1,s2,540 <gettoken+0xa4>
     52a:	0004c583          	lbu	a1,0(s1)
     52e:	854e                	mv	a0,s3
     530:	00000097          	auipc	ra,0x0
     534:	778080e7          	jalr	1912(ra) # ca8 <strchr>
     538:	c501                	beqz	a0,540 <gettoken+0xa4>
    s++;
     53a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     53c:	fe9917e3          	bne	s2,s1,52a <gettoken+0x8e>
  *ps = s;
     540:	009a3023          	sd	s1,0(s4)
  return ret;
}
     544:	8556                	mv	a0,s5
     546:	70e2                	ld	ra,56(sp)
     548:	7442                	ld	s0,48(sp)
     54a:	74a2                	ld	s1,40(sp)
     54c:	7902                	ld	s2,32(sp)
     54e:	69e2                	ld	s3,24(sp)
     550:	6a42                	ld	s4,16(sp)
     552:	6aa2                	ld	s5,8(sp)
     554:	6b02                	ld	s6,0(sp)
     556:	6121                	addi	sp,sp,64
     558:	8082                	ret
  switch(*s){
     55a:	03e00713          	li	a4,62
     55e:	02e79163          	bne	a5,a4,580 <gettoken+0xe4>
    s++;
     562:	00148693          	addi	a3,s1,1
    if(*s == '>'){
     566:	0014c703          	lbu	a4,1(s1)
     56a:	03e00793          	li	a5,62
      s++;
     56e:	0489                	addi	s1,s1,2
      ret = '+';
     570:	02b00a93          	li	s5,43
    if(*s == '>'){
     574:	faf701e3          	beq	a4,a5,516 <gettoken+0x7a>
    s++;
     578:	84b6                	mv	s1,a3
  ret = *s;
     57a:	03e00a93          	li	s5,62
     57e:	bf61                	j	516 <gettoken+0x7a>
  switch(*s){
     580:	07c00713          	li	a4,124
     584:	f8e788e3          	beq	a5,a4,514 <gettoken+0x78>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     588:	00001997          	auipc	s3,0x1
     58c:	f9098993          	addi	s3,s3,-112 # 1518 <whitespace>
     590:	00001a97          	auipc	s5,0x1
     594:	f80a8a93          	addi	s5,s5,-128 # 1510 <symbols>
     598:	0324f563          	bgeu	s1,s2,5c2 <gettoken+0x126>
     59c:	0004c583          	lbu	a1,0(s1)
     5a0:	854e                	mv	a0,s3
     5a2:	00000097          	auipc	ra,0x0
     5a6:	706080e7          	jalr	1798(ra) # ca8 <strchr>
     5aa:	e505                	bnez	a0,5d2 <gettoken+0x136>
     5ac:	0004c583          	lbu	a1,0(s1)
     5b0:	8556                	mv	a0,s5
     5b2:	00000097          	auipc	ra,0x0
     5b6:	6f6080e7          	jalr	1782(ra) # ca8 <strchr>
     5ba:	e909                	bnez	a0,5cc <gettoken+0x130>
      s++;
     5bc:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5be:	fc991fe3          	bne	s2,s1,59c <gettoken+0x100>
  if(eq)
     5c2:	06100a93          	li	s5,97
     5c6:	f40b1ae3          	bnez	s6,51a <gettoken+0x7e>
     5ca:	bf9d                	j	540 <gettoken+0xa4>
    ret = 'a';
     5cc:	06100a93          	li	s5,97
     5d0:	b799                	j	516 <gettoken+0x7a>
     5d2:	06100a93          	li	s5,97
     5d6:	b781                	j	516 <gettoken+0x7a>

00000000000005d8 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     5d8:	7139                	addi	sp,sp,-64
     5da:	fc06                	sd	ra,56(sp)
     5dc:	f822                	sd	s0,48(sp)
     5de:	f426                	sd	s1,40(sp)
     5e0:	f04a                	sd	s2,32(sp)
     5e2:	ec4e                	sd	s3,24(sp)
     5e4:	e852                	sd	s4,16(sp)
     5e6:	e456                	sd	s5,8(sp)
     5e8:	0080                	addi	s0,sp,64
     5ea:	8a2a                	mv	s4,a0
     5ec:	892e                	mv	s2,a1
     5ee:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     5f0:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     5f2:	00001997          	auipc	s3,0x1
     5f6:	f2698993          	addi	s3,s3,-218 # 1518 <whitespace>
     5fa:	00b4fd63          	bgeu	s1,a1,614 <peek+0x3c>
     5fe:	0004c583          	lbu	a1,0(s1)
     602:	854e                	mv	a0,s3
     604:	00000097          	auipc	ra,0x0
     608:	6a4080e7          	jalr	1700(ra) # ca8 <strchr>
     60c:	c501                	beqz	a0,614 <peek+0x3c>
    s++;
     60e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     610:	fe9917e3          	bne	s2,s1,5fe <peek+0x26>
  *ps = s;
     614:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     618:	0004c583          	lbu	a1,0(s1)
     61c:	4501                	li	a0,0
     61e:	e991                	bnez	a1,632 <peek+0x5a>
}
     620:	70e2                	ld	ra,56(sp)
     622:	7442                	ld	s0,48(sp)
     624:	74a2                	ld	s1,40(sp)
     626:	7902                	ld	s2,32(sp)
     628:	69e2                	ld	s3,24(sp)
     62a:	6a42                	ld	s4,16(sp)
     62c:	6aa2                	ld	s5,8(sp)
     62e:	6121                	addi	sp,sp,64
     630:	8082                	ret
  return *s && strchr(toks, *s);
     632:	8556                	mv	a0,s5
     634:	00000097          	auipc	ra,0x0
     638:	674080e7          	jalr	1652(ra) # ca8 <strchr>
     63c:	00a03533          	snez	a0,a0
     640:	b7c5                	j	620 <peek+0x48>

0000000000000642 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     642:	7159                	addi	sp,sp,-112
     644:	f486                	sd	ra,104(sp)
     646:	f0a2                	sd	s0,96(sp)
     648:	eca6                	sd	s1,88(sp)
     64a:	e8ca                	sd	s2,80(sp)
     64c:	e4ce                	sd	s3,72(sp)
     64e:	e0d2                	sd	s4,64(sp)
     650:	fc56                	sd	s5,56(sp)
     652:	f85a                	sd	s6,48(sp)
     654:	f45e                	sd	s7,40(sp)
     656:	f062                	sd	s8,32(sp)
     658:	ec66                	sd	s9,24(sp)
     65a:	1880                	addi	s0,sp,112
     65c:	8a2a                	mv	s4,a0
     65e:	89ae                	mv	s3,a1
     660:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     662:	00001b97          	auipc	s7,0x1
     666:	db6b8b93          	addi	s7,s7,-586 # 1418 <malloc+0x158>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     66a:	06100c13          	li	s8,97
      panic("missing file for redirection");
    switch(tok){
     66e:	03c00c93          	li	s9,60
  while(peek(ps, es, "<>")){
     672:	a02d                	j	69c <parseredirs+0x5a>
      panic("missing file for redirection");
     674:	00001517          	auipc	a0,0x1
     678:	d8450513          	addi	a0,a0,-636 # 13f8 <malloc+0x138>
     67c:	00000097          	auipc	ra,0x0
     680:	9d8080e7          	jalr	-1576(ra) # 54 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     684:	4701                	li	a4,0
     686:	4681                	li	a3,0
     688:	f9043603          	ld	a2,-112(s0)
     68c:	f9843583          	ld	a1,-104(s0)
     690:	8552                	mv	a0,s4
     692:	00000097          	auipc	ra,0x0
     696:	cda080e7          	jalr	-806(ra) # 36c <redircmd>
     69a:	8a2a                	mv	s4,a0
    switch(tok){
     69c:	03e00b13          	li	s6,62
     6a0:	02b00a93          	li	s5,43
  while(peek(ps, es, "<>")){
     6a4:	865e                	mv	a2,s7
     6a6:	85ca                	mv	a1,s2
     6a8:	854e                	mv	a0,s3
     6aa:	00000097          	auipc	ra,0x0
     6ae:	f2e080e7          	jalr	-210(ra) # 5d8 <peek>
     6b2:	c925                	beqz	a0,722 <parseredirs+0xe0>
    tok = gettoken(ps, es, 0, 0);
     6b4:	4681                	li	a3,0
     6b6:	4601                	li	a2,0
     6b8:	85ca                	mv	a1,s2
     6ba:	854e                	mv	a0,s3
     6bc:	00000097          	auipc	ra,0x0
     6c0:	de0080e7          	jalr	-544(ra) # 49c <gettoken>
     6c4:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     6c6:	f9040693          	addi	a3,s0,-112
     6ca:	f9840613          	addi	a2,s0,-104
     6ce:	85ca                	mv	a1,s2
     6d0:	854e                	mv	a0,s3
     6d2:	00000097          	auipc	ra,0x0
     6d6:	dca080e7          	jalr	-566(ra) # 49c <gettoken>
     6da:	f9851de3          	bne	a0,s8,674 <parseredirs+0x32>
    switch(tok){
     6de:	fb9483e3          	beq	s1,s9,684 <parseredirs+0x42>
     6e2:	03648263          	beq	s1,s6,706 <parseredirs+0xc4>
     6e6:	fb549fe3          	bne	s1,s5,6a4 <parseredirs+0x62>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     6ea:	4705                	li	a4,1
     6ec:	20100693          	li	a3,513
     6f0:	f9043603          	ld	a2,-112(s0)
     6f4:	f9843583          	ld	a1,-104(s0)
     6f8:	8552                	mv	a0,s4
     6fa:	00000097          	auipc	ra,0x0
     6fe:	c72080e7          	jalr	-910(ra) # 36c <redircmd>
     702:	8a2a                	mv	s4,a0
      break;
     704:	bf61                	j	69c <parseredirs+0x5a>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     706:	4705                	li	a4,1
     708:	60100693          	li	a3,1537
     70c:	f9043603          	ld	a2,-112(s0)
     710:	f9843583          	ld	a1,-104(s0)
     714:	8552                	mv	a0,s4
     716:	00000097          	auipc	ra,0x0
     71a:	c56080e7          	jalr	-938(ra) # 36c <redircmd>
     71e:	8a2a                	mv	s4,a0
      break;
     720:	bfb5                	j	69c <parseredirs+0x5a>
    }
  }
  return cmd;
}
     722:	8552                	mv	a0,s4
     724:	70a6                	ld	ra,104(sp)
     726:	7406                	ld	s0,96(sp)
     728:	64e6                	ld	s1,88(sp)
     72a:	6946                	ld	s2,80(sp)
     72c:	69a6                	ld	s3,72(sp)
     72e:	6a06                	ld	s4,64(sp)
     730:	7ae2                	ld	s5,56(sp)
     732:	7b42                	ld	s6,48(sp)
     734:	7ba2                	ld	s7,40(sp)
     736:	7c02                	ld	s8,32(sp)
     738:	6ce2                	ld	s9,24(sp)
     73a:	6165                	addi	sp,sp,112
     73c:	8082                	ret

000000000000073e <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     73e:	7159                	addi	sp,sp,-112
     740:	f486                	sd	ra,104(sp)
     742:	f0a2                	sd	s0,96(sp)
     744:	eca6                	sd	s1,88(sp)
     746:	e8ca                	sd	s2,80(sp)
     748:	e4ce                	sd	s3,72(sp)
     74a:	e0d2                	sd	s4,64(sp)
     74c:	fc56                	sd	s5,56(sp)
     74e:	f85a                	sd	s6,48(sp)
     750:	f45e                	sd	s7,40(sp)
     752:	f062                	sd	s8,32(sp)
     754:	ec66                	sd	s9,24(sp)
     756:	1880                	addi	s0,sp,112
     758:	8a2a                	mv	s4,a0
     75a:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     75c:	00001617          	auipc	a2,0x1
     760:	cc460613          	addi	a2,a2,-828 # 1420 <malloc+0x160>
     764:	00000097          	auipc	ra,0x0
     768:	e74080e7          	jalr	-396(ra) # 5d8 <peek>
     76c:	e905                	bnez	a0,79c <parseexec+0x5e>
     76e:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     770:	00000097          	auipc	ra,0x0
     774:	bc6080e7          	jalr	-1082(ra) # 336 <execcmd>
     778:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     77a:	8656                	mv	a2,s5
     77c:	85d2                	mv	a1,s4
     77e:	00000097          	auipc	ra,0x0
     782:	ec4080e7          	jalr	-316(ra) # 642 <parseredirs>
     786:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     788:	008c0913          	addi	s2,s8,8
     78c:	00001b17          	auipc	s6,0x1
     790:	cb4b0b13          	addi	s6,s6,-844 # 1440 <malloc+0x180>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     794:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     798:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     79a:	a0b1                	j	7e6 <parseexec+0xa8>
    return parseblock(ps, es);
     79c:	85d6                	mv	a1,s5
     79e:	8552                	mv	a0,s4
     7a0:	00000097          	auipc	ra,0x0
     7a4:	1bc080e7          	jalr	444(ra) # 95c <parseblock>
     7a8:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     7aa:	8526                	mv	a0,s1
     7ac:	70a6                	ld	ra,104(sp)
     7ae:	7406                	ld	s0,96(sp)
     7b0:	64e6                	ld	s1,88(sp)
     7b2:	6946                	ld	s2,80(sp)
     7b4:	69a6                	ld	s3,72(sp)
     7b6:	6a06                	ld	s4,64(sp)
     7b8:	7ae2                	ld	s5,56(sp)
     7ba:	7b42                	ld	s6,48(sp)
     7bc:	7ba2                	ld	s7,40(sp)
     7be:	7c02                	ld	s8,32(sp)
     7c0:	6ce2                	ld	s9,24(sp)
     7c2:	6165                	addi	sp,sp,112
     7c4:	8082                	ret
      panic("syntax");
     7c6:	00001517          	auipc	a0,0x1
     7ca:	c6250513          	addi	a0,a0,-926 # 1428 <malloc+0x168>
     7ce:	00000097          	auipc	ra,0x0
     7d2:	886080e7          	jalr	-1914(ra) # 54 <panic>
    ret = parseredirs(ret, ps, es);
     7d6:	8656                	mv	a2,s5
     7d8:	85d2                	mv	a1,s4
     7da:	8526                	mv	a0,s1
     7dc:	00000097          	auipc	ra,0x0
     7e0:	e66080e7          	jalr	-410(ra) # 642 <parseredirs>
     7e4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     7e6:	865a                	mv	a2,s6
     7e8:	85d6                	mv	a1,s5
     7ea:	8552                	mv	a0,s4
     7ec:	00000097          	auipc	ra,0x0
     7f0:	dec080e7          	jalr	-532(ra) # 5d8 <peek>
     7f4:	e131                	bnez	a0,838 <parseexec+0xfa>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     7f6:	f9040693          	addi	a3,s0,-112
     7fa:	f9840613          	addi	a2,s0,-104
     7fe:	85d6                	mv	a1,s5
     800:	8552                	mv	a0,s4
     802:	00000097          	auipc	ra,0x0
     806:	c9a080e7          	jalr	-870(ra) # 49c <gettoken>
     80a:	c51d                	beqz	a0,838 <parseexec+0xfa>
    if(tok != 'a')
     80c:	fb951de3          	bne	a0,s9,7c6 <parseexec+0x88>
    cmd->argv[argc] = q;
     810:	f9843783          	ld	a5,-104(s0)
     814:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     818:	f9043783          	ld	a5,-112(s0)
     81c:	04f93823          	sd	a5,80(s2)
    argc++;
     820:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
     822:	0921                	addi	s2,s2,8
     824:	fb7999e3          	bne	s3,s7,7d6 <parseexec+0x98>
      panic("too many args");
     828:	00001517          	auipc	a0,0x1
     82c:	c0850513          	addi	a0,a0,-1016 # 1430 <malloc+0x170>
     830:	00000097          	auipc	ra,0x0
     834:	824080e7          	jalr	-2012(ra) # 54 <panic>
  cmd->argv[argc] = 0;
     838:	098e                	slli	s3,s3,0x3
     83a:	99e2                	add	s3,s3,s8
     83c:	0009b423          	sd	zero,8(s3)
  cmd->eargv[argc] = 0;
     840:	0409bc23          	sd	zero,88(s3)
  return ret;
     844:	b79d                	j	7aa <parseexec+0x6c>

0000000000000846 <parsepipe>:
{
     846:	7179                	addi	sp,sp,-48
     848:	f406                	sd	ra,40(sp)
     84a:	f022                	sd	s0,32(sp)
     84c:	ec26                	sd	s1,24(sp)
     84e:	e84a                	sd	s2,16(sp)
     850:	e44e                	sd	s3,8(sp)
     852:	1800                	addi	s0,sp,48
     854:	892a                	mv	s2,a0
     856:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     858:	00000097          	auipc	ra,0x0
     85c:	ee6080e7          	jalr	-282(ra) # 73e <parseexec>
     860:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     862:	00001617          	auipc	a2,0x1
     866:	be660613          	addi	a2,a2,-1050 # 1448 <malloc+0x188>
     86a:	85ce                	mv	a1,s3
     86c:	854a                	mv	a0,s2
     86e:	00000097          	auipc	ra,0x0
     872:	d6a080e7          	jalr	-662(ra) # 5d8 <peek>
     876:	e909                	bnez	a0,888 <parsepipe+0x42>
}
     878:	8526                	mv	a0,s1
     87a:	70a2                	ld	ra,40(sp)
     87c:	7402                	ld	s0,32(sp)
     87e:	64e2                	ld	s1,24(sp)
     880:	6942                	ld	s2,16(sp)
     882:	69a2                	ld	s3,8(sp)
     884:	6145                	addi	sp,sp,48
     886:	8082                	ret
    gettoken(ps, es, 0, 0);
     888:	4681                	li	a3,0
     88a:	4601                	li	a2,0
     88c:	85ce                	mv	a1,s3
     88e:	854a                	mv	a0,s2
     890:	00000097          	auipc	ra,0x0
     894:	c0c080e7          	jalr	-1012(ra) # 49c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     898:	85ce                	mv	a1,s3
     89a:	854a                	mv	a0,s2
     89c:	00000097          	auipc	ra,0x0
     8a0:	faa080e7          	jalr	-86(ra) # 846 <parsepipe>
     8a4:	85aa                	mv	a1,a0
     8a6:	8526                	mv	a0,s1
     8a8:	00000097          	auipc	ra,0x0
     8ac:	b2c080e7          	jalr	-1236(ra) # 3d4 <pipecmd>
     8b0:	84aa                	mv	s1,a0
  return cmd;
     8b2:	b7d9                	j	878 <parsepipe+0x32>

00000000000008b4 <parseline>:
{
     8b4:	7179                	addi	sp,sp,-48
     8b6:	f406                	sd	ra,40(sp)
     8b8:	f022                	sd	s0,32(sp)
     8ba:	ec26                	sd	s1,24(sp)
     8bc:	e84a                	sd	s2,16(sp)
     8be:	e44e                	sd	s3,8(sp)
     8c0:	e052                	sd	s4,0(sp)
     8c2:	1800                	addi	s0,sp,48
     8c4:	892a                	mv	s2,a0
     8c6:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     8c8:	00000097          	auipc	ra,0x0
     8cc:	f7e080e7          	jalr	-130(ra) # 846 <parsepipe>
     8d0:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     8d2:	00001a17          	auipc	s4,0x1
     8d6:	b7ea0a13          	addi	s4,s4,-1154 # 1450 <malloc+0x190>
     8da:	a839                	j	8f8 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     8dc:	4681                	li	a3,0
     8de:	4601                	li	a2,0
     8e0:	85ce                	mv	a1,s3
     8e2:	854a                	mv	a0,s2
     8e4:	00000097          	auipc	ra,0x0
     8e8:	bb8080e7          	jalr	-1096(ra) # 49c <gettoken>
    cmd = backcmd(cmd);
     8ec:	8526                	mv	a0,s1
     8ee:	00000097          	auipc	ra,0x0
     8f2:	b72080e7          	jalr	-1166(ra) # 460 <backcmd>
     8f6:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     8f8:	8652                	mv	a2,s4
     8fa:	85ce                	mv	a1,s3
     8fc:	854a                	mv	a0,s2
     8fe:	00000097          	auipc	ra,0x0
     902:	cda080e7          	jalr	-806(ra) # 5d8 <peek>
     906:	f979                	bnez	a0,8dc <parseline+0x28>
  if(peek(ps, es, ";")){
     908:	00001617          	auipc	a2,0x1
     90c:	b5060613          	addi	a2,a2,-1200 # 1458 <malloc+0x198>
     910:	85ce                	mv	a1,s3
     912:	854a                	mv	a0,s2
     914:	00000097          	auipc	ra,0x0
     918:	cc4080e7          	jalr	-828(ra) # 5d8 <peek>
     91c:	e911                	bnez	a0,930 <parseline+0x7c>
}
     91e:	8526                	mv	a0,s1
     920:	70a2                	ld	ra,40(sp)
     922:	7402                	ld	s0,32(sp)
     924:	64e2                	ld	s1,24(sp)
     926:	6942                	ld	s2,16(sp)
     928:	69a2                	ld	s3,8(sp)
     92a:	6a02                	ld	s4,0(sp)
     92c:	6145                	addi	sp,sp,48
     92e:	8082                	ret
    gettoken(ps, es, 0, 0);
     930:	4681                	li	a3,0
     932:	4601                	li	a2,0
     934:	85ce                	mv	a1,s3
     936:	854a                	mv	a0,s2
     938:	00000097          	auipc	ra,0x0
     93c:	b64080e7          	jalr	-1180(ra) # 49c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     940:	85ce                	mv	a1,s3
     942:	854a                	mv	a0,s2
     944:	00000097          	auipc	ra,0x0
     948:	f70080e7          	jalr	-144(ra) # 8b4 <parseline>
     94c:	85aa                	mv	a1,a0
     94e:	8526                	mv	a0,s1
     950:	00000097          	auipc	ra,0x0
     954:	aca080e7          	jalr	-1334(ra) # 41a <listcmd>
     958:	84aa                	mv	s1,a0
  return cmd;
     95a:	b7d1                	j	91e <parseline+0x6a>

000000000000095c <parseblock>:
{
     95c:	7179                	addi	sp,sp,-48
     95e:	f406                	sd	ra,40(sp)
     960:	f022                	sd	s0,32(sp)
     962:	ec26                	sd	s1,24(sp)
     964:	e84a                	sd	s2,16(sp)
     966:	e44e                	sd	s3,8(sp)
     968:	1800                	addi	s0,sp,48
     96a:	84aa                	mv	s1,a0
     96c:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     96e:	00001617          	auipc	a2,0x1
     972:	ab260613          	addi	a2,a2,-1358 # 1420 <malloc+0x160>
     976:	00000097          	auipc	ra,0x0
     97a:	c62080e7          	jalr	-926(ra) # 5d8 <peek>
     97e:	c12d                	beqz	a0,9e0 <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     980:	4681                	li	a3,0
     982:	4601                	li	a2,0
     984:	85ca                	mv	a1,s2
     986:	8526                	mv	a0,s1
     988:	00000097          	auipc	ra,0x0
     98c:	b14080e7          	jalr	-1260(ra) # 49c <gettoken>
  cmd = parseline(ps, es);
     990:	85ca                	mv	a1,s2
     992:	8526                	mv	a0,s1
     994:	00000097          	auipc	ra,0x0
     998:	f20080e7          	jalr	-224(ra) # 8b4 <parseline>
     99c:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     99e:	00001617          	auipc	a2,0x1
     9a2:	ad260613          	addi	a2,a2,-1326 # 1470 <malloc+0x1b0>
     9a6:	85ca                	mv	a1,s2
     9a8:	8526                	mv	a0,s1
     9aa:	00000097          	auipc	ra,0x0
     9ae:	c2e080e7          	jalr	-978(ra) # 5d8 <peek>
     9b2:	cd1d                	beqz	a0,9f0 <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     9b4:	4681                	li	a3,0
     9b6:	4601                	li	a2,0
     9b8:	85ca                	mv	a1,s2
     9ba:	8526                	mv	a0,s1
     9bc:	00000097          	auipc	ra,0x0
     9c0:	ae0080e7          	jalr	-1312(ra) # 49c <gettoken>
  cmd = parseredirs(cmd, ps, es);
     9c4:	864a                	mv	a2,s2
     9c6:	85a6                	mv	a1,s1
     9c8:	854e                	mv	a0,s3
     9ca:	00000097          	auipc	ra,0x0
     9ce:	c78080e7          	jalr	-904(ra) # 642 <parseredirs>
}
     9d2:	70a2                	ld	ra,40(sp)
     9d4:	7402                	ld	s0,32(sp)
     9d6:	64e2                	ld	s1,24(sp)
     9d8:	6942                	ld	s2,16(sp)
     9da:	69a2                	ld	s3,8(sp)
     9dc:	6145                	addi	sp,sp,48
     9de:	8082                	ret
    panic("parseblock");
     9e0:	00001517          	auipc	a0,0x1
     9e4:	a8050513          	addi	a0,a0,-1408 # 1460 <malloc+0x1a0>
     9e8:	fffff097          	auipc	ra,0xfffff
     9ec:	66c080e7          	jalr	1644(ra) # 54 <panic>
    panic("syntax - missing )");
     9f0:	00001517          	auipc	a0,0x1
     9f4:	a8850513          	addi	a0,a0,-1400 # 1478 <malloc+0x1b8>
     9f8:	fffff097          	auipc	ra,0xfffff
     9fc:	65c080e7          	jalr	1628(ra) # 54 <panic>

0000000000000a00 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a00:	1101                	addi	sp,sp,-32
     a02:	ec06                	sd	ra,24(sp)
     a04:	e822                	sd	s0,16(sp)
     a06:	e426                	sd	s1,8(sp)
     a08:	1000                	addi	s0,sp,32
     a0a:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a0c:	c521                	beqz	a0,a54 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     a0e:	4118                	lw	a4,0(a0)
     a10:	4795                	li	a5,5
     a12:	04e7e163          	bltu	a5,a4,a54 <nulterminate+0x54>
     a16:	00056783          	lwu	a5,0(a0)
     a1a:	078a                	slli	a5,a5,0x2
     a1c:	00001717          	auipc	a4,0x1
     a20:	abc70713          	addi	a4,a4,-1348 # 14d8 <malloc+0x218>
     a24:	97ba                	add	a5,a5,a4
     a26:	439c                	lw	a5,0(a5)
     a28:	97ba                	add	a5,a5,a4
     a2a:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     a2c:	651c                	ld	a5,8(a0)
     a2e:	c39d                	beqz	a5,a54 <nulterminate+0x54>
     a30:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     a34:	67b8                	ld	a4,72(a5)
     a36:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     a3a:	07a1                	addi	a5,a5,8
     a3c:	ff87b703          	ld	a4,-8(a5)
     a40:	fb75                	bnez	a4,a34 <nulterminate+0x34>
     a42:	a809                	j	a54 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     a44:	6508                	ld	a0,8(a0)
     a46:	00000097          	auipc	ra,0x0
     a4a:	fba080e7          	jalr	-70(ra) # a00 <nulterminate>
    *rcmd->efile = 0;
     a4e:	6c9c                	ld	a5,24(s1)
     a50:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     a54:	8526                	mv	a0,s1
     a56:	60e2                	ld	ra,24(sp)
     a58:	6442                	ld	s0,16(sp)
     a5a:	64a2                	ld	s1,8(sp)
     a5c:	6105                	addi	sp,sp,32
     a5e:	8082                	ret
    nulterminate(pcmd->left);
     a60:	6508                	ld	a0,8(a0)
     a62:	00000097          	auipc	ra,0x0
     a66:	f9e080e7          	jalr	-98(ra) # a00 <nulterminate>
    nulterminate(pcmd->right);
     a6a:	6888                	ld	a0,16(s1)
     a6c:	00000097          	auipc	ra,0x0
     a70:	f94080e7          	jalr	-108(ra) # a00 <nulterminate>
    break;
     a74:	b7c5                	j	a54 <nulterminate+0x54>
    nulterminate(lcmd->left);
     a76:	6508                	ld	a0,8(a0)
     a78:	00000097          	auipc	ra,0x0
     a7c:	f88080e7          	jalr	-120(ra) # a00 <nulterminate>
    nulterminate(lcmd->right);
     a80:	6888                	ld	a0,16(s1)
     a82:	00000097          	auipc	ra,0x0
     a86:	f7e080e7          	jalr	-130(ra) # a00 <nulterminate>
    break;
     a8a:	b7e9                	j	a54 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     a8c:	6508                	ld	a0,8(a0)
     a8e:	00000097          	auipc	ra,0x0
     a92:	f72080e7          	jalr	-142(ra) # a00 <nulterminate>
    break;
     a96:	bf7d                	j	a54 <nulterminate+0x54>

0000000000000a98 <parsecmd>:
{
     a98:	7179                	addi	sp,sp,-48
     a9a:	f406                	sd	ra,40(sp)
     a9c:	f022                	sd	s0,32(sp)
     a9e:	ec26                	sd	s1,24(sp)
     aa0:	e84a                	sd	s2,16(sp)
     aa2:	1800                	addi	s0,sp,48
     aa4:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     aa8:	84aa                	mv	s1,a0
     aaa:	00000097          	auipc	ra,0x0
     aae:	1b2080e7          	jalr	434(ra) # c5c <strlen>
     ab2:	1502                	slli	a0,a0,0x20
     ab4:	9101                	srli	a0,a0,0x20
     ab6:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     ab8:	85a6                	mv	a1,s1
     aba:	fd840513          	addi	a0,s0,-40
     abe:	00000097          	auipc	ra,0x0
     ac2:	df6080e7          	jalr	-522(ra) # 8b4 <parseline>
     ac6:	892a                	mv	s2,a0
  peek(&s, es, "");
     ac8:	00001617          	auipc	a2,0x1
     acc:	9c860613          	addi	a2,a2,-1592 # 1490 <malloc+0x1d0>
     ad0:	85a6                	mv	a1,s1
     ad2:	fd840513          	addi	a0,s0,-40
     ad6:	00000097          	auipc	ra,0x0
     ada:	b02080e7          	jalr	-1278(ra) # 5d8 <peek>
  if(s != es){
     ade:	fd843603          	ld	a2,-40(s0)
     ae2:	00961e63          	bne	a2,s1,afe <parsecmd+0x66>
  nulterminate(cmd);
     ae6:	854a                	mv	a0,s2
     ae8:	00000097          	auipc	ra,0x0
     aec:	f18080e7          	jalr	-232(ra) # a00 <nulterminate>
}
     af0:	854a                	mv	a0,s2
     af2:	70a2                	ld	ra,40(sp)
     af4:	7402                	ld	s0,32(sp)
     af6:	64e2                	ld	s1,24(sp)
     af8:	6942                	ld	s2,16(sp)
     afa:	6145                	addi	sp,sp,48
     afc:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     afe:	00001597          	auipc	a1,0x1
     b02:	99a58593          	addi	a1,a1,-1638 # 1498 <malloc+0x1d8>
     b06:	4509                	li	a0,2
     b08:	00000097          	auipc	ra,0x0
     b0c:	6cc080e7          	jalr	1740(ra) # 11d4 <fprintf>
    panic("syntax");
     b10:	00001517          	auipc	a0,0x1
     b14:	91850513          	addi	a0,a0,-1768 # 1428 <malloc+0x168>
     b18:	fffff097          	auipc	ra,0xfffff
     b1c:	53c080e7          	jalr	1340(ra) # 54 <panic>

0000000000000b20 <main>:
{
     b20:	7139                	addi	sp,sp,-64
     b22:	fc06                	sd	ra,56(sp)
     b24:	f822                	sd	s0,48(sp)
     b26:	f426                	sd	s1,40(sp)
     b28:	f04a                	sd	s2,32(sp)
     b2a:	ec4e                	sd	s3,24(sp)
     b2c:	e852                	sd	s4,16(sp)
     b2e:	e456                	sd	s5,8(sp)
     b30:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     b32:	00001497          	auipc	s1,0x1
     b36:	97648493          	addi	s1,s1,-1674 # 14a8 <malloc+0x1e8>
     b3a:	4589                	li	a1,2
     b3c:	8526                	mv	a0,s1
     b3e:	00000097          	auipc	ra,0x0
     b42:	384080e7          	jalr	900(ra) # ec2 <open>
     b46:	00054963          	bltz	a0,b58 <main+0x38>
    if(fd >= 3){
     b4a:	4789                	li	a5,2
     b4c:	fea7d7e3          	bge	a5,a0,b3a <main+0x1a>
      close(fd);
     b50:	00000097          	auipc	ra,0x0
     b54:	35a080e7          	jalr	858(ra) # eaa <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b58:	00001497          	auipc	s1,0x1
     b5c:	9d048493          	addi	s1,s1,-1584 # 1528 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     b60:	06300913          	li	s2,99
     b64:	02000993          	li	s3,32
      if(chdir(buf+3) < 0)
     b68:	00001a17          	auipc	s4,0x1
     b6c:	9c3a0a13          	addi	s4,s4,-1597 # 152b <buf.0+0x3>
        fprintf(2, "cannot cd %s\n", buf+3);
     b70:	00001a97          	auipc	s5,0x1
     b74:	940a8a93          	addi	s5,s5,-1728 # 14b0 <malloc+0x1f0>
     b78:	a819                	j	b8e <main+0x6e>
    if(fork1() == 0)
     b7a:	fffff097          	auipc	ra,0xfffff
     b7e:	500080e7          	jalr	1280(ra) # 7a <fork1>
     b82:	c925                	beqz	a0,bf2 <main+0xd2>
    wait(0);
     b84:	4501                	li	a0,0
     b86:	00000097          	auipc	ra,0x0
     b8a:	304080e7          	jalr	772(ra) # e8a <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     b8e:	06400593          	li	a1,100
     b92:	8526                	mv	a0,s1
     b94:	fffff097          	auipc	ra,0xfffff
     b98:	46c080e7          	jalr	1132(ra) # 0 <getcmd>
     b9c:	06054763          	bltz	a0,c0a <main+0xea>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     ba0:	0004c783          	lbu	a5,0(s1)
     ba4:	fd279be3          	bne	a5,s2,b7a <main+0x5a>
     ba8:	0014c703          	lbu	a4,1(s1)
     bac:	06400793          	li	a5,100
     bb0:	fcf715e3          	bne	a4,a5,b7a <main+0x5a>
     bb4:	0024c783          	lbu	a5,2(s1)
     bb8:	fd3791e3          	bne	a5,s3,b7a <main+0x5a>
      buf[strlen(buf)-1] = 0;  // chop \n
     bbc:	8526                	mv	a0,s1
     bbe:	00000097          	auipc	ra,0x0
     bc2:	09e080e7          	jalr	158(ra) # c5c <strlen>
     bc6:	fff5079b          	addiw	a5,a0,-1
     bca:	1782                	slli	a5,a5,0x20
     bcc:	9381                	srli	a5,a5,0x20
     bce:	97a6                	add	a5,a5,s1
     bd0:	00078023          	sb	zero,0(a5)
      if(chdir(buf+3) < 0)
     bd4:	8552                	mv	a0,s4
     bd6:	00000097          	auipc	ra,0x0
     bda:	31c080e7          	jalr	796(ra) # ef2 <chdir>
     bde:	fa0558e3          	bgez	a0,b8e <main+0x6e>
        fprintf(2, "cannot cd %s\n", buf+3);
     be2:	8652                	mv	a2,s4
     be4:	85d6                	mv	a1,s5
     be6:	4509                	li	a0,2
     be8:	00000097          	auipc	ra,0x0
     bec:	5ec080e7          	jalr	1516(ra) # 11d4 <fprintf>
     bf0:	bf79                	j	b8e <main+0x6e>
      runcmd(parsecmd(buf));
     bf2:	00001517          	auipc	a0,0x1
     bf6:	93650513          	addi	a0,a0,-1738 # 1528 <buf.0>
     bfa:	00000097          	auipc	ra,0x0
     bfe:	e9e080e7          	jalr	-354(ra) # a98 <parsecmd>
     c02:	fffff097          	auipc	ra,0xfffff
     c06:	4a6080e7          	jalr	1190(ra) # a8 <runcmd>
  exit(0);
     c0a:	4501                	li	a0,0
     c0c:	00000097          	auipc	ra,0x0
     c10:	276080e7          	jalr	630(ra) # e82 <exit>

0000000000000c14 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
     c14:	1141                	addi	sp,sp,-16
     c16:	e422                	sd	s0,8(sp)
     c18:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     c1a:	87aa                	mv	a5,a0
     c1c:	0585                	addi	a1,a1,1
     c1e:	0785                	addi	a5,a5,1
     c20:	fff5c703          	lbu	a4,-1(a1)
     c24:	fee78fa3          	sb	a4,-1(a5)
     c28:	fb75                	bnez	a4,c1c <strcpy+0x8>
    ;
  return os;
}
     c2a:	6422                	ld	s0,8(sp)
     c2c:	0141                	addi	sp,sp,16
     c2e:	8082                	ret

0000000000000c30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     c30:	1141                	addi	sp,sp,-16
     c32:	e422                	sd	s0,8(sp)
     c34:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     c36:	00054783          	lbu	a5,0(a0)
     c3a:	cb91                	beqz	a5,c4e <strcmp+0x1e>
     c3c:	0005c703          	lbu	a4,0(a1)
     c40:	00f71763          	bne	a4,a5,c4e <strcmp+0x1e>
    p++, q++;
     c44:	0505                	addi	a0,a0,1
     c46:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     c48:	00054783          	lbu	a5,0(a0)
     c4c:	fbe5                	bnez	a5,c3c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c4e:	0005c503          	lbu	a0,0(a1)
}
     c52:	40a7853b          	subw	a0,a5,a0
     c56:	6422                	ld	s0,8(sp)
     c58:	0141                	addi	sp,sp,16
     c5a:	8082                	ret

0000000000000c5c <strlen>:

uint
strlen(const char *s)
{
     c5c:	1141                	addi	sp,sp,-16
     c5e:	e422                	sd	s0,8(sp)
     c60:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c62:	00054783          	lbu	a5,0(a0)
     c66:	cf91                	beqz	a5,c82 <strlen+0x26>
     c68:	0505                	addi	a0,a0,1
     c6a:	87aa                	mv	a5,a0
     c6c:	4685                	li	a3,1
     c6e:	9e89                	subw	a3,a3,a0
     c70:	00f6853b          	addw	a0,a3,a5
     c74:	0785                	addi	a5,a5,1
     c76:	fff7c703          	lbu	a4,-1(a5)
     c7a:	fb7d                	bnez	a4,c70 <strlen+0x14>
    ;
  return n;
}
     c7c:	6422                	ld	s0,8(sp)
     c7e:	0141                	addi	sp,sp,16
     c80:	8082                	ret
  for(n = 0; s[n]; n++)
     c82:	4501                	li	a0,0
     c84:	bfe5                	j	c7c <strlen+0x20>

0000000000000c86 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c86:	1141                	addi	sp,sp,-16
     c88:	e422                	sd	s0,8(sp)
     c8a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c8c:	ca19                	beqz	a2,ca2 <memset+0x1c>
     c8e:	87aa                	mv	a5,a0
     c90:	1602                	slli	a2,a2,0x20
     c92:	9201                	srli	a2,a2,0x20
     c94:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c98:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c9c:	0785                	addi	a5,a5,1
     c9e:	fee79de3          	bne	a5,a4,c98 <memset+0x12>
  }
  return dst;
}
     ca2:	6422                	ld	s0,8(sp)
     ca4:	0141                	addi	sp,sp,16
     ca6:	8082                	ret

0000000000000ca8 <strchr>:

char*
strchr(const char *s, char c)
{
     ca8:	1141                	addi	sp,sp,-16
     caa:	e422                	sd	s0,8(sp)
     cac:	0800                	addi	s0,sp,16
  for(; *s; s++)
     cae:	00054783          	lbu	a5,0(a0)
     cb2:	cb99                	beqz	a5,cc8 <strchr+0x20>
    if(*s == c)
     cb4:	00f58763          	beq	a1,a5,cc2 <strchr+0x1a>
  for(; *s; s++)
     cb8:	0505                	addi	a0,a0,1
     cba:	00054783          	lbu	a5,0(a0)
     cbe:	fbfd                	bnez	a5,cb4 <strchr+0xc>
      return (char*)s;
  return 0;
     cc0:	4501                	li	a0,0
}
     cc2:	6422                	ld	s0,8(sp)
     cc4:	0141                	addi	sp,sp,16
     cc6:	8082                	ret
  return 0;
     cc8:	4501                	li	a0,0
     cca:	bfe5                	j	cc2 <strchr+0x1a>

0000000000000ccc <gets>:

char*
gets(char *buf, int max)
{
     ccc:	711d                	addi	sp,sp,-96
     cce:	ec86                	sd	ra,88(sp)
     cd0:	e8a2                	sd	s0,80(sp)
     cd2:	e4a6                	sd	s1,72(sp)
     cd4:	e0ca                	sd	s2,64(sp)
     cd6:	fc4e                	sd	s3,56(sp)
     cd8:	f852                	sd	s4,48(sp)
     cda:	f456                	sd	s5,40(sp)
     cdc:	f05a                	sd	s6,32(sp)
     cde:	ec5e                	sd	s7,24(sp)
     ce0:	1080                	addi	s0,sp,96
     ce2:	8baa                	mv	s7,a0
     ce4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ce6:	892a                	mv	s2,a0
     ce8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     cea:	4aa9                	li	s5,10
     cec:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cee:	89a6                	mv	s3,s1
     cf0:	2485                	addiw	s1,s1,1
     cf2:	0344d863          	bge	s1,s4,d22 <gets+0x56>
    cc = read(0, &c, 1);
     cf6:	4605                	li	a2,1
     cf8:	faf40593          	addi	a1,s0,-81
     cfc:	4501                	li	a0,0
     cfe:	00000097          	auipc	ra,0x0
     d02:	19c080e7          	jalr	412(ra) # e9a <read>
    if(cc < 1)
     d06:	00a05e63          	blez	a0,d22 <gets+0x56>
    buf[i++] = c;
     d0a:	faf44783          	lbu	a5,-81(s0)
     d0e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     d12:	01578763          	beq	a5,s5,d20 <gets+0x54>
     d16:	0905                	addi	s2,s2,1
     d18:	fd679be3          	bne	a5,s6,cee <gets+0x22>
  for(i=0; i+1 < max; ){
     d1c:	89a6                	mv	s3,s1
     d1e:	a011                	j	d22 <gets+0x56>
     d20:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     d22:	99de                	add	s3,s3,s7
     d24:	00098023          	sb	zero,0(s3)
  return buf;
}
     d28:	855e                	mv	a0,s7
     d2a:	60e6                	ld	ra,88(sp)
     d2c:	6446                	ld	s0,80(sp)
     d2e:	64a6                	ld	s1,72(sp)
     d30:	6906                	ld	s2,64(sp)
     d32:	79e2                	ld	s3,56(sp)
     d34:	7a42                	ld	s4,48(sp)
     d36:	7aa2                	ld	s5,40(sp)
     d38:	7b02                	ld	s6,32(sp)
     d3a:	6be2                	ld	s7,24(sp)
     d3c:	6125                	addi	sp,sp,96
     d3e:	8082                	ret

0000000000000d40 <stat>:

int
stat(const char *n, struct stat *st)
{
     d40:	1101                	addi	sp,sp,-32
     d42:	ec06                	sd	ra,24(sp)
     d44:	e822                	sd	s0,16(sp)
     d46:	e426                	sd	s1,8(sp)
     d48:	e04a                	sd	s2,0(sp)
     d4a:	1000                	addi	s0,sp,32
     d4c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d4e:	4581                	li	a1,0
     d50:	00000097          	auipc	ra,0x0
     d54:	172080e7          	jalr	370(ra) # ec2 <open>
  if(fd < 0)
     d58:	02054563          	bltz	a0,d82 <stat+0x42>
     d5c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d5e:	85ca                	mv	a1,s2
     d60:	00000097          	auipc	ra,0x0
     d64:	17a080e7          	jalr	378(ra) # eda <fstat>
     d68:	892a                	mv	s2,a0
  close(fd);
     d6a:	8526                	mv	a0,s1
     d6c:	00000097          	auipc	ra,0x0
     d70:	13e080e7          	jalr	318(ra) # eaa <close>
  return r;
}
     d74:	854a                	mv	a0,s2
     d76:	60e2                	ld	ra,24(sp)
     d78:	6442                	ld	s0,16(sp)
     d7a:	64a2                	ld	s1,8(sp)
     d7c:	6902                	ld	s2,0(sp)
     d7e:	6105                	addi	sp,sp,32
     d80:	8082                	ret
    return -1;
     d82:	597d                	li	s2,-1
     d84:	bfc5                	j	d74 <stat+0x34>

0000000000000d86 <atoi>:

int
atoi(const char *s)
{
     d86:	1141                	addi	sp,sp,-16
     d88:	e422                	sd	s0,8(sp)
     d8a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d8c:	00054603          	lbu	a2,0(a0)
     d90:	fd06079b          	addiw	a5,a2,-48
     d94:	0ff7f793          	andi	a5,a5,255
     d98:	4725                	li	a4,9
     d9a:	02f76963          	bltu	a4,a5,dcc <atoi+0x46>
     d9e:	86aa                	mv	a3,a0
  n = 0;
     da0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     da2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     da4:	0685                	addi	a3,a3,1
     da6:	0025179b          	slliw	a5,a0,0x2
     daa:	9fa9                	addw	a5,a5,a0
     dac:	0017979b          	slliw	a5,a5,0x1
     db0:	9fb1                	addw	a5,a5,a2
     db2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     db6:	0006c603          	lbu	a2,0(a3)
     dba:	fd06071b          	addiw	a4,a2,-48
     dbe:	0ff77713          	andi	a4,a4,255
     dc2:	fee5f1e3          	bgeu	a1,a4,da4 <atoi+0x1e>
  return n;
}
     dc6:	6422                	ld	s0,8(sp)
     dc8:	0141                	addi	sp,sp,16
     dca:	8082                	ret
  n = 0;
     dcc:	4501                	li	a0,0
     dce:	bfe5                	j	dc6 <atoi+0x40>

0000000000000dd0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     dd0:	1141                	addi	sp,sp,-16
     dd2:	e422                	sd	s0,8(sp)
     dd4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dd6:	02b57463          	bgeu	a0,a1,dfe <memmove+0x2e>
    while(n-- > 0)
     dda:	00c05f63          	blez	a2,df8 <memmove+0x28>
     dde:	1602                	slli	a2,a2,0x20
     de0:	9201                	srli	a2,a2,0x20
     de2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     de6:	872a                	mv	a4,a0
      *dst++ = *src++;
     de8:	0585                	addi	a1,a1,1
     dea:	0705                	addi	a4,a4,1
     dec:	fff5c683          	lbu	a3,-1(a1)
     df0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     df4:	fee79ae3          	bne	a5,a4,de8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     df8:	6422                	ld	s0,8(sp)
     dfa:	0141                	addi	sp,sp,16
     dfc:	8082                	ret
    dst += n;
     dfe:	00c50733          	add	a4,a0,a2
    src += n;
     e02:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     e04:	fec05ae3          	blez	a2,df8 <memmove+0x28>
     e08:	fff6079b          	addiw	a5,a2,-1
     e0c:	1782                	slli	a5,a5,0x20
     e0e:	9381                	srli	a5,a5,0x20
     e10:	fff7c793          	not	a5,a5
     e14:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     e16:	15fd                	addi	a1,a1,-1
     e18:	177d                	addi	a4,a4,-1
     e1a:	0005c683          	lbu	a3,0(a1)
     e1e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     e22:	fee79ae3          	bne	a5,a4,e16 <memmove+0x46>
     e26:	bfc9                	j	df8 <memmove+0x28>

0000000000000e28 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     e28:	1141                	addi	sp,sp,-16
     e2a:	e422                	sd	s0,8(sp)
     e2c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e2e:	ca05                	beqz	a2,e5e <memcmp+0x36>
     e30:	fff6069b          	addiw	a3,a2,-1
     e34:	1682                	slli	a3,a3,0x20
     e36:	9281                	srli	a3,a3,0x20
     e38:	0685                	addi	a3,a3,1
     e3a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e3c:	00054783          	lbu	a5,0(a0)
     e40:	0005c703          	lbu	a4,0(a1)
     e44:	00e79863          	bne	a5,a4,e54 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e48:	0505                	addi	a0,a0,1
    p2++;
     e4a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     e4c:	fed518e3          	bne	a0,a3,e3c <memcmp+0x14>
  }
  return 0;
     e50:	4501                	li	a0,0
     e52:	a019                	j	e58 <memcmp+0x30>
      return *p1 - *p2;
     e54:	40e7853b          	subw	a0,a5,a4
}
     e58:	6422                	ld	s0,8(sp)
     e5a:	0141                	addi	sp,sp,16
     e5c:	8082                	ret
  return 0;
     e5e:	4501                	li	a0,0
     e60:	bfe5                	j	e58 <memcmp+0x30>

0000000000000e62 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e62:	1141                	addi	sp,sp,-16
     e64:	e406                	sd	ra,8(sp)
     e66:	e022                	sd	s0,0(sp)
     e68:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     e6a:	00000097          	auipc	ra,0x0
     e6e:	f66080e7          	jalr	-154(ra) # dd0 <memmove>
}
     e72:	60a2                	ld	ra,8(sp)
     e74:	6402                	ld	s0,0(sp)
     e76:	0141                	addi	sp,sp,16
     e78:	8082                	ret

0000000000000e7a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e7a:	4885                	li	a7,1
 ecall
     e7c:	00000073          	ecall
 ret
     e80:	8082                	ret

0000000000000e82 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e82:	4889                	li	a7,2
 ecall
     e84:	00000073          	ecall
 ret
     e88:	8082                	ret

0000000000000e8a <wait>:
.global wait
wait:
 li a7, SYS_wait
     e8a:	488d                	li	a7,3
 ecall
     e8c:	00000073          	ecall
 ret
     e90:	8082                	ret

0000000000000e92 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e92:	4891                	li	a7,4
 ecall
     e94:	00000073          	ecall
 ret
     e98:	8082                	ret

0000000000000e9a <read>:
.global read
read:
 li a7, SYS_read
     e9a:	4895                	li	a7,5
 ecall
     e9c:	00000073          	ecall
 ret
     ea0:	8082                	ret

0000000000000ea2 <write>:
.global write
write:
 li a7, SYS_write
     ea2:	48c1                	li	a7,16
 ecall
     ea4:	00000073          	ecall
 ret
     ea8:	8082                	ret

0000000000000eaa <close>:
.global close
close:
 li a7, SYS_close
     eaa:	48d5                	li	a7,21
 ecall
     eac:	00000073          	ecall
 ret
     eb0:	8082                	ret

0000000000000eb2 <kill>:
.global kill
kill:
 li a7, SYS_kill
     eb2:	4899                	li	a7,6
 ecall
     eb4:	00000073          	ecall
 ret
     eb8:	8082                	ret

0000000000000eba <exec>:
.global exec
exec:
 li a7, SYS_exec
     eba:	489d                	li	a7,7
 ecall
     ebc:	00000073          	ecall
 ret
     ec0:	8082                	ret

0000000000000ec2 <open>:
.global open
open:
 li a7, SYS_open
     ec2:	48bd                	li	a7,15
 ecall
     ec4:	00000073          	ecall
 ret
     ec8:	8082                	ret

0000000000000eca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     eca:	48c5                	li	a7,17
 ecall
     ecc:	00000073          	ecall
 ret
     ed0:	8082                	ret

0000000000000ed2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ed2:	48c9                	li	a7,18
 ecall
     ed4:	00000073          	ecall
 ret
     ed8:	8082                	ret

0000000000000eda <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     eda:	48a1                	li	a7,8
 ecall
     edc:	00000073          	ecall
 ret
     ee0:	8082                	ret

0000000000000ee2 <link>:
.global link
link:
 li a7, SYS_link
     ee2:	48cd                	li	a7,19
 ecall
     ee4:	00000073          	ecall
 ret
     ee8:	8082                	ret

0000000000000eea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     eea:	48d1                	li	a7,20
 ecall
     eec:	00000073          	ecall
 ret
     ef0:	8082                	ret

0000000000000ef2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ef2:	48a5                	li	a7,9
 ecall
     ef4:	00000073          	ecall
 ret
     ef8:	8082                	ret

0000000000000efa <dup>:
.global dup
dup:
 li a7, SYS_dup
     efa:	48a9                	li	a7,10
 ecall
     efc:	00000073          	ecall
 ret
     f00:	8082                	ret

0000000000000f02 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     f02:	48ad                	li	a7,11
 ecall
     f04:	00000073          	ecall
 ret
     f08:	8082                	ret

0000000000000f0a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     f0a:	48b1                	li	a7,12
 ecall
     f0c:	00000073          	ecall
 ret
     f10:	8082                	ret

0000000000000f12 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     f12:	48b5                	li	a7,13
 ecall
     f14:	00000073          	ecall
 ret
     f18:	8082                	ret

0000000000000f1a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     f1a:	48b9                	li	a7,14
 ecall
     f1c:	00000073          	ecall
 ret
     f20:	8082                	ret

0000000000000f22 <trace>:
.global trace
trace:
 li a7, SYS_trace
     f22:	48d9                	li	a7,22
 ecall
     f24:	00000073          	ecall
 ret
     f28:	8082                	ret

0000000000000f2a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f2a:	1101                	addi	sp,sp,-32
     f2c:	ec06                	sd	ra,24(sp)
     f2e:	e822                	sd	s0,16(sp)
     f30:	1000                	addi	s0,sp,32
     f32:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f36:	4605                	li	a2,1
     f38:	fef40593          	addi	a1,s0,-17
     f3c:	00000097          	auipc	ra,0x0
     f40:	f66080e7          	jalr	-154(ra) # ea2 <write>
}
     f44:	60e2                	ld	ra,24(sp)
     f46:	6442                	ld	s0,16(sp)
     f48:	6105                	addi	sp,sp,32
     f4a:	8082                	ret

0000000000000f4c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f4c:	7139                	addi	sp,sp,-64
     f4e:	fc06                	sd	ra,56(sp)
     f50:	f822                	sd	s0,48(sp)
     f52:	f426                	sd	s1,40(sp)
     f54:	f04a                	sd	s2,32(sp)
     f56:	ec4e                	sd	s3,24(sp)
     f58:	0080                	addi	s0,sp,64
     f5a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f5c:	c299                	beqz	a3,f62 <printint+0x16>
     f5e:	0805c863          	bltz	a1,fee <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f62:	2581                	sext.w	a1,a1
  neg = 0;
     f64:	4881                	li	a7,0
     f66:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     f6a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f6c:	2601                	sext.w	a2,a2
     f6e:	00000517          	auipc	a0,0x0
     f72:	58a50513          	addi	a0,a0,1418 # 14f8 <digits>
     f76:	883a                	mv	a6,a4
     f78:	2705                	addiw	a4,a4,1
     f7a:	02c5f7bb          	remuw	a5,a1,a2
     f7e:	1782                	slli	a5,a5,0x20
     f80:	9381                	srli	a5,a5,0x20
     f82:	97aa                	add	a5,a5,a0
     f84:	0007c783          	lbu	a5,0(a5)
     f88:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f8c:	0005879b          	sext.w	a5,a1
     f90:	02c5d5bb          	divuw	a1,a1,a2
     f94:	0685                	addi	a3,a3,1
     f96:	fec7f0e3          	bgeu	a5,a2,f76 <printint+0x2a>
  if(neg)
     f9a:	00088b63          	beqz	a7,fb0 <printint+0x64>
    buf[i++] = '-';
     f9e:	fd040793          	addi	a5,s0,-48
     fa2:	973e                	add	a4,a4,a5
     fa4:	02d00793          	li	a5,45
     fa8:	fef70823          	sb	a5,-16(a4)
     fac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     fb0:	02e05863          	blez	a4,fe0 <printint+0x94>
     fb4:	fc040793          	addi	a5,s0,-64
     fb8:	00e78933          	add	s2,a5,a4
     fbc:	fff78993          	addi	s3,a5,-1
     fc0:	99ba                	add	s3,s3,a4
     fc2:	377d                	addiw	a4,a4,-1
     fc4:	1702                	slli	a4,a4,0x20
     fc6:	9301                	srli	a4,a4,0x20
     fc8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fcc:	fff94583          	lbu	a1,-1(s2)
     fd0:	8526                	mv	a0,s1
     fd2:	00000097          	auipc	ra,0x0
     fd6:	f58080e7          	jalr	-168(ra) # f2a <putc>
  while(--i >= 0)
     fda:	197d                	addi	s2,s2,-1
     fdc:	ff3918e3          	bne	s2,s3,fcc <printint+0x80>
}
     fe0:	70e2                	ld	ra,56(sp)
     fe2:	7442                	ld	s0,48(sp)
     fe4:	74a2                	ld	s1,40(sp)
     fe6:	7902                	ld	s2,32(sp)
     fe8:	69e2                	ld	s3,24(sp)
     fea:	6121                	addi	sp,sp,64
     fec:	8082                	ret
    x = -xx;
     fee:	40b005bb          	negw	a1,a1
    neg = 1;
     ff2:	4885                	li	a7,1
    x = -xx;
     ff4:	bf8d                	j	f66 <printint+0x1a>

0000000000000ff6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ff6:	7119                	addi	sp,sp,-128
     ff8:	fc86                	sd	ra,120(sp)
     ffa:	f8a2                	sd	s0,112(sp)
     ffc:	f4a6                	sd	s1,104(sp)
     ffe:	f0ca                	sd	s2,96(sp)
    1000:	ecce                	sd	s3,88(sp)
    1002:	e8d2                	sd	s4,80(sp)
    1004:	e4d6                	sd	s5,72(sp)
    1006:	e0da                	sd	s6,64(sp)
    1008:	fc5e                	sd	s7,56(sp)
    100a:	f862                	sd	s8,48(sp)
    100c:	f466                	sd	s9,40(sp)
    100e:	f06a                	sd	s10,32(sp)
    1010:	ec6e                	sd	s11,24(sp)
    1012:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1014:	0005c903          	lbu	s2,0(a1)
    1018:	18090f63          	beqz	s2,11b6 <vprintf+0x1c0>
    101c:	8aaa                	mv	s5,a0
    101e:	8b32                	mv	s6,a2
    1020:	00158493          	addi	s1,a1,1
  state = 0;
    1024:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1026:	02500a13          	li	s4,37
      if(c == 'd'){
    102a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    102e:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    1032:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    1036:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    103a:	00000b97          	auipc	s7,0x0
    103e:	4beb8b93          	addi	s7,s7,1214 # 14f8 <digits>
    1042:	a839                	j	1060 <vprintf+0x6a>
        putc(fd, c);
    1044:	85ca                	mv	a1,s2
    1046:	8556                	mv	a0,s5
    1048:	00000097          	auipc	ra,0x0
    104c:	ee2080e7          	jalr	-286(ra) # f2a <putc>
    1050:	a019                	j	1056 <vprintf+0x60>
    } else if(state == '%'){
    1052:	01498f63          	beq	s3,s4,1070 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    1056:	0485                	addi	s1,s1,1
    1058:	fff4c903          	lbu	s2,-1(s1)
    105c:	14090d63          	beqz	s2,11b6 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    1060:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1064:	fe0997e3          	bnez	s3,1052 <vprintf+0x5c>
      if(c == '%'){
    1068:	fd479ee3          	bne	a5,s4,1044 <vprintf+0x4e>
        state = '%';
    106c:	89be                	mv	s3,a5
    106e:	b7e5                	j	1056 <vprintf+0x60>
      if(c == 'd'){
    1070:	05878063          	beq	a5,s8,10b0 <vprintf+0xba>
      } else if(c == 'l') {
    1074:	05978c63          	beq	a5,s9,10cc <vprintf+0xd6>
      } else if(c == 'x') {
    1078:	07a78863          	beq	a5,s10,10e8 <vprintf+0xf2>
      } else if(c == 'p') {
    107c:	09b78463          	beq	a5,s11,1104 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    1080:	07300713          	li	a4,115
    1084:	0ce78663          	beq	a5,a4,1150 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1088:	06300713          	li	a4,99
    108c:	0ee78e63          	beq	a5,a4,1188 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    1090:	11478863          	beq	a5,s4,11a0 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1094:	85d2                	mv	a1,s4
    1096:	8556                	mv	a0,s5
    1098:	00000097          	auipc	ra,0x0
    109c:	e92080e7          	jalr	-366(ra) # f2a <putc>
        putc(fd, c);
    10a0:	85ca                	mv	a1,s2
    10a2:	8556                	mv	a0,s5
    10a4:	00000097          	auipc	ra,0x0
    10a8:	e86080e7          	jalr	-378(ra) # f2a <putc>
      }
      state = 0;
    10ac:	4981                	li	s3,0
    10ae:	b765                	j	1056 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    10b0:	008b0913          	addi	s2,s6,8
    10b4:	4685                	li	a3,1
    10b6:	4629                	li	a2,10
    10b8:	000b2583          	lw	a1,0(s6)
    10bc:	8556                	mv	a0,s5
    10be:	00000097          	auipc	ra,0x0
    10c2:	e8e080e7          	jalr	-370(ra) # f4c <printint>
    10c6:	8b4a                	mv	s6,s2
      state = 0;
    10c8:	4981                	li	s3,0
    10ca:	b771                	j	1056 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    10cc:	008b0913          	addi	s2,s6,8
    10d0:	4681                	li	a3,0
    10d2:	4629                	li	a2,10
    10d4:	000b2583          	lw	a1,0(s6)
    10d8:	8556                	mv	a0,s5
    10da:	00000097          	auipc	ra,0x0
    10de:	e72080e7          	jalr	-398(ra) # f4c <printint>
    10e2:	8b4a                	mv	s6,s2
      state = 0;
    10e4:	4981                	li	s3,0
    10e6:	bf85                	j	1056 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    10e8:	008b0913          	addi	s2,s6,8
    10ec:	4681                	li	a3,0
    10ee:	4641                	li	a2,16
    10f0:	000b2583          	lw	a1,0(s6)
    10f4:	8556                	mv	a0,s5
    10f6:	00000097          	auipc	ra,0x0
    10fa:	e56080e7          	jalr	-426(ra) # f4c <printint>
    10fe:	8b4a                	mv	s6,s2
      state = 0;
    1100:	4981                	li	s3,0
    1102:	bf91                	j	1056 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    1104:	008b0793          	addi	a5,s6,8
    1108:	f8f43423          	sd	a5,-120(s0)
    110c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    1110:	03000593          	li	a1,48
    1114:	8556                	mv	a0,s5
    1116:	00000097          	auipc	ra,0x0
    111a:	e14080e7          	jalr	-492(ra) # f2a <putc>
  putc(fd, 'x');
    111e:	85ea                	mv	a1,s10
    1120:	8556                	mv	a0,s5
    1122:	00000097          	auipc	ra,0x0
    1126:	e08080e7          	jalr	-504(ra) # f2a <putc>
    112a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    112c:	03c9d793          	srli	a5,s3,0x3c
    1130:	97de                	add	a5,a5,s7
    1132:	0007c583          	lbu	a1,0(a5)
    1136:	8556                	mv	a0,s5
    1138:	00000097          	auipc	ra,0x0
    113c:	df2080e7          	jalr	-526(ra) # f2a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1140:	0992                	slli	s3,s3,0x4
    1142:	397d                	addiw	s2,s2,-1
    1144:	fe0914e3          	bnez	s2,112c <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    1148:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    114c:	4981                	li	s3,0
    114e:	b721                	j	1056 <vprintf+0x60>
        s = va_arg(ap, char*);
    1150:	008b0993          	addi	s3,s6,8
    1154:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    1158:	02090163          	beqz	s2,117a <vprintf+0x184>
        while(*s != 0){
    115c:	00094583          	lbu	a1,0(s2)
    1160:	c9a1                	beqz	a1,11b0 <vprintf+0x1ba>
          putc(fd, *s);
    1162:	8556                	mv	a0,s5
    1164:	00000097          	auipc	ra,0x0
    1168:	dc6080e7          	jalr	-570(ra) # f2a <putc>
          s++;
    116c:	0905                	addi	s2,s2,1
        while(*s != 0){
    116e:	00094583          	lbu	a1,0(s2)
    1172:	f9e5                	bnez	a1,1162 <vprintf+0x16c>
        s = va_arg(ap, char*);
    1174:	8b4e                	mv	s6,s3
      state = 0;
    1176:	4981                	li	s3,0
    1178:	bdf9                	j	1056 <vprintf+0x60>
          s = "(null)";
    117a:	00000917          	auipc	s2,0x0
    117e:	37690913          	addi	s2,s2,886 # 14f0 <malloc+0x230>
        while(*s != 0){
    1182:	02800593          	li	a1,40
    1186:	bff1                	j	1162 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    1188:	008b0913          	addi	s2,s6,8
    118c:	000b4583          	lbu	a1,0(s6)
    1190:	8556                	mv	a0,s5
    1192:	00000097          	auipc	ra,0x0
    1196:	d98080e7          	jalr	-616(ra) # f2a <putc>
    119a:	8b4a                	mv	s6,s2
      state = 0;
    119c:	4981                	li	s3,0
    119e:	bd65                	j	1056 <vprintf+0x60>
        putc(fd, c);
    11a0:	85d2                	mv	a1,s4
    11a2:	8556                	mv	a0,s5
    11a4:	00000097          	auipc	ra,0x0
    11a8:	d86080e7          	jalr	-634(ra) # f2a <putc>
      state = 0;
    11ac:	4981                	li	s3,0
    11ae:	b565                	j	1056 <vprintf+0x60>
        s = va_arg(ap, char*);
    11b0:	8b4e                	mv	s6,s3
      state = 0;
    11b2:	4981                	li	s3,0
    11b4:	b54d                	j	1056 <vprintf+0x60>
    }
  }
}
    11b6:	70e6                	ld	ra,120(sp)
    11b8:	7446                	ld	s0,112(sp)
    11ba:	74a6                	ld	s1,104(sp)
    11bc:	7906                	ld	s2,96(sp)
    11be:	69e6                	ld	s3,88(sp)
    11c0:	6a46                	ld	s4,80(sp)
    11c2:	6aa6                	ld	s5,72(sp)
    11c4:	6b06                	ld	s6,64(sp)
    11c6:	7be2                	ld	s7,56(sp)
    11c8:	7c42                	ld	s8,48(sp)
    11ca:	7ca2                	ld	s9,40(sp)
    11cc:	7d02                	ld	s10,32(sp)
    11ce:	6de2                	ld	s11,24(sp)
    11d0:	6109                	addi	sp,sp,128
    11d2:	8082                	ret

00000000000011d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11d4:	715d                	addi	sp,sp,-80
    11d6:	ec06                	sd	ra,24(sp)
    11d8:	e822                	sd	s0,16(sp)
    11da:	1000                	addi	s0,sp,32
    11dc:	e010                	sd	a2,0(s0)
    11de:	e414                	sd	a3,8(s0)
    11e0:	e818                	sd	a4,16(s0)
    11e2:	ec1c                	sd	a5,24(s0)
    11e4:	03043023          	sd	a6,32(s0)
    11e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11f0:	8622                	mv	a2,s0
    11f2:	00000097          	auipc	ra,0x0
    11f6:	e04080e7          	jalr	-508(ra) # ff6 <vprintf>
}
    11fa:	60e2                	ld	ra,24(sp)
    11fc:	6442                	ld	s0,16(sp)
    11fe:	6161                	addi	sp,sp,80
    1200:	8082                	ret

0000000000001202 <printf>:

void
printf(const char *fmt, ...)
{
    1202:	711d                	addi	sp,sp,-96
    1204:	ec06                	sd	ra,24(sp)
    1206:	e822                	sd	s0,16(sp)
    1208:	1000                	addi	s0,sp,32
    120a:	e40c                	sd	a1,8(s0)
    120c:	e810                	sd	a2,16(s0)
    120e:	ec14                	sd	a3,24(s0)
    1210:	f018                	sd	a4,32(s0)
    1212:	f41c                	sd	a5,40(s0)
    1214:	03043823          	sd	a6,48(s0)
    1218:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    121c:	00840613          	addi	a2,s0,8
    1220:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1224:	85aa                	mv	a1,a0
    1226:	4505                	li	a0,1
    1228:	00000097          	auipc	ra,0x0
    122c:	dce080e7          	jalr	-562(ra) # ff6 <vprintf>
}
    1230:	60e2                	ld	ra,24(sp)
    1232:	6442                	ld	s0,16(sp)
    1234:	6125                	addi	sp,sp,96
    1236:	8082                	ret

0000000000001238 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1238:	1141                	addi	sp,sp,-16
    123a:	e422                	sd	s0,8(sp)
    123c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    123e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1242:	00000797          	auipc	a5,0x0
    1246:	2de7b783          	ld	a5,734(a5) # 1520 <freep>
    124a:	a805                	j	127a <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    124c:	4618                	lw	a4,8(a2)
    124e:	9db9                	addw	a1,a1,a4
    1250:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1254:	6398                	ld	a4,0(a5)
    1256:	6318                	ld	a4,0(a4)
    1258:	fee53823          	sd	a4,-16(a0)
    125c:	a091                	j	12a0 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    125e:	ff852703          	lw	a4,-8(a0)
    1262:	9e39                	addw	a2,a2,a4
    1264:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1266:	ff053703          	ld	a4,-16(a0)
    126a:	e398                	sd	a4,0(a5)
    126c:	a099                	j	12b2 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    126e:	6398                	ld	a4,0(a5)
    1270:	00e7e463          	bltu	a5,a4,1278 <free+0x40>
    1274:	00e6ea63          	bltu	a3,a4,1288 <free+0x50>
{
    1278:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    127a:	fed7fae3          	bgeu	a5,a3,126e <free+0x36>
    127e:	6398                	ld	a4,0(a5)
    1280:	00e6e463          	bltu	a3,a4,1288 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1284:	fee7eae3          	bltu	a5,a4,1278 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1288:	ff852583          	lw	a1,-8(a0)
    128c:	6390                	ld	a2,0(a5)
    128e:	02059813          	slli	a6,a1,0x20
    1292:	01c85713          	srli	a4,a6,0x1c
    1296:	9736                	add	a4,a4,a3
    1298:	fae60ae3          	beq	a2,a4,124c <free+0x14>
    bp->s.ptr = p->s.ptr;
    129c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    12a0:	4790                	lw	a2,8(a5)
    12a2:	02061593          	slli	a1,a2,0x20
    12a6:	01c5d713          	srli	a4,a1,0x1c
    12aa:	973e                	add	a4,a4,a5
    12ac:	fae689e3          	beq	a3,a4,125e <free+0x26>
  } else
    p->s.ptr = bp;
    12b0:	e394                	sd	a3,0(a5)
  freep = p;
    12b2:	00000717          	auipc	a4,0x0
    12b6:	26f73723          	sd	a5,622(a4) # 1520 <freep>
}
    12ba:	6422                	ld	s0,8(sp)
    12bc:	0141                	addi	sp,sp,16
    12be:	8082                	ret

00000000000012c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    12c0:	7139                	addi	sp,sp,-64
    12c2:	fc06                	sd	ra,56(sp)
    12c4:	f822                	sd	s0,48(sp)
    12c6:	f426                	sd	s1,40(sp)
    12c8:	f04a                	sd	s2,32(sp)
    12ca:	ec4e                	sd	s3,24(sp)
    12cc:	e852                	sd	s4,16(sp)
    12ce:	e456                	sd	s5,8(sp)
    12d0:	e05a                	sd	s6,0(sp)
    12d2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12d4:	02051493          	slli	s1,a0,0x20
    12d8:	9081                	srli	s1,s1,0x20
    12da:	04bd                	addi	s1,s1,15
    12dc:	8091                	srli	s1,s1,0x4
    12de:	0014899b          	addiw	s3,s1,1
    12e2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    12e4:	00000517          	auipc	a0,0x0
    12e8:	23c53503          	ld	a0,572(a0) # 1520 <freep>
    12ec:	c515                	beqz	a0,1318 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ee:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12f0:	4798                	lw	a4,8(a5)
    12f2:	02977f63          	bgeu	a4,s1,1330 <malloc+0x70>
    12f6:	8a4e                	mv	s4,s3
    12f8:	0009871b          	sext.w	a4,s3
    12fc:	6685                	lui	a3,0x1
    12fe:	00d77363          	bgeu	a4,a3,1304 <malloc+0x44>
    1302:	6a05                	lui	s4,0x1
    1304:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1308:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    130c:	00000917          	auipc	s2,0x0
    1310:	21490913          	addi	s2,s2,532 # 1520 <freep>
  if(p == (char*)-1)
    1314:	5afd                	li	s5,-1
    1316:	a895                	j	138a <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
    1318:	00000797          	auipc	a5,0x0
    131c:	27878793          	addi	a5,a5,632 # 1590 <base>
    1320:	00000717          	auipc	a4,0x0
    1324:	20f73023          	sd	a5,512(a4) # 1520 <freep>
    1328:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    132a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    132e:	b7e1                	j	12f6 <malloc+0x36>
      if(p->s.size == nunits)
    1330:	02e48c63          	beq	s1,a4,1368 <malloc+0xa8>
        p->s.size -= nunits;
    1334:	4137073b          	subw	a4,a4,s3
    1338:	c798                	sw	a4,8(a5)
        p += p->s.size;
    133a:	02071693          	slli	a3,a4,0x20
    133e:	01c6d713          	srli	a4,a3,0x1c
    1342:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1344:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1348:	00000717          	auipc	a4,0x0
    134c:	1ca73c23          	sd	a0,472(a4) # 1520 <freep>
      return (void*)(p + 1);
    1350:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1354:	70e2                	ld	ra,56(sp)
    1356:	7442                	ld	s0,48(sp)
    1358:	74a2                	ld	s1,40(sp)
    135a:	7902                	ld	s2,32(sp)
    135c:	69e2                	ld	s3,24(sp)
    135e:	6a42                	ld	s4,16(sp)
    1360:	6aa2                	ld	s5,8(sp)
    1362:	6b02                	ld	s6,0(sp)
    1364:	6121                	addi	sp,sp,64
    1366:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1368:	6398                	ld	a4,0(a5)
    136a:	e118                	sd	a4,0(a0)
    136c:	bff1                	j	1348 <malloc+0x88>
  hp->s.size = nu;
    136e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1372:	0541                	addi	a0,a0,16
    1374:	00000097          	auipc	ra,0x0
    1378:	ec4080e7          	jalr	-316(ra) # 1238 <free>
  return freep;
    137c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1380:	d971                	beqz	a0,1354 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1382:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1384:	4798                	lw	a4,8(a5)
    1386:	fa9775e3          	bgeu	a4,s1,1330 <malloc+0x70>
    if(p == freep)
    138a:	00093703          	ld	a4,0(s2)
    138e:	853e                	mv	a0,a5
    1390:	fef719e3          	bne	a4,a5,1382 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
    1394:	8552                	mv	a0,s4
    1396:	00000097          	auipc	ra,0x0
    139a:	b74080e7          	jalr	-1164(ra) # f0a <sbrk>
  if(p == (char*)-1)
    139e:	fd5518e3          	bne	a0,s5,136e <malloc+0xae>
        return 0;
    13a2:	4501                	li	a0,0
    13a4:	bf45                	j	1354 <malloc+0x94>
