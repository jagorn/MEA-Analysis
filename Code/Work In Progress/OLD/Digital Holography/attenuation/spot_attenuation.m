function l = spot_attenuation(x, y)
% DMD induces some light attenuation dependent
% on the <x,y> position of the spot

a = (pi * 250 * 20) / (1040 * 400 * 4.5);

f_x_fact = sin(a * x).^2 ./ (a * x).^2;
f_x_fact(isnan(f_x_fact)) = 1;

f_y_fact = sin(a * y).^2 ./ (a * y).^2;
f_y_fact(isnan(f_y_fact)) = 1;

l = f_x_fact .* f_y_fact;
