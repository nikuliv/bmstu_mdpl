.model tiny
.186
CODE SEGMENT
    ASSUME CS:CODE, DS:CODE
    ORG 100h
main:	
	jmp init
	prev_interrupt_proc	DD 0
	counter	DB 0
	speed	DB 0

my_08h proc
	PUSHF
	
	; Calling the previous interrupt handler
	CALL CS:prev_interrupt_proc
	
	PUSHA
	PUSH DS
	
	; Counter incrementing
	XOR AX, AX
    MOV AL, DS:counter
    INC AL
    MOV DS:counter, AL

	; If counter is not equal 18 end execution
    CMP DS:counter, 18
    JNE proc_end

	; Counter zeroing
    XOR AL, AL
    MOV DS:counter, AL

	; If speed is not equal 0 decrement speed
    CMP DS:speed, 0
    JNE dec_speed

	; Else set maximum speed
    MOV AL, 31
    MOV DS:speed, AL
	JMP set_speed

    dec_speed:
    MOV AL, DS:speed
    DEC AL
    MOV DS:speed, AL

	; Changing input port settings
	set_speed:
    MOV AL, 0F3H ; AUTOREPEAT MODE
    OUT 60H, AL
    MOV AL, DS:speed ; SET AUTOREPEAT SPEED (UP TO 31D)
    OUT 60H, AL

    proc_end:
	POPA
	POP DS
	
	; Returning from the interrupt
	; Restoring FLAGS, CS:IP
	IRET
my_08h endp
interrupt_end:

init:
	; Getting the address of the interrupt handler
    MOV AX, 3508H 
	INT 21H
	
	; Saving previous handler
	MOV WORD PTR prev_interrupt_proc, BX
	MOV WORD PTR prev_interrupt_proc + 2, ES
	
	; Installing new 8h interrupt handler
	MOV AX,  2508H
	MOV DX, OFFSET my_08h
	INT 21H
	
	; Calculating the size of the required memory (in paragraphs)
	; (interrupt_end - main) / 16
	MOV AX, interrupt_end
	SUB AX, main
	MOV DL, 16
	DIV DL
	XOR DH, DH
	MOV DL, AL
	INC DL
	MOV AX, 3100H
	
	INT 21H
	

CODE ends
end main
