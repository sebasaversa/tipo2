;LINEA 68 CAMBIO LOS OTROS PUNTEROS CREADOS
;LINEA 209 VOY AUMENTANDO EN 1 EL PUNTERO R15
;LINEA 216 CUANDO TERMINA EL FOR2 HAGO LAS RESPECTIVAS SUMAS DE LOS PUNTEROS
;NO LO CAMBIE PERO EN sumarRGB LOS XMM1...5 SE HARIAN CON R15 Y ESTA PUSHEADO ASI QUE NO SE PIERDE EL ORIGINAL
global ldr_asm

section .data
section .rodata


ALIGN 16 
COOO : 		DB 0x00, 0x80, 0x80,  0x80,
			DB 0x01, 0x80, 0x80,  0x80,
			DB 0x02, 0x80, 0x80,  0x80,
			DB 0x80, 0x80, 0x80,  0x80
ALIGN 16 
RGB : 		DB 0x00, 0x04, 0x08,  0x80,
			DB 0x80, 0x80, 0x80,  0x80,
			DB 0x80, 0x80, 0x80,  0x80,
			DB 0x80, 0x80, 0x80,  0x80

ALIGN 16
unByte:		DB 0x00, 0x80, 0x80, 0x80
			DB 0x80, 0x80, 0x80, 0x80,
			DB 0x80, 0x80, 0x80, 0x80,
			DB 0x80, 0x80, 0x80, 0x80

ALIGN 16
ceros:		DB 0x80, 0x80, 0x80, 0x80
			DB 0x80, 0x80, 0x80, 0x80,
			DB 0x80, 0x09, 0x0A, 0x0B,
			DB 0x0C, 0x0D, 0x0E, 0x80
		
section .text
;void ldr_c    (
;    unsigned char *src,     RDI
;    unsigned char *dst,     RSI
;    int cols,               RDX
;    int filas,              RCX
;    int src_row_size,       R8
;    int dst_row_size,       R9
;	int alfa)				 [RSP + X]
;{
;    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
;    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
;	unsigned int max = 5 * 5 * 255 * 3 * 255;

;    for (int i = 0; i < filas; i++){
;        for (int j = 0; j < cols; j++){
;            rgb_t *p_d = (rgb_t*) &dst_matrix[i][j * 3];
;            rgb_t *p_s = (rgb_t*) &src_matrix[i][j * 3];
;            if(i < 2 || j < 2 || i+2 > filas - 1 || j+2 > cols - 1){
;				*p_d = *p_s;}
;			else{		
;				unsigned int red = 0;
;				unsigned int green = 0;
;				unsigned int blue = 0;
;				for( int f = i-2; f  <= (i+2); f++){
;					for( int c = j-2; c <= (j+2); c++){
;						rgb_t *p_p = (rgb_t*) &src_matrix[f][c * 3];
;						red += p_p->r;
;						green += p_p->g;
;						blue += p_p->b;}}
;				//aca termino de sumar todos los colores
;				unsigned int sumargb = red + green + blue; //aca tengo la suma de los 3 colores
;				sumargb *= alfa;
;				p_d->r = MIN(MAX( p_s->r + ((p_s->r * sumargb) / max), 0), 255);
;				p_d->g = MIN(MAX( p_s->g + ((p_s->g * sumargb) / max), 0), 255);
;				p_d->b = MIN(MAX( p_s->b + ((p_s->b * sumargb) / max), 0), 255);}}}}

