function [R2inadj, R2in,R2oadj, R2o] = adjustR2acrossvoxels(Xtr,ytr,lI,Xte,yte )
%% 
% Xtr  n x p training X data
% ytr  n x 1 training y data
% lI   p x p regularization matrix
% Xte  n x p test X data: if not present the last two output arguments are zero
% yte  n x p test y data
%%
if(nargin == 2 )
   lI   = 0;
end
if(nargin < 4 )
   Xte  = Xtr; 
   yte  = ytr;
end
%% defining important matrices
ntr           = size(Xtr,1); [nte p] = size(Xte);
Cte           = eye(nte) - (1./nte).*ones(nte,1)*ones(1,nte);  % Centering out-of-sample    data
Ctr           = eye(ntr) - (1./ntr).*ones(ntr,1)*ones(1,ntr);  % Centering in-sample        data
Xplus         =  (Xtr'*Xtr + lI)\Xtr';                         
Htr           =  Xtr*Xplus;                                    % Hat matrix in-sample
Hte           =  Xte*Xplus;                                    % Hat matrix out-of-sample 
Rtr           =  Xtr - Htr*Xtr;                     
Rte           =  Xte - Hte*Xtr;                     
%% get R2in and R2out
etr           = ytr - Htr*ytr;                                 % residuals in-sample
ete           = yte - Hte*ytr;                                 % residuals out-of-sample
R2in          = 1 - diag(etr'*etr)./diag(ytr'*Ctr*ytr);                % R2 in-sample
R2o           = 1 - diag(ete'*ete)./diag(yte'*Cte*yte);                % R2 out-of-sample
%% constants for R2in: see Table 2
K         = -Htr*Htr' + 2*Htr';
kop       =  trace(K)./ntr;                        % optimism
ksh       = -trace(Rtr'*Rtr) /trace(Xtr'*Ctr*Xtr); % shrinkage in-sample
%% constants for R2out: see Table 2
kpess     =  -trace(Hte'*Hte)/(nte);               % pessimism
kshO      =  -trace(Rte'*Rte)/trace(Xte'*Cte*Xte); % shrinkage out-of-sample
%% adjusting estimates
R2inadj       = (R2in  - kop)./(1 - kop + ksh);                 % Eq 22
R2oadj        = (R2o  - kpess)./(1 - kpess + kshO);            % Eq 21
%% If no out-of-sample is needed
if(nargin < 4 ) R2oadj = 0;  R2o   = 0; end
