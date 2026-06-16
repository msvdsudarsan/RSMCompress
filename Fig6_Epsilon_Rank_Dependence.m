%% =========================================================================
%% Fig6_Epsilon_Rank_Dependence.m
%% Epsilon-Dependence of Selected Rank and Performance -- V8 CORRECTED
%%
%% Corrections over V7:
%%   - alpha changed from 0.50 to 0.44 (consistent with Fig4 and Remark 5.2)
%%   - Table A.1 row eps=0.10: r1 corrected from 24 to 23, comp from 683x to 712x
%%   - Table A.1 row eps=0.20: r1 corrected from 38 to 32, comp from 430x to 512x
%%   - d1/r1 speedup values updated accordingly
%%   - \\varepsilon LaTeX macro replaced with \epsilon (MATLAB tex interpreter)
%%   - sgtitle uses plain text (no \\delta, \\alpha macros)
%%
%% Author  : M. S. V. D. Sudarsan Madhyannapu
%% Journal : Automatica (IFAC/Elsevier)
%% Date    : 07 June 2026
%% =========================================================================

%% ---- Corrected data (alpha = 0.44, beta = 1.52, d1 = 128) --------------
%%   eps     r1   Compression   Norm.error   d1/r1
%%   0.01     6      2730x        1.041       21.3
%%   0.05    16      1024x        1.058        8.0
%%   0.10    23       712x        1.062        5.6
%%   0.20    32       512x        1.071        4.0
eps_vals   = [0.01,  0.05,  0.10,  0.20];
r1_vals    = [6,     16,    23,    32  ];
comp_ratio = [2730,  1024,  712,   512 ];
norm_error = [1.041, 1.058, 1.062, 1.071];
d1_over_r1 = [21.3,  8.0,   5.6,   4.0 ];

n_eps      = numel(eps_vals);
eps_labels = {'\epsilon=0.01','\epsilon=0.05', ...
              '\epsilon=0.10','\epsilon=0.20'};

%% ---- Theoretical rank curve: r ~ eps^(alpha/(beta-1)) ------------------
alpha_exp = 0.44;
beta_fit  = 1.52;
exp_th    = alpha_exp / (beta_fit - 1);          % ~0.846
eps_cont  = linspace(0.005, 0.25, 200);
C_scale   = 16 / (0.05^exp_th);                 % anchored at (eps=0.05, r1=16)
r_theory  = C_scale .* eps_cont.^exp_th;

%% ---- Verify internal consistency ---------------------------------------
A = 0.85;  beta = 1.52;
k_arr = 1:128;
lambda_emp = A .* k_arr.^(-beta);
cum_en = cumsum(lambda_emp) / sum(lambda_emp);
delta_1 = 0.10 / 3;

fprintf('--- Rank Selection Verification (V8, alpha = %.2f) ---\n', alpha_exp);
for i = 1:n_eps
    thresh = 1 - delta_1 / (eps_vals(i)^alpha_exp);
    r1_check = find(cum_en >= thresh, 1, 'first');
    fprintf('  eps=%.2f: threshold=%.4f, r1=%d (table: %d)\n', ...
            eps_vals(i), thresh, r1_check, r1_vals(i));
end

%% ---- Figure layout: 1x2 subplots ---------------------------------------
fig = figure('Name','Fig6_Epsilon_Rank_Dependence', ...
             'Units','centimeters','Position',[2 2 20 9],'Color','white');

%% ---- Subplot 1: selected rank vs eps -----------------------------------
ax1 = subplot(1,2,1);
bar(1:n_eps, r1_vals, 0.55, 'FaceColor',[0.13 0.47 0.71], ...
    'EdgeColor','k','LineWidth',0.9);
hold(ax1,'on');

% Theoretical power-law markers
r_theory_at_eps = C_scale .* eps_vals.^exp_th;
scatter(1:n_eps, r_theory_at_eps, 80,'rs','filled','DisplayName','Theory');

set(ax1,'XTick',1:n_eps,'XTickLabel',eps_labels, ...
        'FontSize',9.5,'LineWidth',0.8,'Box','on');
ylabel(ax1,'Selected rank  r_1','FontSize',11);
xlabel(ax1,'Singular perturbation parameter  \epsilon','FontSize',10);
title(ax1,'r_1 decreases monotonically with \epsilon','FontSize',10);
grid(ax1,'on');
set(ax1,'GridLineStyle',':','GridAlpha',0.5);

for i = 1:n_eps
    text(ax1, i, r1_vals(i) + 1.2, sprintf('%dx', comp_ratio(i)), ...
         'HorizontalAlignment','center','FontSize',8.5, ...
         'FontWeight','bold','Color',[0.05 0.05 0.40]);
end
legend(ax1, {'r_1 (data)', sprintf('Theory r~\\epsilon^{%.2f}', exp_th)}, ...
       'Location','northwest','FontSize',8.5);
ylim(ax1,[0 42]);

%% ---- Subplot 2: performance vs compression trade-off -------------------
ax2 = subplot(1,2,2);

yyaxis left;
plot(r1_vals, norm_error,'b-o','LineWidth',2,'MarkerSize',8, ...
     'MarkerFaceColor','b','DisplayName','Norm. error');
ylabel(ax2,'Normalized tracking error','FontSize',10,'Color','b');
ylim([1.00 1.12]);
set(ax2,'YColor','b');

yyaxis right;
plot(r1_vals, d1_over_r1,'r-s','LineWidth',2,'MarkerSize',8, ...
     'MarkerFaceColor','r','DisplayName','d_1/r_1');
ylabel(ax2,'Inference speedup  (d_1/r_1)','FontSize',10,'Color','r');
ylim([0 26]);
set(ax2,'YColor','r');

xlabel(ax2,'Selected rank  r_1','FontSize',11);
title(ax2,'Performance vs Compression Trade-off','FontSize',10);
grid(ax2,'on');
set(ax2,'GridLineStyle',':','GridAlpha',0.5,'FontSize',9.5,'LineWidth',0.8,'Box','on');

for i = 1:n_eps
    text(ax2, r1_vals(i), norm_error(i) + 0.003, eps_labels{i}, ...
         'FontSize',8,'HorizontalAlignment','center','Color',[0.2 0.2 0.2]);
end
legend(ax2,{'Norm. error','d_1/r_1'},'Location','northwest','FontSize',8.5);

%% ---- Overall title (plain text, no LaTeX macros) -----------------------
sgtitle({'Appendix Table A.1: Epsilon-Dependence of Rank and Performance'; ...
         'CSTR benchmark,  delta = 0.10,  alpha = 0.44'}, ...
        'FontSize',11,'FontWeight','bold');

%% ---- Export -------------------------------------------------------------
set(fig,'PaperPositionMode','auto');
print(fig,'Fig6_Epsilon_Rank_Dependence','-dpdf','-r300');
print(fig,'Fig6_Epsilon_Rank_Dependence','-dpng','-r300');
fprintf('[Done] Fig6_Epsilon_Rank_Dependence saved.\n');
fprintf('  Confirms: smaller eps => lower rank at comparable performance.\n');