%% Init
clc;
clear;
close all;
%% Import Data
Fixpunktkalibration = importfile('../Fixpunktkalibration.csv');
%% Fixpunktkalibration

x = Fixpunktkalibration.Scan; %D
y = Fixpunktkalibration.RefC;
M = mean(Fixpunktkalibration.RefC(300:421));
S = std(Fixpunktkalibration.RefC(300:421));
offset = M-0.01;

%% plot Data
figure
hold on
plot(x,y);
plot(x,M)
xlabel('Scan [s]')
ylabel('Temperatur [$^{\circ}C]$')
run plotsettings.m
print('Fixpunktkalibration','-depsc');
hold off
%% import SensorData
d.d1 = importfile('../0001C.csv');
d.d2 = importfile('../1500C.csv');
d.d3 = importfile('../4000C.csv');
d.d4 = importfile('../8000C.csv');
%% 
dataPoints = 1:2:13; %start:step:stop
fn = fieldnames(d); % bezug auf d.d1 bis d.d4

for i = 1:numel(fn) %1 bis 4 numel=Anzahl Elemente von fn
    d.(fn{i})(:,3) = array2table(table2array(d.(fn{i})(:,3)) - offset);
    for k = 1:numel(dataPoints)
        curr = table2array(d.(fn{i})(:,3:15));
        m2(k,i) = mean(curr(size(curr,1)-20:size((curr),1),dataPoints(:,k)));
    end
end

disp(m2);
%% calc fits

m2t = m2'; %transformiere Matrix
syms x1;
for m = 1:size(m2t,2)
    [f{m},g{m}] = fit(m2t(:,1),m2t(:,m),'poly1');
    pfun{m} = f{m}.p1*x1+f{m}.p2;
    if m == size(m2t,2)-1
        [f{m},g{m}] = fit(m2t(:,1),m2t(:,m),'exp1');
        pfun{m} = f{m}.a*exp(f{m}.b*x1);
    end
end


%% plot Data
% linStyles = {'-x','-.o',':^','--s','-+','-.*'};
names = {'Pt100 (4L)';'Pt100 (2L)';'Pt1000';'KTY';'NTC'};
figure
for h = 1:5
    subplot(2,3,h)
    hold on
    grid on
    title(names{h})
    plot(m2(1,:),m2(h+1,:),'x','color','k');
    fplot(pfun{h+1},'color','r');
    xlabel('Temperatur [$^{\circ}C$]')
    ylabel('Widerstand [$\Omega$]')
    xlim([-10 85])
end
subplot(2,3,6)
hold on
plot(0,0,'x','color','k')
plot(0,0,'-','color','r')
axis off
legend('data','fit','location','east')
run plotsettings.m
print('Widerstandsgeraden','-depsc');

%% Vergleich 2L 4L

figure
hold on
plot(m2(1,:),m2(2,:),'-x');
plot(m2(1,:),m2(3,:),'-.o');
xlabel('Temperatur [$^{\circ}C$]')
ylabel('Widerstand [$\Omega$]')
run plotsettings.m
legend(names{1},names{2},'location','best')
print('Vergleich2L4L','-depsc');

%% Spannung
figure
hold on
grid on
plot(m2(1,:),m2(7,:),'x','color','k');
fplot(pfun{7},'color','r');
xlabel('Temperatur [$^{\circ}C$]')
ylabel('Spannung [$V$]')
legend('data','linear fit','location','best')
run plotsettings.m
print('Spannung','-depsc');
hold off

%% print coeffs

for i = 2:numel(f)
    tempVal = confint(f{i});
    tempVal = tempVal(2,:)-tempVal(1,:);
    rVals(i,:) = coeffvalues(f{i});
    confInts(i,:) = tempVal./2;
end

