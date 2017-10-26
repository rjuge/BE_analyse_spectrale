
% Change the path wrt the location of files
config;

% Test with only zero-level noise
lst_Noise_Level = [0, 5e-4];
% Test with different additional zero-level noise
%lst_Noise_Level = [0,1,2,4,8, 16, 32]*5e-4;

% Set basic signal parameters
time_Sampling = 0.0000010000;
freq_Sampling = 1/time_Sampling;
% Choose one specific signal and set time axis
index_Data_Demo = 150;
data_Demo = data_Mat(:,index_Data_Demo);
data_Length = length(data_Demo);
data_Demo_Time_Axis = time_Sampling*([1:data_Length]-1)';

% Define low-cut, high-cut filter parameters (adapted to this signal, maybe not suitable for  other signals)
f_Low = 0.8e4;f_High = 20e4;
[B_cut,A_cut] = cheby2(2,40,[f_Low f_High]*2/freq_Sampling);

% Definie apodizing window parameters
time_Burst_Max = 0.6e-3;
taper_Burst_Length = 20;
taper_Fractional_Order = 2;
sample_Burst_Max = max(find(data_Demo_Time_Axis <= time_Burst_Max))-1;


  for i_Noise_Level  = 1:length(lst_Noise_Level)
    data_Demo_N = data_Demo + lst_Noise_Level(i_Noise_Level)*randn(size(data_Demo));
    
    % Window the signal and add zeros
    data_Demo_Window = data_Demo_N.*...
      [Window_Raised_Frac_Sine(sample_Burst_Max,taper_Burst_Length,taper_Fractional_Order);zeros(data_Length-sample_Burst_Max,1)];
    
    % Define low-cut, high-cut filter parameters (depends on the signal)
    data_Demo_Filt = filtfilt(B_cut,A_cut,data_Demo_Window);
    
    % Concatenate signals:
    % noisy, windowed and filtered
    data_Demo_Matrix = [data_Demo_N,data_Demo_Window,data_Demo_Filt];
    
    % Estimate noise
    data_Noise = data_Demo_N-data_Demo_Filt;
    [data_Noise_Median,data_Noise_MAD] = MAD_Estimate(data_Noise - mean(data_Noise),1);
    
    % Compute FFTR
    [data_Demo_FFT,data_Demo_FFT_Axis] = FFTR(data_Demo_Matrix,time_Sampling);
    
    % Compute three max location (in frequency) add max amplitude
    [data_Demo_FFT_Max,data_Demo_FFT_Idx] = max(data_Demo_FFT);
    
    % 5 features defined from one signal:
    % - freq max from FFT of raw signal
    % - freq max from FFT of windowed signal
    % - freq max from FFT of filtered signal
    % - freq bar from abs FFT of raw signal
    % - freq bar from squared FFT of raw signal
    data_fmax_values = data_Demo_FFT_Axis(data_Demo_FFT_Idx);
    data_Demo_Filt_bar1 = sum(data_Demo_FFT_Axis.*(abs(data_Demo_FFT(:,1))).^1)/sum((abs(data_Demo_FFT(:,1))).^1);
    data_Demo_Filt_bar2 = sum(data_Demo_FFT_Axis.*(abs(data_Demo_FFT(:,1))).^2)/sum((abs(data_Demo_FFT(:,1))).^2);
    
    % Here we have 5 "amplitude" related to the 5 locations defined from one signal
    data_fmax_amp = data_Demo_FFT_Max';
    data_Demo_Filt_bar1_value = (mean((abs(data_Demo_FFT(:,3))).^1));
    data_Demo_Filt_bar2_value = sqrt(mean((abs(data_Demo_FFT(:,3))).^2));
    
    % Plot results
    figure(i_Noise_Level);clf
    subplot(2,1,1);hold on
    plot(data_Demo_Time_Axis,data_Demo_Matrix);axis tight;grid
    hline1 = refline([0 data_Noise_MAD]);
    hline1.Color = 'g';
    hline2 = refline([0 -data_Noise_MAD]);
    hline2.Color = 'g';
    ylabel('Amplitude (au)');
    xlabel('Time (s)');
    legend('Signal','Signal windowed','Signal filtered')
    subplot(2,1,2);hold on
    plot(data_Demo_FFT_Axis,data_Demo_FFT);axis tight;grid
    ylabel('Amplitude (au)');
    xlabel('Frequency (Hz)');
    % Plot the location of the five spectrum locations
    h = plot(data_fmax_values,data_fmax_amp,'+','MarkerSize',12);
    legend('Signal','Signal windowed','Signal filtered','freq max')
    vline(data_Demo_Filt_bar1,'r','f_{bar1}')
    vline(data_Demo_Filt_bar2,'r','f_{bar2}')
  end
  
