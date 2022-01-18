	.data
result:	.float 	1.0
x:	.float	4.0
	.text
	.globl main

main:	
	addiu	$sp,$sp,-4	
	sw	$ra,0($sp)
	
	l.s	$f12,x			# x = 4.0
	li	$a0,2			# y = 2
	jal	xtoy			# xtoy(4, 2)
	
	mov.s 	$f12,$f0
	li	$v0,2
	syscall				# print_float(xtoy(3, 2))
		
	lw	$ra,0($sp)
	addiu	$sp,$sp,4
	
	li	$v0,0			# return 0;
	
	jr	$ra

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