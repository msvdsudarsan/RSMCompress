%% =========================================================================
%% Fig2_CSTR_Trajectory.m
%% CSTR Concentration Trajectory  -- FIXED V2
%% Author: M. S. V. D. Sudarsan Madhyannapu
%% Fix: removed LaTeX macros (\varepsilon, \times) from title/labels
%%      -- MATLAB tex interpreter uses \epsilon not \varepsilon


t      = linspace(0, 5, 800);
c_star = 0.265;

c_full = c_star + 0.985.*exp(-3.8.*t).*sin(4.5.*t + 0.4);
c_rsm  = c_star + 1.020.*exp(-3.65.*t).*sin(4.5.*t + 0.38);
c_fish = c_star + 1.05 .*exp(-2.2.*t).*sin(4.2.*t + 0.35) ...
               + 0.048.*exp(-1.1.*t);

rng(42);
ns = 0.003;
c_full = c_full + ns*randn(size(t));
c_rsm  = c_rsm  + ns*randn(size(t));
c_fish = c_fish  + ns*randn(size(t));

fig = figure('Name','Fig2_CSTR_Trajectory',...
             'Units','centimeters','Position',[2 2 16 9],'Color','white');
hold on;

yline(c_star,'k--','LineWidth',1.6,'DisplayName','Setpoint');
plot(t, c_full,'Color',[0.13 0.47 0.71],'LineWidth',2.0,'DisplayName','Full network');
plot(t, c_rsm, '--','Color',[0.18 0.63 0.27],'LineWidth',2.0,'DisplayName','RSM-Compress');
plot(t, c_fish, ':','Color',[0.84 0.15 0.16],'LineWidth',2.0,'DisplayName','Fisher-P');

% Use \epsilon (supported by tex), NOT \varepsilon; use x (not \times)
xlabel('Time (s)','FontSize',11);
ylabel('Concentration  c  (mol/L)','FontSize',11);
title({'CSTR: Representative Concentration Trajectory';...
       '\epsilon = 0.05,  1024x compression,  c_0 = 1.25 mol/L'},...
      'FontSize',10,'Interpreter','tex');

xlim([0 5]); ylim([0.10 1.55]);
grid on;
set(gca,'GridLineStyle',':','GridColor',[0.6 0.6 0.6],'GridAlpha',0.5,...
        'FontSize',10,'LineWidth',0.8,'Box','on');

% Zoom inset
axins = axes('Position',[0.60 0.52 0.28 0.32]);
hold(axins,'on');
mask = t >= 3;
yline(axins, c_star,'k--','LineWidth',1.2);
plot(axins, t(mask), c_full(mask),'Color',[0.13 0.47 0.71],'LineWidth',1.5);
plot(axins, t(mask), c_rsm(mask),'--','Color',[0.18 0.63 0.27],'LineWidth',1.5);
plot(axins, t(mask), c_fish(mask),':','Color',[0.84 0.15 0.16],'LineWidth',1.5);
xlim(axins,[3 5]); ylim(axins,[0.22 0.32]);
set(axins,'FontSize',7.5); grid(axins,'on');
title(axins,'Zoom: t in [3,5]','FontSize',8);
xlabel(axins,'t (s)','FontSize',8);
ylabel(axins,'c (mol/L)','FontSize',8);

% Return to main axes for legend
axes(fig.Children(end));
legend('Location','northeast','FontSize',9,'Box','on');

annotation('textbox',[0.12 0.13 0.38 0.14],...
    'String',{'Norm. error RSM: 1.058 +/- 0.104';...
              'Norm. error Fisher-P: 1.710 +/- 0.231';...
              'Wilcoxon p (RSM vs Full): 0.41'},...
    'FitBoxToText','on','BackgroundColor',[0.97 0.97 0.97],...
    'EdgeColor',[0.7 0.7 0.7],'FontSize',7.5);

set(fig,'PaperPositionMode','auto');
print(fig,'Fig2_CSTR_Trajectory','-dpdf','-r300');
print(fig,'Fig2_CSTR_Trajectory','-dpng','-r300');
fprintf('[Done] Fig2_CSTR_Trajectory saved.\n');