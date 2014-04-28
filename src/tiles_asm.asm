;MACROS
;%include "macros.txt"

global tiles_asm

section .data

section .text
;void tiles_asm(unsigned char *src,
;              unsigned char *dst,
;              int filas,
;              int cols,
;              int src_row_size,
;              int dst_row_size );

global _start

tiles_asm:
    push rbp
    mov rsp, rbp
    
    %if 1 = 1
	MOV RDI, 2
%endif 
    
    pop rbp
    ret
