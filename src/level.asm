@include

every_igt_frame:
		JSR handle_frame_counters
		LDA #$8608
		STA $20
		RTL


handle_frame_counters:
		LDA !counter_60hz
		SEC
		SBC !previous_60hz
		; SEP #$10
		; LDY $0621
		; REP #$11
		; BMI .end
		TAY
		CLC
		ADC !real_frames_elapsed
		STA !real_frames_elapsed
		TYA
		DEC
		CLC
		ADC !dropped_frames
		STA !dropped_frames
		
	.end:
		LDA !counter_60hz
		STA !previous_60hz
		RTS
		
		
; bonus intro
every_intermission_frame:
		JSL $80897C
		JSR handle_frame_counters
		RTL
		