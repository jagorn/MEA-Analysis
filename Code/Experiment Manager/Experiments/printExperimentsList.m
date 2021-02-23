function printExperimentsList()

exp_list = experimentList();
for i = 1:numel(exp_list)
    fprintf('%i: %s\n', i, exp_list{i})
end
fprintf('\n')
