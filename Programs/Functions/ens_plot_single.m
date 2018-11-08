function ens_plot_single(data)
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
% 
% linewidth and colors can be changed in the plot function below
%%
data = unique(data,'rows');
figure
% default values
smoothing = 1;
x_spacing = 0;
y_spacing = 0;
bgcolor = [1 1 1];
beg_color = [.4 .4 .4];
end_color = [.4 .4 .4];

cla;
hold on; 

a = size(data);
T = length(data)/500;
t = 0.002:0.002:T; % time
j = 1;

for i = 1:a(1)
    tmp = data(i,:);
    tmp = tmp - mean(tmp(1:50));
    b = find(isnan(tmp));
    data1 = smooth(tmp,smoothing);
    c = (data1');
    c(b) = NaN;
    plot(t+(j-1)*(x_spacing),c-(j-1)*(y_spacing),...
        'Color',[beg_color(1)+(j-1)*(end_color(1)-beg_color(1))/(a(1))...
        beg_color(2)+(j-1)*(end_color(2)-beg_color(2))/(a(1))...
        beg_color(3)+(j-1)*(end_color(3)-beg_color(3))/(a(1))],...
        'linewidth',1)
%     beg_color(3)+(j-1)*(end_color(3)-beg_color(3))/(a(2))
    j = j + 1;
end

% title('Left Eye')
xlabel('Time')
ylabel('Angle (degrees)')
axis([0 .5 -100 300])
%% add mean
% comment this feature out if not wanted

% % find the mean of the data set
% % 
% for i = 1:a(2)
%     tmp(1,i) = nanmean(data(:,i))*-1;
% end
% 
% data1 = smooth(tmp,smoothing);
% data1(:) = data1(:)-mean(data1(1:50));
% plot(t,-1*(data1),'color',[0 0 1],'linewidth',3)
%%
ax = gca;
set(ax,'Color',bgcolor) % setting the background color