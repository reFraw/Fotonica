%% ESERCITAZIONE 2 - XX apr 2023 - Spettrofotometria a fluorescenza
%% Inizializzazione
clear all
close all force
clc

%% Caricamento dati
%--->> ASSORBANZA E FLUORESCENZA 
abs_path = "C:\Users\bened\OneDrive\Desktop\ES.2\assorbanze.xlsx";
fluo_path = "C:\Users\bened\OneDrive\Desktop\ES.2\fluorescenze.xlsx";
ref_path = "C:\Users\bened\OneDrive\Desktop\ES.2\DH_46_4microsecondi.xlsx";


%--->> ASSORBANZA CONCENTRAZIONI NOTE E PER LA CONCENTRAZIONE INCOGNITA
abs_calib = xlsread(abs_path, 1, "B7:E1618");
abs_unknow = xlsread(abs_path, 1, "F7:H1618");
%--->> FLUORESCENZA CONCENTRAZIONI NOTE E PER LA CONCENTRAZIONE INCOGNITA
fluo_calib = xlsread(fluo_path, 1, "C7:F1618");
fluo_unknow = xlsread(fluo_path, 1, "G7:I1618");


dark = xlsread(fluo_path, 1, "B7:B1618");
ref = xlsread(ref_path, 1, "B7:B1618");

wavelength = xlsread(abs_path, 1, "A7:A1618");

%% Plot spettro sostanza incognita
% Calcolo della media e deviazione standard per le tre misure della
% concentrazione incognita
abs_mean_unknow = zeros(size(abs_unknow(:,1)));
abs_std_unknow = zeros(size(abs_unknow(:,1)));

for i = 1 : length(abs_unknow(:, 1))
    abs_mean_unknow(i) = mean(abs_unknow(i,:));
    abs_std_unknow(i) = std(abs_unknow(i,:));
end

figure
plot(wavelength, abs_mean_unknow, '-r');
hold on
plot(wavelength, abs_mean_unknow - abs_std_unknow, '--b');
plot(wavelength, abs_mean_unknow + abs_std_unknow, '--b');
grid on

set(gca, "Xlim", [min(wavelength) - 5, max(wavelength) + 5]);
title("Spettro della concentrazione Incognita");
xlabel("Lunghezza d'onda");
ylabel("Absorbance A [A.U.]");
legend("Spettro medio", "Spettro medio - \sigma", "Spettro medio + \sigma");

%% Plot spettri di assorbimento per calibrazione

figure

for i = 1 : length(abs_calib(1, :))
    plot(wavelength, abs_calib(:, i),LineWidth=0.8);
    hold on
end

plot(wavelength, abs_mean_unknow, '--', LineWidth=1);
set(gca, "Xlim", [min(wavelength) - 5, max(wavelength) + 5]);

legend("A5", "A10", "A20", "A30","Concentrazione incognita");
xlabel("Wavelength \lambda [nm]");
ylabel("Absorbance A [A.U.]");
title("Spectrum");
grid on


%% Calcolo retta di calibrazione per assorbanza
% Range per il calcolo delle rette di calibrazione
indici_wavelength=[113 126 169 175 281 284 563 573];
figure

% Concentrazioni
concentrations = [5, 10, 20, 30]; % M = mol/L
concentrations_1 = 0 : 0.00001 : 40;
sostanza_incognita= [];

for j=1:2:length(indici_wavelength)
    for i = 1 : length(abs_calib(1, :))
        [maxx(i), idx(i)] = max(abs_calib(indici_wavelength(j):indici_wavelength(j+1),i));
    end

    p = polyfit(concentrations, maxx, 1);
    abs_fitted = polyval(p, concentrations_1);
    
    plot(concentrations, maxx,"ok", MarkerFaceColor="k", MarkerSize=3);
    hold on
    plot(concentrations_1, abs_fitted, LineWidth=0.8);

    %---> Calcolo della concentrazione incognita 
    [max_unknow, idx_unknow] = max(abs_mean_unknow(indici_wavelength(j):indici_wavelength(j+1)));

    p_inv = polyfit(maxx, concentrations, 1);
    result= polyval(p_inv, max_unknow)

    sostanza_incognita= [sostanza_incognita; result];

