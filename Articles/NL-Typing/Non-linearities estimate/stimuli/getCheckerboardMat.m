function [checkerboard, frame_rate] = getCheckerboardMat(NbBlocks)
% reconstruct the stimulus assuming repeats are interleaved as AABACA where
% each letter is one block, block A is the one that gets repeated

block_size = 30*20;%Nb of frames in one bloc: 600
%The beginning of repeats will be 1 601 1801 3001...

frame_rate = 30;

BitFilePath='binarysource1000Mbits';
NCheckerboard1 = 51;
NCheckerboard2 = 38;
fid=fopen(BitFilePath,'r','ieee-le');   %Little Endian ordering: specifies the order in which to read the bites in the file
data=fread(fid,'uint16');
fclose(fid);
Nframes = min(8*floor(size(data,1)/(NCheckerboard1*NCheckerboard2)), NbBlocks * block_size);
checkerboard = zeros(NCheckerboard1, NCheckerboard2, Nframes);
for ib=1:NbBlocks
    if mod(ib,2)==0%RepeatedBlock
        Shift=0;
    else
        Shift=block_size*(ib-1)/2;
    end
    for ifr=1:block_size
        it=ifr+Shift;
        for ix=1:NCheckerboard1
            for iy=1:NCheckerboard2
                total = (it-1)*NCheckerboard1*NCheckerboard2 + (iy-1)*NCheckerboard1 + (ix-1);
                %Similar to the stimulus display program.
                k = floor(total/16);
                j = mod(total,16);
                checkerboard(ix,iy,ifr+(ib-1)*block_size) = bitand(data(k+1),2^j)>0;
            end
        end
    end
end