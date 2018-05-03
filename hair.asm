Hair:	
	LDA frames
	AND #%00000011		; Get an iterating 0-3 for hair index
	TAY

	LDA player_x+1
	SEC
	LDX flip_x
	BEQ .right
	SBC #$01
	JMP .setX
.right:
	ADC #$04
.setX:
	ASL A
	STA hairs_x, Y

	LDA player_y+1
	ADC #$03
	ASL A
	STA hairs_y, Y
