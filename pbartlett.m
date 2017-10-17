function [pxb,fb] = pbartlett(x, window, f, fs);

if ~isreal(data) 
   error('Input data is complex')
end

N = length(x);
L = length(window);
K = N/L;
pxx = zeros(L/2+1,K);

for i = 1:K
    [pxx(:,i), fb] = periodogram(x(L*(i-1)+1:1:i*L), window, f, fs, 'onesided', 'psd');
end
pxb = sum(pxx,2)/K;
end