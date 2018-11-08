function varargout = mSDMT_gui(varargin)
% MSDMT_GUI MATLAB code for mSDMT_gui.fig
%      MSDMT_GUI, by itself, creates a new MSDMT_GUI or raises the existing
%      singleton*.
%
%      H = MSDMT_GUI returns the handle to a new MSDMT_GUI or the handle to
%      the existing singleton*.
%
%      MSDMT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MSDMT_GUI.M with the given input arguments.
%
%      MSDMT_GUI('Property','Value',...) creates a new MSDMT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mSDMT_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mSDMT_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Revision History
% 1.0   7/25/2016   Release
% 1.1   8/11/2016   Redid Data Table
% 1.2   8/15/2016   Fixed custom cal
% 1.3   9/21/2016   Changed from avg pupil size to std of pupil size.
% 1.4   9/28/2016   Removed blinks from the pupil data. Put avg pupil size
%                   back in. Did calibration for pupil data (forgot to 
%                   before).

% Edit the above text to modify the response to help mSDMT_gui

% Last Modified by GUIDE v2.5 11-Aug-2016 09:23:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @mSDMT_gui_OpeningFcn, ...
    'gui_OutputFcn',  @mSDMT_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mSDMT_gui is made visible.
function mSDMT_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mSDMT_gui (see VARARGIN)

% Choose default command line output for mSDMT_gui
handles.output = hObject;

set(handles.rb_ycal1,'value',1)
set(handles.rb_xcal1,'value',1)
handles.x_calchoice = 1;
handles.y_calchoice = 1;
handles.row = 1;
handles.plottype = 1;
handles.row_names = {'rowall' 'rowfirstthree' 'row1' 'row2' 'row3' 'row4' 'row5'};
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mSDMT_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mSDMT_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%to add:
%- add choice to load new data set or an already processed one

% Get files... find only the .txt (raw data) files
[handles.FileName,handles.PathName] = ...
    uigetfile('*.mat*','Select data file',('Data'),'MultiSelect','off');

set(handles.pop_row,'value',1)
handles.row = 'total';

set(handles.slider_vert,'value',0)
set(handles.slider_horz,'value',0)
set(handles.text_vert,'string','0')
set(handles.text_horz,'string','0')



if handles.FileName == 0
    return
end

load([handles.PathName handles.FileName]);
set(handles.text1,'string',handles.FileName);

if exist('processed','var') == 0
    handles.CalData = CalData;
    handles.data.RawData = RawData;
    handles.data.CalData = CalData;
    
    try
        handles.data = rmfield(handles.data,row1);
        handles.data = rmfield(handles.data,row2);
        handles.data = rmfield(handles.data,row3);
        handles.data = rmfield(handles.data,row4);
        handles.data = rmfield(handles.data,row5);
    catch
    end

    % horizontal calibration
    
    CalData_L = CalData(1:3);
    CalData_R = CalData(1:3);
    CalPoints_L = [-10 0 10];
    CalPoints_R = [-10 0 10];
    axis1 = 1;
    
    [handles.cal.x_L1, handles.cal.x_R1] = Calibrate(CalData_L,CalData_R,CalPoints_L,CalPoints_R,axis1);
    
    CalData_L = CalData(7:9);
    CalData_R = CalData(7:9);
    CalPoints_L = [-10 0 10];
    CalPoints_R = [-10 0 10];
    
    
    [handles.cal.x_L2, handles.cal.x_R2] = Calibrate(CalData_L,CalData_R,CalPoints_L,CalPoints_R,axis1);
    
    % vertical calibration
    
    CalData_L = CalData(4:6);
    CalData_R = CalData(4:6);
    CalPoints_L = [10 0 -10];
    CalPoints_R = [10 0 -10];
    axis1 = 0;
    
    [handles.cal.y_L1, handles.cal.y_R1] = Calibrate(CalData_L,CalData_R,CalPoints_L,CalPoints_R,axis1);
    
    CalData_L = CalData(10:12);
    CalData_R = CalData(10:12);
    CalPoints_L = [10 0 -10];
    CalPoints_R = [10 0 -10];
    
    
    [handles.cal.y_L2, handles.cal.y_R2] = Calibrate(CalData_L,CalData_R,CalPoints_L,CalPoints_R,axis1);
    
    
    
    % set calibration values
    set(handles.edit_XLGain1,'string',num2str(handles.cal.x_L1(1)))
    set(handles.edit_XLInt1,'string',num2str(handles.cal.x_L1(2)))
    
    set(handles.edit_XRGain1,'string',num2str(handles.cal.x_R1(1)))
    set(handles.edit_XRInt1,'string',num2str(handles.cal.x_R1(2)))
    
    set(handles.edit_XLGain2,'string',num2str(handles.cal.x_L2(1)))
    set(handles.edit_XLInt2,'string',num2str(handles.cal.x_L2(2)))
    
    set(handles.edit_XRGain2,'string',num2str(handles.cal.x_R2(1)))
    set(handles.edit_XRInt2,'string',num2str(handles.cal.x_R2(2)))
    
    % set calibration values
    set(handles.edit_YLGain1,'string',num2str(handles.cal.y_L1(1)))
    set(handles.edit_YLInt1,'string',num2str(handles.cal.y_L1(2)))
    
    set(handles.edit_YRGain1,'string',num2str(handles.cal.y_R1(1)))
    set(handles.edit_YRInt1,'string',num2str(handles.cal.y_R1(2)))
    
    set(handles.edit_YLGain2,'string',num2str(handles.cal.y_L2(1)))
    set(handles.edit_YLInt2,'string',num2str(handles.cal.y_L2(2)))
    
    set(handles.edit_YRGain2,'string',num2str(handles.cal.y_R2(1)))
    set(handles.edit_YRInt2,'string',num2str(handles.cal.y_R2(2)))
    handles.processed = 0;
    
else % already been processed
    handles.data = data;
    handles.params = params;
    handles.time = time;
    %     handles.data_table = data_table;
    handles.cal = cal;
    
    m_R = 1.56;
    b_R = 8.36;
    m_L = 1.74;
    b_L = 9.29;
    
    handles.data.row1 = rmfield(handles.data.row1,'pupil_data');
    handles.data.row1.pupil_data(1,:) = (m_R*handles.data.original(5,handles.time.t1_index)+b_R);
    handles.data.row1.pupil_data(2,:) = (m_L*handles.data.original(6,handles.time.t1_index)+b_L);
    
    handles.data.row2 = rmfield(handles.data.row2,'pupil_data');
    handles.data.row2.pupil_data(1,:) = (m_R*handles.data.original(5,handles.time.t2_index)+b_R);
    handles.data.row2.pupil_data(2,:) = (m_L*handles.data.original(6,handles.time.t2_index)+b_L);
    
    handles.data.row3 = rmfield(handles.data.row3,'pupil_data');
    handles.data.row3.pupil_data(1,:) = (m_R*handles.data.original(5,handles.time.t3_index)+b_R);
    handles.data.row3.pupil_data(2,:) = (m_L*handles.data.original(6,handles.time.t3_index)+b_L);
    
    handles.data.row4 = rmfield(handles.data.row4,'pupil_data');
    handles.data.row4.pupil_data(1,:) = (m_R*handles.data.original(5,handles.time.t4_index)+b_R);
    handles.data.row4.pupil_data(2,:) = (m_L*handles.data.original(6,handles.time.t4_index)+b_L);
    
    handles.data.row5 = rmfield(handles.data.row5,'pupil_data');
    handles.data.row5.pupil_data(1,:) = (m_R*handles.data.original(5,handles.time.t5_index)+b_R);
    handles.data.row5.pupil_data(2,:) = (m_L*handles.data.original(6,handles.time.t5_index)+b_L);
    
    % set calibration values
    set(handles.edit_XLGain1,'string',num2str(handles.cal.x_L1(1)))
    set(handles.edit_XLInt1,'string',num2str(handles.cal.x_L1(2)))
    
    set(handles.edit_XRGain1,'string',num2str(handles.cal.x_R1(1)))
    set(handles.edit_XRInt1,'string',num2str(handles.cal.x_R1(2)))
    
    set(handles.edit_XLGain2,'string',num2str(handles.cal.x_L2(1)))
    set(handles.edit_XLInt2,'string',num2str(handles.cal.x_L2(2)))
    
    set(handles.edit_XRGain2,'string',num2str(handles.cal.x_R2(1)))
    set(handles.edit_XRInt2,'string',num2str(handles.cal.x_R2(2)))
    
    % set calibration values
    set(handles.edit_YLGain1,'string',num2str(handles.cal.y_L1(1)))
    set(handles.edit_YLInt1,'string',num2str(handles.cal.y_L1(2)))
    
    set(handles.edit_YRGain1,'string',num2str(handles.cal.y_R1(1)))
    set(handles.edit_YRInt1,'string',num2str(handles.cal.y_R1(2)))
    
    set(handles.edit_YLGain2,'string',num2str(handles.cal.y_L2(1)))
    set(handles.edit_YLInt2,'string',num2str(handles.cal.y_L2(2)))
    
    set(handles.edit_YRGain2,'string',num2str(handles.cal.y_R2(1)))
    set(handles.edit_YRInt2,'string',num2str(handles.cal.y_R2(2)))
    
    % set timing values
    
    set(handles.edit_t1,'string', num2str(handles.params.row1.completion_time))
    set(handles.edit_t2,'string', num2str(handles.params.row2.completion_time))
    set(handles.edit_t3,'string', num2str(handles.params.row3.completion_time))
    set(handles.edit_t4,'string', num2str(handles.params.row4.completion_time))
    set(handles.edit_t5,'string', num2str(handles.params.row5.completion_time))
    
    % plot this jazz
    axes(handles.axes1)
    plot_this(handles.data,'total',1,handles.time,handles.params)
    
    %     set(handles.uitable1,'data',handles.data_table);
    handles.processed = 1;
    
    row = {'row1' 'row2' 'row3' 'row4' 'row5'};

    if isfield(handles.params.row1,'vert_sacc')==0
        for i = 1:5
            handles.params.(row{i}).vert_sacc = 0;
        end
    end
    
