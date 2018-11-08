function varargout = Protocol_Maker_VEMAP(varargin)
% PROTOCOL_MAKER_VEMAP MATLAB code for Protocol_Maker_VEMAP.fig
%      PROTOCOL_MAKER_VEMAP, by itself, creates a new PROTOCOL_MAKER_VEMAP or raises the existing
%      singleton*.
%
%      H = PROTOCOL_MAKER_VEMAP returns the handle to a new PROTOCOL_MAKER_VEMAP or the handle to
%      the existing singleton*.
%
%      PROTOCOL_MAKER_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROTOCOL_MAKER_VEMAP.M with the given input arguments.
%
%      PROTOCOL_MAKER_VEMAP('Property','Value',...) creates a new PROTOCOL_MAKER_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Protocol_Maker_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Protocol_Maker_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/03/16    Resolved issues with axis and mode choices for the
%                   calibration sequences. Users should now be able to do
%                   vertical and binocular.

% Edit the above text to modify the response to help Protocol_Maker_VEMAP

% Last Modified by GUIDE v2.5 11-Dec-2015 16:41:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Protocol_Maker_VEMAP_OpeningFcn, ...
                   'gui_OutputFcn',  @Protocol_Maker_VEMAP_OutputFcn, ...
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


% --- Executes just before Protocol_Maker_VEMAP is made visible.
function Protocol_Maker_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Protocol_Maker_VEMAP (see VARARGIN)

% Initialize Variables

handles.config.protocolname_done = 0;
handles.config.sections_done = 0;
handles.config.stimuli_done = 0;
handles.config.sequence_done = 0;
handles.config.cal_done = 0;
handles.config.calibration = [];
handles.pathname = 'C:\Users\VISION-1\Documents\_TOP_SECRET_\Protocols';

