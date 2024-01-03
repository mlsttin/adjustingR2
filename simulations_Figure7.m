% Simulation for model comparison
%% define parameters here
clc;clearvars;close all;   
srng         = rng('default'); %restart random number generator seed
simtype      = 'R2vsNtr';                             % modality of simulation R2 vs n_training
nsteps       = 20;                                    % number of steps in the grid
narray       = [floor(linspace(50 ,500,nsteps)) ];    % array of training sample size to be explored (independent variable)
nTE          = 1000;                                  % number of test samples (fixed)
p1           = 10;                                    % model1 dimensionality (fixed)
p2           = 20;                                    % model1 dimensionality (fixed)
snrSEL       = 0.4;                                  % SNR (fixed)
lambdaOPT    = 0;                                     % regularization parameter (OLS: lambda is zero)  
nrep         = 100;                                   % number of repetitions (voxels)
b1           = randn(p1,1);                           % model1 coefficients
b2           = 1.5*randn(p2,1);                       % model2 coefficients the 1.5 factor ensures the bigger model has larger R2 (this is our example in Figure 7)
S1           = eye(p1);                               % covariance between features of M1
S2           = eye(p2);                               % covariance between features of M2
S12          = zeros(p1,p2);                          % covariance between M1-M2
S            = [[S1 S12]; [S12' S2] ];                % covariance matrix for all the features
%%
for it = 1:nsteps
    disp(['iteration ' ,num2str(it)])
    n     = narray(it);              
    for itrep = 1:nrep % loop across repetitions (voxels)                
        %% create data: R1pop and R2pop do not change across the simulation
        [X1,X2, Y,X1test,X2test, Ytest, e , etest,R1pop,R2pop] = create_data_modelcomparison(n,nTE,b1,b2,S,snrSEL);
        %% R2 adjustment
        [R2adj1(it,itrep), R2tr1(it,itrep), R2outAdj1(it,itrep), R2te1(it,itrep)]  =  adjustR2(X1,Y,0,X1test,Ytest );
        [R2adj2(it,itrep), R2tr2(it,itrep), R2outAdj2(it,itrep), R2te2(it,itrep)]  =  adjustR2(X2,Y,0,X2test,Ytest );
    end
end
%% Create figure
figpdf       = 'Figure7'; % figure name
figurefolder =  fullfile(pwd,'\figures\');mkdir(figurefolder); 
create_Figure_7;