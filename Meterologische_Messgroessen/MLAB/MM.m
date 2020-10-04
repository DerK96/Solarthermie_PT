%% Init
clc;
clear;
close all;
%% Import Data
d.Radiation = importfile2('../200909_MeteoMess_Teil A+B_Solarstrahlung.xlsx'); %aus überordner
d.Response = importfile3('../190919_MeteoMess_Teil B_Ansprechzeiten.xlsx')
d.Humidity = importfile('../Niederschlag_Luftfeuchte_ 04.09.2020 14_34_57.csv');
d.Humidity2 = importfile('../Relative Luftfeucht_Teil_C04.09.2020 14_18_43.csv');
%% Versuchsteil A
names = {'TA GBS','SSR81','CM3','CM11 gesamt','CM11 diffus'};

t1 = d.Radiation.Scan;
TAGBS = d.Radiation.TAGBS;
SSR81 = d.Radiation.ENNOSSSR81;
CM3 = d.Radiation.CM3;
CM11ges = d.Radiation.CM11;
CM11dif = d.Radiation.CM11Schattenring;

figure
hold on
grid on
plot(t1,TAGBS);
plot(t1,SSR81);
plot(t1,CM3);
plot(t1,CM11ges);
plot(t1,CM11dif);
xlabel('Scan [s]')
ylabel('Strahlung $\left[\frac{W}{m^2}\right]$')
legend(names,'location','best')
run plotsettings.m
print('../DATA/Messreihe_Strahlung.eps','-depsc');
hold off

%Scan 170-220

dataPoints = 3:2:19; %start:step:end
fn = fieldnames(d); % Spaltentitel abrufen

for k = 1:numel(dataPoints) %Zeige Mittelwerte in m2, Standardabweichung in s2
     curr = table2array(d.Radiation(:,dataPoints));
     m2(:,k) = mean(curr(170:220,k));
     s2(:,k) = std(curr(170:220,k));
end


disp(m2);
disp(s2);

Edir = m2(1,8)-m2(1,9) %Berechnung direktstrahlung aus Mittelwerten CM11

%% Versuchsteil B

names2 = {'TA GBS','SSR81','CM3','CM11'};

t2 = d.Response.Scan;
TAGBSres = d.Response.TAGBS;
SSR81res = d.Response.ENNOSSSR81;
CM3res = d.Response.CM3;
CM11res = d.Response.CM11;


figure
hold on
grid on
plot(t2,TAGBSres);
plot(t2,SSR81res);
plot(t2,CM3res);
plot(t2,CM11res);
xlabel('Scan [s]')
ylabel('Strahlung $\left[\frac{W}{m^2}\right]$')
legend(names2,'location','best')
run plotsettings.m
print('../DATA/Messreihe_Ansprechzeit.eps','-depsc');
hold off

%% Versuchsteile C und D

AvTemp = mean(d.Humidity2.TemperatureC);
StdAvTemp = std(d.Humidity2.TemperatureC);
AvHum = mean(d.Humidity2.RelativeFeuchteinV);
StdAvHum = std(d.Humidity2.RelativeFeuchteinV);
StdTemp = std(d.Humidity2.TemperatureC);
StdHum = std(d.Humidity2.RelativeFeuchteinV);

t2 = d.Humidity.Scan;
Hum = d.Humidity.RelativeFeuchteinV;
HumNaCl = mean(Hum(1400:1500));
HumLiCl = mean(Hum(3024:3124));
StdNaCl = std(Hum(1400:1500));
StdLiCl = std(Hum(3024:3124));


names3 = {'Temperatur','Spannung'}
figure % Messverlauf der Temperatur/Feuchtemessung
hold on
plot(d.Humidity2.Scan,d.Humidity2.TemperatureC)
plot(d.Humidity2.Scan,d.Humidity2.RelativeFeuchteinV)
xlabel('Scan [s]')
ylabel('Rel. Feuchte [V] / Temperatur [$^{\circ}C$]')
legend(names3,'location','best')
run plotsettings.m
print('../DATA/Messreihe_Umgebung.eps','-depsc');
hold off

FitHum = [HumLiCl,12;HumNaCl,75]; %Gemessene Spannungen und Literaturwerte

figure
hold on
plot(t2,Hum)
xlabel('Scan [s]')
ylabel('Spannung [V]')
run plotsettings.m
print('../DATA/Messreihe_Feuchtekalibration.eps','-depsc');
hold off

figure 
f = fit(FitHum(:,1),FitHum(:,2),'poly1')
hold on
plot(f,FitHum(:,1),FitHum(:,2))
legend('location','best')
ylabel('Relative Luftfeuchte [\%]')
xlabel('Spannung [V]')
run plotsettings.m
print('../DATA/Kalibriergerade_Feuchte.eps','-depsc');

%% Versuchsteil E