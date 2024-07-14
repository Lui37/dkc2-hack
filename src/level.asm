include

every_igt_frame:
		JSR handle_frame_counters
		JSR tick_timer
		LDA #$8608
		STA $20
		RTL


; bonus intro
every_intermission_frame:
		JSL $80897C
		JSR handle_frame_counters
		JSR tick_timer
		RTL


; exits in decimal mode
handle_frame_counters:
		LDA !counter_60hz
		SEC
		SBC !previous_60hz
		STA !real_frames_elapsed
		DEC
		SED
		CLC
		ADC !dropped_frames
		STA !dropped_frames
		LDA !counter_60hz
		STA !previous_60hz
		RTS
		
		
tick_timer:
		; decimal mode
		SEP #$28
		LDA !timer_started
		BEQ .done
		LDA !timer_stopped
		BNE .done
		
		; skip if game is paused
		BIT !pause_flags
		BVS .done
		
		LDA !timer_frames
		CLC
		ADC !real_frames_elapsed
		STA !timer_frames
		CMP #$60
		BCC .done
		
		SBC #$60
		STA !timer_frames
		TDC
		ADC !timer_seconds
		STA !timer_seconds
		CMP #$60
		BCC .done
		
		SBC #$60
		STA !timer_seconds
		TDC
		ADC !timer_minutes
		STA !timer_minutes
		CMP #$10
		BCC .no_cap
		LDA #$59
		STA !timer_frames
		LDA #$59
		STA !timer_seconds
		LDA #$59
	.no_cap:
		STA !timer_minutes
	.done:
		REP #$28
		RTS
		