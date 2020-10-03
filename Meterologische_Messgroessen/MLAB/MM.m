%% Init
clc;
clear;
close all;
%% Import Data
d.Radiation = importfile2('../200909_MeteoMess_Teil A+B_Solarstrahlung.xlsx'); %aus überordner
d.Humidity = importfile('../Niederschlag_Luftfeuchte_ 04.09.2020 14_34_57.csv');
%% Darstellung Messreihe
names = {'TA GBS','SSR81','CM3','CM11 gesamt','CM11 diffus'};
t1 = d.Radiation.Scan;
TAGBS = d.Radiation.TAGBS;
SSR81 = d.Radiation.ENNOSSSR81;
CM3 = d.Radiation.CM3;
CM11ges = d.Radiation.CM11;
CM11dif = d.Radiation.CM11Schattenring;

figure
hold on
plot(t1,TAGBS);
plot(t1,SSR81);
plot(t1,CM3);
plot(t1,CM11ges);
plot(t1,CM11dif);
xlabel('Scan [s]')
ylabel('Strahlung [$\frac{W}{m^2}$]')
legend(names,'location','best')
run plotsettings.m
%print('Messreihe_Strahlung','-depsc');
hold off

%% Versuchsteil A (und B)
%Scan 170-220

dataPoints = 1:2:19; %start:step:stop
fn = fieldnames(d); % Spaltentitel abrufen

for i = 1:numel(fn) %1 bis 4 numel=Anzahl Elemente von fn
    %d.(fn{i})(:,3) = array2table(table2array(d.(fn{i})(:,3)) - offset);
    for k = 1:numel(dataPoints)
        curr = table2array(d.(fn{i})(:,11:19));
        m2(k,i) = mean(curr(size(curr,1)-20:size((curr),1),dataPoints(:,k)));
       % m3(k,i) = std(curr(170:220),dataPoints(:,k)));
    end
end

disp(m2);
%disp(m3);

%Edir = m2(x,y)-m2(x,y)

%% Versuchsteile C und D

AvTemp = mean(d.Radiation.TemperatureC);
AvHum = mean(d.Radiation.RelativeFeuchteinV);
StdTemp = std(d.Radiation.TemperatureC);
StdHum = std(d.Radiation.RelativeFeuchteinV);

t2 = d.Humidity.Scan;
Hum = d.Humidity.RelativeFeuchteinV;
HumNaCl = mean(Hum(1400:1500));
HumLiCl = mean(Hum(3024:3124));



figure % Zeige Messverlauf der Feuchtemessung
hold on
plot(t2,Hum);
xlabel('Scan [s]')
ylabel('Spannung [V]')
run plotsettings.m
%print('Messreihe_Feuchte','-depsc');
hold off

FitHum = [0.11,HumLiCl;0.75,HumNaCl]; %Gemessene Spannungen und Literaturwerte


figure %
f = fit(FitHum(:,1),FitHum(:,2),'poly1')
hold on
plot(f)
plot(FitHum(:,1),FitHum(:,2))
xlabel('Relative Luftfeuchte [%]')
ylabel('Spannung [V]')
run plotsettings.m
%print('Kalibriergerade_Feuchte','-depsc');


