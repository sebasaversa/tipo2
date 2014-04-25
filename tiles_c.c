
#include "tp2.h"


void tiles_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size,
	int tamx,
	int tamy,
	int offsetx,
	int offsety)
{
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i_d = 0, i_s = 0; i_d < filas; i_d++, i_s++) {
		for (int j_d = 0, j_s = 0; j_d < cols; j_d++, j_s++) {
			rgb_t *p_d = (rgb_t*)&dst_matrix[i_d][j_d*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[i_s][j_s*3];
			*p_d = *p_s;
		}
	}

	int inicioTiles = offsetx; //me muevo en X
	inicioTiles += offsety; //me muevo en y
	int ultimoNivelTiles += tamy;
	int actualTiles = inicioTiles;
	

	int hs = (offsety); //altura fuente
	int ws = (offsetx*3); //ancho fuente
	int j = 0:
	while(j < filas){
		for( int a = 0; a == (tamy-1); a++){

			for(int l = 0; l == ((cols*3)-1) ; l++ ){
				
				dst_matrix[l][a] = src_matrix[ws][hs]; //copio el byte
				ws += 1;
				if( ws == ((offsetx*3) + (tamx*3))) //si llegue al final del recuadro arranco del principio
				{
					ws = (offsetx*3);
				}
			}
			ws = (offset*3); //al terminar toda la fila arranco del principio del tile
			hs += 1; //bajo un nivel del tile
		}
	j += tamy //agrego a j todas las filas que paso
	hs = offsety; //acomodo al tile en altura
	}

