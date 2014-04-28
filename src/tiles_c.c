
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
	int offsety){
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i = 0; i < filas; i++) {
		for (int j = 0; j < cols; j++) {
			rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[(i % tamy) + offsety][((j*3) % (tamx*3)) + (offsetx*3)];
			*p_d = *p_s;}}}
