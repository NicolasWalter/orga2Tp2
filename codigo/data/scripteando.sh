
make clean 
make
	

  #   for (( i = 128; i < 300; i=i+128 )); do
  #    	echo "corriendo filtro para una matriz de $i x $i"
	 #  printf '%i   ' $(($i*$i)) >> LDRNEGRA
	 #  ./build/tp2 ldr -i asm negra.bmp 100 -t 100 >>LDRNEGRA
	 # done


	 

	 	#printf '%s ' 'negra' >> LDRNEGRA 
	  ./build/tp2 ldr -i asm negra.bmp sepia -t 1500 >>Sepia
	  ./build/tp2 ldr -i asm ./img/lena.512x512.bmp sepia -t 1500 >>Sepia
	  ./build/tp2 ldr -i asm blanca.bmp sepia -t 1500 >>Sepia


	  python GraficarBarras.py Sepia
