	.data
str:	.asciiz "Arquitetura de computadores I"

	.text
	.globl main

main:
	addiu $sp,$sp,-4
	sw $ra,0($sp)			# prólogo
	
	la $a0,str
	jal strlen			# temp = strlen(str)
	
	move $a0,$v0
	li $v0,1
	syscall				# print_int10(temp)
	
	li $v0,0
	
	lw $ra,0($sp)			# epilogo
	addiu $sp,$sp,4
	jr $ra
	
	
#################################################################################

strlen:					# strlen(char *s)
					# $a0 -> char *s
					# $v0 -> len
					
	li $v0,0			# len = 0
strlen_w1:
	lb $t0,0($a0)			# // $t0 = *s;
	addiu $a0,$a0,1			# s++
	beq $t0,$0,strlen_ew1
	addi $v0,$v0,1			# len++;
	j strlen_w1

strlen_ew1:
	jr $ra			
