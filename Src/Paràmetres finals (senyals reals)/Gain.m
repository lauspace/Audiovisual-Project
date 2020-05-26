%% Generació del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freqüència de Mostreig
duration     = 1.0; 

F = 1000;                        % Freqüència en Hz 
Fd = F*duration;                 % Freqüència per la duració
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = A*sin(2*pi*n*(Fd/Fs))';   % Generació del senyal d'entrada 
f0=abs(fft(x));

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

%% Calculem la fft de la senyal de sortida

f=abs(fft(signal(:,1)));

%% Busquem a quina posició (x) es troba el màxim

x_max = 1;

for i = 1:1:N/2
    if (f(i) > f(x_max))
        x_max = i;
    end
end

harmonics = x_max;                  % Vector amb les posicions dels harmònics
delta_x = round(x_max*0.2);
num_harm = round((N/2)/x_max);      % Càlcul del número d'harmònics generats

% Cerca de la posició de cada harmònic
for i = 2:1:num_harm
    hs = i*x_max;
    for j = (i*x_max-delta_x):1:(i*x_max+delta_x)
        if (f(j) > f(hs))
            hs = j;
        end
    end
    % Només agafem els harmònics amb una potència superior al 0.01%
    % respecte al principal
    if (f(hs)/f(x_max) > 0.01)
        harmonics(end+1) = hs;
    end
end

%% Calculem el guany
G = f(harmonics(1))/f0(F+1)
