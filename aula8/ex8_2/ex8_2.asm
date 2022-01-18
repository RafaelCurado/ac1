	.data
	.eqv 	MAX_STR_SIZE, 33
	.eqv 	read_int, 5
	.eqv	print_string, 4
str:	.space	MAX_STR_SIZE	
	.text 	
	.globl main
	
main:	
	addiu	$sp,$sp,-4		# reserva espaço na stack	
	sw	$ra,0($sp)		# guarda o registo $ra na stack	
	
do:	
	li	$v0,read_int		
	syscall				# read_int();
	move	$t0,$v0			# val = read_int();
	
	move	$a0,$t0			# $a0 = val;
	li	$a1,2			# $a1 = 2;
	la	$a2,str			# $a2 = str;
	jal	itoa			# itoa(val, 2, str)
	
	move	$a0,$v0			# $a0 = $v0
	li	$v0,print_string	# 
	syscall				# print_string( itoa(val, 2, str) )
	
	move	$a0,$t0			# $a0 = val;
	li	$a1,8			# $a1 = 8;
	la	$a2,str			# $a2 = str;
	jal	itoa			# itoa(val, 8, str)
	
	move	$a0,$v0			# $a0 = $v0
	li	$v0,print_string	# 
	syscall				# print_string( itoa(val, 8, str) )
	
	move	$a0,$t0			# $a0 = val;
	li	$a1,16			# $a1 = 16;
	la	$a2,str			# $a2 = str;
	jal	itoa			# itoa(val, 16, str)
	
	move	$a0,$v0			# $a0 = $v0
	li	$v0,print_string	# 
	syscall				# print_string( itoa(val, 16, str) )
	
while:	bnez	$t0,do			# while(val != 0)
	
	li	$v0,0			# return 0;
		
	lw	$ra,0($sp)
	addiu	$sp,$sp,4		# repoe espaço na stack
	
	jr	$ra			# fim do programa


#--------------------------------------------------------------------------------------
# Mapa de registos
# n: $a0 -> $s0
# b: $a1 -> $s1
# s: $a2 -> $s2
# p: $s3
# digit: $t0
# Sub-rotina intermédia

itoa:	addiu	$sp,$sp,-20		# reserva espaço na stack
	sw	$ra,0($sp)		# guarda resistos $sx e $ra na stack
	sw	$s0,4($sp)	
	sw	$s1,8($sp)
	sw	$s2,12($sp)	
	sw	$s3,16($sp)
					
	move 	$s0,$a0			# $s0 = n
	move 	$s1,$a1			# $s1 = b
	move	$s2,$a2			# $s2 = s
	move	$s3,$a2			# $s3 = s = p

itoa_do:	
	rem 	$t0,$s0,$s1		# digit = n % b
	div	$s0,$s0,$s1		# n = n / b;
	move 	$a0,$t0			# $a0 = digit
	jal 	toascii			# toascii(digit)
	sb	$v0,0($s3)		# *p = toascii(digit)
	addiu	$s3,$s3,1		# p++

itoa_while:	bgt	$s0,0,do		# while(n > 0)
	sb	$0,0($s3)		# *p = '\0'
	
	move	$a0,$s2			# $a0 = s
	jal	strrev			# strrev(s)
	
	move	$v0,$s2			# return s;
	
	lw	$ra,0($sp)		# repoe resistos $sx e $ra 
	lw	$s0,4($sp)	
	lw	$s1,8($sp)
	lw	$s2,12($sp)	
	lw	$s3,16($sp)	
	addiu	$sp,$sp,20		# repoe o espaço na stack
	
	jr	$ra			# fim da sub-rotina
	
#-------------------------------------------------------------------------------------	
# Sub-rotina terminal	
# char toascii(char v) 


toascii:
	move	$t0,$a0			# $t0 = $a0
	addiu	$t0,$t0,'0'		# v += '0'
	
if:	ble	$t0,'9',endif		# if ( v > '9' )
	addiu	$t0,$t0,7		# v += 7 // 'A' - '9' - 1
	
endif:	move	$v0,$t0			# return v;
	
	jr	$ra			# fim da sub-rotina
		
	
	
	
	
