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
	 jal array_length		#euresi megethous pinaka mporei na paraleifthei an kseroume eksarxis to megethos
	 
	 nop
	 dadd r25, r2, r0	
	 daddi r8, r0, 3
	 ddiv r24, r25, r8		#o r24 tha exei pleon twn arithmo twn epanalipsewn
	 #daddi r24, r0, 33
	 ld r16,A(r0)			#$r16 = prwto stoixeio triadas
	 dadd r22, r16, r0		#o r22 exei to prwto stoixeio tou pinaka
	 jal check_bound		#elegxoume an einai ektos oriwn
	 nop
	 daddi r11 , r0 , 8		#offset 8 bytes kathe fora gia na pernw ta stoixeia
	 ld r17,A(r11)			#r17 = deutero stoixeio triadas
	 dadd r22, r17, r0		#o r22 exei to deutero stoixeio tou pinaka
	 jal check_bound		#elegxoume an einai ektos oriwn
	 nop
	 daddi r11 , r11 , 8	#offset 8 bytes kathe fora gia na pernw ta stoixeia
	 ld r18,A(r11)			#r18 = trito stoixeio triadas
	 dadd r22, r18, r0		#o r22 exei to deutero stoixeio tou pinaka
	 jal check_bound		#elegxoume an einai ektos oriwn
	 nop
	 j loop			
loop:
	 beq r24, r0, exit		#sinthiki gia tin epanalipsi
	 daddi r24, r24, -1		#meiwnoume ton metriti kata ena
	 daddi r29 , r29 , -16	#xwros gia dio metablites  stoiba
	 jal gcd				#pame sti sinartisi pou briskei to megisto koino diaireti
	 
	 
	 dadd r25, r2, r0 		#apotelesma protis diadas
	 dadd r16, r17, r0 
	 dadd r17, r18, r0
	
	 jal gcd				#pame sti sinartisi pou briskei to megisto koino diaireti
	 dadd r24, r2, r0 		#apotelesma deuteris diadas
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
	 jal check_bound		#elegxoume an einai ektos oriwn
	 nop
	 daddi r11, r11, 8
	 ld r17, A(r11)
	 dadd r22, r17, r0
	 jal check_bound		#elegxoume an einai ektos oriwn
	 nop
	 daddi r11, r11, 8
	 ld r18, A(r11)
	 dadd r22, r18, r0
	 jal check_bound		#elegxoume an einai ektos oriwn
	 nop
	 
	 j loop
	 nop
	 
exit:						#kanoniki eksodos
	 halt
	 
exit2:
	 lwu r21,CONTROL(r0)	#eksodos an exoume out of bounds
     lwu r22,DATA(r0)
     daddi r24,r0,4 
     daddi r1,r0,title   
     sd r1,(r22)
     sd r24,(r21)
	 halt

	 
check_bound:
	daddi r20, r0, 1000		#bazoumne ston r20 gia elegxo me to 1000
	slt r21, r22, r20
	beq r21, r0, exit2		#an megalitero pigaine stin exit2
	dadd r20, r0, r0		#bazoume ston r20 to 0
	slt r21, r20, r22 
	beq r21, r0, exit2		#an mikrotero pigaine stin exit2
	nop
	jr r31 
	  
array_length:
	dadd r8, r0, r0 		#array length
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