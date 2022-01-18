	.data
	.eqv	SIZE, 5
a:	.space 	40			# size*8 
	.text
	.globl 	main	
	
main:	
	addiu	$sp,$sp,-4		# reservar espaço na stack
	sw	$ra,0($sp)		# guarda registo $ra na stack
	
	li	$t0,0			# i = 0
	la	$t1,a			# $f2 = *array[0]
	
for:	bge	$t0,SIZE,endfor		# for(i = 0; i < SIZE; i++)
	
	sll	$t2,$t0,3		# $t2 = i*8
	addu	$t3,$t2,$t1		# $t3 = array[i]
	
	li	$v0,5			
	syscall				# read_int();
	mtc1	$v0,$f4			# 
	cvt.d.w	$f4,$f4			# $f4 = (double)read_int()
	s.d	$f4,0($t3)		# a[i] = (double)read_int();
	
	addi	$t0,$t0,1		# i++
	j	for
endfor:
	la	$a0,a			# $a0 = a
	li	$a1,SIZE		# $a1 = SIZE
	jal	max			# max(a, SIZE)
	
	mov.d 	$f12,$f0
	li	$v0,3		
	syscall				# print_double()
	
	li	$v0,0			# return 0;
	
	lw	$ra,0($sp)		# repoe registo $ra 
	addiu	$sp,$sp,4		# repoe espaço na stack
	
	li	$v0,0			# return 0;
	jr	$ra			# fim do programa





#--------------------------------------------------------------------------------------
# $a0 -> *p
# $a1 -> n

max:					# double max(double *p, unsigned int n) {
	move	$t0,$a0
	move	$t1,$a1	
	
	addi	$t1,$t1,-1		# $t1 = n - 1
	sll	$t1,$t1,3		# (n - 1)`* 3
	addu	$t2,$t0,$t1		# *u  = p + n – 1
	
	l.d	$f0,0($t0)		# $f0 = *p
	addiu	$t0,$t0,8		# p++
	
max_for:
	bgt	$t0,$t2,max_endfor	# for(; p <= u; p++) {
	
	l.d	$f2,0($t0)		# $f2 = *p
max_if:	
	c.le.d	$f2,$f0		
	bc1t	max_endif		# if(*p > max) {
	
	mov.d	$f0,$f2			# max = *p;
max_endif:
	addiu	$t0,$t0,8		# p++
	j 	max_for
max_endfor:
	jr	$ra			# fim da função
	
	
	