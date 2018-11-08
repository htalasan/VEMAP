function [pos,vel,range] = nanblinks(input)
% function replaces manually chosen blinks with NaNs

%% make sure everything is unique
input = unique(input,'rows');

%%
s = size(input);


for i = 1:s(1)
    tmp(i,:) = smooth(input(i,:),20);
    veltmp(i,:) = PositionToVelocity(tmp(i,:),20);
end
%%
figure

for i = 1:s(1)
    clf
    option = 1;
   
    while option == 1;                
        
        plot(tmp(i,:)) %plot the trial
        option = menu('Do blinks need to be removed?','Yes','No');
        
        if option == 1
            [x,~] = ginput(2);
            if x(2) > s(2) % making sure the lengths are the same, even if there is a blink at the end
                x(2) = s(2);
            end
            tmp(i,ceil(x(1)):ceil(x(2))) = NaN;
            veltmp(i,ceil(x(1)):ceil(x(2))) = NaN;
            range = (ceil(x(1)):ceil(x(2)));
        end
        
    end
end

close

pos = tmp;
vel = veltmp;