ldr_asm:

	PUSH RBP					
	MOV RBP, RSP
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	
    ;for (int i = 0; i < filas; i++) {

	LEA RBX, [RDI]
	LEA R15, [RDI]
	LEA R13, [RSI]

	XOR R10, R10	; R10: i
	.for1:
		
		;CONDICION
		;CMP ECX, R10			; ECX: filas
		CMP R10, RCX			; ECX: filas
		JAE .endfor1 
		;CODIGO
		;for (int j = 0; j < cols; j++) {
			XOR R11, R11	;R11: j
			.for2:
				CMP R11, RDX
				JE .endfor2
				
				CMP R10, 1 		;VEO SI ESTOY EN LAS PRIMERAS 2 FILAS
				JBE .copioFila
				; SI NO:
				MOV R12, RCX 
				SUB R12, R10 	;VEO SI ESTOY EN LAS ULTIMAS 2 FILAS
				CMP R12, 2
				JBE .copioFila
				; SI NO:
				CMP R11, 1 		;VEO SI ESTOY EN LAS PRIMERAS 2 COLUMNAS
				JA .else

				.copioIgual:
					MOVDQU XMM0, [RDI]
					MOVDQU [RSI], XMM0
					LEA RDI, [RDI + 6]
					LEA RSI, [RSI + 6]
					ADD R11, 2
					JMP .for2
		
				.copioFila:
					MOVDQU XMM0, [RDI]
					MOVDQU [RSI], XMM0
					LEA RDI, [RDI + 15]
					LEA RSI, [RSI + 15]
					ADD R11, 5				; como agarro 5 pixeles, me corro 5 columnas
					MOV R12, RDX
					SUB R12, R11
					CMP R12, 5
					JA .for2
					
						; HAGO LA CUENTA PARA DEJAR RSI Y RDI DE FORMA DE PROCESAR LOS ULTIMOS 16 BYTES
					PUSH R10
					PUSH RDX
					MOV RAX, RDX
					MOV R10, 3
					MUL R10
					MOV R10, RAX
					LEA RSI, [R13 + R10 - 16]
					LEA RDI, [RBX + R10 - 16]
					POP RDX
					POP R10
					MOVDQU XMM0, [RDI]
					MOVDQU [RSI], XMM0
					JMP .endfor2	

				.else:
					;////////////// PROCESO 1er PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM8, XMM0
					;XMM1 = byte[MIN(MAX(p_s1->r + ((p_s1->r * sumargb) / max),0)), idem gren, idem blue, 0]
					;////////////// PROCESO 2do PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM9, XMM0
					;XMM2 = byte[MIN(MAX(p_s2->r + ((p_s2->r * sumargb) / max),0)), idem gren, idem blue, 0]
					;////////////// PROCESO 3er PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM10, XMM0
					;////////////// PROCESO 4to PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM11, XMM0
					;////////////// PROCESO 5to PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM13, XMM0

					PSLLDQ XMM9, 3					
					PSLLDQ XMM10, 6
					PSLLDQ XMM11, 9
					PSLLDQ XMM13, 12

					POR XMM8, XMM2
					POR XMM8, XMM3
					POR XMM8, XMM4
					POR XMM8, XMM5
					MOVDQU [RSI], XMM8


					ADD R11, 5				; como agarro 5 pixeles, me corro 5 columnas
					MOV R12, RDX
					SUB R12, R11
					CMP R12, 5
					JA .for2

				.finFila:

					; HAGO LA CUENTA PARA DEJAR RSI Y RDI DE FORMA DE PROCESAR LOS ULTIMOS 16 BYTES
					PUSH R10
					PUSH RDX
					MOV RAX, RDX
					MOV R10, 3
					MUL R10
					MOV R10, RAX

					LEA RSI, [R13 + R10 - 16]
					LEA RDI, [RBX + R10 - 16]
					POP RDX
					POP R10
					; PASO LOS ULTIMOS 16 BYTES A XMM0
					MOVDQU XMM0, [RDI]	
					; GUARDO EL PRIMER BYTE PARA RESTAURARLO DESPUES (PORQUE YA LO PROCESE EN LA PASADA ANTERIOR)
					MOVDQU XMM1, [RSI]
					PSHUFB XMM1, [unByte]
					MOVQ R12, XMM1
					; SHIFTEO EL REGISTRO PARA QUE ME QUEDEN LOS 5 PIXELES EN LOS PRIMEROS 15 BYTES DE XMM0
					
					; XMM0: [B|R|G|B|R|G|B|R|G|B|R|G|B|R|G|B]
					PSRLDQ XMM0, 1 
					; XMM0: [R|G|B|R|G|B|R|G|B|R|G|B|R|G|B|0]
					; AHORA QUIERO PROCESAR LOS PRIMEROS 3 PIXELES Y LOS ULTIMOS 2 COPIARLOS IGUALES
					; ENTONCES ME GUARDO LOS ULTIMOS 2 PORQUE AHORA LOS VOY A PISAR
					MOVDQU XMM6, XMM0
					; XMM6: [R|G|B|R|G|B|R|G|B|R|G|B|R|G|B|0]
					PSHUFB XMM6, [ceros]
					; XMM6: [0|0|0|0|0|0|0|0|0|R|G|B|R|G|B|0]
					PSLLDQ XMM6, 1
					; XMM6: [0|0|0|0|0|0|0|0|0|0|R|G|B|R|G|B]
					
					;////////////// PROCESO 1er PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM8, XMM0
					;XMM8 = byte[MIN(MAX(p_s1->r + ((p_s1->r * sumargb) / max),0)), idem gren, idem blue, 0]
					;////////////// PROCESO 2do PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM9, XMM0
					;XMM2 = byte[MIN(MAX(p_s2->r + ((p_s2->r * sumargb) / max),0)), idem gren, idem blue, 0]
					;////////////// PROCESO 3er PIXEL ///////////////
					CALL procesarPixel
					MOVDQU XMM10, XMM0
					
					PSLLDQ XMM8, 1
					PSLLDQ XMM9, 4					
					PSLLDQ XMM10, 7

					XORPD XMM4, XMM4
					MOVQ XMM4, R12

					;JUNTO TODOS LOS REGISTROS
					POR XMM8, XMM9
					POR XMM8, XMM10
					POR XMM8, XMM4
					POR XMM8, XMM6
					MOVDQU [RSI], XMM8

				.endfor2:
					; NO PODES TENER UN PUNTERO EN RAX PORQUE LO USAMOS PARA SUMARGB
					; COPIE Y PEGUE EL QUE USE EN TILES PARA IR ABAJO
					; PONGO LAS COLUMNAS LAS *3 Y LE RESTO EL ROW SIZE
					LEA RDI, [RBX + R8]
					LEA RSI, [R13 + R9]

					INC R10
					;CMP R10, 3
					;JB .for1

					CMP R10, 2
					JB .for1 

					LEA R15, [RDI]

				JMP .for1
		
		.endfor1:
			POP R15
			POP R14
			POP R13
			POP R12
			POP RBP
			RET
 
procesarPixel:
	PUSH RBP
	MOV RBP, RSP

	CALL sumaRGB
	;XMM0 = [sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB] 
	CALL minMax
	;XMM0 = byte[MIN(MAX(p_s->r + ((p_s->r * sumargb) / max),0)), idem gren, idem blue, 0]
	;DEJAR EN XMM0 EL  PIXEL QUE VAMOS A ESCRIBIR
	LEA RSI, [RSI+3]
	LEA RDI, [RDI+3]
	;CMP R11, RDX
	LEA R15, [R15 + 3] ; R15 APUNTA AL PIXEL [-2][-2] PARA ARRANCAR A SUMAR

	POP RBP
	RET

sumaRGB:
	
	PUSH RBP					
	MOV RBP, RSP
	PUSH R14
	PUSH R15

		;RDI : puntero al pixel que estoy mirando
		;R15 ; puntero al pixel que estoy mirando - (2,2)
		MOVDQU XMM1, [R15]
		;XMM1: [R11|G11|B11|R12|G12|B12|R13|G13|B13|R1$|G14|B14|R15|G15|B15|0]
		
		LEA R15, [R15 + R8]
		MOVDQU XMM2, [R15]
		;XMM2: [R21|G21|B21|R22|G22|B22|R23|G23|B23|R24|G24|B24|R25|G25|B25|0]
				
		LEA R15, [R15 + R8]
		MOVDQU XMM3, [R15]
		;XMM3: [R31|G31|B31|R32|G32|B32|R33|G33|B33|R34|G34|B34|R35|G35|B35|0]
				
		LEA R15, [R15 + R8]
		MOVDQU XMM4, [R15]
		;XMM4: [R41|G41|B41|R42|G42|B42|R43|G43|B43|R44|G44|B44|R45|G45|B45|0]
        
		LEA R15, [R15 + R8]      
		MOVDQU XMM5, [R15]       
		;XMM5: [R51|G51|B51|R52|G52|B52|R53|G53|B53|R54|G54|B54|R55|G55|B55|0]
		
		PSLLDQ XMM1, 1
		PSRLDQ XMM1, 1
		PSLLDQ XMM2, 1
		PSRLDQ XMM2, 1
		PSLLDQ XMM3, 1
		PSRLDQ XMM3, 1
		PSLLDQ XMM4, 1
		PSRLDQ XMM4, 1
		PSLLDQ XMM5, 1
		PSRLDQ XMM5, 1
		;CON ESTO ELIMINO EL PIXEL 16 DE TODOS LOS XMM
		
		;///////////////////		SUMO LAS FILAS 1 Y 2 			///////////////////
		CALL sumaFilas	
		MOVDQU XMM7, XMM0
		;///////////////////		SUMO LAS FILAS 3 Y 4 			///////////////////
		MOVDQU XMM1, XMM3
		MOVDQU XMM2, XMM4
		CALL sumaFilas
		PADDW XMM7, XMM0
		;///////////////////		SUMO LAS FILAS 5 Y CEROS		///////////////////
		MOVDQU XMM1, XMM5
		XORPD XMM2, XMM2
		CALL sumaFilas
		PADDW XMM0, XMM7

		
	POP R15
	POP R14
 	POP RBP
	RET

sumaFilas:
	PUSH RBP
	MOV RBP, RSP

		; XMM1: primer fila con 5 pixeles
		; XMM2: segunda fila con 5 pixeles
		;Uso XMM0 para las sumas parciales
		; Agarro la fila 1
		MOVDQU XMM0, XMM1
		;XMM0: [R11|G11|B11|R12|G12|B12|R13|G13|B13|R14 |G14 |B14 |R15 |G15 |B15|0]
		XORPD XMM15, XMM15
		PUNPCKLBW XMM0, XMM15
		PUNPCKHBW XMM1, XMM15
		;XMM0: [R11|0	|G11|0	|B11|0	|R12|0	|G12|0	|B12|0	|R13|0	|G13|0]
		;XMM1: [B13|0	|R14|0	|G14|0	|B14|0	|R15|0	|G15|0	|B15|0	|0|0]
		PADDW XMM0, XMM1
		;XMM0: [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		
		; Agarro la fila 2
		MOVDQU XMM12, XMM2
		;XMM12: [R21|G21|B21|R22|G22|B22|R23|G23|B23|R24|G24|B24|R25|G25|B25|0]
		XORPD XMM15, XMM15
		PUNPCKLBW XMM12, XMM15
		PUNPCKHBW XMM2, XMM15
		;XMM12:  [R21|0	|G21|0	|B21|0	|R22|0	|G22|0	|B22|0	|R23|0	|G23|0]
		;XMM2:  [B23|0	|R24|0	|G24|0	|B24|0	|R25|0	|G25|0	|B25|0	|0  |0]
		PADDW XMM12, XMM2
		;XMM12 : [R21+B23 |G21+R24 |B21+G24 |R22+B24 |G22+R25 |B22+G25 |R23+B25 |G23+0]
		;XMM0:  [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		PHADDW XMM0, XMM12
		;XMM0:  [R11+B13 +G11+R14 	|B11+G14+R12+B14 	|G12+R15+B12+G15 |R13+B15 +G13+0
		;		|R21+B23 +G21+R24 	|B21+G24+R22+B24 	|G22+R25+B22+G25 |R23+B25 +G23+0]
		
		PHADDW XMM0, XMM0
		;XMM0:  [R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	|G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	|G22+R25+B22+G25 +R23+B25 +G23+0		
		
		PHADDW XMM0, XMM0
		;XMM0:	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		
		PHADDW XMM0, XMM0
		;XMM0: 	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		+R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|basura |basura |basura |basura |basura |basura |basura]
		
		; XMM0: [sumargb(deLasFilas1Y2) |basura |basura |basura |basura |basura |basura |basura]

	POP RBP
	RET

minMax:
	PUSH RBP
	MOV RBP, RSP

		MOVDQU XMM5, XMM0		; XMM5 = [sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB|sumaRGB] 
		XORPD XMM14, XMM14
		PUNPCKHWD XMM5, XMM14 	; XMM5 = [sumaRGB |sumaRGB |sumaRGB |sumaRGB] 
		MOVDQU XMM0, [RDI]		; XMM0 = [R|G|B|R |G|B|R|G |B|R|G|B |R|G|B|0]
		PSHUFB XMM0, [COOO] 	; XMM0 = [R|0|0|0 |G|O|O|O |B|O|O|O |O|O|O|O] 
		MOVDQU XMM2, XMM0
		;PARA MULTIPLICAR POR ALFA
		;MOV R12, RDI
		XORPD XMM14, XMM14
		MOV R12, [RSP + 80]
		MOVQ XMM14, R12
		XORPD XMM1, XMM1
		PADDQ XMM1, XMM14
		PSLLDQ XMM1, 4
		PADDQ XMM1, XMM14
		PSLLDQ XMM1, 4
		PADDQ XMM1, XMM14
		PSLLDQ XMM1, 4
		PADDQ XMM1, XMM14
		; XMM0 = [R|0|0|0 	|G|O|O|O 	|B|O|O|O 	|O|O|O|O] 
		; XMM5 = [sumaRGB	|sumaRGB 	|sumaRGB  	|sumaRGB] 
		; XMM1 = [alfa    	|alfa		|alfa		|alfa   ] 
		CVTDQ2PS XMM0, XMM0
		CVTDQ2PS XMM1, XMM1
		CVTDQ2PS XMM5, XMM5
		MULPS XMM1, XMM5 								
		; XMM1 = [alfa*sumaRGB	 |alfa*sumaRGB	 |alfa*sumaRGB	 |alfa*sumaRGB	] 
		MULPS XMM0, XMM1
		; XMM0 = [alfa*sumaRGB*R |alfa*sumaRGB*G |alfa*sumaRGB*B |0	] 

		;ALFA * SUMA * SRC / MAX
		MOV R12, 4876875
		XORPD XMM14, XMM14
		MOVQ XMM14, R12
		XORPD XMM5, XMM5
		PADDQ XMM5, XMM14 
		PSLLDQ XMM5, 4 
		PADDQ XMM5, XMM14
		PSLLDQ XMM5, 4
		PADDQ XMM5, XMM14
		PSLLDQ XMM5, 4
		PADDQ XMM5, XMM14 
		CVTDQ2PS XMM5, XMM5 
		DIVPS XMM0, XMM5
		; XMM0 = [(alfa*sumaRGB*R)/MAX |(alfa*sumaRGB*R)/MAX |(alfa*sumaRGB*R)/MAX |0	] 

		; VAR + SRC
		; XMM2 = [R|0|0|0 |G|O|O|O |B|O|O|O |O|O|O|O] 
		CVTTPS2DQ XMM0, XMM0
		PADDW XMM0, XMM2
		MOVDQU XMM5, XMM0 
		; XMM0 = [((alfa*sumaRGB*R)/MAX)+SRCr |((alfa*sumaRGB*R)/MAX)+SRCg |((alfa*sumaRGB*R)/MAX)+SRCb |0	] 

		XORPD XMM2, XMM2
		PCMPGTD XMM0, XMM2 	;VEO QUIENES SON MAS GRANDES QUE 0
		PAND XMM0, XMM5 	;HAGO AND PARA PONER EN 0 A LOS MENORES A 0
		MOVDQU XMM2, XMM0 
		
		MOV R12, 255
		XORPD XMM14, XMM14
		MOVQ XMM14, R12
		XORPD XMM5, XMM5
		PADDQ XMM5, XMM14 
		PSLLDQ XMM5, 4 
		PADDQ XMM5, XMM14
		PSLLDQ XMM5, 4
		PADDQ XMM5, XMM14
		PSLLDQ XMM5, 4
		PADDQ XMM5, XMM14 
		
		;XMM0 = [MAX(p_s->r + ((p_s->r * sumargb) / max),0), , , ]
		;XMM5 = [255,255,255,255]
		PCMPGTW XMM0, XMM5			; EN LOS QUE SON MAYORES A 255 PONGO 1s, EN LOS OTROS, 0s
		;XMM5 = [255,0,0,255]
		POR XMM0, XMM2
		PSHUFB XMM0, [RGB]
		;sumargb *= alfa;
		;p_d->r = MIN(MAX( p_s->r + ((p_s->r * sumargb) / max), 0), 255);
;				p_d->g = MIN(MAX( p_s->g + ((p_s->g * sumargb) / max), 0), 255);
;				p_d->b = MIN(MAX( p_s->b + ((p_s->b * sumargb) / max), 0), 255);}}}}
		;*p_d = colores[s];}}}	

	POP RBP
	RET