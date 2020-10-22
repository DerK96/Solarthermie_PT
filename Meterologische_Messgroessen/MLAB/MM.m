%% Init
clc;
clear;
close all;
%% Import Data
d.Radiation = importfile2('../200909_MeteoMess_Teil A+B_Solarstrahlung.xlsx'); %aus überordner
d.Response = importfile3('../190919_MeteoMess_Teil B_Ansprechzeiten.xlsx')
d.Humidity = importfile('../Niederschlag_Luftfeuchte_ 04.09.2020 14_34_57.csv');
d.Humidity2 = importfile('../Relative Luftfeucht_Teil_C04.09.2020 14_18_43.csv');
d.Wind = importfile4('../200901_Winddaten.xlsx');
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
xlabel('elapsed time [t] in s')
ylabel('Strahlung in $\frac{W}{m^2}$')
pbaspect([3 1 1])
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
xlabel('elapsed time [t] in s')
ylabel('Strahlung $\frac{W}{m^2}$')
pbaspect([3 1 1])
legend(names2,'location','east')
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

t3 = d.Humidity.Scan;
Hum = d.Humidity.RelativeFeuchteinV;
HumNaCl = mean(Hum(1400:1500));
HumLiCl = mean(Hum(3024:3124));
StdNaCl = std(Hum(1400:1500));
StdLiCl = std(Hum(3024:3124));


names3 = {'Temperatur','Spannung'}
figure % Messverlauf der Temperatur/Feuchtemessung
hold on
grid on
plot(d.Humidity2.Scan,d.Humidity2.TemperatureC)
plot(d.Humidity2.Scan,d.Humidity2.RelativeFeuchteinV)
xlabel('elapsed time [t] in s')
ylabel('Rel. Feuchte [U] in V / Temp. [T] in $^{\circ}C$')
pbaspect([3 1 1])
legend(names3,'location','east')
run plotsettings.m
print('../DATA/Messreihe_Umgebung.eps','-depsc');
hold off

FitHum = [HumLiCl,12;HumNaCl,75]; %Gemessene Spannungen und Literaturwerte

figure
hold on
grid on
plot(t3,Hum)
xlabel('elapsed time [t] in s')
ylabel('Spannung [U] in V')
pbaspect([3 1 1])
run plotsettings.m
print('../DATA/Messreihe_Feuchtekalibration.eps','-depsc');
hold off

figure 
f = fit(FitHum(:,1),FitHum(:,2),'poly1')
hold on
grid on
plot(f,FitHum(:,1),FitHum(:,2))
legend('location','southeast')
ylabel('Relative Luftfeuchte in \%')
xlabel('Spannung [U] in V')
pbaspect([3 1 1])
run plotsettings.m
print('../DATA/Kalibriergerade_Feuchte.eps','-depsc');


%% Versuchsteil E

Rain = d.Humidity.Niederschlag;

figure 
hold on
grid on
plot(t3,Rain)
%legend('location','best')
ylabel('Anzahl Impulse')
xlabel('elapsed time [t] in s')
pbaspect([3 1 1])
run plotsettings.m
print('../DATA/Messreihe_Niederschlag.eps','-depsc');

SensArea = 3.1415*(0.165/2)^2

%% Versuchsteil F

Windspd = d.Wind.Windgeschwindigkeitinmpros;
Winddir = d.Wind.WindrichtunginGrad;
tWind = d.Wind.Scan;

figure 
grid on
plot(tWind,Windspd)
%legend('location','best')
ylabel('Windgeschwindigkeit [v] in $\frac{m}{s}$')
xlabel('elapsed time [t] in s')
run plotsettings.m
print('../DATA/Windgeschwindigkeit.eps','-depsc');

figure 
grid on
plot(tWind,Winddir)
%legend('location','best')
ylabel('Windrichtung in $^{\circ}$')
xlabel('elapsed time [t] in s')
run plotsettings.m
print('../DATA/Windrichtung.eps','-depsc');

%Windrichtung Verteilung
figure 
grid on
edges = [0 46 91 136 181 226 271 316 359]
histogram(Winddir,8,'Normalization','probability','BinEdges',edges)
%legend('location','best')
xlabel('Windrichtung in $^{\circ}$')
ylabel('Relative Häufigkeit')
run plotsettings.m
print('../DATA/WinddirCN.eps','-depsc');

% Windgeschwindigkeit Verteilung
figure 
grid on

histogram(Windspd,8,'BinWidth',1,'Normalization','probability')
%legend('location','best')
xlabel('Windrichtung in Klassen')
ylabel('Relative Häufigkeit')
run plotsettings.m
print('../DATA/WindspdCN.eps','-depsc');