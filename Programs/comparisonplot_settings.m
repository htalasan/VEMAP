function varargout = comparisonplot_settings(varargin)
% COMPARISONPLOT_SETTINGS MATLAB code for comparisonplot_settings.fig
%      COMPARISONPLOT_SETTINGS, by itself, creates a new COMPARISONPLOT_SETTINGS or raises the existing
%      singleton*.
%
%      H = COMPARISONPLOT_SETTINGS returns the handle to a new COMPARISONPLOT_SETTINGS or the handle to
%      the existing singleton*.
%
%      COMPARISONPLOT_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARISONPLOT_SETTINGS.M with the given input arguments.
%
%      COMPARISONPLOT_SETTINGS('Property','Value',...) creates a new COMPARISONPLOT_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before comparisonplot_settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to comparisonplot_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help comparisonplot_settings

% Rev History
% 1.0   02/26/16    Release

% Last Modified by GUIDE v2.5 08-Feb-2016 16:58:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @comparisonplot_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @comparisonplot_settings_OutputFcn, ...
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


% --- Executes just before comparisonplot_settings is made visible.
function comparisonplot_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to comparisonplot_settings (see VARARGIN)
load('Programs\Settings\plot_maker_settings')

handles.settings = plot_maker_settings;

%
set(handles.edit_poslim,'string',num2str(handles.settings.comparison_plot.ylim_p))
set(handles.edit_vellim,'string',num2str(handles.settings.comparison_plot.ylim_v))

set(handles.edit_posticks,'string',num2str(handles.settings.comparison_plot.ytick_p))
set(handles.edit_velticks,'string',num2str(handles.settings.comparison_plot.ytick_v))

% figuring out the symmetry...
a = handles.settings.comparison_plot.ylim_p;
b = handles.settings.comparison_plot.ylim_v;

a_ratio = a(1)/a(2);
b_ratio = b(1)/b(2);

set(handles.check_limsym,'string',num2str(a_ratio/b_ratio))
if a_ratio/b_ratio == 1
    set(handles.check_limsym,'value',1)
else
    set(handles.check_limsym,'value',0)
end

a_t = handles.settings.comparison_plot.ytick_p;
b_t = handles.settings.comparison_plot.ytick_v;

for i = 1:length(a_t)
    a_t2(i) = a_t(1)/a(1);
end
for i = 1:length(b_t)
    b_t2(i) = b_t(1)/b(1);
end

if a_t2 == b_t2
    set(handles.check_ticksym,'value',1)
else
    set(handles.check_ticksym,'value',0)
end



% Choose default command line output for comparisonplot_settings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes comparisonplot_settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = comparisonplot_settings_OutputFcn(hObject, eventdata, handles) 
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
plot_maker_settings = handles.settings;

save('Programs\Settings\plot_maker_settings','plot_maker_settings')
uiwait(msgbox('Settings have been saved!','Saved','modal'));

% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


function edit_poslim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_poslim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_poslim as text
%        str2double(get(hObject,'String')) returns contents of edit_poslim as a double
handles.settings.comparison_plot.ylim_p = str2num(get(hObject,'string'));

% figuring out the symmetry...
a = handles.settings.comparison_plot.ylim_p;
b = handles.settings.comparison_plot.ylim_v;

a_ratio = a(1)/a(2);
b_ratio = b(1)/b(2);

set(handles.check_limsym,'string',num2str(a_ratio/b_ratio))
if a_ratio/b_ratio == 1
    set(handles.check_limsym,'value',1)
else
    set(handles.check_limsym,'value',0)
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_poslim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_poslim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_vellim_Callback(hObject, eventdata, handles)
% hObject    handle to edit_vellim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_vellim as text
%        str2double(get(hObject,'String')) returns contents of edit_vellim as a double
handles.settings.comparison_plot.ylim_v = str2num(get(hObject,'string'));

% figuring out the symmetry...
a = handles.settings.comparison_plot.ylim_p;
b = handles.settings.comparison_plot.ylim_v;

a_ratio = a(1)/a(2);
b_ratio = b(1)/b(2);

set(handles.check_limsym,'string',num2str(a_ratio/b_ratio))
if a_ratio/b_ratio == 1
    set(handles.check_limsym,'value',1)
else
    set(handles.check_limsym,'value',0)
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_vellim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_vellim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_posticks_Callback(hObject, eventdata, handles)
% hObject    handle to posticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of posticks as text
%        str2double(get(hObject,'String')) returns contents of posticks as a double
handles.settings.comparison_plot.ytick_p = str2num(get(hObject,'string'));

% figuring out the symmetry...
a = handles.settings.comparison_plot.ylim_p;
b = handles.settings.comparison_plot.ylim_v;

a_t = handles.settings.comparison_plot.ytick_p;
b_t = handles.settings.comparison_plot.ytick_v;

for i = 1:length(a_t)
    a_t2(i) = a_t(1)/a(1);
end
for i = 1:length(b_t)
    b_t2(i) = b_t(1)/b(1);
end

guidata(hObject,handles)

if length(a_t2) ~= length(b_t2)
    uiwait(msgbox('Lengths are not the same!','Warning','modal'));
    return
end
    
if a_t2 == b_t2
    set(handles.check_ticksym,'value',1)
else
    set(handles.check_ticksym,'value',0)
end


% --- Executes during object creation, after setting all properties.
function edit_posticks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to posticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_velticks_Callback(hObject, eventdata, handles)
% hObject    handle to velticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of velticks as text
%        str2double(get(hObject,'String')) returns contents of velticks as a double
handles.settings.comparison_plot.ytick_v = str2num(get(hObject,'string')); %#ok<*ST2NM>

% figuring out the symmetry...
a = handles.settings.comparison_plot.ylim_p;
b = handles.settings.comparison_plot.ylim_v;

a_t = handles.settings.comparison_plot.ytick_p;
b_t = handles.settings.comparison_plot.ytick_v;

for i = 1:length(a_t)
    a_t2(i) = a_t(1)/a(1);
end
for i = 1:length(b_t)
    b_t2(i) = b_t(1)/b(1);
end

guidata(hObject,handles)

if length(a_t2) ~= length(b_t2)
    uiwait(msgbox('Lengths are not the same!','Warning','modal'));
    return
end
    
if a_t2 == b_t2
    set(handles.check_ticksym,'value',1)
else
    set(handles.check_ticksym,'value',0)
end

% --- Executes during object creation, after setting all properties.
function edit_velticks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to velticks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_limsym.
function check_limsym_Callback(hObject, eventdata, handles)
% hObject    handle to check_limsym (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_limsym


% --- Executes on button press in check_ticksym.
function check_ticksym_Callback(hObject, eventdata, handles)
% hObject    handle to check_ticksym (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_ticksym
