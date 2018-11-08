function Salus_DataLengthFix_1
% Program that takes the Salus Experiment data and cuts each individual
% movement into equal lengths
%%

% Get files... find only the .txt (raw data) files
[FileName,PathName] = ...
    uigetfile('','Select the raw data file','Data\Preprocessed','MultiSelect','on');
%%
if ischar(FileName) == 1
    
    load([PathName FileName])
    
    for i = 1:144 % cut the vergence eye movement data to a length of 1500
        RawData{i} = RawData{i}(1:6,1:1500);
    end
    
    for i = 145:224 % cut the saccade portion to a length of 750 points
        RawData{i} = RawData{i}(1:6,1:750);
    end
    
    save([PathName FileName])
    
else
    for j = 1:length(FileName)
        load([PathName FileName{j}])
        for i = 1:144 % cut the vergence eye movement data to a length of 1500
            RawData{i} = RawData{i}(1:6,1:1500);
        end
        
        for i = 145:224 % cut the saccade portion to a length of 750 points
            RawData{i} = RawData{i}(1:6,1:750);
        end
        
        save([PathName FileName{j}])
    end
    
end