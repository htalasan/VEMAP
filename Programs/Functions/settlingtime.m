function [Ts] = settlingtime(data,mode)
if mode == 1 %horz_vergence
    data1 = data(1,:) + data(2,:);
elseif mode == 2%horz_version
    data1 = (data(1,:) - data(2,:))/2;
elseif mode == 3%vert_vergence
    data1 = data(3,:) - data(4,:);
elseif mode == 4%vert_version
    data1 = (data(3,:) + data(4,:))/2;
end


n = length(data1);
tmp = transpose(smooth(data1,20));
endmean = nanmean(tmp(ceil(end-n/5):end));
thresh1 = endmean*0.95;
thresh2 = endmean*1.05;
a(1) = abs(tmp(1,1)) - abs(thresh1);
b(1) = abs(tmp(1,1)) - abs(thresh2);
cross = 1;
for j=2:length(tmp)-5
    a(j) = abs(tmp(j)) - abs(thresh1);
    b(j) = abs(tmp(j)) - abs(thresh2);
    if a(j)*a(j-1) < 0
        cross = j;
    elseif b(j)*b(j-1)<0
        cross = j;
    end
end
Ts = cross*0.002;