%%%%%%%%%%%%%  Function pixelwisethresholding %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Threshold the input image to convert it into a binary image
%
% Input Variables:
%      image   Input image
%      M, N    rows (M) and columns (N) in image
%      
% Returned Results:
%      thresholdedimage   thresholded image containing only (0,1) as
%                         intensity values
%
% Processing Flow:  
%      1.  Cycle through MxN array 
%      2.  Replace all intensity values less than half of the maximum intensity to zero
%      3.  Replace all intensity values more than half of the maximum intensity to one
%
%  Restrictions/Notes:
%      This function takes an 16-bit image as input.  
%
%  The following functions are called:
%      NONE
%
%  Author:      Mrunmayi Ekbote, Wushuang Bai, Aishwarya Mallampati
%  Date:        01/31/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function thresholdedimage = pixelwisethresholding(image, M, N)
thresholdedimage = zero(M,N);
max_intensity = max(image);

for i=1:M
    for j=1:N
        if image(i,j) < (max_intensity/2)
            thresholdedimage(i,j) = 0;
        else
           thresholdedimage(i,j) = 1; 
        end
    end
end