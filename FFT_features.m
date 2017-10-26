% Compute FFT and 
% extract f_max (to use as a feature)

config;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;

n=1448; % number of signals

if n==1448
data_Demo = data_Mat;
else
% Choose one specific signal and set time axis
index_Data_Demo = randi(1448,[1,n]); %choose randomly n signals
data_Demo = data_Mat(:,index_Data_Demo);
end

data_Length = length(data_Demo);
data_Demo_Time_Axis = time_Sampling*([1:data_Length]-1)';

%FFTR of the raw signals
[abs_FFT,abs_Axis]=FFTR(data_Demo, time_Sampling);
% max freq values
[abs_FFT_Value,abs_FFT_Index] = max(abs_FFT);

fMaxs = abs_Axis(abs_FFT_Index)';

if n<5
%plot raw signals
h1 = figure(1);clf
title(['Signals n°',num2str(index_Data_Demo(1)),' ',num2str(index_Data_Demo(2)),' ', num2str(index_Data_Demo(3)),' ',num2str(index_Data_Demo(4)) ]);
n=length(index_Data_Demo);
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
end

figure(3)
title('Max. spectrum amplitude and frequency over time')
subplot(2,1,1)
stairs(fMaxs)
xlabel('Sig. index');
ylabel('Max. amp. (dB)');
subplot(2,1,2)
stairs(abs_FFT_Value)
ylabel('Max. freq. (Hz)');
xlabel('Signal index');

figure(4);clf
title('Max. spectrum amplitude vs frequency')
plot(fMaxs,abs_FFT_Value,'.')
xlabel('Max. freq. (Hz)');
ylabel('Max. amp. (dB)');
grid on

figure(5)
title('Max. spectrum amplitude and frequency over time')
plot3(1:n,fMaxs,abs_FFT_Value,'.')
xlabel('Signal index');
ylabel('Max freq (Hz)');
zlabel('Max amp (dB)');
view(-74,42)
grid on