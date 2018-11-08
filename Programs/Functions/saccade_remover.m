function [output] = saccade_remover(data,thresh,mode,noise_amp,sample_rate)
% Henry Talasan VNEL 07292014

% saccade_remover: A function to remove saccades and/or blinks from
% individual eye movements. Takes the derivative of the data and
% replaces any data points whose magnitude is greater than the minimum
% threshold with a another value depending on the mode.
% 
% This function may occasionally detect and replace strong noise artifacts,
% but with a smaller noise artifact or zero. Don't see any problem here to
% be honest. If you do, use something else!!!
%
% mode = 1: replaces data point with a random number from a gaussian dist
% mode = 2: replaces data point with zero
%
%
%   output = saccade_remover(data) returns a filtered eye movement
%
% It's under the user's discretion if he/she wants to use the data set.

% variables
if nargin < 2
    mode = 1; % default replaces data with a random number from a gaussian dist
    thresh = 20; % default thresh value is 20
    noise_amp = 5; % default noise amplifier
    sample_rate = 500; % default sample rate
end
 
if nargin < 3
    mode = 1;
    noise_amp = 5;
    sample_rate = 500;
end 


if nargin < 4
    noise_amp = 5;
    sample_rate = 500;
end


if nargin < 5
    sample_rate = 500;
end
%%
% get the velocity trace

skip_value = 1; % this skip value works best so any saccades wouldn't be smoothed out

for j = 1:length(data(1,:))
    
    if j < skip_value + 1
        data2(1,j) = (data(1,j+skip_value) - data(1,j))./(skip_value/sample_rate);
    elseif j > length(data(1,:)) - skip_value
        data2(1,j) = (data(1,j) - data(1,j-skip_value))./(skip_value/sample_rate);
    else
        data2(1,j) = (data(1,j+skip_value) - data(1,j-skip_value))./(2*skip_value/sample_rate);
    end
    
end

%%
% find the intervals of the instances when velocity is greater than thresh

signal = abs(data2);

% find beginning and ending of blinks

% for j = 1:length(signal)
%     if signal(j) > thresh && mode == 1 % if abs(data) crosses thresh, replace with a randn(1)
%         data2(j-5:j+5) = noise_amp*randn(1);
%     elseif signal(j) > thresh && mode == 2
%         data2(j) = 0;
%     end
% end

%%
% integrate updated data set

int_data(1) = data2(1)/sample_rate; % initialize integrated data set

for i = 1:length(data2)
    
    if i > 1
        int_data(i) = data2(i)*(1/sample_rate)+int_data(i-1); % integrate the data
    end
    
end

output = int_data; % make the integrated data set the output
end