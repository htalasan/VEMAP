function [p_L,p_R,r_L,r_R] = Pupil_Calibrate(CalData_L,CalData_R,CalPoints_L,CalPoints_R)

% Henry Talasan     VNEL    11/06/2014
%
% This function uses Mat's original calibration code to get the
% calibration fit to be applied to the Data.
%
% CalPoints is an array of the calibration points used and in the order
% they are used.
%   CalPoints = [cal1 cal2 cal3];
%
% Data should be a cell structure containing the trials for the
% calibration.
%   Data = CalData1(1:3);

color = {'b' 'g' 'r' 'y' 'k' 'bl'};
ReselectCalibMean = 0;
hFig=figure;
screen_size = get(0, 'ScreenSize');
set(hFig,'Position',[0 0 screen_size(3) screen_size(4)]);
LEpt1 = 1; LEpt2 = 500;
REpt1 = 1; REpt2 = 500;

while ReselectCalibMean ~= 3
    
    % Left Eye
    CalibSP1 = subplot(2,2,1);
    hold on
    for i = 1:length(CalData_L)
        plot(CalData_L{i}(4,:),color{i})
    end
    title('Left Eye Pupil Diameter')
    ylim([-5 5])
    ylabel('Volts')
    xlabel('Samples')
    
    % Right Eye
    CalibSP2 = subplot(2,2,2);
    hold on
    for i = 1:length(CalData_R)
        plot(CalData_R{i}(6,:),color{i})
    end
    title('Right Eye Pupil Diameter')
    ylim([-5 5])
    ylabel('Volts')
    xlabel('Samples')
    
    subplot(2,2,3)
    cla
    
    for i = 1:length(CalData_L)
        LE_MeanCalibVolts(1,i) = mean(CalData_L{i}(4,LEpt1:LEpt2));
    end
    
    [LE_R,LE_PVAL] = corrcoef(LE_MeanCalibVolts(1,:),CalPoints_L);
    LE_CorrCoef(1,:) = LE_R(1,2);
    LE_CalibFit(1,:) = polyfit(LE_MeanCalibVolts(1,:),CalPoints_L,1);
    f = polyval(LE_CalibFit(1,:),LE_MeanCalibVolts(1,:));
    
    plot(LE_MeanCalibVolts(1,:),CalPoints_L);
    hold on
    plot(LE_MeanCalibVolts(1,:),f,'r');
    R = mat2str(LE_CorrCoef(1));
    m = mat2str(LE_CalibFit(1,1));
    b = mat2str(LE_CalibFit(1,2));
    title({['R^2 = ',R(1:5),'        y = ',...
        m(1:4),'x + ',b(1:4)]})
    ylabel('Diameter (mm)')
    xlabel('Volts')
    
    % Right Eye
    subplot(2,2,4)
    cla
    
    for i = 1:length(CalData_L)
        RE_MeanCalibVolts(1,i) = mean(CalData_R{i}(6,REpt1:REpt2));
    end
    
    [RE_R,RE_PVAL] = corrcoef(RE_MeanCalibVolts(1,:),CalPoints_R);
    RE_CorrCoef(1,:) = RE_R(1,2);
    RE_CalibFit(1,:) = polyfit(RE_MeanCalibVolts(1,:),CalPoints_R,1);
    f = polyval(RE_CalibFit(1,:),RE_MeanCalibVolts(1,:));
    
    plot(RE_MeanCalibVolts(1,:),CalPoints_R);
    hold on
    plot(RE_MeanCalibVolts(1,:),f,'r');
    R = mat2str(RE_CorrCoef(1));
    m = mat2str(RE_CalibFit(1,1));
    b = mat2str(RE_CalibFit(1,2));
    title({['R^2 = ',R(1:5),'        y = ',...
        m(1:4),'x + ',b(1:4)]})
    ylabel('Diameter (mm)')
    xlabel('Volts')
    
    
    % Menu
    ReselectCalibMean = menu('Reselect data to calculate calibration mean',...
        'Left Eye','Right Eye','Done');
    
    if ReselectCalibMean == 1
        %             gcf(CalibSP1)
        [TmpX,TmpY] = ginput(2);
        LEpt1= round(TmpX(1));
        LEpt2= round(TmpX(2));
    elseif ReselectCalibMean == 2
        %             gcf(CalibSP2)
        [TmpX,TmpY] = ginput(2);
        REpt1= round(TmpX(1));
        REpt2= round(TmpX(2));
    end
    
    
    %     if strcmp(CalibOption,'Type') == 1
    %         if ReselectCalibMean == 1
    %             TmpX = inputdlg('Input new range for calibration','New Calibration Range');
    %             TmpX = str2num(TmpX{:});
    %             LEpt1= TmpX(1);
    %             LEpt2= TmpX(2);
    %         end
    %
    %         if ReselectCalibMean == 2
    %             TmpX = inputdlg('Input new range for calibration','New Calibration Range');
    %             TmpX = str2num(TmpX{:});
    %             REpt1= TmpX(1);
    %             REpt2= TmpX(2);
    %         end
    %     end
end

% Output Data
p_L = LE_CalibFit;
p_R = RE_CalibFit;
r_L = LE_CorrCoef';
r_R = RE_CorrCoef';

close
