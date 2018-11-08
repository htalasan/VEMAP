function [E,S] = RMSError(Original_Signal, Reference_Signal)

% This function calculates the Variance and the Standard Deviation of a 
% function by comparing a specificed signal with a comparitive signal.

    for i = 1:length(Original_Signal)
%         step(i) = (abs(Original_Signal(i) - Reference_Signal(i)))^2;
        step(i) = (Original_Signal(i) - Reference_Signal(i))^2;
    end
    
    step2 = sum(step)/i;
    
    %S = std(abs(Original_Signal(i) - Reference_Signal(i)),0);
    S = std(step.^.5);
    E = (step2)^.5;
end