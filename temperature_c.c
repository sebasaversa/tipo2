
#include <math.h>
#include "tp2.h"


bool between(unsigned int val, unsigned int a, unsigned int b)
{
	return a <= val && val <= b;
}


void temperature_c    (
	unsigned char *src,
	unsigned char *dst,
	int cols,
	int filas,
	int src_row_size,
	int dst_row_size)
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
	
	
		int j = 0;
	while( j < filas){
	int x = 0;
	for(int l = 0; l == ((tamFilas*3)-1); l = l+3)
	{
	tempPixel(src_matrix[l][j], dst_matrix[l][j]);
	}
	j++;
	}

}


void tempPixel(unsigned char src_matrix[x][y], unsigned char dst_matrix[x][y]){
	int x = l;
	int suma = 0;
	suma = src_matrix[x][y];
	x++;
	suma += src_matrix[x][y];
	xx++;
	suma += src_matrix[x][y];
	suma /= 3; //aca divido la suma de los 3 colores del pixel
	if( suma < 32)
	{
		dst_matrix[x][y] = 0;
		x--;
		dst_matrix[x][y] = 0;
		x--;
		dst_matrix[x][y] = 128 + suma*4;
		
		
	}
	else
	{
		if( 32 <= suma < 96)
		{
				
			dst_matrix[x][y] = 0;
			x--;
			dst_matrix[x][y] = (suma - 32) * 4;
			x--;
			dst_matrix[x][y] = 255;	
		}
		else
		{
			if( 96 <= suma < 160)
			{
					
				dst_matrix[x][y] = (suma = 96) * 4;
				x--;
				dst_matrix[x][y] = 255;
				x--;
				dst_matrix[x][y] = 255 - ((suma = 96) * 4);
			}
			else
			{
				if( 160 <= suma < 224)
				{

					dst_matrix[x][y] = 255;
					x--;
					dst_matrix[x][y] = 255 - ((t - 160) * 4);
					x--;
					dst_matrix[x][y] = 0;
				}
				else
				{
					
					dst_matrix[x][y] = 255 - ((t - 224) * 4);
					x--;
					dst_matrix[x][y] = 0;
					x--;
					dst_matrix[x][y] = 0;						
				}
			}
		}
	}
	
	
}






