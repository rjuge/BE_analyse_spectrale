config;

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

% Choses à faire
% - Avec les mêmes signaux et pour chaque méthode, faire des plots avec
% différentes valeurs de p
% - Avec le même signal et même p (sufisammment grand il faudrait du coup), faire le triple plot (pas de superposé finalement)
% + faire la même chose mais en faisant apparaître la freq max
% - Faire comparaison des bruits pour chaque méthode et avec des p
% différents

p_arr_lev = [2,3,4,6];
p_arr_burg = [2,4,8,16,32,64,128];

% Plot several burg with different p values
for i = 1:length(p_arr)
    [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(:,i)', p_arr(i), freq_Sampling);
end 


p_levinson = 4; % order of the AR algorithm
p_burg = 4;
p_marple = 4;
% Voir méthodes de choix de p (vers page 335)

% Plot 4 signals with the three differents methods
% for i =1:n
%     figure(i);
%     subplot(3,1,1);
%     [aa1, sigma1, ref1, ff1, mydsp1] = mylevinsondurbin(data_Demo_Stft(:,i)', p, freq_Sampling);
%     hold on
%     subplot(3,1,2);
%     [aa2, sigma2, kk2, ff2, mydsp2] = myburg(data_Demo_Stft(:,i), p, freq_Sampling);
%     hold on
%     subplot(3,1,3);
%     [aa3, sigma3, kk3, ff3, mydsp3] = mymarple_matlab(data_Demo_Stft(:,i), p, freq_Sampling);
% end


% Test for the different AR algorithms
%mylevinsondurbin(data_Demo_Stft(:,1)', p, freq_Sampling)
%myburg(data_Demo_Stft(:,1), p, freq_Sampling)
%mymarple_matlab(data_Demo_Stft(:,1), p, freq_Sampling)