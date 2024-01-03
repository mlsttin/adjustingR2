clc;clear all;close all
% requires the Matlab Deep Learning Toolbox
%% load data
addpath(genpath('D:\alg2023\npy-matlab-master' ));                                         % path to npy-matlab toolbox
roifolder   = 'D:\alg2023\data\subj01\roi_masks';                                  
roifilesLH  = dir([roifolder,filesep,'lh*_challenge_space.npy']);                          % reading the ROI definition file
itroi       = 5;                                                                           % select ROI
allLH       = double(readNPY([roifolder,filesep,roifilesLH(itroi).name]));
fMRIfolder  = 'D:\alg2023\data\subj01\training_split\'
Y           = double(readNPY([fMRIfolder,filesep,'training_fmri\lh_training_fmri.npy']));  % reading the brain response maps
%% define net from matlab DNN toolbox
net       = alexnet;
inputSize = net.Layers(1).InputSize;
%% read images and store them
imgfolder   = 'D:\alg2023\data\subj01\training_split\training_images';             
fnames      = dir([imgfolder,'\*.png']); % folder to training imagesc 
I1          = zeros(inputSize(1),inputSize(2),inputSize(3),length(fnames));
for it = 1:length(fnames)
    disp(it)
    I                     = imread([imgfolder, filesep,fnames(it).name ]);
    I1(:,:,:,it)          = imresize(I,inputSize(1:2));
end
%% get activations from AlexNet
      selectedlayer = 'fc8';   
%     selectedlayer = 'fc6';   
      scoreZ = activations(net,I1,selectedlayer,'OutputAs','rows'); % squeeze net
      clear I1;
%     save(['D:/ccaR2/R2/features',selectedlayer,'.mat'],'X');
%% scale features?
switch selectedlayer
    case 'fc6'
        scoreZ     = scoreZ./10;
end
[n p] = size(scoreZ); nvox  = sum(allLH==1); 
%% mean of Y seems to be critical
maxit   = 500;%2*p;% + 100;
clear   ntr; clear R2outAdj; clear R2tr; clear R2adj; clear R2te;
kk      = 1;
lI      = 1e2*eye(p+1);
%   fittype   = 'ols';
    fittype   = 'ridge';
%   fittype   = 'gcv';
%% R2bigN
Y         = Y(: , allLH==1 ); % select one ROI
Xbig      = [scoreZ ones(n,1)];
bHatOLS   = Xbig\Y;
Yhat      = Xbig*bHatOLS; E    = Y - Yhat; 
R2true    = 1 - sum(E.^2)./sum( (Y - mean(Y) ).^2 );
R2true    = 1 - (1-R2true).*(size(Xbig,1)-1)./( size(Xbig,1) - size(Xbig,2) );% R2 Ezekiel adjustment Xbig contain the intercept
%% 
ntr0      = 500;  ntr1 = 2000; nte       = 500; 
for(it =ntr0:ntr1) % ridge
    maxit = ntr1;disp(it);
    indperm     = randperm(n);  scoreZ  = scoreZ(indperm,:); Y = Y(indperm,:); % assuring randomized samples are taking every time
    indTR       = 1:floor(it);  indTE = (maxit+1):(maxit+nte);
    [Xtr , Xte, Ytr , Yte] = split_training_and_test(scoreZ,Y, indTR,indTE);
    ntr(kk)     = size(Ytr,1);  nte = size(Yte,1);
    [R2adj(kk,:), R2tr(kk,:), R2outAdj(kk,:), R2te(kk,:)] = adjustR2acrossvoxels(Xtr,Ytr,lI,Xte,Yte );
    kk = kk+1;
end
%% save results for the model comparison figure
save([selectedlayer1,'_',fittype,'__',num2str(ntr1),'.mat'],'R2tr','R2te','R2adj','R2outAdj','R2true','ntr','p');
%% figure for individual models
fs = 14;figure('Color',[1,1,1]);subplot(221);
ltr = plot(ntr, median(R2tr,2), 'LineWidth',2,'Color',[.6 .6 .6]);
hold all;grid on;xlim([min(ntr)  max(ntr)])
plot(xlim(),[0 ,0],'k--','Color',[0.5 0.5 0.5])
vR2tr   =  var(R2tr');
vR2adj  =  var(R2adj');
        fill([ntr  flip(ntr)],[median(R2tr') - vR2tr  flip( median(R2tr') + vR2tr )],[.6 .6 .6],'facealpha',.7,'edgealpha',0);% show quantiles
ladj  = plot(ntr,median(R2adj,2),'LineWidth',2,'Color',[ 0.5412 ,   0.1686 ,   0.8863]);
        fill([ntr  flip(ntr)],[median(R2adj') - vR2adj  flip( median(R2adj') + vR2adj )],[ 0.5412 ,   0.1686 ,   0.8863],'facealpha',.7,'edgealpha',0);% show quantiles
ltrue = plot(xlim(),[median(R2true) median(R2true)],'g--','LineWidth',2);
ylim([-0.5 1]);xlim([ntr(1) ntr(end)])

xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
ylabel('$R^2$','interpreter','Latex','fontSize',fs+4)
switch fittype
    case 'ridge'
    title(['in sample ',selectedlayer,' p = ', num2str(p), ' $ log10(\lambda) = $' , num2str(log10(100))],'interpreter','Latex','fontSize',fs+4)
    plot([p p],ylim(),'k--')
    case 'ols'
    title(['OLS: In of sample p = ', num2str(m1.p)],'interpreter','Latex','fontSize',fs+4)
