
#include "tp2.h"


rgb_t colores[] = { {255,   0,   0},
                    {127,   0, 127},
                    {255,   0, 255},
                    {  0,   0, 255},
                    {  0, 255, 255} };

void popart_c    (
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
	popPixel(src_matrix[l][j], dst_matrix[l][j]);
	}
	j++;
	}

}
void popPixel(unsigned char src_matrix[x][y], unsigned char dst_matrix[x][y]){
	int x = l;
	int suma = 0;
	suma = src_matrix[x][y];
	x++;
	suma += src_matrix[x][y];
	xx++;
	suma += src_matrix[x][y]; //aca sumo los 3 colores del pixel
	if( suma < 153)
	{
		dst_matrix[x][y] = 255;
		x--;
		dst_matrix[x][y] = 0;
		x--;
		dst_matrix[x][y] = 0;
		
		
	}
	else
	{
		if( 153 <= suma < 306)
		{
				
			dst_matrix[x][y] = 127;
			x--;
			dst_matrix[x][y] = 0;
			x--;
			dst_matrix[x][y] = 127;	
		}
		else
		{
			if( 306 <= suma < 459)
			{
					
				dst_matrix[x][y] = 255;
				x--;
				dst_matrix[x][y] = 0;
				x--;
				dst_matrix[x][y] = 255;
			}
			else
			{
				if( 459 <= suma < 612)
				{

					dst_matrix[x][y] = 0;
					x--;
					dst_matrix[x][y] = 0;
					x--;
					dst_matrix[x][y] = 255;
				}
				else
				{
					
					dst_matrix[x][y] = 0;
					x--;
					dst_matrix[x][y] = 255;
					x--;
					dst_matrix[x][y] = 255;						
				}
			}
		}
	}
	
	
}




