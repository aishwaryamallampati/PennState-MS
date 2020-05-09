% This function runs anisotropic diffusion on an image


function [ I_filtered ] = fcn_AnisoDiff( I,lambda,k,gop )
[m,n]=size(I); % Take input image dimensions

I_filtered=zeros(size(I)); % initialization



    for i=2:m-1 
        for j=2:n-1
% north direction
            deltaNI=I(i-1,j)-I(i,j);
            cN = fcn_CondCoe(deltaNI,k,gop );

% south direction
            deltaSI=I(i+1,j)-I(i,j);
            coe_S = fcn_CondCoe( deltaSI,k,gop );

% east direction
            deltaEI=I(i,j+1)-I(i,j);
            coe_E = fcn_CondCoe( deltaEI,k,gop );

%west direction
 
            deltaWI=I(i,j-1)-I(i,j);
            coe_W = fcn_CondCoe( deltaWI,k,gop );           
            
% anisotropic implementation
        I_filtered(i,j) = I(i,j) + (((cN*deltaNI)+(coe_S*deltaSI)+(coe_E*deltaEI)+(coe_W*deltaWI))*lambda);
            if I_filtered(i,j)>=1
                I_filtered(i,j)=1;
            end
            if I_filtered(i,j)<=0
                I_filtered(i,j)=0;
            end
        
        end
    end
end

