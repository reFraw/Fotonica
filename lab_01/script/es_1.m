%% ESERCITAZIONE 1 - 05 apr 2023 - Spettroscopia UV-Vis

%% Inizializzazione

clear all
close all force
clc

%% Caricamento dati

dataset_path = "C:\Users\fabra\Desktop\Misc\esercitazioni_fotonica\es_1_spettroscopia_uv-vis\data\laboratorio _050423.xlsx";

    % Dati per l'interpolazione

        for i = 1 : 7
            data = xlsread(dataset_path, i, "C1:D1321");
            A_calib(:, i) = data(:,2); 
        end

    % Dati del campione incognito

    A_unknow = xlsread(dataset_path, 8, "C4:C1324");

    wavelength = data(:, 1);

%% Plot Assorbanza - Lunghezza d'onda

figure

for i = 1 : 7
    plot(wavelength, A_calib(: ,i));
    hold on
end

plot(wavelength, A_unknow, LineWidth=2);

xlabel("Lunghezza d'onda \lambda [nm]");
ylabel("Assorbanza A [A.U.]");
legend("0 \mug/ml", "16 \mug/ml", "32 \mug/ml", "40 \mug/ml", "48 \mug/ml", "64 \mug/ml", "80 \mug/ml", "Campione incognito");
set(gca, "Xlim", [185, 855]);
grid on;

%% Calcolo della lunghezza d'onda con assorbanza massima

for i = 1 : 7
    [maxx(i), idx(i)] = max(A_calib(:,i));
end

[max_unknow, idx_unknow] = max(A_unknow);

%% Calcolo del polinomio interpolante Concentrazione-Assorbanza

concentrations = [0, 16, 32, 40, 48, 64, 80];

p_direct = polyfit(concentrations, maxx, 1);

%% Calcolo del polinomio interpolante Assorbanza-Concentrazione

p_inv = polyfit(maxx, concentrations, 1);
result = polyval(p_inv, max_unknow);

%% Plot della retta di calibrazione

concentrations_2 = linspace(0, 100, 100000);
fit = polyval(p_direct, concentrations_2);

figure
plot(concentrations_2, fit, '-r');
hold on
plot(concentrations, maxx, 'ok');
plot(result, max_unknow, '+', Color='b', LineWidth=1.5)
xlabel("Concentrazione C [\mug/ml]");
ylabel("Assorbanza A [A.U.]");
title("Curva di calibrazione");
legend("Retta interpolante", "Valori sperimentali");

grid on
set(gca, "Xlim", [50, 75])














