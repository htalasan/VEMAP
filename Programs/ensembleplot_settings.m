function varargout = ensembleplot_settings(varargin)
% ENSEMBLEPLOT_SETTINGS MATLAB code for ensembleplot_settings.fig
%      ENSEMBLEPLOT_SETTINGS, by itself, creates a new ENSEMBLEPLOT_SETTINGS or raises the existing
%      singleton*.
%
%      H = ENSEMBLEPLOT_SETTINGS returns the handle to a new ENSEMBLEPLOT_SETTINGS or the handle to
%      the existing singleton*.
%
%      ENSEMBLEPLOT_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENSEMBLEPLOT_SETTINGS.M with the given input arguments.
%
%      ENSEMBLEPLOT_SETTINGS('Property','Value',...) creates a new ENSEMBLEPLOT_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ensembleplot_settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ensembleplot_settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev. History
% 1.0   02/26/16    Release
% 1.1   03/03/16    Changed type 1 and type 2 radio buttons to check boxes... some
%                   matlab versions do not like radio button groups


% Edit the above text to modify the response to help ensembleplot_settings

% Last Modified by GUIDE v2.5 02-Mar-2016 09:31:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ensembleplot_settings_OpeningFcn, ...
                   'gui_OutputFcn',  @ensembleplot_settings_OutputFcn, ...
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


% --- Executes just before ensembleplot_settings is made visible.
function ensembleplot_settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ensembleplot_settings (see VARARGIN)

load('Programs\Settings\plot_maker_settings')

handles.settings = plot_maker_settings;

% set values
if handles.settings.ensemble_plot.mode == 1
    set(handles.cb_type1,'value',1)
    set(handles.cb_type2,'value',0)
else
    set(handles.cb_type2,'value',1)
    set(handles.cb_type1,'value',0)
end

set(handles.pop_focus,'Value',handles.settings.ensemble_plot.focus)
set(handles.check_auto,'value',handles.settings.ensemble_plot.auto)
if handles.settings.ensemble_plot.auto == 1
    set(handles.y_min,'enable','off')
    set(handles.y_max,'enable','off')
else
    set(handles.y_min,'enable','on')
    set(handles.y_max,'enable','on')
end
set(handles.check_zero,'value',handles.settings.ensemble_plot.zero_plot)
set(handles.check_target,'value',handles.settings.ensemble_plot.target_plot)

set(handles.spacing_x,'string',num2str(handles.settings.ensemble_plot.x_spacing))
set(handles.spacing_y,'string',num2str(handles.settings.ensemble_plot.y_spacing))
set(handles.y_min,'string',num2str(handles.settings.ensemble_plot.ylim(1)))
set(handles.y_max,'string',num2str(handles.settings.ensemble_plot.ylim(2)))

set(handles.start_r,'string',num2str(handles.settings.ensemble_plot.beg_color(1)))
set(handles.start_g,'string',num2str(handles.settings.ensemble_plot.beg_color(2)))
set(handles.start_b,'string',num2str(handles.settings.ensemble_plot.beg_color(3)))
set(handles.uipanel4,'backgroundcolor',handles.settings.ensemble_plot.beg_color)

set(handles.end_r,'string',num2str(handles.settings.ensemble_plot.end_color(1)))
set(handles.end_g,'string',num2str(handles.settings.ensemble_plot.end_color(2)))
set(handles.end_b,'string',num2str(handles.settings.ensemble_plot.end_color(3)))
set(handles.uipanel5,'backgroundcolor',handles.settings.ensemble_plot.end_color)

set(handles.bg_r,'string',num2str(handles.settings.ensemble_plot.bg_color(1)))
set(handles.bg_g,'string',num2str(handles.settings.ensemble_plot.bg_color(2)))
set(handles.bg_b,'string',num2str(handles.settings.ensemble_plot.bg_color(3)))


