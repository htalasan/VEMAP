function varargout = main_menu(varargin)
% MAIN_MENU MATLAB code for main_menu.fig
%      MAIN_MENU, by itself, creates a new MAIN_MENU or raises the existing
%      singleton*.
%
%      H = MAIN_MENU returns the handle to a new MAIN_MENU or the handle to
%      the existing singleton*.
%
%      MAIN_MENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_MENU.M with the given input arguments.
%
%      MAIN_MENU('Property','Value',...) creates a new MAIN_MENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_menu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_menu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   07/18/16    Added mSDMT Analysis
% 1.2   08/01/17    Excel export

% Edit the above text to modify the response to help main_menu

% Last Modified by GUIDE v2.5 01-Aug-2017 22:00:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @main_menu_OpeningFcn, ...
    'gui_OutputFcn',  @main_menu_OutputFcn, ...
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


% --- Executes just before main_menu is made visible.
function main_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_menu (see VARARGIN)

% Display Images
% % Code for displaying NJIT's Logo
% axes(handles.logo_njit);
% imshow('njit-logo.jpg')
% % Code for displaying VNEL's Logo
% axes(handles.logo_vnel);
% imshow('VNEL_final.png')
% This was taken out due to the fact that imshow is part of a toolbox. That
% doesn't help when you want to compile and package the program.


% Choose default command line output for main_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main_menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_menu_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_preprocess.
function pb_preprocess_Callback(hObject, eventdata, handles)
% hObject    handle to pb_preprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
preprocess_VEMAP;

% --- Executes on button press in pb_datacalibration.
function pb_datacalibration_Callback(hObject, eventdata, handles)
% hObject    handle to pb_datacalibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Calibration_VEMAP;

% --- Executes on button press in pb_basic.
function pb_basic_Callback(hObject, eventdata, handles)
% hObject    handle to pb_basic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Analysis_VEMAP;

% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in pb_readme.
function pb_readme_Callback(hObject, eventdata, handles)
% hObject    handle to pb_readme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_protocol.
function pb_protocol_Callback(hObject, eventdata, handles)
% hObject    handle to pb_protocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Protocol_Maker_VEMAP

% --- Executes on button press in pb_experimentviewer.
function pb_experimentviewer_Callback(hObject, eventdata, handles)
% hObject    handle to pb_experimentviewer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Experiment_Viewer_VEMAP;

% --- Executes on button press in pb_categorizedata.
function pb_categorizedata_Callback(hObject, eventdata, handles)
% hObject    handle to pb_categorizedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Classify_VEMAP;

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_mSDMT.
function pb_mSDMT_Callback(hObject, eventdata, handles)
% hObject    handle to pb_mSDMT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mSDMT_gui;

% --- Executes on button press in pb_plot.
function pb_plot_Callback(hObject, eventdata, handles)
% hObject    handle to pb_plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plot_maker_VEMAP;

% --- Executes on button press in pb_preprocess_settings.
function pb_preprocess_settings_Callback(hObject, eventdata, handles)
% hObject    handle to pb_preprocess_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
preprocess_settings_VEMAP;


% --- Executes on button press in pb_calculate.
function pb_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Calculate_VEMAP;

% --- Executes on button press in pb_classify_settings.
function pb_classify_settings_Callback(hObject, eventdata, handles)
% hObject    handle to pb_classify_settings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
classify_settings_VEMAP;


% --- Executes on button press in pb_excelexport.
function pb_excelexport_Callback(hObject, eventdata, handles)
% hObject    handle to pb_excelexport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
export_means;