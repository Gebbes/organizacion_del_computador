global main
extern puts, gets, sscanf, printf, fopen, fread

section .data
    filePath db "AGRO.DAT", 0 ; ---> Necesita el  0? SI
    mode db "rb",  ; Leemos binario, es un .DAT

    fopenErrorMSJ db "No se pudo abrir el archivo", 0
    fgetsErrorMSJ db "No se pudo leer un registro del archivo", 0

    filaInforme db 12

    cantTot dw 0
    parcelasSinFert db 1

    msjFinalFung db "La cantidad total recomendada de fungicida en las parcelas F12 es: %hi", 0
    msjFinalParc db "La cantidad de parcelas que no requieren fertilizante es: %hhi", 0



section .bss

    matriz times 2500 resd 1

    fileHandle resq 1

    fileData times 0 resb 5
        fila resb 1
        col resb 1
        tipo resb 1
        cant resb 2
    
    registroStatus resb 1
    offset resw 1

section .text
main:
    mov rcx,filePath
    mov rdx,mode
    sub rsp,32
    call fopen
    add rsp,32

    cmp rax, 0  
    jle errorFileOpen
    
    mov [fileHandle], rax

procesarRegistro:
    call leerRegistro
    
    cmp rax, 0
    jle generarInforme ; ---> Que pasa cuando llega al ultimo registro? salta error? SI ---> revisar grabaciones igual
    
    call VALIDA

    cmp byte[registroStatus], 'N'
    je procesarRegistro

    call actualizarMatriz
    jmp procesarRegistro

generarInforme:
    ; [(numfila-1)*longFila] + [(numcol-1)*longElemento]
    ; longfila = longElemento * cantcols
    mov   bx,[filaInforme]
    sub   bx,1
    imul  bx,bx,200 ; bx = row offset; bx = (rowNum-1) * 4bytes * 50colNums
    mov   [offset],bx

    mov   rsi, [offset] ; base
    mov   rcx, 0 ; suma de bytes
    siguienteCelda:

    cmp word[matriz + rsi + rcx], 0
    jne sumarCelda
    inc byte[parcelasSinFert]

    sumarCelda:
    mov   ax, [matriz + rsi + rcx]
    add   word[cantTot], ax

    add   rcx, 4 ; 4 = bytes a desplazar para llegar al proximo

    cmp rcx, 200 ; 200 = 50 celdas de 4 bytes
    jl siguienteCelda

    mov rcx, msjFinalFung
    mov rdx, [cantTot]
    sub rsp,32
    call printf
    add rsp,32

    mov rcx, msjFinalParc
    mov rdx, [parcelasSinFert]
    sub rsp,32
    call printf
    add rsp,32

    call closeFile
    
    ret

actualizarMatriz:
    call calculateOffset
    mov rsi, [offset]
    mov ax, [cant]
    add word[matriz + rsi], ax
    ret

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
    cmp   byte[tipo], 'U'
    je return
    add word[offset], 2 ; bytes extra para identificar la segunda celda, la de fungicida

return:
ret

leerRegistro:
    mov rcx, fileData
    mov rdx, 5
    mov r8, 1        ; ----> Esto es el size de a cuanto leer los 5 de arriba, si el archivo no es binario, sacar
    mov r9, [fileHandle]
    sub rsp,32
    call fread
    add rsp,32

    ret

VALIDA:
    cmp byte[fila] , 50  ; ----> Puedo comparar directo por que se levanto con fread desde binario ? SI
    jg registroInvalido

    cmp byte[fila], 1  ; ----> Puedo comparar directo por que se levanto con fread desde binario ? SI
    jl registroInvalido

    cmp byte[col], 50  ; ----> Puedo comparar directo por que se levanto con fread desde binario ?SI
    jg registroInvalido

    cmp byte[col], 1  ; ----> Puedo comparar directo por que se levanto con fread desde binario ? SI
    jl registroInvalido

    cmp byte[tipo], 'U'
    je compararLitros
    cmp byte[tipo], 'F'
    jne registroInvalido
compararLitros:
    cmp word[cant], 0
    jl procesarRegistro
    mov byte[registroStatus], 'S'
    ret

registroInvalido:
    mov byte[registroStatus], 'N'
    ret
errorFileOpen:
    mov rcx, fopenErrorMSJ
    sub rsp,32
    call puts
    add rsp,32
    jmp endOfProgram

endOfProgram:
ret

closeFile:
    mov   rcx,[fileHandle]
    sub   rsp,32
    call  fclose
    add   rsp,32
ret
