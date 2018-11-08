function ens_plot(data,mode,trial_num)
% % regular ensemble plots have x_spacing and y_spacing values of zero.
% % variables:
%         data: the data set to be used in the ensemble plot
%         trial_num: array of trial numbers to be used for the plot
%         mode: 'left' (left_eye), 'right' (right_eye), 'verg' (vergence), 'vers'
%         (version)
% variables to be changed in function:
%         smoothing: smoothing value
%         x_spacing: horizontal shift
%         y_spacing: vertical shift
%         bgcolor: background color
%         beg_color: beginning color val
%         end_color: ending color val

switch nargin %default values
    case 1        
        mode = 'verg';
        trial_num = 1:length(data);
    case 2
        trial_num = 1:length(data);
end

% default values
smoothing = 20;
x_spacing = 0;
y_spacing = 0;
bgcolor = [1 1 1];
beg_color = [.6 .6 .6];
end_color = [.6 .6 .6];


cla;
hold on;

a = size(data);

j = 1;

switch mode
    case 'left'
        for i = trial_num
            t = 0.002:0.002:length(data{i})/500; % time
            tmp = data{i}(2,:);
            tmp = tmp - mean(tmp(1:50));
            b = find(isnan(tmp));
            data1 = smooth(tmp,smoothing);
            c = data1';
            c(b) = NaN;
            plot(t+(j-1)*(x_spacing),c-(j-1)*(y_spacing),...
                'Color',[beg_color(1)+(j-1)*(end_color(1)-beg_color(1))/(a(2))...
                beg_color(2)+(j-1)*(end_color(2)-beg_color(2))/(a(2))...
                beg_color(3)+(j-1)*(end_color(3)-beg_color(3))/(a(2))],...
                'linewidth',2)
            j = j + 1;
        end
        title('Left Eye')
        xlabel('Time')
        ylabel('Angle (degrees)')
    case 'right'
        for i = trial_num
            t = 0.002:0.002:length(data{i})/500; % time
            tmp = data{i}(1,:);
            tmp = tmp - mean(tmp(1:50));
            b = find(isnan(tmp));
            data1 = smooth(tmp,smoothing);
            c = data1';
            c(b) = NaN;
            plot(t+(j-1)*(x_spacing),c-(j-1)*(y_spacing),...
                'Color',[beg_color(1)+(j-1)*(end_color(1)-beg_color(1))/(a(2))...
                beg_color(2)+(j-1)*(end_color(2)-beg_color(2))/(a(2))...
                beg_color(3)+(j-1)*(end_color(3)-beg_color(3))/(a(2))],...
                'linewidth',2)
            j = j + 1;
        end
        title('Right Eye')
        xlabel('Time')
        ylabel('Angle (degrees)')
    case 'verg'
        for i = trial_num
            t = 0.002:0.002:length(data{i})/500; % time
            tmp = data{i}(1,:) + data{i}(2,:);
            tmp = tmp - mean(tmp(1:50));
            b = find(isnan(tmp));
            data1 = smooth(tmp,smoothing);
            c = data1';
            c(b) = NaN;
            plot(t+(j-1)*(x_spacing),c-(j-1)*(y_spacing),...
                'Color',[beg_color(1)+(j-1)*(end_color(1)-beg_color(1))/(a(2))...
                beg_color(2)+(j-1)*(end_color(2)-beg_color(2))/(a(2))...
                beg_color(3)+(j-1)*(end_color(3)-beg_color(3))/(a(2))],...
                'linewidth',2)
            j = j + 1;
        end
        title('Vergence')
        xlabel('Time')
        ylabel('Angle (degrees)')
    case 'vers'
        for i = trial_num
            t = 0.002:0.002:length(data{i})/500; % time
            tmp = (data{i}(1,:) + data{i}(2,:))/2;
            tmp = tmp - mean(tmp(1:50));
            b = find(isnan(tmp));
            data1 = smooth(tmp,smoothing);
            c = data1';
            c(b) = NaN;
            plot(t+(j-1)*(x_spacing),c-(j-1)*(y_spacing),...
                'Color',[beg_color(1)+(j-1)*(end_color(1)-beg_color(1))/(a(2))...
                beg_color(2)+(j-1)*(end_color(2)-beg_color(2))/(a(2))...
                beg_color(3)+(j-1)*(end_color(3)-beg_color(3))/(a(2))],...
                'linewidth',2)
            j = j + 1;
        end
        title('Version')
        xlabel('Time')
        ylabel('Angle (degrees)')
end

ax = gca;
set(ax,'Color',bgcolor) % setting the background color