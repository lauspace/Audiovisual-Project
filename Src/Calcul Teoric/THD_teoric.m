%% Generaci� del sinus de freq. 1KHz que tindrem a l'entrada

Fs           = 48000;            % Freq�encia de Mostreig
duration     = 1.0; 

F = 1000;                        % Freq�encia en Hz 
t = 0:(1/Fs):duration-(1/Fs);    % Eix de temps
n = 0:1:duration*Fs-(1/Fs);      % Vector n
x = sin(2*pi*n*(F/Fs))';         % Generaci� del sinus

% figure(1)
% plot(x)

%% Generaci� del senyal de sortida A

y1 = sin(2*pi*n*(F/Fs))' + sin(2*pi*n*(2*F/Fs))'; % Generaci� senyal de sortida A

% figure(2)
% plot(y1)

%% Generaci� del senyal de sortida B

y2 = sin(2*pi*n*(F/Fs))' + 0.5*sin(2*pi*n*(2*F/Fs))'; % Generaci� senyal de sortida B

% figure(3)
% plot(y2)


%% Generaci� del senyal de sortida C

y3 = sin(2*pi*n*(F/Fs))' + 0.75*sin(2*pi*n*(2*F/Fs))' + 0.5*sin(2*pi*n*(3*F/Fs))' + 0.25*sin(2*pi*n*(4*F/Fs))'; % Generaci� senyal de sortida B

% figure(4)
% plot(y3)

%% Plot de Periodogrames

p = periodogram(x);
p1 = periodogram(y1);
p2 = periodogram(y2);
p3 = periodogram(y3);

% t = tiledlayout(4,1);
% nexttile
% plot(p)
% nexttile
% plot(p1)
% nexttile
% plot(p2)
% nexttile
% plot(p3)

%% C�lcul del THD amb la fucni� de Matlab

THDa = (10^(thd(y1)/20))*100;
THDb = (10^(thd(y2)/20))*100;
THDc = (10^(thd(y3)/20))*100;