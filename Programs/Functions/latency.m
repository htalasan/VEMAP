function [l] = latency(tmp,mode,smooth_val)
%%
if nargin < 3
    smooth_val = 1;
end

if mode == 1 %horz_vergence

    tmp2(1,:) = tmp(1,:) + tmp(2,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    filt_data = smooth(filt_data,smooth_val);
    bthresh = 100;
    
elseif mode == 2%horz_version

    tmp2(1,:) = (tmp(2,:) - tmp(1,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    filt_data = smooth(filt_data,smooth_val);
    bthresh = 700;
elseif mode == 3%vert_vergence

    tmp2(1,:) = tmp(3,:) - tmp(4,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    filt_data = smooth(filt_data,smooth_val);
    bthresh = 100;
    
elseif mode == 4%vert_version

    tmp2(1,:) = (tmp(3,:) + tmp(4,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    filt_data = smooth(filt_data,smooth_val);
    bthresh = 700;
end

veldata= PositionToVelocity(filt_data);
[Vp, Vindex] = max(abs(veldata(50:ceil(end/2))));
thresh = 0.25;

while Vp > bthresh % blink thresholding
    [Vp, Vindex] = max(abs(veldata(50:Vindex)));
end

for i = 75:length(veldata)
    if abs(veldata(i)) > abs(Vp*thresh)
        l = i*(0.002);
        break;
    end
end

if exist('l') == 0
    l = NaN;
end