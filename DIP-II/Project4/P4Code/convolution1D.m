%%%%%%%%%%%%%%% Function convolution1D %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%           Perform 1-D convolution between the given input image and
%           filter along x or y direction
% 
% Input Variable:
%         sigma     standard deviation
%         range     range to get filter window size
%         image     Input Image
%         h         1-D filter to perform convolution
%         dir       Specified direction of convolution(x or y)
%
% Processing Flow:
%      1.  Check the type of dir and calculate start and end points for
%      loop. Use the original image for convoultion.
%      2.  Compute product of image pixel and reverse of h array and add it
%      to all iterated pixel.
%      3.  Substitute this value in the center pixel in every iteration.
%         
% Output:
%         output     Image obtained after performing covolution
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = convolution1D(sigma,range,image,h,dir )
ind = sigma*range;
ind1 = ind+1;
[r,c]=size(image);
output=image;
%Perform convolution between image and h along x direction
if strcmp(dir,'row') == 1
    for i=ind1:r-ind
        for j=1:c
                tmp=0;
            for k = -ind:ind
                c1 = image(i+k,j)*h((ind1)-k);
                tmp = tmp+c1;
            end
                output(i,j) = tmp;
        end
    end
end
%Perform convolution between image and h along y direction
if strcmp(dir,'col') == 1
    for i=1:r
        for j=ind1:c-ind
                tmp=0;
            for k = -ind:ind
                c1 = image(i,j+k)*h((ind1)-k);
                tmp = tmp+c1;
            end
                output(i,j) = tmp;
        end
    end
end
end

