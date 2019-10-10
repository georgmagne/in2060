.text 
.global main

@ Main function of program
main:
	@ First load the desired fibonaci number.
	MOV r0, #13 @ N
	
	@ Initialize the first two numbers in the sequence
	MOV r1, #0 @ current
	MOV r2, #1 @ previous
	

@Loop will do the main work calculating the fibonacci sequence

loop:
	CMP r0, #0		@Comparing r0 to 0.
	BEQ exit		@if r0 = 0, break finish
	MOV r12, r1
	ADD r1, r1, r2 	@r1 = r1 + r2; current += previous
	MOV r2, r12		@ previous = r12 = current
	SUB r0, r0, #1 	@N -= 1
	B loop
	

@ Branching and exchanging on lr register
@ returning to caller
exit:
	BX lr

