%%%%%%%%%%%%% main_nonlinearfiltering.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Solution to the Problem1- Nonlinear Filtering of Project-3
%
% Input Variables:
%      Image            Gray Scale input image(Random Disks)
%      window_size      Window size of each filter used(5*5)
%      sigma            Sigma value used by sigma filter(sigma = 20)
%      alpha            Alpha value used by alpha trim mean filter(alpha =0.25)
%
% Processing Flow:
%      1.  Extract large disk interior from the image. Store the boundary values.
%      2.  Apply mean, median, alpha trim mean, sigma and symmetric NNM
%          filter on the input image for five times iteratively
%      3.  Compute histogram for each filter result
%      4.  In each filter result, extract large disk interior and compute
%          mean and standard deviation of the interior of large disk
%
%  The following functions are called:
%       mean_filter.m
%       alphatrim_filter.m
%       sigma_filter.m
%       symmNNM_filter.m
%
%  The following are the inbuilt matlab functions used:
%       medianfilt2(A), mean2(A), std2(A)
% 
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        03/28/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
close all; % Clear out all memory

% the window size of all the filters used is 5*5
window_size = 5;
sigma = 20;
alpha = 0.25;

%Reading input image 'Random Disks'
input_image=imread('RandomDisks-P10.jpg');
input_image = input_image(:,:,1);
%Padding the input image 
input_image = padarray(input_image,[floor(window_size/2) floor(window_size/2)],0,'both');
figure();
imshow(input_image)
title('Input Image(8 bits)')

%Extracting large disk from input image
large_disk = input_image(391:455,461:530);
figure();
imshow(large_disk)
title('Large Disk')
%Extracting interior large disk from input image
x = 14; 
ld_int_bounds = [391+x,455-x,461+x,530-x];
large_disk_interior = input_image(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4));
figure();
imshow(large_disk_interior)
title('Large Disk Interior')

%Initialze all output matrices with the input image
mean_output = input_image;
median_output = input_image;
alphatrim_output = input_image;
sigma_output = input_image;
symmNNM_output = input_image;
%Apply all the filters iteratively for five times
for i = 1:5
    fprintf("Running iteration(%d)...\n",i);
    fprintf("Iteration%d:Mean Filtering...\n",i);
    mean_output = mean_filter(mean_output, window_size);
    fprintf("Iteration%d:Median Filtering...\n",i);
    median_output = medfilt2(median_output , [window_size, window_size]);
    fprintf("Iteration%d:Alpha Trim Mean Filtering...\n",i);
    alphatrim_output = alphatrim_filter(alphatrim_output, window_size, alpha);
    fprintf("Iteration%d:Sigma Filtering...\n",i);
    sigma_output = sigma_filter(sigma_output, window_size,sigma);
    fprintf("Iteration%d:Symmetric NNM Filtering...\n",i);
    symmNNM_output = symmNNM_filter(symmNNM_output, window_size);
    
    %Display and store results after first and fifth iteration
    if(i==1 || i==5)
        fprintf("The statistics of interior of large disk in iteration(%d) are:\n",i);
        %Output
        figure();
        imshow(mean_output)
        title('Mean Filter Output')
        imwrite(mean_output,['MeanOutput_' num2str(i) '.png'])
        %Histogram
        figure();
        imhist(mean_output)
        title('Mean Filter Output(Histogram)')
        saveas(gcf,sprintf('MeanOutputHist_%d.png',i))
        %Mean and STD
        mean = mean2(mean_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        std = std2(mean_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        fprintf("Mean Filter Output: Mean=%d STD=%d\n",mean,std);
        
        %Output
        figure();
        imshow(median_output)
        title('Median Filter Output')
        imwrite(median_output,['MedianOutput_' num2str(i) '.png'])
        %Histogram
        figure();
        imhist(median_output)
        title('Median Filter Output(Histogram)')
        saveas(gcf,sprintf('MedianOutputHist_%d.png',i))
        %Mean and STD
        mean = mean2(median_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        std = std2(median_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        fprintf("Median Filter Output: Mean=%d STD=%d\n",mean,std);
        
        %Output
        figure();
        imshow(alphatrim_output)
        title('Alpha Trimmed Mean Filter Output')
        imwrite(alphatrim_output,['AlphaTrimOutput_' num2str(i) '.png'])
        %Histogram
        figure();
        imhist(alphatrim_output)
        title('Alpha Trimmed Mean Filter Output(Histogram)')
        saveas(gcf,sprintf('AlphaTrimOutputHist_%d.png',i))
        %Mean and STD
        mean = mean2(alphatrim_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        std = std2(alphatrim_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        fprintf("Alpha Trimmed Mean Filter Output: Mean=%d STD=%d\n",mean,std);
        
        %Output
        figure();
        imshow(sigma_output)
        title('Sigma Filter Output')
        imwrite(sigma_output,['SigmaOutput_' num2str(i) '.png'])
        %Histogram
        figure();
        imhist(sigma_output)
        title('Sigma Filter Output(Histogram)')
        saveas(gcf,sprintf('SigmaOutputHist_%d.png',i))
        %Mean and STD
        mean = mean2(sigma_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        std = std2(sigma_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        fprintf("Sigma Filter Output: Mean=%d STD=%d\n",mean,std);
        
        %Output
        figure();
        imshow(symmNNM_output)
        title('Symmetric Nearest-Neighbor Mean Filter Output')
        imwrite(symmNNM_output,['SymmNNMOutput_' num2str(i) '.png'])
        %Histogram
        figure();
        imhist(symmNNM_output)
        title('Symmetric Nearest-Neighbor Mean Filter Output(Histogram)')
        saveas(gcf,sprintf('SymmNNMOutputHist_%d.png',i));
        %Mean and STD
        mean = mean2(symmNNM_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        std = std2(symmNNM_output(ld_int_bounds(1):ld_int_bounds(2), ld_int_bounds(3):ld_int_bounds(4)));
        fprintf("Symmetric Nearest-Neighbor Mean Filter Output: Mean=%d STD=%d\n",mean,std);
    end
end