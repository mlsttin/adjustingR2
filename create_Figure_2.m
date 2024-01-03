outputfolder  = fullfile(pwd,'output');close all;
%% define axes
facealpha = .4;
a  = .06;    a2= .05 ; b  = .1;   width1 = (1-a-a2-b)/2;   % in sample
axR2invsnTR      = [a                0.57  width1  0.33]; % in sample
axR2invsP        = [a+width1+b       0.57  width1  0.33]; % in sample

a   = .06;  a2 = 0.04;  b  = .06; width2 = (1-a-a2-2*b)/3; % out of sample
axR2ovsnTR       = [a                0.07  width2  0.33];
axR2ovsP         = [a+b+width2       0.07  width2  0.33];
axR2ovsnTE       = [a+2*(b+width2)   0.07  width2  0.33];
fs               = 12; % fontsize for all the plots
faceColorTirr    = [0         0.4470    0.7410]; % parametrically defined colors
faceColorTop     = [0.8500    0.3250    0.0980]; 
ylimscaling      = 1.1;
%% Create figure
figure(234);clf, set(gcf,'units','centimeters','position',[3 1 29.5 20.5],'color',[1 1 1])
h0 = annotation('textbox', [ 0.2, .96,   0.6, 0.05],  'string', 'Explained variance \textbf{In Sample}',...
    'VerticalAlignment','middle','horizontalAlignment','center','interpreter','Latex','fontSize',fs+6,'EdgeColor',[1,1,1])

h0 = annotation('textbox', [ 0.2, .47,   0.6, 0.05],  'string', 'Explained variance \textbf{Out of Sample}',...
    'VerticalAlignment','middle','horizontalAlignment','center','interpreter','Latex','fontSize',fs+6,'EdgeColor',[1,1,1])
%% Sample Size dependence
load([outputfolder,filesep,outputfile1]); % load data
ax1             = axes('Position',axR2invsnTR,'box','off','FontSize',fs);hold all;
% l1              = bar(narray,[1+mean(Tirr,2)  mean(Topt,2) mean(Tsh,2) mean(Tcov,2) ],'stacked','FaceAlpha',facealpha,'linewidth',.5);
  l1              = bar(narray,[1+mean(Tirr,2)  mean(Topt,2) mean(Tsh,2) ],'stacked','FaceAlpha',facealpha,'linewidth',.5);
  l1(1).FaceColor = faceColorTirr; l1(2).FaceColor = faceColorTop;

