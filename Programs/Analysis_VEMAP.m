function varargout = Analysis_VEMAP(varargin)
% ANALYSIS_VEMAP MATLAB code for Analysis_VEMAP.fig
%      ANALYSIS_VEMAP, by itself, creates a new ANALYSIS_VEMAP or raises the existing
%      singleton*.
%
%      H = ANALYSIS_VEMAP returns the handle to a new ANALYSIS_VEMAP or the handle to
%      the existing singleton*.
%
%      ANALYSIS_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYSIS_VEMAP.M with the given input arguments.
%
%      ANALYSIS_VEMAP('Property','Value',...) creates a new ANALYSIS_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Analysis_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Analysis_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/21/16    Added pb_calculate. Updated choose classes function to
%                   work with the new structure format. Now checks if
%                   parameters are missing or not. If they are, then
%                   calculates missing parameters for the mode chosen.
% 1.2   03/23/16    Added option to invert data sets when combining data.
% 1.3   03/29/16    Fixed bug from inverting the data set
% 1.4   04/15/16    Updated phase plot/response amp functions. Takes
%                   absolute values instead of actual values. Update MSR
%                   function.
% 1.5   05/05/16    Class lb resets every time a new movement has been
%                   chosen. Now it won't disappear because the selection
%                   value is not in the new chosen movement.
% 1.6   05/13/16    Modified response amplitude remeasuring algorithm to
%                   use the position plot instead of the phase plot
% 1.7   06/15/16    Modified the averages to use nanmean/nanstd instead of
%                   mean/std
% 1.8   08/17/16    Modified the remeasure peak velocity to look at the
%                   position trace instead of the velocity trace
% 1.9   09/30/16    Allowed user to switch between velocity/pos trace when
%                   remeasuring for peak velocity
% 1.10  11/2/2016   Changed the PathName.
% 1.11  11/4/2016   Added the smoothing filter
% 1.11.1    11/7/2016   Fixed some bugs with the smoothing filter...
% 1.12  12/7/2017   Fixed bugs having to do with bad data while entering it
%                   in the table or plotting
% 1.13  01/17/2018  Fixed all the inputs to the plot_this function; fixed
%                   the cellselection bug where it kept going to handle.num
%                   = 1 whenever you do a remove function or remeasure 
%                   function...instead it 'remembers' the last handle.num 
%                   and uses that if it can't find a cellselection index
%                   because it usually blanks out the selection whenever
%                   you do one of those functions
% 1.14  02/08/2018  Added reclassify function. Also created the
%                   update_the_things funnction because calling the block 
%                   everytime is pretty much a hassle. TODO: in the future,
%                   try to implement the update_the_things function to
%                   clean up the code a bit.
% 1.15  03/12/2018  Fixed bug where plot did not update properly with a
%                   remeasure of the peak velocity

% Edit the above text to modify the response to help Analysis_VEMAP

% Last Modified by GUIDE v2.5 08-Feb-2018 21:13:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Analysis_VEMAP_OpeningFcn, ...
    'gui_OutputFcn',  @Analysis_VEMAP_OutputFcn, ...
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


% --- Executes just before Analysis_VEMAP is made visible.
function Analysis_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Analysis_VEMAP (see VARARGIN)

% load settings
load('Programs\Settings\table_settings.mat')
handles.table_settings = table_settings;
% HT 2/8/18 added for reclassification function
load('Programs\Settings\classify_settings') 
handles.classify_settings = classify_settings;


set(handles.uitable1,'columnname',['Seq #' handles.table_settings.table_params_str])
set(handles.uitable3,'columnname',[handles.table_settings.table_params_str])
% initialize variables
handles.plottype = 1;
handles.plot_axes = [];
% Choose default command line output for Analysis_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Analysis_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Analysis_VEMAP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% load data set
[handles.FileName,handles.PathName] = uigetfile('*.mat*','Select the data file to analyze',('Data\Processed'));

if handles.FileName == 0
    return
end

load([handles.PathName handles.FileName]);

set(handles.text_filename,'String',handles.FileName)

% calculate all the things

a = fieldnames(data);
b = fieldnames(data.(a{1}));

handles.eye_movements = eye_movements;
handles.data = data;



% populate sections
a = fieldnames(data);
set(handles.pop_section,'value',1);
set(handles.pop_section,'string',a);

% populate movements
b = fieldnames(data.(a{1}));
set(handles.pop_movement,'value',1);
set(handles.pop_movement,'string',b);

guidata(hObject, handles)


% --- Executes on selection change in pop_section.
function pop_section_Callback(hObject, eventdata, handles)
% hObject    handle to pop_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(handles.pop_section,'value');
str = get(handles.pop_section,'string');

section = str{val};

% set pop_movement list
a = fieldnames(handles.data.(section));
set(handles.pop_movement,'value',1);
set(handles.pop_movement,'string',a);


% Hints: contents = cellstr(get(hObject,'String')) returns pop_section contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_section


