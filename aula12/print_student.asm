	.data
	.eqv	id_number, 0
	.eqv	first_name, 4
	.eqv	last_name, 22
	.eqv 	grade, 40
	.eqv 	print_intu10, 36
	.eqv	print_string, 4
	.eqv	print_float, 2
	.text
	.globl print_student
	
print_student:				# void print_student(student *p) {
	
	move	$t0,$a0			#
	
	lw	$a0,id_number($t0)	#
	li	$v0,print_intu10	#
	syscall				#	print_intu10(p->id_number); 
	
	addiu	$a0,$t0,first_name	#
	li	$v0,print_string	#
	syscall				# 	print_string(p->first_name); 
	
	addiu	$a0,$t0,last_name	#
	li	$v0,print_string	#
	syscall				#	print_string(p->last_name);
	
	l.s	$f12,grade($t0)		#
	li	$v0,print_float		#
	syscall				#	print_float((p->grade); 
	
	jr	$ra			# }	// fim da sub-rotina	
	
	
	