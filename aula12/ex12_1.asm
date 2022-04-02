	.data
	.eqv 	MAX_STUDENTS, 4
	.eqv	print_string, 4
	.eqv	print_float, 2
st_arr:	.space	176
media:	.space	4
str1:	.asciiz	"\nMedia: "
	.text
	.globl 	main
	
main:					# int main(void) {
	addiu	$sp,$sp,-8		# 	// reservar espaço na pilha
	sw	$ra,0($sp)		#	// guardar o registo $ra 
	sw	$s0,4($s0)		#	// guarda o registo $s0
	
	la	$a0,st_arr		
	li	$a1,MAX_STUDENTS	
	jal	read_data		# 	read_data( st_array, MAX_STUDENTS );
	
	la	$a0,st_arr
	li	$a1,MAX_STUDENTS	
	la	$a2,media
	jal	max			#	max( st_array, MAX_STUDENTS, &media ); 
	
	move	$s0,$v0			# 	$t0 = max( st_array, MAX_STUDENTS, &media );
	
	la	$a0,str1
	li	$v0,print_string	
	syscall				#	print_string("\nMedia: ");
	
	l.s	$f12,media		# 	$f12 = media
	li	$v0,print_float		
	syscall				# 	print_float( media );
	
	move	$a0,$s0
	jal	print_student		# 	print_student( pmax );
	
	lw	$s0,4($sp)		#	// devolve o registo $s0
	lw	$ra,0($sp)		#	// devolve o regist $ra
	addiu	$sp,$sp,8		# 	// retoma o espaço
	
	li	$v0,0			#	return 0;
	
	jr	$ra			# 	// fim do programa
	
	
	
	
	
