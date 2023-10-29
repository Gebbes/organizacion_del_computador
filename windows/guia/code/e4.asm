global main
extern printf, gets

section .data
    ingTexto db "Ingrese un numero: ",0
    formatoIngresado db "%d", 0
    formatoInt db "%d",0
    desplazamiento dq 8
    cantidadNums dq 4
    cantidadIngresada dq 0

    ; Errores:
    msjError db "Hubo un error en el programa", 0

    ; Debbuging
    debugA db "ACA A", 0
    debugB db "ACA B", 0

section .bss
    nums resq 1

    numIngresado resb 50

section .text

main:
    mov rsi, 0
enterNum:
    mov rcx, ingTexto ;Ingreso de los numeros
    sub rsp, 32
    call printf
    add rsp, 32

    mov rcx, numIngresado
    sub rsp, 32
    call gets
    add rsp, 32

    add qword[cantidadIngresada], 1
    mov rax, qword[cantidadNums]
    cmp rax, qword[cantidadIngresada] 
    jg enterNum

    
    ret
