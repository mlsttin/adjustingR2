clc;clear all;close all;
nsteps    = 100; nrep = 50;
ntr_array = floor(linspace(50,500,nsteps));
nte_array = zeros(1,nsteps) + 500;
p         = 10;
b         = randn(p,1);
s         = 5;
lI        = 1e0*eye(p);
for it = 1:nsteps
    for itr  = 1:nrep
        % training data             % test data
        ntr    = ntr_array(it);   nte = nte_array(it);
        Xtr  = randn(ntr,p);    Xte =   randn(nte,p);
        etr = s*randn(ntr,1);  ete = s*randn(nte,1);
        ytr = Xtr*b + etr;     yte = Xte*b + ete;
        [R2inadj(itr,it), R2in(itr,it), R2oadj(itr,it), R2o(itr,it)]  =  adjustR2(Xtr,ytr,lI,Xte,yte );
    end
end
%%
R2inadj = mean(R2inadj);  R2in = mean( R2in); 
R2oadj  = mean(R2oadj);   R2o  = mean(R2o);
%%
figure('Color',[1,1,1]);
subplot(221)
plot(ntr_array,R2in,'LineWidth',2); hold all
plot(ntr_array,R2inadj,'LineWidth',2);
xlabel('training set size');ylabel('R2');title('in-sample');legend('Rin','Rinadj')
subplot(222)
plot(ntr_array,R2o,'LineWidth',2); hold all
plot(ntr_array,R2oadj,'LineWidth',2);
xlabel('training set size');ylabel('R2');title('out-of-sample');legend('Ro','Roadj')
%% save data for numerically checking closs platforms
save('C:\data\work\regcca\R2\codes4submission\check\Xtr.txt','Xtr','-ascii');
save('C:\data\work\regcca\R2\codes4submission\check\Xte.txt','Xte','-ascii');
save('C:\data\work\regcca\R2\codes4submission\check\ytr.txt','ytr','-ascii');
save('C:\data\work\regcca\R2\codes4submission\check\yte.txt','yte','-ascii');
save('C:\data\work\regcca\R2\codes4submission\check\check.mat','Xtr','Xte','ytr','yte')
[R2adj1 R2tr1 R2oadj1 R2o1]=adjustR2(Xtr,ytr,lI,Xte,yte );