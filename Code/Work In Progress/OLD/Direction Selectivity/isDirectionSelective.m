function [dsK, dsAngle, osK, osAngle, directionModules] = isDirectionSelective(bars_psth, directions)

nCells = size(bars_psth, 1);
nDirections = size(bars_psth, 3);

dsK = zeros(nCells, 1);
osK = zeros(nCells, 1);

dsAngle = zeros(nCells, 1);
osAngle = zeros(nCells, 1);

dirVectors = zeros(nCells, nDirections);
orVectors = zeros(nCells, nDirections);

directionModules = zeros(nCells, nDirections);
for iCell = 1:nCells
    cellBarPSTHs = squeeze(bars_psth(iCell, :, :));
    [~, ~, dirComponents] = svd(cellBarPSTHs);
    directionModules(iCell, :) = dirComponents(:,1)';
    
    % Solve the sign ambiguity of SVD
    activityByDirection = std(cellBarPSTHs);
    [~, maxActivityDirection] = max(activityByDirection);
    if directionModules(iCell, maxActivityDirection) < 0
        directionModules(iCell, :) = directionModules(iCell, :) * -1;
    end
    
    dirVectors(iCell, :) = directionModules(iCell, :) .* exp(directions * 1i);
    orVectors(iCell, :) = directionModules(iCell, :) .* exp(directions * 2i);

    dsK(iCell) = abs(sum(dirVectors(iCell, :)));
    osK(iCell) = abs(sum(orVectors(iCell, :)));

    dsAngle(iCell) = angle(sum(dirVectors(iCell, :)));
    osAngle(iCell) = mod(angle(sum(orVectors(iCell, :))), 2 * pi) / 2;
end
