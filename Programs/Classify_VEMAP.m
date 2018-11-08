function varargout = Classify_VEMAP(varargin)
% CLASSIFY_VEMAP MATLAB code for Classify_VEMAP.fig
%
%      CLASSIFY_VEMAP, by itself, creates a new CLASSIFY_VEMAP or raises the existing
%      singleton*.
%
%      H = CLASSIFY_VEMAP returns the handle to a new CLASSIFY_VEMAP or the handle to
%      the existing singleton*.
%
%      CLASSIFY_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFY_VEMAP.M with the given input arguments.
%
%      CLASSIFY_VEMAP('Property','Value',...) creates a new CLASSIFY_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Classify_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Classify_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   05/06/16    Vertical plotting has been fixed
% 1.2   06/07/16    Up and down arrows change the classification
% 1.3   08/29/16    Added more functionality. 'e' and 'r' change the
%                   movement.
% 1.4   09/15/16    Added filtering to the plots. Fixed vertical velocity 
%                   plotting. Fixed velocity plotting. Added pop-up when
%                   movement is completed.
% 1.5   10/31/2016  Added scale for second plot. Manual scale for posiiton
%                   is always on.
% 1.6   11/2/2016   Automatically saves when you change the movement type
% Edit the above text to modify the response to help Classify_VEMAP

% Last Modified by GUIDE v2.5 31-Oct-2016 16:45:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Classify_VEMAP_OpeningFcn, ...
    'gui_OutputFcn',  @Classify_VEMAP_OutputFcn, ...
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


% --- Executes just before Classify_VEMAP is made visible.
function Classify_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Classify_VEMAP (see VARARGIN)

% initialization
global params;
params.button.classify = 0;

load('Programs\Settings\classify_settings')
handles.classify_settings = classify_settings;

% logos and images
% imshow('Logo.png','Parent',handles.vnel_logo)
% imshow('Salus_logo.jpg','Parent',handles.salus_logo)
% imshow('NJITfull.png','Parent',handles.njit_logo)
% imshow('redline.png','Parent',handles.axes4)
% imshow('blueline.png','Parent',handles.axes8)
% imshow('greenline.png','Parent',handles.axes9)
% imshow('blackline.png','Parent',handles.axes10)
% imshow('dashline.png','Parent',handles.axes11)
% imshow('redline.png','Parent',handles.axes12)
% imshow('blueline.png','Parent',handles.axes13)
% imshow('greenline.png','Parent',handles.axes14)
% imshow('blackline.png','Parent',handles.axes15)
% imshow('dashline.png','Parent',handles.axes16)

handles.mode = 1;
handles.move_axis = 0;
handles.plot_axes = [-10 10];
handles.plot_axes2 = [];
handles.smooth_val = 1;
handles.flip_right = 0;
handles.flip_left = 0;
set(handles.slider1,'value',1)

% update classifications
set(handles.pop_classtypes,'string',classify_settings.classificationtypes)
set(handles.lb_classes,'string',classify_settings.classifications{1})

