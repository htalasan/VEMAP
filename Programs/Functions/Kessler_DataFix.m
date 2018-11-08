function RawData = Kessler_DataFix(RawData)
% Splits movement into two: initial movement and return movement.
nogap = [2 5 7 10];
gap = [3 6 9 12];
overlap = [1 4 8 11];

for i = 2:10
    a = [2+12*(i-1) 5+12*(i-1) 7+12*(i-1) 10+12*(i-1)];
    b = [3+12*(i-1) 6+12*(i-1) 9+12*(i-1) 12+12*(i-1)];
    c = [1+12*(i-1) 4+12*(i-1) 8+12*(i-1) 11+12*(i-1)];
    
    gap = [gap b];
    nogap = [nogap a];
    overlap = [overlap c];
end

%%
k = 1;

for i = 1:length(RawData)
    
    if intersect(gap,i) == i
%         disp('gap')
        new_data{k} = RawData{i}(1:6,100:750);
        k = k+1;
        new_data{k} = RawData{i}(1:6,1051:1700);
        k = k+1;
    elseif intersect(nogap,i) == i
%         disp('nogap')
        new_data{k} = RawData{i}(1:6,1:750);
        k = k+1;
        new_data{k} = RawData{i}(1:6,851:1600);
        k = k+1;
    elseif intersect(overlap,i) == i
%         disp('overlap')
        new_data{k} = RawData{i}(1:6,1:750);
        k = k+1;
        new_data{k} = RawData{i}(1:6,751:1500);
        k = k+1;
    end
end
%%
RawData = new_data;