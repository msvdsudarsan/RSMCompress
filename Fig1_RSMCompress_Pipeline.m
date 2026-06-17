%% =========================================================================
%% Fig1_RSMCompress_Pipeline.m
%% RSM-Compress Pipeline Block Diagram
%% Authors: Sri Venkata Durga Sudarsan Madhyannapu and Sravanam Pradheep Kumar
%% =========================================================================

fig = figure('Name','Fig1_RSMCompress_Pipeline',...
             'Units','centimeters','Position',[2 2 22 7],...
             'Color','white');
ax = axes('Position',[0 0 1 1],'Visible','off',...
          'XLim',[0 1],'YLim',[0 1]);
hold(ax,'on');

col = [0.88 0.92 0.97;
       0.78 0.86 0.95;
       0.65 0.77 0.91;
       0.50 0.66 0.86;
       0.35 0.54 0.80;
       0.74 0.93 0.79];
edgeC = [0.15 0.15 0.15];

nbox = 6;
bw   = 0.120;
bh   = 0.320;
yc   = 0.460;
gap  = 0.020;
x0   = 0.030;
xc   = zeros(1,nbox);
for k = 1:nbox
    xc(k) = x0 + (k-1)*(bw+gap) + bw/2;
end

% Use plain-text labels (no LaTeX macros) for tex interpreter
titles = {'Ph.1','Ph.2','Ph.3','Ph.4','Ph.5','Out'};
lines2 = {'Slow-mfld','CS-FIM','eps-Rank','Stiefel','NGD','\theta~ (compressed)'};
lines3 = {'Sampling','Estimation','Select','Project','Refine',''};

for k = 1:nbox
    rectangle(ax,'Position',[xc(k)-bw/2 yc-bh/2 bw bh],...
              'Curvature',[0.18 0.22],...
              'FaceColor',col(k,:),'EdgeColor',edgeC,'LineWidth',1.1);

    text(ax, xc(k), yc+0.085, titles{k},...
         'HorizontalAlignment','center','VerticalAlignment','middle',...
         'FontSize',9,'FontWeight','bold','Color',[0.05 0.05 0.35]);

    text(ax, xc(k), yc+0.00, lines2{k},...
         'HorizontalAlignment','center','VerticalAlignment','middle',...
         'FontSize',7.8,'Color',[0.10 0.10 0.10]);

    if ~isempty(lines3{k})
        text(ax, xc(k), yc-0.085, lines3{k},...
             'HorizontalAlignment','center','VerticalAlignment','middle',...
             'FontSize',7.8,'Color',[0.10 0.10 0.10]);
    end
end

for k = 1:nbox-1
    annotation('arrow',[xc(k)+bw/2+0.002 xc(k+1)-bw/2-0.002],[yc yc],...
               'HeadWidth',8,'HeadLength',7,'LineWidth',1.5,...
               'Color',[0.20 0.20 0.20]);
end

% Dashed input arrow
text(ax, xc(1), yc+bh/2+0.14, 'Plant: epsilon, h',...
     'HorizontalAlignment','center','FontSize',8.5,...
     'FontAngle','italic','Color',[0.25 0.25 0.25]);
annotation('arrow',[xc(1) xc(1)],[yc+bh/2+0.10 yc+bh/2+0.005],...
           'HeadWidth',7,'HeadLength',6,'LineWidth',1.2,...
           'Color',[0.25 0.25 0.25],'LineStyle','--');

text(ax, 0.5, 0.96,...
     'RSM-Compress Pipeline: Slow Manifold Guides All Five Phases',...
     'HorizontalAlignment','center','FontSize',10,...
     'FontWeight','bold','Color',[0.05 0.05 0.30]);

set(fig,'PaperPositionMode','auto');
print(fig,'Fig1_RSMCompress_Pipeline','-dpdf','-r300');
print(fig,'Fig1_RSMCompress_Pipeline','-dpng','-r300');
fprintf('[Done] Fig1_RSMCompress_Pipeline saved.\n');
