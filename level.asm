FirstLevel:
	LDA #LOW(levels)
	STA world_pointer
	LDA #HIGH(levels)
	STA world_pointer+1
	JMP LoadLevel

NextLevel:
	INC world_pointer+1
	
LoadLevel:
	LDY #$00
LL_CopyLoop:
	LDA [world_pointer], Y
	STA world, Y
	INY
	BNE LL_CopyLoop
	
	LDA #$00
	STA frames

	JSR LoadWorld
	JSR PreparePlayer
	JSR ResetStrawberry

	LDY #$F0
	JSR PopWorld
	STA player_x+1

	JSR PopWorld
	STA player_y+1

LL_NextObject:
	JSR PopWorld
	CMP #$FF
	BEQ LL_Finish

	CMP #$01
	BEQ LL_Strawberry

	CMP #$02
	BEQ LL_FlyStrawberry
	
	JMP LL_NextObject
	
LL_FlyStrawberry:
	JSR SetFlyStrawberry
LL_Strawberry:
	JSR LoadStrawberry
	JMP LL_NextObject
	
	JMP LL_NextObject

LL_Finish:
	JSR LevelContainsBreakable
	BNE LL_NoBreakable
	MOVB #$00, strawberry_on
LL_NoBreakable:	
	
	RTS

PopWorld:
	LDA world, Y
	PHA
	INY
	PLA
	RTS

LevelContainsBreakable:
	LDY #$00
LCB_Loop:	
	LDA world, Y
	CMP #TILE_BREAKABLE
	BEQ LCB_Found
	INY
	CPY #$F0
	BNE LCB_Loop
	LDA #$01
	RTS
LCB_Found:
	LDA #$00
	RTS
	
