	JMP_ZERO J_Done, jbuffer
	JMP_ZERO J_Wall, grace

	MOVB #$00, jbuffer
	MOVB #$00, grace
	MOVCW $10000-JUMP_SPEED, speed_y

	LDXY #$00, #$04
	JSR AddSmoke

	JMP J_Done

J_Wall:
	LDA on_wall
	CMP #$FF
	BEQ J_WallOnLeft
	CMP #$01
	BEQ J_WallOnRight
	JMP J_WallDone

J_WallOnLeft:
	LDXY #$FA, #$00
	MOVCW WALL_JUMP_SPEED_X, speed_x
	JMP J_WallFinish

J_WallOnRight:
	LDXY #$06, #$00
	MOVCW ($10000-WALL_JUMP_SPEED_X), speed_x

J_WallFinish:
	JSR AddSmoke
	MOVCW ($10000-WALL_JUMP_SPEED_Y), speed_y
	MOVB #$00, jbuffer
J_WallDone:	

J_Done:	
