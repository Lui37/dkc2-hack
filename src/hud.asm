@include

handle_displays:
		SEP #$20
		LDA !timer_started
		BNE .active
		LDA !fade_type
		BEQ .start
		; ignore frames elapsed before taking control at the start of a level
		STZ !real_frames_elapsed
		STZ !real_frames_elapsed+1
		BRA .draw
		
	.start:
		INC !timer_started
		BRA .update
		
	.active:
		LDA !fade_type
		BMI .skip_update
		LDA !timer_stopped
		BNE .draw
		
	.update:
		JSR tick_timer
		
	.skip_update:
		; checking here lets the timer tick on the first frame you hit the goal
		; to properly account for lag frames
		LDA !level_state
		CMP #$A0
		BNE +
		INC !timer_stopped
	+
		
	.draw:
		; convert seconds to decimal
		LDA !timer_seconds
		STA $4204
		STZ $4205
		LDA #10
		STA $4206
		
		REP #$20
		; starting x position
		LDX #!timer_x
		; starting y position
		LDA #!timer_y
		STA $32
		
		LDA !timer_minutes
		AND #$00FF
		JSR draw_digit
		INX
		INX
		
		; seconds tens digit
		LDA $4214
		JSR draw_digit
		; seconds units digit
		LDA $4216
		TAY
		; meanwhile convert frames to decimal
		LDA !timer_frames
		STA $4204
		SEP #$20
		STZ $4205
		LDA #10
		STA $4206
		REP #$20
		TYA
		JSR draw_digit
		INX
		INX
		
		; frames tens digit
		LDA $4214
		JSR draw_digit
		; frames units digit
		LDA $4216
		JSR draw_digit
		
		JMP draw_dropped_frames
		
		
tick_timer:
		REP #$20
		LDA !timer_frames
		CLC
		ADC !real_frames_elapsed
		STA !timer_frames
		CMP.w #60
		BCC .done
		CMP.w #120
		BCC .one_sec
		
		STA $4204
		SEP #$20
		LDA #60
		STA $4206
		REP #$21
		NOP #6
		LDA $4216
		STA !timer_frames
		LDA $4214
		BRA .add_sec
		
	.one_sec:
		SBC.w #59
		STA !timer_frames
		TDC
	.add_sec:
		ADC !timer_seconds
		STA !timer_seconds
		CMP.w #60
		BCC .done
		CMP.w #120
		BCC .one_min
		
		STA $4204
		SEP #$20
		LDA #60
		STA $4206
		REP #$21
		NOP #6
		LDA $4216
		STA !timer_seconds
		LDA $4214
		BRA .add_min
		
	.one_min:
		SBC.w #59
		STA !timer_seconds
		TDC
	.add_min:
		ADC !timer_minutes
		STA !timer_minutes
		CMP.w #10
		BCC .no_cap
		LDA.w #59
		STA !timer_frames
		LDA.w #59
		STA !timer_seconds
		LDA.w #9
	.no_cap:
		STA !timer_minutes
	.done:
		STZ !real_frames_elapsed
		SEP #$20
		RTS

		
draw_dropped_frames:
		LDA !dropped_frames
		CMP.w #100
		BCS .calc_hundreds

		; starting y position
		LDX #!dropped_frames_y
		STX $32
		; starting x position
		LDX #!dropped_frames_x
		
		LDY #$0000
		BRA .skip_hundreds
		
	.calc_hundreds:
		STA $4204
		SEP #$20
		LDA #100
		STA $4206
		REP #$20
		
		; starting x position
		LDX #!dropped_frames_x
		; starting y position
		LDA #!dropped_frames_y
		STA $32
		NOP #2
		; hundreds
		LDA $4214
		CMP #$0009
		BCC .no_cap
		LDA #$0009
		JSR draw_digit
		LDA #$0009
		JSR draw_digit
		LDA #$0009
		JMP draw_digit
		
	.no_cap:
		TAY
		; meanwhile calc tens and units
		LDA $4216
	.skip_hundreds:
		STA $4204
		SEP #$20
		LDA #10
		STA $4206
		REP #$20
		; draw hundreds digit
		TYA
		JSR draw_digit
		
		; draw tens digit
		LDA $4214
		JSR draw_digit
		
		; draw units digit
		LDA $4216
		JMP draw_digit
		