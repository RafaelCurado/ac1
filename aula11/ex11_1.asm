	.data
str1:	.asciiz	"\nN. Mec: "
str2:	.asciiz	"\nNome: "
str3:	.asciiz	"\nNota: "
stg:	.word 	72313
	.asciiz	"Napoleao"
	.space	9
	.asciiz	"Bonaparte"
	.space 	5
	.float	5.1
	.text
	.globl main

main:				# int main(void) {
	la	$t0,stg		# 	
	la	$a0,str1	# 	
	li	$v0,4		#
	syscall			# 	print_string("\nN. Mec: ")
	
	lw	$a0,0($t0)	# 	
	li	$v0,36		#
	syscall			# 	print_intu10(stg.id_number);

	la	$a0,str2	#	
	li	$v0,4		#
	syscall			# 	print_string("\nNome: ");
	
	addiu	$a0,$t0,22	#
	li	$v0,4		#
	syscall			#	print_string(stg.last_name);
	
	li	$a0,','		#
	li	$v0,11		#
	syscall			#	print_char(',');

	addiu	$a0,$t0,4	#
	li	$v0,4		#
	syscall			# 	print_string(stg.first_name);
	
	la	$a0,str3	#
	li	$v0,4		#
	syscall			# 	print_string("\nNota: ");

	l.s	$f12,40($t0)	#
	li	$v0,2		#
	syscall			#	print_float(stg.grade);	
	
	li	$v0,0		# 	return 0;
				# --fim do programa--