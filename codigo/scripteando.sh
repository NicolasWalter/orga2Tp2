
make clean 
make
	

  #   for (( i = 128; i < 1700; i=i+128 )); do
  #    	echo "corriendo filtro para una matriz de $i x $i"
	 #  printf '%i   ' $(($i*$i)) >> SEPIALENTO
	 #  ./build/tp2 ldr -i asm lena.bmp -t 100 >>SEPIALENTO
	 # done


	 for (( i = 128; i < 1700; i=i+128 )); do
     	echo "corriendo filtro para una matriz de $i x $i"
	  printf '%i   ' $(($i*$i)) >> SEPIAFATFAST
	  ./build/tp2 sepia -i asm ./img/lena.${i}x${i}.bmp -t 100 >>SEPIAFATFAST
	 done

	 	#printf '%s ' 'negra' >> LDRNEGRA 
	 	# for (( i = 0; i < 100; i++ )); do
	 	# 	echo "corriendo filtro, iteracion:$i"
	 	# ./build/tp2 sepia -i asm negra.1536x1536.bmp   >>DesvioNegraSepia
	  # ./build/tp2 sepia -i asm lena.1536x1536.bmp   >>DesvioLenaSepia
	  # ./build/tp2 sepia -i asm blanca.1536x1536.bmp   >>DesvioBlancaSepia
	  # ./build/tp2 ldr -i asm negra.1536x1536.bmp 100  >>DesvioNegraLdr
	  # ./build/tp2 ldr -i asm lena.1536x1536.bmp 100  >>DesvioLenaLdr
	  # ./build/tp2 ldr -i asm blanca.1536x1536.bmp  100  >>DesvioBlancaLdr
	  # ./build/tp2 cropflip -i asm negra.1536x1536.bmp 768 768 0 0   >>DesvioNegraCropflip
	  # ./build/tp2 cropflip -i asm lena.1536x1536.bmp 768 768 0 0  >>DesvioLenaCropflip
	  # ./build/tp2 cropflip -i asm blanca.1536x1536.bmp  768 768 0 0  >>DesvioBlancaCropflip


	 	# done
	  
	  #python GraficarBarras.py Sepia