%     disp(handles.params.row1.vert_sacc)
    
end

guidata(hObject, handles);

% --- Executes on button press in pb_process.
function pb_process_Callback(hObject, eventdata, handles)
% hObject    handle to pb_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%to add:
% - add notification that asks if operator is sure to process data when
% they already did

set(handles.pop_row,'value',1)
handles.row = 'total';
set(handles.cb_vert_analyzed,'value',0)
set(handles.slider_vert,'value',0)
set(handles.slider_horz,'value',0)
set(handles.text_vert,'string','0')
set(handles.text_horz,'string','0')
set(handles.pop_plottype,'value',1)
set(handles.pop_row,'value',1)

handles.cal.x_Rcus(1) = str2num(get(handles.edit_XRGainC,'string'));
handles.cal.x_Lcus(1) = str2num(get(handles.edit_XLGainC,'string'));
handles.cal.x_Rcus(2) = str2num(get(handles.edit_XRIntC,'string'));
handles.cal.x_Lcus(2) = str2num(get(handles.edit_XLIntC,'string'));

handles.cal.y_Rcus(1) = str2num(get(handles.edit_YRGainC,'string'));
handles.cal.y_Lcus(1) = str2num(get(handles.edit_YLGainC,'string'));
handles.cal.y_Rcus(2) = str2num(get(handles.edit_YRIntC,'string'));
handles.cal.y_Lcus(2) = str2num(get(handles.edit_YLIntC,'string'));
% apply calibration to data
switch handles.x_calchoice
    case 1 % cal 1
        handles.xgainr = handles.cal.x_R1(1);
        handles.xgainl = handles.cal.x_L1(1);
        handles.xintr = handles.cal.x_R1(2);
        handles.xintl = handles.cal.x_L1(2);
        
    case 2 % cal 2
        handles.xgainr = handles.cal.x_R2(1);
        handles.xgainl = handles.cal.x_L2(1);
        handles.xintr = handles.cal.x_R2(2);
        handles.xintl = handles.cal.x_L2(2);
        
    case 3 % custom cal
        handles.xgainr = handles.cal.x_Rcus(1);
        handles.xgainl = handles.cal.x_Lcus(1);
        handles.xintr = handles.cal.x_Rcus(2);
        handles.xintl = handles.cal.x_Lcus(2);
        
end

switch handles.y_calchoice
    case 1 % cal 1
        handles.ygainr = handles.cal.y_R1(1);
        handles.ygainl = handles.cal.y_L1(1);
        handles.yintr = handles.cal.y_R1(2);
        handles.yintl = handles.cal.y_L1(2);
        
    case 2 % cal 2
        handles.ygainr = handles.cal.y_R2(1);
        handles.ygainl = handles.cal.y_L2(1);
        handles.yintr = handles.cal.y_R2(2);
        handles.yintl = handles.cal.y_L2(2);
        
    case 3 % custom cal
        handles.ygainr = handles.cal.y_Rcus(1);
        handles.ygainl = handles.cal.y_Lcus(1);
        handles.yintr = handles.cal.y_Rcus(2);
        handles.yintl = handles.cal.y_Lcus(2);
        
end

% apply gainzzzz

for i = 1:length(handles.data.RawData{1})
    handles.data.original(1,i) = handles.data.RawData{1}(1,i)*handles.xgainr...
        + handles.xintr;
    handles.data.original(2,i) = handles.data.RawData{1}(2,i)*handles.xgainl...
        + handles.xintl;
    handles.data.original(3,i) = handles.data.RawData{1}(5,i)*handles.ygainr...
        + handles.yintr;
    handles.data.original(4,i) = handles.data.RawData{1}(3,i)*handles.ygainl...
        + handles.yintl;
    % pupil ... calibrate in later version
    m_R = 1.56;
    b_R = 8.36;
    m_L = 1.74;
    b_L = 9.29;
    handles.data.original(5,i) = m_R*handles.data.RawData{1}(6,i)+b_R;
    handles.data.original(6,i) = m_L*handles.data.RawData{1}(4,i)+b_L;
end

% separate into rows depending on length
% disp(get(handles.edit_t1,'string'))
handles.time.completion_1 = str2num(get(handles.edit_t1,'string'));
handles.time.completion_2 = str2num(get(handles.edit_t2,'string'));
handles.time.completion_3 = str2num(get(handles.edit_t3,'string'));
handles.time.completion_4 = str2num(get(handles.edit_t4,'string'));
handles.time.completion_5 = str2num(get(handles.edit_t5,'string'));


handles.time.T1 = str2num(get(handles.edit_t1,'string'));
handles.time.T2 = str2num(get(handles.edit_t2,'string')) + handles.time.T1;
handles.time.T3 = str2num(get(handles.edit_t3,'string')) + handles.time.T2;
handles.time.T4 = str2num(get(handles.edit_t4,'string')) + handles.time.T3;
handles.time.T5 = str2num(get(handles.edit_t5,'string')) + handles.time.T4;

% times
handles.time.t1 = 0.002:0.002:handles.time.T1;
handles.time.t2 = handles.time.T1:0.002:handles.time.T2;
handles.time.t3 = handles.time.T2:0.002:handles.time.T3;
handles.time.t4 = handles.time.T3:0.002:handles.time.T4;
handles.time.t5 = handles.time.T4:0.002:handles.time.T5;
handles.time.total = 0.002:0.002:handles.time.T5;
handles.time.firstthree = 0.002:0.002:handles.time.T3;

% indices
handles.time.t1_index = floor(handles.time.t1*500);
handles.time.t2_index = floor(handles.time.t2*500);
handles.time.t3_index = floor(handles.time.t3*500);
handles.time.t4_index = floor(handles.time.t4*500);
handles.time.t5_index = floor(handles.time.t5*500);
handles.time.total_index = floor(handles.time.total*500);
handles.time.firstthree_index = floor(handles.time.firstthree*500);


% separate the data
handles.data.row1.horz_data = (handles.data.original(1,handles.time.t1_index)+handles.data.original(2,handles.time.t1_index))/2;
handles.data.row1.vert_data = (handles.data.original(3,handles.time.t1_index)+handles.data.original(4,handles.time.t1_index))/2;
handles.data.row1.pupil_data(1,:) = (handles.data.original(5,handles.time.t1_index));
handles.data.row1.pupil_data(2,:) = (handles.data.original(6,handles.time.t1_index));
handles.data.row1.drift_control.horz = 0;
handles.data.row1.drift_control.vert = 0;

