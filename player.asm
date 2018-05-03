PreparePlayer:
	LDA #$00
	STA player_x
	STA player_x+1
	STA player_y
	STA player_y+1
	STA speed_x
	STA speed_x+1
	STA speed_y
	STA speed_y+1

	LDA #MAX_DJUMP
	STA djump
	RTS

KillPlayer:
	JSR PPU_TurnOFF
	JSR LoadLevel
	JMP PPU_Restore
	
UpdatePlayer:	
	INCLUDE "update_player.asm"

DrawPlayer:
	;; Do palette swap
	LDA #$3F
	STA PPUADDR
	LDA #$11
	STA PPUADDR

	LDA djump
	BEQ .noDashes
	CMP #$01
	BEQ .oneDash
	;; Multiple dashes
	LDA frames
	AND #%00100000
	BEQ .blinkON
	LDA #$1A		; Green
	JMP .setPaletteColor
.blinkON:
	LDA #$30		; White
	JMP .setPaletteColor
.oneDash:
	LDA #$16		; Red
	JMP .setPaletteColor
.noDashes:
	LDA #$2C		; Lightblue
.setPaletteColor:
	STA PPUDATA

	;; Draw body
	LDA player_y+1
	ASL A
	SEC
	SBC #$01
	CLC
	STA SLOT_BODY_TL + DRAW_Y
	STA SLOT_BODY_TR + DRAW_Y

	ADC #$02
	STA SLOT_BACK_HAIR + DRAW_Y
	ADC #$06
	STA SLOT_BODY_BL + DRAW_Y
	STA SLOT_BODY_BR + DRAW_Y

	LDA flip_x
	BEQ .flipON
	MOVB #$00, SLOT_BODY_TL + DRAW_TILE
	MOVB #$01, SLOT_BODY_TR + DRAW_TILE
	MOVB #$10, SLOT_BODY_BL + DRAW_TILE
	MOVB #$11, SLOT_BODY_BR + DRAW_TILE
	LDA player_x+1
	ASL A
	SBC #$01		; Substract 2, carry is clear
	STA SLOT_BACK_HAIR + DRAW_X
	LDA #%00000000
	JMP .flipFinish
.flipON:
	MOVB #$01, SLOT_BODY_TL + DRAW_TILE
	MOVB #$00, SLOT_BODY_TR + DRAW_TILE
	MOVB #$11, SLOT_BODY_BL + DRAW_TILE
	MOVB #$10, SLOT_BODY_BR + DRAW_TILE
	LDA player_x+1
	ASL A
	ADC #$0A
	STA SLOT_BACK_HAIR + DRAW_X
	LDA #%01000000
.flipFinish:
	STA SLOT_BODY_TL + DRAW_ATTR
	STA SLOT_BODY_TR + DRAW_ATTR
	STA SLOT_BODY_BL + DRAW_ATTR
	STA SLOT_BODY_BR + DRAW_ATTR
	STA SLOT_BACK_HAIR + DRAW_ATTR

	LDA player_x+1
	ASL A
	STA SLOT_BODY_TL + DRAW_X
	STA SLOT_BODY_BL + DRAW_X
	ADC #$08
	STA SLOT_BODY_TR + DRAW_X
	STA SLOT_BODY_BR + DRAW_X

	;; Draw hairs
	MOVB hairs_y,   SLOT_HAIR0 + DRAW_Y
	MOVB hairs_y+1, SLOT_HAIR1 + DRAW_Y
	MOVB hairs_y+2, SLOT_HAIR2 + DRAW_Y
	MOVB hairs_y+3, SLOT_HAIR3 + DRAW_Y

	LDA #$0E
	STA SLOT_HAIR0 + DRAW_TILE
	STA SLOT_HAIR1 + DRAW_TILE
	STA SLOT_HAIR2 + DRAW_TILE
	STA SLOT_HAIR3 + DRAW_TILE
	
	LDA #%00000000
	STA SLOT_HAIR0 + DRAW_ATTR
	STA SLOT_HAIR1 + DRAW_ATTR
	STA SLOT_HAIR2 + DRAW_ATTR
	STA SLOT_HAIR3 + DRAW_ATTR
	
	MOVB hairs_x,   SLOT_HAIR0 + DRAW_X
	MOVB hairs_x+1, SLOT_HAIR1 + DRAW_X
	MOVB hairs_x+2, SLOT_HAIR2 + DRAW_X
	MOVB hairs_x+3, SLOT_HAIR3 + DRAW_X
	
	RTS

