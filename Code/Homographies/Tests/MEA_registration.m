tx10 = Tiff('c10.tif','r');
tx40 = Tiff('c40.tif','r');
imgx10 = read(tx10);
imgx40 = read(tx40);

lum_fact = 50;
Hx10 = getHomography('cx10', 'mea');
Hx40 = getHomography('cx40', 'mea');
[meax10, ref_x10] = transformImage(Hx10, imgx10);
[meax40, ref_x40] = transformImage(Hx40, imgx40);

sizex10(1) = ref_x10.XWorldLimits(2) - ref_x10.XWorldLimits(1);
sizex10(2) = ref_x10.YWorldLimits(2) - ref_x10.YWorldLimits(1);

sizex40(1) = ref_x40.XWorldLimits(2) - ref_x40.XWorldLimits(1);
sizex40(2) = ref_x40.YWorldLimits(2) - ref_x40.YWorldLimits(1);

figure();
imshow(meax10*lum_fact, ref_x10)
hold on
imshow(meax40*lum_fact, ref_x40)
hold on
for x = 1:16
    for y = 1:16
        scatter(x*30, y*30, 'r');
    end
end

sizex10
sizex40

x_ratio = sizex10(1) / sizex40(1)
y_ratio = sizex10(2) / sizex40(2)
