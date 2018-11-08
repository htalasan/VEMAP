function [line_fixation, key_fixation] = fixation_time_mSDMT(line_data,key_data)
% disp(line_data.count)
% disp(key_data.count)
line_data.bin = zeros(1,line_data.count);
key_data.bin = ones(1,key_data.count);

total.bin = [line_data.bin key_data.bin];
total.indices = [line_data.indices(1:line_data.count) key_data.indices(1:key_data.count)];

[total.indices(1,:), something] = sort(total.indices);
% disp(length(total.indices))
% disp(total.bin)
total.indices(2,:) = total.bin(something);

total.indices(3,1) = total.indices(1,1); % initialize the differences array

for i = 2:length(total.indices)
    total.indices(3,i) = total.indices(1,i) - total.indices(1,i-1);
end

key_count = 0;
line_count = 0;
for i = 1:length(total.indices)
    if total.indices(2,i) == 1
        key_count = key_count + 1;
        key_fixation_times(key_count) = total.indices(3,i)/500;
    else
        line_count = line_count + 1;
        line_fixation_times(line_count) = total.indices(3,i)/500;
    end
end

line_fixation.mean = mean(line_fixation_times);
line_fixation.std = std(line_fixation_times);
key_fixation.mean = mean(key_fixation_times);
key_fixation.std = std(key_fixation_times);

