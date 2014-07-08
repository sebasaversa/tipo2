global temperature_asm

section .data
section .rodata

; PROCESAMOS DE A 5 PIXELES

ALIGN 16 
pixel0BGR :				DB 0x00, 0x80, 0x01,  0x80, ; [ 0 , - , 1 , - 
						DB 0x02, 0x80, 0x80,  0x80, ;   2 , - , - , -
						DB 0x03, 0x80, 0x04,  0x80, ;   3 , - , 4 , -
						DB 0x05, 0x80, 0x80,  0x80  ;   5 , - , - , - ]
ALIGN 16
soloPrimero : 			DB  0x00, 0x80, 0x80, 0x80, ; [ 0 , - , - , -
						DB  0x80, 0x80, 0x80, 0x80, ;   - , - , - , -
						DB  0x08, 0x80, 0x80, 0x80, ;   8 , - , - , -
						DB  0x80, 0x80, 0x80, 0x80  ;   - , - , - , - ]
ALIGN 16		
invertir: 				DB  0x09, 0x0A, 0x0B, 0x0C,	; [ 9 , 10 , 11 , 12 , 13 , 14
						DB  0x0D, 0x0E, 0x03, 0x04,	;   3 , 4 , 5 , 6 , 7 , 8 
						DB  0x05, 0x06, 0x07, 0x08,	;   0 , 1 , 2 , - ]
						DB  0x00, 0x01, 0x02, 0x80
ALIGN 16
moverPixeles: 			DB  0x06, 0x07, 0x08, 0x09, ; [ 6 , 7 , 8 , 9
						DB  0x0A, 0x0B, 0x0C, 0x0D, ;   10, 11, 12, 13
						DB  0x0E, 0x0F, 0x80, 0x80, ;   14, 15, - , -
						DB  0x80, 0x80, 0x80, 0x80  ;   - , - , - , - ]
ALIGN 16
moverPixeles1: 			DB  0x06, 0x07, 0x08, 0x80, ; [ 6 , 7 , 8 , -
						DB  0x80, 0x80, 0x80, 0x80, ;   - , - , - , -
						DB  0x80, 0x80, 0x80, 0x80, ;   - , - , - , -
						DB  0x80, 0x80, 0x80, 0x80  ;   - , - , - , - ]
ALIGN 16			
moverPixeles2:			DB  0x80, 0x80, 0x80, 0x80, ; [ - , - , - , -
						DB  0x80, 0x80, 0x80, 0x80, ;   - , - , - , -
						DB  0x80, 0x00, 0x01, 0x02, ;   - , 0 , 1 , 2
						DB  0x03, 0x04, 0x05, 0x80  ;   3 , 4 , 5 , - ]
ALIGN 16			
moverPixeles3:			DB  0x80, 0x80, 0x80, 0x00, ; [ - , - , - , 0
						DB  0x01, 0x02, 0x03, 0x04, ;   1 , 2 , 3 , 4
						DB  0x05, 0x80, 0x80, 0x80, ;   5 , - , - , -
						DB  0x80, 0x80, 0x80, 0x80  ;   - , - , - , - ]
ALIGN 16
shuffleCaverna2:		DB  0x00, 0x01, 0x02, 0x03, ; [ 0 , 1 , 2 , 3
						DB  0x08, 0x09, 0x0A, 0x0B, ;   8 , 9 , 10, 11
						DB  0x80, 0x80, 0x80, 0x80, ;   - , - , - , -
						DB  0x80, 0x80, 0x80, 0x80  ;   - , - , - , - ]
ALIGN 16		
unPixel :				DB 0x00, 0x01, 0x02, 0x80,  ; [ 0 , 1 , 2 , -
						DB 0x80, 0x80, 0x80, 0x80,  ;   - , - , - , -
						DB 0x80, 0x80, 0x80, 0x80,  ;   - , - , - , -
						DB 0x80, 0x80, 0x80, 0x80   ;   - , - , - , - ]
