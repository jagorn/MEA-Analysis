function generateFakeRawFile(n_electrodes, output_file)

matrix = ones(10, n_electrodes);

file_id = fopen(output_file, 'w');
fwrite(file_id, matrix, 'int16');
fclose(file_id);

