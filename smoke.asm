AddSmoke:
	LDA last_smoke
	BNE AddSmokeDone

	TYA
	PHA
	LDY smoke_index

	TXA
	CLC
	ADC player_x+1
	LDX flip_x
	BNE AddSmokeSetX
	ADC #$02
AddSmokeSetX:
	ASL A
	STA smoke_x, Y

	PLA			; Now A holds argument Y
	ADC player_y+1
	ASL A
	STA smoke_y, Y

	LDA #$04
	STA smoke_counter, Y

	;; TODO
	;LDA smoke_index
	;CLC
	;ADC #$01
	;AND #%00000011
	;STA smoke_index

	LDA #$03
	STA last_smoke

AddSmokeDone:
	RTS

	
UpdateSmoke:
	LDA last_smoke
	BEQ UpdateSmokeNoDecrease
	DEC last_smoke
UpdateSmokeNoDecrease:

	;; Update some frames
	LDA frames
	AND #%00000001
	BNE UpdateSmokeDone
	
	LDY #$00
UpdateSmokeLoop:
	LDA smoke_counter, Y
	BEQ UpdateSmokeCheckLoop

	CLC
	LDA smoke_x, Y
	ADC #$03
	STA smoke_x, Y
	
	LDA smoke_y, Y
	SBC #$00		; Substract 1, carry is clear
	STA smoke_y, Y
	
	LDA smoke_counter, Y
	SBC #$01		; Substract 1, carry is set
	STA smoke_counter, Y

UpdateSmokeCheckLoop:	
	INY
	CPY #$04
	BEQ UpdateSmokeLoop
	
UpdateSmokeDone:
	LDA #$01
	STA flag_oam
	STA flag_smoke
	RTS


	.macro DRAW_SMOKE
	MOVB smoke_y+\1, SLOT_SMOKE + $\1*4 + DRAW_Y
	
	LDA #$FF
	LDX smoke_counter+\1
	BEQ DrawSmokeEmpty\@
	LDA #$18
	SEC
	SBC smoke_counter+\1
DrawSmokeEmpty\@:
	STA SLOT_SMOKE + $\1*4 + DRAW_TILE

	MOVB #%00000001, SLOT_SMOKE + $\1*4 + DRAW_ATTR
	MOVB smoke_x+\1, SLOT_SMOKE + $\1*4 + DRAW_X
	.endm
	
DrawSmoke:
	DRAW_SMOKE 0
	DRAW_SMOKE 1
	DRAW_SMOKE 2
	DRAW_SMOKE 3
	
	RTS
