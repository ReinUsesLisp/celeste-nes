Dash:	
	JMP_NONZERO .continue1, djump
	JMP .done
.continue1:
	JMP_NONZERO .continue2, dash
	JMP .done
.continue2:	

	LDXY #$00, #$00
	DEC djump
	
	MOVB #$04, dash_time
	MOVB #$01, has_dashed
	MOVB #$0A, dash_effect_time

	MOVCW DASH_ACCEL, dash_accel_x
	MOVCW DASH_ACCEL, dash_accel_y
	
	;; WARNING: Branch hell below
.branch1:	
	LDA input
	BNE .branch2
	JMP .branch5

.branch2:
	JSR InputUp
	BNE .branch3minus
	JSR InputDown
	BNE .branch2plus
	JMP .branch4
.branch2plus:
	JMP .branch3plus

.branch4:
	LDA input
	BMI .branch4minus
.branch4plus:
	MOVCW FULL_DASH, speed_x
	MOVCW FULL_TARGET, dash_target_x
	MOVCW $0000, speed_y
	MOVCW $0000, dash_target_y
	JMP .branch7

.branch4minus:
	MOVCW $10000-FULL_DASH, speed_x
	MOVCW $10000-FULL_TARGET, dash_target_x
	MOVCW $0000, speed_y
	MOVCW $0000, dash_target_y
	JMP .branch7
	
.branch3minus:
	MOVCW HALF_DASH_ACCEL, dash_accel_x
	MOVCW HALF_DASH_ACCEL, dash_accel_y
	LDA input
	BMI .branch3minusMinus
.branch3minusPlus:
	MOVCW HALF_DASH, speed_x
	MOVCW HALF_TARGET, dash_target_x
	MOVCW $10000-HALF_DASH, speed_y
	MOVCW $10000-HALF_TARGET_UP, dash_target_y
	JMP .branch7

.branch3minusMinus:	
	MOVCW $10000-HALF_DASH, speed_x
	MOVCW $10000-HALF_TARGET, dash_target_x
	MOVCW $10000-HALF_DASH, speed_y
	MOVCW $10000-HALF_TARGET_UP, dash_target_y
	JMP .branch7

.branch3plus:
	MOVCW HALF_DASH_ACCEL, dash_accel_x
	MOVCW HALF_DASH_ACCEL, dash_accel_y
	LDA input
	BMI .branch3plusMinus

.branch3plusPlus:
	MOVCW HALF_DASH, speed_x
	MOVCW HALF_TARGET, dash_target_x
	MOVCW HALF_DASH, speed_y
	MOVCW HALF_TARGET, dash_target_y
	JMP .branch7

.branch3plusMinus:
	MOVCW $10000-HALF_DASH, speed_x
	MOVCW $10000-HALF_TARGET, dash_target_x
	MOVCW HALF_DASH, speed_y
	MOVCW HALF_TARGET_UP, dash_target_y
	JMP .branch7

.branch5:
	JSR InputUp
	BNE .branch6minus
	JSR InputDown
	BNE .branch6plus
.branch8:
	LDA flip_x
	BEQ .branch8minus
	JMP .branch4plus
.branch8minus:
	JMP .branch4minus

.branch6plus:
	MOVCW $0000, speed_x
	MOVCW $0000, dash_target_x
	MOVCW FULL_DASH, speed_y
	MOVCW FULL_TARGET, dash_target_y
	JMP .branch7

.branch6minus:
	MOVCW $0000, speed_x
	MOVCW $0000, dash_target_x
	MOVCW $10000-FULL_DASH, speed_y
	MOVCW $10000-FULL_TARGET_UP, dash_target_y
	JMP .branch7

.branch7:
.done:	
