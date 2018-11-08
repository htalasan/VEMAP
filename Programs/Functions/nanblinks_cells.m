function [pos] = nanblinks_cells(data)
% function replaces manually chosen blinks with NaNs
%%
s = size(data);

figure

tmp1 = data;

for i = 1:s(2)
    clf
    option = 1;
    tmp =  (data{i}(1,:) + data{i}(2,:))/2;
    tmp = tmp(1,:)-mean(tmp(1,1:50));
    
    while option == 1;
        
        plot(tmp(1,:)) %plot the trial
        option = menu('Do blinks need to be removed?','Yes','No');
        
        if option == 1
            [x,~] = ginput(2);
            if x(2) > length(tmp) % making sure the lengths are the same, even if there is a blink at the end
                x(2) = length(tmp);
            end
            tmp(1,ceil(x(1)):ceil(x(2))) = nan;
            tmp1{i}(1,ceil(x(1)):ceil(x(2))) = nan;
            tmp1{i}(2,ceil(x(1)):ceil(x(2))) = nan;
            tmp1{i}(3,ceil(x(1)):ceil(x(2))) = nan;
            tmp1{i}(4,ceil(x(1)):ceil(x(2))) = nan;
            tmp1{i}(5,ceil(x(1)):ceil(x(2))) = nan;
            tmp1{i}(6,ceil(x(1)):ceil(x(2))) = nan;
             
        end
        
    end
    
end

close

pos = tmp1;