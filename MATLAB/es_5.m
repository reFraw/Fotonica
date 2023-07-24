%% ESERCITAZIONE 5 - XX maggio 2023 - Saggio ELISA
%% Inizializzazione
clear all
close all force
clc

%% Caricamento dati
%--->> FLUORESCENZA 
fluo_path = "C:\Users\bened\OneDrive\Desktop\FOTONICA\Es_5_fotonica\letture fluorescenza.xlsx";

%--->> FLUORESCENZA CONCENTRAZIONI NOTE E PER LA CONCENTRAZIONE INCOGNITA
concentrations=xlsread(fluo_path, 1, "A3:A8");
fluo_calib1 = xlsread(fluo_path, 1, "B3:B8");
fluo_calib2 = xlsread(fluo_path, 1, "C3:C8");
fluo_calib3 = xlsread(fluo_path, 1, "D3:D8");
fluo_unknow = xlsread(fluo_path, 1, "B12:B13");


fluo=[fluo_calib1,fluo_calib2,fluo_calib3];
fluo_mean=mean(fluo');
%% Calcolo retta di calibrazione per assorbanza 1
concentrations_1=[0:10:1050];
sostanza_incognita1= [];
sostanza_incognita2= [];

p = polyfit(concentrations, fluo(:,1), 1);
abs_fitted = polyval(p, concentrations_1);

plot(concentrations, fluo(:,1),"ok", MarkerFaceColor="k", MarkerSize=3);
hold on
plot(concentrations_1, abs_fitted, LineWidth=0.8);

grid on

title("Rette di calibrazione");
xlabel("Concentrazione C [\mu\cdotM]");
ylabel("Absorbance A [A.U.]");

%---> Calcolo della concentrazione incognita 

p_inv = polyfit(fluo(:,1), concentrations, 1);
result= polyval(p_inv, fluo_unknow(1))
result2= polyval(p_inv, fluo_unknow(2))
 
sostanza_incognita1= [sostanza_incognita1; result];
sostanza_incognita2= [sostanza_incognita2; result2];

%% Calcolo retta di calibrazione per fluorescenza 2

p = polyfit(concentrations, fluo(:,2), 1);
abs_fitted = polyval(p, concentrations_1);

plot(concentrations, fluo(:,2),"ok", MarkerFaceColor="k", MarkerSize=3);
hold on
plot(concentrations_1, abs_fitted, LineWidth=0.8);

grid on

title("Rette di calibrazione");
xlabel("Concentrazione C [\mu\cdotM]");
ylabel("Absorbance A [A.U.]");

%---> Calcolo della concentrazione incognita 

p_inv = polyfit(fluo(:,2), concentrations, 1);
result= polyval(p_inv, fluo_unknow(1))
result2= polyval(p_inv, fluo_unknow(2))
 
sostanza_incognita1= [sostanza_incognita1; result];
sostanza_incognita2= [sostanza_incognita2; result2];

%% Calcolo retta di calibrazione per assorbanza 1

p = polyfit(concentrations, fluo(:,3), 1);
abs_fitted = polyval(p, concentrations_1);

plot(concentrations, fluo(:,3),"ok", MarkerFaceColor="k", MarkerSize=3);
hold on
plot(concentrations_1, abs_fitted, LineWidth=0.8);

grid on

title("Rette di calibrazione");
xlabel("Concentrazione C [\mu\cdotM]");
ylabel("Absorbance A [A.U.]");

%---> Calcolo della concentrazione incognita 

p_inv = polyfit(fluo(:,3), concentrations, 1);
result= polyval(p_inv, fluo_unknow(1))
result2= polyval(p_inv, fluo_unknow(2))
 
sostanza_incognita1= [sostanza_incognita1; result];
sostanza_incognita2= [sostanza_incognita2; result2];

%% Calcolo retta di calibrazione per fluorescenza sulla media

p = polyfit(concentrations, fluo_mean, 3);
abs_fitted = polyval(p, concentrations_1);

plot(concentrations, fluo_mean,"ok", MarkerFaceColor="k", MarkerSize=3);
hold on
plot(concentrations_1, abs_fitted, LineWidth=0.8);

grid on

title("Rette di calibrazione");
xlabel("Concentrazione C [\mu\cdotM]");
ylabel("Absorbance A [A.U.]");

%---> Calcolo della concentrazione incognita 

p_inv = polyfit(fluo_mean, concentrations, 3);
result_mean1= polyval(p_inv, fluo_unknow(1))
result_mean2= polyval(p_inv, fluo_unknow(2))
 
