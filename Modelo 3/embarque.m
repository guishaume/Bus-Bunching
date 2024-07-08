function pax = embarque(Bus, Paradas, b, lamb)

    pasajeros_en_parada = Paradas.pasajeros(Bus.parada(b));
    parada = Bus.parada(b);
    N_paradas = Paradas.n;
    
    pax = zeros(N_paradas,1);
    for i = 1 : pasajeros_en_parada
        probabilidades = lamb(parada+1:N_paradas) / sum(lamb(parada+1:N_paradas));

        % Crear un vector de probabilidades acumuladas
        prob_acumuladas = cumsum(probabilidades);

        % Generar un número aleatorio entre 0 y 1
        r = rand;

        % Encontrar el índice correspondiente en el vector de probabilidades acumuladas
        j = find(prob_acumuladas >= r, 1, 'first') + parada;
        
        pax(j) = pax(j) + 1;
    end
end

