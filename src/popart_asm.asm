global popart_asm

section .data
section .rodata

ALIGN 16 
pixel0BGR : DB 0x8C, 0x0B, 0x0A, 0x09,
			DB 0x89, 0x08, 0x07, 0x06,
			DB 0x86, 0x05, 0x04, 0x03,
			DB 0x83, 0x02, 0x01, 0x00

pixelFinal : DB 0x8C, 0x8B, 0x8A, 0x89,
			DB 0x0E, 0x0D, 0x0C, 0x0A,
			DB 0x09, 0x08, 0x06, 0x05,
			DB 0x04, 0x02, 0x01, 0x00

seisOnce: 			DD 0x263, 0x263, 0x263, 0x263,		; 611, 611, 611, 611			
cuatroCincoOcho: 	DD 0x1CA, 0x1CA, 0x1CA, 0x1CA,		; 458, 458, 458, 458, 	
tresOCinco: 		DD 0x131, 0x131, 0x131, 0x131,		; 305, 305, 305, 305, 	
unoCincoDos: 		DD 0x98, 0x98, 0x98, 0x98			; 152, 152, 152, 152, 


colores0: 			DB 0x0, 0xFF, 0x0, 0x0,		; 0, 255, 0, 0
					DB 0x0, 0xFF, 0x0, 0x0,		; 0, 255, 0, 0
					DB 0x0, 0xFF, 0x0, 0x0,		; 0, 255, 0, 0
					DB 0x0, 0xFF, 0x0, 0x0		; 0, 255, 0, 0
colores1: 			DB 0x0, 0x7F, 0x0, 0x7F,		; 0, 127, 0, 127			
					DB 0x0, 0x7F, 0x0, 0x7F,		; 0, 127, 0, 127			
					DB 0x0, 0x7F, 0x0, 0x7F,		; 0, 127, 0, 127			
					DB 0x0, 0x7F, 0x0, 0x7F		; 0, 127, 0, 127			
colores2: 			DB 0x0, 0xFF, 0x0, 0xFF,		; 0, 255, 0, 255			
					DB 0x0, 0xFF, 0x0, 0xFF,		; 0, 255, 0, 255
					DB 0x0, 0xFF, 0x0, 0xFF,		; 0, 255, 0, 255
					DB 0x0, 0xFF, 0x0, 0xFF		; 0, 255, 0, 255
colores3: 			DB 0x0, 0x0, 0x0, 0xFF,		; 0, 0, 0, 255			
					DB 0x0, 0x0, 0x0, 0xFF,		; 0, 0, 0, 255			
					DB 0x0, 0x0, 0x0, 0xFF,		; 0, 0, 0, 255			
					DB 0x0, 0x0, 0x0, 0xFF		; 0, 0, 0, 255			
colores4: 			DB 0x0, 0x0, 0xFF, 0xFF,		; 0, 0, 255, 255			
					DB 0x0, 0x0, 0xFF, 0xFF,		; 0, 0, 255, 255			
					DB 0x0, 0x0, 0xFF, 0xFF,		; 0, 0, 255, 255			
					DB 0x0, 0x0, 0xFF, 0xFF		; 0, 0, 255, 255			
	

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

	
	


	;unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	
	;unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
    
    ;for (int i = 0; i < filas; i++) {
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
				JMP .for2
	
				.endfor2:
				;AUMENTAR Y SEGUIR
				INC R10
				JMP .for1
		
		.endfor1:
    
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
	
	MOVDQU XMM0, [RDI]	; coloco los primeros 16bytes de la imagen en XMM1
	
	; VER COMO FUNCIONA ESTE SHUFFLE
	MOVDQU XMM10, [pixel0BGR] 
	PSHUFB XMM0, XMM10		 	; ordeno en el registro los pixels de forma 0BGR (tengo 4 pixeles)
	PHADDSW XMM0, XMM0			; me queda en la parte baja de XMM0 los 4 pixeles que estoy viendo
								; esto los quiero desempaquetar para volver a dword y poder elegir que colores[i] usamos
	PXOR XMM1, XMM1
	PUNPCKLWD XMM0, XMM1		; en XMM0 tenemos suma() de 4 pixeles en dword
	
	; ponemos colores[0] en su lugar correspondiente
	MOVDQU XMM1, [unoCincoDos] 
	PCMPGTD XMM1, XMM0
	MOVDQU XMM10, [colores0] 
	PANDN XMM1, XMM10
	POR XMM2, XMM1				; ponemos colores0 en donde va en dst

	; ponemos colores[1] en su lugar correspondiente
	MOVDQU XMM1, [unoCincoDos] 
	PCMPGTD XMM1, XMM0			; en XMM1 tenemos unos donde se cumple la condicion
	MOVDQU XMM10, [colores1]
	PAND XMM1 ,XMM10 		; estos pixeles le ponemos colores[4]
	POR XMM2, XMM1				; ponemos colores1 en donde va en dst
	
	; ponemos colores[2] en su lugar correspondiente
	MOVDQU XMM1, [tresOCinco] 
	PCMPGTD XMM1, XMM0			; en XMM1 tenemos unos donde se cumple la condicion
	PAND XMM1 ,[colores2] 		; estos pixeles le ponemos colores[4]
	POR XMM2, XMM1				; ponemos colores2 en donde va en dst
	
	; ponemos colores[3] en su lugar correspondiente
	MOVDQU XMM1, [cuatroCincoOcho] 
	PCMPGTD XMM1, XMM0			; en XMM1 tenemos unos donde se cumple la condicion
	MOVDQU XMM10, [colores3]
	PAND XMM1 , XMM10 		; estos pixeles le ponemos colores[4]
	POR XMM2, XMM1				; ponemos colores3 en donde va en dst
	
	; ponemos colores[4] en su lugar correspondiente
	MOVDQU XMM1, [seisOnce] 
	PCMPGTD XMM1, XMM0			; en XMM1 tenemos unos donde se cumple la condicion
	MOVDQU XMM10, [colores4]
	PAND XMM1 , XMM10 		; estos pixeles le ponemos colores[4]
	POR XMM2, XMM1				; ponemos colores4 en donde va en dst
	
	;ahora en XMM2 tenemos dst con los colores finales
	;sacamos los ceros para que queden pixeles de 3 bytes
	MOVDQU XMM10, [pixelFinal]
	PSHUFB XMM2, XMM10
	MOVDQU XMM0, XMM2
	
	POP RBP
	RET
