% Durchflussmessung
%% Init
clc;
clear;
close all;
%% Import Data
d.h060 = importfile('../DATA/bak/060l-h_07.09.2020 16_15_40.csv');
d.h120 = importfile('../DATA/bak/120l-h_07.09.2020 16_27_41.csv');
d.h240 = importfile('../DATA/bak/240l-h_07.09.2020 16_35_40.csv');
d.h360 = importfile('../DATA/bak/360l-h_07.09.2020 16_42_15.csv');
d.h480 = importfile('../DATA/bak/480l-h_07.09.2020 16_47_24.csv');
d.h660 = importfile('../DATA/bak/660l-h_07.09.2020 16_53_33.csv');
tData = importfile('../DATA/bak/Versuch2_Temperatur_07.09.2020 16_59_22.csv');
%% Process Data
Sensor = [3 5 7 9 11 13 15];
sNames = fieldnames(d);
for i = 1:numel(sNames)
    s = size(d.(sNames{i}));
    FT = d.(sNames{i}).Zeit(s) - d.(sNames{i}).Zeit(1);
    for k = 1:size(Sensor,2)
%         if k == 1
%             for j = 1:size(d.(sNames{i})(:,Sensor(k)),1)
%                 if table2array(d.(sNames{i})(j,Sensor(k))) < 54
%                     d.(sNames{i})(j,Sensor(k)) = array2table(54);
%                 end
%             end
%         end
        if k == 6 
            for j = 1:size(d.(sNames{i})(:,Sensor(k)),1)
                d.(sNames{i})(j,Sensor(k)) = array2table((table2array(d.(sNames{i})(j,Sensor(k)))*1000));
            end
        end
        if k == 7 
            for j = 1:size(d.(sNames{i})(:,Sensor(k)),1)
                d.(sNames{i})(j,Sensor(k)) = array2table((table2array(d.(sNames{i})(j,Sensor(k)))/table2array(d.(sNames{i})(j,1))*3600));
            end
        end
        meanData(i,k) = mean(table2array(d.(sNames{i})(:,Sensor(k))));
        sigData(i,k) = std(table2array(d.(sNames{i})(:,Sensor(k))));
    end
end
%% calc refvalues
wiegeverfahren;
%% calc percentual deviation 
for n = 1 : size(meanData,2)%Sensoren
    for m = 1 : size(meanData,1)%Datensaetzen
        deviPc(m,n) = ((dfLpH(:,m)-meanData(m,n))/dfLpH(:,m))*100;
    end
end
%% plot deviation
figure
hold on
plot(dfLpH,deviPc(:,1),'-x');
plot(dfLpH,deviPc(:,2),'-.o');
plot(dfLpH,deviPc(:,5),':+');
plot(dfLpH,deviPc(:,6),'--s');
plot(dfLpH,deviPc(:,7),'-^');
grid on
xlim([0 660])
xlabel('wahrer Durchfluss [$\frac{L}{h}$]')
ylabel('prozentuale Abweichung [\%]')
legend('Vortex','US stat','MID','US mobil','RKZ','location','best')
run plotsettings.m
printPath = '../DATA/devPcPlot';
print(printPath,'-depsc');
%% plot Temperatures
figure
hold on
plot(tData.Scan,tData.T1C,'-x');
plot(tData.Scan,tData.T2C,'-.o');
grid on
%xlim([0 660])
xlabel('elapsed Time [s]')
ylabel('Temperature [$^{\circ} C$]')
legend('T1','T2','location','best')
run plotsettings.m
printPath = '../DATA/tempPlot';
print(printPath,'-depsc');
%% calc V dot with tempdev

tempDev = 90;       %[s]
dRohr = 20*10^-3;   %[m]
lRohr = 9.48;       %[m]

vPs = ((pi*(dRohr^2))*lRohr)/tempDev;
vPh = vPs*3600000;
%% Vdot for comparison (source MID)
VpMID = mean(tData.MIDinlproh);
