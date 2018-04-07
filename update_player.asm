	;; Check for pause
	LDA paused
	BEQ UP_NoPause
	RTS
UP_NoPause:

	;; Calculate X direction (pressed by the player)
	JSR InputLeft
	BEQ UP_TryInputRight
	LDX #$FF		; Left pressed, load -1
	JMP UP_InputFinish
UP_TryInputRight:	
	JSR InputRight
	BEQ UP_InputNone
	LDX #$01		; Right pressed, load 1
	JMP UP_InputFinish
UP_InputNone:
	LDX #$00 		; None is pressed, load 0
UP_InputFinish:
	STX input		; Store it
		
	;; Check for spikes
	JSR InSpikes
	BNE UP_NoSpikes
	JSR KillPlayer
UP_NoSpikes:	

	;; Check for bottom death
	LDA player_y+1
	CMP #$78
	BMI UP_BottomDeathDone
	JSR KillPlayer
UP_BottomDeathDone:	

	;; Floor state
	LDXY #$00, #$08
	JSR SolidAt
	BEQ UP_OnGround
	LDXY #$07, #$08
	JSR SolidAt
	BEQ UP_OnGround
	LDA #$00
	JMP UP_OnGroundFinish
UP_OnGround:
	LDA #$01
UP_OnGroundFinish:
	STA on_ground

	;; Wall state
	LDA player_x+1
	CMP #$02
	BMI UP_NoWall
	CMP #$78
	BPL UP_NoWall
	
	LDXY #$FE, #$00		; Check left
	JSR SolidAt
	BEQ UP_WallOnLeft
	LDXY #$FF, #$07
	JSR SolidAt
	BEQ UP_WallOnLeft

	LDXY #$08, #$00		; Check right
	JSR SolidAt
	BEQ UP_WallOnRight
	LDXY #$08, #$07
	JSR SolidAt
	BEQ UP_WallOnRight
UP_NoWall:	
	LDA #$00
	JMP UP_WallSet
UP_WallOnLeft:
	LDA #$FF
	JMP UP_WallSet
UP_WallOnRight:
	LDA #$01
UP_WallSet:
	STA on_wall

	;; Add smoke when landing
	;;LDA on_ground		; Carried from above
	BNE UP_LandSmokeDone	; Must be on ground
	LDA was_on_ground
	BEQ UP_LandSmokeDone	; Must come from air
	LDXY #$00, #$04
	JSR AddSmoke
UP_LandSmokeDone:

	INCLUDE "jump_input.asm"

	;; Dash input
	LDXY #$00, #$00
	JSR InputB
	BEQ UP_InputDashFinish
	LDX #$01
	LDA p_dash
	BNE UP_InputDashFinish
	LDY #$01
UP_InputDashFinish:
	STX p_dash
	STY dash

	INCLUDE "grace.asm"

	;; Update dash time
	DEC dash_effect_time
	
	JMP_ZERO UP_DashTimeDone, dash_time

	LDA frames
	AND #%00000001
	BEQ UP_SkipDashSmoke
	LDXY #$02, #$00
	JSR AddSmoke
UP_SkipDashSmoke:	
	
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
	
	
UP_DashTimeDone:

	INCLUDE "speed_x.asm"
	INCLUDE "speed_y.asm"
	INCLUDE "jump.asm"
	INCLUDE "dash.asm"
	INCLUDE "move.asm"
	INCLUDE "hair.asm"

	LDA player_y+1
	CMP #$02
	BPL UP_NoNextLevel

	JSR PPU_TurnOFF
	JSR NextLevel
	JSR PPU_Restore
UP_NoNextLevel:	
	
	;; FIXME what happens if NMI gets between STAs?
	LDA #$01
	STA flag_oam
	STA flag_ppu_refresh
	STA flag_player

	RTS
