	.data
	.eqv	STR_MAX_SIZE,30
	.eqv	print_string,4
	.eqv 	print_int10,1
str1:	.asciiz "I serodatupmoC ed arutetiuqrA"
str2:	.space	STR_MAX_SIZE
str3:	.asciiz	"\n"
str4:	.asciiz "String too long: "
	.text
	.globl main

main:	addiu	$sp,$sp,-4		# reservar espaço na pilha 
	sw	$ra,0($sp)		# guardar $ra	

	la	$a0,str1		# $a0 = str1
	jal 	strlen			# strlen(str1)

if:	bgt	$v0,STR_MAX_SIZE,else	# if(strlen(str1) <= STR_MAX_SIZE) {
	la 	$a0,str2		# $a0 -> str2  // str dst
	la 	$a1,str1		# $a1 -> str1  // str src
	jal	strcpy			# strcpy(str2,str1)
	
	move	$a0,$v0			# $a0 = str2
	li	$v0,print_string	
	syscall				# print_string(str2)
	
	la	$a0,str3		# $a0 -> "\n" // str3
	li	$v0,print_string	
	syscall				# print_string("\n")
	
	la	$a0,str2		# $a0 -> str2
	jal	strrev			# strrev(str2)
	move	$a0,$v0			# $a0 = $v0
	li	$v0,print_string	
	syscall				# print_string(strrev(str2))
	
	li	$s0,0			# exit_value = 0;
	j 	endif
else:	la	$a0,str4		# $a0 -> str4
	li 	$v0,print_string	
	syscall				# print_string("String too long: ")
	
	la	$a0,str1		# $a0 = str1
	jal 	strlen			# strlen(str1)
	
	move	$a0,$v0			# $a0 = strlen(str1)
	li	$v0,print_int10		
	syscall				# print_int10(strlen(str1))
	
	li	$s0,-1			# exit_value = -1;
	
endif:	move	$v0,$s0			# $vo = exit_value		
	
	lw	$ra,0($sp)		# 
	addiu	$sp,$sp,4		# 
	
	jr	$ra			# fim do programa
	

#--------------------------------------------------------------------------------------

strcpy: 				# char *strcpy(char *dst, char *src) 
					#	// *dst -> $a0
					#	// *src	-> $a1
	move 	$t2,$a0			# $t2 = dst
do:	
	lb 	$t1,0($a1)		# $t1 	 = src[i]
	sb 	$t1,0($a0)		# dst[i] = src[i]
	addiu	$a0,$a0,1		# src++
	addiu	$a1,$a1,1		# dst++
while:	bne	$t1,'\0',do		# while(src[i++] != '\0');
	move	$v0,$t2			# return dst;
	jr 	$ra			# fim do programa
	
#--------------------------------------------------------------------------------------
	
strrev:	addiu 	$sp,$sp,-16		# reserva espaço na stack 
	sw 	$ra,0($sp) 		# guarda endereço de retorno
 	sw 	$s0,4($sp) 		# guarda valor dos registos
 	sw 	$s1,8($sp) 		# $s0, $s1 e $s2
 	sw	$s2,12($sp) 		#
 	move 	$s0,$a0 		# registo "callee-saved"
 	move 	$s1,$a0 		# p1 = str
 	move	$s2,$a0 		# p2 = str 
while1: lb 	$t1,0($s2)		# $t1 = *p2
	beq     $t1,'\0',endw1		# while( *p2 != '\0' ) {
	addiu   $s2,$s2,1		# p2++;
 	j 	while1 			# }
endw1:	addiu	$s2,$s2,-1 		# p2--;
while2: bge	$s1,$s2,endw2		# while(p1 < p2) {
 	move 	$a0,$s1 		#
 	move	$a1,$s2 		#
 	jal 	exchange 		# exchange(p1,p2)
 	addiu 	$s1,$s1,1		# p1++
 	addiu 	$s2,$s2,-1		# p2--
 	j 	while2 			# }
endw2:
 	move 	$v0,$s0 		# return str
 	lw 	$ra,0($sp)		# repõe endereço de retorno
 	lw 	$s0,4($sp) 		# repõe o valor dos registos
 	lw 	$s1,8($sp)		# $s0, $s1 e $s2
 	lw 	$s2,12($sp) 		#
 	addiu 	$sp,$sp,16 		# liberta espaço da stack
 	jr 	$ra 			# termina a sub-rotina
 	
exchange:
	lb	$t0,0($a0)		# $t0 = *c1
	lb 	$t1,0($a1)		# $t1 = *c2
	sb	$t0,0($a1)		# 
	sb	$t1,0($a0)		#
	jr 	$ra			# termina a sub-rotina
	
#-----------------------------------------------------------------------------------

strlen:					# strlen(char *s)
					# $a0 -> char *s
					# $v0 -> len
					
	li 	$t1,0			# len = 0
strlen_w1:
	lb 	$t0,0($a0)		# // $t0 = *s;
	addiu 	$a0,$a0,1		# s++
	beq 	$t0,'\0',strlen_ew1
	addi 	$t1,$t1,1		# len++;
	j 	strlen_w1
strlen_ew1:
	move	$v0,$t1	
	jr 	$ra			