handles.data.row2.horz_data = (handles.data.original(1,handles.time.t2_index)+handles.data.original(2,handles.time.t2_index))/2;
handles.data.row2.vert_data = (handles.data.original(3,handles.time.t2_index)+handles.data.original(4,handles.time.t2_index))/2;
handles.data.row2.pupil_data(1,:) = (handles.data.original(5,handles.time.t2_index));
handles.data.row2.pupil_data(2,:) = (handles.data.original(6,handles.time.t2_index));
handles.data.row2.drift_control.horz = 0;
handles.data.row2.drift_control.vert = 0;

handles.data.row3.horz_data = (handles.data.original(1,handles.time.t3_index)+handles.data.original(2,handles.time.t3_index))/2;
handles.data.row3.vert_data = (handles.data.original(3,handles.time.t3_index)+handles.data.original(4,handles.time.t3_index))/2;
handles.data.row3.pupil_data(1,:) = (handles.data.original(5,handles.time.t3_index));
handles.data.row3.pupil_data(2,:) = (handles.data.original(6,handles.time.t3_index));
handles.data.row3.drift_control.horz = 0;
handles.data.row3.drift_control.vert = 0;

handles.data.row4.horz_data = (handles.data.original(1,handles.time.t4_index)+handles.data.original(2,handles.time.t4_index))/2;
handles.data.row4.vert_data = (handles.data.original(3,handles.time.t4_index)+handles.data.original(4,handles.time.t4_index))/2;
handles.data.row4.pupil_data(1,:) = (handles.data.original(5,handles.time.t4_index));
handles.data.row4.pupil_data(2,:) = (handles.data.original(6,handles.time.t4_index));
handles.data.row4.drift_control.horz = 0;
handles.data.row4.drift_control.vert = 0;

handles.data.row5.horz_data = (handles.data.original(1,handles.time.t5_index)+handles.data.original(2,handles.time.t5_index))/2;
handles.data.row5.vert_data = (handles.data.original(3,handles.time.t5_index)+handles.data.original(4,handles.time.t5_index))/2;
handles.data.row5.pupil_data(1,:) = (handles.data.original(5,handles.time.t5_index));
handles.data.row5.pupil_data(2,:) = (handles.data.original(6,handles.time.t5_index));
handles.data.row5.drift_control.horz = 0;
handles.data.row5.drift_control.vert = 0;

% do calculations
% 
for i = 3:7 %rows
    row_name = handles.row_names{i};
%     [params] = mSDMT_params(handles.data.(row_name),100,row_name);
%     %          disp(mean(handles.params.(row_name).saccade_velocities_magnitude))
%     
%     params.(row_name).avg_velocity(1) = mean(params.(row_name).saccade_velocities_magnitude);
%     params.(row_name).avg_velocity(2) = nanstd(params.(row_name).saccade_velocities_magnitude);
%     
%     params.(row_name).avg_fixation_time(1) = mean(params.(row_name).total_fixation_times);
%     params.(row_name).avg_fixation_time(2) = std(params.(row_name).total_fixation_times);
    params.(row_name).vert_sacc = 0;
    handles.params.(row_name) = params.(row_name);
%     
end
% 
% 
% % all
% handles.params.rowall.saccade_count = handles.params.row1.saccade_count + ...
%     handles.params.row2.saccade_count + handles.params.row3.saccade_count + ...
%     handles.params.row4.saccade_count + handles.params.row5.saccade_count;
% 
% handles.params.rowall.saccade_velocities = [handles.params.row1.saccade_velocities_magnitude ...
%     handles.params.row2.saccade_velocities_magnitude handles.params.row3.saccade_velocities_magnitude ...
%     handles.params.row4.saccade_velocities_magnitude handles.params.row5.saccade_velocities_magnitude];
% 
% handles.params.rowall.avg_velocity(1) = mean(handles.params.rowall.saccade_velocities);
% handles.params.rowall.avg_velocity(2) = std(handles.params.rowall.saccade_velocities);
% 
% handles.params.rowall.fixation_times = [handles.params.row1.fixation_times ...
%     handles.params.row2.fixation_times handles.params.row3.fixation_times ...
%     handles.params.row4.fixation_times handles.params.row5.fixation_times];
% 
% handles.params.rowall.total_fixation_times = [handles.params.row1.total_fixation_times ...
%     handles.params.row2.total_fixation_times handles.params.row3.total_fixation_times ...
%     handles.params.row4.total_fixation_times handles.params.row5.total_fixation_times];
% 
% handles.params.rowall.avg_fixation_time(1) = mean(handles.params.rowall.total_fixation_times);
% handles.params.rowall.avg_fixation_time(2) = std(handles.params.rowall.total_fixation_times);
% 
% handles.params.rowall.blink_count = handles.params.row1.blink_count + ...
%     handles.params.row2.blink_count + handles.params.row3.blink_count + ...
%     handles.params.row4.blink_count + handles.params.row5.blink_count;
% 
% % firstthree
% handles.params.rowfirstthree.saccade_count = handles.params.row1.saccade_count + ...
%     handles.params.row2.saccade_count + handles.params.row3.saccade_count;
% 
% handles.params.rowfirstthree.saccade_velocities = [handles.params.row1.saccade_velocities_magnitude ...
%     handles.params.row2.saccade_velocities_magnitude handles.params.row3.saccade_velocities_magnitude];
% 
% handles.params.rowfirstthree.avg_velocity(1) = mean(handles.params.rowfirstthree.saccade_velocities);
% handles.params.rowfirstthree.avg_velocity(2) = std(handles.params.rowfirstthree.saccade_velocities);
% 
% handles.params.rowfirstthree.fixation_times = [handles.params.row1.fixation_times ...
%     handles.params.row2.fixation_times handles.params.row3.fixation_times];
% 
% handles.params.rowfirstthree.total_fixation_times = [handles.params.row1.total_fixation_times ...
%     handles.params.row2.total_fixation_times handles.params.row3.total_fixation_times];
% 
% handles.params.rowfirstthree.avg_fixation_time(1) = mean(handles.params.rowfirstthree.total_fixation_times);
% handles.params.rowfirstthree.avg_fixation_time(2) = std(handles.params.rowfirstthree.total_fixation_times);
% 
% handles.params.rowfirstthree.blink_count = handles.params.row1.blink_count + ...
%     handles.params.row2.blink_count + handles.params.row3.blink_count;

% completion_time
handles.params.row1.completion_time = str2num(get(handles.edit_t1,'string'));
handles.params.row2.completion_time = str2num(get(handles.edit_t2,'string'));
handles.params.row3.completion_time = str2num(get(handles.edit_t3,'string'));
handles.params.row4.completion_time = str2num(get(handles.edit_t4,'string'));
handles.params.row5.completion_time = str2num(get(handles.edit_t5,'string'));
handles.params.rowall.completion_time = handles.params.row1.completion_time ...
    + handles.params.row2.completion_time + handles.params.row3.completion_time...
    + handles.params.row4.completion_time + handles.params.row5.completion_time;
handles.params.rowfirstthree.completion_time = handles.params.row1.completion_time ...
    + handles.params.row2.completion_time + handles.params.row3.completion_time;


% accuracy
handles.params.row1.accuracy = str2num(get(handles.edit_A1,'string'));
handles.params.row2.accuracy = str2num(get(handles.edit_A2,'string'));
handles.params.row3.accuracy = str2num(get(handles.edit_A3,'string'));
handles.params.row4.accuracy = str2num(get(handles.edit_A4,'string'));
handles.params.row5.accuracy = str2num(get(handles.edit_A5,'string'));
handles.params.rowall.accuracy = (handles.params.row1.accuracy + ...
    handles.params.row2.accuracy + handles.params.row3.accuracy + ...
    handles.params.row4.accuracy + handles.params.row5.accuracy)/5;
handles.params.rowfirstthree.accuracy = (handles.params.row1.accuracy + ...
    handles.params.row2.accuracy + handles.params.row3.accuracy)/3;

