function varargout = Calibration_VEMAP(varargin)
% CALIBRATION_VEMAP MATLAB code for Calibration_VEMAP.fig
% Version 1.0
%      CALIBRATION_VEMAP, by itself, creates a new CALIBRATION_VEMAP or raises the existing
%      singleton*.
%
%      H = CALIBRATION_VEMAP returns the handle to a new CALIBRATION_VEMAP or the handle to
%      the existing singleton*.
%
%      CALIBRATION_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIBRATION_VEMAP.M with the given input arguments.
%
%      CALIBRATION_VEMAP('Property','Value',...) creates a new CALIBRATION_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calibration_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calibration_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/02/16    Added manual scaling. Worked on the horizontal vs. vertical
%                   plotting.
% 1.2   03/21/16    Added auto blink removal
% 1.3   02/25/18    Added some hotkeys

% Edit the above text to modify the response to help Calibration_VEMAP

% Last Modified by GUIDE v2.5 25-Feb-2018 08:08:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Calibration_VEMAP_OpeningFcn, ...
    'gui_OutputFcn',  @Calibration_VEMAP_OutputFcn, ...
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


% --- Executes just before Calibration_VEMAP is made visible.
function Calibration_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calibration_VEMAP (see VARARGIN)
handles.scaling.comb.manual = 0;
handles.scaling.comb.min = -10;
handles.scaling.comb.max = 10;

handles.scaling.right.manual = 0;
handles.scaling.right.min = -10;
handles.scaling.right.max = 10;

handles.scaling.left.manual = 0;
handles.scaling.left.min = -10;
handles.scaling.left.max = 10;

handles.auto_blink = 0;

% pupil calibration: Cal Date 06/07/2016 


