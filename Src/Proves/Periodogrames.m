%% Càlcul THD

clear all;

t = 0:0.001:1-0.001; 
x = 2*cos(2*pi*100*t)+0.01*cos(2*pi*200*t)+0.005*cos(2*pi*300*t);
thd = 10*log10((0.01^2+0.005^2)/2^2);
plot(x);

%% Periodograma audio "Hola"

clear all;

[y,fs] = audioread("per.wav");

dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;
plot(t,y); xlabel('Seconds'); ylabel('Amplitude');
figure
plot(periodogram(y));

%% Periodograma audio "Hola" més soroll random

clear all;

[y,fs] = audioread("per.wav");

dt = 1/fs;
t = 0:dt:(length(y)*dt)-dt;
%plot(t,y); xlabel('Seconds'); ylabel('Amplitude');
n = randn(size(y));
figure
plot(periodogram(0.1*n));
y = y + 0.1*n;
figure
plot(periodogram(y));

%% Periodograma Gong

clear all;
load gong;
whos

figure
plot(periodogram(y))

%% Periodograma sinus

clear all;

Fs           = 48000;            % Sampling Rate (check with your computer/sound board doc)
duration     = 1.0; 

F = 440;                         % Frequency in Hz. 
t = 0:(1/Fs):duration-(1/Fs);    % Axis time.
n = 0:1:duration*Fs-(1/Fs);      % Index vector.
x = sin(2*pi*n*(F/Fs))'; 

plot(periodogram(x));

%% Periodograma Chirp

clear all;

Fs           = 48000;   % Sample Rate in Mac only 44100 Hz is allowed;
duration     = 10;      % Records duration time in seconds;
Nbits        = 16;      % Number of bits of A/D D/A converters;

F       = 20000;                         % Max. Frequency modulation in Hertz;
samples = duration*Fs;
fmi     = (0:1:samples-1)'./(samples-1); % Vector for frequecy modulation
x       = pi*(F/Fs)*(0:samples-1)';
y       = sin(x.*fmi);                   % Generate Chirp

plot(periodogram(y));
