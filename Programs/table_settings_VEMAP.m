function varargout = table_settings_VEMAP(varargin)
% TABLE_SETTINGS_VEMAP MATLAB code for table_settings_VEMAP.fig
%      TABLE_SETTINGS_VEMAP, by itself, creates a new TABLE_SETTINGS_VEMAP or raises the existing
%      singleton*.
%
%      H = TABLE_SETTINGS_VEMAP returns the handle to a new TABLE_SETTINGS_VEMAP or the handle to
%      the existing singleton*.
%
%      TABLE_SETTINGS_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TABLE_SETTINGS_VEMAP.M with the given input arguments.
%
%      TABLE_SETTINGS_VEMAP('Property','Value',...) creates a new TABLE_SETTINGS_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before table_settings_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to table_settings_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/11/16    Added Main Sequence Ratio

% Edit the above text to modify the response to help table_settings_VEMAP

% Last Modified by GUIDE v2.5 11-Apr-2016 17:11:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @table_settings_VEMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @table_settings_VEMAP_OutputFcn, ...
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


% --- Executes just before table_settings_VEMAP is made visible.
function table_settings_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to table_settings_VEMAP (see VARARGIN)

load('Programs\Settings\table_settings.mat');

handles.settings = table_settings;

set(handles.cb_tlatency,'value',table_settings.tlatency)
set(handles.cb_tpeak,'value',table_settings.tpeak)
set(handles.cb_tsettle,'value',table_settings.tsettle)
set(handles.cb_vpeak,'value',table_settings.vpeak)
set(handles.cb_respamp,'value',table_settings.respamp)
set(handles.cb_finalamp,'value',table_settings.finalamp)
set(handles.cb_mainseq,'value',table_settings.main_seq_ratio)

% Choose default command line output for table_settings_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes table_settings_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = table_settings_VEMAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.table_params_str = {}; % initiate as a cell
handles.settings.table_params = {};
handles.settings.index = {};
j = 2;
if handles.settings.tlatency == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Latency'];
    handles.settings.table_params = [handles.settings.table_params 'latency'];
    handles.settings.index.latency = j;
    j= j+1;
else
    handles.settings.index.latency = [];
end

if handles.settings.tpeak == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Time to Peak Velocity'];
    handles.settings.table_params = [handles.settings.table_params 'tpeak'];
    handles.settings.index.tpeak = j;
    j= j+1;
else
    handles.settings.index.tpeak = [];
end

if handles.settings.tsettle == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Settling Time'];
    handles.settings.table_params = [handles.settings.table_params 'tsettle'];
    handles.settings.index.tsettle = j;
    j= j+1;
else
    handles.settings.index.tsettle = [];
end

if handles.settings.vpeak == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Peak Velocity'];
    handles.settings.table_params = [handles.settings.table_params 'vpeak'];
    handles.settings.index.vpeak = j;
    j= j+1;
else
    handles.settings.index.vpeak = [];
end

if handles.settings.respamp == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Response Amplitude'];
    handles.settings.table_params = [handles.settings.table_params 'response_amp'];
    handles.settings.index.response_amp = j;
    j= j+1;
else
    handles.settings.index.response_amp = [];
end

if handles.settings.finalamp == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Final Amplitude'];
    handles.settings.table_params = [handles.settings.table_params 'final_amp'];
    handles.settings.index.final_amp = j;
    j= j+1;
else
    handles.settings.index.final_amp = [];
end

if handles.settings.main_seq_ratio == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Main Sequence Ratio'];
    handles.settings.table_params = [handles.settings.table_params 'main_seq_ratio'];
    handles.settings.index.main_seq_ratio = j;
    j= j+1;
else
    handles.settings.index.main_seq_ratio = [];
end

if handles.settings.time_constant == 1
    handles.settings.table_params_str = [handles.settings.table_params_str 'Time Constant'];
    handles.settings.table_params = [handles.settings.table_params 'time_constant'];
    handles.settings.index.time_constant = j;
    j= j+1;
else
    handles.settings.index.time_constant = [];
end

table_settings = handles.settings;
save('Programs\Settings\table_settings.mat','table_settings')

guidata(hObject,handles)

% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in cb_tlatency.
function cb_tlatency_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tlatency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.tlatency = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_tlatency


% --- Executes on button press in cb_tpeak.
function cb_tpeak_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.tpeak= get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_tpeak


% --- Executes on button press in cb_tsettle.
function cb_tsettle_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tsettle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.tsettle = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_tsettle


% --- Executes on button press in cb_vpeak.
function cb_vpeak_Callback(hObject, eventdata, handles)
% hObject    handle to cb_vpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.vpeak = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_vpeak


% --- Executes on button press in cb_respamp.
function cb_respamp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_respamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.respamp = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_respamp


% --- Executes on button press in cb_finalamp.
function cb_finalamp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_finalamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.finalamp = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_finalamp


% --- Executes on button press in cb_mainseq.
function cb_mainseq_Callback(hObject, eventdata, handles)
% hObject    handle to cb_mainseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.main_seq_ratio = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_mainseq


% --- Executes on button press in cb_timeconstant.
function cb_timeconstant_Callback(hObject, eventdata, handles)
% hObject    handle to cb_timeconstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.settings.time_constant = get(hObject,'value');

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_timeconstant
