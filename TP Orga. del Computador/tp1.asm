 global main
 extern puts
 extern gets
 extern printf
 extern sscanf

section .data
    matrizPrincipal db "A", "B", "C", "D", "E",
                    db "F", "G", "H", "I", "J",
                    db "K", "L", "M", "N", "O",
                    db "P", "Q", "R", "S", "T",
                    db "U", "V", "W", "X", "Y"
    mensaje db "%lli", 0
    contador_indice dq 0
    ingreseTexto db "Ingrese el texto a codificar: ", 0
    vector_indices dq 1, 1, 1, 1
    contador_dos_letras dq 0
    mostrarVectorTextoCompleto db " %lli ", 0
    mensajitoPrueba db "MENSAJITO PRUEBA", 0
    mensajeFunciona db "FUNCIONA 2 veces", 0
    mensajeErrorLetraIngresada db "ah: %lli", 0
    mostrarVECTOR db "posicion vector: %lli", 0
    mostrarRBXmensaje db "RBX: %lli", 0
    mostrarIndice db "Indice nuevo: %lli", 0
    mostrarRAXMSJ db "RAX: %lli", 0
    mostrarLetraEncriptada db "%c", 0
    elegirEncripDesencrip db "Encriptar (1) - Desencriptar (2):", 0
    mostrarOPCION db "%c ", 0
    Encriptar db "1", 0
    Desencriptar db "2", 0
    msjErrorIngresoOpcion db "La opcion ingresada no es correcta, intente de nuevo", 0
	formatoOpcionIng		db	'%li',0	;%i 32 bits / %li 64 bits
    vector dq 1, -1

    msj123 db " %lli ", 0

section .bss
    indicei resq 1
    indicej resq 1
    indiceMatriz resq 1
    texto resb 1
    variableAH resq 1
    errenueve resq 1
    opcionEncripDesencrip resq 1
	opcionFormateada resq	1

section .text

main:

    mov rcx, elegirEncripDesencrip
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, opcionEncripDesencrip
    sub rsp, 32
    call gets
    add rsp, 32
    
    jmp validarOpcion

validarOpcion:
    mov ah, [opcionEncripDesencrip]
    cmp ah, [Encriptar]
    je transformarOpcion
    cmp ah, [Desencriptar]
    je  transformarOpcion
    jmp errorIngresoOpcion

transformarOpcion:
    mov rcx, mostrarOPCION
    mov rdx, [opcionEncripDesencrip]
    sub rsp, 32
    call printf
    add rsp, 32

	mov		rcx, opcionEncripDesencrip		;Parametro 1: campo donde están los datos a leer
	mov		rdx, formatoOpcionIng	;Parametro 2: dir del string que contiene los formatos
	mov		r8, opcionFormateada		;Parametro 3: dir del campo que recibirá el dato formateado
	call	sscanf

	cmp		rax,1			;rax tiene la cantidad de campos que pudo formatear correctamente
	jl		errorIngresoOpcion
    dec qword[opcionFormateada]
    jmp ingresarTexto
    
mostrarr8:
    mov rcx, msj123
    mov rdx, [opcionFormateada]
    sub rsp, 32
    call printf
    add rsp, 32
    jmp main

errorIngresoOpcion:
    mov rcx, msjErrorIngresoOpcion
    sub rsp, 32
    call puts
    add rsp, 32
    jmp main

ingresarTexto:
    mov rsi, 0 ; declaro en 0 el rsi para poder usarlo de índice en el texto ingresado
    mov rcx, ingreseTexto
    sub rsp, 32
    call puts
    add rsp, 32

    mov rcx, texto
    sub rsp, 32
    call gets
    add rsp, 32

    jmp recorrerTexto

recorrerTexto:  ; cont 3 rsi 3

    cmp qword[contador_dos_letras], 2   ;si el contador es igual a 2 lo manda a una función para ver que caso de los 3 hay que aplicar a la codificación
    ;je  recorrerTexto ; -> este je va a ir a la función que va a los 3 casos
    je comprobarSituacion
    cmp qword[texto + rsi], 0
    je  endProgram
    inc qword[contador_dos_letras]
    mov ah, [texto + rsi] ; guardo en ax la letra
    inc rsi
    mov qword[indiceMatriz], 0 ; -> en rax voy a tener el inice para recorrer la matriz

    jmp recorrerMatriz ; -> esto sería recorrerMatriz y de ahí a calcular los índices de la letra en cuestión

;-------------CALCULAR I ---------------- CALCULOS DE ÍNDICES
calcular_i:
    mov rdx, 0
    mov rax, [indiceMatriz]

    mov rcx, 5
    div rcx

    ;mov [indicei], rax
    mov rdx, [contador_indice]

    imul rdx, 8 ;multiplico por 8 para cambiar de posición en el vector
    mov [vector_indices + rdx], rax ; rax es mi indiceI
    mov [indicei], rax
    ; mostrar i


    inc qword[contador_indice]
