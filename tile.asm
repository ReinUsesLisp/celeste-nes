	.macro TEST_IN
	LDX #$00
	LDY #$00
	JSR \1
	BEQ Finish\@
	LDX #$00
	LDY #$07
	JSR \1
	BEQ Finish\@
	LDX #$07
	LDY #$00
	JSR \1
	BEQ Finish\@
	LDX #$07
	LDY #$07
	JSR \1
	BEQ Finish\@
	;; There is no collision
	LDA #$01		; Clear zero flag
Finish\@:
	.endm

;;; X: offset x, Y: offset y
PlayerTile:
	TYA
	CLC
	ADC player_y+1
	AND #%11111000
	ASL A
	STA tmp

	TXA
	ADC player_x+1
	JSR Divide08
	ORA tmp

	TAY
	LDA world, Y
	AND #%00111111
	RTS
	
SolidAt:
	TXA
	CLC
	ADC player_x+1
	BMI .solid
	CMP #$80
	BPL .solid

	TYA
	CLC
	ADC player_y+1
	BMI .notSolid
	CMP #$78
	BPL .notSolid

	JSR PlayerTile
	BEQ .notSolid
	CMP #TILE_SOLIDS
	BMI .solid
.notSolid:
	LDA #$01
	RTS
.solid:
	LDA #$00
	RTS

BotSpikesAt:
	JSR PlayerTile
	CMP #TILE_SPIKES_BOT
	RTS
	
InSolid:
	TEST_IN SolidAt
	RTS

InBotSpikes:
	TEST_IN BotSpikesAt
	BNE .end
	LDA player_y+1
	AND #%00000111
	CMP #$06
	BMI .no
	LDA #$00
	RTS
.no:
	LDA #$01
.end:	
	RTS

InSpikes:
	JSR InBotSpikes
	BEQ .finish
.finish:
	RTS

BreakableBlockAt:
	JSR PlayerTile
	CMP #$21
	BEQ .finish
	CMP #$22
	BEQ .finish
	CMP #$23
	BEQ .finish
	CMP #$24
.finish:	
	RTS
	
InBreakableBlock:	
	TEST_IN BreakableBlockAt
	RTS
