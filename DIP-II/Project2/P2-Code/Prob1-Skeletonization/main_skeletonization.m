%%%%%%%%%%%%% main_skeletonization.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Solution to the Problem1- Homotopic Skeletonization of Project-2
%
% Input Variables:
%      option           1 for penn256; 2 for bear
%      Image            Binary input image 
%      B1,B2 ..B8       Structuring Elements
% 
% Returned Results:
%     Gives the output images after every iteration of skeletonization
%
% Processing Flow:
%      1.  Computer hit or miss transform of input image with SE.
%      2.  Subtract it from the previous image to obtain the skeleton
%      3.  Repeat steps 1,2 for all structuring elements and input images
%
%  The following functions are called:
%       erosion.m
% 
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        02/21/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
close all; % Clear out all memory

%Taking option from user to select the input image
option = input('Enter input image(1:penn.256, 2:bear): ');
switch option
    case 1
        in_img = imread('penn256.gif'); %Reading input image 'penn256'
        option = 'penn256';
    case 2 
        in_img = imread('bear.gif'); %Reading input image 'bear'
        option = 'bear';
end
in_img = logical(in_img);
figure();
imshow(in_img)
title('Input Image(8 bits)')

%Structuring elements given to perform homotopic skeletonization
%NaN is used to indicate positions which are not considered
se_b1_fore = [0 0 0;NaN 1 NaN;1 1 1]; 
se_b2_fore = [NaN 0 0;1 1 0;1 1 NaN];
se_b3_fore = [1 NaN 0;1 1 0;1 NaN 0];
se_b4_fore = [1 1 NaN;1 1 0;NaN 0 0];
se_b5_fore = [1 1 1;NaN 1 NaN;0 0 0];
se_b6_fore = [NaN 1 1;0 1 1;0 0 NaN];
se_b7_fore = [0 NaN 1;0 1 1;0 NaN 1];
se_b8_fore = [0 0 NaN;0 1 1;NaN 1 1];
%put the structuring elements in a map to retrive them using keys
key = {1, 2, 3, 4, 5, 6, 7, 8}; 
value = {se_b1_fore, se_b2_fore, se_b3_fore, se_b4_fore, se_b5_fore, se_b6_fore, se_b7_fore, se_b8_fore};
se_map =  containers.Map(key, value);

%Perform homotopic skeletonization on the given input image
i = 0;
X_prev = in_img;
while(1)
    i = i+1;
    X_curr = X_prev;
    %Thin the given input image using 8 structuring elements
    for j=1:8
        se = se_map(j);
        hit = logical(erosion(X_curr, se));
        miss = logical(erosion(~X_curr, (1-se)));
        hit_miss_output = hit & miss;
        X_curr = logical(X_curr - hit_miss_output);  %thinning    
    end
    
    %Display results for X2, X5, X10
    if(i==2 || i==5 || i==10)
        %Display the partial outputs 
        figure();
        imshow(X_curr) 
        %title('X:', num2str(i))
        imwrite(double(X_curr), ['X' num2str(i) '_' option '.png']);
        %superposition of image
        superpos = mod(in_img & ~logical(X_curr), 2);
        figure();
        imshow(superpos);
        %title('superposition X:', num2str(i), ' on original image');
        imwrite(double(superpos), ['superpos' num2str(i) '_' option '.png']);
    end
    
    %Check whether the current and prev images are same or different usingXNOR logic
    temp = ((X_curr & X_prev) | (~X_curr & ~X_prev));
    are_equal = all(all(temp));
    %break the thinning operations if X_curr and X_prev are same
    if(are_equal == 1)
        break;
    else
       X_prev = X_curr; 
    end
end
%Display and save final outputs
figure();
imshow(X_curr) 
%title('X:Final Output')
imwrite(double(X_curr), ['X_final_' option '.png']);
%superposition of image
superpos = mod(in_img & ~logical(X_curr), 2);
figure();
imshow(superpos);
%title('superposition X:Final Output',i,' on original image');
imwrite(double(superpos), ['superpos_final_' option '.png']);