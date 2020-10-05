%Inbetriebnahme
%% Init
clear;
clc;
close all;
%% Import Data
SolarAnlage = importfile('../DATA/InbetriebnahmeSolaranlagen08.09.2020 15_09_52 1.csv');
% DataChrisMainz = importfile('../DATA/Vers_Kollektor_Kennline_Dachlabor_10.09.2020_12_20_45_1.csv');
DrainAnlage = importfileD('../DATA/Drainback-Anlage_Versuch 114_26_08 1.csv');
%% plot fun
figure
hold on
grid on
plot(SolarAnlage.Scan,SolarAnlage.I_KollinWprom2)
xlabel('Scan [arbitrary]')
ylabel('Einstrahlung $G \left[\frac{W}{m^{2}}\right]$')
run plotsettings.m
% legend('$G = 600 \left[\frac{W}{m^{2}}\right]$','$G = 800 \left[\frac{W}{m^{2}}\right]$','$G = 1000 \left[\frac{W}{m^{2}}\right]$')
printPath = '../DATA/DataEinstrahlung';
print(printPath,'-depsc');
%% calc Kennlinie

G = [600 800 1000];
Ta = 296.15;
syms Tf;
eta0 = 0.830;
a1 = 3.249;
a2 = 0.020;

deltaT = ((SolarAnlage.T_VL_KollC+SolarAnlage.T_RL_KollC)./2)-SolarAnlage.T_U_DachC;

eta = eta0-(a1*((Tf-Ta)./(G)))-(a2*(((Tf-Ta)^2)./(G)));
%etaGemessen = eta0-(a1*((deltaT)./(G_vg)))-(a2*(((deltaT).^2)./(G_vg)));

%% plot fun
figure
hold on
grid on
fplot(eta,'-')
fplot(Tf)
xlim([Ta 500])
ylim([0 1])
xlabel('$\frac{T_{f}-T_{a}}{G} \left[\frac{K  m^{2}}{W}\right]$')
ylabel('Wirkungsgrad $\eta$ [arbitrary]')
run plotsettings.m
legend('$G = 600 \left[\frac{W}{m^{2}}\right]$','$G = 800 \left[\frac{W}{m^{2}}\right]$','$G = 1000 \left[\frac{W}{m^{2}}\right]$')
printPath = '../DATA/KennlinieTheo';
print(printPath,'-depsc');

%% calc Leistung over Time

rhoH2O = 1000;
cpH2O = 1.16;
Aap = 2.35;
QdotKoll = (SolarAnlage.T_VL_KollC - SolarAnlage.T_RL_KollC).*rhoH2O.*(SolarAnlage.Vpkt_Vortex./60).*cpH2O;

QdotSpei = (SolarAnlage.T_VL_SpeiC - SolarAnlage.T_RL_SpeiC).*rhoH2O.*(SolarAnlage.Vpkt_Vortex./60).*cpH2O;
PipeLoss = abs(QdotKoll-QdotSpei);
etaWahr = QdotKoll./(Aap.*SolarAnlage.I_KollinWprom2);

%% plot Leistung/Time
figure
grid on
hold on
yyaxis left
plot(SolarAnlage.Scan,QdotKoll,'-x')
ylabel('Momentanleistung Kollektor')
yyaxis right
plot(SolarAnlage.Scan,etaWahr,'--o')
xlabel('Scan')
ylabel('Momentanwirkungsgrad')
run plotsettings.m
% legend('$G = 600 \left[\frac{W}{m^{2}}\right]$','$G = 800 \left[\frac{W}{m^{2}}\right]$','$G = 1000 \left[\frac{W}{m^{2}}\right]$')
printPath = '../DATA/LeistungTime';
print(printPath,'-depsc');

%% plot Temps
figure
hold on
grid on
plot(SolarAnlage.Scan,SolarAnlage.T_RL_KollC,'-')
plot(SolarAnlage.Scan,SolarAnlage.T_VL_KollC,'-')
plot(SolarAnlage.Scan,SolarAnlage.T_RL_SpeiC,'--')
plot(SolarAnlage.Scan,SolarAnlage.T_VL_SpeiC,'--')
legend('RL Koll','VL Koll','RL Spei','VL Spei','location','best')
xlabel('Scan')
ylabel('Temperatur [$^{\circ}C$]')
run plotsettings.m
printPath = '../DATA/TempTime';
print(printPath,'-depsc');
