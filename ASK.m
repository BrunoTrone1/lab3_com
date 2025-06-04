clear; clc; close all;

%% Parámetros
A = 1;             % Amplitud de la señal
Ac = 1;            % Amplitud de la portadora (para compatibilidad)
fs = 1000;         % Frecuencia de muestreo en Hz
T = 1/fs;          % Período de muestreo
t = 0:T:1-T;       % Vector de tiempo de 1 segundo

%% Señal de información m(t)
f1 = 5;            % Frecuencia componente 1 (Hz)
f2 = 20;           % Frecuencia componente 2 (Hz)
m_t = sin(2*pi*f1*t) + 0.5*cos(2*pi*f2*t); % Señal compuesta

%% Envoltura compleja g(t)
g_t = Ac * m_t;    % En este contexto, la envolvente es simplemente m(t) escalada

%% Transformada de Fourier
G_f = fft(g_t);
G_f_mag = abs(fftshift(G_f)); % Magnitud centrada
f = linspace(-fs/2, fs/2, length(G_f)); % Vector de frecuencias

%% Graficar señal en el tiempo
figure;
plot(t, m_t, 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Amplitud');
title('Señal de Información m(t)');
grid on;
xlim([0 1]);

%% Graficar espectro de frecuencia
figure;
plot(f, G_f_mag, 'r', 'LineWidth', 1.5);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Transformada de Fourier de la Envolvente Compleja g(t)');
grid on;
xlim([-100 100]); % Opcional: enfocar alrededor de las componentes útiles
