InitSnowflakes:
	LDX #$00
	LDA #$00
ISF_Loop:	
	ADC #$12
	AND #%10101010
	STA snowflakes_x, X
	ADC #$3B
	AND #%01010101
	STA snowflakes_y, X
	INX
	CPX #$10
	BNE ISF_Loop
	RTS

UpdateSnowflakes:
	LDA #$01
	STA flag_snowflakes
	STA flag_oam
	RTS

DrawSnowflakes:
	
DSF_Loop:
	
	INX
	CPX #$10
	BNE DSF_Loop
	RTS
