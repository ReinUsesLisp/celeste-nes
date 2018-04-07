	LDA frames
	AND #%00000011		; Get an iterating 0-3 for hair index
	TAY

	LDA player_x+1
	SEC
	LDX flip_x
	BEQ HairRight
	SBC #$01
	JMP HairSetX
HairRight:
	ADC #$04
HairSetX:
	ASL A
	STA hairs_x, Y

	LDA player_y+1
	ADC #$03
	ASL A
	STA hairs_y, Y