ALIGN 16		
pixelFinal :			DB 0x00, 0x01, 0x02, 0x04,  ; [ 0 , 1 , 2 , 4
						DB 0x05, 0x06, 0x80, 0x80,  ;   5 , 6 , - , -
						DB 0x80, 0x80, 0x80, 0x80,  ;   - , - , - , -
						DB 0x80, 0x80, 0x80, 0x80   ;   - , - , - , -]
ALIGN 16
unByte:					DB 0X00, 0x80, 0x80, 0x80   ; [ 0 , - , - , -
						DB 0x80, 0x80, 0x80, 0x80,  ;   - , - , - , -
						DB 0x80, 0x80, 0x80, 0x80,  ;   - , - , - , -
						DB 0x80, 0x80, 0x80, 0x80   ;   - , - , - , - ]
ALIGN 16 
dosDosCuatro: 			DQ 0xE1, 0xE1							; 225, 225, 225, 225			
ALIGN 16 
unoSeisCero: 			DQ 0xA1, 0xA1							; 161, 161, 161, 161 	
ALIGN 16 
nueveSeis: 				DQ 0x61, 0x61							; 97, 97, 97, 97, 	
ALIGN 16 
tresDos: 				DQ 0x21, 0x21							; 33, 33, 33, 33, 

ALIGN 16
colores0: 				DW  0x80, 0x0,  0x0, 0x0,				; 128( + 4T),   0			, 0	 			,   0
						DW  0x80, 0x0,  0x0, 0x0,				; 128( + 4T),   0			, 0				,   0
ALIGN 16	
colores1: 				DW  0xFF, 0x0, 0x0, 0x0,				; 255		,   (4T-128)	, 0				,   0	
						DW  0xFF, 0x0, 0x0, 0x0,				; 255		,   (4T-128)	, 0				,   0
ALIGN 16	
colores2: 				DW  0x27F, 0xFF, 0x0, 0x0,				; 639 (- 4T),   255			, (4T - 384)	,   0
						DW  0x27F, 0xFF, 0x0, 0x0,				; 639 (- 4T),   255			, (4T - 384)	,   0
ALIGN 16	
colores3: 				DW 	0x0, 0x37F, 0xFF, 0x0,				; 0			,   895 (- 4T)  , 255			,   0
						DW 	0x0, 0x37F, 0xFF, 0x0,				; 0			,   895 (- 4T)  , 255			,   0
ALIGN 16	
colores4: 				DW  0x0, 0X0, 0x47F, 0x0,				; 0			,	0			, 1151 (- 4T)	,   0
						DW  0x0, 0X0, 0x47F, 0x0				; 0			,	0			, 1151 (- 4T)	,   0


section .text

;void temperature_c    (
;	unsigned char *src,		RDI
;	unsigned char *dst,     RSI
;	int cols,               RDX
;	int filas,              RCX
;	int src_row_size,       R8
;	int dst_row_size){      R9
;		
;	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
;	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
;
;	for (int i = 0; i < filas; i++){
;		for (int j = 0; j < cols; j++){
;			rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
;			rgb_t *p_s = (rgb_t*)&src_matrix[i][j*3];
;			temperatura(p_d, p_s->r, p_s->g, p_s->b);}}}

