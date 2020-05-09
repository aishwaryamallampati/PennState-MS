%%%%%%%%%%%%%%% Function GEF %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Generate Gabor Elementary Functions along x and y direction to
%         perform texture segmentation on the input image
% 
% Input Variable:
%         F         freqency
%         sigma     standard deviation
%         theta     angle of rotation
%         range     range to get filter window size
%
% Functions called:
%       circular_symm_gaussian.m function to calculate circular symmetric gaussian
%
% Processing Flow:
%      1.  Compute the range of x,y,U and V.
%      2.  Compute gx,gy using circular_symm_gaussian function. 
%      3.  Compute GEF using above results.
%      4.  Return GEF in 1-D form (hx and hy).
%         
% Output:
%         hx         Gabor Elementary function along x direction
%         hy         Gabor Elementary function along y direction
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ hx,hy ] = GEF( F,theta,sigma,range )
x = -(sigma*range):(sigma*range);%filter range to be covered on either sides
y = -(sigma*range):(sigma*range);

U = F*cosd(theta);
V = F*sind(theta);
%Compute circular symmetric guassian 
[ gx,gy ] = circular_symm_gaussian( sigma,range );

%Compute 1-D GEF along x and y directions
hx = zeros(size(x));
hy = zeros(size(y));
for k=1:length(x)
   hx(k)= exp(1i*2*pi*U*x(k))*gx(k); 
   hy(k)= exp(1i*2*pi*V*y(k))*gy(k);
end
end

