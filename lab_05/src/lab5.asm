STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(?)
STACKSEG ENDS

MATRIX_SEG SEGMENT para 'DATA'
    ROWSMSG DB 'Enter rows number: $'
    COLSMSG DB 'Enter columns number: $'
    MATRSMSG DB 'Enter matrix elements: $'
	MATRIX DB 9 * 9 DUP(0)
	ROWS DB 0
	COLS DB 0
	MAX_SUM DB 0
	TEMP_SUM DB 0
	COL_INDX DB 0
	RESULT DB 'Matrix: $'
	
	
MATRIX_SEG ENDS

CODESEG SEGMENT para 'CODE'
    ASSUME CS:CODESEG, DS:MATRIX_SEG, SS:STACKSEG 
	
READ_SYMB:
    MOV AH, 01h
    INT 21H
	RET

CARRIAGE_RET:
	MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
	RET

PRINT_SPACE:
	MOV AH, 2
    MOV DL, ' '
    INT 21H
	RET
	
MATRIX_OUTPUT:
	MOV CX, 0
	MOV CL, ROWS
	MOV BX, 0
	OUTPUT:
		MOV DH, CL
		MOV CL, COLS
		OUTPUT_IN_ROW:
			MOV AH, 2
			MOV DL, MATRIX[BX]
			ADD DL, '0'
			INT 21H
			INC BX
			CALL PRINT_SPACE
			LOOP OUTPUT_IN_ROW
		CALL CARRIAGE_RET
		MOV CL, DH
		LOOP OUTPUT
	RET

SWAP_VALUES:
	MOV DL, TEMP_SUM
	MOV MAX_SUM, DL
	MOV DL, COLS
	MOV COL_INDX, DL
	SUB COL_INDX, CL
	JMP BACK1

DELETE_ELEM:
	MOV DH, CL
	MOV AH, BL
	DELETION:
		INC BL
		MOV DL, MATRIX[BX]
		DEC BL
		MOV MATRIX[BX], DL
		INC BL
		LOOP DELETION
	MOV CL, DH
	MOV BL, AH
	MOV DH, COL_INDX
	ADD DH, COLS
	MOV COL_INDX, DH
	DEC COL_INDX
	JMP BACK2

main:
    MOV AX, MATRIX_SEG
    MOV DS, AX
	
	;READ ROWS
	MOV AH, 09h
	MOV DX, OFFSET ROWSMSG
	INT 21h
	CALL READ_SYMB
	MOV ROWS, AL
	SUB ROWS, '0'
	CALL CARRIAGE_RET
	
	;READ COLS
	MOV AH, 09h
	MOV DX, OFFSET COLSMSG
	INT 21h
	CALL READ_SYMB
	MOV COLS, AL
	SUB COLS, '0'
	CALL CARRIAGE_RET
	
	MOV AH, 09h
	MOV DX, OFFSET MATRSMSG
	INT 21h
	CALL CARRIAGE_RET
	
	;READ MATRIX
	MOV CX, 0
	MOV CL, ROWS
	MOV BX, 0
	INPUT:
		MOV DH, CL
		MOV CL, COLS
		INPUT_IN_ROW:
			CALL READ_SYMB
			MOV MATRIX[BX], AL
			SUB MATRIX[BX], '0'
			INC BX
			CALL PRINT_SPACE
			LOOP INPUT_IN_ROW
		CALL CARRIAGE_RET
		MOV CL, DH
		LOOP INPUT
	
	
	;FIND MAXIMUM
	MOV CX, 0
	MOV CL, COLS
	MOV BX, 0
	MARK1:
		MOV BL, COLS
		SUB BL, CL
		MOV DH, CL
		MOV CL, ROWS
		MOV TEMP_SUM, 0
		MARK2:
			MOV DL, TEMP_SUM
			ADD DL, MATRIX[BX]
			MOV TEMP_SUM, DL
			ADD BL, COLS
			LOOP MARK2
		MOV CL, DH
		MOV DL, TEMP_SUM
		CMP DL, MAX_SUM
		JA SWAP_VALUES
		BACK1:
		LOOP MARK1
	
	;MATRIX SIZE CALCULATION
	MOV CX, 0
	MOV CL, ROWS
	MOV BX, 0
	FIND_SIZE:
		ADD BH, COLS
		LOOP FIND_SIZE
	
	;COLUMN DELITION
	MOV CX, 0
	MOV CL, BH
	MOV BX, 0
	DEL_MARK1:
		CMP BL, COL_INDX
		JE DELETE_ELEM
		INC BX
		BACK2:
		LOOP DEL_MARK1
	DEC COLS
	
	;Result output
	CALL CARRIAGE_RET
	MOV AH, 09h
	MOV DX, OFFSET RESULT
	INT 21h
	CALL CARRIAGE_RET
	CALL MATRIX_OUTPUT

	
    MOV AH, 4CH
    INT 21H
CODESEG ENDS
END main