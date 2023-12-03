global main
extern puts, gets, sscanf, printf

; Tomo como validos el rango de años -4999 a 4999 ( -MMMCMXCIX to MMMCMXCIX) (solo por limitacion de las letras romanas)
; Tambien tomo como validas solo letras en mayuscula, para evitar dobles chequeos
; no quedo hecho el caso de los años biciestos, lo pense en el dia de la entrega y no queria comprometer la entrega
; con una sucesion de div sobre el año, y mirar si el resto es 0, se podria haber usado para calcular la cantidad de dias
; de febrero 28/29 y de los años julianos 365/366

; Aclaraciones sobre formato Juliano, viendo el enunciado, surgio la duda de como reducir un año de 4 cifras a uno de dos, y mismo
; cuales son las 2 que se mantenian (el ejemplo era 2020 ---> 20) haciendo esta busqueda:
; https://www.google.com/search?q=formato+juliano&rlz=1C1CHBF_esAR925AR925&oq=formato+&gs_lcrp=EgZjaHJvbWUqDggBEEUYJxg7GIAEGIoFMgYIABBFGDkyDggBEEUYJxg7GIAEGIoFMgoIAhAAGLEDGIAEMgcIAxAAGIAEMgoIBBAAGLEDGIAEMgoIBRAAGLEDGIAEMgcIBhAAGIAEMgcIBxAAGIAEMgcICBAAGIAEMgcICRAAGIAE0gEIMzAxOWowajeoAgCwAgA&sourceid=chrome&ie=UTF-8
; aparecia como definicion:
; "A veces se usa una fecha juliana para hacer referencia a un formato de fecha que es una combinación del año actual y el número de días desde el principio del año. 
; Por ejemplo, el 1 de enero de 2007 se representa como 2007001 y el 31 de diciembre de 2007 se representa como 2007365."
; a esto, supuse que era un error de tipado en el enunciado, dado que tambien, tener solo 2 cifras para representar 4, hace que fechas tengan varios significados
; A razon de que consultando con compañeros los ultimos dias, varios teniamos esa duda, pero en el foro no encontramos una respuesta, mantuve mi calculo.
; si el año fuese los dos ultimos digitos, dividiria el año original por 100 con div, y me quedaria con el resto.

section .data

    msjIngFecha db "Ingrese una fecha ( N para detener el programa ) : ", 0
    formatos db "Formatos :",10,"Gregoriano = G", 10,"Juliano = J", 10, "Romano = R", 10, 0
    ingFromatoDestino db "Ingrese el formato de destino ( G/J/R ): ", 0

    ; formats
    formatoGreg db "%d/%d/%d",10, 0
    formatoJul db "%d/%d",10, 0
    formatoRom db "%s/%s/%s",10, 0

    msjG db "Numero en formato Gregoriano: %d/%d/%d",10,0
    msjJ db "Numero en formato Juliano: %d/%d",10,0
    msjR db "Numero en formato Romano: %s/%s/%s", 10,0

    msjValid db "El formato ingresado es VALIDO", 0

    AC db " AC", 0
    romanChars db "MDCLXVI"
    additiveRomanValues dq 1000
                        dq 500
                        dq 100
                        dq 50
                        dq 10
                        dq 5
                        dq 1
    
    additiveChars db "MDLV" ; this ones are additive only
    additiveValuesOnly dq 1000
                   dq 500
                   dq 50
                   dq 5
    
    allRomanValues  dq 1000
                    dq 900
                    dq 500
                    dq 400
                    dq 100
                    dq 90
                    dq 50
                    dq 40
                    dq 10
                    dq 9
                    dq 5
                    dq 4
                    dq 1

    allRomanChars   db "M ","CM","D ","CD","C ","XC","L ","XL","X ","IX","V ","IV","I ",0
;

    vectordias      dd  31
                    dd  28
                    dd  31
                    dd  30
                    dd  31
                    dd  30
                    dd  31
                    dd  31
                    dd  30
                    dd  31
                    dd  30
                    dd  31
