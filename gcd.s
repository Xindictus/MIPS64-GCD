	.data
A:	 .word 578, 719, 151, 54, 221, 283, 506, 517, 533
.word 296, 668, 495, 708, 325, 132, 932, 887, 533
.word 870, 606, 174, 724, 608, 58, 235, 550, 533
.word 362, 922, 791, 870, 879, 788, 561, 486, 533
.word 930, 742, 827, 905, 437, 22, 787, 835, 533
.word 667, 746, 948, 106, 512, 635, 42, 85, 533
.word 44, 40, 816, 208, 387, 613, 37, 548, 533
.word 305, 443, 452, 292, 248, 822, 781, 321, 533
.word 106, 52, 376, 820, 597, 243, 731, 33, 533
.word 564, 69, 68, 973, 906, 809, 424, 140, 533
.word 2, 4, 16, 33, 5, 9, 3, 9, 27

B:	.word -1
C:	.word 33
title:  .asciiz "Out of bounds"
CONTROL: .word32 0x10000
DATA:    .word32 0x10008

	.text
	
main:
	 #daddi r29 , r29 , -16
	 jal array_length		# find the table size
	 
	 nop
	 dadd r25, r2, r0	
	 daddi r8, r0, 3
	 ddiv r24, r25, r8		# r24 will have the # of loops
	 #daddi r24, r0, 33
	 ld r16,A(r0)			# r16 first number
	 dadd r22, r16, r0		# r22 will have the 1st number of the 1st group of 3
	 jal check_bound		# checking if we are out of bounds
	 nop
	 daddi r11 , r0 , 8		# offset 8 bytes every time to get all numbers
	 ld r17,A(r11)			# r17 = 2nd number of the 1st group of 3
	 dadd r22, r17, r0		# r22 now has the 2nd number of the table
	 jal check_bound		# checking if we are out of bounds
	 nop
	 daddi r11 , r11 , 8	        # offset 8 bytes every time get all numbers
	 ld r18,A(r11)			# r18 = 3rd number of the 1st group of 3
	 dadd r22, r18, r0		# r22 now has the 3rd number of the table
	 jal check_bound		# checking if we are out of bounds
	 nop
	 j loop			
loop:
	 beq r24, r0, exit		
	 daddi r24, r24, -1		
	 daddi r29 , r29 , -16	        # space for 2 variable in heap
	 jal gcd			# finding gcd
	 
	 
	 dadd r25, r2, r0 		# result of the 1st group of 3
	 dadd r16, r17, r0 
	 dadd r17, r18, r0
	
	 jal gcd			# finding gcd
	 dadd r24, r2, r0 		# result of 2nd group of 3
	 dadd r16, r25, r0 
	 dadd r17, r24, r0
	 jal gcd
	 dadd r18, r2, r0
	 
	 #storing
	 dadd r16, r0, r11
	 daddi r17, r11, -16
	 j STORE
	 
STORE:
	 beq r16, r17, NEXT3
	 sd r18, A(r16)
	 daddi r16, r16, -8
	 j STORE
	 nop
	 
NEXT3:
	 daddi r11, r11, 8		
	 ld r16, A(r11)
	 dadd r22, r16, r0
	 jal check_bound		# checking if we are out of bounds
	 nop
	 daddi r11, r11, 8
	 ld r17, A(r11)
	 dadd r22, r17, r0
	 jal check_bound		# checking if we are out of bounds
	 nop
	 daddi r11, r11, 8
	 ld r18, A(r11)
	 dadd r22, r18, r0
	 jal check_bound		# checking if we are out of bounds
	 nop
	 
	 j loop
	 nop
	 
exit:					# exit without errors
	 halt
	 
exit2:
         lwu r21,CONTROL(r0)	       	# exit if we are out of bounds
         lwu r22,DATA(r0)
         daddi r24,r0,4 
         daddi r1,r0,title   
         sd r1,(r22)
         sd r24,(r21)
         halt
	 
check_bound:
	daddi r20, r0, 1000		# checking bounds
	slt r21, r22, r20
	beq r21, r0, exit2		# if greater than go to exit2
	dadd r20, r0, r0		# r20 = 0
	slt r21, r20, r22 
	beq r21, r0, exit2		# if less than, go to exit2
	nop
	jr r31 
	  
array_length:
	dadd r8, r0, r0 		# array length
	dadd r9, r0, r0
	ld r11, A(r0)
	ld r10, B(r0)
	j check
	nop
check:
	beq r11, r10, ENDARRAY
	j array_loop
	nop
array_loop:
	daddi r8, r8, 1
	daddi r9, r9, 8
	ld r11, A(r9)
	j check
	nop

ENDARRAY:
	dadd r2, r8, r0
	jr r31 
	 	 
gcd:
	dadd r4, r16, r0
	dadd r5, r17, r0
	
	slt r13, r4, r5 #an r4 < r5
	bne r13, r0, REVERSE
	j loopdiv
	
loopdiv:
	ddiv r12, r4, r5 #r4/r5	
	dmul r13, r12, r5
	dsub r23, r4, r13
	beq r23, r0, GCDEND
	nop
	nop
	j NEXTDIV
	
REVERSE:
	dadd r8, r4, r0
	dadd r4, r5, r0
	dadd r5, r8, r0
	j loopdiv
	
NEXTDIV:
	dadd r8, r5, r0
	dadd r5, r23, r0
	dadd r4, r8, r0
	j loopdiv

GCDEND:
	dadd r2, r5, r0
	jr r31
