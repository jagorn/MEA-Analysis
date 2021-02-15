function listDataPaths()
global mea_analysis_data_locations

if isempty(mea_analysis_data_locations)
    loadDataPaths();
end

locations = mea_analysis_data_locations.keys();
for i = 1:numel(locations)
    loc = locations{i};
    path = mea_analysis_data_locations(loc);
    fprintf("\t%i. %s\t%s\n", i, loc, path);
end
fprintf("\n");