;    
    ; errors
    errUknownDateFormat db "Error: formato ingresado no coincide con ninguno de los esperados.", 10, 0
    formatoDestioError db "Error: formato de destino invalido.", 10, 0
    valueError db "Error: los valores de las fechas son invalidos.", 10, 0



section .bss
    inputDate resb 50
    inputFormat resb 50

    isValid resb 1
    
    gDia resq 1
    gMes resq 1
    gAnio resq 1
    maxDaysG resd 1

    jDia resq 1
    jAnio resq 1

    rDia resb 20
    rMes resb 20
    rAnio resb 20
    sumBlock resq 1
    valueToAdd resq 1
    auxDate resb 20
    usedBytes resb 20
    yearIsNegative resb 1
    
    leftUsesByChar resb 7
    usedToSubByChar resb 7
    
    lowest resq 1
    actualBlock resb 1

    actualChar resb 1
    barAmount resd 1

    dirNextBlock resq 1

section .text
main:
    mov rbp, rsp; for correct debugging
    mov rcx, formatos
    sub rsp, 32
    call puts
    add rsp, 32

ingFecha:
    mov rbp, rsp; for correct debugging
    mov rcx, msjIngFecha
    sub rsp, 32
    call puts
    add rsp, 32
    
    mov rcx, inputDate
    sub rsp, 32
    call gets
    add rsp, 32

    cmp byte[inputDate], 'N'
    je endOfProgram

    mov rbp, rsp; for correct debugging
    mov rcx, ingFromatoDestino
    sub rsp, 32
    call puts
    add rsp, 32
    
    mov rcx, inputFormat
    sub rsp, 32
    call gets
    add rsp, 32

scaninputDate:
    mov rcx, inputDate
    mov rdx, formatoGreg
    mov r8, gDia
    mov r9, gMes
    mov r10, gAnio
    push r10
    sub rsp, 32
    call sscanf
    add rsp, 32
    pop r10

    cmp rax, 3
    je isGregorian

    mov rcx, inputDate
    mov rdx, formatoJul
    mov r8, jDia
    mov r9, jAnio
    sub rsp, 32
    call sscanf
    add rsp, 32
    
    cmp rax, 2
    je isJulian

    call validateRoman
    cmp byte[isValid], 'Y'
    jne errUknownDate

    jmp isRoman

;/////////////////////////////////////      GREGORIAN FUNCS      /////////////////////////////////////

isGregorian:
    mov ecx, 2
    call validateNumericDate
    cmp byte[isValid], 'Y'
    jne errDateValues  
    

    call validateGregorian
    cmp byte[isValid], 'Y'
    jne errDateValues  

    cmp byte[inputFormat], 'J'
    je convertGregorianToJulian

    cmp byte[inputFormat], 'R'
    je convertGregorianToRoman

    jmp errFormatDest

convertGregorianToJulian:
    mov eax,[gAnio]
    mov dword[jAnio],eax

    sub eax, eax
    mov ecx, [gMes]
    dec ecx

sumDays:

    cmp ecx, 0
    jle endLoop

    mov dword[gMes], ecx
    call calculateMaxDaysG

    add eax, dword[maxDaysG]

    dec ecx
    jmp sumDays

endLoop:
    add eax, [gDia]
    mov dword[jDia], eax

    
    mov rcx, msjJ
    mov rdx, [jDia] 
    mov r8, [jAnio]
    sub rsp, 32
    call printf
    add rsp, 32

    jmp ingFecha

convertGregorianToRoman:
    call configYearRomanFormat

    mov byte[actualBlock], 0
    mov rcx, 0
    mov rax, qword[gDia]
    mov qword[sumBlock], rax
    
    lea rdi, [rDia]
    mov qword[dirNextBlock], rdi
    mov qword[usedBytes], 0

