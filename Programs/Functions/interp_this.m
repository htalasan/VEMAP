function [output] = interp_this(tmp,mode)
% function interpolates the two chosen points; useful for blink removal
% input is a sample movement set
%%
option =1;
figure
while option == 1;
    cla
    if mode == 1 %horz_vergence
        tmp2(1,:) = tmp(1,:) + tmp(2,:);
        tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
        filt_data= EOMfilters(transpose(tmp2),20);
        
    elseif mode == 2%horz_version
        tmp2(1,:) = (tmp(2,:) - tmp(1,:))/2;
        tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
        filt_data= EOMfilters(transpose(tmp2),40);
        
    elseif mode == 3%vert_vergence
        tmp2(1,:) = tmp(3,:) + tmp(4,:);
        tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
        filt_data= EOMfilters(transpose(tmp2),20);
        
    elseif mode == 4%vert_version
        tmp2(1,:) = (tmp(3,:) - tmp(4,:))/2;
        tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
        filt_data= EOMfilters(transpose(tmp2),40);
        
    end
    
    plot(tmp2(:))
    option = menu('Do blinks need to be interpolated?','Yes','No');
    
    if option == 1
        [x,~] = ginput(2); % choose the points
        x1 = [ceil(x(1)) ceil(x(2))]; % making sure they're whole numbers
        X = (x1(1)):(x1(2));
        Y1 = interp1(x1,tmp(1,x1),X); % interpolation taking place
        Y2 = interp1(x1,tmp(2,x1),X);
        Y3 = interp1(x1,tmp(3,x1),X);
        Y4 = interp1(x1,tmp(4,x1),X);
        
        tmp(1,X) = Y1; % substituting the interpolation in place in the input
        tmp(2,X) = Y2;
        tmp(3,X) = Y3;
        tmp(4,X) = Y4; % for right eye vert and horz and left eye vert and horz
    end
end

output = tmp;



