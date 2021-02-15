function save_data(treated,IS,savename)
%SAVE_DATA %////Comment

c=clock;
savefile=[savename '-Day-' int2str(c(1)) '-' int2str(c(2)) '-' int2str(c(3)) '-Hour-' int2str(c(4)) '-' int2str(c(5)) '-' int2str(c(6)) '.mat'];
savefile=['C:\Users\Chris\Desktop\Sauvegarde\cours\LPS - IV\code\Online STA - 2014 02 11 - Christophe Gardella\Data Folder\' savefile];

save(savefile,'treated','IS')
    %///fclose

end

