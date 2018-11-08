function e = findclasses(tmp)
% find and list all the categories in the data structure

e = tmp(1).classifications; % initialize categories
for i = 2:length(tmp)
    e = [e;tmp(i).classifications];
    e = unique(e);
end