.MODEL SMALL
.STACK 100H

.DATA
filename        db 'questi~1.txt', 0
buffer          db 128 dup('$')     ; buffer to store a question
quizIntro       db 'Starting the quiz...',13,10,'$'
newline         db 13,10,'$'
promptNext      db 13,10,'Press any key for next question...',13,10,'$'
eofMsg          db 13,10,'End of quiz.',13,10,'$'
fileErrMsg      db 'Cannot open file.',13,10,'$'
fileHandle      dw ?

questionPrefix  db 'Question [', '$'
slash10         db '/10]: ', '$'
questionNumStr  db '0', '$'   ; ASCII value for number
answerLine      db 13,10,'Agree    [3a][2a][1a] [0] [1d][2d][3d]    Disagree',13,10,'>>> $'
questionNum     db 1

.CODE
PUBLIC StartQuiz
StartQuiz PROC
    mov ax, @DATA
    mov ds, ax

    ; show intro
	lea dx, newline
	int 21h
    mov ah, 09h
    lea dx, quizIntro
    int 21h

    ; open file
    mov ah, 3Dh
    xor al, al      ; read mode
    lea dx, filename
    int 21h
    jc FILE_ERROR
    mov fileHandle, ax

READ_NEXT_QUESTION:
	; stop if 10 questions have been shown
    mov al, questionNum
    cmp al, 11
    jge END_OF_FILE
	
    ; Clear buffer
    lea di, buffer
    mov cx, 128
clearLoop:
    mov byte ptr [di], '$'
    inc di
    loop clearLoop

    ; read one character at a time into buffer until '$'
    lea di, buffer
readLoop:
    mov ah, 3Fh
    mov bx, fileHandle
    mov dx, di
    mov cx, 1
    int 21h
    jc END_OF_FILE      ; if error/EOF
    cmp ax, 0
    je END_OF_FILE      ; if zero bytes read

    cmp byte ptr [di], '$'
    je doneReading

    inc di
    jmp readLoop

doneReading:
    ; newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; print "Question ["
    lea dx, questionPrefix
    int 21h

    ; Convert questionNum to ASCII
    mov al, questionNum
    add al, '0'
    mov questionNumStr, al

    lea dx, questionNumStr
    int 21h

    ; print "/10]: "
    lea dx, slash10
    int 21h

    ; print the question
    lea dx, buffer
    int 21h

    ; print answers layout
    lea dx, answerLine
    int 21h

    ; wait for Enter (ignore input for now)
waitEnter:
	; to do: validate input and record

    mov ah, 01h
    int 21h
    cmp al, 13      ; Enter key
    jne waitEnter

    inc questionNum

    jmp READ_NEXT_QUESTION
END_OF_FILE:
    lea dx, eofMsg
    mov ah, 09h
    int 21h

    ; close file
    mov ah, 3Eh
    mov bx, fileHandle
    int 21h

    ; Exit
    mov ah, 4Ch
    int 21h

FILE_ERROR:
    lea dx, fileErrMsg
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h

ret
StartQuiz ENDP
END