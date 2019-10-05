@include

; never lose a life
org lives_dec
		BRA + : NOP : +
		
; don't try to display bananas/stars
org end_bananas
		RTS
		
org end_lives
		RTS
		
org bypass_hud_face
		BRA + : NOP #2 : +
