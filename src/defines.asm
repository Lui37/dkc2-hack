@include

; define rom locations based on rom revision
if !rom_revision == 0
	hijack_level = $808640
	hijack_map = $B5D404
	hijack_bonus_intro = $808CA4
	freerom_BB = $BBF850
	lives_dec = $BEC66D
	hijack_lives = $BEC70E
	end_bananas = $BEC89F
	draw_digit = $BEC814
	freerom_BE = $BEFB5C
elseif !rom_revision == 1
	hijack_level = $808640
	hijack_bonus_intro = $808CD3
	hijack_map = $B5D424
	freerom_BB = $BBF840
	lives_dec = $BEC678
	hijack_lives = $BEC719
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
