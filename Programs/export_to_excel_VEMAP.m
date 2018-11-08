function varargout = export_to_excel_VEMAP(varargin)
% EXPORT_TO_EXCEL_VEMAP MATLAB code for export_to_excel_VEMAP.fig
%      EXPORT_TO_EXCEL_VEMAP, by itself, creates a new EXPORT_TO_EXCEL_VEMAP or raises the existing
%      singleton*.
%
%      H = EXPORT_TO_EXCEL_VEMAP returns the handle to a new EXPORT_TO_EXCEL_VEMAP or the handle to
%      the existing singleton*.
%
%      EXPORT_TO_EXCEL_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPORT_TO_EXCEL_VEMAP.M with the given input arguments.
%
%      EXPORT_TO_EXCEL_VEMAP('Property','Value',...) creates a new EXPORT_TO_EXCEL_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before export_to_excel_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to export_to_excel_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help export_to_excel_VEMAP

% Last Modified by GUIDE v2.5 06-Aug-2017 20:17:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @export_to_excel_VEMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @export_to_excel_VEMAP_OutputFcn, ...
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


% --- Executes just before export_to_excel_VEMAP is made visible.
function export_to_excel_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to export_to_excel_VEMAP (see VARARGIN)

% Choose default command line output for export_to_excel_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes export_to_excel_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = export_to_excel_VEMAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_filename as a double


% --- Executes during object creation, after setting all properties.
function edit_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_export.
function pb_export_Callback(hObject, eventdata, handles)
% hObject    handle to pb_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filename = get(handles.edit_filename, 'String');

disp(filename)
experiment_contents = get(handles.popup_experiment,'String');
experiment_type = experiment_contents{get(handles.popup_experiment,'Value')};
disp(experiment_type)
%EXPORT_means(filename, experiment_type)

% --- Executes on selection change in popup_experiment.
function popup_experiment_Callback(hObject, eventdata, handles)
% hObject    handle to popup_experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_experiment contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_experiment


% --- Executes during object creation, after setting all properties.
function popup_experiment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_experiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
