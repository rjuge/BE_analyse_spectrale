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
data_Demo_Stft = data_Demo(1:f_Subsampling:end,:);
data_Length = length(data_Demo_Stft);
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

p=5; % order of the AR algorithm
% Voir méthodes de choix de p (vers page 335)

% Test for the different AR algorithms
%mylevinsondurbin(data_Demo_Stft(:,1), p, freq_Sampling)
myburg(data_Demo_Stft(:,1), p, freq_Sampling)
mymarple_matlab(data_Demo_Stft(:,1), p, freq_Sampling)