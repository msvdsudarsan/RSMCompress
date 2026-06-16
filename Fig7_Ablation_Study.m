%% =========================================================================
%% Fig7_Ablation_Study.m
%% Title : Stability-Preserving Neural Network Controller Compression
%%          for Singularly Perturbed Systems via Riemannian Slow-Manifold Geometry
%% Figure : 7 (Bonus) - Ablation Study (Table 3 Visualisation)
%% Journal: Automatica (Elsevier)
%% Author : M. S. V. D. Sudarsan Madhyannapu
%% Date   : 07 June 2026
%% =========================================================================
%% Description:
%%   Visualises Table 3 (Ablation) from Section 8.6 of the paper.
%%   Shows the contribution of each RSM-Compress component:
%%     1. Slow-manifold FIM split  (+24.8% when removed)
%%     2. Stiefel projection       (+12.7% when removed)
%%     3. NGD refinement           (+7.8%  when removed)
%%   And the cascading ablation ending at SVD-C baseline (+54.3%).
%%   Also shows lambda-sensitivity (lambda in {0.001, 0.01, 0.10}).
%% =========================================================================



%% ---- Data from Table 3 -------------------------------------------------
%  Independent ablation
labels_ind = {'RSM-Compress (full)','w/o Slow-mfld FIM','w/o Stiefel Proj.',...
              'w/o NGD Refine'};
errors_ind = [1.058, 1.320, 1.192, 1.141];

%  Cascading ablation
labels_casc = {'RSM-Compress (full)','w/o FIM split','w/o FIM+Stiefel',...
               'w/o All (= SVD-C)'};
errors_casc = [1.058, 1.320, 1.511, 1.633];

%  Lambda sensitivity
lambda_vals  = [0.001, 0.010, 0.100];
errors_lam   = [1.078, 1.058, 1.082];

%% ---- Figure layout: 1x3 subplots ----------------------------------------
fig = figure('Name','Fig7_Ablation_Study',...
             'Units','centimeters','Position',[2 2 28 9.5],...
             'Color','white');

%  Color map: RSM = blue, ablated = orange/red scale
c_rsm  = [0.13 0.47 0.71];
c_grad = [0.99 0.75 0.30;   % mild degradation
          0.97 0.55 0.22;
          0.89 0.20 0.16];  % severe

%% ---- Subplot 1: Independent ablation ------------------------------------
ax1 = subplot(1,3,1);
col_ind = [c_rsm; c_grad(3,:); c_grad(2,:); c_grad(1,:)];
for i = 1:4
    b = bar(ax1, i, errors_ind(i), 0.55,'FaceColor',col_ind(i,:),...
            'EdgeColor','k','LineWidth',0.9);
    hold(ax1,'on');
end

% Reference line at 1.058
yline(ax1, 1.058,'b--','LineWidth',1.5,'HandleVisibility','off');

% Annotate degradation percentages
delta_ind = (errors_ind - 1.058)./1.058.*100;
for i = 2:4
    text(ax1, i, errors_ind(i)+0.012,...
         sprintf('+%.1f%%', delta_ind(i)),...
         'HorizontalAlignment','center','FontSize',9,...
         'Color',[0.55 0.05 0.05],'FontWeight','bold');
end

set(ax1,'XTick',1:4,'XTickLabel',labels_ind,'XTickLabelRotation',25,...
        'FontSize',8.5,'LineWidth',0.8,'Box','on');
ylabel(ax1,'Normalized tracking error','FontSize',10,'Interpreter','tex');
title(ax1,'Independent Ablation','FontSize',10.5,'FontWeight','bold');
ylim(ax1,[0.90 1.45]);
grid(ax1,'on'); set(ax1,'GridLineStyle',':','GridAlpha',0.5);
text(ax1, 1, 1.065, sprintf('%.3f', errors_ind(1)),...
     'HorizontalAlignment','center','FontSize',8,'Color','b');

