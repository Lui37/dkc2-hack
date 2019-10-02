hirom

; 10 for 1.0
; 11 for 1.1
!version ?= 1


if !version == 0
	!hijack_level = $808640
	!hijack_map = $B5D404
	!hijack_bonus_intro = $808CA4
	!freerom_BB = $BBF850
	!lives_dec = $BEC66D
	!hijack_lives = $BEC70E
	!hijack_bananas = $BEC840
	!end_bananas = $BEC89F
	!draw_digit = $C814
	!freerom_BE = $BEFB5C
elseif !version == 1
	!hijack_level = $808640
	!hijack_bonus_intro = $808CD3
	!hijack_map = $B5D424
	!freerom_BB = $BBF840
	!lives_dec = $BEC678
	!hijack_lives = $BEC719
	!hijack_bananas = $BEC84B
	!end_bananas = $BEC8AA
	!draw_digit = $C81F
	!freerom_BE = $BEFB67
endif


!dropped_frames_x = $0008
!dropped_frames_y = $0900

!timer_x = $00CC
!timer_y = $0900

!freeram = $1A00

!current_bgm = $1C
!counter_60hz = $2C
!previous_60hz = !freeram+0

!dropped_frames = !freeram+2
!real_frames_elapsed = !freeram+4

!timer_frames = !freeram+6
!timer_seconds = !freeram+7
!timer_minutes = !freeram+8

!timer_stopped = !freeram+9
!timer_started = !freeram+10


org !hijack_level
		JSL every_igt_frame
		NOP

org !hijack_map
		JSL every_map_frame
		NOP
		
org !hijack_bonus_intro
		JSL every_intermission_frame

org !lives_dec
		BRA + : NOP : +
		
org !hijack_lives
		JMP handle_displays
		
; remove
org !hijack_bananas
		LDA $096D
		CMP $096B
		
org !end_bananas
		RTS



org !freerom_BB


every_igt_frame:
		JSR handle_counters
		LDA #$8608
		STA $20
		RTL

handle_counters:
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
		
		
every_map_frame:
		STZ !dropped_frames
		STZ !real_frames_elapsed
		STZ !timer_frames ; and !timer_seconds
		STZ !timer_minutes ; and !timer_stopped
		LDA !counter_60hz
		STA !previous_60hz
		SEP #$20
		STZ !timer_started
		LDA $0512
		RTL


every_intermission_frame:
		JSL $80897C
		JSR handle_counters
		RTL


org !freerom_BE

handle_displays:
		SEP #$20
		LDA !timer_started
		BNE .active
		LDA $0513
		BEQ .start
		; ignore frames elapsed before taking control at the start of a level
		STZ !real_frames_elapsed
		STZ !real_frames_elapsed+1
		BRA .draw
		
	.start:
		INC !timer_started
		BRA .update
		
	.active:
		LDA $0513
		BMI .skip_update
		LDA !timer_stopped
		BNE .draw
		
	.update:
		JSR tick_timer
		
	.skip_update:
		; checking here lets the timer tick on the first frame you hit the goal
		; to properly account for lag frames
		LDA $0AF1
		CMP #$A0
		BNE +
		INC !timer_stopped
	+
		
	.draw
	
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
		JSR !draw_digit
		INX
		INX
		
		; seconds tens digit
		LDA $4214
		JSR !draw_digit
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
		JSR !draw_digit
		INX
		INX
		
		; frames tens digit
		LDA $4214
		JSR !draw_digit
		; seconds tens digit
		LDA $4216
		JSR !draw_digit
		
		JMP draw_dropped_frames
		
		
tick_timer:
		LDA !timer_frames
		CLC
		ADC !real_frames_elapsed
		STA !timer_frames
		CMP #60
		BCC .done
		
		SBC #60
		STA !timer_frames
		LDA !timer_seconds
		ADC #0
		STA !timer_seconds
		CMP #60
		BCC .done
		
		SBC #60
		STA !timer_seconds
		LDA !timer_minutes
		ADC #0
		CMP #10
		BCC .no_cap
		LDA #59
		STA !timer_frames
		LDA #59
		STA !timer_seconds
		LDA #9
	.no_cap:
		STA !timer_minutes
		
	.done:
		STZ !real_frames_elapsed
		STZ !real_frames_elapsed+1
		RTS
		
; 4204  wl++++ WRDIVL - Dividend C low byte
; 4205  wh++++ WRDIVH - Dividend C high byte
; 4206  wb++++ WRDIVB - Divisor B
; 4214 r l++++ RDDIVL - Quotient of Divide Result low byte
; 4215 r h++++ RDDIVH - Quotient of Divide Result high byte
; 4216 r l++++ RDMPYL - Multiplication Product or Divide Remainder low byte
; 4217 r h++++ RDMPYH - Multiplication Product or Divide Remainder high byte

		
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
		JSR !draw_digit
		LDA #$0009
		JSR !draw_digit
		LDA #$0009
		JMP !draw_digit
		
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
		JSR !draw_digit
		
		; draw tens digit
		LDA $4214
		JSR !draw_digit
		
		; draw units digit
		LDA $4216
		JMP !draw_digit
		
		
		