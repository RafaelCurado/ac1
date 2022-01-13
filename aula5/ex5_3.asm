# Mapa de registos:
# 
# houve_troca: 	$t0
# i:		$t1
# aux:		$t2
# lista:	$t3
# lista+i:	$t4
# lista[i]:	$t5
# lista[i+1]:	$t6 
# p:		$t7
# *p:		$t8
# lista+SIZE:	$t9

	.data
	.eqv SIZE,10
	.eqv SIZE_,9
	.eqv TRUE,1
	.eqv FALSE,0
	.eqv read_int,5
	.eqv print_string,4
	.eqv print_int10,1
lista:	.space 40
str1:	.asciiz "\nIntroduza um numero: "
str2:	.asciiz "\nConteudo do array:\n"
str3:	.asciiz "; "
	.text
	.globl main

main:	li $t1,0		# i = 0
	
while1:	bge $t1,SIZE,do		# while(i<SIZE)
	
	li $v0,print_string
	la $a0,str1
	syscall			# print_string("\nIntroduza um numero: ")
	
	li $v0,read_int
	syscall			# read_int()
	
	la $t3,lista 		# $t3 = lista 
	sll $t4,$t1,2		# $t4 = i * 4
	addu $t4,$t3,$t4	# $t4 = lista[i}
	sw $v0,0($t4)		# lista[i] = read_int()
	addi $t1,$t1,1		# i++
	
	j while1
	
do:	li $t0,FALSE
	
	li $t1,0		# i = 0
	
for:	bge $t1,SIZE_,while 	# while (i <  SIZE-1)
	
if:	sll $t4,$t1,2		# $t4 = i * 4
	addu $t4,$t3,$t4	# $t4 = lista[i}
	lw $t5,0($t4)		# $t5 = lista[i]
	lw $t6,4($t4)		# $t6 = lista[i+1]
	
	ble $t5,$t6,endif	# if(lista[i] > lista[i+1])
	sw $t5,4($t4)		# lista[i+1] = $t5 
	sw $t6,0($t4)		# lista[i] = $t6 
	li $t0,TRUE		# houve_troca = TRUE
	
endif:	addi $t1,$t1,1		# i++
	j for
	
while:  bne $t0,TRUE,end_do
	j do
	
end_do: li $v0,print_string
	la $a0,str2
	syscall			# print_string("\nConteudo do array:\n")
	
	la $t7,lista		# p = lista
	
	li $t9,SIZE		
	sll $t9,$t9,2		# $t9 = SIZE * 4
	addu $t9,$t9,$t7	# $t9 = lista[SIZE]
	
for2:	bge $t7,$t9,end_for2	# while (p < lista + SIZE)
	
	lw $t8,0($t7)		# $t8 = *p
	
	li $v0,print_int10
	move $a0,$t8
	syscall			# print_int10( *p )
	
	li $v0,print_string
	la $a0,str3
	syscall			# print_string("; ")
	
	addi $t7,$t7,4		# p++
	
	j for2
	
end_for2:
	jr $ra
	
	






	
	
	
	
