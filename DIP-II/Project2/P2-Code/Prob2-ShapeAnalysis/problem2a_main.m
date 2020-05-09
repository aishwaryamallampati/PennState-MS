%%%%%%%%%%%%% problem2a_main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Solution to the Problem2a- Shape Analysis of Project-2
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
im1=logical(imread('match1.gif'));
fig1 = figure(1);imshow(im1);
%% Get the MBR for pic1
box1 = regionprops('table',im1,'BoundingBox');
box2 = table2array(box1);
[m,n] = find(box2<2);  % find the trivial box
box2(m,:) = []; % clean the trivial box
hold on;
for ii = 1:4
    rectangle('Position',box2(ii,:),'EdgeColor','r','LineWidth',2) % Get MBR
end
title('MBR for match1');
saveas (fig1,'MBR for match1.jpg');
solid_Box_Pic1 = box2; % select only solid objects - all objects are solid in match1.gif
%% Get the MBR
im2 = logical(imread('match3.gif'));
fig2 = figure(2); imshow(im2);
box3 = regionprops('table',im2,'BoundingBox');
box4 = table2array(box3);
[m,n] = find(box4<2);  % find the trivial box
box4(m,:) = []; % clean the trivial box

for ii = 1:4
    rectangle('Position',box4(ii,:),'EdgeColor','r','LineWidth',2) %get MBR
end
title('MBR for match3');
saveas (fig2,'MBR for match3.jpg');
solid_Box_Pic2 = box4; % select only solid objects - all objects are solid in match3.gif

%% crop out solid objects individually from match1.gif

pic_Crop1 = {};
for ii = 1:4
    pic_Crop1{ii} = imcrop(im1,solid_Box_Pic1(ii,:));
    figure(),imshow(pic_Crop1{ii});
end
label_1 ={'flower','bull','airplane','spade'};
%% crop out solid objects individually from match3.gif
pic_Crop2 = {};
for ii = 1:4
    pic_Crop2{ii} = imcrop(im2,solid_Box_Pic2(ii,:));
    figure(),imshow(pic_Crop2{ii});
end
label_2 ={'flower','bull','spade','airplane'};
%% find pecstrum for solid objects in match1 and match3
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
    fprintf(['match1: Label --> ',num2str(ii),'\n',label_1{ii},':- \n ']);
    fprintf(['Area:  ', num2str(area1{ii}),'\n']);
    fprintf(['Size distribution:  ', num2str(size1{ii}),'\n']);
    fprintf(['Pecstrum:',num2str(pecs1(ii,:)),'\n']);
    fprintf(['Entropy: ',num2str(complexity1(ii,:)),'\n \n']);
    disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');
end
% Finding max and min entropy
[val,pos]=min(complexity1);
fprintf(['match1: The least complex object corresponds to minimum entropy and it is ',num2str(label_1{pos}),'.\n']);
[val,pos]=max(complexity1);
fprintf(['match1: The most complex object corresponds to maximum entropy and it is ',num2str(label_1{pos}),'.\n']);
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
    fprintf(['match3: Label --> ',num2str(ii),'\n',label_2{ii},':- \n ']);
    fprintf(['Area:  ', num2str(area2{ii}),'\n']);
    fprintf(['Size distribution:  ', num2str(size2{ii}),'\n']);
    fprintf(['Pecstrum:',num2str(pecs2(ii,:)),'\n']);
    fprintf(['Entropy: ',num2str(complexity2(ii,:)),'\n \n']);
    disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');
end

% Finding max and min entropy
[val,pos]=min(complexity2);
fprintf(['match3: The least complex object corresponds to minimum entropy and it is ',num2str(label_2{pos}),'.\n']);
[val,pos]=max(complexity2);
fprintf(['match3: The most complex object corresponds to maximum entropy and it is ',num2str(label_2{pos}),'.\n']);
disp('-- -- -- -- -- -- -- -- -- -- -- -- -- --');
%% Do the pattern recognition
weight = [1 0 1 0 1 0 0 0 0 0 0 1]; % artificially choose the weight factors
formatSpec = 'Object Number %d in match1.gif is matching Object Number %d in match3.gif \n';
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
plot(size2{ii});title(strcat('size distribution of ', label_2{ii}))
legend('match1','match3')
% 
subplot(1,2,2)
stem(pecs1(ii,:),'o')
hold on
stem(pecs2(ii,:),'*');title(strcat('pecstrum of ', label_2{ii}))
legend('match1','match3')
filename = strcat('Size_distri_pecstrum_',label_2{ii},'.png');
saveas(fig,filename);
end
    
    
    
