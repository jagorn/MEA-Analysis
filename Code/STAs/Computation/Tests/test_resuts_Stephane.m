
%%
load('/home/christophe/Desktop/check_40Hz_40c_20px_1h.data_STA_30TimeBins.mat');


%%

chan_ind = 5;

load(['/home/christophe/Desktop/STA/STA_check_40Hz_20c_40px_1h_C' int2str(chan_ind) '.mat']);

%%

STAn = STAs{chan_ind};
STAn = STAn(:,:,(end-20):end);

[~,max_ind] = max(STAn(:));

[x,y,t] = ind2sub(size(STAn), max_ind);

figure;

imagesc(STAn(:,:,t));

figure;

plot(squeeze(STAn(x,y,:)));

%%

STA = RFs;


[~,max_ind] = max(STA(:));

[x,y,t] = ind2sub(size(STA), max_ind);

figure;

imagesc(STA(:,:,t));

figure;

plot(squeeze(STA(x,y,:)));
