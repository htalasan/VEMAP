function [l] = crossings(signal,thresh,n)
% Henry Talasan     VNEL    08042014 This function counts the number of
% times the signal crosses the threshold
%
% [l] = crossings(signal,thresh) runs the whole data set through the
% function
% [l] = corssings(signal,thresh,n) runs the data set starting at n

% default value for n if not given
if nargin < 3
    n = 1;
end

l = 0; % crossing count
a = signal(1,n) - thresh; % initiate a

for j = n+1:length(signal)
    
    b = signal(1,j) - thresh;
    
    if a*b <= 0 % whenever this product is negative or zero, signal crosses threshold
        l = l+1; % increase count
    end
    
    a = signal(1,j) - thresh;
    
end

end