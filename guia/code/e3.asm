global main
global puts

; X elevado a Y, considerando todos los casos, 1 ++, 2 +-, 3 -+, 4 --

section .bss
    X db 50
    Y db 50

section .data
    ingTexto "Ingrese dos numeros para hacer X elevado a Y, separados por un espacio: ",0

main:

    mov rdi, ingTexto
    call puts

ret


applyA:
ret

ApplyB:
ret

ApplyC:
ret

ApplyD:
ret
