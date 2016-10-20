function D = computeJaccardDistance(F1, F2)
%function D = computeJaccardDistance(F1, F2)

D = 0;
for i=1:length(F1)
    c1 = F1{i};
    c2 = F2{i};
    
    if(isempty(c1) || isempty(c2))
        continue;
    end
    
    for j=1:length(c1)
        for k=1:length(c2)
            if(c1(j) == c2(k))
                D = D + 1;
            end
        end
    end
end
