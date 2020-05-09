%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Solution to the Problem Texture Segmentation of Project-4
%
% Four options for input image are provided to the user. 
% User has to choose one among them to perform texture segmentation.
%
% Input Variables:
%      Image            Binary or Gray Scale image
%      F                Frequency
%      sigma            Sigma value used by Gabor Filter
%      theta            Angle of rotation
%      range            filter window scaling size
%      scaling          Scale the images for display purposes
%      threshold        Threshold value used to segment textures
%
% Processing Flow:
%      1.  Apply Gabor filter to the input image
%      2.  Apply gaussian smoothing to the gabor filtered image if required
%      3.  Perform thresholding on the smoothened image
%      4.  Superimpose thresholded image on the original image
%
%  The following functions are called:
%       GEF.m
%       circular_symm_gaussian.m
%       convolution1D.m
%       adjust_image.m
%       threshold_image.m
%       superimpose_image.m
%   
%   Output:
%       Displays results obtained after performing Texture Segmentation
% 
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        04/10/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear all;
close all;

%Taking option from user to select the input image
fprintf('The following tests are available:\n')
fprintf('1."texture2.gif": F=0.059 cycles/pixel, theta=135deg, sigma=8, sigma_smooth=24, threshold=12\n');
fprintf('2."texture1.gif": F=0.042 cycles/pixel, theta=0deg, sigma=24, sigma_smooth=24, threshold=12\n');
fprintf('3."d9d77.gif": F=0.062 cycles/pixel, theta=63deg, sigma=38, threshold=0.021\n');
fprintf('4."d4d29.gif": F=0.06038 cycles/pixel, theta=-50.5deg, sigma=8, sigma_smooth=2, threshold=0.12\n');
option = input('Choose one of the above options(1/2/3/4):');
switch(option)
    case 1
        input_image = imread('texture2.gif');
        option_num = 1;
        option = 'texture2';
        F = 0.059; 
        theta = 135;
        sigma = 8;
        range = 2;
        sigma_smooth =24;
        scaling = 10;
        threshold=12;
    case 2
        input_image = imread('texture1.gif');
        option_num = 2;
        option = 'texture1';
        F = 0.042; 
        theta = 0;
        sigma = 24;
        range = 2;
        sigma_smooth =24;
        scaling = 10;
        threshold=12;
    case 3
        input_image = imread('d9d77.gif');
        option_num = 3;
        option = 'd9d77';
        F = 0.062; 
        theta = 63;
        sigma = 38;
        range = 2;
        sigma_smooth =38;
        scaling = 2000;
        threshold=0.021;
    case 4
        input_image = imread('d4d29.gif');
        option_num = 4;
        option = 'd4d29';
        F = 0.06038; 
        theta = -50.5;
        sigma = 8;
        range = 2;
        sigma_smooth = 2;
        scaling = 1000;
        threshold=0.12;
end
[r,c]=size(input_image); %size of the original image

% Perform input image preprocessing based on whether it is binary or gray
% scale
switch(option_num)
    case {1,2}
        %Converting original image to gray-scale
        I=zeros(size(input_image));
        for x=1:r
            for y=1:c
                if input_image(x,y)==1
                    I(x,y) = 255;
                end
            end
        end
        %Displaying and saving original gray scale image
        figure();
        imshow(I)
        title(strcat('I(x,y) Origianl Image:',option))
        imwrite(I,['OriginalImage_' option '.png'])
    case {3,4}
        I = input_image;
        I(:,513)=[];
        %Displaying and saving original gray scale image
        figure();
        imshow(I)
        title(strcat('I(x,y) Origianl Image:',option))
        imwrite(I,['OriginalImage_' option '.png'])
        % Threshold original image to get more clear textures
        I=I>150;
        I=double(I);
        figure();
        imshow(I)
        title(strcat('I(x,y) Origianl Image Thresholded:',option))
        imwrite(I,['OriginalImageThresholded_' option '.png'])
end

% Apply Gabor filter on the input image
[hx,hy] = GEF(F,theta,sigma,range );
i1 = convolution1D(sigma,range,I,hx,'row'); % convolution in x
i2 = convolution1D(sigma,range,i1,hy,'col');% convolution in y
gabor_output = abs(i2);
% Displaying and saving gabor filter output as 2-D gray scale image 
filterDisplay = uint8(gabor_output*scaling); %Rescaling for the sake of display
[rows col] = size(filterDisplay);
h=figure; imshow(filterDisplay(sigma*range+1:rows-sigma*range,sigma*range+1:col-sigma*range));
title(strcat('m(x,y) Gabor Output:',option))
filename = ['GaborOutput2D_' option '.png'];
saveas(h,filename);
% Displaying and saving gabor filter output as 3-D plot 
[rows col] = size(gabor_output);
h=figure; 
mesh(gabor_output(sigma*range+1:rows-sigma*range,sigma*range+1:col-sigma*range)*255); 
colormap(jet); 
title(strcat('m(x,y) Gabor Output:',option))
filename = ['GaborOutput3D_' option '.png'];
saveas(h,filename);

% Perform smoothing based on the type of input image chosen
switch(option_num)
    case {1,2,4}
        % Apply smoothing filter to the gabor filter output
        [gx,gy] = circular_symm_gaussian(sigma_smooth,range);
        m1 = convolution1D(sigma_smooth,range,gabor_output,gx,'row'); % convolution in x
        m2 = convolution1D(sigma_smooth,range,m1,gy,'col');% convolution in y
        smooth_output = adjust_image(m2,sigma_smooth,range);
        % Displaying and saving smooth filter output as 2-D gray scale image 
        filterDisplay = uint8(smooth_output*scaling); %Rescaling for the sake of display
        [rows col] = size(filterDisplay);
        h=figure; imshow(filterDisplay(sigma_smooth*range+1:rows-sigma_smooth*range,sigma_smooth*range+1:col-sigma_smooth*range));
        title(strcat('m''(x,y) Smooth Output:',option))
        filename = ['SmoothOutput2D_' option '.png'];
        saveas(h,filename);
        % Displaying and saving smooth filter output as 3-D plot 
        [rows col] = size(smooth_output);
        h=figure; 
        mesh(smooth_output(sigma_smooth*range+1:rows-sigma_smooth*range,sigma_smooth*range+1:col-sigma_smooth*range)*255); 
        colormap(jet); 
        title(strcat('m''(x,y) Smooth Output:',option))
        filename = ['SmoothOutput3D_' option '.png'];
        saveas(h,filename);       
    case {3}
        % No need of smoothing for d9d77.gif
        smooth_output = gabor_output;
end

% Segment image to seperate textures using thresholding
threshold_output = threshold_image(smooth_output,threshold);
[rows col] =size(threshold_output);
h=figure;imshow(threshold_output(sigma*range+1:rows-sigma*range,sigma*range+1:col-sigma*range));
title(strcat('Threshold Output:',option))
filename = ['ThresholdOutput_' option '.png'];
saveas(h,filename);

% Superimpose segmented image onto original image
superimpose_output = superimpose_image(I,threshold_output);
ind = sigma_smooth*range;
ind1 = ind+1;
I=superimpose_output(ind1:r-ind,ind1:c-ind);
% Displaying and saving superimposed output image
figure();
imshow(I)
title(strcat('Superimposed Output:',option))
imwrite(I,['SuperimposedOutput_' option '.png'])