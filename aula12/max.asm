	.data
	.eqv	id_number, 0
	.eqv	first_name, 4
	.eqv	last_name, 22
	.eqv 	grade, 40
max_grade:.float -20.0
sum:	.float	0.0
	.text
	.globl max
	
max:					# student *max(student *st, int ns, float *media) {
	move	$t0,$a0			#	// $t0 = st
	move	$t1,$a1			#	// $t1 = ns
	move	$t2,$a2			#	// $t2 = *media
	li	$t3,0			#	// $t3 = pmax
	l.s	$f2,sum			#	// $f2 = sum 
	l.s	$f4,max_grade		# 	// $f4 = max_grade
	
	mul	$a1,$a1,44		#	ns = ns * 44
	addu	$t4,$t0,$a1
for:	bge	$t0,$t4,endfor		#	for(p = st; p < (st + ns); p++) {
	
	l.s	$f6,grade($t0)		#		// $f6 = p->grade
	add.s	$f2,$f2,$f6		#		sum += p->grade; 
	
if:	c.le.s 	$f6,$f4			#
	bc1t	endif			#		if(p->grade > max_grade)  {

	mov.s	$f4,$f6			#			max_grade = p->grade;
	move	$t3,$t0			#			pmax = p;	
					#		}
					
endif:	addi	$t0,$t0,44		#		p++;
	j 	for			#	}
	
endfor:	mtc1	$t1,$f8			#	// $f8 = ns
	cvt.s.w	$f8,$f8			#	// $f8 = (float)ns
	div.s	$f10,$f2,$f8		#	// $f10 = sum / (float)ns; 
	s.s	$f10,0($t2)		#	*media = sum/(float)ns;
	move	$v0,$t3			#	return pmax;
	
	jr	$ra			# }	// fim da sub-rotina
									