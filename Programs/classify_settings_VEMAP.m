function varargout = classify_settings_VEMAP(varargin)
% CLASSIFY_SETTINGS_VEMAP MATLAB code for classify_settings_VEMAP.fig
%      CLASSIFY_SETTINGS_VEMAP, by itself, creates a new CLASSIFY_SETTINGS_VEMAP or raises the existing
%      singleton*.
%
%      H = CLASSIFY_SETTINGS_VEMAP returns the handle to a new CLASSIFY_SETTINGS_VEMAP or the handle to
%      the existing singleton*.
%
%      CLASSIFY_SETTINGS_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFY_SETTINGS_VEMAP.M with the given input arguments.
%
%      CLASSIFY_SETTINGS_VEMAP('Property','Value',...) creates a new CLASSIFY_SETTINGS_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before classify_settings_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to classify_settings_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release

% Edit the above text to modify the response to help classify_settings_VEMAP

% Last Modified by GUIDE v2.5 23-Mar-2016 16:22:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @classify_settings_VEMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @classify_settings_VEMAP_OutputFcn, ...
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


% --- Executes just before classify_settings_VEMAP is made visible.
function classify_settings_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to classify_settings_VEMAP (see VARARGIN)
load('Programs\Settings\classify_settings')
handles.settings = classify_settings;
set(handles.pop_classificationtypes,'string',handles.settings.classificationtypes)
set(handles.lb_classifications,'string',handles.settings.classifications{1})
% Choose default command line output for classify_settings_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes classify_settings_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = classify_settings_VEMAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pop_classificationtypes.
function pop_classificationtypes_Callback(hObject, eventdata, handles)
% hObject    handle to pop_classificationtypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'value');

set(handles.lb_classifications,'string',handles.settings.classifications{val})
set(handles.lb_classifications,'value',1)

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns pop_classificationtypes contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_classificationtypes


% --- Executes during object creation, after setting all properties.
function pop_classificationtypes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_classificationtypes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_classifications.
function lb_classifications_Callback(hObject, eventdata, handles)
% hObject    handle to lb_classifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_classifications contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_classifications


% --- Executes during object creation, after setting all properties.
function lb_classifications_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_classifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_addnewtype.
function pb_addnewtype_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addnewtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% put move_data in correct thing
new_type_name = inputdlg('What would you like to name the new classification type?');

handles.settings.classificationtypes = ...
    [handles.settings.classificationtypes new_type_name];

val = length(handles.settings.classificationtypes);

% initialize classifications for new type
handles.settings.classifications{val} = {};

%update table
set(handles.pop_classificationtypes,'string',handles.settings.classificationtypes)

guidata(hObject,handles);

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classify_settings = handles.settings;

save('Programs\Settings\classify_settings','classify_settings')

uiwait(msgbox('Settings have been saved!!!','Save Complete','modal'));

% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pb_deletetype.
function pb_deletetype_Callback(hObject, eventdata, handles)
% hObject    handle to pb_deletetype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = handles.settings.classificationtypes;

[s,~] = listdlg('promptstring','Delete which classification type:',...
    'liststring',str,'SelectionMode','single');

% remove chosen field
handles.settings.classificationtypes(s) = [];
handles.settings.classifications(s) = [];

if get(handles.pop_classificationtypes,'value') == s
    set(handles.pop_classificationtypes,'value',1)
    set(handles.lb_classifications,'string',handles.settings.classifications{1})
    set(handles.lb_classifications,'value',1)
end

%update table
set(handles.pop_classificationtypes,'string',handles.settings.classificationtypes)

guidata(hObject,handles)

function edit_classification_Callback(hObject, eventdata, handles)
% hObject    handle to edit_classification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_classification as text
%        str2double(get(hObject,'String')) returns contents of edit_classification as a double


% --- Executes during object creation, after setting all properties.
function edit_classification_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_classification (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_add.
function pb_add_Callback(hObject, eventdata, handles)
% hObject    handle to pb_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.edit_classification,'string');
type_val = get(handles.pop_classificationtypes,'value');

% check if already in the list

% add string to the classifications handle
handles.settings.classifications{type_val} = ...
    [handles.settings.classifications{type_val} str];

% update the lb
set(handles.lb_classifications,'string',handles.settings.classifications{type_val})

guidata(hObject,handles)

% --- Executes on button press in pb_remove.
function pb_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val_type = get(handles.pop_classificationtypes,'value');
val = get(handles.lb_classifications,'value');

handles.settings.classifications{val_type}(val) = [];

% update the lb
if get(handles.lb_classifications,'value') > length(handles.settings.classifications{val_type})
    set(handles.lb_classifications,'value',length(handles.settings.classifications{val_type}))
end

set(handles.lb_classifications,'string',handles.settings.classifications{val_type})

guidata(hObject,handles)
