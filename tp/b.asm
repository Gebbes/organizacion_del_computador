global main
extern puts, gets, sscanf, printf

section .data
    ingFecha dq "Ingrese una fecha ( N para detener el programa ) : ", 0
    cierre dq "X",0
    formatoGreg dq "%d/%d/%d",10, 0


    msjG db "El formato es Gregoriano!",0



    err dq "Hubo un error", 0
    msjError dq "No proceso la cantidad de args", 0
    msjErrores dq "Se prc+ocesaron %d", 0
    
section .bss
    input resb 50
    
    gDia resd 1
    gMes resd 1
    gAnio resd 1

section .text

main:
    mov rcx, ingFecha
    sub rsp, 32
    call printf
    add rsp, 32
    
    mov rcx, input
    sub rsp, 32
    call gets
    add rsp, 32

    cmp byte[input], 'N'
    jne scanInput
    ret

scanInput:
    mov rcx, input
    mov rdx, formatoGreg
    mov r8, gDia
    mov r9, gMes
    mov r10, gAnio
    push r10
    sub rsp, 32
    call sscanf
    add rsp, 32
    pop r10
    mov qword[gAnio], r10

    cmp rax, 3
    je isGregorian

    mov rcx, msjError
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, msjErrores
    mov rdx, rax
    sub rsp, 32
    call printf
    add rsp, 32

    ret

isGregorian:
    mov rcx, msjG
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, formatoGreg
    mov rdx, [gDia] 
    mov r8, [gMes]
    mov r9, [gAnio]
    sub rsp, 32
    call printf
    add rsp, 32
    
ret
