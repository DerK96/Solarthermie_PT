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


namesa = {'sek Ein','prim Aus','sek Aus','Vblau','prim Ein'};
figure;
hold on
grid on
plot(t1,WTsekEin);
plot(t1,WTprimAus);
plot(t1,WTsekAus);
plot(t1,WTprimEin);
xlabel('elapsed time [t] in 5s');
ylabel('Temperatur [T] in $^{\circ}C$');
legend(namesa,'location','north');
pbaspect([3 1 1])
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
deltaTm = (abs(deltaT0-deltaT1))/(log(deltaT0/deltaT1));
Vorange = mean(d.SpeicherA.MIDorange(150:270));
stdVorange = std(d.SpeicherA.MIDorange(150:270));
Q=1000*(Vorange/3600)*4190*(m2(1,4)-m2(1,2)); %Q=rho*Vdot*cp*(Tprimein
UASpA = Q/deltaTm;

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

fnlanzen = fieldnames(d.SpeicherA);

figure;
hold on
grid on
plot(t1,Lanze6,t1,Lanze12,t1,Lanze18,t1,Lanze24,t1,Lanze30,t1,Lanze36,t1,Lanze42,t1,Lanze48,t1,Lanze54,t1,Lanze60);
plot(t1,Lanze66,t1,Lanze72,t1,Lanze78,t1,Lanze84,t1,Lanze90,t1,Lanze96,t1,Lanze102,t1,Lanze108,t1,Lanze114,t1,Lanze120);
xlabel('elapsed time [t] in 5s')
ylabel('Temperatur [T] in $^{\circ}C$')
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

namesb = {'$T_{Steigrohr}$','$T_{WT,ein}$','$T_{WT,aus}$','$T_{Lanze,6cm}$',};
figure
hold on
grid on
plot(t2,TSpR);
plot(t2,TSpin);
plot(t2,TSpout);
plot(t2,TSp6);
xlabel('elapsed time [t] in 5s');
ylabel('Temperatur [T] in $^{\circ}C$');
legend(namesb,'location','east');
pbaspect([3 1 1])
run plotsettings.m
print('../DATA/RohrWT_B.eps','-depsc');
hold off


dataPoints2 = 11:2:63; %start:step:end
%fn = fieldnames(d); % Spaltentitel abrufen

for j = 1:numel(dataPoints2) %Zeige Mittelwerte in m3, Standardabweichung in s3
     curr2 = table2array(d.SpeicherB2(:,dataPoints2));
     m3(:,j) = mean(curr2(240:end,j)); %letzte 10 Werte (240..250 sind 50 Sekunden)
     s3(:,j) = std(curr2(240:end,j)); %letzte 10 Werte (240..250 sind 50 Sekunden)
end


disp(m3); % ab Spalte 8: Lanzenwerte
disp(s3);

deltaT0B = m3(1,2)-m3(1,1);                                     %hin-cout
deltaT1B = m3(1,3)-m3(1,8);                                     % hout-cin
deltaTmB = (abs(deltaT0B-deltaT1B))/(log(deltaT0B/deltaT1B));
Vblau = m3(1,6)/1;08 ;                        %Vblau in m^3/h                    %8 Prozent Anzeigefehler 
QB=1000*(Vblau/3600)*4190*(m3(1,2)-m3(1,3));                    %Q=rho*Vdot*cp*(Tprimein
UASpB = QB/deltaTmB;



%Volumenstrom Steigrohr, Berechnung über Sekundärseite WÜT
Vdot = (QB/(1000*4190*(m3(1,1)-m3(1,8))))*3600;    %Vdot in m^3/h

%% Dichteintegrale

hLanze = [6 12 18 24 30 36 42 48 54 60 66 72 78 84 90 96 102 108];

for k = 1:numel(hLanze)
    if k < 3
        TLanze(:,k) = m3(:,(7+k));
    elseif k < 7
            TLanze(:,k) = (m3(1,2)+m3(1,3))/2;
    elseif k <= numel(hLanze)
                TLanze(:,k) = m3(1,1);
    end
end
      


figure
grid on
hold on
plot(m3(8:25),hLanze)
plot(TLanze,hLanze)
xlim([25 50])
pbaspect([1 2 1])
xlabel('Temperatur [T] in $^{\circ}C$')
ylabel('Höhe in cm')
legend('T_Sp','T_Rohr','location','northwest')
pbaspect([1 2 1])
run plotsettings.m
print('../DATA/siphon.eps','-depsc');

 %Dichte(Temperatur)
rhoTemp = @(x) 1000/(1+0.0002*(x)); %kg/m^3



dpRohr = rhoTemp(m3(1,8))*0.12+rhoTemp(TLanze(1,6))*(0.38-0.12)+rhoTemp(TLanze(1,18))*(1.09-0.38);
%summe(rho*h) im Steigrohr

for k = 1:numel(hLanze)
    curr4(:,k) = rhoTemp(m3(1,(k+7)))*0.06;
end

dpSp = sum(curr4); % summe(rho*h) im Speicher

pdrive = 9.81*(dpRohr-dpSp); %Druckdifferenz




%% Fluidgeschwindigkeit

visc = @(x) 1/(0.1*(x).^2-34.335*(x)+2472); %Näherungsgleichung für Wasser zwischen 0..100°C
hpipe = 0.73; %m
dpipe = 0.016; %m
zeta0 = 1.44;

problem.objective = @(vpipe) pdrive-((zeta0+(0.3164/((rhoTemp(TLanze(1,18))*vpipe*dpipe)/visc(TLanze(1,18))).^0.25)*(hpipe/dpipe))*(rhoTemp(TLanze(1,18))/2)*vpipe.^2); %pdrive minus Term ergibt null bei einsetzen der Fluidgeschwindigkeit
problem.x0 = 0.16; %Entspricht Vdot MID /A_Steigrohr in m/s
problem.solver = 'fzero';
problem.options = optimset(@fzero);
vpipe = (fzero(problem))*pi*(dpipe/2).^2*3600 %Ausgabe in m3/h

%% Speicher B
t3 = d.SpeicherB.Scan;
Lanze6B = d.SpeicherB.T_Lanze_6cmC;
Lanze12B = d.SpeicherB.T_Lanze_12cmC;
Lanze18B= d.SpeicherB.T_Lanze_18cmC;
Lanze24B = d.SpeicherB.T_Lanze_24cmC;
Lanze30B = d.SpeicherB.T_Lanze_30cmC;
Lanze36B = d.SpeicherB.T_Lanze_36cmC;
Lanze42B = d.SpeicherB.T_Lanze_42cmC;
Lanze48B = d.SpeicherB.T_Lanze_48cmC;
Lanze54B = d.SpeicherB.T_Lanze_54cmC;
Lanze60B = d.SpeicherB.T_Lanze_60cmC;
Lanze66B = d.SpeicherB.T_Lanze_66cmC;
Lanze72B = d.SpeicherB.T_Lanze_72cmC;
Lanze78B = d.SpeicherB.T_Lanze_78cmC;
Lanze84B = d.SpeicherB.T_Lanze_84cmC;
Lanze90B = d.SpeicherB.T_Lanze_90cmC;
Lanze96B = d.SpeicherB.T_Lanze_96cmC;
Lanze102B = d.SpeicherB.T_Lanze_102cmC;
Lanze108B = d.SpeicherB.T_Lanze_108cmC;
Lanze114B = d.SpeicherB.T_Lanze_114cmC;
Lanze120B = d.SpeicherB.T_Lanze_120cmC;
WTSpeinB = d.SpeicherB.T_WT_Speicher_einC;
WTSpausB = d.SpeicherB.T_WT_Speicher_ausC;

figure;
hold on
grid on
plot(t3,Lanze6B,t3,Lanze12B,t3,Lanze18B,t3,Lanze24B,t3,Lanze30B,t3,Lanze36B,t3,Lanze42B,t3,Lanze48B,t3,Lanze54B,t3,Lanze60B);
plot(t3,Lanze66B,t3,Lanze72B,t3,Lanze78B,t3,Lanze84B,t3,Lanze90B,t3,Lanze96B,t3,Lanze102B,t3,Lanze108B,t3,Lanze114B,t3,Lanze120B);
xlabel('elapsed time [t] in 5s')
ylabel('Temperatur [T] in $^{\circ}C$')
fleg = legend(fnlanzen(25:2:63),'location','southoutside');
fleg.NumColumns = 3;
run plotsettings.m
hold off


%% Speicher B2
t4 = d.SpeicherB2.Scan;
Lanze6B2 = d.SpeicherB2.T_Lanze_6cmC;
Lanze12B2 = d.SpeicherB2.T_Lanze_12cmC;
Lanze18B2 = d.SpeicherB2.T_Lanze_18cmC;
Lanze24B2 = d.SpeicherB2.T_Lanze_24cmC;
Lanze30B2 = d.SpeicherB2.T_Lanze_30cmC;
Lanze36B2 = d.SpeicherB2.T_Lanze_36cmC;
Lanze42B2 = d.SpeicherB2.T_Lanze_42cmC;
Lanze48B2 = d.SpeicherB2.T_Lanze_48cmC;
Lanze54B2 = d.SpeicherB2.T_Lanze_54cmC;
Lanze60B2 = d.SpeicherB2.T_Lanze_60cmC;
Lanze66B2 = d.SpeicherB2.T_Lanze_66cmC;
Lanze72B2 = d.SpeicherB2.T_Lanze_72cmC;
Lanze78B2 = d.SpeicherB2.T_Lanze_78cmC;
Lanze84B2 = d.SpeicherB2.T_Lanze_84cmC;
Lanze90B2 = d.SpeicherB2.T_Lanze_90cmC;
Lanze96B2 = d.SpeicherB2.T_Lanze_96cmC;
Lanze102B2 = d.SpeicherB2.T_Lanze_102cmC;
Lanze108B2 = d.SpeicherB2.T_Lanze_108cmC;
Lanze114B2 = d.SpeicherB2.T_Lanze_114cmC;
Lanze120B2 = d.SpeicherB2.T_Lanze_120cmC;
%TSpin = d.SpeicherB2.T_WT_Speicher_einC;
%TSpout = d.SpeicherB2.T_WT_Speicher_ausC;
%TSpR = d.SpeicherB2.T_Steigrohr_ausC;

figure;
hold on
grid on
plot(t4,Lanze6B2,t4,Lanze12B2,t4,Lanze18B2,t4,Lanze24B2,t4,Lanze30B2,t4,Lanze36B2,t4,Lanze42B2,t4,Lanze48B2,t4,Lanze54B2,t4,Lanze60B2);
plot(t4,Lanze66B2,t4,Lanze72B2,t4,Lanze78B2,t4,Lanze84B2,t4,Lanze90B2,t4,Lanze96B2,t4,Lanze102B2,t4,Lanze108B2,t4,Lanze114B2,t4,Lanze120B2);
xlabel('elapsed time [t] in 5s')
ylabel('Temperatur [T] in $^{\circ}C$')
fleg = legend(fnlanzen(25:2:63),'location','southoutside');
fleg.NumColumns = 3;
run plotsettings.m
hold off


