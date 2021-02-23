% original file name: RandomNoisePairedPulseOverSelectedDiams
% generate discs of different diameters in different positions


clear all; close all; clc;

%% parameters

TotalX = 1024;%X and Y of the DMD in pixels
TotalY = 768;

CenterX = TotalX/2;%Center of the stimulus
CenterY = TotalY/2;

PixelSizeInMicrons = 2.5;

LengthXInMicrons = 500;%Size of area covered by the sparse noise
LengthYInMicrons = 500;

FrameRate = 40;%Hz 
DurationON = 0.5;
DurationOFF = 0.5;
DurationBlackSpot = 1.5; %% vedi alla fine secondo quale stimolo decid di fare

BackgroundLum = 230; % 10% of the max

NbRepeats = 20;%How many times the stimulus is repeated

PossibleLums = [0 255]; %If you want several possible luminances

%% parameters: for spots of 100 um diam

Diam100 = 100;

NbPositionsX100 = 4;%Number of different positions for discs in X and Y
NbPositionsY100 = 4;

PossiblePosX100 = round(linspace(CenterX - 0.5*LengthXInMicrons/PixelSizeInMicrons,CenterX + 0.5*LengthXInMicrons/PixelSizeInMicrons,NbPositionsX100));
PossiblePosY100 = round(linspace(CenterY - 0.5*LengthYInMicrons/PixelSizeInMicrons,CenterY + 0.5*LengthYInMicrons/PixelSizeInMicrons,NbPositionsY100));


%% parameters: for spots of 300 um diam

Diam300 = 300;

NbPositionsX300 = 3;%Number of different positions for discs in X and Y
NbPositionsY300 = 3;

PossiblePosX300 = round(linspace(CenterX - 0.5*LengthXInMicrons/PixelSizeInMicrons,CenterX + 0.5*LengthXInMicrons/PixelSizeInMicrons,NbPositionsX300));
PossiblePosY300 = round(linspace(CenterY - 0.5*LengthYInMicrons/PixelSizeInMicrons,CenterY + 0.5*LengthYInMicrons/PixelSizeInMicrons,NbPositionsY300));

%% parameters: for spots of 300 um diam

Diam600 = 600;


NbPositionsX600 = 2;%Number of different positions for discs in X and Y
NbPositionsY600 = 2;

PossiblePosX600 = round(linspace(CenterX - 0.5*LengthXInMicrons/PixelSizeInMicrons,CenterX + 0.5*LengthXInMicrons/PixelSizeInMicrons,NbPositionsX600));
PossiblePosY600 = round(linspace(CenterY - 0.5*LengthYInMicrons/PixelSizeInMicrons,CenterY + 0.5*LengthYInMicrons/PixelSizeInMicrons,NbPositionsY600));

%% 
nbTotalFrames = (NbPositionsX100*NbPositionsY100+NbPositionsX300*NbPositionsY300+NbPositionsX600*NbPositionsY600)*length(PossibleLums)

TotalDuration = (NbPositionsX100*NbPositionsY100+NbPositionsX300*NbPositionsY300+NbPositionsX600*NbPositionsY600) ...
    * (DurationON+DurationBlackSpot+DurationON+DurationOFF)*NbRepeats

frames = zeros(TotalX, TotalY, nbTotalFrames); 
frame_ids = strings(nbTotalFrames, 1);
 
%% generate the frames and save in bin file

Xcoor = (1:TotalX)'*ones(1,TotalY);
Ycoor = ones(TotalX,1)*(1:TotalY);

nBit=8;



fid=fopen(['180704_PairedPulseBg_' int2str(BackgroundLum) '.bin'],'w','ieee-le'); %Ouverture du nouveau fichier BIN
StimData=int16([TotalX TotalY nbTotalFrames nBit]); %[screensizeX screensizeY nFrames 1]
fwrite(fid,StimData,'int16');

% Background frameis the number 0 in the bin
BackGrndFrame = BackgroundLum*ones(TotalX,TotalY);
BackGrndFrame = uint8(BackGrndFrame);
fwrite(fid,BackGrndFrame,'uint8');% Ecriture de la frame  

FrameCount = 1;

%for Diam100 --> idiam=1
for ilum=1:length(PossibleLums)
    for idiam=1
        for iCenterX=1:NbPositionsX100
            for iCenterY=1:NbPositionsY100
                FrameStart(ilum,idiam,iCenterX,iCenterY) = FrameCount;
                Xcenter = PossiblePosX100(iCenterX);
                Ycenter = PossiblePosY100(iCenterY);

                EqRadius2 = (Xcoor - Xcenter).^2 + (Ycoor - Ycenter).^2; 

                Frame = BackgroundLum*ones(size(EqRadius2));
                Frame(find(EqRadius2(:) <= (Diam100/(2*PixelSizeInMicrons))^2 )) = PossibleLums(ilum);
%                 imagesc(Frame);
%                 pause;
                
                FrameId(ilum,idiam,iCenterX,iCenterY) = ilum*1000 +idiam*100+iCenterX*10+iCenterY;
                Frame = uint8(Frame);
                fwrite(fid,Frame,'uint8');% Ecriture de la frame  
                
                frames(:, :, FrameCount) = Frame;
                frame_ids(FrameCount) = string(ilum*1000 +idiam*100+iCenterX*10+iCenterY);

                FrameCount = FrameCount + 1;
            end
%             FrameEnd(ilum,idiam,iCenterX,iCenterY) = FrameCount - 1;
            
        end
    end
end