temperature_asm:

	PUSH RBP					
	MOV RBP, RSP
	PUSH R12
	PUSH R13
	PUSH R14
	PUSH R15
	PUSH RBX
	SUB RSP, 8

    ;for (int i = 0; i < filas; i++) {
	MOV RAX, RDI
	MOV RBX, RSI
	XOR R14, R14	; R10: i
	.for1:

		;CONDICION
		;CMP ECX, R10			; ECX: filas
		CMP R14, RCX			; ECX: filas
		JAE .endfor1 
		;CODIGO
		;for (int j = 0; j < cols; j++) {
			XOR R15, R15	;R11: j
			.for2:
				;CONDICION
				;CMP EDX, R11	; EDX: cols
				CMP R15, RDX	; EDX: cols
				JAE .endfor2 
				;CODIGO
				;rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
				;rgb_t *p_s = (rgb_t2*)&src_matrix[i][j*3];
				;int s = pop_art(p_s->r, p_s->g, p_s->b);
				MOVDQU XMM0, [RDI]	
				CALL tempe		; XMM0: 5 pixeles que van en dst*
				;*p_d = colores[s];}}}					
				MOVDQU [RSI], XMM0
				LEA RSI, [RSI+15]
				LEA RDI, [RDI+15]

				;AUMENTAR Y SEGUIR
				ADD R15, 5				; como agarro 5 pixeles, me corro 5 columnas
				MOV R12, RDX
				SUB R12, R15
				CMP R12, 5
				JA .for2
				
				.finFila:
					; RESGUARDO RAX Y RDX
					MOV R13, RAX
					MOV R11, RDX
					; HAGO LA CUENTA PARA DEJAR RSI Y RDI DE FORMA DE PROCESAR LOS ULTIMOS 16 BYTES
					MOV RAX, RDX
					MOV R10, 3
					MUL R10
					MOV R10, RAX
					; RESTAURO RAX Y RDX
					MOV RAX, R13
					MOV RDX, R11
					LEA RSI, [RBX + R10 - 16]
					LEA RDI, [RAX + R10 - 16]
					; PASO LOS ULTIMOS 16 BYTES A XMM0
					MOVDQU XMM0, [RDI]	
					; GUARDO EL PRIMER BYTE PARA RESTAURARLO DESPUES (PORQUE YA LO PROCESE EN LA PASADA ANTERIOR)
					MOVDQU XMM1, [RSI]
					PSHUFB XMM1, [unByte]
					MOVQ R12, XMM1
					; SHIFTEO EL REGISTRO PARA QUE ME QUEDEN LOS 5 PIXELES EN LOS PRIMEROS 15 BYTES DE XMM0
					PSRLDQ XMM0, 1 
					CALL tempe
					; LO VUELVO A SHIFTEAR PARA EL OTRO LADO PARA PONER EL BYTE QUE GUARDE EN R12
					PSLLDQ XMM0, 1 
					XORPD XMM1, XMM1
					MOVQ XMM1, R12
					; JUNTO LOS DOS REGISTROS
					POR XMM1, XMM0
					MOVDQU [RSI], XMM1
				.endfor2:
					; MUEVO LOS PUNTEROS A LA PROXIMA FILA
					LEA RDI, [RAX + R8]
					LEA RSI, [RBX + R9]

				;AUMENTAR Y SEGUIR
				LEA RAX, [RAX + R8]
				LEA RBX, [RBX + R9]
				INC R14
				JMP .for1

		.endfor1:
	
	ADD RSP, 8
	POP RBX
	POP R15
	POP R14
 	POP R13
 	POP R12
 	POP RBP
	RET


tempe:

	PUSH RBP
	MOV RBP, RSP
	push R12
	push R13
	push r14
	push r15		
		;XMM0: R|G|B|R|G|B|R|G|B|R|G|B|R|G|B|R coloco los primeros 16bytes de la imagen en XMM1
		;XMM0: 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15
		MOVDQU XMM8, XMM0
		CALL temp_aux
		MOVDQU XMM9, XMM0
		PSHUFB XMM8, [moverPixeles] 	; XMM8: 6 |7 |8 |9 |10|11|12|13|14|15|- |- |- |- |- |-
		PSHUFB XMM9, [moverPixeles2]	; XMM9: - |- |- |- |- |- |- |- |- |0 |1 |2 |3 |4 |5 |-
		MOVDQU XMM0, XMM8	
		CALL temp_aux
		MOVDQA XMM13, XMM0
		PSHUFB XMM13, [moverPixeles3]	; xmm13: - |- |- |0 |1 |2 |3 |4 |5 |- |- |- |- | -|- |-
		
		PSHUFB XMM8, [moverPixeles1] 	; xmm8:  12|13|14|- |- |- |- |- |- |- |- |- |- |- |- |-
		MOVDQU XMM0, XMM8
		CALL temp_aux					; xmm0: ??
		PSHUFB XMM0, [unPixel] 			; xmm0:  0 |1 |2 |- |- |- |- |- |- |- |- |- |- |- |- |-
		
		POR XMM0, XMM13					; xmm0: 0 |1 |2 |03|14|25|36|47|58|9 |10|11|12|13|14|15
		POR XMM0, XMM9					; xmm0: 0 |1 |2 |03|14|25|36|47|58|09 |110|211|312|413|514|15
		PSHUFB XMM0, [invertir]			; xmm0: 09|110|211|312|413|514|03|14|25|36|47|58|0 |1 |2 | -
	POP R15
	POP R14
 	POP R13
 	POP R12
	POP RBP
	RET
	