% Choose default command line output for Classify_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Classify_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load data set
[handles.FileName,handles.PathName] = uigetfile('*.mat*','Select the data file',('Data\Processed\'));

if handles.FileName==0
    return
end
load([handles.PathName handles.FileName]);

handles.data = data;
handles.eye_movements = eye_movements;

% filename on top
handles.FileName = handles.FileName(1:end-4);
set(handles.filename_text,'String',handles.FileName)

% set menus
a = fieldnames(data);
set(handles.menu_section,'string',a);

b = fieldnames(data.(a{1}));
set(handles.menu_move,'string',b);

handles.section = a{1};
handles.movement = b{1};
% Choose default command line output for Classify_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Classify_VEMAP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on selection change in menu_move.
function menu_move_Callback(hObject, eventdata, handles)
% hObject    handle to menu_move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns menu_move contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_move
val = get(hObject,'value');
str = get(hObject,'string');

handles.movement = str{val};

% update gui handles
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function menu_move_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_move (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in menu_section.
function menu_section_Callback(hObject, eventdata, handles)
% hObject    handle to menu_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: contents = cellstr(get(hObject,'String')) returns menu_section contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu_section
val = get(hObject,'value');
str = get(hObject,'string');

handles.section = str{val};

a = fieldnames(handles.data.(handles.section));
handles.movement = a{1};

set(handles.menu_move,'string',a);
set(handles.menu_move,'value',1);

% update gui handles
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function menu_section_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_choose.
function pb_choose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
eye_movements = handles.eye_movements;

save([handles.PathName handles.FileName],'data','eye_movements');

handles.plotting = 1; % plotting turns on!!!!

section = handles.section;
move = handles.movement;

handles.tmp = handles.eye_movements.(section).(move);
handles.samp_num = 1; % initialize sample number

% plotting
% values of the legend plots
r1 = get(handles.rightplot1,'Value');
l1 = get(handles.leftplot1,'Value');
g1 = get(handles.vergplot1,'Value');
s1 = get(handles.versplot1,'Value');
z1 = get(handles.zeroplot1,'Value');
r2 = get(handles.rightplot2,'Value');
l2 = get(handles.leftplot2,'Value');
g2 = get(handles.vergplot2,'Value');
s2 = get(handles.versplot2,'Value');
z2 = get(handles.zeroplot2,'Value');

axes(handles.plot1) %sets to plot1
pos_plot(handles.tmp{handles.samp_num},r1,l1,g1,s1,z1,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');
b = handles.samp_num; % current movement sample number

switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        vel_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        acc_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
T = length(data{b})/500;
if isempty(handles.plot_axes2) == 0
    axis([0 T handles.plot_axes2])
end
% update numbers
set(handles.text_sampnum, 'string',num2str(handles.samp_num))
set(handles.text_seqnum,'string',num2str(handles.data.(section).(move)...
    (handles.samp_num).num_seq))
set(handles.lb_trialclasses,'string',...
    handles.data.(section).(move)(handles.samp_num).classifications)

if isempty(handles.data.(section).(move)(handles.samp_num).classifications) == 0
    set(handles.cb_classified,'value',1)
else
    set(handles.cb_classified,'value',0)
end

for i = 1:length(handles.data.(section).(move))
    if isempty(handles.data.(section).(move)(i).classifications) == 1
        set(handles.checkbox22,'value',0)
        break
    else
        set(handles.checkbox22,'value',1)
    end
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on selection change in popupmenu3.
function secondplot_menu_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

% Velocity Data
% Acceleration Data
% Ensemble Data
val = get(hObject, 'Value');
str = get(hObject,'String');
section = handles.section;
move = handles.movement;
b = handles.samp_num; % current movement sample number
% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');

switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end


% --- Executes during object creation, after setting all properties.
function secondplot_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_classify.
function pb_classify_Callback(hObject, eventdata, handles)
% hObject    handle to pb_classify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global params;
%
% % checked for flagged button
% if params.button.classify == 1
%     return
% end
%
% % button flagged
% params.button.classify = 1;

section = handles.section;
move = handles.movement;
samp_num = handles.samp_num;
a = get(handles.lb_trialclasses,'string');

handles.data.(section).(move)(samp_num).classifications = a;

if isempty(handles.data.(section).(move)(samp_num).classifications) == 0
    set(handles.cb_classified,'value',1)
end


for i = 1:length(handles.data.(section).(move))
    if isempty(handles.data.(section).(move)(i).classifications) == 1
        set(handles.checkbox22,'value',0)
        break
    else
        set(handles.checkbox22,'value',1)
    end
end

if get(handles.checkbox22,'value') == 1
    uiwait(msgbox('Current Classification is done.','Done','modal'));
end

% update gui handles
guidata(hObject,handles)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.smooth_val = get(hObject,'Value');
set(handles.text7,'string',num2str(ceil(handles.smooth_val)));
% disp(handles.smooth_val);
% update gui handles
guidata(hObject,handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in quit.
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close;


% --- Executes on button press in save_pb.
function save_pb_Callback(hObject, eventdata, handles)
% hObject    handle to save_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% place data in new variable names
% place data in new variable names

% change filename
% option = menu('Would you like to rename the data file?','Yes','No');
% 
% if option == 1
%     handles.FileName = input('Enter new FileName: ','s');
% end

data = handles.data;
eye_movements = handles.eye_movements;

save([handles.PathName handles.FileName],'data','eye_movements');

set(handles.filename_text,'String',handles.FileName)

uiwait(msgbox('Classification data has been saved!','Saved','modal'));

% update gui handles
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Legends %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in rightplot1.
function rightplot1_Callback(hObject, eventdata, handles)
% hObject    handle to rightplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');
b = handles.samp_num;
axes(handles.plot1)
cla
hold on
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)
% Hint: get(hObject,'Value') returns toggle state of rightplot1


% --- Executes on button press in leftplot1.
function leftplot1_Callback(hObject, eventdata, handles)
% hObject    handle to leftplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');
b = handles.samp_num;
axes(handles.plot1)
cla
hold on
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)
% Hint: get(hObject,'Value') returns toggle state of leftplot1


% --- Executes on button press in vergplot1.
function vergplot1_Callback(hObject, eventdata, handles)
% hObject    handle to vergplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');
b = handles.samp_num;
axes(handles.plot1)
cla
hold on
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)
% Hint: get(hObject,'Value') returns toggle state of vergplot1


% --- Executes on button press in versplot1.
function versplot1_Callback(hObject, eventdata, handles)
% hObject    handle to versplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');
b = handles.samp_num;
axes(handles.plot1)
cla
hold on
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)
% Hint: get(hObject,'Value') returns toggle state of versplot1


% --- Executes on button press in zeroplot1.
function zeroplot1_Callback(hObject, eventdata, handles)
% hObject    handle to zeroplot1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');
b = handles.samp_num;
axes(handles.plot1)
cla
hold on
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)
% Hint: get(hObject,'Value') returns toggle state of zeroplot1


