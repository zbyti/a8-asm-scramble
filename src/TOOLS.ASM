;;------------------------------------------------------------------------------
;; RUNTIME PROCEDURES AND FUNCTIONS
;;------------------------------------------------------------------------------
;
;PROC Poke=*(CARD a BYTE v)
;[$85$A0$86$A1$98$A0$00$91$A0$60]
;
;PROC PokeC=*(CARD a, v)
;[$20 Poke $C8$A5$A3$91$A0$60]
;
;BYTE FUNC Peek=*(CARD a)
;[$85$A2$86$A3$A0$00$B1$A2$85$A0$60]
;
;CARD FUNC PeekC=*(CARD a)
;[$85$A2$86$A3$A0$00$B1$A2$85$A0$C8$B1
;$A2$85$A1$60]
;
;PROC SetBlock=*(CARD a, l, v)
;[$85$A0$86$A1$84$A2$A0$00$A5$A2$D0$04
;$A5$A3$F0$16$A5$A4$91$A0$C8$D0$02$E6
;$A1$C6$A2$A5$A2$C9$FF$D0$E7$C6$A3$38
;$B0$E2$60]


;(TMP) - tutaj
;a- co
;y- bajtow
;x- stron

SETBLOCK
    sta (TMP),Y
    dey
    cpy #$ff
    bne SETBLOCK
    inc TMP+1
    dex
    cpx #$ff
    bne SETBLOCK

    rts




;
;PROC MoveBlock=*(CARD d, s, l)
;[$85$A0$86$A1$84$A2$A0$00$A5$A4$D0$04
;$A5$A5$F0$18$B1$A2$91$A0$C8$D0$04$E6
;$A1$E6$A3$C6$A4$A5$A4$C9$FF$D0$E5$C6
;$A5$38$B0$E0$60]
;
;;------------------------------------------------------------------------------
;; CUSTOM PROCEDURES AND FUNCTIONS
;;------------------------------------------------------------------------------
;
;;------------------------------------------------------------------------------
;; WAIT 0-255 FRAMES
;;------------------------------------------------------------------------------
;PROC WAIT=*(BYTE F)[$18$65$14$C5$14$D0$FC$60]
;
;; 110A: 18        CLC
;; 110B: 65 14     ADC $14     ;RTCLOK+2
;; 110D: C5 14     CMP $14     ;RTCLOK+2
;; 110F: D0 FC     BNE $110D
;; 1111: 60        RTS
;

WAIT
	clc
	adc RTCLOK
czekaj
	cmp RTCLOK
	bne czekaj
	rts


;;------------------------------------------------------------------------------
;; WAIT FOR GIVEN RASTER LINE
;;------------------------------------------------------------------------------
;PROC RSYNC=*(BYTE L)[$CD$0B$D4$D0$FB$60]
;
;; 1112: CD 0B D4  CMP $D40B   ;VCOUNT
;; 1115: D0 FB     BNE $1112
;; 1117: 60        RTS
;


RSYNC
    cmp VCOUNT
    bne RSYNC
    rts

;;------------------------------------------------------------------------------
;; SET SYSTEM TIMERS DURING THE VBLANK ROUTINE.
;; USES THE 6502 X REGISTER FOR THE MSB OF VECTOR/TIMES,
;; Y FOR THE LSB AND A FOR THE NUMBER OF THE VECTOR TO HACK (CHANGE).
;;------------------------------------------------------------------------------
;PROC SETVBLK=SETVBV(BYTE WHICH,MSB,LSB)
;
;;------------------------------------------------------------------------------
;; RESET WORKING VARIABLES
;;------------------------------------------------------------------------------
;PROC RESETVARS=*()
;  ISCANONN=0 NEXTROW=0
;  SCREENI=STARTROW
;  LMS=STARTSCREEN
;RET


RESETVARS
    lda #0
    sta ISCANNON
    sta NEXTROW
    sta ROW

	lda <STARTSCREEN
	sta LMS
	lda >STARTSCREEN
	sta LMS+1

	lda <STARTTERRAIN
	sta SCREENI
	lda >STARTTERRAIN
	sta SCREENI+1


;RET
    rts





RASTERBARON
    lda #$E
    sta WSYNC
    sta COLOR4
    rts

RASTERBAROFF
    lda #0
    sta COLOR4
    rts



