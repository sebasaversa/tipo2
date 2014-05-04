global popart_asm

section .data
section .rodata

; VEMOS CADA PIXEL COMO SI FUERAN 4 BYTES Y PROCESAMOS DE A 4 PIXELES
ALIGN 16 
pixel0BGR : DB 0x00, 0x01, 0x02,  0x80,
			DB 0x03, 0x04, 0x05,  0x80,
			DB 0x06, 0x07, 0x08,  0x80,
			DB 0x09, 0x0A, 0x0B,  0x80
			
soloPrimero : 	DB  0x00, 0x80, 0x80, 0x80,
				DB  0x04, 0x80, 0x80, 0x80,
				DB  0x08, 0x80, 0x80, 0x80,
				DB  0x0C, 0x80, 0x80, 0x80
		
pixelFinal :	DB 0x00, 0x01, 0x02, 0x04
				DB 0x05, 0x06, 0x08, 0x09,
				DB 0x0A, 0x0C, 0x0D, 0x0E,
				DB 0x80, 0x80, 0x80, 0x80,

seisDoce: 			DD 0x264, 0x264, 0x264, 0x264,		; 612, 612, 612, 612			
cuatroCincoNueve: 	DD 0x1CB, 0x1CB, 0x1CB, 0x1CB,		; 459, 459, 459, 459, 	
tresOSeis: 		DD 0x132, 0x132, 0x132, 0x132,		; 306, 306, 306, 306, 	
unoCincoTres: 		DD 0x99, 0x99, 0x99, 0x99			; 153, 153, 153, 153, 


colores0: 			DB  0xFF, 0x0,  0x0, 0x0,	; 255,   0,   0,   0
					DB  0xFF, 0x0,  0x0, 0x0,	; 255,   0,   0,   0
					DB  0xFF, 0x0,  0x0, 0x0,	; 255,   0,   0,   0
					DB  0xFF, 0x0,  0x0, 0x0	; 255,   0,   0,   0
colores1: 			DB  0x7F, 0x0, 0x7F, 0x0,	; 127,   0, 127		,   0	
					DB  0x7F, 0x0, 0x7F, 0x0,	; 127,   0, 127			,   0
					DB  0x7F, 0x0, 0x7F, 0x0,	; 127,   0, 127			,   0
					DB 	0x7F, 0x0, 0x7F, 0x0	; 127,   0, 127			,   0
colores2: 			DB  0xFF, 0x0, 0xFF, 0x0,	; 255,   0, 255			,   0
					DB  0xFF, 0x0, 0xFF, 0x0,	; 255,   0, 255,   0
					DB  0xFF, 0x0, 0xFF, 0x0,	; 255,   0, 255,   0
					DB 	0xFF, 0x0, 0xFF, 0x0	; 255,   0, 255,   0
colores3: 			DB 	0x0, 0x0, 0xFF,  0x0,	; 0,   0, 255			,   0
					DB 	0x0, 0x0, 0xFF,  0x0,	; 0,   0, 255			,   0
					DB 	0x0, 0x0, 0xFF,  0x0,	; 0,   0, 255			,   0
					DB 	0x0, 0x0, 0xFF,	 0x0	; 0,   0, 255			,   0
colores4: 			DB  0x0, 0xFF, 0xFF, 0x0,	; 0, 255, 255			,   0
					DB  0x0, 0xFF, 0xFF, 0x0,	; 0, 255, 255			,   0
					DB  0x0, 0xFF, 0xFF, 0x0,	; 0, 255, 255			,   0
					DB 	0x0, 0xFF, 0xFF, 0x0	; 0, 255, 255			,   0
	

section .text

;void popart_c    (
;	unsigned char *src,			RDI
;	unsigned char *dst,			RSI
;	int cols,					RDX
;	int filas,					RCX
;	int src_row_size,			R8
;	int dst_row_size){			R9
;	
;	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
;	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
;
;	for (int i = 0; i < filas; i++) {
;		for (int j = 0; j < cols; j++) {
;			rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
;			rgb_t *p_s = (rgb_t*)&src_matrix[i][j*3];
;			int s = pop_art(p_s->r, p_s->g, p_s->b);
;			*p_d = colores[s];}}}
popart_asm:

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
				CALL pop_art		; XMM0: 4 pixeles que van en dst*
				;*p_d = colores[s];}}}					
				MOVDQU [RSI], XMM0
				LEA RSI, [RSI+12]
				LEA RDI, [RDI+12]
								
				;AUMENTAR Y SEGUIR
				ADD R11, 4				; como agarro 4 pixeles, me corro 4 columnas
				CMP R11, RDX
				JE .endfor2
				;CMP R11, RDX
				;JGE .endfor2
				;VEMOS SI TOCAMOS PADDING
				MOV R12, R11
				ADD R12, 4
				CMP R12, RDX
				JLE .for2
				LEA RSI, [RSI-9]
				LEA RDI, [RDI-9]
				SUB R11, 3
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


