@include

; never lose a life
org !lives_dec
		BRA + : NOP : +
		
; don't try to display bananas/stars
org !end_bananas
		RTS
		
