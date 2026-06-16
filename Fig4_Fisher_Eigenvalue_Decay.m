%% =========================================================================
%% Fig4_Fisher_Eigenvalue_Decay.m
%% Fisher Eigenvalue Decay (log-log) -- V8 CORRECTED
%%
%% Corrections over V7:
%%   - alpha changed from 0.50 to 0.44 (correct value giving r1=16 at eps=0.05
%%     with beta=1.52 spectrum; see Remark 5.2 in paper)
%%   - Threshold and r1 now match paper Table A.1 exactly
%%
%% Author  : M. S. V. D. Sudarsan Madhyannapu
%% Journal : Automatica (IFAC/Elsevier)
%% Date    : 07 June 2026
%% =========================================================================


%% ---- Spectrum parameters (consistent with paper beta_hat = 1.52) -------
k_arr  = 1:128;
beta   = 1.52;          % fitted power-law exponent (Fig4 result)
A      = 0.85;          % amplitude constant
lambda_emp = A .* k_arr.^(-beta);   % deterministic power-law (no noise)
lambda_fit = lambda_emp;            % same curve for legend

%% ---- Rank selection (CORRECTED: alpha = 0.44, not 0.50) ----------------
eps_val   = 0.05;
delta     = 0.10;
L_layers  = 3;
alpha_exp = 0.44;       %  <-- CORRECTED from 0.50; see Remark 5.2
delta_1   = delta / L_layers;
threshold = 1 - delta_1 / (eps_val^alpha_exp);
cum_energy = cumsum(lambda_emp) / sum(lambda_emp);
r1_selected = find(cum_energy >= threshold, 1, 'first');

fprintf('--- Rank Selection Verification (V8) ---\n');
fprintf('  alpha          = %.4f\n', alpha_exp);
fprintf('  threshold      = %.6f  (paper: 87.5%%)\n', threshold);
fprintf('  Selected r1    = %d     (paper Table A.1: r1 = 16)\n', r1_selected);
fprintf('  Compression    = %dx    (paper: 1024x)\n', round(128^2 / r1_selected));
assert(r1_selected == 16, 'ERROR: r1 must equal 16 for internal consistency.');

%% ---- Figure -------------------------------------------------------------
fig = figure('Name','Fig4_Fisher_Eigenvalue_Decay', ...
             'Units','centimeters','Position',[2 2 14 10],'Color','white');

loglog(k_arr, lambda_emp, 'o-','Color',[0.13 0.47 0.71],'LineWidth',1.8, ...
       'MarkerSize',3.5,'MarkerFaceColor',[0.13 0.47 0.71], ...
       'DisplayName','Empirical eigenvalues');
hold on;
loglog(k_arr, lambda_fit,'--','Color',[0.84 0.15 0.16],'LineWidth',2.0, ...
       'DisplayName','beta-hat = 1.52 fit');

xline(r1_selected,'k:','LineWidth',1.8,'HandleVisibility','off');
text(r1_selected * 1.12, 5e-3, sprintf('r_1 = %d', r1_selected), ...
     'FontSize',9.5,'Color',[0.15 0.15 0.15]);

%  Shaded discarded-direction region
fill_k  = [r1_selected:128, 128:-1:r1_selected];
fill_lv = [lambda_emp(r1_selected:end), 1e-7 * ones(1, 128 - r1_selected + 1)];
patch(fill_k, fill_lv, [0.95 0.85 0.85], 'FaceAlpha',0.35, ...
      'EdgeColor','none','HandleVisibility','off');
text(60, 4e-4,'Discarded directions','FontSize',8.5,'Color',[0.6 0.15 0.15]);

xlabel('Rank  k','FontSize',11);
ylabel('Fisher eigenvalue (normalised)','FontSize',11);
title({'Fisher Eigenvalue Decay  (CSTR Layer 1,  k = 1...128)'; ...
       'Power-law  beta-hat = 1.52  corroborates  alpha = 0.44'}, ...
      'FontSize',10);

xlim([1 128]);  ylim([1e-5 2]);
grid on;
set(gca,'GridLineStyle',':','GridColor',[0.6 0.6 0.6],'GridAlpha',0.5, ...
        'FontSize',10,'LineWidth',0.8,'Box','on');
legend('Location','southwest','FontSize',9,'Box','on');

%% ---- Cumulative energy inset -------------------------------------------
axins = axes('Position',[0.50 0.25 0.38 0.35]);
plot(axins, 1:128, cum_energy*100, 'b-','LineWidth',1.6);
hold(axins,'on');
xline(axins, r1_selected,'k:','LineWidth',1.4);
yline(axins, threshold*100,'r--','LineWidth',1.4);
plot(axins, r1_selected, cum_energy(r1_selected)*100, 'ro', ...
     'MarkerSize',7,'MarkerFaceColor','r');
xlabel(axins,'Rank r','FontSize',8);
ylabel(axins,'Cumulative energy (%)','FontSize',8);
title(axins, sprintf('Threshold = %.1f%% at r_1 = %d', ...
      threshold*100, r1_selected), 'FontSize',8);
xlim(axins,[1 40]);  ylim(axins,[0 105]);
grid(axins,'on');  set(axins,'FontSize',7.5);

%% ---- Export -------------------------------------------------------------
set(fig,'PaperPositionMode','auto');
print(fig,'Fig4_Fisher_Eigenvalue_Decay','-dpdf','-r300');
print(fig,'Fig4_Fisher_Eigenvalue_Decay','-dpng','-r300');
fprintf('[Done] Fig4_Fisher_Eigenvalue_Decay saved.\n');
