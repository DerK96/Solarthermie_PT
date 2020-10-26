%Inbetriebnahme
%% Init
clear;
clc;
close all;
%% Import Data
% SolarAnlage = importfile('../DATA/InbetriebnahmeSolaranlagen08.09.2020 15_09_52 1.csv');
DataChrisMainz = importfile('../DATA/Vers_Kollektor_Kennline_Dachlabor_10.09.2020_12_20_45_1.csv');
DrainAnlage = importfileD('../DATA/Drainback-Anlage_Versuch 114_26_08 1.csv');
SolarAnlage = DataChrisMainz; % this is only that we dont have to replace all varnames
%% Start/Stop Time
ScanStart = 871;
ScanStop = 1088;
EndVal = size(SolarAnlage,1);
%% plot fun
figure
hold on
grid on
plot(SolarAnlage.Scan(1:ScanStart-1),SolarAnlage.I_KollinWprom2(1:ScanStart-1),'color','k')
lgd = plot(SolarAnlage.Scan(ScanStart:ScanStop),SolarAnlage.I_KollinWprom2(ScanStart:ScanStop),'color','r','DisplayName','verwendete Werte');
plot(SolarAnlage.Scan(ScanStop+1:EndVal),SolarAnlage.I_KollinWprom2(ScanStop+1:EndVal),'color','k')
xlabel('Scan')
ylabel('Einstrahlung $[G] = \frac{W}{m^{2}}$')
run plotsettings.m
legend('Show',[lgd],'location','best')
printPath = '../DATA/DataEinstrahlung';
print(printPath,'-depsc');

%% calc Einstrahlungsparameter

I_Kollektor = mean(SolarAnlage.I_KollinWprom2(ScanStart,:):SolarAnlage.I_KollinWprom2(ScanStop,:));
std_Kollektor = std(SolarAnlage.I_KollinWprom2(ScanStart,:):SolarAnlage.I_KollinWprom2(ScanStop,:));

%% calc Kennlinie

G = 1007.5;
Ta = 296.15;
syms Tf;
Tf = Tf+Ta;
eta0 = 0.830;
a1 = 3.249;
a2 = 0.020;

deltaT = ((SolarAnlage.T_VL_KollC + SolarAnlage.T_RL_KollC)./2) - SolarAnlage.T_U_DachC;

eta = eta0-(a1*((Tf-Ta)./(G)))-(a2*(((Tf-Ta)^2)./(G)));
G_vg = I_Kollektor;
etaGemessen = eta0-(a1*((deltaT)./(G_vg)))-(a2*(((deltaT).^2)./(G_vg)));

%% calc Leistung over Time

rhoH2O = 1.000;
cpH2O = 1.16;
Aap = 2.35;
QdotKoll = (SolarAnlage.T_VL_KollC - SolarAnlage.T_RL_KollC).*rhoH2O.*(SolarAnlage.Vpkt_Vortex.*60).*cpH2O;

QdotSpei = (SolarAnlage.T_VL_SpeiC - SolarAnlage.T_RL_SpeiC).*rhoH2O.*(SolarAnlage.Vpkt_Vortex.*60).*cpH2O;
PipeLoss = abs(QdotKoll-QdotSpei);
etaWahr = QdotKoll./(Aap.*SolarAnlage.I_KollinWprom2);

etaWahrPlot = mean(etaWahr(ScanStart:ScanStop));

eqn = eta0-(a1*((Tf-Ta)./(G)))-(a2*(((Tf-Ta)^2)./(G))) == etaWahrPlot;

etaXP = solve(eqn); % find xPos

% calculate errors
yneg = 0.1;
ypos = 0.1;
xneg = 10;
xpos = 10;

%% plot fun
figure
hold on
grid on
fplot(eta,'-','color','k')
errorbar(etaXP(2),etaWahrPlot,yneg,ypos,xneg,xpos,'x','color','r');
xlim([0 150])
ylim([0 1])
xlabel('$\frac{\Delta T}{G}$ in $\frac{K m^{2}}{kW}$')
ylabel('Wirkungsgrad $\eta$')
run plotsettings.m
legend('$G = 1007.5 \frac{W}{m^{2}}$')
printPath = '../DATA/KennlinieTheo';
print(printPath,'-depsc');
%% plot Leistung/Time
figure
grid on
hold on
yyaxis left
plot(SolarAnlage.Scan,QdotKoll,'-x')
ylabel('Momentanleistung Kollektor [P] = W')
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
ylabel('Temperatur [T] = $^{\circ}C$')
run plotsettings.m
printPath = '../DATA/TempTime';
print(printPath,'-depsc');