%clean up function (removes blinks and such)

% build table and input table values

% for i = 1:7
%
%     x = handles.row_names{i};
%     handles.data_table{i,1} = num2str(handles.params.(x).saccade_count);
%     handles.data_table{i,2} = [num2str(handles.params.(x).avg_velocity(1))...
%         ' +/- ' num2str(handles.params.(x).avg_velocity(2))];
%     handles.data_table{i,3} = [num2str(handles.params.(x).avg_fixation_time(1))...
%         ' +/- ' num2str(handles.params.(x).avg_fixation_time(2))];
%     handles.data_table{i,4} = num2str(handles.params.(x).completion_time);
%     handles.data_table{i,5} = num2str(handles.params.(x).blink_count);
%     handles.data_table{i,6} = num2str(handles.params.(x).accuracy);
%
% end

% set(handles.uitable1,'data',handles.data_table);
handles.processed = 1;
% plot this jazz
handles.plottype = get(hObject,'value');
axes(handles.axes1)
plot_this(handles.data,'total',1,handles.time,handles.params)

guidata(hObject, handles);


% --- Executes on button press in pb_animation.
function pb_animation_Callback(hObject, eventdata, handles)
% hObject    handle to pb_animation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in pop_plottype.
function pop_plottype_Callback(hObject, eventdata, handles)
% hObject    handle to pop_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plottype = get(hObject,'value');

plot_this(handles.data,handles.row,handles.plottype,handles.time,handles.params)
guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns pop_plottype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_plottype


% --- Executes during object creation, after setting all properties.
function pop_plottype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_vert_Callback(hObject, eventdata, handles)
% hObject    handle to slider_vert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vertval = get(handles.slider_vert,'value');
set(handles.text_vert,'string',num2str(vertval))

handles.data.(handles.row).drift_control.vert = ...
    get(handles.slider_vert,'value');
handles.data.(handles.row).drift_control.horz = ...
    get(handles.slider_horz,'value');

axes(handles.axes1)
plot_this(handles.data,handles.row,handles.plottype,handles.time,handles.params)

guidata(hObject,handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_vert_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_vert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_horz_Callback(hObject, eventdata, handles)
% hObject    handle to slider_horz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

horzval = get(handles.slider_horz,'value');
set(handles.text_horz,'string',num2str(horzval))

handles.data.(handles.row).drift_control.vert = ...
    get(handles.slider_vert,'value');
handles.data.(handles.row).drift_control.horz = ...
    get(handles.slider_horz,'value');

axes(handles.axes1)
plot_this(handles.data,handles.row,handles.plottype,handles.time,handles.params)

guidata(hObject,handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_horz_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_horz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_t1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t1 as text
%        str2double(get(hObject,'String')) returns contents of edit_t1 as a double


% --- Executes during object creation, after setting all properties.
function edit_t1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t2 as text
%        str2double(get(hObject,'String')) returns contents of edit_t2 as a double


% --- Executes during object creation, after setting all properties.
function edit_t2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t3 as text
%        str2double(get(hObject,'String')) returns contents of edit_t3 as a double


% --- Executes during object creation, after setting all properties.
function edit_t3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t4 as text
%        str2double(get(hObject,'String')) returns contents of edit_t4 as a double


% --- Executes during object creation, after setting all properties.
function edit_t4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_t5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_t5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_t5 as text
%        str2double(get(hObject,'String')) returns contents of edit_t5 as a double


% --- Executes during object creation, after setting all properties.
function edit_t5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_t5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_xcal1.
function rb_xcal1_Callback(hObject, eventdata, handles)
% hObject    handle to rb_xcal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rb_xcal1,'value',1)
set(handles.rb_xcal2,'value',0)
set(handles.rb_xcustomcal,'value',0)

handles.x_calchoice = 1;

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of rb_xcal1


% --- Executes on button press in rb_xcal2.
function rb_xcal2_Callback(hObject, eventdata, handles)
% hObject    handle to rb_xcal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rb_xcal1,'value',0)
set(handles.rb_xcal2,'value',1)
set(handles.rb_xcustomcal,'value',0)

handles.x_calchoice = 2;

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of rb_xcal2


% --- Executes on button press in rb_xcustomcal.
function rb_xcustomcal_Callback(hObject, eventdata, handles)
% hObject    handle to rb_xcustomcal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rb_xcal2,'value',0)
set(handles.rb_xcal1,'value',0)
set(handles.rb_xcustomcal,'value',1)

handles.x_calchoice = 3;

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of rb_xcustomcal



function edit_xcustomcalg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xcustomcalg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xcustomcalg as text
%        str2double(get(hObject,'String')) returns contents of edit_xcustomcalg as a double


% --- Executes during object creation, after setting all properties.
function edit_xcustomcalg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xcustomcalg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_xcustomcalb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_xcustomcalb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_xcustomcalb as text
%        str2double(get(hObject,'String')) returns contents of edit_xcustomcalb as a double


% --- Executes during object creation, after setting all properties.
function edit_xcustomcalb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_xcustomcalb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xcal2g_Callback(hObject, eventdata, handles)
% hObject    handle to xcal2g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcal2g as text
%        str2double(get(hObject,'String')) returns contents of xcal2g as a double


% --- Executes during object creation, after setting all properties.
function xcal2g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcal2g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xcal2b_Callback(hObject, eventdata, handles)
% hObject    handle to xcal2b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcal2b as text
%        str2double(get(hObject,'String')) returns contents of xcal2b as a double


% --- Executes during object creation, after setting all properties.
function xcal2b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcal2b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xcal1g_Callback(hObject, eventdata, handles)
% hObject    handle to xcal1g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcal1g as text
%        str2double(get(hObject,'String')) returns contents of xcal1g as a double


% --- Executes during object creation, after setting all properties.
function xcal1g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcal1g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xcal1b_Callback(hObject, eventdata, handles)
% hObject    handle to xcal1b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xcal1b as text
%        str2double(get(hObject,'String')) returns contents of xcal1b as a double


% --- Executes during object creation, after setting all properties.
function xcal1b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xcal1b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rb_ycal1.
function rb_ycal1_Callback(hObject, eventdata, handles)
% hObject    handle to rb_ycal1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rb_ycal1,'value',1)
set(handles.rb_ycal2,'value',0)
set(handles.rb_ycustomcal,'value',0)

handles.y_calchoice = 1;

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of rb_ycal1


% --- Executes on button press in rb_ycal2.
function rb_ycal2_Callback(hObject, eventdata, handles)
% hObject    handle to rb_ycal2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rb_ycal1,'value',0)
set(handles.rb_ycal2,'value',1)
set(handles.rb_ycustomcal,'value',0)

handles.y_calchoice = 2;

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of rb_ycal2


% --- Executes on button press in rb_ycustomcal.
function rb_ycustomcal_Callback(hObject, eventdata, handles)
% hObject    handle to rb_ycustomcal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.rb_ycal1,'value',0)
set(handles.rb_ycal2,'value',0)
set(handles.rb_ycustomcal,'value',1)

handles.y_calchoice = 3;

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of rb_ycustomcal



function edit_ycustomcalg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ycustomcalg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ycustomcalg as text
%        str2double(get(hObject,'String')) returns contents of edit_ycustomcalg as a double


% --- Executes during object creation, after setting all properties.
function edit_ycustomcalg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ycustomcalg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ycustomcalb_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ycustomcalb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ycustomcalb as text
%        str2double(get(hObject,'String')) returns contents of edit_ycustomcalb as a double


