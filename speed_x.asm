SpeedX:	
	MOVW speed_x, value

	LDA input
	BEQ .zero
	BMI .left
.right:
	LDCXY MAX_RUN
	JMP .L1
	
.zero:
	LDCXY $0000
	JMP .L1

.left:
	LDCXY $10000-MAX_RUN

.L1:
	STXY target

	LDY speed_x+1
	BMI .applyAbsolute
	LDX speed_x
	JMP .compareSpeed
	
.applyAbsolute:
	LDA speed_x
	EOR #$FF
	INC A
	TAX
	LDA speed_x+1
	EOR #$FF
	INC A
	TAY
	
.compareSpeed:
	CPY #HIGH(MAX_RUN)
	BEQ .compareSpeedLow
	BMI .accelerate
	JMP .deaccelerate
.compareSpeedLow:
	CPX #LOW(MAX_RUN)
	BMI .accelerate

.deaccelerate:
	LDX #NORMAL_DEACCEL
	JMP .finish

.accelerate:	
	LDA on_ground
	BEQ .onAir
	LDX #NORMAL_ACCEL
	JMP .finish
.onAir:	
	LDX #AIR_ACCEL

.finish:
	STX amount
	LDY #$00
	STY amount+1
	JSR Approach
	STXY speed_x

	;; Flip
	LDA speed_x
	BNE .flip
	LDA speed_x+1
	BNE .flip
	JMP .done
.flip:
	LDA speed_x+1		; Check sign with higher value
	BPL .turnRight
	LDA #$00
	JMP .flipDo
.turnRight:
	LDA #$01
.flipDo:
	STA flip_x
	
.done:	
