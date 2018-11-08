function [final_amplitude] = amplitude(tmp, mode)
%% get the final amplitude of the data set...

if mode == 1 %horz_vergence
    tmp2(1,:) = tmp(1,:) + tmp(2,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    
elseif mode == 2%horz_version
    tmp2(1,:) = (tmp(2,:) - tmp(1,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    
elseif mode == 3%vert_vergence
    tmp2(1,:) = tmp(3,:) - tmp(4,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    
elseif mode == 4%vert_version
    tmp2(1,:) = (tmp(3,:) + tmp(4,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    
end

final_amplitude = nanmean(filt_data(end-100:end));