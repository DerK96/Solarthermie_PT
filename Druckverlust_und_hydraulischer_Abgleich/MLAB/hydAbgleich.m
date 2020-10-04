%Druckverlust
%% Init
clc;
clear;
close all;
%% Import Data
VKennLinie = importfile('../DATA/Ventilkennlinie_07.09.2020 10_01_30.csv');
Ausprobieren = importfile('../DATA/HydraulischerAbgleich2.2_Ausprobieren 07.09.2020 10_42_54.csv');
VSRed = importfile('../DATA/HydraulischerAbgleich2.307.09.2020 10_58_00.csv');
Tichel = importfile('../DATA/Tichelmann07.09.2020 11_25_45.csv');
%% Init final_Vars
VentStep = [1 113 185 260 340 485 570 680 800 900 1020 1164;
            6.0 5.0 4.0 3.0 2.0 1.5 1.0 0.8 0.6 0.4 0.2 0.2];
%% split Data into Step Intervalls
data = struct;
for i = 1:size(VentStep,2)-1
    id = strcat('data',num2str(i));
    data.(id).VP = VKennLinie.V_Strang_2(VentStep(1,i):VentStep(1,i+1));
    data.(id).dP = VKennLinie.Differenzdruckinmbar(VentStep(1,i):VentStep(1,i+1));
end
%% cut first and last 10 data points
fn = fieldnames(data);
for k = 1:size(fn,1)
    data.(fn{k}).VP = data.(fn{k}).VP(10:(size(data.(fn{k}).VP)-10),:);
    data.(fn{k}).dP = data.(fn{k}).dP(10:(size(data.(fn{k}).dP)-10),:);
    VStrom(:,k) = mean(data.(fn{k}).VP);
    pVerlust(:,k) = mean(data.(fn{k}).dP);
end
%% calculate kV

kV = VStrom.*(sqrt((1*10^5)./(pVerlust)));

hGem = VentStep(2,:)./6;
kVGem = kV./kV(1,1);
%% plot Ventilkennlinie
figure
hold on
plot(kVGem,hGem(1:11),'-x')
grid on
% xlim([0 660])
xlabel('Durchfluss [$H/H_{100}$]')
ylabel('Druckverlust [$k_v/k_{vs}$]') 
%legend('Messung','Rechnung','location','best')
run plotsettings.m
printPath = '../DATA/Ventilkennlinie';
print(printPath,'-depsc');
%% Ausprobieren
figure
hold on
p1 = plot(Ausprobieren.Scan,Ausprobieren.V_Strang_1,'color','r');
plot(Ausprobieren.Scan,Ausprobieren.V_Strang_2,'color','r')
plot(Ausprobieren.Scan,Ausprobieren.V_Strang_3,'color','r')
p2 = plot(VSRed.Scan,VSRed.V_Strang_1,'-.','color','k');
plot(VSRed.Scan,VSRed.V_Strang_2,'-.','color','k')
plot(VSRed.Scan,VSRed.V_Strang_3,'-.','color','k')
legend([p1 p2],'Ausprobieren','Kompensationsmethode','location','best')
grid on
xlabel('vergangene Zeit [$s$]')
ylabel('Durchfluss $\left[\frac{L}{h}\right]$') 
run plotsettings.m
printPath = '../DATA/Ausprobieren';
print(printPath,'-depsc');

%% Tichel
figure
hold on
plot(Tichel.Scan,Tichel.V_Strang_1,':')
plot(Tichel.Scan,Tichel.V_Strang_2,'-.')
plot(Tichel.Scan,Tichel.V_Strang_3,'-')
legend('Strang 1','Strang 2','Strang 3','location','best')
grid on
xlabel('vergangene Zeit [$s$]')
ylabel('Durchfluss $\left[\frac{L}{h}\right]$') 
run plotsettings.m
printPath = '../DATA/Tichel';
print(printPath,'-depsc');
