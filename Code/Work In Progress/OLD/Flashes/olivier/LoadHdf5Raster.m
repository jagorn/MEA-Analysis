function [SpikeTimes,CellList,tags] = LoadHdf5Raster(RasterFile,TemplateFile,SelectedGrades)
%Load raster from circus file, but only cells with a certain grade. 
% Grades: E=1, D=2, C=3, B=4, A=5

tags = double(h5read(TemplateFile,'/tagged'));
Subset = zeros(size(tags));

%New
info = h5info(TemplateFile);
trace_datasets = info.Groups.Datasets;
dataset_names = {trace_datasets.Name};
%
% inf = h5info(RasterFile);
% t = {inf.Groups(3).Datasets.Dataspace};
% for x = 1:550
%     ts{x} = t{1,x}.Size;
% end

for ig=1:length(SelectedGrades)
    Subset(find(tags==SelectedGrades(ig)))=1;
end
Subset = find(Subset>0);

for is=1:length(Subset)
    SpikeTimes{is} = double(h5read(RasterFile,['/spiketimes/' dataset_names{Subset(is)}]));
    CellList(is) = Subset(is);
end

