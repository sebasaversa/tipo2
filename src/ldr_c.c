
#include "tp2.h"

#define MIN(x,y) ( x < y ? x : y )
#define MAX(x,y) ( x > y ? x : y )

#define P 2

void ldr_c    (
    unsigned char *src,
    unsigned char *dst,
    int cols,
    int filas,
    int src_row_size,
    int dst_row_size,
	int alfa)
{
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

    for (int i = 0; i < filas; i++)
    {
        for (int j = 0; j < cols; j++)
        {
            rgb_t *p_d = (rgb_t*) &dst_matrix[i][j * 3];
            rgb_t *p_s = (rgb_t*) &src_matrix[i][j * 3];
            if(i < 2 || j < 2 || i+2 > filas || j+2 > cols)
            {
				*p_d = *p_s;
			}
			else
			{
					LDR(p_d, p_s, filas, alta);
			}
        }
    }
}

void LDR(rgb_t* p_d, rgb_t* p_s, int f, int alfa){
	unsigned sumTotal = 0;
	unsigned sumColores = 0;
	unsigned int max = 5 * 5 * 255 * 3 * 255;
	
	
	unsigned int r = sumaColor(&p_s->r, f);
	unsigned int g = sumaColor(&p_s->g, f);
	unsigned int b = sumaColor(&p_s->b, f);
	
	sumColores = r + g + b;
	r *= sumColores*alfa;
	g *= sumColores*alfa;
	b *= sumColores*alfa;
	r /= max;
	g /= max;
	b /= max;
	p_d->r = max(p_d->r + r  , 0);
	p_d->g = max(p_d->g + g  , 0);
	p_d->b = max(p_d->b + b  , 0);
	p_d->r = min(p_d->r + r  , 255);
	p_d->g = min(p_d->g + g  , 255);
	p_d->b = min(p_d->b + b  , 255);
	
}

unsigned int sumaColor(unsigned int* r, int f){
	unsigned int suma = 0;
	&r -= (6 - (filas*3*2));
	
	for( int c = 0; f < 5; f++){
		&r += (filas*3);
		for( int f = 0; f < 5*3; f+= 3){
			suma += *(&r+f); // suma el valor del rojo en la posicion
		}
	}
	return suma;
}
