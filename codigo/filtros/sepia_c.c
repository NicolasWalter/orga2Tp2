
#include "../tp2.h"


void sepia_c    (
    unsigned char *src,
    unsigned char *dst,
    int cols,
    int filas,
    int src_row_size,
    int dst_row_size)
{
    unsigned char (*src_matrix)[src_row_size] = (unsigned char (*)[src_row_size]) src;
    unsigned char (*dst_matrix)[dst_row_size] = (unsigned char (*)[dst_row_size]) dst;

    int i=0;
    for (i; i < filas; i++)
    {
        int j=0;
        for (j; j < cols; j++)
        {
            bgra_t *p_d = (bgra_t*) &dst_matrix[i][j * 4];
            bgra_t *p_s = (bgra_t*) &src_matrix[i][j * 4];
            *p_d = *p_s;
            double suma=(*p_s).g+(*p_s).b+(*p_s).r;
            double rAux=0.5*suma;
            double gAux=0.3*suma;
            double bAux=0.2*suma;
            if(rAux>255){
                (*p_d).r=255;
            }else{
                (*p_d).r=rAux;
            }
            if(gAux>255){
                 (*p_d).g=255;
            }else{
                 (*p_d).g=0.3*suma;
            }
            if(bAux>255){
                (*p_d).b=255;
            }else{
                (*p_d).b=0.2*suma;
            }
        }
    }	         
}


/*
O Ri,j = 0, 5 · suma i,j
O Gi,j = 0, 3 · suma i,j
O Bi,j = 0, 2 · suma i,j
donde suma i,j = I i,j+ I i,j+ I i,j*/