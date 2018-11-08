function [data_velocity] = PositionToVelocity(data_position,range)

% default values
sample_rate = 500;

if nargin == 1
    range = 1;
end

for i = 1:length(data_position)
    if i < range + 1
    data_velocity(:,i) = (data_position(i+range) - data_position(i))./(range/sample_rate);
    
    elseif i > length(data_position) - range
    data_velocity(:,i) = (data_position(i) - data_position(i-range))./(range/sample_rate);
 
    else
    data_velocity(:,i) = (data_position(i+range) - data_position(i-range))./(2*range/sample_rate);
    end
end