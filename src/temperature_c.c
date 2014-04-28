
#include <math.h>
#include "tp2.h"

/*rgb_t colores[] = { {128, 0,   0}, 	// {128 + 4t, 0, 0},
                    {255, -128, 0},		// {255, -128 + 4t, 0},
                    {639, 255, -384}, 	// {639 -4t, 255, -384 + 4t},
                    {  0, 895, 255}, 	// {  0, 895 - 4t, 255},
                    {  0, 0, 1151} }; 	// {  0, 0, 1151 -4t} };
*/
bool between(unsigned int val, unsigned int a, unsigned int b){
	return a <= val && val <= b;}

void temperatura(rgb_t* p_d, unsigned int r, unsigned int g, unsigned int b){
	unsigned int prom = (r + g + b) / 3;

	if 		 (prom < 32)	{p_d->r = 0; 				p_d->g = 0; 				p_d->b = 128 + 4*prom;}
	else if (prom < 96)	{p_d->r = 0; 				p_d->g = -128 + 4*prom; 	p_d->b = 255;}
	else if (prom < 160)	{p_d->r = -384 + 4*prom;	p_d->g = 255; 				p_d->b = 639 - 4*prom;}
	else if (prom < 224)	{p_d->r = 255; 				p_d->g = 895 - 4*prom;	 	p_d->b = 0;}
	else 					{p_d->r = 1151 - 4*prom;	p_d->g = 0; 				p_d->b = 0;}}

void temperature_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size){
		
	unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
	unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

	for (int i = 0; i < filas; i++){
		for (int j = 0; j < cols; j++){
			rgb_t *p_d = (rgb_t*)&dst_matrix[i][j*3];
			rgb_t *p_s = (rgb_t*)&src_matrix[i][j*3];
			temperatura(p_d, p_s->r, p_s->g, p_s->b);}}}
			
