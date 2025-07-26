.MODEL SMALL
.STACK 100h

.DATA
mainMenuTitle      db 'SocioQuiz: Discover Your Personality Type$', 0
menuOption1        db '[1] Start Quiz$', 0
menuOption2        db '[2] View Past Results$', 0
menuOption3        db '[3] Exit$', 0
promptSelection    db '>>> $'
newline            db 13, 10, '$'
viewResultsMsg     db 'Viewing past results... (not implemented yet)$'

.CODE

PUBLIC ExitProgram

EXTRN ClearScreen:NEAR
EXTRN StartQuiz:NEAR
;EXTRN CountLines:NEAR

start:
    mov ax, @data
    mov ds, ax

    call ClearScreen
    call DrawMainMenu
    call HandleMainMenuInput
    call ExitProgram

; === Procedures ===

DrawMainMenu PROC
    mov ah, 09h
    lea dx, mainMenuTitle
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, menuOption1
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, menuOption2
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h

    mov ah, 09h
    lea dx, menuOption3
    int 21h

    mov ah, 09h
    lea dx, newline
    int 21h

    ret
DrawMainMenu ENDP

HandleMainMenuInput PROC
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h

    lea dx, promptSelection
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    jne Check2
    call StartQuiz
	;call CountLines
    jmp DoneMenu

Check2:
    cmp al, '2'
    jne Check3
    call ViewResults
    jmp DoneMenu

Check3:
    cmp al, '3'
    jne DoneMenu
    call ExitProgram

DoneMenu:
    ret
HandleMainMenuInput ENDP

ViewResults PROC
    mov ah, 09h
    lea dx, newline
    int 21h
    lea dx, viewResultsMsg
    int 21h
    ret
ViewResults ENDP

ExitProgram PROC
    mov ax, 4C00h
    int 21h
ExitProgram ENDP

END start
