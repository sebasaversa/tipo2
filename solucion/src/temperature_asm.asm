global temperature_asm

section .data
section .rodata

; VEMOS CADA PIXEL COMO SI FUERAN 4 WORDS Y PROCESAMOS DE A 2 PIXELES
ALIGN 16 
pixel0BGR : DB 0x00, 0x80, 0x01,  0x80,
			DB 0x02, 0x80, 0x80,  0x80,
			DB 0x03, 0x80, 0x04,  0x80,
			DB 0x05, 0x80, 0x80,  0x80
			
soloPrimero : 	DB  0x00, 0x80, 0x80, 0x80,
				DB  0x80, 0x80, 0x80, 0x80,
				DB  0x08, 0x80, 0x80, 0x80,
				DB  0x80, 0x80, 0x80, 0x80

;shuffleCaverna:	DW 0x00, 0x02, 0x04, 0x80
;				DW 0x80, 0x80, 0x80, 0x80,

shuffleCaverna2:DB  0x00, 0x01, 0x02, 0x03,
				DB  0x08, 0x09, 0x0A, 0x0B,
				DB  0x80, 0x80, 0x80, 0x80,
				DB  0x80, 0x80, 0x80, 0x80
				
pixelFinal :	DB 0x00, 0x01, 0x02, 0x04
				DB 0x05, 0x06, 0x08, 0x09,
				DB 0x80, 0x80, 0x80, 0x80,
				DB 0x80, 0x80, 0x80, 0x80,
				
dosDosCuatro: 	DQ 0xE1, 0xE1						; 225, 225, 225, 225			
unoSeisCero: 	DQ 0xA1, 0xA1						; 161, 161, 161, 161 	
nueveSeis: 		DQ 0x61, 0x61						; 97, 97, 97, 97, 	
tresDos: 		DQ 0x21, 0x21						; 33, 33, 33, 33, 
			
colores0: 			DW  0x80, 0x0,  0x0, 0x0,				; 128( + 4T),   0			, 0	 			,   0
					DW  0x80, 0x0,  0x0, 0x0,				; 128( + 4T),   0			, 0				,   0
colores1: 			DW  0xFF, 0x0, 0x0, 0x0,				; 255		,   (4T-128)	, 0				,   0	
					DW  0xFF, 0x0, 0x0, 0x0,				; 255		,   (4T-128)	, 0				,   0
colores2: 			DW  0x27F, 0xFF, 0x0, 0x0,				; 639 (- 4T),   255			, (4T - 384)	,   0
					DW  0x27F, 0xFF, 0x0, 0x0,				; 639 (- 4T),   255			, (4T - 384)	,   0
colores3: 			DW 	0x0, 0x37F, 0xFF, 0x0,				; 0			,   895 (- 4T)  , 255			,   0
					DW 	0x0, 0x37F, 0xFF, 0x0,				; 0			,   895 (- 4T)  , 255			,   0
