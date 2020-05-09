%%%%%%%%%%%%%%% Function sigma_filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Apply sigma filter of given window_size on the input image
% 
% Input Variable:
%         input_image    the desired image to do the operation
%         window_size    the size of the sigma filter
%         sigma          sigma value given in the question
%         
% Output:
%         output         the image obtained after applying sigma filter
%         
% Process Flow:
%         1. Extract a sub array from the image which is equal to size of the sigma filter
%         2. Compute absolute difference of all the values in the sub array with the middle element 
%         3. Take a pixel value into account,
%               if the absolute difference is less than or equal to twice the sigma value(1)
%               else neglect that pixel value(0)
%         4. Add all the pixel values that satisfy the above if condition and then compute their average
%         5. Place the average value as the pixel value of the middle element in the output image
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 03/26/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = sigma_filter(input_image,window_size,sigma)
[m,n] = size(input_image);
output = zeros(m,n);
% mid is 3 for window size 5*5
mid = floor(window_size/2) + 1; 
for i= (mid):(m-(mid-1)) %do not include border pixels
    for j = mid:(n-(mid-1))
        %find average by moving the window on the image
        Nc = 0;
        temp = zeros(m,n);
        for k=i-(mid-1):i+(mid-1)
            for l = j-(mid-1):j+(mid-1)
                %only consider pixel values whose diff with curr pixel is
                %less than twice of sigma
                if(abs(input_image(k,l) - input_image(i,j)) <= (2*sigma))
                    temp(k,l) = input_image(k,l);
                    Nc = Nc + 1;
                end
            end
        end
        output(i,j) = round(sum(temp,'all')/(Nc));
    end
end

output = uint8(output);
end