% Choose default command line output for Calibration_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% UIWAIT makes Calibration_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calibration_VEMAP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pb_protocol.
function pb_protocol_Callback(hObject, eventdata, handles)
% hObject    handle to pb_protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = ...
    uigetfile('*.protocol.mat','Select Experimental Protocol',('Protocols\'),'MultiSelect','off');

if FileName == 0
    return
end

set(handles.text_protocol,'string',FileName(1:end-13))

load([PathName FileName])
handles.FileName = FileName;
handles.protocol = protocol;
handles.calibration = calibration;
% handles.issaccade = issaccade;
handles.mode = 'Vergence';
handles.axis = 1;

guidata(hObject,handles)

% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% open and load data
[handles.FileName,handles.PathName] = uigetfile('*.mat*','Select the data file',('Data\Preprocessed'));
% set(handles.cb_saccadeexp,'value',0)

if handles.FileName == 0
    return
end
modes = {'vergence_horz' 'vergence_vert' 'version_horz' 'version_vert'};
handles.saccadeexp = 0;

load([handles.PathName handles.FileName]);


% using the config file to parse out the data
a = fieldnames(handles.protocol);
for i = 1:length(a)
    
    b = fieldnames(handles.protocol.(a{i}));
    
    for j = 1:length(b)
        handles.eye_movements.(a{i}).(b{j}) = RawData(handles.protocol.(a{i}).(b{j}));
        for k = 1:length(handles.protocol.(a{i}).(b{j})) % initializing the data structure
            handles.data.(a{i}).(b{j})(k).eye_movements...
                = RawData{handles.protocol.(a{i}).(b{j})(k)};
            handles.data.(a{i}).(b{j})(k).num_seq = handles.protocol.(a{i}).(b{j})(k);
            handles.data.(a{i}).(b{j})(k).cals = [];
            handles.data.(a{i}).(b{j})(k).classifications = [];
%             
%             for h = 1:4
%                 handles.data.(a{i}).(b{j})(k).(modes{h}).vpeak = [];
%                 handles.data.(a{i}).(b{j})(k).(modes{h}).response_amplitude = [];
%                 handles.data.(a{i}).(b{j})(k).(modes{h}).latency = [];
%                 handles.data.(a{i}).(b{j})(k).(modes{h}).tpeak = [];
%                 handles.data.(a{i}).(b{j})(k).(modes{h}).tsettle = [];
%             end
        end
    end
    handles.calibrated.(a{i}) = 0;
end

section_str = fieldnames(handles.protocol);
handles.section_names = section_str;

for i = 1:length(handles.section_names)
handles.calibrated.(handles.section_names{i}) = 0;
end
handles.section = section_str{1};
set(handles.cb_complete,'Value',handles.calibrated.(handles.section))
stim_str = fieldnames(handles.protocol.(handles.section));
handles.move = stim_str{1};

%update section and stimulus popmenus
set(handles.lb_section,'string',section_str);
set(handles.lb_section,'value',1);
set(handles.lb_movements,'string',stim_str);
set(handles.lb_movements,'value',1);
set(handles.pop_mode,'value',1);
handles.mode = 'Vergence';
set(handles.text10,'string',handles.FileName);

handles.tmp = handles.eye_movements.(handles.section).(handles.move);

%%
calibration = handles.calibration; % just makes it easier

%%
n = 1; % initiating cal number
a = fieldnames(calibration); % the number of calibrations
% parse data
for i = 1:length(a)
    n_beg = n;
%     a{i};
    % total length per each cal and separate to each calibration
    if calibration.(a{i}).type == 1
        n = n+length(calibration.(a{i}).LEseq)+length(calibration.(a{i}).REseq);
        n_end = n-1;
    else
        n = n+length(calibration.(a{i}).LEseq);
        n_end = n-1;
    end
%     disp(n_beg)
%     disp(n_end)
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
%     disp(a{i});
    b = length(caldata.(a{i}).data);
%     disp(b);
    % get data sets for left and right eye
    
    if calibration.(a{i}).type == 2
        LEdata = caldata.(a{i}).data(1:b);
        REdata = caldata.(a{i}).data(1:b);
        CalPoints_L = calibration.(a{i}).LEseq;
        CalPoints_R = calibration.(a{i}).REseq;
    else
        if calibration.(a{i}).first_eye == 1
            LEdata = caldata.(a{i}).data(1:b/2);
            REdata = caldata.(a{i}).data((b/2)+1:b);
        else
            REdata = caldata.(a{i}).data(1:b/2);
            LEdata = caldata.(a{i}).data((b/2)+1:b);
        end
        CalPoints_L = calibration.(a{i}).LEseq;
        CalPoints_R = calibration.(a{i}).REseq;
    end
    
    if calibration.(a{i}).axis == 1
    end
    
 % figure out vertical sometime   
    
    [pL,pR,rL,rR] = Calibrate(LEdata,REdata,CalPoints_L,CalPoints_R,...
        calibration.(a{i}).axis);
    
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
%%
% non calibrated (original data goes first)

caldata.no_calibration.L_gain = -1.00;
caldata.no_calibration.R_gain = 1.00;

set(handles.rb_experiment,'value',1)

% string for calibration listbox
cal_string = {'no_calibration'};
handles.cal_string = [cal_string; a];

% update calibration listbox
set(handles.lb_cals,'string',handles.cal_string)
set(handles.lb_cals,'value',1)

set(handles.text_lgain,'string',' ')
set(handles.text_rgain,'string',' ')
set(handles.text_lcorr,'string',' ')
set(handles.text_rcorr,'string',' ')

% initial calibration is no calibration
handles.x_lgain = -1.00;
handles.x_rgain = 1.00;
handles.y_lgain = 1.00;
handles.y_rgain = 1.00;

% do plots
handles.sac = 0;
if handles.axis == 1
    handles.tmp1 = apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1); % tmp1 is data with gain changed
else
    handles.tmp1 = apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2); % tmp1 is data with gain changed
end

