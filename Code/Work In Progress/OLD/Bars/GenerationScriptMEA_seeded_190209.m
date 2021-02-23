%Generate bin/vec for moving bars
clear all
close all

%Fix the seed and the version ID
version_id = '_190209';
seed_id = 190209;

rng(seed_id)
vec_file = strcat('DS_MEA', version_id, '.vec');
bin_file = strcat('DS_MEA', version_id, '.bin');


%% Parameters: in pixel units. 

PixelSizeInMicrons = 2.5;   % 7.3;
BarWidthInMicrons = 300;
BarLengthInMicrons = 1000;
SpeedInMmPerS = 1;          % mm per second
FrameRate = 40;             % Hz

TotalX = 1024;
TotalY = 768;
StartingRadius = 500;       % In Pixel
%Increase this if you want the bar to start further away from the center

BackgroundLum = 255;
PossibleLums = 0;

CenterX = TotalX/2;     % Center by which the bar is passing
CenterY = TotalY/2;

Angles = [0 45 90 135 180 225 270 315];

NbRepeats = 10; % How many times the stimulus is repeated

OrthogonalShiftsInMicrons = [-300 0 300];

BarWidth = BarWidthInMicrons / PixelSizeInMicrons;
BarLength = BarLengthInMicrons / PixelSizeInMicrons;
PixelStep = (1000*SpeedInMmPerS/FrameRate)/PixelSizeInMicrons;
%This is the distance covered by the bar between two consecutives frames, 
% it determines the speed of the bar. 


%% Generate the frames and save in bin file. 

CenterPos = -StartingRadius:PixelStep:StartingRadius;

Xcoor = (1:TotalX)'*ones(1,TotalY);
Ycoor = ones(TotalX,1)*(1:TotalY);

% figure;

nBit=8;
nbTotalFrames = length(CenterPos)*length(Angles)*length(PossibleLums)*length(OrthogonalShiftsInMicrons);

fid=fopen(bin_file,'w','ieee-le'); %Ouverture du nouveau fichier BIN
StimData=int16([TotalX TotalY nbTotalFrames nBit]); %[screensizeX screensizeY nFrames 1]
fwrite(fid,StimData,'int16');

FrameCount = 1;
for ilum=1:length(PossibleLums)
    for iangle=1:length(Angles)
        for ioshift=1:length(OrthogonalShiftsInMicrons)
            FrameStart(iangle,ilum,ioshift) = FrameCount;
            for iCenter=1:length(CenterPos)
                Xcenter = CenterPos(iCenter)*cos(2*pi*Angles(iangle)/360) + CenterX + (OrthogonalShiftsInMicrons(ioshift)/ PixelSizeInMicrons)*cos(2*pi*(Angles(iangle)+90)/360);
                Ycenter = CenterPos(iCenter)*sin(2*pi*Angles(iangle)/360) + CenterY + (OrthogonalShiftsInMicrons(ioshift)/ PixelSizeInMicrons)*sin(2*pi*(Angles(iangle)+90)/360);

                ProjectedLength = (Xcoor - Xcenter)*cos(2*pi*Angles(iangle)/360) + (Ycoor - Ycenter)*sin(2*pi*Angles(iangle)/360); 
                ProjectedWidth = (Xcoor - Xcenter)*cos(2*pi*(Angles(iangle)+90)/360) + (Ycoor - Ycenter)*sin(2*pi*(Angles(iangle)+90)/360); 

                Frame = BackgroundLum*ones(size(ProjectedLength));
                Frame(find(abs(ProjectedLength(:)) <= BarLength/2 & abs(ProjectedWidth(:)) <= BarWidth/2)) = PossibleLums(ilum);
%                 imagesc(Frame);
%                 pause;
                Frame = uint8(Frame);

                fwrite(fid,Frame,'uint8');% Ecriture de la frame  

                FrameCount = FrameCount + 1;
                
                
            end
            FrameEnd(iangle,ilum,ioshift) = FrameCount - 1;
            
            FrameId(iangle,ilum,ioshift) = ilum*1000 + 100*ioshift + iangle;
        end
    end
end

fclose(fid);

TotalFrameNb = FrameCount-1;

% FrameId(:,1) = 100 + (1:length(Angles));
% FrameId(:,2) = 200 + (1:length(Angles));


tab(1,:) = [0 TotalFrameNb 0 0 0]';

FrameCount = 1;

for irep=1:NbRepeats
    Directions = randperm(length(FrameId(:)));
    for iDir=1:length(Directions)
        Seq = (FrameStart(Directions(iDir)):FrameEnd(Directions(iDir)))' - 1;
        tab(FrameCount+1:FrameCount+length(Seq),2) = Seq;
        tab(FrameCount+1:FrameCount+length(Seq),5) = FrameId(Directions(iDir));
        FrameCount = FrameCount+length(Seq);
    end
end


fid=fopen(vec_file,'w');
for i=1:size(tab,1)
    fprintf(fid,'%g %g %g %g %g\n',tab(i,:));
end
fclose(fid);

