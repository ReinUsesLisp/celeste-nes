Approach:
	LDA value
	CMP target
	BNE .L1
	LDA value+1
	CMP target+1
	BEQ .setTarget
	
.L1:	
	LDA value
	CMP target
	LDA value+1
	SBC target+1
	BVC .L2
	EOR #$80
.L2:
	BMI .positive
	JMP .negative

.positive:
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
	BVC .L3
	EOR #$80
.L3:
	BMI .end
	JMP .setTarget

.negative:
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
	BVC .L4
	EOR #$80
.L4:
	BMI .setTarget
	JMP .end

.setTarget:
	LDXY target
.end:	
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
