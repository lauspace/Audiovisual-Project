%% Generaci� de la sinusoide de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freq��ncia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freq��ncia en Hz 
Fd = F*duration;                 % Freq��ncia per la duraci�
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = sin(2*pi*n*(Fd/Fs))';        % Generaci� del sinus
f0 = abs(fft(x));                % M�dul de la fft del sinus

%% Reproducci� i grabaci� de la sinusoide
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

%% C�lcul del valor absolut de la FFT

f = abs(fft(signal));

figure(1)
subplot(2,1,1);plot(t,signal); grid;title('Signal') ;xlabel('Time in seconds');ylabel('Normalized Amplitude');
subplot(2,1,2);plot(n,f); grid;title('FFT');

%% C�lcul de la posici� dels harm�nics

x_max = 1;

% Busquem a quina posici� (x) es troba el m�xim
for i = 1:1:N/2
    if (f(i) > f(x_max))
        x_max = i;
    end
end

harmonics = x_max;                  % Vector amb les posicions dels harm�nics
delta_x = round(x_max*0.2);
num_harm = fix((N/2)/x_max);        % C�lcul del n�mero d'harm�nics generats

% Cerca de la posici� de cada harm�nic
for i = 2:1:num_harm
    hs = i*x_max;
    for j = (i*x_max-delta_x):1:(i*x_max+delta_x)
        if (f(j) > f(hs))
            hs = j;
        end
    end
    % Nom�s agafem els harm�nics amb una pot�ncia superior al 0.01%
    % respecte al principal
    if (f(hs)/f(x_max) > 0.01)
        harmonics(end+1) = hs;
    end
end

%% C�lcul THD

num = 0;
[m,n] = size(harmonics);

% C�lcul de la pot�ncia dels harm�nics secund�ris
for i = 2:1:n
    num = num + (f(harmonics(i)))^2;
end

thd = (sqrt(num)/f(harmonics(1)))*100;