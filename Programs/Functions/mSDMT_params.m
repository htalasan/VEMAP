function [output] = mSDMT_params(eye_data,saccade_thresh,row_name)
%% blink remover/ blink counter/ saccade counter

% Revision History
% 1.0   7/13/16      Release
x = EOMfilters(eye_data.horz_data',40,4);
y = EOMfilters(eye_data.vert_data',40,4);
z = row_name;
% output.(z) = params.(z);
% pupil = data.pupil_data; to be done later
x_vel = PositionToVelocity(x);
y_vel = PositionToVelocity(y);
%

if nargin < 2
    saccade_thresh = 100; % arbitrary saccade threshold
end

blink_threshold = 500; % notes: blink threshold is at 500 deg/s since
% saccades for 20 degree movements do not go above ~450 deg/s (see the
% eye_movement bible on saccade velocities vs. amplitude.

i = 1;
output.(z).saccade_count = 0;
output.(z).horz_saccade_count = 0;
output.(z).vert_saccade_count = 0;
output.(z).total_count = 0;
output.(z).saccade_velocities = [];
output.(z).blink_count = 0;
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
            output.(z).saccade_count = output.(z).saccade_count + 1;
            output.(z).vert_saccade_count = output.(z).vert_saccade_count + 1;
            output.(z).total_count = output.(z).total_count + 1;
            output.(z).saccade_velocities(1,output.(z).saccade_count) = x_vel(k+i-1);
            output.(z).saccade_velocities(2,output.(z).saccade_count) = y_vel(k+i-1);
            output.(z).saccade_indices(output.(z).saccade_count) = k+i-1;
            output.(z).vert_saccade_index(output.(z).vert_saccade_count) = k+1-1;
            output.(z).total_indices(output.(z).total_count) = k+i-1;
            i = i+50;
        else % these are blinks
            output.(z).blink_count = output.(z).blink_count + 1;
            output.(z).total_count = output.(z).total_count + 1;
            output.(z).total_indices(output.(z).total_count) = k+i-1;
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
            output.(z).saccade_count = output.(z).saccade_count + 1;
            output.(z).horz_saccade_count = output.(z).horz_saccade_count + 1;
            output.(z).total_count = output.(z).total_count + 1;
            output.(z).saccade_velocities(1,output.(z).saccade_count) = x_vel(k+i-1);
            output.(z).saccade_velocities(2,output.(z).saccade_count) = y_vel(k+i-1);
            output.(z).saccade_indices(output.(z).saccade_count) = k+i-1;
            output.(z).horz_saccade_index(output.(z).horz_saccade_count) = k+1-1;
            output.(z).total_indices(output.(z).total_count) = k+i-1;
            i = i+50;
        else % these are blinks
            output.(z).blink_count = output.(z).blink_count + 1;
            output.(z).total_count = output.(z).total_count + 1;
            output.(z).total_indices(output.(z).total_count) = k+i-1;
            i = i + 100;
            
        end
    else % no saccades have been found
        i = i+1;
    end
 
end

% calculating the velocities
output.(z).saccade_velocities_magnitude = zeros(1,output.(z).saccade_count);
for i = 1:output.(z).saccade_count
    output.(z).saccade_velocities_magnitude(i) = sqrt(output.(z).saccade_velocities(1,i)^2 ...
        + output.(z).saccade_velocities(2,i)^2); % maths
end

% figuring out fixation times
output.(z).fixation_times = zeros(1,output.(z).saccade_count);
output.(z).saccade_times = output.(z).saccade_indices*0.002;
output.(z).fixation_times(1) = output.(z).saccade_times(1); % initialize
for i = 2:length(output.(z).saccade_indices)
    output.(z).fixation_times(i) = output.(z).saccade_times(i) ...
        - output.(z).saccade_times(i-1);
end

output.(z).total_fixation_times = zeros(1,output.(z).total_count);
output.(z).total_times = output.(z).total_indices*0.002;
output.(z).total_fixation_times(1) = output.(z).total_times(1); % initialize
for i = 2:length(output.(z).total_indices)
    output.(z).total_fixation_times(i) = output.(z).total_times(i) ...
        - output.(z).total_times(i-1);
end


% figure out fixation points

% get the average x and y coordinates between the saccades
output.(z).fixation_points(1,1) = nanmean(x(1:output.(z).saccade_indices(1)-10));
output.(z).fixation_points(2,1) = nanmean(y(1:output.(z).saccade_indices(1)-10));

for i = 2:output.(z).saccade_count
    output.(z).fixation_points(1,i) = ...
        nanmean(x(output.(z).saccade_indices(i-1)+10:output.(z).saccade_indices(i)-10));
    output.(z).fixation_points(2,i) = ...
        nanmean(y(output.(z).saccade_indices(i-1)+10:output.(z).saccade_indices(i)-10));
end

output.(z).total_fixation_points(1,1) = nanmean(x(1:output.(z).total_indices(1)-10));
output.(z).total_fixation_points(2,1) = nanmean(y(1:output.(z).total_indices(1)-10));

for i = 2:output.(z).saccade_count
    output.(z).total_fixation_points(1,i) = ...
        nanmean(x(output.(z).total_indices(i-1)+10:output.(z).total_indices(i)-10));
    output.(z).total_fixation_points(2,i) = ...
        nanmean(y(output.(z).total_indices(i-1)+10:output.(z).total_indices(i)-10));
end

% figuring out amplitudes

% saccade_amplitude;
%
% plotting for plots sake
% figure
% plot(row1)
% hold on
% plot(row1_horz)
% for i = 1:length(saccade_indices)
%     plot([saccade_indices(i) saccade_indices(i)],[-100000 100000],'r')
%
% end
% axis([0 14000 -30 30])

% figure
% hold on
% % plot(x,y)
% for i = 1:saccade_count
% plot(fixation_points(1,i),fixation_points(2,i),'o','markersize',...
%     fixation_times(i)*15,'color',[.3+.5*(i/total_count) 0 0])
% end
%
% axis([-15 15 -15 15])
%
% figure
% hold on
% a = imread('SDMT1.jpg');imagesc([-10 13],[-12 10],a);
% colormap(gray)
% alpha .3
% plot(x,y-2.5,'g')
% alpha .5
% for i = 1:saccade_count
% plot(total_fixation_points(1,i),total_fixation_points(2,i)-2.5,'o','markersize',...
%     total_fixation_times(i)*20,'color',[0 0+.8*(i/total_count) 0],...
%     'linewidth',2)
% end
%
% axis([-15 15 -15 15])
%
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


