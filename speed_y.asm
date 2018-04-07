;;; Update Speed Y
	MOVCW MAXFALL, target

	;; Check for slow speed in Y
	LDX speed_y
	LDA speed_y+1
	BEQ USY_SlowSpeedPositive
	CMP #$FF
	BEQ USY_SlowSpeedNegative

USY_NormalGravity:	
	LDXY #LOW(GRAVITY), #HIGH(GRAVITY)
	JMP USY_GravityFinish

USY_SlowSpeedNegative:
	CPX #($100-SLOW_SPEED)
	BPL USY_HalfGravity
	JMP USY_NormalGravity

USY_SlowSpeedPositive:
	CPX #SLOW_SPEED
	BMI USY_HalfGravity
	JMP USY_NormalGravity

USY_HalfGravity:
	LDXY #LOW(HALF_GRAVITY), #HIGH(HALF_GRAVITY)

USY_GravityFinish:
	STXY amount

	
	;; Wall slide
	LDA input
	BEQ USY_SlideDone

	LDA on_wall
	BEQ USY_SlideDone

	MOVCW GLIDE_MAXFALL, target
USY_SlideDone:	

	
	;; Apply gravity
	LDA on_ground
	BNE USY_GravityDone

	MOVW speed_y, value
	JSR Approach
	STXY speed_y
USY_GravityDone:	
