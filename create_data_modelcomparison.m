function [X1,X2, Y,X1test,X2test, Ytest, e , etest,R1pop,R2pop] = create_data_modelcomparison(n,nTE,b1,b2,S,snrSEL)
% generate X data for Figure 7: model comparison
        p1        = size(b1,1);p2 = size(b2,1);
        S11       = S(1:p1,1:p1);  S22 = S((p1+1):end, (p1+1):end); S12 = S(1:p1,(p1+1):end);
        b         = [b1;b2];
        X         = 1.*mvnrnd(zeros(p1+p2,1),S,n);      % create Xtraining feat covariance matrix S
        Xtest     = 1.*mvnrnd(zeros(p1+p2,1),S,nTE);    % create Xtest     feat covariance matrix S
        X1        = X(:,1:p1);        X2      = X(:,(p1+1):end);
        X1test    = Xtest(:,1:p1);    X2test  = Xtest(:,(p1+1):end);
        %% generate Y with a fixed snrSEL
        s         = sqrt((1 - snrSEL)*( b'*b)./snrSEL);             % scale the noise for obtaining desired SNR
        e         = s.*randn(n,1);                                  % create training data noise
        etest     = s.*randn(nTE,1);                                % create test     data noise
        Y         = X1*b1     + X2*b2     + e;                      % create training data
        Ytest     = X1test*b1 + X2test*b2 + etest;                  % create test     data    
        %% population values
        R1pop = (b1'*S11*b1 + 2*b1'*S12*b2)./(b1'*S11*b1 + b2'*S22*b2 +  2*b1'*S12*b2 + s^2);
        R2pop = (b2'*S22*b2 + 2*b1'*S12*b2)./(b1'*S11*b1 + b2'*S22*b2 +  2*b1'*S12*b2 + s^2);