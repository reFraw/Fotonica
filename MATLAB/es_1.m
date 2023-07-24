%% ESERCITAZIONE 1 - 05 apr 2023 - Spettroscopia di assorbimento UV-Vis

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

% Lunghezze d'onda analizzate
wavelength = data(:, 1);

%% Preprocessing dati
% Obbiettivo --> Rimuovere il reference da ogni spettro
for i = 2 : length(A_calib(1, :))
    A_calib(:,i) = A_calib(:,i) - A_calib(:,1);
end

A_unknow = A_unknow - A_calib(:,1);


%% Plot degli spettri di assorbimento
% Obbiettivo --> Individuare le lunghezze d'onda su cui effettuare l'analisi
figure
for i = 1 : length(A_calib(1,:))
    plot(wavelength, A_calib(:,i));
    hold on
end
plot(wavelength, A_unknow, LineWidth=1.5, LineStyle="-.");
xline(233, LineWidth=1.7, LineStyle="--");
xline(253, LineWidth=1.7, LineStyle="--");
xline(291, LineWidth=1.7, LineStyle="--");
xline(490, LineWidth=1.7, LineStyle="--");

xlim([min(wavelength), max(wavelength)]);
xlabel("Lunghezza d'onda \lambda [nm]");
ylabel("Assorbanza A [U.A.]");
title("Spettro di assorbimento della doxorubicina a differenti concentrazioni");
legend("0 \mug/ml", "16 \mug/ml", "32 \mug/ml","40 \mug/ml", "48 \mug/ml", "64 \mug/ml", "80 \mug/ml", "Incognita");
grid on

%% Determinazione delle assorbanze massime per diverse lambda

% Lambda_1 --> 233 nm
% Lambda_2 --> 253 nm
% Lambda_3 --> 291 nm
% Lambda_4 --> 490 nm

lambda_1_idx = 87;
lambda_2_idx = 127;
lambda_3_idx = 203;
lambda_4_idx = 601;

lambda_idxs = [lambda_1_idx, lambda_2_idx, lambda_3_idx, lambda_4_idx];

max_matrix = [];
max_unknow = [];

for i = 1 : length(A_calib(1,:))
    max_value = [];
    for j = 1 : length(lambda_idxs)
        subdomain = A_calib(lambda_idxs(j)-10 : lambda_idxs(j)+10, i);
        maxx = max(subdomain);
        max_value(end+1) = maxx;
    end
    max_matrix(i,:) = max_value;
end

for i = 1 : length(lambda_idxs)
    subdomain = A_unknow(lambda_idxs(i)-10 : lambda_idxs(i)+10);
    maxx = max(subdomain);
    max_unknow(end+1) = maxx;
end

%% Determinazione dei polinomi interpolanti
C_calib = [0, 16, 32, 40, 48, 64, 80];
C_fit = linspace(0, 90, 1e5);

p_fit = [];

for i = 1 : length(max_matrix(1,:))
    p1 = polyfit(C_calib, max_matrix(:,i), 1);
    p_fit(:,i) = p1;
end

%% Plot delle rette di calibrazione
figure 
for i = 1 : length(p_fit(1,:))
    plot(C_fit, polyval(p_fit(:,i), C_fit));
    hold on
end

for i = 1 : length(max_matrix(1,:))
    plot(C_calib, max_matrix(:,i), 'ok', MarkerFaceColor='k', MarkerSize=3);
end

legend("\lambda_1 = 233 nm | A=0.033\cdotC+0.106 | R^2=0.984", ...
    "\lambda_2 = 253 nm | A=0.023\cdotC+0.040 | R^2=0.999", ...
    "\lambda_3 = 291 nm | A=0.090\cdotC+0.008 | R^2=1", ...
    "\lambda_4 = 490 nm | A=0.012\cdotC+0.012 | R^2=1");

xlabel("Concentrazione C [\mug/ml]");
ylabel("Assorbanza A [U.A.]");
title("Rette di calibrazione");
grid on;

%% Calcolo dei polinomi inversi per la determinazione della concentrazione incognita
p_fit_inv = [];

for i = 1 : length(max_matrix(1,:))
    p1_inv = polyfit(max_matrix(:,i), C_calib, 1);
    p_fit_inv(:,i) = p1_inv;
end

figure
plot(C_fit, polyval(p_fit(:,3), C_fit), "-r");
hold on
plot(C_calib, max_matrix(:,3), 'ok', MarkerFaceColor='k', MarkerSize=3);
plot(60.9497, max_unknow(3), '+b', MarkerSize=13);
xlim([50 70])
xlabel("Concentrazione C [\mug/ml]");
ylabel("Assorbanza A [U.A.]");
title("Concentrazione incognita diluita");
legend("Retta di calibrazione (\lambda=291 nm)", ...
    "Misura sperimentale", ...
    "Concentrazione incognita");
grid on

%% Determinazione della concentrazione incognita
results = zeros(1,4);

for i = 1 : length(p_fit_inv(1,:))
    m = max_unknow(i);
    p = p_fit_inv(:,i);
    r = polyval(p, m);
    results(i) = r;
end

best_results = results(2:end);
best_results = 5000.*best_results;
best_results = mean(best_results);

fprintf(">> Concentrazione incognita --> %d [g/ml]\n\n", best_results/1e6);











   