% --- Executes on button press in rightplot2.
function rightplot2_Callback(hObject, eventdata, handles)
% hObject    handle to rightplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
% Hint: get(hObject,'Value') returns toggle state of rightplot2


% --- Executes on button press in leftplot2.
function leftplot2_Callback(hObject, eventdata, handles)
% hObject    handle to leftplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
% Hint: get(hObject,'Value') returns toggle state of leftplot2


% --- Executes on button press in vergplot2.
function vergplot2_Callback(hObject, eventdata, handles)
% hObject    handle to vergplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
% Hint: get(hObject,'Value') returns toggle state of vergplot2


% --- Executes on button press in versplot2.
function versplot2_Callback(hObject, eventdata, handles)
% hObject    handle to versplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
% Hint: get(hObject,'Value') returns toggle state of versplot2


% --- Executes on button press in zeroplot2.
function zeroplot2_Callback(hObject, eventdata, handles)
% hObject    handle to zeroplot2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section = handles.section;
move = handles.movement;
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
% Hint: get(hObject,'Value') returns toggle state of zeroplot2


% --- Executes on button press in figure_pb.
function figure_pb_Callback(hObject, eventdata, handles)
% hObject    handle to figure_pb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% to be fixed at a later date

figure

subplot(2,1,1) % positional plot
hold on
pos_plot(handles.tmp{handles.icount.verg(handles.b)},1,1,1,1,1,...
    handles.mode,handles.smooth_val,handles.flip_right,handles.flip_left)
title('Position')
axis([0 1000 -4 4])

subplot(2,1,2) % velocity plot
hold on
vel_plot(handles.tmp{handles.icount.verg(handles.b)},1,1,1,1,1,xyaxis_v)
% ens_plot(handles.tmp,handles.icount.verg(handles.movement))
title('Velocity')
% title('Ensemble')
axis([0 1000 -20 20])
% axis([0 1000 -4 4])




% --- Executes on selection change in lb_classes.
function lb_classes_Callback(hObject, eventdata, handles)
% hObject    handle to lb_classes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_classes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_classes


% --- Executes during object creation, after setting all properties.
function lb_classes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_classes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_test.
function pb_test_Callback(hObject, eventdata, handles)
% hObject    handle to pb_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save handles to something
save('testingtesting','handles')

% --- Executes on selection change in lb_trialclasses.
function lb_trialclasses_Callback(hObject, eventdata, handles)
% hObject    handle to lb_trialclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_trialclasses contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_trialclasses


% --- Executes during object creation, after setting all properties.
function lb_trialclasses_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_trialclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_add.
function pb_add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
class_str = get(handles.lb_classes,'string');
class_val = get(handles.lb_classes,'value');
class = class_str{class_val};
% disp(class_str)

cat_str = get(handles.lb_trialclasses,'string');
a = length(cat_str);

cat_str{a+1} = class;
cat_str = unique(cat_str);
% disp(cat_str)

set(handles.lb_trialclasses,'string',cat_str);

guidata(hObject,handles)

% --- Executes on button press in cb_classified.
function cb_classified_Callback(hObject, eventdata, handles)
% hObject    handle to cb_classified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_classified


% --- Executes on button press in pb_remove.
function pb_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cat_str = get(handles.lb_trialclasses,'string');
cat_val = get(handles.lb_trialclasses,'value');
% disp(cat_str)

cat_str{cat_val} = [];
% disp(cat_str)

cat_str = cat_str(~cellfun('isempty',cat_str));
% disp(cat_str)

set(handles.lb_trialclasses,'value',1);
set(handles.lb_trialclasses,'string',cat_str);

guidata(hObject,handles)

%%%%% Plotting Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pos_plot(tmp,r,l,g,s,z,mode,move_axis,plot_axes,smooth_val,flip_right,flip_left)
% plots the positional data
% tmp = data
% rlgsz are the graphing elements
% mode (vergence vs. saccades?))
% move_axis (horizontal [1] vs. vertical [2])
% plot_axes = x and y axes figures
cla reset

T = length(tmp(1,:))*.002;
t = 0.002:0.002:T;

if move_axis == 0 % horizontal
    right(1,:) =transpose(smooth(tmp(1,:),smooth_val));
    left(1,:) =transpose(smooth(tmp(2,:),smooth_val));
else % vertical
    right(1,:) =transpose(smooth(tmp(3,:),smooth_val));
    left(1,:) =transpose(smooth(tmp(4,:),smooth_val));
