%% Generaci� de les sinusoides de freq. 1KHz i 1.5KHz que tindrem a l'entrada

Fs           = 48000;            % Freq��ncia de Mostreig
duration     = 1.0; 

F1 = 1000;                       % Freq��ncia 1 
F2 = 1800;                       % Freq��nica 2
Fd1 = F1*duration;               % Freq��ncia 1 per la duraci�
Fd2 = F2*duration;               % Freq��ncia 2 per la duraci�
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x1 = sin(2*pi*n*(F1/Fs))';       % Generaci� del sinus 1
x2 = sin(2*pi*n*(F2/Fs))';       % Generaci� del sinus 2
f01 = abs(fft(x1));              % M�dul de la fft del sinus 1
f02 = abs(fft(x2));              % M�dul de la fft del sinus 2
x = x1 + x2;                     % Generaci� del senyal d'entrada
f0 = abs(fft(x));                % M�dul de la fft del senyal d'entrada

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

%% C�lcul del valor absolut de la FFT

f = abs(fft(signal));

figure(1)
subplot(2,1,1);plot(t,signal); grid;title('Signal') ;xlabel('Time in seconds');ylabel('Normalized Amplitude');
subplot(2,1,2);plot(n,f); grid;title('FFT');

%% C�lcul de la posici� dels harm�nics principals

s = f;                      % C�pia del senyal per fer manipulacions

x_max_1 = 1;
x_max_2 = 1;

% C�lcul del primer m�xim
for i = 1:1:N/2
    if (s(i) > s(x_max_1))
        x_max_1 = i;
    end
end

rang = round(0.1*x_max_1);

% Valor del primer m�xim a zero per no generar problemes en la cerca del segon
for i = (x_max_1 - rang):1:(x_max_1 + rang)
    s(i) = 0;
end

% C�lcul del segon m�xim
for i = 1:1:N/2
    if (s(i) > s(x_max_2))
        x_max_2 = i;
    end
end

%% C�lcul de la posici� dels harm�nics secund�ris

harmonics = 1;

if (x_max_1 > x_max_2)
    max_absolut = x_max_1;
else
    max_absolut = x_max_2;
end

delta_x = round(((x_max_1+x_max_2)/2)*0.03);
harmonics(end+1) = x_max_1;
harmonics(end+1) = x_max_2;
ordre = 2;                              % Ordre de la intermod. a calcular
vec_aux = 0:ordre;

% Cerca de la posici� dels harm�nics secundaris
for i = -ordre:1:ordre
    for j = -ordre:1:ordre
        % Agafem nom�s els harmonics de l'ordre escollit
        if (abs(i) + abs(j) == ordre)
            pos = i*x_max_1 + j*x_max_2;
            if (pos > 0 && pos < (N/2))
                for k = (pos - delta_x):1:(pos + delta_x)
                    if (f(k) > f(pos))
                        pos = k;
                    end
                end  
                % Agafem nom�s els harm�nics amb una pot�ncia superior 
                % al 0.01% respecte al principal
                if (f(pos)/f(max_absolut) > 0.01)
                    harmonics(end+1) = pos;
                end
            end
        end
    end
end

%% C�lcul IMD

num = 0;
den = 0;
[m,n] = size(harmonics);

% C�lcul de la pot�ncia dels harm�nics secund�ris
for i = 3:1:n
    num = num + (f(harmonics(i)))^2;
end

% C�lcul de la pot�ncia dels harm�nics principals
for i = 1:1:2
    den = den + (f(harmonics(i)))^2;
end

imd = (sqrt(num)/sqrt(den))*100;