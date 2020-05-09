% This function calculates the conduction coefficients


function [ coe ] = fcn_CondCoe( I,k,gop )

normI=abs(I); % magnitude of I 

if strcmp(gop,'exp') == 1  % This defines the equation to used based on g option
    
    coe = exp(-1*((normI/k)^2));
    
end

if strcmp(gop,'quad') == 1
    
    coe = 1/(1+((normI/k)^2));
    
end
end