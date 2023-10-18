global main
extern puts, gets, sscanf, printf

; X elevado a Y, considerando todos los casos, 1 ++, 2 +-, 3 -+, 4 --

section .data
    ingTexto db "Ingrese dos numeros para hacer X elevado a Y, separados por un espacio: ",0
    formatoIngresado db "%d %d", 0
    formatoInt db "%d",0

    valorNegativo dq -1
    realCero dq 0

    ; Errores:
    msjError db "Hubo un error en el programa", 0
    msjError00 db "Error: 0 elevado a la 0 no es una operacion permitida",0

    ; Debbuging
    debugA db "ACA A", 0
    debugB db "ACA B", 0
    debugC db "ACA C", 0



    ; Resultado
    msjFinal db "El resultado es: %d", 0



section .bss
    X resq 4
    Y resq 4

    absX resq 1
    absY resq 1
    
    valorXpotencia resq 1

    valoresIngresados resb 50

section .text
main:
    mov rdi, ingTexto ;Ingreso de los numeros
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, valoresIngresados
    sub rsp, 8
    call gets
    add rsp, 8

    sub rsp, 8 ;Formateo de los numeros
    mov rdi, valoresIngresados
    mov rsi, formatoIngresado
    mov rdx, X
    mov rcx, Y
    call sscanf
    add rsp, 8
    
    cmp rax, 2
    jne error1

    cmp dword[Y], 0 ; Analisis del input

    sub rsp, 8
    mov rdi, formatoInt
    mov rsi, [Y]
    call printf
    add rsp, 8
    je casoY0
    jl negativeY
    sub rsp, 8
    mov rdi, debugA
    call puts
    add rsp, 8
    jl settedY
    sub rsp, 8
    mov rdi, debugB
    call puts
    add rsp, 8
    settedY:

    ret

error1:
    mov rdi, msjError
    call puts
    ret

casoY0:
    mov rax, [X]
    cmp rax, 0
    je error00
    mov rdi, msjFinal
    mov rsi, 1
    sub rsp, 8
    call printf
    add rsp, 8
    call puts
    jmp settedY

casoX0:
    mov rdi, msjFinal
    mov rsi, 0
    sub rsp, 8
    call printf
    add rsp, 8
    call puts
    ret

error00:
    mov rdi, msjError00
    sub rsp, 8
    call puts
    add rsp, 8
    ret

negativeY:
    sub rsp, 8
    mov rdi, debugC
    call puts
    add rsp, 8
    
    mov rax, [absY]
    IMUL rax, qword[valorNegativo]
    mov [absY], rax
    
    sub rsp, 8
    mov rdi, formatoInt
    mov rsi, [absY]
    call printf
    add rsp, 8

    jmp settedY






