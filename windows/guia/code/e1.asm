global main
extern puts

section     .data
mensaje db "Organizacion del Computador", 0

section		.text
main:
	sub     rsp, 32             ; Reserva espacio para el Shadow Space

	mov			rcx,mensaje		;Parametro 1: direccion del mensaje a imprimir
	call		puts					;puts: imprime hasta el 0 binario y agrega fin de linea

	add     rsp, 32             ; Libera el espacio reservado del Shadow Space
	ret