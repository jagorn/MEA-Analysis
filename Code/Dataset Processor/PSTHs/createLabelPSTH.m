function psth_label = createLabelPSTH(label, conditions)

if isempty(label) && isempty(conditions)
    psth_label = 'simple';
elseif isempty(conditions)
        psth_label = label;
elseif isempty(label) 
    joint_conditions = join(conditions, '_');
    psth_label = joint_conditions{1};
else
    joint_conditions = join(conditions, '_');
    psth_label = strcat(label, '_', joint_conditions{1});
end
        


