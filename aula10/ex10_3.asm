	.data
	.eqv	SIZE, 9
a:	.space	72
zero:	.float	0.0
k:	.double	0.0
result:	.float 	1.0
xn:	.double	1.0
aux:	.double	1.0
const1:	.double	0.5
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
	jal	var			# var(a, SIZE)
	
	mov.d 	$f12,$f0
	li	$v0,3		
	syscall				# print_double()
	
	li	$a0,'\n'
	li	$v0,4		
	syscall			
	
	la	$a0,a			# $a0 = a
	li	$a1,SIZE		# $a1 = SIZE
	jal	stdev			# stdev(a, SIZE)
	
	mov.d 	$f12,$f0
	li	$v0,3		
	syscall				# print_double()
	
	li	$v0,0			# return 0;
	
	lw	$ra,0($sp)		# repoe registo $ra 
	addiu	$sp,$sp,4		# repoe espaço na stack
	
	li	$v0,0			# return 0;
	jr	$ra			# fim do programa
#-----------------------------------------------------------------------------
# Sub-rotina intermédia
# $a0 -> double *array 
# $a1 -> int nval
# ------------------------
# $f2 -> media
# $f4 -> soma	
# ------------------------
# $s0 -> double *array 
# $s1 -> int nval
# $s2 -> i
# $s3 -> i*8 -> *array[i]


var:					# double var(double *array, int nval) {
	addiu	$sp,$sp,-20		# // reserva espaço na pilha
	sw	$ra,0($sp)		# // guarda os registos na pilha
	sw	$s0,4($sp)		# // 
	sw	$s1,8($sp)		# //
	sw	$s2,12($sp)		# //
	sw	$s3,16($sp)			
	
	jal	average			# average(array, nval)
	cvt.s.d	$f2,$f0			# media = (float)average(array, nval)
		
	l.s	$f4,zero		# float soma = 0.0;
	move	$s0,$a0			# $s0 = *array
	move 	$s1,$a1			# $s1 = nval
	li	$s2,0			# $s2 = i // int i = 0;
for_v:
	bge	$s2,$s1,endfor_v	# for(i=0, soma=0.0; i < nval; i++) {
	
	sll	$s3,$s2,3		# // i*8
	add	$s3,$s3,$s0		# // $s3 = *array[i]
	
	l.d	$f6,0($s3)		# // $f6 = array[i]
	cvt.s.d	$f6,$f6			# // $f6 = (float)array[i]
	sub.s	$f6,$f6,$f2		# // $f6 = (float)array[i] - media
	mov.s	$f12,$f6		# // $f12 = (float)array[i] - media
	li	$a0,2			# // $a0 = 2
	jal	xtoy			# xtoy((float)array[i] - media, 2)
	
	add.s	$f4,$f4,$f0		# soma += xtoy((float)array[i] - media, 2);
	
	addiu	$s2,$s2,1		# i++
	j	for_v
endfor_v:	
	mtc1	$s1,$f8			# $f8 = nval
	cvt.d.w	$f8,$f8			# (double)nval
	cvt.d.s	$f4,$f4			# (double)soma
	div.d	$f0,$f4,$f8		# return (double)soma / nval;
	
	lw	$ra,0($sp)		# // 
	lw	$s0,4($sp)		# // 
	lw	$s1,8($sp)		# //
	lw	$s2,12($sp)		# //
	lw	$s3,16($sp)		# // repoe os registos na pilha
	addiu	$sp,$sp,20		# // repoe espaço na pilha
	
	jr	$ra			# // fim do programa
	
#--------------------------------------------------------------------------------------
# Sub-rotina intermédia

stdev:					# double stdev(double *array, int nval) {
	addiu	$sp,$sp,-4		# // reserva espaço na pilha
	sw	$ra,0($sp)		# // guarda os registos na pilha

	jal	var			# var(array, nval)
	mov.d	$f12,$f0		# // $f12 = var(array, nval)
	jal	sqrt			# sqrt( var(array, nval) )

	lw	$ra,0($sp)		# // repoe os registos na pilha
	addiu	$sp,$sp,4		# // repoe espaço na pilha
	jr	$ra			# fim da sub-rotina
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
#-----------------------------------------------------------------------------
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

#--------------------------------------------------------------------------------------

# $f12 -> float x
# $a0 -> int y

xtoy:					# float xtoy(float x, int y) {
	addiu	$sp,$sp,-16		
	sw	$ra,0($sp)
	sw	$s0,4($sp)
	sw	$s1,8($sp)
								
	li	$s0,0			# i = 0;
	l.s	$f0,result		# result = 1.0
		
	jal	abso			# abs(y)
	move	$s1,$v0			# $s1 = $v0
xtoy_for:	
	bge	$s0,$s1,xtoy_endfor	# for(i=0, result=1.0; i < abs(y); i++) {
xtoy_if:	
	blez	$a1,xtoy_else		# if(y > 0) {	
	mul.s	$f0,$f0,$f12		# result *= x;
	j	xtoy_endif		
xtoy_else:				# else {
	div.s	$f0,$f0,$f2		# result /= x;
xtoy_endif:
	addiu	$s0,$s0,1		# i++		
	j	xtoy_for		
xtoy_endfor:
	
	lw	$ra,0($sp)
	lw	$s0,4($sp)
	lw	$s1,8($sp)
	addiu	$sp,$sp,16	
	
	jr	$ra			# 
#--------------------------------------------------------------------------------------
# sub-rotina terminal
abso:					# int abs(int val) {
	move	$v0,$a0			
abs_if:	
	bgez	$v0,abs_endif		# if(val < 0) {
	mul	$v0,$v0,-1		# val = -val; 
abs_endif:	
	jr	$ra			# fim da rub-rotina