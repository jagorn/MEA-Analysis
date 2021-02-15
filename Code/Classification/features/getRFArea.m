function rf_area = getRFArea(rf)
rf_area = zeros(numel(rf), 1);
for iS = 1:numel(rf)
    if numel(rf(iS).Vertices) > 0
        rf_area(iS,:) = area(rf(iS));
    end
end

