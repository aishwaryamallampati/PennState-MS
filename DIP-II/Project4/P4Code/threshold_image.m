%%%%%%%%%%%%% Function threshold image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%       To compute thresholded image 
% 
% Input Variables:
%      threshold    Input Threshold 
%      image        Input image
% 
% Processing Flow:
%      1. Set pixel value to 255 in the output image if pixel value is
%      above threshold else set pixel value to 0 in the output image.
%
% Output:
%      Output       Image obtained after thresholding
%      
% Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date : 04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = threshold_image(image,threshold)
output = zeros(size(image));
[r,c] = size(image);
for i=1:r
        for j=1:c
            if image(i,j) > threshold
            output(i,j) = 255;
            end
        end
end
end

