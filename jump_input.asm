	JSR InputA
	PHA			; Save if A is pressed
	BEQ JI_NoJump
	LDA p_jump
	BNE JI_NoJump
	;; Jump will be done
	LDA #$08
	STA jbuffer
	LDA #$01
	JMP JI_SetPress
JI_NoJump:
	;; Jump won't be done
	LDA jbuffer
	BEQ JI_NoJumpFinish
	DEC jbuffer		; Decrease when it's non-zero
JI_NoJumpFinish:	
	LDA #$00
JI_SetPress:
	STA jump		; A holds new jump status
	
	PLA			; Restore if A was pressed
	BEQ JI_NotPressed
	LDA #$01
	JMP JI_Done
JI_NotPressed:
	LDA #$00
JI_Done:
	STA p_jump
	
