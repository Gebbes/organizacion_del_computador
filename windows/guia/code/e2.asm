global main

extern printf
extern gets
extern puts

section .data
unfStrign db "El alumno %s %s tiene %s años", 0
ingTexto db "Ingrese nombre, apellido y edad", 0

section .bss
nombre resb 51
apellido resb 51
edad resb 51

section .text
main:
    sub     rsp, 32 
    
    mov rcx, ingTexto
    call puts

    mov rcx, nombre
    call gets

    mov rcx, apellido
    call gets

    mov rcx, edad
    call gets

    mov rcx, unfStrign
    mov rdx, nombre
    mov r8, apellido
    mov r9, edad

    call printf
    add     rsp, 32 
ret