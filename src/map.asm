include

every_map_frame:
		STZ !dropped_frames
		STZ !real_frames_elapsed
		STZ !timer_frames
		STZ !timer_seconds
		STZ !timer_minutes
		STZ !timer_disp_frames
		STZ !timer_disp_seconds
		STZ !timer_disp_minutes
		STZ !timer_stopped
		STZ !timer_started
		LDA !counter_60hz
		STA !previous_60hz

		JSR check_goto_overworld
		JSR check_toggle_autojump
		JSR check_kong_swap

		SEP #$20
		LDA $0512
		RTL


check_goto_overworld:
		LDA !io_axlr : BIT #$0020 : BEQ .done 		 ; L held?
		LDA !io_byetudlr_1f : BIT #$0020 : BEQ .done ; select pressed?

		; the nmi_pointer selects the address in bank $80 to run at the start of each frame
		; $8087D9 jumps to $B5CDFD, which loads a world map screen based on the value in map_index
		LDA #$87D9 : STA !nmi_pointer_dp
		STZ !map_index ; 0 = overworld

		; $06AF/B0 seems to store a movement value for when the kongs move between map nodes
		; if you try to load the overworld while this is non-zero, you will softlock as they run offscreen
		STZ $06AF

		; $06AD seems to store a value that dictates where the kongs move after beating a level
		; it gets set even when they don't move automatically, and is only cleared when a new node is reached
		; zeroing it prevents another softlock when loading the overworld immediately after beating a level
		STZ $06AD
	.done:
		RTS

; when deciding whether or not to allow a jump, the game checks if B was pressed in the last 15 frames:
; 	current_frame_counter - frame_counter_at_time_of_B_press < 16
; if a value is greater than $8000, it is considered negative in two's complement
; so autojump is active if the current frame counter is at least $8000 (as long as the B press var remains at zero)
check_toggle_autojump:
		LDA !io_axlr : BIT #$0020 : BEQ .done 	 ; L held?
		LDA !io_axlr_1f : BIT #$0010 : BEQ .done ; R pressed?

		; flip the frame counter between 0 (inactive) and two's complement -32768 (active)
		LDA !counter_60hz_pausable_dp : AND #$8000 : EOR #$8000 : STA !counter_60hz_pausable_dp
		BMI +
		LDA.w #!sfx_notallowed
		BRA .play_sound
		+
		LDA.w #!sfx_balloon
	.play_sound:
		JSL play_high_priority_sound
	.done:
		RTS

check_kong_swap:
		LDA !io_axlr : BIT #$0010 : BEQ .check_swap 	; R held?
		LDA !io_axlr_1f : BIT #$0020 : BEQ .check_swap 	; L pressed?

		; toggle sprite visibility
		LDX !follower_kong
		LDA $1C,x
		EOR #$C000
		STA $1C,x

		; toggle extra kong
		LDA !extra_kong_flag
		EOR #$4000
		STA !extra_kong_flag

	.check_swap:
		LDA !io_axlr : BIT #$0010 : BEQ .done 		 ; R held?
		LDA !io_byetudlr_1f : BIT #$0020 : BEQ .done ; select pressed?

		; toggle between diddy and dixie
		LDA !current_map_kong
		EOR #$0001
		STA !current_map_kong

		; toggle animation number for both main and follower kongs
		LDX !main_kong
		LDA $36,x
		EOR #$0003
		STA $36,x
		LDX !follower_kong
		LDA $36,x
		EOR #$0003
		STA $36,x
	.done:
		RTS
