%% =========================================================================
%% Benchmark_Statistics.m
%% Genuine closed-loop Monte Carlo evaluation for RSM-Compress benchmarks.
%%
%% Purpose
%% -------
%% Fig2_CSTR_Trajectory.m and Fig3_Quadrotor_Trajectory.m plot a SINGLE
%% illustrative trajectory built from hand-chosen analytic curves, and the
%% "Norm. error", "Wilcoxon p", and "Pos. error" numbers shown in their
%% annotation boxes are typed strings, not computed values.  This script
%% closes that gap: it simulates the closed-loop dynamics for both
%% benchmarks under (i) a nominal "full-network" feedback gain and
%% (ii) a "compressed" feedback gain perturbed by a magnitude consistent
%% with the rank-truncation analysis in the paper, repeats this over
%% N_TRAJ independent random initial conditions / disturbance draws, and
%% computes a genuine two-sided Wilcoxon rank-sum test between the two
%% error distributions.
%%
%% IMPORTANT — read before citing these numbers in the manuscript
%% -----------------------------------------------------------------------
%% This script approximates the controllers in closed form (linearised
%% feedback laws calibrated to match the *qualitative* settling behaviour
%% described in the paper) because the original PyTorch-trained NN weights
%% are not part of this repository.  It is a transparent, runnable
%% stand-in that produces REAL statistics from REAL simulated trajectories
%% — unlike Fig2/Fig3, nothing here is a typed placeholder — but it is
%% not a re-run of the original PyTorch/Adam training pipeline described
%% in the paper's Implementation Details.  Before using these numbers as
%% the final reported values in the manuscript, either (a) replace the
%% closed-loop ODE blocks below with the actual trained controller
%% rollouts from the Python pipeline, logging the same statistics, or
%% (b) keep this script's numbers but state explicitly in the paper that
%% they come from a calibrated surrogate closed-loop model, not the
%% original trained networks.  Do not present these as identical to a
%% PyTorch-trained-network result without one of (a) or (b).
%%
%% Authors: Sri Venkata Durga Sudarsan Madhyannapu and Sravanam Pradheep Kumar
%% =========================================================================

clear; clc;
rng(2026);  % fixed seed for reproducibility

N_TRAJ = 50;     % matches "50 trajectories" stated in Tables 1-2 of the paper
ALPHA_SIG = 0.05; % significance level, stated explicitly (Consensus report flagged this gap)

results = struct();

%% =========================================================================
%% BENCHMARK 1: Singularly perturbed CSTR
%% =========================================================================
% Slow state x = [C_A, T], fast state z = T_c, eps = 0.05
% Linearised closed-loop error dynamics around the operating point:
%   full network:        e_dot = -3.8 e + w(t)
%   RSM-Compress:         e_dot = -3.65 e + w(t)        (small pole shift)
% This mirrors the decay rates already used for the illustrative plot in
% Fig2_CSTR_Trajectory.m (-3.8 vs -3.65), but here every trajectory has an
% independently sampled initial condition and process-noise realisation,
% and the resulting tracking-error statistic is genuinely computed.

eps_cstr = 0.05;
t_cstr = linspace(0, 5, 800);
dt_cstr = t_cstr(2) - t_cstr(1);

err_full_cstr = zeros(N_TRAJ, 1);
err_rsm_cstr  = zeros(N_TRAJ, 1);

for i = 1:N_TRAJ
    e0 = 0.95 + 0.10*randn();              % randomised initial deviation

    % IMPORTANT: full-network and RSM-Compress controllers must see
    % INDEPENDENT noise/disturbance realisations, not a shared one.
    % A shared noise path makes the two RMS errors co-move almost
    % deterministically (their ratio collapses to a near-constant set
    % fixed only by the pole locations), which destroys the trajectory-
    % to-trajectory variability a genuine Wilcoxon test is meant to see.
    w_full = 0.05*randn(size(t_cstr));
    w_rsm  = 0.05*randn(size(t_cstr));

    e_full = zeros(size(t_cstr)); e_full(1) = e0;
    e_rsm  = zeros(size(t_cstr)); e_rsm(1)  = e0;
    for k = 2:length(t_cstr)
        e_full(k) = e_full(k-1) + dt_cstr*(-3.80*e_full(k-1) + w_full(k-1));
        e_rsm(k)  = e_rsm(k-1)  + dt_cstr*(-3.65*e_rsm(k-1)  + w_rsm(k-1));
    end

    err_full_cstr(i) = sqrt(mean(e_full.^2));   % RMS tracking error
    err_rsm_cstr(i)  = sqrt(mean(e_rsm.^2));
end

norm_err_cstr = err_rsm_cstr ./ err_full_cstr;   % normalised error, matches paper's definition
[p_cstr, ~] = ranksum(err_rsm_cstr, err_full_cstr);

fprintf('--- CSTR Benchmark (N=%d trajectories) ---\n', N_TRAJ);
fprintf('  Norm. error (RSM/Full): %.3f +/- %.3f\n', mean(norm_err_cstr), std(norm_err_cstr));
fprintf('  Wilcoxon rank-sum p (RSM vs Full): %.4f\n', p_cstr);
fprintf('  Significant at alpha=%.2f? %s\n\n', ALPHA_SIG, ternary(p_cstr < ALPHA_SIG, 'YES', 'NO'));

results.cstr.norm_err_mean = mean(norm_err_cstr);
results.cstr.norm_err_std  = std(norm_err_cstr);
results.cstr.p_value       = p_cstr;

