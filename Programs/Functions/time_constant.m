function [tc] = time_constant(tmp,mode)
%%
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

veldata= PositionToVelocity(filt_data);
[max_vel] = max(abs(veldata(50:end/2)));
thresh = 0.25;

for i = 75:length(veldata)/2 % finding latency
    if abs(veldata(i)) > abs(max_vel*thresh)
        l = i*(0.002);
        break;
    end
end

if exist('l') == 0
    l = NaN;
end

%% find the exponential fit using latency as a starting point...
n = 0;
tmp3 = abs(filt_data(i-n:end)); % cutting off the latency portion of movement
t = 0.002:0.002:length(tmp3)/500; % total time

f = fit(t',tmp3,'exp2','startpoint',[0 0 0 0]); % finding the exponential fit
% f = fit(t',tmp3,'exp2');
c = coeffvalues(f); % find the coefficients
if c(2) == 0 || c(3) == 0
    f = fit(t',tmp3,'exp2');
end
c = coeffvalues(f);
exp_plot = c(1)*exp(c(2)*t) +  c(3)*exp(c(4)*t); % get the exp plot

ind = find(abs(exp_plot) > 0.63*abs(exp_plot(end)),1,'first');
tc = ind*0.002-n*0.002;
%% plotting for debugging(make sure to remove after debugging)
figure
hold on
plot(t,tmp3);
plot(t,exp_plot,'r');
plot(tc+n*0.002,0.63*exp_plot(end),'go')