%Inbetriebnahme
%% Init
clear;
clc;
close all;
%% Import Data
% SolarAnlage = importfile('../DATA/InbetriebnahmeSolaranlagen08.09.2020 15_09_52 1.csv');
DataChrisMainz = importfile('../DATA/Vers_Kollektor_Kennline_Dachlabor_10.09.2020_12_20_45_1.csv');
% DrainAnlage = importfileD('../DATA/Drainback-Anlage_Versuch 114_26_08 1.csv');
DrainChrisMainz = importfile('../DATA/Vers Drainback Dachlabor 10.09.2020 11_42_33 1.csv');

SolarAnlage = DataChrisMainz; % this is only that we dont have to replace all varnames
DrainAnlage = DrainChrisMainz;
%% Start/Stop Time
ScanStart = [871 140];
ScanStop = [1088 230];
EndVal = size(SolarAnlage,1);
%% plot fun
figure
hold on
grid on
plot(SolarAnlage.Scan(1:ScanStart(1)-1),SolarAnlage.I_KollinWprom2(1:ScanStart(1)-1),'color','k')
lgd = plot(SolarAnlage.Scan(ScanStart(1):ScanStop(1)),SolarAnlage.I_KollinWprom2(ScanStart(1):ScanStop(1)),'color','r','DisplayName','verwendete Werte');
plot(SolarAnlage.Scan(ScanStop(1)+1:EndVal),SolarAnlage.I_KollinWprom2(ScanStop(1)+1:EndVal),'color','k')
xlabel('Scan')
ylabel('Einstrahlung $[G] = \frac{W}{m^{2}}$')
run plotsettings.m
legend('Show',[lgd],'location','best')
printPath = '../DATA/DataEinstrahlung';
print(printPath,'-depsc');

%% calc Einstrahlungsparameter

I_Kollektor(:,1) = mean(SolarAnlage.I_KollinWprom2(ScanStart(1),:):SolarAnlage.I_KollinWprom2(ScanStop(1),:));
I_Kollektor(:,2) = mean(DrainAnlage.I_KollinWprom2(ScanStart(2),:):DrainAnlage.I_KollinWprom2(ScanStop(2),:));
std_Kollektor(:,1) = std(SolarAnlage.I_KollinWprom2(ScanStart(1),:):SolarAnlage.I_KollinWprom2(ScanStop(1),:));
std_Kollektor(:,2) = std(DrainAnlage.I_KollinWprom2(ScanStart(2),:):DrainAnlage.I_KollinWprom2(ScanStop(2),:));

%% calc Kennlinie

G = I_Kollektor;
Ta = 296.15;
syms Tf;
Tf = Tf+Ta;
eta0 = 0.830;
a1 = 3.249;
a2 = 0.020;

deltaTS = ((SolarAnlage.T_VL_KollC + SolarAnlage.T_RL_KollC)./2) - SolarAnlage.T_U_DachC;
deltaTD = ((DrainAnlage.T_VL_Koll_drainC + DrainAnlage.T_RL_Koll_drainC)./2) - DrainAnlage.T_U_DachC;

meanDT(:,1) = mean(((SolarAnlage.T_VL_KollC + SolarAnlage.T_RL_KollC)./2) - SolarAnlage.T_U_DachC);
meanDT(:,2) = mean(((DrainAnlage.T_VL_Koll_drainC + DrainAnlage.T_RL_Koll_drainC)./2) - DrainAnlage.T_U_DachC);

eta = eta0-(a1*((Tf-Ta)./(G)))-(a2*(((Tf-Ta)^2)./(G)));

etaGemessenS = eta0-(a1*((deltaTS)./(G(:,1))))-(a2*(((deltaTS).^2)./(G(:,1))));
etaGemessenD = eta0-(a1*((deltaTD)./(G(:,2))))-(a2*(((deltaTD).^2)./(G(:,2))));

etaGemessenPlot(:,1) = mean(etaGemessenS(ScanStart(:,1):ScanStop(:,1)));
etaGemessenPlot(:,2) = mean(etaGemessenD(ScanStart(:,2):ScanStop(:,2)));

%% calc Leistung over Time

rhoH2O = 1.000;
cpH2O = 1.16;
Aap = 2.35;

QdotKollS = (SolarAnlage.T_VL_KollC - SolarAnlage.T_RL_KollC).*rhoH2O.*(SolarAnlage.Vpkt_Vortex.*60).*cpH2O;
QdotKollD = (DrainAnlage.T_VL_Koll_drainC - DrainAnlage.T_RL_Koll_drainC).*rhoH2O.*(DrainAnlage.Vpkt_drain_MIDinlpromin.*60).*cpH2O;