% --- Executes during object creation, after setting all properties.
function edit_ycustomcalb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ycustomcalb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in pop_row.
function pop_row_Callback(hObject, eventdata, handles)
% hObject    handle to pop_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(handles.pop_row,'value')
    case 1 % all
        handles.row = 'total';
        set(handles.cb_vert_analyzed,'value',0)
        set(handles.slider_vert,'enable','off')
        set(handles.slider_horz,'enable','off')
        set(handles.slider_vert,'value',0)
        set(handles.slider_horz,'value',0)
        set(handles.text_vert,'string','0')
        set(handles.text_horz,'string','0')
    case 2 % firstthree
        handles.row = 'firstthree';
        set(handles.cb_vert_analyzed,'value',0)
        set(handles.slider_vert,'enable','off')
        set(handles.slider_horz,'enable','off')
        set(handles.slider_vert,'value',0)
        set(handles.slider_horz,'value',0)
        set(handles.text_vert,'string','0')
        set(handles.text_horz,'string','0')
    case 3 % row1
        handles.row = 'row1';
        set(handles.cb_vert_analyzed,'value',handles.params.(handles.row).vert_sacc)
        set(handles.slider_vert,'enable','on')
        set(handles.slider_horz,'enable','on')
        set(handles.text_vert,'string',num2str(handles.data.(handles.row).drift_control.vert))
        set(handles.text_horz,'string',num2str(handles.data.(handles.row).drift_control.horz))
        set(handles.slider_vert,'value',handles.data.(handles.row).drift_control.vert)
        set(handles.slider_horz,'value',handles.data.(handles.row).drift_control.horz)
    case 4 % row2
        handles.row = 'row2';
        set(handles.cb_vert_analyzed,'value',handles.params.(handles.row).vert_sacc)
        set(handles.slider_vert,'enable','on')
        set(handles.slider_horz,'enable','on')
        set(handles.text_vert,'string',num2str(handles.data.(handles.row).drift_control.vert))
        set(handles.text_horz,'string',num2str(handles.data.(handles.row).drift_control.horz))
        set(handles.slider_vert,'value',handles.data.(handles.row).drift_control.vert)
        set(handles.slider_horz,'value',handles.data.(handles.row).drift_control.horz)
    case 5 % row3
        handles.row = 'row3';
        set(handles.cb_vert_analyzed,'value',handles.params.(handles.row).vert_sacc)
        set(handles.slider_vert,'enable','on')
        set(handles.slider_horz,'enable','on')
        set(handles.text_vert,'string',num2str(handles.data.(handles.row).drift_control.vert))
        set(handles.text_horz,'string',num2str(handles.data.(handles.row).drift_control.horz))
        set(handles.slider_vert,'value',handles.data.(handles.row).drift_control.vert)
        set(handles.slider_horz,'value',handles.data.(handles.row).drift_control.horz)
    case 6 % row4
        handles.row = 'row4';
        set(handles.cb_vert_analyzed,'value',handles.params.(handles.row).vert_sacc)
        set(handles.slider_vert,'enable','on')
        set(handles.slider_horz,'enable','on')
        set(handles.text_vert,'string',num2str(handles.data.(handles.row).drift_control.vert))
        set(handles.text_horz,'string',num2str(handles.data.(handles.row).drift_control.horz))
        set(handles.slider_vert,'value',handles.data.(handles.row).drift_control.vert)
        set(handles.slider_horz,'value',handles.data.(handles.row).drift_control.horz)
    case 7 % row5
        handles.row = 'row5';
        set(handles.cb_vert_analyzed,'value',handles.params.(handles.row).vert_sacc)
        set(handles.slider_vert,'enable','on')
        set(handles.slider_horz,'enable','on')
        set(handles.text_vert,'string',num2str(handles.data.(handles.row).drift_control.vert))
        set(handles.text_horz,'string',num2str(handles.data.(handles.row).drift_control.horz))
        set(handles.slider_vert,'value',handles.data.(handles.row).drift_control.vert)
        set(handles.slider_horz,'value',handles.data.(handles.row).drift_control.horz)
end



axes(handles.axes1)
plot_this(handles.data,handles.row,handles.plottype,handles.time,handles.params)

guidata(hObject,handles)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_row contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_row


