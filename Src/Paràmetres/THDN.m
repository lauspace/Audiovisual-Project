%% Generaci� del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freq�encia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freq�encia en Hz 
Fd = F*duration;                 % Freq��ncia per la duraci�
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = sin(2*pi*n*(F/Fs))';         % Generaci� del sinus
s = 0.15*randn(1, Fs);           % Generaci� soroll
f0 = abs(fft(x));                % M�dul de la fft del sinus

% figure(1)
% plot(x)

%% Generaci� del senyal de sortida (amplituds modelables)

A1 = 0.9;
A2 = 0.5;
A3 = 0.3;
A4 = 0;

y = sin(2*pi*n*(Fd/Fs))' + A1*sin(2*pi*n*(2*Fd/Fs))' + A2*sin(2*pi*n*(3*Fd/Fs))' + A3*sin(2*pi*n*(4*Fd/Fs))' + A4*sin(2*pi*n*(5*Fd/Fs))' + s'; % Generaci� senyal de sortida D

% figure(2)
% plot(y)

%% C�lcul del valor absolut de la FFT

f = abs(fft(y));

% figure(3)
% plot(f)

%% C�lcul de la posici� de l'arm�nic principal

M = find(f>1000,1) - 1;

%% C�lcul de la pot�ncia del senyal menys l'armonic principal

fArm1 = f;
fSenseArm1 = f;

for i = 1:1:(M-5)
    fArm1(i) = 0;
end
for i = (M-5):1:(M+5)
    fSenseArm1(i) = 0;
end
for i = (M+5):1:(Fs-M-5)
    fArm1(i) = 0;
end
for i = (Fs-M-5):1:(Fs-M+5)
    fSenseArm1(i) = 0;
end
for i = (Fs-M+5):1:Fs-1
    fArm1(i) = 0;
end

a = ifft(fSenseArm1);
b = ifft(fArm1);

P = sum((abs(a)).^2)/Fs;
Pa = sum((abs(b)).^2)/Fs;

% figure
% plot(abs(fft(a)))
% figure
% plot(abs(fft(b)))

%% C�lcul THD + N

thdn = (P/Pa)*100;