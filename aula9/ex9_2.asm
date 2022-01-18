	.data
c5:	.double	5.0
c9:	.double	9.0
c32:	.double	32.0
	.text
	.globl main	
	
main:	
	addiu	$sp,$sp,-4	# reserva espaço na stack
	sw	$ra,0($sp)	# guarda registo $ra na stack
	
	li	$v0,7		
	syscall			# read_double() = $f0 
	
	mov.d	$f12,$f0	# $f12 = $f0
	jal	f2c		# f2c($f12)
	
	mov.d	$f12,$f0	# $f12 = $f0	
	li	$v0,3
	syscall			# print_double(f2c(x))
		
	lw	$ra,0($sp)	# repõe registo $ra 
	addiu	$sp,$sp,4	# repõe espaço na stack
	
	li	$v0,0		# return 0;
	
	jr	$ra		# termina o programa
	
#--------------------------------------------------------------------------------------

f2c:				# double f2c(double ft) {
	
	l.d 	$f0,c5		# $f0 = 5.0
	l.d	$f2,c9		# $f2 = 9.0
	l.d	$f4,c32		# $f4 = 32.0
	
	div.d	$f6,$f0,$f2	# $f6 = 5.0 / 9.0
	sub.d	$f8,$f12,$f4	# $f8 = ft - 32.0
	mul.d	$f0,$f6,$f8	# $f10 = ( (5.0 / 9.0 * (ft – 32.0) )

	jr	$ra		# fim da sub-rotina