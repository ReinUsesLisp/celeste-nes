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
.loop:
	LDA [world_pointer], Y
	STA world, Y
	INY
	BNE .loop
	
	MOVB #$00, frames

	JSR LoadWorld
	JSR PreparePlayer
	JSR ResetStrawberry

	;; Hide hair
	LDA #$00
	STA hairs_y
	STA hairs_y+1
	STA hairs_y+2
	STA hairs_y+3

	LDY #$F0
	JSR PopWorld
	STA player_x+1

	JSR PopWorld
	STA player_y+1

	;; Load objects
.next:
	JSR PopWorld
	CMP #$FF
	BEQ .finish

	CMP #$01
	BEQ .strawberry

	CMP #$02
	BEQ .flyStrawberry
	
	JMP .next
	
.flyStrawberry:
	JSR SetFlyStrawberry
.strawberry:
	JSR LoadStrawberry
	JMP .next
	
	JMP .next

.finish:
	JSR LevelContainsBreakable
	BNE .noBreakable
	MOVB #$00, strawberry_on
.noBreakable:	
	
	RTS

PopWorld:
	LDA world, Y
	PHA
	INY
	PLA
	RTS

LevelContainsBreakable:
	LDY #$00
.loop:	
	LDA world, Y
	CMP #TILE_BREAKABLE
	BEQ .found
	INY
	CPY #$F0
	BNE .loop
	LDA #$01
	RTS
.found:
	LDA #$00
	RTS
	
