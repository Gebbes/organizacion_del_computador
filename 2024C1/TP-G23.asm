global main
extern puts, printf, gets, sscanf

;el Zorro es el unico que tiene la posibilidad de saltear su turno
;al presionar el 5 donde se quedaria quieto

; variables con contenido

section .data
msjBienvenido db "Hola!!! bienvenido a Las Ocas y el Zorro",0
msjControlesOcas db "Los controles para las ocas son: ",0
controlesOcas db "  4   6  ",10
              db "    2     ",10
              db "cada uno te permite moverte en una direccion, 2 abajo,"
              db " 4 a la izquierda y 6 a la derecha",0
              
msjControlesZorro db "Los controles para el zorro son: ",0
controlesZorro db "  7 8 9   ",10
               db "  4 5 6   ",10
               db "  1 2 3   ",10
               db "cada uno te permite moverte en una direccion, 8 arriba,"
               db " 4 a la izquierda... y el 5 te permite saltear el turno.", 10
               db "('h' para recordar los controles y 'x' para terminar el juego)",0

tablero dq "F","F","o","o","o","F","F"
        dq "F","F","o","o","o","F","F"
        dq "o","o","o","o","o","o","o"
        dq "o","_","_","_","_","_","o"
        dq "o","_","_","_","_","_","o"
        dq "F","F","_","X","_","F","F"
        dq "F","F","_","_","_","F","F",0
        
indicesSup db  "        1   2   3   4   5   6   7", 0
filaCortaV2 db "%lli             | %c | %c | %c |          ",10,0
filaLarga db   "%lli     | %c | %c | %c | %c | %c | %c | %c |",10,0

zorroF dq 5
zorroC dq 4

msjIngresarMovimiento db  "Ingresa un movimiento ('h' para recordar los controles y 'x' para terminar el juego) :", 0
msjMovimientoInvalido db "El movimiento elegido es invalido, por favor elija de nuevo.",0
msjFin db 10,"      FIN DEL JUEGO - NO HAY GANADOR",10,0
msjTurnoZorro db "Es el turno del zorro!", 0
msjZorroWin db 10,"     Gano el Zorro al comer 12 Ocas",10,0
msjOcaWin db 10,"   Pierde el Zorro por acorralamiento",10,0

msjTurnoOca db "Es el turno de la oca!",0
msjOcaFila db "Ingresar Fila de la oca",0
msjOcaColumna db "Ingresar Columna de la oca",0
msjOcaPosicionInvalido db "No existe una oca en esa posicion",10,0
msjesoca db "Finalizo el turno de la Oca",10,0
totalOcas dq 17
           
numFormat db "%lli",0

; variables sin contenido
section .bss

indiceCol resq 1

OcaFila resq 1
OcaCol resq 1
elem  resq 1
movElem resq 1
inputMovimiento resb 8
inputNum resb 8



section .text

main:
    mov rbp, rsp; for correct debugging

    call introduccion
    call printTablero

cambiarTurno:
    call turnoZorro
    cmp rax, 0
    jne end
    
    call turnoOcas
    cmp rax, 0
    jne end
    call printTablero
    
    jmp cambiarTurno

end:
ret

introduccion:
    mov rcx, msjBienvenido
    sub rsp, 32
    call puts
    add rsp, 32
    
    call controles
    
ret
controles:
    mov rcx, msjControlesOcas
    sub rsp, 32
    call puts
    add rsp, 32
    
    mov rcx, controlesOcas
    sub rsp, 32
    call puts
    add rsp, 32
    
    mov rcx, msjControlesZorro
    sub rsp, 32
    call puts
    add rsp, 32
    
    mov rcx, controlesZorro
    sub rsp, 32
    call puts
    add rsp, 32
    
ret
    
printTablero:
    mov rcx, indicesSup
    sub rsp, 32
    call puts
    add rsp, 32
    mov rcx, 2
    mov qword[indiceCol], 0
imprimirFilaCortaAlta:
    call printCorto
    loop imprimirFilaCortaAlta
    mov rcx, 3
imprimirFilaLarga:
    call printLargo
    loop imprimirFilaLarga
    mov rcx, 2
imprimirFilaCortaBaja:
    call printCorto
    loop imprimirFilaCortaBaja
    
ret