substractNextValue:
    cmp qword[sumBlock], 0
    je changeBlockRoman
    
    mov r8, qword[allRomanValues + 8 * rcx]
    cmp qword[sumBlock], r8
    jl setNextSub

    sub qword[sumBlock], r8
    call addRomanLetter
    jmp substractNextValue

setNextSub:
    inc rcx
    jmp substractNextValue

changeBlockRoman:
    mov r10, rcx
    
    cmp byte[actualBlock], 0
    je setRomanDay
    cmp byte[actualBlock], 1
    je setRomanMonth
    
    lea rdi, [rAnio]
    jmp copyChar

setRomanDay:
    mov rax, qword[gMes]
    mov qword[sumBlock],rax
    lea rdi, [rDia]
    jmp copyChar
setRomanMonth:
    mov rax, qword[gAnio]
    mov qword[sumBlock], rax
    lea rdi, [rMes]
    jmp copyChar

copyChar:
    mov rcx, qword[usedBytes]
    lea rsi, [auxDate]
    rep movsb

    mov rcx, r10 ; deberia reemplazar por push/pop

    cmp byte[actualBlock], 2
    je endBlock
    
    mov qword[usedBytes], 0
    inc byte[actualBlock]
    mov rcx, 0
    call restoreAux
    jmp substractNextValue

addRomanLetter:
    push rcx        ; indice principal
    
    mov rbx, rcx
    imul rbx, 2
    inc rbx
    cmp byte[allRomanChars + rbx], " "
    jne addCmpoundLetter
    mov rcx, 1
    jmp copyArray
addCmpoundLetter:    
    mov rcx, 2
copyArray:
    push rcx            ; movsb nos va a bajar a 0 este rcx que necesitamos sumar a bytes usados al final
    dec rbx
    lea rsi, [allRomanChars + rbx ]
    mov rbx, qword[usedBytes]
    lea rdi, [auxDate + rbx]
        
    rep movsb

    pop rcx              ; recupero cantidad de bytes sumados en esta llamada
    add qword[usedBytes], rcx
    pop rcx        ; recupero el indice general
    
ret
endBlock:
    cmp byte[yearIsNegative], 'Y'
    jne printRomanDate
    call addACToYear

printRomanDate:
    mov rcx, msjR
    mov rdx, rDia
    mov r8, rMes
    mov r9, rAnio
    sub rsp, 32
    call printf
    add rsp, 32
    jmp ingFecha

configYearRomanFormat:
    mov byte[yearIsNegative], 'N'
    cmp dword[gAnio], 0
    jge retunYearConfig 
    mov byte[yearIsNegative], 'Y'
    neg dword[gAnio]

retunYearConfig:
    ret
addACToYear:
   mov rbx, qword[usedBytes]
   mov rcx, 3
   lea rsi, [AC]
   lea rdi, [rAnio + rbx]
   rep movsb 
ret

;/////////////////////////////////////      JULIAN FUNCS      /////////////////////////////////////

isJulian:
    mov ecx, 1
    call validateNumericDate
    cmp byte[isValid], 'Y'
    jne errDateValues

    call validateJulian
    cmp byte[isValid], 'Y'
    jne errDateValues  

    cmp byte[inputFormat], 'G'
    je convertJulianToGregorian

    jmp errFormatDest

convertJulianToGregorian:
    mov ecx, 1 ; contador meses
    mov edx, [jDia]
    mov ebx, 0

addPreviousMonths:
    mov r8d, dword[vectordias + ebx]

    cmp edx, dword[vectordias + ebx]
    jle addCurrentDays
    sub edx, dword[vectordias + ebx]

    add ebx, 4
    inc ecx

    jmp addPreviousMonths

addCurrentDays:
    mov dword[gDia], edx
    mov dword[gMes], ecx
    
    mov eax, dword[jAnio]
    mov dword[gAnio], eax

    mov rcx, msjG
    mov rdx, [gDia] 
    mov r8, [gMes]
    mov r9, [gAnio]
    sub rsp, 32
    call printf
    add rsp, 32

    jmp ingFecha

