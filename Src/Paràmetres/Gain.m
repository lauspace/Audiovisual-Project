%% Generaci� del sinus de freq. 1KHz que tindrem a l'entrada
Fs           = 48000;            % Freq��ncia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freq��ncia en Hz 
Fd = F*duration;                 % Freq��ncia per la duraci�
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n

Pot = 0;                         % Pot�ncia

x = sin(2*pi*n*(Fd/Fs))';        % Generaci� del senyal d'entrada

Pin = sum(abs(x).^2)/48000;      %Potencia del senyal d'entrada

%% Reproducci� i grabaci� de les sinusoides
% Inicialitzem els objectes player i recorder
player   = audioplayer(x, Fs, 16);           
recorder = audiorecorder(Fs, 16, 2);  

% Comen�em la grabaci� i bloquejem Matlab fins al final d'aquesta
record(recorder,duration)              
playblocking(player);  

% Parem la grabaci� i guardem el senyal obtingut i les seves mides
stop(recorder)   
signal = getaudiodata(recorder, 'double');
[N,M] = size(signal);

%% Obtenim la pot�ncia mitjana del senyal tenint en compte el retard generat

s = 0;

% Busquem l'amplitud mitja de les primeres mostres per establir un llindar a partir del
% cual considerarem que comen�a la grabaci�
for i = 1:1:100                             
    s = s + abs(signal(i,1));
end
s = s/100;
count = 0;

% C�lcul de la pot�ncia mitja del senyal
for j = 1:1:N
    if signal(j) > 2*s
        Pot = Pot + abs(signal(j,1)).^2;
        count = count + 1;
    end
end
Pot=Pot/(N-count);

%% Calculem el guany

guany = Pot/Pin;