printCorto:
    push rcx
    mov rbx, qword[indiceCol]
    imul rbx, 7*8 ; base del desplazamiento
    inc qword[indiceCol] ; adelanto en 1 el indice para que no arranque en 0
    
    mov rdx, qword[indiceCol]
    add rbx,2 * 8
    mov r8, [tablero + rbx]
    add rbx, 8
    mov r9, [tablero + rbx]
    add rbx, 8
    push qword[tablero + rbx]
    mov rcx, filaCortaV2
    
    sub rsp, 32
    call printf
    add rsp, 32
    pop rbx ;pop para acomodar la pila
    
    pop rcx    
ret
printLargo:
    push rcx
    mov rbx, qword[indiceCol]
    imul rbx, 7*8 ; base del desplazamiento
    inc qword[indiceCol] ; adelanto en 1 el indice para que no arranque en 0
    
    mov rdx, qword[indiceCol]
    mov r8, [tablero + rbx]
    add rbx, 8
    mov r9, [tablero + rbx]
    
    add rbx, 5 * 8
    mov rcx, 5
pushNext: 
    mov rax, qword[tablero+rbx]

    push qword[tablero + rbx]
    sub rbx, 8
    loop pushNext
    mov rcx, filaLarga
    
    sub rsp, 32
    call printf
    add rsp, 32
    
    mov rcx, 5
popNext:
    pop rbx ;pop para acomodar la pila
    loop popNext
    
    
    pop rcx
    
ret

; deja el resultado en el rax, 0 no puede moverse, 1 puede
validarZorroEncerrado:
    mov rcx, 9
    
validarSiguiente:
    cmp rcx, 5; saltear turno no salva de estar encerrado 
    je loopValidar
    call validarMovimientoZorro
    cmp rax, 1
    je puedeMoverse

loopValidar:
    loop validarSiguiente
puedeMoverse:
ret

; numero de movimiento en rcx
;0 en rax si no es valido, 1 si es valido
validarMovimientoZorro:
    cmp rcx, 1
    jl noEsNumeroValido
    cmp rcx, 9
    jg noEsNumeroValido
    mov rax, 1 
    cmp rcx, 5
    jne noSalteaMovimiento
    ret
noSalteaMovimiento:    
    mov r8, qword[zorroF]
    mov r9, qword[zorroC]
    call calcularProximaCelda
    
verificarCelda:
    push rcx
    push rdx
    
    mov rcx, r12
    mov rdx, r14
    
    call validarSiCeldaExiste
    cmp rax, 0
    je noEsValido
    
    call calcularDesplazamiento
    cmp qword[tablero+rax], "_"
    je esValido
    
    mov rcx, r13   ;en este punto el movimiento apunta a una oca
    mov rdx, r15
    
    call validarSiCeldaExiste
    cmp rax, 0
    je noEsValido
    
    call calcularDesplazamiento
    cmp qword[tablero+rax], "_"
    jne noEsValido

esValido:
    mov rax, 1
    pop rdx
    pop rcx
ret
noEsNumeroValido:
    mov rax, 0
    ret
noEsValido:
    mov rax, 0
    pop rdx
    pop rcx
ret

; deja en el rax un 1 si termino la partida, 2 si gano el zorro, 3 si ganan las ocas
turnoOcas:
    mov rcx, msjTurnoOca
    sub rsp, 32
    call puts
    add rsp, 32

pedirOcaPosicion:
    mov rcx, msjOcaFila
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, OcaFila
    sub rsp, 32
    call gets
    add rsp, 32


    cmp qword[OcaFila], "x"
    je terminarPartida

    mov rcx, msjOcaColumna
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, OcaCol
    sub rsp, 32
    call gets
    add rsp, 32

    cmp qword[OcaCol], "x"
    je terminarPartida

verificarOca:
    mov rax, 9
    mov rcx, OcaFila
    call convertirStringAInt
    cmp rax, 0
    je errorOcaPosicion
    mov [OcaFila], rcx


    mov rcx, OcaCol
    call convertirStringAInt
    cmp rax, 0
    je errorOcaPosicion
    mov [OcaCol],rcx


    cmp qword[OcaFila], 7
    jg errorOcaPosicion
    cmp qword[OcaFila], 1
    jl errorOcaPosicion

    cmp qword[OcaCol], 7
    jg errorOcaPosicion
    cmp qword[OcaCol], 1
    jl errorOcaPosicion
    
    mov rax, qword[OcaFila]
    dec rax
    imul rax, 7
    add rax, qword[OcaCol]
    dec rax
    mov rax, qword[tablero + rax*8]
    mov [elem], rax

    cmp qword[elem], "o"
    jne errorOcaPosicion   

