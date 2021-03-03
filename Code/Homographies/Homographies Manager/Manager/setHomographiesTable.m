function setHomographiesTable(HsTable)
hmat_file = getHomographiesMat();
save(hmat_file,  'HsTable');