# Mapa de registos:
# $t0 – value
# $t1 - i
# $t2 - bit
# $t3 - rem
      .data
str1: .asciiz "Introduza um numero: "
str2: .asciiz "\nO valor em binário e': "
      .eqv print_string,4
      .eqv read_int,5
      .eqv print_char,11
      .text
      .globl main
main: 			  # void main(void) {
      
      li $t1,0 		  # i = 0
      	
      li $v0,print_string 
      la $a0, str1
      syscall   	  # print_string("Introduza um numero: ")
      
      li $v0, read_int
      syscall
      move $t0,$v0 	  # value = read_int();
      
      li $v0,print_string 
      la $a0, str2
      syscall   	  # print_string("\nO valor em binário e': ")
      
for:
      bge $t1,32,end_for  # while ( i < 32 )
      
      rem $t3,$t1,4
if1:	
      bnez $t3,for1
      li $v0,print_char
      li $a0,' '
      syscall		  # print_char(' ');
      
for1:
      andi $t2,$t0,0x80000000 # bit = value & 0x80000000;
if: 			  
      beqz $t2,else 	  # if(bit != 0)
   
      li $v0,print_char
      li $a0,'1'
      syscall		  # print_char('1');
      
      j end_if
      
else:
      li $v0,print_char
      li $a0,'0'
      syscall	 	 # print_char('0');

end_if:
      sll $t0,$t0,1	 # value = value << 1;
      addi $t1,$t1,1 	 # i++;
      
      j for
      
end_for:
      jr $ra 
      
      
