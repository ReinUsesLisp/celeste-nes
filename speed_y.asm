SpeedY:	
	MOVCW MAXFALL, target

	;; Check for slow speed in Y
	LDX speed_y
	LDA speed_y+1
	BEQ .slowSpeedPositive
	CMP #$FF
	BEQ .slowSpeedNegative

.normalGravity:	
	LDXY #LOW(GRAVITY), #HIGH(GRAVITY)
	JMP .gravityFinish

.slowSpeedNegative:
	CPX #($100-SLOW_SPEED)
	BPL .halfGravity
	JMP .normalGravity

.slowSpeedPositive:
	CPX #SLOW_SPEED
	BMI .halfGravity
	JMP .normalGravity

.halfGravity:
	LDXY #LOW(HALF_GRAVITY), #HIGH(HALF_GRAVITY)

.gravityFinish:
	STXY amount

	
	;; Wall slide
	LDA input
	BEQ .slideDone

	LDA on_wall
	BEQ .slideDone

	MOVCW GLIDE_MAXFALL, target
.slideDone:	

	
	;; Apply gravity
	LDA on_ground
	BNE .gravityDone

	MOVW speed_y, value
	JSR Approach
	STXY speed_y
.gravityDone:	
