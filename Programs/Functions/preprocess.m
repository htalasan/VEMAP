function preprocess_VEMAP(caliblength)

% Matt
% Edited by: Henry Talasan & Chang Yaramothu
%
% Summary of Routine:
%  1) Data importing 2) Removal of strings 3) Defining data chunks by index
%  4) Seperation of calibration data and data to be analyzed (assuming
%  calibration data is of a certain length and is always less than analysis
%  data)
%  This function saves data set as TBD 


if nargin < 1
    caliblength = 500; % default calibration size
end
% Get files... find only the .txt (raw data) files
[FileName,PathName] = ...
    uigetfile('*.txt*','Select the raw data file',(''),'MultiSelect','on');

PathName
% 
% if ischar(FileName) == 1
%     
%     % A versatile import command for many applications.  In our case, we
%     % are simply importing the data, replacing all strings with NAN.  This
%     % is achieved by placing the 0.
%     [data] = txt2mat([PathName,FileName],0);
%     % a command which looks for all NaN values, and returns an array
%     % containing 1 or 0 depending upon the status.  For example, if we
%     % were to have the array A = [1 4 NaN 3 NaN NaN], isnan(A) would
%     % return [0 0 1 0 1 1].
%     NanInd = isnan(data(:,1));
%     % Find looks for each value which fits the criteria, and returns
%     % the index.
%     %  For our example, find(isnan(A)) would return [3 5 6].
%     x = find(NanInd == 1);
%     nanbeg2 = [];
%     nanend2 = [];
%     % This loop searches for portions where NaN is seperated by more
%     % than two real numbers.  In our data, the only place this happens
%     % is in actual data we need to use.
%     for i =2:length(x)
%         if x(i) - x(i-1) > 2
%             nanbeg = x(i-1)+1;
%             nanbeg2 = [nanbeg2;nanbeg];
%             nanend = x(i)-1;
%             nanend2 = [nanend2;nanend];
%         end
%     end
%     
%     % This loop simply determines if the chunk of data is calibration
%     % or actual data.  It does so by looking at the length of the data.
%     % If the length is more than caliblength (in our case, most eye
%     % data is at least 1000 in length), it is designated as data2exp.
%     % If it is less than caliblength + 1, it is designated as
%     % data2calib.
%     tmp = [nanbeg2,nanend2];
%     CalibInd = 1;
%     ExpInd = 1;
%     for i = 1:length(tmp)
%         tmp = data(nanbeg2(i):nanend2(i));
%         
%         
%         % calibration data length
%         if length(tmp) > caliblength + 1
%             data2calib(CalibInd,:) = tmp;
%             CalibInd = CalibInd+1;
%         else
%             data2exp{ExpInd} = tmp;
%             ExpInd = ExpInd+1;
%         end
%     end
%     
%     % The following breaks up the total data into individual cells on a
%     % trial by trial basis.
%     
%     Data2calibSize = size(data2calib);
%     j=1;
%     for i = 1:6:Data2calibSize(1)
%         data3calib{j} = data2calib(i:i+5,:);
%         j=j+1;
%     end
%     
%     Data2expSize = size(data2exp);
%     j=1;
%     for i = 1:6:Data2expSize(2)
%         data3exp{j}(1,:) = data2exp{i};
%         data3exp{j}(2,:) = data2exp{i+1};
%         data3exp{j}(3,:) = data2exp{i+2};
%         data3exp{j}(4,:) = data2exp{i+3};
%         data3exp{j}(5,:) = data2exp{i+4};
%         data3exp{j}(6,:) = data2exp{i+5};
%         j=j+1;
%     end
%     
%     CalData = data3exp;
%     RawData = data3calib;
%     
%     
%     save([FileName(1:end-4)],'RawData','CalData')
%     
%     
% else
%     
%     for filei = 1:length(FileName)
%         
%         
%         [data] = txt2mat([PathName,FileName{filei}],0);
%         NanInd = isnan(data(:,1));
%         
%         x = find(NanInd == 1);
%         nanbeg2 = [];
%         nanend2 = [];
%         
%         for i =2:length(x)
%             if x(i) - x(i-1) > 2
%                 nanbeg = x(i-1)+1;
%                 nanbeg2 = [nanbeg2;nanbeg];
%                 nanend = x(i)-1;
%                 nanend2 = [nanend2;nanend];
%             end
%         end
%         
%         tmp = [nanbeg2,nanend2];
%         CalibInd = 1;
%         ExpInd = 1;
%         for i = 1:length(tmp)
%             tmp = data(nanbeg2(i):nanend2(i));
%             
%             
%             % calibration data length
%             if length(tmp) > caliblength + 1
%                 data2calib(CalibInd,:) = tmp;
%                 CalibInd = CalibInd+1;
%             else
%                 data2exp{ExpInd} = tmp;
%                 ExpInd = ExpInd+1;
%             end
%         end
%         
%         Data2calibSize = size(data2calib);
%         j=1;
%         for i = 1:6:Data2calibSize(1)
%             data3calib{j} = data2calib(i:i+5,:);
%             j=j+1;
%         end
%         
%         Data2expSize = size(data2exp);
%         j=1;
%         for i = 1:6:Data2expSize(2)
%             data3exp{j}(1,:) = data2exp{i};
%             data3exp{j}(2,:) = data2exp{i+1};
%             data3exp{j}(3,:) = data2exp{i+2};
%             data3exp{j}(4,:) = data2exp{i+3};
%             data3exp{j}(5,:) = data2exp{i+4};
%             data3exp{j}(6,:) = data2exp{i+5};
%             j=j+1;
%         end
%         
%         CalData = data3exp;
%         RawData = data3calib;
%         
%         save(FileName{filei}(1:end-4),'RawData','CalData')
%         
%     end
%     
% end