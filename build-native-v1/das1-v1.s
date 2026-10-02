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

das_strip_c_comments:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[4,,4]
	movem	10,-3(17)
	movem	10,-2(17)
	setz	3,
	movem	3,-1(17)
%L108:
	ldb	1,-3(17)
	jumpe	1,%L109
	move	3,-3(17)
	ibp	-3(17)
	ldb	1,3
	movem	1,0(17)
	move	3,0(11)
	trnn	3,1
	 jrst	%L110
	caie	1,052
	 jrst	%L108
	ldb	2,-3(17)
	caie	2,057
	 jrst	%L108
	movni	4,2
	andb	4,0(11)
	ibp	-3(17)
	move	5,-3(17)
	jrst	%L108
%L110:
	skipn	2,-1(17)
	 jrst	%L111
	move	3,0(17)
	andi	3,0777
	move	4,-2(17)
	ibp	-2(17)
	dpb	3,4
	move	2,-1(17)
	trnn	2,0200
	 jrst	%L112
	movei	1,0177
	andb	1,-1(17)
	jrst	%L108
%L112:
	move	2,0(17)
	caie	2,0134
	 jrst	%L113
	movei	1,0200
	iorb	1,-1(17)
	jrst	%L108
%L113:
	move	2,0(17)
	move	3,-1(17)
	andi	3,0177
	came	2,3
	 jrst	%L108
	setz	1,
	movem	1,-1(17)
	jrst	%L108
%L111:
	move	3,0(17)
	cain	3,047
	 jrst	%L115
	caie	3,042
	 jrst	%L114
%L115:
	move	3,0(17)
	movem	3,-1(17)
	andi	3,0777
	move	2,-2(17)
	ibp	-2(17)
	dpb	3,2
	jrst	%L108
%L114:
	move	2,0(17)
	caie	2,057
	 jrst	%L116
	ldb	1,-3(17)
	caie	1,052
	 jrst	%L116
	movei	3,040
	move	5,-2(17)
	ibp	-2(17)
	dpb	3,5
	movei	1,1
	iorb	1,0(11)
	ibp	-3(17)
	move	2,-3(17)
	jrst	%L108
%L116:
	move	2,0(17)
	andi	2,0777
	move	3,-2(17)
	ibp	-2(17)
	dpb	2,3
	jrst	%L108
%L109:
	setz	1,
	dpb	1,-2(17)
%L107:
	move	10,-5(17)
	move	11,-4(17)
	SUB	17,[6,,6]
	popj	17,

das_read_line:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[4,,4]
	skipe	1,010
	 skipn	3,0(10)
	 jrst	%L119
	skipn	2,011
	 jrst	%L119
	skipe	4,012
	 jrst	%L118
%L119:
	seto	1,
	jrst	%L117
%L118:
	setz	1,
	movem	1,-3(17)
	setm	2,1
	movem	2,0(17)
%L120:
	move	2,0(10)
	move	16,2
	movei	1,-2(17)
	move	3,1(10)
	move	2,1
	move	1,3
	pushj	17,0(16)
	movem	1,-1(17)
	aojn	1,%L122
	seto	1,
	jrst	%L117
%L122:
	skipe	2,-1(17)
	 jrst	%L123
	skipn	3,-3(17)
	 skipe	4,0(17)
	 jrst	%L124
	setm	1,4
	jrst	%L117
%L124:
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
	skipe	5,0(17)
	 jrst	%L125
	move	2,010
	addi	2,2
	move	1,011
	pushj	17,das_strip_c_comments
%L125:
	skipn	2,0(17)
	 jrst	%L126
	movni	1,2
	jrst	%L127
%L126:
	movei	1,1
%L127:
	jrst	%L117
%L123:
	movei	3,0177
	andb	3,-2(17)
	caie	3,012
	 jrst	%L128
	setz	1,
	move	4,-3(17)
	move	2,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	2,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	skipe	6,0(17)
	 jrst	%L129
	move	2,010
	addi	2,2
	move	1,011
	pushj	17,das_strip_c_comments
%L129:
	skipn	2,0(17)
	 jrst	%L130
	movni	1,2
	jrst	%L131
%L130:
	movei	1,1
%L131:
	jrst	%L117
%L128:
	skipe	2,0(17)
	 jrst	%L120
	move	3,-3(17)
	addi	3,1
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	caml	3,1
	 jrst	%L132
	move	5,-2(17)
	andi	5,0777
	aos	4,-3(17)
	subi	4,1
	move	6,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	6,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	5,4
	jrst	%L120
%L132:
	movei	1,1
	movem	1,0(17)
	jrst	%L120
