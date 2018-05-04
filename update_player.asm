_UpdatePlayer:	
	;; Check for pause
	LDA paused
	BEQ .noPause
	RTS
.noPause:

	;; Calculate X direction (pressed by the player)
	JSR InputLeft
	BEQ .tryInputRight
	LDX #$FF		; Left pressed, load -1
	JMP .inputFinish
.tryInputRight:	
	JSR InputRight
	BEQ .inputNone
	LDX #$01		; Right pressed, load 1
	JMP .inputFinish
.inputNone:
	LDX #$00 		; None is pressed, load 0
.inputFinish:
	STX input		; Store it
		
	;; Check for spikes
	JSR InSpikes
	BNE .noSpikes
	JSR KillPlayer
.noSpikes:	

	;; Check for bottom death
	LDA player_y+1
	CMP #$78
	BMI .bottomDeathDone
	JSR KillPlayer
.bottomDeathDone:	

	;; Floor state
	LDXY #$00, #$08
	JSR SolidAt
	BEQ .onGround
	LDXY #$07, #$08
	JSR SolidAt
	BEQ .onGround
	LDA #$00
	JMP .onGroundFinish
.onGround:
	LDA #$01
.onGroundFinish:
	STA on_ground

	;; Wall state
	LDA player_x+1
	CMP #$02
	BMI .noWall
	CMP #$78
	BPL .noWall
	
	LDXY #$FE, #$00		; Check left
	JSR SolidAt
	BEQ .wallOnLeft
	LDXY #$FF, #$07
	JSR SolidAt
	BEQ .wallOnLeft

	LDXY #$08, #$00		; Check right
	JSR SolidAt
	BEQ .wallOnRight
	LDXY #$08, #$07
	JSR SolidAt
	BEQ .wallOnRight
.noWall:	
	LDA #$00
	JMP .wallSet
.wallOnLeft:
	LDA #$FF
	JMP .wallSet
.wallOnRight:
	LDA #$01
.wallSet:
	STA on_wall

	;; Add smoke when landing
	;;LDA on_ground		; Carried from above
	BNE .landSmokeDone	; Must be on ground
	LDA was_on_ground
	BEQ .landSmokeDone	; Must come from air
	LDXY #$00, #$04
	JSR AddSmoke
.landSmokeDone:

	INCLUDE "jump_input.asm"

	;; Dash input
	LDXY #$00, #$00
	JSR InputB
	BEQ .inputDashFinish
	LDX #$01
	LDA p_dash
	BNE .inputDashFinish
	LDY #$01
.inputDashFinish:
	STX p_dash
	STY dash

	INCLUDE "grace.asm"

	;; Update dash time
	DEC dash_effect_time
	
	JMP_ZERO .dashTimeDone, dash_time

	LDA frames
	AND #%00000001
	BEQ .skipDashSmoke
	LDXY #$02, #$00
	JSR AddSmoke
.skipDashSmoke:	
	
	DEC dash_time
	
	MOVW speed_x, value
	MOVW dash_target_x, target
	MOVW dash_accel_x, amount	
	JSR Approach
	STXY speed_x

	MOVW speed_y, value
	MOVW dash_target_y, target
	MOVW dash_accel_y, amount	
	JSR Approach
	STXY speed_y
	
	
.dashTimeDone:

	INCLUDE "speed_x.asm"
	INCLUDE "speed_y.asm"
	INCLUDE "jump.asm"
	INCLUDE "dash.asm"
	INCLUDE "move.asm"
	INCLUDE "hair.asm"

	LDA player_y+1
	CMP #$02
	BPL .noNextLevel

	JSR PPU_TurnOFF
	JSR NextLevel
	JSR PPU_Restore
.noNextLevel:	
	
	;; FIXME what happens if NMI gets between STAs?
	LDA #$01
	STA flag_oam
	STA flag_player

	RTS
