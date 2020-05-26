%% Generació del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;                           % Freqüència de Mostreig
duration     = 1.0; 

F = 1000;                                       % Freqüència en Hz 
t = 0:(1/Fs):duration-(1/Fs);                   % Eix de temps
n = 0:1:duration*Fs-(1/Fs);                     % Vector n

fMin = log10(2);
fMax = log10(4.3);
nSinusoids = 6;

freq = logspace(fMin, fMax, nSinusoids);                 % Vector de freqüències en logaritme (20 punts)
gain = linspace(0, 0, nSinusoids);                      % Vector per guardar els valors del guany

%% Reproducció i grabació de la sinusoide a diferents freqüències

for j=1:nSinusoids
    
    x = 2*sin(2*pi*n*((freq(j)*duration)/Fs))'; 
    f0 = abs(fft(x));  

    x_max_in = 1;

    for r = 1:1:Fs/2
        if (f0(r) > f0(x_max_in))
            x_max_in = r;
        end
    end

    harmonics_in = x_max_in;
    delta_x_in = round(x_max_in*0.2);
    num_harm_in = fix((Fs/2)/x_max_in);

    for r = 2:1:num_harm_in
        hs = r*x_max_in;
        for p = (r*x_max_in-delta_x_in):1:(r*x_max_in+delta_x_in)
            if (f0(p) > f0(hs))
                hs = p;
            end
        end
        if (f0(hs)/f0(x_max_in) > 0.01)
            harmonics_in(end+1) = hs;
        end
    end

    player = audioplayer(x, Fs, 16);           
    recorder = audiorecorder(Fs, 16, 2);

    record(recorder,duration)
    playblocking(player);  

    stop(recorder)                       
    signal = getaudiodata(recorder, 'double');
    [N,M]=size(signal);

    f=abs(fft(signal(:,1)));

    x_max_out = 1;

    for i = 1:1:N/2
        if (f(i) > f(x_max_out))
            x_max_out = i;
        end
    end

    harmonics_out = x_max_out;
    delta_x_out = round(x_max_out*0.2);
    num_harm_out = round((N/2)/x_max_out);

    for i = 2:1:num_harm_out
        hs = i*x_max_out;
        for k = (i*x_max_out-delta_x_out):1:(i*x_max_out+delta_x_out)
            if (f(k) > f(hs))
                hs = k;
            end
        end
        if (f(hs)/f(x_max_out) > 0.01)
            harmonics_out(end+1) = hs;
        end
    end
    
    % Càlcul del guany en dB
   
    gain(j) = 10*log10(f(harmonics_out(1))/f0(harmonics_in(1)));  
end

%% Representació de la gràfica del guany en dB

semilogx(freq, gain, '-p');
title('Resposta freqüèncial');
ylabel('Guany(dB)');
grid on