pop_art:
;int pop_art(unsigned int r, unsigned int g, unsigned int b){
;	unsigned int suma = r + g + b;
;	int res;
;	
;	if 		 (suma < 153)	{res = 0;}
;	else if (suma < 306)	{res = 1;}
;	else if (suma < 459)	{res = 2;}
;	else if (suma < 612)	{res = 3;}
;	else 					{res = 4;}
;	
;	return res;}
	;RDI: src*
	
	PUSH RBP					
	MOV RBP, RSP
	
	MOVDQU XMM0, [RDI]	; R|G|B|R|G|B|R|G|B|R|G|B|R|G|B|R coloco los primeros 16bytes de la imagen en XMM1
	
	; VER COMO FUNCIONA ESTE SHUFFLE

	XORPD XMM2, XMM2
	XORPD XMM3, XMM3
	XORPD XMM4, XMM4
	MOVDQA XMM7, [pixel0BGR]
	PSHUFB XMM0, XMM7		 			; ordeno en el registro los pixels de forma 0RGB (tengo 4 pixeles)
	MOVDQU XMM2, XMM0					; XMM2: R|G|B|0|R|G|B|0|R|G|B|0|R|G|B|0 	
	PSHUFB XMM2, [soloPrimero]			; XMM2: R|0|0|0|R|0|0|0|R|0|0|0|R|0|0|0		; solo dejamos azul para 'suma'
	MOVDQU XMM3, XMM0					; XMM3: R|G|B|0|R|G|B|0|R|G|B|0|R|G|B|0 	
	PSRLD XMM3, 8						; XMM3: G|B|0|0|G|B|0|0|G|B|0|0|G|B|0|0		
	PSHUFB XMM3, [soloPrimero]			; XMM3: G|0|0|0|G|0|0|0|G|0|0|0|G|0|0|0		; solo dejamos verde para 'suma'
	MOVDQU XMM4, XMM0					; XMM4: R|G|B|0|R|G|B|0|R|G|B|0|R|G|B|0 	
	PSRLD XMM4, 16						; XMM4: B|0|0|0|B|0|0|0|B|0|0|0|B|0|0|0		; solo dejamos rojo para 'suma'
	; Ahora podemos hacer suma
	PADDW XMM2, XMM3
	PADDW XMM2, XMM4					; XMM2: dword[R+G+B] dword[R+G+B] dword[R+G+B] dword[R+G+B]
	
	XORPD XMM0, XMM0

	; ponemos colores[0] en su lugar correspondiente	
	MOVDQU XMM1, [unoCincoTres] 
	MOVDQU XMM10, [colores0] 			; XMM10: [0|255|0|0] [0|255|0|0] [0|255|0|0] [0|255|0|0]
	PCMPGTD XMM1, XMM2	
	PAND XMM1 , XMM10 		; estos pixeles le ponemos colores[0]
	POR XMM0, XMM1						; ponemos colores0 en donde va en dst

	; ponemos colores[4] en su lugar correspondiente	
	MOVDQU XMM1, [seisDoce] 
	MOVDQU XMM10, [colores4]
	PCMPGTD XMM1, XMM2			; en XMM1 tenemos unos donde se cumple la condicion
	PAND XMM2, XMM1
	PANDN XMM1 , XMM10 		; estos pixeles le ponemos colores[4]
	POR XMM0, XMM1				; ponemos colores4 en donde va en dst
	
	; ponemos colores[3] en su lugar correspondiente
	MOVDQU XMM1, [cuatroCincoNueve] 
	MOVDQU XMM10 , [colores3] 		; estos pixeles le ponemos colores[3]
	PCMPGTD XMM1, XMM2			; en XMM1 tenemos unos donde se cumple la condicion
	PAND XMM2, XMM1
	PANDN XMM1 , XMM10 		; estos pixeles le ponemos colores[3]
	POR XMM0, XMM1				; ponemos colores3 en donde va en dst
	
	; ponemos colores[2] en su lugar correspondiente
	MOVDQU XMM1, [tresOSeis] 
	MOVDQU XMM10 ,[colores2] 		; estos pixeles le ponemos colores[2]
	PCMPGTD XMM1, XMM2			; en XMM1 tenemos unos donde se cumple la condicion
	PAND XMM2, XMM1
	PANDN XMM1 , XMM10 		; estos pixeles le ponemos colores[2]
	POR XMM0, XMM1				; ponemos colores2 en donde va en dst

	; ponemos colores[1] en su lugar correspondiente
	MOVDQU XMM1, [unoCincoTres] 
	MOVDQU XMM10 ,[colores1] 		; estos pixeles le ponemos colores[1]
	PCMPGTD XMM1, XMM2			; en XMM1 tenemos unos donde se cumple la condicion
	PAND XMM2, XMM1
	PANDN XMM1 , XMM10 		; estos pixeles le ponemos colores[1]
	POR XMM0, XMM1				; ponemos colores1 en donde va en dst
	

	

	
	;ahora en XMM2 tenemos dst con los colores finales
	;sacamos los ceros para que queden pixeles de 3 bytes
	MOVDQU XMM10, [pixelFinal]
	PSHUFB XMM0, XMM10
	;MOVDQU XMM0, XMM2
	
	POP RBP
	RET
