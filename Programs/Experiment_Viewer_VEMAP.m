function varargout = Experiment_Viewer_VEMAP(varargin)
% EXPERIMENT_VIEWER_VEMAP MATLAB code for Experiment_Viewer_VEMAP.fig
%      EXPERIMENT_VIEWER_VEMAP, by itself, creates a new EXPERIMENT_VIEWER_VEMAP or raises the existing
%      singleton*.
%
%      H = EXPERIMENT_VIEWER_VEMAP returns the handle to a new EXPERIMENT_VIEWER_VEMAP or the handle to
%      the existing singleton*.
%
%      EXPERIMENT_VIEWER_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPERIMENT_VIEWER_VEMAP.M with the given input arguments.
%
%      EXPERIMENT_VIEWER_VEMAP('Property','Value',...) creates a new EXPERIMENT_VIEWER_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Experiment_Viewer_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Experiment_Viewer_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release

% Edit the above text to modify the response to help Experiment_Viewer_VEMAP

% Last Modified by GUIDE v2.5 27-Oct-2015 12:40:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Experiment_Viewer_VEMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @Experiment_Viewer_VEMAP_OutputFcn, ...
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


% --- Executes just before Experiment_Viewer_VEMAP is made visible.
function Experiment_Viewer_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Experiment_Viewer_VEMAP (see VARARGIN)

% Choose default command line output for Experiment_Viewer_VEMAP
handles.output = hObject;

% Code for displaying NJIT's Logo
axes(handles.NJIT);
imshow('njit-logo.jpg')
% Code for displaying VNEL's Logo
axes(handles.VNEL);
imshow('VNEL_final.png')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Experiment_Viewer_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Experiment_Viewer_VEMAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pop_stimulus.
function pop_stimulus_Callback(hObject, eventdata, handles)
% hObject    handle to pop_stimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_stimulus contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_stimulus
str = get(hObject,'string');
val = get(hObject,'value');

handles.curr_stim = str{val};

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function pop_stimulus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_stimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_section.
function pop_section_Callback(hObject, eventdata, handles)
% hObject    handle to pop_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_section contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_section

str = get(hObject,'string');
val = get(hObject,'value');

section = str{val};
handles.curr_section = section;

% update stimulus pop menu
new_stim = fieldnames(handles.data.(section));

set(handles.pop_stimulus,'value',1);
set(handles.pop_stimulus,'string',new_stim);

handles.curr_stim = new_stim{1};

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function pop_section_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_config_load.
function pb_config_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_config_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = ...
    uigetfile('*.protocol.mat','Select Experimental Protocol',(''),'MultiSelect','off');

set(handles.text_configfile,'string',['Current Config File: ' (FileName(1:end-13))])

load([PathName FileName])

handles.protocol = protocol;
handles.calibration = calibration;
% handles.issaccade = issaccade;

guidata(hObject,handles)



% --- Executes on button press in pb_config_create.
function pb_config_create_Callback(hObject, eventdata, handles)
% hObject    handle to pb_config_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Protocol_Maker;

% --- Executes on button press in pb_config_edit.
function pb_config_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_config_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_data_load.
function pb_data_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_data_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [RawData,CalData] = Preprocess;

% [FileName,PathName] = ...
%     uigetfile('*.data.mat','Select the raw data file',(''),'MultiSelect','off');
[FileName,PathName] = ...
    uigetfile('*.mat','Select the raw data file',(''),'MultiSelect','off');
load([PathName FileName])
% disp([PathName FileName])
set(handles.edit_data,'string',FileName);

% using the config file to parse out the data
a = fieldnames(handles.protocol);
for i = 1:length(a)
    
    b = fieldnames(handles.protocol.(a{i}));
    
    for j = 1:length(b)
        handles.data.(a{i}).(b{j}) = RawData(handles.protocol.(a{i}).(b{j}));
    end
end

section_str = fieldnames(handles.protocol);

handles.curr_section = section_str{1};

stim_str = fieldnames(handles.protocol.(handles.curr_section));
handles.curr_stim = stim_str{1};

%update section and stimulus popmenus
set(handles.pop_section,'string',section_str);
set(handles.pop_section,'value',1);
set(handles.pop_stimulus,'string',stim_str);
set(handles.pop_stimulus,'value',1);

%%%%%%%% do calibration

% separate the calibration cells

calibration = handles.calibration;
%%
a = fieldnames(calibration); % the number of calibrations

n = 1; % initiating cal number

