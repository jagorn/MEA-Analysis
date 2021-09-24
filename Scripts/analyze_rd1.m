triggers_file = '/home/fran_tr/Data/20210730_rd1_reachr2/sorted/digital.raw';

fid = fopen(triggers_file);
triggers_trace = fread(fid, Inf, 'float32');