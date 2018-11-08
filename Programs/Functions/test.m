function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 06-Apr-2015 10:37:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)

% load data set
[handles.FileName,handles.PathName] = uigetfile('*.mat*','Select the data file',(''));
load([handles.PathName handles.FileName]);

handles.data.right= right;
handles.data.left = left;
handles.data.verg = vergence;
handles.movement_names = movement_names;

set(handles.pop_movement,'String',handles.movement_names)

% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pop_movement.
function pop_movement_Callback(hObject, eventdata, handles)
% hObject    handle to pop_movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_movement contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_movement


% --- Executes during object creation, after setting all properties.
function pop_movement_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_movement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.i = get(handles.pop_movement,'Value');

i = handles.i;

axes(handles.plot_left)
tmp = handles.data.left{i};
ensemble_left(tmp)

axes(handles.plot_right)
tmp = handles.data.right{i};
ensemble_right(tmp)

axes(handles.plot_verg)
tmp = handles.data.verg{i};
ensemble_verg(tmp)

% Update handles structure
guidata(hObject, handles);


%% Plotting Functions

function ensemble_verg(x)
cla
hold on
for i = 1:size(x,1)
    plot(x(i,:),'k')
end

% get average
for i = 1:size(x,2)
average(i) = mean(x(:,i));
end

plot(average,'g','linewidth',2)

axis([0 1500 -4 4])

function ensemble_left(x)
cla
hold on
for i = 1:size(x,1)
    plot(x(i,:),'k')
end

% get average
for i = 1:size(x,2)
average(i) = mean(x(:,i));
end

plot(average,'b','linewidth',2)

axis([0 1500 -2 2])

function ensemble_right(x)
cla
hold on
for i = 1:size(x,1)
    plot(x(i,:),'k')
end

% get average
for i = 1:size(x,2)
average(i) = mean(x(:,i));
end

plot(average,'r','linewidth',2)

axis([0 1500 -2 2])
