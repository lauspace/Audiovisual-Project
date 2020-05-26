%% Generació del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freqüència de Mostreig
duration     = 1.0; 

F = 1000;                        % Freqüència en Hz 
Fd = F*duration;                 % Freqüència per la duració
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = A*sin(2*pi*n*(Fd/Fs))';   % Generació del senyal d'entrada

%% Reproducció i grabació de les sinusoides
% Inicialitzem els objectes player i recorder
player   = audioplayer(x, Fs, 16);           
recorder = audiorecorder(Fs, 16, 2);  

% Començem la grabació i bloquejem Matlab fins al final d'aquesta
record(recorder,duration)              
playblocking(player);  

% Parem la grabació i guardem el senyal obtingut i les seves mides
stop(recorder)   
signal = getaudiodata(recorder, 'double');
[N,M] = size(signal);
figure(2)
plot(signal(:,1));

%% Calculem la potencia

s = 0;
Pot = 0;
% Busquem l'amplitud mitja de les primeres mostres per establir un llindar a partir del
% cual considerarem que comença la grabació
for i = 1:1:1000                             
    s = s + abs(signal(i,1));
end

s = s/1000;

% Càlcul de la potència mitja del senyal
for j = 1000:N
    if(abs(signal(j,1))>2*s)
        Pot = Pot + abs(signal(j,1)).^2;
    end
end

%% Càlcul potencia

Pot = Pot/(N-1000)