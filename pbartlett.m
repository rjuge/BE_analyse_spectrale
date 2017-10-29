function [pxb,fb] = pbartlett(X, window, f, fs);

if ~isreal(X) 
   error('Input data is complex')
end

n = size(X,2);
N = size(X,1);
L = length(window);
K = N/L;
pxx = zeros(L/2+1,K,n);

for s = 1:n
for i = 1:K
    [pxx(:,i,s), fb] = periodogram(X(L*(i-1)+1:1:i*L,s), window, f, fs, 'onesided', 'psd');
end
end
pxb = sum(pxx,2)/K;
pxb = squeeze(pxb);
end