function counter = area_function(input)
    input = logical(input);
    [rows col] = size(input);
    counter=0;
    for i=1:rows
        for j=1:col
            if input(i,j)==1
                counter = counter+1;
            end
        end
    end
end