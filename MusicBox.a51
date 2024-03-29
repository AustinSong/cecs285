; Plays Twinkle Twinkle Little Star & Happy Birthday
      ORG 0000H
      AJMP MAIN

; interrupt service routine assigned location
      ORG 000BH
      LJMP INT_0

      ORG 0100H
MAIN:    
	  BDAY BIT P0.0
	  STAR BIT P0.1

	  MOV TMOD, #01H ;use timer0 mode 1 to generate tone.
	  MOV IE, #82H ; enable timer0 overflow interrupt
	  CLR 7FH
	  CLR 7EH
	  
CHECK:
SONG1:JB BDAY, SONG2
SKIP: MOV DPTR, #NOTE_BDAY
      JNB 7FH, SKIP1
	  RET
SKIP1:MOV 50H, DPL
	  MOV 51H, DPH
	  MOV DPTR, #DURATION_BDAY
	  MOV 52H, DPL
	  MOV 53H, DPH
	  SETB 7FH
	  CLR 7EH
	  SJMP SING
	  
SONG2:
      CLR 7FH
	  JB STAR, CHECK
	  JNB 7EH, SKIP2
	  RET
SKIP2:MOV DPTR, #NOTE_STAR
      MOV 50H, DPL
	  MOV 51H, DPH
	  MOV DPTR, #DURATION_STAR
	  MOV 52H, DPL
	  MOV 53H, DPH
	  SETB 7EH
	  SJMP SING
	  
SING:
AGAIN:
      MOV R2, #0 ; index for note table
	  MOV R1, #0 ; index for duration table
	  CLR TR0
	  MOV R5, #4 ; quater note length 
	  LCALL DELAY ; stop between repeats

NEXT: MOV A, R2
	  INC R2
      MOV DPL, 50H
	  MOV DPH, 51H
	  MOVC A, @A+DPTR
	  JZ AGAIN
	  MOV 21H, A
	  MOV TH0, A
	  MOV A,R2
	  INC R2
	  MOVC A, @A+DPTR
	  MOV 20H,A
	  MOV TL0,A
	  MOV A, R1
      MOV DPL, 52H
	  MOV DPH, 53H
	  MOVC A, @A+DPTR
	  MOV R5, A
	  INC R1
	  SETB TR0
	  LCALL DELAY
	  LCALL CHECK
	  SJMP NEXT
;
DELAY:   
D1:   MOV R6, #200
D2:   MOV R7, #125	  
      DJNZ R7, $
	  DJNZ R6, D2
	  DJNZ R5, D1
	  RET

; Twinkle Twinkle Little Star
NOTE_STAR: DW 63777,63777,64360,64360,64489,64489,64360,64216,64216,64140,64140,63969,63969,63777,64360,64360,64216,64216,64140,64140,63969,64360,64360,64216,64216,64140,64140,63969,63777,63777,64360,64360,64489,64489,64360,64216,64216,64140,64140,63969,63969,63777,0
DURATION_STAR: DB 4,4,4,4,4,4,8,4,4,4,4,4,4,8,4,4,4,4,4,4,8,4,4,4,4,4,4,8,4,4,4,4,4,4,8,4,4,4,4,4,4,8,0

; Happy Birthday
NOTE_BDAY: DW 63777,63777,63969,63777,64216,64140,63777,63777,63969,63777,64360,64216,63777,63777,64655,64489,64216,64140,63969,64603,64603,64489,64216,64360,64216,0
DURATION_BDAY: DB 3,1,4,4,4,8,3,1,4,4,4,8,3,1,4,4,4,4,4,3,1,4,4,4,12,0

; Interrupt service routine for timer0 overflow
INT_0:
      CLR TR0
      MOV TL0, 20H
      MOV TH0, 21H
	  CPL P3.7
	  SETB TR0
	  RETI

	  END	   		   		   	
