ReadInput:
	LDA #$01
	STA $4016
	LDA #$00
	STA $4016
	LDX #$8
RI_Loop:
	LDA $4016
	LSR A
	ROL buttons
	DEX
	BNE RI_Loop
	RTS

InputA:
        LDA buttons
        AND #%10000000
        RTS
InputB:
        LDA buttons
        AND #%01000000
        RTS
InputSelect:
        LDA buttons
        AND #%00100000
        RTS
InputStart:
        LDA buttons
        AND #%00010000
        RTS
InputUp:
        LDA buttons
        AND #%00001000
        RTS
InputDown:
        LDA buttons
        AND #%00000100
        RTS
InputLeft:
        LDA buttons
        AND #%00000010
        RTS
InputRight:
        LDA buttons
        AND #%00000001
        RTS
