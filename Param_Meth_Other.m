config;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

% Set the time-frequency parameters
nfreq = 8*64;
decf =1;
f_Subsampling = 1;

n=4; % number of signals

% Choose one specific signal and set time axis
index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
data_Demo = data_Mat(:,index_Data_Demo);
data_Demo_Stft = data_Demo(:,1:f_Subsampling:end);
data_Length = length(data_Demo_Stft(1,:));
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

% we plot n signals with different p values and with each AR method

p_arr = [2,4,8,16];
% p_arr = [2,4,8,16,32,64,128];
noise_matrix = zeros(length(p_arr), 3,n);
for j = 1:length(p_arr)
    for i =1:n
        figure(i);
        subplot(3,1,1);
        [ff1, mydsp1] = mypisarenko(data_Demo_Stft(:,i)', p_arr(j), freq_Sampling, 0);
        legend('2','4','8','16');
        hold on
%         subplot(3,1,2);
%         [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(:,i), p_arr(j), freq_Sampling);
%         legend('2','4','8','16');
%         noise_matrix(j,2,i) = sigma2;
%         hold on
%         subplot(3,1,3);
%         [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(:,i), p_arr(j), freq_Sampling);
%         legend('2','4','8','16');
%         noise_matrix(j,3,i) = sigma3;
    end
end