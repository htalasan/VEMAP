function [Vp,filt_data,veldata] = vpeak(tmp,mode,smooth_val)

%%
% 1.1   10/24/2016  Added blink thresholding

if nargin < 3
    smooth_val = 1;
end

if mode == 1 %horz_vergence

    tmp2(1,:) = tmp(1,:) + tmp(2,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 100;
    
elseif mode == 2%horz_version

    tmp2(1,:) = (tmp(2,:) - tmp(1,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 700;
elseif mode == 3%vert_vergence

    tmp2(1,:) = tmp(3,:) - tmp(4,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 100;
    
elseif mode == 4%vert_version

    tmp2(1,:) = (tmp(3,:) + tmp(4,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 700;
end


% n = length(tmp3);
% 
% if mode == 1 || mode == 3
%     tmp3 = smooth(tmp2,10);
% else
%     tmp3 = smooth(tmp2,2);
% end

veldata = PositionToVelocity(filt_data);
[Vp, Vindex] = max(abs(veldata(50:ceil(end/2))));

while Vp > thresh % blink thresholding
    [Vp, Vindex] = max(abs(veldata(50:Vindex)));
end
