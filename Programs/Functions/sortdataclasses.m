function newdata = sortdataclasses(tmp,class)
% finds the trials that have the specified class
%%
j = 1;
for i = 1:length(tmp)
    if ismember(tmp(i).classifications,class) == 1 % figures if trial has the class
        c(i) = 1;
        j = j+1;
    end
end