function residual = computeMEAResidual(excluded_electrodes, residuals)

electrodes = 1:size(residuals,1);
for dead = excluded_electrodes
    electrodes(electrodes==dead) = [];
end
residual = max(residuals(electrodes, :));