% --- Executes during object creation, after setting all properties.
function pop_section_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_section (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in pb_choose.
function pb_choose_Callback(hObject, eventdata, handles)
% hObject    handle to pb_choose (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.list_classifications,'value',[]);


section_str = get(handles.pop_section,'string');
section_val = get(handles.pop_section,'value');
handles.curr_section = section_str{section_val};
section = handles.curr_section;
set(handles.text_currsection,'string',section)

move_str = get(handles.pop_movement,'string');
move_val = get(handles.pop_movement,'value');
handles.curr_movement = move_str{move_val};
movement = handles.curr_movement;
set(handles.text_currmove,'string',movement)

switch get(handles.pop_movementmode,'value')
    case 1
        handles.mode = 'vergence_horz';
    case 2
        handles.mode = 'version_horz';
    case 3
        handles.mode = 'vergence_vert';
    case 4
        handles.mode = 'version_vert';
end

val = get(handles.pop_movementmode,'value');
str = get(handles.pop_movementmode,'string');
a = str{val};

set(handles.text_mode,'string',a)

%% make table of data
handles.data_table = []; % clear table of previous values
handles.averages = [];
data = handles.data;
eye_movements = handles.eye_movements;
mode = get(handles.pop_movementmode,'value');

% disp(data.(section).(movement)(1).(handles.mode))

output = check_and_calculate(data,eye_movements,movement,section,mode);

% disp(output.(section).(movement)(1).(handles.mode))

handles.data = output;
handles.tmp = handles.data.(section).(movement);
handles.tmp1 = handles.eye_movements.(section).(movement);

for i = 1:length(handles.tmp)
    handles.data_table(i,1) = handles.tmp(i).num_seq;
    for j = 1:length(handles.table_settings.table_params);
        %         disp(handles.tmp(i).(handles.mode)...
        %             .(handles.table_settings.table_params{j}))
        try
            handles.data_table(i,j+1) = handles.tmp(i).(handles.mode)...
                .(handles.table_settings.table_params{j});
        catch
            handles.data_table(i,j+1) = 0;
        end
    end
end

a = size(handles.data_table);

%
handles.ind = 1:length(handles.tmp1); % data index
handles.num = 1;
set(handles.text_seqnum,'string',num2str(handles.data_table(handles.num,1)))

update_the_things(hObject, handles)




% --- Executes on selection change in list_classifications.
function list_classifications_Callback(hObject, eventdata, handles)
% hObject    handle to list_classifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns list_classifications contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_classifications


% --- Executes during object creation, after setting all properties.
function list_classifications_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_classifications (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in pop_plottype.
function pop_plottype_Callback(hObject, eventdata, handles)
% hObject    handle to pop_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plottype = get(hObject,'value');

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,handles.plottype,handles.parameters,handles.ind,handles.plot_axes);

guidata(hObject,handles)
% Hints: contents = cellstr(get(hObject,'String')) returns pop_plottype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_plottype


% --- Executes during object creation, after setting all properties.
function pop_plottype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_chooseclasses.
function pb_chooseclasses_Callback(hObject, eventdata, handles)
% hObject    handle to pb_chooseclasses (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



try % if a change of classes is done.
classes_str = get(handles.list_classifications,'string');
classes_val = get(handles.list_classifications,'value');
handles.curr_class = classes_str{classes_val};
% this is the probably the worst way to do this... but it works, i guess
if isempty(classes_str) == 0
    handles.data_table = [];
    handles.averages = [];
    handles.ind = [];
    handles.num = 1;
    c = [];
    for i = 1:length(classes_val) % cycles between the chosen classes
        for j = 1:length(handles.tmp) % length of the data structure
            %             disp(j)
            % see the classes inside each data structure
            a = intersect(handles.tmp(j).classifications,...
                classes_str{classes_val(i)}); %determines if chosen class is in classification
            if isempty(a) == 0
                c = [c j];
            end
        end
    end
    
    handles.ind = unique(c);
    %     disp(handles.ind)
    
    % re-do table with in index
    for i = 1:length(handles.ind)
        handles.data_table(i,1) = handles.tmp(handles.ind(i)).num_seq;
        for j = 1:length(handles.table_settings.table_params);
            a = handles.tmp(handles.ind(i)).(handles.mode)...
                .(handles.table_settings.table_params{j});
            try % HT fix for plot data not good error 12/4/17
                handles.data_table(i,j+1) = handles.tmp(handles.ind(i)).(handles.mode)...
                    .(handles.table_settings.table_params{j});
            catch
                handles.data_table(i,j+1) = NaN;
            end
        end
    end
end
catch
end
    
%update tmp structure
handles.tmp = handles.data.(handles.curr_section).(handles.curr_movement);

update_the_things(hObject, handles);






% --- Executes on button press in pb_combinemovements.
function pb_combinemovements_Callback(hObject, eventdata, handles)
% hObject    handle to pb_combinemovements (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str = get(handles.pop_section,'string');
val = get(handles.pop_section,'value');

section = str{val};

str = fieldnames(handles.data.(section)); % get the movements

[s,~] = listdlg('promptstring','Combine which movements? (must be at least two)',...
    'liststring',str);
% disp(s)
if length(s) < 2
    
    return
end

data_data = handles.data.(section).(str{s(1)}); % initialized
eye_data = handles.eye_movements.(section).(str{s(1)}); % eye_movements initialized
eye_movements = handles.eye_movements;
data = handles.data;
% make a new property that lists the original movement
for i = 1:length(data_data)
    data_data(i).original_movement = str{s(1)};
end

% see if new_data needs to be inverted...
input = menu(['Does this data (' (str{s(1)}) ') need to be inverted?'],'Yes','No');

if input == 1
    for i = 1:length(data_data) % figure out what needs to be inverted
        
        eye_movements.(section).(str{s(1)}){i}(1,:) = ...
            -eye_movements.(section).(str{s(1)}){i}(1,:);
        eye_movements.(section).(str{s(1)}){i}(2,:) = ...
            -eye_movements.(section).(str{s(1)}){i}(2,:);
        
    end
    
    eye_data = eye_movements.(section).(str{s(1)});
    
end

for j = 2:length(s)
    
    new_data = handles.data.(section).(str{s(j)});
    
    % see if new_data needs to be inverted...
    input = menu(['Does this data (' (str{s(j)}) ') need to be inverted?'],'Yes','No');
    
    if input == 1
        for i = 1:length(new_data) % figure out what needs to be inverted
            
            eye_movements.(section).(str{s(j)}){i}(1,:) = ...
                -eye_movements.(section).(str{s(j)}){i}(1,:);
            eye_movements.(section).(str{s(j)}){i}(2,:) = ...
                -eye_movements.(section).(str{s(j)}){i}(2,:);
            
        end
        
        
    end
    
    % if the mean of something something is negative, then flip the whole data set
    
    for i = 1:length(new_data)
        new_data(i).original_movement = str{s(j)};
    end
    
    data_data = [data_data new_data];
    eye_data = [eye_data eye_movements.(section).(str{s(j)})];
    
end


% sort it by sequence number...
[data_data2, index] = nestedSortStruct(data_data,'num_seq');
eye_data2 = eye_data(index); %new indexed eye_movement data...

% put move_data in correct thing
new_movename = inputdlg('What would you like to name the new movement?');

% disp(new_movename)

handles.data.(section).(new_movename{1}) = data_data2;
handles.eye_movements.(section).(new_movename{1}) = eye_data2;

% delete existing data
field = {'vergence_horz' 'version_horz' 'vergence_vert' 'version_vert'};
for i = 1:4
    handles.data.(section).(new_movename{1}) = ...
        rmfield(handles.data.(section).(new_movename{1}),field{i});
end
% re-do the calculations
handles.data = check_and_calculate(handles.data,handles.eye_movements,...
    new_movename{1},section,1);

% update movement pop menu
a = fieldnames(handles.data.(section));
set(handles.pop_movement,'string',a);

guidata(hObject,handles)

% --- Executes on button press in pb_remeasure.
function pb_remeasure_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input = menu('What would you like to remeasure?','Latency',...
    'Settling Time','Peak Velocity','Final Amplitude',...
    'Response Amplitude','Cancel');
figure
if input == 1 % Latency
    parameters.tsettle = nan;
    parameters.tpeak = nan;
    parameters.tlatency = handles.parameters.tlatency;
    plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,1,...
        parameters,handles.ind,handles.plot_axes);
    title('Choose new latency value')
    [x,~] = ginput(1); % choose new value
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).latency = x;
    handles.tmp(handles.ind(handles.num)).(handles.mode).latency = x;
    handles.data_table(handles.num,handles.table_settings.index.latency) = x;
    handles.parameters.tlatency = x;
    
    
elseif input == 2 % Settling Time
    parameters.tsettle = handles.parameters.tsettle;
    parameters.tpeak = nan;
    parameters.tlatency = nan;
    plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,1,...
        parameters,handles.ind,handles.plot_axes);
    title('Choose new settling time value')
    [x,~] = ginput(1); % choose new value
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).tsettle = x;
    handles.tmp(handles.ind(handles.num)).(handles.mode).testtle = x;
    handles.parameters.tsettle = x;
    handles.data_table(handles.num,handles.table_settings.index.tsettle) = x;
    
    
