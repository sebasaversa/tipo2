
global ldr_asm

section .data

section .text
;void ldr_c    (
;    unsigned char *src,     RDI
;    unsigned char *dst,     RSI
;    int cols,               RDX
;    int filas,              RCX
;    int src_row_size,       R8
;    int dst_row_size,       R9
;	int alfa)				 [RBP + 16]
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
	;            if(i < 2 || j < 2 || i+2 > filas - 1 || j+2 > cols - 1){
	;				*p_d = *p_s;}
	
				.else:
	;			else{		
	;				unsigned int red = 0;
	;				unsigned int green = 0;
	;				unsigned int blue = 0;
					
	;				for( int f = i-2; f  <= (i+2); f++){
						;for( int c = j-2; c <= (j+2); c++){
			;				unsigned int sumargb = red + green + blue; //aca tengo la suma de los 3 colores
			;				sumargb *= alfa;
			;				p_d->r = MIN(MAX( p_s->r + ((p_s->r * sumargb) / max), 0), 255);
			;				p_d->g = MIN(MAX( p_s->g + ((p_s->g * sumargb) / max), 0), 255);
			;				p_d->b = MIN(MAX( p_s->b + ((p_s->b * sumargb) / max), 0), 255);}}}}
							
					LEA RDI, [RDI - 6]
					MOVDQU XMM1, [RDI]
					
					LEA RDI, [RDI + R8]
					MOVDQU XMM2, [RDI]
					MOV R9, R8
					
					LEA RDI, [RDI + R8]
					MOVDQU XMM3, [RDI]
					ADD R9, R8
					
					LEA RDI, [RDI + R8]
					MOVDQU XMM4, [RDI]
					MOV R9, R8
					
					LEA RDI, [RDI + R8]
					MOVDQU XMM5, [RDI]
					MOV R9, R8
					
					LEA RDI, [RDI + 6]
					LEA RDI, [RDI - R9]
					
					PADDB XMM1, XMM2
					PADDB XMM1, XMM3
					PADDB XMM1, XMM4
					PADDB XMM1, XMM5		; XMM1: tiene 5 pixeles  
					
					;*p_d = colores[s];}}}					
					MOVDQU [RSI], XMM0
					LEA RSI, [RSI+15]
					LEA RDI, [RDI+15]
									
					;AUMENTAR Y SEGUIR
					ADD R11, 5				; como agarro 5 pixeles, me corro 5 columnas
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
 