moverOca:
    mov rcx, msjIngresarMovimiento
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, inputMovimiento
    sub rsp, 32
    call gets
    add rsp, 32

    cmp qword[inputMovimiento], "x"
    je terminarPartida

    cmp qword[inputMovimiento], "4"
    je moverOcaIzq

    cmp qword[inputMovimiento], "6"
    je moverOcaDer

    cmp qword[inputMovimiento], "2"
    je moverOcaAbajo

    cmp qword[inputMovimiento], "h"
    jne validarOcaMovimiento

    call controles
    jmp moverOca
    ret

validarOcaMovimiento:
    mov rcx, inputMovimiento
    call convertirStringAInt
    cmp rax, 0
    je errorMovimientoInvalidoOca
    jmp errorMovimientoInvalidoOca

    ret

moverOcaIzq:

    mov rax, qword[OcaFila]
    dec rax
    imul rax, 7
    add rax, qword[OcaCol]
    dec rax
    dec rax
    mov rbx, qword[tablero + rax*8]
    mov [movElem], rbx

    cmp qword[movElem], "_"
    je realizarMovimientoOca
    jmp errorMovimientoInvalidoOca

ret

moverOcaDer:
    mov rax, qword[OcaFila]
    dec rax
    imul rax, 7
    add rax, qword[OcaCol]
    mov rbx, qword[tablero + rax*8]
    mov [movElem], rbx

    cmp qword[movElem], "_"
    je realizarMovimientoOca

    jmp errorMovimientoInvalidoOca
    
ret


moverOcaAbajo:
    mov rax, qword[OcaFila]
    imul rax, 7
    add rax, qword[OcaCol]
    dec rax
    mov rbx, qword[tablero + rax*8]
    mov [movElem], rbx

    cmp qword[movElem], "_"
    je realizarMovimientoOca

    jmp errorMovimientoInvalidoOca

ret

realizarMovimientoOca:

    mov qword[tablero + rax*8], "o"

    mov rax, 0
    mov rax, qword[OcaFila]
    dec rax
    imul rax, 7
    add rax, qword[OcaCol]
    dec rax
    mov qword[tablero + rax*8],"_"

    mov rcx, msjesoca
    sub rsp, 32
    call puts
    add rsp, 32

verificarEncierro:

    call validarZorroEncerrado
    cmp rax, 1
    jne ganoOca
    mov rax, 0
ret

ganoOca:
    mov rcx, msjOcaWin
    sub rsp, 32
    call puts
    add rsp, 32
    call printTablero
    mov rax, 3
ret


turnoZorro:
    mov rcx, msjTurnoZorro
    sub rsp, 32
    call puts
    add rsp, 32

pedirMovimientoZorro:
    mov rcx, msjIngresarMovimiento
    sub rsp, 32
    call puts
    add rsp, 32


    mov rcx, inputMovimiento
    sub rsp, 32
    call gets
    add rsp, 32

    cmp qword[inputMovimiento], "x"
    je terminarPartida


    cmp qword[inputMovimiento], "5"
    je finTurnoZorro

    cmp qword[inputMovimiento], "h"
    jne continuarTurnoZorro

    call controles
    jmp pedirMovimientoZorro

continuarTurnoZorro:
    mov rcx, inputMovimiento
    call convertirStringAInt
    cmp rax, 0
    je errorMovimientoInvalido

    call hacerMovimientoZorro
    cmp rax, 0
    je errorMovimientoInvalido

    push rax
    call printTablero
    pop rax
    cmp byte[totalOcas], 5
    je ganoZorro
    cmp rax, 2
    je turnoZorro ; comio oca


    mov rcx, rax

    cmp rcx, 2
    je pedirMovimientoZorro

finTurnoZorro:
    mov rax, 0
    ret
terminarPartida:
    mov rcx, msjFin
    sub rsp, 32
    call puts
    add rsp, 32
    call printTablero
    mov rax, 1
    ret
ganoZorro:
    mov rcx, msjZorroWin
    sub rsp, 32
    call puts
    add rsp, 32
    mov rax, 2
    ret

endZorro:
ret
errorMovimientoInvalido:
    mov rcx, msjMovimientoInvalido
    sub rsp, 32
    call puts
    add rsp, 32
    jmp pedirMovimientoZorro

