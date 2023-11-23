global main
extern puts, gets, sscanf, printf

section .data
    ingFecha dq "Ingrese una fecha ( N para detener el programa ) : ", 0
    cierre dq "X",0
    formatoGreg dq "%d/%d/%d",10, 0
    formatoJul dq "%d/%d",10, 0
    formatoRom dq "%s/%s/%s",10, 0

    msjG db "El formato es Gregoriano!",0
    msjJ db "El formato es Juliano!",0
    msjR db "El formato es Romano!",0


    err dq "Hubo un error", 0
    
section .bss
    input resb 50
    
    gDia resq 1
    gMes resq 1
    gAnio resq 1

    jDia resq 1
    jAnio resq 1

    rDia resb 20
    rMes resb 20
    rAnio resb 20

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

    mov rcx, input
    mov rdx, formatoJul
    mov r8, jDia
    mov r9, jAnio
    sub rsp, 32
    call sscanf
    add rsp, 32
    
    cmp rax, 2
    je isJulian

    ; manual scan of roman case

    mov rsi, 0


error:
    mov rcx, err
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

    jmp clean

isJulian:
    mov rcx, msjJ
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, formatoJul
    mov rdx, [jDia] 
    mov r8, [jAnio]
    sub rsp, 32
    call printf
    add rsp, 32
    jmp clean

isRoman:
    mov rcx, msjR
    call puts

    mov rcx, formatoRom
    mov rdx, rDia
    mov r8, rMes
    mov r9, rAnio
    sub rsp, 32
    call printf
    add rsp, 32
    jmp clean

clean:
    ;restart any needed memory
    jmp main
