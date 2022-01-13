# Mapa de registos:
# $t0 – soma
# $t1 – value
# $t2 - i
      .data
str1: .asciiz "Introduza um numero: "
str2: .asciiz "Valor ignorado\n"
str3: .asciiz "A soma dos positivos e': "
      .eqv print_string,4
      .eqv read_int,5
      .eqv print_int10, 1 
      .text
      .globl main
main: 			 # void main(void) {
      li $t0,0 		 # soma = 0;
      li $t2,0 	       	 # i = 0;
for:  bge $t2,5,end_for   # while(i < 5) {
      
      li $v0,print_string 
      la $a0, str1 	 
      syscall		  # print_string("str1");
      
      li $v0, read_int
      syscall
      move $t1,$v0 	 # value = read_int();
      
if:   ble $t1,$0,else    # if(value > 0)
      add $t0,$t0,$t1 	 # soma += value;
      j end_if 		 #
else: 			 # else
      li $v0,print_string 
      la $a0, str2 	 
      syscall		 
             		 # print_string("str2");
end_if:
      addi $t2,$t2,1 	 # i++;
      j for 		 # }
end_for:
      li $v0,print_string 
      la $a0, str3 	 
      syscall		 # print_string("str3");
      
      move $a0,$t0
      li $v0,print_int10
      syscall            #print_int10(soma)		
      jr $ra 