temp_aux:
;void temperatura(rgb_t* p_d, unsigned int r, unsigned int g, unsigned int b){
;	unsigned int prom = (r + g + b) / 3;
;
;	if 		 (prom < 32)	{p_d->r = 0; 				p_d->g = 0; 				p_d->b = 128 + 4*prom;}
;	else if (prom < 96)	{p_d->r = 0; 				p_d->g = -128 + 4*prom; 	p_d->b = 255;}
;	else if (prom < 160)	{p_d->r = -384 + 4*prom;	p_d->g = 255; 				p_d->b = 639 - 4*prom;}
;	else if (prom < 224)	{p_d->r = 255; 				p_d->g = 895 - 4*prom;	 	p_d->b = 0;}
;	else 					{p_d->r = 1151 - 4*prom;	p_d->g = 0; 				p_d->b = 0;}}
;	
;	return res;}
	;RDI: src*

	PUSH RBP					
	MOV RBP, RSP
	PUSH R12
	PUSH R13
	push R14
	push R15

	XORPD XMM2, XMM2
	XORPD XMM3, XMM3
	XORPD XMM4, XMM4
	
	MOVDQA XMM7, [pixel0BGR]
	PSHUFB XMM0, XMM7		 			; ordeno en el registro los pixels de forma 0RGB (tengo 4 pixeles)
	MOVDQU XMM2, XMM0					; XMM2: R|0|G|0|B|0|0|0|R|0|G|0|B|0|0|0	
	PSHUFB XMM2, [soloPrimero]			; XMM2: R|0|0|0|0|0|0|0|R|0|0|0|0|0|0|0		; solo dejamos rojo para 'suma'
	MOVDQU XMM3, XMM0					; XMM3: R|0|G|0|B|0|0|0|R|0|G|0|B|0|0|0 	
	PSRLQ XMM3, 16						; XMM3: G|0|B|0|0|0|0|0|G|0|B|0|0|0|0|0		
	PSHUFB XMM3, [soloPrimero]			; XMM3: G|0|0|0|0|0|0|0|G|0|0|0|0|0|0|0		; solo dejamos verde para 'suma'
	MOVDQU XMM4, XMM0					; XMM4: R|0|G|0|B|0|0|0|R|0|G|0|B|0|0|0 	
	PSRLQ XMM4, 32						; XMM4: B|0|0|0|0|0|0|0|B|0|0|0|0|0|0|0		; solo dejamos azul para 'suma'
	; Ahora podemos hacer suma
	PADDQ XMM2, XMM3
	PADDQ XMM2, XMM4					; XMM2: qword[R+G+B] qword[R+G+B] 

	XORPD XMM5, XMM5
	; suma / 3
	MOV R12, 3
	MOV R13, 1
	XORPD XMM0, XMM0
	XORPD XMM1, XMM1
	CVTSI2SS XMM0, R12
	CVTSI2SS XMM1, R13
	; PARA EXTENDER EL 3 A LOS PACKS DEL XMM5
	XORPD XMM5, XMM5
	ADDSS XMM5, XMM1
	PSLLDQ XMM5, 4
	ADDSS XMM5, XMM0
	PSLLDQ XMM5, 4
	ADDSS XMM5, XMM1
	PSLLDQ XMM5, 4
	ADDSS XMM5, XMM0

	; Paso XMM5 a float	
	;CVTDQ2PS XMM5, XMM5
	CVTDQ2PS XMM2, XMM2
	DIVPS XMM2, XMM5					; XMM2: prom (float)
	CVTTPS2DQ XMM2, XMM2
	CVTDQ2PS XMM2, XMM2
	MOVDQU XMM12, XMM2					; XMM12: prom (float)
	CVTTPS2DQ XMM12, XMM12
	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]

	XORPD XMM0, XMM0
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	; ponemos colores[0] en su lugar correspondiente	{128 + 4t, 0, 0}

	MOVDQU XMM10, [colores0] 			; XMM10: qword[128(+4T)] qword[128(+4T)] 

	;XMM10: colores[0] nos falta agregar 4T
	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	MOVDQU XMM6, XMM2
	;XMM6: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]

	;PARA MULTIPLICAR POR 4
	MOV R12, 4
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14

	CVTDQ2PS XMM5, XMM5
	MULPS XMM6, XMM5	; XMM6: qword[4T|0|0|0|0|0|0|0] qword[4T|0|0|0|0|0|0|0]

	CVTTPS2DQ XMM6, XMM6

	; A: 4T + 128
	; XMM6: 	qword[4T|0|0|0|0|0|0|0] 		qword[4T|0|0|0|0|0|0|0]
	; XMM10: 	qword[128(+4T)|0|0|0|0|0|0|0] 	qword[128(+4T)|0|0|0|0|0|0|0]
	PADDUSW XMM10, XMM6
	MOVDQU XMM6, XMM10
	;XMM10 == XMM6 == qword[4T+128] qword[4T+128]
	XORPD XMM15, XMM15
	PUNPCKLQDQ XMM10, XMM15
	PUNPCKHQDQ XMM6, XMM15
	;XMM10 == qword{[A|0|0|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[A|0|0|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	
	;Lo voy a mirar de otra forma para empaquetar (puedo porque con 16bits me alcanza para representar A):
	;XMM10 == dword{[A|0] [G|0] [B|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	;XMM6 ==  dword{[A|0] [G|0] [B|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	PACKUSWB XMM10, XMM6
	;XMM10 == dword{[AGB0][0000][AGB0][0000]}
	;empaquete saturando word a byte para reducir el tamanio de A de 2 bytes a 1 byte
	PSHUFB XMM10, [shuffleCaverna2]
	;XMM10 == dword{[AGB0][AGB0][0000][0000]}

	MOVDQU XMM1, [tresDos] 
	PCMPGTD XMM1, XMM12	
	PSHUFB XMM1, [shuffleCaverna2]
	PAND XMM1 , XMM10 					; estos pixeles le ponemos colores[0]
	XORPD XMM0, XMM0
	POR XMM0, XMM1						; ponemos colores0 en donde va en dst
	;/////////////////////////////r//////////////////////////////////////////////////////////////////////
	;///////////////////////////////////////////////////////////////////////////////////////////////////

	; ponemos colores[4] en su lugar correspondiente	{  0, 0, 1151 -4t}
	MOVDQU XMM10, [colores4]

	;XMM10: colores[4] nos falta agregar 4T
	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0] (tipo float)
	MOVDQU XMM6, XMM2
	;XMM6: [0|0|0|0|T|0|0|0] [0|0|0|0|T|0|0|0]
	;PARA MULTIPLICAR POR 4
	MOV R12, 4
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14

	CVTDQ2PS XMM5, XMM5
	MULPS XMM6, XMM5	; XMM6: qword[4T|0|0|0|0|0|0|0] qword[4T|0|0|0|0|0|0|0]

	CVTTPS2DQ XMM6, XMM6
	PSLLDQ XMM6, 4
	;XMM6: qword[0|0|0|0|4T|0|0|0] qword[0|0|0|0|4T|0|0|0]

	XORPD XMM15, XMM15
	; A: 1151 - 4T
	; XMM6: 	qword[0|0|0|0|4T|0|0|0] 		qword[0|0|0|0|4T|0|0|0]
	; XMM10: 	qword[0|0|0|0|1151(-4T)|0|0|0] 	qword[0|0|0|0|1151(-4T)|0|0|0]
	PSUBUSW XMM10, XMM6
	MOVDQU XMM6, XMM10
	;XMM10 == XMM6 == qword[4T+128] qword[4T+128]
	PUNPCKLQDQ XMM10, XMM15
	PUNPCKHQDQ XMM6, XMM15
	;XMM10 == qword{[0|0|0|0|A|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[0|0|0|0|A|0|0|0] [0|0|0|0|0|0|0|0]}
	;Lo voy a mirar de otra forma para empaquetar (puedo porque con 16bits me alcanza para representar A):
	;XMM10 == dword{[R|0] [G|0] [A|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	;XMM6 ==  dword{[R|0] [G|0] [A|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	PACKUSWB XMM10, XMM6
	;XMM10 == dword{[RGA0][0000][RGA0][0000]}
	;empaquete saturando word a byte para reducir el tamanio de A de 2 bytes a 1 byte
	PSHUFB XMM10, [shuffleCaverna2]
	;XMM10 == dword{[RGA0][RGA0][0000][0000]}

	MOVDQU XMM1, [dosDosCuatro] 
	PCMPGTD XMM1, XMM12			; en XMM1 tenemos unos donde se cumple la condicion

	PAND XMM12, XMM1			; seteo en 0 los que ya use para no pisarlos despues
	PSHUFB XMM1, [shuffleCaverna2]
	PANDN XMM1 , XMM10 			; estos pixeles le ponemos colores[4]
	POR XMM0, XMM1				; ponemos colores4 en donde va en dst
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	;///////////////////////////////////////////////////////////////////////////////////////////////////

	; ponemos colores[3] en su lugar correspondiente     {0, 895 - 4t, 255}
	MOVDQU XMM10 , [colores3] 		; estos pixeles le ponemos colores[3]

	;XMM10: colores[3] nos falta agregar 4T
	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	MOVDQU XMM6, XMM2
	;XMM6: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	;PARA MULTIPLICAR POR 4
	MOV R12, 4
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14

	CVTDQ2PS XMM5, XMM5
	MULPS XMM6, XMM5	; XMM6: qword[4T|0|0|0|0|0|0|0] qword[4T|0|0|0|0|0|0|0]

	CVTTPS2DQ XMM6, XMM6
	PSLLDQ XMM6, 2

	; A: 895 - 4T
	; XMM6: 	qword[0|0|4T|0|0|0|0|0] 		qword[0|0|4T|0|0|0|0|0]
	; XMM10: 	qword[0|0|895(-4T)|0|255|0|0|0] 	qword[0|0|895(-4T)|0|255|0|0|0]
	PSUBUSW XMM10, XMM6
	MOVDQU XMM6, XMM10
	;XMM10 == XMM6 == qword[4T+128] qword[4T+128]
	XORPD XMM15, XMM15
	PUNPCKLQDQ XMM10, XMM15
	PUNPCKHQDQ XMM6, XMM15
	;XMM10 == qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;Lo voy a mirar de otra forma para empaquetar (puedo porque con 16bits me alcanza para representar A):
	;XMM10 == dword{[R|0] [A|0] [255|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	;XMM6 ==  dword{[R|0] [A|0] [255|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	PACKUSWB XMM10, XMM6
	;XMM10 == dword{[RAB0][0000][RAB0][0000]}
	;empaquete saturando word a byte para reducir el tamanio de A de 2 bytes a 1 byte
	PSHUFB XMM10, [shuffleCaverna2]
	;XMM10 == dword{[RAB0][RAB0][0000][0000]}

	MOVDQU XMM1, [unoSeisCero] 
	PCMPGTD XMM1, XMM12			; en XMM1 tenemos unos donde se cumple la condicion

	PAND XMM12, XMM1
	PSHUFB XMM1, [shuffleCaverna2]
	PANDN XMM1 , XMM10 		; estos pixeles le ponemos colores[3]
	POR XMM0, XMM1				; ponemos colores3 en donde va en dst
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	; ponemos colores[2] en su lugar correspondiente		{639 -4t, 255, -384 + 4t},	

	MOVDQU XMM10 ,[colores2] 		; estos pixeles le ponemos colores[2]

	;XMM10: colores[3] nos falta agregar 4T
	; XMM10: 	qword[639 (- 4T) |0|255|0|4T(-384)|0|0|0] 	qword[639 (- 4T) |0|255|0|4T(-384)|0|0|0]

	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	MOVDQU XMM6, XMM2
	;XMM6: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	;PARA MULTIPLICAR POR 4
	MOV R12, 4
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14

	CVTDQ2PS XMM5, XMM5	
	MULPS XMM6, XMM5	; XMM6: qword[4T|0|0|0|0|0|0|0] qword[4T|0|0|0|0|0|0|0]

	CVTTPS2DQ XMM6, XMM6
	MOVDQU XMM11, XMM6
	; A: 639 - 4T
	; B: 4T - 384
	; XMM6: 	qword[4T|0|0|0|0|0|0|0] 		qword[4T|0|0|0|0|0|0|0]
	; XMM10: 	qword[639|0|255|0|0|0|0|0] 		qword[639|0|255|0|0|0|0|0]
	PSUBUSW XMM10, XMM6
	; XMM10: 	qword[639-4T|0|255|0|0|0|0|0] 		qword[639-4T|0|255|0|0|0|0|0]
	PSLLDQ XMM6, 4
	; XMM6: 	qword[0|0|0|0|4T|0|0|0] 		qword[0|0|0|0|4T|0|0|0]
	PADDUSW XMM10, XMM6
	; XMM10: 	qword[639-4T|0|255|0|4T|0|0|0] 		qword[639-4T|0|255|0|4T|0|0|0]
	MOV R12, 384
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 4
	; XMM5: 	qword[0|0|0|0|384|0|0|0] 	qword[0|0|0|0|384|0|0|0]
	PSUBUSW XMM10, XMM5
	;PSUBUSW XMM10, XMM11
	; XMM10: 	qword[639-4T|0|255|0|4T-384|0|0|0] 		qword[639-4T|0|255|0|4T-384|0|0|0]


	MOVDQU XMM6, XMM10
	;XMM10 == XMM6 == dqword[639-4T|0|255|0|4T-384|0|0|0]
	XORPD XMM15, XMM15
	PUNPCKLQDQ XMM10, XMM15
	PUNPCKHQDQ XMM6, XMM15
	;XMM10 == qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;Lo voy a mirar de otra forma para empaquetar (puedo porque con 16bits me alcanza para representar A):
	;XMM10 == dword{[R|0] [A|0] [255|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	;XMM6 ==  dword{[R|0] [A|0] [255|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	PACKUSWB XMM10, XMM6
	;XMM10 == dword{[RAB0][0000][RAB0][0000]}
	;empaquete saturando word a byte para reducir el tamanio de A de 2 bytes a 1 byte
	PSHUFB XMM10, [shuffleCaverna2]
	;XMM10 == dword{[RAB0][RAB0][0000][0000]}

	MOVDQU XMM1, [nueveSeis] 
	PCMPGTD XMM1, XMM12			; en XMM1 tenemos unos donde se cumple la condicion

	PAND XMM12, XMM1
	PSHUFB XMM1, [shuffleCaverna2]
	PANDN XMM1 , XMM10 		; estos pixeles le ponemos colores[2]
	POR XMM0, XMM1				; ponemos colores2 en donde va en dst
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	; ponemos colores[1] en su lugar correspondiente		{255, -128 + 4t, 0}
	MOVDQU XMM10 ,[colores1] 		; estos pixeles le ponemos colores[1]

	;XMM10: colores[1] nos falta agregar 4T - 128
	;XMM2: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	MOVDQU XMM6, XMM2
	;XMM6: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	;XMM6: [T|0|0|0|0|0|0|0] [T|0|0|0|0|0|0|0]
	;PARA MULTIPLICAR POR 4
	MOV R12, 4
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14

	CVTDQ2PS XMM5, XMM5	
	MULPS XMM6, XMM5	; XMM6: qword[T|0|0|0|0|0|0|0] qword[T|0|0|0|0|0|0|0]

	CVTTPS2DQ XMM6, XMM6
	PSLLDQ XMM6, 2
	; XMM6: qword[0|0|4T|0|0|0|0|0] qword[0|0|4T|0|0|0|0|0]

	; A: 4T - 128
	; XMM6: 	qword[0|0|4T|0|0|0|0|0] 		qword[0|0|4T|0|0|0|0|0]
	; XMM10: 	qword[255|0|(4T - 128)|0|0|0|0|0] 	qword[255|0|(4T - 128)|0|0|0|0|0]
	PADDUSW XMM10, XMM6
	; XMM10: 	qword[255|0|4T (- 128)|0|0|0|0|0] 	qword[255|0|4T (- 128)|0|0|0|0|0]
	; AGREGO EL 128 PACKED PARA RESTARLO
	MOV R12, 128
	XORPD XMM14, XMM14
	MOVQ XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 2
	; XMM5: 	qword[0|0|128|0|0|0|0|0] 	qword[0|0|128|0|0|0|0|0]
	PSUBUSW XMM10, XMM5
	; XMM10: 	qword[255|0|4T - 128|0|0|0|0|0] 	qword[255|0|4T - 128|0|0|0|0|0]

	MOVDQU XMM6, XMM10
	;XMM10 == XMM6 == qword[4T-128] qword[4T-128]
	XORPD XMM15, XMM15
	PUNPCKLQDQ XMM10, XMM15
	PUNPCKHQDQ XMM6, XMM15
	;XMM10 == qword{[255|0|A|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[255|0|A|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;Lo voy a mirar de otra forma para empaquetar (puedo porque con 16bits me alcanza para representar A):
	;XMM10 == dword{[255|0] [A|0] [B|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	;XMM6 ==  dword{[255|0] [A|0] [B|0] [0|0] [0|0] [0|0] [0|0] [0|0]}
	PACKUSWB XMM10, XMM6
	;XMM10 == dword{[RAB0][0000][RAB0][0000]}
	;empaquete saturando word a byte para reducir el tamanio de A de 2 bytes a 1 byte
	PSHUFB XMM10, [shuffleCaverna2]
	;XMM10 == dword{[RAB0][RAB0][0000][0000]}

	MOVDQU XMM1, [tresDos] 
	PCMPGTD XMM1, XMM12			; en XMM1 tenemos unos donde se cumple la condicion

	PAND XMM12, XMM1
	PSHUFB XMM1, [shuffleCaverna2]
	PANDN XMM1 , XMM10 			; estos pixeles le ponemos colores[1]
	POR XMM0, XMM1				; ponemos colores1 en donde va en dst
	;///////////////////////////////////////////////////////////////////////////////////////////////////
	;///////////////////////////////////////////////////////////////////////////////////////////////////	



	;ahora en XMM2 tenemos dst con los colores finales
	;sacamos los ceros para que queden pixeles de 3 bytes
	MOVDQU XMM10, [pixelFinal]
	PSHUFB XMM0, XMM10

	pop r15
	pop r14
	POP R13
	POP R12
	POP RBP
	RET