;/////////////////////////////////////      ROMAN FUNCS      /////////////////////////////////////

isRoman:
    cmp byte[inputFormat], 'G'
    jne errFormatDest

    call convertRomanToGregorian

    call validateGregorian
    cmp byte[isValid], 'Y'
    jne errDateValues
    
    jmp ingFecha

convertRomanToGregorian:

    mov qword[sumBlock], 0 ; sum
    mov ecx, 0 ; index
    mov byte[actualBlock], 0 ; 0 = day, 1 = month, 2 = year

scanNextChar:
    cmp byte[inputDate + ecx], 0
    je formatDate

    cmp byte[inputDate + ecx], '/'
    je changeBlock
   
    mov ebx, 0  ; table comparison index

compareToAdditiveChars:
    cmp ebx,4                 ; ---> Cantidad de elementos de la table
    je addSubstractive           ; ---> Se llego a pasar el ultimo de la tabla y no coincidio con ninguno

    mov dl, [additiveChars + ebx]
    cmp byte[inputDate + ecx], dl
    je addAdditive           ; si el cmp dio igual, coincide, y hacemos break
    
    inc ebx               ; actualizamos iterador para la siguiente
    jmp compareToAdditiveChars


addAdditive:
    mov r9 ,[additiveValuesOnly + 8 * ebx]
    mov qword[valueToAdd], r9   ;unnecesary but more readable
    inc ecx

addValue:
    mov r9, qword[valueToAdd]
    add qword[sumBlock], r9
    mov ebx, 0
    jmp scanNextChar
changeBlock:
    cmp byte[actualBlock], 1
    je saveMonth

saveDays:
    mov r8, qword[sumBlock] ; given that we already check  amountOfBars = 2 there is only 2 options
    mov qword[gDia], r8
    jmp setNext
saveMonth:
    mov r8, qword[sumBlock]
    mov qword[gMes], r8
    inc ecx
    cmp byte[inputDate + ecx], '-'
    je setNext
    dec ecx
    jmp setNext
setNext:
    mov qword[sumBlock], 0
    inc byte[actualBlock]
    inc ecx
    jmp scanNextChar

addSubstractive:
    mov qword[valueToAdd], 900
    cmp word[inputDate + ecx ], 'CM'
    je setCallToAddDouble
    mov qword[valueToAdd], 400
    cmp word[inputDate + ecx ], 'CD'
    je setCallToAddDouble
    mov qword[valueToAdd], 90
    cmp word[inputDate + ecx ], 'XC'
    je setCallToAddDouble
    mov qword[valueToAdd], 40
    cmp word[inputDate + ecx ], 'XL'
    je setCallToAddDouble
    mov qword[valueToAdd], 9
    cmp word[inputDate + ecx ], 'IX'
    je setCallToAddDouble
    mov qword[valueToAdd], 4
    cmp word[inputDate + ecx ], 'IV'
    je setCallToAddDouble
    mov qword[valueToAdd], 100
    cmp byte[inputDate + ecx], 'C'
    je setCallToAddSingle
    mov qword[valueToAdd], 10
    cmp byte[inputDate + ecx], 'X'
    je setCallToAddSingle
    mov qword[valueToAdd], 1
    jmp setCallToAddSingle ;case char = I

setCallToAddDouble:
    inc ecx
setCallToAddSingle:
    inc ecx
    jmp addValue

formatDate:

    mov r8, qword[sumBlock] ;saving year
    mov qword[gAnio], r8

    cmp byte[yearIsNegative], 'Y'
    jne retRoman
    neg qword[gAnio]

retRoman:
    mov rcx, msjG
    mov rdx, [gDia] 
    mov r8, [gMes]
    mov r9, [gAnio]
    sub rsp, 32
    call printf
    add rsp, 32
    
ret

setLogicFlags:
    mov r10d, 0