end

grid on

title("Rette di calibrazione");
xlabel("Concentrazione C [\mu\cdotM]");
ylabel("Absorbance A [A.U.]");
legend("", "\lambda_1= 240 nm    A= 0.0345 C + 0.5461; R^2= 0.827;","", "\lambda_2= 280 nm    A= 0.04367 C + 0.0426; R^2= 0.993;","", "\lambda_3= 345 nm    A= 0.0301 C + 4.79e-4; R^2= 0.999;","", "\lambda_4= 515 nm    A = 0.166 C + 0.642; R^2= 0.862;");

%% Spettro sostanza incognita
fluo_mean_unknow = zeros(size(fluo_unknow(:,1)));
fluo_std_unknow = zeros(size(fluo_unknow(:,1)));

for i=1: length(fluo_unknow(1,:))
    fluo_unknow(:,i)=fluo_unknow(:,i)-dark;
end

for i = 1 : length(fluo_unknow(:, 1))
    fluo_mean_unknow(i) = mean(fluo_unknow(i,:));
    fluo_std_unknow(i) = std(fluo_unknow(i,:));
end

[max_unknow_fluo, idx_unknow_fluo] = max(fluo_mean_unknow);

%% Plot spettri di emissione per calibrazione
figure

for i = 1 : length(fluo_calib(1,:))
    %---> Eliminiamo il valore dark da tutte le misure di fluorescenza
    fluo_calib(:, i)= fluo_calib(:, i)- dark;
    plot(wavelength, fluo_calib(:, i));
    hold on
end

plot(wavelength, dark);
plot(wavelength, fluo_mean_unknow,'--', LineWidth=1);

set(gca, "Xlim", [min(wavelength) - 5, max(wavelength) + 5]);

legend("A5", "A10", "A20", "A30", "DARK",'AX');
xlabel("Wavelength \lambda [nm]");
ylabel("Intensity I [counts/\mu\cdotW]");
title("Spectrum");
grid on


%% Calcolo retta di calibrazione per emissione
% ---> Calcolo del valore massimo per l'emittanza sulle concentrazione note
for i = 1 : length(fluo_calib(1, :))
    [maxx_fluo(i), idx_fluo(i)] = max(fluo_calib(604:661,i));
end
% ---> Calcolo del valore massimo per l'emittanza sul dark 
maxx_fluo=[maxx_fluo max(dark(604:661))];

concentrations=[concentrations 0];

% Costruzione retta di calibrazione
p1 = polyfit(concentrations, maxx_fluo, 3);
retta_calib=polyval(p1, concentrations_1);

figure

plot(concentrations, maxx_fluo, 'ok', MarkerFaceColor='k', MarkerSize=3);
hold on
plot(concentrations_1, retta_calib, '-r', LineWidth=1);
grid on

title("Curva di calibrazione");
xlabel("Concentrazione C [\mu\cdotM]");
ylabel("Intensity I[counts/\mu\cdotW]");
legend("Valori sperimentali", "Retta di calibrazione");


%% Calcolo sostanza incognita

p1_inv = polyfit(maxx_fluo, concentrations, 3);
result_1 = polyval(p1_inv, max_unknow_fluo)


%% Plot spettro di emissione e assorbanza
figure
plot(wavelength, abs_mean_unknow.*10^4, '-r');
hold on
plot(wavelength, fluo_mean_unknow, '-b');
set(gca, "Xlim", [min(wavelength) - 5, max(wavelength) + 5]);
grid on

title("Spettri di assorbimento ed emissione per concentrazione incognita")
legend("Spettro di assorbimento", "Spettro di emissione");
xlabel("Lunghezza d'onda");
ylabel("Assorbanza A / Intensity I");

fprintf('Risultato assorbanza %d\n', sostanza_incognita(3));
fprintf('Risultato emissione %d', result_1);



















