function pupil_cal
% calibrate the measurements of the pupil size
%%
% Get raw data file for pupil calibration
[FileName,PathName] = ...
    uigetfile('*.txt*','Select the preprocessed calibration file','','MultiSelect','off');

if FileName==0
    return
end

load([PathName FileName]);
%% Get Cal Values

CalData_L = CalData(6:10);
CalData_R = CalData(1:5);
CalPoints_L = ([11.5 9.8 8.2 7.4 5.8]);
CalPoints_R = ([11.5 9.8 8.2 7.4 5.8]);
[p_L,p_R,r_L,r_R] = Pupil_Calibrate(CalData_L,CalData_R,CalPoints_L,CalPoints_R);

%% Save as Pupil_Calibration_DDMMYY