% parse data
for i = 1:length(a)
    n_beg = n;
    % total length per each cal and separate to each calibration
    if isfield(calibration.(a{i}),'VERTseq')==1
        n = n+length(calibration.(a{i}).LEseq)+length(calibration.(a{i}).REseq)...
            +length(calibration.(a{i}).VERTseq);
        n_end = n-4;
    else
%         disp(calibration);
        n = n+length(calibration.(a{i}).LEseq)+length(calibration.(a{i}).REseq);
        n_end = n-1;
    end
    
    caldata.(a{i}).data = CalData(n_beg:n_end);     
end
%%
% take out calibration data sets pertaining to vert cals, if needed...
% figure out what to do with this later...
% 
% 
% a = fieldnames(calibration); % the number of calibrations
% 
% if isfield(calibration.(a{1}),'VERTseq')
%     1;
% 
% end  
%%  

% do calibration
for i = 1:length(a)
    
    b = length(caldata.(a{i}).data);
    
    % get data sets for left and right eye
    if calibration.(a{i}).first_eye == 1
        LEdata = caldata.(a{i}).data(1:b/2);
        REdata = caldata.(a{i}).data((b/2)+1:b);
    else
        REdata = caldata.(a{i}).data(1:b/2);
        LEdata = caldata.(a{i}).data((b/2)+1:b);
    end

    CalPoints_L = calibration.(a{i}).LEseq;
    CalPoints_R = calibration.(a{i}).REseq;
    axis = calibration.(a{i}).axis;
    
    [pL,pR,rL,rR] = Calibrate(LEdata,REdata,CalPoints_L,CalPoints_R,axis);
%     
%     if handles.issaccade.(a{i})==1;
%         caldata.(a{i}).L_gain = pL(1);
%     else
%         caldata.(a{i}).L_gain = pL(1)*(-1);
%     end
    
    caldata.(a{i}).L_gain = pL(1);
    
    caldata.(a{i}).R_gain = pR(1);
    caldata.(a{i}).L_corr = rL;
    caldata.(a{i}).R_corr = rR;
end

% non calibrated (original data goes first)

caldata.no_calibration.L_gain = -1.00;
caldata.no_calibration.R_gain = 1.00;

% string for calibration listbox
cal_string = {'no_calibration'};
handles.cal_string = [cal_string; a];

% update calibration listbox
set(handles.lb_calibration,'string',handles.cal_string)

% initial calibration is no calibration
handles.Lgain = -1.00;
handles.Rgain = 1.00;

% update stuff
handles.caldata = caldata;

% update handles
guidata(hObject,handles);


function edit_data_Callback(hObject, eventdata, handles)
% hObject    handle to edit_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_data as text
%        str2double(get(hObject,'String')) returns contents of edit_data as a double


% --- Executes during object creation, after setting all properties.
function edit_data_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_plottype.
function pop_plottype_Callback(hObject, eventdata, handles)
% hObject    handle to pop_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value')==1
    set(handles.cb_lefteye,'value',0)
    set(handles.cb_righteye,'value',0)
    set(handles.cb_version,'value',0)
    set(handles.cb_vergence,'value',1)
end
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


% --- Executes on button press in cb_velocity.
function cb_velocity_Callback(hObject, eventdata, handles)
% hObject    handle to cb_velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_velocity
plottype = get(handles.pop_plottype,'value');

section = handles.curr_section;
stim = handles.curr_stim;

velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 1
    ensembleplot(data1,datatoplot,velplot)
end

if plottype == 2
    trialplot(data1,datatoplot,velplot,handles.curr_trial)
end

% --- Executes on button press in cb_lefteye.
function cb_lefteye_Callback(hObject, eventdata, handles)
% hObject    handle to cb_lefteye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_lefteye
plottype = get(handles.pop_plottype,'value');

if plottype == 1
    set(handles.cb_lefteye,'value',1)
    set(handles.cb_righteye,'value',0)
    set(handles.cb_version,'value',0)
    set(handles.cb_vergence,'value',0)
end

section = handles.curr_section;
stim = handles.curr_stim;

velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 1
    ensembleplot(data1,datatoplot,velplot)
end

if plottype == 2
    trialplot(data1,datatoplot,velplot,handles.curr_trial)
end

% --- Executes on button press in cb_righteye.
function cb_righteye_Callback(hObject, eventdata, handles)
% hObject    handle to cb_righteye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_righteye
plottype = get(handles.pop_plottype,'value');

