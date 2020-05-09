%%%%%%%%%%%%% render_IFS.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Generate fractal image using the given affine transform and probabilities
%
% Input Variables:
%      Image Width      Set the width of output image
%      Image Height     Set the height of output image
%      prob             Choose a probability set to be used with the affine transforms
%      num_of_iter      Number of iterations to run the algo
%
% Processing Flow:
%      1.  Create an image filled with zeros of size passed as input to the function 
%      2.  Runs the algorithm for given number of times
%      3.  In each iteration, a random number is generated with the given range
%      3.  Depending on the random number, choose the affine transform to be used
%      4.  Apply the transform and get the results which will act as seed 
%          point in the next iteration.
%      5.  Calculate the pixel that corresponds to this iteration and set it to 1
%
%  The following functions are called:
%       affine_transform.m
%   
%   Output:
%       returns the fractal image generated after all the iterations
% 
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        04/23/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fractal_image = render_IFS(image_width, image_height, prob, num_of_iter)
% Create a image filled with zeros using the given dimensions 
img =zeros(image_width,image_height);
img_max=0; % maximum element in image

% Set the limits of the viewing window
x_min=-3;
x_max=3;
y_min=0;
y_max=9;

% Initialize a position in the image
x=0;
y=0;
x1=0;
x2=0;
y1=0;
y2=0;

rng(0,'twister'); % set seed for the random number generator
for n = 1:num_of_iter
    % Generate a random number
    random_num = rand();
    if random_num < 0
        random_num = 0;
    elseif random_num > 1
        random_num = 1;
    end
    
    % Initialize sum to first element in prob list
    sum = prob(1);
    k=1;
    while (sum<random_num)
        k=k+1 ;
        sum = sum + prob(k);
    end
   
   % get the transformed values under w_{k}
   [x,y] = affine_transform(x,y,k);
   x1=min(x,x1);
   x2=max(x,x2);
   y1=min(y,y1);
   y2=max(y,y2);
   
   if (x>x_min)&&(x<x_max)&&(y>y_min)&&(y<y_max)
      l= ceil(image_width*(x-x_min)/(x_max-x_min));
      m= ceil(image_height*(y-y_min)/(y_max-y_min));
      img(l,m)=img(l,m)+1;
      img_max=max(img(l,m),img_max);
   end
end

% return the result
img = uint8(img>1)*255;
fractal_image = img;
end