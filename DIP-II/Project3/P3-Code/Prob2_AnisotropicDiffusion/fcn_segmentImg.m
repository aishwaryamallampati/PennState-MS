% This function runs the segmentation of an input with a customized
% threshold 
function I_segmented = fcn_segmentImg( I,threshold )
[m,n]=size(I);
I_segmented=I;
for i=1:m
    for j=1:n
        if I(i,j)<=threshold
            I_segmented(i,j)=I(i,j);
        else
            I_segmented(i,j)=255;
        end
    end
end

end