if plottype == 1
    set(handles.cb_lefteye,'value',0)
    set(handles.cb_righteye,'value',1)
    set(handles.cb_version,'value',0)
    set(handles.cb_vergence,'value',0)
end

section = handles.curr_section;
stim = handles.curr_stim;

velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 1
    ensembleplot(data1,datatoplot,velplot)
end

if plottype == 2
    trialplot(data1,datatoplot,velplot,handles.curr_trial)
end

% --- Executes on button press in cb_version.
function cb_version_Callback(hObject, eventdata, handles)
% hObject    handle to cb_version (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_version
plottype = get(handles.pop_plottype,'value');

if plottype == 1
    set(handles.cb_lefteye,'value',0)
    set(handles.cb_righteye,'value',0)
    set(handles.cb_version,'value',1)
    set(handles.cb_vergence,'value',0)
end

section = handles.curr_section;
stim = handles.curr_stim;

velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 1
    ensembleplot(data1,datatoplot,velplot)
end

if plottype == 2
    trialplot(data1,datatoplot,velplot,handles.curr_trial)
end

% --- Executes on button press in cb_vergence.
function cb_vergence_Callback(hObject, eventdata, handles)
% hObject    handle to cb_vergence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_vergence
plottype = get(handles.pop_plottype,'value');

if plottype == 1
    set(handles.cb_lefteye,'value',0)
    set(handles.cb_righteye,'value',0)
    set(handles.cb_version,'value',0)
    set(handles.cb_vergence,'value',1)
end

section = handles.curr_section;
stim = handles.curr_stim;

velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 1
    ensembleplot(data1,datatoplot,velplot)
end

if plottype == 2
    trialplot(data1,datatoplot,velplot,handles.curr_trial)
end

% --- Executes on selection change in lb_calibration.
function lb_calibration_Callback(hObject, eventdata, handles)
% hObject    handle to lb_calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_calibration contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_calibration

str = get(hObject,'string');
val = get(hObject,'value');

cal = str{val};

% based on which cal is chosen, update the gain values

handles.Lgain = handles.caldata.(cal).L_gain;
handles.Rgain = handles.caldata.(cal).R_gain;

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function lb_calibration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_viewdata.
function pb_viewdata_Callback(hObject, eventdata, handles)
% hObject    handle to pb_viewdata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.curr_section;
stim = handles.curr_stim;

plottype = get(handles.pop_plottype,'value');
velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 1 % ensemble plot
    
    ensembleplot(data1,datatoplot,velplot)
    
elseif plottype == 2 % sample plot
    handles.curr_trial = 1;
    set(handles.text4,'string',['Current Trial #: ' num2str(handles.curr_trial)])
    trialplot(data1,datatoplot,velplot,1)
    
elseif plottype == 3 % mean plot
    
    meanplot(data,datatoplot,velplot);
    
end

guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOTTING FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function trialplot(data,datatoplot,velplot,current_trial)
cla
hold on

% % % % % % Do the code here.
T = length(data{current_trial})/500;
t = 0.002:0.002:T;

b = 0;
if velplot == 0
    if datatoplot(1) == 1 % plot righteye
        right(1,:) = transpose(smooth(data{current_trial}(1,:)));
        right(1,:) = right(1,:) - mean(right(1:50));
        b(end+1) = round(max(abs((right(1,:))))+max(abs((right(1,:))))/3+1);
        plot(t,right,'r','linewidth',2)
    end
    
    if datatoplot(2) == 1 % plot lefteye
        left(1,:) = transpose(smooth(data{current_trial}(2,:)));
        left(1,:) = left(1,:) - mean(left(1:50));
        b(end+1) = round(max(abs((left(1,:))))+max(abs((left(1,:))))/3+1);
        plot(t,left,'b','linewidth',2)
    end
    
    if datatoplot(3) == 1 % plot vergence
        vergence(1,:) = data{current_trial}(1,:)+data{current_trial}(2,:);
        vergence(1,:) = vergence(:) - mean(vergence(1:50));
        b(end+1) = round(max(abs((vergence(1,:))))+max(abs((vergence(1,:))))/3+1);
        plot(t,vergence,'g','linewidth',2)
    end
    
    if datatoplot(4) == 1 % plot version
        version(1,:) = (data{current_trial}(2,:)-data{current_trial}(1,:))/2;
        version(1,:) = version(:) - mean(version(1:50));
        b(end+1) = round(max(abs((version(1,:))))+max(abs((version(1,:))))/3+1);
        plot(t,version,'k','linewidth',2)
    end
    
    plot([0 T],[0 0],'-k')
    c = max(b);
    xlabel('Time (s)')
    ylabel('Position (deg)')
    title('Trial Position Plot')
    axis([0 T -c c])

else
    if datatoplot(1) == 1 % plot righteye
        right(1,:) = PositionToVelocity(transpose(smooth(data{current_trial}(1,:))));
        right(1,:) = right(1,:) - mean(right(1:50));
        b(end+1) = round(max(abs((right(1,:))))+max(abs((right(1,:))))/3+1);
        plot(t,right,'r','linewidth',2)
    end
    
    if datatoplot(2) == 1 % plot lefteye
        left(1,:) = PositionToVelocity(transpose(smooth(data{current_trial}(2,:))));
        left(1,:) = left(1,:) - mean(left(1:50));
        b(end+1) = round(max(abs((left(1,:))))+max(abs((left(1,:))))/3+1);
        plot(t,left,'b','linewidth',2)
    end
    
    if datatoplot(3) == 1 % plot vergence
        vergence(1,:) = PositionToVelocity(data{current_trial}(1,:)+data{current_trial}(2,:));
        vergence(1,:) = vergence(:) - mean(vergence(1:50));
        b(end+1) = round(max(abs((vergence(1,:))))-max(abs((vergence(1,:))))/3+1);
        plot(t,vergence,'g','linewidth',2)
    end
    
    if datatoplot(4) == 1 % plot version
        version(1,:) = PositionToVelocity((data{current_trial}(2,:)-data{current_trial}(1,:))/2);
        version(1,:) = version(:) - mean(version(1:50));
        b(end+1) = round(max(abs((version(1,:))))+max(abs((version(1,:))))/3+1);
        plot(t,version,'k','linewidth',2)
    end
    
    plot([0 T],[0 0],'-k')
    c = max(b);
    xlabel('Time (s)')
    ylabel('Velocity (deg/s)')
    title('Trial Velocity Plot')
    axis([0 T -c c])
    
end
    
    


function ensembleplot(data,datatoplot,velplot)
% datatoplot: righteye [1 0 0 0], lefteye [0 1 0 0], 
% vergence[0 0 1 0], version [0 0 0 1]

if datatoplot == [1 0 0 0] % right data    
    data1 = zeros(length(data),length(data{1}));
    for i = 1:length(data)
        data1(i,:) = data{i}(1,:);
        a = mean(data1(i,1:50));
        data1(i,:) = data1(i,:)-a;
    end    
    
elseif datatoplot == [0 1 0 0] % left data
    data1 = zeros(length(data),length(data{1}));
    for i = 1:length(data)
        data1(i,:) = data{i}(2,:);
        a = mean(data1(i,1:50));
        data1(i,:) = data1(i,:)-a;
    end    

elseif datatoplot == [0 0 1 0] % vergence
    data1 = zeros(length(data),length(data{1}));
    for i = 1:length(data)
        data1(i,:) = data{i}(1,:) + data{i}(2,:);
        a = mean(data1(i,1:50));
        data1(i,:) = data1(i,:)-a;
    end

elseif datatoplot == [0 0 0 1] % version
    data1 = zeros(length(data),length(data{1}));
    for i = 1:length(data)
        data1(i,:) = (data{i}(2,:) - data{i}(1,:))/2;
        a = mean(data1(i,1:50));
        data1(i,:) = data1(i,:)-a;
    end

end

cla
hold on

T = length(data1)/500;
t = 0.002:0.002:T;
a = size(data1);
position = zeros(a(1),a(2));
velocity = zeros(a(1),a(2));
if velplot == 0
    for i = 1:a(1) %ensemble
        position(i,:) = transpose(smooth(data1(i,:),20));
        plot(t,position(i,:),'color',[0.4 0.5 0.4])
    end
    
    meanplot = zeros(1,a(2));
    for i = 1:a(2)
        meanplot(i) = mean(position(:,i));
    end
    
    plot(t,meanplot,'g','linewidth',2) %mean
    plot([0 T],[0 0],'-k')
    
    b = round((max(abs(meanplot)))+max(abs(meanplot))/3+1);
    
%     disp(max(meanplot))
%     disp(b)
    
    %plot values
    xlabel('Time (s)')
    ylabel('Position (deg)')
    title('Ensemble Position Plot')
    axis([0 T -b b])
    
else
    for i = 1:a(1) %ensemble
        position(i,:) = transpose(smooth(data1(i,:),20));
        velocity(i,:) = PositionToVelocity(position(i,:));
        plot(t,velocity(i,:),'color',[0.4 0.5 0.4])
    end
    
    meanplot = zeros(1,a(2));
    for i = 1:a(2)
        meanplot(i) = mean(velocity(:,i));
    end
    
    plot(t,meanplot,'g','linewidth',2) %mean
    plot([0 T],[0 0],'-k')
    
    b = round((max(abs(meanplot)))+max(abs(meanplot))/3+1);
    
%     disp(max(meanplot))
%     disp(b)
    
    %plot values
    xlabel('Time (s)')
    ylabel('Velocity (deg/s)')
    title('Ensemble Velocity Plot')
    axis([0 T -b b])
    
end


function stdplot_pos(data)
%%
cla
hold on
a = size(data);
T = length(data)/500;
t = 0.002:0.002:T;

% get mean of the data set
for i = 1:a(1) %position and velocity
    position(i,:) = transpose(smooth(data(i,:),40));
    velocity(i,:) = PositionToVelocity(position(i,:));
    %     plot(position,velocity(i,:),'color',[0.4 0.5 0.4])
end


for i = 1:a(2)
    meanplot(1,i) = mean(velocity(:,i));
    meanplot(2,i) = mean(position(:,i));
    stdplot(1,i) = std(velocity(:,i));
    stdplot(2,i) = std(position(:,i));
end

plot(t,meanplot(2,:),'g','linewidth',2)
plotshaded(t,[meanplot(2,:)-stdplot(2,:);meanplot(2,:)+stdplot(2,:)],'g')

%plot values
xlabel('Time (s)')
ylabel('Position (deg)')
title('Position Plot w/ Standard Deviation')
axis([0 T -8 8])



function stdplot_vel(data)
%%
cla
hold on
a = size(data);
T = length(data)/500;
t = 0.002:0.002:T;

% get mean of the data set
for i = 1:a(1) %position and velocity
    position(i,:) = transpose(smooth(data(i,:),40));
    velocity(i,:) = PositionToVelocity(position(i,:));
    %     plot(position,velocity(i,:),'color',[0.4 0.5 0.4])
end


for i = 1:a(2)
    meanplot(1,i) = mean(velocity(:,i));
    meanplot(2,i) = mean(position(:,i));
    stdplot(1,i) = std(velocity(:,i));
    stdplot(2,i) = std(position(:,i));
end

plot(t,meanplot(1,:),'g','linewidth',2)
plotshaded(t,[meanplot(1,:)-stdplot(1,:);meanplot(1,:)+stdplot(1,:)],'g')

%plot values
xlabel('Time (s)')
ylabel('Velocity (deg/s)')
title('Velocity Plot w/ Standard Deviation')
axis([0 T -40 40])

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % OTHER FUNCTIONS 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function [output] = apply_gain(data,Rgain,Lgain)

for i = 1:length(data)
    data1{i}(1,:) = data{i}(1,:)*Rgain;
    data1{i}(2,:) = data{i}(2,:)*Lgain;
end

output = data1;
%%
% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save('TEST','handles')


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
section = handles.curr_section;
stim = handles.curr_stim;

plottype = get(handles.pop_plottype,'value');
velplot = get(handles.cb_velocity,'value'); % does operator want to see velocity?

data = handles.data.(section).(stim);

% apply calibration gains to data.
data1 = apply_gain(data,handles.Rgain,handles.Lgain);

% sorting the data to plot
right = get(handles.cb_righteye,'value');
left = get(handles.cb_lefteye,'value');
verg = get(handles.cb_vergence,'value');
vers = get(handles.cb_version,'value');

datatoplot = [right left verg vers];

axes(handles.axes1)

if plottype == 2
   switch eventdata.Key
       case 'rightarrow'
           handles.curr_trial = handles.curr_trial+1;
           if handles.curr_trial > length(data1)
               handles.curr_trial = 1;
           end
           
           set(handles.text4,'string',['Current Trial #: ' num2str(handles.curr_trial)])
           trialplot(data1,datatoplot,velplot,handles.curr_trial)
       
       case 'leftarrow'
           handles.curr_trial = handles.curr_trial-1;
           if handles.curr_trial < 1
               handles.curr_trial = length(data1);
           end
           
           set(handles.text4,'string',['Current Trial #: ' num2str(handles.curr_trial)])
           trialplot(data1,datatoplot,velplot,handles.curr_trial)
           
   end
end

guidata(hObject,handles)
