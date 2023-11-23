global main
extern puts, gets, sscanf, printf

section .data
    ingFecha dq "Ingrese una fecha ( N para detener el programa ) : ", 0
    cierre dq "X",0
    formatoGreg dq "%d/%d/%d",10, 0

    msjG db "El formato es Gregoriano!",0

    msjError dq "No proceso la cantidad de args", 0
    msjErrores dq "Se procesaron %d", 0
    
section .bss
    input resb 50
    
    gDia resq 1
    gMes resq 1
    gAnio resq 1

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
    push gAnio
    sub rsp, 32
    call sscanf
    add rsp, 32
    pop qword[gAnio]

    cmp rax, 3
    je isGregorian

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
