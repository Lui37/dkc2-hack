include

org hijack_level
		JSL every_igt_frame
		NOP
		
org hijack_map
		JSL every_map_frame
		NOP
		
org hijack_bonus_intro
		JSL every_intermission_frame
		
org hijack_lives
		JSR handle_displays
