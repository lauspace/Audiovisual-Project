%% Generació del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;                           % Freqüència de Mostreig
duration     = 1.0; 

F = 1000;                                       % Freqüència en Hz 
t = 0:(1/Fs):duration-(1/Fs);                   % Eix de temps
n = 0:1:duration*Fs-(1/Fs);                     % Vector n

it = 6;                                         % Número de sinus generats
freq = logspace(1.33, 4.4, it);                 % Vector de freqüències en logaritme (20 punts)
gain = linspace(0, 0, it);                      % Vector per guardar els valors del guany

%% Reproducció i grabació de la sinusoide a diferents freqüències

for j=1:it
    x = sin(2*pi*n*((freq(j)*duration)/Fs))'; 
    Pin = sum(abs(x).^2)/48000;                 % Potència de la señal x
    
    player = audioplayer(x, Fs, 16);           
    recorder = audiorecorder(Fs, 16, 2);        % 2 canals

    record(recorder,duration)                   % Començar la grabació
    playblocking(player);  

    stop(recorder)                              %Parar la grabacio
    signal = getaudiodata(recorder, 'double');  %Obtenim el senyal grabat
    [N,M]=size(signal);
    
    Pot = 0;
    s = 0;

    % Busquem l'amplitud mitja de les primeres mostres per establir un llindar a partir del
    % cual considerarem que comença la grabació
    for i = 1:1:100
        s = s + abs(signal(i,1));
    end
    s = s/100;
    
    count = 0;
    
    % Càlcul de la potència mitja del senyal
    for k = 1:1:N
        if signal(k) > 2*s
            Pot = Pot + abs(signal(k,1)).^2;
            count = count + 1;
        end
    end
    
    Pot = Pot/(N-count);
    
    % Càlcul del guany en dB
    gain(j) = 10*log10(Pot/Pin);             
  
end

%% Representació de la gràfica del guany en dB

semilogx(freq, gain, '-p');
title('Resposta freqüèncial');
ylabel('Guany(dB)');
grid on