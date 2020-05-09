%%%%%%%%%%%%% main.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Generating fractal images using iterated function systems (Project-5)
%
% Five options for probability sets are provided to the user. 
% User has to choose one probability set to generate fractal images.
% User should also enter the number of iterations to run the algorithm
%
% Input Variables:
%      Image Width      Set the width of output image
%      Image Height     Set the height of output image
%      prob             Choose a probability set to be used with the affine transforms
%      num_of_iter      Number of iterations to run the algo
%
%  The following functions are called:
%      render_IFS.m
%   
%   Output:
%       Display the final fractal image generated
%
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        04/23/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

% Set the dimensions of the fractal image to be generated
image_width = 1024;
image_height = 1024;

% Ask user to choose a set of probabilities from the below list
fprintf("The following probability sets are available:\n");
fprintf("1.Probabilites:[0.2,0.35,0.35,0.1]\n");
fprintf("2.Probabilites:[0,0.35,0.35,0.1]\n");
fprintf("3.Probabilites:[0.2,0,0.35,0.1]\n");
fprintf("4.Probabilites:[0.2,0.35,0,0.1]\n");
fprintf("5.Probabilites:[0.3,0.35,0.35,0]\n");
option = input('Choose one of the above options(1/2/3/4/5):');
switch(option)
    case 1
        prob  = [0.2, 0.35, 0.35, 0.1];
        option = "ProbabilitySet1";
    case 2
        prob  = [0, 0.35, 0.35, 0.3];
        option = "ProbabilitySet2";
    case 3
        prob  = [0.4, 0, 0.35, 0.25];
        option = "ProbabilitySet3";
    case 4
        prob  = [0.2, 0.35, 0, 0.45];
        option = "ProbabilitySet4";
    case 5
        prob  = [0.2, 0.55, 0.35, 0];
        option = "ProbabilitySet5";
end
% Ask the user to enter the number of iterations to run the algo
num_of_iter = input("Enter the number of iterations:");

% Pass the selected parameters to render_IFS to get the fractal image
output = render_IFS(image_width, image_height, prob, num_of_iter);
% Displaying and saving final result
h=figure();
imshow(output)
title(strcat('Output: ',option,' Iterations=',int2str(num_of_iter)))
filename = strcat('Output_',option,'_',int2str(num_of_iter),'.png');
saveas(h,filename);

