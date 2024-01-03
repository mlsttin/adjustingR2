clc;clear all;close all
fittype        = 'ridge';
ntr1           = 8000;
selectedlayer1 = 'fc8';    m1 = load([selectedlayer1,'_',fittype,'__',num2str(ntr1),'.mat']);
selectedlayer2 = 'fc6';    m2 = load([selectedlayer2,'_',fittype,'__',num2str(ntr1),'.mat']);
ntr           = m2.ntr';
selsim = find(ntr == 1000);
%% subset to smalles
% m1.R2adj      = m1.R2adj(m1.ntr <= m2.ntr(end),:);
% m1.R2outAdj   = m1.R2outAdj(m1.ntr <= m2.ntr(end),:);
% m1.R2te       = m1.R2te(m1.ntr <= m2.ntr(end),:);
% m1.R2tr       = m1.R2tr(m1.ntr <= m2.ntr(end),:);
%%
figure('Color',[1,1,1]);fs = 14;
set(gcf,'units','centimeters','position',[3 1 29.5 20.5],'color',[1 1 1])
subplot(221);hold all;
vdiffR2tr   =    var(m1.R2tr  - m2.R2tr,[],2);
mdiffR2tr   =    mean(m1.R2tr - m2.R2tr,2 );
        fill([ntr ; flip(ntr)],[mdiffR2tr - vdiffR2tr ; flip(mdiffR2tr + vdiffR2tr)],[.6 .6 .6],'facealpha',.7);% show quantiles
        plot(ntr, mdiffR2tr ,'LineWidth',2,'Color',[.6 .6 .6])

        vdiffR2adj   =    var(m1.R2adj  - m2.R2adj,[],2);
        mdiffR2adj   =    mean(m1.R2adj - m2.R2adj,2 );
        fill([ntr ; flip(ntr)],[mdiffR2adj - vdiffR2adj ; flip(mdiffR2adj + vdiffR2adj)],[ 0.5412 ,   0.1686 ,   0.8863],'facealpha',.7);% show quantiles
        plot(ntr, mdiffR2adj ,'LineWidth',2,'Color',[ 0.5412 ,   0.1686 ,   0.8863]);

        mdiffR2true   =    mean(m1.R2true - m2.R2true,2 );
        plot(xlim(),[mdiffR2true  mdiffR2true] ,'LineWidth',2,'Color',[ 0 ,   1 ,   0]);
        
        title(['Difference in-sample ', selectedlayer1,'$_{p=',num2str(m1.p) , '}-$',selectedlayer2,'$_{p=',num2str(m2.p) , '}$' ], 'interpreter','Latex','FontSize',fs+4);
        xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); 
        ylim([-0.5 0.4]);plot(xlim(),[0 ,0],'k--','Color',[0.5 0.5 0.5])
        plot([ntr(selsim) ntr(selsim)],ylim(),'k--')
        xlim([ntr(1) ntr(end)])


        

subplot(222);hold all;
        vdiffR2te   =    var(m1.R2te  - m2.R2te,[],2);
        mdiffR2te   =    mean(m1.R2te - m2.R2te,2 );
        fill([ntr ; flip(ntr)],[mdiffR2te - vdiffR2te ; flip(mdiffR2te + vdiffR2te)],[.6 .6 .6],'facealpha',.7,'edgealpha',0);% show quantiles
        plot(ntr, mdiffR2te ,'LineWidth',2,'Color',[.6 .6 .6])
        
        vdiffR2adjO   =    var(m1.R2outAdj  - m2.R2outAdj,[],2);
        mdiffR2adjO   =    mean(m1.R2outAdj - m2.R2outAdj,2 );
        fill([ntr ; flip(ntr)],[mdiffR2adjO - vdiffR2adjO ; flip(mdiffR2adjO + vdiffR2adjO)],[ 0.5412 ,   0.1686 ,   0.8863],'facealpha',.7);% show quantiles
        plot(ntr, mdiffR2adjO ,'LineWidth',2,'Color',[ 0.5412 ,   0.1686 ,   0.8863]);
   
        mdiffR2true   =    mean(m1.R2true - m2.R2true,2 );
        plot(xlim(), [mdiffR2true  mdiffR2true],'LineWidth',2,'Color',[ 0 ,   1 ,   0]);
       
        title(['Difference out-of-sample ', selectedlayer1,'$_{p=',num2str(m1.p) , '}-$',selectedlayer2,'$_{p=',num2str(m2.p) , '}$' ], 'interpreter','Latex','FontSize',fs+4);
        xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
        ylim([-0.5 0.4]);plot(xlim(),[0 ,0],'k--','Color',[0.5 0.5 0.5])
        plot([ntr(selsim) ntr(selsim)],ylim(),'k--');        xlim([ntr(1) ntr(end)])



