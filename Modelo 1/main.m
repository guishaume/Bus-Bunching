clear all

t = 1; %Tiempo de la simulacion
tmax = 35*60; % Tiempo maximo de la simulacion en segundos
Bus.salidas = 1:7*60:tmax; % Frecuencia de salidas de los buses
Paradas.n = 5; %Numero de paradas en el recorrido 
Paradas.pos = 1:400:400*Paradas.n; %Posicion de las paradas
Bus.n = 5; %Numero de buses en la linea

Bus.v = zeros(Bus.n,1); %Velocidad de cada autobus
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

tiempo_en_parada_medio = 50; %Tiempo que se queda cada autobus en cada parada

p = zeros(tmax,Bus.n); %Posicion de los buses en cada instante de tiempo

while t <= tmax
    for b = 1:Bus.n
        
        if t == Bus.salidas(b)
            p(t,b)=1;
            Bus.estado(b) = 1;
            Parada.estado(1) = 1;
            
            %Tiempo a esperar en la parada
            Bus.tparada(b) = t + tiempo_en_parada_medio;
            
        end
        
        if Bus.estado(b) == 1
            
            if(t > 1)
                p(t,b) = p(t-1,b);
            end
            
            if Bus.tparada(b) == t
                if b > 1 && Bus.estado(b-1) == 1 && Bus.parada(b) == Bus.parada(b-1) %Dos o mas buses en la misma parada
                    Bus.tparada(b) = t + 1;
                else
                    Paradas.estado(Bus.parada(b)) =  Paradas.estado(Bus.parada(b)) - 1;
                    Bus.parada(b) = Bus.parada(b) + 1;
                    Bus.estado(b) = 2;
                end
                if Bus.parada(b) > Paradas.n
                    Bus.estado(b) = 3;
                end
            end
            
        end
        
        if Bus.estado(b) == 2
            
            %Movimiento del autobus
            p(t,b) = p(t-1,b) + Bus.vmax;
            
            if p(t,b) >= Paradas.pos(Bus.parada(b))
                
                p(t,b) = Paradas.pos(Bus.parada(b));
                Bus.estado(b) = 1;
                Bus.v(b) = 0;
                
                %Tiempo a esperar en la parada
                Bus.tparada(b) = t + tiempo_en_parada_medio;
                Paradas.estado(Bus.parada(b)) = Paradas.estado(Bus.parada(b)) + 1;
            end
            
        end
        
        if Bus.estado(b) == 3
            p(t,b) = p(t-1,b);
        end
         
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