function printValidSTAs(exp_id)
[~, ~, ~, valid] = getSTAsComponents(exp_id);
disp(valid(:)')

