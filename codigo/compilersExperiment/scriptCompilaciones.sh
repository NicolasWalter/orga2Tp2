directories=("ICCxHostO3" "ICCO3" "GCCMarchNativeO3" "GCCO3" "ICCO0" "ICCO2" "ICCxHostO0" "ICCxHostO2" "GCCO2" "GCCO0" "GCCMarchNativeO0" "GCCMarchNativeO2")

datosFiltros=("cropflip" "sepia" "ldr")

for z in ${datosFiltros[@]} 
do
	rm $z/*
done

for j in ${directories[@]} 
do
	directory=$j
	makef="make$directory"
	make -f $makef clean
	make -f $makef
	
		echo "Corriendo CropfliFlip $directory"
		for (( i=128; i < 1600; i=i+128 )); 
		do
	    	echo "Corriendo filtro para una matriz de $i x $i"
			printf '%i   ' $(($i*$i)) >> cropflip/$directory
			./$directory/tp2 cropflip -i c imagenes_a_testear/lena.${i}x${i}.bmp  $(($i/2)) $(($i/2)) 0 0 -t 10000 >>cropflip/$directory
		done
	
		echo "Corriendo Sepia $directory"
		for (( i=128; i < 1600; i=i+128 )); 
		do
	    	echo "Corriendo filtro para una matriz de $i x $i"
			printf '%i   ' $(($i*$i)) >> sepia/$directory
			./$directory/tp2 sepia -i c imagenes_a_testear/lena.${i}x${i}.bmp -t 1000 >>sepia/$directory
		done

		echo "Corriendo LDR $directory"
		for (( i=128; i < 1600; i=i+128 )); 
		do
	    	echo "Corriendo filtro para una matriz de $i x $i"
			printf '%i   ' $(($i*$i)) >> ldr/$directory
			./$directory/tp2 ldr -i c imagenes_a_testear/lena.${i}x${i}.bmp  100 -t 1000 >>ldr/$directory
		done

done

	  #python GraficarBarras.py Sepia