QdotSpeiS = (SolarAnlage.T_VL_SpeiC - SolarAnlage.T_RL_SpeiC).*rhoH2O.*(SolarAnlage.Vpkt_Vortex.*60).*cpH2O;
QdotSpeiD = (DrainAnlage.T_VL_Spei_drainC - DrainAnlage.T_RL_Spei_drainC).*rhoH2O.*(DrainAnlage.Vpkt_drain_MIDinlpromin.*60).*cpH2O;

PipeLossS = abs(QdotKollS-QdotSpeiS);
PipeLossD = abs(QdotKollD-QdotSpeiD);

etaWahrS = QdotKollS./(Aap.*SolarAnlage.I_KollinWprom2);
etaWahrD = QdotKollD./(Aap.*DrainAnlage.I_KollinWprom2);

etaWahrPlot(:,1) = mean(etaWahrS(ScanStart(1):ScanStop(1)));
etaWahrPlot(:,2) = mean(etaWahrD(ScanStart(2):ScanStop(2)));

eqn(:,1) = eta0-(a1*((Tf-Ta)./(G(1))))-(a2*(((Tf-Ta)^2)./(G(1)))) == etaWahrPlot(:,1);
eqn(:,2) = eta0-(a1*((Tf-Ta)./(G(2))))-(a2*(((Tf-Ta)^2)./(G(2)))) == etaWahrPlot(:,2);

etaXP(:,1) = solve(eqn(:,1)); % find xPos1
etaXP(:,2) = solve(eqn(:,2)); % find xPos2

% calculate errorbars
yneg = [0.1068 0.7094 0.1068 0.7094];
ypos = [0.1068 0.7094 0.1068 0.7094];
xneg = [0.0241 0.0125 0.0241 0.0125];
xpos = [0.0241 0.0125 0.0241 0.0125];

%% plot fun
figure
hold on
grid on
fplot(eta(1),'-','color','k','DisplayName','Standard $G = 1007.5 \frac{W}{m^{2}}$')
fplot(eta(2),'--','color','b','DisplayName','Drainback $G = 867.6 \frac{W}{m^{2}}$')
errorbar(etaXP(2,1),etaWahrPlot(:,1),yneg(1),ypos(1),xneg(1),xpos(1),'x','color','r','DisplayName','Standardanlage theo');
errorbar(etaXP(2,2),etaWahrPlot(:,2),yneg(2),ypos(2),xneg(2),xpos(2),'o','color','g','DisplayName','Drainbackacnlage theo');
errorbar((meanDT(:,1)/(G(:,1)/1000)),etaGemessenPlot(:,1),yneg(3),ypos(3),xneg(3),xpos(3),'x','color','b','DisplayName','Standardanlage real');
errorbar((meanDT(:,2)/(G(:,2)/1000)),etaGemessenPlot(:,2),yneg(4),ypos(4),xneg(4),xpos(4),'o','color','k','DisplayName','Drainbackacnlage real');
xlim([0 150])
ylim([0 1])
xlabel('$\frac{\Delta T}{G}$ in $\frac{K m^{2}}{kW}$')
ylabel('Wirkungsgrad $\eta$')
run plotsettings.m
legend('Show','location','best')
printPath = '../DATA/KennlinieTheo';
print(printPath,'-depsc');
%% plot Leistung/Time
figure
grid on
hold on
yyaxis left
plot(SolarAnlage.Scan,QdotKollS,'-x')
ylabel('Momentanleistung Kollektor [P] = W')
yyaxis right
plot(SolarAnlage.Scan,etaWahrS,'--o')
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
printPath = '../DATA/TempTimeStandard';
print(printPath,'-depsc');

%% plot Temps
figure
hold on
grid on
plot(DrainAnlage.Scan,DrainAnlage.T_RL_Koll_drainC,'-')
plot(DrainAnlage.Scan,DrainAnlage.T_VL_Koll_drainC,'-')
plot(DrainAnlage.Scan,DrainAnlage.T_RL_Spei_drainC,'--')
plot(DrainAnlage.Scan,DrainAnlage.T_VL_Spei_drainC,'--')
legend('RL Koll','VL Koll','RL Spei','VL Spei','location','best')
xlabel('Scan')
ylabel('Temperatur [T] = $^{\circ}C$')
run plotsettings.m
printPath = '../DATA/TempTimeDrainBack';
print(printPath,'-depsc');


