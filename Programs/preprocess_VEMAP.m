function preprocess_VEMAP
% Matt
% Edited by: Henry Talasan & Chang Yaramothu
%
% Summary of Routine:
%  1) Data importing 2) Removal of strings 3) Defining data chunks by index
%  4) Seperation of calibration data and data to be analyzed (assuming
%  calibration data is of a certain length and is always less than analysis
%  data)
%  This function saves data set as TBD

% Rev History
% 1.0   02/26/16    Release
% 1.1   06/07/16    Fix for if there is no RawData or CalData (doesn't work
%                   for CalData, but whatever...)

%%
load('preprocess_settings')

caliblength = preprocess_settings.caliblength;
rawpath = 'Data\Raw\';
preprocessedpath = 'Data\Preprocessed\';

% Get files... find only the .txt (raw data) files
[FileName,PathName] = ...
    uigetfile('*.txt*','Select the raw data file',(rawpath),'MultiSelect','on');


%%
if ischar(FileName) == 1
    
    % A versatile import command for many applications.  In our case, we
    % are simply importing the data, replacing all strings with NAN.  This
    % is achieved by placing the 0.
    [data] = txt2mat([PathName,FileName],0);
    % a command which looks for all NaN values, and returns an array
    % containing 1 or 0 depending upon the status.  For example, if we
    % were to have the array A = [1 4 NaN 3 NaN NaN], isnan(A) would
    % return [0 0 1 0 1 1].
    NanInd = isnan(data(:,1));
    % Find looks for each value which fits the criteria, and returns
    % the index.
    %  For our example, find(isnan(A)) would return [3 5 6].
    x = find(NanInd == 1);
    nanbeg2 = [];
    nanend2 = [];
    % This loop searches for portions where NaN is seperated by more
    % than two real numbers.  In our data, the only place this happens
    % is in actual data we need to use.
    for i =2:length(x)
        if x(i) - x(i-1) > 2
            nanbeg = x(i-1)+1;
            nanbeg2 = [nanbeg2;nanbeg];
            nanend = x(i)-1;
            nanend2 = [nanend2;nanend];
        end
    end
    
    % This loop simply determines if the chunk of data is calibration
    % or actual data.  It does so by looking at the length of the data.
    % If the length is more than caliblength (in our case, most eye
    % data is at least 1000 in length), it is designated as data2exp.
    % If it is less than caliblength + 1, it is designated as
    % data2calib.
    tmp = [nanbeg2,nanend2];
    CalibInd = 1;
    ExpInd = 1;
    for i = 1:length(tmp)
        tmp = data(nanbeg2(i):nanend2(i));
        
        
        % calibration data length
        if length(tmp) == caliblength
            data2calib(CalibInd,:) = tmp;
            CalibInd = CalibInd+1;
        else
            data2exp{ExpInd} = tmp;
            ExpInd = ExpInd+1;
        end
    end
    
    % The following breaks up the total data into individual cells on a
    % trial by trial basis.
    
    try
        Data2calibSize = size(data2calib);
        j=1;
        for i = 1:6:Data2calibSize(1)
            data3calib{j} = data2calib(i:i+5,:);
            j=j+1;
        end
    catch
    end
    
    try
        Data2expSize = size(data2exp);
        j=1;
        for i = 1:6:Data2expSize(2)
            data3exp{j}(1,:) = data2exp{i};
            data3exp{j}(2,:) = data2exp{i+1};
            data3exp{j}(3,:) = data2exp{i+2};
            data3exp{j}(4,:) = data2exp{i+3};
            data3exp{j}(5,:) = data2exp{i+4};
            data3exp{j}(6,:) = data2exp{i+5};
            j=j+1;
        end
    catch
    end
    
    try
        RawData = data3exp;
    catch
    end
    
    try
        CalData = data3calib;
    catch
    end
    
    try
        if preprocess_settings.salus == 1
            RawData = Salus_DataLengthFix(RawData);
        elseif preprocess_settings.kessler == 1
            RawData = Kessler_DataFix(RawData);
        end
    catch
    end
    
    if exist('RawData','var') == 1 && exist('CalData','var') == 1
        save([preprocessedpath '\' FileName(1:end-4)],'RawData','CalData')
    elseif exist('RawData','var') == 0
        save([preprocessedpath '\' FileName(1:end-4)],'CalData')
    else
        save([preprocessedpath '\' FileName(1:end-4)],'RawData')
    end
    
%     save([preprocessedpath '\' FileName(1:end-4)],'RawData','CalData')
    
%%
elseif iscell(FileName) == 1
    
    for filei = 1:length(FileName)
        
        
        [data] = txt2mat([PathName,FileName{filei}],0);
        NanInd = isnan(data(:,1));
        
        x = find(NanInd == 1);
        nanbeg2 = [];
        nanend2 = [];
        
        for i =2:length(x)
            if x(i) - x(i-1) > 2
                nanbeg = x(i-1)+1;
                nanbeg2 = [nanbeg2;nanbeg];
                nanend = x(i)-1;
                nanend2 = [nanend2;nanend];
            end
        end
        
        tmp = [nanbeg2,nanend2];
        CalibInd = 1;
        ExpInd = 1;
        for i = 1:length(tmp)
            tmp = data(nanbeg2(i):nanend2(i));
            
            
            % calibration data length
            if length(tmp) == caliblength
                data2calib(CalibInd,:) = tmp;
                CalibInd = CalibInd+1;
            else
                data2exp{ExpInd} = tmp;
                ExpInd = ExpInd+1;
            end
        end
        
        try
            Data2calibSize = size(data2calib);
            j=1;
            for i = 1:6:Data2calibSize(1)
                data3calib{j} = data2calib(i:i+5,:);
                j=j+1;
            end
        catch
        end
        
        try
            Data2expSize = size(data2exp);
            j=1;
            for i = 1:6:Data2expSize(2)
                data3exp{j}(1,:) = data2exp{i};
                data3exp{j}(2,:) = data2exp{i+1};
                data3exp{j}(3,:) = data2exp{i+2};
                data3exp{j}(4,:) = data2exp{i+3};
                data3exp{j}(5,:) = data2exp{i+4};
                data3exp{j}(6,:) = data2exp{i+5};
                j=j+1;
            end
        catch
        end
        
        try
            RawData = data3exp;
        catch
        end
        
        try
            CalData = data3calib;
        catch
        end
        
        try
            if preprocess_settings.salus == 1
                RawData = Salus_DataLengthFix(RawData);
            elseif preprocess_settings.kessler == 1
                RawData = Kessler_DataFix(RawData);
            end
        catch
        end
        
        if exist('RawData','var') == 1 && exist('CalData','var') == 1
            save([preprocessedpath '\' FileName{filei}(1:end-4)],'RawData','CalData')
        elseif exist('RawData','var') == 0
            save([preprocessedpath '\' FileName{filei}(1:end-4)],'CalData')
        else
            save([preprocessedpath '\' FileName{filei}(1:end-4)],'RawData')
        end
        
        clear data2exp data3exp
    end
    
end