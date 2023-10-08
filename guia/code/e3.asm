global main
extern puts, gets, sscanf, printf

; X elevado a Y, considerando todos los casos, 1 ++, 2 +-, 3 -+, 4 --

section .data
    ingTexto dq "Ingrese dos numeros para hacer X elevado a Y, separados por un espacio: ",0
    formatoIngresado dq "%d %d", 0
    msjError dq "Hubo un error en el programa", 0
    intFormat dq "%d",0
    debug dq "hasta aca llegue", 0
    debugA dq "hasta aca llegueA", 0
    debugB dq "hasta aca llegueB", 0
    debugC dq "hasta aca llegueC", 0

section .bss
    X resq 1
    Y resq 1
    valoresIngresados resb 50


section .text
main:

    mov rdi, ingTexto
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi,  valoresIngresados
    sub rsp, 8
    call gets
    add rsp, 8

    sub rsp, 8
    mov rdi, formatoIngresado
    mov rsi, X
    mov rdx, Y
    call sscanf
    
    cmp rax, 2
    jne error1

    add rsp, 8

    mov rdi, debugB
    call puts
    mov rdi, intFormat
    mov rsi, X
    sub rsp, 8
    call printf
    add rsp, 8
    mov rdi, debugA


    ret

error1:    
    mov rdi, debug
    call puts
    mov rdi, intFormat
    call printf
    mov rdi, debug
    mov rdi, msjError
    call puts
    ret


