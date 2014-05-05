
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
		;XMM1: [R11|G11|B11|R12|G12|B12|R13|G13|B13|R1$|G14|B14|R15|G15|B15|0]
		
		LEA RDI, [RDI + R8]
		MOVDQU XMM2, [RDI]
		;XMM2: [R21|G21|B21|R22|G22|B22|R23|G23|B23|R24|G24|B24|R25|G25|B25|0]
				
		LEA RDI, [RDI + R8]
		MOVDQU XMM3, [RDI]
		;XMM3: [R31|G31|B31|R32|G32|B32|R33|G33|B33|R34|G34|B34|R35|G35|B35|0]
				
		LEA RDI, [RDI + R8]
		MOVDQU XMM4, [RDI]
		;XMM4: [R41|G41|B41|R42|G42|B42|R43|G43|B43|R44|G44|B44|R45|G45|B45|0]
		MOV R9, R8               
				                 
		LEA RDI, [RDI + R8]      
		MOVDQU XMM5, [RDI]       
		;XMM5: [R51|G51|B51|R52|G52|B52|R53|G53|B53|R54|G54|B54|R55|G55|B55|0]
		ADD R9, R8
		
		LEA RDI, [RDI + 6]
		LEA RDI, [RDI - R9]		;restauro RDI a donde estaba
		
		;//////////////////////////////////////////////////////////////////////////////
		;///////////////////		SUMO LAS FILAS 1 Y 2 			///////////////////
		;//////////////////////////////////////////////////////////////////////////////
		;Uso XMM7 para las sumas parciales
		; Agarro la fila 1
		MOVDQU XMM7, XMM1
		;XMM7: [R11|G11|B11|R12|G12|B12|R13|G13|B13|R14 |G14 |B14 |R15 |G15 |B15|0]
		XORPD XMM15, XMM15
		PUNPCKLQDQ XMM7, XMM15
		PUNPCKHQDQ XMM1, XMM15
		;XMM7: [R11|0	|G11|0	|B11|0	|R12|0	|G12|0	|B12|0	|R13|0	|G13|0]
		;XMM1: [B13|0	|R14|0	|G14|0	|B14|0	|R15|0	|G15|0	|B15|0	|0|0]
		PADD XMM7, XMM1
		;XMM7: [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		
		; Agarro la fila 2
		MOVDQU XMM12, XMM2
		;XMM12: [R21|G21|B21|R22|G22|B22|R23|G23|B23|R24|G24|B24|R25|G25|B25|0]
		XORPD XMM15, XMM15
		PUNPCKLQDQ XMM12, XMM15
		PUNPCKHQDQ XMM2, XMM15
		;XMM12:  [R21|0	|G21|0	|B21|0	|R22|0	|G22|0	|B22|0	|R23|0	|G23|0]
		;XMM2:  [B23|0	|R24|0	|G24|0	|B24|0	|R25|0	|G25|0	|B25|0	|0  |0]
		PADD XMM12, XMM2
		;XMM12 : [R21+B23 |G21+R24 |B21+G24 |R22+B24 |G22+R25 |B22+G25 |R23+B25 |G23+0]
		;XMM7:  [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		PHADDW XMM7, XMM12
		;XMM7:  [R11+B13 +G11+R14 	|B11+G14+R12+B14 	|G12+R15+B12+G15 |R13+B15 +G13+0
		;		|R21+B23 +G21+R24 	|B21+G24+R22+B24 	|G22+R25+B22+G25 |R23+B25 +G23+0]
		
		PHADDW XMM7, XMM7
		;XMM7:  [R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	|G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	|G22+R25+B22+G25 +R23+B25 +G23+0		
		
		PHADDW XMM7, XMM7
		;XMM7:	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		
		PHADDW XMM7, XMM7
		;XMM7: 	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		+R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|basura |basura |basura |basura |basura |basura |basura]
		
		; XMM7: [sumargb(deLasFilas1Y2) |basura |basura |basura |basura |basura |basura |basura]

		;//////////////////////////////////////////////////////////////////////////////
		;///////////////////		SUMO LAS FILAS 1 Y 2 			///////////////////
		;//////////////////////////////////////////////////////////////////////////////
		
		

		;//////////////////////////////////////////////////////////////////////////////
		;///////////////////		SUMO LAS FILAS 3 Y 4 			///////////////////
		;//////////////////////////////////////////////////////////////////////////////
		;Uso XMM8 para las sumas parciales
		;Agarro la fila 3
		MOVDQU XMM8, XMM3
		;XMM7: [R11|G11|B11|R12|G12|B12|R13|G13|B13|R14 |G14 |B14 |R15 |G15 |B15|0]
		XORPD XMM15, XMM15
		PUNPCKLQDQ XMM8, XMM15
		PUNPCKHQDQ XMM1, XMM15
		;XMM8: [R11|0	|G11|0	|B11|0	|R12|0	|G12|0	|B12|0	|R13|0	|G13|0]
		;XMM1: [B13|0	|R14|0	|G14|0	|B14|0	|R15|0	|G15|0	|B15|0	|0|0]
		PADD XMM8, XMM1
		;XMM8: [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		
		; Agarro la fila 4
		MOVDQU XMM12, XMM4
		;XMM12: [R21|G21|B21|R22|G22|B22|R23|G23|B23|R24|G24|B24|R25|G25|B25|0]
		XORPD XMM15, XMM15
		PUNPCKLQDQ XMM12, XMM15
		PUNPCKHQDQ XMM4, XMM15
		;XMM12:  [R21|0	|G21|0	|B21|0	|R22|0	|G22|0	|B22|0	|R23|0	|G23|0]
		;XMM4:  [B23|0	|R24|0	|G24|0	|B24|0	|R25|0	|G25|0	|B25|0	|0  |0]
		PADD XMM12, XMM4
		;XMM12 : [R21+B23 |G21+R24 |B21+G24 |R22+B24 |G22+R25 |B22+G25 |R23+B25 |G23+0]
		;XMM8:  [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		PHADDW XMM8, XMM12
		;XMM8:  [R11+B13 +G11+R14 	|B11+G14+R12+B14 	|G12+R15+B12+G15 |R13+B15 +G13+0
		;		|R21+B23 +G21+R24 	|B21+G24+R22+B24 	|G22+R25+B22+G25 |R23+B25 +G23+0]
		
		PHADDW XMM8, XMM8
		;XMM8:  [R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	|G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	|G22+R25+B22+G25 +R23+B25 +G23+0		
		
		PHADDW XMM8, XMM8
		;XMM8:	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	
		
		PHADDW XMM8, XMM8
		;XMM8: 	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		+R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|basura |basura |basura |basura |basura |basura |basura]
		
		; XMM8: [sumargb(deLasFilas3Y4) |basura |basura |basura |basura |basura |basura |basura]

		;//////////////////////////////////////////////////////////////////////////////
		;///////////////////		SUMO LAS FILAS 3 Y 4 			///////////////////
		;//////////////////////////////////////////////////////////////////////////////
		
		;//////////////////////////////////////////////////////////////////////////////
		;///////////////////		SUMO LAS FILAS 5 Y 6(ceros)		///////////////////
		;//////////////////////////////////////////////////////////////////////////////
		;Uso XMM9 para las sumas parciales
		;Agarro la fila 5
		MOVDQU XMM9, XMM5
		;XMM7: [R11|G11|B11|R12|G12|B12|R13|G13|B13|R14 |G14 |B14 |R15 |G15 |B15|0]
		XORPD XMM15, XMM15
		PUNPCKLQDQ XMM9, XMM15
		PUNPCKHQDQ XMM1, XMM15
		;XMM9: [R11|0	|G11|0	|B11|0	|R12|0	|G12|0	|B12|0	|R13|0	|G13|0]
		;XMM1: [B13|0	|R14|0	|G14|0	|B14|0	|R15|0	|G15|0	|B15|0	|0|0]
		PADD XMM9, XMM1
		;XMM9: [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		
		; Agarro la fila 6 (creo una con todos ceros)
		XORPD XMM6, XMM6
		MOVDQU XMM12, XMM6
		;XMM12: [0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|]
		XORPD XMM15, XMM15
		PUNPCKLQDQ XMM12, XMM15
		PUNPCKHQDQ XMM6, XMM15
		;XMM12: [0|0	|0|0	|0|0	|0|0	|0|0	|0|0	|0|0	|0|0]
		;XMM6:  [0|0	|0|0	|0|0	|0|0	|0|0	|0|0	|0|0	|0|0]
		PADD XMM12, XMM6
		;XMM12 : [0|0	|0|0	|0|0	|0|0	|0|0	|0|0	|0|0	|0|0]
		;XMM9:   [R11+B13 |G11+R14 |B11+G14 |R12+B14 |G12+R15 |B12+G15 |R13+B15 |G13+0]
		PHADDW XMM9, XMM12
		;XMM9:  [R11+B13 +G11+R14 	|B11+G14+R12+B14 	|G12+R15+B12+G15 |R13+B15 +G13+0
		;		|0+0				|0+0				|0+0			 |0+0	]
		
		PHADDW XMM9, XMM9
		;XMM9:  [R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|0 					+0 					|0				 +0 	  +0		XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	|G12+R15+B12+G15 +R13+B15 +G13+0
		;		|0 					+0 					|0				 +0 	  +0		
		
		PHADDW XMM9, XMM9
		;XMM9:	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		|0 					+0 					|0				 +0 	  +0		XX
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|0 					+0 					|0				 +0 	  +0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|0 					+0 					|0				 +0 	  +0	
		;		|R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	
		;		|0 					+0 					|0				 +0 	  +0	
		
		PHADDW XMM9, XMM9
		;XMM9: 	[R11+B13 +G11+R14 	+B11+G14+R12+B14 	+G12+R15+B12+G15 +R13+B15 +G13+0 	XX
		;		+R21+B23 +G21+R24 	+B21+G24+R22+B24 	+G22+R25+B22+G25 +R23+B25 +G23+0	XX
		;		|basura |basura |basura |basura |basura |basura |basura]
		
		; XMM9: [sumargb(deLaFila5) |basura |basura |basura |basura |basura |basura |basura]

		;//////////////////////////////////////////////////////////////////////////////
		;///////////////////		SUMO LAS FILAS 5 Y 6(ceros)		///////////////////
		;//////////////////////////////////////////////////////////////////////////////
		
		
		; XMM7: [sumargb(deLasFilas1Y2) |basura |basura |basura |basura |basura |basura |basura]
		; XMM8: [sumargb(deLasFilas3Y4) |basura |basura |basura |basura |basura |basura |basura]
		; XMM9: [sumargb(deLaFila5) 	|basura |basura |basura |basura |basura |basura |basura]
		
		PADDW XMM7, XMM8
		PADDW XMM7, XMM9

		; XMM7: [sumargb(deLos25Pixeles) |basura |basura |basura |basura |basura |basura |basura]
		;sumargb *= alfa;
		PMULUDQ XMM7, [RBP + 16]
