Grace:	
	LDA on_ground
	BEQ .air

	LDA #$0C
	STA grace

	LDA djump
	CMP #MAX_DJUMP
	BMI .limit
	JMP .done

.limit:
	LDA #MAX_DJUMP
	STA djump
	JMP .done

.air:
	LDA grace
	BEQ .done
	DEC grace

.done:	