end

% normalize the data
right = right - mean(right(1:50));
left = left - mean(left(1:50));
right = EOMfilters(right',40,4);
left = EOMfilters(left',40,4);
hold on

if r == 1 % right
    if flip_right == 0
        plot(t,right,'r')
    else
        plot(t,-right,'r')
    end
end

if l == 1 % left
    if flip_left == 0
        plot(t,left,'b')
    else
        plot(t,-left,'b')
    end
end

if g == 1 % vergence
    if move_axis == 0
        verg = right+left;
        plot(t,verg,'g')
    else
        verg = right - left;
        plot(t,verg,'g')
    end
end

if s == 1 % version
    if move_axis == 0
        vers = (left-right)/2;
        plot(t,vers,'k')
    else
        vers = (left+right)/2;
        plot(t,vers,'k')
    end
end

if z == 1 % zero
    plot([0 T],[0 0],'-.k')
end

plot([.15 .15], [-100 100]);

if isempty(plot_axes) == 0
    axis([0 T plot_axes])
end




function vel_plot(tmp,r,l,g,s,z,mode,smooth_val,move_axis)
cla
hold on
if move_axis == 0 % horizontal
    tmp(1,:) =transpose(smooth(tmp(1,:),smooth_val));
    tmp(2,:) =transpose(smooth(tmp(2,:),smooth_val));
    a = EOMfilters(tmp(1,:)',40,4);
    b = EOMfilters(tmp(2,:)',40,4);
    tmp(1,:) = a';
    tmp(2,:) = b';
else % vertical
    tmp(1,:) =transpose(smooth(tmp(3,:),smooth_val));
    tmp(2,:) =transpose(smooth(tmp(4,:),smooth_val));
    a = EOMfilters(tmp(1,:)',40,4);
    b = EOMfilters(tmp(2,:)',40,4);
    tmp(1,:) = a';
    tmp(2,:) = -b';
end

if mode == 1
    T = length(tmp)*0.002;
    t = 0.002:0.002:T;
    
    if r ==1
        plot(t,PositionToVelocity(tmp(1,:)),'r')
    end
    
    if l == 1
        plot(t,PositionToVelocity(tmp(2,:)))
    end
    
    vergence=tmp(1,:)+tmp(2,:);
    if g == 1
        plot(t,PositionToVelocity(vergence),'g')
    end
    
    version=(tmp(1,:)-tmp(2,:))/2;
    if s == 1
        plot(t,PositionToVelocity(version),'k')
    end
    
    if z == 1
        plot([0 T],[0 0],'-.k')
%         plot([0 T],[1 1],'.b')
    end
    
    % plot values
    %     axis([0 T -40 40])
    xlabel('Time (s)')
    ylabel('Deg/Second')
else
    T = length(tmp)*0.002;
    t = 0.002:0.002:T;
    if r ==1
        plot(t,PositionToVelocity(tmp(1,:)),'r')
    end
    
    if l == 1
        plot(t,PositionToVelocity(tmp(2,:)))
    end
    
    vergence=tmp(1,:)-tmp(2,:);
    if g == 1
        plot(t,PositionToVelocity(vergence),'g')
    end
    
    version=(tmp(1,:)+tmp(2,:))/2;
    if s == 1
        plot(t,PositionToVelocity(version),'k')
    end
    
    if z == 1
        plot([0 T],[0 0],'-.k')
    end
    
    % plot values
    %     axis([0 T -20 20])
    xlabel('Time (s)')
    ylabel('Deg/Second')
end

function acc_plot(tmp,r,l,g,s,z,mode,smooth_val,move_axis)
hold on
% plots the acceleration data
if move_axis == 0 % horizontal
    tmp(1,:) =transpose(smooth(tmp(1,:),smooth_val));
    tmp(1,:) =transpose(smooth(tmp(2,:),smooth_val));
else % vertical
    tmp(1,:) =transpose(smooth(tmp(3,:),smooth_val));
    tmp(1,:) =transpose(smooth(tmp(4,:),smooth_val));
end
if mode == 1
    T = length(tmp)*0.002;
    t = 0.002:0.002:T;
    if r == 1
        plot(t,PositionToVelocity(PositionToVelocity(tmp(1,:))),'r')
    end
    
    if l == 1
        plot(t,PositionToVelocity(PositionToVelocity(-tmp(2,:))))
    end
    
    vergence=tmp(1,:)-tmp(2,:);
    if g == 1
        plot(t,PositionToVelocity(PositionToVelocity(vergence)),'g')
    end
    
    version=(tmp(1,:)+tmp(2,:))/2;
    if s == 1
        plot(t,PositionToVelocity(PositionToVelocity(version)),'k')
    end
    
    if z == 1
        plot([0 T],[0 0],'-.k')
    end
    % plot values
    %     axis([0 T -200 200])
    xlabel('Sample (n)')
    ylabel('Voltage/Sample^2')
else
    T = length(tmp)*0.002;
    t = 0.002:0.002:T;
    
    if r == 1
        plot(t,PositionToVelocity(PositionToVelocity(tmp(1,1:1500))),'r')
    end
    
    if l == 1
        plot(t,PositionToVelocity(PositionToVelocity(-tmp(2,1:1500))))
    end
    
    vergence=tmp(1,:)-tmp(2,:);
    if g == 1
        plot(t,PositionToVelocity(PositionToVelocity(vergence(1:1500))),'g')
    end
    
    version=(tmp(1,:)+tmp(2,:))/2;
    if s == 1
        plot(t,PositionToVelocity(PositionToVelocity(version(1:1500))),'k')
    end
    
    if z == 1
        plot([0 T],[0 0],'-.k')
    end
    
    % plot values
    %     axis([0 T -200 200])
    xlabel('Time (sec)')
    ylabel('Acceleration (deg/sec^2)')
    
end


function ens_plot(tmp,curr_i,mode,smooth_val,move_axis)
% plots an ensemble plot of the vergence data with the mean bolded.
hold on
T = length(tmp{1})*0.002;
t = 0.002:0.002:T;
% disp(size(tmp{1}))
curr_data = tmp{curr_i};
curr_verg = curr_data(1,:) + curr_data(2,:);
curr_vers = (curr_data(2,:) - curr_data(1,:))/2;

if mode == 1
    for i = 1:length(tmp)
        tmp{i}(1,:) =transpose(smooth(tmp{i}(1,:),smooth_val));
        tmp{i}(2,:) =transpose(smooth(tmp{i}(2,:),smooth_val));
        vergence = tmp{i}(1,:)+tmp{i}(2,:);
        plot(t,vergence-mean(vergence(1:50)),'Color',[0.5 0.5 0.5])
    end
    plot(t,curr_verg-mean(curr_verg(1:50)),'g','Linewidth',2)
    plot([0 T],[0 0],'-.k')
    %     axis([0 T -10 10])
    xlabel('Time (s)')
    ylabel('Position (deg)')
else
    for i = 1:length(tmp)
        tmp{i}(1,:) =transpose(smooth(tmp{i}(1,:),smooth_val));
        tmp{i}(2,:) =transpose(smooth(tmp{i}(2,:),smooth_val));
        version = (tmp{i}(2,:)-tmp{i}(1,:))/2;
        plot(t,version(:)-mean(version(1:50)),'Color',[0.5 0.5 0.5])
    end
    plot(t,curr_vers(:)-mean(curr_vers(1:50)),'k','Linewidth',2)
    plot([0 T],[0 0],'-.k')
    %     axis([0 T -8 8])
    xlabel('Time (s)')
    ylabel('Position (deg)')
    
end

function phase_plot(tmp)
% plots a phase plot on the left, right, and vergence data

verg_pos = tmp(1,:) - tmp(2,:);
left_pos = -(tmp(2,:)-mean(tmp(2,1:50)));
right_pos = tmp(1,:)-mean(tmp(1,1:50));

% get velocity data
left_vel = -(PositionToVelocity(tmp(2,:)));
right_vel = PositionToVelocity(tmp(1,:));
verg_vel = PositionToVelocity(verg_pos);

figure

subplot(1,3,1) % plot left
plot(left_pos,left_vel)
axis([-2 2 -6 6])
title('Left Eye')

subplot(1,3,2) % plot right
plot(right_pos,right_vel,'r')
axis([-2 2 -6 6])
title('Right Eye')

subplot(1,3,3) % plot vergence
plot(verg_pos-mean(verg_pos(1:50)),verg_vel,'g')
axis([-3 3 -12 12])
title('Vergence')


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'rightarrow'
        pb_next_Callback(hObject,eventdata,handles);
    case 'leftarrow'
        pb_previous_Callback(hObject,eventdata,handles);
    case 'downarrow'
        a = get(handles.lb_classes,'value');
        num_fields = length(get(handles.lb_classes,'string'));
        b = a + 1;
        if b > num_fields
            b = 1;
        end
        set(handles.lb_classes,'value',b);
    case 'uparrow'
        a = get(handles.lb_classes,'value');
        num_fields = length(get(handles.lb_classes,'string'));
        b = a - 1;
        if b < 1
            b = num_fields;
        end
        set(handles.lb_classes,'value',b);
end

switch eventdata.Character
%     case '1'
%         set(handles.lb_classes,'value',1)
%     case '2'
%         set(handles.lb_classes,'value',2)
%     case '3'
%         set(handles.lb_classes,'value',3)
%     case '4' 
%         set(handles.lb_classes,'value',4)
%     case '5'
%         set(handles.lb_classes,'value',5)
%     case '6'
%         set(handles.lb_classes,'value',6)
%     case '7'
%         set(handles.lb_classes,'value',7)
%     case '8'
%         set(handles.lb_classes,'value',8)
%     case '9'
%         set(handles.lb_classes,'value',9)
%     case '0'
%         set(handles.lb_classes,'value',10)
    case 'c' % classify
        pb_classify_Callback(hObject,eventdata,handles)
    case 'q' % add
        pb_add_Callback(hObject,eventdata,handles)
    case 'w' % remove
        pb_remove_Callback(hObject,eventdata,handles)
    case 'a'
        if get(handles.rightplot1, 'Value') == 0
            set(handles.rightplot1,'Value',1)
        else
            set(handles.rightplot1,'Value',0)
        end
        rightplot1_Callback(hObject, eventdata, handles)
    case 's'
        if get(handles.leftplot1, 'Value') == 0
            set(handles.leftplot1,'Value',1)
        else
            set(handles.leftplot1,'Value',0)
        end
        leftplot1_Callback(hObject, eventdata, handles)
    case 'd'
        if get(handles.vergplot1, 'Value') == 0
            set(handles.vergplot1,'Value',1)
        else
            set(handles.vergplot1,'Value',0)
        end
        versplot1_Callback(hObject, eventdata, handles)
    case 'f'
        if get(handles.versplot1, 'Value') == 0
            set(handles.versplot1,'Value',1)
        else
            set(handles.versplot1,'Value',0)
        end
        vergplot1_Callback(hObject, eventdata, handles)
    case 'g'
        if get(handles.zeroplot1, 'Value') == 0
            set(handles.zeroplot1,'Value',1)
        else
            set(handles.zeroplot1,'Value',0)
        end
        zeroplot1_Callback(hObject, eventdata, handles)
    case 'A'
        if get(handles.rightplot2, 'Value') == 0
            set(handles.rightplot2,'Value',1)
        else
            set(handles.rightplot2,'Value',0)
        end
        rightplot2_Callback(hObject, eventdata, handles)
    case 'S'
        if get(handles.leftplot2, 'Value') == 0
            set(handles.leftplot2,'Value',1)
        else
            set(handles.leftplot2,'Value',0)
        end
        leftplot2_Callback(hObject, eventdata, handles)
    case 'D'
        if get(handles.vergplot2, 'Value') == 0
            set(handles.vergplot2,'Value',1)
        else
            set(handles.vergplot2,'Value',0)
        end
        versplot2_Callback(hObject, eventdata, handles)
    case 'F'
        if get(handles.versplot2, 'Value') == 0
            set(handles.versplot2,'Value',1)
        else
            set(handles.versplot2,'Value',0)
        end
        vergplot2_Callback(hObject, eventdata, handles)
    case 'G'
        if get(handles.zeroplot2, 'Value') == 0
            set(handles.zeroplot2,'Value',1)
        else
            set(handles.zeroplot2,'Value',0)
        end
        zeroplot2_Callback(hObject, eventdata, handles)
    case 'z'
        set(handles.rightplot1,'Value',1)
        set(handles.leftplot1,'Value',1)
        set(handles.vergplot1,'Value',1)
        set(handles.versplot1,'Value',1)
        set(handles.zeroplot1,'Value',1)
        zeroplot1_Callback(hObject, eventdata, handles)
    case 'x'
        set(handles.rightplot2,'Value',1)
        set(handles.leftplot2,'Value',1)
        set(handles.vergplot2,'Value',1)
        set(handles.versplot2,'Value',1)
        set(handles.zeroplot2,'Value',1)
        zeroplot2_Callback(hObject, eventdata, handles)
    case 'e'
        a = get(handles.menu_move,'value');
        b = get(handles.menu_move,'string');
        
        a = a - 1;
        if a < 1
            a = length(b);
        end
%         disp(a)
        set(handles.menu_move,'value',a)
        handles.movement = b{a};
        
        % update gui handles
        guidata(hObject,handles)
        
        pb_choose_Callback(hObject, eventdata, handles)
    case 'r'
        a = get(handles.menu_move,'value');
        b = get(handles.menu_move,'string');
        
        a = a + 1;
        if a > length(b)
            a = 1;
        end
%         disp(a)
        set(handles.menu_move,'value',a)
        handles.movement = b{a};
        
        % update gui handles
        guidata(hObject,handles)
        
        pb_choose_Callback(hObject, eventdata, handles)
    case 'v'
        a = get(handles.cb_vertical,'value');
        
        if a == 1
            set(handles.cb_vertical,'value',0)
        else
            set(handles.cb_vertical,'value',1)
        end
        
        cb_vertical_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in pb_smooth.
function pb_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to pb_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

move = handles.movement;
section = handles.section;

% values of the legend plots
r = get(handles.rightplot2,'Value');
l = get(handles.leftplot2,'Value');
g = get(handles.vergplot2,'Value');
s = get(handles.versplot2,'Value');
z = get(handles.zeroplot2,'Value');
r1 = get(handles.rightplot1,'Value');
l1 = get(handles.leftplot1,'Value');
g1 = get(handles.vergplot1,'Value');
s1 = get(handles.versplot1,'Value');
z1 = get(handles.zeroplot1,'Value');
b = handles.samp_num;
% update plots
axes(handles.plot1)
cla
hold on
pos_plot(handles.tmp{handles.samp_num},r1,l1,g1,s1,z1,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r,l,g,s,z,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end


% --- Executes on button press in pb_next.
function pb_next_Callback(hObject, eventdata, handles)
% hObject    handle to pb_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.samp_num = handles.samp_num + 1;
if handles.samp_num > length(handles.tmp)
    handles.samp_num = 1;
end
move = handles.movement;
section = handles.section;

% plotting
% values of the legend plots
r1 = get(handles.rightplot1,'Value');
l1 = get(handles.leftplot1,'Value');
g1 = get(handles.vergplot1,'Value');
s1 = get(handles.versplot1,'Value');
z1 = get(handles.zeroplot1,'Value');
r2 = get(handles.rightplot2,'Value');
l2 = get(handles.leftplot2,'Value');
g2 = get(handles.vergplot2,'Value');
s2 = get(handles.versplot2,'Value');
z2 = get(handles.zeroplot2,'Value');
b = handles.samp_num;

axes(handles.plot1) %sets to plot1
pos_plot(handles.tmp{handles.samp_num},r1,l1,g1,s1,z1,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)




val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');
samp_num = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end

% update numbers
set(handles.text_sampnum, 'string',num2str(handles.samp_num))
set(handles.text_seqnum,'string',num2str(handles.data.(section).(move)...
    (handles.samp_num).num_seq))
set(handles.lb_trialclasses,'string',...
    handles.data.(section).(move)(handles.samp_num).classifications)

if isempty(handles.data.(section).(move)(samp_num).classifications) == 0
    set(handles.cb_classified,'value',1)
else
    set(handles.cb_classified,'value',0)
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pb_previous.
function pb_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pb_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.samp_num = handles.samp_num - 1;
if handles.samp_num < 1
    handles.samp_num = length(handles.tmp);
end
move = handles.movement;
section = handles.section;
% plotting
% values of the legend plots
r1 = get(handles.rightplot1,'Value');
l1 = get(handles.leftplot1,'Value');
g1 = get(handles.vergplot1,'Value');
s1 = get(handles.versplot1,'Value');
z1 = get(handles.zeroplot1,'Value');
r2 = get(handles.rightplot2,'Value');
l2 = get(handles.leftplot2,'Value');
g2 = get(handles.vergplot2,'Value');
s2 = get(handles.versplot2,'Value');
z2 = get(handles.zeroplot2,'Value');

b = handles.samp_num;

samp_num = handles.samp_num;

axes(handles.plot1) %sets to plot1
pos_plot(handles.tmp{handles.samp_num},r1,l1,g1,s1,z1,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');

switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        vel_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla
        acc_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end

% update numbers
set(handles.text_sampnum, 'string',num2str(handles.samp_num))
set(handles.text_seqnum,'string',num2str(handles.data.(section).(move)...
    (handles.samp_num).num_seq))
set(handles.lb_trialclasses,'string',...
    handles.data.(section).(move)(handles.samp_num).classifications)
if isempty(handles.data.(section).(move)(samp_num).classifications) == 0
    set(handles.cb_classified,'value',1)
else
    set(handles.cb_classified,'value',0)
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in checkbox22.
function checkbox22_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox22


% --- Executes on button press in cb_lefteyeflip.
function cb_lefteyeflip_Callback(hObject, eventdata, handles)
% hObject    handle to cb_lefteyeflip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.flip_left = get(hObject,'value');
% values of the legend plots
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');

axes(handles.plot1)
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_lefteyeflip


% --- Executes on button press in cb_righteyeflip.
function cb_righteyeflip_Callback(hObject, eventdata, handles)
% hObject    handle to cb_righteyeflip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.flip_right = get(hObject,'value');
% values of the legend plots
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');

axes(handles.plot1)
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)


guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_righteyeflip


% --- Executes on button press in cb_vertical.
function cb_vertical_Callback(hObject, eventdata, handles)
% hObject    handle to cb_vertical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.move_axis = get(handles.cb_vertical,'value');

% values of the legend plots
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');

axes(handles.plot1)
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_vertical


% --- Executes on button press in cb_manual.
function cb_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min,'string'));
    max = str2num(get(handles.edit_max,'string'));
    handles.plot_axes = [min max];
end

% values of the legend plots
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');

axes(handles.plot1)
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_manual



function edit_min_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cb_manual,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min,'string'));
    max = str2num(get(handles.edit_max,'string'));
    handles.plot_axes = [min max];
end

% values of the legend plots
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');

axes(handles.plot1)
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_min as text
%        str2double(get(hObject,'String')) returns contents of edit_min as a double


% --- Executes during object creation, after setting all properties.
function edit_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cb_manual,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min,'string'));
    max = str2num(get(handles.edit_max,'string'));
    handles.plot_axes = [min max];
end
% values of the legend plots
r = get(handles.rightplot1,'Value');
l = get(handles.leftplot1,'Value');
g = get(handles.vergplot1,'Value');
s = get(handles.versplot1,'Value');
z = get(handles.zeroplot1,'Value');

axes(handles.plot1)
pos_plot(handles.tmp{handles.samp_num},r,l,g,s,z,handles.mode,...
    handles.move_axis,handles.plot_axes,handles.smooth_val,handles.flip_right,handles.flip_left)

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_max as text
%        str2double(get(hObject,'String')) returns contents of edit_max as a double


% --- Executes during object creation, after setting all properties.
function edit_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_classtypes.
function pop_classtypes_Callback(hObject, eventdata, handles)
% hObject    handle to pop_classtypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_classtypes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_classtypes


% --- Executes during object creation, after setting all properties.
function pop_classtypes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_classtypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_update_classes.
function pb_update_classes_Callback(hObject, eventdata, handles)
% hObject    handle to pb_update_classes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classtype = get(handles.pop_classtypes,'value');
set(handles.lb_classes,'value',1)
set(handles.lb_classes,'string',handles.classify_settings.classifications{classtype})

guidata(hObject,handles)



function edit_max2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cb_manual,'Value') == 0
    handles.plot_axes2 = [];
