	JMP_NONZERO D_Continue1, djump
	JMP D_Done
D_Continue1:
	JMP_NONZERO D_Continue2, dash
	JMP D_Done
D_Continue2:	

	LDXY #$00, #$00
	DEC djump
	
	MOVB #$04, dash_time
	MOVB #$01, has_dashed
	MOVB #$0A, dash_effect_time

	MOVCW DASH_ACCEL, dash_accel_x
	MOVCW DASH_ACCEL, dash_accel_y
	
	;; WARNING: Branch hell below
Branch1:	
	LDA input
	BNE Branch2
	JMP Branch5

Branch2:
	JSR InputUp
	BNE Branch3minus
	JSR InputDown
	BNE Branch2plus
	JMP Branch4
Branch2plus:
	JMP Branch3plus

Branch4:
	LDA input
	BMI Branch4minus
Branch4plus:
	MOVCW FULL_DASH, speed_x
	MOVCW FULL_TARGET, dash_target_x
	MOVCW $0000, speed_y
	MOVCW $0000, dash_target_y
	JMP Branch7

Branch4minus:
	MOVCW $10000-FULL_DASH, speed_x
	MOVCW $10000-FULL_TARGET, dash_target_x
	MOVCW $0000, speed_y
	MOVCW $0000, dash_target_y
	JMP Branch7
	
Branch3minus:
	MOVCW HALF_DASH_ACCEL, dash_accel_x
	MOVCW HALF_DASH_ACCEL, dash_accel_y
	LDA input
	BMI Branch3minusMinus
Branch3minusPlus:
	MOVCW HALF_DASH, speed_x
	MOVCW HALF_TARGET, dash_target_x
	MOVCW $10000-HALF_DASH, speed_y
	MOVCW $10000-HALF_TARGET_UP, dash_target_y
	JMP Branch7

Branch3minusMinus:	
	MOVCW $10000-HALF_DASH, speed_x
	MOVCW $10000-HALF_TARGET, dash_target_x
	MOVCW $10000-HALF_DASH, speed_y
	MOVCW $10000-HALF_TARGET_UP, dash_target_y
	JMP Branch7

Branch3plus:
	MOVCW HALF_DASH_ACCEL, dash_accel_x
	MOVCW HALF_DASH_ACCEL, dash_accel_y
	LDA input
	BMI Branch3plusMinus

Branch3plusPlus:
	MOVCW HALF_DASH, speed_x
	MOVCW HALF_TARGET, dash_target_x
	MOVCW HALF_DASH, speed_y
	MOVCW HALF_TARGET, dash_target_y
	JMP Branch7

Branch3plusMinus:
	MOVCW $10000-HALF_DASH, speed_x
	MOVCW $10000-HALF_TARGET, dash_target_x
	MOVCW HALF_DASH, speed_y
	MOVCW HALF_TARGET_UP, dash_target_y
	JMP Branch7

Branch5:
	JSR InputUp
	BNE Branch6minus
	JSR InputDown
	BNE Branch6plus
Branch8:
	LDA flip_x
	BEQ Branch8minus
	JMP Branch4plus
Branch8minus:
	JMP Branch4minus

Branch6plus:
	MOVCW $0000, speed_x
	MOVCW $0000, dash_target_x
	MOVCW FULL_DASH, speed_y
	MOVCW FULL_TARGET, dash_target_y
	JMP Branch7

Branch6minus:
	MOVCW $0000, speed_x
	MOVCW $0000, dash_target_x
	MOVCW $10000-FULL_DASH, speed_y
	MOVCW $10000-FULL_TARGET_UP, dash_target_y
	JMP Branch7

Branch7:
	
	
D_Done:	
