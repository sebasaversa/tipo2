//gdb -args tp2 ldr -i c lena.bmp debuggeo
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
	unsigned int max = 5 * 5 * 255 * 3 * 255;

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
				unsigned int red = 0;
				unsigned int green = 0;
				unsigned int blue = 0;
				for( int f = i-2; f  <= (i+2); f++){
					for( int c = j-2; c <= (j+2); c++){
						rgb_t *p_p = (rgb_t*) &dst_matrix[f][c * 3];
						red += p_p->r;
						green += p_p->g;
						blue += p_p->b;
					}
				}
				//aca termino de sumar todos los colores
					unsigned int sumColores = red + green + blue; //aca tengo la suma de los 3 colores
					sumColores *= alfa;
					p_s->r = MIN(MAX( p_s->r + ((p_s->r * sumColores) / max), 0), 255);
					p_s->g = MIN(MAX( p_s->g + ((p_s->g * sumColores) / max), 0), 255);
					p_s->b = MIN(MAX( p_s->b + ((p_s->b * sumColores) / max), 0), 255);			
			}
        }
    }
}
