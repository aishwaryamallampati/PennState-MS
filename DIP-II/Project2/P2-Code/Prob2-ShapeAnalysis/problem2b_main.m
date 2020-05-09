%%%%%%%%%%%%% problem2b_main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Solution to the Problem2b- Shape Analysis of Project-2
%
% Input Variables:
%      Image            Binary input image 
% 
% Returned Results:
%     Gives the output images after every iteration of skeletonization
%
% Processing Flow:
%      1.  Extract objects from the input images
%      2.  Compute area, size distribution, pecstrum and entropy of each
%          bject in the image
%      3.  Perform pattern matching between images using distances
%
%  The following functions are called:
%       areafunction.m
%       dilation_erosion.m
%       fcn_sizeDistribution.m
%       fcn_pecstrum.m
%       fcn_complexity.m
%       fcn_patternRec.m
%       
% 
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        02/21/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read the image
im1=logical(imread('shadow1.gif'));
fig1 = figure(1);imshow(im1);
%% Get the MBR for pic1
box1 = regionprops('table',im1,'BoundingBox');
box2 = table2array(box1);
[m,n] = find(box2<2);  % find the trivial box
box2(m,:) = []; % clean the trivial box
hold on;
for ii = 1:8
    rectangle('Position',box2(ii,:),'EdgeColor','r','LineWidth',2) % Get MBR
end
title('MBR for shadow1');
saveas (fig1,'MBR for shadow1.jpg');
solid_Box_Pic1 = box2([1,3,6,7],:); % select only solid objects
%% Get the MBR
im2 = logical(imread('shadow1rotated.gif'));
fig2 = figure(2); imshow(im2);
box3 = regionprops('table',im2,'BoundingBox');
box4 = table2array(box3);
[m,n] = find(box4<2);  % find the trivial box
box4(m,:) = []; % clean the trivial box

for ii = 1:8
    rectangle('Position',box4(ii,:),'EdgeColor','r','LineWidth',2) %get MBR
end
title('MBR for shadow2');
saveas (fig2,'MBR for shadow2.jpg');
solid_Box_Pic2 = box4([2,3,6,7],:); % select only solid objects

%% crop out solid objects individually from shadow1.gif

pic_Crop1 = {};
for ii = 1:4
    pic_Crop1{ii} = imcrop(im1,solid_Box_Pic1(ii,:));
    figure(),imshow(pic_Crop1{ii});
end
%% crop out solid objects individually from shadow1rorated.gif
pic_Crop2 = {};
for ii = 1:4
    pic_Crop2{ii} = imcrop(im2,solid_Box_Pic2(ii,:));
    figure(),imshow(pic_Crop2{ii});
end

%% find pecstrum for solid objects in shadow1 and shadow1rotated
area1 = {};
size1 = {};
pecs1 = [];
complexity1 = [];
for ii = 1:4
    area1{ii} = areafunction(pic_Crop1{ii}); % compute area
    size1{ii} = fcn_sizeDistribution(pic_Crop1{ii}); % compute size distribution
    pecs1(ii,:) = fcn_pecstrum(size1{ii},area1{ii}); % compute pecstrum 
    complexity1(ii,:) = fcn_complexity(pecs1(ii,:)); % compute shape complexity - entropy 
    
    %Displaying results    
    fprintf(['shadow1: Label --> ',num2str(ii),'\n']);
    fprintf(['Area:  ', num2str(area1{ii}),'\n']);
    fprintf(['Size distribution:  ', num2str(size1{ii}),'\n']);
    fprintf(['Pecstrum:',num2str(pecs1(ii,:)),'\n']);
    fprintf(['Entropy: ',num2str(complexity1(ii,:)),'\n \n']);
    disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');
end
% Finding max and min entropy
[val,pos]=min(complexity1);
fprintf(['shadow1: The least complex object corresponds to minimum entropy and it is solid object# ',num2str(pos),'.\n']);
[val,pos]=max(complexity1);
fprintf(['shadow1: The most complex object corresponds to maximum entropy and it is solid object# $',num2str(pos),'.\n']);
disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');

area2 = {};
size2 = {};
pecs2 = [];
complexity2 = [];
for ii = 1:4
    area2{ii} = areafunction(pic_Crop2{ii});% compute area
    size2{ii} = fcn_sizeDistribution(pic_Crop2{ii});% compute size distribution
    pecs2(ii,:) = fcn_pecstrum(size2{ii},area2{ii});% compute pecstrum 
    complexity2(ii,:) = fcn_complexity(pecs2(ii,:)); % compute shape complexity - entropy 
    %Displaying results    
    fprintf(['shadow1rotated: Label --> ',num2str(ii),'\n']);
    fprintf(['Area:  ', num2str(area2{ii}),'\n']);
    fprintf(['Size distribution:  ', num2str(size2{ii}),'\n']);
    fprintf(['Pecstrum:',num2str(pecs2(ii,:)),'\n']);
    fprintf(['Entropy: ',num2str(complexity2(ii,:)),'\n \n']);
    disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');
end
% Finding max and min entropy
[val,pos]=min(complexity2);
fprintf(['shadow1rotated: The least complex object corresponds to minimum entropy and it is solid object # ',num2str(pos),'.\n']);
[val,pos]=max(complexity2);
fprintf(['shadow1rotated: The most complex object corresponds to maximum entropy and it is solid object #',num2str(pos),'.\n']);
disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');
%% Do the pattern recognition
weight = [1 0 1 0 1 0 0 0 0 0 0 1]; % artificially choose the weight factors
formatSpec = 'Solid Object Number %d in shadow1.gif is matching Solid Object Number %d in shadow1rotated.gif \n';
for ii = 1:4
    [D R] = fcn_patternRec(pecs1(ii,:),pecs2,weight);
    fprintf(formatSpec,ii,R);
    
end

%%Plotting size distribution and pecstrum 
for ii = 1:4
fig = figure('OuterPosition',[250 500 700 500]);
subplot(1,2,1)
plot(size1{ii})
hold on
plot(size2{ii});title(strcat('size distribution of solid object ', num2str(ii)))
legend('shadow1','shadow1rotated')
% 
subplot(1,2,2)
stem(pecs1(ii,:),'o')
hold on
stem(pecs2(ii,:),'*');title(strcat('pecstrum of solid object ', num2str(ii)))
legend('shadow1','shadow1rotated')
filename = strcat('Size_distri_pecstrum_',num2str(ii),'.png');
saveas(fig,filename);
end
    
    
    