% Choose default command line output for Protocol_Maker_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Protocol_Maker_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Protocol_Maker_VEMAP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pb_loadprotocol.
function pb_loadprotocol_Callback(hObject, eventdata, handles)
% hObject    handle to pb_loadprotocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = ...
    uigetfile('*.protocol.mat','Select Experimental Protocol',('Protocols\'),'MultiSelect','off');

load([PathName FileName])

handles.config = config;

% update all the listboxes!!!
set(handles.lb_section,'value',1)
set(handles.lb_section,'string',handles.config.sections)

section = handles.config.sections{1};

set(handles.lb_stimtype,'value',1)
set(handles.lb_stimtype,'string',handles.config.(section).stims)

set(handles.edit_protocol_name,'string',FileName(1:end-13));

a = [];

try
a = fieldnames(handles.config.calibration);
catch
end
set(handles.lb_calibration,'string',a)

% update gui handles
guidata(hObject,handles)

% --- Executes on selection change in lb_section.
function lb_section_Callback(hObject, eventdata, handles)
% hObject    handle to lb_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_section contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_section

str = get(hObject,'String');
val = get(hObject,'value');

handles.config.curr_section = str{val};
section = handles.config.curr_section;

% update all the things
try
set(handles.edit_numloops,'string',handles.config.(section).numloops)
set(handles.lb_stimtype,'string',handles.config.(section).stims)
set(handles.lb_stimtype,'value',1)
catch
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lb_section_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_numloops_Callback(hObject, eventdata, handles)
% hObject    handle to edit_numloops (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_numloops as text
%        str2double(get(hObject,'String')) returns contents of edit_numloops as a double


% --- Executes during object creation, after setting all properties.
function edit_numloops_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_numloops (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lb_stimtype.
function lb_stimtype_Callback(hObject, eventdata, handles)
% hObject    handle to lb_stimtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_stimtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_stimtype
sect_str = get(handles.lb_section,'string');
sect = sect_str{get(handles.lb_section,'value')};
stim_str = get(handles.lb_stimtype,'string');
stim = stim_str{get(handles.lb_stimtype,'value')};

new_str = num2str(handles.config.(sect).(stim).sequence);

set(handles.edit_sequence,'string',new_str);

% --- Executes during object creation, after setting all properties.
function lb_stimtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_stimtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_protocol_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_protocol_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_protocol_name as text
%        str2double(get(hObject,'String')) returns contents of edit_protocol_name as a double
handles.config.protocol_name = get(hObject,'String');
handles.config.protocolname_done = 1;
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_protocol_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_protocol_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_addsection.
function pb_addsection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addsection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Adds section to the protocol
section = get(handles.edit_section_name,'string');

if isfield(handles.config,section) == 1
    msgbox('Section name already taken!','Error','error');
else
    if handles.config.sections_done == 0 % initializes the section
        % get section name from edit_section_name
        handles.config.sections = {};
        
        handles.config.sections(1) = {section}; %initialized section names
        handles.config.sections_done = 1;
        
        handles.config.(section).stims = {}; % initialize the lb_stim string
        handles.config.(section).stim_done = 0;
        handles.config.(section).numloops = 1; %initialize the number of loops
        
    else
        handles.config.sections(end+1) = {section};
        handles.config.(section).stim_done = 0;
        handles.config.(section).stims = {}; % initialize the lb_stim string
        handles.config.(section).numloops = 1; %initialize the number of loops
        
    end
    
    %update stuff
    set(handles.lb_section,'string',handles.config.sections)% listbox
    set(handles.lb_section,'value',length(handles.config.sections));
    handles.config.curr_section = section;
    
    % Update handles structure
    guidata(hObject, handles);
end





% --- Executes on button press in pb_deletesection.
function pb_deletesection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_deletesection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
section_str = get(handles.lb_section,'string');
section_val = get(handles.lb_section,'value');

section = section_str{section_val};

handles.config.sections(section_val) = [];

%update stuff
set(handles.lb_section,'string',handles.config.sections)% listbox
set(handles.lb_section,'value',1)
handles.config = rmfield(handles.config,section);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_editsection.
function pb_editsection_Callback(hObject, eventdata, handles)
% hObject    handle to pb_editsection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_addstim.
function pb_addstim_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% add stim to the section in the protocol
stim = get(handles.edit_stimulus_name,'string');
section = handles.config.curr_section;

if isfield(handles.config.(section),stim) == 1
    msgbox('Stimulus Name already taken!','Error','error');
else
    if handles.config.(section).stim_done == 0
        
        handles.config.(section).stims(1) = {stim};
        handles.config.(section).stim_done = 1;
        
        handles.config.(section).(stim).sequence_done = 0; %sees if there's a seq for stim
        handles.config.(section).(stim).sequence = [];
    else
        handles.config.(section).stims(end+1) = {stim};
        handles.config.(section).stim_done = 1;
        handles.config.(section).(stim).sequence_done = 0;
        handles.config.(section).(stim).sequence = [];
    end
    
    %  update stuff
    handles.config.curr_stim = stim;
    set(handles.lb_stimtype,'string',handles.config.(section).stims)
    set(handles.lb_stimtype,'value',length(handles.config.(section).stims))
    
    % Update handles structure
    guidata(hObject, handles);

end


% --- Executes on button press in pb_delstim.
function pb_delstim_Callback(hObject, eventdata, handles)
% hObject    handle to pb_delstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stim_str = get(handles.lb_stimtype,'string');
stim_val = get(handles.lb_stimtype,'value');

stim = stim_str{stim_val};

section_str = get(handles.lb_section,'string');
section_val = get(handles.lb_section,'value');

section = section_str{section_val};

handles.config.(section).stims(stim_val) = [];

%update stuff
set(handles.lb_stimtype,'string',handles.config.(section).stims)% listbox
set(handles.lb_stimtype,'value',length(handles.config.(section).stims))
handles.config.(section) = rmfield(handles.config.(section),stim);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_editstim.
function pb_editstim_Callback(hObject, eventdata, handles)
% hObject    handle to pb_editstim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_sequence_Callback(hObject, eventdata, handles)
% hObject    handle to edit_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_sequence as text
%        str2double(get(hObject,'String')) returns contents of edit_sequence as a double


% --- Executes during object creation, after setting all properties.
function edit_sequence_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_sequence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_updatestimseq.
function pb_updatestimseq_Callback(hObject, eventdata, handles)
% hObject    handle to pb_updatestimseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sect_val = get(handles.lb_section,'value');
sect_str = get(handles.lb_section,'string');

sect = sect_str{sect_val};

stim_val = get(handles.lb_stimtype,'value');
stim_str = get(handles.lb_stimtype,'string');

stim = stim_str{stim_val};

stim_seq_string = get(handles.edit_sequence,'string');

stim_seq = str2num(stim_seq_string);

% disp(handles.(sect));

if isempty(stim_seq) == 1
    msgbox('Stimulus sequence does not have all numeric values','Error','error');
else
    handles.config.(sect).(stim).sequence = stim_seq;
    handles.config.(sect).(stim).sequence_done = 1;
end

% disp(handles.(sect).(stim).sequence)

%update stuff

% Update handles structure
guidata(hObject, handles);



function edit_section_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_section_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% pb_addsection_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit_section_name as text
%        str2double(get(hObject,'String')) returns contents of edit_section_name as a double


% --- Executes during object creation, after setting all properties.
function edit_section_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_section_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_stimulus_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_stimulus_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% pb_addstim_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of edit_stimulus_name as text
%        str2double(get(hObject,'String')) returns contents of edit_stimulus_name as a double


% --- Executes during object creation, after setting all properties.
function edit_stimulus_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_stimulus_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_updateloops.
function pb_updateloops_Callback(hObject, eventdata, handles)
% hObject    handle to pb_updateloops (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
sect_val = get(handles.lb_section,'value');
sect_str = get(handles.lb_section,'string');

sect = sect_str{sect_val};

loopnum = str2num(get(handles.edit_numloops,'string'));

if isempty(loopnum) == 0
    handles.config.(sect).numloops = loopnum;
else
    msgbox('Invalid loopnumber','Error','error')
end

% disp(loopnum)

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in lb_calibration.
function lb_calibration_Callback(hObject, eventdata, handles)
% hObject    handle to lb_calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lb_calibration contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lb_calibration
str = get(hObject,'string');
val = get(hObject,'value');
calname = str{val};

left = num2str(handles.config.calibration.(calname).LEseq);
right = num2str(handles.config.calibration.(calname).REseq);

set(handles.edit_LEcalpoints,'string',left)
set(handles.edit_REcalpoints,'string',right)

% disp(handles.config.calibration.(calname).LEseq)

% disp(handles.config.calibration.(calname))

if handles.config.calibration.(calname).first_eye == 1
    set(handles.rb_left,'value',1)
    set(handles.rb_right,'value',0)
else
    set(handles.rb_left,'value',0)
    set(handles.rb_right,'value',1)
end

if handles.config.calibration.(calname).axis == 1
    set(handles.rb_horz,'value',1)
    set(handles.rb_vert,'value',0)
else
    set(handles.rb_vert,'value',1)
    set(handles.rb_horz,'value',0)
end

if handles.config.calibration.(calname).type == 1
    set(handles.rb_mon,'value',1)
    set(handles.rb_bin,'value',0)
else
    set(handles.rb_bin,'value',1)
    set(handles.rb_mon,'value',0)
end



% --- Executes during object creation, after setting all properties.
function lb_calibration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb_calibration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_addcal.
function pb_addcal_Callback(hObject, eventdata, handles)
% hObject    handle to pb_addcal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Adds section to the protocol
calname = get(handles.edit_calname,'string');

if isfield(handles.config.calibration,calname) == 1
    msgbox('Calibration name already taken!','Error','error');
else
    if handles.config.cal_done == 0 % initializes the section
        % get section name from edit_section_name
%         handles.config.calibration.calnames = {};
        handles.config.calibration.calnames(1) = {calname};
        
        handles.config.calibration.(calname).LEseq = [];
        handles.config.calibration.(calname).REseq = [];
        handles.config.calibration.(calname).BINseq = [];
        handles.config.calibration.(calname).type = 1; % binocular first
        handles.config.calibration.(calname).axis = 1; % horizontal first
        handles.config.calibration.(calname).first_eye = 1; %left eye first
        handles.config.cal_done = 1;
        
    else
%         handles.config.calibration.calnames(end+1) = {calname};
        
        handles.config.calibration.(calname).LEseq = [];
        handles.config.calibration.(calname).REseq = [];
        handles.config.calibration.(calname).BINseq = [];
        handles.config.calibration.(calname).type = 1; % binocular first
        handles.config.calibration.(calname).axis = 1; % horizontal first
        handles.config.calibration.(calname).first_eye = 1; %left eye first
        
    end
    
    a = fieldnames(handles.config.calibration);
    
    %update listbox
    set(handles.lb_calibration,'string',a);
    set(handles.lb_calibration,'value',1);
    % Update handles structure
    guidata(hObject, handles);
end

% --- Executes on button press in pb_deletecal.
function pb_deletecal_Callback(hObject, eventdata, handles)
% hObject    handle to pb_deletecal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cal_str = get(handles.lb_calibration,'string');
cal_val = get(handles.lb_calibration,'value');

cal = cal_str{cal_val};

% handles.config.calibration.(cal) = [];

%update stuff
handles.config.calibration = rmfield(handles.config.calibration,cal);

a = fieldnames(handles.config.calibration);

set(handles.lb_calibration,'string',a)% listbox

if cal_val > length(a)
    set(handles.lb_calibration,'value',cal_val-1)
else
    set(handles.lb_calibration,'value',cal_val)
end

% Update handles structure
guidata(hObject, handles);

function edit_calname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_calname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_calname as text
%        str2double(get(hObject,'String')) returns contents of edit_calname as a double


% --- Executes during object creation, after setting all properties.
function edit_calname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_calname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_LEcalpoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_LEcalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_LEcalpoints as text
%        str2double(get(hObject,'String')) returns contents of edit_LEcalpoints as a double


% --- Executes during object creation, after setting all properties.
function edit_LEcalpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_LEcalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_REcalpoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_REcalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_REcalpoints as text
%        str2double(get(hObject,'String')) returns contents of edit_REcalpoints as a double


% --- Executes during object creation, after setting all properties.
function edit_REcalpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_REcalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in test.
function test_Callback(hObject, eventdata, handles)
% hObject    handle to test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save('TEST','handles')


% --- Executes when selected object is changed in uipanel3.
function uipanel3_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel3 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
% str = get(handles.lb_calibration,'string');
% val = get(handles.lb_calibration,'value');
% calname = str{val};
% 
% switch get(eventdata.NewValue,'Tag')
%     case 'rb_left'
%         handles.calibration.(calname).first_eye = 1;
%     case 'rb_right'
%         handles.calibration.(calname).first_eye = 2;
% end
% 
% disp(handles.calibration.(calname).first_eye)
% 
% guidata(hObject,handles);


% --- Executes on button press in pb_updatecalseq.
function pb_updatecalseq_Callback(hObject, eventdata, handles)
% hObject    handle to pb_updatecalseq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.lb_calibration,'string');
val = get(handles.lb_calibration,'value');
calname = str{val};

if get(handles.rb_left,'value') == 1
    handles.config.calibration.(calname).first_eye = 1;
else
    handles.config.calibration.(calname).first_eye = 2;
end


if get(handles.rb_horz,'value') == 1
    handles.config.calibration.(calname).axis = 1;
else
    handles.config.calibration.(calname).axis = 2;
end

if get(handles.rb_mon,'value') == 1
    handles.config.calibration.(calname).type = 1;
else
    handles.config.calibration.(calname).type = 2;
end


left = get(handles.edit_LEcalpoints,'string');
right = get(handles.edit_REcalpoints,'string');
leftnums = str2num(left);
rightnums = str2num(right);

if isempty(leftnums) == 0 && isempty(rightnums) == 0
    handles.config.calibration.(calname).LEseq = leftnums;
    handles.config.calibration.(calname).REseq = rightnums;
else
    msgbox('Invalid Calibration Sequence','Error','error')
end

% handles.config.calibration.(calname).type

% disp(left)
% disp(right)
% disp(handles.config.calibration.(calname).axis)

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pb_create.
function pb_create_Callback(hObject, eventdata, handles)
% hObject    handle to pb_create (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save variables into a .mat file.
FILENAME = get(handles.edit_protocol_name,'String');

%  create the protocols
observations_done = 0;

for i = 1:length(handles.config.sections)
    section = handles.config.sections{i};
   
    total_observations = 0; % initialize number
    loops = handles.config.(section).numloops;
    
    for j = 1:length(handles.config.(section).stims)
        stim = handles.config.(section).stims{j};
        
        total_observations = total_observations + length(handles.config.(section).(stim).sequence);
    end
    
%     disp(observations_done)
    for j = 1:length(handles.config.(section).stims)
        stim = handles.config.(section).stims{j};
        seq = handles.config.(section).(stim).sequence;
      
        protocol.(section).(stim) = seq_maker(seq,loops,total_observations,observations_done);
    end
    
    observations_done = observations_done + total_observations*loops;
end

%
calibration = handles.config.calibration;
config = handles.config;
if isfield(calibration,'calnames')
    calibration = rmfield(calibration,'calnames');
end

save(['Protocols\' FILENAME '.protocol.mat'],'protocol','config','calibration')
uiwait(msgbox('Protocol has been saved','Saved!','modal'))

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % OTHER FUNCTIONS
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function seq_complete = seq_maker(seq,loops,total_observations,observations_done)
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% inputs:
% seq: order of when the specific observations occur in the loop
% % loops: total number of loops of the section
% % total_observations: total number of observations in section per loop
% observations_done: how many observations are done by this point
% 
% outputs: 
% seq_complete: the completed sequence for the stimulus of the section chosen


a = seq + observations_done; %initialize sequence

for i = 1:loops-1
    b = seq+total_observations*i+observations_done;
    a = [a b];
end

seq_complete = a;



function edit_BINcalpoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BINcalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BINcalpoints as text
%        str2double(get(hObject,'String')) returns contents of edit_BINcalpoints as a double


% --- Executes during object creation, after setting all properties.
function edit_BINcalpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BINcalpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes when selected object is changed in uipanel4.
function uipanel4_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel4 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
