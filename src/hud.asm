include

handle_displays:
		SEP #$20
		LDA !timer_started
		BNE .active
		LDA !fade_type
		BNE .draw
		
	.start:
		INC !timer_started
		BRA .update
		
	.active:
		LDA !fade_type
		BMI .skip_update
		LDA !timer_stopped
		BNE .draw
		
	.update:
		LDA !timer_frames
		STA !timer_disp_frames
		LDA !timer_seconds
		STA !timer_disp_seconds
		LDA !timer_minutes
		STA !timer_disp_minutes
		
	.skip_update:
		; checking here lets the timer tick on the first frame you hit the goal
		; to properly account for lag frames
		LDA !level_state
		CMP #$A0
		BNE +
		INC !timer_stopped
	+
		
	.draw:
		REP #$20
		; starting x position
		LDX #!timer_x
		; starting y position
		LDA #!timer_y
		STA $32
		
		LDA !timer_disp_minutes
		JSR draw_digit
		; 2 pixels padding
		INX
		INX
		; tens
		LDA !timer_disp_seconds
		LSR #4
		JSR draw_digit
		; units
		LDA !timer_disp_seconds
		AND #$000F
		JSR draw_digit
		INX
		INX
		; tens
		LDA !timer_disp_frames
		LSR #4
		JSR draw_digit
		; units
		LDA !timer_disp_frames
		AND #$000F
		JSR draw_digit
		
draw_dropped_frames:
		; starting x position
		LDX #!dropped_frames_x
		; starting y position
		LDA #!dropped_frames_y
		STA $32
		
		; check hundreds
		LDA !dropped_frames
		CMP #$0999
		BCC .no_cap
		LDA #$0009
		JSR draw_digit
		LDA #$0009
		JSR draw_digit
		LDA #$0009
		BRA .last
		
	.no_cap:
		; hundreds
		XBA
		AND #$00FF
		JSR draw_digit
		; tens
		LDA !dropped_frames
		LSR #4
		AND #$000F
		JSR draw_digit
		; units
		LDA !dropped_frames
		AND #$000F
	.last:
		JSR draw_digit
		LDA $0973
		RTS
		