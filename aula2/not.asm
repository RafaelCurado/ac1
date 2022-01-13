.data

.text
.globl main 
		
		
main:
	ori $t0,$0,0x0F1E      # $0 - valor inserido
	ori $t1,$0,0xffffffff  # $1 - valor que inverte (0xffffffff)
	xor $t2,$t0,$t1        # $2 = not $0 (valor inserido negado)
	jr $ra          # fim do programa

