function mSDMT_bubble(eye_data,row_name,saccade_thresh)
%% blink remover/ blink counter/ saccade counter

% Revision History
% 1.0   7/13/16      Release
z = row_name;

x = EOMfilters(eye_data.(z).horz_data',40,4);
y = EOMfilters(eye_data.(z).vert_data',40,4);

x = x + eye_data.(z).drift_control.horz;
y = y + eye_data.(z).drift_control.vert;

% output.(z) = params.(z);
% pupil = data.pupil_data; to be done later
x_vel = PositionToVelocity(x);
y_vel = PositionToVelocity(y);
%

if nargin < 3
    saccade_thresh = 100; % arbitrary saccade threshold
end

blink_threshold = 500; % notes: blink threshold is at 500 deg/s since
% saccades for 20 degree movements do not go above ~450 deg/s (see the
% eye_movement bible on saccade velocities vs. amplitude.

i = 1;
saccade_count = 0;
horz_saccade_count = 0;
vert_saccade_count = 0;
total_count = 0;
saccade_velocities = [];
blink_count = 0;
n = 20;
  
while i < length(x_vel)
    
    
    if abs(y_vel(i))>saccade_thresh % vertical movements
%         abs(y_vel(i))
        % find the local maximum
        if i+n>length(y_vel)
            range = i:length(y_vel);
        else
            range = i:i+20;
        end
        tmp = abs(y_vel);
        [vel,k] = max(tmp(range));
        
        if vel<blink_threshold % these are saccades
            saccade_count = saccade_count + 1;
            vert_saccade_count = vert_saccade_count + 1;
            total_count = total_count + 1;
            saccade_velocities(1,saccade_count) = x_vel(k+i-1);
            saccade_velocities(2,saccade_count) = y_vel(k+i-1);
            saccade_indices(saccade_count) = k+i-1;
            vert_saccade_index(vert_saccade_count) = k+1-1;
            total_indices(total_count) = k+i-1;
            i = i+50;
        else % these are blinks
            blink_count = blink_count + 1;
            total_count = total_count + 1;
            total_indices(total_count) = k+i-1;
            i = i + 100;
            
        end
        
    elseif abs(x_vel(i))>saccade_thresh % find a fast movement for horizontal movements
%         abs(x_vel(i))
        % find the local maximum
        if i+n>length(x_vel) % horizontal movements
            range = i:length(x_vel);
        else
            range = i:i+20;
        end
        tmp = abs(x_vel);
        [vel,k] = max(tmp(range));
        
        if vel<blink_threshold % these are saccades
            saccade_count = saccade_count + 1;
            horz_saccade_count = horz_saccade_count + 1;
            total_count = total_count + 1;
            saccade_velocities(1,saccade_count) = x_vel(k+i-1);
            saccade_velocities(2,saccade_count) = y_vel(k+i-1);
            saccade_indices(saccade_count) = k+i-1;
            horz_saccade_index(horz_saccade_count) = k+1-1;
            total_indices(total_count) = k+i-1;
            i = i+50;
        else % these are blinks
            blink_count = blink_count + 1;
            total_count = total_count + 1;
            total_indices(total_count) = k+i-1;
            i = i + 100;
            
        end
    else % no saccades have been found
        i = i+1;
    end
 
end


% figuring out fixation times
fixation_times = zeros(1,saccade_count);
saccade_times = saccade_indices*0.002;
fixation_times(1) = saccade_times(1); % initialize
for i = 2:length(saccade_indices)
    fixation_times(i) = saccade_times(i) ...
        - saccade_times(i-1);
end

total_fixation_times = zeros(1,total_count);
total_times = total_indices*0.002;
total_fixation_times(1) = total_times(1); % initialize
for i = 2:length(total_indices)
    total_fixation_times(i) = total_times(i) ...
        - total_times(i-1);
end


% figure out fixation points

% get the average x and y coordinates between the saccades
fixation_points(1,1) = nanmean(x(1:saccade_indices(1)-10));
fixation_points(2,1) = nanmean(y(1:saccade_indices(1)-10));

for i = 2:saccade_count
    fixation_points(1,i) = ...
        nanmean(x(saccade_indices(i-1)+10:saccade_indices(i)-10));
    fixation_points(2,i) = ...
        nanmean(y(saccade_indices(i-1)+10:saccade_indices(i)-10));
end

total_fixation_points(1,1) = nanmean(x(1:total_indices(1)-10));
total_fixation_points(2,1) = nanmean(y(1:total_indices(1)-10));

for i = 2:saccade_count
    total_fixation_points(1,i) = ...
        nanmean(x(total_indices(i-1)+10:total_indices(i)-10));
    total_fixation_points(2,i) = ...
        nanmean(y(total_indices(i-1)+10:total_indices(i)-10));
end

% figure

for i = 1:saccade_count
    switch z
        case 'row1'
            plot(total_fixation_points(1,i),total_fixation_points(2,i),'o','markersize',...
                total_fixation_times(i)*20,'color',[0 0 0+.8*(i/total_count)],...
                'linewidth',2)
        case 'row2'
            plot(total_fixation_points(1,i),total_fixation_points(2,i),'o','markersize',...
                total_fixation_times(i)*20,'color',[0 0+.8*(i/total_count) 0],...
                'linewidth',2)
        case 'row3'
            plot(total_fixation_points(1,i),total_fixation_points(2,i),'o','markersize',...
                total_fixation_times(i)*20,'color',[0+.8*(i/total_count) 0 0],...
                'linewidth',2)
        case 'row4'
            plot(total_fixation_points(1,i),total_fixation_points(2,i),'o','markersize',...
                total_fixation_times(i)*20,'color',[0+.8*(i/total_count) 0 0+.8*(i/total_count)],...
                'linewidth',2)
        case 'row5'
            plot(total_fixation_points(1,i),total_fixation_points(2,i),'o','markersize',...
                total_fixation_times(i)*20,'color',[0+.8*(i/total_count) 0+.8*(i/total_count) 0+.8*(i/total_count)],...
                'linewidth',2)
    end
end

axis([-15 15 -15 15])





% figure
% hold on
% a = imread('SDMT1.jpg');imagesc([-10 13],[-12 10],a);
% colormap(gray)
% alpha .3
% % plot(x,y-1.5)
% alpha .5
% for i = 1:saccade_count
% plot(total_fixation_points(1,i),total_fixation_points(2,i)-2.5,'o','markersize',...
%     total_fixation_times(i)*20,'color',[0 0+.8*(i/total_count) 0],...
%     'linewidth',2)
% end
%
% axis([-15 15 -15 15])


%%


