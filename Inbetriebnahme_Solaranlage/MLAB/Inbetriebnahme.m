%Inbetriebnahme
%% Init
clear;
clc;
close all;
%% Import Data
SolarAnlage = importfile('../DATA/InbetriebnahmeSolaranlagen08.09.2020 15_09_52 1.csv');
DrainAnlage = importfileD('../DATA/Drainback-Anlage_Versuch 114_26_08 1.csv');
%% 
figure
hold on
grid on
plot(SolarAnlage.Scan,SolarAnlage.T_RL_SpeiC);
plot(SolarAnlage.Scan,SolarAnlage.T_RL_KollC);
plot(SolarAnlage.Scan,SolarAnlage.T_VL_SpeiC);
plot(SolarAnlage.Scan,SolarAnlage.T_VL_KollC);
legend('RL Spei','RL Koll','VL Spei','VL Koll','location','best')
%% calc Kennlinie

G = [600 800 1000];
Ta = 296.15;
syms Tf;
eta0 = 0.830;
a1 = 3.249;
a2 = 0.020;

eta = eta0-(a1*((Tf-Ta)./(G)))-(a2*(((Tf-Ta)^2)./(G)));

%% plot fun
figure
grid on
fplot(eta,'-')
xlim([Ta 500])
ylim([0 1])
xlabel('$\frac{T_{f}-T_{a}}{G} \left[\frac{K  m^{2}}{W}\right]$')
ylabel('Wirkungsgrad $\eta$ [arbitrary]')
run plotsettings.m
legend('$G = 600 \left[\frac{W}{m^{2}}\right]$','$G = 800 \left[\frac{W}{m^{2}}\right]$','$G = 1000 \left[\frac{W}{m^{2}}\right]$')
printPath = '../DATA/KennlinieTheo';
print(printPath,'-depsc');