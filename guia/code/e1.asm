global main
extern puts

section .data
mensaje db "Organizacion del Computador", 0

main:

    mov rdi, mensaje
    call puts

    ret