else
    min = str2num(get(handles.edit_min2,'string'));
    max = str2num(get(handles.edit_max2,'string'));
    handles.plot_axes2 = [min max];
end
% values of the legend plots
r2 = get(handles.rightplot2,'Value');
l2 = get(handles.leftplot2,'Value');
g2 = get(handles.vergplot2,'Value');
s2 = get(handles.versplot2,'Value');
z2 = get(handles.zeroplot2,'Value');

%second plot
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        vel_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        acc_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
T = length(data{b})/500;
if isempty(handles.plot_axes2) == 0
    axis([0 T handles.plot_axes2])
end

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_max2 as text
%        str2double(get(hObject,'String')) returns contents of edit_max2 as a double


% --- Executes during object creation, after setting all properties.
function edit_max2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_min2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cb_manual,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min2,'string'));
    max = str2num(get(handles.edit_max2,'string'));
    handles.plot_axes2 = [min max];
end
% values of the legend plots
r2 = get(handles.rightplot2,'Value');
l2 = get(handles.leftplot2,'Value');
g2 = get(handles.vergplot2,'Value');
s2 = get(handles.versplot2,'Value');
z2 = get(handles.zeroplot2,'Value');

%second plot
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        vel_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        acc_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
T = length(data{b})/500;
if isempty(handles.plot_axes2) == 0
    axis([0 T handles.plot_axes2])
