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

% max freq values

[abs_FFT_Value,abs_FFT_Index] = max(abs_FFT);
fMaxs1 = abs_Axis(abs_FFT_Index)';

%plot FFTRs of raw signals
h1 = figure(1);
%h=title(['FFTR signals n°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)), ' ',num2str(index_Data_Demo(4)) ]);
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis,20*log10(abs_FFT(:,i)))
    title('FFT')
    hold on
    plot(abs_Axis(abs_FFT_Index,i),20*log10(abs_FFT_Value),'or','MarkerSize',10);
    xlabel({['Freq. (Hz) ;'], ['f_{max} = ',num2str(fMaxs1),' Hz']},'FontSize',7);
    ylabel('Power/Frequency' ,'FontSize',8);
end

%Bartlett DSP estimate
L = 256;
[pxb, fb] = pbartlett(data_Demo, Window_Raised_Frac_Sine(L), [], freq_Sampling);

% max freq values

[abs_FFT_Value2,abs_FFT_Index2] = max(pxb);
fMaxs2 = fb(abs_FFT_Index2)/freq_Sampling;

for i = 1:n
    subplot(4,1,i+1)
    plot(fb/freq_Sampling, 10*log10(pxb))
    title('Bartlett')
    hold on
    plot(fb(abs_FFT_Index2,i)/freq_Sampling,10*log10(abs_FFT_Value2),'or','MarkerSize',10);
    xlabel({['Freq. (Hz) ;'], ['f_{max} = ',num2str(fMaxs2),' Hz']},'FontSize',7);
    ylabel('Power/Frequency' ,'FontSize',8);

    
end
% 
% %Welch DSP estimate
segmentLength = 256;
noverlap = 0.5*segmentLength;
[pxw,fw] = pwelch(data_Demo,Window_Raised_Frac_Sine(segmentLength),noverlap,[],freq_Sampling);

% max freq values
[abs_FFT_Value3,abs_FFT_Index3] = max(pxw);
fMaxs3 = fw(abs_FFT_Index3)/freq_Sampling;

for i = 1:n
    subplot(4,1,i+2)
    plot(fw/freq_Sampling, 10*log10(pxw))
    title('Welch')
    hold on
    plot(fw(abs_FFT_Index3,i)/freq_Sampling,10*log10(abs_FFT_Value3),'or','MarkerSize',10);
    xlabel({['Freq. (Hz) ;'], ['f_{max} = ',num2str(fMaxs3),' Hz']},'FontSize',7);
     ylabel('Power/Frequency' ,'FontSize',8);
%     %exemple pour freqmax
%     plot(abs_Axis_Window,20*log10(abs_FFT_Window(:,i)))
%     hold on
%     plot(abs_Axis_Window(abs_FFT_Index_Window(i)),20*log10(abs_FFT_Value_Window(i)),'or');
%     xlabel('Freq. (Hz)','FontSize',7);ylabel('Amp. (dB)','FontSize',7)
%     ylabel(['Freq. (Hz) [f_{max} = ',num2str(abs_Axis_Window(abs_FFT_Index_Window(i))),' Hz]','FontSize',7])
%     
    
end