elseif input == 3 % peak velocity
    parameters.tsettle = nan;
    parameters.tpeak = handles.parameters.tpeak;
    parameters.tlatency = nan;
    [~,vel_data] = plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,handles.plottype,...
        parameters,handles.ind,handles.plot_axes);
    n=50; % range of values to determine peak
    title('Choose new peak velocity value')
    [x,~] = ginput(1); % choose new value
    ind = ceil(x*500);
    range = ind-n:ind+n;
    [y,I] = max(abs(vel_data(range)));
    tpeak = (I+ind-n)/500;
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).tpeak = tpeak;
    handles.parameters.tpeak = tpeak;
    handles.data_table(handles.num,handles.table_settings.index.tpeak) = tpeak;
    
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).vpeak = y;
    handles.data_table(handles.num,handles.table_settings.index.vpeak) = y;
    
    
    %update main seq ratio
    msr = ...
        handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).vpeak/...
        handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).response_amp;
    
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).main_seq_ratio = msr;
    
    handles.data_table(handles.num,handles.table_settings.index.main_seq_ratio) = msr;
    
elseif input == 4 % final amplitude
    parameters.tsettle = nan;
    parameters.tpeak = nan;
    parameters.tlatency = nan;
    [pos_data] = plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,1,...
        parameters,handles.ind,handles.plot_axes);
    hold on;
    T = length(pos_data)/500;
    plot([0 T],[handles.parameters.final_amp handles.parameters.final_amp],'k')
    title('Choose new range of final amplitude:')
    [x,~] = ginput(2); % choose new value
    final_amp = mean(transpose(pos_data(ceil(x(1)*500):ceil(x(2)*500))));
    %     disp(final_amp)
    %     disp(pos_data)
    %     disp(x)
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).final_amp = final_amp;
    handles.data_table(handles.num,handles.table_settings.index.final_amp) = final_amp;
    handles.parameters.final_amp = final_amp;
    
elseif input == 5 % response amplitude
    parameters = handles.parameters;
    [pos_data] = plot_this(handles.tmp1,handles.ind(handles.num),...
        handles.mode,1,parameters,handles.ind,handles.plot_axes);
    title('Choose new range of response amplitude:')
    [x,~] = ginput(2);
    %     disp(x)
    %find the indices of the two points
    i1 = ceil(x(1)*500);
    i2 = ceil(x(2)*500);
    index = i1:i2;
    %     disp(handles.tmp1(handles.ind(handles.num)))
    response_amp = response(handles.tmp1{handles.ind(handles.num)},...
        get(handles.pop_movementmode,'value'),index);
    %     disp(response_amp)
    
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).response_amp = response_amp;
    handles.data_table(handles.num,handles.table_settings.index.response_amp) = response_amp;
    handles.parameters.response_amp = response_amp;
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).response_amp_index = index;
    handles.parameters.response_amp_index = index;
    
    %update main seq ratio
    msr = ...
        handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).vpeak/...
        handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).response_amp;
    
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).(handles.mode).main_seq_ratio = msr;
    
    handles.data_table(handles.num,handles.table_settings.index.main_seq_ratio) = msr;
    
end
close

update_the_things(hObject, handles)

