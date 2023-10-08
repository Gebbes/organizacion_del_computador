global main

extern printf
extern gets
extern puts

section .data
unfStrign db "El alumno %s %s de Padron N %s tiene %s años", 0

section .bss
nombre resb 51
apellido resb 51
padron resb 51
edad resb 51

section .text
main:
    mov rdi, nombre
    sub     rsp,8
    call gets
    add     rsp,8

    mov rdi, apellido
    sub     rsp,8
    call gets
    add     rsp,8

    mov rdi, padron
    sub     rsp,8
    call gets
    add     rsp,8


    mov rdi, edad
    sub     rsp,8
    call gets
    add     rsp,8

    mov rdi, unfStrign
    mov rsi, nombre
    mov rdx, apellido
    mov rcx, padron
    mov r8, edad

    sub     rsp,8
    call printf
    add     rsp,8
ret