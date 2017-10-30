config;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

% Set the time-frequency parameters
nfreq = 8*64;
decf =1;
f_Subsampling = 100;

%n=4; % number of signals

% Choose one specific signal and set time axis
%index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
data_Demo = data_Mat;
data_Demo_Stft = data_Demo(:,1:f_Subsampling:end);
data_Length = length(data_Demo_Stft(1,:));
signal_Length = length(data_Demo_Stft(:,1));
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

% For all the signals, plot the freq max and the amp. for this freq max for each method
p = 4;
param_lev = zeros(signal_Length, 4);
param_burg = zeros(signal_Length, 4);
param_marple = zeros(signal_Length, 4);


for i = 1:signal_Length
    [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(i,:)', p, freq_Sampling);
    param_lev(i,:) = aa1;
    
    [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(i,:), p, freq_Sampling);
    param_burg(i,:) = aa2;
   
    [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(i,:), p, freq_Sampling);
    param_marple(i,:) = aa3;
end


data_Sup_Lev = zeros(signal_Length);
data_Sup_Burg = zeros(signal_Length);
data_Sup_Marple = zeros(signal_Length);

for j = 1:signal_Length
    % Voir la formule et essayer de l'appliquer au mieux
    data_Sup_Lev(j) = data_Demo_Stft(j,) .* param_lev(j,:)
end
