SEG1 SEGMENT para 'DATA'
    DB 100 DUP(?)
SEG1 ENDS

SEG2 SEGMENT para 'DATA'
    DB 2 DUP(?)
SEG2 ENDS

CODESEG SEGMENT para 'CODE'
    ASSUME CS:CODESEG, DS:SEG1, ES:SEG2
main:
    MOV AX, SEG1
    MOV DS, AX

    MOV AH, 0AH
    MOV DX, 0
    INT 21H
    
    MOV DH, DS:2
    SUB DH, 48
    ADD DH, DS:4
    MOV ES:1, DH
    
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    MOV DL, ES:1
    INT 21H
    
    MOV AH, 4CH
    INT 21H
CODESEG ENDS
END main