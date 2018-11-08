function RawData = Salus_DataLengthFix(RawData)
% Program that takes the Salus Experiment data and cuts each individual
% movement into equal lengths
%%
for i = 1:144 % cut the vergence eye movement data to a length of 1500
    
    RawData{i} = RawData{i}(1:6,1:1500);
    
end

for i = 145:224 % cut the saccade portion to a length of 750 points
    
    RawData{i} = RawData{i}(1:6,1:750);
    
end