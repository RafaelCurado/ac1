	.data
	.eqv	print_int10,1
str:	.asciiz	"111"
	.text
	.globl 	main
	
main:	addiu	$sp,$sp,-4		# reservar espaço na pilha
	sw	$ra,0($sp)		# guardar $ra na pilha 
	
	la	$a0,str			# $a0 = str
	jal 	atoi_bin		# atoi_bin(str)

	move 	$a0,$v0			# $t0 = res
	li	$v0,print_int10		# 
	syscall				# print_int10(atoi_bin(str))
	
	li	$v0,0			# return 0;
	
	lw	$ra,0($sp)		# devolve $ra 
	addiu	$sp,$sp,4		# devolve espaço na pilha
	jr	$ra			# fim do programa
#--------------------------------------------------------------------------------------
# Mapa de registos
# res: $v0
# s: $a0
# *s: $t0
# digit: $t1
# Sub-rotina terminal: não devem ser usados registos $sx 

atoi_bin:	
	li	$v0,0			# res = 0;
while:	lb	$t0,0($a0)		# $t0 = *s
	blt	$t0,'0',endw		# 
	bgt	$t0,'1',endw		# while( (*s >= '0') && (*s <= '1') ) {
	sub	$t1,$t0,'0'		# digit = *s – '0' 
	addiu	$a0,$a0,1		# s++
	mul	$v0,$v0,2		# res = 2*res;
	add	$v0,$v0,$t1		# res = res + digit;
	j	while			
	
endw:	jr	$ra			# fim da sub-rotina
