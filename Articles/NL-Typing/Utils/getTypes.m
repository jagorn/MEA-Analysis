function types = getTypes(classesTable, min_SNR, min_size)

types_idx = ([classesTable.SNR] >= min_SNR) & ([classesTable.size] >= min_size);
types = classesTable(types_idx);