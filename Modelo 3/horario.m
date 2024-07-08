function H = horario(Bus, Paradas)
    
    N_buses = Bus.n;
    salidas = Bus.salidas;
    N_paradas = Paradas.n;
    posicion_paradas = Paradas.pos;
    v = Bus.vmax;
    
    % Calcula el tiempo de llegada a cada parada para cada autobús
    tiempo_llegada = zeros(N_buses, N_paradas);
    for i = 1:N_buses
        tiempo_llegada(i,1) = salidas(i); % Tiempo de salida de la primera parada
        for j = 2:N_paradas
            % Calcula el tiempo de llegada a la parada actual basado en la velocidad y tiempo de parada
            distancia = abs(posicion_paradas(j) - posicion_paradas(j-1));
            tiempo_viaje = distancia / v;
            tiempo_llegada(i,j) = tiempo_llegada(i,j-1) + tiempo_viaje + (tiempo_viaje/60);
        end
    end

    % Construye la matriz de horario
    H = zeros(N_buses, N_paradas);
    for i = 1:N_buses
        for j = 1:N_paradas
            % Redondea al entero más cercano el tiempo de llegada a cada parada
            H(i,j) = round(tiempo_llegada(i,j));
        end
    end
end