% Choose default command line output for ensembleplot_settings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ensembleplot_settings wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ensembleplot_settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function y_min_Callback(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_min as text
%        str2double(get(hObject,'String')) returns contents of y_min as a double
handles.settings.ensemble_plot.ylim(1) = str2double(get(hObject,'string'));
if handles.settings.ensemble_plot.ylim(1) >= handles.settings.ensemble_plot.ylim(2)
    uiwait(msgbox('Choose a value lower than the max value','Warning','modal'));
    return
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function y_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_max_Callback(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_max as text
%        str2double(get(hObject,'String')) returns contents of y_max as a double
handles.settings.ensemble_plot.ylim(2) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.ylim(2) <= handles.settings.ensemble_plot.ylim(1)
    uiwait(msgbox('Choose a value greater than the min value','Warning','modal'));
    return
end

guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function y_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_focus.
function pop_focus_Callback(hObject, eventdata, handles)
% hObject    handle to pop_focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_focus contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_focus
handles.settings.ensemble_plot.focus = get(hObject,'value');

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pop_focus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_focus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spacing_x_Callback(hObject, eventdata, handles)
% hObject    handle to spacing_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spacing_x as text
%        str2double(get(hObject,'String')) returns contents of spacing_x as a double
handles.settings.ensemble_plot.x_spacing = str2double(get(hObject,'string'));

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function spacing_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spacing_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function spacing_y_Callback(hObject, eventdata, handles)
% hObject    handle to spacing_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spacing_y as text
%        str2double(get(hObject,'String')) returns contents of spacing_y as a double
handles.settings.ensemble_plot.y_spacing = str2double(get(hObject,'string'));

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function spacing_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spacing_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_r_Callback(hObject, eventdata, handles)
% hObject    handle to start_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_r as text
%        str2double(get(hObject,'String')) returns contents of start_r as a double
handles.settings.ensemble_plot.beg_color(1) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.beg_color(1) >= 0 && handles.settings.ensemble_plot.beg_color(1) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end
set(handles.uipanel4,'backgroundcolor',handles.settings.ensemble_plot.beg_color)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function start_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_g_Callback(hObject, eventdata, handles)
% hObject    handle to start_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_g as text
%        str2double(get(hObject,'String')) returns contents of start_g as a double
handles.settings.ensemble_plot.beg_color(2) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.beg_color(2) >= 0 && handles.settings.ensemble_plot.beg_color(2) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end
set(handles.uipanel4,'backgroundcolor',handles.settings.ensemble_plot.beg_color)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function start_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function start_b_Callback(hObject, eventdata, handles)
% hObject    handle to start_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_b as text
%        str2double(get(hObject,'String')) returns contents of start_b as a double
handles.settings.ensemble_plot.beg_color(3) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.beg_color(3) >= 0 && handles.settings.ensemble_plot.beg_color(3) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end
set(handles.uipanel4,'backgroundcolor',handles.settings.ensemble_plot.beg_color)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function start_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_r_Callback(hObject, eventdata, handles)
% hObject    handle to end_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_r as text
%        str2double(get(hObject,'String')) returns contents of end_r as a double
handles.settings.ensemble_plot.end_color(1) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.end_color(1) >= 0 && handles.settings.ensemble_plot.end_color(1) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end
set(handles.uipanel5,'backgroundcolor',handles.settings.ensemble_plot.end_color)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function end_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_g_Callback(hObject, eventdata, handles)
% hObject    handle to end_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_g as text
%        str2double(get(hObject,'String')) returns contents of end_g as a double
handles.settings.ensemble_plot.end_color(2) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.end_color(2) >= 0 && handles.settings.ensemble_plot.end_color(2) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end
set(handles.uipanel5,'backgroundcolor',handles.settings.ensemble_plot.end_color)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function end_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function end_b_Callback(hObject, eventdata, handles)
% hObject    handle to end_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of end_b as text
%        str2double(get(hObject,'String')) returns contents of end_b as a double
handles.settings.ensemble_plot.end_color(3) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.end_color(3) >= 0 && handles.settings.ensemble_plot.end_color(3) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end
set(handles.uipanel5,'backgroundcolor',handles.settings.ensemble_plot.end_color)
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function end_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to end_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_zero.
function check_zero_Callback(hObject, eventdata, handles)
% hObject    handle to check_zero (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_zero
handles.settings.ensemble_plot.zero_plot = get(hObject,'value');

guidata(hObject,handles)


function bg_r_Callback(hObject, eventdata, handles)
% hObject    handle to bg_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_r as text
%        str2double(get(hObject,'String')) returns contents of bg_r as a double
handles.settings.ensemble_plot.bg_color(1) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.bg_color(1) >= 0 && handles.settings.ensemble_plot.bg_color(1) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function bg_r_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bg_g_Callback(hObject, eventdata, handles)
% hObject    handle to bg_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_g as text
%        str2double(get(hObject,'String')) returns contents of bg_g as a double
handles.settings.ensemble_plot.bg_color(2) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.bg_color(2) >= 0 && handles.settings.ensemble_plot.bg_color(2) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function bg_g_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_g (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bg_b_Callback(hObject, eventdata, handles)
% hObject    handle to bg_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bg_b as text
%        str2double(get(hObject,'String')) returns contents of bg_b as a double
handles.settings.ensemble_plot.bg_color(3) = str2double(get(hObject,'string'));

if handles.settings.ensemble_plot.bg_color(3) >= 0 && handles.settings.ensemble_plot.bg_color(3) <= 1
else
    uiwait(msgbox('Choose a value between 0 and 1','Warning','modal'));
    return
end

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function bg_b_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bg_b (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_target.
function check_target_Callback(hObject, eventdata, handles)
% hObject    handle to check_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_target
handles.settings.ensemble_plot.target_plot = get(hObject,'value');

guidata(hObject,handles)


function edit_target_Callback(hObject, eventdata, handles)
% hObject    handle to edit_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_target as text
%        str2double(get(hObject,'String')) returns contents of edit_target as a double
handles.settings.ensemble_plot.target_amp = str2double(get(hObject,'string'));

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_target_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_target (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_auto.
function check_auto_Callback(hObject, eventdata, handles)
% hObject    handle to check_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_auto
handles.settings.ensemble_plot.auto = get(hObject,'value');

if handles.settings.ensemble_plot.auto == 1
    set(handles.y_min,'enable','off')
    set(handles.y_max,'enable','off')
else
    set(handles.y_min,'enable','on')
    set(handles.y_max,'enable','on')
end

guidata(hObject,handles)

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


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rb_type1,'value') == 1
    handles.settings.ensemble_plot.mode = 1;
else
    handles.settings.ensemble_plot.mode = 2;
end

guidata(hObject, handles)


% --- Executes on button press in cb_type1.
function cb_type1_Callback(hObject, eventdata, handles)
% hObject    handle to cb_type1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    handles.settings.ensemble_plot.mode = 1;
    set(handles.cb_type2,'value',0)
end

guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of cb_type1


% --- Executes on button press in cb_type2.
function cb_type2_Callback(hObject, eventdata, handles)
% hObject    handle to cb_type2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'value') == 1
    handles.settings.ensemble_plot.mode = 2;
    set(handles.cb_type1,'value',0)
end

guidata(hObject, handles)
% Hint: get(hObject,'Value') returns toggle state of cb_type2
