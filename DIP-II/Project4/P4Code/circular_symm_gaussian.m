%%%%%%%%%%%%%%% Function Circular Symmetric Gaussian %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Compute circular symmetric gaussian function along x and y
%         directions seperately
% 
% Input Variable:
%         sigma     standard deviation
%         range     range to get filter window size
%
% Processing Flow:
%      1.  Compute the range of x and y.
%      2.  Compute gx,gy using x and y.  
%         
% Output:
%         gx         1-D gaussian function along x direction
%         gy         1-D gaussian function along y direction
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ gx,gy ] = circular_symm_gaussian( sigma,range )
x = -(sigma*range):(sigma*range);%filter range to be covered on either sides
y = -(sigma*range):(sigma*range);
%Compute 1-D gaussian along x and y directions
gx = zeros(size(x));
gy = zeros(size(y));
den = (sqrt(2*pi)*sigma);
for k=1:length(x)
   gx(k) = (exp(-(x(k)^2)/(2*(sigma^2))))/den; 
   gy(k) = (exp(-(y(k)^2)/(2*(sigma^2))))/den; 
end
end

