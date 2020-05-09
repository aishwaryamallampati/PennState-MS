%%%%%%%%%%%%%%% Function alphatrim_filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Apply alpha trimmed mean filter of given window_size and alpha value on the input image
% 
% Input Variable:
%         input_image    the desired image to do the operation
%         window_size    the size of the alpha trimmed mean filter
%         alpha          the alpha value given in the problem
%         
% Output:
%         output         the image obtained after applying alpha trimmed mean filter
%         
% Process Flow:
%         1. Exctract a sub array from the image which is equal to size of the mean filter
%         2. Conver the sub array into an array with single row
%         3. Sort the values in the sub array in increasing order
%         4. Compute lower and upper bounds using alpha and window_size
%         5. Computer average only using the elements within the upper and lower bounds
%         6. Place the computed average in the specified location in the output image
%         7. Move the filter window across the image to process all the pixels
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 03/27/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = alphatrim_filter(input_image,window_size,alpha)
[m,n] = size(input_image);
output = zeros(m,n);
% mid is 3 for window size 5*5
mid = floor(window_size/2) + 1; 
Nc = window_size * window_size;
%Compute bounds to extract only needed values
lower_bound = floor(alpha*Nc) + 1;
upper_bound = Nc + 1 - lower_bound;
for i= (mid):(m-(mid-1)) %do not include border pixels
    for j = mid:(n-(mid-1))
        %exctract sub array of window size around (i,j) pixel from the input image
        sub_input = input_image(i-(mid-1):i+(mid-1),j-(mid-1):j+(mid-1));
        %convert matrix of size 5*5 to a matrix of single row
        sub_input = reshape(sub_input,1,Nc);
        %sort the elements in increasing order
        sorted_input = sort(sub_input); 
        %Extract only the elements in the specified bounds
        temp = sorted_input(:,lower_bound:upper_bound);
        %average is computed and placed at location (i,j) in the output image
        output(i,j) = round(sum(temp,'all')/(length(temp)));
    end
end
output = uint8(output);
end