function ensemble_plot(data,sample_rate,bounds,y_label,x_label,data_settings,mean_settings)
% Henry Talasan     VNEL    08042014
% This plots an ensemble plot of the data set with the mean of the data set
% superimposed.

% ensemble_plot(data) plots an ensemble plot of the data trials within the
% data array with a mean data set with the default values
% data =    [11 12 13 14 ... 1n; first trial
%            21 22 23 24 ... 2n; second trial
%                ...
%            n1 n2 n3 n4 ... nn] nth trial

% When settings plot settings: Make sure they are cells with the correct
% formatting. e.g., data_settings = {'Linewidth',2,'r'} makes the data
% trials red lines with a line width of 2

% Note: I always have trouble on determining what inputs to do... may want
% to change this at a later date.

%% Setting default values

if nargin < 2
    y_label = 'Position (deg)'; % default y_label
    x_label = 'Time (s)'; % default x_label;
    sample_rate = 500; % default sample rate
    data_settings = {'Color',[0.7 0.7 0.7]}; % default data settings
    mean_settings = {'Linewidth',2}; % default mean settings
end


if nargin < 3
    y_label = 'Position (deg)'; 
    x_label = 'Time (s)';
    data_settings = {'Color',[0.7 0.7 0.7]};
    mean_settings = {'Linewidth',2};
end

if nargin < 4
    y_label = 'Position (deg)';
    x_label = 'Time (s)'; 
    data_settings = {'Color',[0.7 0.7 0.7]};
    mean_settings = {'Linewidth',2};
end

if nargin < 6
    data_settings = {'Color',[0.7 0.7 0.7]};
    mean_settings = {'Linewidth',2};
end

if nargin < 7
    mean_settings = {'Linewidth',2};
end

%% Time Variables

T = length(data(1,:))/sample_rate; % total time
delta = 1/sample_rate; % change of time per data point
t = delta:delta:T; % time array

%% Mean_Data calculation

for i = 1:length(data(1,:))
    mean_data(i) = mean(data(:,i)); % getting the mean at each point
end

% find min and max values for bounds

maxval = max(mean_data);
minval = min(mean_data);

% for default bounds2

if ~exist('bounds')
    bounds = [0 T floor(minval-1) ceil(maxval+1)];
end

%% Plotting

plot(t,mean_data(1,:),mean_settings{:}) % plot mean data set
for j = 1:length(data(:,1))
    hold on
    plot(t,data(j,:),data_settings{:}) % plot data sets
end
plot(t,mean_data(1,:),mean_settings{:}) % plot mean data set
axis(bounds)
ylabel(y_label)
xlabel(x_label)
legend('Mean','Data Trial')
end
