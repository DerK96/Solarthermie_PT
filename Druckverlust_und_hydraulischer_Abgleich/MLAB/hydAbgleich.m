%Druckverlust
%% Init
clc;
clear;
close all;
%% Import Data
VKennLinie = importfile('../DATA/Ventilkennlinie_07.09.2020 10_01_30.csv');
%% Init final_Vars
VentStep = [1 113 185 260 340 485 570 680 800 900 1020;
            6.0 5.0 4.0 3.0 2.0 1.5 1.0 0.8 0.6 0.4 0.2];
%% split Data into Step Intervalls
data = struct;
for i = 1:size(VentStep,2)-1
    id = strcat('data',int2str(i));
    data.(id) = VKennLinie.V_Strang_2(VentStep(1,i):VentStep(1,i+1));
end
%% test

figure
hold on
plot(VKennLinie.Scan,VKennLinie.V_Strang_2)
plot(VKennLinie.Scan,VKennLinie.Differenzdruckinmbar)