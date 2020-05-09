%%%%%%%%%%%%% Function superimpose_image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%       To superimpose thresholded image on original image
% 
% Input Variables:
%      original_image       Original Input Image 
%      thresholded_image    Processed Image
% 
% Processing Flow:
%      1.  Determine the edge of the processed image.
%      2.  Superimpose the edge on the original image.
% 
% Functions called:
%       Edge.m   Function to detect edge by canny edge detection
%
% Output:
%      superimposed_image   Superimposed Output image 
%      
% Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date : 04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function superimposed_image = superimpose_image(original_image, thresholded_image)
superimposed_image=original_image;
BW = edge(thresholded_image,'Canny');
[r,c] = size(original_image); 
for i=1:r
    for j=1:c
        if BW(i,j)==1
            superimposed_image(i,j)=255;
        end
    end
end

end

