;;; X: point x, Y: point Y, rectangle
;;; X and Y must remain untouched
PointAt:
	TXA
	CMP rectangle_x
	BMI PA_Outside
	SEC
	SBC rectangle_width
	CMP rectangle_x
	BPL PA_Outside
	
	TYA
	CMP rectangle_y
	BMI PA_Outside
	SEC			; TODO is SEC needed here?
	SBC rectangle_height
	CMP rectangle_y
	BPL PA_Outside
PA_Inside:	
	LDA #$01
	RTS
PA_Outside:
	LDA #$00
	RTS

PlayerAt:
	LDX player_x+1
	LDY player_y+1
	JSR PointAt
	BNE PA_Inside		; Label from previous function
	TXA
	CLC
	ADC #$08
	TAX
	JSR PointAt
	BNE PA_Inside
	TYA
	ADC #$08		; ADC can't overflow
	TAY
	JSR PointAt
	BNE PA_Inside
	TXA
	SEC
	SBC #$08
	TAX
	JSR PointAt
	BNE PA_Inside
	JMP PA_Outside
