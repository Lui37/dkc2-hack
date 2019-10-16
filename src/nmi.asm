@include

every_frame:
		SED
		LDA.l !counter_60hz
		ADC #$0001
		STA.l !counter_60hz
		CLD
		LDA $00002C
		JML hijack_nmi_return
