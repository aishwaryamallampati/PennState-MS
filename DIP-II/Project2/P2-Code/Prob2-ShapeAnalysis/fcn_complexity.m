%% this function computes the complexity of a img
function shapecomplexity1 = fcn_complexity(pecstrum1)

f1=0;
    for i=1:length(pecstrum1)
        if pecstrum1(i) ~=0
            f1=f1+(pecstrum1(i)*log(pecstrum1(i))); % compute according to the fomula
        end
    end
    f1=-f1;
   shapecomplexity1=f1;
   
end
