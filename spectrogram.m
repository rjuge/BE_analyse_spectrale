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
index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
data_Demo = data_Mat(:,index_Data_Demo);
data_Demo_Stft = data_Demo(1:f_Subsampling:end,:);
data_Length = length(data_Demo_Stft);
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

%Spectrogramme
tfd = zeros(nfreq,data_Length,n);
t = zeros(data_Length,n);
f = zeros(nfreq,n);
abs_TFD = zeros(nfreq/2+1, data_Length,n);
abs_FFT = zeros(data_Length/2+1,n);

f_red = f(nfreq/2-1:end);

%compute STFT and FFT
for i = 1:n
  [tfd(:,:,i), t(:,i), f(:,i)] = stft2(data_Demo_Stft(:,i), freq_Sampling/f_Subsampling, nfreq, decf);
  abs_TFD(:,:,i) = abs(tfd(1:nfreq/2+1,:,i));
  [abs_FFT(:,i),abs_Axis] = FFTR(data_Demo_Stft(:,i),1/(freq_Sampling/f_Subsampling));
end

%plot STFTs
h1 = figure(1);
for i = 1:n
  subplot(4,1,i)
  hold on
  h= imagesc(t(:,i),f_red,(flipud(abs_TFD(:,:,i)))); axis tight
  xlabel('Time');ylabel('Freq. (Hz)')
end

%plot FFTs
h2 = figure(2);
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis,20*log10(abs_FFT(:,i)))
    hold on
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
end
