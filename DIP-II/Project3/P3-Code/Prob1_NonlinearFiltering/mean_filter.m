%%%%%%%%%%%%%%% Function mean_filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Apply mean filter of given window_size on the input image
% 
% Input Variable:
%         input_image    the desired image to do the operation
%         window_size    the size of the mean filter
%         
% Output:
%         output         the image obtained after applying mean filter
%         
% Process Flow:
%         1. Exctract a sub array from the image which is equal to size of the mean filter
%         2. Sum all the elements in the sub aray and then divide the sum by square of window size to find the average
%         3. Place the average in the specified pixel location
%         4. Move the mean filter window across the image to find its average
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 03/24/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = mean_filter(input_image,window_size)
[m,n] = size(input_image);
output = zeros(m,n);
% mid is 3 for window size 5*5
mid = floor(window_size/2) + 1; 
for i= (mid):(m-(mid-1)) %do not include border pixels
    for j = mid:(n-(mid-1))
        %find average by moving the window on the image
        output(i,j) = round(sum(input_image(i-(mid-1):i+(mid-1),j-(mid-1):j+(mid-1)),'all')/(window_size * window_size));
    end
end
output = uint8(output);
end