errorMovimientoInvalidoOca:
    mov rcx, msjMovimientoInvalido
    sub rsp, 32
    call puts
    add rsp, 32
    jmp pedirOcaPosicion

errorOcaPosicion:
    mov rcx, msjOcaPosicionInvalido
    sub rsp, 32
    call puts
    add rsp, 32
    jmp pedirOcaPosicion
; calcula cual seria la proxima celda si se realizase el movimiento dejado en rcx,a partir
; de fila y col actuales en r8 y r9. Deja proxima fila/col en r12/r14 y en caso de comerse una oca
; los siguientes en r13/r15
calcularProximaCelda:
    mov r12, r8 ;fila del movimiento
    mov r13, r8 ;fila del movimiento si comiese una oca
    mov r14, r9 ;columna del movimiento
    mov r15, r9 ;columna del movimiento si comiese una oca

    cmp rcx, 9
    je calcular9
    cmp rcx, 8
    je calcular8
    cmp rcx, 7
    je calcular7
    cmp rcx, 6
    je calcular6
    cmp rcx, 4
    je calcular4
    cmp rcx, 3
    je calcular3
    cmp rcx, 2
    je calcular2
calcular1:
    inc r12
    dec r14
    add r13, 2
    sub r15, 2
    ret
calcular2:
    inc r12
    add r13, 2
    ret
calcular3:
    inc r12
    inc r14
    add r13, 2
    add r15, 2
    ret
calcular4:
    dec r14
    sub r15, 2
    ret
calcular6:
    inc r14
    add r15, 2
    ret
calcular7:
    dec r12
    dec r14
    sub r13, 2
    sub r15, 2
    ret
calcular8:
    dec r12
    sub r13, 2
    ret
calcular9:
    dec r12
    inc r14
    sub r13, 2
    add r15, 2
    ret
; fila y col se pasan en rcx y rdx respectivamente, deja resultado en rax
; 0 para no existe, 1 para existe
validarSiCeldaExiste:
    mov rax, 0
    cmp rcx, 1
    jl noExiste
    cmp rcx, 7
    jg noExiste
    cmp rdx, 1
    jl noExiste
    cmp rdx, 7
    jg noExiste
    mov rax, 1
   
noExiste:
ret

; toma fila de rcx y col de rdx, asume que son validas, resultado en rax
calcularDesplazamiento:
    dec rcx
    dec rdx ; dec para cambiar fila 1 a fila 0
    mov rax, rcx
    imul rax, 56 ; 7 celdas de 8 bytes de largo
    mov r12, rdx
    imul r12, 8 ; rdx celdas de 8 bytes
    add rax, r12 
    
    inc rcx 
    inc rdx ;restauro valores originales
    
ret

; toma el input del rcx y deja el resultado en el rcx tambien 1 para exito, 0 para fallo en rax
convertirStringAInt:
    mov rdx, numFormat
    mov r8, inputNum
    sub rsp, 32
    call sscanf
    add rsp, 32
    
    mov rcx, qword[inputNum]
    
    ret

; recibe un numero de movimiento (1 a 9) en rcx, lo intenta de ejecutar, deja resultado en rax
; 0 para hubo error, 1 para exitoso sin comer oca, 2 si comio oca
hacerMovimientoZorro:
    call validarMovimientoZorro
    cmp rax, 0
    je movimientoInvalido
ejecutarMovimiento:
    mov rbx, rcx
    mov r8, qword[zorroF]
    mov r9, qword[zorroC]
    
    mov rcx, r8
    mov rdx, r9
    
    call calcularDesplazamiento
    mov qword[tablero+rax], "_"
    
    mov rcx, rbx
    
    call calcularProximaCelda
    mov rcx, r12
    mov rdx, r14
    call calcularDesplazamiento
    
    cmp qword[tablero+rax], "_"
    jne comerOca
    
    mov qword[tablero+rax], "X"
    
    mov qword[zorroF], rcx
    mov qword[zorroC], rdx
   
    mov rax, 1
ret
    
comerOca:
    mov qword[tablero+rax], "_"
    dec byte[totalOcas]

    mov rcx, r13
    mov rdx, r15
    call calcularDesplazamiento
    
    mov qword[tablero+rax], "X"
    
    mov qword[zorroF], rcx
    mov qword[zorroC], rdx
    
    mov rax, 2
    
ret
movimientoInvalido:
    mov rax, 0
ret