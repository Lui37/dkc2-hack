include

; u1.0 checksum
org $00FFDC
		dw $1202^$FFFF, $1202

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

; always spawn dk coins as not collected
org dk_coin_check
		BRA $0E

; don't load the video game heroes screen
org vgheroes_check
		BRA $11 : NOP
