config;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

n=1; % number of signals

% Choose one specific signal and set time axis
%index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
index_Data_Demo = 100;
data_Demo = data_Mat(:,index_Data_Demo);
data_Length = length(data_Demo);
data_Demo_Time_Axis = time_Sampling*([1:data_Length]-1)';

%FFTR of the raw signals
[abs_FFT,abs_Axis]=FFTR(data_Demo);

%plot FFTRs of raw signals
h1 = figure(1);
%h=title(['FFTR signals n°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)), ' ',num2str(index_Data_Demo(4)) ]);
for i = 1:n
    subplot(4,1,i)
    title('FFT')
    plot(abs_Axis,20*log10(abs_FFT(:,i)))
    hold on
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
end

%Bartlett DSP estimate
L = 256;
[pxb, fb] = pbartlett(data_Demo, Window_Raised_Frac_Sine(L), [], freq_Sampling);
for i = 1:n
    subplot(4,1,i+1)
    plot(fb/freq_Sampling, 10*log10(pxb))
    hold on
    xlabel('Freq. (Hz)');ylabel('Power/Frequency (dB/rad/sample)')
end

%Welch DSP estimate
segmentLength = 256;
noverlap = 128;
[pxw,fw] = pwelch(data_Demo,Window_Raised_Frac_Sine(segmentLength),noverlap,[],freq_Sampling);
for i = 1:n
    subplot(4,1,i+2)
    plot(fw/freq_Sampling, 10*log10(pxw))
    hold on
    xlabel('Freq. (Hz)');ylabel('Power/Frequency (dB/rad/sample)')
end

