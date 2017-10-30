config ;

% FLAG for: pre-window and pre-filter (1) or not (0)
f_PreWindow = 1;
f_PreFilter = 1;
f_PreFilter_PreWindow = 1;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

% Set the time-frequency parameters
nfreq = 8*64;
decf =1;
f_Subsampling = 1;

n=4; % number of signals

% Choose one specific signal and set time axis
if n==1448
    data_Demo = data_Mat;
else
    index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
    data_Demo = data_Mat(:,index_Data_Demo);
end
data_Demo_Stft = data_Demo(1:f_Subsampling:end,:);
data_Length = length(data_Demo_Stft);
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

%Spectrogramme
tfd = zeros(nfreq,data_Length,n);
abs_TFD = zeros(nfreq/2+1, data_Length,n);
abs_FFT = zeros(data_Length/2+1,n);
abs_TFD_Max = zeros(1,n);
abs_TFD_Idx = zeros(1,n);
frequency_Idx = zeros(1,n);
time_Idx = zeros(1,n);

%compute STFT
for i = 1:n
  [tfd(:,:,i), t, f] = stft2(data_Demo_Stft(:,i), freq_Sampling/f_Subsampling, nfreq, decf);
  abs_TFD(:,:,i) = abs(tfd(1:nfreq/2+1,:,i));
  abs_TFD_tmp = abs_TFD(:,:,i);
  [abs_TFD_Max(i),abs_TFD_Idx(i)] = max(abs_TFD_tmp(:));
  [frequency_Idx(i),time_Idx(i)] = ind2sub(size(abs_TFD_tmp),abs_TFD_Idx(i));
end

f_red = f(nfreq/2-1:end);

if n<5
%plot STFTs
h1 = figure(1);
for i = 1:n
  subplot(4,1,i)
  hold on
  h = imagesc(t,f_red,(flipud(abs_TFD(:,:,i)))); axis tight
  plot(t(time_Idx(i)),f_red((end-frequency_Idx(i))),'or','MarkerSize',20) ;
  xlabel('Time');ylabel('Freq. (Hz)')
end
end

