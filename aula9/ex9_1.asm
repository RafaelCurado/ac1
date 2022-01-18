	.data
c1:	.float 2.59375
	.text
	.globl main	
	
# res -> float -> $f4
# val -> int   -> $t0

main:	
do:	li	$v0,5			# 
	syscall				# read_int();
	move	$t0,$v0			# val = read_int();
	mtc1 	$t0,$f0			# 
	cvt.s.w	$f0,$f0			# 
	l.s 	$f2, c1
	mul.s	$f4, $f0, $f2		# res = (float)val * 2.59375
	
	li	$v0,2		
	mov.s	$f12,$f4		# 
	syscall				# print_float(res)
	
	mtc1	$0,$f8			# $f8 = 0
	cvt.s.w	$f8,$f8			# $f8 = 0.0
	c.eq.s	$f4,$f8			# ? $f4 = $f8 ?
while:	bc1f	do			# while(res != 0.0)
	
	li	$v0,0			# return 0;	
	jr	$ra			# termina o programa	
	

	