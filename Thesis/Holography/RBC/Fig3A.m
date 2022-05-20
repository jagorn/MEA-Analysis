clear;
close all;

f1 = plotHoloSTA('20191011_grid_no_thresh', 106, 1 ,'Show_Activation', true, 'Center_Microns', [200, 400], 'Width_Microns', 300, 'Title', 'ON RGC - No Blockers' );
pause(3);
f2 = plotHoloSTA('20191011_grid_no_thresh', 106, 3 ,'Show_Activation', true, 'Center_Microns', [200, 400], 'Width_Microns', 300, 'Title','ON RGC - Blockers' );

pause(3);
f3 = plotHoloSTA('20191011_grid_no_thresh', 326, 1 ,'Show_Activation', true, 'Center_Microns', [400, 150], 'Width_Microns', 300, 'Title', 'OFF RGC - No Blockers' );
pause(3);
f4 = plotHoloSTA('20191011_grid_no_thresh', 326, 3 ,'Show_Activation', true, 'Show_Colorbar', true, 'Center_Microns', [400, 150], 'Width_Microns', 300, 'Title', 'OFF RGC- Blockers' );



ss = get(0,'screensize');
width = ss(1, 3);
height = ss(1, 4);


f1.Position =  [0, 0, width/2, height/2];
f2.Position =  [width/2, 0, width/2, height/2];
f3.Position =  [0, height/2, width/2, height/2];
f4.Position =  [width/2, height/2, width/2, height/2];
