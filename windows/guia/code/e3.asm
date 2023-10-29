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
    X resq 1
    Y resq 1

    absX resq 1
    absY resq 1
    
    valorXpotencia resq 1

    valoresIngresados resb 50

section .text
main:
    sub   rsp, 32 

    mov rcx, ingTexto ;Ingreso de los numeros
    call puts

    mov rcx, valoresIngresados
    call gets

    mov rcx, valoresIngresados ;Formateo de los numeros
    mov rdx, formatoIngresado
    mov r8, X
    mov r9, Y
    sub rsp,32
    call sscanf
    add rsp,32

    cmp rax, 2
    jne error1

    cmp qword[Y], -20 ; Analisis del input
    je casoEspecial
    mov rcx, formatoInt
    mov rdx, qword[Y]
    call printf
    je casoEspecial
    
    mov rcx, debugA
    call puts
    jl settedY
    mov rcx, debugB
    call puts
settedY:

    add rsp, 32
    ret

error1:
    mov rcx, msjError
    call puts
    add rsp, 32

    ret

casoEspecial:
    mov rax, qword[X]
    cmp rax, 0
    je error00
    mov rcx, msjFinal
    mov rdx, 1
    call printf
    jmp settedY

casoX0:
    mov rcx, msjFinal
    mov rdx, 0
    call printf
    call puts
    add rsp, 32

    ret

error00:
    mov rcx, msjError00
    call puts
    add rsp, 32

    ret

isYneg:
    mov rcx, debugC
    call puts
    
    mov rax, [absY]
    IMUL rax, qword[valorNegativo]
    mov [absY], rax
    
    mov rcx, formatoInt
    mov rdx, [absY]
    call printf

    jmp settedY







