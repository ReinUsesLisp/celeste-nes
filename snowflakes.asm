InitSnowflakes:
	LDX #$00
	LDA #$00
.loop:	
	ADC #$12
	AND #%10101010
	STA snowflakes_x, X
	ADC #$3B
	AND #%01010101
	STA snowflakes_y, X
	INX
	CPX #$10
	BNE .loop
	RTS

UpdateSnowflakes:
	LDA #$01
	STA flag_snowflakes
	STA flag_oam
	RTS

DrawSnowflakes:
	
.loop:	
	INX
	CPX #$10
	BNE .loop
	RTS
