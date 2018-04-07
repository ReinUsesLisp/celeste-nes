	.macro MOVE_AXIS
	ADDW speed_\1, player_\1

	JSR InSolid
	PHA

	JSR BreakableBlock
	
	PLA
	BNE UP_MoveDone\@

	LDA speed_\1+1
	BMI UP_MoveNegative\@
	
UP_MovePositive\@:
	LDA player_\1+1
	AND #%11111000
	STA player_\1+1
	LDA #$FF
	STA player_\1
	JMP UP_MoveFinish\@

UP_MoveNegative\@:
	LDA player_\1+1
	JSR Divide08
	CLC
	ADC #$01
	JSR Multiply08
	STA player_\1+1
	LDA #$00
	STA player_\1

UP_MoveFinish\@:
	LDA #$00
	STA speed_\1
	STA speed_\1+1
UP_MoveDone\@:
	.endm

	MOVE_AXIS x
	MOVE_AXIS y
