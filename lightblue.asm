	.inesprg 1   ; 1x 16KB PRG code
	.ineschr 1   ; 1x  8KB CHR data
	.inesmap 0   ; Mapper 0 = NROM, No bank swapping
	.inesmir 1   ; Background mirroring
	
	.bank 0
	.org $C000

	INCLUDE "macros.asm"
	INCLUDE "variables.asm"
	INCLUDE "constants.asm"
	INCLUDE "player.asm"
	INCLUDE "smoke.asm"
	INCLUDE "load_world.asm"
	INCLUDE "next_level.asm"
	INCLUDE "strawberry.asm"
	INCLUDE "cosmetics.asm"
	INCLUDE "key.asm"
	INCLUDE "tile.asm"
	INCLUDE "breakable_block.asm"
	INCLUDE "snowflakes.asm"
	INCLUDE "rectangle.asm"
	INCLUDE "state.asm"
	INCLUDE "input.asm"
	INCLUDE "helper.asm"
	
Reset:
	SEI          ; Disable IRQs
	CLD          ; Disable decimal mode
	LDX #$40
	STX $4017    ; Disable APU frame IRQ
	LDX #$FF
	TXS          ; Set up stack
	INX          ; Now X = 0
	STX PPUCTRL  ; Disable NMI
	STX PPUMASK  ; Disable rendering
	STX $4010    ; Disable DMC IRQs

VBlankWait1:
	BIT $2002
	BPL VBlankWait1

ClearMemory:
	LDA #$00
	STA $0000, x
	STA $0100, x
	STA $0200, x
	STA $0400, x
	STA $0500, x
	STA $0600, x
	STA $0700, x
	LDA #$FE
	STA $0300, x
	INX
	BNE ClearMemory
   
VBlankWait2:
	BIT $2002
	BPL VBlankWait2

LoadPalettes:
	LDA PPUSTATUS
	LDA #$3F
	STA PPUADDR
	LDA #$00
	STA PPUADDR
	LDX #$00
LoadPalettesLoop:
	LDA palette, x
	STA PPUDATA
	INX
	CPX #$20
	BNE LoadPalettesLoop

	LDX #$00
ClearSpritesLoop:
	TXA
	ASL A
	ASL A
	TAY
	LDA #$FF
	STA $0200, Y
	LDA #$00
	STA $0201, Y
	STA $0202, Y
	STA $0203, Y
	INX
	CPX #$40
	BNE ClearSpritesLoop

	JSR ClearWorld
	JSR FirstLevel

	JSR PPU_TurnON

Loop:
	JSR UpdatePlayer	
	JSR UpdateSmoke
	JSR UpdateStrawberry
	JSR ReadInput
	
	INC nmi_retraces
WaitNMI:
	LDA nmi_retraces
	BNE WaitNMI
	JMP Loop


	
NMI:
	PHA
	TXA
	PHA
	TYA
	PHA
	
	;; Prepare OAM
	LDA flag_oam
	BEQ NoOAM
	LDA #$00
	STA OAMADDR
	LDA #$02
	STA OAMDMA
	DEC flag_oam
NoOAM:	

	;; Draw player
	LDA flag_player
	BEQ NoPlayer
	JSR DrawPlayer
	DEC flag_player
NoPlayer:	

	;; Draw smoke
	LDA flag_smoke
	BEQ NoSmoke
	JSR DrawSmoke
	DEC flag_smoke
NoSmoke:

	;; Draw strawberry
	LDA flag_strawberry
	BEQ NoStrawberry
	JSR DrawStrawberry
	DEC flag_strawberry
NoStrawberry:

	;; Hide block
	LDA flag_hide_block
	BEQ NoHideBlock
	JSR HideBreakable
	LDA #$00
	STA flag_hide_block
NoHideBlock:	

	;; PPU Refresh
	LDA flag_ppu_refresh
	BEQ NoPPURefresh

	LDA #PPU_CONTROL_FLAGS
	STA PPUCTRL
	
	BIT PPUSTATUS
	LDA #$00
	STA PPUSCROLL
	STA PPUSCROLL

	DEC flag_ppu_refresh
NoPPURefresh:
	
	INC frames
	INC snowflakes_counter

	LDA #$00
	STA nmi_retraces

	PLA
	TAY
	PLA
	TAX
	PLA
	RTI
	
	.bank 1
	.org $E000
levels:
	.incbin "levels/levels.bin"
palette:
	.incbin "palette.dat"
tileset:
	.incbin "levels/tileset.bin"

	.org $FFFA
	.dw NMI
	.dw Reset
	.dw 0
  
	.bank 2
	.org $0000
	.incbin "lightblue.chr"
