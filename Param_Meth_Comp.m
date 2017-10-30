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
        [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(:,i)', p_arr(j), freq_Sampling);
        legend('2','4','8','16');
        noise_matrix(j,1,i) = sigma1;
        hold on
        subplot(3,1,2);
        [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(:,i), p_arr(j), freq_Sampling);
        legend('2','4','8','16');
        noise_matrix(j,2,i) = sigma2;
        hold on
        subplot(3,1,3);
        [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(:,i), p_arr(j), freq_Sampling);
        legend('2','4','8','16');
        noise_matrix(j,3,i) = sigma3;
    end
end

printmat(noise_matrix(:,:,1), 'Matrice des bruits', '2 4 8 16 32 64 128', 'Lev Burg Marple' )
printmat(noise_matrix(:,:,2), 'Matrice des bruits', '2 4 8 16 32 64 128', 'Lev Burg Marple' )
printmat(noise_matrix(:,:,3), 'Matrice des bruits', '2 4 8 16 32 64 128', 'Lev Burg Marple' )
printmat(noise_matrix(:,:,4), 'Matrice des bruits', '2 4 8 16 32 64 128', 'Lev Burg Marple' )


% Plot 4 signals with the three differents methods with the max frequency
% p = 15;
% for i =1:n
%     figure(i);
%     subplot(3,1,1);
%     [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(:,i)', p, freq_Sampling);
%     len = length(mydsp1);
%     pos_dsp1 = mydsp1(ceil(len/2)+1:len);
%     pos_ff1 = ff1(ceil(len/2)+1:len);
%     [max_dsp1, ind1] = max(pos_dsp1);
%     format = 'f_{max} =  %d';
%     str = sprintf(format,ff1(ceil(len/2) + ind1));
%     vline(ff1(ceil(len/2) + ind1),'r',str)
%     hold on
%     subplot(3,1,2);
%     [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(:,i), p, freq_Sampling);
%     len = length(mydsp2);
%     pos_dsp2 = mydsp2(ceil(len/2)+1:len);
%     pos_ff2 = ff2(ceil(len/2)+1:len);
%     [max_dsp2, ind2] = max(pos_dsp2);
%     str = sprintf(format,ff2(ceil(len/2) + ind2));
%     vline(ff2(ceil(len/2) + ind2),'r',str)
%     hold on
%     subplot(3,1,3);
%     [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(:,i), p, freq_Sampling);
%     len = length(mydsp3);
%     pos_dsp3 = mydsp3(ceil(len/2)+1:len);
%     pos_ff3 = ff3(ceil(len/2)+1:len);
%     [max_dsp3, ind3] = max(pos_dsp3);
%     str = sprintf(format,ff3(ceil(len/2) + ind3));
%     vline(ff3(ceil(len/2) + ind3),'r',str)
% end