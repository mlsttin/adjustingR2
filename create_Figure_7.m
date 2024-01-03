%% define graphical parameters here
fs = 10; % font size
figure(234);clf, set(gcf,'units','centimeters','position',[3 1 29.5 20.5],'color',[1 1 1])
yl     = [-0.1 0.5];  % ylimits
yldiff = [-0.3 0.24]; % ylimits difference R2 subplot
h0 = annotation('textbox', [ 0, .90,   0.6-0.2, 0.05],  'string', '\textbf{In Sample}',...
    'VerticalAlignment','middle','horizontalAlignment','center','interpreter','Latex','fontSize',fs+6,'EdgeColor',[1,1,1])

h0 = annotation('textbox', [ 0.46, .90,   0.6-0.2, 0.05],  'string', '\textbf{Out of Sample}',...
    'VerticalAlignment','middle','horizontalAlignment','center','interpreter','Latex','fontSize',fs+6,'EdgeColor',[1,1,1])


h0 = annotation('textbox', [ 0.23, .95,   0.6, 0.05],  'string', ['\textbf{Model 1 $p_{1} = $}',num2str(p1), ',  \textbf{Model 2 $p_{2} = $}',num2str(p2) ],...
    'VerticalAlignment','middle','horizontalAlignment','center','interpreter','Latex','fontSize',fs+6,'EdgeColor',[1,1,1])