% plots
axes(handles.plot_left)
cla
ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_right)
cla
ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_comb)
cla
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)

% update stuff
handles.caldata = caldata;

% update handles
guidata(hObject,handles);


% --- Executes on button press in pb_calibrate.
function pb_calibrate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_calibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
b = fieldnames(handles.data.(section));
l = length(b);

for i = 1:l
    for j = 1:length(handles.eye_movements.(section).(b{i}))
        
        % transforming the eye movements
        handles.eye_movements1.(section).(b{i}){j}(1,:)= handles.eye_movements.(section).(b{i}){j}(1,:)*handles.x_rgain;
        handles.eye_movements1.(section).(b{i}){j}(2,:)= handles.eye_movements.(section).(b{i}){j}(2,:)*handles.x_lgain;
        handles.eye_movements1.(section).(b{i}){j}(3,:)= handles.eye_movements.(section).(b{i}){j}(5,:)*handles.y_rgain;
        handles.eye_movements1.(section).(b{i}){j}(4,:)= handles.eye_movements.(section).(b{i}){j}(3,:)*handles.y_lgain;
        
        tmp = handles.eye_movements1.(section).(b{i}){j};
        
        % filling in the data
        % gains
        handles.data.(section).(b{i})(j).cals.x_rgain = handles.x_rgain;
        handles.data.(section).(b{i})(j).cals.x_lgain = handles.x_lgain;
        handles.data.(section).(b{i})(j).cals.y_rgain = handles.y_rgain;
        handles.data.(section).(b{i})(j).cals.y_lgain = handles.y_lgain;
        
    end
end


handles.calibrated.(handles.section) = 1;
set(handles.cb_complete,'Value',handles.calibrated.(section))

%uiwait(msgbox(['Calibration for movements for ' handles.section ' has been completed.'],'Calibration Complete','modal'));

% future update to add vertical calibrations, if necessary

% Update handles structure
guidata(hObject, handles);

function text_legain_Callback(hObject, eventdata, handles)
% hObject    handle to text_legain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_legain as text
%        str2double(get(hObject,'String')) returns contents of text_legain as a double
input = str2double(get(hObject,'string'));
if isnan(input)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
    % else
    %     display(input)
end


% if plot is on custom calibration, apply gains and update plot
if get(handles.rb_custom,'Value') == 1
        
    % apply gain to the data
    if handles.axis == 1
        handles.x_lgain = input;
        handles.tmp1 = apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1); % tmp1 is data with gain changed
    else
        handles.y_lgain = input;
        handles.tmp1 = apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2); % tmp1 is data with gain changed
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
    % plots
    axes(handles.plot_left)
    cla
    ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
    
    
    axes(handles.plot_right)
    cla
    ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
    
    
    axes(handles.plot_comb)
    cla
    ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
end

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function text_legain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_legain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text_regain_Callback(hObject, eventdata, handles)
% hObject    handle to text_regain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_regain as text
%        str2double(get(hObject,'String')) returns contents of text_regain as a double
input = str2double(get(hObject,'string'));
if isnan(input)
    errordlg('You must enter a numeric value','Invalid Input','modal')
    uicontrol(hObject)
    return
    % else
    %     display(input)
end

% if plot is on custom calibration, apply gains and update plot
if get(handles.rb_custom,'Value') == 1
    if handles.axis == 1
        handles.x_rgain = input;
        handles.tmp1 = apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1); % tmp1 is data with gain changed
    else
        handles.y_rgain = input;
        handles.tmp1 = apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2); % tmp1 is data with gain changed
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
    % plots
    axes(handles.plot_left)
    cla
    ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
    
    
    axes(handles.plot_right)
    cla
    ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
    
    
    axes(handles.plot_comb)
    cla
    ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function text_regain_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_regain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_cals.
function lb_cals_Callback(hObject, eventdata, handles)
% hObject    handle to lb_cals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_cals contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_cals

