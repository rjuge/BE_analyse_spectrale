load('f_max_raw.mat');
load('f_max_stft.mat');
load('f_bar_abs.mat');
load('f_bar_sq.mat');
load('fmax_pb.mat');
load('fmax_pw.mat');

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

% PCA
X = cat(2,f_max_raw', f_max_stft', fmax_pb, fmax_pw, f_bar_abs', f_bar_sq');
C = corr(X,X);

% Kmeans
K = 3;
opts = statset('Display','final');
X = cat(2,f_max_raw', f_bar_abs');
[idx,C] = kmeans(X,K,'Replicates',10,'Options',opts);

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
xlabel 'freq max (Hz)';
ylabel 'freq bar abs (Hz)';
hold off

% GMM
k = 3;
Sigma = {'diagonal','full'};
nSigma = numel(Sigma);
SharedCovariance = {true,false};
SCtext = {'false', 'true'};
nSC = numel(SharedCovariance);
d = 1000;
x1 = linspace(min(X(:,1)) - 2,max(X(:,1)) + 2,d);
x2 = linspace(min(X(:,2)) - 2,max(X(:,2)) + 2,d);
[x1grid,x2grid] = meshgrid(x1,x2);
X0 = [x1grid(:) x2grid(:)];
threshold = sqrt(chi2inv(0.99,2));
options = statset('MaxIter',1000); % Increase number of EM iterations

figure;
c = 1;
for i = 1:nSigma;
    for j = 1:nSC;
        gmfit = fitgmdist(X,k,'CovarianceType',Sigma{i},...
            'SharedCovariance',SharedCovariance{j},'Options',options);
        clusterX = cluster(gmfit,X);
        mahalDist = mahal(gmfit,X0);
        subplot(2,2,c);
        h1 = gscatter(X(:,1),X(:,2),clusterX);
        hold on;
            for m = 1:k;
                idx = mahalDist(:,m)<=threshold;
                Color = h1(m).Color*0.75 + -0.5*(h1(m).Color - 1);
                h2 = plot(X0(idx,1),X0(idx,2),'.','Color',Color,'MarkerSize',1);
                uistack(h2,'bottom');
            end
        plot(gmfit.mu(:,1),gmfit.mu(:,2),'kx','LineWidth',2,'MarkerSize',10)
        title(sprintf('Sigma is %s, SharedCovariance = %s',...
            Sigma{i},SCtext{j}),'FontSize',8)
        xlabel 'freq max (Hz)';
        ylabel 'freq bar abs (Hz)';
        legend(h1,{'1','2','3','4'});
        hold off
        c = c + 1;
    end
end