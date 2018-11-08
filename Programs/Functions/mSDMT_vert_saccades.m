function [output, data_blinks_removed] = mSDMT_vert_saccades(eye_data,row_name,params)
% This function allows the user to manually select vertical saccadic data
% and blinks from the mSDMT experiment

% Rev History

% 1.0   ????        Release
% 1.1   9/28/2016   Added abilty to input values greater than the length of
%                   the data set and values less than 1
%%
s = 1;
x = EOMfilters(eye_data.horz_data',40,6);
y = EOMfilters(eye_data.vert_data',40,6);
x = smooth(x,s);
y = smooth(y,s);
x_vel = PositionToVelocity(x);
y_vel = PositionToVelocity(y);
z = row_name;
y_drift = eye_data.drift_control.vert;
output = params;
output.vert_sacc = 1;
output.saccade2key.count = 0;
output.saccade2line.count = 0;
output.blinks.count = 0;
% output = rmfield(output,'saccade2key');
% output = rmfield(output,'saccade2line');
% % output = rmfield(output,'blinks');
% output.saccade2key = [];
% output.saccade2line = [];
% output.blinks = [];

type = {'saccade2key' 'saccade2line' 'blinks'};
figure('units','normalized','outerposition',[0 0 1 1])
i = 1; % initialize
while i < 4
    cla
    hold on
    plot(y + y_drift)
    
    try
        for J = 1:length(true_index_history)
            true_index = true_index_history(J);
            plot([true_index true_index],[-100 100],'r')
        end
    catch
    end
    
    axis([0 length(y) -15 15])
    
    switch i
        case 1
            title('Choose saccade to KEY (upward) saccades (double click the outside right of the plot to finish)')
        case 2
            title('Choose saccade to LINE (downward) saccades (double click the outside right of the plot to finish)')
        case 3
            title('Any BLINKS? (double click the outside right of the plot to finish)')
    end
    
    [a] = ginput(2);
    pt1 = ceil(a(1));
    pt2 = ceil(a(2));
    try
        if a(1) > length(y) && a(2) > length(y) % next case
            i = i +1;
            clear true_index_history % reset index history
        elseif a(1) < 1 && a(2) < 1 % made a mistake and want to go back
            true_index_history(output.(type{i}).count) = []; % clears the prev val
            output.(type{i}).count = output.(type{i}).count - 1; % decrease count
            
        else
            output.(type{i}).count = output.(type{i}).count + 1; % increase count
            if pt1 < 1
                pt1 = 1;
            end
            
            if pt2 > length(y)
                pt2 = length(y);
            end
            
            if (i == 1 || i == 2) % saccade algorithm
                [~,index] = max(abs(y_vel(pt1:pt2))); % finding max velocity of given points
                true_index = index + pt1; % true index of max velocity
                output.(type{i}).indices(output.(type{i}).count) = true_index;
                
                output.(type{i}).velocities(output.(type{i}).count) = ... % find velocity
                    sqrt(abs(x_vel(true_index))^2 + abs(y_vel(true_index))^2);
                
                output.(type{i}).amplitudes(output.(type{i}).count) = ... % amplitudes
                    sqrt((y(pt1)-y(pt2))^2 + (x(pt1)-x(pt2))^2);
                
                true_index_history(output.(type{i}).count) = true_index;
            else % blinks
                
                output.(type{i}).blink_indices(output.(type{i}).count,1) = pt1;
                output.(type{i}).blink_indices(output.(type{i}).count,2) = pt2;
            end
            
        end
    catch
    end
    
    %     close;
    
end
% key_count = output.saccade2key.count;
% line_count = output.saccade2line.count;
% 
% %
% combined_saccade_velocities =  [output.saccade2key.velocities(1:key_count) ...
%     output.saccade2line.velocities(1:line_count)];
% k = 0;
% for i = 1:length(combined_saccade_velocities) % remove blinks and such
%     if combined_saccade_velocities(i) < 500 && combined_saccade_velocities(i) > 100
%         flt_combined_saccade_velocities(k) = combined_saccade_velocities(i);
%         k = k+1;
%     end
% end
% output.avg_saccade_velocity(1) = mean(flt_combined_saccade_velocities);
% output.avg_saccade_velocity(2) = std(flt_combined_saccade_velocities);
%     output.key_fixation_time =
%     output.line_fixation_time =

data_blinks_removed.horz_data = x;
data_blinks_removed.vert_data = y;

% remove the blinks
try % just in case there are no blinks
    for i = 1:output.blinks.count
        pt1 = output.blinks.blink_indices(i,1);
        pt2 = output.blinks.blink_indices(i,2);
        data_blinks_removed.horz_data(pt1:pt2) = nan;
        data_blinks_removed.vert_data(pt1:pt2) = nan;
    end
catch
end


close
%% plot
% T = length(y)/500;
% t = 0.002:0.002:T;
% figure
% hold on
% plot(t,data_blinks_removed.vert_data+y_drift,'linewidth',2)
% axis([0 T -15 15])
%
% plot([output.saccade2key.indices(1)/500 output.saccade2key.indices(1)/500],[-100 100],'r')
% plot([output.saccade2line.indices(1)/500 output.saccade2line.indices(1)/500],[-100 100],'g')
%
% for i = 2:output.saccade2key.count
%     plot([output.saccade2key.indices(i)/500 output.saccade2key.indices(i)/500],[-100 100],'r')
% end
%
% for i = 2:output.saccade2line.count
%     plot([output.saccade2line.indices(i)/500 output.saccade2line.indices(i)/500],[-100 100],'g')
% end
%
% legend('Vertical Eye Movement','Saccade to Key','Saccade to Lines')
