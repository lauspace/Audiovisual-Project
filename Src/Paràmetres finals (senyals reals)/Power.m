%% Generaci� del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freq��ncia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freq��ncia en Hz 
Fd = F*duration;                 % Freq��ncia per la duraci�
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = A*sin(2*pi*n*(Fd/Fs))';   % Generaci� del senyal d'entrada

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
figure(2)
plot(signal(:,1));

%% Calculem la potencia

s = 0;
Pot = 0;
% Busquem l'amplitud mitja de les primeres mostres per establir un llindar a partir del
% cual considerarem que comen�a la grabaci�
for i = 1:1:1000                             
    s = s + abs(signal(i,1));
end

s = s/1000;

% C�lcul de la pot�ncia mitja del senyal
for j = 1000:N
    if(abs(signal(j,1))>2*s)
        Pot = Pot + abs(signal(j,1)).^2;
    end
end

%% C�lcul potencia

Pot = Pot/(N-1000)