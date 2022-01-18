	.data
	.eqv	print_int10,1
str:	.asciiz	"ola123"
	.text
	.globl 	main
	
main:	addiu	$sp,$sp,-4		# reservar espa�o na pilha
	sw	$ra,0($sp)		# guardar $ra na pilha 
	
	la	$a0,str			# $a0 = str
	jal 	atoi			# atoi(str)

	move 	$a0,$v0			# $t0 = res
	li	$v0,print_int10		# 
	syscall				# print_int10(atoi(str))
	
	li	$v0,0			# return 0;
	
	lw	$ra,0($sp)		# devolve $ra 
	addiu	$sp,$sp,4		# devolve espa�o na pilha
	jr	$ra			# fim do programa

#--------------------------------------------------------------------------------------
# Mapa de registos
# res: $v0
# s: $a0
# *s: $t0
# digit: $t1
# Sub-rotina terminal: n�o devem ser usados registos $sx 

atoi:	
	li	$v0,0			# res = 0;
while:	lb	$t0,0($a0)		# $t0 = *s
	blt	$t0,'0',endw		# 
	bgt	$t0,'9',endw		# while( (*s >= '0') && (*s <= '9') )
	
	sub	$t1,$t0,'0'		# digit = *s � '0' 
	addiu	$a0,$a0,1		# s++
	
	mul	$v0,$v0,10		# res = 10*res;
	add	$v0,$v0,$t1		# res = 10*res + digit;
	
	j	while			
	
endw:	jr	$ra			# fim da sub-rotina
