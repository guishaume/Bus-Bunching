function pax = embarque(Bus, Paradas, b)

    pasajeros_en_parada = Paradas.pasajeros(Bus.parada(b));
    parada = Bus.parada(b);
    N_paradas = Paradas.n;
    
    pax = zeros(N_paradas,1);
    for i = 1 : pasajeros_en_parada
        j = randi([parada+1, N_paradas]);
        pax(j) = pax(j) + 1;
    end
end

