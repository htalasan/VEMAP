function varargout = preprocess_settings_VEMAP(varargin)
% PREPROCESS_SETTINGS_VEMAP MATLAB code for preprocess_settings_VEMAP.fig
%      PREPROCESS_SETTINGS_VEMAP, by itself, creates a new PREPROCESS_SETTINGS_VEMAP or raises the existing
%      singleton*.
%
%      H = PREPROCESS_SETTINGS_VEMAP returns the handle to a new PREPROCESS_SETTINGS_VEMAP or the handle to
%      the existing singleton*.
%
%      PREPROCESS_SETTINGS_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCESS_SETTINGS_VEMAP.M with the given input arguments.
%
%      PREPROCESS_SETTINGS_VEMAP('Property','Value',...) creates a new PREPROCESS_SETTINGS_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before preprocess_settings_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to preprocess_settings_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release

% Edit the above text to modify the response to help preprocess_settings_VEMAP

% Last Modified by GUIDE v2.5 31-Mar-2016 14:19:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @preprocess_settings_VEMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @preprocess_settings_VEMAP_OutputFcn, ...
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


% --- Executes just before preprocess_settings_VEMAP is made visible.
function preprocess_settings_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to preprocess_settings_VEMAP (see VARARGIN)

% initialize settings
% try
    load('Programs\Settings\preprocess_settings')
    handles.settings = preprocess_settings; % places old settings into settings handle
    set(handles.edit_caliblength,'string',handles.settings.caliblength)
    set(handles.cb_salus,'value',handles.settings.salus)
    set(handles.cb_kessler,'value',handles.settings.kessler)
%     disp('This loaded')
% catch
% end

% Choose default command line output for preprocess_settings_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes preprocess_settings_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = preprocess_settings_VEMAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;



function edit_rawpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_rawpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_rawpath as text
%        str2double(get(hObject,'String')) returns contents of edit_rawpath as a double

dir = get(hObject,'String');

handles.settings.rawpath = dir;

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_rawpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_rawpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_preprocessedpath_Callback(hObject, eventdata, handles)
% hObject    handle to edit_preprocessedpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_preprocessedpath as text
%        str2double(get(hObject,'String')) returns contents of edit_preprocessedpath as a double

dir = get(hObject,'String');

handles.settings.preprocessedpath = dir;

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_preprocessedpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_preprocessedpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_caliblength_Callback(hObject, eventdata, handles)
% hObject    handle to edit_caliblength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_caliblength as text
%        str2double(get(hObject,'String')) returns contents of edit_caliblength as a double

n = get(hObject,'string');

handles.settings.caliblength = str2double(n);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit_caliblength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_caliblength (see GCBO)
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
preprocess_settings = handles.settings;

save('Programs\Settings\preprocess_settings','preprocess_settings');


% --- Executes on button press in cb_salus.
function cb_salus_Callback(hObject, eventdata, handles)
% hObject    handle to cb_salus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.cb_kessler,'value',0)
% Hint: get(hObject,'Value') returns toggle state of cb_salus
handles.settings.salus = get(hObject,'value');
guidata(hObject,handles)


% --- Executes on button press in cb_kessler.
function cb_kessler_Callback(hObject, eventdata, handles)
% hObject    handle to cb_kessler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.cb_salus,'value',0)
% Hint: get(hObject,'Value') returns toggle state of cb_kessler
handles.settings.kessler = get(hObject,'value');
guidata(hObject,handles)
