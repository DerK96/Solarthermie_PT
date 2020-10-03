%% Init
clc;
clear;
close all;
%% Import Data
d.d1 = importfile2('../200909_MeteoMess_Teil A+B_Solarstrahlung.xslx'); %aus überordner
%% Teil A
dataPoints = 1:2:19; %start:step:stop
fn = fieldnames(d); % bezug auf d.d1 bis d.d4

for i = 1:numel(dataPoints) %1 bis 4 numel=Anzahl Elemente von fn
    d.(fn{i})(:,3) = array2table(table2array(d.(fn{i})(:,3)) - offset);
    for k = 1:numel(dataPoints)
        curr = table2array(d.(fn{i})(:,3:15));
        m2(k,i) = mean(curr(size(curr,1)-20:size((curr),1),dataPoints(:,k)));
    end
end

disp(m2);
%% plot
figure
hold on
plot(d(2,:),d(4,:));
plot(d(2,:),d(6,:));
xlabel('Scan [s]')
ylabel('Temperatur [$^{\circ}C]$')
run plotsettings.m
%print('Fixpunktkalibration','-depsc');
hold off