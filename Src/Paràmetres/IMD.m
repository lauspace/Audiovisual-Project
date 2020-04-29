%% Generació dels sinus de freq. 1KHz i 1.5KHz que tindrem a l'entrada

Fs           = 48000;            % Freqüència de Mostreig
duration     = 1.0; 

F1 = 1000;                       % Freqüència 1 
F2 = 1100;                       % Freqüènica 2
Fd1 = F1*duration;               % Freqüència 1 per la duració
Fd2 = F2*duration;               % Freqüència 2 per la duració
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x1 = sin(2*pi*n*(F1/Fs))';       % Generació del sinus 1
x2 = sin(2*pi*n*(F2/Fs))';       % Generació del sinus 2
f01 = abs(fft(x1));              % Módul de la fft del sinus 1
f02 = abs(fft(x2));              % Módul de la fft del sinus 2
x = x1 + x2;                     % Generació del senyal d'entrada
f0 = abs(fft(x));                % Módul de la fft del senyal d'entrada
 
% figure(1)
% plot(f0);

%% Generació dels armonics que trobarem a la sortida

% Segon ordre:
a21 = sin(2*pi*n*((F1+F2)/Fs))';
a22 = sin(2*pi*n*(2*F1/Fs))';
a23 = sin(2*pi*n*(2*F2/Fs))';

% Tercer ordre:
a31 = sin(2*pi*n*((2*F1-F2)/Fs))';
a32 = sin(2*pi*n*((2*F2-F1)/Fs))';
a33 = sin(2*pi*n*((3*F1)/Fs))';
a34 = sin(2*pi*n*((2*F1+F2)/Fs))';
a35 = sin(2*pi*n*((2*F2+F1)/Fs))';
a36 = sin(2*pi*n*((3*F2)/Fs))';


%% Generació del senyal de sortida (amplituds modificables)

A1 = 0.4;
A2 = 0.55;
A3 = 0.35;
A4 = 0.4;
A5 = 0.3;

y = x1 + x2 + A2*a21 + A3*a22 + A3*a23 + A1*a31 + A1*a32 + A5*a33 + A4*a34 + A4*a35 + A5*a36;

% figure(2)
% plot(y)

%% Càlcul del valor absolut de la FFT

f = abs(fft(y));

% figure(3)
% plot(f);

%% Càlcul dels màxims dels harmònics principals
s = f;                           % Còpia del valor absolut de la fft del senyal de sortida
M = find(s>1,5) - 1;             % Vector dels primers màxims relatius

M1 = 1;
M2 = 1;

% Càlcul del primer màxim
for i = 1:1:5
    if s(M(i)+1) > s(M1)
        M1 = M(i) + 1;
    end
end
s(M1) = 0;                        % Valor del primer màxim a zero per no generar problemes en la cerca del segon

% Càlcul del segon màxim
for i = 1:1:5
    if s(M(i) + 1) > s(M2)
        M2 = M(i) + 1;
    end
end

M1 = M1 - 1;
M2 = M2 - 1;

%% IMD

imd = (sqrt((f(M1+M2+1))^2+(f(2*M1+1))^2+(f(2*M2+1))^2+(f(2*M1-M2+1))^2+(f(2*M2-M1+1))^2+(f(3*M1+1))^2+(f(3*M2+1))^2+(f(2*M1+M2+1))^2+(f(2*M2+M1+1))^2)/sqrt((f(M1+1))^2+(f(M2+1))^2))*100;