function [response_amplitude,index] = response(tmp,mode,index_num,smooth_val) %redo
%%
% 1.1   10/24/2016  Added blink thresholder
% 1.2   11/4/2016   Changed blink thresholding values to match type of mode
if nargin < 4
    smooth_val = 1;
end

if mode == 1 %horz_vergence
    range = 100/2;
    tmp2(1,:) = tmp(1,:) + tmp(2,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 100;
    
elseif mode == 2%horz_version
    range = 20/2;
    tmp2(1,:) = (tmp(2,:) - tmp(1,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 700;
elseif mode == 3%vert_vergence
    range = 100/2;
    tmp2(1,:) = tmp(3,:) - tmp(4,:);
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),20);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 100;
    
elseif mode == 4%vert_version
    range = 20/2;
    tmp2(1,:) = (tmp(3,:) + tmp(4,:))/2;
    tmp2(1,:) = tmp2(1,:) - nanmean(tmp2(1:50));
    filt_data= EOMfilters(transpose(tmp2),40);
    filt_data = smooth(filt_data,smooth_val);
    thresh = 700;
end

filt_data = abs(filt_data');
vel_data = abs(PositionToVelocity(filt_data));

if isempty(index_num) == 1
    
    [max_val,max_index_num] = max(abs(vel_data(50:ceil(end/2))));
    
    while max_val > thresh % thresholding for blinks
        [max_val,max_index_num] = max(abs(vel_data(50:max_index_num)));
    end
    
    index_num = max_index_num + 50;
    
    c = index_num - range;
    d = index_num + range;
    
    index = c:d;
    
    x = (filt_data(index));
    y = (vel_data(index));
    %     disp(index)
    p = polyfit(x,y,2);
    f = polyval(p,x);
    resp = roots(p);
else % using a custom range
    x = (filt_data(index_num));
    y = (vel_data(index_num));
    p = polyfit(x,y,2);
    f = polyval(p,x);
    resp = roots(p);
end

response = resp;

try
    if isreal(response(1,1))
        if response(2,1) > 0
            response_amplitude = abs(response(1,1)-response(2,1));
        else
            response_amplitude = response(1,1);
        end
    else
        %     disp(response)
        response_amplitude = NaN; %figure out a different way to do this.
    end
catch
    response_amplitude = NaN;
end
% figure;
% plot(x,f)
%%
% disp(filt_data)
% disp(response)
% for i = index:length(filt_data)
%     disp(i)
%     f1 = polyval(p,filt_data(i));
%     if f1 < 0
%         break
%     end
%     disp(f1)
% end
%
% % disp(i)
% range = i-index;
%
% % disp(range)
% range2 = index - range:index+range;
% % disp(range2)
% x1 = filt_data(range2);
%
% f1 = polyval(p,x1);
