
config;

% FLAG for: pre-window and pre-filter (1) or not (0)
f_PreWindow = 1;
f_PreFilter = 1;
f_PreFilter_PreWindow = 1;


% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

n=4; % number of signals

% Choose one specific signal and set time axis
index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals

data_Demo = data_Mat(:,index_Data_Demo);
data_Length = length(data_Demo);
data_Demo_Time_Axis = time_Sampling*([1:data_Length]-1)';

%FFTR of the raw signals
[abs_FFT,abs_Axis]=FFTR(data_Demo)
% max freq values
[abs_FFT_Value,abs_FFT_Index] = max(abs_FFT);

%plot raw signals
h1 = figure(1);clf
title(['Signals n°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)),' ',num2str(index_Data_Demo(4)) ]);
n=length(index_Data_Demo)
for i = 1:n
    subplot(4,1,i)
    xlabel('Time');ylabel('Amp.')
    plot(data_Demo_Time_Axis, data_Demo(:,i))
end

%plot FFTRs of raw signals
h2 = figure(2);
h=title(['FFTR signals n°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)), ' ',num2str(index_Data_Demo(4)) ]);
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis,20*log10(abs_FFT(:,i)))
    hold on
    plot(abs_Axis(abs_FFT_Index(i)),20*log10(abs_FFT_Value(i)),'or');
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
    ylabel(['Freq. (Hz) [f_{max} = ',num2str(abs_Axis(abs_FFT_Index(i))),' Hz]'])
end


% Definie apodizing window parameters
time_Burst_Max = 0.6e-3;
taper_Burst_Length = 20;
taper_Fractional_Order = 2;
sample_Burst_Max = max(find(data_Demo_Time_Axis <= time_Burst_Max))-1;

% Define low-cut, high-cut filter parameters (adapted to this signal, maybe not suitable for  other signals)
f_Low = 2*0.8e4;f_High = 20e4/2;
[B_cut,A_cut] = cheby2(2,40,[f_Low f_High]*2/freq_Sampling); %ordre 2, -40dB, 

%Apply window
if f_PreWindow
  % Window the signal and fill with zeros
  data_Demo_Window = zeros(4096,n)
  for i=1:n
  data_Demo_Window(:,i) = data_Demo(:,i).*...
    [Window_Raised_Frac_Sine(sample_Burst_Max,taper_Burst_Length,taper_Fractional_Order);zeros(data_Length-sample_Burst_Max,1)];
  end
%    data_Demo_Window = data_Demo.*...
%     [hamming(sample_Burst_Max);zeros(data_Length-sample_Burst_Max,1)];
else
  data_Demo_Window = data_Demo;
end

%FFTR and max of Windowd FFTRs
[abs_FFT_Window,abs_Axis_Window]=FFTR(data_Demo_Window)
[abs_FFT_Value_Window,abs_FFT_Index_Window] = max(abs_FFT_Window);

h3 = figure(3);
h=title(['FFTR Windowed signals nÂ°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)), ' ',num2str(index_Data_Demo(4)) ]);
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis_Window,20*log10(abs_FFT_Window(:,i)))
    hold on
    plot(abs_Axis_Window(abs_FFT_Index_Window(i)),20*log10(abs_FFT_Value_Window(i)),'or');
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
    ylabel(['Freq. (Hz) [f_{max} = ',num2str(abs_Axis_Window(abs_FFT_Index_Window(i))),' Hz]'])
end

if f_PreFilter
  % Define low-cut, high-cut filter parameters (adapted to this signal, maybe not to other signals)
   data_Demo_Filter = filtfilt(B_cut,A_cut,data_Demo);
else
  data_Demo_Filter = data_Demo;
end


[abs_FFT_Filter,abs_Axis_Filter]=FFTR(data_Demo_Filter)
[abs_FFT_Value_Filter,abs_FFT_Index_Filter] = max(abs_FFT_Filter);

h4 = figure(4);
h=title(['FFTR Filtered signals nÂ°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)), ' ',num2str(index_Data_Demo(4)) ]);
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis_Filter,20*log10(abs_FFT_Filter(:,i)))
    hold on
    plot(abs_Axis_Filter(abs_FFT_Index_Filter(i)),20*log10(abs_FFT_Value_Filter(i)),'or');
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
    ylabel(['Freq. (Hz) [f_{max} = ',num2str(abs_Axis_Filter(abs_FFT_Index_Filter(i))),' Hz]'])
end



if f_PreFilter_PreWindow
  % Window the signal and fill with zeros
  data_Demo_WinFilt = zeros(4096,4)
  for i=1:n
  data_Demo_WinFilt(:,i) = data_Demo(:,i).*...
    [Window_Raised_Frac_Sine(sample_Burst_Max,taper_Burst_Length,taper_Fractional_Order);zeros(data_Length-sample_Burst_Max,1)];
  end
%    data_Demo_Window = data_Demo.*...
%     [hamming(sample_Burst_Max);zeros(data_Length-sample_Burst_Max,1)];
 
  % Define low-cut, high-cut filter parameters (adapted to this signal, maybe not to other signals)
   data_Demo_WinFilt = filtfilt(B_cut,A_cut,data_Demo_Window);
 %  data_Demo_Filt = data_Demo_Window;
else
  data_Demo_WinFilt = data_Demo;
end

[abs_FFT_WinFilt,abs_Axis_WinFilt]=FFTR(data_Demo_WinFilt)
[abs_FFT_Value_WinFilt,abs_FFT_Index_WinFilt] = max(abs_FFT_WinFilt);

h5 = figure(5);
h=title(['FFTR WinFilted signals nÂ°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)), ' ',num2str(index_Data_Demo(4)) ]);
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis_WinFilt,20*log10(abs_FFT_WinFilt(:,i)))
    hold on
    plot(abs_Axis_WinFilt(abs_FFT_Index_WinFilt(i)),20*log10(abs_FFT_Value_WinFilt(i)),'or');
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
    ylabel(['Freq. (Hz) [f_{max} = ',num2str(abs_Axis_WinFilt(abs_FFT_Index_WinFilt(i))),' Hz]'])
end


