function pasajeros = nuevos_pasajeros(H,Bus,Paradas,t,lamb)
    
    estado_bus = Bus.estado;
    estado_parada = Paradas.estado;
    parada_bus = Bus.parada;
    
    [N_buses,N_paradas] = size(H);
    pasajeros = zeros(N_paradas,1);
    
    for i = 1:N_buses
        for j = parada_bus(i):N_paradas-1
            if estado_parada(j) < 1 && estado_bus(i) == 2 && H(i,j) < 400 + t
                pasajeros(j) = poissrnd(lamb);
            end
        end
    end
    
end

