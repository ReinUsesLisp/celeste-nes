PPU_TurnOFF:
	LDA #$00
	STA PPUCTRL
	STA PPUMASK
	RTS

PPU_TurnON:	
PPU_Restore:
	LDA #$00
	STA PPUSCROLL
	STA PPUSCROLL

	LDA #PPU_CONTROL_FLAGS
	STA PPUCTRL
	
	LDA #PPU_MASK_FLAGS
	STA PPUMASK
	RTS