textYshift1 = 0; textYshift2 = 0;
textXshift1 = 80;          
%%  In sample figures (left column of Figure 7)
s1 = subplot(321); % Model 1 in-sample
l5 = plot(narray,median(R2tr1,2),'LineWidth',1,'color',[0 0 0]); hold all;
bootR2tr = bootstrp(1000,@median,R2tr1');qR2tr = quantile(bootR2tr,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2tr(1,:) flip(qR2tr(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles

l6 = plot(narray,median(R2adj1,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@median,R2adj1');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
xlim([narray(1) narray(end)])

l4 = plot([narray(1) narray(end)],[R1pop R1pop],'color', [0 1 0],'LineWidth',2,'LineStyle','--');

h0 = text(narray(1)-textXshift1,textYshift1 ,'\textbf{$R^2$} \textbf{Model 1}','Rotation',90,'interpreter','Latex','fontSize',fs+6)
xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off','FontSize',fs+4);h=gca; h.XAxis.TickLength = [0 0]; 
ylim(yl)
l = legend([l4  l5 l6],{'$R^2$','$\hat{R}^2$','$\hat{R}^2_{adj}$'},'interpreter','latex','Fontsize',10,'fontSize',fs,'location','northeast','FontSize',fs+2);
l.Position = l.Position + [0.07 -0.01 0 0]; %adjusting legend
legend boxoff 


s2 = subplot(323); % Model 2 in sample
l5 = plot(narray,median(R2tr2,2),'LineWidth',1,'color',[0 0 0]); hold all;
bootR2tr = bootstrp(1000,@median,R2tr2');qR2tr = quantile(bootR2tr,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2tr(1,:) flip(qR2tr(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles
l6 = plot(narray,median(R2adj2,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@median,R2adj2');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
xlim([narray(1) narray(end)])
l4 = plot([narray(1) narray(end)], [R2pop , R2pop],'color', [0 1 0],'LineWidth',2,'LineStyle','--');
h0 = text(narray(1)-textXshift1,textYshift2 ,'\textbf{$R^2$} \textbf{Model 2}','Rotation',90,'interpreter','Latex','fontSize',fs+6)

xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off','FontSize',fs+4);h=gca; h.XAxis.TickLength = [0 0]; 
ylim(yl)


s3 = subplot(325); % Model1-Model2 in-sample
l5 = plot(narray,median(R2tr1 - R2tr2,2),'LineWidth',1,'color',[0 0 0]); hold all;
bootR2tr = bootstrp(1000,@median,(R2tr1 - R2tr2)');qR2tr = quantile(bootR2tr,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2tr(1,:) flip(qR2tr(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles
l6 = plot(narray,median(R2adj1 - R2adj2,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@median,(R2adj1 - R2adj2)');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
xlim([narray(1) narray(end)])

l4 = plot([narray(1) narray(end)],[ R1pop - R2pop , R1pop - R2pop],'color', [0 1 0],'LineWidth',2,'LineStyle','--');
plot([narray(1) narray(end)],[0 0 ],'k--')
h0 = text(narray(1)-textXshift1,-0.2 ,'\textbf{$R^2_{M1}$} - \textbf{$R^2_{M2}$}','Rotation',90,'interpreter','Latex','fontSize',fs+6)

xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off','FontSize',fs+4);h=gca; h.XAxis.TickLength = [0 0]; 
ylim(yldiff);


%%  Out-of-Sample (right column of Figure 7)
s4 = subplot(322); % Out-of-sample Model 1
l5 = plot(narray,median(R2te1,2),'LineWidth',1,'color',[0 0 0]); hold all;
bootR2te = bootstrp(1000,@median,R2te1');qR2te = quantile(bootR2te,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2te(1,:) flip(qR2te(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles
l6 = plot(narray,median(R2outAdj1,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@median,R2outAdj1');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
xlim([narray(1) narray(end)])

l4 = plot([narray(1) narray(end)],[R1pop R1pop],'color', [0 1 0],'LineWidth',2,'LineStyle','--');
xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off','FontSize',fs+4);h=gca; h.XAxis.TickLength = [0 0]; 
ylim(yl)


s5 = subplot(324); % Out-of-sample Model 2
      l5 = plot(narray,median(R2te2,2),'LineWidth',1,'color',[0 0 0]); hold all;
bootR2te = bootstrp(1000,@median,R2te2');qR2te = quantile(bootR2te,[.025 .975]);       % bootstrap and quantiles
fill([narray flip(narray)],[qR2te(1,:) flip(qR2te(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles

l6 = plot(narray,median(R2outAdj2,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@median,R2outAdj2');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
xlim([narray(1) narray(end)])
l4 = plot([narray(1) narray(end)],[R2pop R2pop],'color', [0 1 0],'LineWidth',2,'LineStyle','--');

xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off','FontSize',fs+4);h=gca; h.XAxis.TickLength = [0 0]; 
ylim(yl)

 s3 = subplot(326); % Model1 - Model2 Out-of-sample
 hold all
 l5 = plot(narray,median(R2te1 - R2te2,2),'LineWidth',1,'color',[0 0 0]); hold all;
 bootR2te = bootstrp(1000,@median,(R2te1 - R2te2)');qR2tr = quantile(bootR2te,[.025 .975]);       % bootstrap and quantiles
 fill([narray flip(narray)],[qR2tr(1,:) flip(qR2tr(2,:))],[.6 .6 .6],'facealpha',.7);% show quantiles
l6 = plot(narray,median(R2outAdj1 - R2outAdj2,2),'linewidth',1,'color',[ 0.5412    0.1686    0.8863],'LineStyle','-')
bootR2adj = bootstrp(1000,@median,(R2outAdj1 - R2outAdj2)');  qR2tradj = quantile(bootR2adj,[.025 .975]);% bootstrap and quantiles
 fill([narray flip(narray)],[qR2tradj(1,:) flip(qR2tradj(2,:))],[ 0.5412    0.1686    0.8863],'facealpha',.4);% show quantiles
xlim([narray(1) narray(end)])
l4 = plot([narray(1) narray(end)],[ R1pop - R2pop , R1pop - R2pop],'color', [0 1 0],'LineWidth',2,'LineStyle','--');
plot([narray(1) narray(end)],[0 0 ],'k--')

xlabel('$\mathbf{n_{tr}}$','interpreter','Latex','fontSize',fs+4); %xlim([narray(1) narray(end)])
set(gca,'box','off','FontSize',fs+4);h=gca; h.XAxis.TickLength = [0 0]; 
ylim(yldiff)

%% save figure
set(gcf,'PaperOrientation','landscape','PaperPositionMode','auto','papertype',['A4']);
print(gcf,'-dpdf',[figurefolder,filesep,figpdf]);
