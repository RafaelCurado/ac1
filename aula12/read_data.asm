	.data
	.eqv	id_number, 0
	.eqv	first_name, 4
	.eqv	last_name, 22
	.eqv 	grade, 40
	.eqv	print_string, 4
	.eqv	read_int, 5
	.eqv	read_string, 8
	.eqv	read_float, 7
str1:	.asciiz	"N. Mec: "
str2:	.asciiz	"Primeiro Nome: "
str3:	.asciiz	"Ultimo Nome: "
str4:	.asciiz	"Nota: "
	.text
	.globl	read_data
	
read_data:				# void read_data(student *st, int ns) {
	li	$t0,0			#	i = 0;	// $t0 = 0
	move	$t1,$a1			#		// $t1 = ns
	move	$t2,$a0			#		// $t2 = student *st
	
for:	bge	$t0,$t1,endfor		#	for(i=0; i < ns; i++) {
	
	la	$a0,str1		
	li	$v0,print_string		
	syscall				#		print_string("N. Mec: ");
	
	li	$v0,read_int		#
	syscall				# 		read_int();
	
	mul	$t3,$t0,44		#		i*44
	addu	$t3,$t2,$t3		#
	sw	$v0,id_number($t3)	#		st[i].id_number = read_int();
	
	la	$a0,str2		#
	li	$v0,print_string	#
	syscall				# 		print_string("Primeiro Nome: ");
	
	addiu	$a0,$t3,first_name	#	
	li	$a1,18			#
	li	$v0,read_string		#
	syscall				# 		read_string();
					
	la	$a0,str3		#
	li	$v0,print_string	#
	syscall				# 		print_string("Ultimo Nome: ");
	
	addiu 	$a0,$t3,last_name	#	
	li	$a1,15			#
	li	$v0,read_string		#
	syscall				# 		read_string();
	
	la	$a0,str4		#
	li	$v0,print_string	#
	syscall				# 		print_string("Nota: ");
	
	li	$v0,read_float		#
	syscall				# 		read_float();
	#addiu	$t2, $t2, grade		#			
	s.s	$f0,grade($t2)		#		st[i].grade = read_float();
	
	addiu	$t0,$t0,1		#		i++;
	j	for			#	}
endfor:	
	jr	$ra			# }		// fim da sub-rotina