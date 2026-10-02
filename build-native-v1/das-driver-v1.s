	.text

	.data

das1_path:
	.word 021
	.word 0176371636445
	.word 0551745704543
	.word 0174441632100

das2_path:
	.word 021
	.word 0176371636445
	.word 0551745704543
	.word 0174441632200

das2_name:
	.word 4
	.word 0444163220000

opt_o:
	.word 2
	.word 0155700000000

	.text

s6_char:
	push	17,016
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[2,,2]
	move	1,011
	SKIPL	2,1
	 TDZA	1,1
	  MOVEI	1,1
	DIVI	1,6
	addi	1,1
	movem	1,-1(17)
	movem	2,0(17)
	move	5,010
	add	5,1
	move	1,0(5)
	move	6,2
	muli	6,6
	trne	6,1
	 tloa	7,0400000
	 tlz	7,0400000
	movn	7,7
	addi	7,036
	movn	7,7
	lsh	1,0(7)
	andi	1,077
	addi	1,040
%L1:
	move	10,-3(17)
	move	11,-2(17)
	move	16,-4(17)
	SUB	17,[5,,5]
	popj	17,

record_words:
	push	17,016
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	skipe	1,010
	 jrst	%L3
	setm	1,1
	jrst	%L2
%L3:
	hrrz	2,0(10)
	movem	2,0(17)
	jumpe	2,%L5
	tlc	2,0400000
	camg	2,[0400000000146]
	 jrst	%L4
%L5:
	setz	1,
	jrst	%L2
%L4:
	move	2,0(17)
	addi	2,5
	SKIPL	3,2
	 TDZA	2,2
	  MOVEI	2,1
	DIVI	2,6
	aos	1,2
%L2:
	move	10,-1(17)
	move	16,-2(17)
	SUB	17,[3,,3]
	popj	17,

copy_record:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[2,,2]
	move	1,012
	pushj	17,record_words
	movem	1,-1(17)
	skipn	3,1
	 jrst	%L8
	move	4,0(11)
	tlc	4,0400000
	movn	5,-1(17)
	addi	5,0471
	tlc	5,0400000
	camg	4,5
	 jrst	%L7
%L8:
	seto	1,
	jrst	%L6
%L7:
	setzb	1,0(17)
%L9:
	move	2,0(17)
	tlc	2,0400000
	move	3,-1(17)
	tlc	3,0400000
	caml	2,3
	 jrst	%L10
	move	5,012
	add	5,0(17)
	move	1,0(5)
	aos	4,0(11)
	subi	4,1
	add	4,010
	movem	1,0(4)
	aos	7,0(17)
	jrst	%L9
%L10:
	setz	1,
%L6:
	move	10,-4(17)
	move	11,-3(17)
	move	12,-2(17)
	SUB	17,[5,,5]
	popj	17,

is_output_option:
	push	17,010
	move	10,1
	ADD	17,[1,,1]
	move	1,010
	jumpe	1,%L14
	hrrz	3,0(10)
	cain	3,2
	 jrst	%L13
%L14:
	setz	1,
	jrst	%L12
%L13:
	move	1,010
	setz	2,
	pushj	17,s6_char
	cain	1,055
	 jrst	%L15
	setz	1,
	jrst	%L12
%L15:
	move	1,010
	movei	2,1
	pushj	17,s6_char
	caie	1,0117
	 tdza	1,1
	 movei	1,1
%L12:
	move	10,-1(17)
	SUB	17,[2,,2]
	popj	17,

find_output:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,[1]
%L19:
	move	2,0(17)
	addi	2,1
	caml	2,010
	 jrst	%L20
	move	2,0(17)
	add	2,011
	move	1,0(2)
	pushj	17,is_output_option
	jumpe	1,%L21
	move	3,0(17)
	add	3,011
	move	1,1(3)
	jrst	%L18
%L21:
	aos	1,0(17)
	jrst	%L19
%L20:
	setz	1,
%L18:
	move	10,-2(17)
	move	11,-1(17)
	SUB	17,[3,,3]
	popj	17,

run_child:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	push	17,012
	move	12,3
	ADD	17,[0476,,0476]
	move	1,012
	jumpe	1,%L24
	move	2,012
	tlc	2,0400000
	camg	2,[0400000000020]
	 jrst	%L23