%% ---- Subplot 2: Cascading ablation --------------------------------------
ax2 = subplot(1,3,2);
col_casc = [c_rsm; c_grad(1,:); c_grad(2,:); c_grad(3,:)];
for i = 1:4
    bar(ax2, i, errors_casc(i), 0.55,'FaceColor',col_casc(i,:),...
        'EdgeColor','k','LineWidth',0.9);
    hold(ax2,'on');
end
yline(ax2, 1.058,'b--','LineWidth',1.5,'HandleVisibility','off');
delta_casc = (errors_casc - 1.058)./1.058.*100;
for i = 2:4
    text(ax2, i, errors_casc(i)+0.015,...
         sprintf('+%.1f%%', delta_casc(i)),...
         'HorizontalAlignment','center','FontSize',9,...
         'Color',[0.55 0.05 0.05],'FontWeight','bold');
end

% Synergy annotation
annotation('doublearrow',[0.415 0.445],[0.185 0.185],...
           'LineWidth',1.2,'Color',[0.4 0.0 0.4]);
text(ax2, 2.5, 1.58, sprintf('Synergy: +%.1f%% > sum', delta_casc(4) - sum(delta_ind(2:4))),...
     'FontSize',7.8,'Color',[0.4 0.0 0.4],'HorizontalAlignment','center','Interpreter','tex');

set(ax2,'XTick',1:4,'XTickLabel',labels_casc,'XTickLabelRotation',25,...
        'FontSize',8.5,'LineWidth',0.8,'Box','on');
ylabel(ax2,'Normalized tracking error','FontSize',10,'Interpreter','tex');
title(ax2,'Cascading Ablation','FontSize',10.5,'FontWeight','bold');
ylim(ax2,[0.90 1.75]);
grid(ax2,'on'); set(ax2,'GridLineStyle',':','GridAlpha',0.5);

%% ---- Subplot 3: Lambda sensitivity -------------------------------------
ax3 = subplot(1,3,3);
bar(ax3, 1:3, errors_lam, 0.55,'FaceColor',[0.55 0.73 0.62],...
    'EdgeColor','k','LineWidth',0.9);
hold(ax3,'on');
yline(ax3, 1.058,'b--','LineWidth',1.5);

for i = 1:3
    text(ax3, i, errors_lam(i)+0.003,...
         sprintf('%.3f', errors_lam(i)),...
         'HorizontalAlignment','center','FontSize',9.5,...
         'Color',[0.05 0.35 0.05],'FontWeight','bold');
end
set(ax3,'XTick',1:3,...
        'XTickLabel',{'\lambda=0.001','\lambda=0.010 (nom.)','\lambda=0.100'},...
        'XTickLabelRotation',20,'FontSize',8.5,'LineWidth',0.8,'Box','on');
ylabel(ax3,'Normalized tracking error','FontSize',10,'Interpreter','tex');
title(ax3,'\lambda Sensitivity  (1 decade each side)','FontSize',10.5,...
      'FontWeight','bold','Interpreter','tex');
ylim(ax3,[0.95 1.15]);
grid(ax3,'on'); set(ax3,'GridLineStyle',':','GridAlpha',0.5);
text(ax3, 2, 1.045, '\Delta max = 2.3%','HorizontalAlignment','center',...
     'FontSize',9,'Color',[0.3 0.3 0.3],'Interpreter','tex');

%% ---- Overall title ------------------------------------------------------
sgtitle({'Ablation Study: RSM-Compress Component Contributions';...
         'CSTR benchmark,  1024\times compression,  \epsilon = 0.05'},...
        'FontSize',11,'FontWeight','bold','Interpreter','tex');

%% ---- Export -------------------------------------------------------------
set(fig,'PaperPositionMode','auto');
print(fig,'Fig7_Ablation_Study','-dpdf','-r300');
print(fig,'Fig7_Ablation_Study','-dpng','-r300');
fprintf('[Done] Fig7_Ablation_Study saved as PDF + PNG.\n');
fprintf('  Key result: slow-manifold FIM split is the dominant contributor (+24.8%%)\n');
fprintf('  Synergy: removing all 3 components: +54.3%% > sum of independent +45.3%%\n');
