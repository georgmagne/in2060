@ Output til programmet skal være tall1 + tall2,
@ Som IEEE 754 32-bit flyttall. Vist som hex.

tall1:   	.word 0x40400000 @ #2 tall1 som skal legges sammen med tall2
tall2: 	 	.word 0x40600000 @ #0.5039062 tall2
keepExp: 	.word 0x007fffff @ 0000 0000 0111 1111...1111 For å ta vare på eksponent, ved BIC
ledende:    .word 0x80000000 @ 1000 0000 0000 0000...0000 For å legge til ledende ener.
enEkponent: .word 0x00800000 @ 0000 0000 1000 0000...0000 Kan brukes for å legge #1 til exponent, ved Overflow.
num1:    	.word 0x7fffffff @ 0111 1111 1111 1111...1111



equal:
	MOV r3, r1		@ Lagrer en av eksponentene  9bit (med sign)
	MOV r0, #0  	@ Antall shift = 0, fordi likt.
	LDR r1, tall1	@ Ikke viktig hvilket tall som er hvor
	LDR r2, tall2	@ Gjør det for å være sikker på at tallene er i de registerene funksjonene senere forventer.
	B cont

minus:
	MOV r3, r2	    @ Største eksponent til r3
	SUB r0, r2, r1	@ Finner differansen til ekponentene.
	LSR r0, r0, #23 @ Flytter utregningen til LSB, slik at desimal verdien blir lik differansen og antall shift som skal gjøres i mantissa.
	LDR r1, tall1	@ Minste til r1
	LDR r2, tall2	@ Største til r2
	B cont
	
plus:
	MOV r3, r1	    @ Største eksponent i r3
	SUB r0, r1, r2	@ Finner differansen til ekponentene.
	LSR r0, r0, #23	@ Flytter utregningen til LSB, slik at desimal verdien blir lik differansen og antall shift som skal gjøres i mantissa.
	LDR r1, tall2	@ Minste til r1
	LDR r2, tall1	@ Største til r2
	B cont
	
normaliser:
	PUSH {r4, r5} 		@ Trenger noen fler register, PUSHer r4 og r5 for å kunnne bruke disse.
	LSL r12, r12, #1    @ Fjerner overflow deteksjonsbiten
	
	LDR r5, enEkponent
	@ Eksponent ligger i r3, mantissa ligger i r12
	ADD r3, r3, r5 		@ Legger til #1 i eksponenten
	
	LSR r12, r12, #1 	@ Legger til bit på MSB
	LDR r4, ledende
	ORR r12, r12, r4 	@ OR med 1000 000...0000
	
	POP {r4, r5}        @ POPer r4 og r5 tilbake.
	BX lr 				
		
ikkeNormaliser:
	LSL r12, r12, #1 @ Fjerner overflow deteksjonsbiten
	BX lr				
	
	
.text
.global main
main:
	@ Laster inn tall.
	LDR r1, tall1 	@ Tall1 til r1
	LDR r2, tall2 	@ Tall2 til r2
	
	@ Maskerer mantissa
	LDR r3, keepExp 
	BIC r1, r1, r3  
	BIC r2, r2, r3
	
	@ Sammenligner ekponentene til tall1 og tall2.
	CMP r1, r2	
	BEQ equal   	@ r1 og r2 er like
	BMI minus		@ r2 er større enn r1
	BPL plus		@ r1 er større enn r2
	
cont:
	LSL r1, r1, #9  	@ Shifter ut eksponent og signed bits.
	LSL r2, r2, #9		@ I begge tallene.
	
	LDR r12, ledende 	@ Laster inn ledende ener
	LSR r1, r1, #1  	@ Legger på ledende bit på venstre siden
	LSR r2, r2, #1		@ I begge tall
	ORR r1, r1, r12 	@ OR med 1000 0000...0000 Slik at ledende bit, blir ledende ener.
	ORR r2, r2, r12 	@ OR med 1000 0000...0000 

	
	LSR r1, r1, r0  	@ Shifter minste tall, antall steg som differanse i exponent.
	
	@ Må sjekke for overflow,
	@ Prøvde å bruke ADDS og CPRS flag V, men fungerte kun når sum ble:
	@ (1)0....
	@ ikke når 
	@ (1)1....
	@ (Overflow)bits....

	@ Legger et shift til høyre en gang for å få et bit som kan detektere overflow.
	LSR r2, r2, #1		
	LSR r1, r1, #1
	
	ADD r12, r2, r1
	
	@ BIC-er summen, med 0111 1111...1111 for å maskere alt annet enn overflow bit.
	LDR r0, num1
	BIC r1, r12, r0
	
	@ Hvis det er en ener på MSB er det overflow.
	LDR r0, ledende
	CMP r1, r0
	
	PUSH {lr}			@ Passer på lr, slik at programmet avslutter riktig.
	BLEQ normaliser 	@ Overflow
	BLNE ikkeNormaliser @ Ikke overflow.
	
	@ Sum ligger i r12
	@ Riktig eksponent ligger i r3
	LSL r12, r12, #1 	@ Fjerner ledene 1
	LSR r12, r12, #9  	@ Legger på 0- i eksponent og signed	
	ORR r0, r3, r12 	@ Legger sammen signed/eksponenten og mantissa
	
	@ Flytter litt slik at printf blir riktig
	MOV r1, r0
	LDR r0, =string
	BL printf
	POP {lr}			@ Passer på lr, slik at programmet avslutter riktig.
	BX lr 
	
.data
string:
	.asciz "0x%x\n"