;-------------CALCULAR I ----------------

;-------------CALCULAR J ----------------
calcular_j:
    mov rbx, [indicei]
    imul rbx, 5
    mov rdx, [indiceMatriz]
    sub rdx, rbx
    mov rax, rdx
    mov rdx, [contador_indice]
    imul rdx, 8 ;multiplico por 8 para cambiar de posición en el vector
    mov [vector_indices + rdx], rax ; utilizo rax para guardar indiceJ

    ; mostrar j


    inc qword[contador_indice]
    jmp recorrerTexto
;-------------CALCULAR J ----------------

recorrerMatriz: ; esto va a buscar a cada letra dentro de la matriz
    mov r8, [indiceMatriz]
    cmp qword[indiceMatriz], 25
    je endProgram
    mov al, [matrizPrincipal + r8] ; matriz posición 0

    cmp al, ah ; comparo valores de la matriz
    je calcular_i
    
    inc qword[indiceMatriz]
    jmp recorrerMatriz

    
aumentarRSIPRUEBA:
;    mov rsi, 0
;contador_es_mas_grande:
;    mov [contador_dos_letras], 0
;    cmp rsi, 4 ; 4 es la longitud 
;    je  recorrerTexto
;    mov rcx, mostrarVectorTextoCompleto
;    mov rbx, [texto + rsi]
;    sub rsp, 32
;    call printf
;    add rsp, 32
;    inc rsi
;    jmp contador_es_mas_grande

    mov rcx, mensajitoPrueba
    sub rsp, 32
    call puts
    add rsp, 32
    jmp recorrerTexto


comprobarSituacion:
    mov rax, 0
    mov qword[contador_dos_letras], 0
    mov qword[contador_indice], 0
    mov rbx, [vector_indices + 16]
    cmp [vector_indices], rbx
    je  mismaFila ; punto dos de las condiciones
    mov rbx, [vector_indices + 8]
    cmp [vector_indices + 24], rbx
    je mismaColumna ; punto tres de las condiciones
    ;jmp recorrerTexto ; punto uno de las condiciones


mismaFila:
    mov rbx, [opcionFormateada]
    imul rbx, 8
    mov rdx, [vector + rbx]
    ;mov rbx, [vector + opcionFormateada]
    add qword[vector_indices + 8], rdx ; columna j
    add qword[vector_indices + 24], rdx ; columna j

    jmp validarIndices

mismaColumna:
    mov rbx, [opcionFormateada]
    imul rbx, 8
    mov rdx, [vector + rbx]
    add qword[vector_indices], rdx ; fila i
    add qword[vector_indices + 16], rdx ; fila i

    mov rax, 0
    jmp validarIndices

validarIndices:
    cmp rax, 5
    je  obtenerLetra
    mov rdx, rax
    imul rdx, 8
    mov rbx, [vector_indices + rdx]
    inc rax
    cmp rbx, 0
    jl cambiarIndice
    cmp rbx, 4
    jle validarIndices

    mov qword[vector_indices + rdx], 0
    jmp validarIndices

cambiarIndice: ; si la opción es Desencriptar y la letra está en el borde izquierdo voy a mover el indice a borde derecho, que es mi letra desencriptada
    mov qword[vector_indices + rdx], 4
    jmp validarIndices

mostrarRAX:
    mov qword[errenueve], rax
    mov rcx, mostrarRAXMSJ
    mov rdx, rax
    sub rsp, 32
    call printf
    add rsp, 32
    ret


obtenerLetra: ; recorre vector_indices que almacena los indices de las letras ya Encriptadas/Desencriptadas 
    ;PRIMERA LETRA
    mov rbx, [vector_indices] ; almaceno la pos 0
    imul rbx, 5 ; la multiplico por 5 (dimensión matriz) para obtener la fila en la que se encuentra la letra
    add rbx, [vector_indices + 8] ; y le sumo la posición j para identificar la letra en el vector (matriz)

    mov rcx, mostrarLetraEncriptada
    mov rdx, [matrizPrincipal + rbx]
    sub rsp, 32
    call printf
    add rsp, 32

    ; SEGUNDA LETRA
    mov rbx, [vector_indices + 16]
    imul rbx, 5
    add rbx, [vector_indices + 24]

    mov rcx, mostrarLetraEncriptada
    mov rdx, [matrizPrincipal + rbx]
    sub rsp, 32
    call printf
    add rsp, 32

    jmp recorrerTexto


endProgram:

    ret