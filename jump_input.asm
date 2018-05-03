JumpInput:	
	JSR InputA
	PHA			; Save if A is pressed
	BEQ .no
	LDA p_jump
	BNE .no
	;; Jump will be done
	LDA #$08
	STA jbuffer
	LDA #$01
	JMP .setPress
.no:
	;; Jump won't be done
	LDA jbuffer
	BEQ .noFinish
	DEC jbuffer		; Decrease when it's non-zero
.noFinish:	
	LDA #$00
.setPress:
	STA jump		; A holds new jump status
	
	PLA			; Restore if A was pressed
	BEQ .notPressed
	LDA #$01
	JMP .done
.notPressed:
	LDA #$00
.done:
	STA p_jump
	
