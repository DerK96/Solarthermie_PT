%Druckverlust
%% Init
clc;
clear;
close all;
%% Import Data
d1.h600 = importfile('../DATA/Volumenstrom600l-h_07.09.2020 09_36_04.csv');
d1.h1310 = importfile('../DATA/Volumenstrom1310l-h_07.09.2020 09_31_25.csv');
d1.h2147 = importfile('../DATA/Volumenstrom2147l-h_07.09.2020 09_25_42.csv');
d1.h2855 = importfile('../DATA/Volumenstrom2855l-h_07.09.2020 09_14_37.csv');
%% init constants
NennVp = [600;1310;2147;2855];  %[L/h]
NennVpSI = NennVp./3600000;     %[m^3/s]
%% calc Verlust aus Messung
fn = fieldnames(d1);
for i=1:numel(fn)
    meanDP(:,i) = mean(table2array(d1.(fn{i})(:,15)));
end

meanDP = meanDP.*100; %[mbar] -> [pa]
dPBhs = 0.000155*(NennVp.^2)+0.0967*NennVp-37.7; %[pa]
dPBhs = dPBhs';

dPKr = meanDP - dPBhs;

%% Rohrreibung (Rechnung)
meanDP = meanDP';
di = 16.8*10^-3;
d1 = 19.3*10^-3;
d2 = 33*10^-3;
did2 = (di/d2)^2;
zetaRohrQ = 0.5; % aus Abbildung 6.1
nQuerRohr = 12;
A1 = ((d1/2)^2)*pi;
A2 = ((d2/2)^2)*pi;
t = 25;
l = 1.1;
rho = 1000.6-0.0426*t-0.0041*t^2;
v_inf = NennVpSI ./ A1; %[m/s]
q = (rho/2).*(v_inf.^2);
eta = (554.78+19.73*t+0.128*t^2-2.69*10^-4+t^3)^-1;
Re = (v_inf.*d1*rho)/eta;
lambda = (meanDP./q)*(d1/l);
dA = A1/A2;
zetaAng = 0.08;
zeta = 2*zetaAng*(zetaRohrQ*nQuerRohr);

dPReib = ((rho/2)*(v_inf).^2).*lambda*(l/d2)+((rho/2)*(v_inf).^2).*zeta;

%% plot Vergleich Mesung Rechnung
figure
hold on
plot(NennVp,dPKr,'-x');
plot(NennVp,dPReib,'-.o')
grid on
xlabel('Durchfluss [$\frac{L}{h}$]')
ylabel('Druckverlust [$pa$]') 
legend('Messung','Rechnung','location','best')
run plotsettings.m
printPath = '../DATA/dPPlot';
print(printPath,'-depsc');

%% zeta-gewichtet

zetaTeil = 2*((dPKr')./(rho*(v_inf.^2)));
zetaGew = (sum(NennVpSI.*zetaTeil))/(sum(NennVpSI));
disp(zetaGew)
