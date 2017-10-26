load('f_max_raw.mat');
load('f_max_stft.mat');
load('f_bar_abs.mat');
load('f_bar_sq.mat');

figure;
scatter(f_max_raw,f_bar_abs);
xlabel 'freq max (Hz)';
ylabel 'freq bar abs (Hz)';

figure;
scatter(f_max_raw,f_bar_sq);
xlabel 'freq max (Hz)';
ylabel 'freq bar square (Hz)';

figure;
scatter(f_max_raw,f_max_stft);
xlabel 'freq max fft (Hz)';
ylabel 'freq max stft (Hz)';

K = 3;
X = cat(2,f_max_raw',f_bar_abs');

opts = statset('Display','final');
[idx,C] = kmeans(X,K,'Replicates',5,'Options',opts);

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
hold on
plot(X(idx==3,1),X(idx==3,2),'g.','MarkerSize',12)
hold on
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2', 'Cluster 3','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off