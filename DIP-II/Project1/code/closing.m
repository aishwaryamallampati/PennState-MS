%%%%%%%%%%%%%  Function closing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Remove salt and pepper noise present in the given image
%
% Input Variables:
%       image       Input image which contains salt and pepper noise
%       str_ele     Structing element used to remove noise

% Returned Results:
%      closing      Image after removing salt and pepper noise
%
% Processing Flow:  
%      1.  Dilate the image with the structuring element to fill gaps
%      2.  Erode the dilated image with the structuring element to remove
%          smaller elements

%  Restrictions/Notes:
%      This function takes an 16-bit image as input.  
%
%  The following functions are called:
%       dilation_erosion.m
%
%  Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%  Date:        01/31/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function closing = closing(image,str_ele)
dilated_image = dilation_erosion(image,str_ele,1);
eroded_image = dilation_erosion(dilated_image,str_ele,2);
closing= eroded_image;
