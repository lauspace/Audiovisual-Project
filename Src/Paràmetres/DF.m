%% Generaci� del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freq�encia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freq�encia en Hz 
Fd = F*duration;                 % Freq��ncia per la duraci�
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = sin(2*pi*n*(Fd/Fs))';        % Generaci� del sinus
f0 = abs(fft(x));                % M�dul de la fft del sinus

% figure(1)
% plot(x)

%% Generaci� del senyal de sortida (amplituds modelables)

A1 = 0.75;
A2 = 0.6;
A3 = 0.4;
A4 = 0.2;

y = sin(2*pi*n*(Fd/Fs))' + A1*sin(2*pi*n*(2*Fd/Fs))' + A2*sin(2*pi*n*(3*Fd/Fs))' + A3*sin(2*pi*n*(4*Fd/Fs))' + A4*sin(2*pi*n*(5*Fd/Fs))'; % Generaci� senyal de sortida D

% figure(2)
% plot(y)

%% C�lcul del valor absolut de la FFT

f = abs(fft(y));

% figure(3)
% plot(f);

%% C�lcul de la posici� de l'arm�nic principal

M = find(f>1,1) - 1;

%% Factor de Distorsi�

fdd = sqrt((f(M+1))^2)/sqrt(((f(M+1))^2+(f(2*M+1))^2+(f(3*M+1))^2+(f(4*M+1))^2+(f(5*M+1))^2));