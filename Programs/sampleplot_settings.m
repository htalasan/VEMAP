function varargout = sampleplot_settings(varargin)
% SAMPLEPLOT_SETTINGS MATLAB code for sampleplot_settings.fig
%      SAMPLEPLOT_SETTINGS, by itself, creates a new SAMPLEPLOT_SETTINGS or raises the existing
%      singleton*.
%
%      H = SAMPLEPLOT_SETTINGS returns the handle to a new SAMPLEPLOT_SETTINGS or the handle to
%      the existing singleton*.
%
%      SAMPLEPLOT_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLEPLOT_SETTINGS.M with the given input arguments.
%
%      SAMPLEPLOT_SETTINGS('Property','Value',...) creates a new SAMPLEPLOT_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sampleplot_settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sampleplot_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/03/16    Added inverse checkboxes for combined, left, and right

% Edit the above text to modify the response to help sampleplot_settings

% Last Modified by GUIDE v2.5 02-Mar-2016 09:43:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sampleplot_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @sampleplot_settings_OutputFcn, ...
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


% --- Executes just before sampleplot_settings is made visible.
function sampleplot_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sampleplot_settings (see VARARGIN)
load('Programs\Settings\plot_maker_settings')

handles.plot_maker_settings = plot_maker_settings;

%set values
set(handles.cb_in_left,'value',handles.plot_maker_settings.sample_plot.inverse_left)
set(handles.cb_in_right,'value',handles.plot_maker_settings.sample_plot.inverse_right)
set(handles.cb_in_comb,'value',handles.plot_maker_settings.sample_plot.inverse_comb)
set(handles.cb_comb,'value',handles.plot_maker_settings.sample_plot.comb)
set(handles.cb_right,'value',handles.plot_maker_settings.sample_plot.right)
set(handles.cb_left,'value',handles.plot_maker_settings.sample_plot.left)
set(handles.cb_zero,'value',handles.plot_maker_settings.sample_plot.zero)
set(handles.cb_target,'value',handles.plot_maker_settings.sample_plot.target)
set(handles.edit_targetamp,'string',num2str(handles.plot_maker_settings.sample_plot.target_amp))

if handles.plot_maker_settings.sample_plot.auto == 1
    set(handles.cb_auto,'value',1)
    set(handles.cb_manual,'value',0)
    set(handles.edit_start,'enable','off')
    set(handles.edit_end,'enable','off')
else
    set(handles.cb_manual,'value',1)
    set(handles.cb_auto,'value',0)
    set(handles.edit_start,'enable','on')
    set(handles.edit_end,'enable','on')
end

set(handles.edit_start,'string',num2str(handles.plot_maker_settings.sample_plot.ylim(1)))
set(handles.edit_end,'string',num2str(handles.plot_maker_settings.sample_plot.ylim(2)))

% Choose default command line output for sampleplot_settings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes sampleplot_settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sampleplot_settings_OutputFcn(hObject, eventdata, handles) 
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
plot_maker_settings = handles.plot_maker_settings;

save('Programs\Settings\plot_maker_settings','plot_maker_settings')

uiwait(msgbox('Settings have been saved!','Saved','modal'));



% --- Executes on button press in cb_auto.
function cb_auto_Callback(hObject, eventdata, handles)
% hObject    handle to cb_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'value',1)
set(handles.cb_manual,'Value',0)
handles.plot_maker_settings.sample_plot.auto = get(handles.cb_auto,'Value');
set(handles.edit_start,'enable','off')
set(handles.edit_end,'enable','off')
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_auto


% --- Executes on button press in cb_manual.
function cb_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(hObject,'value',1)
set(handles.cb_auto,'Value',0)
handles.plot_maker_settings.sample_plot.auto = get(handles.cb_auto,'Value');
set(handles.edit_start,'enable','on')
set(handles.edit_end,'enable','on')
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_manual



function edit_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.ylim(1) = str2double(get(hObject,'string'));

if handles.plot_maker_settings.sample_plot.ylim(1) >= handles.plot_maker_settings.sample_plot.ylim(2)
    uiwait(msgbox('Choose a value less than the max value','Warning','modal'));
    return
end


guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_start as text
%        str2double(get(hObject,'String')) returns contents of edit_start as a double


% --- Executes during object creation, after setting all properties.
function edit_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.ylim(2) = str2double(get(hObject,'string'));

if handles.plot_maker_settings.sample_plot.ylim(2) <= handles.plot_maker_settings.sample_plot.ylim(1)
    uiwait(msgbox('Choose a greater lower than the min value','Warning','modal'));
    return
end


guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_end as text
%        str2double(get(hObject,'String')) returns contents of edit_end as a double


% --- Executes during object creation, after setting all properties.
function edit_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cb_comb.
function cb_comb_Callback(hObject, eventdata, handles)
% hObject    handle to cb_comb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.comb = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_comb


% --- Executes on button press in cb_right.
function cb_right_Callback(hObject, eventdata, handles)
% hObject    handle to cb_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.right = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_right


% --- Executes on button press in cb_left.
function cb_left_Callback(hObject, eventdata, handles)
% hObject    handle to cb_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.left = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_left


% --- Executes on button press in cb_zero.
function cb_zero_Callback(hObject, eventdata, handles)
% hObject    handle to cb_zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.zero = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_zero


% --- Executes on button press in cb_target.
function cb_target_Callback(hObject, eventdata, handles)
% hObject    handle to cb_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.target = get(hObject,'Value');

if get(hObject,'value') == 1
    set(handles.edit_targetamp,'enable','on')
else
    set(handles.edit_targetamp,'enable','off')
end

guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_target



function edit_targetamp_Callback(hObject, eventdata, handles)
% hObject    handle to edit_targetamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.target_amp = str2double(get(hObject,'string'));
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_targetamp as text
%        str2double(get(hObject,'String')) returns contents of edit_targetamp as a double


% --- Executes during object creation, after setting all properties.
function edit_targetamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_targetamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in cb_in_comb.
function cb_in_comb_Callback(hObject, eventdata, handles)
% hObject    handle to cb_in_comb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.inverse_comb = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_in_comb


% --- Executes on button press in cb_in_right.
function cb_in_right_Callback(hObject, eventdata, handles)
% hObject    handle to cb_in_right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.inverse_right = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_in_right


% --- Executes on button press in cb_in_left.
function cb_in_left_Callback(hObject, eventdata, handles)
% hObject    handle to cb_in_left (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plot_maker_settings.sample_plot.inverse_left = get(hObject,'Value');
guidata(hObject,handles)
% Hint: get(hObject,'Value') returns toggle state of cb_in_left
