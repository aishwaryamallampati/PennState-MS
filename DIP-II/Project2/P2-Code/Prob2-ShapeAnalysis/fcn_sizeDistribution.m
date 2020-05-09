%% this function computes the size distribution of a image
function sizedistribution1 = fcn_sizeDistribution(fig1)
sizedistribution1=[];
entiresizedistribution1 =[];
for r=1:12
        rB1 = ones((2*r)+1);
       [m n] = size(rB1);
    output = zeros(m,n);
    for i=1:m
        for j=1:n
            output(m-i+1, n-j+1) = rB1(i,j);
        end
    end
    rBs1=output;
   
     Y1=dilation_erosion(fig1,rBs1,2);
     Y2=dilation_erosion(Y1,rB1,1);
     Y2area = areafunction(Y2);
     sizedistribution1 =[sizedistribution1 Y2area];
    end
   entiresizedistribution1 = [entiresizedistribution1;sizedistribution1];
end