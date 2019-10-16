@include

; define rom locations based on rom revision
if !rom_revision == 0
	hijack_level = $808640
	hijack_nmi = $80F398
	hijack_map = $B5D404
	hijack_bonus_intro = $808CA4
	freerom_BB = $BBF850
	dk_coin_check = $BEBA35
	lives_dec = $BEC66D
	hijack_lives = $BEC70E
	end_lives = $BEC7AE
	bypass_hud_face = $BEC809
	end_bananas = $BEC89F
	draw_digit = $BEC814
	freerom_BE = $BEFB5C
elseif !rom_revision == 1
	hijack_level = $808640
	hijack_nmi = $80F3D8
	hijack_bonus_intro = $808CD3
	hijack_map = $B5D424
	freerom_BB = $BBF840
	dk_coin_check = $BEBA40
	lives_dec = $BEC678
	hijack_lives = $BEC719
	end_lives = $BEC7B9
	bypass_hud_face = $BEC814
	end_bananas = $BEC8AA
	draw_digit = $BEC81F
	freerom_BE = $BEFB67
endif

; constants
!dropped_frames_x = $0008
!dropped_frames_y = $0900
!timer_x = $00CC
!timer_y = $0900

; wram
!freeram = $1A00

!freeram_claimed = 0
macro claim_freeram(size)
	!freeram+!freeram_claimed
	!freeram_claimed #= !freeram_claimed+<size>
endmacro

!fade_type = $0513
!level_state = $0AF1

!counter_60hz = %claim_freeram(2)
!previous_60hz = %claim_freeram(2)

!dropped_frames = %claim_freeram(2)
!real_frames_elapsed = %claim_freeram(2)

!timer_frames = %claim_freeram(2)
!timer_seconds = %claim_freeram(2)
!timer_minutes = %claim_freeram(2)

!timer_disp_frames = %claim_freeram(2)
!timer_disp_seconds = %claim_freeram(2)
!timer_disp_minutes = %claim_freeram(2)

!timer_stopped = %claim_freeram(2)
!timer_started = %claim_freeram(2)