% --- Executes on button press in pb_remove.
function pb_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pb_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data_table(handles.num,:) = [];
handles.ind(handles.num) = [];

if handles.num > length(handles.ind)
    handles.num = handles.num - 1;
end

update_the_things(hObject, handles)



% --- Executes on selection change in pop_movementmode.
function pop_movementmode_Callback(hObject, eventdata, handles)
% hObject    handle to pop_movementmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_movementmode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_movementmode


% --- Executes during object creation, after setting all properties.
function pop_movementmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_movementmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pb_previous.
function pb_previous_Callback(hObject, eventdata, handles)
% hObject    handle to pb_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pb_previous.

handles.num = handles.num - 1;
if handles.num < 1
    handles.num = length(handles.ind);
end

% update parameters
handles.parameters.tlatency = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).latency;
handles.parameters.tpeak = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tpeak;
handles.parameters.tsettle = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tsettle;
handles.parameters.final_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).final_amp;
handles.parameters.response_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp;
set(handles.text_seqnum,'string',num2str(handles.data_table(handles.num,1)))
handles.parameters.response_amp_index = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp_index;

s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(s,'smooth_val')
    smooth_val = s.smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);

guidata(hObject,handles)

% --- Executes on button press in pb_next.
function pb_next_Callback(hObject, eventdata, handles)
% hObject    handle to pb_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.num = handles.num + 1;
if handles.num > length(handles.ind)
    handles.num = 1;
end

% update parameters
handles.parameters.tlatency = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).latency;
handles.parameters.tpeak = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tpeak;
handles.parameters.tsettle = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tsettle;
handles.parameters.final_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).final_amp;
handles.parameters.response_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp;
handles.parameters.response_amp_index = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp_index;


set(handles.text_seqnum,'string',num2str(handles.data_table(handles.num,1)))

s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(s,'smooth_val')
    smooth_val = s.smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);

guidata(hObject,handles)

% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data = handles.data;
eye_movements = handles.eye_movements;

save([handles.PathName handles.FileName],'data','eye_movements')

uiwait(msgbox('Data has been saved!!!','Save Complete','modal'));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%PLOTTING FUNCTIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pos_data,vel_data] = plot_this(data,num,mode,plottype,parameters,index,plot_axes,smooth_val)
% plotting function
% parameters(1) latency (position)
% parameters(2) tpeak (velocity)
% parameters(3) settle (position)
% parameters(4) vpeak (velocity)

if isempty(parameters.tpeak)% HT fix for plot parameters being empty 12/4/17
    parameters.tpeak = NaN;
end

%if isempty(parameters.vpeak)% HT fix for plot parameters being empty 12/7/17
%    parameters.tpeak = NaN;
%end


if nargin < 8
    smooth_val = 1;
end

if isempty(smooth_val)
    smooth_val = 1;
end

cla %clears the graph data
hold on

switch mode
    case 'vergence_horz' % horz_verg
        tmp = data{num}(1,:)+data{num}(2,:);
        tmp = tmp - mean(tmp(1:50));
        pos_data = EOMfilters(transpose(tmp),20);
        pos_data = smooth(pos_data,smooth_val);
    case 'version_horz' % horz_vers
        tmp = (data{num}(2,:)-data{num}(1,:))/2;
        tmp = tmp - mean(tmp(1:50));
        pos_data = EOMfilters(transpose(tmp),40);
        pos_data = smooth(pos_data,smooth_val);
    case 'vergence_vert' % vert_verg
        tmp = data{num}(4,:)-data{num}(3,:);
        tmp = tmp - mean(tmp(1:50));
        pos_data = EOMfilters(transpose(tmp),20);
        pos_data = smooth(pos_data,smooth_val);
    case 'version_vert' % vert_vers
        tmp = (data{num}(4,:)+data{num}(3,:))/2;
        tmp = tmp - mean(tmp(1:50));
        pos_data = EOMfilters(transpose(tmp),40);
        pos_data = smooth(pos_data,smooth_val);
end

% disp(pos_data)

T = length(pos_data)/500;
t = 0.002:0.002:T;

if plottype == 1 % position
    plot(t,pos_data,'linewidth',2)
    vel_data = PositionToVelocity(pos_data);
    %     disp((parameters(1)*500))
    plot([parameters.tlatency parameters.tlatency],[-10000 10000],'--g','markersize',15,'linewidth',2)
    plot([parameters.tpeak parameters.tpeak],[-10000 10000],'--y','markersize',15,'linewidth',2)
    plot([parameters.tsettle parameters.tsettle],[-10000 10000],'--r','markersize',15,'linewidth',2)
    plot([0 T],[0 0],'-.k')
    % plot values
    axis([0 T (-1.5)*ceil(max(abs(pos_data))) (1.5)*ceil(max(abs(pos_data)))])
    xlabel('Time (s)')
    ylabel('Position (deg)')
    %     title('Position Plot')
    legend('Position','Latency','Peak Velocity','Settling Time','location','northeast')
elseif plottype == 2 % velocity
    vel_data = PositionToVelocity(pos_data);
    plot(t,vel_data,'linewidth',2)
    plot([parameters.tpeak parameters.tpeak],[-10000 10000],'--r','markersize',15,'linewidth',2)
    plot([0 T],[0 0],'-.k')
    % plot values
    axis([0 T (-1.5)*ceil(max(abs(vel_data))) (1.5)*ceil(max(abs(vel_data)))])
    xlabel('Time (s)')
    ylabel('Velocity (deg)')
    %     title('Velocity Plot')
    legend('Velocity','Peak Velocity','location','northwest')
