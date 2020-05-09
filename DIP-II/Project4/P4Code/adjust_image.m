%%%%%%%%%%%%% Function adjust image %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%       To compute adjusted image 
% 
% Input Variables:
%      sigma     Standard Deviation
%      range     range to get filter window size
%      image     input image
%
% Processing Flow:
%      1.  Compute zero padded image.
%
% Output:
%      Output    Output image obtained after adjusting perimeter  
%
% Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date : 04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Output = adjust_image(image,sigma,range)
[r,c] = size(image);
ind = sigma*range;
ind1 = ind+1;
Output=zeros(size(image));
for i=ind1:r-ind
        for j=ind1:c-ind
            Output(i,j) = image(i,j);
        end
end
end

