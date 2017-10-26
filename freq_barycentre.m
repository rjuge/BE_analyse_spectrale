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
data_Mat_Time_Axis = time_Sampling*([1:data_Length]-1)';

%FFTR of the raw signals
[abs_FFT,abs_Axis]=FFTR(data_Demo);

%frequence barycentrique, moyenne pond�r�amp_square = abs_FFT.^2;
den = sum(amp_square,1);
f_bar = amp_square.'*abs_Axis./den.';

%%variance pond�r�e de f autour de f
% vecteur proche f_approx

%f_mod le reste de la div euclidienne de fbar par la taille d'un intervalle
f_mod = (f_bar - mod(f_bar,1/4096))

    if f_mod >0.5/4096 % si c'est sup�rieur � la moiti� d'un intervalle arrondi au d        f_approx = f_bar - mod(f_bar,1/4096)+1/4096
    else % sinon arrondi en dessous
        f_approx = f_bar -mod(f_bar,1/4096)
    end

% on r�cup�re le vecteur des indi
f_bar_ind= f_approx/(1/4096)

% on a chaque indice correspondant � la fr�quence barycentrique pour cha% signal, on en d�duit un vecteur de variance � 4 composan
for i = 1:4
   
    var_f(i) = sum((abs_FFT(:,i)-abs_FFT(f_bar_ind(i)).^2))/length(abs_Axis)

end 



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



