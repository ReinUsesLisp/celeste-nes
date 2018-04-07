;;; Update grace

	LDA on_ground
	BEQ UG_Air

	LDA #$0C
	STA grace

	LDA djump
	CMP #MAX_DJUMP
	BMI UG_LimitDJump
	JMP UG_Finish

UG_LimitDJump:
	LDA #MAX_DJUMP
	STA djump
	JMP UG_Finish

UG_Air:
	LDA grace
	BEQ UG_Finish
	DEC grace

UG_Finish:	
