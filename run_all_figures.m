%% =========================================================================
%% run_all_figures.m
%% =========================================================================

clearvars;
close all;
clc;

scripts = { ...
    'Fig1_RSMCompress_Pipeline', ...
    'Fig2_CSTR_Trajectory', ...
    'Fig3_Quadrotor_Trajectory', ...
    'Fig4_Fisher_Eigenvalue_Decay', ...
    'Fig5_NGD_Convergence', ...
    'Fig6_Epsilon_Rank_Dependence', ...
    'Fig7_Ablation_Study' ...
};

nScripts = numel(scripts);

figure_status = strings(nScripts,1);
figure_times  = NaN(nScripts,1);

fprintf('============================================================\n');
fprintf(' RSM-Compress Figure Suite\n');
fprintf('============================================================\n\n');

for idx = 1:nScripts

    scriptName = scripts{idx};
    try

        tStart = tic;

        run([scriptName '.m']);

        elapsed = toc(tStart);

        close all;

        figure_status(idx) = "PASS";
        figure_times(idx)  = elapsed;

        fprintf('[PASS] %s (%.2f s)\n', scriptName, elapsed);

    catch ME

        figure_status(idx) = "FAIL";
        figure_times(idx)  = NaN;

        fprintf('\n');
        fprintf('====================================================\n');
        fprintf('[FAIL] %s\n', scriptName);
        fprintf('Message : %s\n', ME.message);

        if ~isempty(ME.stack)
            fprintf('File    : %s\n', ME.stack(1).file);
            fprintf('Line    : %d\n', ME.stack(1).line);
        end

        fprintf('====================================================\n\n');

    end

end

fprintf('\n============================================================\n');
fprintf('SUMMARY\n');
fprintf('============================================================\n');

for idx = 1:nScripts
    fprintf('%-35s  %-5s  %.2f s\n', ...
        scripts{idx}, figure_status(idx), figure_times(idx));
end

fprintf('------------------------------------------------------------\n');

nPass = sum(figure_status=="PASS");

fprintf('Passed : %d / %d\n', nPass, nScripts);
fprintf('Failed : %d / %d\n', nScripts-nPass, nScripts);

fprintf('============================================================\n');