function discs = getDiscsStimInfo(discs_mat_file, discs_vec_file)

load(discs_mat_file, 'Diam100', 'Diam300', 'Diam600');
load(discs_mat_file, 'PossiblePosX100', 'PossiblePosY100');
load(discs_mat_file, 'PossiblePosX300', 'PossiblePosY300');
load(discs_mat_file, 'PossiblePosX600', 'PossiblePosY600');
load(discs_mat_file, 'DurationON', 'DurationOFF', 'DurationBlackSpot');
PossibleDiams = [Diam100, Diam300, Diam600];

stim_vec = load(discs_vec_file);
discs_triggers = num2str(stim_vec(2:end, 5));
discs_triggers = discs_triggers(:, 2:4); % Ignore first position (Luminosity)
discs_ids = unique(discs_triggers(~ismember(discs_triggers, '  0', 'rows'), :), 'rows');

% Build a struct with informations about all the discs
for i_disc = 1:length(discs_ids)
    id = discs_ids(i_disc, :);
    
    % remember that: id = ilum*1000 +idiam*100+iCenterX*10+iCenterY
    idiam = str2double(id(1));
    ix = str2double(id(2));
    iy = str2double(id(3));
    
    diam = PossibleDiams(idiam);
    
    if diam == 100
        PossiblePosX = PossiblePosX100;
        PossiblePosY = PossiblePosY100;
    elseif diam == 300
        PossiblePosX = PossiblePosX300;
        PossiblePosY = PossiblePosY300;
    elseif diam == 600
        PossiblePosX = PossiblePosX600;
        PossiblePosY = PossiblePosY600;
    end
    
    % In my dmd reference frame x is the short side, and y is the long one,
    % so I need to swap them.
    y = PossiblePosX(ix);
    x = PossiblePosY(iy);
    
    discs(i_disc).id = string(id);
    discs(i_disc).diameter = diam;
    discs(i_disc).center_x = x;
    discs(i_disc).center_y = y;
    discs(i_disc).dt = DurationON + DurationBlackSpot + DurationOFF;

    discs(i_disc).triggers_idx_onset = [];
    discs(i_disc).triggers_idx_offset = [];

    discs(i_disc).dt_white_init = DurationON;
    discs(i_disc).dt_black_middle = DurationBlackSpot;
    discs(i_disc).dt_white_end = DurationOFF;

end

% For each disc, find all the onset and offset triggers.
previous_disc_id = '  0';
for i_trigger = 1:length(discs_triggers)
    
    current_disc_id = discs_triggers(i_trigger, :);
    if ~strcmp(current_disc_id, previous_disc_id)
        
        for i_disc = 1:numel(discs)
            % assign the onset trigger to the current disc
            if strcmp(discs(i_disc).id, current_disc_id) && strcmp(previous_disc_id, '  0')
                discs(i_disc).triggers_idx_onset = [discs(i_disc).triggers_idx_onset i_trigger];
            end
            % assign the offset trigger to the previous disc
            if strcmp(discs(i_disc).id, previous_disc_id) && strcmp(current_disc_id, '  0')
                discs(i_disc).triggers_idx_offset = [discs(i_disc).triggers_idx_offset i_trigger];
            end
        end
    end
    previous_disc_id = current_disc_id;
end