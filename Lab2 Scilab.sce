clc
// Datos de entrada (Cargados por defecto)
rugosidad = 0.0000015; 
viscosidad = 0.000001007; 
km = 11.8; 
H_Total = 43.5; 
diametro = 0.293;  
longitud = 730;

// Parámetros del ciclo while
Tolerancia = 0.001; 
maxIteraciones = 30; 
error_hf = 1; 
iteracion = 0; 
H = H_Total; 

// Creación del archivo de exportación (CSV)
fd = mopen('resultados_iteraciones.csv', 'wt');
mfprintf(fd, "Iteracion,V,Hf\n");

// Ciclo Iterativo
while error_hf > Tolerancia & maxIteraciones > iteracion 
    // Cálculo de velocidad y pérdidas
    velocidad = (-2*sqrt(19.62*diametro*H)/sqrt(longitud))*(log10((rugosidad/(3.7*diametro))+((2.51*viscosidad*sqrt(longitud))/(diametro*sqrt(19.62*diametro*H)))));  
    perdidas_menores = km * (velocidad^2/(19.62));
    perdidas_por_friccion = H_Total - perdidas_menores; 
    
    // Cálculo del error con valor absoluto
    error_hf = abs(perdidas_por_friccion - H);
    
    // Guardar fila iterada en el archivo de texto
    mfprintf(fd, "%d,%.3f,%.3f\n", iteracion+1, velocidad, perdidas_por_friccion);
    
    H = perdidas_por_friccion; 
    iteracion = iteracion + 1; 
end

// Cierre del archivo exportado
mclose(fd);

// Pruebas Condicionales de Finalización
if iteracion >= maxIteraciones then
    disp("Se alcanzó el número máximo de iteraciones sin convergencia.");
else
    disp("Convergencia alcanzada en " + string(iteracion) + " iteraciones. Resultados exportados a resultados_iteraciones.csv.");
end

disp("La velocidad del fluido final es: " + string(velocidad));
disp("Las pérdidas por fricción finales son: " + string(perdidas_por_friccion));
