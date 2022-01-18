	.data
	.eqv	SIZE, 5
a:	.space 	40			# size*8 
k:	.double	0.0
	.text
	.globl 	main	
	
# $t0 -> i
# $t1 -> 
# $f2 -> *array[0]
# $f4 -> (double)read_int() 
	
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
	jal	average			# average(a, SIZE)
	
	mov.d 	$f12,$f0
	li	$v0,3		
	syscall				# print_double()
	
	li	$v0,0			# return 0;
	
	lw	$ra,0($sp)		# repoe registo $ra 
	addiu	$sp,$sp,4		# repoe espaço na stack
	
	li	$v0,0			# return 0;
	jr	$ra			# fim do programa
#--------------------------------------------------------------------------------------
# $t0 -> i 
# $t1 -> i-1 -> (i-1)*8
# $t2 -> array[i-1]
	
average:				# double average(double *array, int n) {
	move	$t0,$a1			# int i = n;
	l.d	$f4,k			# double sum = 0.0; // $f0 = 0.0
	move	$t3,$a0
avg_for:	
	blez	$t0,avg_endfor		# for(; i > 0; i--) {

	addi	$t1,$t0,-1		# i-1
	sll	$t1,$t1,3		# (i-1)*8
	addu	$t2,$t3,$t1		# $t2 = *array[i-1]
	
	l.d	$f2,0($t2)		# $f2 = array[i-1]
	add.d	$f4,$f4,$f2		# sum = sum + array[i-1]
	
	addi	$t0,$t0,-1		# i--
	j	avg_for		
avg_endfor:	
	mtc1	$a1,$f6			# $f6 = $a
	cvt.d.w	$f6,$f6			
	div.d	$f0,$f4,$f6		# return sum / (double)n 	
	
	jr	$ra			# fim da sub-rotina