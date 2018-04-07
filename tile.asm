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
	BMI SA_Solid
	CMP #$80
	BPL SA_Solid

	TYA
	CLC
	ADC player_y+1
	BMI SA_NotSolid
	CMP #$78
	BPL SA_NotSolid

	JSR PlayerTile
	BEQ SA_NotSolid
	CMP #TILE_SOLIDS
	BMI SA_Solid
SA_NotSolid:
	LDA #$01
	RTS
SA_Solid:
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
	BNE InBotSpikesEnd
	LDA player_y+1
	AND #%00000111
	CMP #$06
	BMI InBotSpikesNo
	LDA #$00
	RTS
InBotSpikesNo:
	LDA #$01
InBotSpikesEnd:	
	RTS

InSpikes:
	JSR InBotSpikes
	BEQ InSpikesFinish
InSpikesFinish:
	RTS

BreakableBlockAt:
	JSR PlayerTile
	CMP #$21
	BEQ BreakableBlockAtFinish
	CMP #$22
	BEQ BreakableBlockAtFinish
	CMP #$23
	BEQ BreakableBlockAtFinish
	CMP #$24
BreakableBlockAtFinish:	
	RTS
	
InBreakableBlock:	
	TEST_IN BreakableBlockAt
	RTS