%% =========================================================================
%% BENCHMARK 2: Quadrotor attitude/position controller
%% =========================================================================
% Slow state x = [phi,theta,psi] (attitude), fast state z = [p,q,r] (rates)
% eps = 0.03.  We simulate the SLOW-LOOP position-tracking error directly,
% since the paper's headline claim is a position error in metres.
%   full network:  x_dot = -2.50 x + w(t),  x(0) = x0 (metres)
%   RSM-Compress:   x_dot = -2.42 x + w(t)
% again mirroring the decay-rate pair already used in
% Fig3_Quadrotor_Trajectory.m, but now driving N_TRAJ independent runs and
% reporting (a) the genuine RMS position error in metres and (b) the
% genuine normalised error, so the manuscript can report ONE
% self-consistent pair of numbers instead of two untraceable ones.

eps_quad = 0.03;
t_quad = linspace(0, 3, 600);
dt_quad = t_quad(2) - t_quad(1);
SETTLE_MASK = t_quad >= 1.5;   % post-settling window; RMS over the FULL
                                % transient (including the initial 1 m
                                % offset) is dominated by the decay itself,
                                % not steady-state tracking accuracy, and
                                % is not what "position error" should mean
                                % physically for an already-converged loop.

pos_err_full_quad = zeros(N_TRAJ, 1);
pos_err_rsm_quad  = zeros(N_TRAJ, 1);

for i = 1:N_TRAJ
    x0 = 1.0 + 0.05*randn();               % initial position offset (m), matches x0=1m in paper

    % Independent noise realisations per controller (see CSTR comment above
    % for why a shared noise path would be wrong here).
    w_full = 0.01*randn(size(t_quad));
    w_rsm  = 0.01*randn(size(t_quad));

    x_full = zeros(size(t_quad)); x_full(1) = x0;
    x_rsm  = zeros(size(t_quad)); x_rsm(1)  = x0;
    for k = 2:length(t_quad)
        x_full(k) = x_full(k-1) + dt_quad*(-2.50*x_full(k-1) + w_full(k-1));
        x_rsm(k)  = x_rsm(k-1)  + dt_quad*(-2.42*x_rsm(k-1)  + w_rsm(k-1));
    end

    pos_err_full_quad(i) = sqrt(mean(x_full(SETTLE_MASK).^2));   % post-settling RMS position error, metres
    pos_err_rsm_quad(i)  = sqrt(mean(x_rsm(SETTLE_MASK).^2));
end

norm_err_quad = pos_err_rsm_quad ./ pos_err_full_quad;
[p_quad, ~] = ranksum(pos_err_rsm_quad, pos_err_full_quad);

fprintf('--- Quadrotor Benchmark (N=%d trajectories) ---\n', N_TRAJ);
fprintf('  Position error RSM-Compress (m): %.4f +/- %.4f\n', mean(pos_err_rsm_quad), std(pos_err_rsm_quad));
fprintf('  Position error Full network (m): %.4f +/- %.4f\n', mean(pos_err_full_quad), std(pos_err_full_quad));
fprintf('  Norm. error (RSM/Full):          %.3f +/- %.3f\n', mean(norm_err_quad), std(norm_err_quad));
fprintf('  Wilcoxon rank-sum p (RSM vs Full): %.4f\n', p_quad);
fprintf('  Significant at alpha=%.2f? %s\n\n', ALPHA_SIG, ternary(p_quad < ALPHA_SIG, 'YES', 'NO'));

results.quadrotor.pos_err_rsm_mean  = mean(pos_err_rsm_quad);
results.quadrotor.pos_err_rsm_std   = std(pos_err_rsm_quad);
results.quadrotor.norm_err_mean     = mean(norm_err_quad);
results.quadrotor.norm_err_std      = std(norm_err_quad);
results.quadrotor.p_value           = p_quad;

%% =========================================================================
%% Save results for cross-referencing against the manuscript
%% =========================================================================
save('Benchmark_Statistics_Results.mat', 'results');

fid = fopen('Benchmark_Statistics_Results.txt', 'w');
fprintf(fid, 'RSM-Compress Benchmark Statistics (genuinely computed, N=%d per benchmark)\n', N_TRAJ);
fprintf(fid, 'Generated by Benchmark_Statistics.m -- see header comment for scope/caveats.\n\n');
fprintf(fid, 'CSTR:\n');
fprintf(fid, '  Norm. error: %.3f +/- %.3f\n', results.cstr.norm_err_mean, results.cstr.norm_err_std);
fprintf(fid, '  Wilcoxon p:  %.4f\n\n', results.cstr.p_value);
fprintf(fid, 'Quadrotor:\n');
fprintf(fid, '  Position error RSM (m): %.4f +/- %.4f\n', results.quadrotor.pos_err_rsm_mean, results.quadrotor.pos_err_rsm_std);
fprintf(fid, '  Norm. error:            %.3f +/- %.3f\n', results.quadrotor.norm_err_mean, results.quadrotor.norm_err_std);
fprintf(fid, '  Wilcoxon p:              %.4f\n', results.quadrotor.p_value);
fclose(fid);

fprintf('[Done] Benchmark_Statistics.m complete. Results saved to:\n');
fprintf('  Benchmark_Statistics_Results.mat\n');
fprintf('  Benchmark_Statistics_Results.txt\n');

%% =========================================================================
function out = ternary(cond, a, b)
    if cond, out = a; else, out = b; end
end
