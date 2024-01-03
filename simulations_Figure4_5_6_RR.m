%   this script inmplements the simulations for Figure 2
% def snr better all codes
outputfolder  = fullfile(pwd,'\output\');mkdir(outputfolder);
%%  R2 vs training set sample size (ntr)
clc;clear all;close all;   
simtype      = 'R2vsNtr';                             % modality of simulation R2 vs n_training
nsteps       = 10;                                    % number of steps in the grid
narray       = [floor(linspace(50 ,200,nsteps)) ];    % array of training sample size to be explored (independent variable)
nTE          = 1000;                                  % number of test samples (fixed)
p            = 100;                                    % model dimensionality (fixed)
snrSEL       = 0.25;                                  % SNR (fixed)
lambdaOPT    = 1e2;                                   % regularization parameter (OLS: lambda is zero)  
nrep         = 100;                                   % number of repetitions (voxels)
outputfile   = [simtype,'_p',num2str(p),'_nte',num2str(nTE),'_snr',num2str(snrSEL),'.mat']; % save results in this file
outputfile1  = outputfile;                            % keep the file name for creating the figure
outputfolder = fullfile(pwd,'\output\');              % where to save the results: important for plotting
run_analyses;                                         % run analyses

%% R2 vs test set sample size (nte)
clc;close all;clearvars -except outputfile1;         % keep the file names for creating the figures
simtype     = 'R2vsNte';                             % modality of simulation R2 vs n_test
nsteps      = 10;                                    % number of steps in the grid
narray      = floor(linspace(50 ,200,nsteps)) ;      % array  of test sample sizes to be explored (independent variable)
n           = 1000;                                  % number of training samples (fixed)
p           = 100;                                    % model dimensionality (fixed)
snrSEL      = 0.25;                                  % SNR fixed
lambdaOPT   = 1e2;                                     % regularization parameter (OLS: lambda is zero)  
nrep        = 100;                                   % number of repetitions (voxels)
outputfile  = [simtype,'_p',num2str(p),'_ntr',num2str(n),'_snr',num2str(snrSEL),'.mat']; % save results in this file
outputfile2  = outputfile;                            % keep the file name for creating the figure
outputfolder = fullfile(pwd,'\output\');             % where to save the results: important for plotting
run_analyses;                                        % run analyses

%% R2 vs model dimensionality (p)
clc;close all;
clearvars -except outputfile1 outputfile2;           % keep the file names for creating the figures
simtype      = 'R2vsModeldim'; ;                      % modality of simulation R2 vs model dim
nsteps       = 10;                                    % number of steps in the grid
nTE          = 1000;                                  % number of test samples (fixed)
n            = 50;                                   % number of training samples (fixed)
parray       = floor(linspace(10,200,nsteps));        % array of model dimensionalities (independent variable)
snrSEL       = 0.25;                                  % SNR fixed
lambdaOPT    = 1e2;                                     % regularization parameter (OLS: lambda is zero)  
nrep         = 100;                                   % number of repetitions (voxels)
outputfile   = [simtype,'_ntr',num2str(n),'_nte',num2str(nTE),'_snr',num2str(snrSEL),'.mat']; % save results in this file
outputfile3  = outputfile;                            % keep the file name for creating the figure
outputfolder = fullfile(pwd,'\output\');             % where to save the results: important for plotting
run_analyses;                                        % run analyses
%% R2 vs lambda
clc;close all;
clearvars -except outputfile1 outputfile2 outputfile3;           % keep the file names for creating the figures
simtype      = 'R2vslambdas';                                   % modality of simulation R2 vs model dim
nsteps       = 10;                                    % number of steps in the grid
lambdas      = 10.^linspace(-1,3,nsteps);             % grid of regularization parameters (independent variable)
nTE          = 1000;                                  % number of test samples (fixed)
n            = 50;                                    % number of training samples (fixed)
p            = 100;                                   % model dimensionality (fixed)
snrSEL       = 0.25;                                  % SNR fixed
nrep         = 100;                                   % number of repetitions (voxels)
outputfile   = [simtype,'_ntr',num2str(n),'_nte',num2str(nTE),'_snr',num2str(snrSEL),'.mat']; % save results in this file
outputfile4  = outputfile;                            % keep the file name for creating the figure
outputfolder = fullfile(pwd,'\output\');             % where to save the results: important for plotting
run_analyses;                                        % run analyses
%% Create Figure 4
%  combines the results of the three analyses in one figure. Loading  outputfile1 outputfile2 outputfile3
figpdf       = 'Figure4'; % figure name
figurefolder =  fullfile(pwd,'\figures\');mkdir(figurefolder); 
create_Figure_2; % valid for Figure2 and 4
%% Create Figure 5
figpdf       = 'Figure5'; % figure name
figurefolder =  fullfile(pwd,'\figures\');mkdir(figurefolder); 
create_Figure_5;
%% analyses for Figure 6
clc;clearvars                                
simtype        = 'R2vsNte';                             % modality of simulation R2 vs n_test
narray         = [50 1000] ; nsteps = 2;                % array  of test sample sizes to be explored (independent variable)
n              = 50;                                    % number of training samples (fixed)
p              = 100;                                    % model dimensionality (fixed)
snrSEL         = 0.25;                                  % SNR fixed
lambdaOPT      = 1e2;                                     % regularization parameter (OLS: lambda is zero)  
nrep           = 100;                                   % number of repetitions (voxels)
outputfile     = [simtype,'_p',num2str(p),'_ntr',num2str(n),'_snr',num2str(snrSEL),'inputFig3.mat']; % save results in this file
outputfileFig3 = outputfile;                            % keep the file name for creating the figure
outputfolder   = fullfile(pwd,'\output\');             % where to save the results: important for plotting
run_analyses;                                        % run analyses
%% create Figure 3
figpdf       = 'Figure6'; % figure name
figurefolder =  fullfile(pwd,'\figures\');mkdir(figurefolder); 
create_Figure_3