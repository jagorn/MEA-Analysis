function plotElectrodeMEA(elec_position, color)

elec_rect = [elec_position(1) - 0.5, elec_position(2) - 0.5, 1, 1];
rectangle('Position', elec_rect, 'FaceColor', color, 'LineStyle', 'none');