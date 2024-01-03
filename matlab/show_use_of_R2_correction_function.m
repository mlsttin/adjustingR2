clc;clearvars;close all;
% authors: Agustin Lage Castellanos and Giancarlo Valente
%          a.lagecastellanos@maastrichtuniversity.nl giancarlo.valente@maastrichtuniversity.nl
nsteps    = 100;                            % number of training set sizes
nrep      = 50;                             % number of test set sizes
ntr_array = floor(linspace(50,500,nsteps)); % create training set size array
nte_array = zeros(1,nsteps) + 500;          % create test set size array (constant)
p         = 10;                             % number of features
b         = randn(p,1);                     % vector of coefficients
s         = 5;                              % noise scaling
lI        = 1e0*eye(p);                     % regularization parameter

for it = 1:nsteps % loop across training set size steps
    for itr  = 1:nrep % loop across repetitions
        ntr    = ntr_array(it);   nte = nte_array(it);  % training and test set sizes
        Xtr  = randn(ntr,p);      Xte =   randn(nte,p); % generated Xtraining and Xtest
        etr = s*randn(ntr,1);     ete = s*randn(nte,1); % generate  noise training and test
        ytr = Xtr*b + etr;        yte = Xte*b + ete;    % generate  training and test responses
        % adjust R2
        [R2inadj(itr,it), R2in(itr,it), R2oadj(itr,it), R2o(itr,it)]  =  adjustR2(Xtr,ytr,lI,Xte,yte );
    end
end
%% average across repetitions
R2inadj = mean(R2inadj);  R2in = mean( R2in); 
R2oadj  = mean(R2oadj);   R2o  = mean(R2o);
%% create figure
figure('Color',[1,1,1]);
subplot(221)
plot(ntr_array,R2in,'LineWidth',2); hold all;plot(ntr_array,R2inadj,'LineWidth',2);
xlabel('training set size','interpreter','Latex');ylabel('R2','interpreter','Latex');title('in-sample','interpreter','Latex');legend('Rin','Rinadj','interpreter','Latex')
subplot(222)
plot(ntr_array,R2o,'LineWidth',2); hold all;plot(ntr_array,R2oadj,'LineWidth',2);
xlabel('training set size','interpreter','Latex');ylabel('R2','interpreter','Latex');title('out-of-sample','interpreter','Latex');legend('Ro','Roadj','interpreter','Latex')
%% save data for numerically cross checking R and py codes
% save('C:\data\work\regcca\R2\codes4submission\check\Xtr.txt','Xtr','-ascii');
% save('C:\data\work\regcca\R2\codes4submission\check\Xte.txt','Xte','-ascii');
% save('C:\data\work\regcca\R2\codes4submission\check\ytr.txt','ytr','-ascii');
% save('C:\data\work\regcca\R2\codes4submission\check\yte.txt','yte','-ascii');
% save('C:\data\work\regcca\R2\codes4submission\check\check.mat','Xtr','Xte','ytr','yte')
% [R2adj1 R2tr1 R2oadj1 R2o1]=adjustR2(Xtr,ytr,lI,Xte,yte );