l5 = plot(narray,mean(R2tr,2),'LineWidth',1,'color',[.6 .6 .6])
bootR2tr = bootstrp(1000,@mean,R2tr');qR2tr = quantile(bootR2tr,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2tr(1,:) flip(qR2tr(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles

l6 = plot(narray,mean(R2adj,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@mean,R2adj');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles

l4 = plot(narray,1+mean(Tirr,2),'color', [ 0 ,   1 ,   0],'LineWidth',2,'LineStyle','--')
if(narray(1) < p)% ridge legend
%   l = legend([l1 , l4, l5 l6],{'$R^2$', '$T_{op}$','$T_{sh}$','$T_{cov}$','$R^2_{pop}$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs);
    l = legend([l1 , l4, l5 l6],{'$R^2$', '$T_{op}$','$T_{sh}$','$R^2_{pop}$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs);
    l.Position = l.Position + [0.06 0 0 0 ];  legend boxoff 
    title(['Training Set Sample Size'],'interpreter','Latex','fontSize',fs+4)
    subtitle(['$\lambda = $ ', num2str(lambdaOPT) ,' $ p = $', num2str(p),' $n_{te} = $ ', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
else % ols legend
    l = legend([l1(1) ,l1(2), l4,l5,l6],{'$R^2$', '$T_{op}$','$R^2_{pop}$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs,'location','northeast');    
    l.Position = l.Position + [0.06 0 0 0 ];  legend boxoff 

    title(['Training Set Sample Size'],'interpreter','Latex','fontSize',fs+4)
    subtitle(['$p = $', num2str(p), ' $n_{te} = $ ', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
end
xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off');h=gca; h.XAxis.TickLength = [0 0]; 

% second plot: R2out vs nTR: training size dependence goes first
ax3 = axes('Position',axR2ovsnTR,'box','off','FontSize',fs);hold all;
l1  = bar(narray,[1+mean(TirrO,2)  mean(Tpess,2) mean(TshO,2) mean(TcovO,2)],'stacked','FaceAlpha',0.5)

l5       = plot(narray,mean(R2te,2),'LineWidth',1,'color',[.6 .6 .6])
bootR2te = bootstrp(1000,@mean,R2te');qR2te = quantile(bootR2te,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2te(1,:) flip(qR2te(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles

l6           = plot(narray,mean(R2outAdj,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2outAdj = bootstrp(1000,@mean,R2outAdj');  qR2outadj = quantile(bootR2outAdj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2outadj(1,:) flip(qR2outadj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles

l4 = plot(narray,1+mean(TirrO,2),'color', [ 0 ,   1 ,   0],'LineWidth',2,'LineStyle','--')
xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
h = gca(); set(h,'FontSize',fs);set(gca,'box','off');h=gca; h.XAxis.TickLength = [0 0]; 

if(narray(1) < p)% ridge legend
title(['Training Set Sample Size'],'interpreter','Latex','fontSize',fs+4)
subtitle(['$\lambda = $ ', num2str(lambdaOPT),' $ p = $', num2str(p),' $n_{te} = $ ', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
xl  = xlim();xlim([xl(1) 1.16*narray(end)]);
else % ols legend
title(['Training Set Sample Size'],'interpreter','Latex','fontSize',fs+4)
subtitle(['$ p = $', num2str(p),' $n_{te} = $ ', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
end
%% number of features dependence
load([outputfolder,filesep,outputfile3]); % load data
ax2      = axes('Position',axR2invsP); hold all;
% l1       = bar(narray,[1+mean(Tirr,2)  mean(Topt,2) mean(Tsh,2) mean(Tcov,2) ],'stacked','FaceAlpha',facealpha,'linewidth',.5);
l1       = bar(narray,[1+mean(Tirr,2)  mean(Topt,2) mean(Tsh,2)  ],'stacked','FaceAlpha',facealpha,'linewidth',.5);

l5       = plot(narray,mean(R2tr,2),'LineWidth',1,'color',[.6 .6 .6])
bootR2tr = bootstrp(1000,@mean,R2tr');qR2tr = quantile(bootR2tr,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2tr(1,:) flip(qR2tr(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles

l6        = plot(narray,mean(R2adj,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@mean,R2adj');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles

l4       = plot(narray,      1+mean(Tirr,2),'color', [ 0 ,   1 ,   0],'LineWidth',2,'LineStyle','--')
xlabel('$\mathbf{p}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
h = gca(); set(h,'FontSize',fs);set(gca,'box','off');h=gca; h.XAxis.TickLength = [0 0]; 

if(narray(end) > n)% ridge legend
title(['Number of Features'],'interpreter','Latex','fontSize',fs+4)
subtitle(['$\lambda = $ ', num2str(lambdaOPT),  ' $n_{tr} = $', num2str(n),' $n_{te} = $', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
else % ols legend
title(['Number of Features'],'interpreter','Latex','fontSize',fs+4)
subtitle([ ' $n_{tr} = $', num2str(n),' $n_{te} = $', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
end

axes('Position',axR2ovsP,'box','off','FontSize',fs);hold all;
% l1       = bar(narray,[1+mean(TirrO,2)  mean(Tpess,2) mean(TshO,2) mean(TcovO,2)],'stacked','FaceAlpha',facealpha)
l1       = bar(narray,[1+mean(TirrO,2)  mean(Tpess,2) mean(TshO,2)],'stacked','FaceAlpha',facealpha)

l5       = plot(narray,mean(R2te,2),'LineWidth',1,'color',[.6 .6 .6])
bootR2te = bootstrp(1000,@mean,R2te');qR2te = quantile(bootR2te,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2te(1,:) flip(qR2te(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles

l6           = plot(narray,mean(R2outAdj,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2outAdj = bootstrp(1000,@mean,R2outAdj');  qR2outadj = quantile(bootR2outAdj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2outadj(1,:) flip(qR2outadj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
l4       = plot(narray,1+mean(TirrO,2),'color', [ 0 ,   1 ,   0],'LineWidth',2,'LineStyle','--')
xlabel('$\mathbf{p}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
h = gca(); set(h,'FontSize',fs);set(gca,'box','off');h=gca; h.XAxis.TickLength = [0 0]; 

if(narray(end) > n)% ridge legend
title(['Number of Features'],'interpreter','Latex','fontSize',fs+4)
subtitle(['$\lambda = $ ', num2str(lambdaOPT), ' $n_{tr} = $', num2str(n),' $n_{te} = $', num2str(nTE) ],'interpreter','Latex','fontSize',fs+4)
% l = legend([l1 , l4, l5 l6],{'$R^2$', '$T_{pess}$','$T_{sh_{o}}$','$T_{cov_{o}}$','$R^2_{pop}$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs,'location','northwest');
l = legend([l1 , l4, l5 l6],{'$R^2$', '$T_{pess}$','$T_{sh_{o}}$','$R^2_{pop}$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs,'location','northwest');
l.Position = l.Position + [-0.1 0.02 0 0 ];
legend boxoff 
else % ols legend
title(['Number of Features'],'interpreter','Latex','fontSize',fs+4)
subtitle(['$n_{tr} = $', num2str(n), ' $n_{te} = $', num2str(nTE)],'interpreter','Latex','fontSize',fs+4)
legend([l1(1) ,l1(2), l4,l5,l6],{'$R^2$', '$T_{pess}$','$R^2_{pop}$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs,'location','southwest');    
legend boxoff 
end



%% Test set size dependence
load([outputfolder,filesep,outputfile2]); % load data
axes('Position',axR2ovsnTE,'box','off','FontSize',fs);hold all;
l1       = bar(narray,[1+mean(TirrO,2)  mean(Tpess,2) mean(TshO,2) mean(TcovO,2)],'stacked','FaceAlpha',facealpha)    

l5       = plot(narray,mean(R2te,2),'LineWidth',1,'color',[.6 .6 .6])
bootR2te = bootstrp(1000,@mean,R2te');qR2te    = quantile(bootR2te,[.025 .975]);
fill([narray flip(narray)],[qR2te(1,:) flip(qR2te(2,:))],[.6 .6 .6],'facealpha',.7);

l6           = plot(narray,mean(R2outAdj,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2outAdj = bootstrp(1000,@mean,R2outAdj');
qR2outAdj    = quantile(bootR2outAdj,[.025 .975]);
fill([narray flip(narray)],[qR2outAdj(1,:) flip(qR2outAdj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);

l4       = plot(narray,1+mean(TirrO,2),'color', [ 0 ,   1 ,   0],'LineWidth',2,'LineStyle','--')
xlabel('$\mathbf{n_{te}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
h = gca(); set(h,'FontSize',fs);set(gca,'box','off');h=gca; h.XAxis.TickLength = [0 0]; 
if(narray(1) < p)% ridge legend
     title(['Test Set Sample Size'],'interpreter','Latex','fontSize',fs+4)
     subtitle(['$n_{tr}$ = ',num2str(n), ' $\lambda = $ ', num2str(lambdaOPT), ' $p = $', num2str(p)],'interpreter','Latex','fontSize',fs+4)
else % ols legend
     title(['Test Set Sample Size'],'interpreter','Latex','fontSize',fs+4)
     subtitle(['$n_{tr}$ = ',num2str(n),' $p = $', num2str(p)],'interpreter','Latex','fontSize',fs+4)
end
%% save to pdf
set(gcf,'PaperOrientation','landscape','PaperPositionMode','auto','papertype',['A4']);
print(gcf,'-dpdf',[figurefolder,filesep,figpdf]);