if get(handles.rb_experiment,'Value') == 1
    cal_str = get(handles.lb_cals,'string');
    cal_val = get(handles.lb_cals,'value');
    a = cal_str{cal_val};
%     disp(a)
%     strcmp(a,'no_calibration')
    
    % apply gain to the data
    if handles.axis == 1
        handles.x_rgain = handles.caldata.(a).R_gain;
        handles.x_lgain = handles.caldata.(a).L_gain;
        handles.tmp1 = apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1); % tmp1 is data with gain changed
    else
        handles.y_rgain = handles.caldata.(a).R_gain;
        handles.y_lgain = handles.caldata.(a).L_gain;
        handles.tmp1 = apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2); % tmp1 is data with gain changed
    end
    
    if strcmp(a,'no_calibration') == 0
        if handles.axis == 1
            set(handles.text_lgain,'string',handles.x_lgain)
            set(handles.text_rgain,'string',handles.x_rgain)
        else
            set(handles.text_lgain,'string',handles.y_lgain)
            set(handles.text_rgain,'string',handles.y_rgain)
        end
        set(handles.text_lcorr,'string',abs(handles.caldata.(a).L_corr))
        set(handles.text_rcorr,'string',abs(handles.caldata.(a).R_corr))
    else
        set(handles.text_lgain,'string',' ')
        set(handles.text_rgain,'string',' ')
        set(handles.text_lcorr,'string',' ')
        set(handles.text_rcorr,'string',' ')
    end
    % Update handles structure
    guidata(hObject, handles);
    
    % plots
    axes(handles.plot_left)
    cla
    ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
    
    
    axes(handles.plot_right)
    cla
    ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
    
    
    axes(handles.plot_comb)
    cla
    ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
else
    
    cal_str = get(handles.lb_cals,'string');
    cal_val = get(handles.lb_cals,'value');
    a = cal_str{cal_val};
    
    if strcmp(a,'no_calibration') == 0
        set(handles.text_lgain,'string',handles.caldata.(a).L_gain)
        set(handles.text_rgain,'string',handles.caldata.(a).R_gain)
        set(handles.text_lcorr,'string',abs(handles.caldata.(a).L_corr))
        set(handles.text_rcorr,'string',abs(handles.caldata.(a).R_corr))
    else
        set(handles.text_lgain,'string',' ')
        set(handles.text_rgain,'string',' ')
        set(handles.text_lcorr,'string',' ')
        set(handles.text_rcorr,'string',' ')
    end
end



% --- Executes during object creation, after setting all properties.
function lb_cals_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_cals (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_movements.
function lb_movements_Callback(hObject, eventdata, handles)
% hObject    handle to lb_movements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
i = get(hObject,'value');
str = get(hObject,'string');
handles.move = str{i};

handles.tmp = handles.eye_movements.(handles.section).(handles.move);
% disp(handles.tmp);
if handles.axis == 1
    handles.tmp1= apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1);
else
    handles.tmp1= apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2);
end

% plots
axes(handles.plot_left)
cla
ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_right)
cla
ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_comb)
cla
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function lb_movements_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_movements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'rb_experiment'
        lb_cals_Callback(hObject, eventdata, handles)
    case 'rb_custom'
        if handles.axis == 1
            handles.x_rgain = str2double(get(handles.text_regain,'string'));
            handles.x_lgain = str2double(get(handles.text_legain,'string'));
            handles.tmp1= apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1);
        else
            handles.y_rgain = str2double(get(handles.text_regain,'string'));
            handles.y_lgain = str2double(get(handles.text_legain,'string'));
            handles.tmp1= apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2);
        end
        
        % plots
        axes(handles.plot_left)
        cla
        ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
        
        
        axes(handles.plot_right)
        cla
        ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
        
        
        axes(handles.plot_comb)
        cla
        ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
end



% Update handles structure
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns lb_movements contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_movements



