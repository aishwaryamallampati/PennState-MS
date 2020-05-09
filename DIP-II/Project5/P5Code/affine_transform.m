%%%%%%%%%%%%% affine_transform.m file %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Purpose:  
%      Applies respective affine transform based on k value
%
% Input Variables:
%      x,y              Pixel Location
%      k                Decides affine transform to be used
%
%   Output:
%       returns the transformed values
% 
% Author:      Aishwarya Mallampati, Mrunmayi Ekbote, Wushuang Bai
% Date:        04/23/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x1,y1] = affine_transform(x,y,k)
% Assing w and t values on the basis of the k value passed to the function 
if k==1
    w = [0, 0; 0, 0.16];
    t = [0; 0];
elseif k==2
    w = [0.2, -0.26; 0.23, 0.22];
    t = [0; 1.6];
elseif k==3
    w = [-0.15, 0.28; 0.26, 0.24];
    t = [0; 0.44];
elseif k==4
    w = [0.85, 0.04; -0.04, 0.85];
    t = [0; 1.6];
end

% Perform mapping on input coordinate
transfomed_values = w*[x;y] + t;

% Extract (x,y) from computed vector and return the values.
x1 = transfomed_values(1);
y1 = transfomed_values(2);

end
