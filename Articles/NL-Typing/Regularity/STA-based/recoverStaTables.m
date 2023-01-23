
load('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/typing_data.mat', ...
     'controlTable', 'temporalSTAs', 'psths');


classNames = unique([controlTable.class]);
nClasses = length(classNames);

classesTableRF = struct(  'name',     cell(1, nClasses), ...
    'size',     cell(1, nClasses), ...
    'indices',  cell(1, nClasses) ...
    );

for iClass = 1:numel(classNames)
    name = classNames(iClass);
    if  not(endsWith(name, "."))
        name = strcat(name, ".");
    end
    typeCodes = [controlTable.class];
    indices = startsWith(typeCodes, name);
    find(indices)
    
    classesTableRF(iClass).name = classNames(iClass);
    classesTableRF(iClass).size = sum(indices);
    
    if sum(indices>0) > 1
        classesTableRF(iClass).PSTH = mean(psths(indices, :));
        classesTableRF(iClass).STA = mean(temporalSTAs(indices, :));
    else
        classesTableRF(iClass).PSTH = psths;
        classesTableRF(iClass).STA = temporalSTAs;
    end
    
    if   abs(max(classesTableRF(iClass).STA)) > abs(min(classesTableRF(iClass).STA))
        classesTableRF(iClass).POLARITY = "ON";
    else
        classesTableRF(iClass).POLARITY = "OFF";
    end
    
    classesTableRF(iClass).SNR = doSNR(psths(indices, :));
    classesTableRF(iClass).SNR_STA = doSNR(temporalSTAs(indices, :));
    classesTableRF(iClass).indices = indices;
end

classesTableNotPrunedRF = classesTableRF;

% remove pruned
pruned = false(nClasses, 1);
for iClass = 1:nClasses
    pruned(iClass) = endsWith(classesTableRF(iClass).name, "_PRUNED.");
end
classesTableRF(pruned) = [];

save('/home/fran_tr/Projects/MEA-Analysis/Articles/Typing/typing_data.mat', ...
     'classesTableRF', 'classesTableNotPrunedRF', '-append');
