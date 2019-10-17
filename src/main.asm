hirom

; 0 for 1.0
; 1 for 1.1
!rom_revision ?= 1

incsrc "defines.asm"

incsrc "edits.asm"
incsrc "hijacks.asm"

org freerom_BB
incsrc "level.asm"
incsrc "map.asm"

warnpc $BBFFFF

org freerom_BE
incsrc "hud.asm"

warnpc $BEFFFF