elseif plottype == 3 % ensemble position
    cla reset
    hold on
    %     disp(length(pos_data))
    switch mode % getting the ens. position data...
        case 'vergence_horz' % horz_verg
            for i = 1:length(data)
                tmp = data{i}(1,:)+data{i}(2,:);
                tmp = tmp - mean(tmp(1:50));
                ens_pos_data(i,:) = EOMfilters(transpose(tmp),20);
            end
        case 'version_horz' % horz_vers
            for i = 1:length(data)
                tmp = (data{i}(2,:)-data{i}(1,:))/2;
                tmp = tmp - mean(tmp(1:50));
                ens_pos_data(i,:) = EOMfilters(transpose(tmp),40);
            end
        case 'vergence_vert' % vert_verg
            for i = 1:length(data)
                tmp = data{i}(4,:)-data{i}(3,:);
                tmp = tmp - mean(tmp(1:50));
                ens_pos_data(i,:) = EOMfilters(transpose(tmp),20);
            end
        case 'version_vert' % vert_vers
            for i = 1:length(data)
                tmp = (data{i}(4,:)+data{i}(3,:))/2;
                tmp = tmp - mean(tmp(1:50));
                ens_pos_data(i,:) = EOMfilters(transpose(tmp),40);
            end
    end
    
    updated_ens_pos_data = ens_pos_data(index,:);
    a = size(updated_ens_pos_data);
    for i = 1:a(1)
        plot(t,updated_ens_pos_data(i,:),'color',[.5 .5 .5])
    end
    
    for i = 1:a(2)
        mean_pos_data(i) = mean(ens_pos_data(:,i));
    end
    
    plot(t,pos_data(:),'g','linewidth',2)
    
    axis([0 T (-1.5)*ceil(max(abs(mean_pos_data))) (1.5)*ceil(max(abs(mean_pos_data)))])
    xlabel('Time (s)')
    ylabel('Position (deg)')
    %     title('Position Plot')
    %     legend('Position','Latency','Peak Velocity','Settling Time','location','northwest')
elseif plottype == 4 % phase plot
    cla reset
    hold on
    pos_data = abs(pos_data);
    vel_data = abs(PositionToVelocity(pos_data));
    index = parameters.response_amp_index;
    x = (pos_data(index));
    y = (vel_data(index));
    p = polyfit(x,y',2);
    f = polyval(p,x);
    plot((pos_data),(vel_data),'k','linewidth',1)
    plot((x),(f),'r','linewidth',2)
    plot((parameters.response_amp),0,'r*','markersize',20,'linewidth',2)
    xlabel('Position (deg)')
    ylabel('Velocity (deg/s)')
end

if isempty(plot_axes) == 0
    axis([0 T plot_axes])
end


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% switch eventdata.Key
%     case 'rightarrow'
%         pb_next_Callback(hObject,eventdata,handles);
%     case 'leftarrow'
%         pb_previous_Callback(hObject,eventdata,handles);
% end


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% this is what happens when you click on the table. plot will change
% depending on which row you are on

try % HT fix for the cell selection bugging out 12/7/17
    % if the Indices variable is empty, which happens when the table
    % clears itself, make the row_ind equal to what it was
    row_ind = eventdata.Indices(1);
catch
    % row_ind = 1; % this bugged the system out...
    row_ind = handles.num; % fix 1/17/18
end
    handles.num = row_ind;
    
    % update parameters
    handles.parameters.tlatency = handles.tmp(handles.ind(handles.num))...
        .(handles.mode).latency;
    handles.parameters.tpeak = handles.tmp(handles.ind(handles.num))...
        .(handles.mode).tpeak;
    handles.parameters.tsettle = handles.tmp(handles.ind(handles.num))...
        .(handles.mode).tsettle;
    handles.parameters.final_amp = handles.tmp(handles.ind(handles.num))...
        .(handles.mode).final_amp;
    handles.parameters.response_amp = handles.tmp(handles.ind(handles.num))...
        .(handles.mode).response_amp;
    handles.parameters.response_amp_index = handles.tmp(handles.ind(handles.num))...
        .(handles.mode).response_amp_index;
    
    set(handles.text_seqnum,'string',num2str(handles.data_table(handles.num,1)))
    
    s =  handles.data.(handles.curr_section).(handles.curr_movement);
    
    if isfield(s,'smooth_val')
        smooth_val = s(handles.ind(handles.num)).smooth_val;
        if isempty(smooth_val)
            smooth_val = 1;
        end
        set(handles.slider_smooth,'value',smooth_val);
        set(handles.text29,'string',num2str(ceil(smooth_val)));
    else
        set(handles.slider_smooth,'value',1);
        set(handles.text29,'string','1');
        smooth_val = 1;
    end
    
    % re-plot data
    
    axes(handles.axes1)
    
    plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
        handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
        ,smooth_val);
    guidata(hObject,handles)


% --- Executes on button press in pb_createfigure.
function pb_createfigure_Callback(hObject, eventdata, handles)
% hObject    handle to pb_createfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% creates a figure of the plot
ax = handles.axes1;
fig = figure;
aux = get(ax,'children');
s = gca;
for j = 0:size(aux)-1
    fig = aux(end-j);
    copyobj(fig,s)
    hold on
end

xlab=get(get(ax,'xlabel'),'string');
ylab=get(get(ax,'ylabel'),'string');
tit=get(get(ax,'title'),'string');

x_limit = get(ax,'XLim');
y_limit = get(ax,'YLim');
% disp(y_limit)
xlabel(xlab);ylabel(ylab);title(tit);xlim(x_limit);ylim(y_limit);



% --- Executes on button press in cb_manual.
function cb_manual_Callback(hObject, eventdata, handles)
% hObject    handle to cb_manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% when calling this function, this rescales the plot to the min/maxes that
% are indicated under scale
% if this function is not turned on, it will just autoscale the plot
if get(hObject,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min_y,'string'));
    max = str2num(get(handles.edit_max_y,'string'));
    handles.plot_axes = [min max];
