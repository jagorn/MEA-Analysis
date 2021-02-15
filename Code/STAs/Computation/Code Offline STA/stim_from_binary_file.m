function [checkerboard, Nframes, path_proposal] = stim_from_binary_file(BitFilePath,NCheckerboard1, NCheckerboard2, Nframes_max)
%STIM_FROM_BINARY_FILE creates an (NCheckerboard1, NCheckerboard2, Nframes) array representing the checkerboard used during the experiment, in a form used for STA computation

% NCheckerboard1 and 2 is the number of squarres per screen side (typically 15)

% Nframes_max : maximum number of frames in the resulting checkerboard. Can be set to Inf  if no restrictions are set,
% but the result file can be very large. If the file is too small, it is detected at the beginning of the Offline STA program.

% OUTPUT :

% path_proposal is a path where it can be convenient to save the checkerboard

% Nframes : number of frames in the checkerboard ( smaller or equal to Nframes_max )


fid=fopen(BitFilePath,'r','ieee-le');   %Little Endian ordering: specifies the order in which to read the bites in the file
data=fread(fid,'uint16');
fclose(fid);

Nframes = min(8*floor(size(data,1)/(NCheckerboard1*NCheckerboard2)), Nframes_max);

checkerboard = zeros(NCheckerboard1, NCheckerboard2, Nframes);

for it=1:Nframes
    for ix=1:NCheckerboard1
        for iy=1:NCheckerboard2
            %total = (it-1)*NCheckerboard1*NCheckerboard2 + (iy-1)*NCheckerboard2 + (ix-1); %/////? See the stimulus display program.   %-1 so that it could be 0. %///// ?
            total = (it-1)*NCheckerboard1*NCheckerboard2 + (iy-1)*NCheckerboard1 + (ix-1); %/////? See the stimulus display program.   %-1 so that it could be 0. %///// ?

            %Similar to the stimulus display program.
            k = floor(total/16);
            j = mod(total,16);
            checkerboard(ix,iy,it) = bitand(data(k+1),2^j)>0; %///// ?
        end
    end
end


%last_dir_separation = find(BitFilePath == '.',1,'last');

if NCheckerboard1 == NCheckerboard2
    path_proposal = [BitFilePath '_vector_Nsq' int2str(NCheckerboard1) '_Nframes' int2str(Nframes) '_.mat'];
    %path_proposal = [BitFilePath(1:(last_dir_separation-1)) '_vector_Nsq' int2str(NCheckerboard1) '_.mat'];
else
    path_proposal = [BitFilePath '_vector_Nsq' int2str(NCheckerboard1) 'x'  int2str(NCheckerboard2) '_Nframes' int2str(Nframes) '.mat'];
    %path_proposal = [BitFilePath(1:(last_dir_separation-1)) '_vector_Nsq' int2str(NCheckerboard1) 'x'  int2str(NCheckerboard2) '_.mat'];
end

end

