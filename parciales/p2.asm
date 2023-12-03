global main
extern puts, gets, sscanf, printf, fopen, fread

section .data
    filePath db "AGRO.DAT", 0 
    mode db "rb",

    fopenErrorMSJ db "No se pudo abrir el archivo", 0


section .bss

    matriz times 300 resb 1 ; 30 * 10

    fileHandle resq 1

    fileData times 0 resb 5
        fila resb 1
        col resb 1
        tipo resb 1
        cant resb 2
    
    registroStatus resb 1
    offset resw 1


Bloques utiles:

; ----> tambien binario, NO es FUNCION, esto se pone en el main (no tiene ret)
openFile:
    mov rcx,filePath
    mov rdx,mode
    sub rsp,32
    call fopen
    add rsp,32

    cmp rax, 0  
    jle errorFileOpen
    
    mov [fileHandle], rax
;

; ---> binario
closeFile:
    mov rcx,qword[fileHandle]
    sub rsp,32
    call fclose 
    add rsp,32
    ret
;

; binario
leerRegistro:
    mov rcx, fileData
    mov rdx, 5       ; ----> largo en bytes del registro
    mov r8, 1        ; ----> Esto es el size de a cuanto leer los 5 de arriba, si el archivo no es binario, sacar
    mov r9, [fileHandle]
    sub rsp,32
    call fread
    add rsp,32

    ret
;

calculateOffset:
    ; [(numfila-1)*longFila] + [(numcol-1)*longElemento]
    ; longfila = longElemento * cantcols
    mov   bx,[fila]
    sub   bx,1
    imul  bx,bx,200 ; bx = row offset; bx = (rowNum-1) * 4bytes * 50colNums
    mov   [offset],bx

    mov   bx,[col]
    dec   bx
    imul  bx,bx,4  ; bx = (colNum-1) * 4bytes

    add   [offset],bx
    ret
;

;comparador por tabla, cambiar el 9/4 de rcx/rbx -----> No tiene ret btw
    mov rcx,0
    mov rbx,0
comparacionPorTabla:
    cmp rcx,9                 ; ---> Cantidad de elementos de la table
    je noCoincidio           ; ---> Se llego a pasar el ultimo de la tabla y no coincidio con ninguno

    push rcx                 ; ----> Guardo el contador de iteracion = nro de elemento de la tabla contra el que estoy comparando
    mov rcx,4                ; ----> cantidad de bytes que mide el objeto de la tabla (lo necesita cmpsb)
    lea rsi,[tabla + rbx] ; ----> mover pointer inicio tabla + desplazamiento (desplazamiento en bytes = largo de un elemento)
    lea rdi,[valor] ; ----> mover pointer inicio valor a comparar
    repe cmpsb             ; funcion que compara [rcx] veces desplazandose 1 byte
    pop rcx                ; recupero lo que guarde en el stack (contador de iteracion)
    je coincidio           ; si el cmp dio igual, coincide, y hacemos break (por eso el pop de recien)

    inc rcx               ; actualizamos iterador para la siguiente
    add rbx,4             ; sumamos 4 = largo del elemento de la tabla 
    jmp comparacionPorTabla
; aca termina el bloque, si encuentra, sale por "coincidio" si no por "noCoincidio" es un bloque cerrado

