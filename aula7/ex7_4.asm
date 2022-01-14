	.data
	.eqv 	print_string,4
str1:	.asciiz	"Arquitetura de "
str2:	.space 	50
str3:	.asciiz	"\n"
str4:	.asciiz "Computadores I"
	.text
	.globl 	main

main:		
	addiu	$sp,$sp,-4		# reservar espaço na pilha		
	sw	$ra,0($sp)
	
	la	$a0,str2		# $a0 -> str2
	la	$a1,str1		# $a1 -> str1
	jal	strcpy			# strcpy(str2, str1)

	move	$a0,$v0			# $a0 = $v0 = str2
	li	$v0,print_string	# 
	syscall				# print_string(str2)
	
	la	$a0,str3		# $a0 = "\n"
	li	$v0,print_string	#
	syscall				# print_string("\n")
	
	la	$a0,str2		# $a0 = str2
	la	$a1,str4		# $a1 = "Computadores I"
	jal 	strcat			# strcat(str2, "Computadores I")	
	
	move	$a0,$v0			# $a0 = str2
	li	$v0,print_string	#
	syscall				# print_string(strcat(str2, "Computadores I"))
	
	li	$v0,0			# $v0 = 0;
	
	lw	$ra,0($sp)		# 
	addiu	$sp,$sp,4		# devolver espaço na pilha
			
	jr 	$ra			# fim do programa
#--------------------------------------------------------------------------------------
strcat:	 
	addiu 	$sp,$sp,-20		# reservar espaço na pilha
	sw 	$ra,0($sp)		# guardar $ra
	sw	$s0,4($sp)		# 
	sw	$s1,8($sp)
	sw	$s2,12($sp)
	sw	$s3,16($sp)	
	
	move	$s0,$a0			# $s0 = *dst = p
	move 	$s1,$a1			# $s1 = *src = src
	move 	$s3,$a0			# $s3 = 
strcat_w:
	lb	$s2,0($s0)		# *p = dst[0]
	beq	$s2,'\0',strcat_ew	# while(*p != '\0') 
	addiu	$s0,$s0,1		# p++
	j 	strcat_w		
strcat_ew:
	move 	$a0,$s0			# 	
	move 	$a1,$s1			# 
	jal	strcpy			# strcpy(p, src)
	move 	$v0,$s3			# $v0 = dst
	
	lw 	$ra,0($sp)		# guardar $ra
	lw	$s0,4($sp)		#  
	lw	$s1,8($sp)		#
	lw	$s2,12($sp)		#
	lw	$s3,16($sp)		#
	addiu 	$sp,$sp,20		# devolver espaço na pilha
	
	jr	$ra			# fim da sub-rotina
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