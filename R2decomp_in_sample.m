function [Tirr Topt Tcov Tsh algebraCheck]=R2decomp_in_sample(X,Y, e,b, lambdaI)
Xplus           =    inv(X'*X + lambdaI)*X';
Htest           =    (X*Xplus);
%%    R2 partition based on residuals
TSSte           = sum( (Y-mean(Y)).^2); % Total sum of squares
E               =  Y - Htest*Y;            % Residuals
R2              =  1 - sum( E.^2  )./TSSte;     % Explained Variance
%% R2 decomposition See Table 2
Rte             =  (X - Htest*X);
Tirr            = -(e'*e)./TSSte;
Topt            = -(e'*Htest*Htest'*e)./TSSte + (2*e'*Htest*e)./TSSte;
Tsh             = -(b'*Rte'*Rte*b)/TSSte;
Tcov            = -(2*e'*(X - Htest'*X)*b - 2*e'*Htest*(X- Htest'*X)*b )./TSSte;
algebraCheck    = R2 - (1 + Tirr + Topt + Tsh + Tcov); % has to be zero if the decomposition is correct
