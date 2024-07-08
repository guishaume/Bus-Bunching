function t = tiempo_parado(Bus,Paradas,emb, desemb, b)

    pasajeros_en_bus = Bus.pasajeros(b,Bus.parada(b));
    pasajeros_en_parada = Paradas.pasajeros(Bus.parada(b));
    
    
    t1 = pasajeros_en_parada*emb;
    t2 = pasajeros_en_bus*desemb;
    t = max(t1,t2)+1;
end

