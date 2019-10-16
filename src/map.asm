@include

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
		SEP #$20
		LDA $0512
		RTL
		