end
s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(s,'smooth_val')
    smooth_val = s(handles.ind(handles.num)).smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);

guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of cb_manual



function edit_min_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cb_manual,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min_y,'string'));
    max = str2num(get(handles.edit_max_y,'string'));
    handles.plot_axes = [min max];
end
s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(s,'smooth_val')
    smooth_val = s(handles.ind(handles.num)).smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);

guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_min_y as text
%        str2double(get(hObject,'String')) returns contents of edit_min_y as a double


% --- Executes during object creation, after setting all properties.
function edit_min_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_y_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cb_manual,'Value') == 0
    handles.plot_axes = [];
else
    min = str2num(get(handles.edit_min_y,'string'));
    max = str2num(get(handles.edit_max_y,'string'));
    handles.plot_axes = [min max];
end
s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(s,'smooth_val')
    smooth_val = s(handles.ind(handles.num)).smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of edit_max_y as text
%        str2double(get(hObject,'String')) returns contents of edit_max_y as a double


% --- Executes during object creation, after setting all properties.
function edit_max_y_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_y (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_tablesettings.
function pb_tablesettings_Callback(hObject, eventdata, handles)
% hObject    handle to pb_tablesettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
table_settings_VEMAP;



% --- Executes on button press in pb_updatetablesettings.
function pb_updatetablesettings_Callback(hObject, eventdata, handles)
% hObject    handle to pb_updatetablesettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Programs\Settings\table_settings.mat')
handles.table_settings = table_settings;
set(handles.uitable1,'columnname',['Seq #' handles.table_settings.table_params_str])
set(handles.uitable3,'columnname',[handles.table_settings.table_params_str])
handles.tmp = handles.data.(handles.curr_section).(handles.curr_movement);
handles.tmp1 = handles.eye_movements.(handles.curr_section).(handles.curr_movement);
%% make table of data
handles.data_table = []; % clear table of previous values
handles.averages = [];
% disp(length(handles.table_settings.table_params))
for i = 1:length(handles.tmp)
    handles.data_table(i,1) = handles.tmp(i).num_seq;
    for j = 1:length(handles.table_settings.table_params);
        handles.data_table(i,j+1) = handles.tmp(i).(handles.mode)...
            .(handles.table_settings.table_params{j});
    end
end

a = size(handles.data_table);
handles.ind = 1:length(handles.tmp1); % data index
handles.num = 1;
% averages
for i = 1:a(2)-1
    handles.averages(1,i) = nanmean(handles.data_table(:,i+1));
    handles.averages(2,i) = nanstd(handles.data_table(:,i+1));
end

% set table
set(handles.uitable1,'data',handles.data_table)
set(handles.uitable3,'data',handles.averages)

% update parameters
handles.parameters.tlatency = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).latency;
handles.parameters.tpeak = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tpeak;
handles.parameters.tsettle = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tsettle;
handles.parameters.final_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).final_amp;
handles.parameters.response_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp;
handles.parameters.response_amp_index = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp_index;

s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(s,'smooth_val')
    smooth_val = s(handles.ind(handles.num)).smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);
guidata(hObject,handles)


% --- Executes on button press in pb_calculate.
function pb_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Calculate_VEMAP;

function output = check_and_calculate(data,eye_movements,movement,section,mode)
% This function takes in data and checks if everything is calculated or
% not. If not, then does the calculation for the missing parameters.
modes = {'vergence_horz' 'version_horz' 'vergence_vert' 'version_vert'};
if isfield(data.(section).(movement),modes{1}) == 0 % creates modes if not there
    for i = 1:length(modes)
        for j = 1:length(data.(section).(movement))
            data.(section).(movement)(j).(modes{i}) = [];
        end
    end
end
params = {'latency' 'tpeak' 'tsettle' 'vpeak' 'response_amp' 'final_amp' ...
    'main_seq_ratio'};
param_str = {'latency' 'tpeak' 'tsettle' 'vpeak' 'response_amp' 'final_amp' ...
    'main_seq_ratio'};
for i = 1:length(params) % checking for parameters
    %     disp(data.(section).(movement)(1).(modes{mode}))
    % disp(isfield(data.(section).(movement)(1).(modes{mode}),(params{i})))
    % disp(data.(section).(movement)(1).(modes{mode}))
    % disp(params{i})
    if isfield(data.(section).(movement)(1).(modes{mode}),params{i}) == 0
        % checks if parameter is a field (i.e. calculated already)
        %         uiwait(msgbox(['Data for ' param_str{i}...
        %             ' have not been found. Will calculate parameter.'],'Warning','modal'));
        for j = 1:length(data.(section).(movement))
            tmp = eye_movements.(section).(movement){j};
            %             disp(params{i})
            
            for mode = 1:4
                switch params{i}
                    
                    case 'latency'
                        data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                            latency(tmp,mode);
                    case 'tpeak'
                        data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                            tpeak(tmp,mode);
                    case 'tsettle'
                        data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                            settlingtime(tmp,mode);
                    case 'vpeak'
                        data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                            vpeak(tmp,mode);
                    case 'response_amp'
                        [data.(section).(movement)(j).(modes{mode}).response_amp,...
                            data.(section).(movement)(j).(modes{mode})...
                            .response_amp_index] = response(tmp,mode,[]);
                    case 'final_amp'
                        data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                            amplitude(tmp,mode);
                    case 'main_seq_ratio'
                        data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                            data.(section).(movement)(j).(modes{mode}).vpeak/...
                            data.(section).(movement)(j).(modes{mode}).response_amp;
                end
            end
        end
        
    end
end

output = data;




function edit_min_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_x as text
%        str2double(get(hObject,'String')) returns contents of edit_min_x as a double


% --- Executes during object creation, after setting all properties.
function edit_min_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_x_Callback(hObject, eventdata, handles)
% hObject    handle to edit_max_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_max_x as text
%        str2double(get(hObject,'String')) returns contents of edit_max_x as a double


