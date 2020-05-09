%%%%%%%%%%%%%%% Function symmNNM_filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:
%         Apply symmetric nearest neighbor mean filter of given window_size on the input image
% 
% Input Variable:
%         input_image    the desired image to do the operation
%         window_size    the size of the symmetric nearest neighbor mean filter
%         
% Output:
%         output         the image obtained after applying symmetric nearest neighbor mean filter
%         
% Process Flow:
%         1. Exctract a sub array from the image which is equal to size of the mean filter
%         2. Pick a pair of summetrically opposite pixels, store the pixel
%         closest to the middle pixel value and discard the other pixel value
%         3. Compute the average of all the closes pixels and place it in the specified pixel location
%         4. Move the filter window across the image to process all the pixels
%Authors: Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%Date : 03/27/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output = synnNNM_filter(input_image,window_size)
[m,n] = size(input_image);
output = zeros(m,n);
% mid is 3 for window size 5*5
mid = floor(window_size/2) + 1; 
for i= (mid):(m-(mid-1)) %do not include border pixels
    for j = mid:(n-(mid-1))
        %exctract sub array of window size around (i,j) pixel from the input image
        sub_input = input_image(i-(mid-1):i+(mid-1),j-(mid-1):j+(mid-1));
        temp = [];
        for k=1:window_size
            for l = 1:window_size
                %difference is computed and point closest to (i,j) is
                %stored and other point is discarded
                diff1=abs(int16(sub_input(k,l))-int16(sub_input(mid,mid)));
                diff2=abs(int16(sub_input(window_size-k+1,window_size-l+1))-int16(sub_input(mid,mid)));
                if diff1<=diff2
                    temp=[temp sub_input(k,l)]; 
                else
                    temp=[temp sub_input(window_size-k+1,window_size-l+1)]; 
                end 
                %Processing half of the matrix is completed 
                %the process can be stopped
                if(k==mid && l == mid)
                    break
                end
            end
            %Processing half of the matrix is completed 
            %the process can be stopped
            if(k==mid && l == mid)
                    break
            end
        end
        %average is computed and placed at location (i,j) in the output image
        output(i,j) = round(sum(temp,'all')/(length(temp)));
    end
end
output = uint8(output);
end