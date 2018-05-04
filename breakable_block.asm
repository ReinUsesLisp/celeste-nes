BreakableBlock:	
	LDA dash_time
	BEQ .done

	JSR InBreakableBlock
	BNE .done

	JSR FindBreakable
	TYA
	PHA
	
	LDA #$00
	STA world, Y
	INY
	STA world, Y
	TYA
	CLC
	ADC #$10
	TAY
	LDA #$00
	STA world, Y
	DEY
	STA world, Y

	PLA
	STA flag_hide_block
	LDA #$01
	STA strawberry_on
.done:
	RTS
	

HideBreakable:
	LDA flag_hide_block
	JSR HideBreakableRow
	LDA flag_hide_block
	CLC
	ADC #$10
	JSR HideBreakableRow
	RTS

HideBreakableRow:
	TAX
	JSR Divide40
	CLC
	ADC #$20
	TAY
	STA PPUADDR

	TXA
	AND #$0F
	ASL A
	STA nmi_tmp

	TXA
	AND #$F0
	JSR Divide10
	JSR Multiply40
	CLC
	ADC nmi_tmp
	PHA
	STA PPUADDR

	LDA #$6A
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA

	STY PPUADDR
	PLA
	CLC
	ADC #$20
	STA PPUADDR
	LDA #$6A
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	STA PPUDATA
	RTS

FindBreakable:
	LDY #$00
.loop:
	LDA world, Y
	CMP #TILE_BREAKABLE
	BEQ .found
	INY
	BNE .loop
	LDA #$01
	RTS
.found:
	LDA #$00
	RTS
