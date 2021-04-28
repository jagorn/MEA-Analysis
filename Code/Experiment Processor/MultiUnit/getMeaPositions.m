function Positions = getMeaPositions(exp_id)

if exist('exp_id', 'var')
    
    mea_file = meaFile(exp_id);
    load(mea_file, 'Positions');
    
    if ~exist('Positions', 'var')
        error_struct.message = strcat("MEA map not found in ", exp_id);
        error_struct.identifier = strcat('MEA_Analysis:', mfilename);
        error(error_struct);
    end
else
    mea_file = fullfile(rigPath, 'PositionsMEA');
    load(mea_file, 'Positions');
end


