%% Init
clc;
clear;
close all;
%% import Data

d.SpeicherA = importfile('../DATA/SolarspeicherA_07.09.2020 11_51_36.csv');
d.SpeicherB = importfile('../DATA/SolarspeicherB_2_07.09.2020 13_36_42.csv');
d.SpeicherB2 = importfile('../DATA/SolarspeicherB_07.09.2020 13_13_26.csv');
%% Berechnung UA Wert

t1 = d.SpeicherA.Scan;
WTsekEin = d.SpeicherA.T_WT_sek_einC;
WTprimAus = d.SpeicherA.T_WT_prim_ausC;
WTsekAus = d.SpeicherA.T_WT_sek_ausC;
WTprimEin = d.SpeicherA.T_WT_prim_einC;


namesa = {'sek Ein','prim Aus','sek Aus','prim Ein'};
figure
hold on
grid on
plot(t1,WTsekEin);
plot(t1,WTprimAus);
plot(t1,WTsekAus);
plot(t1,WTprimEin);
xlabel('Scan [5s]');
ylabel('Temperatur [$^{\circ}C$]');
legend(namesa,'location','best');
run plotsettings.m
print('../DATA/PlattenWT_A.eps','-depsc');
hold off


%150 bis 270 Konstanter Bereich
dataPoints = 3:2:9; %start:step:end
%fn = fieldnames(d); % Spaltentitel abrufen

for k = 1:numel(dataPoints) %Zeige Mittelwerte in m2, Standardabweichung in s2
     curr = table2array(d.SpeicherA(:,dataPoints));
     m2(:,k) = mean(curr(150:270,k));
     s2(:,k) = std(curr(150:270,k));
end


disp(m2);
disp(s2);

deltaT0 = m2(1,4)-m2(1,3); %hin-cout
deltaT1 = m2(1,2)-m2(1,1); % hout-cin
deltaTm = (abs(deltaT0-deltaT1))/(log(deltaT0/deltaT1))
Vorange = mean(d.SpeicherA.MIDorange(150:270))
stdVorange = std(d.SpeicherA.MIDorange(150:270))
Q=1000*(Vorange/3600)*4190*(m2(1,4)-m2(1,2)) %Q=rho*Vdot*cp*(Tprimein
UASpA = Q/deltaTm

%% Befüllvorgang

%fnlanzen = fieldnames(d.SpeicherA)
%for j = 25:2:numel(fnlanzen)
 %   lanze({j}) = d.SpeicherA.(fnlanzen(j,1));
%end
 
%figure
%hold on
%grid on
%plot(t1,lance{j})

Lanze6 = d.SpeicherA.T_Lanze_6cmC;
Lanze12 = d.SpeicherA.T_Lanze_12cmC;
Lanze18 = d.SpeicherA.T_Lanze_18cmC;
Lanze24 = d.SpeicherA.T_Lanze_24cmC;
Lanze30 = d.SpeicherA.T_Lanze_30cmC;
Lanze36 = d.SpeicherA.T_Lanze_36cmC;
Lanze42 = d.SpeicherA.T_Lanze_42cmC;
Lanze48 = d.SpeicherA.T_Lanze_48cmC;
Lanze54 = d.SpeicherA.T_Lanze_54cmC;
Lanze60 = d.SpeicherA.T_Lanze_60cmC;
Lanze66 = d.SpeicherA.T_Lanze_66cmC;
Lanze72 = d.SpeicherA.T_Lanze_72cmC;
Lanze78 = d.SpeicherA.T_Lanze_78cmC;
Lanze84 = d.SpeicherA.T_Lanze_84cmC;
Lanze90 = d.SpeicherA.T_Lanze_90cmC;
Lanze96 = d.SpeicherA.T_Lanze_96cmC;
Lanze102 = d.SpeicherA.T_Lanze_102cmC;
Lanze108 = d.SpeicherA.T_Lanze_108cmC;
Lanze114 = d.SpeicherA.T_Lanze_114cmC;
Lanze120 = d.SpeicherA.T_Lanze_120cmC;

fnlanzen = fieldnames(d.SpeicherA)

figure
hold on
grid on
plot(t1,Lanze6,t1,Lanze12,t1,Lanze18,t1,Lanze24,t1,Lanze30,t1,Lanze36,t1,Lanze42,t1,Lanze48,t1,Lanze54,t1,Lanze60)
plot(t1,Lanze66,t1,Lanze72,t1,Lanze78,t1,Lanze84,t1,Lanze90,t1,Lanze96,t1,Lanze102,t1,Lanze108,t1,Lanze114,t1,Lanze120)
xlabel('Scan [5s]')
ylabel('Temperatur [$^{\circ}C$]')
fleg = legend(fnlanzen(25:2:63),'location','southoutside');
fleg.NumColumns = 3;
run plotsettings.m
hold off
print('../DATA/SpA_Lanzen.eps','-depsc')

%% Speicher B

t2 = d.SpeicherB2.Scan;
TSpR = d.SpeicherB2.T_Steigrohr_ausC;
TSpin = d.SpeicherB2.T_WT_Speicher_einC;
TSpout = d.SpeicherB2.T_WT_Speicher_ausC;
TSp6 = d.SpeicherB2.T_Lanze_6cmC;

namesb = {'Sp.Rohr','Sp.Ein','Sp.Aus','Sp.Lanze',};
figure
hold on
grid on
plot(t2,TSpR);
plot(t2,TSpin);
plot(t2,TSpout);
plot(t2,TSp6);
xlabel('Scan [5s]');
ylabel('Temperatur [$^{\circ}C$]');
legend(namesb,'location','best');
run plotsettings.m
hold off

%ab Scan 200 Konstanter Bereich
dataPoints2 = 11:2:25; %start:step:end
%fn = fieldnames(d); % Spaltentitel abrufen

for j = 1:numel(dataPoints2) %Zeige Mittelwerte in m3, Standardabweichung in s3
     curr2 = table2array(d.SpeicherB2(:,dataPoints2));
     m3(:,j) = mean(curr2(200:end,j));
     s3(:,j) = std(curr2(200:end,j));
end


disp(m3);
disp(s3);

deltaT0B = m3(1,2)-m3(1,1);                                     %hin-cout
deltaT1B = m3(1,3)-m3(1,8);                                     % hout-cin
deltaTmB = (abs(deltaT0B-deltaT1B))/(log(deltaT0B/deltaT1B));
Vblau = m3(1,6)/1,08 ;                        %Vblau in m^3/h                    %8 Prozent Anzeigefehler 
QB=1000*(Vblau/3600)*4190*(m3(1,2)-m3(1,3));                    %Q=rho*Vdot*cp*(Tprimein
UASpB = QB/deltaTmB



%Volumenstrom Steigrohr, Berechnung über Sekundärseite WÜT
Vdot = QB/(1000*4190*(m3(1,1)-m3(1,8)))    %Vdot in m^3/s



