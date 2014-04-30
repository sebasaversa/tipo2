;MACROS
;%include "macros.txt"

global tiles_asm

%define modulo(x,y) mod x,y

%macro mod 2
	mov rax, %1
	mov rbx, %2
	xor rdx, rdx
	div rbx
	; rdx = %1 mod %2
%endmacro 

section .data

section .text

global _start

tiles_asm:
;void tiles_c    (
;	unsigned char *src,		RDI
;	unsigned char *dst,		RSI
;	int cols,				RDX
;	int filas,				RCX
;	int src_row_size,		R8
;	int dst_row_size,		R9
;	int tamx,				[RBP + 16]
;	int tamy,				[RBP + 24]
;	int offsetx,			[RBP + 32]
;	int offsety){			[RBP + 40]

;	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
;	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
;
;	for (int i = 0; i < filas; i++) {
;		for (int j = 0; j < cols; j++) {
;			rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
;			rgb_t *p_s = (rgb_t*)&src_matrix[(i % tamy) + offsety][((j*3) % (tamx*3)) + (offsetx*3)];
;			*p_d = *p_s;}}}
 
	
	PUSH RBP					
	MOV RBP, RSP
	PUSH R12
	PUSH R13

	;unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	
	;unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;
    
    ;for (int i = 0; i < filas; i++) {
	MOV R8, 0	; R8: i
	.for1:
		;CONDICION
		CMP RCX, R8
		JG .endfor1 
		;CODIGO
		;for (int j = 0; j < cols; j++) {
			MOV R9, 0	;R9: j
			.for2:
				;CONDICION
				CMP RDX, R9
				JG .endfor2 
				;CODIGO
				;rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
				;rgb_t *p_s = (rgb_t*)&src_matrix[(i % tamy) + offsety][((j*3) % (tamx*3)) + (offsetx*3)];
				;*p_d = *p_s;}}}
				
				;AUMENTAR Y SEGUIR
				INC R9			
				JMP .for2
	
				.endfor2:
				;AUMENTAR Y SEGUIR
				INC R8
				JMP .for1
		
		.endfor1:
    
    
	POP RBP
	POP R12
	POP R13
	RET
