	MOVW speed_x, value

	LDA input
	BEQ USX_Zero
	BMI USX_Left
USX_Right:
	LDCXY MAX_RUN
	JMP USX_L1
	
USX_Zero:
	LDCXY $0000
	JMP USX_L1
	
USX_Left:
	LDCXY $10000-MAX_RUN

USX_L1:
	STXY target

	LDY speed_x+1
	BMI USX_ApplyAbsolute
	LDX speed_x
	JMP USX_CompareSpeed
	
USX_ApplyAbsolute:
	LDA speed_x
	EOR #$FF
	INC A
	TAX
	LDA speed_x+1
	EOR #$FF
	INC A
	TAY
	
USX_CompareSpeed:
	CPY #HIGH(MAX_RUN)
	BEQ USX_CompareSpeedLow
	BMI USX_Accelerate
	JMP USX_Deaccelerate
USX_CompareSpeedLow:
	CPX #LOW(MAX_RUN)
	BMI USX_Accelerate

USX_Deaccelerate:
	LDX #NORMAL_DEACCEL
	JMP USX_Finish

USX_Accelerate:	
	LDA on_ground
	BEQ USX_OnAir
	LDX #NORMAL_ACCEL
	JMP USX_Finish
USX_OnAir:	
	LDX #AIR_ACCEL

USX_Finish:
	STX amount
	LDY #$00
	STY amount+1
	JSR Approach
	STXY speed_x

	;; Flip
	LDA speed_x
	BNE USX_Flip
	LDA speed_x+1
	BNE USX_Flip
	JMP USX_Done
USX_Flip:
	LDA speed_x+1		; Check sign with higher value
	BPL USX_TurnRight
	LDA #$00
	JMP USX_FlipDo
USX_TurnRight:
	LDA #$01
USX_FlipDo:
	STA flip_x
	
USX_Done:	
