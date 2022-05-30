function initializeHomographies()

h_file = fullfile(homographiesPath(), 'Homographies.mat');
h_base_file = fullfile(homographiesPath(), 'Homographies_base.mat');

if isfile(h_file)
    yes_or_no = input('Homographies were already inizialized. Do you want to overwrite? (y/n)', 's');
    if ~strcmp(yes_or_no, 'y') && ~strcmp(yes_or_no, 'Y')
        return
    end
end

try 
    copyfile(h_base_file, h_file, 'f')
catch
    disp('Homographies Not found, they will be recomputed');
    setH_Checker2DMD();
    setH_DMD2Camera();
    setH_CameraCenter10x2MEA();
    setH_CameraCenter40x2MEA();
end
disp('Homographies were succesfully Initialized');

