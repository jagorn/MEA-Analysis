load(strcat(stimPath, "/Euler/euler_170614.vec"))
euler_rate = 100;  % Hz
new_rate = 30;

euler_dt = 1/euler_rate;  % s
new_dt = 1/new_rate;  % s

euler_vec = euler_170614(2:end, 2);
euler_length = length(euler_vec)/ 10;
euler_stim = euler_vec(1:euler_length);

euler_duration = (euler_length-1) * euler_dt;

time_vec = 0:euler_dt:euler_duration; 
new_time_vec = 0:new_dt:euler_duration;

euler_stim_30hz_v1 = interp1(time_vec, euler_stim, new_time_vec);
save("euler_stim_30hz_v1.mat", "euler_stim_30hz_v1")

close all
figure()
plot(time_vec, euler_stim);
hold on
plot(new_time_vec, euler_stim_30hz_v1, ".-");