% --- Executes during object creation, after setting all properties.
function pop_row_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_row (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_A1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A1 as text
%        str2double(get(hObject,'String')) returns contents of edit_A1 as a double


% --- Executes during object creation, after setting all properties.
function edit_A1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_A2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A2 as text
%        str2double(get(hObject,'String')) returns contents of edit_A2 as a double


% --- Executes during object creation, after setting all properties.
function edit_A2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_A3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A3 as text
%        str2double(get(hObject,'String')) returns contents of edit_A3 as a double


% --- Executes during object creation, after setting all properties.
function edit_A3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A4_Callback(hObject, eventdata, handles)
% hObject    handle to edit_A4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A4 as text
%        str2double(get(hObject,'String')) returns contents of edit_A4 as a double


% --- Executes during object creation, after setting all properties.
function edit_A4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_A5_Callback(hObject, eventdata, handles)
% hObject    handle to edit_A5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_A5 as text
%        str2double(get(hObject,'String')) returns contents of edit_A5 as a double


% --- Executes during object creation, after setting all properties.
function edit_A5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_A5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XRGain1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRGain1 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRGain1 as a double


% --- Executes during object creation, after setting all properties.
function edit_XRGain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XLGain1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRGain1 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRGain1 as a double


% --- Executes during object creation, after setting all properties.
function edit_XLGain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XRInt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRInt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRInt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_XRInt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XLInt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRInt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRInt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_XLInt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XRGain2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRGain2 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRGain2 as a double


% --- Executes during object creation, after setting all properties.
function edit_XRGain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XLGain2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRGain2 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRGain2 as a double


% --- Executes during object creation, after setting all properties.
function edit_XLGain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XRInt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRInt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRInt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_XRInt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XLInt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XRInt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_XRInt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_XLInt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XRGainC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.x_Rcus(1) = str2double(get(hObject,'string'));

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_XRGainC as text
%        str2double(get(hObject,'String')) returns contents of edit_XRGainC as a double


% --- Executes during object creation, after setting all properties.
function edit_XRGainC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XLGainC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.x_Lcus(1) = str2double(get(hObject,'string'));

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_XRGainC as text
%        str2double(get(hObject,'String')) returns contents of edit_XRGainC as a double


% --- Executes during object creation, after setting all properties.
function edit_XLGainC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XRIntC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.x_Rcus(2) = str2double(get(hObject,'string'));

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_XRIntC as text
%        str2double(get(hObject,'String')) returns contents of edit_XRIntC as a double


% --- Executes during object creation, after setting all properties.
function edit_XRIntC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_XLIntC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XRIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.x_Lcus(2) = str2double(get(hObject,'string'));

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_XRIntC as text
%        str2double(get(hObject,'String')) returns contents of edit_XRIntC as a double


% --- Executes during object creation, after setting all properties.
function edit_XLIntC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XRIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YLGain1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YLGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YLGain1 as text
%        str2double(get(hObject,'String')) returns contents of edit_YLGain1 as a double


% --- Executes during object creation, after setting all properties.
function edit_YLGain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YLGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YRGain1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YRGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YRGain1 as text
%        str2double(get(hObject,'String')) returns contents of edit_YRGain1 as a double


% --- Executes during object creation, after setting all properties.
function edit_YRGain1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YRGain1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YLInt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YLInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YLInt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_YLInt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_YLInt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YLInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YRInt1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YRInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YRInt1 as text
%        str2double(get(hObject,'String')) returns contents of edit_YRInt1 as a double


% --- Executes during object creation, after setting all properties.
function edit_YRInt1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YRInt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YLGain2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YLGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YLGain2 as text
%        str2double(get(hObject,'String')) returns contents of edit_YLGain2 as a double


% --- Executes during object creation, after setting all properties.
function edit_YLGain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YLGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YRGain2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YRGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YRGain2 as text
%        str2double(get(hObject,'String')) returns contents of edit_YRGain2 as a double


% --- Executes during object creation, after setting all properties.
function edit_YRGain2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YRGain2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YLInt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YLInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YLInt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_YLInt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_YLInt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YLInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YRInt2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YRInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YRInt2 as text
%        str2double(get(hObject,'String')) returns contents of edit_YRInt2 as a double


% --- Executes during object creation, after setting all properties.
function edit_YRInt2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YRInt2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YLGainC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YLGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YLGainC as text
%        str2double(get(hObject,'String')) returns contents of edit_YLGainC as a double


% --- Executes during object creation, after setting all properties.
function edit_YLGainC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YLGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YRGainC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YRGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YRGainC as text
%        str2double(get(hObject,'String')) returns contents of edit_YRGainC as a double


% --- Executes during object creation, after setting all properties.
function edit_YRGainC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YRGainC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YLIntC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YLIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YLIntC as text
%        str2double(get(hObject,'String')) returns contents of edit_YLIntC as a double


% --- Executes during object creation, after setting all properties.
function edit_YLIntC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YLIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_YRIntC_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YRIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YRIntC as text
%        str2double(get(hObject,'String')) returns contents of edit_YRIntC as a double


% --- Executes during object creation, after setting all properties.
function edit_YRIntC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YRIntC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
% data_table = handles.data_table;
cal = handles.cal;
data_table = handles.data_table;
params = handles.params;
time = handles.time;
filename = handles.FileName;
processed = handles.processed;
uiwait(msgbox('Data set has been saved!','Saved!','modal'));
save(['Data\Processed\' filename],'data','cal','params','time','processed','data_table')

% --- Executes on button press in pb_vert_sacc.
function pb_vert_sacc_Callback(hObject, eventdata, handles)
% hObject    handle to pb_vert_sacc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
row_name = handles.row;

if strcmp('total',row_name) == 1 || strcmp('firstthree',row_name) == 1
    uiwait(msgbox('Please choose Row 1, 2, 3, 4, or 5','Warning','modal'));
    return
end

if get(handles.cb_vert_analyzed,'value') == 1
    output = menu('This has already been analyzed. Reanalyze?','Yes','No');
    if output == 2
        return
    end
end


params = handles.params;
[output,data_blinks_removed] = mSDMT_vert_saccades(handles.data.(row_name),...
    row_name,params.(row_name));

handles.params.(row_name) = output;
handles.data.(row_name).data_blinks_removed = data_blinks_removed;
set(handles.cb_vert_analyzed,'value',1)

axes(handles.axes1)
plot_this(handles.data,handles.row,handles.plottype,handles.time,handles.params)


guidata(hObject,handles)

%% OTTER FUNCTIONS


function plot_this(data,row,plot_type,time,params)
cla reset

switch plot_type
    case 1 % scan path plot
        hold on
        i = imread('SDMT1.jpg');imagesc([-10 10],[-10 10],i);
        colormap(gray)
        set(gca,'YDir','normal')
        
        switch row
            case 'total'
                x = data.row1.horz_data+data.row1.drift_control.horz;
                y = data.row1.vert_data+data.row1.drift_control.vert;
                plot(x,y,'b')
                axis([-15 15 -15 15])
                
                x = data.row2.horz_data+data.row2.drift_control.horz;
                y = data.row2.vert_data+data.row2.drift_control.vert;
                plot(x,y,'g')
                axis([-15 15 -15 15])
                
                x = data.row3.horz_data+data.row3.drift_control.horz;
                y = data.row3.vert_data+data.row3.drift_control.vert;
                plot(x,y,'r')
                axis([-15 15 -15 15])
                
                x = data.row4.horz_data+data.row4.drift_control.horz;
                y = data.row4.vert_data+data.row4.drift_control.vert;
                plot(x,y,'m')
                axis([-15 15 -15 15])
                
                x = data.row5.horz_data+data.row5.drift_control.horz;
                y = data.row5.vert_data+data.row5.drift_control.vert;
                plot(x,y,'k')
                axis([-15 15 -15 15])
                
                
            case 'firstthree'
                x = data.row1.horz_data+data.row1.drift_control.horz;
                y = data.row1.vert_data+data.row1.drift_control.vert;
                plot(x,y,'b')
                axis([-15 15 -15 15])
                
                x = data.row2.horz_data+data.row2.drift_control.horz;
                y = data.row2.vert_data+data.row2.drift_control.vert;
                plot(x,y,'g')
                axis([-15 15 -15 15])
                
                x = data.row3.horz_data+data.row3.drift_control.horz;
                y = data.row3.vert_data+data.row3.drift_control.vert;
                plot(x,y,'r')
                axis([-15 15 -15 15])
                
            case 'row1'
                x = data.(row).horz_data+data.(row).drift_control.horz;
                y = data.(row).vert_data+data.(row).drift_control.vert;
                plot(x,y,'b')
                
                %             for i = 1:length(x) % gradient
                %                 plot(x(i),y(i),'-','color',[0 0 1-.5*(i/length(x))])
                %             end
                axis([-15 15 -15 15])
            case 'row2'
                x = data.(row).horz_data+data.(row).drift_control.horz;
                y = data.(row).vert_data+data.(row).drift_control.vert;
                plot(x,y,'g')
                axis([-15 15 -15 15])
            case 'row3'
                x = data.(row).horz_data+data.(row).drift_control.horz;
                y = data.(row).vert_data+data.(row).drift_control.vert;
                plot(x,y,'r')
                axis([-15 15 -15 15])
            case 'row4'
                x = data.(row).horz_data+data.(row).drift_control.horz;
                y = data.(row).vert_data+data.(row).drift_control.vert;
                plot(x,y,'m')
                axis([-15 15 -15 15])
            case 'row5'
                x = data.(row).horz_data+data.(row).drift_control.horz;
                y = data.(row).vert_data+data.(row).drift_control.vert;
                plot(x,y,'k')
                axis([-15 15 -15 15])
        end
        
    case 2 % bubble plot (plot that shows fixation spots)
        hold on
        a = imread('SDMT1.jpg');imagesc([-10 10],[-10 10],a);
        colormap(gray)
        alpha .3
        if strcmp(row,'firstthree')
            mSDMT_bubble(data,'row1');
            mSDMT_bubble(data,'row2');
            mSDMT_bubble(data,'row3');
        elseif strcmp(row,'total')
            mSDMT_bubble(data,'row1');
            mSDMT_bubble(data,'row2');
            mSDMT_bubble(data,'row3');
            mSDMT_bubble(data,'row4');
            mSDMT_bubble(data,'row5');
        else
            mSDMT_bubble(data,row)
        end
        
    case 3 % vertical plot
        hold on
        switch row
            case 'total'
                
                y = data.row1.vert_data+data.row1.drift_control.vert;
                t1 = time.t1_index * 0.002;
                
                plot(t1,y,'color',[0 0 1]);
                
                y = data.row2.vert_data+data.row2.drift_control.vert;
                t2 = time.t2_index * 0.002;
                plot(t2,y,'color',[0 1 0]);
                
                y = data.row3.vert_data+data.row3.drift_control.vert;
                t3 = time.t3_index * 0.002;
                plot(t3,y,'color',[1 0 0]);
                
                y = data.row4.vert_data+data.row4.drift_control.vert;
                t4 = time.t4_index * 0.002;
                plot(t4,y,'color',[1 0 1]);
                
                y = data.row5.vert_data+data.row5.drift_control.vert;
                t5 = time.t5_index * 0.002;
                plot(t5,y,'color',[0 0 0]);
                
                axis([0 time.T5 -15 15])
                
                
            case 'firstthree'
                y = data.row1.vert_data+data.row1.drift_control.vert;
                t1 = time.t1_index * 0.002;
                plot(t1,y,'color',[0 0 1]);
                
                y = data.row2.vert_data+data.row2.drift_control.vert;
                t2 = time.t2_index * 0.002;
                plot(t2,y,'color',[0 1 0]);
                
                y = data.row3.vert_data+data.row3.drift_control.vert;
                t3 = time.t3_index * 0.002;
                plot(t3,y,'color',[1 0 0]);
                
                axis([0 time.T3 -15 15])
                
            case 'row1'
                
                y = data.row1.vert_data+data.row1.drift_control.vert;
                t1 = time.t1_index * 0.002;
                plot(t1,y,'color',[0 0 1]);
                try
                    plot([params.row1.saccade2key.indices(1)/500 params.row1.saccade2key.indices(1)/500],[-100 100],'r')
                    plot([params.row1.saccade2line.indices(1)/500 params.row1.saccade2line.indices(1)/500],[-100 100],'g')
                    
                    for i = 2:params.row1.saccade2key.count
                        plot([params.row1.saccade2key.indices(i)/500 params.row1.saccade2key.indices(i)/500],[-100 100],'r')
                    end
                    
                    for i = 2:params.row1.saccade2line.count
                        plot([params.row1.saccade2line.indices(i)/500 params.row1.saccade2line.indices(i)/500],[-100 100],'g')
                    end
                catch
                end
                axis([0 time.T1 -15 15])
                legend('Vertical Eye Movement','Saccade to Key','Saccade to Lines')
            case 'row2'
                y = data.row2.vert_data+data.row2.drift_control.vert;
                t2 = time.t2_index * 0.002;
                plot(t2,y,'color',[0 1 0]);
                try
                    plot([(params.row2.saccade2key.indices(1)/500+time.T1) (params.row2.saccade2key.indices(1)/500+time.T1)],[-100 100],'r')
                    plot([(params.row2.saccade2line.indices(1)/500+time.T1) (params.row2.saccade2line.indices(1)/500+time.T1)],[-100 100],'g')
                    
                    for i = 2:params.row2.saccade2key.count
                        plot([(params.row2.saccade2key.indices(i)/500+time.T1) (params.row2.saccade2key.indices(i)/500+time.T1)],[-100 100],'r')
                    end
                    
                    for i = 2:params.row2.saccade2line.count
                        plot([(params.row2.saccade2line.indices(i)/500+time.T1) (params.row2.saccade2line.indices(i)/500+time.T1)],[-100 100],'g')
                    end
                catch
                end
                axis([time.T1 time.T2 -15 15])
                legend('Vertical Eye Movement','Saccade to Key','Saccade to Lines')
            case 'row3'
                y = data.row3.vert_data+data.row3.drift_control.vert;
                t3 = time.t3_index * 0.002;
                plot(t3,y,'color',[1 0 0]);
                try
                    plot([(params.row3.saccade2key.indices(1)/500+time.T2) (params.row3.saccade2key.indices(1)/500+time.T2)],[-100 100],'r')
                    plot([(params.row3.saccade2line.indices(1)/500+time.T2) (params.row3.saccade2line.indices(1)/500+time.T2)],[-100 100],'g')
                    
                    for i = 2:params.row3.saccade2key.count
                        plot([(params.row3.saccade2key.indices(i)/500+time.T2) (params.row3.saccade2key.indices(i)/500+time.T2)],[-100 100],'r')
                    end
                    
                    for i = 2:params.row3.saccade2line.count
                        plot([(params.row3.saccade2line.indices(i)/500+time.T2) (params.row3.saccade2line.indices(i)/500+time.T2)],[-100 100],'g')
                    end
                catch
                end
                axis([time.T2 time.T3 -15 15])
                legend('Vertical Eye Movement','Saccade to Key','Saccade to Lines')
            case 'row4'
                y = data.row4.vert_data+data.row4.drift_control.vert;
                t4 = time.t4_index * 0.002;
                plot(t4,y,'color',[1 0 1]);
                try
                    plot([(params.row4.saccade2key.indices(1)/500+time.T3) (params.row4.saccade2key.indices(1)/500+time.T3)],[-100 100],'r')
                    plot([(params.row4.saccade2line.indices(1)/500+time.T3) (params.row4.saccade2line.indices(1)/500+time.T3)],[-100 100],'g')
                    
                    for i = 2:params.row4.saccade2key.count
                        plot([(params.row4.saccade2key.indices(i)/500+time.T3) (params.row4.saccade2key.indices(i)/500+time.T3)],[-100 100],'r')
                    end
                    
                    for i = 2:params.row4.saccade2line.count
                        plot([(params.row4.saccade2line.indices(i)/500+time.T3) (params.row4.saccade2line.indices(i)/500+time.T3)],[-100 100],'g')
                    end
                catch
                end
                axis([time.T3 time.T4 -15 15])
                legend('Vertical Eye Movement','Saccade to Key','Saccade to Lines')
            case 'row5'
                y = data.row5.vert_data+data.row5.drift_control.vert;
                t5 = time.t5_index * 0.002;
                plot(t5,y,'color',[0 0 0]);
                try
                    plot([(params.row5.saccade2key.indices(1)/500+time.T4) (params.row5.saccade2key.indices(1)/500+time.T4)],[-100 100],'r')
                    plot([(params.row5.saccade2line.indices(1)/500+time.T4) (params.row5.saccade2line.indices(1)/500+time.T4)],[-100 100],'g')
                    
                    for i = 2:params.row5.saccade2key.count
                        plot([(params.row5.saccade2key.indices(i)/500+time.T4) (params.row5.saccade2key.indices(i)/500+time.T4)],[-100 100],'r')
                    end
                    
                    for i = 2:params.row5.saccade2line.count
                        plot([(params.row5.saccade2line.indices(i)/500+time.T4) (params.row5.saccade2line.indices(i)/500+time.T4)],[-100 100],'g')
                    end
                catch
                    %                     disp('something did not work')
                end
                axis([time.T4 time.T5 -15 15])
                legend('Vertical Eye Movement','Saccade to Key','Saccade to Lines')
        end
    case 4
        hold on
        switch row
            case 'total'
                x = data.row1.horz_data+data.row1.drift_control.horz;
                t1 = time.t1_index * 0.002;
                plot(t1,x,'color',[0 0 1]);
                
                x = data.row2.horz_data+data.row2.drift_control.horz;
                t2 = time.t2_index * 0.002;
                plot(t2,x,'color',[0 1 0]);
                
                x = data.row3.horz_data+data.row3.drift_control.horz;
                t3 = time.t3_index * 0.002;
                plot(t3,x,'color',[1 0 0]);
                
                x = data.row4.horz_data+data.row4.drift_control.horz;
                t4 = time.t4_index * 0.002;
                plot(t4,x,'color',[1 0 1]);
                
                x = data.row5.horz_data+data.row5.drift_control.horz;
                t5 = time.t5_index * 0.002;
                plot(t5,x,'color',[0 0 0]);
                
                axis([0 time.T5 -15 15])
                
            case 'firstthree'
                x = data.row1.horz_data+data.row1.drift_control.horz;
                t1 = time.t1_index * 0.002;
                plot(t1,x,'color',[0 0 1]);
                
                x = data.row2.horz_data+data.row2.drift_control.horz;
                t2 = time.t2_index * 0.002;
                plot(t2,x,'color',[0 1 0]);
                
                x = data.row3.horz_data+data.row3.drift_control.horz;
                t3 = time.t3_index * 0.002;
                plot(t3,x,'color',[1 0 0]);
                
                axis([0 time.T3 -15 15])
                
            case 'row1'
                x = data.row1.horz_data+data.row1.drift_control.horz;
                t1 = time.t1_index * 0.002;
                plot(t1,x,'color',[0 0 1]);
                axis([0 time.T1 -15 15])
            case 'row2'
                x = data.row2.horz_data+data.row2.drift_control.horz;
                t2 = time.t2_index * 0.002;
                plot(t2,x,'color',[0 1 0]);
                axis([time.T1 time.T2 -15 15])
            case 'row3'
                x = data.row3.horz_data+data.row3.drift_control.horz;
                t3 = time.t3_index * 0.002;
                plot(t3,x,'color',[1 0 0]);
                axis([time.T2 time.T3 -15 15])
            case 'row4'
                x = data.row4.horz_data+data.row4.drift_control.horz;
                t4 = time.t4_index * 0.002;
                plot(t4,x,'color',[1 0 1]);
                axis([time.T3 time.T4 -15 15])
            case 'row5'
                x = data.row5.horz_data+data.row5.drift_control.horz;
                t5 = time.t5_index * 0.002;
                plot(t5,x,'color',[0 0 0]);
                axis([time.T4 time.T5 -15 15])
        end
    case 5 % pupil plot
        hold on
        m_R = 1.56;
        b_R = 8.36;
        m_L = 1.74;
        b_L = 9.29;
        switch row
            case 'total'
                y1 = data.row1.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row1.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t1 = time.t1_index * 0.002;
                plot(t1,y1,'color',[0 0 1]);
                plot(t1,y2,'color',[0 0 .5]);
                
                y1 = data.row2.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row2.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t2 = time.t2_index * 0.002;
                plot(t2,y1,'color',[0 1 0]);
                plot(t2,y2,'color',[0 .5 0]);
                
                y1 = data.row3.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row3.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t3 = time.t3_index * 0.002;
                plot(t3,y1,'color',[1 0 0]);
                plot(t3,y2,'color',[.5 0 0]);
                
                y1 = data.row4.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row4.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t4 = time.t4_index * 0.002;
                plot(t4,y1,'color',[1 0 1]);
                plot(t4,y2,'color',[.5 0 .5]);
                
                y1 = data.row5.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row5.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t5 = time.t5_index * 0.002;
                plot(t5,y2,'color',[0 0 0]);
                plot(t5,y1,'color',[.5 .5 .5]);
                
                axis([0 time.T5 0 10])
            case 'firstthree'
                y1 = data.row1.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row1.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t1 = time.t1_index * 0.002;
                plot(t1,y1,'color',[0 0 1]);
                plot(t1,y2,'color',[0 0 .5]);
                
                y1 = data.row2.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row2.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t2 = time.t2_index * 0.002;
                plot(t2,y1,'color',[0 1 0]);
                plot(t2,y2,'color',[0 .5 0]);
                
                y1 = data.row3.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row3.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t3 = time.t3_index * 0.002;
                plot(t3,y1,'color',[1 0 0]);
                plot(t3,y2,'color',[.5 0 0]);
                
                axis([0 time.T3 0 10])
            case 'row1'
                y1 = data.row1.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row1.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t1 = time.t1_index * 0.002;
                plot(t1,y1,'color',[0 0 1]);
                plot(t1,y2,'color',[0 0 .5]);
                
                legend('Right Eye', 'Left Eye')
                
                axis([0 time.T1 0 10])
                
            case 'row2'
                y1 = data.row2.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row2.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t2 = time.t2_index * 0.002;
                plot(t2,y1,'color',[0 1 0]);
                plot(t2,y2,'color',[0 .5 0]);
                
                legend('Right Eye', 'Left Eye')
                
                axis([time.T1 time.T2 0 10])
            case 'row3'
                y1 = data.row3.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row3.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t3 = time.t3_index * 0.002;
                plot(t3,y1,'color',[1 0 0]);
                plot(t3,y2,'color',[.5 0 0]);
                
                legend('Right Eye', 'Left Eye')
                
                axis([time.T2 time.T3 0 10])
            case 'row4'
                y1 = data.row4.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row4.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t4 = time.t4_index * 0.002;
                plot(t4,y1,'color',[1 0 1]);
                plot(t4,y2,'color',[.5 0 .5]);
                
                legend('Right Eye', 'Left Eye')
                axis([time.T3 time.T4 0 10])
            case 'row5'
                y1 = data.row5.pupil_data(1,:);
%                 y1 = y1*m_R + b_R;
                y2 = data.row5.pupil_data(2,:);
%                 y2 = y2*m_L + b_L;
                t5 = time.t5_index * 0.002;
                plot(t5,y2,'color',[0 0 0]);
                plot(t5,y1,'color',[.5 .5 .5]);
                
                legend('Right Eye', 'Left Eye')
                axis([time.T4 time.T5 0 10])
        end
end
% --- Executes on button press in pb_updatedata.
function pb_updatedata_Callback(hObject, eventdata, handles)
% hObject    handle to pb_updatedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% 
% function output = num_saccades(data,row)
% % number of saccades
% 
% function output = avg_velocity(data,row)
% % avg velocity of saccades
% 
% function output = avg_fixation(data,row)
% % avg fixation time
% 
% function output = completion_time(data,row)
% % completion time
% 
% function output = num_blinks(data,row)
% % number of blinks


% --- Executes on button press in cb_vert_analyzed.
function cb_vert_analyzed_Callback(hObject, eventdata, handles)
% hObject    handle to cb_vert_analyzed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_vert_analyzed


% --- Executes on button press in pb_update_table.
function pb_update_table_Callback(hObject, eventdata, handles)
% hObject    handle to pb_update_table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% row_name = handles.row;
% try
% handles.data_table.(row_name) = show_mSDMT_data(handles.params,row_name);
% catch
%     disp('Cannot do, sorry')
%     return
% end
clear handles.data_table
% All
% data_table(1,:) = num2cell(zeros(1,8));
% 
% 
% % First Three
% data_table(2,:) = num2cell(zeros(1,8));


% 1st Row
if handles.params.row1.vert_sacc == 1
    handles.data_table.row1 = show_mSDMT_data(handles.params,'row1');
    data_table(1,1:10) = handles.data_table.row1;
    nan_index = find(isnan(handles.data.row1.data_blinks_removed.horz_data));
    handles.data.row1.pupil_data(1,nan_index) = nan;
    handles.data.row1.pupil_data(2,nan_index) = nan;
    data_table{1,11} = (nanstd(handles.data.row1.pupil_data(1,:))+...
        nanstd(handles.data.row1.pupil_data(2,:)))/2;
    data_table{1,12} = (nanmean(handles.data.row1.pupil_data(1,:))+...
        nanmean(handles.data.row1.pupil_data(2,:)))/2;
else
    data_table(1,:) = num2cell(zeros(1,12));
end
% disp(data_table)
% 2nd Row
if handles.params.row2.vert_sacc == 1
    handles.data_table.row2 = show_mSDMT_data(handles.params,'row2');
    data_table(2,1:10) = handles.data_table.row2;
    nan_index = find(isnan(handles.data.row2.data_blinks_removed.horz_data));
    handles.data.row2.pupil_data(1,nan_index) = nan;
    handles.data.row2.pupil_data(2,nan_index) = nan;
    data_table{2,11} = (nanstd(handles.data.row2.pupil_data(1,:))+...
        nanstd(handles.data.row2.pupil_data(2,:)))/2;
    data_table{2,12} = (nanmean(handles.data.row2.pupil_data(1,:))+...
        nanmean(handles.data.row2.pupil_data(2,:)))/2;
else
    data_table(2,:) = num2cell(zeros(1,12));
end
% disp(data_table)
% 3rd Row
if handles.params.row3.vert_sacc == 1
    handles.data_table.row3 = show_mSDMT_data(handles.params,'row3');
    data_table(3,1:10) = handles.data_table.row3;
    nan_index = find(isnan(handles.data.row3.data_blinks_removed.horz_data));
    handles.data.row3.pupil_data(1,nan_index) = nan;
    handles.data.row3.pupil_data(2,nan_index) = nan;
    data_table{3,11} = (nanstd(handles.data.row3.pupil_data(1,:))+...
        nanstd(handles.data.row3.pupil_data(2,:)))/2;
    data_table{3,12} = (nanmean(handles.data.row3.pupil_data(1,:))+...
        nanmean(handles.data.row3.pupil_data(2,:)))/2;
else
    data_table(3,:) = num2cell(zeros(1,12));
end

% 4th Row
if handles.params.row4.vert_sacc == 1
    handles.data_table.row4 = show_mSDMT_data(handles.params,'row4');
    data_table(4,1:10) = handles.data_table.row4;
    nan_index = find(isnan(handles.data.row4.data_blinks_removed.horz_data));
    handles.data.row4.pupil_data(1,nan_index) = nan;
    handles.data.row4.pupil_data(2,nan_index) = nan;
    data_table{4,11} = (nanstd(handles.data.row4.pupil_data(1,:))+...
        nanstd(handles.data.row4.pupil_data(2,:)))/2;
    data_table{4,12} = (nanmean(handles.data.row4.pupil_data(1,:))+...
        nanmean(handles.data.row4.pupil_data(2,:)))/2;
else
    data_table(4,:) = num2cell(zeros(1,12));
end

% 5th Row
if handles.params.row5.vert_sacc == 1
    handles.data_table.row5 = show_mSDMT_data(handles.params,'row5');
    data_table(5,1:10) = handles.data_table.row5;
    nan_index = find(isnan(handles.data.row5.data_blinks_removed.horz_data));
    handles.data.row5.pupil_data(1,nan_index) = nan;
    handles.data.row5.pupil_data(2,nan_index) = nan;
    data_table{5,11} = (nanstd(handles.data.row5.pupil_data(1,:))+...
        nanstd(handles.data.row5.pupil_data(2,:)))/2;
    data_table{5,12} = (nanmean(handles.data.row5.pupil_data(1,:))+...
        nanmean(handles.data.row5.pupil_data(2,:)))/2;
else
    data_table(5,:) = num2cell(zeros(1,12));
end

set(handles.uitable1,'data',data_table);


guidata(hObject,handles)
