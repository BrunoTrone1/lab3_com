clear all; close all; clc;

%% Generar datos binarios aleatorios
numBits = 10;
data = randi([0 1], 1, numBits);
fprintf('Datos binarios: ');
disp(data);

%% Agrupar de a 2 bits y mapear a símbolos FSK (0,1,2,3)
symbols = zeros(1, numBits/2);
index = 0;
for i = 1:2:numBits
    index = index + 1;
    bits = data(i:i+1);
    if isequal(bits, [0 0])
        symbols(index) = 0;
    elseif isequal(bits, [0 1])
        symbols(index) = 1;
    elseif isequal(bits, [1 1])
        symbols(index) = 2;
    elseif isequal(bits, [1 0])
        symbols(index) = 3;
    end
end

%% Mostrar datos binarios con stairs
figure;
stairs(0:numBits-1, data, 'LineWidth', 2);
axis([0 numBits -0.5 1.5]);
xlabel('Tiempo (s)');
ylabel('Valor binario');
title(['Datos binarios: ', num2str(data)]);
grid on;

%% Definir señales FSK para cada símbolo
fs = 100; % Frecuencia de muestreo
Ts = 1/fs;
symbolDuration = 1; % Duración de cada símbolo (1 s)
t_symbol = 0:Ts:symbolDuration-Ts;

f1 = sin(2 * pi * 1 * t_symbol);   % para símbolo 0
f2 = sin(2 * pi * 4 * t_symbol);   % para símbolo 1
f3 = sin(2 * pi * 8 * t_symbol);   % para símbolo 2
f4 = sin(2 * pi * 16 * t_symbol);  % para símbolo 3

% Ensamblar señal FSK completa
fsk_signal = [];
for k = 1:length(symbols)
    switch symbols(k)
        case 0
            fsk_signal = [fsk_signal f1];
        case 1
            fsk_signal = [fsk_signal f2];
        case 2
            fsk_signal = [fsk_signal f3];
        case 3
            fsk_signal = [fsk_signal f4];
    end
end

%% Graficar la señal FSK en el tiempo
figure;
t_total = 0:Ts:Ts*length(fsk_signal)-Ts;
plot(t_total, fsk_signal, 'b');
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal FSK generada');
grid on;

%% Transformada de Fourier (FFT)
N = length(fsk_signal);
frequencies = linspace(-fs/2, fs/2, N);
G_FSK = fft(fsk_signal);
G_shifted = fftshift(abs(G_FSK));

figure;
plot(frequencies, G_shifted, 'r', 'LineWidth', 1.5);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Transformada de Fourier de la señal FSK');
grid on;
