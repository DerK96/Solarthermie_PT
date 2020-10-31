function errVal = calcErrorY(Vp,T_out,T_in,rhoH2O,cP_H2O,VpSens)

% define Errorspans 
dErrT_in = 2;
dErrT_out = 2;
if VpSens == 0 %Vortex Sensor
    dErrVp = 18; % 1% v.E bei Vp_max = 900l/h (Wert immer kleiner als 50% FS)
elseif VpSens == 1 %MID Sensor
    dErrVp = 0.03*Vp*2;
else
    error('Input invalid!')
end

% calculate partial errors
err1 = abs(rhoH2O*cP_H2O*(T_out-T_in)*dErrVp);
err2 = abs(Vp*rhoH2O*cP_H2O*dErrT_in);
err3 = abs(Vp*rhoH2O*cP_H2O*dErrT_out);

% build max error 
errGes = [err1 err2 err3];
errVal = sum(errGes)/3600;

end