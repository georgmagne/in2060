.text
.global main

@ Function that main should call
fib:
	@ Initialize the first two numbers in the sequence
	MOV r1, #0 			@ current
	MOV r2, #1 			@ previous
	
	B loop
	

@Loop will do the main work calculating the fibonacci sequence

loop:
	CMP r0, #0			@Comparing r0 to 0.
	BEQ exit			@if r0 = 0, break finish
	MOV r12, r1			@Saving r1 until end of loop.
	ADD r1, r1, r2 		@r1 = r1 + r2; current += previous
	MOV r2, r12			@ previous = r12 = current
	SUB r0, r0, #1 		@N -= 1
	B loop
	

@ Branching and exchanging on lr register
@ returning to caller
exit:
	MOV r0, r1 		@ Putting return value from fib function in r0.

	BX lr
	
main:
	@ Loading the desired fibonaci number.
	MOV r0, #13 			@ N
	
	PUSH {lr} 				@ Must push lr because of branch and link.
	BL fib
	POP {lr} 				@ popping lr to set it to the value before the branch.
	
							@ Setting values for printf.
	MOV r1, r0 				@ Answer from fib function
	LDR r0, =output_string 	@ output string.
	MOV r2, #13
	
	PUSH {lr}
	BL printf
	POP {lr}
	
	BX lr
	
.data
output_string:
	.asciz "%d is fib number %d.\n"
