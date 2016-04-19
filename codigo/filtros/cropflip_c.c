
#include "../tp2.h"

void cropflip_c    (
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

	// ejemplo de uso de src_matrix y dst_matrix (copia una parte de la imagen)
	int i=0;
	for (i; i < tamy; i++) {
		int j=0;
		for (j; j < tamx; j++) {
			bgra_t *p_d = (bgra_t*) &dst_matrix[i][(j) * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[i][(j) * 4];

			p_d->b = ((bgra_t*) &src_matrix[tamy+offsety-i-1][(offsetx+j) * 4])->b;
			p_d->g = ((bgra_t*) &src_matrix[tamy+offsety-i-1][(offsetx+j) * 4])->g;
			p_d->r = ((bgra_t*) &src_matrix[tamy+offsety-i-1][(offsetx+j) * 4])->r;
			p_d->a = ((bgra_t*) &src_matrix[tamy+offsety-i-1][(offsetx+j) * 4])->a;

		}
	}


}
