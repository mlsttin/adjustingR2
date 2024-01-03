function [X,Y, Xtest,Ytest, e , etest] = create_data(n,nTE,p,b,S,snrSEL)
% generate X data
        X         = 1.*mvnrnd(zeros(p,1),S,n);      % create Xtraining feat covariance matrix S
        Xtest     = 1.*mvnrnd(zeros(p,1),S,nTE);    % create Xtest     feat covariance matrix S
        X         = [X ,   ones(n,1)  ];            % add intercept
        Xtest     = [Xtest,ones(nTE,1)];            % add intercept                 
%% generate Y with a fixed snrSEL
        s         = sqrt((1 - snrSEL)*( b'*b - b(end)^2 )./snrSEL); % scale the noise for obtaining desired SNR
        e         = s.*randn(n,1);                                  % create training data noise
        etest     = s.*randn(nTE,1);                                % create test     data noise
        Y         = X*b     + e;                                    % create training data
        Ytest     = Xtest*b + etest;                                % create test     data    