colores4: 			DW  0x0, 0X0, 0x47F, 0x0,				; 0			,	0			, 1151 (- 4T)	,   0
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
	
    ;for (int i = 0; i < filas; i++) {
	MOV RAX, RDI
	MOV RBX, RSI
	XOR R10, R10	; R10: i
	.for1:
		
		;CONDICION
		;CMP ECX, R10			; ECX: filas
		CMP R10, RCX			; ECX: filas
		JGE .endfor1 
		;CODIGO
		;for (int j = 0; j < cols; j++) {
			XOR R11, R11	;R11: j
			.for2:
				;CONDICION
				;CMP EDX, R11	; EDX: cols
				CMP R11, RDX	; EDX: cols
				JGE .endfor2 
				;CODIGO
				;rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
				;rgb_t *p_s = (rgb_t2*)&src_matrix[i][j*3];
				;int s = pop_art(p_s->r, p_s->g, p_s->b);
				CALL temp_aux		; XMM0: 2 pixeles que van en dst*
				;*p_d = colores[s];}}}					
				MOVDQU [RSI], XMM0
				LEA RSI, [RSI+6]
				LEA RDI, [RDI+6]
								
				;AUMENTAR Y SEGUIR
				ADD R11, 2				; como agarro 2 pixeles, me corro 2 columnas
				CMP R11, RDX
				JE .endfor2
				;CMP R11, RDX
				;JGE .endfor2
				;VEMOS SI TOCAMOS PADDING
				MOV R12, R11
				ADD R12, 2
				CMP R12, RDX
				JLE .for2
				LEA RSI, [RSI-3]
				LEA RDI, [RDI-3]
				SUB R11, 1
				jmp .for2
				.endfor2:
				LEA RSI, [RBX + R8]
				LEA RDI, [RAX + R9]
				
				;AUMENTAR Y SEGUIR
				LEA RAX, [RAX + R8]
				LEA RBX, [RBX + R9]
				INC R10
				JMP .for1
		
		.endfor1:
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
	
	MOVDQU XMM0, [RDI]	; R|G|B|R|G|B|R|G|B|R|G|B|R|G|B|R coloco los primeros 16bytes de la imagen en XMM1
	
	; VER COMO FUNCIONA ESTE SHUFFLE

	XORPD XMM2, XMM2
	XORPD XMM3, XMM3
	XORPD XMM4, XMM4
	MOVDQA XMM7, [pixel0BGR]
	PSHUFB XMM0, XMM7		 			; ordeno en el registro los pixels de forma 0RGB (tengo 4 pixeles)
	MOVDQU XMM2, XMM0					; XMM2: R|0|G|0|B|0|0|0|R|0|G|0|B|0|0|0	
	PSHUFB XMM2, [soloPrimero]			; XMM2: R|0|0|0|0|0|0|0|R|0|0|0|0|0|0|0		; solo dejamos azul para 'suma'
	MOVDQU XMM3, XMM0					; XMM3: R|0|G|0|B|0|0|0|R|0|G|0|B|0|0|0 	
	PSRLQ XMM3, 16						; XMM3: G|0|B|0|0|0|0|0|G|0|B|0|0|0|0|0		
	PSHUFB XMM3, [soloPrimero]			; XMM3: G|0|0|0|0|0|0|0|G|0|0|0|0|0|0|0		; solo dejamos verde para 'suma'
	MOVDQU XMM4, XMM0					; XMM4: R|0|G|0|B|0|0|0|R|0|G|0|B|0|0|0 	
	PSRLQ XMM4, 32						; XMM4: B|0|0|0|0|0|0|0|B|0|0|0|0|0|0|0		; solo dejamos rojo para 'suma'
	; Ahora podemos hacer suma
	PADDQ XMM2, XMM3
	PADDQ XMM2, XMM4					; XMM2: qword[R+G+B] qword[R+G+B] 
	
	XORPD XMM5, XMM5
	; suma / 3
	MOV R12, 3
	MOV R13, 1
	CVTDQ2PS XMM2, XMM2
	XORPD XMM0, XMM0
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
	DIVPS XMM2, XMM5					; XMM2: prom
	MOVDQU XMM12, XMM2
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
	CVTSI2SS XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
	
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
	;XMM10 == dqword[A|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0]
	;XMM6 ==  dqword[A|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0]
	;PSHUFB XMM10, [shuffleCaverna]
	;PSHUFB XMM6, [shuffleCaverna]
	;XMM10 == qword{[A|0|0|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[A|0|0|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;Pero me hago el vivo y para empaquetar lo miro como (puedo porque con 16bits me alcanza para representar A)
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
	;MOVQ XMM14, R12
	CVTSI2SS XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
	
	MULPS XMM6, XMM5	; XMM6: qword[T|0|0|0|0|0|0|0] qword[T|0|0|0|0|0|0|0]
	
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
	;XMM10 == dqword[0|0|0|0|A|0|0|0|0|0|0|0|0|0|0|0]
	;XMM6 ==  dqword[0|0|0|0|A|0|0|0|0|0|0|0|0|0|0|0]
	;PSHUFB XMM10, [shuffleCaverna2]
	;PSHUFB XMM6, [shuffleCaverna2]
	;XMM10 == qword{[0|0|0|0|A|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[0|0|0|0|A|0|0|0] [0|0|0|0|0|0|0|0]}
	;Pero me hago el vivo y para empaquetar lo miro como (puedo porque con 16bits me alcanza para representar A)
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
	CVTSI2SS XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
		
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
	;XMM10 == dqword[0|0|A|0|255|0|0|0|0|0|0|0|0|0|0|0]
	;XMM6 ==  dqword[0|0|A|0|255|0|0|0|0|0|0|0|0|0|0|0]
	;PSHUFB XMM10, [shuffleCaverna2]
	;PSHUFB XMM6, [shuffleCaverna2]
	;XMM10 == qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;Pero me hago el vivo y para empaquetar lo miro como (puedo porque con 16bits me alcanza para representar A)
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
	CVTSI2SS XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
	
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
	;XMM10 == dqword[0|0|A|0|255|0|0|0|0|0|0|0|0|0|0|0]
	;XMM6 ==  dqword[0|0|A|0|255|0|0|0|0|0|0|0|0|0|0|0]
	;PSHUFB XMM10, [shuffleCaverna2]
	;PSHUFB XMM6, [shuffleCaverna2]
	;XMM10 == qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[0|0|A|0|255|0|0|0] [0|0|0|0|0|0|0|0]}
	;Pero me hago el vivo y para empaquetar lo miro como (puedo porque con 16bits me alcanza para representar A)
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
	CVTSI2SS XMM14, R12
	XORPD XMM5, XMM5
	PADDQ XMM5, XMM14
	PSLLDQ XMM5, 8
	PADDQ XMM5, XMM14
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
	;XMM10 == dqword[255|0|A|0|0|0|0|0|0|0|0|0|0|0|0|0]
	;XMM6 ==  dqword[255|0|A|0|0|0|0|0|0|0|0|0|0|0|0|0]
	;PSHUFB XMM10, [shuffleCaverna2]
	;PSHUFB XMM6, [shuffleCaverna2]
	;XMM10 == qword{[255|0|A|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;XMM6 ==  qword{[255|0|A|0|0|0|0|0] [0|0|0|0|0|0|0|0]}
	;Pero me hago el vivo y para empaquetar lo miro como (puedo porque con 16bits me alcanza para representar A)
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
	
	POP R13
	POP R12
	POP RBP
	RET