.data 
.text 
.globl main 

main:
	li $t1,2 # instrução virtual (decomposta 
			  # em duas instruções nativas) 
	#sll $t2,$t0,1     # Shift left logical
	#srl $t3,$t0,1     # Shift right logical
	#sra $t4,$t0,1     # Shift right arithmetic
	
	#xor $t1,$t0,$t3   # c) gray = bin ^ (bin >> 1) 
			  # gray -> $t1
			  # bin  -> $t0
	
	or $t5,$0,$t1     # num = gray
	srl $t6,$t5,4     # num >> 4
	xor $t5,$t5,$t6   # num = num ^ (num >> 4)
	srl $t6,$t5,2     # num >> 2
	xor $t5,$t5,$t7   # num = num ^ (num >> 2)
	srl $t6,$t5,1     # num >> 1
	xor $t5,$t5,$t6   # num = num ^ (num >> 1)
	or $t0,$0,$t5
	
	
	jr $ra            # fim do programa
