@include

every_igt_frame:
		SED
		JSR handle_frame_counters
		JSR tick_timer
		CLD
		LDA #$8608
		STA $20
		RTL


; bonus intro
every_intermission_frame:
		JSL $80897C
		SED
		JSR handle_frame_counters
		JSR tick_timer
		CLD
		RTL


handle_frame_counters:
		LDA !counter_60hz
		SEC
		SBC !previous_60hz
		STA !real_frames_elapsed
		SEC
		SBC #$0001
		CLC
		ADC !dropped_frames
		STA !dropped_frames
		
	.end:
		LDA !counter_60hz
		STA !previous_60hz
		RTS
		

tick_timer:
		LDA !timer_started
		BEQ .done
		LDA !timer_stopped
		BNE .done
		
		; skip if game is paused
		LDA $0621
		AND #$0080
		BNE .done
		
		LDA !timer_frames
		CLC
		ADC !real_frames_elapsed
		STA !timer_frames
		CMP #$0060
		BCC .done
		
		SBC #$0060
		STA !timer_frames
		TDC
		ADC !timer_seconds
		STA !timer_seconds
		CMP #$0060
		BCC .done
		
		SBC #$0060
		STA !timer_seconds
		TDC
		ADC !timer_minutes
		STA !timer_minutes
		CMP #$0010
		BCC .no_cap
		LDA #$0059
		STA !timer_frames
		LDA #$0059
		STA !timer_seconds
		LDA #$0059
	.no_cap:
		STA !timer_minutes
	.done:
		RTS
		