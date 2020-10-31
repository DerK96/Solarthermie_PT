function errVal = calcErrorY(Vp,T_out,T_in,rhoH2O,cP_H2O,VpSens)

% define Errorspans 
dErrT_in = 2;
dErrT_out = 2;
if VpSens == 0 %Vortex Sensor
    dErrVp = 9; % 1% v.E bei Vp_max = 900l/h (Wert immer kleiner als 50% FS)
elseif VpSens == 1 %MID Sensor
    dErrVp = 0.03*Vp*2;
else
    error('Input invalid!')
end

% calculate partial errors
err1 = abs(G/2*dErrT_in);
err2 = abs(G/2*dErrT_out);
err3 = abs(-(1/G)*dErrT_amb);

% build max error 
errGes = [err1 err2 err3];
errVal = sum(errGes);

end