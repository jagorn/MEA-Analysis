%Generate bin/vec for moving bars
clear all
close all

%% Parameters

lum_magnification = 16;
size_factor = 4;
StimFileName = 'DiscsX40_DIM';
ShowFrames = true;
DT = 0.3;

x_bckgnd = 32;
PixelSizeInMicrons = 2.5/size_factor;% size of 1 pixel. Here estimated value for 40x. 
DiscWidths = [300 480];%Width of the disc. 
PossibleLums = [x_bckgnd (x_bckgnd - 255)];%Luminance of the disc compared to the background
PossibleX = [ 0 ];%Possible X coordinates for the center of the disc
PossibleY = [ 0 ];%Possible Y coordinates for the center of the disc
BackgroundLum = 255 - x_bckgnd;%Background luminance

FrameRate = 40;%Hz
DurationON = round(DT*FrameRate);%In number of frames
DurationOFF = round(DT*FrameRate);

TotalX = 1024;
TotalY = 768;

CenterX = TotalX/2;%Center by which the bar is passing
CenterY = TotalY/2;

PossibleX = PossibleX/PixelSizeInMicrons + CenterX;
PossibleY = PossibleY/PixelSizeInMicrons + CenterY;

NbRepeats = 60;%How many times the stimulus is repeated: this depends on the number of different spot stimulation


%% Generate the frames and save in bin file. 

Xcoor = (1:TotalX)'*ones(1,TotalY);
Ycoor = ones(TotalX,1)*(1:TotalY);
FrameCount = 0;

nBit=8;
nbTotalFrames = length(PossibleX)*length(PossibleY)*length(PossibleLums)*length(DiscWidths)+1;

fid=fopen([StimFileName '.bin'],'w','ieee-le'); %Ouverture du nouveau fichier BIN
StimData=int16([TotalX TotalY nbTotalFrames nBit]); %[screensizeX screensizeY nFrames 1]
fwrite(fid,StimData,'int16');

Frame = BackgroundLum*ones(size(Xcoor));
Frame = 255 - round((255 - Frame) / lum_magnification);

if ShowFrames
    figure();
    imshow(255 - Frame', [0 255]);
    title(['Frame #' num2str(FrameCount)])
    maxFrame = max(Frame(:))
    minFrame = min(Frame(:))
    waitforbuttonpress();
end
fwrite(fid,Frame,'uint8'); 
FrameCount = FrameCount + 1;

for iWidth=1:length(DiscWidths)
    for iPosX=1:length(PossibleX)
        for iPosY=1:length(PossibleY)
            for iLum=1:length(PossibleLums)
                FrameNumber(iWidth,iPosX,iPosY,iLum) = FrameCount;

                Frame = BackgroundLum*ones(size(Xcoor));
                Frame = Frame + PossibleLums(iLum)*(sqrt( (Xcoor-PossibleX(iPosX)).^2 + (Ycoor-PossibleY(iPosY)).^2 ) < DiscWidths(iWidth)/2/PixelSizeInMicrons);
                Frame = 255 - round((255 - Frame) / lum_magnification);
                
                if ShowFrames
                    imshow(255 - Frame', [0 255]);
                    title(['Frame #' num2str(FrameCount)])
                    maxFrame = max(Frame(:))
                    minFrame = min(Frame(:))
                    waitforbuttonpress();
                end
                
                Frame = uint8(Frame);
                fwrite(fid,Frame,'uint8');% Ecriture de la frame  


                FrameId(iWidth,iPosX,iPosY,iLum) = iWidth*1000 + iPosX*100 + iPosY*10 + iLum;

                FrameCount = FrameCount + 1;
            end
        end
    end
end

fclose(fid);

TotalFrameNb = FrameCount-1;


tab(1,:) = [0 TotalFrameNb 0 0 0]';

FrameCount = 0;

rng(0);


for irep=1:NbRepeats
    Spots = randperm(length(FrameId(:)));
    for iSpot=1:length(Spots)
        
        FrameToDisplay = FrameNumber(Spots(iSpot));
        IdFrame = FrameId(Spots(iSpot));
                
        tab(FrameCount+1:FrameCount+DurationON,2) = FrameToDisplay;
        tab(FrameCount+1:FrameCount+DurationON,5) = IdFrame;
        

        FrameCount = FrameCount+DurationON;
        
        tab(FrameCount+1:FrameCount+DurationOFF,2) = 0;
        tab(FrameCount+1:FrameCount+DurationOFF,5) = IdFrame;
        
        FrameCount = FrameCount+DurationOFF;
    end
    
end


fid=fopen([ StimFileName '.vec'],'w');
for i=1:size(tab,1)
    fprintf(fid,'%g %g %g %g %g\n',tab(i,:));
end
fclose(fid);
close;

