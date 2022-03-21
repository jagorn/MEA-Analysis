%Generate bin/vec for moving bars
clear all
close all

rng(0);

%% Parameters: in pixel units. 

vec_name = 'spots_fast_white_disc_delay.vec';
bin_name = 'spots_fast_white_disc_delay.bin';

PixelSizeInMicrons = 2.5/4;%7.3;
DiscWidths = [480];%[300 480];%Width of the disc. 900 is a full field in this configuration
DiscLum = [-253 ] ;%Luminance increment of the disc compared to the background
PossibleX = [ 0 ];%Possible X coordinates for the center of the disc
PossibleY = [ 0 ];%Possible Y coordinates for the center of the disc
BackgroundLum = 253;%Background luminance

FrameRate = 40;%Hz
DurationON = 20;%In number of frames
DurationOFF = 140;

ProbaStimVisAlone = length(DiscWidths)*length(DiscLum)*(DurationON+DurationOFF)/(30*FrameRate); % 1 repeat of each stim vis alone each 30 seconds

DurationBefore = 7;
DurationStim = 13;
DurationAfter = 0;
%NOTE sum of the 3 should be DurationON

if (DurationBefore+DurationStim+DurationAfter)~=DurationON
    error('DurationBefore+DurationStim+DurationAfter different from DurationON');
end

TotalX = 1024;
TotalY = 768;

CenterX = TotalX/2;%Center by which the bar is passing
CenterY = TotalY/2;

PossibleX = PossibleX/PixelSizeInMicrons + CenterX;
PossibleY = PossibleY/PixelSizeInMicrons + CenterY;

NbRepeats = 3000;%How many times the stimulus is repeated: this depends on the number of different spot stimulation


%% Generate the frames and save in bin file. 

Xcoor = (1:TotalX)'*ones(1,TotalY);
Ycoor = ones(TotalX,1)*(1:TotalY);

% figure;

nBit=8;
nbTotalFrames = length(PossibleX)*length(PossibleY)+1;

fid=fopen(bin_name,'w','ieee-le'); %Ouverture du nouveau fichier BIN
StimData=int16([TotalX TotalY nbTotalFrames nBit]); %[screensizeX screensizeY nFrames 1]
fwrite(fid,StimData,'int16');

% figure;

Frame = BackgroundLum*ones(size(Xcoor));
Frame = uint8(Frame);
fwrite(fid,Frame,'uint8');% Ecriture de la frame  

FrameCount = 2;
for iWidth=1:length(DiscWidths)
    for iLum=1:length(DiscLum)
        iPosX=1;%Only one position here
        iPosY=1;
        
        FrameNumber(iWidth,iLum) = FrameCount;

        Frame = BackgroundLum*ones(size(Xcoor));

        Frame = Frame + DiscLum(iLum)*(sqrt( (Xcoor-PossibleX(iPosX)).^2 + (Ycoor-PossibleY(iPosY)).^2 ) < DiscWidths(iWidth)/2/PixelSizeInMicrons);

%             imagesc(Frame);
%             pause;
        Frame = uint8(Frame);

        fwrite(fid,Frame,'uint8');% Ecriture de la frame  


        FrameId(iWidth,iLum) = iWidth*10 + iLum;

        FrameCount = FrameCount + 1;
    end
end

fclose(fid);

TotalFrameNb = FrameCount-1;

% FrameId(:,1) = 100 + (1:length(Angles));
% FrameId(:,2) = 200 + (1:length(Angles));


tab(1,:) = [0 TotalFrameNb 0 0 0]';

FrameCount = 1;

rng(0);


tab(FrameCount+1:FrameCount+DurationBefore,2) = 0;
tab(FrameCount+DurationBefore+1:FrameCount+DurationBefore+DurationStim,2) = 0;
tab(FrameCount+DurationBefore+DurationStim+1:FrameCount+DurationON,2) = 0;

tab(FrameCount+1:FrameCount+DurationBefore,4) = 0;
tab(FrameCount+DurationBefore+1:FrameCount+DurationBefore+DurationStim,4) = 0;
tab(FrameCount+DurationBefore+DurationStim+1:FrameCount+DurationON,4) = 0;

tab(FrameCount+1:FrameCount+DurationON,5) = 0;

tab(FrameCount+1:FrameCount+DurationON,1) = 0;
tab(FrameCount+1,1) = 1;

FrameCount = FrameCount+DurationON;

tab(FrameCount+1:FrameCount+DurationOFF,2) = 0;
tab(FrameCount+1:FrameCount+DurationOFF,4) = 0;
tab(FrameCount+1:FrameCount+DurationOFF,5) = 0;

tab(FrameCount+1:FrameCount+DurationOFF,1) = 0;

FrameCount = FrameCount+DurationOFF;

for irep=1:NbRepeats
    
    if rand<ProbaStimVisAlone%We do visual stimulation alone. 
        DisplayHolospot = 0;
        StimId = randi(length(FrameId(:)));
        IdFrame = FrameId(StimId);
        FrameToDisplay = FrameNumber(StimId);
    else
        DisplayHolospot = 1;
        if rand< 1/(length(FrameId(:))+1)%No stim vis
            IdFrame = 0;
            FrameToDisplay=1;
        else
            StimId = randi(length(FrameId(:)));
            IdFrame = FrameId(StimId);
            FrameToDisplay = FrameNumber(StimId);
        end
    end
        
%         tab(FrameCount+1:FrameCount+DurationON,2) = FrameToDisplay-1;
    tab(FrameCount+1:FrameCount+DurationBefore,2) = 0;
    tab(FrameCount+DurationBefore+1:FrameCount+DurationBefore+DurationStim,2) = FrameToDisplay-1;
    tab(FrameCount+DurationBefore+DurationStim+1:FrameCount+DurationON,2) = 0;

    tab(FrameCount+1:FrameCount+DurationBefore,4) = DisplayHolospot;
    tab(FrameCount+DurationBefore+1:FrameCount+DurationBefore+DurationStim,4) = DisplayHolospot;
    tab(FrameCount+DurationBefore+DurationStim+1:FrameCount+DurationON,4) = DisplayHolospot;

    tab(FrameCount+1:FrameCount+DurationON,5) = IdFrame;

    tab(FrameCount+1:FrameCount+DurationON,1) = 0;

    FrameCount = FrameCount+DurationON;

    tab(FrameCount+1:FrameCount+DurationOFF,2) = 0;
    tab(FrameCount+1:FrameCount+DurationOFF,4) = 0;
    tab(FrameCount+1:FrameCount+DurationOFF,5) = IdFrame;

    tab(FrameCount+1:FrameCount+DurationOFF,1) = 0;
    FrameCount = FrameCount+DurationOFF;
    
    
    tab(FrameCount+1-DurationOFF,1) = DisplayHolospot;%Switch to the next pattern if there was a holographic stimulation. 

end


fid=fopen(vec_name,'w');
for i=1:size(tab,1)
    fprintf(fid,'%g %g %g %g %g\n',tab(i,:));
end
fclose(fid);

