function savePatternProfile(pattern_id, pattern_profile)
% It saves the temporal profile of a given stimulus pattern
%
% PARAMTERS:
% PATTERN_ID:          the identifier of the pattern.
% PATTERN_PROFILE: a structure describing the temporal profile of a stimulus pattern.
%   pattern_profile.structure: the whole duration (in frames) of the stimulus
%   pattern_profile.is_full_field: if true, each element of the structure represents a luminance value from 0 (black) to 255 (white).
%                                  if false, each element of the structure represents a frame, listed in the frames field.  
%   pattern_profile.frames: a [n*h*w] matrix representing all the n [h*w]frames of the pattern.

pattern_file = stimPath('patterns.mat');
s.(pattern_id) = pattern_profile;

if ~isfile(pattern_file)
    save(pattern_file, '-struct', 's', pattern_id);
else
    save(pattern_file, '-struct', 's', pattern_id, '-append');
end
fprintf('pattern %s saved\n', pattern_id);