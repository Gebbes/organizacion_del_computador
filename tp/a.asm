global main
extern puts, gets, sscanf, printf

section .data
    ingFecha dq "Ingrese una fecha ( N para detener el programa ) : ", 0

    string db "Usted ingreso: %s", 10,0

    
section .bss
    input resb 50
    

    stringv2 resq 1

section .text

main: ; ----> uso correcto de pila
    mov rcx, ingFecha
    sub rsp, 32
    call printf
    add rsp, 32
    
    mov rcx, input
    sub rsp, 32
    call gets
    add rsp, 32

    push input

    pop r10

    mov rcx, string
    mov rdx, r10
    sub rsp, 32
    call printf
    add rsp, 32
    
ret