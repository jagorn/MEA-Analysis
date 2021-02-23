%Script to analyze Elaine's data, and more generally flash data. 

close all
clear all

% gtacr expt
RasterFile = '/home/fran_tr/Data/20190416_gtacr/sorted/CONVERTED/CONVERTED.result-final.hdf5';
TemplateFile = '/home/fran_tr/Data/20190416_gtacr/sorted/CONVERTED/CONVERTED.templates-final.hdf5';
StimFile = '/home/fran_tr/Data/20190416_gtacr/processed/trigT_stim_short.mat';
SelectedGrades = [4 5];%A and B=4 5

Conds = [5 8 11 12 15];
CellsToDisplay = [55 68 69 78 91];

ONCtrlWin = [0.5 0.95];
ONRespWin = [1 2];

OFFCtrlWin = [1.5 1.95];
OFFRespWin = [2 3];
IndexFromSorting = 1;

%% ReachR expt
% RasterFile = '/home/fran_tr/Data/20180806_reachr/sorted/CONVERTED/CONVERTED.result-final.hdf5';
% TemplateFile = '/home/fran_tr/Data/20180806_reachr/sorted/CONVERTED/CONVERTED.templates-final.hdf5';
% StimFile = '/home/fran_tr/Data/20180806_reachr/processed/trigT_stim.mat';
% RemoveTrigStep = 4;%We jump by steps of 4 in the event times. 
% SelectedGrades = [4 5];%A and B
% 
% Conds = [2 9 10 11 12 14];
% CellsToDisplay = [1 2 3 4 5];
% 
% ONCtrlWin = [1.5 1.95];
% ONRespWin = [2 3];
% 
% OFFCtrlWin = [3.5 3.95];
% OFFRespWin = [4 5];
% 
% IndexFromSorting = 0;

%% Common parameters

ShowThreshold = 1;

BinSize = 0.05*20000;
NbBins = 60;
SamplingRate = 20000;


kZscore = 5;
MinFiringRate = 2;

ShowResponses = 1;
% Load data
[SpikeTimes,CellList,tags] = LoadHdf5Raster(RasterFile,TemplateFile,SelectedGrades);

load (StimFile,'-mat')

% Reindex cells for display
if IndexFromSorting>0
    for ic=1:length(CellsToDisplay)
        SortingId = CellsToDisplay(ic);
        if any(CellList == SortingId)
            CellsToDisplay(ic) = find(CellList==SortingId);
        else
            CellsToDisplay(ic) = 0;
        end
    end
    CellsToDisplay = CellsToDisplay(find(CellsToDisplay>0));
end



% Compute PSTH for different cells and different conditions
for ic=1:length(Conds)
    EventTime = trigT_stim{Conds(ic)};
    EventTime = EventTime(1:2:end)*20000;%Variable was in seconds. Take one flash out of 4. 
    median(diff(EventTime))/20000
    [PSTH{ic},XPSTH,MeanPSTH] = DoPSTH_Olivier(SpikeTimes,EventTime,BinSize,NbBins,SamplingRate,(1:length(SpikeTimes)));
    % estimate zscore

    [zON(:,ic),ThresON(:,ic)] = EstimateZscore(PSTH{ic},XPSTH,ONCtrlWin,ONRespWin,kZscore,MinFiringRate);
    [zOFF(:,ic),ThresOFF(:,ic)] = EstimateZscore(PSTH{ic},XPSTH,OFFCtrlWin,OFFRespWin,kZscore,MinFiringRate);
end

%Display PSTHs
if ~isempty(CellsToDisplay)
    figure;
    count = 1;
    for ic=1:length(CellsToDisplay)
        MaxP = 0;
        for icond=1:length(Conds)
            if max(PSTH{icond}(:,CellsToDisplay(ic)))>MaxP
                MaxP = max(PSTH{icond}(:,CellsToDisplay(ic)));
            end
        end
        for icond=1:length(Conds)
            subplot(length(CellsToDisplay),length(Conds),count);
            if ShowResponses>0
                if zON(CellsToDisplay(ic),icond)>0 | zOFF(CellsToDisplay(ic),icond)>0 
                    plot(XPSTH,PSTH{icond}(:,CellsToDisplay(ic)),'b','LineWidth',2)
                else
                    plot(XPSTH,PSTH{icond}(:,CellsToDisplay(ic)),'k','LineWidth',2)
                end
            else 
                plot(XPSTH,PSTH{icond}(:,CellsToDisplay(ic)),'k','LineWidth',2)
            end
            hold on
            
            if ShowThreshold>0
                plot(ONRespWin,[ThresON(CellsToDisplay(ic),icond) ThresON(CellsToDisplay(ic),icond)] ,'m')
                plot(OFFRespWin,[ThresOFF(CellsToDisplay(ic),icond) ThresOFF(CellsToDisplay(ic),icond)] ,'c')
            end
            
%             plot([2 4],[1 1]*MaxP+1,'r','LineWidth',2)
%             plot([6 8],[1 1]*MaxP+1,'r','LineWidth',2)
            plot([1 2],[1 1]*MaxP+1,'r','LineWidth',2)
            plot([3 4],[1 1]*MaxP+1,'r','LineWidth',2)
            ylim([0 MaxP+2])
            xlim([0 8])
            set(gca,'box','off')
            count = count + 1;
        end
    end
end


% compile results: 
% tracked cells across conditions: pick the cells are always responding. 

zResponse = 1 - (1 - zON).*(1 - zOFF);
TrackedCells = find(sum(zResponse,2) == size(zResponse,2));%Cells responding in all conditions. 

% Ratio of ON and OFF cells for each condition for tracked cells. 
% Number of ON and OFF cells for each condition for all cells. 

TotalON = sum(zON);
TotalOFF = sum(zOFF);

RatioON = TotalON./(TotalON+TotalOFF);
RatioOFF = TotalOFF./(TotalON+TotalOFF);

TotalCells = [TotalON ; TotalOFF];
RatioCells = [RatioON ; RatioOFF]*100;

figure;bar(TotalCells')
legend('ON','OFF')
set(gca,'box','off')
set(gca,'FontSize',16)
ylabel('Cell Number ')
set(gca,'XTick',[1 2 3 4 5 6],'XTickLabel',{'L1';'L2';'L3';'L4';'L5';'L6'})


figure;bar(RatioCells')
legend('ON','OFF')
set(gca,'box','off')
set(gca,'FontSize',16)
ylabel('Ratio (%) ')
set(gca,'XTick',[1 2 3 4 5 6],'XTickLabel',{'L1';'L2';'L3';'L4';'L5';'L6'})

