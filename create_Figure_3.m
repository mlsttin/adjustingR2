%% Get figure variance R2
outputfolder  = fullfile(pwd,'output');
load([outputfolder,filesep,outputfileFig3]); % load data
%%
fs = 16;
figure(236);clf, set(gcf,'units','centimeters','position',[3 1 29.5 20.5],'color',[1 1 1])
l  = [-0.4 0.8];

R2       = 1+Tirr;
subplot(231);
l1 = plot(R2(1,:),R2tr(1,:),'.','Color',[.6 .6 .6]-0.1,'MarkerSize',12); hold all;
l2 = plot(R2(1,:),R2adj(1,:),'.','Color',[ 0.5412    0.1686    0.8863],'MarkerSize',12);
xlim(l); ylim(l);plot(l,l,'k--'); h = gca();set(h,'FontSize',fs);
xlabel('$R^2$','interpreter','Latex')
ylabel('$\hat{R^2}$','interpreter','Latex');
legend([l1, l2],{'$\hat{R^2}$','$\hat{R^2}_{adj}$'},'interpreter','Latex','location','southeast')
title(['In-sample $n_{tr}$ = ', num2str(n), ', p = ', num2str(p) ],'interpreter','Latex');
axis square


R2 = 1+TirrO(1,:);
subplot(232);
l1 = plot(R2,R2te(1,:),'.','Color',[.6 .6 .6]-0.1,'MarkerSize',12); hold all;
l2 = plot(R2,R2outAdj(1,:),'.','Color',[ 0.5412    0.1686    0.8863],'MarkerSize',12);
xlim(l); ylim(l);plot(l,l,'k--'); h = gca();set(h,'FontSize',fs);
xlabel('$R^2$','interpreter','Latex')
ylabel('$\hat{R^2}$','interpreter','Latex');
% legend([l1, l2],{'$\hat{R^2}$','$\hat{R^2}_{adj}$'},'interpreter','Latex','location','southwest')
title(['Out-of-sample $n_{te}$ = ', num2str(narray(1))  ],'interpreter','Latex');
% disp(mean( (m.R2outAdj - R2).^2));
axis square

R2 = 1+TirrO(2,:);
subplot(233);
l1 = plot(R2,R2te(2,:),'.','Color',[.6 .6 .6]-0.1,'MarkerSize',12); hold all;
l2 = plot(R2,R2outAdj(2,:),'.','Color',[ 0.5412    0.1686    0.8863],'MarkerSize',12);
xlim(l); ylim(l);plot(l,l,'k--'); h = gca();set(h,'FontSize',fs);
xlabel('$R^2$','interpreter','Latex')
ylabel('$\hat{R^2}$','interpreter','Latex');
title(['Out-of-sample $n_{te}$ = ', num2str(narray(2))  ],'interpreter','Latex');
axis square
%% save fig
set(gcf,'PaperOrientation','landscape','PaperPositionMode','auto','papertype',['A4']);
print(gcf,'-dpdf',[figurefolder,filesep,figpdf]);