%% histograms       
breaks = linspace(-0.5,1,60);
subplot(223);
ladj     = histfit(m1.R2adj(selsim,:)    - m2.R2adj(selsim,:),31,'kernel'); hold all;    ladj(1).FaceAlpha  = 0.3; ladj(1).EdgeAlpha  = 0;       ladj(2).Color  = [ 0.5412 ,   0.1686 ,   0.8863];  ladj(1).FaceColor  = [ 0.5412 ,   0.1686 ,   0.8863];                                   ladj(2).LineWidth = 4;
ltr      = histfit(m1.R2tr(selsim,:)     - m2.R2tr(selsim,:),31,'kernel'); hold all;     ltr(1).FaceAlpha   = 0.3; ltr(1).EdgeAlpha   = 0;       ltr(2).Color   = [.6 .6 .6];                       ltr(1).FaceColor   =   [.6 .6 .6];                                                      ltr(2).LineWidth = 4;
ltrue    = histfit(m1.R2true             - m2.R2true,31,'kernel'); hold all;             ltrue(1).FaceAlpha = 0.3; ltrue(1).EdgeAlpha = 0;       ltrue(2).Color = [0 1 0];                          ltrue(1).FaceColor = [0 1 0]; ltrue(1).EdgeAlpha = 0;       ltrue(2).Color = [0 1 0];   ltrue(2).LineWidth = 4;
xlabel(['$R^2_{',selectedlayer1,'}$ - $R^2_{',selectedlayer2,'}$' ],'interpreter','Latex','fontSize',fs+4)
ylabel('counts','interpreter','Latex','fontSize',fs+4)
title(['Difference in-sample $\mathbf{n_{tr}}= $' , num2str(ntr(selsim))],'interpreter','Latex','fontSize',fs+4)
l = legend([ltr(2) ladj(2) ltrue(2)],{'diff $\hat{R}^2_{in}$','diff $\hat{R}^2_{adj}$','diff $\hat{R}^2_{nmax }$'},'interpreter','Latex' , 'FontSize',fs,'Location','northeast');
% ylim([0 150])
xlim([-0.4 0.9])

subplot(224);
ladj     = histfit(m1.R2outAdj(selsim,:) - m2.R2outAdj(selsim,:),31,'kernel'); hold all; ladj(1).FaceAlpha  = 0.3; ladj(1).EdgeAlpha  = 0;       ladj(2).Color  = [ 0.5412 ,   0.1686 ,   0.8863];  ladj(1).FaceColor  = [ 0.5412 ,   0.1686 ,   0.8863];  ladj(2).LineWidth = 4;
lte      = histfit(m1.R2te(selsim,:)     - m2.R2te(selsim,:),31,    'kernel'); hold all;     lte(1).FaceAlpha   = 0.3; lte(1).EdgeAlpha   = 0;       lte(2).Color   = [.6 .6 .6];                       lte(1).FaceColor   =   [.6 .6 .6];                 lte(2).LineWidth = 4;
ltrue    = histfit(m1.R2true             - m2.R2true,31,            'kernel'); hold all;             ltrue(1).FaceAlpha = 0.3; ltrue(1).EdgeAlpha = 0;       ltrue(2).Color = [0 1 0];                          ltrue(1).FaceColor = [0 1 0];              ltrue(2).LineWidth = 4;
% ylim([0 150]);
xlim([-0.4 0.9]);
ylabel('counts','interpreter','Latex','fontSize',fs+4)
xlabel(['$R^2_{',selectedlayer1,'}$ - $R^2_{',selectedlayer2,'}$' ],'interpreter','Latex','fontSize',fs+4)
title(['Difference out-of-sample $\mathbf{n_{tr}}= $',  num2str(ntr(selsim)) ],'interpreter','Latex','fontSize',fs+4)
l = legend([lte(2) ladj(2) ltrue(2)],{'diff $\hat{R}^2_{o}$','diff $\hat{R}^2_{adj}$','diff $\hat{R}^2_{nmax }$'},'interpreter','Latex' , 'FontSize',fs,'Location','northeast');
%%
namesave = 'algonauts_R2_models_comparison';
set(gcf,'units','centimeters','position',[3 1 29.5 20.5],'color',[1 1 1])
set(gcf,'PaperOrientation','landscape','PaperPositionMode','auto','papertype',['A4']);
print(gcf,'-dpdf',fullfile(pwd,namesave));
