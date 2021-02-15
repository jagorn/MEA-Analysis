function plotEulerCheckerTest(exp_id)

euler_sections = findSections(exp_id, 'euler', 'Allow_Other_Conditions', false);
checker_sections = findSections(exp_id, 'checkerboard', 'Allow_Other_Conditions', false);

if isempty(checker_sections)
    disp('Checkerboard Section (without conditions) not found');
else
    checker_section_id = checker_sections(1).id;
    plotSectionPsth(exp_id, checker_section_id);
end

if isempty(euler_sections)
    disp('Euler Section (without conditions) not found');
    
else
    euler_section_id = euler_sections(1).id;
    plotSectionPsth(exp_id, euler_section_id);
end