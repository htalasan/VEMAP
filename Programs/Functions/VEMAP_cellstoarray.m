function [new_array] =  VEMAP_cellstoarray(tmp,mode)
% takes eye movement data that is in cell form and transforms it to an
% array

for i = 1:length(tmp)
    if mode == 1 %vergence
        new_array(i,:) = (tmp{i}(1,:)-tmp{i}(2,:))/2;
        new_array(i,:) = new_array(i,:) - mean(new_array(i,1:50)); % normalize
    end
end