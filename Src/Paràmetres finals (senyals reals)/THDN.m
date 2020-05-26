%% Generació de la sinusoide de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freqüencia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freqüencia en Hz 
Fd = F*duration;                 % Freqüència per la duració
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = sin(2*pi*n*(F/Fs))';         % Generació del sinus
f0 = abs(fft(x));                % Módul de la fft del sinus

%% Reproducció i grabació de la sinusoide
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

%% Càlcul del valor absolut de la FFT

f = abs(fft(signal));

figure(1)
subplot(2,1,1);plot(t,signal); grid;title('Signal') ;xlabel('Time in seconds');ylabel('Normalized Amplitude');
subplot(2,1,2);plot(n,f); grid;title('FFT');

%% Càlcul de la posició de l'harmònic principal

x_max = 1;

% Busquem a quina posició (x) es troba el màxim
for i = 1:1:N/2
    if (f(i) > f(x_max))
        x_max = i;
    end
end

%% Càlcul de la potència del senyal sense l'harmonic principal

f_harm_prin = f(:,1);               % Senyal que conté l'harmonic principal
f_seny_sense_harm = f(:,1);         % Senyal sense l'harmonic principal

rang = round(0.1*x_max);

% Separem l'harmonic principal del senyal
for i = 1:1:(x_max - rang)
    f_harm_prin(i) = 0;
end
for i = (x_max - rang):1:(x_max + rang)
    f_seny_sense_harm(i) = 0;
end
for i = (x_max + rang):1:(Fs - x_max - rang)
    f_harm_prin(i) = 0;
end
for i = (Fs - x_max - rang):1:(Fs - x_max + rang)
    f_seny_sense_harm(i) = 0;
end
for i = (Fs - x_max + rang):1:Fs-1
    f_harm_prin(i) = 0;
end

% Transformada inversa dels senyals
a = ifft(f_seny_sense_harm);
b = ifft(f_harm_prin);

% Càlcul de la potència de cada senyal
P = sum((abs(a)).^2)/Fs;
Pa = sum((abs(b)).^2)/Fs;

figure(2)
subplot(2,1,1);plot(f_seny_sense_harm); grid;title('FFT') ;xlabel('Time in seconds');ylabel('Normalized Amplitude');
subplot(2,1,2);plot(f_har_prin); grid;title('FFT') ;xlabel('Time in seconds');ylabel('Normalized Amplitude');

%% Càlcul THD + N

thdn = (P/Pa)*100;