config;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

% Set the time-frequency parameters
nfreq = 8*64;
decf =1;
f_Subsampling = 15;

%n=4; % number of signals

% 1448 signaux différents

% Choose one specific signal and set time axis
%index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
data_Demo = data_Mat;
data_Demo_Stft = data_Demo(:,1:f_Subsampling:end);
data_Length = length(data_Demo_Stft(1,:));
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

% For all the signals, plot the freq max and the amp. for this freq max for each method
p = 6;
f_max1 = zeros(data_Length);
amp1 = zeros(data_Length);
f_max2 = zeros(data_Length);
amp2 = zeros(data_Length);
f_max3 = zeros(data_Length);
amp3 = zeros(data_Length);

for i = 1:data_Length
    [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(:,i)', p, freq_Sampling);
    len = length(mydsp1);
    pos_dsp1 = mydsp1(ceil(len/2)+1:len);
    pos_ff1 = ff1(ceil(len/2)+1:len);
    [max_dsp1, ind1] = max(pos_dsp1);
    f_max1(i) = ff1(ceil(len/2) + ind1);
    amp1(i) = mydsp1(ceil(len/2) + ind1);
    
    [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(:,i), p, freq_Sampling);
    len = length(mydsp2);
    pos_dsp2 = mydsp2(ceil(len/2)+1:len);
    pos_ff2 = ff2(ceil(len/2)+1:len);
    [max_dsp2, ind2] = max(pos_dsp2);
    f_max2(i) = ff2(ceil(len/2) + ind2);
    amp2(i) = mydsp2(ceil(len/2) + ind2);
   
    [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(:,i), p, freq_Sampling);
    len = length(mydsp3);
    pos_dsp3 = mydsp3(ceil(len/2)+1:len);
    pos_ff3 = ff3(ceil(len/2)+1:len);
    [max_dsp3, ind3] = max(pos_dsp3);
    f_max3(i) = ff3(ceil(len/2) + ind3);
    amp3(i) = mydsp3(ceil(len/2) + ind3);
end

figure(1);
title('Méthode de Levinson Durbin');
subplot(2,1,1);
plot(f_max1);
xlabel('Signal');ylabel('Freq. max');
subplot(2,1,2);
plot(amp1);
xlabel('Signal');ylabel('Amp. en freq max');

figure(2);
title('Méthode de Burg');
subplot(2,1,1);
plot(f_max2);
xlabel('Signal');ylabel('Freq. max');
subplot(2,1,2);
plot(amp2);
xlabel('Signal');ylabel('Amp. en freq max');

figure(3);
title('Méthode de Marple');
subplot(2,1,1);
plot(f_max3);
xlabel('Signal');ylabel('Freq. max');
subplot(2,1,2);
plot(amp3);
xlabel('Signal');ylabel('Amp. en freq max');

figure(4);
title('Méthode de Levinson Durbin');
scatter(f_max1(:,1), amp1(:,1));
xlabel('Freq. max (Hz)');ylabel('Amp. en freq max');
figure(5);
title('Méthode de Burg');
scatter(f_max2(:,1), amp2(:,1));
xlabel('Freq. max (Hz)');ylabel('Amp. en freq max');
figure(6);
title('Méthode de Marple');
scatter(f_max1(:,1), amp1(:,1));
xlabel('Freq. max (Hz)');ylabel('Amp. en freq max');

% Plot the continuous noise (f=0)
% p = 4;
% amp_nul1 = zeros(data_Length);
% amp_nul2 = zeros(data_Length);
% amp_nul3 = zeros(data_Length);
% 
% for i = 1:data_Length
%     [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(:,i)', p, freq_Sampling);
%     len = length(mydsp1);
%     amp_nul1(i) = mydsp1(ceil(len/2));
%     
%     [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(:,i), p, freq_Sampling);
%     len = length(mydsp2);
%     amp_nul2(i) = mydsp2(ceil(len/2));
%    
%     [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(:,i), p, freq_Sampling);
%     len = length(mydsp3);
%     amp_nul3(i) = mydsp3(ceil(len/2));
% end
% 
% figure(1);
% subplot(3,1,1);
% xlabel('Signal');ylabel('Continuous noise with Levinson Durbin');
% plot(amp_null1);
% subplot(3,1,2);
% xlabel('Signal');ylabel('Continuous noise with Burg');
% plot(amp_null2);
% subplot(3,1,3);
% xlabel('Signal');ylabel('Continuous noise with Marple');
% plot(amp_null3);