# Mapa de registos:
# p:		$t0	
# pultimo: 	$t1
# *p:		$t2
# soma:		$t3

	.data
array:	.word 7692, 23, 5, 234
	.eqv SIZE,4
	.eqv print_int10,1
	.text
	.globl main
	
main:	
	li $t3,0		# soma = 0
	li $t1,SIZE		
	addi $t1,$t1,-1		# $t1 = 3	
	sll $t1,$t1,2		# ou "mul $t4,$t4,4"
	la $t0,array
	addu $t1,$t0,$t1
while:
	bgt $t0,$t1,endw
	lw $t2,0($t0)	
	add $t3,$t3,$t2		
	addiu $t0,$t0,4		# p++
	j while
endw:
	li $v0,print_int10
	move $a0,$t3
	syscall			# print_int10(soma)
	
	jr $ra