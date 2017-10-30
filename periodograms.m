config;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

n=1; % number of signals

% Choose one specific signal and set time axis
if n==1448
data_Demo = data_Mat;
else
%index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
index_Data_Demo = 700;
data_Demo = data_Mat(:,index_Data_Demo);
end
data_Length = length(data_Demo);
data_Demo_Time_Axis = time_Sampling*([1:data_Length]-1)';

%FFTR of the raw signals
[abs_FFT,abs_Axis]=FFTR(data_Demo, time_Sampling);

% max freq values

[abs_FFT_Value1, abs_FFT_Index1] = max(abs_FFT);
f_max1 = abs_Axis(abs_FFT_Index1);

if n==1
%plot FFTRs of raw signals
h1 = figure(1);
for i = 1:n
    subplot(3,1,i)
    plot(abs_Axis,20*log10(abs_FFT(:,i)))
    title('FFT')
    hold on
    plot(abs_Axis(abs_FFT_Index1,i),20*log10(abs_FFT_Value1),'or','MarkerSize',10);
    xlabel({['Freq. (Hz) ;'], ['f_{max} = ',num2str(f_max1),' Hz']},'FontSize',8);
    ylabel('dB' ,'FontSize',8);
end
end

%Bartlett DSP estimate
L = 256;
[pxb, fb] = pbartlett(data_Demo, Window_Raised_Frac_Sine(L), [], freq_Sampling);

% max freq values
[abs_FFT_Value2, abs_FFT_Index2] = max(pxb);
f_max2 = fb(abs_FFT_Index2);

if n ==1
for i = 1:n
    subplot(3,1,i+1)
    plot(fb, 10*log10(pxb))
    title('Bartlett')
    hold on
    plot(fb(abs_FFT_Index2,i),10*log10(abs_FFT_Value2),'or','MarkerSize',10);
    xlabel({['Freq. (Hz) ;'], ['f_{max} = ',num2str(f_max2),' Hz']},'FontSize',8);
    ylabel('Power/Frequency' ,'FontSize',8);
end
end

% %Welch DSP estimate
segmentLength = 256;
noverlap = 0.5*segmentLength;
[pxw,fw] = pwelch(data_Demo,Window_Raised_Frac_Sine(segmentLength),noverlap,[],freq_Sampling);

% max freq values
[abs_FFT_Value3, abs_FFT_Index3] = max(pxw);
f_max3 = fw(abs_FFT_Index3);

if n==1
    for i = 1:n
        subplot(3,1,i+2)
        plot(fw, 10*log10(pxw))
        title('Welch')
        hold on
        plot(fw(abs_FFT_Index3,i),10*log10(abs_FFT_Value3),'or','MarkerSize',10);
        xlabel({['Freq. (Hz) ;'], ['f_{max} = ',num2str(f_max3),' Hz']},'FontSize',8);
        ylabel('Power/Frequency' ,'FontSize',8);
    end
end

%plot pour tous les signaux
f_max = [f_max1 f_max2 f_max3];
abs_FFT_Value = [abs_FFT_Value1' abs_FFT_Value2' abs_FFT_Value3'];

figure(5)
title('Max. spectrum amplitude and frequency over time')
for i = 1 : 1
    plot3(1:n,f_max(:,i),abs_FFT_Value(:,i),'.');hold on
    xlabel('Signal index');
    ylabel('Max freq (Hz)');
    zlabel('Max amp (dB)');
    view(-10,10)
    grid on
end