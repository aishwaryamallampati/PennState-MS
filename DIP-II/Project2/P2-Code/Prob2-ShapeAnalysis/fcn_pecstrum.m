%% this function cumputes the pecstrum of a image with the input of size distribution and the image area
function pecstrum1 = fcn_pecstrum(sizedistribution1,object1area)
pecstrum1 = [];
entirepecstrum1=[];
sizedistribution1=[sizedistribution1 0];
   for i=1:(length(sizedistribution1)-1)
       pecstrum1(i) = (sizedistribution1(i) - sizedistribution1(i+1))./(object1area);
   end
entirepecstrum1=[entirepecstrum1;pecstrum1];
end