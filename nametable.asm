ClearWorld:
	;; Clear nametable
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	LDX #$00
	LDY #$00
.loop1:
	LDA #$FF
	STA PPUDATA
	INX
	BNE .loop1
	INY
	CPY #$08
	BNE .loop1

	;; Clear attributes
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$C0
	STA PPUADDR
	LDX #$00
.loop2:	
	LDA #$00
	STA PPUDATA
	INX
	CPX #$40
	BNE .loop2
	RTS
	
LoadWorld:
	LDA PPUSTATUS
	LDA #$20
	STA PPUADDR
	LDA #$00
	STA PPUADDR

	LDX #$00
.L3:
	TXA
	PHA
	
	;; Copy top tiles
	LDY #$00
.L1:
	LDA [world_pointer], Y
	ASL A
	ASL A
	TAX
	LDA tileset, X
	STA PPUDATA
	INX
	LDA tileset, X
	STA PPUDATA

	INY
	CPY #$10
	BNE .L1

	;; Copy bot tiles
	LDY #$00
.L2:	
	LDA [world_pointer], Y
	ASL A
	ASL A
	TAX
	INX
	INX
	LDA tileset, X
	STA PPUDATA
	INX
	LDA tileset, X
	STA PPUDATA

	INY
	CPY #$10
	BNE .L2

	;; Increment world pointer
	LDA world_pointer
	CLC
	ADC #$10
	STA world_pointer

	;; Check for loop
	PLA
	TAX
	INX
	CPX #$0F
	BNE .L3

	;; Reset world pointer
	LDA #$00
	STA world_pointer

	;; Now set attributes
	LDY #$00
.L4:
	TYA
	PHA
	JSR SetAttribute
	PLA
	TAY

	INY
	INY
	CPY #$F0
	BEQ .L6
	TYA
	AND #$0F
	BNE .L4
	TYA
	CLC
	ADC #$10
	TAY
.L5:
	JMP .L4
.L6:	
	RTS

SetAttribute:
	LDA [world_pointer], Y
	JSR Divide40
	STA tmp

	INY
	LDA [world_pointer], Y
	JSR Divide40
	JSR Multiply04
	ORA tmp
	STA tmp

	TYA
	CLC
	ADC #$0F
	TAY
	LDA [world_pointer], Y
	JSR Divide40
	JSR Multiply10
	ORA tmp
	STA tmp

	INY
	LDA [world_pointer], Y
	AND #%11000000
	JSR Divide40
	JSR Multiply40
	ORA tmp
	STA PPUDATA
	RTS
