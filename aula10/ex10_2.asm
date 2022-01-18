	.data
xn:	.double	1.0
aux:	.double	1.0
zero:	.double	0.0
const1:	.double	0.5
	.text
	.globl main
	
main:	
	addiu	$sp,$sp,-4		# reserva espaço na stack
	sw	$ra,0($sp)		# guarda o registo $ra
	
	li	$v0,7			# 7 -> read_double()
	syscall				# read_double();	
	
	mov.d	$f12,$f0		# $f12 = read_double()
	jal	sqrt			# sqrt(read_double())
	
	mov.d	$f12,$f0
	li	$v0,3			
	syscall				# print_double( sqrt( read_double() ) )

	lw	$ra,0($sp)		# repoe o registo $ra
	addiu	$sp,$sp,4		# repoe espaço na stack
	
	jr	$ra			# fim do programa


#---------------------------------------------------------------------------
#f12 -> val
sqrt:					# double sqrt(double val) {
	li	$t0,0			# 	int i = 0;
	l.d	$f0,xn			# 	double xn = 1.0;
	l.d	$f2,aux			#	double aux = 1.0;
	l.d	$f4,zero		#	double zero = 0.0;
	l.d	$f6,const1
s_if:	
	c.le.d	$f12,$f4		#
	bc1t	s_else			# if(val > 0.0) {
s_do:					#	do {
	mov.d	$f2,$f0			# 		aux = xn;
	
	div.d	$f8,$f12,$f0		# // $f8 = val/xn
	add.d	$f8,$f8,$f0		# // $f8 = xn + val/xn
	mul.d	$f0,$f8,$f6		# xn = 0.5 * (xn + val/xn)
s_while:
	c.eq.d	$f2,$f0			# 
	bc1t	s_endif			# 
	addiu	$t0,$t0,1		# i++
	bge	$t0,25,s_endif		#
	j	s_do			# while((aux != xn) && (++i < 25));		

s_else:					# else {
	l.d	$f0,zero		# 	xn = 0.0; 
s_endif:
	jr	$ra			# fim da sub-rotina
	