% --- Executes during object creation, after setting all properties.
function edit_max_x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_x (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% data = handles.tmp1{handles.num};
%
% mode = get(handles.pop_movementmode,'value');
%
% tc = time_constant(data,mode);
%
% disp(tc)

% disp(handles.tmp.classifications)


% --- Executes on button press in pb_excel.
function pb_excel_Callback(hObject, eventdata, handles)
% hObject    handle to pb_excel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% exporting the data you're currently looking at to an xcel file...

% handles.xcel.filename = filename to append to; most likely the experiment
% handles.xcel.sheetname = sheet to append to; most likely the subject

% handles.data_table = data table
% handles.averages = data summary
%
% disp(handles.data_table)
% disp(handles.averages)

filename = 'KESSLER_GAP.xlsx';
sheet = handles.FileName;
summary_sheet = ['summary_' handles.FileName];
% disp(handles.table_settings.table_params_str)
data = handles.data_table;
summary = handles.averages;

try
    current_file = xlsread(filename,sheet);
    b = size(current_file);
    sheet_range = ['A' num2str(b(1)+2)];
    
    summary_file = xlsread(filename,summary_sheet);
    b = size(summary_file);
    summary_range1 = ['A' num2str(b(1)+4)];
    summary_range2 = ['B' num2str(b(1)+5)];
    summary_range3 = ['A' num2str(b(1)+6)];
    summary_range4 = ['A' num2str(b(1)+7)];
    summary_range5 = ['B' num2str(b(1)+6)];
    summary_range6 = ['B' num2str(b(1)+7)];
    %     disp(sheet_range)
catch
    headers = ['Stimulus Type' 'Direction' 'Return' 'Seq Num' ...
        handles.table_settings.table_params_str 'Classification'];
    xlswrite(filename,headers,sheet,'A1')
    sheet_range = 'A2';
    summary_range1 = 'A1';
    summary_range2 = 'B2';
    summary_range3 = 'A3';
    summary_range4 = 'A4';
    summary_range5 = 'B3';
    summary_range6 = 'B4';
end

% disp(handles.curr_movement)
% disp(data)

stim_type = {handles.curr_movement(5:end)};
direction = {handles.curr_movement(1)};
Return = {handles.curr_movement(3)};

B = num2cell(data);
% disp(B)
for i = 1:length(data)
    %     disp(B(i,:))
    classification = handles.tmp(i).classifications;
    table(i,:) = [stim_type direction Return B(i,:) classification];
    disp(classification)
end

xlswrite(filename,table,sheet,sheet_range); % write data

% Summary

% disp(table)
xlswrite(filename,{[handles.curr_movement ' Summary']}...
    ,summary_sheet,summary_range1); % write summary movement
xlswrite(filename,handles.table_settings.table_params_str...
    ,summary_sheet,summary_range2); % write summary headers
xlswrite(filename,{'Average'},summary_sheet,summary_range3);
xlswrite(filename,summary(1,:),summary_sheet,summary_range5);% write summary averages
xlswrite(filename,{'STDev'},summary_sheet,summary_range4);
xlswrite(filename,summary(2,:),summary_sheet,summary_range6);% write summary averages
uiwait(msgbox('Data has been exported!!!','Export Complete','modal'));


% --- Executes on slider movement.
function slider_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to slider_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.smooth_val = get(handles.slider_smooth,'value');
set(handles.text29,'string',num2str(ceil(smooth_val)));
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pb_smooth.
function pb_smooth_Callback(hObject, eventdata, handles)
% hObject    handle to pb_smooth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the smoothing value from the slider
smooth_val = get(handles.slider_smooth,'value');
section = handles.curr_section;
movement = handles.curr_movement;

j = handles.ind(handles.num);

handles.data.(section).(movement)(j).smooth_val = smooth_val;

modes = {'vergence_horz' 'version_horz' 'vergence_vert' 'version_vert'};
params = {'latency' 'tpeak' 'tsettle' 'vpeak' 'response_amp' 'final_amp' ...
    'main_seq_ratio'};

tmp = handles.eye_movements.(section).(movement){j};
mode = get(handles.pop_movementmode,'value');
% re-do the calculations
for i = 1:length(params)
    
    switch params{i}
        
        case 'latency'
            handles.data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                latency(tmp,mode,smooth_val);
            tlatency = latency(tmp,mode,smooth_val);
        case 'tpeak'
            handles.data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                tpeak(tmp,mode,smooth_val);
            atpeak = tpeak(tmp,mode,smooth_val);
        case 'tsettle'
            handles.data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                settlingtime(tmp,mode);
            tsettle = settlingtime(tmp,mode);
        case 'vpeak'
            handles.data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                vpeak(tmp,mode,smooth_val);
            avpeak = vpeak(tmp,mode,smooth_val);
        case 'response_amp'
            response_index = handles.data.(section).(movement)(j).(modes{mode}).response_amp_index;
            handles.data.(section).(movement)(j).(modes{mode}).response_amp...
                = response(tmp,mode,response_index,smooth_val);
            response_amp = response(tmp,mode,response_index,smooth_val);
            %             case 'final_amp'
            %                 handles.data.(section).(movement)(j).(modes{mode}).(params{i}) =...
            %                     amplitude(tmp,mode);
            %                 final_amp = amplitude(tmp,mode);
        case 'main_seq_ratio'
            handles.data.(section).(movement)(j).(modes{mode}).(params{i}) =...
                handles.data.(section).(movement)(j).(modes{mode}).vpeak/...
                handles.data.(section).(movement)(j).(modes{mode}).response_amp;
            msr = handles.data.(section).(movement)(j).(modes{mode}).(params{i});
    end
    
end

handles.data_table(handles.num,handles.table_settings.index.latency) = tlatency;
handles.parameters.tlatency = tlatency;

handles.parameters.tsettle = tsettle;
handles.data_table(handles.num,handles.table_settings.index.tsettle) = tsettle;

handles.parameters.tpeak = atpeak;
handles.data_table(handles.num,handles.table_settings.index.tpeak) = atpeak;

handles.parameters.vpeak = avpeak;
handles.data_table(handles.num,handles.table_settings.index.vpeak) = avpeak;

% handles.data_table(handles.num,handles.table_settings.index.final_amp) = final_amp;
% handles.parameters.final_amp = final_amp;

handles.data_table(handles.num,handles.table_settings.index.response_amp) = response_amp;
handles.parameters.response_amp = response_amp;

handles.data_table(handles.num,handles.table_settings.index.main_seq_ratio) = msr;


% update table and averages
a = size(handles.data_table);
% averages
for i = 1:a(2)-1
    handles.averages(1,i) = nanmean(handles.data_table(:,i+1));
    handles.averages(2,i) = nanstd(handles.data_table(:,i+1));
end

set(handles.uitable1,'data',handles.data_table)
set(handles.uitable3,'data',handles.averages)

%update tmp structure
handles.tmp = handles.data.(handles.curr_section).(handles.curr_movement);

% re-plot data
axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes,smooth_val);



