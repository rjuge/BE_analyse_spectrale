config ;

% FLAG for: pre-window and pre-filter (1) or not (0)
f_PreWindow = 1;
f_PreFilter = 1;
f_PreFilter_PreWindow = 1;


% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

n=4 % number of signals

% Choose one specific signal and set time axis
index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals

data_Demo = data_Mat(:,index_Data_Demo);
data_Length = length(data_Demo);
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

%FFTR of the raw signals
[abs_FFT,abs_Axis]=FFTR(data_Demo);

%Spectrogramme
tfd = zeros(n,2049,4096);
t = zeros(n,4096);
f = zeros(n,2049);
for i = 1:n
[tfd(i,:,:), t(i,:), f(i,:)] = stft2(data_Demo(:,i), freq_Sampling,length(abs_Axis));
end
for i = 1:n
   subplot(4,1,i) 
contourf(t(i,:),f(i,:), abs(squeeze(tfd(i,:,:))));
end
