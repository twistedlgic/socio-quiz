.MODEL SMALL

.DATA

.CODE
PUBLIC ClearScreen
PUBLIC PrintNum
PUBLIC PrintLine

ClearScreen PROC
    mov ah, 0
    mov al, 3
    int 10h
    ret
ClearScreen ENDP

PrintNum PROC
    push ax
    mov ah, 0
    mov bl, 10
    div bl
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h

    mov al, ah
    add al, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    pop ax
    ret
PrintNum ENDP

PrintLine PROC
    push dx
    push si
    mov si, dx
.nextChar:
    mov al, [si]
    cmp al, 0Dh
    je .done
    cmp al, 0Ah
    je .done
    mov dl, al
    mov ah, 02h
    int 21h
    inc si
    jmp .nextChar
.done:
    pop si
    pop dx
    ret
PrintLine ENDP

END
