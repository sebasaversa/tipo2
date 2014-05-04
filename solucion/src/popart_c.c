
#include "tp2.h"


rgb_t colores[] = { {255,   0,   0},
                    {127,   0, 127},
                    {255,   0, 255},
                    {  0,   0, 255},
                    {  0, 255, 255} };

			
int pop_art(unsigned int r, unsigned int g, unsigned int b){
	unsigned int suma = r + g + b;
	int res;
	
	if 		 (suma < 153)	{res = 0;}
	else if (suma < 306)	{res = 1;}
	else if (suma < 459)	{res = 2;}
	else if (suma < 612)	{res = 3;}
	else 					{res = 4;}
	
	return res;}

void popart_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size){
	
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i = 0; i < filas; i++) {
		for (int j = 0; j < cols; j++) {
			rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[i][j*3];
			int s = pop_art(p_s->r, p_s->g, p_s->b);
			*p_d = colores[s];}}}
