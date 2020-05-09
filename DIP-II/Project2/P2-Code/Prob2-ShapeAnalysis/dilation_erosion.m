%%%%%%%%%%%%%  Function dilation_erosion %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Perform dilation and erosion without using inbuild functions
%
% Input Variables:
%       image       Input image 
%       str_ele     Structing element used to dilate/erode the given image
%       flag        flag which denotes whether the desired operation is
%                   dilation(1) or erosion(2)
% Returned Results:
%      output      Image after performing dilation/erosion
%
% Processing Flow:  
%      1.  Move the structuring element through the given input image
%          excluding borders.
%      2.  Take logical operation for structuring element
%      3.  For dilation, If any of the neighbour value is 1, the output
%          pixel value is set to 1.
%      4.  For erosion, If any of the neighbour value is 0, the output
%          pixel value is set to 0.   
%
%  Restrictions/Notes:
%      This function takes an 16-bit image as input.  
%
%  The following functions are called:
%       zero.m
%
%  Author:      Wushuang Bai, Mrunmayi Ekbote, Aishwarya Mallampati
%  Date:        01/31/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output = dilation_erosion(image,str_ele,flag) % Take binary image, structuring element and a flag as input
    % The flag should be 1 or 2, where 1 works for dilation and 2 works for
    % erosion
    [m1,n1] = size(image); %Get dimensions of image   
    [m2,n2] = size(str_ele); % Get dimensions of structuring element
    output = zeros(m1,n1); % Create a zero matrix to put the output value later
    
    for i=ceil(m2/2)+1:m1 -floor(m2/2)-1 %Enumerate rows excluding the border
        for j=ceil(n2/2)+1:n1-floor(n2/2) -1 % Enumerate columns excluding the border
  
        % take all the neighbourhoods. 
        neighbour=image(i-floor(m2/2):i+floor(m2/2), j-floor(n2/2):j+floor(n2/2));  
  
        % take logical operation for structuring element
        neighbourLogic=neighbour(logical(str_ele));        
        
        if flag == 1 % works for dilation
            output(i, j)=max(neighbourLogic(:));%If any of the neighbour value is 1, the output pixel value is set to 1
        elseif flag == 2 % works for erosion
            output(i, j)=min(neighbourLogic(:));% If any of the neighbour value is 0, the output pixel value is set to 0
        else
            print('flag error'); % If any flag other than 1 or 2 is given, throw a error
        end
        end  
    end 
end
  