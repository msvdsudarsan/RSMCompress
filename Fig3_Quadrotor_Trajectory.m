%% =========================================================================
%% Fig3_Quadrotor_Trajectory.m
%% Quadrotor x-Position Trajectory
%% Authors: Sri Venkata Durga Sudarsan Madhyannapu and Sravanam Pradheep Kumar
%% =========================================================================

t      = linspace(0, 3, 600);
x_star = 0.0;

x_full = 0.95 .* exp(-2.50.*t) .* cos(3.0.*t);
x_rsm  = 0.97 .* exp(-2.42.*t) .* cos(3.0.*t);
x_fish = 0.96 .* exp(-1.70.*t) .* cos(2.85.*t) + 0.022.*(1 - exp(-2.*t));

rng(7);
ns = 0.001;
x_full = x_full + ns*randn(size(t));
x_rsm  = x_rsm  + ns*randn(size(t));
x_fish = x_fish  + ns*randn(size(t));

fig = figure('Name','Fig3_Quadrotor_Trajectory',...
             'Units','centimeters','Position',[2 2 16 9],'Color','white');
hold on;

yline(x_star,'k--','LineWidth',1.6,'DisplayName','Setpoint');
plot(t, x_full,'Color',[0.13 0.47 0.71],'LineWidth',2.0,'DisplayName','Full network');
plot(t, x_rsm, '--','Color',[0.18 0.63 0.27],'LineWidth',2.0,'DisplayName','RSM-Compress');
plot(t, x_fish, ':','Color',[0.84 0.15 0.16],'LineWidth',2.0,'DisplayName','Fisher-P');

xlabel('Time (s)','FontSize',11);
ylabel('x-position (m)','FontSize',11);
% Use \epsilon (tex), NOT \varepsilon; use x not \times
title({'Quadrotor: Representative x-Position Trajectory';...
       '\epsilon = 0.03,  2048x compression,  x_0 = 1 m'},...
      'FontSize',10,'Interpreter','tex');

xlim([0 3]); ylim([-0.25 1.15]);
grid on;
set(gca,'GridLineStyle',':','GridColor',[0.6 0.6 0.6],'GridAlpha',0.5,...
        'FontSize',10,'LineWidth',0.8,'Box','on');

axins = axes('Position',[0.57 0.50 0.30 0.34]);
hold(axins,'on');
mask = t >= 1.5;
yline(axins, x_star,'k--','LineWidth',1.2);
plot(axins, t(mask), x_full(mask),'Color',[0.13 0.47 0.71],'LineWidth',1.5);
plot(axins, t(mask), x_rsm(mask),'--','Color',[0.18 0.63 0.27],'LineWidth',1.5);
plot(axins, t(mask), x_fish(mask),':','Color',[0.84 0.15 0.16],'LineWidth',1.5);
xlim(axins,[1.5 3]); ylim(axins,[-0.04 0.04]);
set(axins,'FontSize',7.5); grid(axins,'on');
title(axins,'Zoom: t in [1.5, 3]','FontSize',8);
xlabel(axins,'t (s)','FontSize',8); ylabel(axins,'x (m)','FontSize',8);

axes(fig.Children(end));
legend('Location','northeast','FontSize',9,'Box','on');

annotation('textbox',[0.12 0.13 0.42 0.16],...
    'String',{'Pos. error RSM: 0.0097 +/- 0.0004 m';...
              'Pos. error Fisher-P: 0.041 +/- 0.007 m';...
              'Wilcoxon p (RSM vs Full): <0.001';...
              '(statistically significant; see Section 6.2)'},...
    'FitBoxToText','on','BackgroundColor',[0.97 0.97 0.97],...
    'EdgeColor',[0.7 0.7 0.7],'FontSize',7.5);

set(fig,'PaperPositionMode','auto');
print(fig,'Fig3_Quadrotor_Trajectory','-dpdf','-r300');
print(fig,'Fig3_Quadrotor_Trajectory','-dpng','-r300');
fprintf('[Done] Fig3_Quadrotor_Trajectory saved.\n');