end

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_min2 as text
%        str2double(get(hObject,'String')) returns contents of edit_min2 as a double


% --- Executes during object creation, after setting all properties.
function edit_min2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_manual2.
function cb_manual2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_manual2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_manual2
if get(hObject,'Value') == 0
    handles.plot_axes2 = [];
else
    min = str2num(get(handles.edit_min2,'string'));
    max = str2num(get(handles.edit_max2,'string'));
    handles.plot_axes2 = [min max];
end

% values of the legend plots
r2 = get(handles.rightplot2,'Value');
l2 = get(handles.leftplot2,'Value');
g2 = get(handles.vergplot2,'Value');
s2 = get(handles.versplot2,'Value');
z2 = get(handles.zeroplot2,'Value');

%second plot
val = get(handles.secondplot_menu, 'Value');
str = get(handles.secondplot_menu,'String');
b = handles.samp_num;
switch str{val}
    case 'Velocity Data' % user chooses Velocity Data
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        vel_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Acceleration Data'
        data = handles.tmp; % current data
        axes(handles.plot2) % set to plot2
        cla reset
        acc_plot(data{b},r2,l2,g2,s2,z2,handles.mode,handles.smooth_val,handles.move_axis)
    case 'Ensemble Vergence'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,1,handles.smooth_val,handles.move_axis)
    case 'Ensemble Version'
        data = handles.tmp; % current data set
        axes(handles.plot2) % set to plot2
        cla reset
        ens_plot(data,b,2,handles.smooth_val,handles.move_axis)
end
T = length(data{b})/500;
if isempty(handles.plot_axes2) == 0
    axis([0 T handles.plot_axes2])
end

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_manual
