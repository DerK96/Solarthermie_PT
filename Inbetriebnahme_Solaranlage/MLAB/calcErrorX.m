function errVal = calcErrorX(T_in,T_out,T_amb,G)

% define Errorspans 
dErrT_in = 2;
dErrT_out = 2;
dErrT_amb = 2;
dErrG = G*0.15*2;

% calculate partial errors
err1 = abs(G/2*dErrT_in);
err2 = abs(G/2*dErrT_out);
err3 = abs(-(1/G)*dErrT_amb);
err4 = abs(((T_out/2)+(T_in/2)+(T_amb/G^2))*dErrG);

% build max error 
errGes = [err1 err2 err3 err4];
errVal = sum(errGes)/1000;

end