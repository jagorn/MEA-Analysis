load(getDatasetMat, 'mosaicsTable')

for i = 1:numel(mosaicsTable)
    class = mosaicsTable(i).class;
    exp = mosaicsTable(i).experiment;
    
    plotExpClassCard(class, exp);
    saveas(gcf, regexprep(class, '\.', ','),'jpg')
    close;
end

function plotClassTraces(typeIDs, titleText)

if ~exist('titleText','var')
    titleText = "Class Mean Trace";
end
 
nTypes = length(typeIDs);
nCols = 2;
nRows = 4;
iClass = 0; 

while iClass < nTypes
    figure('Name', titleText)
    for iColPlot = 1:nCols
        for iRowPlot = 1:nRows 
            iClass = iClass + 1;
            if iClass <= nTypes
                
                iPlot = mod(iClass - 1, nCols*nRows) + 1;
                indices = classIndices(typeIDs(iClass));

                subplot(nRows, nCols*4, [(iPlot-1)*4+1, (iPlot-1)*4+2, (iPlot-1)*4+3])
                plotPSTH(indices);
                title(strcat("Class ", typeIDs(iClass), " (size = ", num2str(sum(indices)), ")"));
                set(gca,'XTickLabel',[]);
                set(gca,'YTickLabel',[]);
                
                subplot(nRows, nCols*4, iPlot*4)
                plotTSTAs(indices);
                set(gca,'XTickLabel',[]);
                set(gca,'YTickLabel',[]);
                title("");
            end
        end
    end
    ss = get(0,'screensize');
    width = ss(3);
    height = ss(4);
    vert = 800;
    horz = 1600;
    set(gcf,'Position',[(width/2)-horz/2, (height/2)-vert/2, horz, vert]);
end

