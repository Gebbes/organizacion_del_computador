global main
extern puts, gets, sscanf, printf

section .data
    ingFecha dq "Ingrese una fecha: ", 0
    formatoGreg dq "%d/%d/%d", 0
    formatoRom dq "%s/%s", 0
    formatoJul dq "%d/%d", 0

    err dq "Hubo un error", 13, 0
    
section .bss
    input resb 50

    gDia resq 1
    gMes resq 1
    gAño resq 1

section .text

main:
    mov rcx, ingFecha
    sub rsp, 32
    call printf
    add rsp, 32

    sub rsp, 32
    mov rcx, input
    call gets
    add rsp, 32

    sub rsp, 32
    mov rcx, input
    mov rdx, formatoGreg
    mov r8, gDia
    mov r9, gMes
    mov r10, gAño
    call sscanf
    add rsp, 32

    cmp rax, 3
    je printFecha
    
    mov rcx, err
    sub rsp, 32
    call printf
    add rsp, 32

    ret

printFecha:

    mov rcx, ingFecha
    sub rsp, 32
    call printf
    add rsp, 32

    
    mov rcx, formatoGreg
    mov rdx, gDia
    mov r8, gMes
    mov r9, gAño
    sub rsp, 32
    call printf
    add rsp, 32
    ret