% --- Executes on button press in cb_complete.
function cb_complete_Callback(hObject, eventdata, handles)
% hObject    handle to cb_complete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_complete


% --- Executes on selection change in text4.
function lb_section_Callback(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
j = get(handles.lb_section,'Value');
str = get(handles.lb_section,'string');

handles.section = handles.section_names{j};

a = fieldnames(handles.data.(str{j}));

set(handles.lb_movements,'string',a);
set(handles.lb_movements,'value',1);
handles.move = a{1};

set(handles.cb_complete,'Value',handles.calibrated.(handles.section))

handles.tmp = handles.eye_movements.(handles.section).(handles.move);

if handles.axis == 1
    handles.tmp1= apply_gain(handles.tmp,handles.x_rgain,handles.x_lgain,1);
else
    handles.tmp1= apply_gain(handles.tmp,handles.y_rgain,handles.y_lgain,2);
end

% plots
axes(handles.plot_left)
cla
ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_right)
cla
ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_comb)
cla
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)

% Update handles structure
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns text4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from text4


% --- Executes during object creation, after setting all properties.
function lb_section_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

eye_movements = handles.eye_movements1;
data = handles.data;
% filename = input('Rename file: ','s');
save(['Data\Processed\' handles.FileName],'eye_movements','data')
uiwait(msgbox('Calibration data has been saved!','Saved','modal'));


% --- Executes on button press in pb_quit.
function pb_quit_Callback(hObject, eventdata, handles)
% hObject    handle to pb_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on selection change in pop_mode.
function pop_mode_Callback(hObject, eventdata, handles)
% hObject    handle to pop_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mode_str = get(hObject,'string');
mode_val = get(hObject,'value');
handles.mode = mode_str{mode_val};

axes(handles.plot_comb)
cla
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns pop_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_mode


% --- Executes during object creation, after setting all properties.
function pop_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% Plotting Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ens_plot(tmp,mode,axis_mode,scaling,blink)
% plots an ensemble plot of the vergence data
hold on
cla
a = length(tmp);
b = size(tmp{1});
% disp(a)
T = b(2)*0.002;
t = 0.002:0.002:T;
if blink == 1
    tmp = auto_NANblink_cal(tmp);
end

[left, right, vers, verg] = datamean(tmp,axis_mode);

% sac may or may not be used... need to test.

switch mode
    case 'Left'
        for i = 1:a %ensemble
%             tmp{i} = auto_NANblink_cal(tmp{i});
            if axis_mode == 1
                tmp2 = EOMfilters(tmp{i}(2,:)',20,4);
            else
                tmp2 = EOMfilters(tmp{i}(3,:)',40,4);
            end
            plot(t,tmp2-nanmean(tmp2(1:50)),'Color',[0.4 0.4 0.5])
        end
        left = EOMfilters(left',40,4);
        plot(t,left,'b','Linewidth',2) %mean plot
        plot([0 T],[0 0],'-.k')
        
        if scaling.left.manual == 1
            axis([0 T scaling.left.min scaling.left.max])
        else
            axis([0 T (-1.5)*ceil(max(abs(left))) (1.5)*ceil(max(abs(left)))])
        end
        
        ylabel('Angle')
        
        
        
    case 'Right'
        for i = 1:a %ensemble
%             tmp{i} = auto_NANblink_cal(tmp{i});
            if axis_mode == 1
                tmp2 = EOMfilters(tmp{i}(1,:)',20,4);
            else
                tmp2 = EOMfilters(tmp{i}(5,:)',40,4);
            end
            plot(t,tmp2-nanmean(tmp2(1:50)),'Color',[0.4 0.4 0.5])
        end
        right = EOMfilters(right',40,4);
        plot(t,right,'r','Linewidth',2) %mean plot
        plot([0 T],[0 0],'-.k')
        if scaling.right.manual == 1
            axis([0 T scaling.right.min scaling.right.max])
        else
            axis([0 T (-1.5)*ceil(max(abs(right))) (1.5)*ceil(max(abs(right)))])
        end
        ylabel('Angle')
        
    case 'Version'
        for i = 1:a %ensemble
%             tmp{i} = auto_NANblink_cal(tmp{i});
            if axis_mode == 1
                tmp2 = EOMfilters(((tmp{i}(2,:)-tmp{i}(1,:))/2)',40,4);
            else
                tmp2 = EOMfilters(((tmp{i}(3,:)+tmp{i}(5,:))/2)',40,4);
            end
            plot(t,tmp2-nanmean(tmp2(1:50)),'Color',[0.4 0.4 0.4])
        end
        
        plot(t,vers,'k','Linewidth',2) %mean plot
        plot([0 T],[0 0],'-.k')
        if scaling.comb.manual == 1
            axis([0 T scaling.comb.min scaling.comb.max])
        else
            axis([0 T (-1.5)*ceil(max(abs(vers))) (1.5)*ceil(max(abs(vers)))])
        end
        ylabel('Version Angle')
        xlabel('Time (s)')
        
    case 'Vergence'
        for i = 1:a %ensemble
%             tmp{i} = auto_NANblink_cal(tmp{i});
            if axis_mode == 1
                tmp2 = EOMfilters((tmp{i}(1,:)+tmp{i}(2,:))',40,4);
            else
                tmp2 = EOMfilters((tmp{i}(3,:)-tmp{i}(5,:))',40,4);
            end
%             disp((tmp2))
            try
                plot(t,tmp2-mean(tmp2(1:50)),'Color',[0.4 0.5 0.4])
            catch
                disp((tmp2))
            end
        end
        
        plot(t,verg,'g','Linewidth',2) %mean plot
        plot([0 T],[0 0],'-.k')
        if scaling.comb.manual == 1
            axis([0 T scaling.comb.min scaling.comb.max])
        else
            axis([0 T (-1.5)*ceil(max(abs(verg))) (1.5)*ceil(max(abs(verg)))])
        end
        ylabel('Vergence Angle')
        xlabel('Time (s)')
        
end


function [l_mean, r_mean, vers_mean, verg_mean] = datamean(tmp,axis)

n = length(tmp{1});

% convert cell data into an array
if axis == 1
    for i = 1:length(tmp)
        ldata(i,:) = tmp{i}(2,1:n);
        rdata(i,:) = tmp{i}(1,1:n);
        vgdata(i,:) = tmp{i}(1,1:n)+tmp{i}(2,1:n);
        vsdata(i,:) = (tmp{i}(2,1:n)-tmp{i}(1,1:n))/2;
    end
else
    for i = 1:length(tmp)
        ldata(i,:) = tmp{i}(3,1:n);
        rdata(i,:) = tmp{i}(5,1:n);
        vgdata(i,:) = tmp{i}(3,1:n)-tmp{i}(5,1:n);
        vsdata(i,:) = (tmp{i}(3,1:n)+tmp{i}(5,1:n))/2;
    end
end

% get the mean data
for i = 1:length(ldata)
    l_mean(i) = nanmean(ldata(:,i));
    r_mean(i) = nanmean(rdata(:,i));
    verg_mean(i) = nanmean(vgdata(:,i));
    vers_mean(i) = nanmean(vsdata(:,i));
end

% normalize
l_mean = l_mean - nanmean(l_mean(1:50));
r_mean = r_mean - nanmean(r_mean(1:50));
verg_mean = verg_mean - nanmean(verg_mean(1:50));
vers_mean = vers_mean - nanmean(vers_mean(1:50));

function output = apply_gain(input,rgain,lgain,axis_mode)

if axis_mode == 1
    for i = 1:length(input)
        input{i}(1,:) = input{i}(1,:)*rgain;
        input{i}(2,:) = input{i}(2,:)*lgain;
    end
else    
    for i = 1:length(input)
        input{i}(5,:) = input{i}(5,:)*rgain;
        input{i}(3,:) = input{i}(3,:)*lgain;
    end
end

output = input;


% --- Executes on button press in cb_saccadeexp.
function cb_saccadeexp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_saccadeexp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_saccadeexp


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rb_horz,'value') == 1
    handles.axis = 1;
else
    handles.axis = 2;
end

% plots
axes(handles.plot_left)
cla
ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_right)
cla
ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_comb)
cla
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)

guidata(hObject, handles)


% --- Executes on button press in cb_comb_manual.
function cb_comb_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_comb_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.comb.manual = get(hObject,'value');
axes(handles.plot_comb)
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_comb_manual



function edit_comb_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_comb_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.comb.min = str2num(get(hObject,'string'));
if handles.scaling.comb.manual == 1
    axes(handles.plot_comb)
    ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
end
    
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_comb_min as text
%        str2double(get(hObject,'String')) returns contents of edit_comb_min as a double


% --- Executes during object creation, after setting all properties.
function edit_comb_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_comb_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_comb_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_comb_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.comb.max = str2num(get(hObject,'string'));
if handles.scaling.comb.manual == 1
    axes(handles.plot_comb)
    ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)
end
    
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_comb_max as text
%        str2double(get(hObject,'String')) returns contents of edit_comb_max as a double


% --- Executes during object creation, after setting all properties.
function edit_comb_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_comb_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_right_manual.
function cb_right_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_right_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.right.manual = get(hObject,'value');
axes(handles.plot_right)
ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_right_manual



function edit_right_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_right_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.right.min = str2num(get(hObject,'string'));
if handles.scaling.right.manual == 1
    axes(handles.plot_right)
    ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
end
    
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_right_min as text
%        str2double(get(hObject,'String')) returns contents of edit_right_min as a double


% --- Executes during object creation, after setting all properties.
function edit_right_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_right_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_right_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_right_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.right.max = str2num(get(hObject,'string'));
if handles.scaling.right.manual == 1
    axes(handles.plot_right)
    ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)
end
    
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_right_max as text
%        str2double(get(hObject,'String')) returns contents of edit_right_max as a double


% --- Executes during object creation, after setting all properties.
function edit_right_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_right_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_left_manual.
function cb_left_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_left_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.left.manual = get(hObject,'value');
axes(handles.plot_left)
ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_left_manual



function edit_left_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_left_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.left.min = str2num(get(hObject,'string'));
if handles.scaling.left.manual == 1
    axes(handles.plot_left)
    ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
end
    
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_left_min as text
%        str2double(get(hObject,'String')) returns contents of edit_left_min as a double


% --- Executes during object creation, after setting all properties.
function edit_left_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_left_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_left_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_left_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.scaling.left.max = str2num(get(hObject,'string'));
if handles.scaling.left.manual == 1
    axes(handles.plot_left)
    ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)
end
    
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_left_max as text
%        str2double(get(hObject,'String')) returns contents of edit_left_max as a double


% --- Executes during object creation, after setting all properties.
function edit_left_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_left_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_blinkremover.
function cb_blinkremover_Callback(hObject, eventdata, handles)
% hObject    handle to cb_blinkremover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.auto_blink = get(hObject,'Value');

% plots
axes(handles.plot_left)
cla
ens_plot(handles.tmp1,'Left',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_right)
cla
ens_plot(handles.tmp1,'Right',handles.axis,handles.scaling,handles.auto_blink)


axes(handles.plot_comb)
cla
ens_plot(handles.tmp1,handles.mode,handles.axis,handles.scaling,handles.auto_blink)

guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of cb_blinkremover


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


switch eventdata.Character
    case 'c' %calibrate!
        pb_calibrate_Callback(hObject, eventdata, handles)
    case 's' %save
        pb_save_Callback(hObject, eventdata, handles)
        
end
        