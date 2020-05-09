%%%%%%%%%%%%%  Function main_without_noiseremoval %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Detect smallest and largest disks in the given input image without
%      noise removal
%
% Input Variables:
%       NONE
%      
% Returned Results:
%      Two seperate images each with only smallest and largest disks in it 
%      are stored in the directory.
%
% Processing Flow:  
%      1.  Reading input image 'Random Disks'
%      2.  Converting 8 bit input image to higher precision format(16bit)
%      3.  Converting image with 3 intensity channels(R,G,B) to one intensity channel
%      4.  Calling function 'pixelwisethresholding' to threshold the image
%      5.  Apply hit transform to detect smallest disks in the image
%      6.  Apply miss transform to detect largest disks in the image
%
%  Restrictions/Notes:
%      This function takes an 8-bit image as input.  
%
%  The following functions are called:
%       pixelwisethresholding.m
%       closing.m
%       dilation_erosion.m
%
%  Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
%  Date:        01/31/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
close all; % Clear out all memory

%Reading input image 'Random Disks'
input_image=imread('RandomDisks.jpg');
figure(1),imshow(input_image)
title('Input Image(8 bits)')

% Converting 8 bit input image to higher precision format(16bit)
Image = im2uint16(input_image);
figure(2),imshow(Image)
title('Input Image(16 bits)')
saveas(figure(2),[pwd '\output_images_without_noiseremoval\2Input Image(16 bits).tiff']);

%Converting image with 3 intensity channels(R,G,B) to one intensity channel
image = Image(:,:,1);
figure(3),imshow(image)
title('Image with one intensity channel')
saveas(figure(3),[pwd '\output_images_without_noiseremoval\3Image with one intensity channel.tiff']);

%Calling function 'pixelwisethresholding' to threshold the image 
[M,N] = size(image);
thresholdedimage = pixelwisethresholding(image, M, N);
figure(4), imshow(thresholdedimage);
title('Thresholded Grayscale Image')
saveas(figure(4),[pwd '\output_images_without_noiseremoval\4Thresholded Grayscale Image.tiff']);

%The given image considers WHITE as background and BLACK as foreground.
%Generally, BLACK is considered as background and WHITE is considered as
%foreground. So, negating the given image to convert it into standard format.
neg_image = ~thresholdedimage;
figure(5), imshow(neg_image)
title('Negative of Thresholded Grayscale Image')
saveas(figure(5),[pwd '\output_images_without_noiseremoval\5Negative of Thresholded Grayscale Image.tiff']);
img = neg_image;

% Hit transform: The following steps are performed to detect smallest disks:
% 
% Step1: Designing structural element to detect small disks
% To detect small disks present in the input image, a structuring element approximately of the same size and shape of the small disks is required. 
% To create structuring element, the input image is analyzed using imshow and the boundaries pixel values of small disk are noted. 
% Using the boundary pixel values, small disk sub-matrix is extracted from the input image.
se_smalldisk = img(46:68, 101:128);
figure(8), imshow(se_smalldisk)
title('Structuring element to detect small disks')
saveas(figure(8),[pwd '\output_images_without_noiseremoval\8Structuring element to detect small disks.tiff']);

%Step2: Remove small disks from the input image
erode_smalldisk = dilation_erosion(img,se_smalldisk,2);
figure(9), imshow(erode_smalldisk)
title('Small disks are eroded from the whole image')
saveas(figure(9),[pwd '\output_images_without_noiseremoval\9Small disks are eroded from the whole image.tiff']);

%Step3: Dilate the remaining disks to retrieve their previous shape and size
retrieve_disks = dilation_erosion(erode_smalldisk,se_smalldisk,1);
figure(10), imshow(retrieve_disks)
title('Remaining disks are dilated to retrieve thir original shape and size')
saveas(figure(10),[pwd '\output_images_without_noiseremoval\10Remaining disks are dilated to retrieve thir original shape and size.tiff']);

%Step4: Remove all the remaining disks from the input image to get an
%output image containing only smallest disks
smalldisks_output = img - retrieve_disks;
figure(11), imshow(smalldisks_output)
title('Image containing only smallest disks')
saveas(figure(11),[pwd '\output_images_without_noiseremoval\11Image containing only smallest disks.tiff']);

%Miss transform: The following steps are performed to detect largest disks
%
% Step1: Designing structural element to detect large disks
% Similarly, to detect large disk, the boundaries of one large disk in the input image are noted using imshow(). 
% Using these boundary pixel values, large disk submatrix is extracted from the input image
x = 10; %padding for the large disk
largedisk_withnbh = img(391-x:455+x, 461-x:530+x);
figure(12), imshow(largedisk_withnbh)
title('Large Disk')
saveas(figure(12),[pwd '\output_images_without_noiseremoval\12Large Disk.tiff']);

% In order to detect large disk, a miss transform needs to be applied which misses all the other disks in the input image.
% So, the structuring element should be the background image of the large disk. 
% The large disk matrix is negated to generate the required structuring element
se_largedisk_bck = ~largedisk_withnbh;
figure(13), imshow(se_largedisk_bck)
title('Structuring element to detect large disks')
saveas(figure(13),[pwd '\output_images_without_noiseremoval\13Structuring element to detect large disks.tiff']);

%For miss transform, the complement of the input image is used to perform
%the transforms
neg_image = ~img;

%Step2: Erode large disks from the complement of the input image
erode_largedisks = dilation_erosion(neg_image, se_largedisk_bck,2);
figure(14), imshow(erode_largedisks)
title('Erode large disks from input image')
saveas(figure(14),[pwd '\output_images_without_noiseremoval\14Erode large disks from input image.tiff']);

%Step3: Dilate the remaining disks to retrieve their previous shape and size
retrieve_disks = dilation_erosion(erode_largedisks,se_largedisk_bck,1);
figure(15), imshow(retrieve_disks)
title('Disks are dilated to retrieve thir original shape and size')
saveas(figure(15),[pwd '\output_images_without_noiseremoval\15Disks are dilated to retrieve thir original shape and size.tiff']);

%Step4: Remove all the remaining disks from the input image to get an
%output image containing only largest disks
largedisks_output = neg_image - retrieve_disks;
figure(16), imshow(largedisks_output)
title('Image containing only largest disks')
saveas(figure(16),[pwd '\output_images_without_noiseremoval\16Image containing only largest disks.tiff']);

%As per our original image, disks should be in black color, so negating the
%output image
smalldisksoriginal_output = ~smalldisks_output;

%Final Result - Images with only small and large disks
final_result = [smalldisksoriginal_output, largedisks_output];
figure(17),imshow(final_result)
title('Final Result - Images with only smallest and largest disks')
saveas(figure(17),[pwd '\output_images_without_noiseremoval\17Image containing only largest disks.tiff']);

%%%%%%%%%%%%% End of the main_without_noiseremoval.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%