PPU_TurnOFF:
	LDA #$00
	STA flag_ppu
	
	INC nmi_retraces
.wait:
	LDA nmi_retraces
	BNE .wait
	RTS

PPU_TurnON:	
PPU_Restore:
	LDA #$01
	STA flag_ppu
	RTS
