%% this function does the pattern recognition as per the formula in lecture 6
function [D R] = fcn_patternRec(pecs_test,pecs_ref,weight)
    [m1,n1]=size(pecs_ref);
    [m2,n2]=size(pecs_test);
    R=[];
    D=[];
    for k=1:m2
        d=[];
        for i=1:m1
            co=0;
            for j=1:n1
               co= co + (weight(j)*(pecs_test(k,j)-pecs_ref(i,j)))^2; 
            end
            d=[d;(sqrt(co))];
        end
        D=[D d];
        [vi,ri]=min(d);
        R=[R;ri];
    end
end