setUsesAmount:
    cmp r10d, 7
    je endFlagSetting
    
    cmp r10d, 1
    je setUsesTo1
    cmp r10d, 3
    je setUsesTo1
    cmp r10d, 5
    je setUsesTo1

    mov byte[leftUsesByChar + r10d], 3
    
    cmp r10d, 0
    jne setUsesToSub
    
    inc r10d
    jmp setUsesAmount
    
setUsesToSub:
    mov byte[usedToSubByChar + r10d], 'N' ; for C X I we set posible uses for substractive compound numbers
    inc r10d
    jmp setUsesAmount
    
setUsesTo1: 
    mov byte[leftUsesByChar+ r10d], 1
    inc r10d
    jmp setUsesAmount
endFlagSetting:   
ret

;/////////////////////////////////////      VALIDATIONS      /////////////////////////////////////
validateJulian:
    mov byte[isValid], 'Y'
    
    cmp dword[jDia], 1
    jl isInvalidJulian

    cmp dword[jDia], 365 ; Se podria calcular si es 365 o 366 dependiendo de si es biciesto
    jg isInvalidJulian

    cmp dword[jAnio], -4999
    jl isInvalidJulian

    cmp dword[jAnio], 4999
    jg isInvalidJulian

    ret
isInvalidJulian:
    mov byte[isValid], 'N'
    ret
validateGregorian:
    mov byte[isValid], 'Y'

    cmp dword[gMes], 1
    jl isInvalidGregorian

    cmp dword[gMes], 12
    jg isInvalidGregorian

    cmp dword[gDia], 1
    jl isInvalidGregorian

    call calculateMaxDaysG  ; validamos primero los meses para poder usar el dato de mes en esta funcion
    mov eax, dword[maxDaysG]

    cmp dword[gDia], eax ; varia entre 28, 29, 30 y 31
    jg isInvalidGregorian

    cmp dword[gAnio], -4999
    jl isInvalidGregorian

    cmp dword[gAnio], 4999
    jg isInvalidGregorian

    ret
isInvalidGregorian:
    mov byte[isValid], 'N'
    ret
validateNumericDate:
    mov dword[barAmount], ecx
    push rax
    push rbx
    mov ecx, 0
    mov ebx, 0
validateNextChar:
    mov al, byte[inputDate + ecx]
    mov byte[actualChar], al
    inc ecx

    cmp byte[actualChar], 0
    je endFisicalValidation

    cmp byte[actualChar], '/'
    je addBar

    cmp byte[actualChar], '-'
    je dateHasNegativeSign

    cmp byte[actualChar], '0'
    jl numericDateInvalid

    cmp byte[actualChar], '9'
    jg numericDateInvalid

    jmp validateNextChar

addBar:
    dec dword[barAmount]
    cmp dword[barAmount], 0
    jl numericDateInvalid 
    jmp validateNextChar
dateHasNegativeSign:
    cmp ebx, 0
    jg numericDateInvalid
    inc ecx
    mov al, byte[inputDate + ecx]
    cmp al, 0
    je numericDateInvalid
    dec ecx
    inc ebx
    jmp validateNextChar
numericDateInvalid:
    mov byte[isValid], 'N'
    pop rax
    pop rbx
    ret
endFisicalValidation:
    mov byte[isValid], 'Y'
    pop rax
    pop rbx
ret
;
validateRoman:
    mov byte[isValid], 'Y'

    call setLogicFlags

setRegisters:
    mov ecx, 0
    mov eax, 0 ; amount of /
    mov ebx, 0 ; counter for roman chars
    mov qword[lowest], 1000 ; lowest value used

scanInputChar:

    cmp byte[inputDate + ecx], 0
    je endScan

    cmp byte[inputDate + ecx], '/'
    je addSideBar

