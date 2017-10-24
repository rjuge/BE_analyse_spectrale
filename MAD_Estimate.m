function [data_Median,data_MAD] = MAD_Estimate(data,flag_Scale)

% MAD: Median and Median absolute deviation; serve as a scale estimate
% 
% [data_Median,data_MAD] = MAD_Estimate(data,flag_Scale)
% Compute the median and the median absolution deviation from 'data'; if
% (optional) flag 'flag_Scale' is set to 1, them normalize by scale factor
% 1.4826 for gaussian inputs (see Example).
%
% Input:       
%               data: input data (1D or 2D array of double)
%               flag_Scale[opt]: flag for Gaussian scale normalisation (0 or 1)
% Output:       
%               data_Median: data Median (array of double)
%               data_MAD: data Median absolute Deviation (MAD) (array of double)
% Example:
%               data_Mean = 3; data_Std = 2.8;% Set mean and standard deviation
%               % Gaussian vector with set mean and standard deviation
%               data = random('Normal',data_Mean,data_Std,30,1); 
%               data(3:3)= 100;
%               [data_Median,data_MAD] = MAD_Estimate(data,1);
%               data_Std_Estim = std(data,1);
%               disp(['Input Std: ',num2str(data_Std),'; Estim Std: ',num2str(data_Std_Estim),'; MAD estimate: ',num2str(data_MAD),'; Relative error: ',num2str((data_MAD-data_Std)/data_Std)]);
% Uses:    
% Used in:      
% Comments:     
% Notes:
%               Should add support for other (than gaussian) random sample distributions
% Created:      2005/08/24
% Modified:     2009/03/21   
%               Help update
%
%   Author: Laurent C. Duval, laurent.duval@ifp.fr
%   Institution: IFP, Technology Department
%   (c) All right reserved

if (nargin == 2) & (flag_Scale == 1)
    scale_Factor = 1.4826;
else 
    scale_Factor = 1;
end
data_Median = zeros([size(data,2),1]);
data_Median = median(data);
data_MAD = scale_Factor*median(abs(data - repmat(data_Median,size(data,1),1)));
