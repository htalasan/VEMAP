function [out_data] = PeakVelShift(data,padn,mode)
% This function takes in an array of velocity data, finds the peaks, and
% synchronizes them to a specified index number, padn.

% The data padding can be either zeros or random numbers depending on the
% mode
for j = 1:length(data(:,1))
    %%
    %set default values
    if nargin < 2
        padn = 500;
        mode = 0;
    end
    
    if nargin < 3
        mode = 0;
    end
    
    %%
    % find the peak velocity's location.
    [~, loc] = max(abs(data(j,:)));
    
    k = padn - loc;
    
    % pad the beginning of the data set
    
    if mode == 1;
    for i = 1:k % pad with noise
        padding = randn(1,i);
    end
    end
    
    if mode == 0;
    padding = zeros(1,k); % pad with zeros
    end
    
    paddata = cat(2,padding(1,:),data(j,:));
    
    % cut the excess
    out_data(j,:) = paddata(1,1:length(data(1,:)));
    
end
end