Approach:
	LDA value
	CMP target
	BNE ApproachL1
	LDA value+1
	CMP target+1
	BEQ ApproachSetTarget
	
ApproachL1:	
	LDA value
	CMP target
	LDA value+1
	SBC target+1
	BVC ApproachL2
	EOR #$80
ApproachL2:
	BMI ApproachPositive
	JMP ApproachNegative

ApproachPositive:
	LDA value
	CLC
	ADC amount
	TAX
	LDA value+1
	ADC amount+1
	TAY

	TXA
	CMP target
	TYA
	SBC target+1
	BVC ApproachL3
	EOR #$80
ApproachL3:
	BMI ApproachEnd
	JMP ApproachSetTarget

ApproachNegative:
	LDA value
	SEC
	SBC amount
	TAX
	LDA value+1
	SBC amount+1
	TAY

	TXA
	CMP target
	TYA
	SBC target+1
	BVC ApproachL4
	EOR #$80
ApproachL4:
	BMI ApproachSetTarget
	JMP ApproachEnd

ApproachSetTarget:
	LDXY target
ApproachEnd:	
	RTS

Multiply40:
	ASL A
Multiply20:
	ASL A
Multiply10:
	ASL A
Multiply08:
	ASL A
Multiply04:
	ASL A
	ASL A
	RTS

Divide40:
	LSR A
Divide20:
	LSR A
Divide10:
	LSR A
Divide08:
	LSR A
Divide04:
	LSR A
	LSR A
	RTS
