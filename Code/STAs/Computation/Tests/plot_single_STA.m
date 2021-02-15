
chan_ind = 1;

STA = treated.STA{chan_ind};


[~,max_ind] = max(STA(:));

[x,y,t] = ind2sub(size(STA), max_ind);

figure;

imagesc(STA(:,:,t));

figure;

plot(squeeze(STA(x,y,:)));