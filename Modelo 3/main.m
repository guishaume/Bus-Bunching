clear all

t = 1; %Tiempo de la simulacion
tmax = 90*60; % Tiempo maximo de la simulacion en segundos
Bus.salidas = 1:7*60:tmax; % Frecuencia de salidas de los buses
Paradas.n = 15; %Numero de paradas en el recorrido 
Paradas.pos = 1:400:400*Paradas.n; %Posicion de las paradas
% Paradas.pos = [1, 270, 500, 1000, 1400, 1700, 1900, 2200, 2400, 2700, 3100, 3700, 4200, 4500, 4800];
Bus.n = 10; %Numero de buses en la linea

ti = transpose(1:tmax);
vmax = 10; % 36km/h
vmin = 5; % 25 km/h
Bus.v = (4/tmax^2)*(vmax-vmin)*ti.^2-(4/tmax)*(vmax-vmin)*ti+vmax;
v = @(t) (4/tmax^2)*(vmax-vmin)*t.^2-(4/tmax)*(vmax-vmin)*t+vmax;
Bus.vi = zeros(Bus.n,1);
Bus.vmax = 10; %Velocidad maxima de la ruta
Bus.a = 2; %Aceleracion del autobus

Bus.estado = zeros(Bus.n,1); 
%Si es 0, no ha empezado el servicio
%Si es 1, esta parado
%Si es 2, se esta moviendo
%Si es 3, ya no circula

Paradas.estado = zeros(Paradas.n,1);
%Si es 0, no hay autobus en la parada
%Si es 1, hay algun autobus en la parada

Bus.tparada = ones(Bus.n,1)*tmax; %Tiempo programado para el siguiente estado

Bus.parada = ones(Bus.n,1); %Parada en la que se encuentra cada autobus

tiempo_en_parada_medio = 80; %Tiempo que se queda cada autobus en cada parada
Paradas.pasajeros = zeros(Paradas.n,1);
Bus.pasajeros = zeros(Bus.n, Paradas.n);

emb = 5; %Tiempo de embarque para cada pasajero
desemb = 2; %Tiempo de desembarque para cada pasajero

lambd = 2;
% lambda = [1; 1; 1; 3; 1; 2; 1; 2; 2.5; 2; 2; 3; 2; 1; 1; 1.3; 1; 0.5; 0.3; 0.1];
% lambda = [0.6; 1; 2; 1; 2; 3.3; 2; 3; 2; 1; 1.3; 1; 0.5; 0.3; 0.1];
% lambda = [3; 2.2; 2; 1; 1; 1; 0.5; 0.8; 1; 1.2; 1; 1; 2; 2.5; 3.2];
% lambda = [1; 1; 1; 1; 5; 1; 1; 1; 1; 5; 1; 1; 1; 1; 1];
lambda = [0.6; 1; 1.3; 2; 1.4; 2; 3; 2; 2.4; 4; 2; 3; 1.5; 0.4; 0.1];
p = zeros(tmax,Bus.n); %Posicion de los buses en cada instante de tiempo

H = horario(Bus, Paradas);

while t <= tmax
    for b = 1:Bus.n
        
        if t == Bus.salidas(b)
            p(t,b)=1;
            Bus.estado(b) = 1;
            Paradas.estado(1) = 1;
            
            %Tiempo a esperar en la parada
            Bus.tparada(b) = t + tiempo_en_parada_medio;
            
        end
        
        if Bus.estado(b) == 1
            
            if(t > 1)
                p(t,b) = p(t-1,b);
            end
            
            if Bus.tparada(b) == t
                if b > 1 && Bus.estado(b-1) == 1 && p(t,b) == p(t,b-1) %Dos o mas buses en la misma parada
                    Bus.tparada(b) = t + 1;
                else
                    Paradas.estado(Bus.parada(b)) =  Paradas.estado(Bus.parada(b)) - 1;
                    Bus.parada(b) = Bus.parada(b) + 1;
                    Bus.estado(b) = 2;
%                     Bus.vi(b) = Bus.v(t);
                    Bus.vi(b) = v(t);
                end
                if Bus.parada(b) > Paradas.n
                    Bus.estado(b) = 3;
                end
            end
            
        end
        
        if Bus.estado(b) == 2
            
            %Movimiento del autobus
            p(t,b) = p(t-1,b) + Bus.vi(b);
            
            if p(t,b) >= Paradas.pos(Bus.parada(b))
                
                p(t,b) = Paradas.pos(Bus.parada(b));
                Bus.estado(b) = 1;
                
                %Tiempo a esperar en la parada
                Bus.pasajeros(b,:) = Bus.pasajeros(b,:) + embarque(Bus, Paradas, b, lambda)';
                Bus.tparada(b) = t + tiempo_parado(Bus, Paradas ,emb, desemb, b);
                Paradas.pasajeros(Bus.parada(b)) = 0;
                Paradas.estado(Bus.parada(b)) = Paradas.estado(Bus.parada(b)) + 1;
            end
            
        end
        
        if Bus.estado(b) == 3
            p(t,b) = p(t-1,b);
        end
         
    end
    
    if mod(t,60) == 0
        Paradas.pasajeros = Paradas.pasajeros + nuevos_pasajeros(H,Bus,Paradas,t,lambda);
    end
    
    t = t + 1;
end

figure;
plot(p)
hold on
for i = 1:Paradas.n
    plot([1 tmax],[Paradas.pos(i) Paradas.pos(i)],':', 'Color', [.7 .7 .7]);
    
end
title("Evolución de la posición de los autobuses", 'FontSize', 15);
xlabel("Tiempo (s)",'FontSize', 12);
ylabel("Posición (m)",'FontSize', 12);