end
h = gca(); set(h,'FontSize',fs);

subplot(222);
lte = plot(ntr,median(R2te,2),'LineWidth',2,'Color',[.6 .6 .6]); hold all;grid on;
plot(xlim(),[0 ,0],'k--','Color',[0.5 0.5 0.5])
vR2te = var(R2te');
vR2outAdj = var(R2outAdj');
fill([ntr  flip(ntr)],[median(R2te') - vR2te  flip( median(R2te') + vR2te )],[.6 .6 .6],'facealpha',.7,'edgealpha',0);% show quantiles
ladj  = plot(ntr,median(R2outAdj,2),'LineWidth',2);

fill([ntr  flip(ntr)],[median(R2outAdj') - vR2outAdj  flip( median(R2outAdj') + vR2outAdj )],[ 0.5412 ,   0.1686 ,   0.8863],'facealpha',.7,'edgealpha',0);% show quantiles
ltrue = plot(xlim(),[median(R2true) median(R2true)],'g--','LineWidth',2);
ylim([-0.5 1]);xlim([ntr(1) ntr(end)]);yl = ylim();
switch fittype
    case 'ridge'
    plot([p p],yl,'k--')
end
xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
ylabel('$R^2$','interpreter','Latex','fontSize',fs+4)
title(['out of sample ',selectedlayer,' p = ', num2str(p), ' $ log10(\lambda) = $' , num2str(log10(100))],'interpreter','Latex','fontSize',fs+4)
h = gca(); set(h,'FontSize',fs);

%
breaks = linspace(-1,1,60);selsim = find(ntr == 1000);
subplot(223);
ladj     = histfit(R2adj(selsim,:)   ,31,'kernel'); hold all;     ladj(1).FaceAlpha  = 0.3; ladj(1).EdgeAlpha  = 0;       ladj(2).Color  = [ 0.5412 ,   0.1686 ,   0.8863];  ladj(1).FaceColor  = [ 0.5412 ,   0.1686 ,   0.8863];ladj(2).LineWidth = 4;
ltr      = histfit(R2tr(selsim,:)    ,31,'kernel'); hold all;     ltr(1).FaceAlpha   = 0.3; ltr(1).EdgeAlpha   = 0;       ltr(2).Color   = [.6 .6 .6];                       ltr(1).FaceColor   =   [.6 .6 .6]; ltr(2).LineWidth = 4;  
ltrue    = histfit(R2true            ,31,'kernel'); hold all;     ltrue(1).FaceAlpha = 0.3; ltrue(1).EdgeAlpha = 0;       ltrue(2).Color = [0 1 0];                          ltrue(1).FaceColor = [0 1 0];      ltrue(2).LineWidth = 4;
xlabel('$R^2$','interpreter','Latex','fontSize',fs+4)
ylabel('counts','interpreter','Latex','fontSize',fs+4)
title(['in-sample $\mathbf{n_{tr}}= $' , num2str(ntr(selsim))],'interpreter','Latex','fontSize',fs+4)
l = legend([ltr(2) ladj(2) ltrue(2)],{'$\hat{R}^2_{in}$','$\hat{R}^2_{adj}$','$\hat{R}^2_{nmax }$'},'interpreter','Latex' , 'FontSize',fs,'Location','northwest');
% ylim([0 150]);
xlim([-0.6 0.8])

subplot(224);
ladj     = histfit(R2outAdj(selsim,:) ,31,'kernel'); hold all;     ladj(1).FaceAlpha  = 0.3; ladj(1).EdgeAlpha  = 0;       ladj(2).Color  = [ 0.5412 ,   0.1686 ,   0.8863];  ladj(1).FaceColor  = [ 0.5412 ,   0.1686 ,   0.8863];ladj(2).LineWidth = 4;
lte      = histfit(R2te(selsim,:)     ,31,'kernel'); hold all;     lte(1).FaceAlpha   = 0.3; lte(1).EdgeAlpha   = 0;       lte(2).Color   = [.6 .6 .6];                       lte(1).FaceColor   =   [.6 .6 .6];   lte(2).LineWidth = 4;
ltrue    = histfit(R2true             ,31,'kernel'); hold all;     ltrue(1).FaceAlpha = 0.3; ltrue(1).EdgeAlpha = 0;       ltrue(2).Color = [0 1 0];                          ltrue(1).FaceColor = [0 1 0];ltrue(2).LineWidth = 4;


ylabel('counts','interpreter','Latex','fontSize',fs+4);xlim([-0.6 0.8]);
xlabel('$R^2$','interpreter','Latex','fontSize',fs+4)
title(['out of sample $\mathbf{n_{tr}}= $',  num2str(ntr(selsim)) ],'interpreter','Latex','fontSize',fs+4)
l           = legend([lte(2) ladj(2) ltrue(2)],{'$\hat{R}^2_{o}$','$\hat{R}^2_{adj}$','$\hat{R}^2_{nmax }$'},'interpreter','Latex' , 'FontSize',fs,'Location','northeast');
simulations = '';

% namesave = ['algonauts_R2_sample_size_' , selectedlayer1,fittype,simulations ];
% set(gcf,'units','centimeters','position',[3 1 29.5 20.5],'color',[1 1 1])
% set(gcf,'PaperOrientation','landscape','PaperPositionMode','auto','papertype',['A4']);
% print(gcf,'-dpdf',fullfile(pwd,namesave));