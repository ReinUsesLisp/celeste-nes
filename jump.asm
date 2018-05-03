Jump:	
	JMP_ZERO .done, jbuffer
	JMP_ZERO .wall, grace

	MOVB #$00, jbuffer
	MOVB #$00, grace
	MOVCW $10000-JUMP_SPEED, speed_y

	LDXY #$00, #$04
	JSR AddSmoke

	JMP .done

.wall:
	LDA on_wall
	CMP #$FF
	BEQ .onLeft
	CMP #$01
	BEQ .onRight
	JMP .wallDone

.onLeft:
	LDXY #$FA, #$00
	MOVCW WALL_JUMP_SPEED_X, speed_x
	JMP .wallFinish

.onRight:
	LDXY #$06, #$00
	MOVCW ($10000-WALL_JUMP_SPEED_X), speed_x

.wallFinish:
	JSR AddSmoke
	MOVCW ($10000-WALL_JUMP_SPEED_Y), speed_y
	MOVB #$00, jbuffer
.wallDone:	

.done:	
