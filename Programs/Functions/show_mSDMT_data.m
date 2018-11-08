function data_table = show_mSDMT_data(params,row)
% disp(params)
% % data that needs to be shown:
% 
% - # of saccades to key/line
% - Average Velocity
% - Average Amplitude
% - Key Fixation Time
% - Line Fixation Time
% - Completion Time
% - Accuracy
% - # of blinks

num_sacc_key = params.(row).saccade2key.count;
num_sacc_line = params.(row).saccade2line.count;
% includes blinks that made the saccade

num_blinks = params.(row).blinks.count;

% average_velocity
velo_comb = [params.(row).saccade2key.velocities(1:num_sacc_key) ...
    params.(row).saccade2line.velocities(1:num_sacc_line)];

k = 1;
for i = 1:length(velo_comb)
    if velo_comb(i) < 500 % blink filterer
        velo_comb1(k) = velo_comb(i);
        k = k+1;
    end
end

velocity_mean = mean(velo_comb1);
velocity_std = std(velo_comb1);


amplitudes = [params.(row).saccade2key.amplitudes(1:num_sacc_key)...
    params.(row).saccade2line.amplitudes(1:num_sacc_line)];

amplitudes_mean = mean(abs(amplitudes));
amplitudes_std = std(amplitudes);

% fixation_times

[line_fixation_time,key_fixation_time] = fixation_time_mSDMT(params.(row).saccade2line,...
    params.(row).saccade2key);

completion_time = params.(row).completion_time;

accuracy = params.(row).accuracy;

data_table{1} = completion_time;
data_table{2} = accuracy;
data_table{3} = num_sacc_key + num_sacc_line; % number of saccades
data_table{4} = num_blinks;
data_table{5} = velocity_mean; % average velocity
data_table{6} = velocity_std;
data_table{7} = amplitudes_mean; % average amplitude
data_table{8} = amplitudes_std;
data_table{9} = line_fixation_time.mean;
data_table{10} = key_fixation_time.mean;



% 
% uitable('data',data_table,'ColumnName',{'Number of Saccades',...
%     'Mean Velocity', 'Mean Amplitude', 'Fixation Time (Line)', ...
%     'Fixation Time (Key)', 'Completion Time', 'Accuracy', ...
%     'Number of Blinks'},'Position',[100 100 1000 150]);

