function pattern_profile = getPatternProfile(pattern_id)
% It returns the temporal profile of a given stimulus pattern
%
% PARAMTERS:
% PATTERN_ID:          the identifier of the pattern.
% 
% OUTPUT:
% pattern_profile: a structure describing the temporal profile of a stimulus pattern.
%   pattern_profile.structure: the whole duration (in frames) of the stimulus
%   pattern_profile.is_full_field: if true, each element of the structure represents a luminance value from 0 (black) to 255 (white).
%                                  if false, each element of the structure represents a frame, listed in the frames field.  
%   pattern_profile.frames: a [n*h*w] matrix representing all the n [h*w]frames of the pattern.

pattern_file = stimPath('patterns.mat');
if ~isfile(pattern_file)
    error_struct.message = strcat("the profile for the pattern ", pattern_id, " has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

load(pattern_file, pattern_id);
pattern_profile = eval(pattern_id);

if ~exist(pattern_id, 'var')
    error_struct.message = strcat("the profile for the pattern ", pattern_id, " has not been found");
    error_struct.identifier = strcat('MEA_Analysis:', mfilename);
    error(error_struct);
end

