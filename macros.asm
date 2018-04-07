	.macro ADDW
	LDA \2
	CLC
	ADC \1
	STA \2
	LDA \2+1
	ADC \1+1
	STA \2+1
	.endm

	.macro MOVB
	LDA \1
	STA \2
	.endm

	.macro MOVW
	LDA \1
	STA \2
	LDA \1+1
	STA \2+1
	.endm

	;; Move constant word
	.macro MOVCW
	MOVB #LOW(\1), \2
	MOVB #HIGH(\1), \2+1
	.endm

	.macro STXY
	.if \# = 2
	STX \1
	STX \2
	.else
	STX \1
	STY \1+1
	.endif
	.endm

	.macro LDXY
	.if \# = 2
	LDX \1
	LDY \2
	.else
	LDX \1
	LDY \1+1
	.endif
	.endm

	.macro LDCXY
	LDX #LOW(\1)
	LDY #HIGH(\1)
	.endm

	.macro JMP_ZERO
	LDA \2
	BEQ \1
	.endm

	.macro JMP_NONZERO
	LDA \2
	BNE \1
	.endm
	
