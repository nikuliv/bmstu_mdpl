;A TSR which prevents Num Lock from being activated

;STEP 1: Get the interrupt vector of INT 8
CLI ; Turn off hardware interrupts
; INT 21, 35 gets an interrupt vector
MOV AH, 35h
MOV AL, 8
INT 21h
;ES:BX Is now a pointer to the interrupt routine for INT 8.

; STEP 2: Make another interrupt behave like INT 8.
; We do this by pointing another interrupt at the vector for INT 8.
; You can set an interrupt's vector using INT 21, 25
; Set DS:DX to the desired vector point, set AL to the interrupt number,
; and then just call INT 21h.

MOV DX, BX
PUSH ES
POP ES

MOV AL, 0C8h
MOV AH, 25h
INT 21h
; INT C8 now points to the code location of INT 8.

; STEP 3: Set INT 8's vector to your own TSR routine
; Need to set DS:DX to point to "TSRCODE".
PUSH CS
POP DS ; Sets DS to equal the Code Segment (where this program is running now)
MOV DX, OFFSET TSRCODE
MOV AL, 8
MOV AH, 25h
INT 21h


; STEP 4: Do INT 21, 31 and you're done.
MOV AL, 0 ; Exit code (for batch files)
MOV DX, 0FFh ; How much memory is reserved for this TSR
MOV AH, 31h ; Make this into a TSR
INT 21h

TSRCODE:
CLI

; TO DO (main code)

INT 0C8h ; Do the old INT 8h

MOV AL, 20h
OUT 20h, AL ; Sends an End-Of-Interrupt signal to the 8259

STI ; Re-enable hardware interrupts
IRET ; Return from interrupt
