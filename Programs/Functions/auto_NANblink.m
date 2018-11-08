function data_with_blinks_removed = auto_NANblink(tmp)
% this automatically removes blinks by taking the derivative and replacing
% any numbers higher than a certain threshold with nans.

%% use pupil to figure out where the blinks are...
% disp(tmp)
close all
tmp1 = (RawData{1}(4,:)); % get the pupil
figure
% plot(tmp1)
l = 50;
%
% tmp2 = tmp(6,:);

n(1) = 1;
for j = 1:1000
    
    for i = n(j):length(tmp1) % find beginning of blink
        if tmp1(i) < -4.5
            val(1,j) = tmp1(i);
            ind(1,j) = i-l;
            if ind(1,j)<1
                ind(1,j) = 1;
                disp(1)
            end
            
            break
        end
    end
    for i = ind(1,j):length(tmp1)
        if tmp1(i) > -4.5
            val(2,j) = tmp1(i);
            ind(2,j) = i+l;
            if ind(2,j)>length(tmp1)
                ind(2,j) = length(tmp1);
            end
            break
        end
        
        if i == length(tmp1)
            ind(2,j) = i;
        end
    end
    
    a(j) = ind(2,j) - ind(1,j);
        
    if a(j) > 1000
        ind(2,j) = length(tmp1);
       
    end
    n(j+1) = ind(2,j)+1;
    tmp = RawData{1};
    tmp(:,ind(1,j):ind(2,j)) = nan;
    tmp1(:,ind(1,j):ind(2,j)) = nan;
    
    if ind(2,j) == length(tmp1)
%         disp('yaay')
        break
        
    end
    % substitute nans
    
    %     tmp1(beg_ind-50:end_ind) = nan;
    %     tmp2(beg_ind-50:end_ind) = nan;
    
    
end

% figure
% plot(tmp1)
% plot(tmp(1,:))
data_with_blinks_removed = tmp;