%L24:
	movei	1,0176
	jrst	%L22
%L23:
	movei	1,6
	movem	1,-2(17)
	movei	1,-2(17)
	movei	2,-0475(17)
	move	3,010
	move	6,2
	move	2,1
	move	1,6
	pushj	17,copy_record
	jumpe	1,%L25
	movei	1,0176
	jrst	%L22
%L25:
	setz	1,
	movem	1,-1(17)
%L26:
	move	2,-1(17)
	tlc	2,0400000
	move	1,012
	tlc	1,0400000
	caml	2,1
	 jrst	%L27
	move	2,-1(17)
	add	2,011
	move	3,0(2)
	movei	4,-2(17)
	movei	1,-0475(17)
	move	2,4
	pushj	17,copy_record
	jumpe	1,%L28
	movei	1,0176
	jrst	%L22
%L28:
	aos	1,-1(17)
	jrst	%L26
%L27:
	move	2,-2(17)
	tlc	2,0400000
	camge	2,[0400000000471]
	 jrst	%L29
	movei	1,0176
	jrst	%L22
%L29:
	move	1,[02000002]
	movei	2,-0475(17)
	aos	3,-2(17)
	add	3,2
	movem	1,-1(3)
	movei	7,-0475(17)
	movem	7,-4(17)
	hrrz	6,-2(17)
	tlo	6,2
	movem	6,0(7)
	move	1,-4(17)
	setzb	4,1(1)
	setm	5,4
	move	2,-4(17)
	movem	5,2(2)
	movei	1,1
	move	3,-4(17)
	movem	1,3(3)
	move	1,012
	move	3,-4(17)
	movem	1,4(3)
	move	3,-4(17)
	setzb	1,5(3)
	move	1,-4(17)
	pushj	17,dsys_run
	movem	1,0(17)
	skipl	3,1
	 jrst	%L30
	movei	1,0176
	jrst	%L22
%L30:
	setz	1,
	movem	1,-3(17)
	movei	2,-3(17)
	move	3,0(17)
	move	1,3
	setz	3,
	pushj	17,dsys_wait
	camn	1,0(17)
	 jrst	%L31
	movei	1,0176
	jrst	%L22
%L31:
	hlrz	2,-3(17)
	andi	2,3
	soje	2,%L32
	movei	1,0176
	jrst	%L22
%L32:
	hrrz	1,-3(17)
%L22:
	move	10,-0500(17)
	move	11,-0477(17)
	move	12,-0476(17)
	SUB	17,[0501,,0501]
	popj	17,

main:
	push	17,010
	move	10,1
	push	17,011
	move	11,2
	ADD	17,[5,,5]
	skiple	1,010
	 skipa	2,011
	 trna	
	 jumpn	2,%L34
	movei	1,1
	jrst	%L33
%L34:
	move	1,010
	move	2,011
	pushj	17,find_output
	movem	1,-1(17)
	skipe	3,1
	 jrst	%L36
	movei	1,1
	jrst	%L33
%L36:
	move	3,010
	movei	2,das1_path
	move	1,2
	move	2,011
	pushj	17,run_child
	movem	1,0(17)
	jumpn	1,%L33
	movei	2,das2_name
	movem	2,-4(17)
	movei	3,opt_o
	movei	4,-4(17)
	movei	5,1
	add	5,4
	movem	3,0(5)
	move	7,-1(17)
	movei	6,-4(17)
	movei	1,2
	add	1,6
	movem	7,0(1)
	movei	1,-4(17)
	movei	6,das2_path
	move	2,1
	move	1,6
	movei	3,3
	pushj	17,run_child
%L33:
	move	10,-6(17)
	move	11,-5(17)
	SUB	17,[7,,7]
	popj	17,


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
;	.extern	dsys_open
;	.extern	dsys_close
;	.extern	dsys_readchar
;	.extern	dsys_writechar
;	.extern	dsys_read_words
;	.extern	dsys_write_words
;	.extern	dsys_stat
;	.extern	dsys_dirread
;	.extern	dsys_mkdir
;	.extern	dsys_unlink
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
;	.extern	dsys_seek
;	.extern	dsys_symlink
;	.extern	dsys_nice
	.extern	dsys_run
	.extern	dsys_wait
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
;	.extern	dsys_exit
;	.extern	dsys_halt

