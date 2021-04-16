function createEulerStimPattern()

euler_profile = load(getVecFile('euler', 'euler_180530'));
pattern_profile.profile = 255 - euler_profile(2:1001, 2);
pattern_profile.is_full_field = true;
savePatternProfile('euler', pattern_profile)