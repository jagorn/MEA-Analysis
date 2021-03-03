function HsTable = getHomographiesTable()
hmat_file = getHomographiesMat();
load(hmat_file,  'HsTable');