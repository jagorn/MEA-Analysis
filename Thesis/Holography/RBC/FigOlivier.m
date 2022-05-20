clear;
close all;

f1 = plotHoloSTA('20191011_grid_no_thresh', 31, 1 ,'Show_Activation', true, 'Center_Microns', [200, 160], 'Width_Microns', 300, 'Title','OFF RGC #1' );
pause(3);
f2 = plotHoloSTA('20191011_grid_no_thresh', 44, 1 ,'Show_Activation', true, 'Center_Microns', [250, 350], 'Width_Microns', 300, 'Title','OFF RGC #2' );

ss = get(0,'screensize');
width = ss(1, 3);
height = ss(1, 4);


f1.Position =  [0, 0, width/2, height/2];
f2.Position =  [width/2, 0, width/2, height/2];
f3.Position =  [0, height/2, width/2, height/2];
f4.Position =  [width/2, height/2, width/2, height/2];
