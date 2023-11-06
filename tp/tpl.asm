global main
extern puts, gets, sscanf, printf, checkAlign

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
    mov rdi, ingFecha
    sub rax, rax
    call printf

    mov rdi, input
    call gets

    cmp byte[input], 'N'
    jne scanInput
    ret

scanInput:
    mov rdi, input
    mov rsi, formatoGreg
    mov rdx, gDia
    mov rcx, gMes
    mov r8, gAnio
    call sscanf

    cmp rax, 3
    je isGregorian

    mov rdi, input
    mov rsi, formatoJul
    mov rdx, jDia
    mov rcx, jAnio
    call sscanf
    
    cmp rax, 2
    je isJulian

    ;sub rsp, 8
    ;mov rdi, input
    ;mov rsi, formatoRom
    ;mov rdx, rDia
    ;mov rcx, rMes
    ;mov r8, rAnio
    ;call sscanf
    ;add rsp, 8

    ;cmp rax, 3
    ;je isRoman

    ; manual scan of roman case


    mov rdi, err
    sub rax, rax
    call printf

    ret

isGregorian:
    mov rdi, msjG
    call puts

    mov rdi, formatoGreg
    mov rsi, [gDia] 
    mov rdx, [gMes]
    mov rcx, [gAnio]
    sub rax, rax
    call printf

    jmp clean

isJulian:
    mov rdi, msjJ
    call puts

    mov rdi, formatoJul
    mov rsi, [jDia] 
    mov rcx, [jAnio]
    sub rax, rax
    call printf
    jmp clean

isRoman:
    mov rdi, msjR
    call puts

    mov rdi, formatoRom
    mov rsi, rDia
    mov rdx, rMes
    mov rcx, rAnio
    sub rax, rax
    call printf
    jmp clean

clean:
    ;restart any needed memory
    jmp main