%L117:
	move	10,-6(17)
	move	11,-5(17)
	move	12,-4(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

das_s6_get:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	3,010
	tlz	3,0777700
	push	17,3
	ADD	17,[3,,3]
	jumpe	3,%L135
	move	1,011
	jumpn	1,%L134
%L135:
	seto	1,
	jrst	%L133
%L134:
	move	5,-3(17)
	skipn	1,5(5)
	 jrst	%L136
	setzb	3,5(5)
	movei	2,012
	movem	2,0(11)
	movei	1,1
	jrst	%L133
%L136:
%L137:
	move	4,-3(17)
	skipe	1,3(4)
	 jrst	%L138
	move	16,0(4)
	movei	1,-2(17)
	move	3,-3(17)
	move	6,1(3)
	move	2,1
	move	1,6
	pushj	17,0(16)
	movem	1,0(17)
	soje	1,%L139
	move	1,0(17)
	jrst	%L133
%L139:
	move	2,-2(17)
	lsh	2,-036
	soje	2,%L140
	seto	1,
	jrst	%L133
%L140:
	move	2,-2(17)
	tlz	2,01777777777777700
	move	3,-3(17)
	movem	2,3(3)
	movei	1,6
	move	5,-3(17)
	movem	1,4(5)
	move	6,-3(17)
	skipe	4,3(6)
	 jrst	%L137
	movei	7,012
	movem	7,0(11)
	movei	1,1
	jrst	%L133
%L138:
	move	2,-3(17)
	move	1,4(2)
	tlc	1,0400000
	camge	1,[0400000000006]
	 jrst	%L141
	move	4,-3(17)
	move	16,0(4)
	move	2,-3(17)
	addi	2,2
	move	3,-3(17)
	move	1,1(3)
	pushj	17,0(16)
	movem	1,0(17)
	soje	1,%L142
	seto	1,
	jrst	%L133
%L142:
	move	3,-3(17)
	setzb	1,4(3)
%L141:
	move	2,-3(17)
	move	1,4(2)
	muli	1,6
	trne	1,1
	 tloa	2,0400000
	 tlz	2,0400000
	movn	6,2
	addi	6,036
	movem	6,-1(17)
	move	4,-3(17)
	move	3,2(4)
	movn	6,6
	lsh	3,0(6)
	andi	3,077
	addi	3,040
	movem	3,0(11)
	move	1,-3(17)
	aos	5,4(1)
	move	2,-3(17)
	sos	7,3(2)
	move	2,-3(17)
	skipn	1,3(2)
	 skipa	1,[1]
	 trna	
	 movem	1,5(2)
	movei	1,1
%L133:
	move	10,-5(17)
	move	11,-4(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

das_s6_init:
	movem	2,0(1)
	movem	3,1(1)
	setzb	6,2(1)
	setm	7,6
	movem	7,3(1)
	movei	4,6
	movem	4,4(1)
	setzb	4,5(1)
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
%L145:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-3(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L146
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
	 jrst	%L147
	move	1,-2(17)
	movem	1,-3(17)
	jrst	%L145
%L147:
	move	1,010
	tlc	1,0400000
	move	2,-2(17)
	move	3,das_op_mn(2)
	tlc	3,0400000
	camg	1,3
	 jrst	%L148
	move	5,-2(17)
	addi	5,1
	movem	5,-4(17)
	jrst	%L145
%L148:
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
	 jrst	%L149
	trnn	1,01000
	 tdza	1,1
	 movei	1,1
	movem	1,0(11)
%L149:
	move	1,0(17)
	andi	1,0777
	jrst	%L144
%L146:
	skipe	1,011
	 tdza	2,2
	 trna	
	 movem	2,0(11)
	seto	1,
%L144:
	move	10,-6(17)
	move	11,-5(17)
	move	16,-7(17)
	SUB	17,[010,,010]
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
	 jrst	%L154
	move	4,-1(17)
	move	2,0(4)
	move	3,0(2)
	move	2,1(4)
	move	1,3
	movei	3,040
	pushj	17,dsys_read_words
	movem	1,0(17)
	skipe	3,1
	 jrst	%L155
	setm	1,3
	jrst	%L153
%L155:
	skipl	2,0(17)
	 jrst	%L156
	movei	1,1
	move	4,-1(17)
	move	3,0(4)
	movem	1,1(3)
	seto	1,
	jrst	%L153
%L156:
	move	2,0(17)
	move	5,-1(17)
	movem	2,3(5)
	setzb	1,2(5)
%L154:
	move	4,-1(17)
	aos	1,2(4)
	add	1,1(4)
	move	2,-1(1)
	movem	2,0(11)
	movei	1,1
%L153:
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
	 jrst	%L158
	movei	1,02507
	pushj	17,das_native_die
%L158:
	move	1,0(17)
%L157:
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
%L159:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

strcopy:
	skipn	4,3
	 popj	17,
%L162:
	move	4,3
	tlc	4,0400000
	camg	4,[0400000000001]
	 jrst	%L163
	move	5,2
	ldb	6,5
	jumpe	6,%L163
	move	7,2
	ibp	2
	ldb	4,7
	move	5,1
	ibp	1
	dpb	4,5
	soja	3,%L162
%L163:
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
%L165:
	move	1,010
	camn	1,011
	 jrst	%L166
	ibp	010
	aos	3,0(17)
	jrst	%L165
%L166:
	move	1,0(17)
%L164:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

skipws:
	push	17,010
	move	10,1
%L168:
	move	1,010
	ldb	2,1
	jumpe	2,%L169
	move	1,010
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L169
	ibp	010
	jrst	%L168
%L169:
	move	1,010
%L167:
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
%L171:
	skipn	2,0(17)
	 jrst	%L172
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
	jumpe	1,%L172
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
	jrst	%L171
%L172:
%L170:
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
%L173:
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
%L177:
	move	2,0(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L178
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
	 jrst	%L179
	setz	1,
	jrst	%L176
%L179:
	aos	1,0(17)
	jrst	%L177
%L178:
	movei	1,1
%L176:
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
%L181:
	move	1,010
	ldb	2,1
	jumpe	2,%L182
	move	4,-1(17)
	tlc	4,0400000
	caml	4,[0400000000006]
	 jrst	%L182
	move	3,010
	ibp	010
	ldb	7,3
	andi	7,0777
	movem	7,0(17)
	tlc	7,0400000
	camge	7,[0400000000141]
	 jrst	%L183
	move	6,0(17)
	tlc	6,0400000
	camle	6,[0400000000172]
	 jrst	%L183
	movni	1,040
	addb	1,0(17)
%L183:
	move	2,-2(17)
	lsh	2,6
	move	3,0(17)
	subi	3,0100
	ior	2,3
	movem	2,-2(17)
	aos	1,-1(17)
	jrst	%L181
%L182:
%L184:
	aos	1,-1(17)
	subi	1,1
	tlc	1,0400000
	caml	1,[0400000000006]
	 jrst	%L185
	move	4,-2(17)
	lsh	4,6
	movem	4,-2(17)
	jrst	%L184
%L185:
	move	1,-2(17)
%L180:
	move	10,-3(17)
	SUB	17,[4,,4]
	popj	17,

%L186:
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
	move	2,[POINT 9,%L189,8]
	move	1,011
	movei	3,7
	pushj	17,pref_i
	jumpe	1,%L188
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
	jumpn	2,%L188
	movei	1,033
	jrst	%L187
%L188:
	move	1,011
	ldb	4,1
	andi	4,0777
	subi	4,0101
	movem	4,0(17)
	tlc	4,0400000
	caml	4,[0400000000032]
	 jrst	%L191
	move	2,[0223544577]
	movn	5,0(17)
	ash	2,0(5)
	trne	2,1
	 jrst	%L190
%L191:
	setz	1,
	jrst	%L187
%L190:
	move	1,011
	pushj	17,token_key
	movem	1,-4(17)
	setz	2,
	movem	2,-3(17)
	movei	3,052
	movem	3,-2(17)
%L192:
	move	2,-3(17)
	tlc	2,0400000
	move	3,-2(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L193
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
	move	5,%L186(1)
	tlc	5,0400000
	caml	6,5
	 jrst	%L194
	move	1,-1(17)
	movem	1,-2(17)
	jrst	%L192
%L194:
	move	2,-4(17)
	tlc	2,0400000
	move	4,-1(17)
	ash	4,1
	move	1,%L186(4)
	tlc	1,0400000
	camg	2,1
	 jrst	%L195
	move	5,-1(17)
	addi	5,1
	movem	5,-3(17)
	jrst	%L192
%L195:
	move	3,-1(17)
	ash	3,1
	move	1,%L186+1(3)
	jrst	%L187
%L193:
	setz	1,
%L187:
	move	10,-6(17)
	move	11,-5(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,
%L189:
	.byte	9,0120,062,0101,0114
	.byte	9,0111,0107,0116,0
	


isname0:
	push	17,010
	move	10,1
	move	1,010
	andi	1,0777
	pushj	17,das_native_is_alpha
	jumpn	1,%L198
	move	2,010
	cain	2,0137
	 jrst	%L198
	move	3,010
	cain	3,056
	 jrst	%L198
	move	4,010
	movei	5,045
	came	4,5
	 skipa	6,010
	 trna	
	 cain	6,044
%L198:
	 skipa	1,[1]
	 setz	1,
%L196:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

isname:
	push	17,010
	move	10,1
	move	1,010
	andi	1,0777
	pushj	17,das_native_is_alnum
	jumpn	1,%L201
	move	2,010
	cain	2,0137
	 jrst	%L201
	move	3,010
	cain	3,056
	 jrst	%L201
	move	4,010
	movei	5,045
	came	4,5
	 skipa	6,010
	 trna	
	 cain	6,044
%L201:
	 skipa	1,[1]
	 setz	1,
%L199:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

parse_octal_w:
	push	17,010
	move	10,1
	push	17,[0]
%L203:
	move	1,010
	ldb	2,1
	caige	2,060
	 jrst	%L204
	move	3,010
	ldb	4,3
	caile	4,067
	 jrst	%L204
	move	5,010
	ldb	6,5
	subi	6,060
	move	2,0(17)
	lsh	2,3
	add	6,2
	movem	6,0(17)
	ibp	010
	jrst	%L203
%L204:
	move	1,0(17)
	tlz	1,01777777777000000
%L202:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

parse_octal_u:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,parse_octal_w
	hrrz	1,1
%L205:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

sixbit_mn:
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	setz	1,
	movem	1,-2(17)
	setm	2,1
	movem	2,-1(17)
%L207:
	move	1,010
	ldb	2,1
	jumpe	2,%L208
	move	4,-1(17)
	cail	4,6
	 jrst	%L208
	move	3,010
	ibp	010
	ldb	5,3
	dpb	5,[POINT 9,0(17),35]
	ldb	1,[POINT 9,0(17),35]
	cail	1,0141
	 caile	1,0172
	 jrst	%L209
	subi	1,040
	move	7,1
	andi	7,0777
	dpb	7,[POINT 9,0(17),35]
%L209:
	ldb	4,[POINT 9,0(17),35]
	cail	4,0101
	 caile	4,0132
	 jrst	%L210
	move	2,-2(17)
	lsh	2,6
	subi	4,0100
	ior	2,4
	movem	2,-2(17)
	aos	1,-1(17)
%L210:
	jrst	%L207
%L208:
	move	1,-2(17)
%L206:
	move	10,-3(17)
	SUB	17,[4,,4]
	popj	17,

	.data

das_strict_base:
	.word 0

das_kernel_mode:
	.word 0

	.text

%L211:
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
%L213:
	move	6,0(17)
	ash	6,1
	move	1,%L211(6)
	came	1,010
	 jrst	%L215
	move	1,%L211+1(6)
	jrst	%L212
%L215:
	aos	3,0(17)
	tlc	3,0400000
	camge	3,[0400000000030]
	 jrst	%L213
	seto	1,
%L212:
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
	jumpge	1,%L216
	move	1,-1(17)
	pushj	17,lookup_extra_op_mn
	movem	1,0(17)
	skipl	3,1
	 skipn	2,011
	 jrst	%L218
	movei	4,1
	movem	4,0(11)
%L218:
	move	1,0(17)
%L216:
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	popj	17,

%L219:
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
	movei	3,%L219
%L221:
	move	2,0(3)
	came	2,-1(17)
	 jrst	%L223
	move	1,0(17)
	jrst	%L220
%L223:
	aos	4,0(17)
	addi	3,1
	tlc	4,0400000
	camge	4,[0400000000010]
	 jrst	%L221
	seto	1,
%L220:
	move	10,-2(17)
	SUB	17,[3,,3]
	popj	17,

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
	jumpn	1,%L225
	setm	1,1
	jrst	%L226
%L225:
	seto	1,
%L226:
%L224:
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
%L228:
	skipn	1,012
	 jrst	%L229
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
	 jrst	%L230
	seto	1,
	jrst	%L227
%L230:
	move	2,0(17)
	add	2,011
	move	11,2
	move	4,0(17)
	move	3,012
	sub	3,4
	move	12,3
	jrst	%L228
%L229:
	setz	1,
%L227:
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
%L232:
	skipn	1,012
	 jrst	%L233
	move	2,0(10)
	move	1,0(2)
	move	2,011
	move	3,012
	pushj	17,dsys_read_words
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
	jumpe	1,%L236
	seto	1,
	jrst	%L235
%L236:
	move	1,010
	move	2,011
	move	3,012
	pushj	17,wordfile_write
	jumpe	1,%L237
	seto	1,
	jrst	%L235
%L237:
	move	1,012
	addb	1,1(10)
	setz	1,
%L235:
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
	 jrst	%L240
	move	2,013
	tlc	2,0400000
	move	5,1(10)
	sub	5,011
	tlc	5,0400000
	camg	2,5
	 jrst	%L239
%L240:
	seto	1,
	jrst	%L238
%L239:
	move	1,010
	move	2,011
	pushj	17,wordfile_seek
	jumpe	1,%L241
	seto	1,
	jrst	%L238
%L241:
	move	1,010
	move	2,012
	move	3,013
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	move	13,0(17)
	SUB	17,[4,,4]
	jrst	wordfile_read_words
%L238:
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
%L243:
	move	2,-2(17)
	tlc	2,0400000
	move	1,011
	tlc	1,0400000
	caml	2,1
	 jrst	%L244
	move	6,010
	add	6,-2(17)
	setzb	3,0(6)
	aos	4,-2(17)
	jrst	%L243
%L244:
	setz	1,
	movem	1,-2(17)
%L246:
	move	2,-2(17)
	tlc	2,0400000
	move	1,013
	tlc	1,0400000
	caml	2,1
	 jrst	%L247
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
	jrst	%L246
%L247:
%L242:
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
	 jrst	%L249
	move	2,013
	tlc	2,0400000
	move	3,011
	tlc	3,0400000
	camge	2,3
	 jrst	%L251
	move	4,011
	subi	4,1
	move	13,4
%L251:
	setz	1,
	movem	1,-2(17)
%L252:
	move	2,-2(17)
	tlc	2,0400000
	move	1,013
	tlc	1,0400000
	caml	2,1
	 jrst	%L253
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
	jrst	%L252
%L253:
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
%L249:
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
%L256:
	move	1,010
	ldb	2,1
	jumpe	2,%L257
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
	jrst	%L256
%L257:
	move	1,0(17)
%L255:
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
%L258:
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
%L260:
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
	 jrst	%L262
	seto	1,
	jrst	%L261
%L262:
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
	move	1,[POINT 9,%L263,8]
	move	6,010
	addi	6,2
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,fopen
	movem	1,0(10)
	skipe	3,1
	 jrst	%L264
	seto	2,
	move	1,2
	jrst	%L265
%L264:
	setz	1,
%L265:
%L261:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	popj	17,
%L263:
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
	move	3,[POINT 9,%L268,8]
	move	2,010
	addi	2,0703
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L267
	seto	1,
	jrst	%L266
%L267:
	move	3,[POINT 9,%L270,8]
	move	2,010
	addi	2,0742
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L269
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
	jrst	%L266
%L269:
	move	3,[POINT 9,%L272,8]
	move	2,010
	addi	2,01045
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L271
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
	jrst	%L266
%L271:
	move	3,[POINT 9,%L274,8]
	move	2,010
	addi	2,01101
	move	1,2
	move	2,011
	pushj	17,scratch_open
	jumpe	1,%L273
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
	jrst	%L266
%L273:
	setz	1,
%L266:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L274:
	.byte	9,056,0104,061,0122
	.byte	9,0
	

%L272:
	.byte	9,056,0104,0122,0120
	.byte	9,0
	

%L270:
	.byte	9,056,0104,0114,0124
	.byte	9,0
	

%L268:
	.byte	9,056,0104,0123,0131
	.byte	9,0
	


store_close:
	push	17,010
	move	10,1
	skipn	2,0703(1)
	 jrst	%L276
	move	2,0703(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0703(10)
	move	1,010
	addi	1,0705
	hrli	1,0331100
	pushj	17,remove
%L276:
	skipn	2,0742(10)
	 jrst	%L277
	move	2,0742(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,0742(10)
	move	1,010
	addi	1,0744
	hrli	1,0331100
	pushj	17,remove
%L277:
	skipn	2,01045(10)
	 jrst	%L278
	move	2,01045(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,01045(10)
	move	1,010
	addi	1,01047
	hrli	1,0331100
	pushj	17,remove
%L278:
	skipn	2,01101(10)
	 jrst	%L279
	move	2,01101(10)
	move	1,2
	pushj	17,fclose
	setz	1,
	movem	1,01101(10)
	move	1,010
	addi	1,01103
	hrli	1,0331100
	pushj	17,remove
%L279:
%L275:
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
%L280:
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
	jumpe	5,%L282
	move	7,0(2)
	came	7,-017(17)
	 jrst	%L282
	move	1,-035(17)
	addi	1,3
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L282
	move	2,-035(17)
	addi	2,3
	move	1,012
	pushj	17,sym_copy
	movei	1,1
	jrst	%L281
%L282:
	move	4,-017(17)
	andi	4,0377
	movem	4,-016(17)
	add	4,-036(17)
	move	1,0(4)
	movem	1,-015(17)
%L283:
	skipn	2,-015(17)
	 jrst	%L284
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
	jumpe	1,%L285
	movei	1,04013
	pushj	17,das_native_die
%L285:
	move	3,-036(17)
	aos	1,0741(3)
	move	2,-033(17)
	came	2,-017(17)
	 jrst	%L286
	movei	1,-013(17)
	movei	6,-034(17)
	move	2,1
	move	1,6
	pushj	17,sym_record_unpack
	movei	1,-013(17)
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L286
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
	jrst	%L281
%L286:
	hrrz	2,-034(17)
	movem	2,-015(17)
	jrst	%L283
%L284:
	setz	1,
%L281:
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
	jumpe	1,%L288
	movei	1,04056
	pushj	17,das_native_die
%L288:
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
%L287:
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
%L289:
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
%L290:
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
%L292:
	skipn	2,-014(17)
	 jrst	%L293
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
	jumpe	1,%L294
	movei	1,04130
	pushj	17,das_native_die
%L294:
	move	1,-032(17)
	came	1,-016(17)
	 jrst	%L295
	movei	1,-013(17)
	movei	6,-033(17)
	move	2,1
	move	1,6
	pushj	17,sym_record_unpack
	movei	1,-013(17)
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L295
	move	3,-1(17)
	andi	3,030
	caie	3,030
	 jrst	%L295
	movei	1,1
	jrst	%L291
%L295:
	hrrz	2,-033(17)
	movem	2,-014(17)
	jrst	%L292
%L293:
	setz	1,
%L291:
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
	jumpn	1,%L296
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
	jumpe	1,%L298
	movei	1,04166
	pushj	17,das_native_die
%L298:
	move	3,0(17)
	move	4,-020(17)
	add	4,-1(17)
	movem	3,0(4)
	move	2,-020(17)
	movem	3,0737(2)
%L296:
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
%L300:
	skipn	2,-014(17)
	 jrst	%L301
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
	jumpe	1,%L302
	movei	1,04215
	pushj	17,das_native_die
%L302:
	move	1,-032(17)
	came	1,-016(17)
	 jrst	%L303
	movei	1,-013(17)
	movei	6,-033(17)
	move	2,1
	move	1,6
	pushj	17,sym_record_unpack
	movei	1,-013(17)
	hrli	1,0331100
	move	2,011
	pushj	17,strcmp
	jumpn	1,%L303
	move	3,-1(17)
	andi	3,030
	caie	3,030
	 jrst	%L303
	movei	2,-013(17)
	move	1,012
	pushj	17,sym_copy
	movei	1,1
	jrst	%L299
%L303:
	hrrz	2,-033(17)
	movem	2,-014(17)
	jrst	%L300
%L301:
	setz	1,
%L299:
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
	jumpn	1,%L304
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
	jumpe	1,%L306
	movei	1,04256
	pushj	17,das_native_die
%L306:
	move	3,-014(17)
	move	4,-034(17)
	add	4,-015(17)
	movem	3,0(4)
	move	2,-034(17)
	movem	3,0737(2)
%L304:
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
	jumpn	1,%L308
	setm	1,1
	jrst	%L307
%L308:
	hrrz	2,0(17)
	tlc	2,0400000
	move	3,01337(10)
	tlc	3,0400000
	camle	2,3
	 tdza	1,1
	 movei	1,1
%L307:
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
	move	2,[POINT 9,%L316,8]
	move	3,-2(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L315
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
	jumpn	1,%L314
%L315:
	move	2,[POINT 9,%L318,8]
	move	3,-2(17)
	move	1,3
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L317
	move	1,-2(17)
	ibp	1
	ibp	1
	ildb	1,1
	pushj	17,das_native_is_space
	jumpn	1,%L314
%L317:
	move	2,[POINT 9,%L320,8]
	move	3,-2(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L319
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
	jumpn	1,%L314
%L319:
	move	2,[POINT 9,%L321,8]
	move	3,-2(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L313
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
	 jrst	%L313
%L314:
	movei	1,1
	jrst	%L311
%L313:
	move	2,[POINT 9,%L323,8]
	move	3,-2(17)
	move	1,3
	pushj	17,strstr
	jumpe	1,%L322
	movei	1,1
	jrst	%L311
%L322:
	setzb	1,0(17)
%L324:
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
	jumpe	1,%L325
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
	jumpn	1,%L325
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
	 jrst	%L325
	move	5,0(17)
	addi	5,1
	tlc	5,0400000
	caml	5,[0400000000040]
	 jrst	%L325
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
	jrst	%L324
%L325:
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
	 jrst	%L326
	ldb	5,[POINT 9,-012(17),8]
	caie	5,056
	 jrst	%L327
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
%L327:
	movei	1,-012(17)
	hrli	1,0331100
	setz	2,
	pushj	17,lookup_op
	jumpge	1,%L328
	movei	1,-012(17)
	hrli	1,0331100
	pushj	17,lookup_io
	jumpl	1,%L326
%L328:
	movei	1,1
	jrst	%L311
%L326:
	move	1,-2(17)
	movei	2,054
	pushj	17,strchr
	movem	1,-1(17)
	jumpe	1,%L329
	move	1,-1(17)
	ibp	1
	movei	2,054
	pushj	17,strchr
	jumpn	1,%L329
	movei	1,2
	jrst	%L311
%L329:
	movei	1,1
%L311:
	move	10,-0113(17)
	move	16,-0114(17)
	SUB	17,[0115,,0115]
	popj	17,
%L323:
	.byte	9,054,054,0
	

%L321:
	.byte	9,045,0105,0130,0111
	.byte	9,0116,0104,0
	

%L320:
	.byte	9,0117,0127,0107,0102
	.byte	9,0120,0
	

%L318:
	.byte	9,0107,0111,0127,0
	

%L316:
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
	 jrst	%L331
	move	1,011
	SKIPL	2,1
	 TDZA	1,1
	  MOVEI	1,1
	DIVI	1,12
	move	2,1
	move	1,010
	pushj	17,das_format_u10_digits
	move	10,1
%L331:
	move	1,011
	movei	3,012
	skipge	16,3
	 JRST	%UIDN5
	JUMPGE	1,%UIDP5
	CAIG	16,1
	 JRST	%UIDZ5
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
	 JRST	%UIDD5
	SUB	2,016
	AOJA	1,%UIDD5
%UIDN5:	MOVE	2,1
	MOVEI	1,0
	JUMPGE	2,%UIDD5
	CAMGE	2,016
	 JRST	%UIDD5
	SUB	2,016
	AOJA	1,%UIDD5
%UIDZ5:	TDZA	2,2
%UIDP5:	IDIV	1,016
%UIDD5:
	addi	2,060
	andi	2,0777
	move	4,010
	ibp	010
	dpb	2,4
	move	1,010
%L330:
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
%L332:
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
%L334:
	move	4,011
	movn	3,-2(17)
	lsh	4,0(3)
	andi	4,7
	movem	4,0(17)
	jumpn	4,%L338
	skipe	2,-1(17)
	 jrst	%L338
	skipe	5,-2(17)
	 jrst	%L337
%L338:
	move	2,0(17)
	addi	2,060
	andi	2,0777
	move	3,-3(17)
	ibp	-3(17)
	dpb	2,3
	movei	1,1
	movem	1,-1(17)
%L337:
	movni	2,3
	addb	2,-2(17)
	jumpge	2,%L334
	setz	1,
	dpb	1,-3(17)
%L333:
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
	jumpe	1,%L339
	move	2,[POINT 9,%L341,8]
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
	 jrst	%L342
	move	4,012
	subi	4,1
	sub	4,-1(17)
	movem	4,0(17)
%L342:
	skipn	2,0(17)
	 jrst	%L343
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
%L343:
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
%L339:
	move	10,-010(17)
	move	11,-7(17)
	move	12,-6(17)
	move	16,-011(17)
	SUB	17,[012,,012]
	popj	17,
%L341:
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
	 jrst	%L345
	setz	1,
	jrst	%L344
%L345:
	hrrz	3,013(2)
	movem	3,0(17)
	jumpe	3,%L347
	tlc	3,0400000
	move	4,01336(10)
	tlc	4,0400000
	camg	3,4
	 jrst	%L346
%L347:
	setz	1,
	jrst	%L344
%L346:
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
	jumpn	1,%L348
	setm	1,1
	jrst	%L344
%L348:
	move	2,012(11)
	andi	2,030
	caie	2,010
	 tdza	1,1
	 movei	1,1
%L344:
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
%L351:
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
	 jrst	%L354
	tlc	3,0400000
	camg	3,[0400000000047]
	 jrst	%L353
%L354:
	setz	1,
	jrst	%L352
%L353:
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
	 jrst	%L355
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
%L355:
	movei	1,0(17)
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,lookup_op
	jumpge	1,%L357
	movei	1,-013(17)
	hrli	1,0331100
	pushj	17,lookup_io
	jumpl	1,%L356
%L357:
	movei	1,1
	jrst	%L352
%L356:
	move	1,[POINT 9,%L360,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,5
	pushj	17,pref_i
	jumpn	1,%L359
	move	1,[POINT 9,%L361,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,3
	pushj	17,pref_i
	jumpn	1,%L359
	move	1,[POINT 9,%L362,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,5
	pushj	17,pref_i
	jumpn	1,%L359
	move	1,[POINT 9,%L363,8]
	movei	6,-013(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L358
%L359:
	movei	1,1
	jrst	%L352
%L358:
	setz	1,
%L352:
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,
%L363:
	.byte	9,045,0105,0130,0111
	.byte	9,0116,0104,0
	

%L362:
	.byte	9,0117,0127,0107,0102
	.byte	9,0120,0
	

%L361:
	.byte	9,0107,0111,0127,0
	

%L360:
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
	 jrst	%L364
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L364:
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
%L365:
	skipl	2,-072(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-071(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L366
	skipn	4,-067(17)
	 jrst	%L367
	move	5,-070(17)
	addi	5,1
	tlc	5,0400000
	move	6,-0101(17)
	tlc	6,0400000
	camge	5,6
	 jrst	%L368
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L368:
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
	jrst	%L365
%L367:
	ldb	1,-072(17)
	cain	1,047
	 jrst	%L371
	caie	1,042
	 jrst	%L370
%L371:
	ldb	1,-072(17)
	andi	1,0777
	movem	1,-067(17)
	move	3,-070(17)
	addi	3,1
	tlc	3,0400000
	move	4,-0101(17)
	tlc	4,0400000
	camge	3,4
	 jrst	%L372
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L372:
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
	jrst	%L365
%L370:
	ldb	1,-072(17)
	andi	1,0777
	pushj	17,isname0
	jumpe	1,%L373
	move	2,-072(17)
	ibp	2
	movem	2,-065(17)
%L374:
	skipl	2,-065(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-071(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L375
	ldb	1,-065(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L375
	ibp	-065(17)
	move	2,-065(17)
	jrst	%L374
%L375:
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
	 jrst	%L376
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
	 jrst	%L377
	move	2,-065(17)
	move	1,-072(17)
	pushj	17,literal_first_token_is_operator
	jumpn	1,%L376
%L377:
	movei	3,-051(17)
	movei	2,-064(17)
	hrli	2,0331100
	move	4,-075(17)
	move	1,4
	pushj	17,find_sym
	jumpe	1,%L376
	move	3,-037(17)
	andi	3,030
	cain	3,020
	 skipa	2,[1]
	 trna	
	 movem	2,-035(17)
%L376:
	skipn	2,-035(17)
	 jrst	%L379
	hrrz	3,-036(17)
	movem	3,0(17)
	movei	3,-014(17)
	movei	2,-051(17)
	move	4,-075(17)
	move	1,4
	pushj	17,set_snapshot_lookup
	jumpe	1,%L381
	move	3,-2(17)
	trne	3,7
	 jrst	%L381
	movei	2,060
	dpb	2,[POINT 9,-034(17),8]
	move	2,-1(17)
	tlz	2,01777777777000000
	movei	1,-034(17)
	hrli	1,0221100
	pushj	17,das_format_octal
	jrst	%L380
%L381:
	movei	2,-034(17)
	hrli	2,0331100
	move	3,0(17)
	move	1,3
	movei	3,077
	pushj	17,set_snapshot_name
%L380:
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
	 jrst	%L382
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L382:
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
	jrst	%L378
%L379:
	move	2,-052(17)
	add	2,-070(17)
	tlc	2,0400000
	move	3,-0101(17)
	tlc	3,0400000
	camge	2,3
	 jrst	%L383
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L383:
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
%L378:
	move	2,-065(17)
	movem	2,-072(17)
	setz	1,
	movem	1,-066(17)
	jrst	%L365
%L373:
	ldb	1,-072(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpn	1,%L384
	setm	2,1
	movem	2,-066(17)
%L384:
	move	2,-070(17)
	addi	2,1
	tlc	2,0400000
	move	3,-0101(17)
	tlc	3,0400000
	camge	2,3
	 jrst	%L385
	seto	1,
	move	16,-073(17)
	SUB	17,[074,,074]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L385:
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
	jrst	%L365
%L366:
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
	movei	1,das_native_rept_record
	movem	1,-011(17)
	move	2,[POINT 9,das_native_tmp,8]
	movem	2,-010(17)
	setz	3,
	movem	3,-6(17)
	setm	4,3
	movem	4,-5(17)
	setz	5,
	movem	5,-4(17)
%L387:
	move	2,-4(17)
	tlc	2,0400000
	move	3,0776(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L388
	movei	1,-7(17)
	move	3,-6(17)
	move	6,010
	addi	6,0742
	move	2,3
	move	3,1
	move	1,6
	movei	4,1
	pushj	17,wordfile_read
	jumpe	1,%L390
	movei	1,05246
	pushj	17,das_native_die
%L390:
	move	3,-7(17)
	movem	3,-3(17)
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L391
	movei	1,05252
	pushj	17,das_native_die
%L391:
	move	1,-3(17)
	pushj	17,lit_record_words
	movem	1,-2(17)
	move	3,1
	tlc	3,0400000
	camg	3,[0400000000001]
	 jrst	%L392
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
	jumpe	1,%L392
	movei	1,05264
	pushj	17,das_native_die
%L392:
	move	2,-3(17)
	move	3,-011(17)
	move	1,-010(17)
	move	4,2
	movei	2,0400
	pushj	17,unpack_text_words
	move	2,-3(17)
	came	2,012
	 jrst	%L393
	movei	3,1
	movem	3,0(17)
	setz	4,
	movem	4,-1(17)
%L394:
	move	2,-1(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L395
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
	 jrst	%L396
	setzb	1,0(17)
	jrst	%L395
%L396:
	aos	1,-1(17)
	jrst	%L394
%L395:
	skipn	2,0(17)
	 jrst	%L397
	skipe	1,013
	 skipa	4,-5(17)
	 trna	
	 movem	4,0(13)
	movei	1,1
	jrst	%L386
%L397:
%L393:
	move	2,-3(17)
	move	1,-010(17)
	pushj	17,literal_image_words
	addb	1,-5(17)
	move	3,-2(17)
	addb	3,-6(17)
	aos	2,-4(17)
	jrst	%L387
%L388:
	setz	1,
%L386:
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
	 jrst	%L401
	movei	2,-0102(17)
	hrli	2,0331100
	move	11,2
	movem	1,-2(17)
%L401:
	move	2,-2(17)
	move	1,010
	move	3,2
	move	2,011
	setz	4,
	pushj	17,lit_find_text
	jumpn	1,%L399
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
	jumpe	1,%L403
	movei	1,05343
	pushj	17,das_native_die
%L403:
	aos	1,0776(10)
	move	3,-1(17)
	addb	3,0777(10)
	move	2,-2(17)
	move	1,011
	pushj	17,literal_image_words
	move	3,01000(10)
	add	3,1
	movem	3,01000(10)
%L399:
	move	10,-0206(17)
	move	11,-0205(17)
	move	12,-0204(17)
	SUB	17,[0207,,0207]
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
	 jrst	%L406
	move	2,011
	caie	2,4
	 skipa	3,011
	 trna	
	 sojn	3,%L405
%L406:
	setz	1,
	jrst	%L404
%L405:
	move	1,011
	caie	1,2
	 jrst	%L407
	move	1,010
	move	10,-1(17)
	move	11,0(17)
	SUB	17,[2,,2]
	jrst	text_total
%L407:
	move	1,010
	pushj	17,text_total
	move	2,01137(10)
	add	1,2
%L404:
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
	 jrst	%L409
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
%L409:
	move	1,010
	pushj	17,strlen
	movem	1,0(17)
%L410:
	skipn	2,0(17)
	 jrst	%L411
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
	jumpe	1,%L411
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
	jrst	%L410
%L411:
	move	2,0(17)
	tlc	2,0400000
	camge	2,[0400000000002]
	 jrst	%L412
	move	1,010
	ldb	3,1
	caie	3,0133
	 jrst	%L412
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
	 jrst	%L412
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
%L412:
%L408:
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
	 jrst	%L414
	ildb	6,3
	iori	6,040
	movem	6,0(17)
	caie	6,0144
	 jrst	%L415
	movei	4,012
	movem	4,-1(17)
	move	5,-3(17)
	ibp	5
	ibp	5
	movem	5,-3(17)
	jrst	%L414
%L415:
	move	2,0(17)
	caie	2,0157
	 jrst	%L416
	movei	1,010
	movem	1,-1(17)
	move	3,-3(17)
	ibp	3
	ibp	3
	movem	3,-3(17)
	jrst	%L414
%L416:
	move	2,0(17)
	caie	2,0170
	 jrst	%L417
	movei	1,020
	movem	1,-1(17)
	move	3,-3(17)
	ibp	3
	ibp	3
	movem	3,-3(17)
	jrst	%L414
%L417:
	move	2,0(17)
	caie	2,0142
	 jrst	%L418
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
	jrst	%L414
%L418:
	move	1,-3(17)
	ildb	2,1
	caige	2,060
	 jrst	%L414
	move	3,-3(17)
	ildb	4,3
	caig	4,067
	 skipa	5,[010]
	 trna	
	 movem	5,-1(17)
%L414:
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
	 jrst	%L419
	seto	1,
	jrst	%L413
%L419:
	move	2,-2(17)
	movem	2,0(10)
	setz	1,
%L413:
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
	 jrst	%L422
	move	3,016(10)
	jumpn	3,%L422
	move	4,017(10)
	camn	4,[015172605]
	 jrst	%L421
%L422:
	setz	1,
	jrst	%L420
%L421:
	skipe	2,024(10)
	 jrst	%L423
	setm	1,2
	jrst	%L420
%L423:
	move	2,020(10)
	movem	2,0(11)
	move	4,023(10)
	movem	4,-1(17)
	ibp	-1(17)
	ldb	1,4
	cain	1,0133
	 jrst	%L424
	setz	1,
	jrst	%L420
%L424:
	move	1,-1(17)
	pushj	17,skipws
	movem	1,-1(17)
	ldb	2,1
	cain	2,055
	 jrst	%L426
	movei	1,0(17)
	movei	6,-1(17)
	move	2,1
	move	1,6
	pushj	17,parse_expr_integer
	jumpn	1,%L426
	move	3,0(17)
	tlc	3,0400000
	camg	3,[0400000777777]
	 jrst	%L425
%L426:
	setz	1,
	jrst	%L420
%L425:
	move	1,-1(17)
	pushj	17,skipws
	movem	1,-1(17)
	move	3,1
	ibp	-1(17)
	ldb	1,3
	cain	1,0135
	 jrst	%L427
	setz	1,
	jrst	%L420
%L427:
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L428
	setz	1,
	jrst	%L420
%L428:
	move	2,0(17)
	movem	2,0(12)
	movei	1,1
%L420:
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
	 jrst	%L430
	move	3,0(10)
	move	1,01335(3)
	jumpn	1,%L430
	movei	1,05637
	pushj	17,das_native_diag
%L430:
	movei	1,1
	movem	1,5(10)
%L429:
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
%L431:
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
	 jrst	%L433
	skipn	3,-4(17)
	 jrst	%L432
%L433:
	move	2,-1(17)
	skipe	1,5(2)
	 jrst	%L434
	movei	1,05667
	pushj	17,das_native_diag
%L434:
	movei	1,1
	move	3,-1(17)
	movem	1,5(3)
	seto	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L432:
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
	 jrst	%L436
	move	1,010
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	jrst	das_mask36
%L436:
	move	1,011
	tlc	1,0400000
	camge	1,[0400000000044]
	 jrst	%L437
	tlnn	10,0400000
	 jrst	%L438
	move	1,[0777777777777]
	jrst	%L439
%L438:
	setz	1,
%L439:
	jrst	%L435
%L437:
	move	1,010
	and	1,[0400000000000]
	movem	1,-1(17)
	move	2,011
	move	3,010
	movn	2,2
	lsh	3,0(2)
	move	10,3
	jumpe	1,%L440
	move	7,[0777777777777]
	movn	5,011
	ash	7,0(5)
	eqvi	7,0
	movem	7,0(17)
	iorb	7,010
%L440:
	move	1,010
	move	10,-3(17)
	move	11,-2(17)
	SUB	17,[4,,4]
	jrst	das_mask36
%L435:
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
	 jrst	%L446
	movn	1,010
	pushj	17,das_mask36
	jrst	%L447
%L446:
	move	1,010
%L447:
	movem	1,-2(17)
	skipn	3,-3(17)
	 jrst	%L448
	movn	1,011
	pushj	17,das_mask36
	jrst	%L449
%L448:
	move	1,011
%L449:
	movem	1,-1(17)
	skipn	2,012
	 jrst	%L451
	move	4,-2(17)
	skipge	16,1
	 JRST	%UIDN6
	JUMPGE	4,%UIDP6
	CAIG	16,1
	 JRST	%UIDZ6
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
	 JRST	%UIDD6
	SUB	5,016
	AOJA	4,%UIDD6
%UIDN6:	MOVE	5,4
	MOVEI	4,0
	JUMPGE	5,%UIDD6
	CAMGE	5,016
	 JRST	%UIDD6
	SUB	5,016
	AOJA	4,%UIDD6
%UIDZ6:	TDZA	5,5
%UIDP6:	IDIV	4,016
%UIDD6:
	movem	5,0(17)
	skipn	6,-4(17)
	 jrst	%L450
	movn	1,0(17)
	pushj	17,das_mask36
	movem	1,0(17)
	jrst	%L450
%L451:
	move	2,-2(17)
	skipge	16,-1(17)
	 JRST	%UIDN7
	JUMPGE	2,%UIDP7
	CAIG	16,1
	 JRST	%UIDZ7
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
	 JRST	%UIDD7
	SUB	3,016
	AOJA	2,%UIDD7
%UIDN7:	MOVE	3,2
	MOVEI	2,0
	JUMPGE	3,%UIDD7
	CAMGE	3,016
	 JRST	%UIDD7
	SUB	3,016
	AOJA	2,%UIDD7
%UIDZ7:	TDZA	3,3
%UIDP7:	IDIV	2,016
%UIDD7:
	movem	2,0(17)
	move	3,-4(17)
	camn	3,-3(17)
	 jrst	%L450
	movn	1,0(17)
	pushj	17,das_mask36
	movem	1,0(17)
%L450:
	move	1,0(17)
%L441:
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
	move	2,[POINT 9,%L454,8]
	move	1,010
	movei	3,7
	pushj	17,pref_i
	jumpn	1,%L453
	setm	1,1
	jrst	%L452
%L453:
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
	 jrst	%L456
	caig	3,071
	 jrst	%L455
%L456:
	setz	1,
	jrst	%L452
%L455:
	movei	2,0(17)
	move	3,-2(17)
	move	1,3
	movei	3,012
	pushj	17,strtol
	movem	1,-1(17)
	ldb	2,0(17)
	jumpn	2,%L458
	skipn	5,1
	 jrst	%L458
	tlc	5,0400000
	camg	5,[0400000777777]
	 jrst	%L457
%L458:
	setz	1,
	jrst	%L452
%L457:
	move	1,-1(17)
%L452:
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,
%L454:
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
	 jrst	%L460
	movei	1,1
	jrst	%L459
%L460:
	movei	1,-013(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,set_snapshot_lookup
	jumpn	1,%L461
	setm	1,1
	jrst	%L459
%L461:
	move	2,011
	MOVEI	16,(2)
	HRLI	16,-013(17)
	BLT	16,13(2)
	movei	1,1
%L459:
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
	 jrst	%L463
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
	 jrst	%L464
	move	2,[POINT 9,%L465,8]
	move	1,010
	pushj	17,expr_error
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L464:
	ibp	2(10)
	move	1,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L463:
	move	2,2(10)
	ldb	1,2
	caie	1,056
	 jrst	%L466
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
	jumpe	1,%L466
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
%L467:
	ldb	1,-3(17)
	pushj	17,das_native_is_digit
	jumpe	1,%L468
	move	3,0(17)
	cail	3,047
	 jrst	%L468
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
	jrst	%L467
%L468:
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
	jumpn	1,%L469
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L470
	movei	1,06100
	pushj	17,das_native_diag
%L470:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L469:
	move	2,-017(17)
	andi	2,030
	caie	2,020
	 jrst	%L471
	hrrz	1,-016(17)
	jrst	%L472
%L471:
	movei	1,-015(17)
	hrli	1,0331100
	pushj	17,set_snapshot_generation
%L472:
	movem	1,-1(17)
	movei	1,-031(17)
	move	3,0(10)
	move	2,1
	move	1,3
	pushj	17,resolve_set_symbol
	jumpn	1,%L473
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L474
	movei	1,06112
	pushj	17,das_native_diag
%L474:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L473:
	move	2,-017(17)
	andi	2,7
	caie	2,4
	 jrst	%L476
	move	3,-016(17)
	movem	3,-033(17)
	jrst	%L475
%L476:
	move	2,-017(17)
	andi	2,7
	move	3,0(10)
	move	1,3
	pushj	17,sec_base
	add	1,-016(17)
	movem	1,-033(17)
%L475:
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
	jrst	%L462
%L466:
	move	2,2(10)
	ldb	1,2
	caie	1,056
	 jrst	%L479
	move	4,3(10)
	movem	4,-033(17)
	movei	3,1
	movem	3,-032(17)
	ibp	2(10)
	move	5,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L479:
	move	2,2(10)
	ldb	1,2
	pushj	17,das_native_is_digit
	jumpe	1,%L480
	move	3,2(10)
	movem	3,-3(17)
	move	2,4(10)
	movei	1,-2(17)
	movei	6,-3(17)
	move	3,2
	move	2,1
	move	1,6
	pushj	17,parse_expr_integer_base
	jumpe	1,%L481
	move	2,[POINT 9,%L482,8]
	move	1,010
	pushj	17,expr_error
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L481:
	move	2,-2(17)
	movem	2,-033(17)
	move	3,-3(17)
	movem	3,2(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L480:
	move	2,2(10)
	ldb	1,2
	pushj	17,isname0
	jumpe	1,%L483
	setzb	2,0(17)
%L484:
	move	2,2(10)
	ldb	1,2
	pushj	17,isname
	jumpe	1,%L485
	move	3,0(17)
	cail	3,047
	 jrst	%L485
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
	jrst	%L484
%L485:
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
	jumpn	1,%L486
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L487
	movei	1,06202
	pushj	17,das_native_diag
%L487:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L486:
	move	2,-017(17)
	andi	2,030
	caie	2,020
	 jrst	%L488
	hrrz	1,-016(17)
	jrst	%L489
%L488:
	movei	1,-015(17)
	hrli	1,0331100
	pushj	17,set_snapshot_generation
%L489:
	movem	1,-1(17)
	movei	1,-031(17)
	move	3,0(10)
	move	2,1
	move	1,3
	pushj	17,resolve_set_symbol
	jumpn	1,%L490
	move	3,0(10)
	skipe	2,01335(3)
	 jrst	%L491
	movei	1,06214
	pushj	17,das_native_diag
%L491:
	movei	1,1
	movem	1,5(10)
	move	1,-033(17)
	move	2,-032(17)
	jrst	%L462
%L490:
	move	2,-017(17)
	andi	2,7
	caie	2,4
	 jrst	%L493
	move	3,-016(17)
	movem	3,-033(17)
	jrst	%L492
%L493:
	move	2,-017(17)
	andi	2,7
	move	3,0(10)
	move	1,3
	pushj	17,sec_base
	add	1,-016(17)
	movem	1,-033(17)
%L492:
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
	jrst	%L462
%L483:
	move	2,[POINT 9,%L496,8]
	move	1,010
	pushj	17,expr_error
	move	1,-033(17)
	move	2,-032(17)
%L462:
	move	10,-034(17)
	move	16,-035(17)
	SUB	17,[036,,036]
	popj	17,
%L496:
	.byte	9,0155,0141,0154,0146
	.byte	9,0157,0162,0155,0145
	.byte	9,0144,040,0145,0170
	.byte	9,0160,0162,0145,0163
	.byte	9,0163,0151,0157,0156
	.byte	9,0
	

%L482:
	.byte	9,0155,0141,0154,0146
	.byte	9,0157,0162,0155,0145
	.byte	9,0144,040,0145,0170
	.byte	9,0160,0162,0145,0163
	.byte	9,0163,0151,0157,0156
	.byte	9,0
	

%L465:
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
	 jrst	%L499
	caie	4,0176
	 jrst	%L498
%L499:
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
	 jrst	%L501
	movn	1,-2(17)
	pushj	17,das_mask36
	movem	1,-2(17)
	movns	3,-1(17)
	jrst	%L500
%L501:
	move	2,0(17)
	caie	2,0176
	 jrst	%L500
	skipn	3,-1(17)
	 jrst	%L502
	skipe	4,5(10)
	 jrst	%L503
	movei	1,06265
	pushj	17,das_native_diag
%L503:
	movei	1,1
	movem	1,5(10)
%L502:
	setcm	1,-2(17)
	pushj	17,das_mask36
	movem	1,-2(17)
	setzb	2,-1(17)
%L500:
	move	1,-2(17)
	move	2,-1(17)
	jrst	%L497
%L498:
	move	1,010
	move	10,-3(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	jrst	parse_expr_primary
%L497:
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
	 jrst	%L505
	movei	1,1
	movem	1,0(2)
	movem	1,0(3)
	movem	1,0(4)
	jrst	%L504
%L505:
	move	5,1
	ldb	6,5
	caie	6,0136
	 jrst	%L506
	movei	7,2
	movem	7,0(2)
	movem	7,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L506:
	move	5,1
	ldb	6,5
	movei	7,046
	came	6,7
	 jrst	%L507
	movei	5,3
	movem	5,0(2)
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L507:
	move	5,1
	ldb	6,5
	movei	7,074
	came	6,7
	 jrst	%L508
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
	 jrst	%L508
	movei	5,4
	movem	5,0(2)
	movem	5,0(3)
	movei	5,2
	movem	5,0(4)
	movei	1,1
	jrst	%L504
%L508:
	move	5,1
	ldb	6,5
	caie	6,076
	 jrst	%L509
	ildb	7,5
	caie	7,076
	 jrst	%L509
	movei	5,5
	movem	5,0(2)
	movei	5,4
	movem	5,0(3)
	movei	5,2
	movem	5,0(4)
	movei	1,1
	jrst	%L504
%L509:
	move	5,1
	ldb	6,5
	caie	6,053
	 jrst	%L510
	movei	7,6
	movem	7,0(2)
	movei	5,5
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L510:
	move	5,1
	ldb	6,5
	caie	6,055
	 jrst	%L511
	movei	7,7
	movem	7,0(2)
	movei	5,5
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L511:
	move	5,1
	ldb	6,5
	caie	6,052
	 jrst	%L512
	movei	7,010
	movem	7,0(2)
	movei	5,6
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L512:
	move	5,1
	ldb	6,5
	movei	7,057
	came	6,7
	 jrst	%L513
	movei	5,011
	movem	5,0(2)
	movei	5,6
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L513:
	move	5,1
	ldb	6,5
	caie	6,045
	 jrst	%L514
	movei	7,012
	movem	7,0(2)
	movei	5,6
	movem	5,0(3)
	movei	1,1
	movem	1,0(4)
	jrst	%L504
%L514:
	setz	1,
%L504:
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
%L516:
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
	jumpe	1,%L519
	move	3,-1(17)
	caml	3,011
	 jrst	%L518
%L519:
	move	1,-010(17)
	move	2,-7(17)
	jrst	%L515
%L518:
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
	 jrst	%L520
	move	1,-6(17)
	add	1,-010(17)
	pushj	17,das_mask36
	movem	1,-010(17)
	move	4,-5(17)
	addb	4,-7(17)
	jrst	%L516
%L520:
	move	2,-2(17)
	caie	2,7
	 jrst	%L521
	move	1,-010(17)
	sub	1,-6(17)
	pushj	17,das_mask36
	movem	1,-010(17)
	movn	4,-5(17)
	addb	4,-7(17)
	jrst	%L516
%L521:
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
	jumpe	1,%L522
	move	1,-010(17)
	move	2,-7(17)
	jrst	%L515
%L522:
	move	3,-2(17)
	caie	3,011
	 cain	3,012
	 skipe	2,-6(17)
	 jrst	%L523
	move	2,[POINT 9,%L525,8]
	move	1,010
	pushj	17,expr_error
	move	1,-010(17)
	move	2,-7(17)
	jrst	%L515
%L523:
	move	2,-2(17)
	caie	2,010
	 jrst	%L527
	move	4,-6(17)
	mul	4,-010(17)
	trne	4,1
	 tloa	5,0400000
	 tlz	5,0400000
	move	1,5
	pushj	17,das_mask36
	movem	1,-010(17)
	jrst	%L526
%L527:
	move	3,-2(17)
	cail	3,011
	 caile	3,012
	 jrst	%L528
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
	jrst	%L526
%L528:
	move	3,-2(17)
	cail	3,4
	 caile	3,5
	 jrst	%L532
	move	2,-6(17)
	tlc	2,0400000
	camge	2,[0400000000044]
	 jrst	%L534
	movei	1,044
	jrst	%L535
%L534:
	move	1,-6(17)
%L535:
	movem	1,-3(17)
	move	3,-2(17)
	caie	3,4
	 jrst	%L536
	move	4,1
	tlc	4,0400000
	camge	4,[0400000000044]
	 jrst	%L537
	setz	1,
	jrst	%L538
%L537:
	move	1,-010(17)
	move	3,-3(17)
	lsh	1,0(3)
	pushj	17,das_mask36
%L538:
	movem	1,-010(17)
	jrst	%L526
%L536:
	move	2,-3(17)
	move	1,-010(17)
	pushj	17,expr_shift_right
	movem	1,-010(17)
	jrst	%L526
%L532:
	move	2,-2(17)
	caie	2,3
	 jrst	%L539
	move	4,-6(17)
	andb	4,-010(17)
	jrst	%L526
%L539:
	move	2,-2(17)
	caie	2,2
	 jrst	%L540
	move	4,-6(17)
	xorb	4,-010(17)
	jrst	%L526
%L540:
	move	3,-6(17)
	iorb	3,-010(17)
%L526:
	setzb	1,-7(17)
	jrst	%L516
%L515:
	move	10,-012(17)
	move	11,-011(17)
	move	16,-013(17)
	SUB	17,[014,,014]
	popj	17,
%L525:
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
%L541:
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
	jumpn	5,%L542
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
%L542:
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
	 jrst	%L543
	ldb	2,1
	jumpe	2,%L543
	move	1,[POINT 9,%L544,8]
	movei	6,-7(17)
	move	2,1
	move	1,6
	pushj	17,expr_error
%L543:
	skipn	2,-2(17)
	 skipn	4,0(17)
	 jrst	%L545
	soje	4,%L545
	move	3,-0112(17)
	skipe	1,01335(3)
	 jrst	%L546
	movei	1,06720
	pushj	17,das_native_diag
%L546:
	movei	1,1
	movem	1,-2(17)
%L545:
	skipn	2,-2(17)
	 jrst	%L547
	seto	1,
	move	16,-0110(17)
	SUB	17,[0111,,0111]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L547:
	move	1,-1(17)
	pushj	17,das_mask36
	move	3,-0116(17)
	movem	1,0(3)
	move	4,0(17)
	sojn	4,%L548
	movei	1,1
	jrst	%L549
%L548:
	setz	1,
%L549:
	move	3,-0117(17)
	movem	1,0(3)
	setz	1,
	move	16,-0110(17)
	SUB	17,[0111,,0111]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L544:
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

matching_rbracket:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[2,,2]
	skipn	1,010
	 jrst	%L552
	move	2,010
	ldb	3,2
	cain	3,0133
	 jrst	%L551
%L552:
	setz	1,
	jrst	%L550
%L551:
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
%L553:
	ldb	2,-1(17)
	jumpe	2,%L554
	caie	2,0133
	 jrst	%L556
	aos	1,0(17)
	jrst	%L555
%L556:
	ldb	1,-1(17)
	cain	1,0135
	 sose	4,0(17)
	 jrst	%L555
	move	1,-1(17)
	jrst	%L550
%L555:
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L553
%L554:
	setz	1,
%L550:
	move	10,-2(17)
	move	16,-3(17)
	SUB	17,[4,,4]
	popj	17,

byte_field_end:
	push	17,010
	move	10,1
	ADD	17,[3,,3]
	movem	10,-2(17)
	setz	2,
	movem	2,-1(17)
%L558:
	ldb	1,-2(17)
	jumpe	1,%L559
	caie	1,054
	 cain	1,050
	 jrst	%L559
	ldb	1,-2(17)
	pushj	17,das_native_is_space
	jumpe	1,%L560
	move	1,-2(17)
	pushj	17,skipws
	movem	1,0(17)
	ldb	3,1
	caie	3,053
	 cain	3,055
	 jrst	%L561
	move	5,-1(17)
	cain	5,053
	 jrst	%L561
	caie	5,055
	 jrst	%L559
%L561:
	move	2,0(17)
	movem	2,-2(17)
	jrst	%L558
%L560:
	ldb	1,-2(17)
	movem	1,-1(17)
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L558
%L559:
	move	1,-2(17)
%L557:
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
	move	1,[POINT 9,%L565,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L564
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
%L564:
	move	1,010
%L562:
	move	10,0(17)
	move	16,-1(17)
	SUB	17,[2,,2]
	popj	17,
%L565:
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
%L567:
	move	1,010
	ldb	2,1
	jumpe	2,%L568
	move	3,010
	ldb	4,3
	caie	4,050
	 jrst	%L570
	aos	5,-1(17)
	jrst	%L569
%L570:
	move	1,010
	ldb	2,1
	movei	3,051
	came	2,3
	 jrst	%L571
	skipe	5,-1(17)
	 jrst	%L572
	setm	1,5
	jrst	%L566
%L572:
	sos	1,-1(17)
	jrst	%L569
%L571:
	move	1,010
	ldb	2,1
	caie	2,0133
	 jrst	%L573
	aos	3,0(17)
	jrst	%L569
%L573:
	move	1,010
	ldb	2,1
	caie	2,0135
	 jrst	%L574
	skipe	4,0(17)
	 jrst	%L575
	setm	1,4
	jrst	%L566
%L575:
	sos	1,0(17)
	jrst	%L569
%L574:
	move	1,010
	ldb	2,1
	cain	2,054
	 skipe	4,-1(17)
	 jrst	%L569
	skipe	5,0(17)
	 jrst	%L569
	move	1,010
	jrst	%L566
%L569:
	ibp	010
	jrst	%L567
%L568:
	skipe	2,-1(17)
	 jrst	%L577
	skipn	3,0(17)
	 jrst	%L576
%L577:
	setz	1,
	jrst	%L566
%L576:
	move	1,010
%L566:
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
	jumpn	2,%L579
	seto	1,
	jrst	%L578
%L579:
	setzb	1,0(17)
%L580:
	move	1,-2(17)
	pushj	17,long_field_end
	movem	1,-1(17)
	jumpn	1,%L582
	seto	1,
	jrst	%L578
%L582:
	aos	1,0(17)
	ldb	2,-1(17)
	jumpe	2,%L578
	move	3,-1(17)
	ibp	3
	movem	3,-2(17)
	jrst	%L580
%L578:
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
	 jrst	%L584
	ibp	-6(17)
	move	3,-6(17)
%L584:
	move	2,[POINT 9,%L586,8]
	move	3,-6(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L585
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
%L585:
	move	2,-6(17)
	movem	2,-2(17)
%L587:
	ldb	2,-2(17)
	jumpe	2,%L588
	cain	2,054
	 jrst	%L588
	ldb	1,-2(17)
	pushj	17,das_native_is_space
	jumpn	1,%L588
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L587
%L588:
	move	2,-2(17)
	came	2,-6(17)
	 jrst	%L589
	seto	1,
	move	16,-3(17)
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L589:
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
	 jumpe	1,%L590
	ldb	4,[POINT 9,-1(17),35]
	dpb	4,-2(17)
	seto	1,
	move	16,-3(17)
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L590:
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
	 jrst	%L592
	ibp	-6(17)
	move	3,-6(17)
%L592:
	move	2,-6(17)
	move	3,-010(17)
	movem	2,0(3)
	setz	1,
	move	16,-3(17)
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L586:
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
	 jrst	%L594
	movem	1,0(11)
	setz	1,
	jrst	%L593
%L594:
	ibp	-3(17)
	move	1,-3(17)
	move	1,-3(17)
	movei	2,051
	pushj	17,strchr
	movem	1,-2(17)
	jumpn	1,%L595
	seto	1,
	jrst	%L593
%L595:
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
	 jumpe	1,%L596
	ldb	4,[POINT 9,-1(17),35]
	dpb	4,-2(17)
	seto	1,
	jrst	%L593
%L596:
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
%L593:
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
	jumpe	1,%L599
	seto	1,
	jrst	%L598
%L599:
%L600:
	move	1,-4(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L601
	move	1,-4(17)
	pushj	17,skipws
	movem	1,-4(17)
	ldb	2,1
	caie	2,054
	 jrst	%L602
	ibp	-4(17)
	move	3,-4(17)
	jrst	%L600
%L602:
	movei	1,-2(17)
	move	3,0(17)
	add	3,012
	movei	2,-4(17)
	move	4,1
	move	1,010
	pushj	17,byte_size_prefix
	jumpe	1,%L603
	seto	1,
	jrst	%L598
%L603:
	move	1,-4(17)
	pushj	17,byte_field_end
	movem	1,-3(17)
	camn	1,-4(17)
	 jrst	%L601
	move	3,-1(17)
	add	3,-2(17)
	caig	3,044
	 jrst	%L604
	aos	2,0(17)
	setz	4,
	movem	4,-1(17)
%L604:
	move	3,-2(17)
	addb	3,-1(17)
	caie	3,044
	 jrst	%L605
	aos	1,0(17)
	setz	2,
	movem	2,-1(17)
%L605:
	move	2,-3(17)
	movem	2,-4(17)
	jrst	%L600
%L601:
	skipe	2,-1(17)
	 jrst	%L607
	skipe	3,0(17)
	 jrst	%L606
%L607:
	aos	1,0(17)
%L606:
	move	1,0(17)
%L598:
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
	jumpn	2,%L609
	seto	1,
	jrst	%L608
%L609:
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
	jumpn	1,%L610
	seto	1,
	jrst	%L608
%L610:
	move	2,0(17)
	move	1,-1(17)
	pushj	17,char_distance
	movem	1,0(11)
	setz	1,
%L608:
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
	 jrst	%L612
	ibp	-1(17)
	move	3,-1(17)
%L612:
	move	2,[POINT 9,%L615,8]
	move	3,-1(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L614
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
	jrst	%L613
%L614:
	move	2,[POINT 9,%L616,8]
	move	3,-1(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L613
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
%L613:
	movei	2,0(17)
	move	3,-1(17)
	move	1,3
	pushj	17,delimited_text_len
	jumpe	1,%L617
	seto	1,
	jrst	%L611
%L617:
	skipe	1,011
	 aos	2,0(17)
	skiple	4,0(17)
	 jrst	%L619
	movei	1,1
	jrst	%L611
%L619:
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
%L611:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,
%L616:
	.byte	9,0101,0123,0103,0111
	.byte	9,0111,0
	

%L615:
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
	 jrst	%L621
	ibp	-1(17)
	move	3,-1(17)
%L621:
	move	2,[POINT 9,%L623,8]
	move	3,-1(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L622
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
%L622:
	movei	2,0(17)
	move	3,-1(17)
	move	1,3
	pushj	17,delimited_text_len
	jumpe	1,%L624
	seto	1,
	jrst	%L620
%L624:
	skiple	2,0(17)
	 jrst	%L625
	movei	1,1
	jrst	%L620
%L625:
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
%L620:
	move	10,-2(17)
	move	16,-3(17)
	SUB	17,[4,,4]
	popj	17,
%L623:
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
	jumpn	1,%L627
	skipe	3,0(17)
	 jrst	%L627
	move	4,-1(17)
	tlc	4,0400000
	move	5,-6(17)
	tlc	5,0400000
	camg	4,5
	 jrst	%L626
%L627:
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L626:
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
	jumpe	1,%L628
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L628:
	move	2,-1(17)
	tlc	2,0400000
	camle	2,[0400000000002]
	 jrst	%L629
	move	4,-7(17)
	setzb	1,0(4)
	setm	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L629:
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
	jumpe	1,%L630
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L630:
	skipe	2,0(17)
	 jrst	%L632
	move	3,-1(17)
	tlc	3,0400000
	camg	3,[0400000777777]
	 jrst	%L631
%L632:
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L631:
	move	2,-1(17)
	move	3,-7(17)
	movem	2,0(3)
	move	4,-7(17)
	move	1,0(4)
	tlc	1,0400000
	move	6,-6(17)
	tlc	6,0400000
	caml	1,6
	 jrst	%L633
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L633:
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
	 jrst	%L635
	jrst	@%L646(2)
%L646:
	setz	%L645
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L637
	setz	%L638
	setz	%L639
	setz	%L639
	setz	%L640
	setz	%L641
	setz	%L642
	setz	%L643
	setz	%L645
	setz	%L645
	setz	%L644
	setz	%L645
	setz	%L645
	setz	%L645
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
	setz	%L636
%L636:
	setz	1,
	jrst	%L634
%L637:
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
	jumpn	1,%L648
	skipe	3,-1(17)
	 jrst	%L648
	move	4,-2(17)
	tlc	4,0400000
	camg	4,[0400000777777]
	 jrst	%L647
%L648:
	seto	1,
	jrst	%L634
%L647:
	move	1,-2(17)
	jrst	%L634
%L638:
	movei	1,0(17)
	push	17,1
	move	3,3(11)
	move	1,010
	move	2,3
	move	3,012
	move	4,[03777774]
	pushj	17,eval_abs_u
	SUB	17,[1,,1]
	jumpe	1,%L649
	seto	1,
	jrst	%L634
%L649:
	move	1,0(17)
	addi	1,3
	lsh	1,-2
	jrst	%L634
%L639:
	setz	1,
	jrst	%L634
%L640:
	move	2,2(11)
	move	1,010
	move	3,012
	pushj	17,byte_word_count
	jrst	%L634
%L641:
	move	2,2(11)
	move	1,2
	setz	2,
	pushj	17,ascii_word_count
	jrst	%L634
%L642:
	move	2,2(11)
	move	1,2
	movei	2,1
	pushj	17,ascii_word_count
	jrst	%L634
%L643:
	move	2,2(11)
	move	1,2
	pushj	17,sixbit_word_count
	jrst	%L634
%L644:
	move	2,2(11)
	move	1,2
	pushj	17,long_word_count
	jrst	%L634
%L645:
	movei	1,1
	jrst	%L634
%L635:
	movei	1,1
%L634:
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
%L651:
	move	1,-1(17)
	movei	2,0133
	pushj	17,strchr
	movem	1,-1(17)
	jumpe	1,%L652
	move	1,-1(17)
	pushj	17,matching_rbracket
	movem	1,0(17)
	jumpe	1,%L650
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
	jrst	%L651
%L652:
%L650:
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
	move	1,[POINT 9,%L659,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpn	1,%L658
	move	1,[POINT 9,%L660,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L657
%L658:
	movei	1,1
	jrst	%L654
%L657:
	move	1,[POINT 9,%L663,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,pref_i
	jumpn	1,%L662
	move	1,[POINT 9,%L664,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,6
	pushj	17,pref_i
	jumpn	1,%L662
	move	1,[POINT 9,%L665,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L661
%L662:
	movei	1,2
	jrst	%L654
%L661:
	move	1,[POINT 9,%L667,8]
	move	2,010
	move	6,2
	move	2,1
	move	1,6
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L666
	movei	1,3
	jrst	%L654
%L666:
	move	1,011
%L654:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L667:
	.byte	9,0102,0123,0123,0
	

%L665:
	.byte	9,0103,0117,0116,0123
	.byte	9,0124,0
	

%L664:
	.byte	9,0122,0117,0104,0101
	.byte	9,0124,0101,0
	

%L663:
	.byte	9,0104,0101,0124,0101
	.byte	9,0
	

%L660:
	.byte	9,0103,0117,0104,0105
	.byte	9,0
	

%L659:
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
	jumpe	1,%L669
	setz	2,
	dpb	2,1
%L669:
	move	1,011
	pushj	17,rtrim
	move	1,011
	pushj	17,skipws
	movem	1,-010(17)
	ldb	2,1
	jumpn	2,%L670
	setm	1,2
	jrst	%L668
%L670:
	move	1,-010(17)
	movei	2,072
	pushj	17,strchr
	movem	1,-7(17)
	jumpe	1,%L671
	move	2,-7(17)
	move	1,-010(17)
	pushj	17,char_distance
	movem	1,-5(17)
%L672:
	skipn	2,-5(17)
	 jrst	%L673
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
	jumpe	1,%L673
	sos	2,-5(17)
	jrst	%L672
%L673:
	move	2,-010(17)
	movem	2,0(12)
	move	3,-5(17)
	movem	3,1(12)
	move	1,-7(17)
	ibp	1
	pushj	17,skipws
	movem	1,-010(17)
	ldb	2,1
	jumpn	2,%L671
	movei	1,1
	jrst	%L668
%L671:
	move	2,-010(17)
	movem	2,2(12)
	movem	2,-6(17)
	ldb	1,2
	caie	1,056
	 jrst	%L674
	movei	3,1
	movem	3,030(12)
	ibp	-6(17)
	move	4,-6(17)
%L674:
	setz	1,
	movem	1,-4(17)
%L675:
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
	jumpe	1,%L676
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
	jumpn	1,%L676
	move	3,-4(17)
	tlc	3,0400000
	caml	3,[0400000000047]
	 jrst	%L676
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
	jrst	%L675
%L676:
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
	 jrst	%L677
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
	jumpe	1,%L678
	ldb	2,-3(17)
	caie	2,054
	 jrst	%L678
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
	jumpe	1,%L679
	ldb	2,-2(17)
	jumpn	2,%L679
	movei	3,1
	movem	3,025(12)
%L679:
	move	3,023(12)
	movem	3,-1(17)
	ldb	1,3
	caie	1,055
	 tdza	2,2
	 movei	2,1
	movem	2,027(12)
	ldb	5,-1(17)
	cain	5,055
	 jrst	%L683
	caie	5,053
	 jrst	%L682
%L683:
	ibp	-1(17)
	move	1,-1(17)
%L682:
	movei	1,0(17)
	movei	6,-1(17)
	move	2,1
	move	1,6
	pushj	17,parse_expr_integer
	jumpn	1,%L684
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpn	2,%L684
	movei	1,1
	movem	1,026(12)
	move	4,0(17)
	movem	4,022(12)
%L684:
%L678:
%L677:
	aos	1,01144(10)
	movei	1,1
%L668:
	move	10,-013(17)
	move	11,-012(17)
	move	12,-011(17)
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,

cond_active:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	skipe	2,0(10)
	 jrst	%L686
	movei	1,1
	jrst	%L685
%L686:
	movei	1,1
	move	3,0(10)
	subi	3,1
	lsh	1,0(3)
	move	5,1(10)
	and	5,1
	cain	5,0
	 tdza	1,1
	 movei	1,1
%L685:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

conditional_prefix:
	push	17,016
	push	17,010
	move	10,1
	push	17,010
%L690:
	ldb	1,0(17)
	jumpe	1,%L691
	ldb	1,0(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L691
	ibp	0(17)
	move	2,0(17)
	jrst	%L690
%L691:
	ldb	1,0(17)
	caie	1,056
	 jrst	%L692
	ibp	0(17)
	move	2,0(17)
%L692:
	move	2,[POINT 9,%L694,8]
	move	3,0(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L693
	movei	2,5
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
	ldb	3,2
	jumpe	3,%L695
	movei	1,5
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
	jumpe	1,%L693
%L695:
	movei	1,1
	jrst	%L689
%L693:
	move	2,[POINT 9,%L697,8]
	move	3,0(17)
	move	1,3
	movei	3,6
	pushj	17,pref_i
	jumpe	1,%L696
	movei	2,6
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
	ldb	3,2
	jumpe	3,%L698
	movei	1,6
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
	jumpe	1,%L696
%L698:
	movei	1,1
	jrst	%L689
%L696:
	move	2,[POINT 9,%L700,8]
	move	3,0(17)
	move	1,3
	movei	3,2
	pushj	17,pref_i
	jumpe	1,%L699
	move	2,0(17)
	ibp	2
	ildb	3,2
	jumpe	3,%L701
	move	1,0(17)
	ibp	1
	ildb	1,1
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L699
%L701:
	movei	1,1
	jrst	%L689
%L699:
	move	2,[POINT 9,%L703,8]
	move	3,0(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L702
	movei	2,4
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
	ldb	3,2
	jumpe	3,%L704
	movei	1,4
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
	jumpe	1,%L702
%L704:
	movei	1,1
	jrst	%L689
%L702:
	move	2,[POINT 9,%L706,8]
	move	3,0(17)
	move	1,3
	movei	3,5
	pushj	17,pref_i
	jumpe	1,%L705
	movei	2,5
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
	ldb	3,2
	jumpe	3,%L707
	movei	1,5
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
	jumpe	1,%L705
%L707:
	movei	1,1
	jrst	%L689
%L705:
	setz	1,
%L689:
	move	10,-1(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L706:
	.byte	9,0105,0116,0104,0111
	.byte	9,0106,0
	

%L703:
	.byte	9,0105,0114,0123,0105
	.byte	9,0
	

%L700:
	.byte	9,0111,0106,0
	

%L697:
	.byte	9,0111,0106,0116,0104
	.byte	9,0105,0106,0
	

%L694:
	.byte	9,0111,0106,0104,0105
	.byte	9,0106,0
	


conditional_symbol_arg:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,010
	pushj	17,skipws
	movem	1,-1(17)
	ldb	1,-1(17)
	pushj	17,isname0
	jumpn	1,%L709
	seto	1,
	jrst	%L708
%L709:
	setzb	1,0(17)
%L710:
	ldb	1,-1(17)
	pushj	17,isname
	jumpe	1,%L711
	move	3,0(17)
	addi	3,1
	tlc	3,0400000
	move	2,012
	tlc	2,0400000
	camge	3,2
	 jrst	%L712
	seto	1,
	jrst	%L708
%L712:
	move	2,-1(17)
	ibp	-1(17)
	ldb	1,2
	aos	2,0(17)
	subi	2,1
	move	3,011
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
	dpb	1,2
	jrst	%L710
%L711:
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
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpn	2,%L713
	setm	1,2
	jrst	%L714
%L713:
	seto	1,
%L714:
%L708:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	popj	17,

conditional_line:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[050,,050]
	move	3,-056(17)
	setzb	1,0(3)
	move	1,-053(17)
	pushj	17,conditional_prefix
	jumpn	1,%L715
	setm	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L715:
	movei	1,-047(17)
	move	2,-053(17)
	move	4,-052(17)
	move	3,1
	move	1,4
	pushj	17,parse_line_head
	skipe	3,-045(17)
	 jumpn	1,%L716
	setz	1,
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L716:
	move	1,[POINT 9,%L719,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L718
	move	1,[POINT 9,%L720,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L718
	move	1,[POINT 9,%L721,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L718
	move	1,[POINT 9,%L722,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L718
	move	1,[POINT 9,%L723,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L718
	setm	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L718:
	movei	1,1
	move	3,-056(17)
	movem	1,0(3)
	skipn	4,-047(17)
	 jrst	%L724
	movei	1,010133
	pushj	17,das_native_diag
	movei	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L724:
	move	1,[POINT 9,%L727,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L726
	move	1,[POINT 9,%L728,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L726
	move	1,[POINT 9,%L729,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L725
%L726:
	move	2,-054(17)
	move	1,0(2)
	tlc	1,0400000
	caml	1,[0400000000022]
	 jrst	%L731
	move	1,-044(17)
	pushj	17,skipws
	ldb	2,1
	jumpn	2,%L730
%L731:
	movei	1,010143
	pushj	17,das_native_diag
	movei	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L730:
	move	1,-054(17)
	pushj	17,cond_active
	movem	1,-2(17)
	movei	6,1
	move	7,-054(17)
	move	3,0(7)
	lsh	6,0(3)
	movem	6,-016(17)
	setcm	2,6
	andb	2,1(7)
	setcm	4,-016(17)
	move	1,-054(17)
	andb	4,2(1)
	move	1,[POINT 9,%L734,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L733
	skipn	3,-2(17)
	 jrst	%L732
	movei	1,-1(17)
	push	17,1
	movei	2,-016(17)
	move	4,-056(17)
	move	5,-045(17)
	move	1,-053(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,eval_expr
	SUB	17,[1,,1]
	skipn	3,-1(17)
	 jumpe	1,%L735
	movei	1,010157
	pushj	17,das_native_diag
	movei	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L735:
	skipn	2,-015(17)
	 jrst	%L732
	move	3,-016(17)
	move	4,-054(17)
	iorb	3,1(4)
	jrst	%L732
%L733:
	movei	2,-014(17)
	hrli	2,0331100
	move	3,-044(17)
	move	1,3
	movei	3,050
	pushj	17,conditional_symbol_arg
	jumpe	1,%L737
	movei	1,010172
	pushj	17,das_native_diag
	movei	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L737:
	skipn	2,-2(17)
	 jrst	%L732
	movei	2,-014(17)
	hrli	2,0331100
	move	3,-052(17)
	move	1,3
	pushj	17,symbol_visible_here
	movem	1,0(17)
	move	1,[POINT 9,%L739,8]
	movei	2,-043(17)
	hrli	2,0331100
	move	6,2
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L738
	skipe	3,0(17)
	 tdza	2,2
	 movei	2,1
	movem	2,0(17)
%L738:
	skipn	2,0(17)
	 jrst	%L742
	move	3,-016(17)
	move	4,-054(17)
	iorb	3,1(4)
%L742:
%L732:
	move	3,-054(17)
	aos	1,0(3)
	setz	1,
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L725:
	move	1,-044(17)
	pushj	17,skipws
	ldb	2,1
	jumpn	2,%L744
	move	3,-054(17)
	skipe	1,0(3)
	 jrst	%L743
%L744:
	movei	1,010214
	pushj	17,das_native_diag
	movei	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L743:
	movei	1,1
	move	3,-054(17)
	move	2,0(3)
	lsh	1,-1(2)
	movem	1,-016(17)
	move	1,[POINT 9,%L746,8]
	movei	6,-043(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L745
	move	3,-054(17)
	move	2,2(3)
	and	2,-016(17)
	jumpe	2,%L747
	movei	1,010223
	pushj	17,das_native_diag
	movei	1,1
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L747:
	move	2,-016(17)
	move	3,-054(17)
	iorb	2,2(3)
	move	4,-054(17)
	move	1,0(4)
	sojn	1,%L749
	movei	5,1
	movem	5,-2(17)
	jrst	%L748
%L749:
	move	5,-054(17)
	move	1,1(5)
	movei	3,1
	move	2,0(5)
	lsh	3,-2(2)
	and	1,3
	cain	1,0
	 tdza	4,4
	 movei	4,1
	movem	4,-2(17)
%L748:
	skipn	2,-2(17)
	 jrst	%L753
	move	3,-016(17)
	move	4,-054(17)
	xorb	3,1(4)
	jrst	%L752
%L753:
	setcm	1,-016(17)
	move	4,-054(17)
	andb	1,1(4)
%L752:
	setz	1,
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L745:
	move	3,-054(17)
	sos	1,0(3)
	setcm	2,-016(17)
	move	6,-054(17)
	andb	2,1(6)
	setcm	4,-016(17)
	move	1,-054(17)
	andb	4,2(1)
	setz	1,
	move	16,-050(17)
	SUB	17,[051,,051]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L746:
	.byte	9,0105,0114,0123,0105
	.byte	9,0
	

%L739:
	.byte	9,0111,0106,0116,0104
	.byte	9,0105,0106,0
	

%L734:
	.byte	9,0111,0106,0
	

%L729:
	.byte	9,0111,0106,0116,0104
	.byte	9,0105,0106,0
	

%L728:
	.byte	9,0111,0106,0104,0105
	.byte	9,0106,0
	

%L727:
	.byte	9,0111,0106,0
	

%L723:
	.byte	9,0105,0116,0104,0111
	.byte	9,0106,0
	

%L722:
	.byte	9,0105,0114,0123,0105
	.byte	9,0
	

%L721:
	.byte	9,0111,0106,0116,0104
	.byte	9,0105,0106,0
	

%L720:
	.byte	9,0111,0106,0104,0105
	.byte	9,0106,0
	

%L719:
	.byte	9,0111,0106,0
	


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
%L755:
	move	2,0(17)
	move	4,010
	add	4,0(17)
	movem	2,01147(4)
	aos	5,0(17)
	tlc	5,0400000
	camge	5,[0400000000020]
	 jrst	%L755
%L754:
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
%L759:
	ldb	1,-2(17)
	jumpe	1,%L760
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L760
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L759
%L760:
	setz	1,
	movem	1,-1(17)
	setm	2,1
	movem	2,0(17)
%L761:
	ldb	1,-2(17)
	cail	1,060
	 caile	1,067
	 jrst	%L762
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
	 jrst	%L763
	setz	1,
	jrst	%L758
%L763:
	ibp	-2(17)
	move	1,-2(17)
	jrst	%L761
%L762:
	skipe	2,0(17)
	 jrst	%L764
	setm	1,2
	jrst	%L758
%L764:
%L765:
	ldb	1,-2(17)
	jumpe	1,%L766
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L766
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L765
%L766:
	move	2,-2(17)
	movem	2,0(10)
	move	3,-1(17)
	movem	3,0(11)
	movei	1,1
%L758:
	move	10,-4(17)
	move	11,-3(17)
	SUB	17,[5,,5]
	popj	17,

opt_reg_pair:
	skipn	6,016(1)
	 skipn	7,024(1)
	 jrst	%L768
	move	6,025(1)
	jumpn	6,%L767
%L768:
	setz	1,
	popj	17,
%L767:
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
	 jrst	%L770
	move	6,026(1)
	jumpn	6,%L769
%L770:
	setz	1,
	popj	17,
%L769:
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
	 jrst	%L772
	skipe	3,026(5)
	 jrst	%L771
%L772:
	setz	1,
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L771:
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
	jumpe	1,%L775
	move	3,0(17)
	came	3,[015172605]
%L775:
	 tdza	1,1
	 movei	1,1
%L773:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

opt_any_movei:
	skipe	4,016(1)
	 jrst	%L777
	move	5,017(1)
	move	3,[01517260511]
	camn	5,3
	 jrst	%L776
%L777:
	setz	1,
	popj	17,
%L776:
	move	4,024(1)
	jumpn	4,%L778
	setm	1,4
	popj	17,
%L778:
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
	jumpe	1,%L783
	move	3,-1(17)
	came	3,[01517260511]
	 jrst	%L783
	move	4,0(17)
	tlc	4,0400000
	camg	4,[0400000777777]
	 jrst	%L782
%L783:
	setz	1,
	jrst	%L781
%L782:
	move	2,0(17)
	movem	2,0(12)
	movei	1,1
%L781:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

opt_direct_setz:
	skipe	4,016(1)
	 jrst	%L785
	move	5,017(1)
	move	3,[023052432]
	camn	5,3
	 skipn	7,024(1)
	 jrst	%L785
	move	3,023(1)
	setm	6,4
	camn	3,6
	 jrst	%L785
	move	4,023(1)
	ldb	3,4
	jumpe	3,%L784
%L785:
	setz	1,
	popj	17,
%L784:
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
	 jrst	%L788
	skipn	4,01167(10)
	 jrst	%L788
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
	jumpe	1,%L788
	move	3,-1(17)
	move	4,01170(10)
	camn	3,4
	 jrst	%L787
%L788:
	setz	1,
	jrst	%L786
%L787:
	move	2,-2(17)
	came	2,[01160411]
	 jrst	%L789
	skipe	3,0(17)
	 jrst	%L791
	move	4,-3(17)
	cain	4,0777777
	 jrst	%L790
%L791:
	setz	1,
	jrst	%L786
%L790:
	movei	1,3
	jrst	%L786
%L789:
	move	2,-2(17)
	caie	2,0142310
	 jrst	%L793
	move	3,-3(17)
	cain	3,022
	 jrst	%L792
%L793:
	setz	1,
	jrst	%L786
%L792:
	skipn	2,0(17)
	 jrst	%L794
	movei	1,1
	jrst	%L795
%L794:
	movei	1,2
%L795:
%L786:
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
%L797:
	ldb	2,-2(17)
	jumpe	2,%L798
	caie	2,056
	 jrst	%L799
	move	3,-2(17)
	camn	3,010
	 jrst	%L801
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
	jumpn	1,%L800
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
	 jrst	%L800
	caie	4,056
%L801:
	 tdza	2,2
%L800:
	 movei	2,1
	movem	2,-1(17)
	move	1,-2(17)
	ildb	1,1
	andi	1,0777
	pushj	17,das_native_is_alnum
	jumpn	1,%L803
	move	2,-2(17)
	ildb	3,2
	cain	3,0137
	 jrst	%L803
	move	4,-2(17)
	ildb	5,4
	movei	6,044
	camn	5,6
	 jrst	%L803
	move	7,-2(17)
	ildb	1,7
	cain	1,056
%L803:
	 skipa	1,[1]
	 setz	1,
	movem	1,0(17)
	skipn	3,-1(17)
	 caie	1,0
	 jrst	%L804
	movei	1,1
	jrst	%L796
%L804:
%L799:
	ibp	-2(17)
	move	1,-2(17)
	jrst	%L797
%L798:
	setz	1,
%L796:
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
	jumpe	1,%L806
	setz	1,
	jrst	%L805
%L806:
	movem	10,0(17)
%L807:
	ldb	1,0(17)
	jumpe	1,%L808
	caie	1,0100
	 cain	1,050
	 jrst	%L810
	caie	1,051
	 cain	1,0133
	 jrst	%L810
	caie	1,0135
	 jrst	%L809
%L810:
	setz	1,
	jrst	%L805
%L809:
	ibp	0(17)
	move	1,0(17)
	jrst	%L807
%L808:
	movei	1,1
%L805:
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
	 jrst	%L811
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L811:
	move	2,-6(17)
	move	4,017(2)
	movem	4,0(17)
	came	4,[015172605]
	 jrst	%L813
	movei	1,1
	move	5,-7(17)
	movem	1,0(5)
	jrst	%L812
%L813:
	move	2,0(17)
	came	2,[01517260515]
	 jrst	%L814
	movei	1,2
	move	4,-7(17)
	movem	1,0(4)
	jrst	%L812
%L814:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L812:
	move	2,-6(17)
	skipe	1,024(2)
	 jrst	%L815
	setm	1,1
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L815:
	move	5,-6(17)
	move	1,020(5)
	move	4,-010(17)
	movem	1,0(4)
	move	6,023(5)
	movem	6,-3(17)
	ldb	2,6
	jumpe	2,%L817
	move	1,-3(17)
	pushj	17,opt_mem_ea_is_direct
	jumpn	1,%L816
%L817:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L816:
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
%L818:
	move	2,-2(17)
	camn	2,-3(17)
	 jrst	%L819
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
	jumpe	1,%L819
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
	jrst	%L818
%L819:
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
	 jrst	%L821
	tlc	3,0400000
	move	2,-012(17)
	tlc	2,0400000
	camge	3,2
	 jrst	%L820
%L821:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L820:
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
	 jrst	%L824
	move	4,01214(10)
	soje	4,%L825
	move	5,01214(10)
	caie	5,2
	 jrst	%L824
%L825:
	skipn	2,016(11)
	 jrst	%L823
%L824:
	setz	1,
	jrst	%L822
%L823:
	move	2,01214(10)
	sojn	2,%L827
	move	3,017(11)
	camn	3,[015172605]
	 jrst	%L826
	setm	1,2
	jrst	%L822
%L827:
	move	2,017(11)
	camn	2,[01517260515]
	 jrst	%L826
	move	3,017(11)
	camn	3,[015172605]
	 jrst	%L826
	setz	1,
	jrst	%L822
%L826:
	skipn	2,024(11)
	 jrst	%L829
	move	3,020(11)
	move	4,01215(10)
	camn	3,4
	 jrst	%L828
%L829:
	setz	1,
	jrst	%L822
%L828:
	move	3,023(11)
	movem	3,-1(17)
	ldb	1,3
	jumpe	1,%L831
	move	1,-1(17)
	pushj	17,opt_mem_ea_is_direct
	jumpn	1,%L830
%L831:
	setz	1,
	jrst	%L822
%L830:
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
%L832:
	move	2,0(17)
	camn	2,-1(17)
	 jrst	%L833
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
	jumpe	1,%L833
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
	jrst	%L832
%L833:
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
%L822:
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
	 jrst	%L837
	skipn	3,024(6)
	 jrst	%L837
	move	4,023(6)
	setm	5,2
	came	4,5
	 jrst	%L836
%L837:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L836:
	move	2,-6(17)
	move	1,017(2)
	setz	2,
	pushj	17,lookup_op_mn
	movem	1,0(17)
	cail	1,0321
	 caile	1,0327
	 jrst	%L839
	caie	1,0324
	 jrst	%L838
%L839:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L838:
	move	2,-6(17)
	move	1,023(2)
	pushj	17,skipws
	movem	1,-3(17)
	ldb	1,-3(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L840
	setm	1,1
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L840:
	move	1,-3(17)
	ibp	1
	movem	1,-2(17)
%L841:
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L842
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L841
%L842:
	move	1,-2(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L843
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L843:
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
	 jrst	%L845
	tlc	3,0400000
	move	2,-010(17)
	tlc	2,0400000
	camge	3,2
	 jrst	%L844
%L845:
	setz	1,
	move	16,-4(17)
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L844:
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
	 jrst	%L848
	move	4,017(10)
	camn	4,[012222324]
	 jrst	%L847
%L848:
	setz	1,
	jrst	%L846
%L847:
	move	2,3(10)
	move	1,2
	pushj	17,skipws
	movem	1,-2(17)
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L849
	setm	1,1
	jrst	%L846
%L849:
	move	1,-2(17)
	ibp	1
	movem	1,-1(17)
%L850:
	ldb	1,-1(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L851
	ibp	-1(17)
	move	2,-1(17)
	jrst	%L850
%L851:
	move	1,-1(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L852
	setz	1,
	jrst	%L846
%L852:
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
	 jrst	%L854
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camge	3,1
	 jrst	%L853
%L854:
	setz	1,
	jrst	%L846
%L853:
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
%L846:
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
	 jrst	%L856
	setm	1,2
	jrst	%L855
%L856:
	move	3,1(1)
	movem	3,0(17)
	jumpe	3,%L858
	tlc	3,0400000
	camg	3,[0400000000047]
	 jrst	%L857
%L858:
	setz	1,
	jrst	%L855
%L857:
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
%L855:
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
	 jrst	%L861
	move	3,01214(10)
	caie	3,3
	 jrst	%L861
	move	2,010
	addi	2,01216
	hrli	2,0331100
	move	1,011
	pushj	17,opt_label_is
	cain	1,0
%L861:
	 tdza	1,1
	 movei	1,1
%L859:
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
	 jrst	%L864
	move	3,01214(10)
	caie	3,5
	 jrst	%L864
	move	2,010
	addi	2,01216
	hrli	2,0331100
	move	1,011
	pushj	17,opt_label_is
	cain	1,0
%L864:
	 tdza	1,1
	 movei	1,1
%L862:
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
	 jrst	%L867
	move	3,01214(10)
	movei	1,4
	camn	3,1
	 jrst	%L866
%L867:
	setz	1,
	jrst	%L865
%L866:
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
	jumpn	1,%L868
	setm	1,1
	jrst	%L865
%L868:
	move	1,010
	pushj	17,opt_reset
	movei	1,5
	movem	1,01214(10)
	movei	1,1
%L865:
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
	 jumpe	3,%L870
	setz	1,
	jrst	%L869
%L870:
	movei	3,0(17)
	movei	2,-2(17)
	move	1,010
	pushj	17,opt_direct_movei
	jumpe	1,%L872
	move	3,-2(17)
	came	3,011
	 tdza	1,1
	 movei	1,1
	jrst	%L869
%L872:
	movei	3,-1(17)
	movei	2,-2(17)
	move	1,010
	pushj	17,opt_direct_move
	jumpe	1,%L875
	move	6,-2(17)
	camn	6,011
	 camn	6,-1(17)
	 tdza	1,1
	 movei	1,1
	jrst	%L869
%L875:
	setz	1,
%L869:
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
	 jrst	%L880
	move	3,017(10)
	cain	3,0300324
	 jrst	%L879
%L880:
	setz	1,
	jrst	%L878
%L879:
	move	2,3(10)
	move	1,2
	pushj	17,skipws
	movem	1,-3(17)
	ldb	2,1
	caie	2,0100
	 jrst	%L881
	move	1,-3(17)
	ibp	1
	pushj	17,skipws
	movem	1,-3(17)
%L881:
	ldb	1,-3(17)
	andi	1,0777
	pushj	17,isname0
	jumpn	1,%L882
	setm	1,1
	jrst	%L878
%L882:
	move	1,-3(17)
	ibp	1
	movem	1,-2(17)
%L883:
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L884
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L883
%L884:
	move	2,-2(17)
	movem	2,-1(17)
%L885:
	ldb	2,-1(17)
	jumpe	2,%L886
	cain	2,050
	 jrst	%L886
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L885
%L886:
	ldb	1,-1(17)
	cain	1,050
	 jrst	%L887
	setz	1,
	jrst	%L878
%L887:
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
	 jrst	%L889
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camge	3,1
	 jrst	%L888
%L889:
	setz	1,
	jrst	%L878
%L888:
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
%L878:
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
	 jrst	%L891
	setm	1,1
	jrst	%L890
%L891:
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
%L890:
	move	10,-013(17)
	move	16,-014(17)
	SUB	17,[015,,015]
	popj	17,

opt_instruction_may_skip:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	skipn	2,das_optimize
	 jrst	%L895
	skipn	3,016(10)
	 jrst	%L894
%L895:
	setz	1,
	jrst	%L893
%L894:
	move	2,017(10)
	caie	2,0300324
	 jrst	%L896
	movei	1,1
	jrst	%L893
%L896:
	move	2,017(10)
	move	1,2
	setz	2,
	pushj	17,lookup_op_mn
	movem	1,0(17)
	skipl	3,1
	 jrst	%L897
	setz	1,
	jrst	%L893
%L897:
	move	3,0(17)
	caige	3,0301
	 jrst	%L900
	caig	3,0307
	 jrst	%L899
%L900:
	move	3,0(17)
	caige	3,0311
	 jrst	%L901
	caig	3,0317
	 jrst	%L899
%L901:
	move	3,0(17)
	caige	3,0331
	 jrst	%L902
	caig	3,0337
	 jrst	%L899
%L902:
	move	3,0(17)
	caige	3,0351
	 jrst	%L903
	caig	3,0357
	 jrst	%L899
%L903:
	move	3,0(17)
	cail	3,0371
	 caile	3,0377
	 jrst	%L898
%L899:
	movei	1,1
	jrst	%L893
%L898:
	move	2,0(17)
	cail	2,0600
	 caile	2,0677
	 jrst	%L904
	trnn	2,7
	 jrst	%L904
	movei	1,1
	jrst	%L893
%L904:
	setz	1,
%L893:
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
	 jrst	%L906
	movni	1,3
	andb	1,0(17)
	move	1,010
	move	2,011
	pushj	17,opt_label_is_indexed_xct_target
	jumpe	1,%L906
	movei	2,2
	iorb	2,0(17)
%L906:
	skipn	2,2(11)
	 jrst	%L908
	skipn	3,016(11)
	 jrst	%L907
%L908:
	setz	1,
	movem	1,01322(10)
	move	3,0(17)
	movem	3,01321(10)
	move	4,2(11)
	setm	2,1
	camn	4,2
	 skipn	6,0(11)
	 jrst	%L909
	movei	5,1
	iorb	5,01321(10)
%L909:
	jrst	%L905
%L907:
	skipn	2,0(17)
	 jrst	%L910
	move	1,010
	pushj	17,opt_reset
%L910:
	move	2,0(17)
	movem	2,01322(10)
	move	3,2
	andi	3,2
	movem	3,01321(10)
	move	1,011
	pushj	17,opt_instruction_may_skip
	jumpe	1,%L911
	movei	2,1
	iorb	2,01321(10)
%L911:
%L905:
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
	 jrst	%L912
	move	3,0(11)
	setm	1,2
	camn	3,1
	 jrst	%L914
	move	1,010
	pushj	17,opt_reset
	jrst	%L912
%L914:
	setz	1,
	movem	1,-014(17)
	setm	2,1
	movem	2,-013(17)
	setz	3,
	movem	3,-012(17)
	skipn	5,das_optimize
	 jrst	%L916
	move	6,01202(10)
	jumpe	6,%L916
	movei	3,-7(17)
	movei	2,-010(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L916
	move	5,-7(17)
	move	4,01203(10)
	camn	5,4
	 camn	5,-010(17)
	 jrst	%L916
	movei	2,1
	movem	2,-014(17)
	movem	5,-013(17)
	move	6,-010(17)
	movem	6,01206(10)
	move	7,01202(10)
	caie	7,2
	 jrst	%L917
	movei	1,4
	jrst	%L918
%L917:
	movei	1,2
%L918:
	movem	1,-012(17)
	jrst	%L915
%L916:
	skipe	2,das_optimize
	 skipn	3,01176(10)
	 jrst	%L915
	movei	3,-7(17)
	movei	2,-010(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L915
	move	5,-7(17)
	move	4,01177(10)
	camn	5,4
	 camn	5,-010(17)
	 jrst	%L915
	movei	2,1
	movem	2,-014(17)
	movem	5,-013(17)
	move	6,-010(17)
	movem	6,01206(10)
	movei	3,3
	movem	3,-012(17)
%L915:
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
	jumpe	1,%L919
	move	1,-013(17)
	movem	1,01205(10)
	move	1,-012(17)
	movem	1,01207(10)
%L919:
	setz	1,
	movem	1,01214(10)
	setm	2,1
	movem	2,01316(10)
	skipn	4,das_optimize
	 jrst	%L921
	skipn	5,016(11)
	 jrst	%L920
%L921:
	jrst	%L912
%L920:
	skipe	2,0(11)
	 jrst	%L922
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_movei
	jumpe	1,%L924
	movei	2,1
	movem	2,01200(10)
	move	4,-016(17)
	movem	4,01201(10)
	jrst	%L923
%L924:
	movei	3,-6(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L923
	movei	2,1
	movem	2,01200(10)
	move	4,-016(17)
	movem	4,01201(10)
%L923:
%L922:
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
	jumpe	1,%L925
	move	3,-5(17)
	sojn	3,%L926
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_move_literal_immediate
	jumpn	1,%L925
%L926:
	move	2,-5(17)
	movem	2,01214(10)
	move	3,-016(17)
	movem	3,01215(10)
%L925:
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
	jumpe	1,%L927
	movei	3,4
	movem	3,01214(10)
	move	4,-4(17)
	lsh	4,0(3)
	move	5,-3(17)
	andi	5,017
	ior	4,5
	movem	4,01215(10)
%L927:
	skipe	2,01214(10)
	 jrst	%L928
	move	1,010
	addi	1,01216
	hrli	1,0331100
	move	2,1
	move	1,011
	movei	3,0400
	pushj	17,opt_direct_jrst_symbol
	jumpe	1,%L928
	movei	2,3
	movem	2,01214(10)
%L928:
	skipe	2,0(11)
	 jrst	%L930
	move	3,017(11)
	camn	3,[015172605]
	 skipn	4,024(11)
	 jrst	%L930
	move	5,023(11)
	setm	1,2
	camn	5,1
	 jrst	%L930
	move	7,023(11)
	ldb	6,7
	jumpe	6,%L930
	skipe	2,025(11)
	 jrst	%L930
	movei	1,1
	movem	1,01202(10)
	move	2,020(11)
	movem	2,01203(10)
	jrst	%L929
%L930:
	skipe	2,0(11)
	 jrst	%L929
	movei	4,-7(17)
	movei	2,-010(17)
	movei	3,-011(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L929
	move	3,-011(17)
	came	3,[023052415]
	 jrst	%L929
	move	4,-010(17)
	camn	4,-7(17)
	 jrst	%L929
	movei	2,2
	movem	2,01202(10)
	move	6,-010(17)
	movem	6,01203(10)
%L929:
	move	2,017(11)
	came	2,[015172605]
	 jrst	%L931
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_move_literal_immediate
	jumpn	1,%L931
	skipn	3,024(11)
	 jrst	%L912
	move	4,020(11)
	movem	4,-016(17)
	movei	2,1
	movem	2,01167(10)
	move	6,-016(17)
	movem	6,01170(10)
	jrst	%L912
%L931:
	move	2,017(11)
	camn	2,[01517260515]
	 jrst	%L912
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_setz
	jumpe	1,%L934
	movei	2,1
	movem	2,01171(10)
	move	4,-016(17)
	movem	4,01172(10)
	jrst	%L912
%L934:
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_any_movei
	jumpe	1,%L935
	movei	2,1
	movem	2,01176(10)
	move	4,-016(17)
	movem	4,01177(10)
%L935:
	movei	3,-015(17)
	movei	2,-016(17)
	move	1,011
	pushj	17,opt_direct_movei
	jumpe	1,%L936
	movei	3,1
	movem	3,01173(10)
	move	4,-016(17)
	movem	4,01174(10)
	move	5,-015(17)
	movem	5,01175(10)
	skipe	6,5
	 jrst	%L936
	movem	3,01171(10)
	move	7,-016(17)
	movem	7,01172(10)
%L936:
	skipe	2,0(11)
	 jrst	%L937
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
	jumpe	1,%L937
	move	3,-2(17)
	cain	3,0142310
	 skipn	4,0(17)
	 jrst	%L937
	move	5,-1(17)
	tlc	5,0400000
	camle	5,[0400000000077]
	 jrst	%L937
	movei	2,1
	movem	2,01316(10)
	move	7,-016(17)
	movem	7,01317(10)
	move	1,-1(17)
	movem	1,01320(10)
%L937:
%L912:
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
	skipe	2,das_optimize
	 skipe	3,0(11)
	 jrst	%L940
	move	4,01316(10)
	jumpe	4,%L940
	movei	4,-3(17)
	movei	2,-1(17)
	movei	3,-4(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_ac_integer
	jumpe	1,%L940
	move	3,-4(17)
	came	3,[01160411]
	 jrst	%L940
	move	4,-1(17)
	move	5,01317(10)
	came	4,5
	 jrst	%L940
	move	6,-3(17)
	tlc	6,0400000
	camle	6,[0400000777777]
	 jrst	%L940
	move	7,01320(10)
	tlc	7,0400000
	caml	7,[0400000000022]
	 jrst	%L939
%L940:
	setz	1,
	jrst	%L938
%L939:
	move	2,01320(10)
	tlc	2,0400000
	camge	2,[0400000000044]
	 jrst	%L942
	setz	1,
	movem	1,-2(17)
	jrst	%L941
%L942:
	movn	4,01320(10)
	addi	4,044
	movem	4,0(17)
	movei	1,1
	lsh	1,0(4)
	subi	1,1
	movem	1,-2(17)
%L941:
	move	2,-3(17)
	and	2,-2(17)
	came	2,-2(17)
	 tdza	1,1
	 movei	1,1
%L938:
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
	skipn	2,das_optimize
	 jrst	%L947
	move	3,0(11)
	setz	1,
	camn	3,1
	 skipn	5,01173(10)
	 jrst	%L947
	move	6,016(11)
	jumpe	6,%L946
%L947:
	setz	1,
	jrst	%L945
%L946:
	movei	1,-3(17)
	movei	2,-2(17)
	move	3,012
	move	4,1
	move	1,011
	pushj	17,opt_ac_integer
	jumpe	1,%L949
	move	3,0(12)
	move	4,01174(10)
	came	3,4
	 jrst	%L949
	move	5,-3(17)
	tlc	5,0400000
	camg	5,[0400000777777]
	 jrst	%L948
%L949:
	setz	1,
	jrst	%L945
%L948:
	move	3,-2(17)
	came	3,[01040411]
	 camn	3,[01160411]
	 jrst	%L950
	came	3,[011172211]
	 camn	3,[01115251411]
	 jrst	%L950
	setz	1,
	jrst	%L945
%L950:
	move	5,01175(10)
	movem	5,0(17)
	move	3,-3(17)
	movem	3,-1(17)
	move	4,-2(17)
	came	4,[01040411]
	 jrst	%L952
	tlc	5,0400000
	movn	2,-1(17)
	addi	2,0777777
	tlc	2,0400000
	camg	5,2
	 jrst	%L953
	setz	1,
	jrst	%L945
%L953:
	move	2,0(17)
	add	2,-1(17)
	movem	2,0(13)
	jrst	%L951
%L952:
	move	2,-2(17)
	came	2,[01160411]
	 jrst	%L954
	move	3,0(17)
	and	3,-1(17)
	movem	3,0(13)
	jrst	%L951
%L954:
	move	2,-2(17)
	came	2,[011172211]
	 jrst	%L955
	move	3,0(17)
	ior	3,-1(17)
	movem	3,0(13)
	jrst	%L951
%L955:
	skipn	2,-1(17)
	 jrst	%L956
	move	3,0(17)
	tlc	3,0400000
	movei	1,0777777
	skipge	16,-1(17)
	 JRST	%UIDN10
	JUMPGE	1,%UIDP10
	CAIG	16,1
	 JRST	%UIDZ10
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
	 JRST	%UIDD10
	SUB	2,016
	AOJA	1,%UIDD10
%UIDN10:	MOVE	2,1
	MOVEI	1,0
	JUMPGE	2,%UIDD10
	CAMGE	2,016
	 JRST	%UIDD10
	SUB	2,016
	AOJA	1,%UIDD10
%UIDZ10:	TDZA	2,2
%UIDP10:	IDIV	1,016
%UIDD10:
	tlc	1,0400000
	camg	3,1
	 jrst	%L956
	setz	1,
	jrst	%L945
%L956:
	move	4,0(17)
	mul	4,-1(17)
	trne	4,1
	 tloa	5,0400000
	 tlz	5,0400000
	movem	5,0(13)
%L951:
	movei	1,1
%L945:
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
	 jrst	%L959
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L959
	move	5,01173(10)
	jumpe	5,%L959
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
	jumpe	1,%L959
	move	3,0(12)
	move	4,01174(10)
	camn	3,4
	 skipn	5,0(17)
	 jrst	%L959
	move	7,-1(17)
	cain	7,012310
	 jrst	%L960
	caie	7,0142310
	 jrst	%L959
%L960:
	move	2,-2(17)
	tlc	2,0400000
	camg	2,[0400000000077]
	 jrst	%L958
%L959:
	setz	1,
	jrst	%L957
%L958:
	move	2,-2(17)
	tlc	2,0400000
	camge	2,[0400000000022]
	 jrst	%L962
	setz	1,
	movem	1,0(13)
	jrst	%L961
%L962:
	move	2,01175(10)
	movn	3,-2(17)
	lsh	2,0(3)
	movem	2,0(13)
%L961:
	movei	1,1
%L957:
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
	 jrst	%L965
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L965
	move	5,01173(10)
	skipn	6,016(11)
	 jumpn	5,%L964
%L965:
	setz	1,
	jrst	%L963
%L964:
	movei	4,-3(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_ac_integer
	jumpe	1,%L967
	move	3,-1(17)
	move	4,01174(10)
	came	3,4
	 jrst	%L967
	move	5,-3(17)
	tlc	5,0400000
	camg	5,[0400000777777]
	 jrst	%L966
%L967:
	setz	1,
	jrst	%L963
%L966:
	move	3,-2(17)
	came	3,[024221605]
	 camn	3,[024221616]
	 jrst	%L968
	came	3,[024141605]
	 camn	3,[024141616]
	 jrst	%L968
	setz	1,
	jrst	%L963
%L968:
	move	3,-2(17)
	camn	3,[024221605]
	 jrst	%L971
	came	3,[024221616]
	 jrst	%L970
%L971:
	move	2,01175(10)
	and	2,-3(17)
	movem	2,0(17)
	jrst	%L969
%L970:
	setzb	1,0(17)
%L969:
	move	3,-2(17)
	camn	3,[024221605]
	 jrst	%L973
	came	3,[024141605]
	 jrst	%L972
%L973:
	skipn	2,0(17)
	 tdza	1,1
	 movei	1,1
	jrst	%L963
%L972:
	skipe	2,0(17)
	 tdza	1,1
	 movei	1,1
%L963:
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
	 jrst	%L980
	move	4,01173(10)
	jumpe	4,%L980
	movei	1,0(17)
	movei	2,-1(17)
	move	3,012
	move	4,1
	move	1,011
	pushj	17,opt_reg_pair
	jumpe	1,%L980
	move	3,-1(17)
	camn	3,[015172616]
	 jrst	%L979
%L980:
	setz	1,
	jrst	%L978
%L979:
	move	2,0(12)
	move	3,01174(10)
	came	2,3
	 jrst	%L982
	move	4,0(17)
	move	5,0(12)
	came	4,5
%L982:
	 tdza	1,1
	 movei	1,1
%L978:
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
%L984:
	move	2,0(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L985
	move	4,0(17)
	ash	4,1
	add	4,011
	move	5,0(4)
	came	5,-1(17)
	 jrst	%L986
	move	7,0(17)
	ash	7,1
	add	7,011
	move	1,1(7)
	movem	1,0(13)
	movei	1,1
	jrst	%L983
%L986:
	aos	1,0(17)
	jrst	%L984
%L985:
	setz	1,
%L983:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	SUB	17,[6,,6]
	popj	17,

%L987:
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
	 jrst	%L990
	skipn	4,01173(10)
	 jrst	%L990
	movei	1,0(17)
	movei	2,-1(17)
	move	3,012
	move	4,1
	move	1,011
	pushj	17,opt_reg_pair
	jumpe	1,%L990
	movei	1,%L987
	move	2,011
	addi	2,4
	hrli	2,0331100
	move	4,013
	move	6,2
	move	2,1
	move	1,6
	movei	3,4
	pushj	17,opt_lookup_code
	jumpn	1,%L989
%L990:
	setz	1,
	jrst	%L988
%L989:
	move	2,0(12)
	move	3,01174(10)
	came	2,3
	 jrst	%L992
	move	4,0(17)
	move	5,0(12)
	came	4,5
%L992:
	 tdza	1,1
	 movei	1,1
%L988:
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
	jumpn	1,%L994
	movem	7,01171(10)
	movem	11,01172(10)
%L994:
%L993:
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
	 jrst	%L997
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L997
	move	5,01171(10)
	jumpe	5,%L997
	movei	1,0(17)
	move	2,012
	move	3,1
	move	1,011
	pushj	17,opt_direct_move
	jumpn	1,%L996
%L997:
	setz	1,
	jrst	%L995
%L996:
	move	2,0(17)
	move	3,01172(10)
	camn	2,3
	 skipa	4,0(12)
	 trna	
	 camn	4,2
	 tdza	1,1
	 movei	1,1
%L995:
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
	 jrst	%L1002
	move	3,0(11)
	setz	1,
	camn	3,1
	 skipa	5,01171(10)
	 trna	
	 jumpn	5,%L1001
%L1002:
	setz	1,
	jrst	%L1000
%L1001:
	move	1,011
	move	2,012
	pushj	17,opt_direct_setz
	jumpn	1,%L1003
	movei	1,0(17)
	move	2,012
	move	3,1
	move	1,011
	pushj	17,opt_direct_movei
	skipn	3,0(17)
	 jumpn	1,%L1003
	setz	1,
	jrst	%L1000
%L1003:
	move	2,0(12)
	move	3,01172(10)
	camn	2,3
	 tdza	1,1
	 movei	1,1
%L1000:
	move	10,-3(17)
	move	11,-2(17)
	move	12,-1(17)
	SUB	17,[4,,4]
	popj	17,

%L1007:
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
	 jrst	%L1010
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L1010
	move	5,01167(10)
	jumpe	5,%L1010
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L1010
	movei	1,%L1007
	move	2,011
	addi	2,4
	hrli	2,0331100
	move	4,012
	move	6,2
	move	2,1
	move	1,6
	movei	3,6
	pushj	17,opt_lookup_code
	jumpn	1,%L1009
%L1010:
	setz	1,
	jrst	%L1008
%L1009:
	move	5,-1(17)
	move	3,01170(10)
	camn	5,3
	 came	5,0(17)
	 tdza	1,1
	 movei	1,1
%L1008:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	SUB	17,[6,,6]
	popj	17,

%L1013:
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
	 jrst	%L1016
	move	3,0(11)
	setz	1,
	came	3,1
	 jrst	%L1016
	move	5,01167(10)
	jumpe	5,%L1016
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L1016
	movei	1,%L1013
	move	2,011
	addi	2,4
	hrli	2,0331100
	move	4,012
	move	6,2
	move	2,1
	move	1,6
	movei	3,010
	pushj	17,opt_lookup_code
	jumpn	1,%L1015
%L1016:
	setz	1,
	jrst	%L1014
%L1015:
	skipn	5,-1(17)
	 jrst	%L1018
	move	2,01170(10)
	camn	5,2
	 came	5,0(17)
%L1018:
	 tdza	1,1
	 movei	1,1
%L1014:
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
	 jrst	%L1021
	move	4,01171(10)
	jumpe	4,%L1021
	move	5,016(11)
	jumpn	5,%L1021
	move	6,017(11)
	camn	6,[01517260515]
	 jrst	%L1020
%L1021:
	setz	1,
	jrst	%L1019
%L1020:
	skipn	2,024(11)
	 jrst	%L1023
	move	3,020(11)
	move	4,01172(10)
	camn	3,4
	 jrst	%L1022
%L1023:
	setz	1,
	jrst	%L1019
%L1022:
	move	3,023(11)
	movem	3,0(17)
	ldb	1,3
	jumpe	1,%L1025
	move	4,025(11)
	cain	4,0
%L1025:
	 tdza	1,1
	 movei	1,1
%L1019:
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
	 jrst	%L1028
	move	4,01176(10)
	jumpe	4,%L1028
	movei	4,0(17)
	movei	2,-1(17)
	movei	3,-2(17)
	move	1,011
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_reg_pair
	jumpe	1,%L1028
	move	3,-2(17)
	camn	3,[010222232]
	 jrst	%L1027
%L1028:
	setz	1,
	jrst	%L1026
%L1027:
	move	5,-1(17)
	move	3,01177(10)
	camn	5,3
	 came	5,0(17)
	 tdza	1,1
	 movei	1,1
%L1026:
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
	 jrst	%L1033
	move	3,01200(10)
	jumpe	3,%L1033
	move	2,01201(10)
	move	1,011
	pushj	17,opt_instruction_overwrites_ac
	jumpn	1,%L1032
%L1033:
	setz	1,
	jrst	%L1031
%L1032:
	move	2,01201(10)
	movem	2,0(12)
	movei	1,1
%L1031:
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
	 jrst	%L1036
	move	2,01205(10)
	move	1,011
	pushj	17,opt_instruction_overwrites_ac
	cain	1,0
%L1036:
	 tdza	1,1
	 movei	1,1
%L1034:
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
	 jrst	%L1038
	setm	1,2
	jrst	%L1037
%L1038:
	skipn	2,0(11)
	 jrst	%L1039
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1037
%L1039:
	skipe	2,2(11)
	 jrst	%L1040
	setm	1,2
	jrst	%L1037
%L1040:
	move	2,01322(10)
	jumpe	2,%L1041
	setz	1,
	jrst	%L1037
%L1041:
	move	2,01146(10)
	tlc	2,0400000
	camge	2,[0400000000006]
	 jrst	%L1042
	move	1,010
	pushj	17,opt_reset
%L1042:
	movei	3,-5(17)
	movei	2,-6(17)
	move	1,011
	pushj	17,opt_direct_move
	jumpe	1,%L1044
	move	4,010
	add	4,-5(17)
	move	2,01147(4)
	movem	2,-4(17)
	jrst	%L1043
%L1044:
	movei	3,-5(17)
	movei	2,-6(17)
	move	1,011
	pushj	17,opt_direct_movei
	jumpe	1,%L1045
	move	3,-5(17)
	add	3,[01000000]
	movem	3,-4(17)
	jrst	%L1043
%L1045:
	skipe	2,01210(10)
	 skipe	3,016(11)
	 jrst	%L1047
	move	4,017(11)
	came	4,[015172605]
%L1047:
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
	 jrst	%L1048
	movei	1,1
	movem	1,01210(10)
	move	4,-2(17)
	movem	4,01211(10)
	move	5,-1(17)
	movem	5,01212(10)
	move	6,0(17)
	movem	6,01213(10)
%L1048:
	setz	1,
	jrst	%L1037
%L1043:
	move	3,010
	add	3,-6(17)
	move	1,01147(3)
	came	1,-4(17)
	 jrst	%L1049
	movei	1,1
	jrst	%L1037
%L1049:
	move	2,-4(17)
	move	4,010
	add	4,-6(17)
	movem	2,01147(4)
	aos	1,01146(10)
	setz	1,
%L1037:
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
	jumpn	1,%L1051
	seto	1,
	jrst	%L1050
%L1051:
	move	2,-2(17)
	move	1,010
	pushj	17,char_distance
	movem	1,0(17)
%L1052:
	skipn	2,0(17)
	 jrst	%L1053
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
	jumpe	1,%L1053
	sos	2,0(17)
	jrst	%L1052
%L1053:
%L1054:
	skipn	2,0(17)
	 jrst	%L1055
	move	1,010
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L1055
	ibp	010
	sos	2,0(17)
	jrst	%L1054
%L1055:
	skipn	3,0(17)
	 jrst	%L1057
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	caml	3,1
	 jrst	%L1057
	move	1,010
	ldb	1,1
	pushj	17,isname0
	jumpn	1,%L1056
%L1057:
	seto	1,
	jrst	%L1050
%L1056:
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
%L1058:
	ldb	1,-1(17)
	jumpe	1,%L1059
	ldb	1,-1(17)
	pushj	17,isname
	jumpn	1,%L1060
	seto	1,
	jrst	%L1050
%L1060:
	ibp	-1(17)
	move	1,-1(17)
	jrst	%L1058
%L1059:
	move	1,-2(17)
	ibp	1
	pushj	17,skipws
	movem	1,0(13)
	ldb	2,1
	jumpn	2,%L1061
	seto	1,
	jrst	%L1050
%L1061:
	setz	1,
%L1050:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	move	16,-7(17)
	SUB	17,[010,,010]
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
	jumpn	1,%L1063
	seto	1,
	jrst	%L1062
%L1063:
	move	2,-4(17)
	move	1,010
	pushj	17,char_distance
	movem	1,0(17)
%L1064:
	skipn	2,0(17)
	 jrst	%L1065
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
	jumpe	1,%L1065
	sos	2,0(17)
	jrst	%L1064
%L1065:
%L1066:
	skipn	2,0(17)
	 jrst	%L1067
	move	1,010
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L1067
	ibp	010
	sos	2,0(17)
	jrst	%L1066
%L1067:
	skipn	3,0(17)
	 jrst	%L1069
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camge	3,1
	 jrst	%L1068
%L1069:
	seto	1,
	jrst	%L1062
%L1068:
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
	 jumpn	3,%L1070
	seto	1,
	jrst	%L1062
%L1070:
	movei	2,-2(17)
	move	3,-3(17)
	move	1,3
	movei	3,012
	pushj	17,strtol
	movem	1,-1(17)
	move	3,-2(17)
	came	3,-3(17)
	 jrst	%L1072
	seto	1,
	jrst	%L1062
%L1072:
	move	1,-2(17)
	pushj	17,skipws
	movem	1,-2(17)
	ldb	3,1
	jumpe	3,%L1073
	cain	3,054
	 jrst	%L1073
	seto	1,
	jrst	%L1062
%L1073:
	move	2,-1(17)
	tlc	2,0400000
	camg	2,[0400003777774]
	 jrst	%L1074
	seto	1,
	jrst	%L1062
%L1074:
	move	2,-1(17)
	addi	2,3
	lsh	2,-2
	movem	2,0(13)
	setz	1,
%L1062:
	MOVEI	0,010
	HRLI	0,-010(17)
	BLT	0,013
	move	16,-011(17)
	SUB	17,[012,,012]
	popj	17,

pass1_assignment:
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
	jumpe	1,%L1076
	movei	1,012523
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1075
%L1076:
	move	2,016(11)
	movei	1,031
	came	2,1
	 jrst	%L1077
	movei	1,010
	jrst	%L1078
%L1077:
	movei	1,020
%L1078:
	movem	1,-3(17)
	setz	2,
	movem	2,-1(17)
	cain	1,020
	 aosa	3,01336(10)
	 trna	
	 movem	3,-1(17)
	movei	3,-021(17)
	movei	2,-034(17)
	hrli	2,0331100
	move	1,010
	pushj	17,find_sym
	jumpe	1,%L1080
	move	5,-7(17)
	andi	5,030
	movem	5,0(17)
	move	4,-3(17)
	cain	4,010
	 jrst	%L1082
	cain	5,020
	 jrst	%L1081
%L1082:
	movei	1,012543
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1075
%L1081:
%L1080:
	movei	2,-034(17)
	hrli	2,0331100
	move	1,010
	pushj	17,mark_symbol_visible
	movei	1,1
	movem	1,01335(10)
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
	jumpe	1,%L1083
	setz	2,
	movem	2,01335(10)
	move	4,-3(17)
	caie	4,020
	 jrst	%L1084
	move	4,-1(17)
	movei	1,-034(17)
	hrli	1,0331100
	move	2,1
	move	1,010
	movei	3,020
	pushj	17,add_sym
%L1084:
	setz	1,
	jrst	%L1075
%L1083:
	setz	1,
	movem	1,01335(10)
	skipn	3,-4(17)
	 jrst	%L1085
	movei	1,4
	jrst	%L1086
%L1085:
	setz	1,
%L1086:
	movem	1,-2(17)
	move	3,-3(17)
	caie	3,020
	 jrst	%L1088
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
	jrst	%L1087
%L1088:
	move	4,-5(17)
	move	3,-2(17)
	ior	3,-3(17)
	movei	1,-034(17)
	hrli	1,0331100
	move	2,1
	move	1,010
	pushj	17,add_sym
%L1087:
	setz	1,
%L1075:
	move	10,-037(17)
	move	11,-036(17)
	move	12,-035(17)
	SUB	17,[040,,040]
	popj	17,

pass1_line:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[0120,,0120]
	movei	1,-0117(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,parse_line_head
	jumpn	1,%L1090
	setm	1,1
	jrst	%L1089
%L1090:
	movei	1,-066(17)
	hrli	1,0331100
	movei	6,-0117(17)
	move	2,1
	move	1,6
	movei	3,050
	pushj	17,opt_indexed_xct_symbol
	jumpe	1,%L1091
	move	2,[POINT 9,%L1092,8]
	move	1,010
	pushj	17,mark_indexed_xct_target
%L1091:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_jump_jrst_next_label
	jumpe	1,%L1094
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	skipe	3,0(4)
	 jrst	%L1095
	movei	1,1
	jrst	%L1089
%L1095:
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	sos	1,0(4)
	move	1,010
	pushj	17,opt_reset
	jrst	%L1093
%L1094:
	skipn	2,das_optimize
	 jrst	%L1093
	move	3,01214(10)
	caie	3,5
	 jrst	%L1093
	move	1,010
	pushj	17,opt_reset
%L1093:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_jrst_next_label
	jumpe	1,%L1097
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	move	3,0(4)
	jumpn	3,%L1098
	movei	1,1
	jrst	%L1089
%L1098:
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	sos	1,0(4)
	move	1,010
	pushj	17,opt_reset
	jrst	%L1096
%L1097:
	skipn	2,das_optimize
	 jrst	%L1096
	move	3,01214(10)
	caie	3,3
	 jrst	%L1096
	move	1,010
	pushj	17,opt_reset
%L1096:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_begin_line
	move	2,01322(10)
	jumpn	2,%L1099
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_jump_jrst_transition
	jumpe	1,%L1099
	move	3,010
	addi	3,01135
	move	5,0(12)
	add	5,3
	aos	2,0(5)
	setz	1,
	jrst	%L1089
%L1099:
	skipn	2,-0117(17)
	 jrst	%L1100
	move	4,-0116(17)
	movem	4,-054(17)
	tlc	4,0400000
	camle	4,[0400000000047]
	 skipa	1,[047]
	 trna	
	 movem	1,-054(17)
	move	2,-054(17)
	move	6,-0117(17)
	movei	1,-066(17)
	hrli	1,0331100
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	setz	1,
	move	4,-054(17)
	PUSH	17,1
	MOVEI	16,-067(17)
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
	movei	3,-052(17)
	movei	2,-066(17)
	hrli	2,0331100
	move	1,010
	pushj	17,find_sym
	jumpe	1,%L1102
	movei	1,012657
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1102:
	movei	2,-066(17)
	hrli	2,0331100
	move	1,010
	pushj	17,mark_symbol_visible
	move	1,010
	addi	1,01135
	move	3,0(12)
	add	3,1
	move	2,0(3)
	move	5,0(12)
	movei	4,-066(17)
	hrli	4,0331100
	move	1,010
	move	3,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,add_sym
%L1100:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_finish_pending_push
	jumpe	1,%L1103
	move	1,010
	pushj	17,opt_reset
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_record_prev
	setz	1,
	jrst	%L1089
%L1103:
	movei	3,-036(17)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_overwrite_prev
	jumpe	1,%L1104
	setz	2,
	movem	2,01210(10)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_record_prev
	setz	1,
	jrst	%L1089
%L1104:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_redundant_mem_pair
	jumpe	1,%L1105
	setz	1,
	jrst	%L1089
%L1105:
	movei	3,-035(17)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_move_unary_fold
	jumpe	1,%L1106
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1106:
	movei	3,-034(17)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_move_skip_fold
	jumpe	1,%L1107
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1107:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_lshr_andi_redundant
	jumpe	1,%L1108
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1108:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_movei_hrrz_redundant
	jumpe	1,%L1109
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1109:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_zero_store
	jumpe	1,%L1110
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1110:
	movei	3,-033(17)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_zero_move_pair
	jumpe	1,%L1111
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1111:
	movei	3,-032(17)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_zero_pair
	jumpe	1,%L1112
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1112:
	movei	4,-030(17)
	movei	2,-031(17)
	movei	3,-0117(17)
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_immediate_fold
	jumpe	1,%L1113
	move	2,-030(17)
	move	3,-031(17)
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_set_prev_immediate
	setz	1,
	jrst	%L1089
%L1113:
	movei	4,-026(17)
	movei	2,-027(17)
	movei	3,-0117(17)
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_movei_right_shift_fold
	jumpe	1,%L1114
	move	2,-026(17)
	move	3,-027(17)
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_set_prev_immediate
	setz	1,
	jrst	%L1089
%L1114:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_movei_test_nonskip
	jumpe	1,%L1115
	movni	2,2
	andb	2,01321(10)
	setz	1,
	jrst	%L1089
%L1115:
	movei	3,-025(17)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_movei_movn_fold
	jumpe	1,%L1116
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1116:
	movei	4,-023(17)
	movei	2,-024(17)
	movei	3,-0117(17)
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,opt_movei_unary_immediate_fold
	jumpe	1,%L1117
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1117:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_halfword_fold
	movem	1,-022(17)
	skipn	3,1
	 jrst	%L1118
	move	1,010
	pushj	17,opt_reset
	setz	1,
	jrst	%L1089
%L1118:
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_drop_line
	jumpe	1,%L1119
	setz	1,
	jrst	%L1089
%L1119:
	skipe	2,-0115(17)
	 jrst	%L1120
	setm	1,2
	jrst	%L1089
%L1120:
	skiple	2,-0101(17)
	 cail	2,036
	 jrst	%L1121
	jrst	@%L1135-1(2)
%L1135:
	setz	%L1122
	setz	%L1123
	setz	%L1124
	setz	%L1125
	setz	%L1133
	setz	%L1126
	setz	%L1129
	setz	%L1128
	setz	%L1133
	setz	%L1121
	setz	%L1121
	setz	%L1134
	setz	%L1134
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1121
	setz	%L1131
	setz	%L1132
	setz	%L1132
	setz	%L1130
	setz	%L1127
	setz	%L1127
%L1122:
	movei	1,1
	movem	1,0(12)
	setz	1,
	jrst	%L1089
%L1123:
	movei	1,2
	movem	1,0(12)
	setz	1,
	jrst	%L1089
%L1124:
	movei	1,3
	movem	1,0(12)
	setz	1,
	jrst	%L1089
%L1125:
	move	2,0(12)
	move	1,-0114(17)
	pushj	17,psect_to_sec
	movem	1,0(12)
	setz	1,
	jrst	%L1089
%L1126:
	move	2,-0114(17)
	move	1,010
	addi	1,01323
	hrli	1,0331100
	movei	3,050
	pushj	17,strcopy
	setz	1,
	jrst	%L1089
%L1127:
	setz	1,
	jrst	%L1089
%L1128:
	movei	1,013106
	pushj	17,das_native_diag
	setz	1,
	jrst	%L1089
%L1129:
	movei	1,013112
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1130:
	movei	1,-021(17)
	push	17,1
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	push	17,0(4)
	move	2,0(12)
	move	1,010
	pushj	17,sec_base
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	add	1,0(4)
	move	2,-0116(17)
	pop	17,3
	move	4,3
	move	3,1
	move	1,010
	pushj	17,align_word_padding
	SUB	17,[1,,1]
	jumpe	1,%L1136
	movei	1,013121
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1136:
	move	2,-021(17)
	move	1,010
	addi	1,01135
	move	4,0(12)
	add	4,1
	addb	2,0(4)
	setz	1,
	jrst	%L1089
%L1131:
	move	2,0(12)
	move	1,010
	pushj	17,sec_base
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	add	1,0(4)
	movem	1,-017(17)
	movei	1,-020(17)
	push	17,1
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	move	3,0(4)
	move	6,-020(17)
	move	7,-0115(17)
	move	1,010
	move	2,7
	move	4,3
	move	3,6
	pushj	17,org_word_target
	SUB	17,[1,,1]
	jumpe	1,%L1137
	movei	1,013135
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1137:
	move	2,-020(17)
	move	1,010
	addi	1,01135
	move	4,0(12)
	add	4,1
	movem	2,0(4)
	setz	1,
	jrst	%L1089
%L1132:
	move	2,0(12)
	move	1,010
	pushj	17,sec_base
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	add	1,0(4)
	movei	2,-0117(17)
	move	3,1
	move	1,010
	pushj	17,pass1_assignment
	jrst	%L1089
%L1133:
	setz	1,
	jrst	%L1089
%L1134:
	movei	1,-016(17)
	movei	2,-066(17)
	hrli	2,0331100
	move	6,-0114(17)
	move	4,1
	move	1,6
	movei	3,050
	pushj	17,common_args
	jumpe	1,%L1138
	movei	1,013160
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1138:
	movei	3,-015(17)
	movei	2,-066(17)
	hrli	2,0331100
	move	1,010
	pushj	17,find_sym
	jumpe	1,%L1139
	movei	1,013164
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1139:
	movei	2,-066(17)
	hrli	2,0331100
	move	1,010
	pushj	17,mark_symbol_visible
	move	4,01140(10)
	movei	2,-066(17)
	hrli	2,0331100
	move	1,010
	movei	3,3
	pushj	17,add_sym
	move	2,-016(17)
	addb	2,01140(10)
	setz	1,
	jrst	%L1089
%L1121:
	movei	1,0(17)
	movei	2,-1(17)
	movei	6,-0117(17)
	move	3,1
	move	1,6
	pushj	17,opt_move_literal_immediate
	jumpn	1,%L1140
	move	2,-0115(17)
	move	1,010
	pushj	17,scan_literals
%L1140:
	move	2,0(12)
	move	1,010
	pushj	17,sec_base
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	add	1,0(4)
	movei	2,-0117(17)
	move	3,1
	move	1,010
	pushj	17,parsed_word_count
	movem	1,-053(17)
	skipl	3,1
	 jrst	%L1141
	movei	1,013215
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1089
%L1141:
	move	3,-053(17)
	move	2,010
	addi	2,01135
	move	4,0(12)
	add	4,2
	addb	3,0(4)
	movei	2,-0117(17)
	move	1,010
	pushj	17,opt_record_prev
	setz	1,
%L1089:
	move	10,-0122(17)
	move	11,-0121(17)
	move	12,-0120(17)
	move	16,-0123(17)
	SUB	17,[0124,,0124]
	popj	17,
%L1092:
	.byte	9,0
	


parse_include_line:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	move	1,010
	movei	2,073
	pushj	17,strchr
	movem	1,-2(17)
	jumpe	1,%L1143
	setz	2,
	dpb	2,1
%L1143:
	move	1,010
	pushj	17,rtrim
	move	1,010
	pushj	17,skipws
	movem	1,-2(17)
	ldb	2,1
	caie	2,056
	 jrst	%L1144
	ibp	-2(17)
	move	3,-2(17)
%L1144:
	move	2,[POINT 9,%L1146,8]
	move	3,-2(17)
	move	1,3
	movei	3,7
	pushj	17,pref_i
	jumpn	1,%L1145
	setm	1,1
	jrst	%L1142
%L1145:
	movei	1,7
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,-2(17)
	ldb	2,1
	cain	2,042
	 jrst	%L1147
	seto	1,
	jrst	%L1142
%L1147:
	move	1,-2(17)
	ibp	1
	movem	1,-1(17)
	move	1,-1(17)
	movei	2,042
	pushj	17,strchr
	movem	1,0(17)
	jumpn	1,%L1148
	seto	1,
	jrst	%L1142
%L1148:
	setz	1,
	dpb	1,0(17)
	move	2,-1(17)
	move	1,011
	move	3,012
	pushj	17,strcopy
	movei	1,1
%L1142:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,
%L1146:
	.byte	9,0111,0116,0103,0114
	.byte	9,0125,0104,0105,0
	


dirname_of:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,010
	movei	2,057
	pushj	17,strrchr
	movem	1,-1(17)
	jumpn	1,%L1150
	move	2,[POINT 9,%L1151,8]
	move	1,011
	move	3,012
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	jrst	strcopy
%L1150:
	move	2,-1(17)
	move	1,010
	pushj	17,char_distance
	movem	1,0(17)
	move	3,1
	tlc	3,0400000
	move	2,012
	tlc	2,0400000
	camge	3,2
	 jrst	%L1152
	move	4,012
	subi	4,1
	movem	4,0(17)
%L1152:
	move	2,0(17)
	move	1,010
	move	3,011
	move	6,3
	move	3,2
	move	2,1
	move	1,6
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
%L1149:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	move	16,-5(17)
	SUB	17,[6,,6]
	popj	17,
%L1151:
	.byte	9,056,0
	


join_path:
	push	17,016
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,011
	ldb	2,1
	movei	3,057
	came	2,3
	 jrst	%L1154
	move	1,012
	move	2,011
	move	3,013
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	move	13,-2(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	jrst	strcopy
%L1154:
	move	1,010
	pushj	17,strlen
	movem	1,-1(17)
	move	1,011
	pushj	17,strlen
	movem	1,0(17)
	add	1,-1(17)
	addi	1,1
	move	3,1
	tlc	3,0400000
	move	2,013
	tlc	2,0400000
	camge	3,2
	 jrst	%L1155
	movei	1,015740
	pushj	17,das_native_die
%L1155:
	move	2,-1(17)
	move	1,010
	move	3,012
	move	6,3
	move	3,2
	move	2,1
	move	1,6
	pushj	17,das_native_memcpy
	movei	1,057
	move	4,-1(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	4,-1(17)
	MOVEM	12,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	4,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	1,4
	move	2,0(17)
	addi	2,1
	move	1,011
	move	6,-1(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	6,-1(17)
	MOVEM	12,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	6,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ibp	6
	move	3,2
	move	2,1
	move	1,6
	pushj	17,das_native_memcpy
%L1153:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

rept_prefix:
	push	17,016
	push	17,010
	move	10,1
	push	17,010
%L1157:
	ldb	1,0(17)
	jumpe	1,%L1158
	ldb	1,0(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L1158
	ibp	0(17)
	move	2,0(17)
	jrst	%L1157
%L1158:
	ldb	1,0(17)
	caie	1,056
	 jrst	%L1159
	ibp	0(17)
	move	2,0(17)
%L1159:
	move	2,[POINT 9,%L1161,8]
	move	3,0(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L1160
	movei	2,4
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
	ldb	3,2
	jumpe	3,%L1162
	movei	1,4
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
	jumpe	1,%L1160
%L1162:
	movei	1,1
	jrst	%L1156
%L1160:
	move	2,[POINT 9,%L1164,8]
	move	3,0(17)
	move	1,3
	movei	3,3
	pushj	17,pref_i
	jumpe	1,%L1163
	move	2,0(17)
	ibp	2
	ibp	2
	ildb	3,2
	jumpe	3,%L1165
	move	1,0(17)
	ibp	1
	ibp	1
	ildb	1,1
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L1163
%L1165:
	movei	1,1
	jrst	%L1156
%L1163:
	move	2,[POINT 9,%L1167,8]
	move	3,0(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L1166
	movei	2,4
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
	ldb	3,2
	jumpe	3,%L1168
	movei	1,4
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
	jumpe	1,%L1166
%L1168:
	movei	1,1
	jrst	%L1156
%L1166:
	move	2,[POINT 9,%L1170,8]
	move	3,0(17)
	move	1,3
	movei	3,4
	pushj	17,pref_i
	jumpe	1,%L1169
	movei	2,4
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
	ldb	3,2
	jumpe	3,%L1171
	movei	1,4
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
	jumpe	1,%L1169
%L1171:
	movei	1,1
	jrst	%L1156
%L1169:
	setz	1,
%L1156:
	move	10,-1(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L1170:
	.byte	9,0105,0116,0104,0122
	.byte	9,0
	

%L1167:
	.byte	9,0111,0122,0120,0103
	.byte	9,0
	

%L1164:
	.byte	9,0111,0122,0120,0
	

%L1161:
	.byte	9,0122,0105,0120,0124
	.byte	9,0
	


rept_structure_kind:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[031,,031]
	move	1,011
	pushj	17,rept_prefix
	jumpn	1,%L1173
	setm	1,1
	jrst	%L1172
%L1173:
	movei	1,-030(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,parse_line_head
	skipe	3,-026(17)
	 jumpn	1,%L1174
	setz	1,
	jrst	%L1172
%L1174:
	move	1,[POINT 9,%L1178,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1177
	move	1,[POINT 9,%L1179,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1177
	move	1,[POINT 9,%L1180,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1176
%L1177:
	movei	1,1
	jrst	%L1172
%L1176:
	move	1,[POINT 9,%L1182,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1181
	movei	1,2
	jrst	%L1172
%L1181:
	setz	1,
%L1172:
	move	10,-032(17)
	move	11,-031(17)
	move	16,-033(17)
	SUB	17,[034,,034]
	popj	17,
%L1182:
	.byte	9,0105,0116,0104,0122
	.byte	9,0
	

%L1180:
	.byte	9,0111,0122,0120,0103
	.byte	9,0
	

%L1179:
	.byte	9,0111,0122,0120,0
	

%L1178:
	.byte	9,0122,0105,0120,0124
	.byte	9,0
	


rept_count_line:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[034,,034]
	move	3,-042(17)
	setzb	1,0(3)
	move	1,-037(17)
	pushj	17,rept_prefix
	jumpn	1,%L1183
	setm	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1183:
	movei	1,-033(17)
	move	2,-037(17)
	move	4,-036(17)
	move	3,1
	move	1,4
	pushj	17,parse_line_head
	skipe	3,-031(17)
	 jumpn	1,%L1184
	setz	1,
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1184:
	move	1,[POINT 9,%L1187,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1186
	move	1,[POINT 9,%L1188,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1186
	move	1,[POINT 9,%L1189,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1186
	move	1,[POINT 9,%L1190,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1186
	setm	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1186:
	move	1,[POINT 9,%L1193,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1192
	movei	2,1
	move	4,-042(17)
	movem	2,0(4)
	jrst	%L1191
%L1192:
	move	1,[POINT 9,%L1195,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1194
	movei	2,3
	move	4,-042(17)
	movem	2,0(4)
	jrst	%L1191
%L1194:
	move	1,[POINT 9,%L1197,8]
	movei	6,-027(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1196
	movei	2,4
	move	4,-042(17)
	movem	2,0(4)
	jrst	%L1191
%L1196:
	movei	1,2
	move	3,-042(17)
	movem	1,0(3)
%L1191:
	skipn	2,-033(17)
	 jrst	%L1198
	movei	1,016050
	pushj	17,das_native_diag
	movei	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1198:
	move	2,-042(17)
	move	1,0(2)
	caie	1,2
	 jrst	%L1199
	move	1,-030(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L1200
	movei	1,016056
	pushj	17,das_native_diag
	movei	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1200:
	setz	1,
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1199:
	move	5,-042(17)
	move	1,0(5)
	movei	3,3
	camn	1,3
	 jrst	%L1202
	caie	1,4
	 jrst	%L1201
%L1202:
	move	1,-030(17)
	pushj	17,skipws
	movem	1,-2(17)
	ldb	1,-2(17)
	pushj	17,isname0
	jumpn	1,%L1203
	movei	1,016070
	pushj	17,das_native_diag
	movei	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1203:
%L1204:
	ldb	1,-2(17)
	pushj	17,isname
	jumpe	1,%L1205
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L1204
%L1205:
	move	1,-2(17)
	pushj	17,skipws
	movem	1,-2(17)
	ldb	2,1
	jumpe	2,%L1206
	caie	2,054
	 cain	2,073
	 jrst	%L1206
	movei	1,016101
	pushj	17,das_native_diag
	movei	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1206:
	setz	1,
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1201:
	move	1,-030(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L1208
	movei	1,0(17)
	push	17,1
	movei	2,-2(17)
	move	4,-041(17)
	move	5,-031(17)
	move	1,-037(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,eval_expr
	SUB	17,[1,,1]
	jumpn	1,%L1208
	skipe	3,0(17)
	 jrst	%L1208
	move	4,-1(17)
	tlc	4,0400000
	camg	4,[0400000177777]
	 jrst	%L1207
%L1208:
	movei	1,016113
	pushj	17,das_native_diag
	movei	1,1
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1207:
	move	2,-1(17)
	move	3,-041(17)
	movem	2,0(3)
	setz	1,
	move	16,-034(17)
	SUB	17,[035,,035]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1197:
	.byte	9,0111,0122,0120,0103
	.byte	9,0
	

%L1195:
	.byte	9,0111,0122,0120,0
	

%L1193:
	.byte	9,0122,0105,0120,0124
	.byte	9,0
	

%L1190:
	.byte	9,0105,0116,0104,0122
	.byte	9,0
	

%L1189:
	.byte	9,0111,0122,0120,0103
	.byte	9,0
	

%L1188:
	.byte	9,0111,0122,0120,0
	

%L1187:
	.byte	9,0122,0105,0120,0124
	.byte	9,0
	


rept_store_append_line:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[3,,3]
	move	1,011
	pushj	17,strlen
	movem	1,-2(17)
	move	3,1
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L1210
	seto	1,
	jrst	%L1209
%L1210:
	move	3,-2(17)
	addi	3,3
	lsh	3,-2
	movem	3,-1(17)
	movei	5,das_native_rept_record
	movem	5,0(17)
	move	4,-2(17)
	movem	4,0(5)
	jumpe	3,%L1211
	move	4,-2(17)
	move	3,-1(17)
	move	1,0(17)
	addi	1,1
	move	2,3
	move	3,011
	pushj	17,pack_text_words
%L1211:
	move	3,-1(17)
	addi	3,1
	move	2,0(17)
	move	1,010
	addi	1,01045
	move	10,-4(17)
	move	11,-3(17)
	SUB	17,[5,,5]
	jrst	wordfile_append
%L1209:
	move	10,-4(17)
	move	11,-3(17)
	SUB	17,[5,,5]
	popj	17,

rept_store_read_line:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[4,,4]
	move	2,-6(17)
	tlc	2,0400000
	move	3,-7(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1213
	movei	1,-3(17)
	move	2,-6(17)
	move	4,-5(17)
	addi	4,01045
	move	3,1
	move	1,4
	movei	4,1
	pushj	17,wordfile_read
	jumpe	1,%L1212
%L1213:
	seto	1,
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1212:
	hrrz	3,-3(17)
	movem	3,-2(17)
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L1214
	seto	1,
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1214:
	move	4,-2(17)
	addi	4,3
	lsh	4,-2
	movem	4,-1(17)
	add	4,-6(17)
	addi	4,1
	move	3,4
	tlc	3,0400000
	move	2,-7(17)
	tlc	2,0400000
	camg	3,2
	 jrst	%L1215
	seto	1,
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1215:
	movei	1,das_native_rept_record
	movem	1,0(17)
	skipn	3,-1(17)
	 jrst	%L1216
	move	2,-1(17)
	move	3,0(17)
	move	4,-6(17)
	addi	4,1
	move	1,-5(17)
	addi	1,01045
	move	6,4
	move	4,2
	move	2,6
	pushj	17,wordfile_read
	jumpe	1,%L1216
	seto	1,
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1216:
	skipn	2,-1(17)
	 jrst	%L1218
	move	2,-2(17)
	move	3,0(17)
	move	1,-010(17)
	move	4,2
	movei	2,0400
	pushj	17,unpack_text_words
	jrst	%L1217
%L1218:
	setz	1,
	dpb	1,-010(17)
%L1217:
	move	2,-6(17)
	add	2,-1(17)
	addi	2,1
	move	3,-011(17)
	movem	2,0(3)
	setz	1,
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

iter_store_spec:
	push	17,016
	ADD	17,[045,,045]
	MOVEI	0,-044(17)
	HRLI	0,010
	BLT	0,-041(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movei	1,-040(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,parse_line_head
	jumpe	1,%L1221
	skipn	3,-036(17)
	 jrst	%L1221
	move	1,[POINT 9,%L1222,8]
	movei	6,-034(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1220
	move	1,[POINT 9,%L1223,8]
	movei	6,-034(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1220
%L1221:
	seto	1,
	jrst	%L1219
%L1220:
	move	1,-035(17)
	pushj	17,skipws
	movem	1,-7(17)
	movem	1,-5(17)
%L1224:
	ldb	1,-5(17)
	pushj	17,isname
	jumpe	1,%L1225
	ibp	-5(17)
	move	2,-5(17)
	jrst	%L1224
%L1225:
	move	2,-5(17)
	came	2,-7(17)
	 jrst	%L1226
	seto	1,
	jrst	%L1219
%L1226:
	ldb	1,-5(17)
	dpb	1,[POINT 9,-3(17),35]
	setz	2,
	dpb	2,-5(17)
	move	4,01046(10)
	movem	4,0(12)
	move	2,-7(17)
	move	1,010
	pushj	17,rept_store_append_line
	jumpe	1,%L1227
	ldb	3,[POINT 9,-3(17),35]
	dpb	3,-5(17)
	seto	1,
	jrst	%L1219
%L1227:
	ldb	2,[POINT 9,-3(17),35]
	dpb	2,-5(17)
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-6(17)
	ldb	2,1
	caie	2,054
	 jrst	%L1229
	move	1,-6(17)
	ibp	1
	pushj	17,skipws
	movem	1,-6(17)
	jrst	%L1228
%L1229:
	move	1,-6(17)
	pushj	17,strlen
	move	16,-6(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	movem	1,-6(17)
%L1228:
	setz	1,
	movem	1,-2(17)
	setm	2,1
	movem	2,-1(17)
	move	5,-6(17)
	movem	5,-4(17)
	movem	5,-5(17)
%L1230:
	ldb	2,-5(17)
	jumpe	2,%L1231
	movem	2,0(17)
	skipn	3,-2(17)
	 jrst	%L1234
	skipn	4,-1(17)
	 jrst	%L1235
	setz	1,
	movem	1,-1(17)
	jrst	%L1233
%L1235:
	move	2,0(17)
	caie	2,0134
	 jrst	%L1236
	movei	1,1
	movem	1,-1(17)
	jrst	%L1233
%L1236:
	move	2,0(17)
	came	2,-2(17)
	 jrst	%L1233
	setz	1,
	movem	1,-2(17)
	jrst	%L1233
%L1234:
	move	3,0(17)
	cain	3,042
	 jrst	%L1238
	caie	3,047
	 jrst	%L1237
%L1238:
	move	2,0(17)
	movem	2,-2(17)
	jrst	%L1233
%L1237:
	move	2,0(17)
	cain	2,073
	 jrst	%L1231
%L1233:
	move	1,-5(17)
	ibp	1
	movem	1,-4(17)
	ibp	-5(17)
	move	2,-5(17)
	jrst	%L1230
%L1231:
%L1239:
	skipl	2,-4(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-6(17)
	 tlc	3,0770000
	rot	3,6
	camg	2,3
	 jrst	%L1240
	seto	1,
	move	16,-4(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L1240
	seto	2,
	PUSH	17,1
	move	16,-5(17)
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
	movem	2,-4(17)
	jrst	%L1239
%L1240:
	ldb	1,-4(17)
	dpb	1,[POINT 9,-3(17),35]
	setz	2,
	dpb	2,-4(17)
	move	4,01046(10)
	movem	4,0(13)
	move	2,-6(17)
	move	1,010
	pushj	17,rept_store_append_line
	jumpe	1,%L1241
	ldb	3,[POINT 9,-3(17),35]
	dpb	3,-4(17)
	seto	1,
	jrst	%L1219
%L1241:
	ldb	2,[POINT 9,-3(17),35]
	dpb	2,-4(17)
	setz	1,
%L1219:
	MOVEI	0,010
	HRLI	0,-044(17)
	BLT	0,013
	move	16,-045(17)
	SUB	17,[046,,046]
	popj	17,
%L1223:
	.byte	9,0111,0122,0120,0103
	.byte	9,0
	

%L1222:
	.byte	9,0111,0122,0120,0
	


iter_store_value_slice:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[1,,1]
%L1242:
	skipl	2,-5(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-6(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L1243
	ldb	1,-5(17)
	pushj	17,das_native_is_space
	jumpe	1,%L1243
	ibp	-5(17)
	move	2,-5(17)
	jrst	%L1242
%L1243:
%L1244:
	skipl	2,-6(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-5(17)
	 tlc	3,0770000
	rot	3,6
	camg	2,3
	 jrst	%L1245
	seto	1,
	move	16,-6(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	ldb	1,1
	pushj	17,das_native_is_space
	jumpe	1,%L1245
	seto	2,
	PUSH	17,1
	move	16,-7(17)
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
	movem	2,-6(17)
	jrst	%L1244
%L1245:
	move	4,-6(17)
	move	16,-5(17)
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
	sojle	5,%L1246
	ldb	1,-5(17)
	caie	1,042
	 jrst	%L1246
	seto	2,
	PUSH	17,1
	move	16,-7(17)
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
	caie	3,042
	 jrst	%L1246
	ibp	-5(17)
	move	6,-5(17)
	seto	1,
	move	16,-6(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	movem	1,-6(17)
%L1246:
	ldb	1,-6(17)
	dpb	1,[POINT 9,0(17),35]
	setz	2,
	dpb	2,-6(17)
	move	4,-3(17)
	move	3,01046(4)
	move	6,-7(17)
	movem	3,0(6)
	move	2,-5(17)
	move	1,-3(17)
	pushj	17,rept_store_append_line
	jumpe	1,%L1247
	ldb	3,[POINT 9,0(17),35]
	dpb	3,-6(17)
	seto	1,
	move	16,-1(17)
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1247:
	ldb	2,[POINT 9,0(17),35]
	dpb	2,-6(17)
	setz	1,
	move	16,-1(17)
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

iter_irp_next:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[014,,014]
	move	1,[POINT 9,das_native_tmp,8]
	movem	1,-013(17)
	movei	1,-012(17)
	push	17,1
	move	3,-014(17)
	move	1,-017(17)
	move	2,01046(1)
	move	6,-020(17)
	move	4,3
	move	3,2
	move	2,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1248
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1248:
	move	1,-013(17)
	pushj	17,strlen
	movem	1,-011(17)
	skipe	3,1
	 jrst	%L1249
	move	4,-021(17)
	skipn	2,0(4)
	 jrst	%L1250
	setm	1,3
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1250:
	movei	1,1
	move	3,-021(17)
	movem	1,0(3)
	move	4,-016(17)
	move	2,01046(4)
	move	6,-022(17)
	movem	2,0(6)
	move	2,[POINT 9,%L1253,8]
	move	3,-016(17)
	move	1,3
	pushj	17,rept_store_append_line
	jumpn	1,%L1251
	movei	1,1
	jrst	%L1252
%L1251:
	seto	1,
%L1252:
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1249:
	move	2,-020(17)
	move	1,0(2)
	tlc	1,0400000
	move	4,-011(17)
	tlc	4,0400000
	camge	1,4
	 jrst	%L1254
	setz	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1254:
	move	2,-020(17)
	move	4,0(2)
	movem	4,-010(17)
	PUSH	17,1
	move	16,-014(17)
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
	movem	4,-2(17)
	setz	1,
	movem	1,-4(17)
	movem	1,-5(17)
	movem	1,-6(17)
	movem	1,-7(17)
	setm	3,1
	movem	3,-3(17)
%L1255:
	move	2,-010(17)
	PUSH	17,1
	move	16,-014(17)
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
	movem	1,0(17)
	skipn	4,-7(17)
	 jrst	%L1257
	skipe	5,1
	 jrst	%L1258
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1258:
	skipn	2,-3(17)
	 jrst	%L1260
	setz	1,
	movem	1,-3(17)
	jrst	%L1259
%L1260:
	move	2,0(17)
	caie	2,0134
	 jrst	%L1261
	movei	1,1
	movem	1,-3(17)
	jrst	%L1259
%L1261:
	move	2,0(17)
	camn	2,-7(17)
	 tdza	1,1
	 trna	
	 movem	1,-7(17)
%L1259:
	aos	1,-010(17)
	jrst	%L1255
%L1257:
	move	3,0(17)
	cain	3,042
	 jrst	%L1263
	caie	3,047
	 jrst	%L1262
%L1263:
	move	2,0(17)
	movem	2,-7(17)
	aos	1,-010(17)
	jrst	%L1255
%L1262:
	move	2,0(17)
	caie	2,050
	 jrst	%L1265
	aos	1,-6(17)
	jrst	%L1264
%L1265:
	move	2,0(17)
	caie	2,051
	 jrst	%L1266
	skipe	3,-6(17)
	 jrst	%L1267
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1267:
	sos	1,-6(17)
	jrst	%L1264
%L1266:
	move	2,0(17)
	caie	2,0133
	 jrst	%L1268
	aos	1,-5(17)
	jrst	%L1264
%L1268:
	move	2,0(17)
	caie	2,0135
	 jrst	%L1269
	skipe	3,-5(17)
	 jrst	%L1270
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1270:
	sos	1,-5(17)
	jrst	%L1264
%L1269:
	move	2,0(17)
	caie	2,0173
	 jrst	%L1271
	aos	1,-4(17)
	jrst	%L1264
%L1271:
	move	2,0(17)
	caie	2,0175
	 jrst	%L1264
	skipe	3,-4(17)
	 jrst	%L1272
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1272:
	sos	1,-4(17)
%L1264:
	move	3,0(17)
	caie	3,054
	 jumpn	3,%L1273
	skipn	2,-6(17)
	 skipe	4,-5(17)
	 jrst	%L1273
	skipn	5,-4(17)
	 jrst	%L1256
%L1273:
	skipe	2,0(17)
	 jrst	%L1275
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1275:
	aos	1,-010(17)
	jrst	%L1255
%L1256:
	move	3,-010(17)
	PUSH	17,1
	move	16,-014(17)
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
	movem	3,-1(17)
	ldb	1,3
	cain	1,054
	 skipa	1,-010(17)
	 aosa	2,1
	 move	1,-010(17)
	move	5,-020(17)
	movem	2,0(5)
	movei	4,1
	move	7,-021(17)
	movem	4,0(7)
	push	17,-022(17)
	move	2,-2(17)
	move	3,-3(17)
	move	4,-014(17)
	move	1,-017(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,iter_store_value_slice
	SUB	17,[1,,1]
	jumpe	1,%L1278
	seto	1,
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1278:
	movei	1,1
	move	16,-014(17)
	SUB	17,[015,,015]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1253:
	.byte	9,0
	


iter_irpc_next:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[5,,5]
	move	1,[POINT 9,das_native_tmp,8]
	movem	1,-4(17)
	movei	1,-3(17)
	push	17,1
	move	3,-5(17)
	move	1,-010(17)
	move	2,01046(1)
	move	6,-011(17)
	move	4,3
	move	3,2
	move	2,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1279
	seto	1,
	move	16,-5(17)
	SUB	17,[6,,6]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1279:
	move	1,-4(17)
	pushj	17,strlen
	movem	1,-2(17)
	skipe	3,1
	 jrst	%L1280
	move	4,-012(17)
	skipn	2,0(4)
	 jrst	%L1281
	setm	1,3
	move	16,-5(17)
	SUB	17,[6,,6]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1281:
	movei	1,1
	move	3,-012(17)
	movem	1,0(3)
	move	4,-7(17)
	move	2,01046(4)
	move	6,-014(17)
	movem	2,0(6)
	move	2,[POINT 9,%L1284,8]
	move	3,-7(17)
	move	1,3
	pushj	17,rept_store_append_line
	jumpn	1,%L1282
	movei	1,1
	jrst	%L1283
%L1282:
	seto	1,
%L1283:
	move	16,-5(17)
	SUB	17,[6,,6]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1280:
	movei	1,1
	move	3,-012(17)
	movem	1,0(3)
%L1285:
	move	2,-011(17)
	move	1,0(2)
	tlc	1,0400000
	move	4,-2(17)
	tlc	4,0400000
	caml	1,4
	 jrst	%L1286
	move	2,-011(17)
	move	3,0(2)
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
	ldb	6,3
	movem	6,0(17)
	aos	7,0(2)
	move	1,0(17)
	caie	1,042
	 jrst	%L1287
	move	1,-013(17)
	skipe	5,0(1)
	 jrst	%L1288
	move	1,0(17)
	jrst	%L1289
%L1288:
	setz	1,
%L1289:
	move	3,-013(17)
	movem	1,0(3)
	jrst	%L1285
%L1287:
	move	2,-013(17)
	skipe	1,0(2)
	 jrst	%L1290
	move	1,0(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpn	1,%L1285
%L1290:
	move	2,0(17)
	andi	2,0777
	dpb	2,[POINT 9,-1(17),8]
	setz	1,
	dpb	1,[POINT 9,-1(17),17]
	move	4,-7(17)
	move	3,01046(4)
	move	6,-014(17)
	movem	3,0(6)
	movei	2,-1(17)
	hrli	2,0331100
	move	3,-7(17)
	move	1,3
	pushj	17,rept_store_append_line
	jumpn	1,%L1291
	movei	1,1
	jrst	%L1292
%L1291:
	seto	1,
%L1292:
	move	16,-5(17)
	SUB	17,[6,,6]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1286:
	move	2,-013(17)
	skipe	1,0(2)
	 jrst	%L1293
	setm	1,1
	jrst	%L1294
%L1293:
	seto	1,
%L1294:
	move	16,-5(17)
	SUB	17,[6,,6]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1284:
	.byte	9,0
	


ir_store_begin:
	push	17,010
	move	10,1
	push	17,[0444163516221]
	movei	1,0(17)
	move	6,010
	addi	6,01101
	move	2,1
	move	1,6
	movei	3,1
	pushj	17,wordfile_append
%L1295:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

ir_store_control:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,011
	andi	1,077
	lsh	1,036
	push	17,1
	movei	1,0(17)
	move	6,010
	addi	6,01101
	move	2,1
	move	1,6
	movei	3,1
	pushj	17,wordfile_append
%L1296:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

ir_store_append_line:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[4,,4]
	move	1,011
	pushj	17,strlen
	movem	1,-2(17)
	move	3,1
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L1298
	seto	1,
	jrst	%L1297
%L1298:
	move	2,-2(17)
	addi	2,3
	lsh	2,-2
	movem	2,-1(17)
	move	3,-2(17)
	tlo	3,010000
	movem	3,-3(17)
	movei	1,-3(17)
	move	6,010
	addi	6,01101
	move	2,1
	move	1,6
	movei	3,1
	pushj	17,wordfile_append
	jumpe	1,%L1299
	seto	1,
	jrst	%L1297
%L1299:
	movei	1,das_native_rept_record
	movem	1,0(17)
	skipn	3,-1(17)
	 jrst	%L1300
	move	2,-2(17)
	move	3,-1(17)
	move	1,0(17)
	move	4,2
	move	2,3
	move	3,011
	pushj	17,pack_text_words
	move	2,-1(17)
	move	6,0(17)
	move	1,010
	addi	1,01101
	move	3,2
	move	2,6
	pushj	17,wordfile_append
	jumpe	1,%L1300
	seto	1,
	jrst	%L1297
%L1300:
	setz	1,
%L1297:
	move	10,-5(17)
	move	11,-4(17)
	SUB	17,[6,,6]
	popj	17,

ir_store_read_line:
	ADD	17,[010,,010]
	MOVEI	0,-7(17)
	HRLI	0,010
	BLT	0,-4(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	2,0(11)
	tlc	2,0400000
	move	3,01102(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1303
	movei	1,-3(17)
	move	3,0(11)
	move	6,010
	addi	6,01101
	move	2,3
	move	3,1
	move	1,6
	movei	4,1
	pushj	17,wordfile_read
	jumpe	1,%L1302
%L1303:
	seto	1,
	jrst	%L1301
%L1302:
	aos	1,0(11)
	move	3,-3(17)
	lsh	3,-036
	movem	3,0(13)
	soje	3,%L1304
	setz	2,
	move	4,012
	dpb	2,4
	setz	1,
	jrst	%L1301
%L1304:
	hrrz	3,-3(17)
	movem	3,-2(17)
	tlc	3,0400000
	camge	3,[0400000000400]
	 jrst	%L1305
	seto	1,
	jrst	%L1301
%L1305:
	move	2,-2(17)
	addi	2,3
	lsh	2,-2
	movem	2,-1(17)
	move	3,0(11)
	add	3,2
	tlc	3,0400000
	move	4,01102(10)
	tlc	4,0400000
	camg	3,4
	 jrst	%L1306
	seto	1,
	jrst	%L1301
%L1306:
	movei	1,das_native_rept_record
	movem	1,0(17)
	skipn	3,-1(17)
	 jrst	%L1308
	move	2,-1(17)
	move	3,0(17)
	move	6,0(11)
	move	1,010
	addi	1,01101
	move	4,2
	move	2,6
	pushj	17,wordfile_read
	jumpe	1,%L1309
	seto	1,
	jrst	%L1301
%L1309:
	move	2,-2(17)
	move	3,0(17)
	move	1,012
	move	4,2
	movei	2,0400
	pushj	17,unpack_text_words
	jrst	%L1307
%L1308:
	setz	1,
	move	2,012
	dpb	1,2
%L1307:
	move	2,-1(17)
	addb	2,0(11)
	setz	1,
%L1301:
	MOVEI	0,010
	HRLI	0,-7(17)
	BLT	0,013
	SUB	17,[010,,010]
	popj	17,

ir_indexed_xct_targets:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[036,,036]
	move	1,[POINT 9,das_native_line,8]
	movem	1,-035(17)
	move	2,[POINT 9,das_native_inc,8]
	movem	2,-034(17)
	movei	3,1
	movem	3,-2(17)
	setzb	4,0(17)
%L1311:
	move	2,-2(17)
	tlc	2,0400000
	move	3,01102(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1312
	movei	4,-1(17)
	move	3,-035(17)
	movei	2,-2(17)
	move	1,010
	pushj	17,ir_store_read_line
	jumpe	1,%L1313
	seto	1,
	jrst	%L1310
%L1313:
	move	2,-1(17)
	sojn	2,%L1311
	movei	1,-033(17)
	move	2,-035(17)
	move	3,1
	move	1,010
	pushj	17,parse_line_head
	jumpe	1,%L1311
	move	2,-034(17)
	movei	1,-033(17)
	movei	3,050
	pushj	17,opt_indexed_xct_symbol
	jumpe	1,%L1311
	movei	2,1
	movem	2,0(17)
	move	3,011
	jumpe	3,%L1311
	move	2,-034(17)
	move	1,010
	pushj	17,mark_indexed_xct_target
	jrst	%L1311
%L1312:
	move	1,0(17)
%L1310:
	move	10,-037(17)
	move	11,-036(17)
	SUB	17,[040,,040]
	popj	17,

pass1_reset_semantics_for_ir_re:
	push	17,010
	move	10,1
	move	1,010
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,02000
	pushj	17,memset
	move	1,010
	addi	1,0400
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,01414
	pushj	17,memset
	setz	1,
	movem	1,0704(10)
	setm	2,1
	movem	2,0737(10)
	setz	3,
	movem	3,0740(10)
	setm	4,3
	movem	4,0741(10)
	setz	5,
	movem	5,0743(10)
	setm	6,5
	movem	6,0776(10)
	setz	7,
	movem	7,0777(10)
	setm	1,7
	movem	1,01000(10)
	setz	1,
	movem	1,01001(10)
	movem	1,01002(10)
	movem	1,01003(10)
	movem	1,01004(10)
	move	1,010
	addi	1,01135
	skipe	1,1
	 hrli	1,0331100
	setz	2,
	movei	3,020
	pushj	17,memset
	setz	1,
	movem	1,01141(10)
	setm	2,1
	move	3,010
	dpb	2,[POINT 9,01323(3),8]
	setz	4,
	movem	4,01337(10)
	setm	5,4
	movem	5,01336(10)
	setz	6,
	movem	6,01321(10)
	setm	7,6
	movem	7,01322(10)
	move	1,010
	move	10,0(17)
	SUB	17,[1,,1]
	jrst	opt_reset
%L1314:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

pass1_replay_ir:
	push	17,010
	move	10,1
	ADD	17,[4,,4]
	move	1,[POINT 9,das_native_line,8]
	movem	1,-3(17)
	movei	3,1
	movem	3,0(17)
	movem	3,-2(17)
%L1316:
	move	2,-2(17)
	tlc	2,0400000
	move	3,01102(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1317
	movei	4,-1(17)
	move	3,-3(17)
	movei	2,-2(17)
	move	1,010
	pushj	17,ir_store_read_line
	jumpe	1,%L1318
	movei	1,1
	jrst	%L1315
%L1318:
	move	2,-1(17)
	caie	2,2
	 jrst	%L1319
	move	1,010
	pushj	17,opt_reset
	jrst	%L1316
%L1319:
	move	2,-1(17)
	caie	2,3
	 jrst	%L1320
	movei	1,1
	iorb	1,01321(10)
	jrst	%L1316
%L1320:
	move	2,-1(17)
	soje	2,%L1321
	movei	1,1
	jrst	%L1315
%L1321:
	move	1,010
	pushj	17,source_advance
	jumpn	1,%L1322
	movei	1,0(17)
	move	2,-3(17)
	move	3,1
	move	1,010
	pushj	17,pass1_line
	jumpe	1,%L1316
%L1322:
	movei	1,1
	jrst	%L1315
%L1317:
	setz	1,
%L1315:
	move	10,-4(17)
	SUB	17,[5,,5]
	popj	17,

pass1_replay_indexed_xct:
	push	17,016
	push	17,010
	move	10,1
	move	2,[POINT 9,%L1325,8]
	move	1,010
	pushj	17,find_indexed_xct_marker
	jumpn	1,%L1324
	setm	1,1
	jrst	%L1323
%L1324:
	move	1,010
	pushj	17,pass1_reset_semantics_for_ir_re
	move	1,010
	movei	2,1
	pushj	17,ir_indexed_xct_targets
	jumpg	1,%L1326
	movei	1,1
	jrst	%L1323
%L1326:
	move	1,010
	move	10,0(17)
	move	16,-1(17)
	SUB	17,[2,,2]
	jrst	pass1_replay_ir
%L1323:
	move	10,0(17)
	move	16,-1(17)
	SUB	17,[2,,2]
	popj	17,
%L1325:
	.byte	9,0
	


phase_header:
	andi	1,077
	lsh	1,036
	move	4,2
	tlz	4,01777777777770000
	ior	1,4
	popj	17,

phase_write_words:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[034,,034]
	movei	1,-033(17)
	hrli	1,0331100
	setz	2,
	movei	3,0160
	pushj	17,memset
	movem	10,-033(17)
	movei	1,-033(17)
	move	2,011
	move	3,012
	pushj	17,wordfile_write
%L1327:
	move	10,-036(17)
	move	11,-035(17)
	move	12,-034(17)
	SUB	17,[037,,037]
	popj	17,

phase_copy_wordfile:
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movei	1,das_native_rept_record
	movem	1,-1(17)
%L1329:
	skipn	1,013
	 jrst	%L1330
	move	2,013
	tlc	2,0400000
	camg	2,[0400000000040]
	 jrst	%L1331
	movei	1,040
	jrst	%L1332
%L1331:
	move	1,013
%L1332:
	movem	1,0(17)
	move	2,0(17)
	move	3,-1(17)
	move	1,011
	move	4,2
	move	2,012
	pushj	17,wordfile_read
	jumpn	1,%L1334
	move	2,0(17)
	move	3,-1(17)
	move	1,010
	move	6,3
	move	3,2
	move	2,6
	pushj	17,phase_write_words
	jumpe	1,%L1333
%L1334:
	seto	1,
	jrst	%L1328
%L1333:
	move	2,0(17)
	addb	2,012
	move	3,0(17)
	move	1,013
	sub	1,3
	move	13,1
	jrst	%L1329
%L1330:
	setz	1,
%L1328:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	SUB	17,[6,,6]
	popj	17,

phase_export_stream:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[023,,023]
	setz	1,
	movem	1,-2(17)
	skipe	3,das_optimize
	 skipa	2,[1]
	 trna	
	 iorb	2,-2(17)
	skipe	5,das_strict_base
	 skipa	4,[2]
	 trna	
	 iorb	4,-2(17)
	skipe	7,das_kernel_mode
	 skipa	6,[4]
	 trna	
	 iorb	6,-2(17)
	move	2,-2(17)
	movem	2,-022(17)
	move	2,01141(10)
	movem	2,-021(17)
	move	2,01135(10)
	movem	2,-020(17)
	move	1,010
	addi	1,01135
	movei	2,1
	add	2,1
	move	1,0(2)
	movem	1,-017(17)
	move	1,01137(10)
	movem	1,-016(17)
	move	1,01140(10)
	movem	1,-015(17)
	move	2,0737(10)
	movem	2,-014(17)
	move	2,0776(10)
	movei	1,-022(17)
	movei	3,7
	add	3,1
	movem	2,0(3)
	move	2,0777(10)
	movem	2,-012(17)
	move	2,01000(10)
	movem	2,-011(17)
	move	2,01143(10)
	movem	2,-010(17)
	move	2,01144(10)
	movem	2,-7(17)
	move	2,01145(10)
	movem	2,-6(17)
	hrlz	2,0740(10)
	hrrz	3,0741(10)
	ior	2,3
	movei	1,-022(17)
	movei	3,015
	add	3,1
	movem	2,0(3)
	move	1,[0444163516222]
	movem	1,-3(17)
	movei	1,4
	movei	2,016
	pushj	17,phase_header
	movem	1,-4(17)
	movei	2,-3(17)
	move	1,011
	movei	3,1
	pushj	17,phase_write_words
	jumpn	1,%L1340
	movei	2,-4(17)
	move	1,011
	movei	3,1
	pushj	17,phase_write_words
	jumpn	1,%L1340
	movei	2,-022(17)
	move	1,011
	movei	3,016
	pushj	17,phase_write_words
	caie	1,0
%L1340:
	 skipa	3,[1]
	 setz	3,
	movem	3,0(17)
	jumpn	3,%L1341
	move	2,0737(10)
	movei	1,5
	pushj	17,phase_header
	movem	1,-4(17)
	movei	2,-4(17)
	move	1,011
	movei	3,1
	pushj	17,phase_write_words
	jumpn	1,%L1343
	move	2,0737(10)
	muli	2,015
	trne	2,1
	 tloa	3,0400000
	 tlz	3,0400000
	move	2,010
	addi	2,0703
	move	4,3
	move	1,011
	setz	3,
	pushj	17,phase_copy_wordfile
	caie	1,0
%L1343:
	 skipa	2,[1]
	 setz	2,
	movem	2,0(17)
%L1341:
	skipe	2,0(17)
	 jrst	%L1344
	move	2,0777(10)
	movei	1,6
	pushj	17,phase_header
	movem	1,-4(17)
	movei	2,-4(17)
	move	1,011
	movei	3,1
	pushj	17,phase_write_words
	jumpn	1,%L1346
	move	4,0777(10)
	move	1,010
	addi	1,0742
	move	2,1
	move	1,011
	setz	3,
	pushj	17,phase_copy_wordfile
	caie	1,0
%L1346:
	 skipa	2,[1]
	 setz	2,
	movem	2,0(17)
%L1344:
	skipe	2,0(17)
	 jrst	%L1347
	move	3,01102(10)
	subi	3,1
	movem	3,-1(17)
	move	2,-1(17)
	movei	1,7
	pushj	17,phase_header
	movem	1,-4(17)
	movei	2,-4(17)
	move	1,011
	movei	3,1
	pushj	17,phase_write_words
	jumpn	1,%L1349
	move	4,-1(17)
	move	1,010
	addi	1,01101
	move	2,1
	move	1,011
	movei	3,1
	pushj	17,phase_copy_wordfile
	caie	1,0
%L1349:
	 skipa	2,[1]
	 setz	2,
	movem	2,0(17)
%L1347:
	skipe	2,0(17)
	 jrst	%L1350
	movei	1,010
	setz	2,
	pushj	17,phase_header
	movem	1,-4(17)
	movei	2,-4(17)
	move	1,011
	movei	3,1
	pushj	17,phase_write_words
	cain	1,0
	 tdza	2,2
	 movei	2,1
	movem	2,0(17)
%L1350:
	skipn	2,0(17)
	 jrst	%L1353
	seto	1,
	jrst	%L1354
%L1353:
	setz	1,
%L1354:
%L1335:
	move	10,-024(17)
	move	11,-023(17)
	SUB	17,[025,,025]
	popj	17,

macro_name_eq:
	push	17,016
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,011
	camn	1,013
	 jrst	%L1356
	setz	1,
	jrst	%L1355
%L1356:
	setz	1,
	movem	1,-2(17)
%L1357:
	move	2,-2(17)
	tlc	2,0400000
	move	1,011
	tlc	1,0400000
	caml	2,1
	 jrst	%L1358
	move	4,-2(17)
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
	ldb	2,4
	andi	2,0777
	movem	2,-1(17)
	move	7,-2(17)
	move	6,012
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
	andi	1,0777
	movem	1,0(17)
	tlc	2,0400000
	camge	2,[0400000000141]
	 jrst	%L1360
	move	1,-1(17)
	tlc	1,0400000
	camle	1,[0400000000172]
	 jrst	%L1360
	move	1,-1(17)
	subi	1,040
	movem	1,-1(17)
%L1360:
	move	2,0(17)
	tlc	2,0400000
	camge	2,[0400000000141]
	 jrst	%L1361
	move	3,0(17)
	tlc	3,0400000
	camle	3,[0400000000172]
	 jrst	%L1361
	movni	4,040
	addb	4,0(17)
%L1361:
	move	2,-1(17)
	camn	2,0(17)
	 jrst	%L1362
	setz	1,
	jrst	%L1355
%L1362:
	aos	1,-2(17)
	jrst	%L1357
%L1358:
	movei	1,1
%L1355:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

macro_internal_key:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[3,,3]
	move	1,010
	pushj	17,strlen
	movem	1,-2(17)
	skipn	4,1
	 jrst	%L1365
	addi	4,2
	tlc	4,0400000
	move	2,012
	tlc	2,0400000
	camg	4,2
	 jrst	%L1364
%L1365:
	seto	1,
	jrst	%L1363
%L1364:
	movei	1,1
	move	2,011
	dpb	1,2
	setz	3,
	movem	3,-1(17)
%L1366:
	move	2,-1(17)
	tlc	2,0400000
	move	3,-2(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1367
	move	5,-1(17)
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	5,-1(17)
	MOVEM	10,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	5,0(17)
	SUB	17,[2,,2]
	POP	17,1
	ldb	6,5
	andi	6,0777
	movem	6,0(17)
	tlc	6,0400000
	camge	6,[0400000000141]
	 jrst	%L1369
	move	4,0(17)
	tlc	4,0400000
	camle	4,[0400000000172]
	 jrst	%L1369
	movni	7,040
	addb	7,0(17)
%L1369:
	move	2,0(17)
	andi	2,0777
	move	3,-1(17)
	addi	3,1
	move	1,011
	PUSH	17,1
	ADD	17,[2,,2]
	MOVEM	3,-1(17)
	MOVEM	1,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	MOVEM	1,0(17)
	MOVE	3,0(17)
	SUB	17,[2,,2]
	POP	17,1
	dpb	2,3
	aos	4,-1(17)
	jrst	%L1366
%L1367:
	setz	1,
	move	3,-2(17)
	addi	3,1
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
%L1363:
	move	10,-5(17)
	move	11,-4(17)
	move	12,-3(17)
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,

macro_name_reserved:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	move	1,010
	move	2,011
	pushj	17,classify_token
	jumpn	1,%L1372
	move	1,011
	pushj	17,sixbit_mn
	setz	2,
	pushj	17,lookup_op_mn
	jumpl	1,%L1371
%L1372:
	movei	1,1
	jrst	%L1370
%L1371:
	move	2,[POINT 9,%L1375,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1376,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1377,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1378,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1379,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1380,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1381,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1382,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1383,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	1,[POINT 9,%L1384,8]
	move	2,1
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	2,[POINT 9,%L1385,8]
	move	1,011
	pushj	17,streqi
	jumpn	1,%L1374
	move	1,[POINT 9,%L1386,8]
	move	2,1
	move	1,011
	pushj	17,streqi
	caie	1,0
%L1374:
	 skipa	1,[1]
	 setz	1,
%L1370:
	move	10,-1(17)
	move	11,0(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,
%L1386:
	.byte	9,0105,0116,0104,0111
	.byte	9,0106,0
	

%L1385:
	.byte	9,0105,0114,0123,0105
	.byte	9,0
	

%L1384:
	.byte	9,0111,0106,0116,0104
	.byte	9,0105,0106,0
	

%L1383:
	.byte	9,0111,0106,0104,0105
	.byte	9,0106,0
	

%L1382:
	.byte	9,0111,0106,0
	

%L1381:
	.byte	9,0111,0116,0103,0114
	.byte	9,0125,0104,0105,0
	

%L1380:
	.byte	9,0105,0116,0104,0122
	.byte	9,0
	

%L1379:
	.byte	9,0111,0122,0120,0103
	.byte	9,0
	

%L1378:
	.byte	9,0111,0122,0120,0
	

%L1377:
	.byte	9,0122,0105,0120,0124
	.byte	9,0
	

%L1376:
	.byte	9,0105,0116,0104,0115
	.byte	9,0
	

%L1375:
	.byte	9,0115,0101,0103,0122
	.byte	9,0117,0
	


macro_param_seen:
	ADD	17,[7,,7]
	MOVEI	0,-6(17)
	HRLI	0,010
	BLT	0,-3(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movem	10,-2(17)
%L1388:
	skipl	2,-2(17)
	 tlc	2,0770000
	rot	2,6
	move	1,011
	skipl	1,1
	 tlc	1,0770000
	rot	1,6
	caml	2,1
	 jrst	%L1389
%L1390:
	skipl	2,-2(17)
	 tlc	2,0770000
	rot	2,6
	move	1,011
	skipl	1,1
	 tlc	1,0770000
	rot	1,6
	caml	2,1
	 jrst	%L1391
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpn	1,%L1392
	ldb	2,-2(17)
	caie	2,054
	 jrst	%L1391
%L1392:
	ibp	-2(17)
	move	1,-2(17)
	jrst	%L1390
%L1391:
	skipl	2,-2(17)
	 tlc	2,0770000
	rot	2,6
	move	1,011
	skipl	1,1
	 tlc	1,0770000
	rot	1,6
	caml	2,1
	 jrst	%L1389
	move	4,-2(17)
	movem	4,-1(17)
%L1393:
	skipl	2,-2(17)
	 tlc	2,0770000
	rot	2,6
	move	1,011
	skipl	1,1
	 tlc	1,0770000
	rot	1,6
	caml	2,1
	 jrst	%L1394
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L1394
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L1393
%L1394:
	move	2,-2(17)
	move	1,-1(17)
	pushj	17,char_distance
	movem	1,0(17)
	move	2,0(17)
	move	1,-1(17)
	move	3,012
	move	4,013
	pushj	17,macro_name_eq
	jumpe	1,%L1395
	movei	1,1
	jrst	%L1387
%L1395:
%L1396:
	skipl	2,-2(17)
	 tlc	2,0770000
	rot	2,6
	move	1,011
	skipl	1,1
	 tlc	1,0770000
	rot	1,6
	caml	2,1
	 jrst	%L1397
	ldb	3,-2(17)
	cain	3,054
	 jrst	%L1397
	ibp	-2(17)
	move	4,-2(17)
	jrst	%L1396
%L1397:
	jrst	%L1388
%L1389:
	setz	1,
%L1387:
	MOVEI	0,010
	HRLI	0,-6(17)
	BLT	0,013
	SUB	17,[7,,7]
	popj	17,

macro_parse_definition:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[037,,037]
	move	3,-045(17)
	setzb	1,0(3)
	movei	1,-036(17)
	move	2,-042(17)
	move	4,-041(17)
	move	3,1
	move	1,4
	pushj	17,parse_line_head
	jumpe	1,%L1399
	skipn	3,-034(17)
	 jrst	%L1399
	move	1,[POINT 9,%L1400,8]
	movei	6,-032(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1398
%L1399:
	setz	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1398:
	skipn	2,-036(17)
	 jrst	%L1401
	movei	1,017647
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1401:
	move	1,-033(17)
	pushj	17,skipws
	movem	1,-5(17)
	ldb	1,-5(17)
	pushj	17,isname0
	jumpn	1,%L1402
	movei	1,017655
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1402:
	setz	1,
	movem	1,-3(17)
%L1403:
	ldb	1,-5(17)
	pushj	17,isname
	jumpe	1,%L1404
	move	3,-3(17)
	addi	3,1
	tlc	3,0400000
	move	4,-044(17)
	tlc	4,0400000
	camge	3,4
	 jrst	%L1405
	movei	1,017664
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1405:
	move	2,-5(17)
	ibp	-5(17)
	ldb	1,2
	aos	2,-3(17)
	subi	2,1
	PUSH	17,1
	move	16,-044(17)
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
	jrst	%L1403
%L1404:
	setz	1,
	move	4,-3(17)
	PUSH	17,1
	move	16,-044(17)
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
	move	3,-3(17)
	tlc	3,0400000
	camge	3,[0400000000047]
	 jrst	%L1406
	movei	1,017675
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1406:
	move	2,-043(17)
	move	1,-041(17)
	pushj	17,macro_name_reserved
	jumpe	1,%L1407
	movei	1,017703
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1407:
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-5(17)
	ldb	2,1
	jumpn	2,%L1408
	movei	1,1
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1408:
	move	2,-5(17)
	movem	2,-4(17)
	setz	1,
	movem	1,-2(17)
%L1409:
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-5(17)
	ldb	1,-5(17)
	pushj	17,isname0
	jumpn	1,%L1411
	movei	1,017722
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1411:
	move	2,-5(17)
	movem	2,-1(17)
%L1412:
	ldb	1,-5(17)
	pushj	17,isname
	jumpe	1,%L1413
	ibp	-5(17)
	move	2,-5(17)
	jrst	%L1412
%L1413:
	move	2,-5(17)
	move	1,-1(17)
	pushj	17,char_distance
	movem	1,0(17)
	move	2,0(17)
	move	3,-1(17)
	move	4,3
	move	1,-4(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_param_seen
	jumpe	1,%L1414
	movei	1,017734
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1414:
	aos	3,-2(17)
	tlc	3,0400000
	camg	3,[0400000000011]
	 jrst	%L1415
	movei	1,017743
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1415:
	move	1,-5(17)
	pushj	17,skipws
	movem	1,-5(17)
	ldb	3,1
	jumpe	3,%L1410
	cain	3,054
	 jrst	%L1416
	movei	1,017753
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1416:
	ibp	-5(17)
	move	1,-5(17)
	move	1,-5(17)
	pushj	17,skipws
	ldb	2,1
	jumpn	2,%L1417
	movei	1,017761
	pushj	17,das_native_diag
	seto	1,
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1417:
	jrst	%L1409
%L1410:
	move	2,-2(17)
	move	3,-045(17)
	movem	2,0(3)
	movei	1,1
	move	16,-037(17)
	SUB	17,[040,,040]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1400:
	.byte	9,0115,0101,0103,0122
	.byte	9,0117,0
	


macro_scan_head:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[5,,5]
	setz	1,
	movem	1,0(11)
	setm	2,1
	movem	2,1(11)
	setz	3,
	movem	3,2(11)
	setm	4,3
	movem	4,3(11)
	setz	5,
	move	6,011
	dpb	5,[POINT 9,4(6),8]
	move	1,010
	movei	2,073
	pushj	17,strchr
	movem	1,-4(17)
	jumpe	1,%L1419
	setz	2,
	dpb	2,1
%L1419:
	move	1,010
	pushj	17,rtrim
	move	1,010
	pushj	17,skipws
	movem	1,-4(17)
	ldb	2,1
	jumpn	2,%L1420
	setm	1,2
	jrst	%L1418
%L1420:
	move	1,-4(17)
	movei	2,072
	pushj	17,strchr
	movem	1,-3(17)
	jumpe	1,%L1421
	move	2,-3(17)
	move	1,-4(17)
	pushj	17,char_distance
	movem	1,-1(17)
%L1422:
	skipn	2,-1(17)
	 jrst	%L1423
	move	2,-1(17)
	subi	2,1
	PUSH	17,1
	move	16,-5(17)
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
	jumpe	1,%L1423
	sos	2,-1(17)
	jrst	%L1422
%L1423:
	move	2,-4(17)
	movem	2,0(11)
	move	3,-1(17)
	movem	3,1(11)
	move	1,-3(17)
	ibp	1
	pushj	17,skipws
	movem	1,-4(17)
	ldb	2,1
	jumpn	2,%L1421
	movei	1,1
	jrst	%L1418
%L1421:
	move	2,-4(17)
	movem	2,2(11)
	movem	2,-2(17)
	ldb	1,2
	caie	1,056
	 jrst	%L1424
	ibp	-2(17)
	move	3,-2(17)
%L1424:
	setzb	1,0(17)
%L1425:
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
	jumpe	1,%L1426
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
	jumpn	1,%L1426
	move	3,0(17)
	tlc	3,0400000
	caml	3,[0400000000047]
	 jrst	%L1426
	move	5,0(17)
	PUSH	17,1
	move	16,-3(17)
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
	move	4,011
	move	7,0(17)
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
	aos	6,0(17)
	jrst	%L1425
%L1426:
	setz	1,
	move	2,011
	move	4,0(17)
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
	move	1,0(17)
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	pushj	17,skipws
	movem	1,3(11)
	movei	1,1
%L1418:
	move	10,-6(17)
	move	11,-5(17)
	move	16,-7(17)
	SUB	17,[010,,010]
	popj	17,

macro_structure_kind:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[031,,031]
	movei	2,-030(17)
	move	1,011
	pushj	17,macro_scan_head
	skipe	3,-026(17)
	 jumpn	1,%L1428
	setz	1,
	jrst	%L1427
%L1428:
	move	1,[POINT 9,%L1431,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1430
	movei	1,1
	jrst	%L1427
%L1430:
	move	1,[POINT 9,%L1433,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpe	1,%L1432
	movei	1,2
	jrst	%L1427
%L1432:
	setz	1,
%L1427:
	move	10,-032(17)
	move	11,-031(17)
	move	16,-033(17)
	SUB	17,[034,,034]
	popj	17,
%L1433:
	.byte	9,0105,0116,0104,0115
	.byte	9,0
	

%L1431:
	.byte	9,0115,0101,0103,0122
	.byte	9,0117,0
	


macro_validate_endm:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[031,,031]
	movei	1,-030(17)
	move	2,011
	move	3,1
	move	1,010
	pushj	17,parse_line_head
	jumpe	1,%L1436
	skipn	3,-026(17)
	 jrst	%L1436
	move	1,[POINT 9,%L1437,8]
	movei	6,-024(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1435
%L1436:
	setz	1,
	jrst	%L1434
%L1435:
	skipe	2,-030(17)
	 jrst	%L1439
	move	1,-025(17)
	pushj	17,skipws
	ldb	2,1
	jumpe	2,%L1438
%L1439:
	movei	1,020076
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1434
%L1438:
	movei	1,1
%L1434:
	move	10,-032(17)
	move	11,-031(17)
	move	16,-033(17)
	SUB	17,[034,,034]
	popj	17,
%L1437:
	.byte	9,0105,0116,0104,0115
	.byte	9,0
	


macro_arg_scan:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[012,,012]
	move	2,-014(17)
	movem	2,-011(17)
%L1440:
	ldb	1,-011(17)
	jumpe	1,%L1441
	ldb	1,-011(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L1441
	ibp	-011(17)
	move	2,-011(17)
	jrst	%L1440
%L1441:
	ldb	2,-011(17)
	caie	2,073
	 jumpn	2,%L1442
	move	4,-020(17)
	setzb	1,0(4)
	skipe	5,-015(17)
	 jrst	%L1444
	setm	1,5
	jrst	%L1445
%L1444:
	seto	1,
%L1445:
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1442:
	move	2,-011(17)
	movem	2,-010(17)
	movei	1,1
	movem	1,-6(17)
	setz	3,
	movem	3,-2(17)
	movem	3,-3(17)
	movem	3,-4(17)
	movem	3,-5(17)
	setm	4,3
	movem	4,-1(17)
%L1446:
	ldb	1,-011(17)
	andi	1,0777
	movem	1,0(17)
	skipn	3,-2(17)
	 jrst	%L1448
	skipe	4,1
	 jrst	%L1449
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1449:
	skipn	2,-1(17)
	 jrst	%L1451
	setz	1,
	movem	1,-1(17)
	jrst	%L1450
%L1451:
	move	2,0(17)
	caie	2,0134
	 jrst	%L1452
	movei	1,1
	movem	1,-1(17)
	jrst	%L1450
%L1452:
	move	2,0(17)
	camn	2,-2(17)
	 tdza	1,1
	 trna	
	 movem	1,-2(17)
%L1450:
	ibp	-011(17)
	move	1,-011(17)
	jrst	%L1446
%L1448:
	move	3,0(17)
	cain	3,047
	 jrst	%L1454
	caie	3,042
	 jrst	%L1453
%L1454:
	move	2,0(17)
	movem	2,-2(17)
	ibp	-011(17)
	move	1,-011(17)
	jrst	%L1446
%L1453:
	skipe	2,0(17)
	 jrst	%L1455
	skipn	3,-5(17)
	 skipe	4,-4(17)
	 jrst	%L1456
	skipn	5,-3(17)
	 jrst	%L1455
%L1456:
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1455:
	move	2,0(17)
	caie	2,050
	 jrst	%L1458
	aos	1,-5(17)
	jrst	%L1457
%L1458:
	move	2,0(17)
	caie	2,051
	 jrst	%L1459
	skipe	3,-5(17)
	 jrst	%L1460
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1460:
	sos	1,-5(17)
	jrst	%L1457
%L1459:
	move	2,0(17)
	caie	2,0133
	 jrst	%L1461
	aos	1,-4(17)
	jrst	%L1457
%L1461:
	move	2,0(17)
	caie	2,0135
	 jrst	%L1462
	skipe	3,-4(17)
	 jrst	%L1463
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1463:
	sos	1,-4(17)
	jrst	%L1457
%L1462:
	move	2,0(17)
	caie	2,0173
	 jrst	%L1464
	aos	1,-3(17)
	jrst	%L1457
%L1464:
	move	2,0(17)
	caie	2,0175
	 jrst	%L1457
	skipe	3,-3(17)
	 jrst	%L1465
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1465:
	sos	1,-3(17)
%L1457:
	move	2,0(17)
	caie	2,054
	 cain	2,0
	 jrst	%L1467
	caie	2,073
	 jrst	%L1466
%L1467:
	skipn	2,-5(17)
	 skipe	3,-4(17)
	 jrst	%L1466
	skipe	4,-3(17)
	 jrst	%L1466
	move	5,-011(17)
	movem	5,-7(17)
%L1468:
	skipl	2,-7(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-010(17)
	 tlc	3,0770000
	rot	3,6
	camg	2,3
	 jrst	%L1469
	seto	1,
	move	16,-7(17)
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
	jumpe	1,%L1469
	seto	2,
	PUSH	17,1
	move	16,-010(17)
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
	movem	2,-7(17)
	jrst	%L1468
%L1469:
%L1470:
	skipl	2,-010(17)
	 tlc	2,0770000
	rot	2,6
	skipl	3,-7(17)
	 tlc	3,0770000
	rot	3,6
	caml	2,3
	 jrst	%L1471
	ldb	1,-010(17)
	andi	1,0777
	pushj	17,das_native_is_space
	jumpe	1,%L1471
	ibp	-010(17)
	move	2,-010(17)
	jrst	%L1470
%L1471:
	move	2,-010(17)
	came	2,-7(17)
	 jrst	%L1472
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1472:
	move	2,-6(17)
	camn	2,-015(17)
	 skipn	6,-016(17)
	 jrst	%L1473
	skipn	4,-017(17)
	 jrst	%L1473
	move	5,-010(17)
	movem	5,0(6)
	move	2,-7(17)
	move	1,-010(17)
	pushj	17,char_distance
	move	3,-017(17)
	movem	1,0(3)
%L1473:
	move	2,0(17)
	caie	2,054
	 jrst	%L1474
	aos	1,-6(17)
	ibp	-011(17)
	move	3,-011(17)
	move	2,-011(17)
	movem	2,-010(17)
	jrst	%L1446
%L1474:
	skipn	2,-5(17)
	 skipe	3,-4(17)
	 jrst	%L1476
	skipn	4,-3(17)
	 jrst	%L1475
%L1476:
	seto	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1475:
	move	2,-6(17)
	move	3,-020(17)
	movem	2,0(3)
	setz	1,
	move	16,-012(17)
	SUB	17,[013,,013]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1466:
	ibp	-011(17)
	move	1,-011(17)
	jrst	%L1446

macro_param_index:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[036,,036]
	movei	1,-4(17)
	push	17,1
	move	3,-045(17)
	move	1,-041(17)
	move	2,01046(1)
	move	6,-042(17)
	move	4,3
	move	3,2
	move	2,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpn	1,%L1478
	movei	1,-035(17)
	move	2,-044(17)
	move	4,-040(17)
	move	3,1
	move	1,4
	pushj	17,parse_line_head
	jumpe	1,%L1478
	skipn	3,-033(17)
	 jrst	%L1478
	move	1,[POINT 9,%L1479,8]
	movei	6,-031(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,streqi
	jumpn	1,%L1477
%L1478:
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1477:
	move	1,-032(17)
	pushj	17,skipws
	movem	1,-3(17)
%L1480:
	ldb	1,-3(17)
	pushj	17,isname
	jumpe	1,%L1481
	ibp	-3(17)
	move	2,-3(17)
	jrst	%L1480
%L1481:
	move	1,-3(17)
	pushj	17,skipws
	movem	1,-3(17)
	setz	2,
	movem	2,-2(17)
%L1482:
	ldb	2,-3(17)
	jumpe	2,%L1483
	caie	2,054
	 jrst	%L1484
	move	1,-3(17)
	ibp	1
	pushj	17,skipws
	movem	1,-3(17)
%L1484:
	move	2,-3(17)
	movem	2,-1(17)
	ldb	1,-3(17)
	pushj	17,isname0
	jumpn	1,%L1485
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1485:
%L1486:
	ldb	1,-3(17)
	pushj	17,isname
	jumpe	1,%L1487
	ibp	-3(17)
	move	2,-3(17)
	jrst	%L1486
%L1487:
	move	2,-3(17)
	move	1,-1(17)
	pushj	17,char_distance
	movem	1,0(17)
	aos	2,-2(17)
	move	2,-043(17)
	move	3,-042(17)
	move	4,0(17)
	move	1,-1(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_name_eq
	jumpe	1,%L1488
	move	3,-2(17)
	move	4,-045(17)
	movem	3,0(4)
	setz	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1488:
	move	1,-3(17)
	pushj	17,skipws
	movem	1,-3(17)
	ldb	3,1
	jumpe	3,%L1489
	cain	3,054
	 jrst	%L1489
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1489:
	jrst	%L1482
%L1483:
	movei	1,1
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1479:
	.byte	9,0115,0101,0103,0122
	.byte	9,0117,0
	


macro_append_text:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	move	2,-4(17)
	move	1,0(2)
	add	1,-6(17)
	tlc	1,0400000
	move	4,-3(17)
	tlc	4,0400000
	camge	1,4
	 jrst	%L1490
	seto	1,
	move	16,0(17)
	SUB	17,[1,,1]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1490:
	skipn	2,-6(17)
	 jrst	%L1491
	move	2,-6(17)
	move	6,-5(17)
	move	4,-4(17)
	move	1,0(4)
	move	16,-2(17)
	ADD	17,[2,,2]
	MOVEM	1,-1(17)
	MOVEM	16,0(17)
	MOVE	1,0(17)
	MOVE	16,-1(17)
	PUSHJ	17,%ADJBPH
	SUB	17,[2,,2]
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
%L1491:
	move	3,-6(17)
	move	5,-4(17)
	addb	3,0(5)
	setz	1,
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
	dpb	1,3
	setz	1,
	move	16,0(17)
	SUB	17,[1,,1]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

macro_append_arg:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[4,,4]
	movei	1,0(17)
	push	17,1
	move	3,-014(17)
	move	1,-6(17)
	move	2,01046(1)
	move	6,-7(17)
	move	4,3
	move	3,2
	move	2,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpn	1,%L1493
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	movei	3,-4(17)
	move	5,-010(17)
	move	1,-014(17)
	move	4,2
	move	2,5
	pushj	17,macro_arg_scan
	SUB	17,[1,,1]
	jumpn	1,%L1493
	skipn	4,-7(17)
	 jrst	%L1493
	tlc	4,0400000
	move	3,-1(17)
	tlc	3,0400000
	camg	4,3
	 jrst	%L1492
%L1493:
	seto	1,
	SUB	17,[4,,4]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1492:
	push	17,-2(17)
	move	2,-4(17)
	move	3,-013(17)
	move	4,-012(17)
	move	1,-011(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_append_text
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

iter_append_named:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[2,,2]
%L1494:
	skipn	2,-4(17)
	 jrst	%L1495
	movei	1,-1(17)
	push	17,1
	move	4,-013(17)
	move	1,-4(17)
	move	2,01046(1)
	move	6,-5(17)
	move	5,0(6)
	move	3,2
	move	2,5
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1496
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1496:
	move	1,-012(17)
	pushj	17,strlen
	movem	1,0(17)
	move	2,-6(17)
	move	3,-5(17)
	move	4,0(17)
	move	1,-012(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_name_eq
	jumpe	1,%L1497
	movei	1,-1(17)
	push	17,1
	move	4,-013(17)
	move	1,-4(17)
	move	2,01046(1)
	move	6,-5(17)
	move	5,1(6)
	move	3,2
	move	2,5
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1498
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1498:
	move	1,-012(17)
	pushj	17,strlen
	push	17,1
	move	2,-013(17)
	move	3,-012(17)
	move	4,-011(17)
	move	1,-010(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	jumpe	1,%L1499
	seto	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1499:
	movei	1,1
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1497:
	move	2,-4(17)
	move	1,2(2)
	movem	1,-4(17)
	jrst	%L1494
%L1495:
	setz	1,
	SUB	17,[2,,2]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

iter_substitute_line:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[7,,7]
	skipe	2,-012(17)
	 jrst	%L1500
	move	2,-015(17)
	move	3,-013(17)
	move	1,-014(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,strcopy
	move	1,-013(17)
	pushj	17,strlen
	tlc	1,0400000
	move	3,-015(17)
	tlc	3,0400000
	caml	1,3
	 jrst	%L1501
	setz	1,
	jrst	%L1502
%L1501:
	seto	1,
%L1502:
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1500:
	move	2,-013(17)
	movem	2,-6(17)
	setz	1,
	movem	1,-5(17)
	setm	3,1
	dpb	3,-014(17)
	setz	4,
	movem	4,-4(17)
	setm	5,4
	movem	5,-3(17)
%L1503:
	ldb	1,-6(17)
	jumpe	1,%L1504
	skipn	3,-4(17)
	 caie	1,073
	 jrst	%L1505
	move	1,-6(17)
	pushj	17,strlen
	push	17,1
	move	2,-7(17)
	movei	3,-6(17)
	move	4,-016(17)
	move	5,-015(17)
	move	1,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1505:
	ldb	1,-6(17)
	caie	1,0134
	 jrst	%L1506
	move	1,-6(17)
	ildb	1,1
	andi	1,0777
	pushj	17,isname0
	jumpe	1,%L1506
	move	2,-6(17)
	ibp	2
	movem	2,-2(17)
%L1507:
	ldb	1,-2(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L1508
	ibp	-2(17)
	move	2,-2(17)
	jrst	%L1507
%L1508:
	move	2,-2(17)
	move	1,-6(17)
	ibp	1
	pushj	17,char_distance
	movem	1,-1(17)
	push	17,-016(17)
	movei	1,-6(17)
	push	17,1
	push	17,-017(17)
	push	17,-017(17)
	move	3,-5(17)
	move	2,-012(17)
	ibp	2
	move	5,-016(17)
	move	1,-015(17)
	move	4,3
	move	3,2
	move	2,5
	pushj	17,iter_append_named
	SUB	17,[4,,4]
	movem	1,0(17)
	skipl	3,1
	 jrst	%L1509
	seto	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1509:
	skipg	2,0(17)
	 jrst	%L1510
	move	3,-2(17)
	movem	3,-6(17)
	jrst	%L1503
%L1510:
%L1506:
	push	17,[1]
	move	2,-7(17)
	movei	3,-6(17)
	move	4,-016(17)
	move	5,-015(17)
	move	1,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	jumpe	1,%L1511
	seto	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1511:
	skipn	2,-3(17)
	 jrst	%L1513
	setz	1,
	movem	1,-3(17)
	jrst	%L1512
%L1513:
	skipn	4,-4(17)
	 jrst	%L1514
	ldb	1,-6(17)
	andi	1,0777
	came	1,4
	 jrst	%L1514
	setz	2,
	movem	2,-4(17)
	jrst	%L1512
%L1514:
	skipn	2,-4(17)
	 jrst	%L1515
	ldb	1,-6(17)
	caie	1,0134
	 jrst	%L1515
	movei	3,1
	movem	3,-3(17)
	jrst	%L1512
%L1515:
	skipe	2,-4(17)
	 jrst	%L1512
	ldb	1,-6(17)
	cain	1,047
	 jrst	%L1516
	caie	1,042
	 jrst	%L1512
%L1516:
	ldb	1,-6(17)
	andi	1,0777
	movem	1,-4(17)
%L1512:
	ibp	-6(17)
	move	1,-6(17)
	jrst	%L1503
%L1504:
	setz	1,
	move	16,-7(17)
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

macro_substitute_line:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[017,,017]
	move	2,-025(17)
	movem	2,-016(17)
	setz	1,
	movem	1,-015(17)
	setm	3,1
	dpb	3,-026(17)
	setz	4,
	movem	4,-014(17)
	setm	5,4
	movem	5,-013(17)
%L1517:
	ldb	1,-016(17)
	jumpe	1,%L1518
	skipn	3,-014(17)
	 caie	1,073
	 jrst	%L1519
	move	1,-016(17)
	pushj	17,strlen
	push	17,1
	move	2,-017(17)
	movei	3,-016(17)
	move	4,-030(17)
	move	5,-027(17)
	move	1,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1519:
	ldb	1,-016(17)
	caie	1,0134
	 jrst	%L1520
	move	4,-016(17)
	ibp	4
	movem	4,-012(17)
	ldb	2,4
	jumpn	2,%L1521
	movei	1,020514
	pushj	17,das_native_diag
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1521:
	ldb	1,-012(17)
	caie	1,0134
	 jrst	%L1522
	push	17,[1]
	move	1,[POINT 9,%L1524,8]
	movei	3,-016(17)
	move	4,-030(17)
	move	5,-027(17)
	move	2,4
	move	4,1
	move	1,5
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	jumpe	1,%L1523
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1523:
	skipe	2,-014(17)
	 skipa	1,[1]
	 trna	
	 movem	1,-013(17)
	move	3,-016(17)
	ibp	3
	ibp	3
	movem	3,-016(17)
	jrst	%L1517
%L1522:
	ldb	1,-012(17)
	caie	1,050
	 jrst	%L1526
	move	2,-012(17)
	ildb	3,2
	caie	3,051
	 jrst	%L1526
	move	4,-016(17)
	ibp	4
	ibp	4
	ibp	4
	movem	4,-016(17)
	jrst	%L1517
%L1526:
	ldb	1,-012(17)
	caie	1,0100
	 jrst	%L1527
	move	2,-024(17)
	movei	1,-010(17)
	hrli	1,0331100
	pushj	17,das_format_u10
	movem	1,-4(17)
	push	17,-4(17)
	movei	1,-011(17)
	hrli	1,0331100
	movei	3,-016(17)
	move	4,-030(17)
	move	5,-027(17)
	move	2,4
	move	4,1
	move	1,5
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	jumpe	1,%L1528
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1528:
	move	1,-016(17)
	ibp	1
	ibp	1
	movem	1,-016(17)
	jrst	%L1517
%L1527:
	ldb	1,-012(17)
	cail	1,061
	 caile	1,071
	 jrst	%L1529
	subi	1,060
	movem	1,-011(17)
	push	17,-030(17)
	movei	1,-016(17)
	push	17,1
	push	17,-031(17)
	move	3,-031(17)
	move	4,-014(17)
	move	5,-026(17)
	move	1,-024(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,macro_append_arg
	SUB	17,[3,,3]
	jumpe	1,%L1530
	movei	1,020554
	pushj	17,das_native_diag
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1530:
	move	1,-016(17)
	ibp	1
	ibp	1
	movem	1,-016(17)
	jrst	%L1517
%L1529:
	ldb	1,-012(17)
	andi	1,0777
	pushj	17,isname0
	jumpe	1,%L1531
	move	3,-012(17)
	movem	3,-3(17)
%L1532:
	ldb	1,-012(17)
	andi	1,0777
	pushj	17,isname
	jumpe	1,%L1533
	ibp	-012(17)
	move	2,-012(17)
	jrst	%L1532
%L1533:
	move	2,-012(17)
	move	1,-3(17)
	pushj	17,char_distance
	movem	1,-2(17)
	movei	1,-011(17)
	push	17,1
	push	17,-031(17)
	move	3,-4(17)
	move	4,-5(17)
	move	5,-024(17)
	move	1,-023(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,macro_param_index
	SUB	17,[2,,2]
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L1534
	push	17,-030(17)
	movei	1,-016(17)
	push	17,1
	push	17,-031(17)
	move	3,-031(17)
	move	4,-014(17)
	move	5,-026(17)
	move	1,-024(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,macro_append_arg
	SUB	17,[3,,3]
	jumpe	1,%L1535
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1535:
	move	2,-012(17)
	movem	2,-016(17)
	jrst	%L1517
%L1534:
	push	17,-030(17)
	movei	1,-016(17)
	push	17,1
	push	17,-031(17)
	push	17,-031(17)
	move	3,-6(17)
	move	4,-7(17)
	move	5,-035(17)
	move	1,-025(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,iter_append_named
	SUB	17,[4,,4]
	movem	1,0(17)
	skipg	3,1
	 jrst	%L1536
	move	4,-012(17)
	movem	4,-016(17)
	jrst	%L1517
%L1536:
	skipl	2,0(17)
	 jrst	%L1537
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1537:
	movei	1,020621
	pushj	17,das_native_diag
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1531:
	movei	1,020626
	pushj	17,das_native_diag
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1520:
	push	17,[1]
	move	2,-017(17)
	movei	3,-016(17)
	move	4,-030(17)
	move	5,-027(17)
	move	1,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_append_text
	SUB	17,[1,,1]
	jumpe	1,%L1538
	seto	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1538:
	skipn	2,-013(17)
	 jrst	%L1540
	setz	1,
	movem	1,-013(17)
	jrst	%L1539
%L1540:
	skipn	4,-014(17)
	 jrst	%L1541
	ldb	1,-016(17)
	andi	1,0777
	came	1,4
	 jrst	%L1541
	setz	2,
	movem	2,-014(17)
	jrst	%L1539
%L1541:
	skipe	2,-014(17)
	 jrst	%L1539
	ldb	1,-016(17)
	cain	1,047
	 jrst	%L1542
	caie	1,042
	 jrst	%L1539
%L1542:
	ldb	1,-016(17)
	andi	1,0777
	movem	1,-014(17)
%L1539:
	ibp	-016(17)
	move	1,-016(17)
	jrst	%L1517
%L1518:
	setz	1,
	move	16,-017(17)
	SUB	17,[020,,020]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1524:
	.byte	9,0134,0
	


macro_lookup:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[026,,026]
	movei	2,-025(17)
	hrli	2,0331100
	move	1,011
	movei	3,050
	pushj	17,macro_internal_key
	jumpn	1,%L1545
	movei	3,-013(17)
	movei	2,-025(17)
	hrli	2,0331100
	move	1,010
	pushj	17,find_sym
	jumpe	1,%L1545
	movei	2,-025(17)
	hrli	2,0331100
	move	1,010
	pushj	17,symbol_visible_here
	jumpn	1,%L1544
%L1545:
	setz	1,
	jrst	%L1543
%L1544:
	move	2,-1(17)
	andi	2,030
	cain	2,010
	 jrst	%L1546
	setz	1,
	jrst	%L1543
%L1546:
	move	2,0(17)
	tlz	2,01777777777000000
	movem	2,0(12)
	movei	1,1
%L1543:
	move	10,-030(17)
	move	11,-027(17)
	move	12,-026(17)
	SUB	17,[031,,031]
	popj	17,

macro_frame_contains:
%L1547:
	skipn	3,1
	 jrst	%L1548
	move	5,0(1)
	came	5,2
	 jrst	%L1549
	movei	1,1
	popj	17,
%L1549:
	move	4,1(1)
	move	1,4
	jrst	%L1547
%L1548:
	setz	1,
	popj	17,

rept_find_end:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[5,,5]
	move	1,[POINT 9,das_native_tmp,8]
	movem	1,-2(17)
	move	3,-7(17)
	movem	3,-4(17)
	setz	2,
	movem	2,-3(17)
%L1550:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-010(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1551
	movei	1,-1(17)
	push	17,1
	move	3,-3(17)
	move	4,-011(17)
	move	5,-5(17)
	move	1,-7(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1552
	seto	1,
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1552:
	move	2,-2(17)
	move	1,-6(17)
	pushj	17,rept_structure_kind
	movem	1,0(17)
	sojn	1,%L1554
	aos	2,-3(17)
	jrst	%L1553
%L1554:
	move	2,0(17)
	caie	2,2
	 jrst	%L1553
	skipe	3,-3(17)
	 jrst	%L1555
	move	4,-4(17)
	move	5,-011(17)
	movem	4,0(5)
	move	6,-1(17)
	move	7,-012(17)
	movem	6,0(7)
	setm	1,3
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1555:
	sos	1,-3(17)
%L1553:
	move	2,-1(17)
	movem	2,-4(17)
	jrst	%L1550
%L1551:
	seto	1,
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

capture_rept_body:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[3,,3]
	move	2,-4(17)
	move	1,01046(2)
	move	4,-011(17)
	movem	1,0(4)
	setz	3,
	movem	3,-2(17)
%L1556:
	move	2,-6(17)
	move	1,-5(17)
	movei	3,0400
	pushj	17,das_read_line
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L1558
	movei	1,020770
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[3,,3]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1558:
	move	2,-1(17)
	came	2,[-2]
	 jrst	%L1559
	movei	1,020775
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[3,,3]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1559:
	move	2,-1(17)
	aojn	2,%L1560
	movei	1,021002
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[3,,3]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1560:
	move	2,-6(17)
	move	1,-7(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-7(17)
	move	1,-4(17)
	pushj	17,rept_structure_kind
	movem	1,0(17)
	caie	1,2
	 jrst	%L1562
	skipn	3,-2(17)
	 jrst	%L1557
	sos	2,-2(17)
	jrst	%L1561
%L1562:
	move	2,0(17)
	sojn	2,%L1561
	move	3,-2(17)
	add	3,-010(17)
	tlc	3,0400000
	camge	3,[0400000000010]
	 jrst	%L1563
	movei	1,021016
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[3,,3]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1563:
	aos	1,-2(17)
%L1561:
	move	2,-6(17)
	move	1,-4(17)
	pushj	17,rept_store_append_line
	jumpe	1,%L1564
	movei	1,021025
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[3,,3]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1564:
	jrst	%L1556
%L1557:
	move	2,-4(17)
	move	1,01046(2)
	move	4,-012(17)
	movem	1,0(4)
	setz	1,
	SUB	17,[3,,3]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

capture_macro_body:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[043,,043]
	move	2,-046(17)
	move	1,-050(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-2(17)
	push	17,1
	movei	2,-043(17)
	hrli	2,0331100
	move	4,-051(17)
	move	1,-045(17)
	move	3,2
	move	2,4
	movei	4,050
	pushj	17,macro_parse_definition
	SUB	17,[1,,1]
	jumpg	1,%L1565
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1565:
	movei	1,-030(17)
	hrli	1,0331100
	movei	6,-042(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,050
	pushj	17,macro_internal_key
	jumpn	1,%L1567
	movei	3,-016(17)
	movei	2,-030(17)
	hrli	2,0331100
	move	4,-044(17)
	move	1,4
	pushj	17,find_sym
	jumpe	1,%L1566
%L1567:
	movei	1,021055
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1566:
	move	2,-044(17)
	move	1,01046(2)
	move	4,-051(17)
	movem	1,0(4)
	move	2,-046(17)
	move	1,-044(17)
	pushj	17,rept_store_append_line
	jumpe	1,%L1568
	movei	1,021063
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1568:
%L1569:
	move	2,-047(17)
	move	1,-045(17)
	movei	3,0400
	pushj	17,das_read_line
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L1571
	movei	1,021075
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1571:
	move	2,-1(17)
	came	2,[-2]
	 jrst	%L1572
	movei	1,021102
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1572:
	move	2,-1(17)
	aojn	2,%L1573
	movei	1,021107
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1573:
	move	2,-047(17)
	move	1,-050(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-050(17)
	move	1,-044(17)
	pushj	17,macro_structure_kind
	movem	1,0(17)
	sojn	1,%L1574
	movei	1,021116
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1574:
	move	2,0(17)
	caie	2,2
	 jrst	%L1575
	move	2,-047(17)
	move	1,-050(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-050(17)
	move	1,-044(17)
	pushj	17,macro_validate_endm
	jumpg	1,%L1575
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1575:
	move	2,-047(17)
	move	1,-044(17)
	pushj	17,rept_store_append_line
	jumpe	1,%L1576
	movei	1,021130
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1576:
	move	2,0(17)
	caie	2,2
	 jrst	%L1569
	move	2,-051(17)
	move	1,0(2)
	movei	2,-030(17)
	hrli	2,0331100
	move	5,-044(17)
	move	4,1
	move	1,5
	movei	3,010
	pushj	17,add_sym
	movei	2,-030(17)
	hrli	2,0331100
	move	3,-044(17)
	move	1,3
	pushj	17,mark_symbol_visible
	setz	1,
	SUB	17,[043,,043]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

discard_macro_body:
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
%L1578:
	move	1,011
	move	2,012
	movei	3,0400
	pushj	17,das_read_line
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L1580
	movei	1,021157
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1577
%L1580:
	move	3,-1(17)
	came	3,[-2]
	 aojn	3,%L1581
	movei	1,021164
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1577
%L1581:
	move	1,012
	move	2,1
	move	1,013
	movei	3,0400
	pushj	17,strcopy
	move	1,010
	move	2,013
	pushj	17,macro_structure_kind
	movem	1,0(17)
	sojn	1,%L1583
	movei	1,021173
	pushj	17,das_native_diag
	seto	1,
	jrst	%L1577
%L1583:
	move	2,0(17)
	caie	2,2
	 jrst	%L1584
	move	1,010
	move	2,013
	pushj	17,macro_validate_endm
	jumple	1,%L1585
	setz	1,
	jrst	%L1586
%L1585:
	seto	1,
%L1586:
	jrst	%L1577
%L1584:
	jrst	%L1578
%L1577:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	SUB	17,[6,,6]
	popj	17,

macro_definition_end:
	ADD	17,[010,,010]
	MOVEI	0,-7(17)
	HRLI	0,010
	BLT	0,-4(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	1,[POINT 9,das_native_tmp,8]
	movem	1,-1(17)
	movei	1,-2(17)
	push	17,1
	move	3,-2(17)
	move	4,01046(10)
	move	1,010
	move	2,011
	move	6,4
	move	4,3
	move	3,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1588
	seto	1,
	jrst	%L1587
%L1588:
	move	3,-2(17)
	movem	3,0(12)
	movem	3,-3(17)
%L1589:
	move	2,-3(17)
	tlc	2,0400000
	move	3,01046(10)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1590
	movei	1,-2(17)
	push	17,1
	move	3,-2(17)
	move	4,01046(10)
	move	5,-4(17)
	move	1,010
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1591
	seto	1,
	jrst	%L1587
%L1591:
	move	2,-1(17)
	move	1,010
	pushj	17,macro_structure_kind
	movem	1,0(17)
	sojn	1,%L1592
	seto	1,
	jrst	%L1587
%L1592:
	move	2,0(17)
	caie	2,2
	 jrst	%L1593
	move	3,-3(17)
	movem	3,0(13)
	setz	1,
	jrst	%L1587
%L1593:
	move	2,-2(17)
	movem	2,-3(17)
	jrst	%L1589
%L1590:
	seto	1,
%L1587:
	MOVEI	0,010
	HRLI	0,-7(17)
	BLT	0,013
	SUB	17,[010,,010]
	popj	17,

macro_prepare_invocation:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[036,,036]
	setz	1,
	dpb	1,-043(17)
	movei	2,-035(17)
	move	3,-041(17)
	move	1,3
	pushj	17,macro_scan_head
	skipe	3,-033(17)
	 jumpn	1,%L1594
	setz	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1594:
	ldb	1,-033(17)
	cain	1,056
	 jrst	%L1597
	movei	1,-031(17)
	hrli	1,0331100
	pushj	17,sixbit_mn
	setz	2,
	pushj	17,lookup_op_mn
	jumpl	1,%L1596
%L1597:
	setz	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1596:
	move	3,-045(17)
	movei	1,-031(17)
	hrli	1,0331100
	move	4,-040(17)
	move	2,1
	move	1,4
	pushj	17,macro_lookup
	movem	1,0(17)
	jumpn	1,%L1598
	setm	1,1
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1598:
	movei	1,-2(17)
	push	17,1
	move	4,-043(17)
	move	1,-041(17)
	move	2,01046(1)
	move	6,-046(17)
	move	5,0(6)
	move	3,2
	move	2,5
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpn	1,%L1600
	movei	1,-4(17)
	push	17,1
	move	3,-045(17)
	move	4,-044(17)
	move	5,-043(17)
	move	1,-041(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,macro_parse_definition
	SUB	17,[1,,1]
	jumpg	1,%L1599
%L1600:
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1599:
	movei	1,-3(17)
	push	17,1
	move	1,-033(17)
	setz	2,
	setz	3,
	setz	4,
	pushj	17,macro_arg_scan
	SUB	17,[1,,1]
	jumpe	1,%L1601
	movei	1,021311
	pushj	17,das_native_diag
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1601:
	move	2,-3(17)
	camn	2,-4(17)
	 jrst	%L1602
	movei	1,021317
	pushj	17,das_native_diag
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1602:
	setz	1,
	dpb	1,-043(17)
	move	3,-040(17)
	move	2,01046(3)
	move	5,-046(17)
	movem	2,0(5)
	move	2,-032(17)
	move	1,-040(17)
	pushj	17,rept_store_append_line
	jumpe	1,%L1603
	movei	1,021327
	pushj	17,das_native_diag
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1603:
	move	2,-040(17)
	move	1,01337(2)
	move	4,-047(17)
	movem	1,0(4)
	skipn	5,-035(17)
	 jrst	%L1604
	move	7,-034(17)
	movem	7,-1(17)
	addi	7,2
	tlc	7,0400000
	move	6,-044(17)
	tlc	6,0400000
	camg	7,6
	 jrst	%L1605
	seto	1,
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1605:
	move	2,-1(17)
	move	3,-035(17)
	move	1,-043(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,das_native_memcpy
	movei	1,072
	move	3,-1(17)
	PUSH	17,1
	move	16,-044(17)
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
	setz	2,
	move	5,-1(17)
	addi	5,1
	PUSH	17,1
	move	16,-044(17)
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
	dpb	2,5
%L1604:
	movei	1,1
	move	16,-036(17)
	SUB	17,[037,,037]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

macro_materialize:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[5,,5]
	move	1,[POINT 9,das_native_line,8]
	movem	1,-3(17)
	move	2,[POINT 9,das_native_tmp,8]
	movem	2,-2(17)
	move	3,[POINT 9,das_native_inc,8]
	movem	3,-1(17)
	move	5,-6(17)
	move	4,01046(5)
	move	7,-014(17)
	movem	4,0(7)
	move	1,-012(17)
	movem	1,-4(17)
%L1606:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-013(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1607
	movei	1,0(17)
	push	17,1
	move	3,-4(17)
	move	4,-014(17)
	move	5,-5(17)
	move	1,-7(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1608
	seto	1,
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1608:
	move	2,0(17)
	movem	2,-4(17)
	push	17,-016(17)
	push	17,-2(17)
	push	17,[0400]
	push	17,-5(17)
	push	17,-7(17)
	move	2,-016(17)
	move	3,-015(17)
	move	4,-014(17)
	move	1,-013(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,macro_substitute_line
	SUB	17,[5,,5]
	jumpe	1,%L1609
	movei	1,021417
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1609:
	move	2,-2(17)
	move	1,-6(17)
	pushj	17,rept_store_append_line
	jumpe	1,%L1610
	movei	1,021424
	pushj	17,das_native_diag
	seto	1,
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1610:
	jrst	%L1606
%L1607:
	move	2,-6(17)
	move	1,01046(2)
	move	4,-015(17)
	movem	1,0(4)
	setz	1,
	SUB	17,[5,,5]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

pass1_iter_body:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[010,,010]
	setz	1,
	movem	1,-4(17)
	setm	2,1
	movem	2,-3(17)
	setz	3,
	movem	3,-2(17)
%L1611:
	move	2,-013(17)
	caie	2,3
	 jrst	%L1614
	movei	1,-1(17)
	push	17,1
	movei	2,-4(17)
	movei	3,-5(17)
	move	5,-016(17)
	move	1,-012(17)
	move	4,2
	move	2,5
	pushj	17,iter_irp_next
	SUB	17,[1,,1]
	movem	1,0(17)
	jrst	%L1613
%L1614:
	movei	1,-1(17)
	push	17,1
	movei	2,-3(17)
	push	17,2
	movei	3,-5(17)
	movei	4,-6(17)
	move	6,-017(17)
	move	1,-013(17)
	move	2,6
	move	6,4
	move	4,3
	move	3,6
	pushj	17,iter_irpc_next
	SUB	17,[2,,2]
	movem	1,0(17)
%L1613:
	skipl	2,0(17)
	 jrst	%L1615
	movei	1,021512
	pushj	17,das_native_diag
	movei	1,1
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1615:
	skipn	2,0(17)
	 jrst	%L1612
	move	3,-014(17)
	movem	3,-7(17)
	move	4,-1(17)
	movem	4,-6(17)
	move	5,-027(17)
	movem	5,-5(17)
	movei	1,-7(17)
	push	17,1
	push	17,-027(17)
	push	17,-027(17)
	push	17,-027(17)
	push	17,-027(17)
	push	17,-027(17)
	push	17,-027(17)
	push	17,-027(17)
	move	3,-027(17)
	move	4,-026(17)
	move	5,-022(17)
	move	1,-021(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,pass1_rept_body
	SUB	17,[010,,010]
	jumpe	1,%L1616
	movei	1,1
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1616:
	jrst	%L1611
%L1612:
	setz	1,
	SUB	17,[010,,010]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

source_advance:
	push	17,010
	move	10,1
	move	2,01337(1)
	tlc	2,0400000
	camge	2,[0400000777777]
	 jrst	%L1618
	movei	1,021536
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1617
%L1618:
	aos	1,01337(10)
	setz	1,
%L1617:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

pass1_ir_line:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	move	1,011
	move	2,1
	move	1,010
	pushj	17,ir_store_append_line
	jumpe	1,%L1620
	movei	1,021551
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1619
%L1620:
	move	1,010
	move	2,011
	move	3,012
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	jrst	pass1_line
%L1619:
	move	10,-2(17)
	move	11,-1(17)
	move	12,0(17)
	SUB	17,[3,,3]
	popj	17,

pass1_ir_reset:
	push	17,010
	move	10,1
	move	1,010
	pushj	17,opt_reset
	move	1,010
	movei	2,2
	pushj	17,ir_store_control
	jumpe	1,%L1622
	movei	1,021564
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1621
%L1622:
	setz	1,
%L1621:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

pass1_ir_guard:
	push	17,010
	move	10,1
	movei	1,1
	iorb	1,01321(10)
	move	1,010
	movei	2,3
	pushj	17,ir_store_control
	jumpe	1,%L1624
	movei	1,021577
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1623
%L1624:
	setz	1,
%L1623:
	move	10,0(17)
	SUB	17,[1,,1]
	popj	17,

pass1_macro_invoke:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	ADD	17,[021,,021]
	move	2,-036(17)
	tlc	2,0400000
	camge	2,[0400000000010]
	 jrst	%L1625
	movei	1,021627
	pushj	17,das_native_diag
	movei	1,1
	SUB	17,[021,,021]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1625:
	move	2,-025(17)
	move	1,-035(17)
	pushj	17,macro_frame_contains
	jumpe	1,%L1626
	movei	1,021634
	pushj	17,das_native_diag
	movei	1,1
	SUB	17,[021,,021]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1626:
	movei	1,-015(17)
	movei	3,-016(17)
	move	4,-025(17)
	move	5,-022(17)
	move	2,4
	move	4,1
	move	1,5
	pushj	17,macro_definition_end
	jumpn	1,%L1628
	push	17,-037(17)
	movei	1,-014(17)
	push	17,1
	movei	2,-016(17)
	push	17,2
	push	17,-020(17)
	push	17,-022(17)
	move	4,-034(17)
	move	5,-033(17)
	move	6,-032(17)
	move	1,-027(17)
	move	2,6
	move	3,5
	pushj	17,macro_materialize
	SUB	17,[5,,5]
	jumpe	1,%L1627
%L1628:
	movei	1,021643
	pushj	17,das_native_diag
	movei	1,1
	SUB	17,[021,,021]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1627:
	ldb	1,-024(17)
	jumpe	1,%L1629
	move	2,-024(17)
	movei	1,-012(17)
	hrli	1,0331100
	movei	3,051
	pushj	17,strcopy
	move	3,-030(17)
	movei	1,-012(17)
	hrli	1,0331100
	move	4,-022(17)
	move	2,1
	move	1,4
	pushj	17,pass1_ir_line
	jumpe	1,%L1630
	movei	1,1
	SUB	17,[021,,021]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1630:
	move	1,-022(17)
	pushj	17,pass1_ir_guard
	jumpe	1,%L1631
	movei	1,1
	SUB	17,[021,,021]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1631:
%L1629:
	move	2,-025(17)
	movem	2,-020(17)
	move	3,-035(17)
	movem	3,-017(17)
	push	17,-037(17)
	move	2,-037(17)
	addi	2,1
	push	17,2
	movei	1,-022(17)
	push	17,1
	push	17,-037(17)
	push	17,-037(17)
	push	17,-037(17)
	push	17,-037(17)
	push	17,-037(17)
	move	4,-023(17)
	move	5,-024(17)
	move	6,-033(17)
	move	1,-032(17)
	move	2,6
	move	3,5
	pushj	17,pass1_rept_body
	SUB	17,[031,,031]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

pass1_rept_body:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[043,,043]
	move	1,[POINT 9,das_native_line,8]
	movem	1,-040(17)
	move	2,[POINT 9,das_native_tmp,8]
	movem	2,-037(17)
	move	3,[POINT 9,das_native_inc,8]
	movem	3,-036(17)
	move	4,[POINT 9,das_native_dir,8]
	movem	4,-035(17)
	move	7,-052(17)
	imuli	7,0147
	PUSH	17,1
	move	16,[POINT 9,das_native_file_paths,8]
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
	movem	7,-034(17)
	movei	6,0147
	movem	6,-033(17)
	movem	6,-032(17)
	move	1,-047(17)
	movem	1,-042(17)
	move	1,-054(17)
	move	5,0(1)
	movem	5,-041(17)
%L1632:
	move	2,-042(17)
	tlc	2,0400000
	move	3,-050(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1633
	movei	1,-031(17)
	push	17,1
	move	3,-041(17)
	move	4,-051(17)
	move	5,-043(17)
	move	1,-046(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,rept_store_read_line
	SUB	17,[1,,1]
	jumpe	1,%L1634
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1634:
	move	2,-031(17)
	movem	2,-042(17)
	move	1,-045(17)
	pushj	17,source_advance
	jumpe	1,%L1635
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1635:
	skipn	2,-060(17)
	 jrst	%L1636
	push	17,-036(17)
	push	17,[0400]
	move	2,-041(17)
	move	3,-042(17)
	move	4,-062(17)
	move	1,-047(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,iter_substitute_line
	SUB	17,[2,,2]
	jumpe	1,%L1637
	movei	1,021762
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1637:
	move	2,-037(17)
	move	1,-040(17)
	movei	3,0400
	pushj	17,strcopy
%L1636:
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-051(17)
	move	2,0(2)
	move	4,-045(17)
	move	1,4
	pushj	17,sec_base
	move	2,-045(17)
	addi	2,01135
	move	4,-051(17)
	add	2,0(4)
	add	1,0(2)
	movem	1,-027(17)
	movei	1,-030(17)
	push	17,1
	move	3,-030(17)
	move	4,-055(17)
	move	5,-040(17)
	move	1,-046(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,conditional_line
	SUB	17,[1,,1]
	jumpe	1,%L1638
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1638:
	skipn	2,-030(17)
	 jrst	%L1639
	move	1,-045(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1632
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1639:
	move	1,-054(17)
	pushj	17,cond_active
	jumpn	1,%L1640
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-037(17)
	move	1,-045(17)
	pushj	17,macro_structure_kind
	jumpe	1,%L1641
	movei	1,022004
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1641:
	move	1,-045(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1632
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1640:
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-037(17)
	move	1,-045(17)
	pushj	17,macro_structure_kind
	movem	1,-025(17)
	skipn	3,1
	 jrst	%L1642
	movei	1,022017
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1642:
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-025(17)
	push	17,1
	movei	2,-027(17)
	move	4,-030(17)
	move	5,-040(17)
	move	1,-046(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,rept_count_line
	SUB	17,[1,,1]
	jumpe	1,%L1643
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1643:
	move	2,-025(17)
	caie	2,2
	 jrst	%L1644
	movei	1,022027
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1644:
	move	2,-025(17)
	soje	2,%L1646
	move	4,-025(17)
	cail	4,3
	 caile	4,4
	 jrst	%L1645
%L1646:
	move	2,-055(17)
	tlc	2,0400000
	camge	2,[0400000000010]
	 jrst	%L1647
	movei	1,022043
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1647:
	movei	1,-022(17)
	push	17,1
	movei	2,-024(17)
	move	4,-051(17)
	move	5,-043(17)
	move	1,-046(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,rept_find_end
	SUB	17,[1,,1]
	jumpe	1,%L1648
	movei	1,022050
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1648:
	move	2,-025(17)
	sojn	2,%L1650
	setm	1,2
	movem	1,-017(17)
%L1651:
	move	2,-017(17)
	tlc	2,0400000
	move	3,-026(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1652
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	move	2,-060(17)
	addi	2,1
	push	17,2
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	move	3,-033(17)
	move	4,-052(17)
	move	5,-056(17)
	move	1,-055(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,pass1_rept_body
	SUB	17,[010,,010]
	jumpe	1,%L1653
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1653:
	aos	1,-017(17)
	jrst	%L1651
%L1652:
	jrst	%L1649
%L1650:
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-020(17)
	movei	3,-021(17)
	move	4,-037(17)
	move	5,-045(17)
	move	2,4
	move	4,1
	move	1,5
	pushj	17,iter_store_spec
	jumpn	1,%L1654
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	move	2,-060(17)
	addi	2,1
	push	17,2
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-033(17)
	push	17,-053(17)
	push	17,-032(17)
	move	3,-034(17)
	move	4,-040(17)
	move	5,-061(17)
	move	1,-060(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,pass1_iter_body
	SUB	17,[013,,013]
	jumpe	1,%L1649
%L1654:
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1649:
	move	2,-022(17)
	movem	2,-042(17)
	move	1,-045(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1632
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1645:
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-014(17)
	push	17,1
	movei	2,-016(17)
	push	17,2
	movei	3,-020(17)
	push	17,3
	push	17,[051]
	movei	4,-017(17)
	hrli	4,0331100
	move	6,-042(17)
	move	2,-043(17)
	move	1,-051(17)
	move	3,6
	pushj	17,macro_prepare_invocation
	SUB	17,[4,,4]
	movem	1,0(17)
	skipl	3,1
	 jrst	%L1655
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1655:
	skipg	2,0(17)
	 jrst	%L1656
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-024(17)
	push	17,-026(17)
	move	2,-030(17)
	movei	3,-025(17)
	hrli	3,0331100
	move	4,-060(17)
	move	5,-057(17)
	move	1,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass1_macro_invoke
	SUB	17,[012,,012]
	jumpe	1,%L1632
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1656:
	move	2,-040(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-036(17)
	move	1,-037(17)
	movei	3,0400
	pushj	17,parse_include_line
	movem	1,-024(17)
	skipl	3,1
	 jrst	%L1657
	movei	1,022134
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1657:
	skipg	2,-024(17)
	 jrst	%L1659
	move	1,-045(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1660
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1660:
	move	2,-033(17)
	move	3,-035(17)
	move	1,-046(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,dirname_of
	move	2,-032(17)
	move	3,-034(17)
	move	4,-036(17)
	move	1,-035(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,join_path
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	push	17,-060(17)
	move	2,-060(17)
	addi	2,1
	move	3,-057(17)
	move	4,-042(17)
	move	1,-053(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass1_file
	SUB	17,[6,,6]
	jumpe	1,%L1658
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1659:
	move	2,-051(17)
	move	3,-040(17)
	move	1,-045(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,pass1_ir_line
	jumpe	1,%L1658
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1658:
	jrst	%L1632
%L1633:
	move	2,-054(17)
	move	1,0(2)
	camn	1,-041(17)
	 jrst	%L1661
	movei	1,022163
	pushj	17,das_native_diag
	movei	1,1
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1661:
	setz	1,
	move	16,-043(17)
	SUB	17,[044,,044]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)

pass1_file:
	pop	17,6
	ADD	17,[4,,4]
	movem	1,0(17)
	movem	2,-1(17)
	movem	3,-2(17)
	movem	4,-3(17)
	push	17,6
	push	17,016
	ADD	17,[0124,,0124]
	move	2,-0133(17)
	move	1,0(2)
	movem	1,-035(17)
	skipe	4,-0131(17)
	 jrst	%L1662
	setm	3,4
	move	6,-0126(17)
	movem	3,01321(6)
	move	1,-0126(17)
	setzb	5,01322(1)
%L1662:
	move	2,-0131(17)
	caig	2,010
	 jrst	%L1663
	movei	1,022241
	pushj	17,das_native_diag
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1663:
	move	1,[POINT 9,das_native_line,8]
	movem	1,-0105(17)
	move	2,[POINT 9,das_native_inc,8]
	movem	2,-0104(17)
	move	3,[POINT 9,das_native_dir,8]
	movem	3,-0103(17)
	move	6,-0131(17)
	imuli	6,0147
	PUSH	17,1
	move	16,[POINT 9,das_native_file_paths,8]
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
	movem	6,-0102(17)
	move	4,[POINT 9,das_native_tmp,8]
	movem	4,-0101(17)
	movei	5,-076(17)
	movem	5,-0121(17)
	movei	1,0147
	movem	1,-0100(17)
	movem	1,-077(17)
	move	2,[POINT 9,%L1664,8]
	move	3,-0127(17)
	move	1,3
	pushj	17,fopen
	movem	1,-0123(17)
	jumpn	1,%L1665
	movei	1,022272
	pushj	17,das_native_diag
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1665:
	move	2,-0123(17)
	movem	2,-0122(17)
	setzb	1,-0120(17)
	setm	3,1
	movem	3,-0117(17)
	movei	1,-0122(17)
	hrli	1,0331100
	movei	2,host_word_get
	movei	6,-0116(17)
	move	3,1
	move	1,6
	pushj	17,das_s6_init
	movei	1,das_s6_get
	movem	1,-0110(17)
	movei	2,-0116(17)
	hrli	2,0331100
	movem	2,-0107(17)
	setzb	3,-0106(17)
%L1666:
	move	2,-0105(17)
	movei	1,-0110(17)
	movei	3,0400
	pushj	17,das_read_line
	movem	1,-036(17)
	skipn	4,1
	 jrst	%L1667
	came	4,[-2]
	 jrst	%L1668
	movei	1,022334
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1668:
	move	2,-036(17)
	aojn	2,%L1669
	movei	1,022341
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1669:
	move	1,-0126(17)
	pushj	17,source_advance
	jumpe	1,%L1670
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1670:
	skipn	2,-0137(17)
	 jrst	%L1671
	push	17,-0104(17)
	push	17,[0400]
	move	2,-0103(17)
	move	3,-0107(17)
	move	4,-0141(17)
	move	1,-0130(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,iter_substitute_line
	SUB	17,[2,,2]
	jumpe	1,%L1672
	movei	1,022356
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1672:
	move	2,-0101(17)
	move	1,-0105(17)
	movei	3,0400
	pushj	17,strcopy
%L1671:
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-0130(17)
	move	2,0(2)
	move	4,-0126(17)
	move	1,4
	pushj	17,sec_base
	move	2,-0126(17)
	addi	2,01135
	move	4,-0130(17)
	add	2,0(4)
	add	1,0(2)
	movem	1,-032(17)
	movei	1,-033(17)
	push	17,1
	move	3,-033(17)
	move	4,-0134(17)
	move	5,-0102(17)
	move	1,-0127(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,conditional_line
	SUB	17,[1,,1]
	jumpe	1,%L1673
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1673:
	skipn	2,-033(17)
	 jrst	%L1674
	move	1,-0126(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1666
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1674:
	move	1,-0133(17)
	pushj	17,cond_active
	jumpn	1,%L1675
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-0101(17)
	move	1,-0126(17)
	pushj	17,macro_structure_kind
	movem	1,-031(17)
	sojn	1,%L1676
	move	4,-0101(17)
	move	3,-0105(17)
	movei	1,-0110(17)
	move	5,-0126(17)
	move	2,1
	move	1,5
	pushj	17,discard_macro_body
	jumpe	1,%L1676
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1676:
	move	1,-0126(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1666
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1675:
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-0101(17)
	move	1,-0126(17)
	pushj	17,macro_structure_kind
	movem	1,-030(17)
	caie	1,2
	 jrst	%L1677
	movei	1,022435
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1677:
	move	2,-030(17)
	sojn	2,%L1678
	skipn	3,-0136(17)
	 jrst	%L1679
	movei	1,022446
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1679:
	movei	1,-027(17)
	push	17,1
	push	17,-0102(17)
	move	3,-0107(17)
	move	4,3
	movei	2,-0112(17)
	move	1,-0130(17)
	move	6,4
	move	4,3
	move	3,6
	pushj	17,capture_macro_body
	SUB	17,[2,,2]
	jumpe	1,%L1680
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1680:
	move	1,-0126(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1666
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1678:
	move	2,-0130(17)
	move	2,0(2)
	move	4,-0126(17)
	move	1,4
	pushj	17,sec_base
	move	2,-0126(17)
	addi	2,01135
	move	4,-0130(17)
	add	2,0(4)
	add	1,0(2)
	movem	1,-025(17)
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-024(17)
	push	17,1
	movei	2,-027(17)
	move	4,-026(17)
	move	5,-0102(17)
	move	1,-0127(17)
	move	3,4
	move	4,2
	move	2,5
	pushj	17,rept_count_line
	SUB	17,[1,,1]
	jumpe	1,%L1681
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1681:
	move	2,-024(17)
	caie	2,2
	 jrst	%L1682
	movei	1,022503
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1682:
	move	2,-024(17)
	soje	2,%L1684
	move	4,-024(17)
	cail	4,3
	 caile	4,4
	 jrst	%L1683
%L1684:
	move	2,-0134(17)
	tlc	2,0400000
	camge	2,[0400000000010]
	 jrst	%L1685
	movei	1,022520
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1685:
	setz	1,
	movem	1,-021(17)
	setm	2,1
	movem	2,-020(17)
	move	4,-024(17)
	soje	4,%L1686
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-020(17)
	movei	3,-021(17)
	move	4,-0101(17)
	move	5,-0126(17)
	move	2,4
	move	4,1
	move	1,5
	pushj	17,iter_store_spec
	jumpe	1,%L1686
	movei	1,022533
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1686:
	movei	1,-022(17)
	push	17,1
	movei	2,-024(17)
	push	17,2
	move	4,-0136(17)
	addi	4,1
	push	17,4
	move	5,-0104(17)
	move	6,-0110(17)
	movei	2,-0113(17)
	move	1,-0131(17)
	move	3,6
	move	4,5
	pushj	17,capture_rept_body
	SUB	17,[3,,3]
	jumpe	1,%L1687
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1687:
	move	1,-0126(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1688
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1688:
	move	2,-024(17)
	sojn	2,%L1689
	setm	1,2
	movem	1,-017(17)
%L1690:
	move	2,-017(17)
	tlc	2,0400000
	move	3,-026(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1691
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	move	2,-0137(17)
	addi	2,1
	push	17,2
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	move	3,-032(17)
	move	4,-033(17)
	move	5,-0137(17)
	move	1,-0136(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,pass1_rept_body
	SUB	17,[010,,010]
	jumpe	1,%L1692
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1692:
	aos	1,-017(17)
	jrst	%L1690
%L1691:
	jrst	%L1666
%L1689:
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	move	2,-0137(17)
	addi	2,1
	push	17,2
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-032(17)
	push	17,-034(17)
	push	17,-032(17)
	move	3,-034(17)
	move	4,-037(17)
	move	5,-0142(17)
	move	1,-0141(17)
	move	2,5
	move	6,4
	move	4,3
	move	3,6
	pushj	17,pass1_iter_body
	SUB	17,[013,,013]
	jumpe	1,%L1666
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1683:
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	movei	1,-014(17)
	push	17,1
	movei	2,-016(17)
	push	17,2
	movei	3,-020(17)
	push	17,3
	push	17,[051]
	movei	4,-017(17)
	hrli	4,0331100
	move	6,-0110(17)
	move	2,-0105(17)
	move	1,-0132(17)
	move	3,6
	pushj	17,macro_prepare_invocation
	SUB	17,[4,,4]
	movem	1,0(17)
	skipl	3,1
	 jrst	%L1693
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1693:
	skipg	2,0(17)
	 jrst	%L1694
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-024(17)
	push	17,-026(17)
	move	2,-030(17)
	movei	3,-025(17)
	hrli	3,0331100
	move	4,-0141(17)
	move	5,-0140(17)
	move	1,5
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass1_macro_invoke
	SUB	17,[012,,012]
	jumpe	1,%L1666
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1694:
	move	2,-0105(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,strcopy
	move	2,-0104(17)
	move	1,-0101(17)
	movei	3,0400
	pushj	17,parse_include_line
	movem	1,-034(17)
	skipl	3,1
	 jrst	%L1695
	movei	1,022636
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1695:
	skipg	2,-034(17)
	 jrst	%L1697
	move	1,-0126(17)
	pushj	17,pass1_ir_reset
	jumpe	1,%L1698
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1698:
	move	2,-0100(17)
	move	3,-0103(17)
	move	1,-0127(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,dirname_of
	move	2,-077(17)
	move	3,-0102(17)
	move	4,-0104(17)
	move	1,-0103(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,join_path
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	push	17,-0137(17)
	move	2,-0137(17)
	addi	2,1
	move	3,-0136(17)
	move	4,-0110(17)
	move	1,-0134(17)
	move	6,4
	move	4,2
	move	2,6
	pushj	17,pass1_file
	SUB	17,[6,,6]
	jumpe	1,%L1696
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1697:
	move	2,-0130(17)
	move	3,-0105(17)
	move	1,-0126(17)
	move	6,3
	move	3,2
	move	2,6
	pushj	17,pass1_ir_line
	jumpe	1,%L1696
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1696:
	jrst	%L1666
%L1667:
	move	2,-0106(17)
	trnn	2,1
	 jrst	%L1699
	movei	1,022667
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1699:
	move	2,-0133(17)
	move	1,0(2)
	camn	1,-035(17)
	 jrst	%L1700
	movei	1,022675
	pushj	17,das_native_diag
	move	1,-0123(17)
	pushj	17,fclose
	movei	1,1
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1700:
	move	1,-0123(17)
	pushj	17,fclose
	setz	1,
	move	16,-0124(17)
	SUB	17,[0125,,0125]
	pop	17,6
	SUB	17,[4,,4]
	jrst	0(6)
%L1664:
	.byte	9,0162,0142,0
	


assemble_phase1_stream:
	push	17,016
	ADD	17,[030,,030]
	MOVEI	0,-027(17)
	HRLI	0,010
	BLT	0,-024(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	movei	1,das_native_ctx
	movem	1,-023(17)
	skipe	1,-023(17)
	 hrli	1,0331100
	setz	2,
	movei	3,05600
	pushj	17,memset
	move	1,-023(17)
	move	2,011
	pushj	17,store_init
	jumpe	1,%L1702
	movei	1,024201
	pushj	17,das_native_die
%L1702:
	move	1,-023(17)
	pushj	17,ir_store_begin
	jumpe	1,%L1703
	move	1,-023(17)
	pushj	17,store_close
	movei	1,024204
	pushj	17,das_native_die
%L1703:
	move	1,-023(17)
	setz	2,
	pushj	17,das_note_work
	movei	1,1
	movem	1,-3(17)
	movei	1,-6(17)
	hrli	1,0331100
	setz	2,
	movei	3,014
	pushj	17,memset
	move	1,-023(17)
	pushj	17,opt_reset
	push	17,[0]
	push	17,[0]
	push	17,[0]
	push	17,[0]
	movei	1,-012(17)
	push	17,1
	move	2,013
	push	17,2
	movei	3,-011(17)
	move	1,-031(17)
	move	2,010
	setz	4,
	pushj	17,pass1_file
	SUB	17,[6,,6]
	movem	1,-2(17)
	skipe	3,1
	 jrst	%L1704
	move	1,-023(17)
	pushj	17,pass1_replay_indexed_xct
	movem	1,-2(17)
%L1704:
	skipn	2,-2(17)
	 jrst	%L1705
	move	1,-023(17)
	pushj	17,store_close
	movei	1,1
	jrst	%L1701
%L1705:
	move	2,-023(17)
	ldb	1,[POINT 9,01323(2),8]
	jumpe	1,%L1707
	movei	1,-022(17)
	move	2,-023(17)
	addi	2,01323
	hrli	2,0331100
	move	4,-023(17)
	move	3,1
	move	1,4
	pushj	17,find_sym
	jumpn	1,%L1708
	movei	1,024224
	pushj	17,das_native_die
%L1708:
	move	2,-010(17)
	andi	2,7
	move	1,-023(17)
	pushj	17,sec_base
	hrrz	3,-7(17)
	add	1,3
	move	4,-023(17)
	movem	1,01141(4)
	jrst	%L1706
%L1707:
	movei	3,-022(17)
	move	2,[POINT 9,%L1709,8]
	move	4,-023(17)
	move	1,4
	pushj	17,find_sym
	jumpe	1,%L1706
	move	2,-010(17)
	andi	2,7
	move	1,-023(17)
	pushj	17,sec_base
	hrrz	3,-7(17)
	add	1,3
	move	4,-023(17)
	movem	1,01141(4)
%L1706:
	move	1,-023(17)
	pushj	17,text_total
	move	2,-023(17)
	add	1,01137(2)
	movem	1,-1(17)
	skipn	4,1
	 skipe	3,01140(2)
	 jrst	%L1710
	movei	1,024241
	pushj	17,das_native_die
%L1710:
	skipn	2,-1(17)
	 jrst	%L1711
	move	3,-023(17)
	move	1,01141(3)
	tlc	1,0400000
	move	5,-1(17)
	tlc	5,0400000
	camge	1,5
	 jrst	%L1711
	movei	1,024244
	pushj	17,das_native_die
%L1711:
	move	2,-1(17)
	addi	2,043
	SKIPL	3,2
	 TDZA	2,2
	  MOVEI	2,1
	DIVI	2,44
	movem	2,0(17)
	move	3,2
	move	4,-023(17)
	movem	3,01142(4)
	move	2,0(17)
	move	1,-023(17)
	pushj	17,das_note_work
	move	2,-1(17)
	tlc	2,0400000
	camle	2,[0400000036000]
	 jrst	%L1713
	move	1,-023(17)
	move	3,01140(1)
	tlc	3,0400000
	camle	3,[0400000020000]
	 jrst	%L1713
	move	4,-023(17)
	move	5,01140(4)
	add	5,-1(17)
	addi	5,02000
	tlc	5,0400000
	camg	5,[0400000040000]
	 jrst	%L1712
%L1713:
	movei	1,024255
	pushj	17,das_native_die
%L1712:
	move	1,-023(17)
	move	2,012
	pushj	17,phase_export_stream
	cain	1,0
	 tdza	2,2
	 movei	2,1
	movem	2,-2(17)
	move	1,-023(17)
	pushj	17,store_close
	skipn	2,-2(17)
	 jrst	%L1716
	movei	1,024263
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1701
%L1716:
	setz	1,
%L1701:
	MOVEI	0,010
	HRLI	0,-027(17)
	BLT	0,013
	move	16,-030(17)
	SUB	17,[031,,031]
	popj	17,
%L1709:
	.byte	9,0155,0141,0151,0156
	.byte	9,0
	


assemble_phase1_file:
	push	17,016
	ADD	17,[6,,6]
	MOVEI	0,-5(17)
	HRLI	0,010
	BLT	0,-2(17)
	move	10,1
	move	11,2
	move	12,3
	move	13,4
	move	2,[POINT 9,%L1718,8]
	move	1,012
	pushj	17,fopen
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L1719
	movei	1,024301
	pushj	17,das_native_diag
	movei	1,1
	jrst	%L1717
%L1719:
	move	2,-1(17)
	move	1,010
	move	3,2
	move	4,013
	move	2,011
	pushj	17,assemble_phase1_stream
	movem	1,0(17)
	move	1,-1(17)
	pushj	17,fclose
	jumpe	1,%L1720
	movei	2,1
	movem	2,0(17)
%L1720:
	skipn	2,0(17)
	 jrst	%L1721
	move	1,012
	pushj	17,remove
%L1721:
	move	1,0(17)
%L1717:
	MOVEI	0,010
	HRLI	0,-5(17)
	BLT	0,013
	move	16,-6(17)
	SUB	17,[7,,7]
	popj	17,
%L1718:
	.byte	9,0167,053,0142,0
	


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
	 jrst	%L1724
	skipe	3,012
	 jrst	%L1723
%L1724:
	movei	1,1
	jrst	%L1722
%L1723:
	hrrz	3,0(10)
	movem	3,-5(17)
	addi	3,1
	tlc	3,0400000
	move	1,012
	tlc	1,0400000
	camg	3,1
	 jrst	%L1725
	movei	1,1
	jrst	%L1722
%L1725:
	setz	1,
	movem	1,-4(17)
%L1726:
	move	2,-4(17)
	tlc	2,0400000
	move	3,-5(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L1727
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
	jrst	%L1726
%L1727:
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
%L1722:
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
	ADD	17,[0154,,0154]
	setz	1,
	pushj	17,dsys_close
	movei	1,1
	pushj	17,dsys_close
	skipge	1,010
	 jrst	%L1731
	move	2,010
	caig	2,020
	 skipa	3,011
	 trna	
	 jumpn	3,%L1730
%L1731:
	movei	1,1
	jrst	%L1729
%L1730:
	setz	1,
	movem	1,-3(17)
	setm	2,1
	movem	2,-2(17)
	movei	3,1
	movem	3,-1(17)
%L1732:
	move	2,-1(17)
	caml	2,010
	 jrst	%L1733
	movei	1,-035(17)
	hrli	1,0331100
	move	3,-1(17)
	add	3,011
	move	4,0(3)
	move	2,1
	move	1,4
	movei	3,0147
	pushj	17,das_counted_sixbit_arg_text
	jumpe	1,%L1735
	movei	1,1
	jrst	%L1729
%L1735:
	move	1,[POINT 9,%L1737,8]
	movei	6,-035(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,strcmp
	jumpn	1,%L1736
	aos	2,-1(17)
	caml	2,010
	 jrst	%L1739
	movei	1,-0153(17)
	hrli	1,0331100
	move	3,-1(17)
	add	3,011
	move	4,0(3)
	move	2,1
	move	1,4
	movei	3,0147
	pushj	17,das_counted_sixbit_arg_text
	jumpe	1,%L1738
%L1739:
	movei	1,1
	jrst	%L1729
%L1738:
	movei	1,1
	movem	1,-3(17)
	jrst	%L1734
%L1736:
	move	1,[POINT 9,%L1741,8]
	movei	6,-035(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,strcmp
	jumpn	1,%L1740
	movei	2,1
	movem	2,das_strict_base
	jrst	%L1734
%L1740:
	move	1,[POINT 9,%L1743,8]
	movei	6,-035(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,strcmp
	jumpn	1,%L1742
	movei	3,1
	movem	3,das_strict_base
	movem	3,das_kernel_mode
	jrst	%L1734
%L1742:
	move	1,[POINT 9,%L1745,8]
	movei	6,-035(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,strcmp
	jumpn	1,%L1744
	movei	2,1
	movem	2,das_optimize
	jrst	%L1734
%L1744:
	move	1,[POINT 9,%L1746,8]
	movei	6,-035(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	pushj	17,strcmp
	jumpe	1,%L1734
	ldb	3,[POINT 9,-035(17),8]
	caie	3,055
	 jrst	%L1747
	movei	1,1
	jrst	%L1729
%L1747:
	movei	1,-035(17)
	hrli	1,0331100
	movei	6,-0121(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,0147
	pushj	17,strcopy
	movei	1,1
	movem	1,-2(17)
%L1734:
	aos	1,-1(17)
	jrst	%L1732
%L1733:
	skipn	2,-3(17)
	 jrst	%L1749
	skipe	3,-2(17)
	 jrst	%L1748
%L1749:
	movei	1,1
	jrst	%L1729
%L1748:
	movei	1,-0153(17)
	hrli	1,0331100
	pushj	17,strlen
	movem	1,0(17)
	addi	1,4
	move	3,1
	tlc	3,0400000
	camg	3,[0400000000146]
	 jrst	%L1750
	movei	1,1
	jrst	%L1729
%L1750:
	movei	1,-0153(17)
	hrli	1,0331100
	movei	6,-067(17)
	hrli	6,0331100
	move	2,1
	move	1,6
	movei	3,0147
	pushj	17,strcopy
	movn	2,0(17)
	addi	2,0147
	move	1,[POINT 9,%L1751,8]
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
	movei	1,-067(17)
	hrli	1,0331100
	pushj	17,remove
	movei	1,-067(17)
	hrli	1,0331100
	movei	2,-0153(17)
	hrli	2,0331100
	movei	6,-0121(17)
	hrli	6,0331100
	move	3,1
	move	1,6
	movei	4,1
	pushj	17,assemble_phase1_file
%L1729:
	move	10,-0155(17)
	move	11,-0154(17)
	move	16,-0156(17)
	SUB	17,[0157,,0157]
	popj	17,
%L1751:
	.byte	9,056,0104,062,0122
	.byte	9,0
	

%L1746:
	.byte	9,055,0123,0
	

%L1745:
	.byte	9,055,0106,0
	

%L1743:
	.byte	9,055,0113,0
	

%L1741:
	.byte	9,055,0102,0
	

%L1737:
	.byte	9,055,0117,0
	


main:
	jrst	das_native_main

	.bss

das_native_files:
	.space 144

das_optimize:
	.space 4

das_native_file_paths:
	.space 928

das_native_inc:
	.space 256

das_native_dir:
	.space 104

das_native_rept_record:
	.space 260

das_native_line:
	.space 256

das_native_tmp:
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
	JUMPL	16,%UIDN13
	JUMPGE	2,%UIDP13
	CAIG	16,1
	 JRST	%UIDZ13
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
	 JRST	%UIDD13
	SUB	3,016
	AOJA	2,%UIDD13
%UIDN13:	MOVE	3,2
	MOVEI	2,0
	JUMPGE	3,%UIDD13
	CAMGE	3,016
	 JRST	%UIDD13
	SUB	3,016
	AOJA	2,%UIDD13
%UIDZ13:	TDZA	3,3
%UIDP13:	IDIV	2,016
%UIDD13:
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

