%%%%%%%%%%%%%%% Function erosion %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Implement erosion with certain structuring element to an image
% 
% Input Variable:
%         input_image    the desired image to do the operation
%         structure      the structuring element for the operation
%         
% Output:
%         output         the image after operation
%         
% Process Flow:
%         1. Find the positions that the pixel is black.(black pixel:1, white pixel:0)
%         2. Extract the same size of the mask of the structuring 
%             element from the input image
%         3. If all the pixels on the extracted image has the same value as the 
%             corresponding position on the structuring element, set the origin of the 
%             input image to be black.
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 02/21/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = erosion(input_image,str_ele)
    
    [rows, col] = size(input_image);
    [x, y] = size(str_ele);
    output = zeros(rows, col);
    pos = (str_ele == 1); % find the postion of black pixel
    
    for i = 1+floor(x/2):rows-floor(x/2)
        for j = 1+floor(y/2):col-floor(y/2)
            temp = input_image(i-floor(x/2):i+floor(x/2), j-floor(y/2):j+floor(y/2));
           if (min(temp(pos)) == 0) % if the position of the image pixel is white
               output(i, j) = 0;
           else
               output(i, j) = 1;
           end
        end
    end      
end