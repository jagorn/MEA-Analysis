clear
close all

load(getDatasetMat(), 'cellsTable', 'classesTable', 'flash_Z');
flashes_conditions = {'No Block';'Very Dim';'Mid Dim';'Mid Bright';'Very Bright'};

[n_cells, n_conditions] = size(flash_Z.zON);

ONCells = [cellsTable.POLARITY] == 'ON';
OFFCells = [cellsTable.POLARITY] == 'OFF';

TotalON = sum(ONCells);
TotalOFF = sum(OFFCells);

% cells that behave weird
BothOnsetOffset_idx = logical(sum(flash_Z.zON' & flash_Z.zOFF'));  % cells that respond to both onset and offset
InconsistentOFF_idx = logical(~flash_Z.zOFF(:, 1)' & OFFCells);  % cells with OFF STA that respond like ON
InconsistentON_idx = logical(~flash_Z.zON(:, 1)' & ONCells); % cells with ON STA that respond like OFF
bad_cells = BothOnsetOffset_idx | InconsistentOFF_idx | InconsistentON_idx;
disp([num2str(sum(bad_cells)) ' bad cells were removed'])

onsetOn = sum(repmat(ONCells & ~bad_cells, n_conditions, 1)' & flash_Z.zON);
offsetOn = sum(repmat(ONCells & ~bad_cells, n_conditions, 1)' & flash_Z.zOFF);
onsetOff = sum(repmat(OFFCells & ~bad_cells, n_conditions, 1)' & flash_Z.zON);
offsetOff = sum(repmat(OFFCells & ~bad_cells, n_conditions, 1)' & flash_Z.zOFF);
silentOn = sum(repmat(ONCells & ~bad_cells, n_conditions, 1)' & ~flash_Z.zOFF & ~flash_Z.zON);
silentOff =  sum(repmat(OFFCells & ~bad_cells, n_conditions, 1)' & ~flash_Z.zOFF & ~flash_Z.zON);

TotalON = sum(ONCells & ~bad_cells);
TotalOFF = sum(OFFCells & ~bad_cells);

PercentageOnsetON = onsetOn / TotalON;
PercentageOnsetOFF = onsetOff / TotalOFF;
PercentageOffsetON = offsetOn / TotalON;
PercentageOffsetOFF = offsetOff / TotalOFF;
PercentageSilentON = silentOn / TotalON;
PercentageSilentOFF = silentOff / TotalOFF;

GraphOnCells = [PercentageOnsetON; PercentageOffsetON; PercentageSilentON]*100;
GraphOffCells = [PercentageOnsetOFF  ; PercentageOffsetOFF; PercentageSilentOFF]*100;


flash_idx = 2:5;
legend_onset = 'Cells activated at Onset';
legend_offset ='Cells activated at Offset';
legend_silent ='Cells not activated';

figure;
subplot(1, 2, 1);
b = bar(GraphOnCells(:, flash_idx)');
legend(legend_onset, legend_offset, legend_silent)
set(gca,'box','off')
ylabel('Percentage (%) ')
set(gca,'XTickLabel', flashes_conditions(flash_idx))
xlabel('Light Levels')
ylim([0 100])
b(1).FaceColor = [.99 .5 .5];
b(2).FaceColor = [.8 .2 .2];
b(3).FaceColor = [.3 .3 .3];
title(['ON Cells (' num2str(TotalON) ')'])

subplot(1, 2, 2);
b = bar(GraphOffCells(:, flash_idx)');
legend(legend_onset, legend_offset, legend_silent)
set(gca,'box','off')
ylabel('Percentage (%) ')
set(gca,'XTickLabel', flashes_conditions(flash_idx))
xlabel('Light Levels')
ylim([0 100])
b(1).FaceColor = [.5 .99 .5];
b(2).FaceColor = [.2 .8 .2];
b(3).FaceColor = [.3 .3 .3];
title( ['OFF Cells (' num2str(TotalOFF) ')'])


% Now look at cell types
conditions = [2 3];

on_classes_names = [];
off_classes_names = [];
on_classes_activation = [];
off_classes_activation = [];

for class = classesTable
    class_idx = find(class.indices);
    class_name = string(class.name);
    class_size = numel(class_idx);
    
    if strcmp(class.POLARITY, 'ON')
        ClassActivated = sum(flash_Z.zOFF(class_idx, conditions));  % OFF response to inhibition ==> ON cell
        classPercentage = ClassActivated/class_size*100;
        on_classes_names = [on_classes_names class_name];
        on_classes_activation = [on_classes_activation classPercentage'];
    else
        ClassActivated = sum(flash_Z.zON(class_idx, conditions));   % ON response to inhibition ==> OFF cell
        classPercentage = ClassActivated/class_size*100;
        off_classes_names = [off_classes_names class_name];
        off_classes_activation = [off_classes_activation classPercentage'];
    end
end

figure;
subplot(1, 3, [1 2])
b = bar(on_classes_activation');
b(1).FaceColor = [.2 .2 .7];
b(2).FaceColor = [.7 .7 .95 ];

legend('Very Dim', 'Mid Dim')
set(gca,'box','off')
% set(gca,'FontSize',16)
ylabel('Percentage (%) ')
set(gca,'XTickLabel', on_classes_names)
xlabel('ON cell types')

subplot(1, 3, 3)
b = bar(off_classes_activation');
b(1).FaceColor = [.8 .2 .2];
b(2).FaceColor = [.99 .6 .6];

legend('Very Dim', 'Mid Dim')
set(gca,'box','off')
% set(gca,'FontSize',16)
ylabel('Percentage (%) ')
set(gca,'XTickLabel', off_classes_names)
xlabel('OFF cell types')

suptitle('Percentage of activated cells for each cell type')
