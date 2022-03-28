close all;
figure();
hold on;
daspect([1, 1, 1]);

d = 4;
for i_y = 1:10
    for i_x = 1:10
        y = i_y * d * sqrt(3) / 2;
        x = i_x * d + d / 2 * mod(i_y, 2);
        p = doExagon(d/sqrt(3), x, y);
        
        if i_y == 5 && i_x == 5
            plot(p, 'FaceColor', 'magenta', 'FaceAlpha', 0.2)
            plot([x, x+d/2], [y, y + d * sqrt(3) / 2], 'k', 'LineWidth', 1);
        else
            plot(p, 'FaceAlpha', 0)
        end
        scatter(x, y, 30, [0.8, 0.2, 0.2], 'Filled');
        area_measured = area(p)
        area_computed = sqrt(3) * d^2 / 2;
    end
end

xlim([2, 8]);
ylim([2, 8]);

function p = doExagon(size, cx, cy)

N_sides = 6;
t=(0:1/N_sides:(1-1/(N_sides*2)))'*2*pi;
x=sin(t);
y=cos(t);
x=size*[x; x(1)];
y=size*[y; y(1)];
p = polyshape(x + cx, y + cy);
end