
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
				
				CMP R10, 2 ;VEO SI ESTOY EN LAS PRIMERAS 2 FILAS
				JGE .else
				CMP R11, 2 ;VEO SI ESTOY EN LAS PRIMERAS 2 COLUMNAS
				JGE .else
				MOV R12, RCX 
				SUB R12, R10 ;VEO QUE TAN LEJOS ESTOY DE LAS ULTIMAS 2 FILAS
				CMP R12, 2
				JBE .else
				MOV R12, RDX ;VEO QUE TAN LEJOS ESTOY DE LAS ULTIMAS 2 COLUMNAS
				SUB R12, R11
				CMP R12, 2
				JBE .else
				 
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
							

					CALL ldr_aux
					
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
 

ldr_aux:


		LEA RDI, [RDI - 6]
		LEA RDI, [RDI - R8]
		LEA RDI, [RDI - R8]
		MOVDQU XMM1, [RDI]
		;XMM1: [R11|G12|B13|R14|G15|B16|R17|G18|B19|R110|G111|B112|R113|G114|B115|0]
		
		LEA RDI, [RDI + R8]
		MOVDQU XMM2, [RDI]
		;XMM2: [R21|G22|B23|R24|G25|B26|R27|G28|B29|R210|G211|B212|R213|G214|B215|0]
				
		LEA RDI, [RDI + R8]
		MOVDQU XMM3, [RDI]
		;XMM3: [R31|G32|B33|R34|G35|B36|R37|G38|B39|R310|G311|B312|R313|G314|B315|0]
				
		LEA RDI, [RDI + R8]
		MOVDQU XMM4, [RDI]
		;XMM4: [R41|G42|B43|R44|G45|B46|R47|G48|B49|R410|G411|B412|R413|G414|B415|0]
		MOV R9, R8               
				                 
		LEA RDI, [RDI + R8]      
		MOVDQU XMM5, [RDI]       
		;XMM5: [R51|G52|B53|R54|G55|B56|R57|G58|B59|R510|G511|B512|R513|G514|B515|0]
		ADD R9, R8
		
		LEA RDI, [RDI + 6]
		LEA RDI, [RDI - R9]		;restauro RDI a donde estaba
		
		
		;Uso xmm10 para las sumas parciales
		XORPD XMM10, XMM10
		MOVDQU XMM10, XMM1
		;XMM10: [R11|G12|B13|R14|G15|B16|R17|G18|B19|R110|G111|B112|R113|G114|B115|0]
		PUNPCK XMM10, CEROS
		;XMM10: [R11|0	|G12|0	|B13|0	|R14|0	|G15|0	|B16|0	|R17|0	|G18|0]
		;XMM11: [B19|0	|R110|0	|G111|0	|B112|0	|R113|0	|G114|0	|B115|0	|0|0]
		PADD XMM10, XMM11
		;XMM10: [R11+B19 |G12+R110 |B13+G111 |R14+B112 |G15+R113 |B16+G114 |R17+B115 |G18+0]
		
		MOVDQU XMM12, XMM2
		;XMM12: [R11|G12|B13|R14|G15|B16|R17|G18|B19|R110|G111|B112|R113|G114|B115|0]
		PUNPCK XMM12, CEROS
		;XMM12: [R21|0	|G22|0	|B23|0	|R24|0	|G25|0	|B26|0	|R27|0	|G28|0]
		;XMM13: [B29|0	|R210|0	|G211|0	|B212|0	|R213|0	|G214|0	|B215|0	|0|0]
		PADD XMM10, XMM11
		;XMM12: [R21+B29 |G22+R210 |B23+G211 |R24+B212 |G25+R213 |B26+G214 |R27+B215 |G28+0]
		
		PHADDSW XMM10, XMM12
		;XMM10: [R11+B19+G12+R110 	|B13+G111+R14+B112 	|R21+B29+G22+R210  |B23+G211+R24+B212 
		;		|G15+R113+B16+G114 	|R17+B115+G18+0 	|G25+R213+B26+G214 |R27+B215+G28+0]
		
		PHADDSW XMM10, XMM10
		;XMM10: [R11+B19+G12+R110 	+B13+G111+R14+B112 	|R21+B29+G22+R210  +B23+G211+R24+B212 	XX
		;		|R11+B19+G12+R110 	+B13+G111+R14+B112 	|R21+B29+G22+R210  +B23+G211+R24+B212 
		;		|G15+R113+B16+G114 	+R17+B115+G18+0 	|G25+R213+B26+G214 +R27+B215+G28+0]		XX
		;		|G15+R113+B16+G114 	+R17+B115+G18+0 	|G25+R213+B26+G214 +R27+B215+G28+0]
		
		PHADDSW XMM10, XMM10
		;XMM10: [R11+B19+G12+R110 	+B13+G111+R14+B112 	+R21+B29+G22+R210  +B23+G211+R24+B212 	XX
		;		|R11+B19+G12+R110 	+B13+G111+R14+B112 	+R21+B29+G22+R210  +B23+G211+R24+B212 
		;		|R11+B19+G12+R110 	+B13+G111+R14+B112 	+R21+B29+G22+R210  +B23+G211+R24+B212 	
		;		|R11+B19+G12+R110 	+B13+G111+R14+B112 	+R21+B29+G22+R210  +B23+G211+R24+B212 
		;		|G15+R113+B16+G114 	+R17+B115+G18+0 	+G25+R213+B26+G214 +R27+B215+G28+0]		XX
		;		|G15+R113+B16+G114 	+R17+B115+G18+0 	+G25+R213+B26+G214 +R27+B215+G28+0]
		;		|G15+R113+B16+G114 	+R17+B115+G18+0 	+G25+R213+B26+G214 +R27+B215+G28+0]		
		;		|G15+R113+B16+G114 	+R17+B115+G18+0 	+G25+R213+B26+G214 +R27+B215+G28+0]
	
		
		PSHUFB XMM1, [moverUnPixel]
		;XMM1: [R11|G12|B13|R14|G15|B16|R17|G18|B19|R110|G111|B112|R113|G114|B115|0]
		
