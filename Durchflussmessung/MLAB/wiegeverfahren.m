%Waegeverfahren
%% Input Data
Waage = [60 507.1 515.06 9033.9; 120 507.9 237.75 7725.3; 240 507.9 123.03 8265.5; 360 510.8 83.66 9057.6; 480 510.2 64.69 8785.1; 660 511.8 50.28 8470.7];
%% Process Data
for i = 1 : size(Waage,1)
    df(:,i) = (Waage(i,4)/1000)/Waage(i,3);
end

dfLpH = df*3600; %für rhoH20=1000kg/m^3