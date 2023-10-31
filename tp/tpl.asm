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
    
    gDia resq 0
    gMes resq 0
    gAño resq 0

section .text
main:
    mov rdi, ingFecha
    sub rsp, 8
    call printf
    add rsp, 8

    sub rsp, 8
    mov rdi, input
    call gets
    add rsp, 8

    sub rsp, 8
    mov rdi, input
    mov rsi, formatoGreg
    mov rdx, gDia
    mov rcx, gMes
    mov r8, gAño
    call sscanf
    add rsp, 8

    cmp rax, 3
    je printFecha
    
    mov rdi, err
    sub rsp, 8
    call printf
    add rsp, 8

    ret

printFecha:

    mov rdi, ingFecha
    sub rsp, 8
    call printf
    add rsp, 8

    
    mov rdi, formatoGreg
    mov rsi, gDia
    mov rdx, gMes
    mov rcx, gAño
    sub rsp, 8
    call printf
    add rsp, 8
    ret