compareToArrayChar:
    cmp ebx,7                 ; ---> Cantidad de elementos de la table
    je didntMatch           ; ---> Se llego a pasar el ultimo de la tabla y no coincidio con ninguno

    mov dl, [romanChars + ebx]
    cmp byte[inputDate + ecx], dl
    je match           ; si el cmp dio igual, coincide, y hacemos break
    
    inc ebx               ; actualizamos iterador para la siguiente
    jmp compareToArrayChar

match:
    cmp byte[leftUsesByChar + ebx], 0
    je failedLogicValidation
    dec byte[leftUsesByChar + ebx]

    ; revisamos si es una suma compuesta / resta
    mov qword[valueToAdd], 900
    cmp word[inputDate + ecx ], 'CM'
    je validateSubs
    mov qword[valueToAdd], 400
    cmp word[inputDate + ecx ], 'CD'
    je validateSubs
    mov qword[valueToAdd], 90
    cmp word[inputDate + ecx ], 'XC'
    je validateSubs
    mov qword[valueToAdd], 40
    cmp word[inputDate + ecx ], 'XL'
    je validateSubs
    mov qword[valueToAdd], 9
    cmp word[inputDate + ecx ], 'IX'
    je validateSubs
    mov qword[valueToAdd], 4
    cmp word[inputDate + ecx ], 'IV'
    je validateSubs

    jmp isAddition
    
validateSubs:
    push rcx
    mov rcx, qword[valueToAdd]
    cmp qword[lowest], rcx
    jl invalidSubs ; chars were not order from biggest to lowest value
    mov qword[lowest], rcx
    pop rcx

    cmp byte[leftUsesByChar + ebx], 2
    jne failedLogicValidation ; char used for both substracting and adding
    cmp byte[usedToSubByChar + ebx], 'N'
    jne failedLogicValidation ; used more than one time for substracting
    mov ebx, 0
    add ecx, 2
    jmp scanInputChar
invalidSubs:
    pop rcx
    jmp failedLogicValidation

isAddition:
    mov r10, qword[lowest]
    cmp qword[additiveRomanValues + ebx * 8], r10
    jg failedLogicValidation ; chars were not order from biggest to lowest value
    mov r10, qword[additiveRomanValues + ebx * 8]
    mov qword[lowest], r10
    mov ebx, 0
    inc ecx
    jmp scanInputChar

addSideBar:
    call setLogicFlags
    inc eax
    inc ecx
    mov dword[barAmount], eax
    mov qword[lowest], 1000 ; lowest value used

    cmp dword[barAmount], 2
    jne scanInputChar

    cmp byte[inputDate + ecx ], '-'
    jne goToNext
    mov byte[yearIsNegative], 'Y'
    inc rcx

goToNext:
    jmp scanInputChar

endScan:
    cmp eax, 2
    jne didntMatch

    ret
didntMatch:
failedLogicValidation:
    mov byte[isValid], 'N'
    ret
;
;/////////////////////////////////////      ERRORS      /////////////////////////////////////
errUknownDate:
    mov rcx, errUknownDateFormat
    sub rsp, 32
    call printf
    add rsp, 32
    jmp ingFecha

errFormatDest:
    mov rcx, formatoDestioError
    sub rsp, 32
    call puts
    add rsp, 32
    jmp ingFecha

errDateValues:
    mov rcx, valueError
    sub rsp, 32
    call puts
    add rsp, 32
    jmp ingFecha

;/////////////////////////////////////      MISC      /////////////////////////////////////

calculateMaxDaysG:

    mov   ebx,[gMes]
    dec   ebx
    imul  ebx,ebx,4  ; bx = (colNum-1) * 4bytes

    mov edx, dword[vectordias + ebx] 
    mov dword[maxDaysG], edx

    ret
restoreAux:
    push rcx
    mov rcx, 20
restoreByte:
    dec rcx ; necesitamos que aplique cuando rcx = 0
    mov byte[auxDate + rcx], 0
    inc rcx 
        loop restoreByte
    pop rcx
ret
endOfProgram:
ret
