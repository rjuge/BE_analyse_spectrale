% Change the path wrt the location of files
addpath('/Users/remi_juge/Documents/analyse_spectrale/BE/');
load('Supelec_2012_SIR_Spectral_Analysis_EA_v001');
% Add the path to the toolbox and subdirs
addpath('/Applications/MATLAB_R2017b.app');

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

%frequence barycentrique, moyenne pondérée
amp_square = abs_FFT.^2;
den = sum(amp_square,1);
f_bar = amp_square.'*abs_Axis./den.';

%variance pondérée


h1 = figure(1);clf
title('Frequences barycentriques');
for i = 1:n
    subplot(4,1,i)
    plot(abs_Axis,20*log10(abs_FFT(:,i)))
    hold on
    vline(f_bar(i),'r','f_{bar}')
    xlabel('Freq. (Hz)');ylabel('Amp. (dB)')
    ylabel(['Freq. (Hz) [f_{bar} = ',num2str(f_bar(i)),' Hz]'])
end




