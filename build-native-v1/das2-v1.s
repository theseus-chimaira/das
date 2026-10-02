	.text

das_native_diag:
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	movei	1,077777
	andb	1,010
	movei	1,2
	movei	2,0104
	pushj	17,dsys_writechar
	jumpge	1,%L2
	seto	1,
	jrst	%L1
%L2:
	movei	1,014
	movem	1,-1(17)
%L3:
	move	2,010
	movn	3,-1(17)
	lsh	2,0(3)
	andi	2,7
	addi	2,060
	movei	1,2
	pushj	17,dsys_writechar
	movem	1,0(17)
	skipl	3,1
	 skipn	6,-1(17)
	 jrst	%L4
	subi	6,3
	movem	6,-1(17)
	jrst	%L3
%L4:
	skipge	2,0(17)
	 jrst	%L5
	movei	1,2
	movei	2,012
	pushj	17,dsys_writechar
	movem	1,0(17)
%L5:
	move	1,0(17)
%L1:
	move	10,-2(17)
	SUB	17,[3,,3]
	popj	17,

	.data

das_native_stderr:
	.word 2
	.word 0
	.word 1

	.text

das_native_is_space:
	move	2,1
	movei	3,040
	camn	2,3
	 jrst	%L7
	move	4,1
	cain	4,011
	 jrst	%L7
	move	5,1
	cain	5,012
	 jrst	%L7
	move	6,1
	cain	6,015
	 jrst	%L7
	move	7,1
	movei	2,014
	came	7,2
	 skipa	2,1
	 trna	
	 cain	2,013
%L7:
	 skipa	1,[1]
	 setz	1,
	popj	17,

das_native_is_alpha:
	move	2,1
	movei	3,0101
	caml	2,3
	 skipa	4,1
	 trna	
	 caile	4,0132
	 tdza	1,1
	 movei	1,1
	popj	17,

das_native_is_digit:
	move	2,1
	movei	3,060
	caml	2,3
	 skipa	4,1
	 trna	
	 caile	4,071
	 tdza	1,1
	 movei	1,1
	popj	17,

das_native_is_alnum:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,das_native_is_alpha
	jumpn	1,%L14
	move	1,010
	pushj	17,das_native_is_digit
	caie	1,0
%L14:
	 skipa	1,[1]
	 setz	1,
%L12:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

strlen:
	push	17,016
	push	17,010
	move	10,1
	push	17,[0]
%L16:
	move	3,0(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,3
	jumpe	1,%L17
	aos	2,0(17)
	jrst	%L16
%L17:
	move	1,0(17)
%L15:
	move	10,-1(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,

strcmp:
%L18:
	move	3,1
	ldb	4,3
	jumpe	4,%L19
	move	5,1
	ldb	6,5
	move	7,2
	ldb	3,7
	came	6,3
	 jrst	%L19
	ibp	1
	ibp	2
	jrst	%L18
%L19:
	move	3,1
	ldb	1,3
	andi	1,0777
	move	5,2
	ldb	6,5
	andi	6,0777
	sub	1,6
	popj	17,

memset:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
	move	1,010
	push	17,1
	hlrz	2,1
	lsh	2,-6
	andi	2,077
	caie	2,011
	 jrst	%L21
	jrst	%L22
%L21:
	skipe	1,0(17)
	 hrli	1,0331100
	movem	1,0(17)
%L22:
	pop	17,1
	movem	1,0(17)
%L23:
	skipn	1,012
	 jrst	%L24
	move	2,011
	andi	2,0777
	move	4,0(17)
	ibp	0(17)
	dpb	2,4
	soja	12,%L23
%L24:
	move	1,010
%L20:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

das_native_memcpy:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,010
	push	17,1
	hlrz	2,1
	lsh	2,-6
	andi	2,077
	caie	2,011
	 jrst	%L26
	jrst	%L27
%L26:
	skipe	1,0(17)
	 hrli	1,0331100
	movem	1,0(17)
%L27:
	pop	17,1
	movem	1,-1(17)
	move	2,011
	push	17,2
	hlrz	3,2
	lsh	3,-6
	andi	3,077
	caie	3,011
	 jrst	%L28
	jrst	%L29
%L28:
	skipe	1,0(17)
	 hrli	1,0331100
	movem	1,0(17)
%L29:
	pop	17,1
	movem	1,0(17)
%L30:
	skipn	1,012
	 jrst	%L31
	move	3,0(17)
	ibp	0(17)
	ldb	1,3
	move	3,-1(17)
	ibp	-1(17)
	dpb	1,3
	soja	12,%L30
%L31:
	move	1,010
%L25:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

memmove:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,010
	push	17,1
	hlrz	2,1
	lsh	2,-6
	andi	2,077
	caie	2,011
	 jrst	%L33
	jrst	%L34
%L33:
	skipe	1,0(17)
	 hrli	1,0331100
	movem	1,0(17)
%L34:
	pop	17,1
	movem	1,-1(17)
	move	2,011
	push	17,2
	hlrz	3,2
	lsh	3,-6
	andi	3,077
	caie	3,011
	 jrst	%L35
	jrst	%L36
%L35:
	skipe	1,0(17)
	 hrli	1,0331100
	movem	1,0(17)
%L36:
	pop	17,1
	movem	1,0(17)
	skipl	3,-1(17)
	 tlc	3,0770000
	rot	3,6
	skipl	4,0(17)
	 tlc	4,0770000
	rot	4,6
	caml	3,4
	 jrst	%L38
%L39:
	move	1,012
	jumpe	1,%L37
	move	3,0(17)
	ibp	0(17)
	ldb	1,3
	move	3,-1(17)
	ibp	-1(17)
	dpb	1,3
	soja	12,%L39
	jrst	%L37
%L38:
	skipl	2,-1(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,0(17)
	 tlc	3,0770000
	rot	3,6
	camg	2,3
	 jrst	%L37
	move	1,012
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	movem	1,-1(17)
	move	4,012
	PUSH	17,1
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	4,0(17)
%L40:
	skipn	1,012
	 jrst	%L37
	seto	2,
	PUSH	17,1
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,0(17)
	ldb	1,2
	seto	2,
	PUSH	17,1
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,-1(17)
	dpb	1,2
	soja	12,%L40
%L37:
	move	1,010
%L32:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	popj	17,

strchr:
%L41:
	move	3,1
	ldb	4,3
	jumpe	4,%L42
	move	5,1
	ldb	6,5
	andi	6,0777
	move	7,2
	andi	7,0777
	camn	6,7
	 popj	17,
	ibp	1
	jrst	%L41
%L42:
	skipe	3,2
	 jrst	%L44
	move	4,1
	jrst	%L45
%L44:
	setz	3,
	move	1,3
%L45:
	popj	17,

strrchr:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,[0]
%L47:
	move	1,010
	ldb	2,1
	andi	2,0777
	move	3,011
	andi	3,0777
	camn	2,3
	 skipa	4,010
	 trna	
	 movem	4,0(17)
	move	5,010
	ibp	010
	ldb	6,5
	jumpn	6,%L47
	move	1,0(17)
%L46:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

strstr:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	move	1,011
	ldb	2,1
	jumpn	2,%L51
	move	1,010
	jrst	%L50
%L51:
%L52:
	move	1,010
	ldb	2,1
	jumpe	2,%L53
	movem	10,-1(17)
	movem	11,0(17)
%L54:
	ldb	3,-1(17)
	jumpe	3,%L55
	ldb	1,0(17)
	jumpe	1,%L55
	came	3,1
	 jrst	%L55
	ibp	-1(17)
	move	2,-1(17)
	ibp	0(17)
	move	1,0(17)
	jrst	%L54
%L55:
	ldb	1,0(17)
	jumpn	1,%L56
	move	1,010
	jrst	%L50
%L56:
	ibp	010
	jrst	%L52
%L53:
	setz	1,
%L50:
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	popj	17,

strtol:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
%L58:
	move	1,010
	ldb	1,1
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L59
	ibp	010
	jrst	%L58
%L59:
	setz	1,
	movem	1,-2(17)
	move	2,010
	ldb	3,2
	cain	3,053
	 jrst	%L61
	move	4,010
	ldb	5,4
	caie	5,055
	 jrst	%L60
%L61:
	move	1,010
	ldb	2,1
	caie	2,055
	 tdza	3,3
	 movei	3,1
	movem	3,-2(17)
	ibp	010
%L60:
	skipe	1,012
	 jrst	%L64
	move	2,010
	ldb	3,2
	movei	4,060
	came	3,4
	 jrst	%L65
	movei	6,1
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	5,6
	cain	5,0170
	 jrst	%L66
	movei	1,1
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	7,1
	caie	7,0130
	 jrst	%L65
%L66:
	movei	1,020
	move	12,1
	movei	2,2
	move	3,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	3,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	10,2
	jrst	%L64
%L65:
	move	1,010
	ldb	2,1
	caie	2,060
	 jrst	%L67
	movei	3,010
	move	12,3
	jrst	%L64
%L67:
	movei	1,012
	move	12,1
%L64:
	setz	1,
	movem	1,-1(17)
%L68:
	move	1,010
	ldb	2,1
	caige	2,060
	 jrst	%L71
	move	3,010
	ldb	4,3
	caile	4,071
	 jrst	%L71
	move	5,010
	ldb	6,5
	subi	6,060
	movem	6,0(17)
	jrst	%L70
%L71:
	move	1,010
	ldb	2,1
	caige	2,0101
	 jrst	%L72
	move	3,010
	ldb	4,3
	caile	4,0106
	 jrst	%L72
	move	5,010
	ldb	6,5
	subi	6,067
	movem	6,0(17)
	jrst	%L70
%L72:
	move	1,010
	ldb	2,1
	caige	2,0141
	 jrst	%L69
	move	3,010
	ldb	4,3
	caile	4,0146
	 jrst	%L69
	move	5,010
	ldb	6,5
	subi	6,0127
	movem	6,0(17)
%L70:
	move	2,0(17)
	caml	2,012
	 jrst	%L69
	move	3,012
	mul	3,-1(17)
	trne	3,1
	 tloa	4,0400000
	 tlz	4,0400000
	add	4,0(17)
	movem	4,-1(17)
	ibp	010
	jrst	%L68
%L69:
	skipe	1,011
	 skipa	2,010
	 trna	
	 movem	2,0(11)
	skipn	4,-2(17)
	 jrst	%L74
	movn	1,-1(17)
	jrst	%L75
%L74:
	move	1,-1(17)
%L75:
%L57:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

das_native_pack_path:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[5,,5]
	setzb	1,0(17)
%L77:
	move	4,011
	add	4,0(17)
	setzb	1,0(4)
	aos	5,0(17)
	tlc	5,0400000
	camge	5,[0400000000022]
	 jrst	%L77
	setz	2,
	movem	2,-4(17)
%L80:
	move	1,010
	ldb	2,1
	jumpe	2,%L81
	move	3,010
	ibp	010
	ldb	6,3
	andi	6,0777
	movem	6,-1(17)
	tlc	6,0400000
	camge	6,[0400000000141]
	 jrst	%L82
	move	5,-1(17)
	tlc	5,0400000
	camle	5,[0400000000172]
	 jrst	%L82
	move	7,-1(17)
	subi	7,040
	movem	7,-1(17)
%L82:
	move	2,-1(17)
	tlc	2,0400000
	camge	2,[0400000000040]
	 jrst	%L84
	move	3,-1(17)
	tlc	3,0400000
	camle	3,[0400000000137]
	 jrst	%L84
	move	4,-4(17)
	tlc	4,0400000
	camge	4,[0400000000146]
	 jrst	%L83
%L84:
	movei	1,1
	jrst	%L76
%L83:
	move	2,-4(17)
	SKIPL	3,2
	 TDZA	2,2
	  MOVEI	2,1
	DIVI	2,6
	addi	2,1
	movem	2,-3(17)
	movem	3,-2(17)
	move	1,-1(17)
	subi	1,040
	andi	1,077
	movem	1,-1(17)
	move	6,3
	muli	6,6
	trne	6,1
	 tloa	7,0400000
	 tlz	7,0400000
	movn	7,7
	lsh	1,036(7)
	move	2,011
	add	2,-3(17)
	iorb	1,0(2)
	aos	4,-4(17)
	jrst	%L80
%L81:
	skipe	2,-4(17)
	 jrst	%L85
	movei	1,1
	jrst	%L76
%L85:
	move	2,-4(17)
	movem	2,0(11)
	setz	1,
%L76:
	move	10,-6(17)
	move	11,-5(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

das_native_alloc_file:
	push	17,010
	move	10,1
	push	17,[0]
%L87:
	move	6,0(17)
	imuli	6,3
	skipe	1,das_native_files+2(6)
	 jrst	%L89
	movem	10,das_native_files(6)
	setm	3,1
	move	1,0(17)
	imuli	1,3
	movem	3,das_native_files+1(1)
	movei	4,1
	movem	4,das_native_files+2(1)
	movei	1,das_native_files(1)
	jrst	%L86
%L89:
	aos	3,0(17)
	tlc	3,0400000
	camge	3,[0400000000014]
	 jrst	%L87
	setz	1,
%L86:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

fopen:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[025,,025]
	movei	2,-024(17)
	move	1,010
	pushj	17,das_native_pack_path
	jumpe	1,%L91
	setz	1,
	jrst	%L90
%L91:
	setz	1,
	movem	1,-2(17)
	move	2,011
	ldb	3,2
	caie	3,0167
	 jrst	%L93
	movei	4,031
	movem	4,-2(17)
	jrst	%L92
%L93:
	move	1,011
	ldb	2,1
	caie	2,0162
	 jrst	%L92
	move	1,011
	movei	2,053
	pushj	17,strchr
	jumpe	1,%L92
	movei	2,2
	movem	2,-2(17)
%L92:
	move	1,011
	ldb	2,1
	caie	2,0167
	 jrst	%L94
	move	1,011
	movei	2,053
	pushj	17,strchr
	jumpe	1,%L94
	movei	2,032
	movem	2,-2(17)
%L94:
	move	2,-2(17)
	movei	1,-024(17)
	pushj	17,dsys_open
	movem	1,-1(17)
	skipl	3,1
	 jrst	%L95
	setz	1,
	jrst	%L90
%L95:
	move	1,-1(17)
	pushj	17,das_native_alloc_file
	movem	1,0(17)
	skipe	3,1
	 jrst	%L96
	move	1,-1(17)
	pushj	17,dsys_close
	setz	1,
	jrst	%L90
%L96:
	move	1,0(17)
%L90:
	move	10,-026(17)
	move	11,-025(17)
	SUB	17,[027,,027]
	popj	17,

fclose:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	skipe	1,010
	 skipa	3,2(10)
	 trna	
	 jumpn	3,%L98
	seto	1,
	jrst	%L97
%L98:
	move	2,0(10)
	move	1,2
	pushj	17,dsys_close
	movem	1,0(17)
	setz	2,
	movem	2,2(10)
	skipl	4,1
	 jrst	%L100
	movei	3,1
	movem	3,1(10)
	seto	1,
	jrst	%L97
%L100:
	setz	1,
%L97:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

fseek:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
	move	1,012
	move	2,011
	move	4,0(10)
	move	3,1
	move	1,4
	pushj	17,dsys_seek
	movem	1,0(17)
	aojn	1,%L102
	movei	2,1
	movem	2,1(10)
	seto	1,
	jrst	%L101
%L102:
	setz	1,
%L101:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

remove:
	push	17,010
	move	10,1
	ADD	17,[022,,022]
	movei	2,-021(17)
	move	1,010
	pushj	17,das_native_pack_path
	jumpe	1,%L104
	seto	1,
	jrst	%L103
%L104:
	movei	1,-021(17)
	pushj	17,dsys_unlink
	jumpge	1,%L105
	seto	1,
	jrst	%L106
%L105:
	setz	1,
%L106:
%L103:
	move	10,-022(17)
	SUB	17,[023,,023]
	popj	17,

das_op_mn:
	.word 010404
	.word 011604
	.word 011712
	.word 011723
	.word 012310
	.word 021424
	.word 030111
	.word 030115
	.word 040616
	.word 041126
	.word 042002
	.word 052126
	.word 060104
	.word 060426
	.word 061130
	.word 061520
	.word 062302
	.word 062303
	.word 0101414
	.word 0101422
	.word 0102214
	.word 0102222
	.word 0110220
	.word 0111722
	.word 0122201
	.word 0122301
	.word 0122320
	.word 0122322
	.word 0140402
	.word 0142310
	.word 0150120
	.word 0152514
	.word 0172202
	.word 0172211
	.word 0172215
	.word 0201720
	.word 0221724
	.word 0231712
	.word 0231723
	.word 0232502
	.word 0240403
	.word 0240416
	.word 0240417
	.word 0240432
	.word 0241403
	.word 0241416
	.word 0241417
	.word 0241432
	.word 0242203
	.word 0242216
	.word 0242217
	.word 0242232
	.word 0242303
	.word 0242316
	.word 0242317
	.word 0242332
	.word 0250601
	.word 0300324
	.word 0301722
	.word 01040402
	.word 01040411
	.word 01040415
	.word 01160402
	.word 01160411
	.word 01160415
	.word 01171201
	.word 01171205
	.word 01171207
	.word 01171214
	.word 01171216
	.word 01172301
	.word 01172305
	.word 01172307
	.word 01172314
	.word 01172316
	.word 01231003
	.word 03011101
	.word 03011105
	.word 03011107
	.word 03011114
	.word 03011116
	.word 03011501
	.word 03011505
	.word 03011507
	.word 03011514
	.word 03011516
	.word 04010404
	.word 04041126
	.word 04060104
	.word 04060426
	.word 04061520
	.word 04062302
	.word 04112602
	.word 04112611
	.word 04112615
	.word 04152514
	.word 04232502
	.word 05212602
	.word 05212611
	.word 05212615
	.word 05300310
	.word 06010402
	.word 06010414
	.word 06010415
	.word 06010422
	.word 06042602
	.word 06042614
	.word 06042615
	.word 06042622
	.word 06113022
	.word 06142422
	.word 06152002
	.word 06152014
	.word 06152015
	.word 06152022
	.word 06230202
	.word 06230214
	.word 06230215
	.word 06230222
	.word 010011424
	.word 010141405
	.word 010141411
	.word 010141415
	.word 010141417
	.word 010141423
	.word 010141432
	.word 010142205
	.word 010142211
	.word 010142215
	.word 010142217
	.word 010142223
	.word 010142232
	.word 010221405
	.word 010221411
	.word 010221415
	.word 010221417
	.word 010221423
	.word 010221432
	.word 010222205
	.word 010222211
	.word 010222215
	.word 010222217
	.word 010222223
	.word 010222232
	.word 011041126
	.word 011042002
	.word 011140402
	.word 011152514
	.word 011172202
	.word 011172211
	.word 011172215
	.word 012060314
	.word 012060617
	.word 012222324
	.word 012251520
	.word 014231003
	.word 015172605
	.word 015172615
	.word 015172616
	.word 015172623
	.word 015251402
	.word 015251411
	.word 015251415
	.word 017220301
	.word 017220302
	.word 017220315
	.word 020172012
	.word 020252310
	.word 022172403
	.word 023052401
	.word 023052415
	.word 023052417
	.word 023052432
	.word 023131120
	.word 023171201
	.word 023171205
	.word 023171207
	.word 023171214
	.word 023171216
	.word 023172301
	.word 023172305
	.word 023172307
	.word 023172314
	.word 023172316
	.word 023250202
	.word 023250211
	.word 023250215
	.word 024040301
	.word 024040305
	.word 024040316
	.word 024041601
	.word 024041605
	.word 024041616
	.word 024041701
	.word 024041705
	.word 024041716
	.word 024043201
	.word 024043205
	.word 024043216
	.word 024140301
	.word 024140305
	.word 024140316
	.word 024141601
	.word 024141605
	.word 024141616
	.word 024141701
	.word 024141705
	.word 024141716
	.word 024143201
	.word 024143205
	.word 024143216
	.word 024220301
	.word 024220305
	.word 024220316
	.word 024221601
	.word 024221605
	.word 024221616
	.word 024221701
	.word 024221705
	.word 024221716
	.word 024223201
	.word 024223205
	.word 024223216
	.word 024230301
	.word 024230305
	.word 024230316
	.word 024231601
	.word 024231605
	.word 024231616
	.word 024231701
	.word 024231705
	.word 024231716
	.word 024233201
	.word 024233205
	.word 024233216
	.word 030172202
	.word 030172211
	.word 030172215
	.word 0104120220
	.word 0104122320
	.word 0116040301
	.word 0116040302
	.word 0116040315
	.word 0117021216
	.word 0117021220
	.word 0117120705
	.word 0117121405
	.word 0117230705
	.word 0117231405
	.word 0301110705
	.word 0301111405
	.word 0301150705
	.word 0301151405
	.word 0314050122
	.word 0415172605
	.word 0415172616
	.word 0601042202
	.word 0601042211
	.word 0601042214
	.word 0601042215
	.word 0604262202
	.word 0604262211
	.word 0604262214
	.word 0604262215
	.word 0615202202
	.word 0615202211
	.word 0615202214
	.word 0615202215
	.word 0623022202
	.word 0623022211
	.word 0623022214
	.word 0623022215
	.word 01014140511
	.word 01014140515
	.word 01014140523
	.word 01014141711
	.word 01014141715
	.word 01014141723
	.word 01014143211
	.word 01014143215
	.word 01014143223
	.word 01014220511
	.word 01014220515
	.word 01014220523
	.word 01014221711
	.word 01014221715
	.word 01014221723
	.word 01014223211
	.word 01014223215
	.word 01014223223
	.word 01022140511
	.word 01022140515
	.word 01022140523
	.word 01022141711
	.word 01022141715
	.word 01022141723
	.word 01022143211
	.word 01022143215
	.word 01022143223
	.word 01022220511
	.word 01022220515
	.word 01022220523
	.word 01022221711
	.word 01022221715
	.word 01022221723
	.word 01022223211
	.word 01022223215
	.word 01022223223
	.word 01104112602
	.word 01104112611
	.word 01104112615
	.word 01115251402
	.word 01115251411
	.word 01115251415
	.word 01225152001
	.word 01225152005
	.word 01225152007
	.word 01225152014
	.word 01225152016
	.word 01517260511
	.word 01517260515
	.word 01517260523
	.word 01517261511
	.word 01517261515
	.word 01517261523
	.word 01517261611
	.word 01517261615
	.word 01517261623
	.word 01517262311
	.word 01517262315
	.word 01517262323
	.word 01722030102
	.word 01722030111
	.word 01722030115
	.word 01722030202
	.word 01722030211
	.word 01722030215
	.word 01722031502
	.word 01722031511
	.word 01722031515
	.word 02025231012
	.word 02305240102
	.word 02305240111
	.word 02305240115
	.word 02305240301
	.word 02305240315
	.word 02305241502
	.word 02305241511
	.word 02305241515
	.word 02305241702
	.word 02305241711
	.word 02305241715
	.word 02305243202
	.word 02305243211
	.word 02305243215
	.word 02313112001
	.word 02313112005
	.word 02313112007
	.word 02313112014
	.word 02313112016
	.word 02317120705
	.word 02317121405
	.word 02317230705
	.word 02317231405
	.word 011604030102
	.word 011604030111
	.word 011604030115
	.word 011604030202
	.word 011604030211
	.word 011604030215
	.word 011604031502
	.word 011604031511
	.word 011604031515
	.word 031405012202
	.word 031405012211
	.word 031405012215
	.word 041517260515
	.word 041517261615
	.word 053024051604
	.word 0122515200705
	.word 0122515201405
	.word 0230524030102
	.word 0230524030111
	.word 0230524030115
	.word 0230524031502
	.word 0230524031511
	.word 0230524031515
	.word 0231311200705
	.word 0231311201405
	.word 0301517260511

das_op_info:
	.word 01341010340
	.word 01640500251
	.word 01400621131
	.word 01160276444
	.word 04602361122
	.word 04702321132
	.word 02401310504
	.word 02600266434
	.word 01334554265
	.word 01320272242
	.word 05274450437
	.word 02165074262
	.word 01204740370
	.word 01361520610
	.word 03341460641
	.word 03005542621
	.word 03201400660
	.word 03101522611
	.word 03345463130
	.word 01271060273
	.word 01344564407
	.word 02025014344
	.word 01610716341
	.word 01630730352
	.word 01674722356
	.word 01220610302
	.word 01434602306
	.word 01460624317
	.word 01444635114
	.word 04476221113
	.word 04452222237
	.word 01164475116
	.word 04465116445
	.word 02230521143
	.word 04606305144
	.word 04756363172
	.word 04762255127
	.word 04716343162
	.word 04722327151
	.word 04652330254
	.word 02541202502
	.word 02501206510
	.word 02761312546
	.word 02721316554
	.word 02561212506
	.word 02521216514
	.word 02741302542
	.word 02701306550
	.word 01140274134
	.word 01101076435
	.word 02170532243
	.word 01260640246
	.word 01000430210
	.word 01020456225
	.word 01131130470
	.word 02320546261
	.word 01225050414
	.word 02361000330
	.word 01720744367
	.word 01704754374
	.word 01750776371
	.word 01770576275
	.word 01371530652
	.word 03271430612
	.word 03071570672
	.word 03371470632
	.word 03171512643
	.word 03235412603
	.word 03035552663
	.word 03335452623
	.word 03135510642
	.word 03231410602
	.word 03031550662
	.word 03331450622
	.word 03131532653
	.word 03275432613
	.word 03075572673
	.word 03375472633
	.word 03175066431
	.word 02150266105
	.word 02041100420
	.word 01254524345
	.word 01614732353
	.word 01424606315
	.word 01455001120
	.word 04506317145
	.word 04626315177
	.word 04766373176
	.word 04736353165
	.word 04732337155
	.word 04666334531
	.word 02551266521
	.word 02511246511
	.word 02451226575
	.word 02771376565
	.word 02731356555
	.word 02671336535
	.word 02571276525
	.word 02531256515
	.word 02471236571
	.word 02751366561
	.word 02711346551
	.word 02651326233
	.word 01144464223
	.word 01104444324
	.word 01510656321
	.word 01530402202
	.word 01014432216
	.word 01074422212
	.word 01054412206
	.word 01035136455
	.word 02271166471
	.word 02351156465
	.word 02330540427
	.word 02125054450
	.word 02301036415
	.word 02071176475
	.word 02371006401
	.word 02010670332
	.word 01574662336
	.word 01724746375
	.word 01755026411
	.word 02051106441
	.word 02211046421
	.word 02111006401
	.word 02012251125
	.word 04514652323
	.word 02255122452
	.word 02315142462
	.word 01564667201

das_mask36:
	tlz	1,01777777777000000
	popj	17,

lookup_op_mn:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[5,,5]
	setz	1,
	movem	1,-4(17)
	movei	2,0606
	movem	2,-3(17)
%L108:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-3(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L109
	move	4,-3(17)
	sub	4,-4(17)
	lsh	4,-1
	add	4,-4(17)
	movem	4,-2(17)
	move	1,010
	tlc	1,0400000
	move	5,-2(17)
	move	6,das_op_mn(5)
	tlc	6,0400000
	caml	1,6
	 jrst	%L110
	move	1,-2(17)
	movem	1,-3(17)
	jrst	%L108
%L110:
	move	1,010
	tlc	1,0400000
	move	2,-2(17)
	move	3,das_op_mn(2)
	tlc	3,0400000
	camg	1,3
	 jrst	%L111
	move	5,-2(17)
	addi	5,1
	movem	5,-4(17)
	jrst	%L108
%L111:
	movn	2,-2(17)
	SKIPL	3,2
	 TDZA	2,2
	  MOVEI	2,1
	DIVI	2,3
	addi	3,2
	muli	3,012
	trne	3,1
	 tloa	4,0400000
	 tlz	4,0400000
	movem	4,-1(17)
	move	5,-2(17)
	SKIPL	6,5
	 TDZA	5,5
	  MOVEI	5,1
	DIVI	5,3
	move	1,das_op_info(5)
	movn	7,4
	lsh	1,0(7)
	andi	1,01777
	movem	1,0(17)
	skipn	6,011
	 jrst	%L112
	trnn	1,01000
	 tdza	1,1
	 movei	1,1
	movem	1,0(11)
%L112:
	move	1,0(17)
	andi	1,0777
	jrst	%L107
%L109:
	skipe	1,011
	 tdza	2,2
	 trna	
	 movem	2,0(11)
	seto	1,
%L107:
	move	10,-6(17)
	move	11,-5(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

das_enc_mem:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	move	1,-1(17)
	lsh	1,033
	move	3,-2(17)
	andi	3,017
	lsh	3,027
	ior	1,3
	move	4,-3(17)
	andi	4,1
	lsh	4,026
	ior	1,4
	move	5,-4(17)
	andi	5,017
	lsh	5,022
	ior	1,5
	hrrz	6,-5(17)
	ior	1,6
	pop	17,6
	SUB	17,[4,,4]
	push	17,6
	jrst	das_mask36

das_bitmap_set:
	push	17,016
	movei	7,1
	movn	4,2
	SKIPL	5,4
	 TDZA	4,4
	  MOVEI	4,1
	DIVI	4,44
	lsh	7,043(5)
	move	5,2
	SKIPL	6,5
	 TDZA	5,5
	  MOVEI	5,1
	DIVI	5,44
	add	5,1
	ior	7,0(5)
	move	3,2
	SKIPL	4,3
	 TDZA	3,3
	  MOVEI	3,1
	DIVI	3,44
	add	3,1
	movem	7,0(3)
%L116:
	move	16,0(17)
	SUB	17,[1,,1]
	popj	17,

das_bitmap_clear:
	push	17,016
	movei	3,1
	movn	4,2
	SKIPL	5,4
	 TDZA	4,4
	  MOVEI	4,1
	DIVI	4,44
	lsh	3,043(5)
	setcm	4,3
	move	5,2
	movei	7,044
	skipge	16,7
	 JRST	%UIDN7
	JUMPGE	5,%UIDP7
	CAIG	16,1
	 JRST	%UIDZ7
	MOVE	6,5
	ANDI	6,1
	PUSH	17,06
	LSH	5,-1
	IDIV	5,016
	LSH	5,1
	LSH	6,1
	ADD	6,0(17)
	SUB	17,[1,,1]
	CAMGE	6,016
	 JRST	%UIDD7
	SUB	6,016
	AOJA	5,%UIDD7
%UIDN7:	MOVE	6,5
	MOVEI	5,0
	JUMPGE	6,%UIDD7
	CAMGE	6,016
	 JRST	%UIDD7
	SUB	6,016
	AOJA	5,%UIDD7
%UIDZ7:	TDZA	6,6
%UIDP7:	IDIV	5,016
%UIDD7:
	add	5,1
	and	4,0(5)
	move	3,2
	move	5,3
	skipge	16,7
	 JRST	%UIDN10
	JUMPGE	5,%UIDP10
	CAIG	16,1
	 JRST	%UIDZ10
	MOVE	6,5
	ANDI	6,1
	PUSH	17,06
	LSH	5,-1
	IDIV	5,016
	LSH	5,1
	LSH	6,1
	ADD	6,0(17)
	SUB	17,[1,,1]
	CAMGE	6,016
	 JRST	%UIDD10
	SUB	6,016
	AOJA	5,%UIDD10
%UIDN10:	MOVE	6,5
	MOVEI	5,0
	JUMPGE	6,%UIDD10
	CAMGE	6,016
	 JRST	%UIDD10
	SUB	6,016
	AOJA	5,%UIDD10
%UIDZ10:	TDZA	6,6
%UIDP10:	IDIV	5,016
%UIDD10:
	add	5,1
	movem	4,0(5)
%L117:
	move	16,0(17)
	SUB	17,[1,,1]
	popj	17,

das_bitmap_get:
	push	17,016
	move	3,2
	movei	5,044
	skipge	16,5
	 JRST	%UIDN11
	JUMPGE	3,%UIDP11
	CAIG	16,1
	 JRST	%UIDZ11
	MOVE	4,3
	ANDI	4,1
	PUSH	17,04
	LSH	3,-1
	IDIV	3,016
	LSH	3,1
	LSH	4,1
	ADD	4,0(17)
	SUB	17,[1,,1]
	CAMGE	4,016
	 JRST	%UIDD11
	SUB	4,016
	AOJA	3,%UIDD11
%UIDN11:	MOVE	4,3
	MOVEI	3,0
	JUMPGE	4,%UIDD11
	CAMGE	4,016
	 JRST	%UIDD11
	SUB	4,016
	AOJA	3,%UIDD11
%UIDZ11:	TDZA	4,4
%UIDP11:	IDIV	3,016
%UIDD11:
	add	3,1
	move	6,0(3)
	movei	7,1
	movn	3,2
	skipge	16,5
	 JRST	%UIDN12
	JUMPGE	3,%UIDP12
	CAIG	16,1
	 JRST	%UIDZ12
	MOVE	4,3
	ANDI	4,1
	PUSH	17,04
	LSH	3,-1
	IDIV	3,016
	LSH	3,1
	LSH	4,1
	ADD	4,0(17)
	SUB	17,[1,,1]
	CAMGE	4,016
	 JRST	%UIDD12
	SUB	4,016
	AOJA	3,%UIDD12
%UIDN12:	MOVE	4,3
	MOVEI	3,0
	JUMPGE	4,%UIDD12
	CAMGE	4,016
	 JRST	%UIDD12
	SUB	4,016
	AOJA	3,%UIDD12
%UIDZ12:	TDZA	4,4
%UIDP12:	IDIV	3,016
%UIDD12:
	lsh	7,043(4)
	and	6,7
	cain	6,0
	 tdza	1,1
	 movei	1,1
%L118:
	move	16,0(17)
	SUB	17,[1,,1]
	popj	17,

host_word_get:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	3,010
	tlz	3,0777700
	push	17,3
	ADD	17,[1,,1]
	move	1,2(3)
	tlc	1,0400000
	move	4,-1(17)
	move	2,3(4)
	tlc	2,0400000
	camge	1,2
	 jrst	%L122
	move	4,-1(17)
	move	2,0(4)
	move	3,0(2)
	move	2,1(4)
	move	1,3
	movei	3,040
	pushj	17,dsys_read_words
	movem	1,0(17)
	skipe	3,1
	 jrst	%L123
	setm	1,3
	jrst	%L121
%L123:
	skipl	2,0(17)
	 jrst	%L124
	movei	1,1
	move	4,-1(17)
	move	3,0(4)
	movem	1,1(3)
	seto	1,
	jrst	%L121
%L124:
	move	2,0(17)
	move	5,-1(17)
	movem	2,3(5)
	setzb	1,2(5)
%L122:
	move	4,-1(17)
	aos	1,2(4)
	add	1,1(4)
	move	2,-1(1)
	movem	2,0(11)
	movei	1,1
%L121:
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	popj	17,

das_native_die:
	pushj	17,das_native_diag
	movei	1,1
	pushj	17,dsys_exit
	popj	17,

das_work_words:
	push	17,010
	move	10,1
	push	17,[03743]
	move	2,010
	addi	2,03743
	movem	2,0(17)
	tlc	2,0400000
	camg	2,[0400000200000]
	 jrst	%L126
	movei	1,02507
	pushj	17,das_native_die
%L126:
	move	1,0(17)
%L125:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

das_note_work:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[1,,1]
	move	1,011
	pushj	17,das_work_words
	movem	1,0(17)
	move	3,1
	tlc	3,0400000
	move	4,01143(10)
	tlc	4,0400000
	camle	3,4
	 skipa	5,0(17)
	 trna	
	 movem	5,01143(10)
%L127:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

strcopy:
	skipn	4,3
	 popj	17,
%L130:
	move	4,3
	tlc	4,0400000
	camg	4,[0400000000001]
	 jrst	%L131
	move	5,2
	ldb	6,5
	jumpe	6,%L131
	move	7,2
	ibp	2
	ldb	4,7
	move	5,1
	ibp	1
	dpb	4,5
	soja	3,%L130
%L131:
	setz	4,
	move	5,1
	dpb	4,5
	popj	17,

char_distance:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,[0]
%L133:
	move	1,010
	camn	1,011
	 jrst	%L134
	ibp	010
	aos	3,0(17)
	jrst	%L133
%L134:
	move	1,0(17)
%L132:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

skipws:
	push	17,010
	move	10,1
%L136:
	move	1,010
	ldb	2,1
	jumpe	2,%L137
	move	1,010
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L137
	ibp	010
	jrst	%L136
%L137:
	move	1,010
%L135:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

rtrim:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	move	1,010
	pushj	17,strlen
	movem	1,0(17)
%L139:
	skipn	2,0(17)
	 jrst	%L140
	move	2,0(17)
	subi	2,1
	move	1,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,2
	pushj	17,das_native_is_space
	jumpe	1,%L140
	setz	2,
	sos	3,0(17)
	move	4,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	4,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	2,3
	jrst	%L139
%L140:
%L138:
	move	10,-1(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,

streqi:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,010
	move	2,011
	pushj	17,strcmp
	caie	1,0
	 tdza	1,1
	 movei	1,1
%L141:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

pref_i:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	push	17,[0]
%L145:
	move	2,0(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L146
	move	4,0(17)
	move	3,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	3,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	5,4
	move	7,0(17)
	move	6,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	7,-1(17)
	MOVEM	6,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	7,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,7
	camn	5,1
	 jrst	%L147
	setz	1,
	jrst	%L144
%L147:
	aos	1,0(17)
	jrst	%L145
%L146:
	movei	1,1
%L144:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

token_key:
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	setz	1,
	movem	1,-2(17)
	setm	2,1
	movem	2,-1(17)
%L149:
	move	1,010
	ldb	2,1
	jumpe	2,%L150
	move	4,-1(17)
	tlc	4,0400000
	caml	4,[0400000000006]
	 jrst	%L150
	move	3,010
	ibp	010
	ldb	7,3
	andi	7,0777
	movem	7,0(17)
	tlc	7,0400000
	camge	7,[0400000000141]
	 jrst	%L151
	move	6,0(17)
	tlc	6,0400000
	camle	6,[0400000000172]
	 jrst	%L151
	movni	1,040
	addb	1,0(17)
%L151:
	move	2,-2(17)
	lsh	2,6
	move	3,0(17)
	subi	3,0100
	ior	2,3
	movem	2,-2(17)
	aos	1,-1(17)
	jrst	%L149
%L150:
%L152:
	aos	1,-1(17)
	subi	1,1
	tlc	1,0400000
	caml	1,[0400000000006]
	 jrst	%L153
	move	4,-2(17)
	lsh	4,6
	movem	4,-2(17)
	jrst	%L152
%L153:
	move	1,-2(17)
%L148:
	move	10,-3(17)
	SUB	17,[4,,4]
	popj	17,

%L154:
	.word 011411071600
	.word 033
	.word 012303111100
	.word 017
	.word 012303113200
	.word 020
	.word 021417031300
	.word 012
	.word 022323000000
	.word 3
	.word 023124050000
	.word 016
	.word 031704050000
	.word 1
	.word 031715150000
	.word 014
	.word 031715151716
	.word 014
	.word 031716232400
	.word 2
	.word 040124010000
	.word 2
	.word 051604000000
	.word 5
	.word 051604202300
	.word 5
	.word 051624223100
	.word 6
	.word 052125000000
	.word 031
	.word 052222172200
	.word 7
	.word 053020000000
	.word 023
	.word 053024052216
	.word 035
	.word 061114050000
	.word 5
	.word 071127000000
	.word 026
	.word 071417020114
	.word 034
	.word 071417021400
	.word 034
	.word 0110405162400
	.word 5
	.word 0140317151500
	.word 015
	.word 0141703000000
	.word 5
	.word 0141716070000
	.word 024
	.word 0172207000000
	.word 030
	.word 0172707022000
	.word 027
	.word 0201711162400
	.word 025
	.word 0202305032400
	.word 4
	.word 0220104113000
	.word 011
	.word 0221704012401
	.word 2
	.word 0230503240000
	.word 4
	.word 0230503241117
	.word 4
	.word 0230524000000
	.word 032
	.word 0231130021124
	.word 021
	.word 0232001030500
	.word 013
	.word 0240530240000
	.word 1
	.word 0241124140500
	.word 5
	.word 0270122161116
	.word 010
	.word 0271722040000
	.word 022
	.word 0320522170000
	.word 013

classify_token:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[5,,5]
	move	2,[POINT 9,%L157,8]
	move	1,011
	movei	3,7
	pushj	17,pref_i
	jumpe	1,%L156
	movei	3,7
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	11,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	2,3
	jumpn	2,%L156
	movei	1,033
	jrst	%L155
%L156:
	move	1,011
	ldb	4,1
	andi	4,0777
	subi	4,0101
	movem	4,0(17)
	tlc	4,0400000
	caml	4,[0400000000032]
	 jrst	%L159
	move	2,[0223544577]
	movn	5,0(17)
	ash	2,0(5)
	trne	2,1
	 jrst	%L158
%L159:
	setz	1,
	jrst	%L155
%L158:
	move	1,011
	pushj	17,token_key
	movem	1,-4(17)
	setz	2,
	movem	2,-3(17)
	movei	3,052
	movem	3,-2(17)
%L160:
	move	2,-3(17)
	tlc	2,0400000
	move	3,-2(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L161
	move	4,-2(17)
	sub	4,-3(17)
	lsh	4,-1
	add	4,-3(17)
	movem	4,-1(17)
	aos	1,01145(10)
	move	6,-4(17)
	tlc	6,0400000
	move	1,-1(17)
	ash	1,1
	move	5,%L154(1)
	tlc	5,0400000
	caml	6,5
	 jrst	%L162
	move	1,-1(17)
	movem	1,-2(17)
	jrst	%L160
%L162:
	move	2,-4(17)
	tlc	2,0400000
	move	4,-1(17)
	ash	4,1
	move	1,%L154(4)
	tlc	1,0400000
	camg	2,1
	 jrst	%L163
	move	5,-1(17)
	addi	5,1
	movem	5,-3(17)
	jrst	%L160
%L163:
	move	3,-1(17)
	ash	3,1
	move	1,%L154+1(3)
	jrst	%L155
%L161:
	setz	1,
%L155:
	move	10,-6(17)
	move	11,-5(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,
%L157:
	.byte	9,0120,062,0101,0114
	.byte	9,0111,0107,0116,0
	


isname0:
	push	17,010
	move	10,1
	move	1,010
	andi	1,0777
	pushj	17,das_native_is_alpha
	jumpn	1,%L166
	move	2,010
	cain	2,0137
	 jrst	%L166
	move	3,010
	cain	3,056
	 jrst	%L166
	move	4,010
	movei	5,045
	came	4,5
	 skipa	6,010
	 trna	
	 cain	6,044
%L166:
	 skipa	1,[1]
	 setz	1,
%L164:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

isname:
	push	17,010
	move	10,1
	move	1,010
	andi	1,0777
	pushj	17,das_native_is_alnum
	jumpn	1,%L169
	move	2,010
	cain	2,0137
	 jrst	%L169
	move	3,010
	cain	3,056
	 jrst	%L169
	move	4,010
	movei	5,045
	came	4,5
	 skipa	6,010
	 trna	
	 cain	6,044
%L169:
	 skipa	1,[1]
	 setz	1,
%L167:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

parse_octal_w:
	push	17,010
	move	10,1
	push	17,[0]
%L171:
	move	1,010
	ldb	2,1
	caige	2,060
	 jrst	%L172
	move	3,010
	ldb	4,3
	caile	4,067
	 jrst	%L172
	move	5,010
	ldb	6,5
	subi	6,060
	move	2,0(17)
	lsh	2,3
	add	6,2
	movem	6,0(17)
	ibp	010
	jrst	%L171
%L172:
	move	1,0(17)
	tlz	1,01777777777000000
%L170:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

parse_octal_u:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,parse_octal_w
	hrrz	1,1
%L173:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

is_octal_end:
	push	17,010
	move	10,1
	jumpe	1,%L176
	move	1,010
	andi	1,0777
	pushj	17,das_native_is_space
	jumpn	1,%L176
	move	2,010
	cain	2,054
	 jrst	%L176
	move	3,010
	movei	4,051
	camn	3,4
	 jrst	%L176
	move	5,010
	cain	5,0135
	 jrst	%L176
	move	6,010
	caie	6,053
	 skipa	7,010
	 trna	
	 cain	7,055
%L176:
	 skipa	1,[1]
	 setz	1,
%L174:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

looks_octal_token:
	move	2,1
	ldb	3,2
	movei	4,053
	camn	3,4
	 jrst	%L178
	move	5,1
	ldb	6,5
	movei	7,055
	came	6,7
	 jrst	%L177
%L178:
	ibp	1
%L177:
	move	2,1
	ldb	3,2
	movei	4,060
	camge	3,4
	 jrst	%L180
	move	5,1
	ldb	6,5
	caig	6,067
	 jrst	%L179
%L180:
	setz	1,
	popj	17,
%L179:
%L181:
	move	2,1
	ldb	3,2
	caige	3,060
	 jrst	%L182
	move	4,1
	ldb	5,4
	caile	5,067
	 jrst	%L182
	ibp	1
	jrst	%L181
%L182:
	move	2,1
	ldb	3,2
	andi	3,0777
	move	1,3
	jrst	is_octal_end

looks_symbolic_data_expr:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	skipn	2,016(10)
	 skipe	3,030(10)
	 jrst	%L185
	move	2,3(10)
	move	1,2
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L184
%L185:
	setz	1,
	jrst	%L183
%L184:
	move	2,2(10)
	movem	2,0(17)
	ldb	1,0(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L186
	setm	1,1
	jrst	%L183
%L186:
%L187:
	ldb	1,0(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L188
	ibp	0(17)
	move	2,0(17)
	jrst	%L187
%L188:
	ldb	1,0(17)
	cain	1,0
	 tdza	1,1
	 movei	1,1
%L183:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

sixbit_mn:
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	setz	1,
	movem	1,-2(17)
	setm	2,1
	movem	2,-1(17)
%L192:
	move	1,010
	ldb	2,1
	jumpe	2,%L193
	move	4,-1(17)
	cail	4,6
	 jrst	%L193
	move	3,010
	ibp	010
	ldb	5,3
	dpb	5,[POINT 9,0(17),35]
	ldb	1,[POINT 9,0(17),35]
	cail	1,0141
	 caile	1,0172
	 jrst	%L194
	subi	1,040
	move	7,1
	andi	7,0777
	dpb	7,[POINT 9,0(17),35]
%L194:
	ldb	4,[POINT 9,0(17),35]
	cail	4,0101
	 caile	4,0132
	 jrst	%L195
	move	2,-2(17)
	lsh	2,6
	subi	4,0100
	ior	2,4
	movem	2,-2(17)
	aos	1,-1(17)
%L195:
	jrst	%L192
%L193:
	move	1,-2(17)
%L191:
	move	10,-3(17)
	SUB	17,[4,,4]
	popj	17,

sixbit_ascii:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[4,,4]
	setz	1,
	movem	1,-3(17)
	setm	2,1
	movem	2,-2(17)
%L197:
	setz	1,
	movem	1,-1(17)
	move	4,-2(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	2,4
	jumpe	2,%L200
	move	6,-2(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	3,6
	dpb	3,[POINT 9,0(17),35]
	ldb	1,[POINT 9,0(17),35]
	cail	1,0141
	 caile	1,0172
	 jrst	%L201
	subi	1,040
	move	7,1
	andi	7,0777
	dpb	7,[POINT 9,0(17),35]
%L201:
	ldb	2,[POINT 9,0(17),35]
	cail	2,040
	 caile	2,0137
	 jrst	%L202
	subi	2,040
	movem	2,-1(17)
%L202:
%L200:
	move	1,-3(17)
	lsh	1,6
	move	3,-1(17)
	andi	3,077
	ior	1,3
	movem	1,-3(17)
	aos	5,-2(17)
	caige	5,6
	 jrst	%L197
	tlz	1,01777777777000000
%L196:
	move	10,-4(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	popj	17,

	.data

das_strict_base:
	.word 0

das_kernel_mode:
	.word 0

	.text

%L203:
	.word 02015172605
	.word 052
	.word 0201517260515
	.word 053
	.word 025120516
	.word 0100
	.word 07060104
	.word 0102
	.word 07062302
	.word 0103
	.word 012233123
	.word 0104
	.word 07061520
	.word 0106
	.word 07060426
	.word 0107
	.word 03112203
	.word 0247
	.word 0120221104
	.word 0700
	.word 02515172605
	.word 0704
	.word 0251517260515
	.word 0705
	.word 024111705
	.word 0710
	.word 024111716
	.word 0711
	.word 022041117
	.word 0712
	.word 027221117
	.word 0713
	.word 02231117
	.word 0714
	.word 02031117
	.word 0715
	.word 02411170502
	.word 0720
	.word 02411171602
	.word 0721
	.word 02204111702
	.word 0722
	.word 02722111702
	.word 0723
	.word 0223111702
	.word 0724
	.word 0203111702
	.word 0725

lookup_extra_op_mn:
	push	17,010
	move	10,1
	push	17,[0]
%L205:
	move	6,0(17)
	ash	6,1
	move	1,%L203(6)
	came	1,010
	 jrst	%L207
	move	1,%L203+1(6)
	jrst	%L204
%L207:
	aos	3,0(17)
	tlc	3,0400000
	camge	3,[0400000000030]
	 jrst	%L205
	seto	1,
%L204:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

lookup_op:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	move	1,010
	pushj	17,sixbit_mn
	movem	1,-1(17)
	move	1,-1(17)
	move	2,011
	pushj	17,lookup_op_mn
	movem	1,0(17)
	jumpge	1,%L208
	move	1,-1(17)
	pushj	17,lookup_extra_op_mn
	movem	1,0(17)
	skipl	3,1
	 skipn	2,011
	 jrst	%L210
	movei	4,1
	movem	4,0(11)
%L210:
	move	1,0(17)
%L208:
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	popj	17,

%L211:
	.word 0201722240114
	.word 05301
	.word 01222232406
	.word 05302
	.word 0301222232406
	.word 05305
	.word 030120516
	.word 05306
	.word 030200327
	.word 05307
	.word 0120516
	.word 05312
	.word 0230615
	.word 05314
	.word 03012222324
	.word 05315
	.word 012061726
	.word 05321
	.word 0121726
	.word 05330
	.word 031422230310
	.word 016020
	.word 02204250222
	.word 016021
	.word 0314222024
	.word 016022
	.word 02722250222
	.word 016023
	.word 02722050222
	.word 016024
	.word 02204050222
	.word 016025
	.word 02204232002
	.word 016040
	.word 02204032302
	.word 016041
	.word 02204202522
	.word 016042
	.word 0220403232415
	.word 016043
	.word 0220424111505
	.word 016044
	.word 02204111624
	.word 016045
	.word 02204102302
	.word 016046
	.word 0232015
	.word 016047
	.word 02722232002
	.word 016050
	.word 02722032302
	.word 016051
	.word 02722202522
	.word 016052
	.word 0272203232415
	.word 016053
	.word 0272224111505
	.word 016054
	.word 02722111624
	.word 016055
	.word 02722102302
	.word 016056
	.word 014201522
	.word 016057

lookup_fixed_ac_alias:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[4,,4]
	move	1,010
	pushj	17,sixbit_mn
	movem	1,-3(17)
	came	1,[012032231]
	 jrst	%L213
	movem	10,0(17)
%L214:
	ldb	1,0(17)
	jumpe	1,%L215
	ldb	1,0(17)
	andi	1,0777
	pushj	17,das_native_is_digit
	jumpn	1,%L215
	ibp	0(17)
	move	2,0(17)
	jrst	%L214
%L215:
	movei	1,0255
	movem	1,0(11)
	ldb	2,0(17)
	caie	2,061
	 jrst	%L217
	move	3,0(17)
	ildb	4,3
	jumpn	4,%L217
	movei	5,2
	movem	5,0(12)
	jrst	%L216
%L217:
	ldb	1,0(17)
	caie	1,060
	 jrst	%L218
	move	2,0(17)
	ildb	3,2
	jumpn	3,%L218
	movei	4,4
	movem	4,0(12)
	jrst	%L216
%L218:
	ldb	1,0(17)
	jumpn	1,%L219
	movei	2,6
	movem	2,0(12)
	jrst	%L216
%L219:
	setz	1,
	jrst	%L212
%L216:
	movei	1,1
	jrst	%L212
%L213:
	setz	1,
	movem	1,-2(17)
%L220:
	move	5,-2(17)
	ash	5,1
	move	1,%L211(5)
	came	1,-3(17)
	 jrst	%L222
	move	4,%L211+1(5)
	movem	4,-1(17)
	lsh	4,-4
	movem	4,0(11)
	move	3,-1(17)
	andi	3,017
	movem	3,0(12)
	movei	1,1
	jrst	%L212
%L222:
	aos	3,-2(17)
	tlc	3,0400000
	camge	3,[0400000000040]
	 jrst	%L220
	setz	1,
%L212:
	move	10,-6(17)
	move	11,-5(17)
	move	12,-4(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

%L223:
	.word 02141311
	.word 0401240111
	.word 02141317
	.word 0401240117
	.word 03171617
	.word 03171611
	.word 0317162332
	.word 0317162317

lookup_io:
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	move	1,010
	pushj	17,sixbit_mn
	movem	1,-1(17)
	setzb	2,0(17)
	movei	3,%L223
%L225:
	move	2,0(3)
	came	2,-1(17)
	 jrst	%L227
	move	1,0(17)
	jrst	%L224
%L227:
	aos	4,0(17)
	addi	3,1
	tlc	4,0400000
	camge	4,[0400000000010]
	 jrst	%L225
	seto	1,
%L224:
	move	10,-2(17)
	SUB	17,[3,,3]
	popj	17,

das_enc_io:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	move	1,-1(17)
	lsh	1,-2
	andi	1,0177
	lsh	1,032
	tlo	1,0700000
	move	3,-2(17)
	andi	3,7
	lsh	3,027
	ior	1,3
	move	4,-3(17)
	andi	4,1
	lsh	4,026
	ior	1,4
	move	5,-4(17)
	andi	5,017
	lsh	5,022
	ior	1,5
	hrrz	6,-5(17)
	ior	1,6
	pop	17,6
	SUB	17,[4,,4]
	push	17,6
	jrst	das_mask36

wordfile_seek:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,011
	move	2,0(17)
	move	3,0(10)
	move	1,3
	setz	3,
	pushj	17,fseek
	jumpn	1,%L229
	setm	1,1
	jrst	%L230
%L229:
	seto	1,
%L230:
%L228:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

wordfile_write:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
%L232:
	skipn	1,012
	 jrst	%L233
	move	1,011
	move	3,0(10)
	move	2,0(3)
	move	3,012
	move	6,2
	move	2,1
	move	1,6
	pushj	17,dsys_write_words
	movem	1,0(17)
	skiple	3,1
	 jrst	%L234
	seto	1,
	jrst	%L231
%L234:
	move	2,0(17)
	add	2,011
	move	11,2
	move	4,0(17)
	move	3,012
	sub	3,4
	move	12,3
	jrst	%L232
%L233:
	setz	1,
%L231:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

wordfile_read_words:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
%L236:
	skipn	1,012
	 jrst	%L237
	move	2,0(10)
	move	1,0(2)
	move	2,011
	move	3,012
	pushj	17,dsys_read_words
	movem	1,0(17)
	skiple	3,1
	 jrst	%L238
	seto	1,
	jrst	%L235
%L238:
	move	2,0(17)
	add	2,011
	move	11,2
	move	4,0(17)
	move	3,012
	sub	3,4
	move	12,3
	jrst	%L236
%L237:
	setz	1,
%L235:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

wordfile_append:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	move	2,1(10)
	move	1,010
	pushj	17,wordfile_seek
	jumpe	1,%L240
	seto	1,
	jrst	%L239
%L240:
	move	1,010
	move	2,011
	move	3,012
	pushj	17,wordfile_write
	jumpe	1,%L241
	seto	1,
	jrst	%L239
%L241:
	move	1,012
	addb	1,1(10)
	setz	1,
%L239:
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	popj	17,

wordfile_read:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	push	17,013
	move	13,4
	move	1,011
	tlc	1,0400000
	move	3,1(10)
	tlc	3,0400000
	camle	1,3
	 jrst	%L244
	move	2,013
	tlc	2,0400000
	move	5,1(10)
	sub	5,011
	tlc	5,0400000
	camg	2,5
	 jrst	%L243
%L244:
	seto	1,
	jrst	%L242
%L243:
	move	1,010
	move	2,011
	pushj	17,wordfile_seek
	jumpe	1,%L245
	seto	1,
	jrst	%L242
%L245:
	move	1,010
	move	2,012
	move	3,013
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	move	13,0(17)
	SUB	17,[4,,4]
	jrst	wordfile_read_words
%L242:
	MOVEI	0,010
	HRLI	0,-3(17)
	BLT	0,013
	SUB	17,[4,,4]
	popj	17,

pack_text_words:
	push	17,016
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	setz	1,
	movem	1,-2(17)
%L247:
	move	2,-2(17)
	tlc	2,0400000
	move	1,011
	tlc	1,0400000
	caml	2,1
	 jrst	%L248
	move	6,010
	add	6,-2(17)
	setzb	3,0(6)
	aos	4,-2(17)
	jrst	%L247
%L248:
	setz	1,
	movem	1,-2(17)
%L250:
	move	2,-2(17)
	tlc	2,0400000
	move	1,013
	tlc	1,0400000
	caml	2,1
	 jrst	%L251
	move	5,-2(17)
	andi	5,3
	movem	5,-1(17)
	muli	5,011
	trne	5,1
	 tloa	6,0400000
	 tlz	6,0400000
	movn	2,6
	addi	2,033
	movem	2,0(17)
	move	4,-2(17)
	move	3,012
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	3,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	7,4
	andi	7,0777
	andi	7,0177
	lsh	7,0(2)
	move	2,-2(17)
	lsh	2,-2
	add	2,010
	ior	7,0(2)
	move	1,7
	move	3,-2(17)
	lsh	3,-2
	add	3,010
	movem	1,0(3)
	aos	1,-2(17)
	jrst	%L250
%L251:
%L246:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

unpack_text_words:
	push	17,016
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipn	1,011
	 jrst	%L253
	move	2,013
	tlc	2,0400000
	move	3,011
	tlc	3,0400000
	camge	2,3
	 jrst	%L255
	move	4,011
	subi	4,1
	move	13,4
%L255:
	setz	1,
	movem	1,-2(17)
%L256:
	move	2,-2(17)
	tlc	2,0400000
	move	1,013
	tlc	1,0400000
	caml	2,1
	 jrst	%L257
	move	5,-2(17)
	andi	5,3
	movem	5,-1(17)
	muli	5,011
	trne	5,1
	 tloa	6,0400000
	 tlz	6,0400000
	movn	2,6
	addi	2,033
	movem	2,0(17)
	move	4,-2(17)
	lsh	4,-2
	add	4,012
	move	7,0(4)
	movn	2,2
	lsh	7,0(2)
	andi	7,0177
	andi	7,0777
	move	2,-2(17)
	move	1,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	7,2
	aos	1,-2(17)
	jrst	%L256
%L257:
	setz	1,
	move	2,010
	move	3,013
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
%L253:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

sym_hash:
	push	17,010
	move	10,1
	push	17,[0]
%L260:
	move	1,010
	ldb	2,1
	jumpe	2,%L261
	move	1,010
	ldb	1,1
	andi	1,0777
	andi	1,0177
	move	4,0(17)
	lsh	4,5
	add	1,4
	add	1,0(17)
	pushj	17,das_mask36
	movem	1,0(17)
	ibp	010
	jrst	%L260
%L261:
	move	1,0(17)
%L259:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

sym_cache_index:
	push	17,016
	move	2,1
	hlrz	3,1
	xor	2,3
	SKIPL	3,2
	 TDZA	2,2
	  MOVEI	2,1
	DIVI	2,15
	move	1,3
%L262:
	move	16,0(17)
	SUB	17,[1,,1]
	popj	17,

sym_record_pack:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[1,,1]
	move	1,-5(17)
	pushj	17,strlen
	movem	1,0(17)
	move	3,1
	tlc	3,0400000
	camle	3,[0400000000047]
	 skipa	2,[047]
	 trna	
	 movem	2,0(17)
	hlrz	5,-7(17)
	lsh	5,022
	hrrz	6,-3(17)
	ior	5,6
	move	6,-2(17)
	movem	5,0(6)
	move	1,-4(17)
	movem	1,1(6)
	move	1,0(17)
	andi	1,077
	lsh	1,027
	move	2,-6(17)
	andi	2,037
	lsh	2,022
	ior	1,2
	hrrz	2,-7(17)
	ior	1,2
	movem	1,2(6)
	move	4,0(17)
	move	3,-5(17)
	addi	6,3
	move	1,6
	movei	2,012
	SUB	17,[1,,1]
	pop	17,6
	SUB	17,[4,,4]
	push	17,6
	jrst	pack_text_words

sym_record_unpack:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,2(10)
	lsh	1,-027
	andi	1,077
	push	17,1
	move	4,0(17)
	move	3,010
	addi	3,3
	move	1,011
	hrli	1,0331100
	movei	2,050
	pushj	17,unpack_text_words
	hlrz	1,2(10)
	andi	1,037
	movem	1,012(11)
	hlrz	3,0(10)
	lsh	3,022
	hrrz	2,2(10)
	ior	3,2
	movem	3,013(11)
%L264:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

scratch_open:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,011
	pushj	17,strlen
	movem	1,-1(17)
	move	1,012
	pushj	17,strlen
	movem	1,0(17)
	add	1,-1(17)
	move	3,1
	tlc	3,0400000
	camg	3,[0400000000146]
	 jrst	%L266
	seto	1,
	jrst	%L265
%L266:
	move	1,010
	addi	1,2
	hrli	1,0331100
	move	2,011
	movei	3,0147
	pushj	17,strcopy
	movn	2,-1(17)
	addi	2,0147
	move	1,010
	addi	1,2
	hrli	1,0331100
	move	4,-1(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	1,4
	move	3,2
	move	2,012
	pushj	17,strcopy
	move	1,010
	addi	1,2
	hrli	1,0331100
	pushj	17,remove
	move	1,[POINT 9,%L267,8]
	move	6,010
	addi	6,2
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,fopen
	movem	1,0(10)
	skipe	3,1
	 jrst	%L268
	seto	2,
	move	1,2
	jrst	%L269
%L268:
	setz	1,
%L269:
%L265:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	popj	17,
%L267:
	.byte	9,0167,053,0142,0
	


store_init:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,010
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,03610
	pushj	17,memset
	move	1,010
	addi	1,0742
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,0414
	pushj	17,memset
	move	1,010
	addi	1,01045
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,0160
	pushj	17,memset
	move	1,010
	addi	1,01101
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,0160
	pushj	17,memset
	move	3,[POINT 9,%L272,8]
	move	2,010
	addi	2,0703
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L271
	seto	1,
	jrst	%L270
%L271:
	move	3,[POINT 9,%L274,8]
	move	2,010
	addi	2,0742
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L273
	move	2,0703(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0703(10)
	move	1,010
	addi	1,0705
	hrli	1,0331100
	pushj	17,remove
	seto	1,
	jrst	%L270
%L273:
	move	3,[POINT 9,%L276,8]
	move	2,010
	addi	2,01045
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L275
	move	2,0742(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0742(10)
	move	1,010
	addi	1,0744
	hrli	1,0331100
	pushj	17,remove
	move	2,0703(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0703(10)
	move	1,010
	addi	1,0705
	hrli	1,0331100
	pushj	17,remove
	seto	1,
	jrst	%L270
%L275:
	move	3,[POINT 9,%L278,8]
	move	2,010
	addi	2,01101
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L277
	move	2,01045(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,01045(10)
	move	1,010
	addi	1,01047
	hrli	1,0331100
	pushj	17,remove
	move	2,0742(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0742(10)
	move	1,010
	addi	1,0744
	hrli	1,0331100
	pushj	17,remove
	move	2,0703(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0703(10)
	move	1,010
	addi	1,0705
	hrli	1,0331100
	pushj	17,remove
	seto	1,
	jrst	%L270
%L277:
	setz	1,
%L270:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L278:
	.byte	9,056,0104,061,0122
	.byte	9,0
	

%L276:
	.byte	9,056,0104,0122,0120
	.byte	9,0
	

%L274:
	.byte	9,056,0104,0114,0124
	.byte	9,0
	

%L272:
	.byte	9,056,0104,0123,0131
	.byte	9,0
	


store_init_phase2:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,010
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,03610
	pushj	17,memset
	move	1,010
	addi	1,0742
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,0414
	pushj	17,memset
	move	1,010
	addi	1,01045
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,0160
	pushj	17,memset
	move	1,010
	addi	1,01101
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,0160
	pushj	17,memset
	move	3,[POINT 9,%L281,8]
	move	2,010
	addi	2,0703
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L280
	seto	1,
	jrst	%L279
%L280:
	move	3,[POINT 9,%L283,8]
	move	2,010
	addi	2,0742
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L282
	move	2,0703(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0703(10)
	move	1,010
	addi	1,0705
	hrli	1,0331100
	pushj	17,remove
	seto	1,
	jrst	%L279
%L282:
	setz	1,
%L279:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L283:
	.byte	9,056,0104,0114,0124
	.byte	9,0
	

%L281:
	.byte	9,056,0104,0123,0131
	.byte	9,0
	


store_close:
	push	17,010
	move	10,1
	skipn	2,0703(1)
	 jrst	%L285
	move	2,0703(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0703(10)
	move	1,010
	addi	1,0705
	hrli	1,0331100
	pushj	17,remove
%L285:
	skipn	2,0742(10)
	 jrst	%L286
	move	2,0742(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0742(10)
	move	1,010
	addi	1,0744
	hrli	1,0331100
	pushj	17,remove
%L286:
	skipn	2,01045(10)
	 jrst	%L287
	move	2,01045(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,01045(10)
	move	1,010
	addi	1,01047
	hrli	1,0331100
	pushj	17,remove
%L287:
	skipn	2,01101(10)
	 jrst	%L288
	move	2,01101(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,01101(10)
	move	1,010
	addi	1,01103
	hrli	1,0331100
	pushj	17,remove
%L288:
%L284:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

sym_copy:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,011
	hrli	1,0331100
	move	6,010
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,050
	pushj	17,strcopy
	move	2,012(11)
	movem	2,012(10)
	move	3,013(11)
	movem	3,013(10)
%L289:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

find_sym:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[037,,037]
	movem	10,-036(17)
	move	1,011
	pushj	17,sym_hash
	movem	1,-017(17)
	move	1,-017(17)
	pushj	17,sym_cache_index
	movem	1,-014(17)
	move	3,-036(17)
	addi	3,0400
	move	4,1
	imuli	4,017
	add	4,3
	movem	4,-035(17)
	move	6,-036(17)
	aos	2,0740(6)
	move	2,-035(17)
	move	5,2(2)
	jumpe	5,%L291
	move	7,0(2)
	came	7,-017(17)
	 jrst	%L291
	move	1,-035(17)
	addi	1,3
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L291
	move	2,-035(17)
	addi	2,3
	move	1,012
	pushj	17,sym_copy
	movei	1,1
	jrst	%L290
%L291:
	move	4,-017(17)
	andi	4,0377
	movem	4,-016(17)
	add	4,-036(17)
	move	1,0(4)
	movem	1,-015(17)
%L292:
	skipn	2,-015(17)
	 jrst	%L293
	movei	1,-034(17)
	move	3,-015(17)
	subi	3,1
	muli	3,015
	trne	3,1
	 tloa	4,0400000
	 tlz	4,0400000
	move	5,-036(17)
	addi	5,0703
	move	2,4
	move	3,1
	move	1,5
	movei	4,015
	pushj	17,wordfile_read
	jumpe	1,%L294
	movei	1,04013
	pushj	17,das_native_die
%L294:
	move	3,-036(17)
	aos	1,0741(3)
	move	2,-033(17)
	came	2,-017(17)
	 jrst	%L295
	movei	1,-013(17)
	movei	6,-034(17)
	move	2,1
	move	1,6
	pushj	17,sym_record_unpack
	movei	1,-013(17)
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L295
	move	3,-017(17)
	move	4,-035(17)
	movem	3,0(4)
	move	5,-015(17)
	move	6,-035(17)
	movem	5,1(6)
	movei	2,1
	move	1,-035(17)
	movem	2,2(1)
	movei	2,-013(17)
	move	3,-035(17)
	addi	3,3
	move	1,3
	pushj	17,sym_copy
	movei	2,-013(17)
	move	1,012
	pushj	17,sym_copy
	movei	1,1
	jrst	%L290
%L295:
	hrrz	2,-034(17)
	movem	2,-015(17)
	jrst	%L292
%L293:
	setz	1,
%L290:
	move	10,-041(17)
	move	11,-040(17)
	move	12,-037(17)
	SUB	17,[042,,042]
	popj	17,

add_sym:
	ADD	17,[027,,027]
	MOVEI	0,-026(17)
	HRLI	0,010
	BLT	0,-023(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movem	10,-022(17)
	move	1,011
	pushj	17,sym_hash
	movem	1,-3(17)
	move	3,1
	andi	3,0377
	movem	3,-2(17)
	move	4,-022(17)
	move	2,0737(4)
	addi	2,1
	movem	2,-1(17)
	move	1,013
	push	17,1
	move	2,012
	push	17,2
	move	4,-5(17)
	move	6,-024(17)
	add	6,-4(17)
	move	3,0(6)
	movei	1,-022(17)
	move	2,3
	move	3,4
	move	4,011
	pushj	17,sym_record_pack
	SUB	17,[2,,2]
	movei	2,-020(17)
	move	3,-022(17)
	addi	3,0703
	move	1,3
	movei	3,015
	pushj	17,wordfile_append
	jumpe	1,%L297
	movei	1,04056
	pushj	17,das_native_die
%L297:
	move	3,-1(17)
	move	4,-022(17)
	add	4,-2(17)
	movem	3,0(4)
	move	2,-022(17)
	movem	3,0737(2)
	move	1,-3(17)
	pushj	17,sym_cache_index
	movem	1,0(17)
	move	3,-022(17)
	addi	3,0400
	move	6,1
	imuli	6,017
	add	6,3
	movem	6,-021(17)
	move	5,-3(17)
	movem	5,0(6)
	move	4,-1(17)
	move	7,-021(17)
	movem	4,1(7)
	movei	2,1
	move	3,-021(17)
	movem	2,2(3)
	move	1,-021(17)
	addi	1,3
	hrli	1,0331100
	move	2,011
	movei	3,050
	pushj	17,strcopy
	move	1,012
	move	3,-021(17)
	movem	1,015(3)
	move	2,013
	tlz	2,01777777777000000
	move	5,-021(17)
	movem	2,016(5)
%L296:
	MOVEI	0,010
	HRLI	0,-026(17)
	BLT	0,013
	SUB	17,[027,,027]
	popj	17,

visibility_hash:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,sym_hash
	xor	1,[0525252525252]
	move	10,0(17)
	SUB	17,[1,,1]
	jrst	das_mask36
%L298:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

indexed_xct_hash:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,sym_hash
	xor	1,[0252525252525]
	move	10,0(17)
	SUB	17,[1,,1]
	jrst	das_mask36
%L299:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

find_indexed_xct_marker:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[035,,035]
	movem	10,-034(17)
	move	1,011
	pushj	17,indexed_xct_hash
	movem	1,-016(17)
	move	5,1
	andi	5,0377
	movem	5,-015(17)
	add	5,-034(17)
	move	2,0(5)
	movem	2,-014(17)
%L301:
	skipn	2,-014(17)
	 jrst	%L302
	movei	1,-033(17)
	move	3,-014(17)
	subi	3,1
	muli	3,015
	trne	3,1
	 tloa	4,0400000
	 tlz	4,0400000
	move	5,-034(17)
	addi	5,0703
	move	2,4
	move	3,1
	move	1,5
	movei	4,015
	pushj	17,wordfile_read
	jumpe	1,%L303
	movei	1,04130
	pushj	17,das_native_die
%L303:
	move	1,-032(17)
	came	1,-016(17)
	 jrst	%L304
	movei	1,-013(17)
	movei	6,-033(17)
	move	2,1
	move	1,6
	pushj	17,sym_record_unpack
	movei	1,-013(17)
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L304
	move	3,-1(17)
	andi	3,030
	caie	3,030
	 jrst	%L304
	movei	1,1
	jrst	%L300
%L304:
	hrrz	2,-033(17)
	movem	2,-014(17)
	jrst	%L301
%L302:
	setz	1,
%L300:
	move	10,-036(17)
	move	11,-035(17)
	SUB	17,[037,,037]
	popj	17,

mark_indexed_xct_target:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[021,,021]
	move	1,010
	move	2,011
	pushj	17,find_indexed_xct_marker
	jumpn	1,%L305
	movem	10,-020(17)
	move	1,011
	pushj	17,indexed_xct_hash
	movem	1,-2(17)
	move	3,1
	andi	3,0377
	movem	3,-1(17)
	move	4,-020(17)
	move	2,0737(4)
	addi	2,1
	movem	2,0(17)
	push	17,[0]
	push	17,[030]
	move	2,-4(17)
	move	4,-022(17)
	add	4,-3(17)
	move	1,0(4)
	movei	3,-021(17)
	move	4,011
	move	6,3
	move	3,2
	move	2,1
	move	1,6
	pushj	17,sym_record_pack
	SUB	17,[2,,2]
	movei	2,-017(17)
	move	3,-020(17)
	addi	3,0703
	move	1,3
	movei	3,015
	pushj	17,wordfile_append
	jumpe	1,%L307
	movei	1,04166
	pushj	17,das_native_die
%L307:
	move	3,0(17)
	move	4,-020(17)
	add	4,-1(17)
	movem	3,0(4)
	move	2,-020(17)
	movem	3,0737(2)
%L305:
	move	10,-022(17)
	move	11,-021(17)
	SUB	17,[023,,023]
	popj	17,

find_visible_marker:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[035,,035]
	movem	10,-034(17)
	move	1,011
	pushj	17,visibility_hash
	movem	1,-016(17)
	move	5,1
	andi	5,0377
	movem	5,-015(17)
	add	5,-034(17)
	move	2,0(5)
	movem	2,-014(17)
%L309:
	skipn	2,-014(17)
	 jrst	%L310
	movei	1,-033(17)
	move	3,-014(17)
	subi	3,1
	muli	3,015
	trne	3,1
	 tloa	4,0400000
	 tlz	4,0400000
	move	5,-034(17)
	addi	5,0703
	move	2,4
	move	3,1
	move	1,5
	movei	4,015
	pushj	17,wordfile_read
	jumpe	1,%L311
	movei	1,04215
	pushj	17,das_native_die
%L311:
	move	1,-032(17)
	came	1,-016(17)
	 jrst	%L312
	movei	1,-013(17)
	movei	6,-033(17)
	move	2,1
	move	1,6
	pushj	17,sym_record_unpack
	movei	1,-013(17)
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L312
	move	3,-1(17)
	andi	3,030
	caie	3,030
	 jrst	%L312
	movei	2,-013(17)
	move	1,012
	pushj	17,sym_copy
	movei	1,1
	jrst	%L308
%L312:
	hrrz	2,-033(17)
	movem	2,-014(17)
	jrst	%L309
%L310:
	setz	1,
%L308:
	move	10,-037(17)
	move	11,-036(17)
	move	12,-035(17)
	SUB	17,[040,,040]
	popj	17,

mark_symbol_visible:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[035,,035]
	movei	1,-013(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,find_visible_marker
	jumpn	1,%L313
	movem	10,-034(17)
	move	1,011
	pushj	17,visibility_hash
	movem	1,-016(17)
	move	3,1
	andi	3,0377
	movem	3,-015(17)
	move	4,-034(17)
	move	2,0737(4)
	addi	2,1
	movem	2,-014(17)
	move	2,01337(10)
	push	17,2
	push	17,[030]
	move	3,-020(17)
	move	5,-036(17)
	add	5,-017(17)
	move	2,0(5)
	movei	4,-035(17)
	move	1,4
	move	4,011
	pushj	17,sym_record_pack
	SUB	17,[2,,2]
	movei	2,-033(17)
	move	3,-034(17)
	addi	3,0703
	move	1,3
	movei	3,015
	pushj	17,wordfile_append
	jumpe	1,%L315
	movei	1,04256
	pushj	17,das_native_die
%L315:
	move	3,-014(17)
	move	4,-034(17)
	add	4,-015(17)
	movem	3,0(4)
	move	2,-034(17)
	movem	3,0737(2)
%L313:
	move	10,-036(17)
	move	11,-035(17)
	SUB	17,[037,,037]
	popj	17,

symbol_visible_here:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[014,,014]
	movei	1,-013(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,find_visible_marker
	jumpn	1,%L317
	setm	1,1
	jrst	%L316
%L317:
	hrrz	2,0(17)
	tlc	2,0400000
	move	3,01337(10)
	tlc	3,0400000
	camle	2,3
	 tdza	1,1
	 movei	1,1
%L316:
	move	10,-015(17)
	move	11,-014(17)
	SUB	17,[016,,016]
	popj	17,

lit_record_words:
	addi	1,4
	subi	1,1
	lsh	1,-2
	addi	1,1
	popj	17,

literal_image_words:
	push	17,016
	push	17,010
	move	10,2
	ADD	17,[0113,,0113]
	move	2,010
	tlc	2,0400000
	caml	2,[0400000000400]
	 skipa	3,[0377]
	 trna	
	 move	10,3
	move	2,1
	movei	3,-0112(17)
	hrli	3,0331100
	move	1,3
	move	3,010
	pushj	17,das_native_memcpy
	setz	1,
	move	3,010
	PUSH	17,1
	MOVEI	16,-0113(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	movei	1,-0112(17)
	hrli	1,0331100
	pushj	17,skipws
	movem	1,-2(17)
	move	2,[POINT 9,%L325,8]
	move	3,-2(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L324
	movei	1,5
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	pushj	17,das_native_is_space
	jumpn	1,%L323
%L324:
	move	2,[POINT 9,%L327,8]
	move	3,-2(17)
	move	1,3
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L326
	move	1,-2(17)
	ibp	1
	ibp	1
	ildb	1,1
	pushj	17,das_native_is_space
	jumpn	1,%L323
%L326:
	move	2,[POINT 9,%L329,8]
	move	3,-2(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L328
	movei	1,5
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	pushj	17,das_native_is_space
	jumpn	1,%L323
%L328:
	move	2,[POINT 9,%L330,8]
	move	3,-2(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L322
	movei	2,6
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	3,2
	caie	3,050
	 jrst	%L322
%L323:
	movei	1,1
	jrst	%L320
%L322:
	move	2,[POINT 9,%L332,8]
	move	3,-2(17)
	move	1,3
	pushj	17,strstr
	jumpe	1,%L331
	movei	1,1
	jrst	%L320
%L331:
	setzb	1,0(17)
%L333:
	move	3,0(17)
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,3
	jumpe	1,%L334
	move	3,0(17)
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,3
	pushj	17,das_native_is_space
	jumpn	1,%L334
	move	4,0(17)
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	2,4
	cain	2,054
	 jrst	%L334
	move	5,0(17)
	addi	5,1
	tlc	5,0400000
	caml	5,[0400000000040]
	 jrst	%L334
	move	7,0(17)
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	7,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	7,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	3,7
	move	2,0(17)
	PUSH	17,1
	MOVEI	16,-013(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	3,2
	aos	6,0(17)
	jrst	%L333
%L334:
	setz	1,
	move	4,0(17)
	PUSH	17,1
	MOVEI	16,-013(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	skipn	3,0(17)
	 jrst	%L335
	ldb	5,[POINT 9,-012(17),8]
	caie	5,056
	 jrst	%L336
	movei	1,-012(17)
	hrli	1,0331100
	pushj	17,strlen
	movei	3,-012(17)
	hrli	3,0221100
	movei	6,-012(17)
	hrli	6,0331100
	move	2,3
	move	3,1
	move	1,6
	pushj	17,memmove
%L336:
	movei	1,-012(17)
	hrli	1,0331100
	setz	2,
	pushj	17,lookup_op
	jumpge	1,%L337
	movei	1,-012(17)
	hrli	1,0331100
	pushj	17,lookup_io
	jumpl	1,%L335
%L337:
	movei	1,1
	jrst	%L320
%L335:
	move	1,-2(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-1(17)
	jumpe	1,%L338
	move	1,-1(17)
	ibp	1
	movei	2,054
	pushj	17,strchr
	jumpn	1,%L338
	movei	1,2
	jrst	%L320
%L338:
	movei	1,1
%L320:
	move	10,-0113(17)
	move	16,-0114(17)
	SUB	17,[0115,,0115]
	popj	17,
%L332:
	.byte	9,054,054,0
	

%L330:
	.byte	9,045,0105,0130,0111
	.byte	9,0116,0104,0
	

%L329:
	.byte	9,0117,0127,0107,0102
	.byte	9,0120,0
	

%L327:
	.byte	9,0107,0111,0127,0
	

%L325:
	.byte	9,0120,0117,0111,0116
	.byte	9,0124,0
	


das_format_u10_digits:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,011
	tlc	1,0400000
	camge	1,[0400000000012]
	 jrst	%L340
	move	1,011
	SKIPL	2,1
	 TDZA	1,1
	  MOVEI	1,1
	DIVI	1,12
	move	2,1
	move	1,010
	pushj	17,das_format_u10_digits
	move	10,1
%L340:
	move	1,011
	movei	3,012
	skipge	16,3
	 JRST	%UIDN15
	JUMPGE	1,%UIDP15
	CAIG	16,1
	 JRST	%UIDZ15
	MOVE	2,1
	ANDI	2,1
	PUSH	17,02
	LSH	1,-1
	IDIV	1,016
	LSH	1,1
	LSH	2,1
	ADD	2,0(17)
	SUB	17,[1,,1]
	CAMGE	2,016
	 JRST	%UIDD15
	SUB	2,016
	AOJA	1,%UIDD15
%UIDN15:	MOVE	2,1
	MOVEI	1,0
	JUMPGE	2,%UIDD15
	CAMGE	2,016
	 JRST	%UIDD15
	SUB	2,016
	AOJA	1,%UIDD15
%UIDZ15:	TDZA	2,2
%UIDP15:	IDIV	1,016
%UIDD15:
	addi	2,060
	andi	2,0777
	move	4,010
	ibp	010
	dpb	2,4
	move	1,010
%L339:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,

das_format_u10:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[1,,1]
	move	1,010
	move	2,011
	pushj	17,das_format_u10_digits
	movem	1,0(17)
	setz	2,
	dpb	2,1
	move	3,010
	move	1,3
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	jrst	strlen
%L341:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

das_format_octal:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[4,,4]
	movem	10,-3(17)
	setz	2,
	movem	2,-1(17)
	movei	3,041
	movem	3,-2(17)
%L343:
	move	4,011
	movn	3,-2(17)
	lsh	4,0(3)
	andi	4,7
	movem	4,0(17)
	jumpn	4,%L347
	skipe	2,-1(17)
	 jrst	%L347
	skipe	5,-2(17)
	 jrst	%L346
%L347:
	move	2,0(17)
	addi	2,060
	andi	2,0777
	move	3,-3(17)
	ibp	-3(17)
	dpb	2,3
	movei	1,1
	movem	1,-1(17)
%L346:
	movni	2,3
	addb	2,-2(17)
	jumpge	2,%L343
	setz	1,
	dpb	1,-3(17)
%L342:
	move	10,-5(17)
	move	11,-4(17)
	SUB	17,[6,,6]
	popj	17,

set_snapshot_name:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[6,,6]
	move	1,012
	jumpe	1,%L348
	move	2,[POINT 9,%L350,8]
	move	3,012
	move	1,011
	pushj	17,strcopy
	move	1,011
	pushj	17,strlen
	movem	1,-1(17)
	movei	1,-5(17)
	hrli	1,0331100
	move	2,010
	pushj	17,das_format_u10
	movem	1,0(17)
	add	1,-1(17)
	move	3,1
	tlc	3,0400000
	move	2,012
	tlc	2,0400000
	camge	3,2
	 jrst	%L351
	move	4,012
	subi	4,1
	sub	4,-1(17)
	movem	4,0(17)
%L351:
	skipn	2,0(17)
	 jrst	%L352
	move	2,0(17)
	movei	1,-5(17)
	hrli	1,0331100
	move	5,-1(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	5,-1(17)
	MOVEM	11,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	5,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	3,2
	move	2,1
	move	1,5
	pushj	17,das_native_memcpy
%L352:
	setz	1,
	move	3,0(17)
	add	3,-1(17)
	move	2,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
%L348:
	move	10,-010(17)
	move	11,-7(17)
	move	12,-6(17)
	move	16,-011(17)
	SUB	17,[012,,012]
	popj	17,
%L350:
	.byte	9,045,044,0104,0101
	.byte	9,0123,044,0123,0
	


set_snapshot_lookup:
	push	17,010
	move	10,1
	push	17,011
	move	11,3
	ADD	17,[013,,013]
	move	3,012(2)
	andi	3,030
	cain	3,020
	 jrst	%L354
	setz	1,
	jrst	%L353
%L354:
	hrrz	3,013(2)
	movem	3,0(17)
	jumpe	3,%L356
	tlc	3,0400000
	move	4,01336(10)
	tlc	4,0400000
	camg	3,4
	 jrst	%L355
%L356:
	setz	1,
	jrst	%L353
%L355:
	movei	2,-012(17)
	hrli	2,0331100
	move	3,0(17)
	move	1,3
	movei	3,050
	pushj	17,set_snapshot_name
	movei	2,-012(17)
	hrli	2,0331100
	move	3,011
	move	1,010
	pushj	17,find_sym
	jumpn	1,%L357
	setm	1,1
	jrst	%L353
%L357:
	move	2,012(11)
	andi	2,030
	caie	2,010
	 tdza	1,1
	 movei	1,1
%L353:
	move	10,-014(17)
	move	11,-013(17)
	SUB	17,[015,,015]
	popj	17,

set_snapshot_define:
	push	17,010
	move	10,1
	push	17,011
	move	11,3
	push	17,012
	move	12,4
	ADD	17,[012,,012]
	movei	1,-011(17)
	hrli	1,0331100
	move	6,2
	move	2,1
	move	1,6
	movei	3,050
	pushj	17,set_snapshot_name
	move	3,011
	iori	3,010
	movei	2,-011(17)
	hrli	2,0331100
	move	4,012
	move	1,010
	pushj	17,add_sym
%L360:
	move	10,-014(17)
	move	11,-013(17)
	move	12,-012(17)
	SUB	17,[015,,015]
	popj	17,

literal_first_token_is_operator:
	push	17,016
	ADD	17,[014,,014]
	move	3,2
	move	5,3
	move	16,1
	ADD	17,[3,,3]
	MOVEM	5,-02(17)
	MOVEM	16,-01(17)
	MOVEM	15,00(17)
	MOVE	6,-02(17)
	ANDI	6,0777777
	MOVE	5,-01(17)
	ANDI	5,0777777
	SUB	6,5
	IMULI	6,04
	HLRZ	15,-02(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	ADD	6,15
	HLRZ	15,-01(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	SUB	6,15
	MOVE	15,00(17)
	SUB	17,[3,,3]
	movem	6,-1(17)
	skipn	3,6
	 jrst	%L363
	tlc	3,0400000
	camg	3,[0400000000047]
	 jrst	%L362
%L363:
	setz	1,
	jrst	%L361
%L362:
	move	3,-1(17)
	move	2,1
	movei	4,-013(17)
	hrli	4,0331100
	move	1,4
	pushj	17,das_native_memcpy
	setz	1,
	move	4,-1(17)
	PUSH	17,1
	MOVEI	16,-014(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	ldb	3,[POINT 9,-013(17),8]
	movei	2,056
	came	3,2
	 jrst	%L364
	movei	1,-013(17)
	hrli	1,0331100
	pushj	17,strlen
	movei	3,-013(17)
	hrli	3,0221100
	movei	6,-013(17)
	hrli	6,0331100
	move	2,3
	move	3,1
	move	1,6
	pushj	17,memmove
%L364:
	movei	1,0(17)
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,lookup_op
	jumpge	1,%L366
	movei	1,-013(17)
	hrli	1,0331100
	pushj	17,lookup_io
	jumpl	1,%L365
%L366:
	movei	1,1
	jrst	%L361
%L365:
	move	1,[POINT 9,%L369,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,5
	pushj	17,pref_i
	jumpn	1,%L368
	move	1,[POINT 9,%L370,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,3
	pushj	17,pref_i
	jumpn	1,%L368
	move	1,[POINT 9,%L371,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,5
	pushj	17,pref_i
	jumpn	1,%L368
	move	1,[POINT 9,%L372,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L367
%L368:
	movei	1,1
	jrst	%L361
%L367:
	setz	1,
%L361:
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,
%L372:
	.byte	9,045,0105,0130,0111
	.byte	9,0116,0104,0
	

%L371:
	.byte	9,0117,0127,0107,0102
	.byte	9,0120,0
	

%L370:
	.byte	9,0107,0111,0127,0
	

%L369:
	.byte	9,0120,0117,0111,0116
	.byte	9,0124,0
	


literal_canonicalize:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[073,,073]
	skipe	2,-0101(17)
	 jrst	%L373
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L373:
	move	4,-076(17)
	movem	4,-072(17)
	move	3,-077(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	4,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	3,-071(17)
	setz	1,
	movem	1,-070(17)
	setm	2,1
	movem	2,-067(17)
	movei	5,1
	movem	5,-066(17)
%L374:
	skipl	2,-072(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-071(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L375
	skipn	4,-067(17)
	 jrst	%L376
	move	5,-070(17)
	addi	5,1
	tlc	5,0400000
	move	6,-0101(17)
	tlc	6,0400000
	camge	5,6
	 jrst	%L377
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L377:
	ldb	1,-072(17)
	aos	2,-070(17)
	subi	2,1
	PUSH	17,1
	move	16,-0101(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,2
	ldb	3,-072(17)
	camn	3,-067(17)
	 tdza	4,4
	 trna	
	 movem	4,-067(17)
	ibp	-072(17)
	move	5,-072(17)
	jrst	%L374
%L376:
	ldb	1,-072(17)
	cain	1,047
	 jrst	%L380
	caie	1,042
	 jrst	%L379
%L380:
	ldb	1,-072(17)
	andi	1,0777
	movem	1,-067(17)
	move	3,-070(17)
	addi	3,1
	tlc	3,0400000
	move	4,-0101(17)
	tlc	4,0400000
	camge	3,4
	 jrst	%L381
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L381:
	move	2,-072(17)
	ibp	-072(17)
	ldb	1,2
	aos	2,-070(17)
	subi	2,1
	PUSH	17,1
	move	16,-0101(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,2
	jrst	%L374
%L379:
	ldb	1,-072(17)
	andi	1,0777
	pushj	17,isname0
	jumpe	1,%L382
	move	2,-072(17)
	ibp	2
	movem	2,-065(17)
%L383:
	skipl	2,-065(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-071(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L384
	ldb	1,-065(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L384
	ibp	-065(17)
	move	2,-065(17)
	jrst	%L383
%L384:
	move	4,-065(17)
	move	16,-072(17)
	ADD	17,[3,,3]
	MOVEM	4,-02(17)
	MOVEM	16,-01(17)
	MOVEM	15,00(17)
	MOVE	5,-02(17)
	ANDI	5,0777777
	MOVE	4,-01(17)
	ANDI	4,0777777
	SUB	5,4
	IMULI	5,04
	HLRZ	15,-02(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	ADD	5,15
	HLRZ	15,-01(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	SUB	5,15
	MOVE	15,00(17)
	SUB	17,[3,,3]
	movem	5,-052(17)
	setz	1,
	movem	1,-035(17)
	move	3,5
	tlc	3,0400000
	camle	3,[0400000000047]
	 jrst	%L385
	move	2,-052(17)
	move	6,-072(17)
	movei	1,-064(17)
	hrli	1,0331100
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	setz	1,
	move	4,-052(17)
	PUSH	17,1
	MOVEI	16,-065(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	skipn	3,-066(17)
	 jrst	%L386
	move	2,-065(17)
	move	1,-072(17)
	pushj	17,literal_first_token_is_operator
	jumpn	1,%L385
%L386:
	movei	3,-051(17)
	movei	2,-064(17)
	hrli	2,0331100
	move	4,-075(17)
	move	1,4
	pushj	17,find_sym
	jumpe	1,%L385
	move	3,-037(17)
	andi	3,030
	cain	3,020
	 skipa	2,[1]
	 trna	
	 movem	2,-035(17)
%L385:
	skipn	2,-035(17)
	 jrst	%L388
	hrrz	3,-036(17)
	movem	3,0(17)
	movei	3,-014(17)
	movei	2,-051(17)
	move	4,-075(17)
	move	1,4
	pushj	17,set_snapshot_lookup
	jumpe	1,%L390
	move	3,-2(17)
	trne	3,7
	 jrst	%L390
	movei	2,060
	dpb	2,[POINT 9,-034(17),8]
	move	2,-1(17)
	tlz	2,01777777777000000
	movei	1,-034(17)
	hrli	1,0221100
	pushj	17,das_format_octal
	jrst	%L389
%L390:
	movei	2,-034(17)
	hrli	2,0331100
	move	3,0(17)
	move	1,3
	movei	3,077
	pushj	17,set_snapshot_name
%L389:
	movei	1,-034(17)
	hrli	1,0331100
	pushj	17,strlen
	movem	1,-052(17)
	add	1,-070(17)
	move	3,1
	tlc	3,0400000
	move	4,-0101(17)
	tlc	4,0400000
	camge	3,4
	 jrst	%L391
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L391:
	move	3,-052(17)
	movei	1,-034(17)
	hrli	1,0331100
	move	4,-070(17)
	PUSH	17,1
	move	16,-0101(17)
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	2,1
	move	1,4
	pushj	17,das_native_memcpy
	move	2,-052(17)
	addb	2,-070(17)
	jrst	%L387
%L388:
	move	2,-052(17)
	add	2,-070(17)
	tlc	2,0400000
	move	3,-0101(17)
	tlc	3,0400000
	camge	2,3
	 jrst	%L392
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L392:
	move	2,-052(17)
	move	3,-072(17)
	move	1,-070(17)
	move	16,-0100(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	move	6,3
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	move	2,-052(17)
	addb	2,-070(17)
%L387:
	move	2,-065(17)
	movem	2,-072(17)
	setz	1,
	movem	1,-066(17)
	jrst	%L374
%L382:
	ldb	1,-072(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpn	1,%L393
	setm	2,1
	movem	2,-066(17)
%L393:
	move	2,-070(17)
	addi	2,1
	tlc	2,0400000
	move	3,-0101(17)
	tlc	3,0400000
	camge	2,3
	 jrst	%L394
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L394:
	move	2,-072(17)
	ibp	-072(17)
	ldb	1,2
	aos	2,-070(17)
	subi	2,1
	PUSH	17,1
	move	16,-0101(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,2
	jrst	%L374
%L375:
	setz	1,
	move	3,-070(17)
	PUSH	17,1
	move	16,-0101(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	move	1,-070(17)
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

lit_find_text:
	push	17,016
	ADD	17,[016,,016]
	MOVEI	0,-015(17)
	HRLI	0,010
	BLT	0,-012(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movei	1,das_native_output_buffer
	movem	1,-011(17)
	move	2,[POINT 9,das_native_tmp,8]
	movem	2,-010(17)
	setz	3,
	movem	3,-6(17)
	setm	4,3
	movem	4,-5(17)
	setz	5,
	movem	5,-4(17)
%L396:
	move	2,-4(17)
	tlc	2,0400000
	move	3,0776(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L397
	movei	1,-7(17)
	move	3,-6(17)
	move	6,010
	addi	6,0742
	move	2,3
	move	3,1
	move	1,6
	movei	4,1
	pushj	17,wordfile_read
	jumpe	1,%L399
	movei	1,05246
	pushj	17,das_native_die
%L399:
	move	3,-7(17)
	movem	3,-3(17)
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L400
	movei	1,05252
	pushj	17,das_native_die
%L400:
	move	1,-3(17)
	pushj	17,lit_record_words
	movem	1,-2(17)
	move	3,1
	tlc	3,0400000
	camg	3,[0400000000001]
	 jrst	%L401
	move	2,-2(17)
	subi	2,1
	move	3,-011(17)
	move	6,-6(17)
	addi	6,1
	move	1,010
	addi	1,0742
	move	4,2
	move	2,6
	pushj	17,wordfile_read
	jumpe	1,%L401
	movei	1,05264
	pushj	17,das_native_die
%L401:
	move	2,-3(17)
	move	3,-011(17)
	move	1,-010(17)
	move	4,2
	movei	2,0400
	pushj	17,unpack_text_words
	move	2,-3(17)
	came	2,012
	 jrst	%L402
	movei	3,1
	movem	3,0(17)
	setz	4,
	movem	4,-1(17)
%L403:
	move	2,-1(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L404
	move	4,-1(17)
	PUSH	17,1
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	3,4
	move	6,-1(17)
	move	5,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	5,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	7,6
	camn	3,7
	 jrst	%L405
	setzb	1,0(17)
	jrst	%L404
%L405:
	aos	1,-1(17)
	jrst	%L403
%L404:
	skipn	2,0(17)
	 jrst	%L406
	skipe	1,013
	 skipa	4,-5(17)
	 trna	
	 movem	4,0(13)
	movei	1,1
	jrst	%L395
%L406:
%L402:
	move	2,-3(17)
	move	1,-010(17)
	pushj	17,literal_image_words
	addb	1,-5(17)
	move	3,-2(17)
	addb	3,-6(17)
	aos	2,-4(17)
	jrst	%L396
%L397:
	setz	1,
%L395:
	MOVEI	0,010
	HRLI	0,-015(17)
	BLT	0,013
	move	16,-016(17)
	SUB	17,[017,,017]
	popj	17,

add_lit_text:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[0204,,0204]
	move	3,012
	movem	3,-2(17)
	tlc	3,0400000
	caml	3,[0400000000400]
	 skipa	1,[0377]
	 trna	
	 movem	1,-2(17)
	push	17,[0400]
	movei	1,-0103(17)
	hrli	1,0331100
	move	3,-3(17)
	move	2,011
	move	4,1
	move	1,010
	pushj	17,literal_canonicalize
	SUB	17,[1,,1]
	movem	1,0(17)
	skipge	5,1
	 jrst	%L410
	movei	2,-0102(17)
	hrli	2,0331100
	move	11,2
	movem	1,-2(17)
%L410:
	move	2,-2(17)
	move	1,010
	move	3,2
	move	2,011
	setz	4,
	pushj	17,lit_find_text
	jumpn	1,%L408
	move	1,-2(17)
	pushj	17,lit_record_words
	movem	1,-1(17)
	move	3,-2(17)
	movem	3,-0203(17)
	move	2,-2(17)
	move	3,-1(17)
	subi	3,1
	movei	1,-0202(17)
	move	4,2
	move	2,3
	move	3,011
	pushj	17,pack_text_words
	move	2,-1(17)
	movei	1,-0203(17)
	move	6,010
	addi	6,0742
	move	3,2
	move	2,1
	move	1,6
	pushj	17,wordfile_append
	jumpe	1,%L412
	movei	1,05343
	pushj	17,das_native_die
%L412:
	aos	1,0776(10)
	move	3,-1(17)
	addb	3,0777(10)
	move	2,-2(17)
	move	1,011
	pushj	17,literal_image_words
	move	3,01000(10)
	add	3,1
	movem	3,01000(10)
%L408:
	move	10,-0206(17)
	move	11,-0205(17)
	move	12,-0204(17)
	SUB	17,[0207,,0207]
	popj	17,

lit_stream_reset:
	setzb	2,01001(1)
	setm	3,2
	movem	3,01002(1)
	setzb	4,01003(1)
	setm	5,4
	movem	5,01004(1)
	popj	17,

lit_stream_word:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	3,010
	addi	3,0742
	push	17,3
	ADD	17,[1,,1]
	move	1,040(3)
	tlc	1,0400000
	move	4,-1(17)
	move	2,041(4)
	tlc	2,0400000
	camge	1,2
	 jrst	%L414
	move	6,-1(17)
	move	5,037(6)
	tlc	5,0400000
	move	1,-1(17)
	move	7,035(1)
	tlc	7,0400000
	camge	5,7
	 jrst	%L415
	seto	1,
	jrst	%L413
%L415:
	move	4,-1(17)
	move	3,035(4)
	sub	3,037(4)
	movem	3,0(17)
	tlc	3,0400000
	camle	3,[0400000000040]
	 skipa	1,[040]
	 trna	
	 movem	1,0(17)
	move	4,0(17)
	move	3,-1(17)
	addi	3,043
	move	6,-1(17)
	move	1,037(6)
	move	2,1
	move	1,6
	pushj	17,wordfile_read
	jumpe	1,%L417
	seto	1,
	jrst	%L413
%L417:
	move	2,0(17)
	move	6,-1(17)
	addb	2,037(6)
	setzb	1,040(6)
	move	4,0(17)
	movem	4,041(6)
%L414:
	move	3,-1(17)
	aos	1,040(3)
	add	1,3
	move	2,042(1)
	movem	2,0(11)
	setz	1,
%L413:
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	popj	17,

lit_read_next:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[6,,6]
	move	2,01004(10)
	tlc	2,0400000
	move	3,0776(10)
	tlc	3,0400000
	camge	2,3
	 jrst	%L419
	seto	1,
	jrst	%L418
%L419:
	movei	2,-5(17)
	move	1,010
	pushj	17,lit_stream_word
	jumpe	1,%L420
	seto	1,
	jrst	%L418
%L420:
	move	3,-5(17)
	movem	3,-3(17)
	tlc	3,0400000
	camge	3,[0400000000400]
	 skipn	1,012
	 jrst	%L422
	move	4,-3(17)
	tlc	4,0400000
	move	2,012
	tlc	2,0400000
	camge	4,2
	 jrst	%L421
%L422:
	seto	1,
	jrst	%L418
%L421:
	setz	1,
	movem	1,-4(17)
	setm	2,1
	movem	2,-2(17)
%L423:
	move	2,-2(17)
	tlc	2,0400000
	move	3,-3(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L424
	move	5,-2(17)
	andi	5,3
	movem	5,-1(17)
	jumpn	5,%L426
	movei	2,-4(17)
	move	1,010
	pushj	17,lit_stream_word
	jumpe	1,%L426
	seto	1,
	jrst	%L418
%L426:
	move	2,-1(17)
	muli	2,011
	trne	2,1
	 tloa	3,0400000
	 tlz	3,0400000
	movn	5,3
	addi	5,033
	movem	5,0(17)
	move	4,-4(17)
	movn	5,5
	lsh	4,0(5)
	andi	4,0177
	andi	4,0777
	move	6,-2(17)
	move	1,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	4,6
	aos	7,-2(17)
	jrst	%L423
%L424:
	setz	1,
	move	3,-3(17)
	move	2,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	aos	4,01004(10)
	setz	1,
%L418:
	move	10,-010(17)
	move	11,-7(17)
	move	12,-6(17)
	move	16,-011(17)
	SUB	17,[012,,012]
	popj	17,

text_total:
	move	2,1
	addi	2,01135
	movei	3,1
	add	3,2
	move	4,0(3)
	move	6,01000(1)
	add	4,6
	move	1,4
	popj	17,

sec_base:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	skipn	1,011
	 jrst	%L429
	move	2,011
	cain	2,4
	 jrst	%L429
	move	3,011
	movei	4,1
	came	3,4
	 jrst	%L428
%L429:
	setz	1,
	jrst	%L427
%L428:
	move	1,011
	caie	1,2
	 jrst	%L430
	move	1,010
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	jrst	text_total
%L430:
	move	1,010
	pushj	17,text_total
	move	2,01137(10)
	add	1,2
%L427:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

strip_brackets:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	move	1,010
	pushj	17,skipws
	movem	1,-1(17)
	move	3,1
	camn	3,010
	 jrst	%L432
	move	1,-1(17)
	pushj	17,strlen
	addi	1,1
	move	3,-1(17)
	move	2,010
	move	6,2
	move	2,3
	move	3,1
	move	1,6
	pushj	17,memmove
%L432:
	move	1,010
	pushj	17,strlen
	movem	1,0(17)
%L433:
	skipn	2,0(17)
	 jrst	%L434
	move	2,0(17)
	subi	2,1
	move	1,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,2
	pushj	17,das_native_is_space
	jumpe	1,%L434
	setz	2,
	sos	3,0(17)
	move	4,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	4,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	2,3
	jrst	%L433
%L434:
	move	2,0(17)
	tlc	2,0400000
	camge	2,[0400000000002]
	 jrst	%L435
	move	1,010
	ldb	3,1
	caie	3,0133
	 jrst	%L435
	move	5,0(17)
	subi	5,1
	move	4,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	5,-1(17)
	MOVEM	4,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	5,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	6,5
	caie	6,0135
	 jrst	%L435
	move	2,0(17)
	subi	2,2
	movei	3,1
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,memmove
	setz	1,
	move	3,0(17)
	subi	3,2
	move	2,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
%L435:
%L431:
	move	10,-2(17)
	move	16,-3(17)
	SUB	17,[4,,4]
	popj	17,

parse_expr_integer_base:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[4,,4]
	move	3,0(10)
	movem	3,-3(17)
	movem	12,-1(17)
	ldb	2,3
	caie	2,060
	 jrst	%L437
	ildb	6,3
	iori	6,040
	movem	6,0(17)
	caie	6,0144
	 jrst	%L438
	movei	4,012
	movem	4,-1(17)
	move	5,-3(17)
	ibp	5
	ibp	5
	movem	5,-3(17)
	jrst	%L437
%L438:
	move	2,0(17)
	caie	2,0157
	 jrst	%L439
	movei	1,010
	movem	1,-1(17)
	move	3,-3(17)
	ibp	3
	ibp	3
	movem	3,-3(17)
	jrst	%L437
%L439:
	move	2,0(17)
	caie	2,0170
	 jrst	%L440
	movei	1,020
	movem	1,-1(17)
	move	3,-3(17)
	ibp	3
	ibp	3
	movem	3,-3(17)
	jrst	%L437
%L440:
	move	2,0(17)
	caie	2,0142
	 jrst	%L441
	movei	3,2
	movem	3,-1(17)
	PUSH	17,1
	move	16,-4(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	3,-3(17)
	jrst	%L437
%L441:
	move	1,-3(17)
	ildb	2,1
	caige	2,060
	 jrst	%L437
	move	3,-3(17)
	ildb	4,3
	caig	4,067
	 skipa	5,[010]
	 trna	
	 movem	5,-1(17)
%L437:
	move	3,-1(17)
	movei	1,-2(17)
	move	4,-3(17)
	move	2,1
	move	1,4
	pushj	17,strtol
	pushj	17,das_mask36
	movem	1,0(11)
	move	3,-2(17)
	came	3,-3(17)
	 jrst	%L442
	seto	1,
	jrst	%L436
%L442:
	move	2,-2(17)
	movem	2,0(10)
	setz	1,
%L436:
	move	10,-6(17)
	move	11,-5(17)
	move	12,-4(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

parse_expr_integer:
	movei	3,010
	jrst	parse_expr_integer_base

opt_move_literal_immediate:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	skipn	2,das_optimize
	 jrst	%L445
	move	3,016(10)
	jumpn	3,%L445
	move	4,017(10)
	camn	4,[015172605]
	 jrst	%L444
%L445:
	setz	1,
	jrst	%L443
%L444:
	skipe	2,024(10)
	 jrst	%L446
	setm	1,2
	jrst	%L443
%L446:
	move	2,020(10)
	movem	2,0(11)
	move	4,023(10)
	movem	4,-1(17)
	ibp	-1(17)
	ldb	1,4
	cain	1,0133
	 jrst	%L447
	setz	1,
	jrst	%L443
%L447:
	move	1,-1(17)
	pushj	17,skipws
	movem	1,-1(17)
	ldb	2,1
	cain	2,055
	 jrst	%L449
	movei	1,0(17)
	movei	6,-1(17)
	move	2,1
	move	1,6
	pushj	17,parse_expr_integer
	jumpn	1,%L449
	move	3,0(17)
	tlc	3,0400000
	camg	3,[0400000777777]
	 jrst	%L448
%L449:
	setz	1,
	jrst	%L443
%L448:
	move	1,-1(17)
	pushj	17,skipws
	movem	1,-1(17)
	move	3,1
	ibp	-1(17)
	ldb	1,3
	cain	1,0135
	 jrst	%L450
	setz	1,
	jrst	%L443
%L450:
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L451
	setz	1,
	jrst	%L443
%L451:
	move	2,0(17)
	movem	2,0(12)
	movei	1,1
%L443:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

expr_error:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	skipe	2,5(10)
	 jrst	%L453
	move	3,0(10)
	move	1,01335(3)
	jumpn	1,%L453
	movei	1,05637
	pushj	17,das_native_diag
%L453:
	movei	1,1
	movem	1,5(10)
%L452:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

expr_abs:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	move	1,010
	pushj	17,das_mask36
	movem	1,-1(17)
	setzb	2,0(17)
	move	1,-1(17)
	move	2,0(17)
%L454:
	move	10,-2(17)
	move	16,-3(17)
	SUB	17,[4,,4]
	popj	17,

expr_require_abs:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-2(17)
	movem	3,-1(17)
	movem	4,-3(17)
	push	17,6
	skipe	2,-2(17)
	 jrst	%L456
	skipn	3,-4(17)
	 jrst	%L455
%L456:
	move	2,-1(17)
	skipe	1,5(2)
	 jrst	%L457
	movei	1,05667
	pushj	17,das_native_diag
%L457:
	movei	1,1
	move	3,-1(17)
	movem	1,5(3)
	seto	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L455:
	setz	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

expr_shift_right:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	skipe	1,011
	 jrst	%L459
	move	1,010
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	jrst	das_mask36
%L459:
	move	1,011
	tlc	1,0400000
	camge	1,[0400000000044]
	 jrst	%L460
	tlnn	10,0400000
	 jrst	%L461
	move	1,[0777777777777]
	jrst	%L462
%L461:
	setz	1,
%L462:
	jrst	%L458
%L460:
	move	1,010
	and	1,[0400000000000]
	movem	1,-1(17)
	move	2,011
	move	3,010
	movn	2,2
	lsh	3,0(2)
	move	10,3
	jumpe	1,%L463
	move	7,[0777777777777]
	movn	5,011
	ash	7,0(5)
	eqvi	7,0
	movem	7,0(17)
	iorb	7,010
%L463:
	move	1,010
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	jrst	das_mask36
%L458:
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	popj	17,

expr_signed_div:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[5,,5]
	tlnn	10,0400000
	 tdza	2,2
	 movei	2,1
	movem	2,-4(17)
	tlnn	11,0400000
	 tdza	4,4
	 movei	4,1
	movem	4,-3(17)
	skipn	6,-4(17)
	 jrst	%L469
	movn	1,010
	pushj	17,das_mask36
	jrst	%L470
%L469:
	move	1,010
%L470:
	movem	1,-2(17)
	skipn	3,-3(17)
	 jrst	%L471
	movn	1,011
	pushj	17,das_mask36
	jrst	%L472
%L471:
	move	1,011
%L472:
	movem	1,-1(17)
	skipn	2,012
	 jrst	%L474
	move	4,-2(17)
	skipge	16,1
	 JRST	%UIDN16
	JUMPGE	4,%UIDP16
	CAIG	16,1
	 JRST	%UIDZ16
	MOVE	5,4
	ANDI	5,1
	PUSH	17,05
	LSH	4,-1
	IDIV	4,016
	LSH	4,1
	LSH	5,1
	ADD	5,0(17)
	SUB	17,[1,,1]
	CAMGE	5,016
	 JRST	%UIDD16
	SUB	5,016
	AOJA	4,%UIDD16
%UIDN16:	MOVE	5,4
	MOVEI	4,0
	JUMPGE	5,%UIDD16
	CAMGE	5,016
	 JRST	%UIDD16
	SUB	5,016
	AOJA	4,%UIDD16
%UIDZ16:	TDZA	5,5
%UIDP16:	IDIV	4,016
%UIDD16:
	movem	5,0(17)
	skipn	6,-4(17)
	 jrst	%L473
	movn	1,0(17)
	pushj	17,das_mask36
	movem	1,0(17)
	jrst	%L473
%L474:
	move	2,-2(17)
	skipge	16,-1(17)
	 JRST	%UIDN17
	JUMPGE	2,%UIDP17
	CAIG	16,1
	 JRST	%UIDZ17
	MOVE	3,2
	ANDI	3,1
	PUSH	17,03
	LSH	2,-1
	IDIV	2,016
	LSH	2,1
	LSH	3,1
	ADD	3,0(17)
	SUB	17,[1,,1]
	CAMGE	3,016
	 JRST	%UIDD17
	SUB	3,016
	AOJA	2,%UIDD17
%UIDN17:	MOVE	3,2
	MOVEI	2,0
	JUMPGE	3,%UIDD17
	CAMGE	3,016
	 JRST	%UIDD17
	SUB	3,016
	AOJA	2,%UIDD17
%UIDZ17:	TDZA	3,3
%UIDP17:	IDIV	2,016
%UIDD17:
	movem	2,0(17)
	move	3,-4(17)
	camn	3,-3(17)
	 jrst	%L473
	movn	1,0(17)
	pushj	17,das_mask36
	movem	1,0(17)
%L473:
	move	1,0(17)
%L464:
	move	10,-7(17)
	move	11,-6(17)
	move	12,-5(17)
	move	16,-010(17)
	SUB	17,[011,,011]
	popj	17,

set_snapshot_generation:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	move	2,[POINT 9,%L477,8]
	move	1,010
	movei	3,7
	pushj	17,pref_i
	jumpn	1,%L476
	setm	1,1
	jrst	%L475
%L476:
	move	1,010
	movei	5,7
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	5,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	5,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	5,-2(17)
	ldb	3,5
	caige	3,060
	 jrst	%L479
	caig	3,071
	 jrst	%L478
%L479:
	setz	1,
	jrst	%L475
%L478:
	movei	2,0(17)
	move	3,-2(17)
	move	1,3
	movei	3,012
	pushj	17,strtol
	movem	1,-1(17)
	ldb	2,0(17)
	jumpn	2,%L481
	skipn	5,1
	 jrst	%L481
	tlc	5,0400000
	camg	5,[0400000777777]
	 jrst	%L480
%L481:
	setz	1,
	jrst	%L475
%L480:
	move	1,-1(17)
%L475:
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,
%L477:
	.byte	9,045,044,0104,0101
	.byte	9,0123,044,0123,0
	


resolve_set_symbol:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[014,,014]
	move	2,012(11)
	andi	2,030
	movei	1,020
	camn	2,1
	 jrst	%L483
	movei	1,1
	jrst	%L482
%L483:
	movei	1,-013(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,set_snapshot_lookup
	jumpn	1,%L484
	setm	1,1
	jrst	%L482
%L484:
	move	2,011
	MOVEI	16,(2)
	HRLI	16,-013(17)
	BLT	16,13(2)
	movei	1,1
%L482:
	move	10,-015(17)
	move	11,-014(17)
	move	16,-016(17)
	SUB	17,[017,,017]
	popj	17,

parse_expr_primary:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[034,,034]
	movei	1,-033(17)
	push	17,1
	setz	1,
	pushj	17,expr_abs
	pop	17,3
	movem	1,0(3)
	movem	2,1(3)
	move	2,2(10)
	move	1,2
	pushj	17,skipws
	movem	1,2(10)
	ldb	2,1
	caie	2,050
	 jrst	%L486
	ibp	2(10)
	move	3,2(10)
	movei	1,-033(17)
	push	17,1
	move	1,010
	pushj	17,parse_expr_or
	pop	17,3
	movem	1,0(3)
	movem	2,1(3)
	move	2,2(10)
	move	1,2
	pushj	17,skipws
	movem	1,2(10)
	ldb	2,1
	cain	2,051
	 jrst	%L487
	move	2,[POINT 9,%L488,8]
	move	1,010
	pushj	17,expr_error
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L487:
	ibp	2(10)
	move	1,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L486:
	move	2,2(10)
	ldb	1,2
	caie	1,056
	 jrst	%L489
	movei	1,1
	move	16,2(10)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	pushj	17,das_native_is_digit
	jumpe	1,%L489
	movei	2,1
	PUSH	17,1
	move	16,2(10)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,-3(17)
	movei	3,2
	movem	3,0(17)
	movei	4,045
	dpb	4,[POINT 9,-015(17),8]
	movei	5,0114
	dpb	5,[POINT 9,-015(17),17]
%L490:
	ldb	1,-3(17)
	pushj	17,das_native_is_digit
	jumpe	1,%L491
	move	3,0(17)
	cail	3,047
	 jrst	%L491
	move	4,-3(17)
	ibp	-3(17)
	ldb	1,4
	aos	2,0(17)
	PUSH	17,1
	MOVEI	16,-017(17)
	HRLI	16,01100
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,2
	jrst	%L490
%L491:
	setz	1,
	move	4,0(17)
	PUSH	17,1
	MOVEI	16,-016(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	movei	1,-031(17)
	movei	2,-015(17)
	hrli	2,0331100
	move	4,0(10)
	move	3,1
	move	1,4
	pushj	17,find_sym
	jumpn	1,%L492
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L493
	movei	1,06100
	pushj	17,das_native_diag
%L493:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L492:
	move	2,-017(17)
	andi	2,030
	caie	2,020
	 jrst	%L494
	hrrz	1,-016(17)
	jrst	%L495
%L494:
	movei	1,-015(17)
	hrli	1,0331100
	pushj	17,set_snapshot_generation
%L495:
	movem	1,-1(17)
	movei	1,-031(17)
	move	3,0(10)
	move	2,1
	move	1,3
	pushj	17,resolve_set_symbol
	jumpn	1,%L496
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L497
	movei	1,06112
	pushj	17,das_native_diag
%L497:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L496:
	move	2,-017(17)
	andi	2,7
	caie	2,4
	 jrst	%L499
	move	3,-016(17)
	movem	3,-033(17)
	jrst	%L498
%L499:
	move	2,-017(17)
	andi	2,7
	move	3,0(10)
	move	1,3
	pushj	17,sec_base
	add	1,-016(17)
	movem	1,-033(17)
%L498:
	move	1,-033(17)
	pushj	17,das_mask36
	movem	1,-033(17)
	move	3,-017(17)
	trnn	3,7
	 tdza	2,2
	 movei	2,1
	movem	2,-032(17)
	move	5,-3(17)
	movem	5,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L489:
	move	2,2(10)
	ldb	1,2
	caie	1,056
	 jrst	%L502
	move	4,3(10)
	movem	4,-033(17)
	movei	3,1
	movem	3,-032(17)
	ibp	2(10)
	move	5,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L502:
	move	2,2(10)
	ldb	1,2
	pushj	17,das_native_is_digit
	jumpe	1,%L503
	move	3,2(10)
	movem	3,-3(17)
	move	2,4(10)
	movei	1,-2(17)
	movei	6,-3(17)
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_expr_integer_base
	jumpe	1,%L504
	move	2,[POINT 9,%L505,8]
	move	1,010
	pushj	17,expr_error
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L504:
	move	2,-2(17)
	movem	2,-033(17)
	move	3,-3(17)
	movem	3,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L503:
	move	2,2(10)
	ldb	1,2
	pushj	17,isname0
	jumpe	1,%L506
	setzb	2,0(17)
%L507:
	move	2,2(10)
	ldb	1,2
	pushj	17,isname
	jumpe	1,%L508
	move	3,0(17)
	cail	3,047
	 jrst	%L508
	move	4,2(10)
	ibp	2(10)
	ldb	1,4
	aos	2,0(17)
	PUSH	17,1
	MOVEI	16,-017(17)
	HRLI	16,01100
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,2
	jrst	%L507
%L508:
	setz	1,
	move	4,0(17)
	PUSH	17,1
	MOVEI	16,-016(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	movei	1,-031(17)
	movei	2,-015(17)
	hrli	2,0331100
	move	4,0(10)
	move	3,1
	move	1,4
	pushj	17,find_sym
	jumpn	1,%L509
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L510
	movei	1,06202
	pushj	17,das_native_diag
%L510:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L509:
	move	2,-017(17)
	andi	2,030
	caie	2,020
	 jrst	%L511
	hrrz	1,-016(17)
	jrst	%L512
%L511:
	movei	1,-015(17)
	hrli	1,0331100
	pushj	17,set_snapshot_generation
%L512:
	movem	1,-1(17)
	movei	1,-031(17)
	move	3,0(10)
	move	2,1
	move	1,3
	pushj	17,resolve_set_symbol
	jumpn	1,%L513
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L514
	movei	1,06214
	pushj	17,das_native_diag
%L514:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L513:
	move	2,-017(17)
	andi	2,7
	caie	2,4
	 jrst	%L516
	move	3,-016(17)
	movem	3,-033(17)
	jrst	%L515
%L516:
	move	2,-017(17)
	andi	2,7
	move	3,0(10)
	move	1,3
	pushj	17,sec_base
	add	1,-016(17)
	movem	1,-033(17)
%L515:
	move	1,-033(17)
	pushj	17,das_mask36
	movem	1,-033(17)
	move	3,-017(17)
	trnn	3,7
	 tdza	2,2
	 movei	2,1
	movem	2,-032(17)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L485
%L506:
	move	2,[POINT 9,%L519,8]
	move	1,010
	pushj	17,expr_error
	move	1,-033(17)
	move	2,-032(17)
%L485:
	move	10,-034(17)
	move	16,-035(17)
	SUB	17,[036,,036]
	popj	17,
%L519:
	.byte	9,0155,0141,0154,0146
	.byte	9,0157,0162,0155,0145
	.byte	9,0144,040,0145,0170
	.byte	9,0160,0162,0145,0163
	.byte	9,0163,0151,0157,0156
	.byte	9,0
	

%L505:
	.byte	9,0155,0141,0154,0146
	.byte	9,0157,0162,0155,0145
	.byte	9,0144,040,0145,0170
	.byte	9,0160,0162,0145,0163
	.byte	9,0163,0151,0157,0156
	.byte	9,0
	

%L488:
	.byte	9,0155,0141,0154,0146
	.byte	9,0157,0162,0155,0145
	.byte	9,0144,040,0145,0170
	.byte	9,0160,0162,0145,0163
	.byte	9,0163,0151,0157,0156
	.byte	9,0
	


parse_expr_unary:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	move	2,2(10)
	move	1,2
	pushj	17,skipws
	movem	1,2(10)
	ldb	4,1
	movem	4,0(17)
	caie	4,053
	 cain	4,055
	 jrst	%L522
	caie	4,0176
	 jrst	%L521
%L522:
	ibp	2(10)
	move	1,2(10)
	movei	1,-2(17)
	push	17,1
	move	1,010
	pushj	17,parse_expr_unary
	pop	17,3
	movem	1,0(3)
	movem	2,1(3)
	move	3,0(17)
	caie	3,055
	 jrst	%L524
	movn	1,-2(17)
	pushj	17,das_mask36
	movem	1,-2(17)
	movns	3,-1(17)
	jrst	%L523
%L524:
	move	2,0(17)
	caie	2,0176
	 jrst	%L523
	skipn	3,-1(17)
	 jrst	%L525
	skipe	4,5(10)
	 jrst	%L526
	movei	1,06265
	pushj	17,das_native_diag
%L526:
	movei	1,1
	movem	1,5(10)
%L525:
	setcm	1,-2(17)
	pushj	17,das_mask36
	movem	1,-2(17)
	setzb	2,-1(17)
%L523:
	move	1,-2(17)
	move	2,-1(17)
	jrst	%L520
%L521:
	move	1,010
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	jrst	parse_expr_primary
%L520:
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

expr_binary_op:
	push	17,016
	move	5,1
	ldb	6,5
	movei	7,0174
	came	6,7
	 jrst	%L528
	movei	1,1
	movem	1,0(2)
	movem	1,0(3)
	movem	1,0(4)
	jrst	%L527
%L528:
	move	5,1
	ldb	6,5
	caie	6,0136
	 jrst	%L529
	movei	7,2
	movem	7,0(2)
	movem	7,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L529:
	move	5,1
	ldb	6,5
	movei	7,046
	came	6,7
	 jrst	%L530
	movei	5,3
	movem	5,0(2)
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L530:
	move	5,1
	ldb	6,5
	movei	7,074
	came	6,7
	 jrst	%L531
	move	5,1
	movei	6,1
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	5,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	5,6
	caie	5,074
	 jrst	%L531
	movei	5,4
	movem	5,0(2)
	movem	5,0(3)
	movei	5,2
	movem	5,0(4)
	movei	1,1
	jrst	%L527
%L531:
	move	5,1
	ldb	6,5
	caie	6,076
	 jrst	%L532
	ildb	7,5
	caie	7,076
	 jrst	%L532
	movei	5,5
	movem	5,0(2)
	movei	5,4
	movem	5,0(3)
	movei	5,2
	movem	5,0(4)
	movei	1,1
	jrst	%L527
%L532:
	move	5,1
	ldb	6,5
	caie	6,053
	 jrst	%L533
	movei	7,6
	movem	7,0(2)
	movei	5,5
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L533:
	move	5,1
	ldb	6,5
	caie	6,055
	 jrst	%L534
	movei	7,7
	movem	7,0(2)
	movei	5,5
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L534:
	move	5,1
	ldb	6,5
	caie	6,052
	 jrst	%L535
	movei	7,010
	movem	7,0(2)
	movei	5,6
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L535:
	move	5,1
	ldb	6,5
	movei	7,057
	came	6,7
	 jrst	%L536
	movei	5,011
	movem	5,0(2)
	movei	5,6
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L536:
	move	5,1
	ldb	6,5
	caie	6,045
	 jrst	%L537
	movei	7,012
	movem	7,0(2)
	movei	5,6
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L527
%L537:
	setz	1,
%L527:
	move	16,0(17)
	SUB	17,[1,,1]
	popj	17,

parse_expr_binary:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[011,,011]
	movei	1,-010(17)
	push	17,1
	move	1,010
	pushj	17,parse_expr_unary
	pop	17,3
	movem	1,0(3)
	movem	2,1(3)
%L539:
	move	2,2(10)
	move	1,2
	pushj	17,skipws
	movem	1,-4(17)
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	5,-4(17)
	move	1,5
	move	6,3
	move	3,2
	move	2,6
	pushj	17,expr_binary_op
	jumpe	1,%L542
	move	3,-1(17)
	caml	3,011
	 jrst	%L541
%L542:
	move	1,-010(17)
	move	2,-7(17)
	jrst	%L538
%L541:
	move	3,0(17)
	PUSH	17,1
	move	16,-5(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	3,2(10)
	movei	1,-6(17)
	push	17,1
	move	2,-2(17)
	addi	2,1
	move	1,010
	pushj	17,parse_expr_binary
	pop	17,3
	movem	1,0(3)
	movem	2,1(3)
	move	3,-2(17)
	caie	3,6
	 jrst	%L543
	move	1,-6(17)
	add	1,-010(17)
	pushj	17,das_mask36
	movem	1,-010(17)
	move	4,-5(17)
	addb	4,-7(17)
	jrst	%L539
%L543:
	move	2,-2(17)
	caie	2,7
	 jrst	%L544
	move	1,-010(17)
	sub	1,-6(17)
	pushj	17,das_mask36
	movem	1,-010(17)
	movn	4,-5(17)
	addb	4,-7(17)
	jrst	%L539
%L544:
	push	17,-6(17)
	push	17,-6(17)
	push	17,-012(17)
	push	17,-012(17)
	move	1,010
	push	17,1
	move	2,-2(17)
	move	3,-1(17)
	move	4,-3(17)
	SUB	17,[4,,4]
	pushj	17,expr_require_abs
	SUB	17,[1,,1]
	jumpe	1,%L545
	move	1,-010(17)
	move	2,-7(17)
	jrst	%L538
%L545:
	move	3,-2(17)
	caie	3,011
	 cain	3,012
	 skipe	2,-6(17)
	 jrst	%L546
	move	2,[POINT 9,%L548,8]
	move	1,010
	pushj	17,expr_error
	move	1,-010(17)
	move	2,-7(17)
	jrst	%L538
%L546:
	move	2,-2(17)
	caie	2,010
	 jrst	%L550
	move	4,-6(17)
	mul	4,-010(17)
	trne	4,1
	 tloa	5,0400000
	 tlz	5,0400000
	move	1,5
	pushj	17,das_mask36
	movem	1,-010(17)
	jrst	%L549
%L550:
	move	3,-2(17)
	cail	3,011
	 caile	3,012
	 jrst	%L551
	move	2,-2(17)
	caie	2,012
	 tdza	1,1
	 movei	1,1
	move	2,-6(17)
	move	5,-010(17)
	move	3,1
	move	1,5
	pushj	17,expr_signed_div
	movem	1,-010(17)
	jrst	%L549
%L551:
	move	3,-2(17)
	cail	3,4
	 caile	3,5
	 jrst	%L555
	move	2,-6(17)
	tlc	2,0400000
	camge	2,[0400000000044]
	 jrst	%L557
	movei	1,044
	jrst	%L558
%L557:
	move	1,-6(17)
%L558:
	movem	1,-3(17)
	move	3,-2(17)
	caie	3,4
	 jrst	%L559
	move	4,1
	tlc	4,0400000
	camge	4,[0400000000044]
	 jrst	%L560
	setz	1,
	jrst	%L561
%L560:
	move	1,-010(17)
	move	3,-3(17)
	lsh	1,0(3)
	pushj	17,das_mask36
%L561:
	movem	1,-010(17)
	jrst	%L549
%L559:
	move	2,-3(17)
	move	1,-010(17)
	pushj	17,expr_shift_right
	movem	1,-010(17)
	jrst	%L549
%L555:
	move	2,-2(17)
	caie	2,3
	 jrst	%L562
	move	4,-6(17)
	andb	4,-010(17)
	jrst	%L549
%L562:
	move	2,-2(17)
	caie	2,2
	 jrst	%L563
	move	4,-6(17)
	xorb	4,-010(17)
	jrst	%L549
%L563:
	move	3,-6(17)
	iorb	3,-010(17)
%L549:
	setzb	1,-7(17)
	jrst	%L539
%L538:
	move	10,-012(17)
	move	11,-011(17)
	move	16,-013(17)
	SUB	17,[014,,014]
	popj	17,
%L548:
	.byte	9,0144,0151,0166,0151
	.byte	9,0163,0151,0157,0156
	.byte	9,040,0142,0171,040
	.byte	9,0172,0145,0162,0157
	.byte	9,040,0151,0156,040
	.byte	9,0145,0170,0160,0162
	.byte	9,0145,0163,0163,0151
	.byte	9,0157,0156,0
	


parse_expr_or:
	push	17,016
	movei	2,1
	move	16,0(17)
	SUB	17,[1,,1]
	jrst	parse_expr_binary
%L564:
	move	16,0(17)
	SUB	17,[1,,1]
	popj	17,

eval_expr_radix:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[0110,,0110]
	move	2,-0113(17)
	movei	1,-0107(17)
	hrli	1,0331100
	movei	3,0400
	pushj	17,strcopy
	movei	1,-0107(17)
	hrli	1,0331100
	pushj	17,strip_brackets
	move	2,-0112(17)
	movem	2,-7(17)
	move	3,-0113(17)
	movem	3,-6(17)
	movei	1,-0107(17)
	hrli	1,0331100
	pushj	17,skipws
	movem	1,-5(17)
	move	3,-0114(17)
	movem	3,-4(17)
	move	4,-0115(17)
	movem	4,-3(17)
	setzb	2,-2(17)
	ldb	5,1
	jumpn	5,%L565
	setm	6,5
	move	1,-0116(17)
	movem	6,0(1)
	move	2,-0117(17)
	setzb	7,0(2)
	setm	1,7
	move	16,-0110(17)
	SUB	17,[0111,,0111]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L565:
	movei	1,-1(17)
	push	17,1
	movei	1,-010(17)
	pushj	17,parse_expr_or
	pop	17,3
	movem	1,0(3)
	movem	2,1(3)
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-5(17)
	skipe	3,-2(17)
	 jrst	%L566
	ldb	2,1
	jumpe	2,%L566
	move	1,[POINT 9,%L567,8]
	movei	6,-7(17)
	move	2,1
	move	1,6
	pushj	17,expr_error
%L566:
	skipn	2,-2(17)
	 skipn	4,0(17)
	 jrst	%L568
	soje	4,%L568
	move	3,-0112(17)
	skipe	1,01335(3)
	 jrst	%L569
	movei	1,06720
	pushj	17,das_native_diag
%L569:
	movei	1,1
	movem	1,-2(17)
%L568:
	skipn	2,-2(17)
	 jrst	%L570
	seto	1,
	move	16,-0110(17)
	SUB	17,[0111,,0111]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L570:
	move	1,-1(17)
	pushj	17,das_mask36
	move	3,-0116(17)
	movem	1,0(3)
	move	4,0(17)
	sojn	4,%L571
	movei	1,1
	jrst	%L572
%L571:
	setz	1,
%L572:
	move	3,-0117(17)
	movem	1,0(3)
	setz	1,
	move	16,-0110(17)
	SUB	17,[0111,,0111]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L567:
	.byte	9,0155,0141,0154,0146
	.byte	9,0157,0162,0155,0145
	.byte	9,0144,040,0145,0170
	.byte	9,0160,0162,0145,0163
	.byte	9,0163,0151,0157,0156
	.byte	9,0
	


eval_expr:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,-5(17)
	push	17,-5(17)
	move	2,-5(17)
	move	3,-4(17)
	move	1,-3(17)
	move	6,3
	move	3,2
	move	2,6
	movei	4,012
	pushj	17,eval_expr_radix
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

eval_expr_octal:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,-5(17)
	push	17,-5(17)
	move	2,-5(17)
	move	3,-4(17)
	move	1,-3(17)
	move	6,3
	move	3,2
	move	2,6
	movei	4,010
	pushj	17,eval_expr_radix
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

split2:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[4,,4]
	setz	1,
	movem	1,-2(17)
	setm	2,1
	movem	2,-1(17)
	setzb	3,0(17)
	movem	10,-3(17)
%L574:
	ldb	1,-3(17)
	jumpe	1,%L575
	skipn	5,0(17)
	 jrst	%L577
	camn	1,5
	 setzb	2,0(17)
	jrst	%L576
%L577:
	ldb	1,-3(17)
	cain	1,047
	 jrst	%L579
	caie	1,042
	 jrst	%L578
%L579:
	ldb	1,-3(17)
	movem	1,0(17)
	jrst	%L576
%L578:
	ldb	1,-3(17)
	caie	1,0133
	 jrst	%L580
	aos	2,-1(17)
	jrst	%L576
%L580:
	ldb	1,-3(17)
	caie	1,0135
	 jrst	%L581
	skiple	3,-1(17)
	 sos	2,-1(17)
	jrst	%L576
%L581:
	ldb	1,-3(17)
	caie	1,050
	 jrst	%L582
	aos	2,-2(17)
	jrst	%L576
%L582:
	ldb	1,-3(17)
	caie	1,051
	 jrst	%L583
	skiple	3,-2(17)
	 sos	2,-2(17)
	jrst	%L576
%L583:
	ldb	1,-3(17)
	cain	1,054
	 skipe	3,-2(17)
	 jrst	%L576
	skipn	4,-1(17)
	 jrst	%L575
%L576:
	ibp	-3(17)
	move	1,-3(17)
	jrst	%L574
%L575:
	ldb	1,-3(17)
	jumpn	1,%L584
	setm	1,1
	jrst	%L573
%L584:
	setz	1,
	move	3,-3(17)
	ibp	-3(17)
	dpb	1,3
	move	1,010
	pushj	17,skipws
	movem	1,0(11)
	move	1,-3(17)
	pushj	17,skipws
	movem	1,0(12)
	move	2,0(11)
	move	1,2
	pushj	17,rtrim
	move	2,0(12)
	move	1,2
	pushj	17,rtrim
	movei	1,1
%L573:
	move	10,-6(17)
	move	11,-5(17)
	move	12,-4(17)
	SUB	17,[7,,7]
	popj	17,

parse_index_suffix:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[4,,4]
	move	1,010
	pushj	17,rtrim
	move	1,010
	movei	2,051
	pushj	17,strrchr
	movem	1,-2(17)
	jumpe	1,%L587
	move	2,1
	ildb	3,2
	jumpe	3,%L586
%L587:
	setz	1,
	jrst	%L585
%L586:
	move	1,010
	movei	2,050
	pushj	17,strrchr
	movem	1,-3(17)
	jumpe	1,%L589
	skipl	3,1
	 tlc	3,0770000
	rot	3,6
	skipl	4,-2(17)
	 tlc	4,0770000
	rot	4,6
	camg	3,4
	 jrst	%L588
%L589:
	setz	1,
	jrst	%L585
%L588:
	move	1,-3(17)
	ibp	1
	pushj	17,skipws
	movem	1,-1(17)
	camn	1,-2(17)
	 jrst	%L591
	ldb	3,1
	caige	3,060
	 jrst	%L591
	caig	3,067
	 jrst	%L590
%L591:
	setz	1,
	jrst	%L585
%L590:
	setzb	1,0(17)
%L592:
	skipl	2,-1(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-2(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L593
	ldb	1,-1(17)
	cail	1,060
	 caile	1,067
	 jrst	%L593
	move	5,0(17)
	lsh	5,3
	subi	1,060
	ior	5,1
	movem	5,0(17)
	ibp	-1(17)
	move	4,-1(17)
	jrst	%L592
%L593:
	move	1,-1(17)
	pushj	17,skipws
	movem	1,-1(17)
	came	1,-2(17)
	 jrst	%L595
	move	3,0(17)
	tlc	3,0400000
	camg	3,[0400000000017]
	 jrst	%L594
%L595:
	setz	1,
	jrst	%L585
%L594:
	setz	1,
	dpb	1,-3(17)
	move	1,010
	pushj	17,rtrim
	move	2,0(17)
	movem	2,0(11)
	movei	1,1
%L585:
	move	10,-5(17)
	move	11,-4(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

matching_rbracket:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	skipn	1,010
	 jrst	%L598
	move	2,010
	ldb	3,2
	movei	4,0133
	camn	3,4
	 jrst	%L597
%L598:
	setz	1,
	jrst	%L596
%L597:
	movei	1,1
	movem	1,0(17)
	move	3,1
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	3,-1(17)
%L599:
	ldb	2,-1(17)
	jumpe	2,%L600
	caie	2,0133
	 jrst	%L602
	aos	1,0(17)
	jrst	%L601
%L602:
	ldb	1,-1(17)
	cain	1,0135
	 sose	4,0(17)
	 jrst	%L601
	move	1,-1(17)
	jrst	%L596
%L601:
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L599
%L600:
	setz	1,
%L596:
	move	10,-2(17)
	move	16,-3(17)
	SUB	17,[4,,4]
	popj	17,

parse_ea:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[0107,,0107]
	move	3,-0115(17)
	setzb	1,0(3)
	setm	2,1
	move	5,-0116(17)
	movem	2,0(5)
	move	7,-0117(17)
	setzb	4,0(7)
	move	1,-0112(17)
	pushj	17,skipws
	movem	1,-0112(17)
	ldb	2,1
	jumpn	2,%L603
	setm	3,2
	move	5,-0114(17)
	movem	3,0(5)
	setz	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L603:
%L604:
	ldb	1,-0112(17)
	caie	1,0100
	 jrst	%L605
	movei	2,1
	move	4,-0115(17)
	movem	2,0(4)
	ibp	-0112(17)
	move	3,-0112(17)
	jrst	%L604
%L605:
	ldb	1,-0112(17)
	caie	1,0133
	 jrst	%L606
	move	1,-0112(17)
	pushj	17,matching_rbracket
	movem	1,-0105(17)
	jumpn	1,%L607
	seto	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L607:
	move	2,-0105(17)
	move	1,-0112(17)
	ibp	1
	pushj	17,char_distance
	movem	1,-0103(17)
	move	3,1
	tlc	3,0400000
	caml	3,[0400000000400]
	 skipa	2,[0377]
	 trna	
	 movem	2,-0103(17)
	push	17,[0400]
	movei	4,-0103(17)
	hrli	4,0331100
	move	3,-0104(17)
	move	2,-0113(17)
	ibp	2
	move	5,-0112(17)
	move	1,5
	pushj	17,literal_canonicalize
	SUB	17,[1,,1]
	movem	1,-2(17)
	skipge	3,1
	 jrst	%L610
	movei	4,-0104(17)
	move	3,-2(17)
	movei	2,-0102(17)
	hrli	2,0331100
	move	5,-0111(17)
	move	1,5
	pushj	17,lit_find_text
	jumpn	1,%L609
	movei	4,-0104(17)
	move	3,-0103(17)
	move	2,-0112(17)
	ibp	2
	move	5,-0111(17)
	move	1,5
	pushj	17,lit_find_text
	jumpn	1,%L609
	seto	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L610:
	movei	4,-0104(17)
	move	3,-0103(17)
	move	2,-0112(17)
	ibp	2
	move	5,-0111(17)
	move	1,5
	pushj	17,lit_find_text
	jumpn	1,%L609
	seto	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L609:
	move	1,-0111(17)
	pushj	17,text_total
	move	3,-0111(17)
	sub	1,01000(3)
	add	1,-0104(17)
	move	4,-0114(17)
	movem	1,0(4)
	movei	2,1
	move	6,-0117(17)
	movem	2,0(6)
	setz	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L606:
	move	2,[POINT 9,%L612,8]
	move	3,-0112(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L611
	movei	1,5
	move	16,-0112(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L611
	movei	1,5
	move	16,-0112(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-0112(17)
	move	1,-0112(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-1(17)
	jumpn	1,%L613
	seto	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L613:
	move	1,-1(17)
	ibp	1
	movei	2,054
	pushj	17,strchr
	movem	1,0(17)
	jumpe	1,%L614
	setz	2,
	dpb	2,1
%L614:
	push	17,-0117(17)
	push	17,-0117(17)
	push	17,-0117(17)
	push	17,-0116(17)
	push	17,-0120(17)
	move	1,-6(17)
	ibp	1
	pushj	17,skipws
	move	6,-0116(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L611:
	move	2,-0116(17)
	move	1,-0112(17)
	pushj	17,parse_index_suffix
	move	1,-0112(17)
	pushj	17,rtrim
	ldb	1,-0112(17)
	jumpn	1,%L615
	setm	2,1
	move	4,-0114(17)
	movem	2,0(4)
	move	6,-0117(17)
	setzb	3,0(6)
	setm	1,3
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L615:
	push	17,-0117(17)
	movei	1,-0107(17)
	move	3,-0114(17)
	move	2,-0113(17)
	move	5,-0112(17)
	move	4,1
	move	1,5
	pushj	17,eval_expr_octal
	SUB	17,[1,,1]
	jumpe	1,%L616
	seto	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L616:
	hrrz	2,-0106(17)
	move	3,-0114(17)
	movem	2,0(3)
	setz	1,
	move	16,-0107(17)
	SUB	17,[0110,,0110]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L612:
	.byte	9,0120,0117,0111,0116
	.byte	9,0124,0
	


byte_field_end:
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	movem	10,-2(17)
	setz	2,
	movem	2,-1(17)
%L618:
	ldb	1,-2(17)
	jumpe	1,%L619
	caie	1,054
	 cain	1,050
	 jrst	%L619
	ldb	1,-2(17)
	pushj	17,das_native_is_space
	jumpe	1,%L620
	move	1,-2(17)
	pushj	17,skipws
	movem	1,0(17)
	ldb	3,1
	caie	3,053
	 cain	3,055
	 jrst	%L621
	move	5,-1(17)
	cain	5,053
	 jrst	%L621
	caie	5,055
	 jrst	%L619
%L621:
	move	2,0(17)
	movem	2,-2(17)
	jrst	%L618
%L620:
	ldb	1,-2(17)
	movem	1,-1(17)
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L618
%L619:
	move	1,-2(17)
%L617:
	move	10,-3(17)
	SUB	17,[4,,4]
	popj	17,

long_values:
	push	17,016
	push	17,010
	move	10,1
	move	1,010
	pushj	17,skipws
	move	10,1
	ldb	2,1
	cain	2,056
	 ibp	010
	move	1,[POINT 9,%L625,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L624
	movei	2,4
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	1,2
	pushj	17,skipws
	move	10,1
%L624:
	move	1,010
%L622:
	move	10,0(17)
	move	16,-1(17)
	SUB	17,[2,,2]
	popj	17,
%L625:
	.byte	9,0114,0117,0116,0107
	.byte	9,0
	


long_field_end:
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	setz	1,
	movem	1,-1(17)
	setm	2,1
	movem	2,0(17)
%L627:
	move	1,010
	ldb	2,1
	jumpe	2,%L628
	move	3,010
	ldb	4,3
	caie	4,050
	 jrst	%L630
	aos	5,-1(17)
	jrst	%L629
%L630:
	move	1,010
	ldb	2,1
	movei	3,051
	came	2,3
	 jrst	%L631
	skipe	5,-1(17)
	 jrst	%L632
	setm	1,5
	jrst	%L626
%L632:
	sos	1,-1(17)
	jrst	%L629
%L631:
	move	1,010
	ldb	2,1
	caie	2,0133
	 jrst	%L633
	aos	3,0(17)
	jrst	%L629
%L633:
	move	1,010
	ldb	2,1
	caie	2,0135
	 jrst	%L634
	skipe	4,0(17)
	 jrst	%L635
	setm	1,4
	jrst	%L626
%L635:
	sos	1,0(17)
	jrst	%L629
%L634:
	move	1,010
	ldb	2,1
	cain	2,054
	 skipe	4,-1(17)
	 jrst	%L629
	skipe	5,0(17)
	 jrst	%L629
	move	1,010
	jrst	%L626
%L629:
	ibp	010
	jrst	%L627
%L628:
	skipe	2,-1(17)
	 jrst	%L637
	skipn	3,0(17)
	 jrst	%L636
%L637:
	setz	1,
	jrst	%L626
%L636:
	move	1,010
%L626:
	move	10,-2(17)
	SUB	17,[3,,3]
	popj	17,

long_word_count:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	move	1,010
	pushj	17,long_values
	movem	1,-2(17)
	ldb	2,1
	jumpn	2,%L639
	seto	1,
	jrst	%L638
%L639:
	setzb	1,0(17)
%L640:
	move	1,-2(17)
	pushj	17,long_field_end
	movem	1,-1(17)
	jumpn	1,%L642
	seto	1,
	jrst	%L638
%L642:
	aos	1,0(17)
	ldb	2,-1(17)
	jumpe	2,%L638
	move	3,-1(17)
	ibp	3
	movem	3,-2(17)
	jrst	%L640
%L638:
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

byte_begin:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[3,,3]
	move	1,-6(17)
	pushj	17,skipws
	movem	1,-6(17)
	ldb	2,1
	caie	2,056
	 jrst	%L644
	ibp	-6(17)
	move	3,-6(17)
%L644:
	move	2,[POINT 9,%L646,8]
	move	3,-6(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L645
	movei	1,4
	move	16,-6(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-6(17)
%L645:
	move	2,-6(17)
	movem	2,-2(17)
%L647:
	ldb	2,-2(17)
	jumpe	2,%L648
	cain	2,054
	 jrst	%L648
	ldb	1,-2(17)
	pushj	17,das_native_is_space
	jumpn	1,%L648
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L647
%L648:
	move	2,-2(17)
	came	2,-6(17)
	 jrst	%L649
	seto	1,
	move	16,-3(17)
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L649:
	ldb	1,-2(17)
	movei	2,-1(17)
	hrli	2,01100
	dpb	1,2
	setz	3,
	dpb	3,-2(17)
	movei	1,0(17)
	push	17,1
	move	3,-010(17)
	move	4,-7(17)
	move	1,-6(17)
	move	2,4
	movei	4,044
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	skipe	3,0(17)
	 jumpe	1,%L650
	ldb	4,[POINT 9,-1(17),35]
	dpb	4,-2(17)
	seto	1,
	move	16,-3(17)
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L650:
	ldb	2,[POINT 9,-1(17),35]
	dpb	2,-2(17)
	move	3,0(17)
	move	4,-011(17)
	movem	3,0(4)
	move	1,-2(17)
	pushj	17,skipws
	movem	1,-6(17)
	ldb	2,1
	caie	2,054
	 jrst	%L652
	ibp	-6(17)
	move	3,-6(17)
%L652:
	move	2,-6(17)
	move	3,-010(17)
	movem	2,0(3)
	setz	1,
	move	16,-3(17)
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L646:
	.byte	9,0102,0131,0124,0105
	.byte	9,0
	


byte_size_prefix:
	push	17,016
	ADD	17,[010,,010]
	MOVEI	0,-7(17)
	HRLI	0,010
	BLT	0,-4(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	2,0(11)
	move	1,2
	pushj	17,skipws
	movem	1,-3(17)
	ldb	2,1
	cain	2,050
	 jrst	%L654
	movem	1,0(11)
	setz	1,
	jrst	%L653
%L654:
	ibp	-3(17)
	move	1,-3(17)
	move	1,-3(17)
	movei	2,051
	pushj	17,strchr
	movem	1,-2(17)
	jumpn	1,%L655
	seto	1,
	jrst	%L653
%L655:
	ldb	1,-2(17)
	dpb	1,[POINT 9,-1(17),35]
	setz	2,
	dpb	2,-2(17)
	movei	1,0(17)
	push	17,1
	move	3,-4(17)
	move	1,010
	move	2,3
	move	3,012
	movei	4,044
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	skipe	3,0(17)
	 jumpe	1,%L656
	ldb	4,[POINT 9,-1(17),35]
	dpb	4,-2(17)
	seto	1,
	jrst	%L653
%L656:
	movei	1,-1(17)
	hrli	1,01100
	ldb	2,1
	dpb	2,-2(17)
	move	4,0(17)
	movem	4,0(13)
	move	1,-2(17)
	ibp	1
	pushj	17,skipws
	movem	1,0(11)
	setz	1,
%L653:
	MOVEI	0,010
	HRLI	0,-7(17)
	BLT	0,013
	move	16,-010(17)
	SUB	17,[011,,011]
	popj	17,

byte_word_count:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[5,,5]
	setz	1,
	movem	1,-1(17)
	setm	2,1
	movem	2,0(17)
	movei	1,-2(17)
	push	17,1
	movei	2,-5(17)
	move	1,010
	move	3,012
	move	4,2
	move	2,011
	pushj	17,byte_begin
	SUB	17,[1,,1]
	jumpe	1,%L659
	seto	1,
	jrst	%L658
%L659:
%L660:
	move	1,-4(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L661
	move	1,-4(17)
	pushj	17,skipws
	movem	1,-4(17)
	ldb	2,1
	caie	2,054
	 jrst	%L662
	ibp	-4(17)
	move	3,-4(17)
	jrst	%L660
%L662:
	movei	1,-2(17)
	move	3,0(17)
	add	3,012
	movei	2,-4(17)
	move	4,1
	move	1,010
	pushj	17,byte_size_prefix
	jumpe	1,%L663
	seto	1,
	jrst	%L658
%L663:
	move	1,-4(17)
	pushj	17,byte_field_end
	movem	1,-3(17)
	camn	1,-4(17)
	 jrst	%L661
	move	3,-1(17)
	add	3,-2(17)
	caig	3,044
	 jrst	%L664
	aos	2,0(17)
	setz	4,
	movem	4,-1(17)
%L664:
	move	3,-2(17)
	addb	3,-1(17)
	caie	3,044
	 jrst	%L665
	aos	1,0(17)
	setz	2,
	movem	2,-1(17)
%L665:
	move	2,-3(17)
	movem	2,-4(17)
	jrst	%L660
%L661:
	skipe	2,-1(17)
	 jrst	%L667
	skipe	3,0(17)
	 jrst	%L666
%L667:
	aos	1,0(17)
%L666:
	move	1,0(17)
%L658:
	move	10,-7(17)
	move	11,-6(17)
	move	12,-5(17)
	SUB	17,[010,,010]
	popj	17,

delimited_text_len:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	move	1,010
	pushj	17,skipws
	move	10,1
	ldb	2,1
	jumpn	2,%L669
	seto	1,
	jrst	%L668
%L669:
	move	1,010
	movei	2,1
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,-1(17)
	move	1,010
	ldb	2,1
	move	1,-1(17)
	pushj	17,strrchr
	movem	1,0(17)
	jumpn	1,%L670
	seto	1,
	jrst	%L668
%L670:
	move	2,0(17)
	move	1,-1(17)
	pushj	17,char_distance
	movem	1,0(11)
	setz	1,
%L668:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

ascii_word_count:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	move	1,010
	pushj	17,skipws
	movem	1,-1(17)
	ldb	2,1
	caie	2,056
	 jrst	%L672
	ibp	-1(17)
	move	3,-1(17)
%L672:
	move	2,[POINT 9,%L675,8]
	move	3,-1(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L674
	movei	1,5
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-1(17)
	jrst	%L673
%L674:
	move	2,[POINT 9,%L676,8]
	move	3,-1(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L673
	movei	1,5
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-1(17)
%L673:
	movei	2,0(17)
	move	3,-1(17)
	move	1,3
	pushj	17,delimited_text_len
	jumpe	1,%L677
	seto	1,
	jrst	%L671
%L677:
	skipe	1,011
	 aos	2,0(17)
	skiple	4,0(17)
	 jrst	%L679
	movei	1,1
	jrst	%L671
%L679:
	move	2,0(17)
	addi	2,4
	movei	16,5
	CAMN	2,[0400000000000]
	 JRST	%SIDE0
	IDIVI	2,5
	JRST	%SIDD0
%SIDE0:	PUSHJ	17,%SIDH2
%SIDD0:
	move	1,2
%L671:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,
%L676:
	.byte	9,0101,0123,0103,0111
	.byte	9,0111,0
	

%L675:
	.byte	9,0101,0123,0103,0111
	.byte	9,0132,0
	


sixbit_word_count:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	move	1,010
	pushj	17,skipws
	movem	1,-1(17)
	ldb	2,1
	caie	2,056
	 jrst	%L681
	ibp	-1(17)
	move	3,-1(17)
%L681:
	move	2,[POINT 9,%L683,8]
	move	3,-1(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L682
	movei	1,6
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-1(17)
%L682:
	movei	2,0(17)
	move	3,-1(17)
	move	1,3
	pushj	17,delimited_text_len
	jumpe	1,%L684
	seto	1,
	jrst	%L680
%L684:
	skiple	2,0(17)
	 jrst	%L685
	movei	1,1
	jrst	%L680
%L685:
	move	2,0(17)
	addi	2,5
	movei	16,6
	CAMN	2,[0400000000000]
	 JRST	%SIDE1
	IDIVI	2,6
	JRST	%SIDD1
%SIDE1:	PUSHJ	17,%SIDH2
%SIDD1:
	move	1,2
%L680:
	move	10,-2(17)
	move	16,-3(17)
	SUB	17,[4,,4]
	popj	17,
%L683:
	.byte	9,0123,0111,0130,0102
	.byte	9,0111,0124,0
	


eval_abs_u:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[2,,2]
	movei	1,0(17)
	push	17,1
	movei	2,-2(17)
	push	17,-6(17)
	push	17,2
	move	1,-7(17)
	pushj	17,skipws
	move	6,-6(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpn	1,%L687
	skipe	3,0(17)
	 jrst	%L687
	move	4,-1(17)
	tlc	4,0400000
	move	5,-6(17)
	tlc	5,0400000
	camg	4,5
	 jrst	%L686
%L687:
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L686:
	move	2,-1(17)
	move	3,-7(17)
	movem	2,0(3)
	setz	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

align_word_padding:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[2,,2]
	movei	1,-1(17)
	push	17,1
	move	3,-6(17)
	move	4,-5(17)
	move	1,-4(17)
	move	2,4
	movei	4,023
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	jumpe	1,%L688
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L688:
	move	2,-1(17)
	tlc	2,0400000
	camle	2,[0400000000002]
	 jrst	%L689
	move	4,-7(17)
	setzb	1,0(4)
	setm	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L689:
	movei	5,1
	move	3,-1(17)
	lsh	5,-2(3)
	movem	5,0(17)
	movn	4,-6(17)
	subi	5,1
	and	4,5
	move	2,-7(17)
	movem	4,0(2)
	setz	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

org_word_target:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[2,,2]
	movei	1,0(17)
	push	17,1
	movei	2,-2(17)
	push	17,-6(17)
	push	17,2
	move	1,-7(17)
	pushj	17,skipws
	move	6,-6(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpe	1,%L690
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L690:
	skipe	2,0(17)
	 jrst	%L692
	move	3,-1(17)
	tlc	3,0400000
	camg	3,[0400000777777]
	 jrst	%L691
%L692:
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L691:
	move	2,-1(17)
	move	3,-7(17)
	movem	2,0(3)
	move	4,-7(17)
	move	1,0(4)
	tlc	1,0400000
	move	6,-6(17)
	tlc	6,0400000
	caml	1,6
	 jrst	%L693
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L693:
	setz	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

parsed_word_count:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	skipl	2,016(11)
	 cail	2,036
	 jrst	%L695
	jrst	@%L706(2)
%L706:
	setz	%L705
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L697
	setz	%L698
	setz	%L699
	setz	%L699
	setz	%L700
	setz	%L701
	setz	%L702
	setz	%L703
	setz	%L705
	setz	%L705
	setz	%L704
	setz	%L705
	setz	%L705
	setz	%L705
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
	setz	%L696
%L696:
	setz	1,
	jrst	%L694
%L697:
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	move	4,3(11)
	move	1,010
	move	3,012
	move	6,4
	move	4,2
	move	2,6
	pushj	17,eval_expr_octal
	SUB	17,[1,,1]
	jumpn	1,%L708
	skipe	3,-1(17)
	 jrst	%L708
	move	4,-2(17)
	tlc	4,0400000
	camg	4,[0400000777777]
	 jrst	%L707
%L708:
	seto	1,
	jrst	%L694
%L707:
	move	1,-2(17)
	jrst	%L694
%L698:
	movei	1,0(17)
	push	17,1
	move	3,3(11)
	move	1,010
	move	2,3
	move	3,012
	move	4,[03777774]
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	jumpe	1,%L709
	seto	1,
	jrst	%L694
%L709:
	move	1,0(17)
	addi	1,3
	lsh	1,-2
	jrst	%L694
%L699:
	setz	1,
	jrst	%L694
%L700:
	move	2,2(11)
	move	1,010
	move	3,012
	pushj	17,byte_word_count
	jrst	%L694
%L701:
	move	2,2(11)
	move	1,2
	setz	2,
	pushj	17,ascii_word_count
	jrst	%L694
%L702:
	move	2,2(11)
	move	1,2
	movei	2,1
	pushj	17,ascii_word_count
	jrst	%L694
%L703:
	move	2,2(11)
	move	1,2
	pushj	17,sixbit_word_count
	jrst	%L694
%L704:
	move	2,2(11)
	move	1,2
	pushj	17,long_word_count
	jrst	%L694
%L705:
	movei	1,1
	jrst	%L694
%L695:
	movei	1,1
%L694:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

scan_literals:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	movem	11,-1(17)
%L711:
	move	1,-1(17)
	movei	2,0133
	pushj	17,strchr
	movem	1,-1(17)
	jumpe	1,%L712
	move	1,-1(17)
	pushj	17,matching_rbracket
	movem	1,0(17)
	jumpe	1,%L710
	move	2,0(17)
	move	1,-1(17)
	ibp	1
	pushj	17,char_distance
	move	2,-1(17)
	ibp	2
	move	3,1
	move	1,010
	pushj	17,add_lit_text
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L711
%L712:
%L710:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

psect_to_sec:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,010
	pushj	17,skipws
	move	10,1
	ldb	2,1
	cain	2,042
	 ibp	010
	move	1,010
	ldb	3,1
	cain	3,056
	 ibp	010
	move	1,[POINT 9,%L719,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpn	1,%L718
	move	1,[POINT 9,%L720,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L717
%L718:
	movei	1,1
	jrst	%L714
%L717:
	move	1,[POINT 9,%L723,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpn	1,%L722
	move	1,[POINT 9,%L724,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,6
	pushj	17,pref_i
	jumpn	1,%L722
	move	1,[POINT 9,%L725,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L721
%L722:
	movei	1,2
	jrst	%L714
%L721:
	move	1,[POINT 9,%L727,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L726
	movei	1,3
	jrst	%L714
%L726:
	move	1,011
%L714:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L727:
	.byte	9,0102,0123,0123,0
	

%L725:
	.byte	9,0103,0117,0116,0123
	.byte	9,0124,0
	

%L724:
	.byte	9,0122,0117,0104,0101
	.byte	9,0124,0101,0
	

%L723:
	.byte	9,0104,0101,0124,0101
	.byte	9,0
	

%L720:
	.byte	9,0103,0117,0104,0105
	.byte	9,0
	

%L719:
	.byte	9,0124,0105,0130,0124
	.byte	9,0
	


parse_line_head:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[011,,011]
	setz	1,
	movem	1,0(12)
	setm	2,1
	movem	2,1(12)
	setz	3,
	movem	3,2(12)
	setm	4,3
	movem	4,3(12)
	setz	5,
	move	6,012
	dpb	5,[POINT 9,4(6),8]
	setz	7,
	movem	7,016(12)
	setm	1,7
	movem	1,017(12)
	setz	1,
	movem	1,020(12)
	movem	1,021(12)
	movem	1,022(12)
	movem	1,023(12)
	movem	1,024(12)
	movem	1,025(12)
	movem	1,026(12)
	movem	1,027(12)
	movem	1,030(12)
	move	1,011
	movei	2,073
	pushj	17,strchr
	movem	1,-010(17)
	jumpe	1,%L729
	setz	2,
	dpb	2,1
%L729:
	move	1,011
	pushj	17,rtrim
	move	1,011
	pushj	17,skipws
	movem	1,-010(17)
	ldb	2,1
	jumpn	2,%L730
	setm	1,2
	jrst	%L728
%L730:
	move	1,-010(17)
	movei	2,072
	pushj	17,strchr
	movem	1,-7(17)
	jumpe	1,%L731
	move	2,-7(17)
	move	1,-010(17)
	pushj	17,char_distance
	movem	1,-5(17)
%L732:
	skipn	2,-5(17)
	 jrst	%L733
	move	2,-5(17)
	subi	2,1
	PUSH	17,1
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,2
	pushj	17,das_native_is_space
	jumpe	1,%L733
	sos	2,-5(17)
	jrst	%L732
%L733:
	move	2,-010(17)
	movem	2,0(12)
	move	3,-5(17)
	movem	3,1(12)
	move	1,-7(17)
	ibp	1
	pushj	17,skipws
	movem	1,-010(17)
	ldb	2,1
	jumpn	2,%L731
	movei	1,1
	jrst	%L728
%L731:
	move	2,-010(17)
	movem	2,2(12)
	movem	2,-6(17)
	ldb	1,2
	caie	1,056
	 jrst	%L734
	movei	3,1
	movem	3,030(12)
	ibp	-6(17)
	move	4,-6(17)
%L734:
	setz	1,
	movem	1,-4(17)
%L735:
	move	3,-4(17)
	PUSH	17,1
	move	16,-7(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,3
	jumpe	1,%L736
	move	3,-4(17)
	PUSH	17,1
	move	16,-7(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,3
	pushj	17,das_native_is_space
	jumpn	1,%L736
	move	3,-4(17)
	tlc	3,0400000
	caml	3,[0400000000047]
	 jrst	%L736
	move	5,-4(17)
	PUSH	17,1
	move	16,-7(17)
	ADD	17,[2,,2]
	MOVEM	5,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	5,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	2,5
	move	4,012
	move	7,-4(17)
	PUSH	17,1
	move	16,[POINT 9,4(4),8]
	ADD	17,[2,,2]
	MOVEM	7,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	7,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	2,7
	aos	6,-4(17)
	jrst	%L735
%L736:
	setz	1,
	move	2,012
	move	4,-4(17)
	PUSH	17,1
	move	16,[POINT 9,4(2),8]
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	move	1,-4(17)
	move	16,-6(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,3(12)
	move	2,012
	addi	2,4
	hrli	2,0331100
	move	1,010
	pushj	17,classify_token
	movem	1,016(12)
	skipe	3,1
	 jrst	%L737
	move	1,012
	addi	1,4
	hrli	1,0331100
	pushj	17,sixbit_mn
	movem	1,017(12)
	move	3,3(12)
	movem	3,-3(17)
	move	1,012
	addi	1,020
	movei	6,-3(17)
	move	2,1
	move	1,6
	pushj	17,opt_octal_ac
	jumpe	1,%L738
	ldb	2,-3(17)
	caie	2,054
	 jrst	%L738
	movei	3,1
	movem	3,024(12)
	move	1,-3(17)
	ibp	1
	pushj	17,skipws
	movem	1,023(12)
	movem	1,-2(17)
	move	1,012
	addi	1,021
	movei	6,-2(17)
	move	2,1
	move	1,6
	pushj	17,opt_octal_ac
	jumpe	1,%L739
	ldb	2,-2(17)
	jumpn	2,%L739
	movei	3,1
	movem	3,025(12)
%L739:
	move	3,023(12)
	movem	3,-1(17)
	ldb	1,3
	caie	1,055
	 tdza	2,2
	 movei	2,1
	movem	2,027(12)
	ldb	5,-1(17)
	cain	5,055
	 jrst	%L743
	caie	5,053
	 jrst	%L742
%L743:
	ibp	-1(17)
	move	1,-1(17)
%L742:
	movei	1,0(17)
	movei	6,-1(17)
	move	2,1
	move	1,6
	pushj	17,parse_expr_integer
	jumpn	1,%L744
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpn	2,%L744
	movei	1,1
	movem	1,026(12)
	move	4,0(17)
	movem	4,022(12)
%L744:
%L738:
%L737:
	aos	1,01144(10)
	movei	1,1
%L728:
	move	10,-013(17)
	move	11,-012(17)
	move	12,-011(17)
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,

opt_reset:
	push	17,010
	move	10,1
	setz	1,
	movem	1,01146(10)
	setm	2,1
	movem	2,01167(10)
	setz	3,
	movem	3,01171(10)
	setm	4,3
	movem	4,01173(10)
	setz	5,
	movem	5,01176(10)
	setm	6,5
	movem	6,01200(10)
	setz	7,
	movem	7,01202(10)
	setm	1,7
	movem	1,01204(10)
	setz	1,
	movem	1,01207(10)
	movem	1,01214(10)
	movem	1,01210(10)
	push	17,1
%L746:
	move	2,0(17)
	move	4,010
	add	4,0(17)
	movem	2,01147(4)
	aos	5,0(17)
	tlc	5,0400000
	camge	5,[0400000000020]
	 jrst	%L746
%L745:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

opt_octal_ac:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[3,,3]
	move	2,0(10)
	movem	2,-2(17)
%L750:
	ldb	1,-2(17)
	jumpe	1,%L751
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L751
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L750
%L751:
	setz	1,
	movem	1,-1(17)
	setm	2,1
	movem	2,0(17)
%L752:
	ldb	1,-2(17)
	cail	1,060
	 caile	1,067
	 jrst	%L753
	movei	2,1
	movem	2,0(17)
	subi	1,060
	move	6,1
	move	5,-1(17)
	lsh	5,3
	add	6,5
	movem	6,-1(17)
	tlc	6,0400000
	camg	6,[0400000000017]
	 jrst	%L754
	setz	1,
	jrst	%L749
%L754:
	ibp	-2(17)
	move	1,-2(17)
	jrst	%L752
%L753:
	skipe	2,0(17)
	 jrst	%L755
	setm	1,2
	jrst	%L749
%L755:
%L756:
	ldb	1,-2(17)
	jumpe	1,%L757
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L757
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L756
%L757:
	move	2,-2(17)
	movem	2,0(10)
	move	3,-1(17)
	movem	3,0(11)
	movei	1,1
%L749:
	move	10,-4(17)
	move	11,-3(17)
	SUB	17,[5,,5]
	popj	17,

opt_reg_pair:
	skipn	6,016(1)
	 skipn	7,024(1)
	 jrst	%L759
	move	6,025(1)
	jumpn	6,%L758
%L759:
	setz	1,
	popj	17,
%L758:
	move	6,020(1)
	movem	6,0(3)
	move	7,021(1)
	movem	7,0(4)
	move	6,017(1)
	movem	6,0(2)
	movei	1,1
	popj	17,

opt_ac_integer:
	skipn	6,016(1)
	 skipn	7,024(1)
	 jrst	%L761
	move	6,026(1)
	jumpn	6,%L760
%L761:
	setz	1,
	popj	17,
%L760:
	move	6,020(1)
	movem	6,0(3)
	move	7,022(1)
	movem	7,0(4)
	move	6,017(1)
	movem	6,0(2)
	movei	1,1
	popj	17,

opt_ac_signed_integer:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	move	5,-1(17)
	skipn	1,016(5)
	 skipn	2,024(5)
	 jrst	%L763
	skipe	3,026(5)
	 jrst	%L762
%L763:
	setz	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L762:
	move	7,-1(17)
	move	1,020(7)
	move	4,-3(17)
	movem	1,0(4)
	move	2,027(7)
	move	6,-4(17)
	movem	2,0(6)
	move	3,022(7)
	move	1,-5(17)
	movem	3,0(1)
	move	5,017(7)
	move	2,-2(17)
	movem	5,0(2)
	movei	1,1
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

opt_direct_move:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
	movei	2,0(17)
	move	3,011
	move	4,012
	move	1,010
	pushj	17,opt_reg_pair
	jumpe	1,%L766
	move	3,0(17)
	came	3,[015172605]
%L766:
	 tdza	1,1
	 movei	1,1
%L764:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

opt_any_movei:
	skipe	4,016(1)
	 jrst	%L768
	move	5,017(1)
	move	3,[01517260511]
	camn	5,3
	 jrst	%L767
%L768:
	setz	1,
	popj	17,
%L767:
	move	4,024(1)
	jumpn	4,%L769
	setm	1,4
	popj	17,
%L769:
	move	4,020(1)
	movem	4,0(2)
	move	5,023(1)
	ldb	3,5
	cain	3,0
	 tdza	1,1
	 movei	1,1
	popj	17,

opt_direct_movei:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	movei	1,0(17)
	movei	2,-1(17)
	move	3,011
	move	4,1
	move	1,010
	pushj	17,opt_ac_integer
	jumpe	1,%L774
	move	3,-1(17)
	came	3,[01517260511]
	 jrst	%L774
	move	4,0(17)
	tlc	4,0400000
	camg	4,[0400000777777]
	 jrst	%L773
%L774:
	setz	1,
	jrst	%L772
%L773:
	move	2,0(17)
	movem	2,0(12)
	movei	1,1
%L772:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

opt_direct_setz:
	skipe	4,016(1)
	 jrst	%L776
	move	5,017(1)
	move	3,[023052432]
	camn	5,3
	 skipn	7,024(1)
	 jrst	%L776
	move	3,023(1)
	setm	6,4
	camn	3,6
	 jrst	%L776
	move	4,023(1)
	ldb	3,4
	jumpe	3,%L775
%L776:
	setz	1,
	popj	17,
%L775:
	move	4,020(1)
	movem	4,0(2)
	movei	1,1
	popj	17,

opt_halfword_fold:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[4,,4]
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L779
	skipn	4,01167(10)
	 jrst	%L779
	movei	1,-3(17)
	push	17,1
	movei	2,-1(17)
	movei	3,-2(17)
	movei	4,-3(17)
	move	1,011
	move	6,4
	move	4,2
	move	2,6
	pushj	17,opt_ac_signed_integer
	SUB	17,[1,,1]
	jumpe	1,%L779
	move	3,-1(17)
	move	4,01170(10)
	camn	3,4
	 jrst	%L778
%L779:
	setz	1,
	jrst	%L777
%L778:
	move	2,-2(17)
	came	2,[01160411]
	 jrst	%L780
	skipe	3,0(17)
	 jrst	%L782
	move	4,-3(17)
	cain	4,0777777
	 jrst	%L781
%L782:
	setz	1,
	jrst	%L777
%L781:
	movei	1,3
	jrst	%L777
%L780:
	move	2,-2(17)
	caie	2,0142310
	 jrst	%L784
	move	3,-3(17)
	cain	3,022
	 jrst	%L783
%L784:
	setz	1,
	jrst	%L777
%L783:
	skipn	2,0(17)
	 jrst	%L785
	movei	1,1
	jrst	%L786
%L785:
	movei	1,2
%L786:
%L777:
	move	10,-5(17)
	move	11,-4(17)
	SUB	17,[6,,6]
	popj	17,

opt_operand_uses_dot:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	movem	10,-2(17)
%L788:
	ldb	2,-2(17)
	jumpe	2,%L789
	caie	2,056
	 jrst	%L790
	move	3,-2(17)
	camn	3,010
	 jrst	%L792
	seto	1,
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	andi	1,0777
	pushj	17,das_native_is_alnum
	jumpn	1,%L791
	seto	3,
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	4,3
	caie	4,0137
	 cain	4,044
	 jrst	%L791
	caie	4,056
%L792:
	 tdza	2,2
%L791:
	 movei	2,1
	movem	2,-1(17)
	move	1,-2(17)
	ildb	1,1
	andi	1,0777
	pushj	17,das_native_is_alnum
	jumpn	1,%L794
	move	2,-2(17)
	ildb	3,2
	cain	3,0137
	 jrst	%L794
	move	4,-2(17)
	ildb	5,4
	movei	6,044
	camn	5,6
	 jrst	%L794
	move	7,-2(17)
	ildb	1,7
	cain	1,056
%L794:
	 skipa	1,[1]
	 setz	1,
	movem	1,0(17)
	skipn	3,-1(17)
	 caie	1,0
	 jrst	%L795
	movei	1,1
	jrst	%L787
%L795:
%L790:
	ibp	-2(17)
	move	1,-2(17)
	jrst	%L788
%L789:
	setz	1,
%L787:
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

opt_mem_ea_is_direct:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	move	1,010
	pushj	17,opt_operand_uses_dot
	jumpe	1,%L797
	setz	1,
	jrst	%L796
%L797:
	movem	10,0(17)
%L798:
	ldb	1,0(17)
	jumpe	1,%L799
	caie	1,0100
	 cain	1,050
	 jrst	%L801
	caie	1,051
	 cain	1,0133
	 jrst	%L801
	caie	1,0135
	 jrst	%L800
%L801:
	setz	1,
	jrst	%L796
%L800:
	ibp	0(17)
	move	1,0(17)
	jrst	%L798
%L799:
	movei	1,1
%L796:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

opt_copy_mem_ea:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[4,,4]
	move	2,-6(17)
	skipn	1,016(2)
	 jrst	%L802
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L802:
	move	2,-6(17)
	move	4,017(2)
	movem	4,0(17)
	came	4,[015172605]
	 jrst	%L804
	movei	1,1
	move	5,-7(17)
	movem	1,0(5)
	jrst	%L803
%L804:
	move	2,0(17)
	came	2,[01517260515]
	 jrst	%L805
	movei	1,2
	move	4,-7(17)
	movem	1,0(4)
	jrst	%L803
%L805:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L803:
	move	2,-6(17)
	skipe	1,024(2)
	 jrst	%L806
	setm	1,1
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L806:
	move	5,-6(17)
	move	1,020(5)
	move	4,-010(17)
	movem	1,0(4)
	move	6,023(5)
	movem	6,-3(17)
	ldb	2,6
	jumpe	2,%L808
	move	1,-3(17)
	pushj	17,opt_mem_ea_is_direct
	jumpn	1,%L807
%L808:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L807:
	move	1,-3(17)
	pushj	17,strlen
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	movem	1,-2(17)
%L809:
	move	2,-2(17)
	camn	2,-3(17)
	 jrst	%L810
	seto	1,
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L810
	seto	2,
	PUSH	17,1
	move	16,-3(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,-2(17)
	jrst	%L809
%L810:
	move	4,-2(17)
	move	16,-3(17)
	ADD	17,[3,,3]
	MOVEM	4,-02(17)
	MOVEM	16,-01(17)
	MOVEM	15,00(17)
	MOVE	5,-02(17)
	ANDI	5,0777777
	MOVE	4,-01(17)
	ANDI	4,0777777
	SUB	5,4
	IMULI	5,04
	HLRZ	15,-02(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	ADD	5,15
	HLRZ	15,-01(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	SUB	5,15
	MOVE	15,00(17)
	SUB	17,[3,,3]
	movem	5,-1(17)
	skipn	3,5
	 jrst	%L812
	tlc	3,0400000
	move	2,-012(17)
	tlc	2,0400000
	camge	3,2
	 jrst	%L811
%L812:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L811:
	move	2,-1(17)
	move	3,-3(17)
	move	1,-011(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	setz	1,
	move	3,-1(17)
	PUSH	17,1
	move	16,-012(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	movei	1,1
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

opt_redundant_mem_pair:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L815
	move	4,01214(10)
	soje	4,%L816
	move	5,01214(10)
	caie	5,2
	 jrst	%L815
%L816:
	skipn	2,016(11)
	 jrst	%L814
%L815:
	setz	1,
	jrst	%L813
%L814:
	move	2,01214(10)
	sojn	2,%L818
	move	3,017(11)
	camn	3,[015172605]
	 jrst	%L817
	setm	1,2
	jrst	%L813
%L818:
	move	2,017(11)
	camn	2,[01517260515]
	 jrst	%L817
	move	3,017(11)
	camn	3,[015172605]
	 jrst	%L817
	setz	1,
	jrst	%L813
%L817:
	skipn	2,024(11)
	 jrst	%L820
	move	3,020(11)
	move	4,01215(10)
	camn	3,4
	 jrst	%L819
%L820:
	setz	1,
	jrst	%L813
%L819:
	move	3,023(11)
	movem	3,-1(17)
	ldb	1,3
	jumpe	1,%L822
	move	1,-1(17)
	pushj	17,opt_mem_ea_is_direct
	jumpn	1,%L821
%L822:
	setz	1,
	jrst	%L813
%L821:
	move	1,-1(17)
	pushj	17,strlen
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	movem	1,0(17)
%L823:
	move	2,0(17)
	camn	2,-1(17)
	 jrst	%L824
	seto	1,
	move	16,0(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L824
	seto	2,
	PUSH	17,1
	move	16,-1(17)
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,0(17)
	jrst	%L823
%L824:
	setz	1,
	dpb	1,0(17)
	move	2,010
	addi	2,01216
	hrli	2,0331100
	move	3,-1(17)
	move	1,3
	pushj	17,strcmp
	caie	1,0
	 tdza	1,1
	 movei	1,1
%L813:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

opt_direct_jump_symbol:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[4,,4]
	move	6,-6(17)
	skipn	1,0(6)
	 skipe	2,016(6)
	 jrst	%L828
	skipn	3,024(6)
	 jrst	%L828
	move	4,023(6)
	setm	5,2
	came	4,5
	 jrst	%L827
%L828:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L827:
	move	2,-6(17)
	move	1,017(2)
	setz	2,
	pushj	17,lookup_op_mn
	movem	1,0(17)
	cail	1,0321
	 caile	1,0327
	 jrst	%L830
	caie	1,0324
	 jrst	%L829
%L830:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L829:
	move	2,-6(17)
	move	1,023(2)
	pushj	17,skipws
	movem	1,-3(17)
	ldb	1,-3(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L831
	setm	1,1
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L831:
	move	1,-3(17)
	ibp	1
	movem	1,-2(17)
%L832:
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L833
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L832
%L833:
	move	1,-2(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L834
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L834:
	move	4,-2(17)
	move	16,-3(17)
	ADD	17,[3,,3]
	MOVEM	4,-02(17)
	MOVEM	16,-01(17)
	MOVEM	15,00(17)
	MOVE	5,-02(17)
	ANDI	5,0777777
	MOVE	4,-01(17)
	ANDI	4,0777777
	SUB	5,4
	IMULI	5,04
	HLRZ	15,-02(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	ADD	5,15
	HLRZ	15,-01(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	SUB	5,15
	MOVE	15,00(17)
	SUB	17,[3,,3]
	movem	5,-1(17)
	skipn	3,5
	 jrst	%L836
	tlc	3,0400000
	move	2,-010(17)
	tlc	2,0400000
	camge	3,2
	 jrst	%L835
%L836:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L835:
	move	2,-1(17)
	move	3,-3(17)
	move	1,-7(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	setz	1,
	move	3,-1(17)
	PUSH	17,1
	move	16,-010(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	move	4,0(17)
	move	5,-011(17)
	movem	4,0(5)
	move	6,-6(17)
	move	2,020(6)
	move	1,-012(17)
	movem	2,0(1)
	movei	1,1
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

opt_direct_jrst_symbol:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	skipn	2,0(10)
	 skipe	3,016(10)
	 jrst	%L839
	move	4,017(10)
	camn	4,[012222324]
	 jrst	%L838
%L839:
	setz	1,
	jrst	%L837
%L838:
	move	2,3(10)
	move	1,2
	pushj	17,skipws
	movem	1,-2(17)
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L840
	setm	1,1
	jrst	%L837
%L840:
	move	1,-2(17)
	ibp	1
	movem	1,-1(17)
%L841:
	ldb	1,-1(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L842
	ibp	-1(17)
	move	2,-1(17)
	jrst	%L841
%L842:
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L843
	setz	1,
	jrst	%L837
%L843:
	move	4,-1(17)
	move	16,-2(17)
	ADD	17,[3,,3]
	MOVEM	4,-02(17)
	MOVEM	16,-01(17)
	MOVEM	15,00(17)
	MOVE	5,-02(17)
	ANDI	5,0777777
	MOVE	4,-01(17)
	ANDI	4,0777777
	SUB	5,4
	IMULI	5,04
	HLRZ	15,-02(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	ADD	5,15
	HLRZ	15,-01(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	SUB	5,15
	MOVE	15,00(17)
	SUB	17,[3,,3]
	movem	5,0(17)
	skipn	3,5
	 jrst	%L845
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camge	3,1
	 jrst	%L844
%L845:
	setz	1,
	jrst	%L837
%L844:
	move	2,0(17)
	move	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	setz	1,
	move	3,0(17)
	move	2,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	movei	1,1
%L837:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

opt_label_is:
	push	17,016
	push	17,010
	move	10,2
	ADD	17,[013,,013]
	move	3,0(1)
	setz	2,
	came	3,2
	 jrst	%L847
	setm	1,2
	jrst	%L846
%L847:
	move	3,1(1)
	movem	3,0(17)
	jumpe	3,%L849
	tlc	3,0400000
	camg	3,[0400000000047]
	 jrst	%L848
%L849:
	setz	1,
	jrst	%L846
%L848:
	move	3,0(17)
	move	4,0(1)
	movei	2,-012(17)
	hrli	2,0331100
	move	1,2
	move	2,4
	pushj	17,das_native_memcpy
	setz	1,
	move	4,0(17)
	PUSH	17,1
	MOVEI	16,-013(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	movei	1,-012(17)
	hrli	1,0331100
	move	2,010
	pushj	17,streqi
%L846:
	move	10,-013(17)
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,

opt_jrst_next_label:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	skipn	2,das_optimize
	 jrst	%L852
	move	3,01214(10)
	caie	3,3
	 jrst	%L852
	move	2,010
	addi	2,01216
	hrli	2,0331100
	move	1,011
	pushj	17,opt_label_is
	cain	1,0
%L852:
	 tdza	1,1
	 movei	1,1
%L850:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

opt_jump_jrst_next_label:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	skipn	2,das_optimize
	 jrst	%L855
	move	3,01214(10)
	caie	3,5
	 jrst	%L855
	move	2,010
	addi	2,01216
	hrli	2,0331100
	move	1,011
	pushj	17,opt_label_is
	cain	1,0
%L855:
	 tdza	1,1
	 movei	1,1
%L853:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

opt_jump_jrst_transition:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	skipn	2,das_optimize
	 jrst	%L858
	move	3,01214(10)
	movei	1,4
	camn	3,1
	 jrst	%L857
%L858:
	setz	1,
	jrst	%L856
%L857:
	move	1,010
	addi	1,01216
	hrli	1,0331100
	movei	2,050
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,-1(17)
	movei	3,0330
	movem	3,0(17)
	move	2,0(17)
	move	3,-1(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_direct_jrst_symbol
	jumpn	1,%L859
	setm	1,1
	jrst	%L856
%L859:
	move	1,010
	pushj	17,opt_reset
	movei	1,5
	movem	1,01214(10)
	movei	1,1
%L856:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

opt_instruction_overwrites_ac:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[3,,3]
	skipn	2,0(10)
	 skipa	3,016(10)
	 trna	
	 jumpe	3,%L861
	setz	1,
	jrst	%L860
%L861:
	movei	3,0(17)
	movei	2,-2(17)
	move	1,010
	pushj	17,opt_direct_movei
	jumpe	1,%L863
	move	3,-2(17)
	came	3,011
	 tdza	1,1
	 movei	1,1
	jrst	%L860
%L863:
	movei	3,-1(17)
	movei	2,-2(17)
	move	1,010
	pushj	17,opt_direct_move
	jumpe	1,%L866
	move	6,-2(17)
	camn	6,011
	 camn	6,-1(17)
	 tdza	1,1
	 movei	1,1
	jrst	%L860
%L866:
	setz	1,
%L860:
	move	10,-4(17)
	move	11,-3(17)
	SUB	17,[5,,5]
	popj	17,

opt_indexed_xct_symbol:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[4,,4]
	skipe	2,016(10)
	 jrst	%L871
	move	3,017(10)
	cain	3,0300324
	 jrst	%L870
%L871:
	setz	1,
	jrst	%L869
%L870:
	move	2,3(10)
	move	1,2
	pushj	17,skipws
	movem	1,-3(17)
	ldb	2,1
	caie	2,0100
	 jrst	%L872
	move	1,-3(17)
	ibp	1
	pushj	17,skipws
	movem	1,-3(17)
%L872:
	ldb	1,-3(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L873
	setm	1,1
	jrst	%L869
%L873:
	move	1,-3(17)
	ibp	1
	movem	1,-2(17)
%L874:
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L875
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L874
%L875:
	move	2,-2(17)
	movem	2,-1(17)
%L876:
	ldb	2,-1(17)
	jumpe	2,%L877
	cain	2,050
	 jrst	%L877
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L876
%L877:
	ldb	1,-1(17)
	cain	1,050
	 jrst	%L878
	setz	1,
	jrst	%L869
%L878:
	move	4,-2(17)
	move	16,-3(17)
	ADD	17,[3,,3]
	MOVEM	4,-02(17)
	MOVEM	16,-01(17)
	MOVEM	15,00(17)
	MOVE	5,-02(17)
	ANDI	5,0777777
	MOVE	4,-01(17)
	ANDI	4,0777777
	SUB	5,4
	IMULI	5,04
	HLRZ	15,-02(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	ADD	5,15
	HLRZ	15,-01(17)
	LSH	15,-014
	ANDI	15,077
	MOVN	15,15
	ADDI	15,033
	IMULI	15,010
	LSH	15,-06
	SUB	5,15
	MOVE	15,00(17)
	SUB	17,[3,,3]
	movem	5,0(17)
	skipn	3,5
	 jrst	%L880
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camge	3,1
	 jrst	%L879
%L880:
	setz	1,
	jrst	%L869
%L879:
	move	2,0(17)
	move	3,-3(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	setz	1,
	move	4,0(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	11,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	movei	1,1
%L869:
	move	10,-6(17)
	move	11,-5(17)
	move	12,-4(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

opt_label_is_indexed_xct_target:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[013,,013]
	move	3,0(2)
	setz	1,
	came	3,1
	 jrst	%L882
	setm	1,1
	jrst	%L881
%L882:
	move	4,1(2)
	movem	4,0(17)
	tlc	4,0400000
	camle	4,[0400000000047]
	 skipa	1,[047]
	 trna	
	 movem	1,0(17)
	move	3,0(17)
	move	4,0(2)
	movei	1,-012(17)
	hrli	1,0331100
	move	2,4
	pushj	17,das_native_memcpy
	setz	1,
	move	4,0(17)
	PUSH	17,1
	MOVEI	16,-013(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	movei	1,-012(17)
	hrli	1,0331100
	move	2,1
	move	1,010
	pushj	17,find_indexed_xct_marker
%L881:
	move	10,-013(17)
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,

opt_instruction_may_skip:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	skipn	2,das_optimize
	 jrst	%L886
	skipn	3,016(10)
	 jrst	%L885
%L886:
	setz	1,
	jrst	%L884
%L885:
	move	2,017(10)
	caie	2,0300324
	 jrst	%L887
	movei	1,1
	jrst	%L884
%L887:
	move	2,017(10)
	move	1,2
	setz	2,
	pushj	17,lookup_op_mn
	movem	1,0(17)
	skipl	3,1
	 jrst	%L888
	setz	1,
	jrst	%L884
%L888:
	move	3,0(17)
	caige	3,0301
	 jrst	%L891
	caig	3,0307
	 jrst	%L890
%L891:
	move	3,0(17)
	caige	3,0311
	 jrst	%L892
	caig	3,0317
	 jrst	%L890
%L892:
	move	3,0(17)
	caige	3,0331
	 jrst	%L893
	caig	3,0337
	 jrst	%L890
%L893:
	move	3,0(17)
	caige	3,0351
	 jrst	%L894
	caig	3,0357
	 jrst	%L890
%L894:
	move	3,0(17)
	cail	3,0371
	 caile	3,0377
	 jrst	%L889
%L890:
	movei	1,1
	jrst	%L884
%L889:
	move	2,0(17)
	cail	2,0600
	 caile	2,0677
	 jrst	%L895
	trnn	2,7
	 jrst	%L895
	movei	1,1
	jrst	%L884
%L895:
	setz	1,
%L884:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

opt_begin_line:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,01321(10)
	skipn	2,0(11)
	 jrst	%L897
	movni	1,3
	andb	1,0(17)
	move	1,010
	move	2,011
	pushj	17,opt_label_is_indexed_xct_target
	jumpe	1,%L897
	movei	2,2
	iorb	2,0(17)
%L897:
	skipn	2,2(11)
	 jrst	%L899
	skipn	3,016(11)
	 jrst	%L898
%L899:
	setz	1,
	movem	1,01322(10)
	move	3,0(17)
	movem	3,01321(10)
	move	4,2(11)
	setm	2,1
	camn	4,2
	 skipn	6,0(11)
	 jrst	%L900
	movei	5,1
	iorb	5,01321(10)
%L900:
	jrst	%L896
%L898:
	skipn	2,0(17)
	 jrst	%L901
	move	1,010
	pushj	17,opt_reset
%L901:
	move	2,0(17)
	movem	2,01322(10)
	move	3,2
	andi	3,2
	movem	3,01321(10)
	move	1,011
	pushj	17,opt_instruction_may_skip
	jumpe	1,%L902
	movei	2,1
	iorb	2,01321(10)
%L902:
%L896:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

opt_record_prev:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[017,,017]
	skipe	2,01322(10)
	 jrst	%L903
	move	3,0(11)
	setm	1,2
	camn	3,1
	 jrst	%L905
	move	1,010
	pushj	17,opt_reset
	jrst	%L903
%L905:
	setz	1,
	movem	1,-014(17)
	setm	2,1
	movem	2,-013(17)
	setz	3,
	movem	3,-012(17)
	skipn	5,das_optimize
	 jrst	%L907
	move	6,01202(10)
	jumpe	6,%L907
	movei	3,-7(17)
	movei	2,-010(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L907
	move	5,-7(17)
	move	4,01203(10)
	camn	5,4
	 camn	5,-010(17)
	 jrst	%L907
	movei	2,1
	movem	2,-014(17)
	movem	5,-013(17)
	move	6,-010(17)
	movem	6,01206(10)
	move	7,01202(10)
	caie	7,2
	 jrst	%L908
	movei	1,4
	jrst	%L909
%L908:
	movei	1,2
%L909:
	movem	1,-012(17)
	jrst	%L906
%L907:
	skipe	2,das_optimize
	 skipn	3,01176(10)
	 jrst	%L906
	movei	3,-7(17)
	movei	2,-010(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L906
	move	5,-7(17)
	move	4,01177(10)
	camn	5,4
	 camn	5,-010(17)
	 jrst	%L906
	movei	2,1
	movem	2,-014(17)
	movem	5,-013(17)
	move	6,-010(17)
	movem	6,01206(10)
	movei	3,3
	movem	3,-012(17)
%L906:
	setz	1,
	movem	1,01167(10)
	setm	2,1
	movem	2,01171(10)
	setz	3,
	movem	3,01173(10)
	setm	4,3
	movem	4,01176(10)
	setz	5,
	movem	5,01200(10)
	setm	6,5
	movem	6,01202(10)
	move	1,-014(17)
	movem	1,01204(10)
	jumpe	1,%L910
	move	1,-013(17)
	movem	1,01205(10)
	move	1,-012(17)
	movem	1,01207(10)
%L910:
	setz	1,
	movem	1,01214(10)
	setm	2,1
	movem	2,01316(10)
	skipn	4,das_optimize
	 jrst	%L912
	skipn	5,016(11)
	 jrst	%L911
%L912:
	jrst	%L903
%L911:
	skipe	2,0(11)
	 jrst	%L913
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_movei
	jumpe	1,%L915
	movei	2,1
	movem	2,01200(10)
	move	4,-016(17)
	movem	4,01201(10)
	jrst	%L914
%L915:
	movei	3,-6(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L914
	movei	2,1
	movem	2,01200(10)
	move	4,-016(17)
	movem	4,01201(10)
%L914:
%L913:
	push	17,[0400]
	move	4,010
	addi	4,01216
	hrli	4,0331100
	movei	2,-017(17)
	movei	3,-6(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_copy_mem_ea
	SUB	17,[1,,1]
	jumpe	1,%L916
	move	3,-5(17)
	sojn	3,%L917
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_move_literal_immediate
	jumpn	1,%L916
%L917:
	move	2,-5(17)
	movem	2,01214(10)
	move	3,-016(17)
	movem	3,01215(10)
%L916:
	movei	1,-3(17)
	push	17,1
	movei	2,-5(17)
	move	3,010
	addi	3,01216
	hrli	3,0331100
	move	1,011
	move	4,2
	move	2,3
	movei	3,050
	pushj	17,opt_direct_jump_symbol
	SUB	17,[1,,1]
	jumpe	1,%L918
	movei	3,4
	movem	3,01214(10)
	move	4,-4(17)
	lsh	4,0(3)
	move	5,-3(17)
	andi	5,017
	ior	4,5
	movem	4,01215(10)
%L918:
	skipe	2,01214(10)
	 jrst	%L919
	move	1,010
	addi	1,01216
	hrli	1,0331100
	move	2,1
	move	1,011
	movei	3,0400
	pushj	17,opt_direct_jrst_symbol
	jumpe	1,%L919
	movei	2,3
	movem	2,01214(10)
%L919:
	skipe	2,0(11)
	 jrst	%L921
	move	3,017(11)
	came	3,[015172605]
	 jrst	%L921
	move	4,024(11)
	jumpe	4,%L921
	move	5,023(11)
	setm	1,2
	camn	5,1
	 jrst	%L921
	move	7,023(11)
	ldb	6,7
	jumpe	6,%L921
	skipe	2,025(11)
	 jrst	%L921
	movei	1,1
	movem	1,01202(10)
	move	2,020(11)
	movem	2,01203(10)
	jrst	%L920
%L921:
	skipe	2,0(11)
	 jrst	%L920
	movei	4,-7(17)
	movei	2,-010(17)
	movei	3,-011(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L920
	move	3,-011(17)
	came	3,[023052415]
	 jrst	%L920
	move	4,-010(17)
	camn	4,-7(17)
	 jrst	%L920
	movei	2,2
	movem	2,01202(10)
	move	6,-010(17)
	movem	6,01203(10)
%L920:
	move	2,017(11)
	came	2,[015172605]
	 jrst	%L922
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_move_literal_immediate
	jumpn	1,%L922
	skipn	3,024(11)
	 jrst	%L903
	move	4,020(11)
	movem	4,-016(17)
	movei	2,1
	movem	2,01167(10)
	move	6,-016(17)
	movem	6,01170(10)
	jrst	%L903
%L922:
	move	2,017(11)
	camn	2,[01517260515]
	 jrst	%L903
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_setz
	jumpe	1,%L925
	movei	2,1
	movem	2,01171(10)
	move	4,-016(17)
	movem	4,01172(10)
	jrst	%L903
%L925:
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_any_movei
	jumpe	1,%L926
	movei	2,1
	movem	2,01176(10)
	move	4,-016(17)
	movem	4,01177(10)
%L926:
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_movei
	jumpe	1,%L927
	movei	3,1
	movem	3,01173(10)
	move	4,-016(17)
	movem	4,01174(10)
	move	5,-015(17)
	movem	5,01175(10)
	skipe	6,5
	 jrst	%L927
	movem	3,01171(10)
	move	7,-016(17)
	movem	7,01172(10)
%L927:
	skipe	2,0(11)
	 jrst	%L928
	movei	1,-1(17)
	push	17,1
	movei	2,-1(17)
	movei	3,-017(17)
	movei	4,-3(17)
	move	1,011
	move	6,4
	move	4,2
	move	2,6
	pushj	17,opt_ac_signed_integer
	SUB	17,[1,,1]
	jumpe	1,%L928
	move	3,-2(17)
	cain	3,0142310
	 skipn	4,0(17)
	 jrst	%L928
	move	5,-1(17)
	tlc	5,0400000
	camle	5,[0400000000077]
	 jrst	%L928
	movei	2,1
	movem	2,01316(10)
	move	7,-016(17)
	movem	7,01317(10)
	move	1,-1(17)
	movem	1,01320(10)
%L928:
%L903:
	move	10,-020(17)
	move	11,-017(17)
	SUB	17,[021,,021]
	popj	17,

opt_lshr_andi_redundant:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[5,,5]
	skipn	2,das_optimize
	 jrst	%L931
	move	3,0(11)
	setz	1,
	camn	3,1
	 skipn	5,01316(10)
	 jrst	%L931
	movei	4,-3(17)
	movei	2,-1(17)
	movei	3,-4(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_ac_integer
	jumpe	1,%L931
	move	3,-4(17)
	came	3,[01160411]
	 jrst	%L931
	move	4,-1(17)
	move	5,01317(10)
	came	4,5
	 jrst	%L931
	move	6,-3(17)
	tlc	6,0400000
	camle	6,[0400000777777]
	 jrst	%L931
	move	7,01320(10)
	tlc	7,0400000
	caml	7,[0400000000022]
	 jrst	%L930
%L931:
	setz	1,
	jrst	%L929
%L930:
	move	2,01320(10)
	tlc	2,0400000
	camge	2,[0400000000044]
	 jrst	%L933
	setz	1,
	movem	1,-2(17)
	jrst	%L932
%L933:
	movn	4,01320(10)
	addi	4,044
	movem	4,0(17)
	movei	1,1
	lsh	1,0(4)
	subi	1,1
	movem	1,-2(17)
%L932:
	move	2,-3(17)
	and	2,-2(17)
	came	2,-2(17)
	 tdza	1,1
	 movei	1,1
%L929:
	move	10,-6(17)
	move	11,-5(17)
	SUB	17,[7,,7]
	popj	17,

opt_immediate_fold:
	push	17,016
	ADD	17,[010,,010]
	MOVEI	0,-7(17)
	HRLI	0,010
	BLT	0,-4(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L938
	move	4,01173(10)
	skipn	5,016(11)
	 jumpn	4,%L937
%L938:
	setz	1,
	jrst	%L936
%L937:
	movei	1,-3(17)
	movei	2,-2(17)
	move	3,012
	move	4,1
	move	1,011
	pushj	17,opt_ac_integer
	jumpe	1,%L940
	move	3,0(12)
	move	4,01174(10)
	came	3,4
	 jrst	%L940
	move	5,-3(17)
	tlc	5,0400000
	camg	5,[0400000777777]
	 jrst	%L939
%L940:
	setz	1,
	jrst	%L936
%L939:
	move	3,-2(17)
	came	3,[01040411]
	 camn	3,[01160411]
	 jrst	%L941
	came	3,[011172211]
	 camn	3,[01115251411]
	 jrst	%L941
	setz	1,
	jrst	%L936
%L941:
	move	5,01175(10)
	movem	5,0(17)
	move	3,-3(17)
	movem	3,-1(17)
	move	4,-2(17)
	came	4,[01040411]
	 jrst	%L943
	tlc	5,0400000
	movn	2,-1(17)
	addi	2,0777777
	tlc	2,0400000
	camg	5,2
	 jrst	%L944
	setz	1,
	jrst	%L936
%L944:
	move	2,0(17)
	add	2,-1(17)
	movem	2,0(13)
	jrst	%L942
%L943:
	move	2,-2(17)
	came	2,[01160411]
	 jrst	%L945
	move	3,0(17)
	and	3,-1(17)
	movem	3,0(13)
	jrst	%L942
%L945:
	move	2,-2(17)
	came	2,[011172211]
	 jrst	%L946
	move	3,0(17)
	ior	3,-1(17)
	movem	3,0(13)
	jrst	%L942
%L946:
	skipn	2,-1(17)
	 jrst	%L947
	move	3,0(17)
	tlc	3,0400000
	movei	1,0777777
	skipge	16,-1(17)
	 JRST	%UIDN20
	JUMPGE	1,%UIDP20
	CAIG	16,1
	 JRST	%UIDZ20
	MOVE	2,1
	ANDI	2,1
	PUSH	17,02
	LSH	1,-1
	IDIV	1,016
	LSH	1,1
	LSH	2,1
	ADD	2,0(17)
	SUB	17,[1,,1]
	CAMGE	2,016
	 JRST	%UIDD20
	SUB	2,016
	AOJA	1,%UIDD20
%UIDN20:	MOVE	2,1
	MOVEI	1,0
	JUMPGE	2,%UIDD20
	CAMGE	2,016
	 JRST	%UIDD20
	SUB	2,016
	AOJA	1,%UIDD20
%UIDZ20:	TDZA	2,2
%UIDP20:	IDIV	1,016
%UIDD20:
	tlc	1,0400000
	camg	3,1
	 jrst	%L947
	setz	1,
	jrst	%L936
%L947:
	move	4,0(17)
	mul	4,-1(17)
	trne	4,1
	 tloa	5,0400000
	 tlz	5,0400000
	movem	5,0(13)
%L942:
	movei	1,1
%L936:
	MOVEI	0,010
	HRLI	0,-7(17)
	BLT	0,013
	move	16,-010(17)
	SUB	17,[011,,011]
	popj	17,

opt_movei_right_shift_fold:
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipn	2,das_optimize
	 jrst	%L950
	move	3,0(11)
	setz	1,
	camn	3,1
	 skipn	5,01173(10)
	 jrst	%L950
	movei	1,-2(17)
	push	17,1
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	4,2
	move	2,3
	move	3,012
	pushj	17,opt_ac_signed_integer
	SUB	17,[1,,1]
	jumpe	1,%L950
	move	3,0(12)
	move	4,01174(10)
	camn	3,4
	 skipn	5,0(17)
	 jrst	%L950
	move	7,-1(17)
	cain	7,012310
	 jrst	%L951
	caie	7,0142310
	 jrst	%L950
%L951:
	move	2,-2(17)
	tlc	2,0400000
	camg	2,[0400000000077]
	 jrst	%L949
%L950:
	setz	1,
	jrst	%L948
%L949:
	move	2,-2(17)
	tlc	2,0400000
	camge	2,[0400000000022]
	 jrst	%L953
	setz	1,
	movem	1,0(13)
	jrst	%L952
%L953:
	move	2,01175(10)
	movn	3,-2(17)
	lsh	2,0(3)
	movem	2,0(13)
%L952:
	movei	1,1
%L948:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	SUB	17,[7,,7]
	popj	17,

opt_movei_test_nonskip:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[4,,4]
	skipn	2,das_optimize
	 jrst	%L956
	move	3,0(11)
	setz	1,
	camn	3,1
	 skipn	5,01173(10)
	 jrst	%L956
	skipn	6,016(11)
	 jrst	%L955
%L956:
	setz	1,
	jrst	%L954
%L955:
	movei	4,-3(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_ac_integer
	jumpe	1,%L958
	move	3,-1(17)
	move	4,01174(10)
	came	3,4
	 jrst	%L958
	move	5,-3(17)
	tlc	5,0400000
	camg	5,[0400000777777]
	 jrst	%L957
%L958:
	setz	1,
	jrst	%L954
%L957:
	move	3,-2(17)
	came	3,[024221605]
	 camn	3,[024221616]
	 jrst	%L959
	came	3,[024141605]
	 camn	3,[024141616]
	 jrst	%L959
	setz	1,
	jrst	%L954
%L959:
	move	3,-2(17)
	camn	3,[024221605]
	 jrst	%L962
	came	3,[024221616]
	 jrst	%L961
%L962:
	move	2,01175(10)
	and	2,-3(17)
	movem	2,0(17)
	jrst	%L960
%L961:
	setzb	1,0(17)
%L960:
	move	3,-2(17)
	camn	3,[024221605]
	 jrst	%L964
	came	3,[024141605]
	 jrst	%L963
%L964:
	skipn	2,0(17)
	 tdza	1,1
	 movei	1,1
	jrst	%L954
%L963:
	skipe	2,0(17)
	 tdza	1,1
	 movei	1,1
%L954:
	move	10,-5(17)
	move	11,-4(17)
	SUB	17,[6,,6]
	popj	17,

opt_movei_movn_fold:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L971
	skipn	4,01173(10)
	 jrst	%L971
	movei	1,0(17)
	movei	2,-1(17)
	move	3,012
	move	4,1
	move	1,011
	pushj	17,opt_reg_pair
	jumpe	1,%L971
	move	3,-1(17)
	camn	3,[015172616]
	 jrst	%L970
%L971:
	setz	1,
	jrst	%L969
%L970:
	move	2,0(12)
	move	3,01174(10)
	came	2,3
	 jrst	%L973
	move	4,0(17)
	move	5,0(12)
	came	4,5
%L973:
	 tdza	1,1
	 movei	1,1
%L969:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

opt_lookup_code:
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,010
	pushj	17,sixbit_mn
	movem	1,-1(17)
	setzb	2,0(17)
%L975:
	move	2,0(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L976
	move	4,0(17)
	ash	4,1
	add	4,011
	move	5,0(4)
	came	5,-1(17)
	 jrst	%L977
	move	7,0(17)
	ash	7,1
	add	7,011
	move	1,1(7)
	movem	1,0(13)
	movei	1,1
	jrst	%L974
%L977:
	aos	1,0(17)
	jrst	%L975
%L976:
	setz	1,
%L974:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	SUB	17,[6,,6]
	popj	17,

%L978:
	.word 015172623
	.word 0205
	.word 02305240315
	.word 0461
	.word 010221432
	.word 0515
	.word 010222205
	.word 0571

opt_movei_unary_immediate_fold:
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L981
	skipn	4,01173(10)
	 jrst	%L981
	movei	1,0(17)
	movei	2,-1(17)
	move	3,012
	move	4,1
	move	1,011
	pushj	17,opt_reg_pair
	jumpe	1,%L981
	movei	1,%L978
	move	2,011
	addi	2,4
	hrli	2,0331100
	move	4,013
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,opt_lookup_code
	jumpn	1,%L980
%L981:
	setz	1,
	jrst	%L979
%L980:
	move	2,0(12)
	move	3,01174(10)
	came	2,3
	 jrst	%L983
	move	4,0(17)
	move	5,0(12)
	came	4,5
%L983:
	 tdza	1,1
	 movei	1,1
%L979:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	SUB	17,[6,,6]
	popj	17,

opt_set_prev_immediate:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	move	1,010
	pushj	17,opt_reset
	movei	5,1
	movem	5,01146(10)
	move	2,012
	add	2,[01000000]
	move	3,010
	addi	3,01147
	move	4,011
	add	4,3
	movem	2,0(4)
	movem	5,01173(10)
	movem	11,01174(10)
	movem	12,01175(10)
	move	7,5
	movem	7,01176(10)
	movem	11,01177(10)
	move	1,012
	jumpn	1,%L985
	movem	7,01171(10)
	movem	11,01172(10)
%L985:
%L984:
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	popj	17,

opt_zero_move_pair:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
	skipn	2,das_optimize
	 jrst	%L988
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L988
	move	5,01171(10)
	jumpe	5,%L988
	movei	1,0(17)
	move	2,012
	move	3,1
	move	1,011
	pushj	17,opt_direct_move
	jumpn	1,%L987
%L988:
	setz	1,
	jrst	%L986
%L987:
	move	2,0(17)
	move	3,01172(10)
	camn	2,3
	 skipa	4,0(12)
	 trna	
	 camn	4,2
	 tdza	1,1
	 movei	1,1
%L986:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

opt_zero_pair:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
	skipn	2,das_optimize
	 jrst	%L993
	move	3,0(11)
	setz	1,
	camn	3,1
	 skipa	5,01171(10)
	 trna	
	 jumpn	5,%L992
%L993:
	setz	1,
	jrst	%L991
%L992:
	move	1,011
	move	2,012
	pushj	17,opt_direct_setz
	jumpn	1,%L994
	movei	1,0(17)
	move	2,012
	move	3,1
	move	1,011
	pushj	17,opt_direct_movei
	skipn	3,0(17)
	 jumpn	1,%L994
	setz	1,
	jrst	%L991
%L994:
	move	2,0(12)
	move	3,01172(10)
	camn	2,3
	 tdza	1,1
	 movei	1,1
%L991:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

%L998:
	.word 015172623
	.word 0204
	.word 02305240315
	.word 0460
	.word 010141432
	.word 0510
	.word 010222232
	.word 0550
	.word 010142232
	.word 0554
	.word 010222205
	.word 0570

opt_move_unary_fold:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	skipn	2,das_optimize
	 jrst	%L1001
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L1001
	move	5,01167(10)
	jumpe	5,%L1001
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L1001
	movei	1,%L998
	move	2,011
	addi	2,4
	hrli	2,0331100
	move	4,012
	move	6,2
	move	2,1
	move	1,6
	movei	3,6
	pushj	17,opt_lookup_code
	jumpn	1,%L1000
%L1001:
	setz	1,
	jrst	%L999
%L1000:
	move	5,-1(17)
	move	3,01170(10)
	camn	5,3
	 came	5,0(17)
	 tdza	1,1
	 movei	1,1
%L999:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	SUB	17,[6,,6]
	popj	17,

%L1004:
	.word 023131120
	.word 0330
	.word 02313112014
	.word 0331
	.word 02313112005
	.word 0332
	.word 0231311201405
	.word 0333
	.word 02313112001
	.word 0334
	.word 0231311200705
	.word 0335
	.word 02313112016
	.word 0336
	.word 02313112007
	.word 0337

opt_move_skip_fold:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	skipn	2,das_optimize
	 jrst	%L1007
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L1007
	move	5,01167(10)
	jumpe	5,%L1007
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L1007
	movei	1,%L1004
	move	2,011
	addi	2,4
	hrli	2,0331100
	move	4,012
	move	6,2
	move	2,1
	move	1,6
	movei	3,010
	pushj	17,opt_lookup_code
	jumpn	1,%L1006
%L1007:
	setz	1,
	jrst	%L1005
%L1006:
	skipn	5,-1(17)
	 jrst	%L1009
	move	2,01170(10)
	camn	5,2
	 came	5,0(17)
%L1009:
	 tdza	1,1
	 movei	1,1
%L1005:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	SUB	17,[6,,6]
	popj	17,

opt_zero_store:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[1,,1]
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L1012
	move	4,01171(10)
	jumpe	4,%L1012
	move	5,016(11)
	jumpn	5,%L1012
	move	6,017(11)
	camn	6,[01517260515]
	 jrst	%L1011
%L1012:
	setz	1,
	jrst	%L1010
%L1011:
	skipn	2,024(11)
	 jrst	%L1014
	move	3,020(11)
	move	4,01172(10)
	camn	3,4
	 jrst	%L1013
%L1014:
	setz	1,
	jrst	%L1010
%L1013:
	move	3,023(11)
	movem	3,0(17)
	ldb	1,3
	jumpe	1,%L1016
	move	4,025(11)
	cain	4,0
%L1016:
	 tdza	1,1
	 movei	1,1
%L1010:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

opt_movei_hrrz_redundant:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[3,,3]
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L1019
	move	4,01176(10)
	jumpe	4,%L1019
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L1019
	move	3,-2(17)
	camn	3,[010222232]
	 jrst	%L1018
%L1019:
	setz	1,
	jrst	%L1017
%L1018:
	move	5,-1(17)
	move	3,01177(10)
	camn	5,3
	 came	5,0(17)
	 tdza	1,1
	 movei	1,1
%L1017:
	move	10,-4(17)
	move	11,-3(17)
	SUB	17,[5,,5]
	popj	17,

opt_overwrite_prev:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	skipn	2,das_optimize
	 jrst	%L1024
	move	3,01200(10)
	jumpe	3,%L1024
	move	2,01201(10)
	move	1,011
	pushj	17,opt_instruction_overwrites_ac
	jumpn	1,%L1023
%L1024:
	setz	1,
	jrst	%L1022
%L1023:
	move	2,01201(10)
	movem	2,0(12)
	movei	1,1
%L1022:
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	popj	17,

opt_finish_pending_push:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	skipe	2,das_optimize
	 skipn	3,01204(10)
	 jrst	%L1027
	move	2,01205(10)
	move	1,011
	pushj	17,opt_instruction_overwrites_ac
	cain	1,0
%L1027:
	 tdza	1,1
	 movei	1,1
%L1025:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

opt_drop_line:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[7,,7]
	skipe	2,das_optimize
	 jrst	%L1029
	setm	1,2
	jrst	%L1028
%L1029:
	skipn	2,0(11)
	 jrst	%L1030
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1028
%L1030:
	skipe	2,2(11)
	 jrst	%L1031
	setm	1,2
	jrst	%L1028
%L1031:
	move	2,01322(10)
	jumpe	2,%L1032
	setz	1,
	jrst	%L1028
%L1032:
	move	2,01146(10)
	tlc	2,0400000
	camge	2,[0400000000006]
	 jrst	%L1033
	move	1,010
	pushj	17,opt_reset
%L1033:
	movei	3,-5(17)
	movei	2,-6(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L1035
	move	4,010
	add	4,-5(17)
	move	2,01147(4)
	movem	2,-4(17)
	jrst	%L1034
%L1035:
	movei	3,-5(17)
	movei	2,-6(17)
	move	1,011
	pushj	17,opt_direct_movei
	jumpe	1,%L1036
	move	3,-5(17)
	add	3,[01000000]
	movem	3,-4(17)
	jrst	%L1034
%L1036:
	move	2,01210(10)
	jumpe	2,%L1038
	skipn	3,016(11)
	 skipa	4,017(11)
	 trna	
	 came	4,[015172605]
%L1038:
	 tdza	1,1
	 movei	1,1
	movem	1,-3(17)
	move	3,01211(10)
	movem	3,-2(17)
	move	4,01212(10)
	movem	4,-1(17)
	move	5,01213(10)
	movem	5,0(17)
	move	1,010
	pushj	17,opt_reset
	skipn	2,-3(17)
	 jrst	%L1039
	movei	1,1
	movem	1,01210(10)
	move	4,-2(17)
	movem	4,01211(10)
	move	5,-1(17)
	movem	5,01212(10)
	move	6,0(17)
	movem	6,01213(10)
%L1039:
	setz	1,
	jrst	%L1028
%L1034:
	move	1,010
	add	1,-6(17)
	move	2,01147(1)
	came	2,-4(17)
	 jrst	%L1040
	movei	1,1
	jrst	%L1028
%L1040:
	move	2,-4(17)
	move	4,010
	add	4,-6(17)
	movem	2,01147(4)
	aos	1,01146(10)
	setz	1,
%L1028:
	move	10,-010(17)
	move	11,-7(17)
	SUB	17,[011,,011]
	popj	17,

assignment_args:
	push	17,016
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,010
	movei	2,054
	pushj	17,strchr
	movem	1,-2(17)
	jumpn	1,%L1042
	seto	1,
	jrst	%L1041
%L1042:
	move	2,-2(17)
	move	1,010
	pushj	17,char_distance
	movem	1,0(17)
%L1043:
	skipn	2,0(17)
	 jrst	%L1044
	move	2,0(17)
	subi	2,1
	move	1,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,2
	pushj	17,das_native_is_space
	jumpe	1,%L1044
	sos	2,0(17)
	jrst	%L1043
%L1044:
%L1045:
	skipn	2,0(17)
	 jrst	%L1046
	move	1,010
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L1046
	ibp	010
	sos	2,0(17)
	jrst	%L1045
%L1046:
	skipn	3,0(17)
	 jrst	%L1048
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	caml	3,1
	 jrst	%L1048
	move	1,010
	ldb	1,1
	pushj	17,isname0
	jumpn	1,%L1047
%L1048:
	seto	1,
	jrst	%L1041
%L1047:
	move	2,0(17)
	move	1,010
	move	3,011
	move	6,3
	move	3,2
	move	2,1
	move	1,6
	pushj	17,das_native_memcpy
	setz	1,
	move	4,0(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	11,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	movei	3,1
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	11,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	3,-1(17)
%L1049:
	ldb	1,-1(17)
	jumpe	1,%L1050
	ldb	1,-1(17)
	pushj	17,isname
	jumpn	1,%L1051
	seto	1,
	jrst	%L1041
%L1051:
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L1049
%L1050:
	move	1,-2(17)
	ibp	1
	pushj	17,skipws
	movem	1,0(13)
	ldb	2,1
	jumpn	2,%L1052
	seto	1,
	jrst	%L1041
%L1052:
	setz	1,
%L1041:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

define_assignment:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[035,,035]
	movei	1,-022(17)
	movei	2,-034(17)
	hrli	2,0331100
	move	4,3(11)
	move	6,4
	move	4,1
	move	1,6
	movei	3,050
	pushj	17,assignment_args
	jumpe	1,%L1054
	movei	1,012360
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1053
%L1054:
	move	2,016(11)
	movei	1,031
	came	2,1
	 jrst	%L1055
	movei	1,010
	jrst	%L1056
%L1055:
	movei	1,020
%L1056:
	movem	1,-3(17)
	setz	2,
	movem	2,-1(17)
	cain	1,020
	 aosa	3,01336(10)
	 trna	
	 movem	3,-1(17)
	movei	1,-4(17)
	push	17,1
	movei	2,-6(17)
	move	4,-023(17)
	move	1,010
	move	3,012
	move	6,4
	move	4,2
	move	2,6
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpe	1,%L1058
	movei	1,1
	jrst	%L1053
%L1058:
	skipn	2,-4(17)
	 jrst	%L1059
	movei	1,4
	jrst	%L1060
%L1059:
	setz	1,
%L1060:
	movem	1,-2(17)
	movei	3,-021(17)
	movei	2,-034(17)
	hrli	2,0331100
	move	1,010
	pushj	17,find_sym
	jumpe	1,%L1061
	move	5,-7(17)
	andi	5,030
	movem	5,0(17)
	move	6,-3(17)
	caie	6,010
	 jrst	%L1062
	caie	5,010
	 jrst	%L1063
	move	3,-7(17)
	ior	6,-2(17)
	came	3,6
	 jrst	%L1063
	move	4,-6(17)
	came	4,-5(17)
	 jrst	%L1063
	setz	1,
	jrst	%L1053
%L1063:
	movei	1,012404
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1053
%L1062:
	move	2,0(17)
	cain	2,020
	 jrst	%L1064
	movei	1,012411
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1053
%L1064:
%L1061:
	move	2,-3(17)
	caie	2,020
	 jrst	%L1066
	move	2,-5(17)
	move	3,-2(17)
	move	4,-1(17)
	move	1,010
	move	6,4
	move	4,2
	move	2,6
	pushj	17,set_snapshot_define
	move	4,-1(17)
	movei	1,-034(17)
	hrli	1,0331100
	move	2,1
	move	1,010
	movei	3,020
	pushj	17,add_sym
	jrst	%L1065
%L1066:
	move	4,-5(17)
	move	3,-2(17)
	ior	3,-3(17)
	movei	1,-034(17)
	hrli	1,0331100
	move	2,1
	move	1,010
	pushj	17,add_sym
%L1065:
	setz	1,
%L1053:
	move	10,-037(17)
	move	11,-036(17)
	move	12,-035(17)
	SUB	17,[040,,040]
	popj	17,

common_args:
	push	17,016
	ADD	17,[011,,011]
	MOVEI	0,-010(17)
	HRLI	0,010
	BLT	0,-5(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,010
	movei	2,054
	pushj	17,strchr
	movem	1,-4(17)
	jumpn	1,%L1068
	seto	1,
	jrst	%L1067
%L1068:
	move	2,-4(17)
	move	1,010
	pushj	17,char_distance
	movem	1,0(17)
%L1069:
	skipn	2,0(17)
	 jrst	%L1070
	move	2,0(17)
	subi	2,1
	move	1,010
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	1,2
	pushj	17,das_native_is_space
	jumpe	1,%L1070
	sos	2,0(17)
	jrst	%L1069
%L1070:
%L1071:
	skipn	2,0(17)
	 jrst	%L1072
	move	1,010
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L1072
	ibp	010
	sos	2,0(17)
	jrst	%L1071
%L1072:
	skipn	3,0(17)
	 jrst	%L1074
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camge	3,1
	 jrst	%L1073
%L1074:
	seto	1,
	jrst	%L1067
%L1073:
	move	2,0(17)
	move	1,010
	move	3,011
	move	6,3
	move	3,2
	move	2,1
	move	1,6
	pushj	17,das_native_memcpy
	setz	1,
	move	4,0(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	11,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	move	1,-4(17)
	ibp	1
	pushj	17,skipws
	movem	1,-3(17)
	ldb	3,1
	caie	3,055
	 jumpn	3,%L1075
	seto	1,
	jrst	%L1067
%L1075:
	movei	2,-2(17)
	move	3,-3(17)
	move	1,3
	movei	3,012
	pushj	17,strtol
	movem	1,-1(17)
	move	3,-2(17)
	came	3,-3(17)
	 jrst	%L1077
	seto	1,
	jrst	%L1067
%L1077:
	move	1,-2(17)
	pushj	17,skipws
	movem	1,-2(17)
	ldb	3,1
	jumpe	3,%L1078
	cain	3,054
	 jrst	%L1078
	seto	1,
	jrst	%L1067
%L1078:
	move	2,-1(17)
	tlc	2,0400000
	camg	2,[0400003777774]
	 jrst	%L1079
	seto	1,
	jrst	%L1067
%L1079:
	move	2,-1(17)
	addi	2,3
	lsh	2,-2
	movem	2,0(13)
	setz	1,
%L1067:
	MOVEI	0,010
	HRLI	0,-010(17)
	BLT	0,013
	move	16,-011(17)
	SUB	17,[012,,012]
	popj	17,

parse_point_position:
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movei	1,0(17)
	push	17,1
	movei	2,-2(17)
	move	3,011
	move	1,010
	move	4,2
	move	2,3
	move	3,012
	pushj	17,eval_expr
	SUB	17,[1,,1]
	skipn	3,0(17)
	 jumpe	1,%L1081
	seto	1,
	jrst	%L1080
%L1081:
	move	2,-1(17)
	came	2,[0777777777777]
	 jrst	%L1083
	seto	1,
	movem	1,0(13)
	setz	1,
	jrst	%L1080
%L1083:
	move	2,-1(17)
	tlc	2,0400000
	camg	2,[0400000000043]
	 jrst	%L1084
	seto	1,
	jrst	%L1080
%L1084:
	move	2,-1(17)
	movem	2,0(13)
	setz	1,
%L1080:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	SUB	17,[6,,6]
	popj	17,

parse_point_word:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[013,,013]
	move	1,-015(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-7(17)
	jumpn	1,%L1085
	seto	1,
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1085:
	setz	1,
	move	3,-7(17)
	ibp	-7(17)
	dpb	1,3
	move	1,-015(17)
	pushj	17,skipws
	movem	1,-012(17)
	move	1,-7(17)
	pushj	17,skipws
	movem	1,-011(17)
	move	1,-012(17)
	pushj	17,rtrim
	move	1,-011(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-6(17)
	jumpe	1,%L1087
	setz	2,
	move	4,1
	ibp	-6(17)
	dpb	2,4
	move	1,-6(17)
	pushj	17,skipws
	movem	1,-010(17)
	move	1,-011(17)
	pushj	17,rtrim
	move	1,-010(17)
	pushj	17,rtrim
	ldb	1,-010(17)
	jumpe	1,%L1088
	movei	1,-4(17)
	move	3,-016(17)
	move	2,-010(17)
	move	5,-014(17)
	move	4,1
	move	1,5
	pushj	17,parse_point_position
	jumpe	1,%L1086
%L1088:
	seto	1,
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1087:
	move	1,-011(17)
	pushj	17,rtrim
	seto	1,
	movem	1,-4(17)
%L1086:
	ldb	1,-012(17)
	jumpe	1,%L1090
	ldb	2,-011(17)
	jumpe	2,%L1090
	movei	1,-5(17)
	push	17,1
	move	3,-017(17)
	move	4,-013(17)
	move	1,-015(17)
	move	2,4
	movei	4,077
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	jumpe	1,%L1089
%L1090:
	seto	1,
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1089:
	movei	1,-2(17)
	push	17,1
	movei	2,-1(17)
	push	17,2
	movei	3,-3(17)
	push	17,3
	movei	4,-6(17)
	move	6,-021(17)
	move	2,-014(17)
	move	1,-017(17)
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1091
	seto	1,
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1091:
	movn	1,-4(17)
	addi	1,043
	lsh	1,036
	move	3,-5(17)
	lsh	3,030
	ior	1,3
	move	4,-1(17)
	andi	4,1
	lsh	4,026
	ior	1,4
	move	5,0(17)
	andi	5,017
	lsh	5,022
	ior	1,5
	hrrz	6,-3(17)
	ior	1,6
	pushj	17,das_mask36
	move	3,-017(17)
	movem	1,0(3)
	move	4,-2(17)
	move	5,-020(17)
	movem	4,0(5)
	setz	1,
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

parse_giw_word:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,-5(17)
	move	2,-5(17)
	move	3,-4(17)
	move	4,-3(17)
	move	1,-2(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,eval_expr_octal
	SUB	17,[1,,1]
	jumpe	1,%L1092
	seto	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1092:
	setz	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

parse_exind_word:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[012,,012]
	move	1,-014(17)
	pushj	17,skipws
	movem	1,-014(17)
	ldb	2,1
	cain	2,050
	 jrst	%L1093
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1093:
	ibp	-014(17)
	move	1,-014(17)
	move	1,-014(17)
	movei	2,051
	pushj	17,strrchr
	movem	1,-6(17)
	jumpn	1,%L1094
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1094:
	setz	1,
	move	3,-6(17)
	ibp	-6(17)
	dpb	1,3
	move	1,-6(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L1095
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1095:
	move	2,-014(17)
	movem	2,-011(17)
	move	1,-011(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-010(17)
	jumpn	1,%L1096
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1096:
	setz	1,
	move	3,-010(17)
	ibp	-010(17)
	dpb	1,3
	move	1,-010(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-7(17)
	jumpn	1,%L1097
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1097:
	setz	1,
	move	3,-7(17)
	ibp	-7(17)
	dpb	1,3
	move	1,-7(17)
	movei	2,054
	pushj	17,strchr
	jumpe	1,%L1098
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1098:
	move	1,-011(17)
	pushj	17,rtrim
	move	1,-010(17)
	pushj	17,rtrim
	move	1,-7(17)
	pushj	17,rtrim
	movei	1,-2(17)
	push	17,1
	movei	2,-6(17)
	move	4,-016(17)
	move	5,-012(17)
	move	1,-014(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpn	1,%L1100
	movei	1,-1(17)
	push	17,1
	movei	2,-5(17)
	move	4,-016(17)
	move	5,-011(17)
	move	1,-014(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpn	1,%L1100
	movei	1,0(17)
	push	17,1
	movei	2,-4(17)
	move	4,-016(17)
	move	5,-010(17)
	move	1,-014(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpe	1,%L1099
%L1100:
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1099:
	skipn	2,-2(17)
	 skipe	3,-1(17)
	 jrst	%L1102
	skipn	4,0(17)
	 jrst	%L1101
%L1102:
	movei	1,013371
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1101:
	move	2,-5(17)
	tlc	2,0400000
	camle	2,[0400000000001]
	 jrst	%L1104
	move	3,-4(17)
	tlc	3,0400000
	camle	3,[0400000000017]
	 jrst	%L1104
	move	4,-3(17)
	tlc	4,0400000
	camg	4,[0407777777777]
	 jrst	%L1103
%L1104:
	movei	1,013376
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1103:
	move	2,-5(17)
	andi	2,1
	lsh	2,042
	move	3,-4(17)
	andi	3,017
	lsh	3,036
	ior	2,3
	move	4,-3(17)
	tlz	4,01777777777770000
	ior	2,4
	move	5,-016(17)
	movem	2,0(5)
	move	7,-017(17)
	setzb	1,0(7)
	setm	1,1
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

%L1105:
	.byte 9,0,0,0,046
	.byte 9,0,0,0,6
	.byte 9,0,0,0,0
	.byte 9,0,0,0,047
	.byte 9,0,0,0,6
	.byte 9,0,0,0,6
	.byte 9,0,0,0,050
	.byte 9,0,0,0,6
	.byte 9,0,0,0,014
	.byte 9,0,0,0,051
	.byte 9,0,0,0,6
	.byte 9,0,0,0,022
	.byte 9,0,0,0,052
	.byte 9,0,0,0,6
	.byte 9,0,0,0,030
	.byte 9,0,0,0,053
	.byte 9,0,0,0,6
	.byte 9,0,0,0,036
	.byte 9,0,0,0,062
	.byte 9,0,0,0,7
	.byte 9,0,0,0,0
	.byte 9,0,0,0,063
	.byte 9,0,0,0,7
	.byte 9,0,0,0,7
	.byte 9,0,0,0,064
	.byte 9,0,0,0,7
	.byte 9,0,0,0,016
	.byte 9,0,0,0,065
	.byte 9,0,0,0,7
	.byte 9,0,0,0,025
	.byte 9,0,0,0,066
	.byte 9,0,0,0,7
	.byte 9,0,0,0,034
	.byte 9,0,0,0,055
	.byte 9,0,0,0,010
	.byte 9,0,0,0,0
	.byte 9,0,0,0,056
	.byte 9,0,0,0,010
	.byte 9,0,0,0,010
	.byte 9,0,0,0,057
	.byte 9,0,0,0,010
	.byte 9,0,0,0,020
	.byte 9,0,0,0,060
	.byte 9,0,0,0,010
	.byte 9,0,0,0,030
	.byte 9,0,0,0,070
	.byte 9,0,0,0,011
	.byte 9,0,0,0,0
	.byte 9,0,0,0,071
	.byte 9,0,0,0,011
	.byte 9,0,0,0,011
	.byte 9,0,0,0,072
	.byte 9,0,0,0,011
	.byte 9,0,0,0,022
	.byte 9,0,0,0,073
	.byte 9,0,0,0,011
	.byte 9,0,0,0,033
	.byte 9,0,0,0,075
	.byte 9,0,0,0,022
	.byte 9,0,0,0,0
	.byte 9,0,0,0,076
	.byte 9,0,0,0,022
	.byte 9,0,0,0,022
	.byte 9,0,0,0,0
	.byte 9,0,0,0,0
	.byte 9,0,0,0,0

owgbp_lookup:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	push	17,[0]
%L1107:
	move	7,0(17)
	imuli	7,3
	skipn	1,%L1105(7)
	 jrst	%L1108
	move	2,1
	came	2,010
	 jrst	%L1109
	move	5,%L1105+1(7)
	movem	5,0(11)
	move	6,%L1105+2(7)
	movem	6,0(12)
	movei	1,1
	jrst	%L1106
%L1109:
	aos	1,0(17)
	jrst	%L1107
%L1108:
	setz	1,
%L1106:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

parse_owgbp_word:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[7,,7]
	move	1,-012(17)
	pushj	17,skipws
	movem	1,-012(17)
	movei	3,-5(17)
	movei	2,-6(17)
	move	4,-012(17)
	move	1,4
	pushj	17,split2
	jumpn	1,%L1110
	seto	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1110:
	move	1,-6(17)
	pushj	17,parse_octal_u
	movem	1,-4(17)
	movei	3,-2(17)
	movei	2,-3(17)
	move	4,-4(17)
	move	1,4
	pushj	17,owgbp_lookup
	jumpn	1,%L1111
	movei	1,013434
	pushj	17,das_native_diag
	seto	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1111:
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-5(17)
	move	2,[POINT 9,%L1113,8]
	move	3,-5(17)
	move	1,3
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L1112
	move	1,-5(17)
	ibp	1
	ibp	1
	ibp	1
	pushj	17,skipws
	movem	1,-5(17)
%L1112:
	push	17,-015(17)
	movei	1,-1(17)
	move	3,-014(17)
	move	2,-6(17)
	move	5,-012(17)
	move	4,1
	move	1,5
	pushj	17,eval_expr_octal
	SUB	17,[1,,1]
	jumpe	1,%L1114
	seto	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1114:
	move	2,-3(17)
	add	2,-2(17)
	subi	2,1
	movem	2,-1(17)
	movn	1,-1(17)
	addi	1,043
	lsh	1,036
	move	3,-3(17)
	lsh	3,030
	ior	1,3
	hrrz	4,0(17)
	ior	1,4
	pushj	17,das_mask36
	move	3,-014(17)
	movem	1,0(3)
	setz	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1113:
	.byte	9,0107,0111,0127,0
	


write_words_host:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[1,,1]
%L1116:
	skipn	1,012
	 jrst	%L1117
	move	1,011
	move	3,0(10)
	move	2,1
	move	1,3
	move	3,012
	pushj	17,dsys_write_words
	movem	1,0(17)
	skiple	3,1
	 jrst	%L1118
	seto	1,
	jrst	%L1115
%L1118:
	move	2,0(17)
	add	2,011
	move	11,2
	move	4,0(17)
	move	3,012
	sub	3,4
	move	12,3
	jrst	%L1116
%L1117:
	setz	1,
%L1115:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

output_seek_raw:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[1,,1]
	move	2,4(10)
	came	2,011
	 jrst	%L1120
	setz	1,
	jrst	%L1119
%L1120:
	movem	11,0(17)
	move	2,0(17)
	move	3,0(10)
	move	1,3
	setz	3,
	pushj	17,fseek
	jumpe	1,%L1121
	seto	1,
	jrst	%L1119
%L1121:
	movem	11,4(10)
	setz	1,
%L1119:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

output_flush:
	push	17,010
	move	10,1
	move	2,7(1)
	jumpn	2,%L1123
	setm	1,2
	jrst	%L1122
%L1123:
	move	2,6(10)
	move	1,010
	pushj	17,output_seek_raw
	jumpe	1,%L1124
	seto	1,
	jrst	%L1122
%L1124:
	move	2,7(10)
	move	3,5(10)
	move	4,0(10)
	move	1,4
	move	6,3
	move	3,2
	move	2,6
	pushj	17,write_words_host
	jumpe	1,%L1125
	seto	1,
	jrst	%L1122
%L1125:
	move	2,6(10)
	move	3,7(10)
	add	2,3
	movem	2,4(10)
	setz	1,
	movem	1,7(10)
	setm	1,1
%L1122:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

output_queue:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	skipn	2,7(10)
	 jrst	%L1127
	move	1,011
	move	4,6(10)
	move	5,7(10)
	sub	1,5
	came	1,4
	 jrst	%L1128
	move	6,7(10)
	tlc	6,0400000
	camge	6,[0400000000100]
	 jrst	%L1127
%L1128:
	move	1,010
	pushj	17,output_flush
	jumpe	1,%L1127
	seto	1,
	jrst	%L1126
%L1127:
	skipn	2,7(10)
	 skipa	1,011
	 trna	
	 movem	1,6(10)
	move	3,012
	tlz	3,01777777777000000
	aos	4,7(10)
	subi	4,1
	move	6,5(10)
	add	4,6
	movem	3,0(4)
	setz	1,
%L1126:
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	popj	17,

output_emit:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	push	17,013
	move	13,4
	move	1,011
	tlc	1,0400000
	move	3,3(10)
	tlc	3,0400000
	camge	1,3
	 jrst	%L1131
	seto	1,
	jrst	%L1130
%L1131:
	move	2,011
	addi	2,2
	move	3,012
	move	1,010
	pushj	17,output_queue
	jumpe	1,%L1132
	seto	1,
	jrst	%L1130
%L1132:
	skipn	1,013
	 jrst	%L1133
	move	2,1(10)
	move	1,2
	move	2,011
	pushj	17,das_bitmap_set
%L1133:
	setz	1,
%L1130:
	MOVEI	0,010
	HRLI	0,-3(17)
	BLT	0,013
	SUB	17,[4,,4]
	popj	17,

output_read_word:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,011
	addi	1,2
	movem	1,-1(17)
	skipn	4,7(10)
	 jrst	%L1136
	move	5,1
	tlc	5,0400000
	move	6,6(10)
	tlc	6,0400000
	camge	5,6
	 jrst	%L1136
	move	7,-1(17)
	tlc	7,0400000
	move	1,6(10)
	move	2,7(10)
	add	1,2
	tlc	1,0400000
	camge	7,1
	 jrst	%L1135
%L1136:
	seto	1,
	jrst	%L1134
%L1135:
	move	2,-1(17)
	move	3,6(10)
	sub	2,3
	add	2,5(10)
	move	1,0(2)
	tlz	1,01777777777000000
	movem	1,0(12)
	setz	1,
%L1134:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

output_replace_word:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,011
	addi	1,2
	movem	1,-1(17)
	skipn	4,7(10)
	 jrst	%L1139
	move	5,1
	tlc	5,0400000
	move	6,6(10)
	tlc	6,0400000
	camge	5,6
	 jrst	%L1139
	move	7,-1(17)
	tlc	7,0400000
	move	1,6(10)
	move	2,7(10)
	add	1,2
	tlc	1,0400000
	camge	7,1
	 jrst	%L1138
%L1139:
	seto	1,
	jrst	%L1137
%L1138:
	move	2,-1(17)
	move	3,6(10)
	sub	2,3
	move	1,012
	tlz	1,01777777777000000
	add	2,5(10)
	movem	1,0(2)
	setz	1,
%L1137:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

output_replace_word_reloc:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	push	17,013
	move	13,4
	move	1,010
	move	2,011
	move	3,012
	pushj	17,output_replace_word
	jumpe	1,%L1141
	seto	1,
	jrst	%L1140
%L1141:
	skipn	1,013
	 jrst	%L1143
	move	2,1(10)
	move	1,2
	move	2,011
	pushj	17,das_bitmap_set
	jrst	%L1142
%L1143:
	move	2,1(10)
	move	1,2
	move	2,011
	pushj	17,das_bitmap_clear
%L1142:
	setz	1,
%L1140:
	MOVEI	0,010
	HRLI	0,-3(17)
	BLT	0,013
	SUB	17,[4,,4]
	popj	17,

output_reopcode:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	move	1,011
	addi	1,2
	movem	1,-1(17)
	skipn	4,7(10)
	 jrst	%L1146
	move	5,1
	tlc	5,0400000
	move	6,6(10)
	tlc	6,0400000
	camge	5,6
	 jrst	%L1146
	move	7,-1(17)
	tlc	7,0400000
	move	1,6(10)
	move	2,7(10)
	add	1,2
	tlc	1,0400000
	camge	7,1
	 jrst	%L1145
%L1146:
	seto	1,
	jrst	%L1144
%L1145:
	move	2,-1(17)
	move	3,6(10)
	sub	2,3
	movem	2,0(17)
	add	2,5(10)
	move	5,0(2)
	tlz	5,01777777777777000
	move	1,012
	andi	1,0777
	lsh	1,033
	ior	5,1
	move	7,5(10)
	add	7,0(17)
	movem	5,0(7)
	setz	1,
%L1144:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	SUB	17,[6,,6]
	popj	17,

output_emit_zeros:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
%L1148:
	move	1,012
	jumpe	1,%L1149
	move	1,010
	move	2,011
	setz	3,
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1150
	seto	1,
	jrst	%L1147
%L1150:
	addi	11,1
	soja	12,%L1148
%L1149:
	setz	1,
%L1147:
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	popj	17,

output_begin:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[2,,2]
	skipe	1,-3(17)
	 hrli	1,0331100
	setz	2,
	movei	3,040
	pushj	17,memset
	move	2,-4(17)
	move	3,-3(17)
	movem	2,0(3)
	move	4,-010(17)
	move	5,-3(17)
	movem	4,1(5)
	move	6,-011(17)
	move	7,-3(17)
	movem	6,2(7)
	move	2,-6(17)
	move	3,-3(17)
	movem	2,3(3)
	movei	1,das_native_output_buffer
	move	3,-3(17)
	movem	1,5(3)
	hrrz	2,-5(17)
	tlo	2,0447062
	movem	2,-1(17)
	hrlz	2,-6(17)
	hrrz	3,-7(17)
	ior	2,3
	movem	2,0(17)
	movei	2,-1(17)
	move	3,-4(17)
	move	1,3
	movei	3,2
	pushj	17,write_words_host
	jumpe	1,%L1151
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1151:
	movei	1,2
	move	3,-3(17)
	movem	1,4(3)
	setz	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

output_finish:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,output_flush
	jumpe	1,%L1153
	seto	1,
	jrst	%L1152
%L1153:
	move	2,3(10)
	addi	2,2
	move	1,010
	pushj	17,output_seek_raw
	jumpe	1,%L1154
	seto	1,
	jrst	%L1152
%L1154:
	move	2,2(10)
	move	3,1(10)
	move	4,0(10)
	move	1,4
	move	6,3
	move	3,2
	move	2,6
	pushj	17,write_words_host
	jumpe	1,%L1155
	seto	1,
	jrst	%L1152
%L1155:
	move	2,2(10)
	move	3,4(10)
	add	3,2
	movem	3,4(10)
	setz	1,
%L1152:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

emit_byte_directive:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[011,,011]
	setz	1,
	movem	1,-5(17)
	setm	2,1
	movem	2,-4(17)
	setz	3,
	movem	3,-3(17)
	movei	1,-6(17)
	push	17,1
	movei	2,-011(17)
	move	4,-015(17)
	move	5,-014(17)
	move	1,-013(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,byte_begin
	SUB	17,[1,,1]
	jumpe	1,%L1156
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1156:
%L1157:
	move	1,-010(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L1158
	move	1,-010(17)
	pushj	17,skipws
	movem	1,-010(17)
	ldb	2,1
	caie	2,054
	 jrst	%L1159
	ibp	-010(17)
	move	3,-010(17)
	jrst	%L1157
%L1159:
	movei	4,-6(17)
	move	3,-014(17)
	add	3,-4(17)
	movei	2,-010(17)
	move	5,-012(17)
	move	1,5
	pushj	17,byte_size_prefix
	jumpe	1,%L1160
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1160:
	move	1,-010(17)
	pushj	17,byte_field_end
	movem	1,-7(17)
	camn	1,-010(17)
	 jrst	%L1158
	ldb	2,1
	jumpe	2,%L1161
	setz	3,
	move	5,1
	ibp	-7(17)
	dpb	3,5
%L1161:
	move	1,-010(17)
	pushj	17,rtrim
	movei	1,0(17)
	push	17,1
	movei	2,-3(17)
	move	4,-015(17)
	add	4,-5(17)
	move	5,-011(17)
	move	1,-013(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpe	1,%L1162
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1162:
	skipn	2,0(17)
	 jrst	%L1163
	movei	1,014671
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1163:
	move	2,-5(17)
	add	2,-6(17)
	caig	2,044
	 jrst	%L1164
	move	3,-4(17)
	tlc	3,0400000
	move	4,-016(17)
	tlc	4,0400000
	caml	3,4
	 jrst	%L1166
	move	2,-3(17)
	move	3,-014(17)
	add	3,-4(17)
	move	1,-015(17)
	move	6,3
	move	3,2
	move	2,6
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1165
%L1166:
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1165:
	aos	1,-4(17)
	setz	2,
	movem	2,-3(17)
	setm	3,2
	movem	3,-5(17)
%L1164:
	move	2,-6(17)
	caie	2,044
	 jrst	%L1167
	move	1,[0777777777777]
	jrst	%L1168
%L1167:
	movei	1,1
	move	3,-6(17)
	lsh	1,0(3)
	subi	1,1
%L1168:
	movem	1,-1(17)
	and	1,-2(17)
	move	5,1
	movn	4,-5(17)
	addi	4,044
	sub	4,-6(17)
	lsh	5,0(4)
	iorb	5,-3(17)
	move	6,-6(17)
	addb	6,-5(17)
	caie	6,044
	 jrst	%L1169
	move	3,-4(17)
	tlc	3,0400000
	move	7,-016(17)
	tlc	7,0400000
	caml	3,7
	 jrst	%L1171
	move	2,-3(17)
	move	3,-014(17)
	add	3,-4(17)
	move	1,-015(17)
	move	6,3
	move	3,2
	move	2,6
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1170
%L1171:
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1170:
	aos	1,-4(17)
	setz	2,
	movem	2,-3(17)
	setm	3,2
	movem	3,-5(17)
%L1169:
	move	2,-7(17)
	movem	2,-010(17)
	jrst	%L1157
%L1158:
	skipe	2,-5(17)
	 jrst	%L1173
	skipe	3,-4(17)
	 jrst	%L1172
%L1173:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-016(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1174
	move	2,-3(17)
	move	3,-014(17)
	add	3,-4(17)
	move	1,-015(17)
	move	6,3
	move	3,2
	move	2,6
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1172
%L1174:
	seto	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1172:
	setz	1,
	SUB	17,[011,,011]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

emit_sixbit_directive:
	push	17,016
	ADD	17,[016,,016]
	MOVEI	0,-015(17)
	HRLI	0,010
	BLT	0,-012(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,010
	pushj	17,skipws
	movem	1,-011(17)
	ldb	2,1
	caie	2,056
	 jrst	%L1176
	ibp	-011(17)
	move	3,-011(17)
%L1176:
	move	2,[POINT 9,%L1178,8]
	move	3,-011(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L1177
	movei	1,6
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-011(17)
%L1177:
	movei	2,-6(17)
	move	3,-011(17)
	move	1,3
	pushj	17,delimited_text_len
	jumpe	1,%L1179
	seto	1,
	jrst	%L1175
%L1179:
	move	1,-011(17)
	ibp	1
	movem	1,-010(17)
	ldb	2,-011(17)
	move	3,-010(17)
	move	1,3
	pushj	17,strrchr
	movem	1,-7(17)
	skipg	3,-6(17)
	 skipa	2,[1]
	 trna	
	 movem	2,-6(17)
	setz	4,
	movem	4,-4(17)
%L1181:
	move	2,-4(17)
	tlc	2,0400000
	move	1,013
	tlc	1,0400000
	caml	2,1
	 jrst	%L1182
	setz	3,
	movem	3,-3(17)
	setm	4,3
	movem	4,-5(17)
%L1184:
	move	2,-4(17)
	muli	2,6
	trne	2,1
	 tloa	3,0400000
	 tlz	3,0400000
	add	3,-5(17)
	movem	3,-2(17)
	setz	1,
	movem	1,-1(17)
	caml	3,-6(17)
	 jrst	%L1187
	move	6,3
	PUSH	17,1
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	4,6
	dpb	4,[POINT 9,0(17),35]
	ldb	1,[POINT 9,0(17),35]
	cail	1,0141
	 caile	1,0172
	 jrst	%L1188
	subi	1,040
	move	7,1
	andi	7,0777
	dpb	7,[POINT 9,0(17),35]
%L1188:
	ldb	2,[POINT 9,0(17),35]
	cail	2,040
	 caile	2,0137
	 jrst	%L1187
	subi	2,040
	movem	2,-1(17)
%L1187:
	move	2,-3(17)
	lsh	2,6
	move	3,-1(17)
	andi	3,077
	ior	2,3
	movem	2,-3(17)
	aos	5,-5(17)
	caige	5,6
	 jrst	%L1184
	move	3,-3(17)
	move	1,011
	add	1,-4(17)
	move	2,1
	move	1,012
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1189
	seto	1,
	jrst	%L1175
%L1189:
	aos	1,-4(17)
	jrst	%L1181
%L1182:
	setz	1,
%L1175:
	MOVEI	0,010
	HRLI	0,-015(17)
	BLT	0,013
	move	16,-016(17)
	SUB	17,[017,,017]
	popj	17,
%L1178:
	.byte	9,0123,0111,0130,0102
	.byte	9,0111,0124,0
	


emit_ascii_directive:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[012,,012]
	setz	1,
	movem	1,-3(17)
	setm	2,1
	movem	2,-2(17)
	setz	3,
	movem	3,-1(17)
	move	1,-014(17)
	pushj	17,skipws
	movem	1,-011(17)
	ldb	2,1
	caie	2,056
	 jrst	%L1190
	ibp	-011(17)
	move	3,-011(17)
%L1190:
	move	2,[POINT 9,%L1193,8]
	move	3,-011(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L1192
	movei	1,5
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-011(17)
	jrst	%L1191
%L1192:
	move	2,[POINT 9,%L1194,8]
	move	3,-011(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L1191
	movei	1,5
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-011(17)
%L1191:
	movei	2,-6(17)
	move	3,-011(17)
	move	1,3
	pushj	17,delimited_text_len
	jumpe	1,%L1195
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1195:
	move	1,-011(17)
	ibp	1
	movem	1,-010(17)
	ldb	2,-011(17)
	move	3,-010(17)
	move	1,3
	pushj	17,strrchr
	movem	1,-7(17)
	skipn	3,-020(17)
	 jrst	%L1196
	movei	1,1
	jrst	%L1197
%L1196:
	setz	1,
%L1197:
	add	1,-6(17)
	movem	1,-4(17)
	skipg	3,1
	 skipa	2,[1]
	 trna	
	 movem	2,-4(17)
	setz	4,
	movem	4,-5(17)
%L1199:
	move	3,-5(17)
	caml	3,-4(17)
	 jrst	%L1200
	setzb	1,0(17)
	caml	3,-6(17)
	 jrst	%L1202
	PUSH	17,1
	move	16,-011(17)
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	2,3
	movem	2,0(17)
%L1202:
	move	2,-3(17)
	caig	2,035
	 jrst	%L1203
	move	3,-2(17)
	tlc	3,0400000
	move	4,-017(17)
	tlc	4,0400000
	caml	3,4
	 jrst	%L1205
	move	2,-1(17)
	move	3,-015(17)
	add	3,-2(17)
	move	1,-016(17)
	move	6,3
	move	3,2
	move	2,6
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1204
%L1205:
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1204:
	aos	1,-2(17)
	setz	2,
	movem	2,-1(17)
	setm	3,2
	movem	3,-3(17)
%L1203:
	move	4,0(17)
	andi	4,0177
	movn	3,-3(17)
	lsh	4,035(3)
	iorb	4,-1(17)
	movei	1,7
	addb	1,-3(17)
	aos	2,-5(17)
	jrst	%L1199
%L1200:
	move	2,-2(17)
	tlc	2,0400000
	move	3,-017(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1207
	move	2,-1(17)
	move	3,-015(17)
	add	3,-2(17)
	move	1,-016(17)
	move	6,3
	move	3,2
	move	2,6
	setz	4,
	pushj	17,output_emit
	jumpe	1,%L1206
%L1207:
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1206:
	setz	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1194:
	.byte	9,0101,0123,0103,0111
	.byte	9,0111,0
	

%L1193:
	.byte	9,0101,0123,0103,0111
	.byte	9,0132,0
	


parse_instruction_word:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[025,,025]
	setz	1,
	movem	1,-010(17)
	setm	2,1
	movem	2,-3(17)
	move	1,-030(17)
	pushj	17,skipws
	movem	1,-014(17)
	ldb	1,-014(17)
	pushj	17,isname0
	jumpn	1,%L1208
	setm	1,1
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1208:
%L1209:
	ldb	1,-014(17)
	jumpe	1,%L1210
	ldb	1,-014(17)
	pushj	17,das_native_is_space
	jumpn	1,%L1210
	move	3,-010(17)
	cail	3,037
	 jrst	%L1211
	ldb	2,-014(17)
	aos	4,-010(17)
	PUSH	17,1
	MOVEI	16,-026(17)
	HRLI	16,01100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	2,4
%L1211:
	ibp	-014(17)
	move	1,-014(17)
	jrst	%L1209
%L1210:
	setz	1,
	move	4,-010(17)
	PUSH	17,1
	MOVEI	16,-025(17)
	HRLI	16,0331100
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	move	1,-014(17)
	pushj	17,skipws
	movem	1,-013(17)
	ldb	2,1
	jumpn	2,%L1212
	setm	1,2
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1212:
	ldb	2,[POINT 9,-024(17),8]
	caie	2,056
	 jrst	%L1213
	movei	1,-024(17)
	hrli	1,0331100
	pushj	17,strlen
	movei	3,-024(17)
	hrli	3,0221100
	movei	6,-024(17)
	hrli	6,0331100
	move	2,3
	move	3,1
	move	1,6
	pushj	17,memmove
%L1213:
	movei	1,-024(17)
	hrli	1,0331100
	setz	2,
	pushj	17,lookup_op
	movem	1,-7(17)
	skipl	3,1
	 jrst	%L1215
	movei	1,-3(17)
	movei	2,-1(17)
	movei	6,-024(17)
	hrli	6,0331100
	move	3,1
	move	1,6
	pushj	17,lookup_fixed_ac_alias
	jumpe	1,%L1217
	move	3,-1(17)
	movem	3,-7(17)
	move	4,-013(17)
	movem	4,-011(17)
	jrst	%L1216
%L1217:
	movei	1,-024(17)
	hrli	1,0331100
	pushj	17,lookup_io
	movem	1,0(17)
	skipl	3,1
	 jrst	%L1218
	setz	1,
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1218:
	movei	3,-011(17)
	movei	2,-012(17)
	move	4,-013(17)
	move	1,4
	pushj	17,split2
	jumpn	1,%L1219
	move	2,[POINT 9,%L1220,8]
	movem	2,-012(17)
	move	4,-013(17)
	movem	4,-011(17)
%L1219:
	movei	1,-4(17)
	push	17,1
	movei	2,-6(17)
	push	17,2
	movei	3,-010(17)
	push	17,3
	movei	4,-5(17)
	move	6,-034(17)
	move	2,-014(17)
	move	1,-032(17)
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1221
	seto	1,
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1221:
	push	17,-2(17)
	push	17,-1(17)
	push	17,-010(17)
	push	17,-010(17)
	move	1,-016(17)
	pushj	17,parse_octal_u
	move	2,-2(17)
	move	3,-1(17)
	pop	17,4
	SUB	17,[2,,2]
	pushj	17,das_enc_io
	SUB	17,[1,,1]
	move	3,-032(17)
	movem	1,0(3)
	move	4,-4(17)
	move	5,-033(17)
	movem	4,0(5)
	movei	1,1
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1216:
	jrst	%L1214
%L1215:
	movei	1,-024(17)
	hrli	1,0331100
	pushj	17,sixbit_mn
	came	1,[010011424]
	 jrst	%L1222
	movei	2,4
	movem	2,-3(17)
	move	4,-013(17)
	movem	4,-011(17)
	jrst	%L1214
%L1222:
	movei	3,-011(17)
	movei	2,-012(17)
	move	4,-013(17)
	move	1,4
	pushj	17,split2
	jumpn	1,%L1223
	move	2,[POINT 9,%L1224,8]
	movem	2,-012(17)
	move	4,-013(17)
	movem	4,-011(17)
%L1223:
	move	1,-012(17)
	pushj	17,parse_octal_u
	movem	1,-3(17)
%L1214:
	movei	1,-4(17)
	push	17,1
	movei	2,-6(17)
	push	17,2
	movei	3,-010(17)
	push	17,3
	movei	4,-5(17)
	move	6,-034(17)
	move	2,-014(17)
	move	1,-032(17)
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1225
	seto	1,
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1225:
	push	17,-2(17)
	move	2,-6(17)
	move	3,-7(17)
	move	4,-4(17)
	move	1,-010(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	move	3,-032(17)
	movem	1,0(3)
	move	4,-4(17)
	move	5,-033(17)
	movem	4,0(5)
	movei	1,1
	move	16,-025(17)
	SUB	17,[026,,026]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1224:
	.byte	9,060,0
	

%L1220:
	.byte	9,060,0
	


parse_data_word_radix:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[011,,011]
	move	1,-014(17)
	pushj	17,skipws
	movem	1,-010(17)
	ldb	2,1
	caie	2,056
	 jrst	%L1226
	ibp	-010(17)
	move	3,-010(17)
%L1226:
	move	2,[POINT 9,%L1228,8]
	move	3,-010(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L1227
	move	1,-010(17)
	movei	2,057
	pushj	17,strchr
	movem	1,-6(17)
	jumpn	1,%L1229
	seto	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1229:
	move	1,-6(17)
	ibp	1
	movei	2,057
	pushj	17,strrchr
	movem	1,-5(17)
	jumpe	1,%L1230
	setz	2,
	dpb	2,1
%L1230:
	move	1,-6(17)
	ibp	1
	pushj	17,sixbit_ascii
	move	3,-016(17)
	movem	1,0(3)
	move	5,-017(17)
	setzb	2,0(5)
	setm	1,2
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1227:
	move	2,[POINT 9,%L1233,8]
	move	3,-010(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L1232
	movei	1,4
	move	16,-010(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-010(17)
	jrst	%L1231
%L1232:
	move	2,[POINT 9,%L1235,8]
	move	3,-010(17)
	move	1,3
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L1234
	move	1,-010(17)
	ibp	1
	ibp	1
	ibp	1
	pushj	17,skipws
	movem	1,-010(17)
	jrst	%L1231
%L1234:
	move	2,[POINT 9,%L1236,8]
	move	3,-010(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L1231
	movei	1,4
	move	16,-010(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-010(17)
%L1231:
	move	2,[POINT 9,%L1238,8]
	move	3,-010(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L1237
	push	17,-017(17)
	push	17,-016(17)
	push	17,-020(17)
	movei	1,5
	move	16,-013(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	move	6,-016(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_point_word
	SUB	17,[1,,1]
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1237:
	move	2,[POINT 9,%L1240,8]
	move	3,-010(17)
	move	1,3
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L1239
	push	17,-017(17)
	push	17,-016(17)
	push	17,-020(17)
	move	1,-013(17)
	ibp	1
	ibp	1
	ibp	1
	pushj	17,skipws
	move	6,-016(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_giw_word
	SUB	17,[1,,1]
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1239:
	move	2,[POINT 9,%L1242,8]
	move	3,-010(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L1241
	push	17,-017(17)
	push	17,-016(17)
	push	17,-020(17)
	movei	1,5
	move	16,-013(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	move	6,-016(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_owgbp_word
	SUB	17,[1,,1]
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1241:
	move	2,[POINT 9,%L1244,8]
	move	3,-010(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L1243
	push	17,-017(17)
	push	17,-016(17)
	push	17,-020(17)
	movei	1,6
	move	16,-013(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	move	6,-016(17)
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_exind_word
	SUB	17,[1,,1]
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1243:
	push	17,-017(17)
	move	2,-017(17)
	move	3,-016(17)
	move	4,-011(17)
	move	1,-014(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,parse_instruction_word
	SUB	17,[1,,1]
	movem	1,-7(17)
	jumpe	1,%L1245
	skipl	3,1
	 jrst	%L1246
	seto	2,
	move	1,2
	jrst	%L1247
%L1246:
	setz	1,
%L1247:
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1245:
	move	2,[POINT 9,%L1249,8]
	move	3,-010(17)
	move	1,3
	pushj	17,strstr
	jumpe	1,%L1248
	move	2,[POINT 9,%L1250,8]
	move	3,-010(17)
	move	1,3
	pushj	17,strstr
	movem	1,-4(17)
	setz	2,
	dpb	2,1
	move	3,-4(17)
	ibp	3
	ibp	3
	movem	3,-4(17)
	movei	1,-1(17)
	push	17,1
	movei	2,-4(17)
	push	17,2
	move	4,-022(17)
	move	5,-017(17)
	move	6,-012(17)
	move	1,-015(17)
	move	2,6
	move	3,5
	pushj	17,eval_expr_radix
	SUB	17,[2,,2]
	jumpe	1,%L1251
	seto	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1251:
	movei	1,0(17)
	push	17,1
	movei	2,-3(17)
	push	17,2
	move	4,-022(17)
	move	5,-017(17)
	move	6,-6(17)
	move	1,-015(17)
	move	2,6
	move	3,5
	pushj	17,eval_expr_radix
	SUB	17,[2,,2]
	jumpe	1,%L1252
	seto	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1252:
	skipn	2,-1(17)
	 jrst	%L1253
	move	1,[POINT 9,%L1254,8]
	pushj	17,das_native_diag
	seto	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1253:
	hrlz	2,-3(17)
	hrrz	3,-2(17)
	ior	2,3
	move	4,-016(17)
	movem	2,0(4)
	skipe	5,-1(17)
	 jrst	%L1257
	skipn	6,0(17)
	 jrst	%L1255
%L1257:
	movei	1,1
	jrst	%L1256
%L1255:
	setz	1,
%L1256:
	move	3,-017(17)
	movem	1,0(3)
	setz	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1248:
	push	17,-017(17)
	push	17,-017(17)
	move	2,-022(17)
	move	3,-017(17)
	move	4,-012(17)
	move	1,-015(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,eval_expr_radix
	SUB	17,[2,,2]
	jumpe	1,%L1258
	seto	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1258:
	move	2,-017(17)
	skipn	1,0(2)
	 jrst	%L1259
	ldb	3,-010(17)
	caie	3,056
	 jrst	%L1260
	move	4,-010(17)
	ildb	5,4
	jumpn	5,%L1260
	movei	1,015300
	pushj	17,das_native_diag
	seto	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1260:
	movei	1,1
	move	3,-017(17)
	movem	1,0(3)
%L1259:
	setz	1,
	move	16,-011(17)
	SUB	17,[012,,012]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1254:
	.byte	9,0144,0141,0163,072
	.byte	9,040,0154,0145,0146
	.byte	9,0164,055,0150,0141
	.byte	9,0154,0146,040,0162
	.byte	9,0145,0154,0157,0143
	.byte	9,0141,0164,0151,0157
	.byte	9,0156,040,0151,0163
	.byte	9,040,0165,0156,0163
	.byte	9,0165,0160,0160,0157
	.byte	9,0162,0164,0145,0144
	.byte	9,012,0
	

%L1250:
	.byte	9,054,054,0
	

%L1249:
	.byte	9,054,054,0
	

%L1244:
	.byte	9,045,0105,0130,0111
	.byte	9,0116,0104,0
	

%L1242:
	.byte	9,0117,0127,0107,0102
	.byte	9,0120,0
	

%L1240:
	.byte	9,0107,0111,0127,0
	

%L1238:
	.byte	9,0120,0117,0111,0116
	.byte	9,0124,0
	

%L1236:
	.byte	9,0114,0117,0116,0107
	.byte	9,0
	

%L1235:
	.byte	9,0105,0130,0120,0
	

%L1233:
	.byte	9,0127,0117,0122,0104
	.byte	9,0
	

%L1228:
	.byte	9,0123,0111,0130,0102
	.byte	9,0111,0124,0
	


parse_data_word:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,[012]
	push	17,-6(17)
	move	2,-6(17)
	move	3,-5(17)
	move	4,-4(17)
	move	1,-3(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,parse_data_word_radix
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

emit_long_directive:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[6,,6]
	move	1,-011(17)
	pushj	17,long_values
	movem	1,-5(17)
	setz	2,
	movem	2,-3(17)
%L1261:
	move	1,-5(17)
	pushj	17,long_field_end
	movem	1,-4(17)
	jumpn	1,%L1263
	seto	1,
	move	16,-6(17)
	SUB	17,[7,,7]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1263:
	ldb	1,-4(17)
	caie	1,0
	 tdza	2,2
	 movei	2,1
	movem	2,-2(17)
	jumpn	2,%L1266
	setm	3,2
	dpb	3,-4(17)
%L1266:
	move	1,-5(17)
	pushj	17,rtrim
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-5(17)
	ldb	2,1
	jumpe	2,%L1268
	move	4,-3(17)
	tlc	4,0400000
	move	5,-014(17)
	tlc	5,0400000
	camge	4,5
	 jrst	%L1267
%L1268:
	seto	1,
	move	16,-6(17)
	SUB	17,[7,,7]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1267:
	movei	1,0(17)
	push	17,1
	movei	2,-2(17)
	move	4,-013(17)
	add	4,-4(17)
	move	5,-6(17)
	move	1,-011(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,parse_data_word
	SUB	17,[1,,1]
	jumpn	1,%L1270
	move	2,0(17)
	move	3,-1(17)
	move	4,-012(17)
	add	4,-3(17)
	move	1,-013(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	jumpe	1,%L1269
%L1270:
	seto	1,
	move	16,-6(17)
	SUB	17,[7,,7]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1269:
	aos	1,-3(17)
	skipe	3,-2(17)
	 jrst	%L1262
	move	2,-4(17)
	ibp	2
	movem	2,-5(17)
	jrst	%L1261
%L1262:
	move	2,-3(17)
	came	2,-014(17)
	 jrst	%L1271
	setz	1,
	jrst	%L1272
%L1271:
	seto	1,
%L1272:
	move	16,-6(17)
	SUB	17,[7,,7]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

pass2_stmt:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[045,,045]
	move	2,-050(17)
	move	1,-047(17)
	pushj	17,sec_base
	add	1,-051(17)
	movem	1,-041(17)
	move	3,-050(17)
	caie	3,3
	 jrst	%L1273
	setz	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1273:
	movei	3,-037(17)
	movei	2,-040(17)
	move	4,-052(17)
	move	1,4
	pushj	17,opt_move_literal_immediate
	jumpe	1,%L1274
	push	17,-037(17)
	move	2,-041(17)
	movei	1,0201
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	move	2,-041(17)
	move	4,-054(17)
	move	3,1
	move	1,4
	setz	4,
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1274:
	move	2,-052(17)
	move	1,016(2)
	cail	1,011
	 cail	1,030
	 jrst	%L1275
	jrst	@%L1284-011(1)
%L1284:
	setz	%L1276
	setz	%L1277
	setz	%L1277
	setz	%L1275
	setz	%L1275
	setz	%L1278
	setz	%L1279
	setz	%L1280
	setz	%L1281
	setz	%L1283
	setz	%L1283
	setz	%L1282
	setz	%L1283
	setz	%L1283
	setz	%L1283
%L1276:
	movei	1,015411
	pushj	17,das_native_diag
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1277:
	move	2,-053(17)
	move	3,-041(17)
	move	1,-054(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,output_emit_zeros
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1278:
	push	17,-053(17)
	move	3,-042(17)
	move	4,-053(17)
	move	1,2(4)
	move	6,-050(17)
	move	4,-055(17)
	move	2,1
	move	1,6
	pushj	17,emit_byte_directive
	SUB	17,[1,,1]
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1279:
	push	17,[0]
	move	2,-054(17)
	move	3,-055(17)
	move	6,-042(17)
	move	5,-053(17)
	move	1,2(5)
	move	4,2
	move	2,6
	pushj	17,emit_ascii_directive
	SUB	17,[1,,1]
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1280:
	push	17,[1]
	move	2,-054(17)
	move	3,-055(17)
	move	6,-042(17)
	move	5,-053(17)
	move	1,2(5)
	move	4,2
	move	2,6
	pushj	17,emit_ascii_directive
	SUB	17,[1,,1]
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1281:
	move	2,-053(17)
	move	3,-054(17)
	move	6,-041(17)
	move	5,-052(17)
	move	1,2(5)
	move	4,2
	move	2,6
	pushj	17,emit_sixbit_directive
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1282:
	push	17,-053(17)
	move	3,-042(17)
	move	4,-053(17)
	move	1,2(4)
	move	6,-050(17)
	move	4,-055(17)
	move	2,1
	move	1,6
	pushj	17,emit_long_directive
	SUB	17,[1,,1]
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1283:
	movei	1,-035(17)
	push	17,1
	movei	2,-037(17)
	move	4,-042(17)
	move	5,-053(17)
	move	3,2(5)
	move	1,-050(17)
	move	6,3
	move	3,4
	move	4,2
	move	2,6
	pushj	17,parse_data_word
	SUB	17,[1,,1]
	jumpe	1,%L1285
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1285:
	move	2,-035(17)
	move	3,-036(17)
	move	4,-041(17)
	move	1,-054(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1275:
	move	1,-052(17)
	addi	1,4
	hrli	1,0331100
	pushj	17,looks_octal_token
	jumpn	1,%L1287
	move	1,-052(17)
	pushj	17,looks_symbolic_data_expr
	jumpe	1,%L1286
%L1287:
	movei	1,-033(17)
	push	17,1
	movei	2,-035(17)
	move	4,-042(17)
	move	5,-053(17)
	move	3,2(5)
	move	1,-050(17)
	move	6,3
	move	3,4
	move	4,2
	move	2,6
	pushj	17,parse_data_word
	SUB	17,[1,,1]
	jumpe	1,%L1288
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1288:
	move	2,-033(17)
	move	3,-034(17)
	move	4,-041(17)
	move	1,-054(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1286:
	move	2,[POINT 9,%L1290,8]
	move	3,-052(17)
	addi	3,4
	hrli	3,0331100
	move	1,3
	pushj	17,streqi
	jumpe	1,%L1289
	movei	1,-043(17)
	movei	2,-044(17)
	move	4,-052(17)
	move	6,3(4)
	move	3,1
	move	1,6
	pushj	17,split2
	jumpn	1,%L1291
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1291:
	movei	1,-032(17)
	push	17,1
	move	3,-042(17)
	move	4,-045(17)
	move	1,-050(17)
	move	2,4
	movei	4,077
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	jumpe	1,%L1292
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1292:
	movei	1,-026(17)
	push	17,1
	movei	2,-030(17)
	push	17,2
	movei	3,-032(17)
	push	17,3
	movei	4,-034(17)
	move	6,-044(17)
	move	2,-046(17)
	move	1,-052(17)
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1293
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1293:
	push	17,-031(17)
	move	2,-030(17)
	move	3,-031(17)
	move	1,-033(17)
	move	4,2
	setz	2,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-025(17)
	move	2,-026(17)
	move	3,-025(17)
	move	4,-041(17)
	move	1,-054(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1289:
	movei	2,-024(17)
	move	3,-052(17)
	addi	3,4
	hrli	3,0331100
	move	1,3
	pushj	17,lookup_op
	movem	1,-042(17)
	skipl	3,1
	 skipn	4,das_strict_base
	 jrst	%L1294
	skipn	5,-024(17)
	 jrst	%L1294
	movei	1,015511
	pushj	17,das_native_diag
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1294:
	skipl	2,-042(17)
	 jrst	%L1295
	movei	3,-022(17)
	movei	2,-023(17)
	move	4,-052(17)
	addi	4,4
	hrli	4,0331100
	move	1,4
	pushj	17,lookup_fixed_ac_alias
	jumpe	1,%L1297
	movei	1,-016(17)
	push	17,1
	movei	2,-020(17)
	push	17,2
	movei	3,-022(17)
	push	17,3
	movei	4,-024(17)
	move	6,-044(17)
	move	7,-055(17)
	move	5,3(7)
	move	1,-052(17)
	move	2,5
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1298
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1298:
	push	17,-021(17)
	move	2,-020(17)
	move	3,-021(17)
	move	4,-023(17)
	move	1,-024(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-015(17)
	move	2,-016(17)
	move	3,-015(17)
	move	4,-041(17)
	move	1,-054(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1297:
	move	1,-052(17)
	addi	1,4
	hrli	1,0331100
	pushj	17,lookup_io
	movem	1,-014(17)
	skipl	3,1
	 jrst	%L1299
	move	4,-052(17)
	skipn	2,030(4)
	 jrst	%L1301
	movei	1,015542
	pushj	17,das_native_diag
	jrst	%L1300
%L1301:
	movei	1,015544
	pushj	17,das_native_diag
%L1300:
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1299:
	skipe	2,das_strict_base
	 skipe	3,das_kernel_mode
	 jrst	%L1302
	movei	1,015550
	pushj	17,das_native_diag
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1302:
	movei	1,-043(17)
	movei	2,-044(17)
	move	4,-052(17)
	move	6,3(4)
	move	3,1
	move	1,6
	pushj	17,split2
	jumpn	1,%L1303
	move	2,[POINT 9,%L1304,8]
	movem	2,-044(17)
	move	4,-052(17)
	move	3,3(4)
	movem	3,-043(17)
%L1303:
	move	1,-044(17)
	pushj	17,parse_octal_u
	movem	1,-013(17)
	movei	1,-7(17)
	push	17,1
	movei	2,-011(17)
	push	17,2
	movei	3,-013(17)
	push	17,3
	movei	4,-015(17)
	move	6,-044(17)
	move	2,-046(17)
	move	1,-052(17)
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1305
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1305:
	push	17,-012(17)
	move	2,-011(17)
	move	3,-012(17)
	move	4,-015(17)
	move	1,-014(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,das_enc_io
	SUB	17,[1,,1]
	movem	1,-6(17)
	move	2,-7(17)
	move	3,-6(17)
	move	4,-041(17)
	move	1,-054(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1295:
	move	1,-052(17)
	addi	1,4
	hrli	1,0331100
	pushj	17,sixbit_mn
	came	1,[010011424]
	 jrst	%L1307
	move	2,[POINT 9,%L1308,8]
	movem	2,-044(17)
	move	4,-052(17)
	move	3,3(4)
	movem	3,-043(17)
	jrst	%L1306
%L1307:
	movei	1,-043(17)
	movei	2,-044(17)
	move	4,-052(17)
	move	6,3(4)
	move	3,1
	move	1,6
	pushj	17,split2
	jumpn	1,%L1306
	move	2,[POINT 9,%L1309,8]
	movem	2,-044(17)
	move	4,-052(17)
	move	3,3(4)
	movem	3,-043(17)
%L1306:
	move	1,-044(17)
	pushj	17,parse_octal_u
	movem	1,-5(17)
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	push	17,2
	movei	3,-5(17)
	push	17,3
	movei	4,-7(17)
	move	6,-044(17)
	move	2,-046(17)
	move	1,-052(17)
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1310
	seto	1,
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1310:
	push	17,-4(17)
	move	2,-3(17)
	move	3,-4(17)
	move	4,-6(17)
	move	1,-043(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,0(17)
	move	2,-1(17)
	move	3,0(17)
	move	4,-041(17)
	move	1,-054(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	move	16,-045(17)
	SUB	17,[046,,046]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1309:
	.byte	9,060,0
	

%L1308:
	.byte	9,064,0
	

%L1304:
	.byte	9,060,0
	

%L1290:
	.byte	9,0125,0125,0117,0
	


fill_literals:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[0110,,0110]
	move	1,010
	pushj	17,text_total
	move	3,01000(10)
	sub	1,3
	movem	1,-0106(17)
	setz	2,
	movem	2,-0105(17)
	move	1,010
	pushj	17,lit_stream_reset
	setz	1,
	movem	1,-0107(17)
%L1312:
	move	2,-0107(17)
	tlc	2,0400000
	move	3,0776(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1313
	movei	2,-0104(17)
	hrli	2,0331100
	move	1,010
	movei	3,0400
	pushj	17,lit_read_next
	jumpe	1,%L1315
	movei	1,015646
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1311
%L1315:
	movei	1,-0104(17)
	hrli	1,0331100
	pushj	17,strlen
	movei	6,-0104(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,literal_image_words
	movem	1,-1(17)
	move	3,-0106(17)
	add	3,-0105(17)
	movem	3,-2(17)
	caie	1,2
	 jrst	%L1317
	movei	1,-0104(17)
	hrli	1,0331100
	movei	2,054
	pushj	17,strchr
	movem	1,0(17)
	jumpn	1,%L1318
	movei	1,015660
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1311
%L1318:
	setz	1,
	dpb	1,0(17)
	push	17,[010]
	movei	1,-4(17)
	push	17,1
	movei	2,-6(17)
	move	4,-4(17)
	movei	3,-0106(17)
	hrli	3,0331100
	move	1,010
	move	6,3
	move	3,4
	move	4,2
	move	2,6
	pushj	17,parse_data_word_radix
	SUB	17,[2,,2]
	jumpn	1,%L1320
	move	2,-3(17)
	move	3,-4(17)
	move	4,-2(17)
	move	1,011
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	jumpe	1,%L1319
%L1320:
	movei	1,015666
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1311
%L1319:
	push	17,[010]
	movei	1,-4(17)
	push	17,1
	movei	2,-6(17)
	move	4,-4(17)
	addi	4,1
	push	17,4
	push	17,2
	move	1,-4(17)
	ibp	1
	pushj	17,skipws
	move	2,-1(17)
	pop	17,4
	SUB	17,[1,,1]
	move	3,2
	move	2,1
	move	1,010
	pushj	17,parse_data_word_radix
	SUB	17,[2,,2]
	jumpn	1,%L1322
	move	2,-3(17)
	move	3,-4(17)
	move	4,-2(17)
	addi	4,1
	move	1,011
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	jumpe	1,%L1321
%L1322:
	movei	1,015675
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1311
%L1321:
	jrst	%L1316
%L1317:
	push	17,[010]
	movei	1,-4(17)
	push	17,1
	movei	2,-6(17)
	move	4,-4(17)
	movei	3,-0106(17)
	hrli	3,0331100
	move	1,010
	move	6,3
	move	3,4
	move	4,2
	move	2,6
	pushj	17,parse_data_word_radix
	SUB	17,[2,,2]
	jumpe	1,%L1323
	movei	1,015702
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1311
%L1323:
	move	2,-3(17)
	move	3,-4(17)
	move	4,-2(17)
	move	1,011
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	jumpe	1,%L1316
	movei	1,015706
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1311
%L1316:
	move	2,-1(17)
	addb	2,-0105(17)
	aos	1,-0107(17)
	jrst	%L1312
%L1313:
	setz	1,
%L1311:
	move	10,-0111(17)
	move	11,-0110(17)
	move	16,-0112(17)
	SUB	17,[0113,,0113]
	popj	17,

phase_get_word:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,010
	skipe	1,1
	 hrli	1,0331100
	move	2,011
	pushj	17,host_word_get
	sojn	1,%L1325
	setm	1,1
	jrst	%L1326
%L1325:
	seto	1,
%L1326:
%L1324:
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	popj	17,

phase_get_header:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	movei	2,-1(17)
	move	1,010
	pushj	17,phase_get_word
	jumpe	1,%L1328
	seto	1,
	jrst	%L1327
%L1328:
	move	3,-1(17)
	lsh	3,-036
	movem	3,0(17)
	camn	3,011
	 jrst	%L1329
	seto	1,
	jrst	%L1327
%L1329:
	move	2,-1(17)
	tlz	2,01777777777770000
	movem	2,0(12)
	setz	1,
%L1327:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

phase_import_state:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[044,,044]
	movei	1,das_native_output_buffer
	movem	1,-010(17)
	movei	2,-7(17)
	move	1,011
	pushj	17,phase_get_word
	jumpn	1,%L1332
	move	3,-7(17)
	came	3,[0444163516222]
	 jrst	%L1332
	movei	3,-6(17)
	move	1,011
	movei	2,4
	pushj	17,phase_get_header
	jumpn	1,%L1332
	move	3,-6(17)
	cain	3,016
	 jrst	%L1331
%L1332:
	seto	1,
	jrst	%L1330
%L1331:
	setz	1,
	movem	1,-4(17)
	movei	2,-043(17)
%L1333:
	push	17,2
	pop	17,2
	move	1,011
	pushj	17,phase_get_word
	ADD	17,[1,,1]
	jumpe	1,%L1335
	seto	1,
	jrst	%L1330
%L1335:
	aos	4,-5(17)
	addi	2,1
	tlc	4,0400000
	camge	4,[0400000000016]
	 jrst	%L1333
	move	7,-044(17)
	movem	7,-6(17)
	trnn	7,1
	 tdza	1,1
	 movei	1,1
	movem	1,das_optimize
	trnn	7,2
	 tdza	3,3
	 movei	3,1
	movem	3,das_strict_base
	trnn	7,4
	 tdza	5,5
	 movei	5,1
	movem	5,das_kernel_mode
	move	6,-043(17)
	movem	6,01141(10)
	move	1,-042(17)
	movem	1,01135(10)
	move	1,-041(17)
	movem	1,01136(10)
	move	1,-040(17)
	movem	1,01137(10)
	move	1,-037(17)
	move	2,010
	addi	2,01135
	movei	3,3
	add	3,2
	movem	1,0(3)
	move	1,-035(17)
	movem	1,0776(10)
	move	1,-034(17)
	movem	1,0777(10)
	move	1,-033(17)
	movem	1,01000(10)
	move	1,-032(17)
	movem	1,01143(10)
	movei	1,-044(17)
	movei	2,013
	add	2,1
	move	1,0(2)
	movem	1,01144(10)
	move	1,-030(17)
	movem	1,01145(10)
	hlrz	1,-027(17)
	movem	1,0740(10)
	hrrz	1,-027(17)
	movem	1,0741(10)
	movei	3,-7(17)
	move	1,011
	movei	2,5
	pushj	17,phase_get_header
	jumpn	1,%L1343
	move	3,-7(17)
	camn	3,-036(17)
	 jrst	%L1342
%L1343:
	seto	1,
	jrst	%L1330
%L1342:
	setz	1,
	movem	1,-5(17)
%L1344:
	move	2,-5(17)
	tlc	2,0400000
	move	3,-7(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1345
	setz	1,
	movem	1,-4(17)
	movei	4,-026(17)
%L1347:
	push	17,4
	pop	17,2
	move	1,011
	pushj	17,phase_get_word
	ADD	17,[1,,1]
	jumpe	1,%L1349
	seto	1,
	jrst	%L1330
%L1349:
	aos	4,-5(17)
	addi	2,1
	tlc	4,0400000
	camge	4,[0400000000015]
	 jrst	%L1347
	move	1,-026(17)
	andi	1,0377
	movem	1,-3(17)
	move	5,-6(17)
	addi	5,1
	movem	5,-2(17)
	hrrz	6,-027(17)
	add	1,010
	came	6,0(1)
	 jrst	%L1351
	movei	1,-027(17)
	move	6,010
	addi	6,0703
	move	2,1
	move	1,6
	movei	3,015
	pushj	17,wordfile_append
	jumpe	1,%L1350
%L1351:
	seto	1,
	jrst	%L1330
%L1350:
	move	2,-2(17)
	move	4,010
	add	4,-3(17)
	movem	2,0(4)
	aos	1,-6(17)
	jrst	%L1344
%L1345:
	move	2,-010(17)
	movem	2,0737(10)
	movei	3,-010(17)
	move	1,011
	movei	2,6
	pushj	17,phase_get_header
	jumpn	1,%L1353
	move	3,-010(17)
	move	4,0777(10)
	camn	3,4
	 jrst	%L1352
%L1353:
	seto	1,
	jrst	%L1330
%L1352:
%L1354:
	skipn	3,-010(17)
	 jrst	%L1355
	tlc	3,0400000
	camg	3,[0400000000040]
	 jrst	%L1356
	movei	1,040
	jrst	%L1357
%L1356:
	move	1,-010(17)
%L1357:
	movem	1,-4(17)
	setz	2,
	movem	2,-6(17)
%L1358:
	move	2,-6(17)
	tlc	2,0400000
	move	3,-4(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1359
	move	2,-6(17)
	add	2,-012(17)
	move	1,011
	pushj	17,phase_get_word
	jumpe	1,%L1360
	seto	1,
	jrst	%L1330
%L1360:
	aos	1,-6(17)
	jrst	%L1358
%L1359:
	move	2,-4(17)
	move	6,-012(17)
	move	1,010
	addi	1,0742
	move	3,2
	move	2,6
	pushj	17,wordfile_append
	jumpe	1,%L1361
	seto	1,
	jrst	%L1330
%L1361:
	movn	3,-4(17)
	addb	3,-010(17)
	jrst	%L1354
%L1355:
	move	1,011
	move	3,012
	movei	2,7
	pushj	17,phase_get_header
	jumpe	1,%L1362
	seto	1,
	jrst	%L1330
%L1362:
	setz	1,
%L1330:
	move	10,-050(17)
	move	11,-047(17)
	move	12,-046(17)
	SUB	17,[051,,051]
	popj	17,

opt_store_forward_emitted:
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipe	2,das_optimize
	 skipn	3,01210(10)
	 jrst	%L1365
	move	4,01214(10)
	movei	1,1
	camn	4,1
	 skipe	6,0(11)
	 jrst	%L1365
	skipe	7,016(11)
	 jrst	%L1365
	move	1,017(11)
	move	5,[015172605]
	camn	1,5
	 jrst	%L1364
%L1365:
	setz	1,
	jrst	%L1363
%L1364:
	movei	1,-2(17)
	move	2,013
	move	3,1
	move	1,012
	pushj	17,output_read_word
	jumpe	1,%L1366
	setz	1,
	jrst	%L1363
%L1366:
	move	2,1(12)
	move	1,2
	move	2,013
	pushj	17,das_bitmap_get
	movem	1,0(17)
	move	3,-2(17)
	tlz	3,01777777777777740
	move	4,01212(10)
	came	3,4
	 jrst	%L1368
	move	5,1
	move	6,01213(10)
	camn	5,6
	 skipn	2,013
	 jrst	%L1368
	move	1,013
	subi	1,1
	move	3,1(12)
	move	2,1
	move	1,3
	pushj	17,das_bitmap_get
	push	17,1
	move	2,1(12)
	move	1,2
	move	2,013
	pushj	17,das_bitmap_get
	pop	17,2
	camn	2,1
	 jrst	%L1367
%L1368:
	setz	1,
	jrst	%L1363
%L1367:
	move	2,-2(17)
	lsh	2,-027
	andi	2,017
	movem	2,-1(17)
	move	2,01211(10)
	push	17,2
	move	2,-2(17)
	movei	1,0200
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-2(17)
	move	2,-2(17)
	move	1,012
	move	3,2
	move	2,013
	setz	4,
	pushj	17,output_replace_word_reloc
	jumpe	1,%L1369
	seto	1,
	jrst	%L1363
%L1369:
	movei	1,1
%L1363:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	SUB	17,[7,,7]
	popj	17,

opt_record_store_word:
	ADD	17,[5,,5]
	MOVEI	0,-4(17)
	HRLI	0,010
	BLT	0,-1(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	setz	1,
	movem	1,01210(10)
	skipn	3,das_optimize
	 jrst	%L1372
	move	4,01214(10)
	movei	2,2
	came	4,2
	 jrst	%L1372
	move	6,0(11)
	setm	5,1
	came	6,5
	 jrst	%L1372
	move	1,016(11)
	jumpn	1,%L1372
	move	1,017(11)
	camn	1,[01517260515]
	 jrst	%L1371
%L1372:
	jrst	%L1370
%L1371:
	movei	1,0(17)
	move	2,013
	move	3,1
	move	1,012
	pushj	17,output_read_word
	jumpn	1,%L1370
	movei	2,1
	movem	2,01210(10)
	move	4,0(17)
	lsh	4,-027
	andi	4,017
	movem	4,01211(10)
	move	5,0(17)
	tlz	5,01777777777777740
	movem	5,01212(10)
	move	2,1(12)
	move	1,2
	move	2,013
	pushj	17,das_bitmap_get
	movem	1,01213(10)
%L1370:
	MOVEI	0,010
	HRLI	0,-4(17)
	BLT	0,013
	SUB	17,[5,,5]
	popj	17,

pass2_emit_pending_jump_jrst:
	push	17,016
	ADD	17,[013,,013]
	MOVEI	0,-012(17)
	HRLI	0,010
	BLT	0,-7(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipn	2,das_optimize
	 jrst	%L1376
	move	3,01214(10)
	movei	1,5
	camn	3,1
	 jrst	%L1375
%L1376:
	setz	1,
	jrst	%L1374
%L1375:
	move	1,010
	addi	1,01216
	hrli	1,0331100
	movei	2,050
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	2,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	2,0(17)
	SUB	17,[2,,2]
	POP	17,1
	movem	2,-6(17)
	move	2,0(11)
	move	1,010
	pushj	17,sec_base
	move	3,0(11)
	add	3,012
	add	1,0(3)
	movem	1,-4(17)
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	push	17,2
	movei	3,-5(17)
	push	17,3
	movei	4,-010(17)
	move	6,-7(17)
	move	7,-011(17)
	move	1,010
	move	2,7
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1377
	seto	1,
	jrst	%L1374
%L1377:
	push	17,-5(17)
	move	4,-3(17)
	move	3,-4(17)
	movei	1,0254
	setz	2,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,0(17)
	move	2,-1(17)
	move	3,0(17)
	move	4,-4(17)
	move	1,013
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	jumpe	1,%L1378
	seto	1,
	jrst	%L1374
%L1378:
	move	3,0(11)
	add	3,012
	aos	1,0(3)
	move	1,010
	pushj	17,opt_reset
	setz	1,
%L1374:
	MOVEI	0,010
	HRLI	0,-012(17)
	BLT	0,013
	move	16,-013(17)
	SUB	17,[014,,014]
	popj	17,

pass2_fold_jump_jrst:
	push	17,016
	ADD	17,[016,,016]
	MOVEI	0,-015(17)
	HRLI	0,010
	BLT	0,-012(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipn	2,das_optimize
	 jrst	%L1381
	move	3,01214(10)
	movei	1,5
	came	3,1
	 jrst	%L1381
	move	5,0(11)
	add	5,012
	skipe	6,0(5)
	 jrst	%L1380
%L1381:
	seto	1,
	jrst	%L1379
%L1380:
	move	2,010
	addi	2,01230
	hrli	2,0331100
	movem	2,-011(17)
	move	5,01215(10)
	movem	5,-010(17)
	lsh	5,-4
	andi	5,0777
	movem	5,-7(17)
	move	3,-010(17)
	andi	3,017
	movem	3,-6(17)
	tlc	5,0400000
	camge	5,[0400000000321]
	 jrst	%L1383
	move	4,-7(17)
	tlc	4,0400000
	camle	4,[0400000000327]
	 jrst	%L1383
	move	6,-7(17)
	caie	6,0324
	 jrst	%L1382
%L1383:
	seto	1,
	jrst	%L1379
%L1382:
	move	2,0(11)
	move	1,010
	pushj	17,sec_base
	move	3,0(11)
	add	3,012
	add	1,0(3)
	subi	1,1
	movem	1,-4(17)
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	push	17,2
	movei	3,-5(17)
	push	17,3
	movei	4,-010(17)
	move	6,-7(17)
	move	7,-014(17)
	move	1,010
	move	2,7
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1384
	seto	1,
	jrst	%L1379
%L1384:
	skipe	2,-3(17)
	 jrst	%L1386
	skipn	3,-2(17)
	 jrst	%L1385
%L1386:
	seto	1,
	jrst	%L1379
%L1385:
	push	17,-5(17)
	move	2,-7(17)
	move	1,-010(17)
	xori	1,4
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,0(17)
	move	2,-1(17)
	move	3,0(17)
	move	4,-4(17)
	move	1,013
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_replace_word_reloc
	jumpe	1,%L1387
	seto	1,
	jrst	%L1379
%L1387:
	move	1,010
	pushj	17,opt_reset
	setz	1,
%L1379:
	MOVEI	0,010
	HRLI	0,-015(17)
	BLT	0,013
	move	16,-016(17)
	SUB	17,[017,,017]
	popj	17,

pass2_emit_pending_jrst:
	ADD	17,[012,,012]
	MOVEI	0,-011(17)
	HRLI	0,010
	BLT	0,-6(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipn	2,das_optimize
	 jrst	%L1390
	move	3,01214(10)
	movei	1,3
	camn	3,1
	 jrst	%L1389
%L1390:
	setz	1,
	jrst	%L1388
%L1389:
	move	2,0(11)
	move	1,010
	pushj	17,sec_base
	move	3,0(11)
	add	3,012
	add	1,0(3)
	movem	1,-4(17)
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	push	17,2
	movei	3,-5(17)
	push	17,3
	movei	4,-010(17)
	move	6,-7(17)
	move	5,010
	addi	5,01216
	hrli	5,0331100
	move	1,010
	move	2,5
	move	3,6
	pushj	17,parse_ea
	SUB	17,[3,,3]
	jumpe	1,%L1391
	seto	1,
	jrst	%L1388
%L1391:
	push	17,-5(17)
	move	4,-3(17)
	move	3,-4(17)
	movei	1,0254
	setz	2,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,0(17)
	move	2,-1(17)
	move	3,0(17)
	move	4,-4(17)
	move	1,013
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_emit
	jumpe	1,%L1392
	seto	1,
	jrst	%L1388
%L1392:
	move	3,0(11)
	add	3,012
	aos	1,0(3)
	move	1,010
	pushj	17,opt_reset
	setz	1,
%L1388:
	MOVEI	0,010
	HRLI	0,-011(17)
	BLT	0,013
	SUB	17,[012,,012]
	popj	17,

pass2_line:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[0115,,0115]
	movei	1,-0114(17)
	move	2,-0120(17)
	move	4,-0117(17)
	move	3,1
	move	1,4
	pushj	17,parse_line_head
	jumpn	1,%L1393
	setm	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1393:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_jump_jrst_next_label
	jumpe	1,%L1395
	move	2,-0123(17)
	move	3,-0122(17)
	move	4,-0121(17)
	move	1,-0117(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_fold_jump_jrst
	jumpe	1,%L1394
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1395:
	skipn	2,das_optimize
	 jrst	%L1394
	move	3,-0117(17)
	move	1,01214(3)
	caie	1,5
	 jrst	%L1394
	move	2,-0123(17)
	move	3,-0122(17)
	move	4,-0121(17)
	move	1,-0117(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_emit_pending_jump_jrst
	jumpe	1,%L1394
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1394:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_jrst_next_label
	jumpe	1,%L1397
	move	1,-0117(17)
	pushj	17,opt_reset
	jrst	%L1396
%L1397:
	skipn	2,das_optimize
	 jrst	%L1396
	move	3,-0117(17)
	move	1,01214(3)
	caie	1,3
	 jrst	%L1396
	move	2,-0123(17)
	move	3,-0122(17)
	move	4,-0121(17)
	move	1,-0117(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_emit_pending_jrst
	jumpe	1,%L1396
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1396:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_begin_line
	move	2,-0117(17)
	skipe	1,01322(2)
	 jrst	%L1398
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_jump_jrst_transition
	jumpe	1,%L1398
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1398:
	move	2,-0117(17)
	skipe	1,01322(2)
	 jrst	%L1399
	move	4,-0114(17)
	setm	3,1
	camn	4,3
	 skipn	6,das_optimize
	 jrst	%L1399
	move	2,-0117(17)
	addi	2,01216
	hrli	2,0331100
	movei	1,-0114(17)
	movei	3,0400
	pushj	17,opt_direct_jrst_symbol
	jumpe	1,%L1399
	move	1,-0117(17)
	pushj	17,opt_reset
	movei	1,3
	move	3,-0117(17)
	movem	1,01214(3)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1399:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_finish_pending_push
	jumpe	1,%L1400
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	move	4,0(2)
	tlc	4,0400000
	caml	4,[0400000000002]
	 jrst	%L1401
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1401:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	add	1,0(2)
	subi	1,2
	movem	1,-056(17)
	aos	5,1
	movem	5,-055(17)
	movei	1,-061(17)
	move	2,-056(17)
	move	4,-0123(17)
	move	3,1
	move	1,4
	pushj	17,output_read_word
	jumpe	1,%L1402
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1402:
	move	2,-0117(17)
	move	1,01207(2)
	movei	3,3
	came	1,3
	 jrst	%L1404
	movei	4,0201
	movem	4,-053(17)
	jrst	%L1403
%L1404:
	move	2,-0117(17)
	move	1,01207(2)
	caie	1,4
	 jrst	%L1405
	movei	3,0414
	movem	3,-053(17)
	jrst	%L1403
%L1405:
	movei	1,0200
	movem	1,-053(17)
%L1403:
	move	2,-061(17)
	lsh	2,-033
	came	2,-053(17)
	 jrst	%L1407
	move	3,-061(17)
	lsh	3,-027
	andi	3,017
	move	4,-0117(17)
	camn	3,01205(4)
	 jrst	%L1406
%L1407:
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1406:
	move	2,-061(17)
	tlz	2,0740
	move	3,-0117(17)
	move	1,01206(3)
	lsh	1,027
	ior	2,1
	movem	2,-057(17)
	move	2,-057(17)
	move	3,-056(17)
	move	1,-0123(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,output_replace_word
	jumpe	1,%L1408
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1408:
	movei	1,-054(17)
	push	17,1
	movei	2,-061(17)
	move	4,-056(17)
	move	5,-0113(17)
	move	1,-0120(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,parse_instruction_word
	SUB	17,[1,,1]
	jumpg	1,%L1409
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1409:
	move	2,-054(17)
	move	3,-060(17)
	move	4,-055(17)
	move	1,-0123(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_replace_word_reloc
	jumpe	1,%L1410
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1410:
	move	1,-0117(17)
	pushj	17,opt_reset
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_record_prev
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1400:
	movei	3,-052(17)
	movei	2,-0114(17)
	move	4,-0117(17)
	move	1,4
	pushj	17,opt_overwrite_prev
	jumpe	1,%L1411
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1412
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1412:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	add	1,0(2)
	subi	1,1
	movem	1,-047(17)
	movei	1,-050(17)
	push	17,1
	movei	2,-052(17)
	move	4,-050(17)
	move	5,-0113(17)
	move	1,-0120(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,parse_instruction_word
	SUB	17,[1,,1]
	jumpg	1,%L1413
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1413:
	move	2,-050(17)
	move	3,-051(17)
	move	4,-047(17)
	move	1,-0123(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,output_replace_word_reloc
	jumpe	1,%L1414
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1414:
	move	3,-0117(17)
	setzb	1,01210(3)
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_record_prev
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1411:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_redundant_mem_pair
	jumpe	1,%L1415
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1415:
	movei	3,-046(17)
	movei	2,-0114(17)
	move	4,-0117(17)
	move	1,4
	pushj	17,opt_move_unary_fold
	jumpe	1,%L1416
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1417
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1417:
	push	17,-046(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_reopcode
	jumpe	1,%L1418
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1418:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1416:
	movei	3,-045(17)
	movei	2,-0114(17)
	move	4,-0117(17)
	move	1,4
	pushj	17,opt_move_skip_fold
	jumpe	1,%L1419
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1420
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1420:
	push	17,-045(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_reopcode
	jumpe	1,%L1421
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1421:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1419:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_lshr_andi_redundant
	jumpe	1,%L1422
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1422:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_movei_hrrz_redundant
	jumpe	1,%L1423
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1423:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_zero_store
	jumpe	1,%L1424
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1425
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1425:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	add	1,0(2)
	movem	1,-042(17)
	movei	1,-043(17)
	push	17,1
	movei	2,-045(17)
	move	4,-043(17)
	move	5,-0113(17)
	move	1,-0120(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,parse_instruction_word
	SUB	17,[1,,1]
	jumpg	1,%L1426
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1426:
	move	2,-044(17)
	tlz	2,01777777777777000
	tlo	2,0403000
	movem	2,-044(17)
	push	17,-044(17)
	push	17,-044(17)
	move	2,-0123(17)
	move	2,0(2)
	move	4,-0121(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0123(17)
	move	2,0(3)
	add	2,-0124(17)
	add	1,0(2)
	sos	2,1
	move	5,-0125(17)
	move	4,-1(17)
	pop	17,6
	SUB	17,[1,,1]
	move	3,4
	move	4,6
	move	1,5
	pushj	17,output_replace_word_reloc
	jumpe	1,%L1427
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1427:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1424:
	movei	3,-041(17)
	movei	2,-0114(17)
	move	4,-0117(17)
	move	1,4
	pushj	17,opt_zero_move_pair
	jumpe	1,%L1428
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1429
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1429:
	push	17,-041(17)
	move	2,-0120(17)
	move	2,01172(2)
	movei	1,0403
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-040(17)
	push	17,-040(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_replace_word
	jumpe	1,%L1430
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1430:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1428:
	movei	3,-037(17)
	movei	2,-0114(17)
	move	4,-0117(17)
	move	1,4
	pushj	17,opt_zero_pair
	jumpe	1,%L1431
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1432
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1432:
	push	17,-037(17)
	move	2,-0120(17)
	move	2,01172(2)
	movei	1,0403
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-036(17)
	push	17,-036(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_replace_word
	jumpe	1,%L1433
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1433:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1431:
	movei	4,-034(17)
	movei	2,-035(17)
	movei	3,-0114(17)
	move	5,-0117(17)
	move	1,5
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_immediate_fold
	jumpe	1,%L1434
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1435
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1435:
	push	17,-034(17)
	move	2,-036(17)
	movei	1,0201
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-033(17)
	push	17,-033(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_replace_word
	jumpe	1,%L1436
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1436:
	move	2,-034(17)
	move	3,-035(17)
	move	1,-0117(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_set_prev_immediate
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1434:
	movei	4,-031(17)
	movei	2,-032(17)
	movei	3,-0114(17)
	move	5,-0117(17)
	move	1,5
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_movei_right_shift_fold
	jumpe	1,%L1437
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1438
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1438:
	push	17,-031(17)
	move	2,-033(17)
	movei	1,0201
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-030(17)
	push	17,-030(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_replace_word
	jumpe	1,%L1439
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1439:
	move	2,-031(17)
	move	3,-032(17)
	move	1,-0117(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_set_prev_immediate
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1437:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_movei_test_nonskip
	jumpe	1,%L1440
	movni	2,2
	move	4,-0117(17)
	andb	2,01321(4)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1440:
	movei	3,-027(17)
	movei	2,-0114(17)
	move	4,-0117(17)
	move	1,4
	pushj	17,opt_movei_movn_fold
	jumpe	1,%L1441
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1442
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1442:
	move	2,-0117(17)
	push	17,01175(2)
	move	2,-030(17)
	movei	1,0211
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-026(17)
	push	17,-026(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_replace_word
	jumpe	1,%L1443
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1443:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1441:
	movei	4,-024(17)
	movei	2,-025(17)
	movei	3,-0114(17)
	move	5,-0117(17)
	move	1,5
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_movei_unary_immediate_fold
	jumpe	1,%L1444
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	skipe	4,0(2)
	 jrst	%L1445
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1445:
	move	2,-0117(17)
	push	17,01175(2)
	move	3,-026(17)
	move	1,-025(17)
	move	2,3
	setz	3,
	setz	4,
	pushj	17,das_enc_mem
	SUB	17,[1,,1]
	movem	1,-023(17)
	push	17,-023(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_replace_word
	jumpe	1,%L1446
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1446:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1444:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_halfword_fold
	movem	1,-022(17)
	skipn	3,1
	 jrst	%L1447
	move	4,-0121(17)
	move	2,0(4)
	add	2,-0122(17)
	skipe	5,0(2)
	 jrst	%L1448
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1448:
	move	2,-022(17)
	sojn	2,%L1450
	movei	1,0554
	movem	1,-021(17)
	jrst	%L1449
%L1450:
	move	2,-022(17)
	caie	2,2
	 jrst	%L1451
	movei	1,0514
	movem	1,-021(17)
	jrst	%L1449
%L1451:
	movei	1,0550
	movem	1,-021(17)
%L1449:
	push	17,-021(17)
	move	2,-0122(17)
	move	2,0(2)
	move	4,-0120(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	add	1,0(2)
	sos	2,1
	move	5,-0124(17)
	pop	17,4
	move	3,4
	move	1,5
	pushj	17,output_reopcode
	jumpe	1,%L1452
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1452:
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1447:
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_drop_line
	jumpe	1,%L1453
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1453:
	skipe	2,-0112(17)
	 jrst	%L1454
	setm	1,2
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1454:
	skiple	2,-076(17)
	 cail	2,036
	 jrst	%L1455
	jrst	@%L1465-1(2)
%L1465:
	setz	%L1456
	setz	%L1457
	setz	%L1458
	setz	%L1459
	setz	%L1463
	setz	%L1463
	setz	%L1463
	setz	%L1463
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1464
	setz	%L1464
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1455
	setz	%L1462
	setz	%L1460
	setz	%L1460
	setz	%L1461
	setz	%L1463
	setz	%L1463
%L1456:
	movei	1,1
	move	3,-0121(17)
	movem	1,0(3)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1457:
	movei	1,2
	move	3,-0121(17)
	movem	1,0(3)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1458:
	movei	1,3
	move	3,-0121(17)
	movem	1,0(3)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1459:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0111(17)
	move	1,4
	pushj	17,psect_to_sec
	move	3,-0121(17)
	movem	1,0(3)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1460:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	add	1,0(2)
	movei	2,-0114(17)
	move	6,-0117(17)
	move	3,1
	move	1,6
	pushj	17,define_assignment
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1461:
	movei	1,-020(17)
	push	17,1
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	push	17,0(2)
	move	2,-0123(17)
	move	2,0(2)
	move	4,-0121(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0123(17)
	move	2,0(3)
	add	2,-0124(17)
	add	1,0(2)
	move	2,-0113(17)
	move	6,-0121(17)
	pop	17,4
	move	3,1
	move	1,6
	pushj	17,align_word_padding
	SUB	17,[1,,1]
	jumpe	1,%L1466
	movei	1,023573
	pushj	17,das_native_diag
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1466:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	5,-0121(17)
	move	2,0(5)
	add	2,-0122(17)
	add	1,0(2)
	movem	1,-017(17)
	move	3,0(5)
	caie	3,3
	 skipn	6,-020(17)
	 jrst	%L1467
	move	2,-020(17)
	move	3,-017(17)
	move	1,-0123(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,output_emit_zeros
	jumpe	1,%L1467
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1467:
	move	2,-020(17)
	move	3,-0121(17)
	move	1,0(3)
	add	1,-0122(17)
	addb	2,0(1)
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1462:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	add	1,0(2)
	movem	1,-015(17)
	movei	1,-016(17)
	push	17,1
	move	3,-0122(17)
	move	2,0(3)
	add	2,-0123(17)
	move	4,0(2)
	move	6,-016(17)
	move	2,-0112(17)
	move	1,-0120(17)
	move	3,6
	pushj	17,org_word_target
	SUB	17,[1,,1]
	jumpe	1,%L1468
	movei	1,023615
	pushj	17,das_native_diag
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1468:
	move	6,-016(17)
	move	5,-0121(17)
	move	1,0(5)
	add	1,-0122(17)
	sub	6,0(1)
	movem	6,-014(17)
	move	3,0(5)
	caie	3,3
	 cain	6,0
	 jrst	%L1469
	move	2,-014(17)
	move	3,-015(17)
	move	1,-0123(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,output_emit_zeros
	jumpe	1,%L1469
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1469:
	move	2,-016(17)
	move	3,-0121(17)
	move	1,0(3)
	add	1,-0122(17)
	movem	2,0(1)
	move	1,-0117(17)
	pushj	17,opt_reset
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1463:
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1464:
	movei	1,-1(17)
	movei	2,-013(17)
	hrli	2,0331100
	move	6,-0111(17)
	move	4,1
	move	1,6
	movei	3,050
	pushj	17,common_args
	jumpe	1,%L1470
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1470:
	move	2,-1(17)
	move	1,-0122(17)
	addb	2,3(1)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1455:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	move	3,-0121(17)
	move	2,0(3)
	add	2,-0122(17)
	add	1,0(2)
	movei	2,-0114(17)
	move	6,-0117(17)
	move	3,1
	move	1,6
	pushj	17,parsed_word_count
	movem	1,-063(17)
	skipl	3,1
	 jrst	%L1471
	movei	1,023660
	pushj	17,das_native_diag
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1471:
	move	2,-0121(17)
	move	1,0(2)
	add	1,-0122(17)
	move	3,0(1)
	movem	3,-062(17)
	movei	2,-0114(17)
	move	3,-0117(17)
	move	1,3
	pushj	17,opt_record_prev
	push	17,-0123(17)
	push	17,-064(17)
	move	3,-064(17)
	move	4,-0123(17)
	move	2,0(4)
	move	6,-0121(17)
	movei	4,-0116(17)
	move	1,6
	pushj	17,pass2_stmt
	SUB	17,[2,,2]
	jumpe	1,%L1472
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1472:
	move	2,-063(17)
	sojn	2,%L1473
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	add	1,-062(17)
	move	3,-0123(17)
	movei	2,-0114(17)
	move	5,-0117(17)
	move	4,1
	move	1,5
	pushj	17,opt_store_forward_emitted
	movem	1,0(17)
	skipl	3,1
	 jrst	%L1474
	movei	1,1
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1474:
%L1473:
	move	2,-0121(17)
	move	2,0(2)
	move	4,-0117(17)
	move	1,4
	pushj	17,sec_base
	add	1,-062(17)
	move	3,-0123(17)
	movei	2,-0114(17)
	move	5,-0117(17)
	move	4,1
	move	1,5
	pushj	17,opt_record_store_word
	move	4,-063(17)
	move	5,-0121(17)
	move	1,0(5)
	add	1,-0122(17)
	addb	4,0(1)
	setz	1,
	move	16,-0115(17)
	SUB	17,[0116,,0116]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

phase_read_line_record:
	ADD	17,[011,,011]
	MOVEI	0,-010(17)
	HRLI	0,010
	BLT	0,-5(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	skipn	2,0(11)
	 jrst	%L1477
	movei	2,-4(17)
	move	1,010
	pushj	17,phase_get_word
	jumpe	1,%L1476
%L1477:
	seto	1,
	jrst	%L1475
%L1476:
	sos	1,0(11)
	move	3,-4(17)
	lsh	3,-036
	movem	3,0(13)
	soje	3,%L1478
	setz	2,
	move	4,012
	dpb	2,4
	setz	1,
	jrst	%L1475
%L1478:
	hrrz	3,-4(17)
	movem	3,-3(17)
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L1479
	seto	1,
	jrst	%L1475
%L1479:
	move	3,-3(17)
	addi	3,3
	lsh	3,-2
	movem	3,-2(17)
	tlc	3,0400000
	move	2,0(11)
	tlc	2,0400000
	camg	3,2
	 jrst	%L1480
	seto	1,
	jrst	%L1475
%L1480:
	movei	1,das_native_phase_line
	movem	1,0(17)
	setz	2,
	movem	2,-1(17)
%L1481:
	move	2,-1(17)
	tlc	2,0400000
	move	3,-2(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1482
	move	3,0(17)
	add	3,-1(17)
	move	1,010
	move	2,3
	pushj	17,phase_get_word
	jumpe	1,%L1483
	seto	1,
	jrst	%L1475
%L1483:
	aos	1,-1(17)
	jrst	%L1481
%L1482:
	move	2,-2(17)
	move	3,0(11)
	sub	3,2
	movem	3,0(11)
	skipn	4,-2(17)
	 jrst	%L1485
	move	2,-3(17)
	move	3,0(17)
	move	1,012
	move	4,2
	movei	2,0400
	pushj	17,unpack_text_words
	jrst	%L1484
%L1485:
	setz	1,
	move	2,012
	dpb	1,2
%L1484:
	setz	1,
%L1475:
	MOVEI	0,010
	HRLI	0,-010(17)
	BLT	0,013
	SUB	17,[011,,011]
	popj	17,

pass2_phase_stream:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[2,,2]
	move	1,[POINT 9,das_native_line,8]
	movem	1,-1(17)
%L1486:
	skipn	2,-5(17)
	 jrst	%L1487
	movei	4,0(17)
	move	3,-1(17)
	movei	2,-5(17)
	move	5,-4(17)
	move	1,5
	pushj	17,phase_read_line_record
	jumpe	1,%L1488
	movei	1,024107
	pushj	17,das_native_diag
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1488:
	move	2,0(17)
	caie	2,2
	 jrst	%L1489
	move	2,-010(17)
	move	3,-7(17)
	move	4,-6(17)
	move	1,-3(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_emit_pending_jump_jrst
	jumpn	1,%L1491
	move	2,-010(17)
	move	3,-7(17)
	move	4,-6(17)
	move	1,-3(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_emit_pending_jrst
	jumpe	1,%L1490
%L1491:
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1490:
	move	1,-3(17)
	pushj	17,opt_reset
	jrst	%L1486
%L1489:
	move	2,0(17)
	caie	2,3
	 jrst	%L1492
	movei	1,1
	move	4,-3(17)
	iorb	1,01321(4)
	jrst	%L1486
%L1492:
	move	2,0(17)
	soje	2,%L1493
	movei	1,024132
	pushj	17,das_native_diag
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1493:
	push	17,-010(17)
	move	2,-010(17)
	move	3,-7(17)
	move	4,-2(17)
	move	1,-4(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_line
	SUB	17,[1,,1]
	jumpe	1,%L1494
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1494:
	jrst	%L1486
%L1487:
	move	2,-010(17)
	move	3,-7(17)
	move	4,-6(17)
	move	1,-3(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_emit_pending_jump_jrst
	jumpe	1,%L1495
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1495:
	move	2,-010(17)
	move	3,-7(17)
	move	4,-6(17)
	move	1,-3(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass2_emit_pending_jrst
	jumpe	1,%L1496
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1496:
	setz	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

assemble_phase2_stream:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[031,,031]
	movei	1,das_native_ctx
	movem	1,-027(17)
	skipe	1,-027(17)
	 hrli	1,0331100
	setz	2,
	movei	3,05600
	pushj	17,memset
	move	1,-027(17)
	move	2,011
	pushj	17,store_init_phase2
	jumpe	1,%L1498
	movei	1,024354
	pushj	17,das_native_die
%L1498:
	movei	1,-026(17)
	hrli	1,0331100
	setz	2,
	movei	3,020
	pushj	17,memset
	movem	10,-026(17)
	movei	2,das_native_phase_input
	movem	2,-025(17)
	movei	3,-2(17)
	movei	2,-026(17)
	move	4,-027(17)
	move	1,4
	pushj	17,phase_import_state
	jumpe	1,%L1499
	movei	1,024366
	pushj	17,das_native_diag
	move	1,-027(17)
	pushj	17,store_close
	movei	1,1
	jrst	%L1497
%L1499:
	move	1,-027(17)
	pushj	17,text_total
	move	6,-027(17)
	add	1,01137(6)
	movem	1,-010(17)
	addi	1,043
	move	4,1
	SKIPL	5,4
	 TDZA	4,4
	  MOVEI	4,1
	DIVI	4,44
	movem	4,-7(17)
	movem	4,01142(6)
	move	2,-7(17)
	move	1,-027(17)
	pushj	17,das_note_work
	move	2,-7(17)
	tlc	2,0400000
	camg	2,[0400000000653]
	 jrst	%L1500
	movei	1,024400
	pushj	17,das_native_die
%L1500:
	movei	1,das_native_relmap
	movem	1,0(17)
	move	2,-7(17)
	lsh	2,2
	skipe	1,0(17)
	 hrli	1,0331100
	move	3,2
	setz	2,
	pushj	17,memset
	move	2,[POINT 9,%L1501,8]
	move	1,011
	pushj	17,fopen
	movem	1,-030(17)
	jumpn	1,%L1502
	movei	1,024415
	pushj	17,das_native_diag
	move	1,-027(17)
	pushj	17,store_close
	movei	1,1
	jrst	%L1497
%L1502:
	push	17,-7(17)
	push	17,-1(17)
	move	4,-031(17)
	push	17,01140(4)
	move	1,01141(4)
	move	5,-033(17)
	movei	2,-025(17)
	move	4,-013(17)
	move	3,1
	move	1,2
	move	2,5
	pushj	17,output_begin
	SUB	17,[3,,3]
	movem	1,-011(17)
	skipn	3,1
	 jrst	%L1503
	movei	1,024427
	pushj	17,das_native_diag
	move	1,-030(17)
	pushj	17,fclose
	move	1,011
	pushj	17,remove
	move	1,-027(17)
	pushj	17,store_close
	movei	1,1
	jrst	%L1497
%L1503:
	movei	1,-6(17)
	hrli	1,0331100
	setz	2,
	movei	3,020
	pushj	17,memset
	movei	1,1
	movem	1,-012(17)
	move	4,-027(17)
	setzb	2,01336(4)
	setm	3,2
	move	6,-027(17)
	movem	3,01337(6)
	move	1,-027(17)
	pushj	17,opt_reset
	movei	1,-022(17)
	push	17,1
	movei	2,-7(17)
	push	17,2
	movei	3,-014(17)
	move	5,-4(17)
	movei	4,-030(17)
	move	1,-031(17)
	move	2,4
	move	4,3
	move	3,5
	pushj	17,pass2_phase_stream
	SUB	17,[2,,2]
	movem	1,-011(17)
	skipe	3,1
	 jrst	%L1504
	movei	3,-1(17)
	movei	2,-026(17)
	move	1,2
	movei	2,010
	pushj	17,phase_get_header
	skipn	3,-1(17)
	 jumpe	1,%L1504
	movei	1,024453
	pushj	17,das_native_diag
	movei	1,1
	movem	1,-011(17)
%L1504:
	skipe	2,-011(17)
	 jrst	%L1506
	movei	2,-022(17)
	move	3,-027(17)
	move	1,3
	pushj	17,fill_literals
	movem	1,-011(17)
%L1506:
	skipe	2,-011(17)
	 jrst	%L1507
	move	1,-5(17)
	move	3,-027(17)
	came	1,01136(3)
	 jrst	%L1508
	move	4,-4(17)
	came	4,01137(3)
	 jrst	%L1508
	move	5,-3(17)
	camn	5,01140(3)
	 jrst	%L1507
%L1508:
	movei	1,024465
	pushj	17,das_native_diag
	movei	1,1
	movem	1,-011(17)
%L1507:
	skipe	2,-011(17)
	 jrst	%L1509
	movei	1,-022(17)
	pushj	17,output_finish
	movem	1,-011(17)
	skipn	3,1
	 jrst	%L1509
	movei	1,024473
	pushj	17,das_native_diag
%L1509:
	move	1,-030(17)
	pushj	17,fclose
	jumpe	1,%L1510
	movei	1,024476
	pushj	17,das_native_diag
	movei	1,1
	movem	1,-011(17)
%L1510:
	skipn	2,-011(17)
	 jrst	%L1511
	move	1,011
	pushj	17,remove
%L1511:
	move	1,-027(17)
	pushj	17,store_close
	move	1,-011(17)
%L1497:
	move	10,-032(17)
	move	11,-031(17)
	move	16,-033(17)
	SUB	17,[034,,034]
	popj	17,
%L1501:
	.byte	9,0167,053,0142,0
	


assemble_phase2_file:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	move	2,[POINT 9,%L1513,8]
	move	1,010
	pushj	17,fopen
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L1514
	movei	1,024563
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1512
%L1514:
	move	1,-1(17)
	move	2,011
	pushj	17,assemble_phase2_stream
	movem	1,0(17)
	move	1,-1(17)
	pushj	17,fclose
	jumpe	1,%L1515
	movei	2,1
	movem	2,0(17)
%L1515:
	move	1,010
	pushj	17,remove
	move	1,0(17)
%L1512:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,
%L1513:
	.byte	9,0162,0142,0
	


das_counted_sixbit_arg_text:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[6,,6]
	skipe	1,010
	 skipn	2,011
	 jrst	%L1518
	skipe	3,012
	 jrst	%L1517
%L1518:
	movei	1,1
	jrst	%L1516
%L1517:
	hrrz	3,0(10)
	movem	3,-5(17)
	addi	3,1
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camg	3,1
	 jrst	%L1519
	movei	1,1
	jrst	%L1516
%L1519:
	setz	1,
	movem	1,-4(17)
%L1520:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-5(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1521
	move	4,-4(17)
	SKIPL	5,4
	 TDZA	4,4
	  MOVEI	4,1
	DIVI	4,6
	aos	6,4
	movem	6,-3(17)
	movem	5,-2(17)
	add	6,010
	move	2,0(6)
	movem	2,-1(17)
	move	3,5
	muli	3,6
	trne	3,1
	 tloa	4,0400000
	 tlz	4,0400000
	movn	4,4
	addi	4,036
	movn	4,4
	lsh	2,0(4)
	andi	2,077
	movem	2,0(17)
	movei	2,040
	addb	2,0(17)
	andi	2,0777
	move	1,-4(17)
	move	7,011
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	7,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	dpb	2,1
	aos	1,-4(17)
	jrst	%L1520
%L1521:
	setz	1,
	move	3,-5(17)
	move	2,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,3
	setz	1,
%L1516:
	move	10,-010(17)
	move	11,-7(17)
	move	12,-6(17)
	move	16,-011(17)
	SUB	17,[012,,012]
	popj	17,

das_native_main:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[0122,,0122]
	setz	1,
	pushj	17,dsys_close
	movei	1,1
	pushj	17,dsys_close
	skipge	1,010
	 jrst	%L1525
	move	2,010
	caig	2,020
	 skipa	3,011
	 trna	
	 jumpn	3,%L1524
%L1525:
	movei	1,1
	jrst	%L1523
%L1524:
	setz	1,
	movem	1,-3(17)
	setm	2,1
	movem	2,-2(17)
	movei	3,1
	movem	3,-1(17)
%L1526:
	move	2,-1(17)
	caml	2,010
	 jrst	%L1527
	movei	1,-035(17)
	hrli	1,0331100
	move	3,-1(17)
	add	3,011
	move	4,0(3)
	move	2,1
	move	1,4
	movei	3,0147
	pushj	17,das_counted_sixbit_arg_text
	jumpe	1,%L1529
	movei	1,1
	jrst	%L1523
%L1529:
	move	1,[POINT 9,%L1531,8]
	movei	6,-035(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,strcmp
	jumpn	1,%L1530
	aos	2,-1(17)
	caml	2,010
	 jrst	%L1533
	movei	1,-0121(17)
	hrli	1,0331100
	move	3,-1(17)
	add	3,011
	move	4,0(3)
	move	2,1
	move	1,4
	movei	3,0147
	pushj	17,das_counted_sixbit_arg_text
	jumpe	1,%L1532
%L1533:
	movei	1,1
	jrst	%L1523
%L1532:
	movei	1,1
	movem	1,-3(17)
	jrst	%L1528
%L1530:
	ldb	2,[POINT 9,-035(17),8]
	caie	2,055
	 jrst	%L1534
	movei	1,1
	jrst	%L1523
%L1534:
	movei	1,-035(17)
	hrli	1,0331100
	movei	6,-067(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,0147
	pushj	17,strcopy
	movei	1,1
	movem	1,-2(17)
%L1528:
	aos	1,-1(17)
	jrst	%L1526
%L1527:
	skipe	2,-3(17)
	 jrst	%L1535
	movei	1,1
	jrst	%L1523
%L1535:
	skipe	2,-2(17)
	 jrst	%L1536
	movei	1,-0121(17)
	hrli	1,0331100
	pushj	17,strlen
	movem	1,0(17)
	addi	1,4
	move	3,1
	tlc	3,0400000
	camg	3,[0400000000146]
	 jrst	%L1537
	movei	1,1
	jrst	%L1523
%L1537:
	movei	1,-0121(17)
	hrli	1,0331100
	movei	6,-067(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,0147
	pushj	17,strcopy
	movn	2,0(17)
	addi	2,0147
	move	1,[POINT 9,%L1538,8]
	movei	3,-067(17)
	hrli	3,0331100
	move	5,0(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	5,-1(17)
	MOVEM	3,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	5,0(17)
	SUB	17,[2,,2]
	POP	17,1
	move	3,2
	move	2,1
	move	1,5
	pushj	17,strcopy
	movei	1,1
	movem	1,-2(17)
%L1536:
	movei	1,-0121(17)
	hrli	1,0331100
	movei	6,-067(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,assemble_phase2_file
%L1523:
	move	10,-0123(17)
	move	11,-0122(17)
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	popj	17,
%L1538:
	.byte	9,056,0104,062,0122
	.byte	9,0
	

%L1531:
	.byte	9,055,0117,0
	


main:
	jrst	das_native_main

	.bss

das_native_files:
	.space 144

das_optimize:
	.space 4

das_native_line:
	.space 256

das_native_tmp:
	.space 256

das_native_relmap:
	.space 1708

das_native_output_buffer:
	.space 256

das_native_phase_input:
	.space 128

das_native_phase_line:
	.space 256

das_native_ctx:
	.space 2944


	.text
%ADJBPH:
	JUMPE	1,%ADJX0
	JUMPE	16,%ADJX0
	PUSH	17,13
	PUSH	17,14
	PUSH	17,15
	PUSH	17,1
	JUMPL	16,%ADJN0
%ADJP0:	IBP	0(17)
	SOJG	16,%ADJP0
	JRST	%ADJR0
%ADJN0:	ADD	17,[2,,2]
	HLRZ	13,-2(17)
	LSH	13,-6
	ANDI	13,077
	MOVEM	13,-1(17)
%ADNI0:	HLRZ	14,-2(17)
	LSH	14,-014
	ANDI	14,077
	MOVEI	15,044
	SUB	15,-1(17)
	MOVEM	15,0(17)
	CAMN	14,0(17)
	 JRST	%ADJW0
	ADD	14,-1(17)
	JRST	%ADJS0
%ADJW0:	HRRZ	15,-2(17)
	SUBI	15,1
	HRRM	15,-2(17)
	MOVEI	15,044
%ADJL0:	SUB	15,-1(17)
	JUMPGE	15,%ADJL0
	ADD	15,-1(17)
	MOVEM	15,0(17)
	MOVE	14,0(17)
%ADJS0:	HLRZ	15,-2(17)
	ANDI	15,07777
	LSH	14,014
	MOVEM	14,0(17)
	IOR	15,0(17)
	HRLM	15,-2(17)
	AOJL	16,%ADNI0
	SUB	17,[2,,2]
%ADJR0:	POP	17,1
	POP	17,15
	POP	17,14
	POP	17,13
%ADJX0:
	POPJ	17,
%SIDH2:	PUSH	17,015
	PUSH	17,016
	MOVM	15,016
	MOVE	2,[0400000000000]
	MOVE	16,015
	JUMPL	16,%UIDN23
	JUMPGE	2,%UIDP23
	CAIG	16,1
	 JRST	%UIDZ23
	MOVE	3,2
	ANDI	3,1
	PUSH	17,03
	LSH	2,-1
	IDIV	2,016
	LSH	2,1
	LSH	3,1
	ADD	3,0(17)
	SUB	17,[1,,1]
	CAMGE	3,016
	 JRST	%UIDD23
	SUB	3,016
	AOJA	2,%UIDD23
%UIDN23:	MOVE	3,2
	MOVEI	2,0
	JUMPGE	3,%UIDD23
	CAMGE	3,016
	 JRST	%UIDD23
	SUB	3,016
	AOJA	2,%UIDD23
%UIDZ23:	TDZA	3,3
%UIDP23:	IDIV	2,016
%UIDD23:
	SKIPL	0(17)
	 MOVN	2,2
	SKIPE	3
	 MOVN	3,3
	SUB	17,[1,,1]
	POP	17,015
	POPJ	17,

	.globl das_native_main
	.globl main
;	.extern	fs_block_workspace
;	.extern	vfs_current_owner
;	.extern	vfs_name_valid
;	.extern	vfs_name_words_equal
;	.extern	vfs_name_from_words
;	.extern	vfs_name_is6
;	.extern	vfs_sixbit_name_chars
;	.extern	vfs_name_char
;	.extern	vfs_name_setchar
;	.extern	vfs_lookup
;	.extern	vfs_readdir
;	.extern	vfs_stat
;	.extern	vfs_parent
;	.extern	vfs_parent_name
;	.extern	vfs_create
;	.extern	vfs_mkfifo
;	.extern	vfs_mkdir
;	.extern	vfs_symlink
;	.extern	vfs_unlink
;	.extern	vfs_rename
;	.extern	vfs_truncate
;	.extern	vfs_chmod
;	.extern	vfs_chown
;	.extern	vfs_utime
;	.extern	vfs_read_words
;	.extern	vfs_write_words
;	.extern	vfs_readchar
;	.extern	vfs_writechar
;	.extern	vfs_sync
;	.extern	vfs_storage_release
;	.extern	vfs_mount
;	.extern	vfs_mount_prevalidated
;	.extern	vfs_unmount
;	.extern	vfs_remount
;	.extern	vfs_readonly
;	.extern	vfs_namespace_root
;	.extern	file_lookup_path
;	.extern	file_check_access
;	.extern	file_check_owner
;	.extern	file_check_root
;	.extern	file_open
;	.extern	file_close
;	.extern	file_dup
;	.extern	file_dup2
;	.extern	file_seek
;	.extern	file_lock
;	.extern	file_unlock_mount
;	.extern	file_close_all
;	.extern	file_readchar
;	.extern	file_writechar
;	.extern	file_read_words
;	.extern	file_write_words
;	.extern	file_readdir
;	.extern	file_stat_path
;	.extern	file_mkdir
;	.extern	file_mkfifo
;	.extern	file_symlink
;	.extern	file_unlink
;	.extern	file_rmdir
;	.extern	file_truncate
;	.extern	file_rename
;	.extern	file_chdir
;	.extern	file_getcwd
;	.extern	file_used_slots
;	.extern	proc_run_block
;	.extern	proc_wait_status
;	.extern	proc_control
;	.extern	sys_procinfo
;	.extern	sys_meminfo
;	.extern	exec_native_syscall
	.extern	dsys_open
	.extern	dsys_close
;	.extern	dsys_readchar
	.extern	dsys_writechar
	.extern	dsys_read_words
	.extern	dsys_write_words
;	.extern	dsys_stat
;	.extern	dsys_dirread
;	.extern	dsys_mkdir
	.extern	dsys_unlink
;	.extern	dsys_rename
;	.extern	dsys_truncate
;	.extern	dsys_chmod
;	.extern	dsys_chown
;	.extern	dsys_rmdir
;	.extern	dsys_utime
;	.extern	dsys_sleep
;	.extern	dsys_dtfs_mount
;	.extern	dsys_unmount
;	.extern	dsys_flock
;	.extern	dsys_dup
;	.extern	dsys_dup2
	.extern	dsys_seek
;	.extern	dsys_symlink
;	.extern	dsys_nice
;	.extern	dsys_run
;	.extern	dsys_wait
;	.extern	dsys_getpid
;	.extern	dsys_procctl
;	.extern	dsys_rtctl
;	.extern	dsys_logctl
;	.extern	dsys_pipe
;	.extern	dsys_mkfifo
;	.extern	dsys_exec
;	.extern	dsys_gettime
;	.extern	dsys_dtc_read_block
;	.extern	dsys_dtc_write_block
;	.extern	dsys_tsfs_mount
;	.extern	dsys_d6fs_mount
;	.extern	dsys_memfs_mount
;	.extern	dsys_storagectl
;	.extern	dsys_ttyctl
;	.extern	dsys_chdir
;	.extern	dsys_getcwd
;	.extern	dsys_procinfo
;	.extern	dsys_meminfo
	.extern	dsys_exit
;	.extern	dsys_halt
;	.extern	proc_table
;	.extern	proc_slots
;	.extern	proc_high_slot
;	.extern	proc_current_slot
;	.extern	proc_sched_cursor
;	.extern	proc_sched_deferred_ticks
;	.extern	proc_runq_head
;	.extern	proc_rt_owner
;	.extern	proc_timer_clock
;	.extern	proc_timer_next
;	.extern	mach_kernel_stack_base
;	.extern	proc_boot_init
;	.extern	proc_slots_for_core
;	.extern	proc_slot_claim
;	.extern	proc_exit_finish
;	.extern	proc_event_apply
;	.extern	proc_exit_current
;	.extern	proc_slot_discard
;	.extern	proc_child_hierarchy
;	.extern	proc_tty_read_enter
;	.extern	proc_tty_input
;	.extern	proc_tty_line_take
;	.extern	proc_tty_canon_input
;	.extern	proc_tty_line_reset
;	.extern	proc_tty_mode_set
;	.extern	proc_tty_output_route_get
;	.extern	proc_tty_output_route_set
;	.extern	proc_tty_output
;	.extern	proc_tty_pending_take
;	.extern	proc_tty_pending_store
;	.extern	proc_sched_resched_current
;	.extern	proc_scope_id
;	.extern	proc_wait_child
;	.extern	proc_comm
;	.extern	proc_image_text_readchar
;	.extern	proc_wait_event
;	.extern	proc_wait_event_intr
;	.extern	proc_wakeup_event
;	.extern	proc_runq_add
;	.extern	proc_runq_remove
;	.extern	proc_sched_tick_select
;	.extern	proc_sched_resched_select
;	.extern	proc_nice_value
;	.extern	proc_nice_current
;	.extern	proc_rt_control
;	.extern	proc_sleep_ticks
;	.extern	proc_swap_victim
;	.extern	proc_user_context_init
;	.extern	proc_sched_pi_tick
;	.extern	exec_load_process
;	.extern	exec_replace_current