guidata(hObject, handles)


% --- Executes on button press in pb_reclassify.
% Used to reclassify a movement
% added 2.8.18
function pb_reclassify_Callback(hObject, eventdata, handles)
% hObject    handle to pb_reclassify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% figure out what classifications to use (i.e. saccadic vs. vergence)
mode = get(handles.pop_movementmode,'value');
if mode == 1 || 3 % vergence movements
    classifications = handles.classify_settings.classifications{1};
else
    classifications = handles.classify_settings.classifications{2};
end

% add 'Cancel' to the classifications
classifications{end + 1} = 'Cancel';

% pop-up menu to choose the reclassification (maybe add the current class)
input = menu('What would you like to change the classification to?', classifications);

% change the classification
if input == length(classifications)
    return;
else
    handles.data.(handles.curr_section).(handles.curr_movement)...
        (handles.ind(handles.num)).classifications = classifications(input);
end

%update tmp structure
handles.tmp = handles.data.(handles.curr_section).(handles.curr_movement);

try % if a change of classes is done.
classes_str = get(handles.list_classifications,'string');
classes_val = get(handles.list_classifications,'value');
handles.curr_class = classes_str{classes_val};
% this is the probably the worst way to do this... but it works, i guess
if isempty(classes_str) == 0
    handles.data_table = [];
    handles.averages = [];
    handles.ind = [];
    handles.num = 1;
    c = [];
    for i = 1:length(classes_val) % cycles between the chosen classes
        for j = 1:length(handles.tmp) % length of the data structure
            %             disp(j)
            % see the classes inside each data structure
            a = intersect(handles.tmp(j).classifications,...
                classes_str{classes_val(i)}); %determines if chosen class is in classification
            if isempty(a) == 0
                c = [c j];
            end
        end
    end
    
    handles.ind = unique(c);
    %     disp(handles.ind)
    
    % re-do table with in index
    for i = 1:length(handles.ind)
        handles.data_table(i,1) = handles.tmp(handles.ind(i)).num_seq;
        for j = 1:length(handles.table_settings.table_params);
            a = handles.tmp(handles.ind(i)).(handles.mode)...
                .(handles.table_settings.table_params{j});
            try % HT fix for plot data not good error 12/4/17
                handles.data_table(i,j+1) = handles.tmp(handles.ind(i)).(handles.mode)...
                    .(handles.table_settings.table_params{j});
            catch
                handles.data_table(i,j+1) = NaN;
            end
        end
    end
end
catch
end

update_the_things(hObject, handles)



%Used to update the tables, the data, and the plots... helps to keep the
%code clean and hopefully easier to understand.
% HT 2.8.18
function update_the_things(hObject, handles)



% get classification list
class_list = findclasses(handles.tmp);
set(handles.list_classifications,'string',class_list)

a = size(handles.data_table);

% averages
for i = 1:a(2)-1
    handles.averages(1,i) = nanmean(handles.data_table(:,i+1));
    handles.averages(2,i) = nanstd(handles.data_table(:,i+1));
end

% set table
set(handles.uitable1,'data',handles.data_table)
set(handles.uitable3,'data',handles.averages)

set(handles.text_seqnum,'string',num2str(handles.data_table(handles.num,1)))

% added this so parameters update properly. HT 3/12/2018
handles.tmp =  handles.data.(handles.curr_section).(handles.curr_movement);

% update parameters
handles.parameters.tlatency = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).latency;
handles.parameters.tpeak = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tpeak;
handles.parameters.tsettle = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).tsettle;
handles.parameters.final_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).final_amp;
handles.parameters.response_amp = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp;
handles.parameters.response_amp_index = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).response_amp_index;
handles.parameters.vpeak = handles.tmp(handles.ind(handles.num))...
    .(handles.mode).vpeak;

s =  handles.data.(handles.curr_section).(handles.curr_movement);

if isfield(handles.tmp,'smooth_val')
    smooth_val = s.smooth_val;
    if isempty(smooth_val)
        smooth_val = 1;
    end
    set(handles.slider_smooth,'value',smooth_val);
    set(handles.text29,'string',num2str(ceil(smooth_val)));
else
    set(handles.slider_smooth,'value',1);
    set(handles.text29,'string','1');
    smooth_val = 1;
end

% re-plot data

axes(handles.axes1)
plot_this(handles.tmp1,handles.ind(handles.num),handles.mode,...
    handles.plottype,handles.parameters,handles.ind,handles.plot_axes...
    ,smooth_val);

% save the handles
guidata(hObject, handles)