%for Diam300 --> idiam=2
for ilum=1:length(PossibleLums)
    for idiam=2
        for iCenterX=1:NbPositionsX300
            for iCenterY=1:NbPositionsY300
                FrameStart(ilum,idiam,iCenterX,iCenterY) = FrameCount;
                Xcenter = PossiblePosX300(iCenterX);
                Ycenter = PossiblePosY300(iCenterY);

                EqRadius2 = (Xcoor - Xcenter).^2 + (Ycoor - Ycenter).^2; 

                Frame = BackgroundLum*ones(size(EqRadius2));
                Frame(find(EqRadius2(:) <= (Diam300/(2*PixelSizeInMicrons))^2 )) = PossibleLums(ilum);
%                 imagesc(Frame);
%                 pause;

                FrameId(ilum,idiam,iCenterX,iCenterY) = ilum*1000 +idiam*100+iCenterX*10+iCenterY;
                Frame = uint8(Frame);
                fwrite(fid,Frame,'uint8');% Ecriture de la frame  
                
                frames(:, :, FrameCount) = Frame;
                frame_ids(FrameCount) = string(ilum*1000 +idiam*100+iCenterX*10+iCenterY);

                FrameCount = FrameCount + 1;
            end
%             FrameEnd(ilum,idiam,iCenterX,iCenterY) = FrameCount - 1;
            
        end
    end
end


%for Diam600 --> idiam=3
for ilum=1:length(PossibleLums)
    for idiam=3
        for iCenterX=1:NbPositionsX600
            for iCenterY=1:NbPositionsY600
                FrameStart(ilum,idiam,iCenterX,iCenterY) = FrameCount;
                Xcenter = PossiblePosX600(iCenterX);
                Ycenter = PossiblePosY600(iCenterY);

                EqRadius2 = (Xcoor - Xcenter).^2 + (Ycoor - Ycenter).^2; 

                Frame = BackgroundLum*ones(size(EqRadius2));
                Frame(find(EqRadius2(:) <= (Diam600/(2*PixelSizeInMicrons))^2 )) = PossibleLums(ilum);
%                 imagesc(Frame);
%                 pause;

                FrameId(ilum,idiam,iCenterX,iCenterY) = ilum*1000 +idiam*100+iCenterX*10+iCenterY;
                Frame = uint8(Frame);
                fwrite(fid,Frame,'uint8');% Ecriture de la frame  
                
                frames(:, :, FrameCount) = Frame;
                frame_ids(FrameCount) = string(ilum*1000 +idiam*100+iCenterX*10+iCenterY);

                FrameCount = FrameCount + 1;
            end
%             FrameEnd(ilum,idiam,iCenterX,iCenterY) = FrameCount - 1;
            
        end
    end
end

fclose(fid);

TotalFrameNb = FrameCount-1

%% generate and save the vec file


tab(1,:) = [0 TotalFrameNb 0 0 0]';
FrameCount = 1;

%stimulus = white spot, black spot, background
%StandardSeq = [ones(1,round(DurationON*FrameRate)) ones(1,round(DurationBlackSpot*FrameRate)) zeros(1,round(DurationOFF*FrameRate))]'; % calcola quante volte dvi stampare la riga per avere la stimolazione priettata per il tempo giusto al giusto framrate
StandardSeqWhite = [ones(1,round(DurationON*FrameRate))]';
StandardSeqBlack = [ones(1,round(DurationBlackSpot*FrameRate))]';
StandardSeqBckGrnd = [zeros(1,round(DurationOFF*FrameRate))]';

%controlla che il frame non sia zero e non sia lo spot nero prima di stamparlo
for irep=1:NbRepeats
    Stims = randperm(length(FrameId(:)));

    for istim=1:length(Stims)
        if FrameId(Stims(istim))>0 && FrameId(Stims(istim)) < 2000
            %Stims(istim)
            SeqWhite = FrameStart(Stims(istim))*StandardSeqWhite;
            tab(FrameCount+1:FrameCount+length(SeqWhite),2) = SeqWhite;
            tab(FrameCount+1:FrameCount+length(SeqWhite),5) = FrameId(Stims(istim));
            FrameCount = FrameCount+length(SeqWhite);
            
            %find the corresponding black disc frame
            BlackDiscIndx = find(FrameId(:) == FrameId(Stims(istim))+1000);
            SeqBlack = FrameStart(BlackDiscIndx)*StandardSeqBlack;
            tab(FrameCount+1:FrameCount+length(SeqBlack),2) = SeqBlack;
            tab(FrameCount+1:FrameCount+length(SeqBlack),5) = FrameId(BlackDiscIndx);
            FrameCount = FrameCount+length(SeqBlack);

            tab(FrameCount+1:FrameCount+length(SeqWhite),2) = SeqWhite;
            tab(FrameCount+1:FrameCount+length(SeqWhite),5) = FrameId(Stims(istim));
            FrameCount = FrameCount+length(SeqWhite);
            
            tab(FrameCount+1:FrameCount+length(StandardSeqBckGrnd),2) = StandardSeqBckGrnd;
            tab(FrameCount+1:FrameCount+length(StandardSeqBckGrnd),5) = StandardSeqBckGrnd;
            FrameCount = FrameCount+length(StandardSeqBckGrnd);
            
        end
    end

end

fid=fopen(['180704_PairedPulseBg_' int2str(BackgroundLum) '.vec'],'w');
for i=1:size(tab,1)
    fprintf(fid,'%g %g %g %g %g\n',tab(i,:));
end
fclose(fid);

%save(['PairedPulseBg_' int2str(BackgroundLum) '.mat'],'FrameId','FrameStart',...
%    'PixelSizeInMicrons','LengthXInMicrons','LengthYInMicrons',...
%    'FrameRate','DurationON','DurationOFF','','BackgroundLum','PossibleLums','-mat')


save(['180704_PairedPulseBg_' int2str(BackgroundLum) '.mat'])
save(['Frames_180704_PairedPulseBg_' int2str(BackgroundLum) '.mat'], 'frames', 'frame_ids');