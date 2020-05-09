%%%%%%%%%%%%% main_anisotropicdiffusion.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Solution to the Problem2- Anisotropic Diffusion of Project-3
%
% Processing Flow:
%      1.  Ask user to choose one input image
%      2.  Perform anisotroipic diffusion using both the methods of g
%      3.  Plot histogram, y=128 line and segmented image 
%
%  The following functions are called:
%       fcn_AnisoDiff.m
%       fcn_CondCoe.m
%       fcn_segmentImg.m
% 
% Author:      Wushuang Bai,Aishwarya Mallampati, Mrunmayi Ekbote,
% Date:        03/28/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;

%Taking option from user to select the input image
option = input('Enter input image(1:cwheelnoise, 2:cameraman): ');
switch option
    case 1
        I=imread('cwheelnoise.gif');  % Reading input image 'cwheelnoise'
        option = 'cwheelnoise';
    case 2 
        I = imread('cameraman.tif'); % Reading input image 'cameraman'
        option = 'cameraman';
end

%I=imread('cwheelnoise.gif');  % use this for wheel image
%I = imread('cameraman.tif'); % use this for cameraman image

[m,n,p]=size(I);
if p>1
    I=I(:,:,1);
end
I = im2double(I); 
I0 = I; % save original image
%% Parameters for anisotropic diffusion

lambda=0.25;    
k_exp = 30/255;
g_exp = 'exp'; 

k_quad = 10/255; 
g_quad='quad';  % pick k and g accordingly for the option of exponential or quadratic of g   
yLine = 128;

%% ============ anisotropic diffusion with exponential g starts from here====================

for t=1:100
I = fcn_AnisoDiff( I,lambda,k_exp,g_exp);
% Saving images for 5,20 and 100 iterations
 if t==5
     I5 =  I ;
     I5 = im2uint8(I5);
     
 end
 if t==20
     I20 =  I ;
     I20 = im2uint8(I20);
   
 end
 
 if t==100
     I100 =  I ;
     I100 = im2uint8(I100);
     
 end
end
%% plot images after iterations for g with exponential method 
figure()
subplot(2,2,1);
imshow(I0);
title('Original image');
% figure();
subplot(2,2,2)
imshow(I5);
title('Image after 5 iterations with exp method of g');
% figure();
subplot(2,2,3)
imshow(I20);
title('Image after 20 iterations with exp method of g');
% figure();
subplot(2,2,4)
imshow(I100);
title('Image after 100 iterations with exp method of g');
%% plot histogram for g with exponential method
figure();
subplot(2,2,1)
histogram(I0);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Original image');
subplot(2,2,2)
histogram(I5);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Image after 5 iterations with exp method of g');
subplot(2,2,3)
histogram(I20);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Image after 20 iterations with exp method of g');
subplot(2,2,4)
histogram(I100);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Image after 100 iterations with exp method of g');
%% plot y = 128 for g with exponential method
figure()
subplot(2,2,1)
plot(I0(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Original image');
subplot(2,2,2)
plot(I5(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Image after 5 iterations with exp method of g');
subplot(2,2,3)
plot(I20(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Image after 20 iterations with exp method of g');
subplot(2,2,4)
plot(I100(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Image after 100 iterations with exp method of g');
%% segment the image and plot
segVal = 128
I0_seg = fcn_segmentImg(I0,segVal);
I5_seg = fcn_segmentImg(I5,segVal);
I20_seg = fcn_segmentImg(I20,segVal);
I100_seg = fcn_segmentImg(I100,segVal);
figure()
subplot(2,2,1);
imshow(I0_seg);
title('Original image');

subplot(2,2,2)
imshow(I5_seg);
title('Segmented Image after 5 iterations with exp method of g');

subplot(2,2,3)
imshow(I20_seg);
title('Segmented Image after 20 iterations with exp method of g');

subplot(2,2,4)
imshow(I100_seg);
title('Segmented Image after 100 iterations with exp method of g');

%% ============ anisotropic diffusion with quadratic g starts from here====================

for t=1:100
I = fcn_AnisoDiff( I,lambda,k_quad,g_quad);
% Saving images for 5,20 and 100 iterations
 if t==5
     I5 =  I ;
     I5 = im2uint8(I5);
     
 end
 if t==20
     I20 =  I ;
     I20 = im2uint8(I20);
   
 end
 
 if t==100
     I100 =  I ;
     I100 = im2uint8(I100);
     
 end
end
%% plot images after iterations for g with quadratic method 
figure()
subplot(2,2,1);
imshow(I0);
title('Original image');

subplot(2,2,2)
imshow(I5);
title('Image after 5 iterations with quad method of g');

subplot(2,2,3)
imshow(I20);
title('Image after 20 iterations with quad method of g');

subplot(2,2,4)
imshow(I100);
title('Image after 100 iterations with quad method of g');
%% plot histogram for g with quadratic method
figure();
subplot(2,2,1)
histogram(I0);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Original image');
subplot(2,2,2)
histogram(I5);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Image after 5 iterations with quad method of g');
subplot(2,2,3)
histogram(I20);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Image after 20 iterations with quad method of g');
subplot(2,2,4)
histogram(I100);
xlabel('Gray scale pixel value');
ylabel('Frequency');
title('Image after 100 iterations with quad method of g');
%% plot y = 128 for g with quadratic method
figure()
subplot(2,2,1)
plot(I0(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Original image');
subplot(2,2,2)
plot(I5(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Image after 5 iterations with quad method of g');
subplot(2,2,3)
plot(I20(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Image after 20 iterations with quad method of g');
subplot(2,2,4)
plot(I100(yLine,:))
xlabel('x');
ylabel('Pixel value');
title('Image after 100 iterations with quad method of g');
%% segment the image and plot
segVal = 128
I0_seg = fcn_segmentImg(I0,segVal);
I5_seg = fcn_segmentImg(I5,segVal);
I20_seg = fcn_segmentImg(I20,segVal);
I100_seg = fcn_segmentImg(I100,segVal);
figure()
subplot(2,2,1);
imshow(I0_seg);
title('Original image');

subplot(2,2,2)
imshow(I5_seg);
title('Segmented Image after 5 iterations with quad method of g');

subplot(2,2,3)
imshow(I20_seg);
title('Segmented Image after 20 iterations with quad method of g');

subplot(2,2,4)
imshow(I100_seg);
title('Segmented Image after 100 iterations with quad method of g');

