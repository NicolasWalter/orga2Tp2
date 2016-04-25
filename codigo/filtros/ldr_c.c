
#include "../tp2.h"

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
	int alpha)
{
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

    int i=0;
    for (i; i < filas; i++)
    {
        int j = 0;
        for (j; j < cols; j++)
        {
            bgra_t *p_d = (bgra_t*) &dst_matrix[i][j * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[i][j * 4];
            *p_d = *p_s;
            if(!(i<2 || j<2 || i+2 >= filas || j+2 >= cols) ){

                double maxi =5 * 5 * 255 * 3 * 255;
                double sumaRij=0;
                double sumaGij=0;
                double sumaBij=0;
                for (int iAux = -2; iAux <= 2; iAux++)
                {
                   for (int jAux = -2; jAux <= 2; jAux++)
                   {
                       sumaRij=sumaRij+((bgra_t*) &dst_matrix[i+iAux][(j+jAux) * 4])->r;
                       sumaGij=sumaGij+((bgra_t*) &dst_matrix[i+iAux][(j+jAux) * 4])->g;
                       sumaBij=sumaBij+((bgra_t*) &dst_matrix[i+iAux][(j+jAux) * 4])->b;
                   }
                }
                double auxSumaPorAlpha=(sumaBij+sumaGij+sumaRij)*alpha;
                double auxPreDivR=auxSumaPorAlpha*(*p_s).r;
                double auxPreDivG=auxSumaPorAlpha*(*p_s).g;
                double auxPreDivB=auxSumaPorAlpha*(*p_s).b;
                double ldrR=(auxPreDivR / maxi) + (*p_s).r;
                double ldrG= (auxPreDivG / maxi) + (*p_s).g;
                double ldrB= (auxPreDivB / maxi) + (*p_s).b;

                (*p_d).r=MIN(MAX(ldrR,0),255);
                (*p_d).g=MIN(MAX(ldrG,0),255);
                (*p_d).b=MIN(MAX(ldrB,0),255);
            }
            
        }
    }
}

