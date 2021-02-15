function header_size = getHeaderSize(raw_file, varargin)
% Calculates the size the header of a .raw MEA file
% INPUTS:
% raw_file: the path to the raw file
% Header_Max_Size (optional): the maximum expected side of the header
% OUTPUT:
% header_size: the size of the header

% Default parameters
header_max_size_def = 10000;

% Parse Input
p = inputParser;
addRequired(p, 'raw_file');
addParameter(p, 'Header_Max_Size', header_max_size_def);
parse(p, raw_file, varargin{:});
header_max_size = p.Results.Header_Max_Size; 

header_txt = '';
header_size = 0;
is_header = true;

fid = fopen(raw_file,'r');
while is_header
    header_size = header_size + 1;
    header_txt = [header_txt fread(fid, 1, 'uint8=>char')'];
    
    if (header_size > 2)
        if strcmp(header_txt((header_size - 2):header_size), 'EOH')
            is_header = false;
        end
    end
    if header_size > header_max_size
        warning('%s: header not found', raw_file)
        header_size = 0;
        return
    end
end
fclose(fid);

% Because there is two characters after the EOH, before the raw data.
header_size = header_size + 2;
