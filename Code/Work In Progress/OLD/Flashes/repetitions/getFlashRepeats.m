function repetitions = getFlashRepeats(exp_id, flash_type)


vars_path = [dataPath(), '/' exp_id '/processed'];
flashes_path = [vars_path '/Flashes'];
repetitions_file = [flashes_path '/' char(flash_type) '.mat'];
load(repetitions_file, 'repetitions');

