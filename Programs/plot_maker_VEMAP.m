function varargout = plot_maker_VEMAP(varargin)
% PLOT_MAKER_VEMAP MATLAB code for plot_maker_VEMAP.fig
%      PLOT_MAKER_VEMAP, by itself, creates a new PLOT_MAKER_VEMAP or raises the existing
%      singleton*.
%
%      H = PLOT_MAKER_VEMAP returns the handle to a new PLOT_MAKER_VEMAP or the handle to
%      the existing singleton*.
%
%      PLOT_MAKER_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLOT_MAKER_VEMAP.M with the given input arguments.
%
%      PLOT_MAKER_VEMAP('Property','Value',...) creates a new PLOT_MAKER_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before plot_maker_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to plot_maker_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/03/16    Changed plot_main to accomodate flipping plots on the 
%                   sample plot
% 1.2   04/29/16    You can now save and load data that you have worked on.
%                   Fixed minor bug with figure function.

% Edit the above text to modify the response to help plot_maker_VEMAP

% Last Modified by GUIDE v2.5 29-Apr-2016 16:22:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @plot_maker_VEMAP_OpeningFcn, ...
    'gui_OutputFcn',  @plot_maker_VEMAP_OutputFcn, ...
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


% --- Executes just before plot_maker_VEMAP is made visible.
function plot_maker_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to plot_maker_VEMAP (see VARARGIN)

% smoothing number
smooth_val = get(handles.sl_smoothing,'value');
set(handles.edit_smoothing,'string',smooth_val);

load('Programs\Settings\plot_maker_settings');

handles.settings = plot_maker_settings;

handles.smoothing = smooth_val;
handles.mode = 1;
handles.movement_num = 'movement1';
handles.plottype = 1;

% Choose default command line output for plot_maker_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes plot_maker_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Executes on button press in pb_load1.
function pb_load1_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% function to load data
[FileName,PathName] = ...
    uigetfile('*.mat','Select the raw data file',('Data\Processed\'),'MultiSelect','off');

if FileName == 0
    return
end

load([PathName FileName])
% disp([PathName FileName])
set(handles.text_data1,'string',FileName);
handles.data1 = data;
handles.eye_movements1 = eye_movements;

% populate lists
handles.section_names1 = fieldnames(handles.data1);
set(handles.pop_section1,'value',1);
set(handles.pop_section1,'String',handles.section_names1);
handles.section1 = handles.section_names1{1};

% disp(handles.section);

handles.movement_names1 = fieldnames(handles.data1.(handles.section_names1{1}));
set(handles.pop_movement1,'value',1);
set(handles.pop_movement1,'String',handles.movement_names1);
handles.movement1 = (handles.movement_names1{1});

% disp(handles.movement)

handles.curr_data1 = handles.data1.(handles.section1).(handles.movement1);

guidata(hObject,handles)

% --- Executes on button press in pb_load2.
function pb_load2_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = ...
    uigetfile('*.mat','Select the raw data file',('Data\Processed\'),'MultiSelect','off');

if FileName == 0
    return
end

load([PathName FileName])
% disp([PathName FileName])
set(handles.text_data2,'string',FileName);
handles.data2 = data;
handles.eye_movements2 = eye_movements;

% populate lists
handles.section_names2 = fieldnames(handles.data2);
set(handles.pop_section2,'value',1);
set(handles.pop_section2,'String',handles.section_names2);
handles.section2 = handles.section_names2{1};

% disp(handles.section);

handles.movement_names2 = fieldnames(handles.data2.(handles.section_names2{1}));
set(handles.pop_movement2,'value',1);
set(handles.pop_movement2,'String',handles.movement_names2);
handles.movement2 = (handles.movement_names2{1});

% disp(handles.movement)

handles.curr_data = handles.data2.(handles.section2).(handles.movement2);% current data

guidata(hObject,handles)


% --- Outputs from this function are returned to the command line.
function varargout = plot_maker_VEMAP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sl_smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to sl_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.smoothing = ceil(get(hObject,'value'));

set(handles.edit_smoothing,'string',handles.smoothing)

% update plots
axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)

guidata(hObject,handles) % update handles structure

% --- Executes during object creation, after setting all properties.
function sl_smoothing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sl_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pb_blinkremover.
function pb_blinkremover_Callback(hObject, eventdata, handles)
% hObject    handle to pb_blinkremover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.curr_data(handles.trial_num,:) = blink_removal(handles.curr_data...
%     (handles.trial_num,:));

axes(handles.plot_secondary)
[x,~] = ginput(2);

if x(2)*500 > length(handles.tmp.(handles.movement_num).v_data)
    x(2) = length(handles.tmp.(handles.movement_num).v_data)/500;
end

handles.tmp.(handles.movement_num).l_data(handles.num,ceil(x(1)*500):ceil(x(2)*500)) = nan;
handles.tmp.(handles.movement_num).r_data(handles.num,ceil(x(1)*500):ceil(x(2)*500)) = nan;
handles.tmp.(handles.movement_num).v_data(handles.num,ceil(x(1)*500):ceil(x(2)*500)) = nan;

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)
set(handles.edit_trial,'string',handles.num)

guidata(hObject, handles)

% --- Executes on button press in pb_trialremover.
function pb_trialremover_Callback(hObject, eventdata, handles)
% hObject    handle to pb_trialremover (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.tmp.(handles.movement_num).l_data(handles.num,:) = [];
handles.tmp.(handles.movement_num).r_data(handles.num,:) = [];
handles.tmp.(handles.movement_num).v_data(handles.num,:) = [];
handles.tmp.(handles.movement_num).seq_num(handles.num) = [];

if handles.num > length(handles.tmp.(handles.movement_num).seq_num)
    handles.num = length(handles.tmp.(handles.movement_num).seq_num);
end

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)

set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))
guidata(hObject, handles)


function edit_trial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial as text
%        str2double(get(hObject,'String')) returns contents of edit_trial as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_next.
function pb_next_Callback(hObject, eventdata, handles)
% hObject    handle to pb_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = size(handles.tmp.(handles.movement_num).v_data);

handles.num = handles.num + 1;

if handles.num > a(1)
    handles.num = 1;
end

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)
set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))

guidata(hObject, handles)

% --- Executes on button press in pb_prev.
function pb_prev_Callback(hObject, eventdata, handles)
% hObject    handle to pb_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = size(handles.tmp.(handles.movement_num).v_data);

handles.num = handles.num - 1;

if handles.num < 1
    handles.num = a(1);
end

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)
set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))

guidata(hObject, handles)


function edit_smoothing_Callback(hObject, eventdata, handles)
% hObject    handle to edit_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_smoothing as text
%        str2double(get(hObject,'String')) returns contents of edit_smoothing as a double


% --- Executes during object creation, after setting all properties.
function edit_smoothing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_smoothing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_figure.
function pb_figure_Callback(hObject, eventdata, handles)
% hObject    handle to pb_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in pb_createfigure.

handles.figname = inputdlg('Name Figure');

if handles.plottype == 3
    data = handles.tmp;
    T = length(data.movement1.v_data)/500;
    t = 0.002:0.002:T;
    % axis variables
    ylim_v = handles.settings.comparison_plot.ylim_v;
    ytick_v = handles.settings.comparison_plot.ytick_v;
    ylim_p = handles.settings.comparison_plot.ylim_p;
    ytick_p = handles.settings.comparison_plot.ytick_p;
    line1_color = 'blue';
    line2_color = 'red';
    
    
    %% get the means
    pos1 = data.movement1.v_data;
    pos2 = data.movement2.v_data;
    
    for i = 1:length(pos1(:,1))
        vel1(i,:) = PositionToVelocity(pos1(i,:));
    end
    
    
    for i = 1:length(pos2(:,1))
        vel2(i,:) = PositionToVelocity(pos2(i,:));
    end
    
    for i = 1:length(vel1)
        velmean1(i) = nanmean(vel1(:,i));
    end
    
    
    for i = 1:length(vel2)
        velmean2(i) = nanmean(vel2(:,i));
    end
    
    
    for i = 1:length(pos1)
        posmean1(i) = nanmean(pos1(:,i));
    end
    
    
    for i = 1:length(pos2)
        posmean2(i) = nanmean(pos2(:,i));
    end
    fig = figure;
    hold on;
    [haxes1, hline1, hline2] = plotyy(t,velmean1,t,posmean1);
    [haxes2, hline3, hline4] = plotyy(t,velmean2,t,posmean2);
    plot([0 T],[0 0],'-.k')
    set(hline2,'Color',line1_color,'LineWidth',1.5)
    set(hline1,'Color',line1_color,'LineStyle','-.','LineWidth',1.5)
    set(hline4,'Color',line2_color,'LineWidth',1.5)
    set(hline3,'Color',line2_color,'LineStyle','-.','LineWidth',1.5)
    ylabel(haxes2(1),'Velocity (degrees/sec)') % label left y-axis
    ylabel(haxes2(2),'Position (degrees)') % label right y-axis
    xlabel(haxes2(1),'Time (s)') % label x-axis
    
    set(haxes1(1),'YColor','black','Ylim',ylim_v,'YTick',ytick_v)
    set(haxes2(1),'YColor','black','Ylim',ylim_v,'YTick',ytick_v)
    set(haxes2(2),'YColor','black','Ylim',ylim_p,'YTick',ytick_p)
    set(haxes1(2),'YColor','black','Ylim',ylim_p,'YTick',ytick_p)
    
elseif handles.plottype == 4

   
    
    movement = handles.movement_num;
    data = handles.tmp;
    settings = handles.settings;
    smoothing = handles.smoothing;
    fig = figure;
    hold on
    tmp = data.(movement).v_data;
    
    T = length(data.(movement).v_data)/500;
    t = 0.002:0.002:T;

    a = size(tmp);

    for i = 1:a(1) % individual plots
        tmp1 = tmp(i,:);
        b = isnan(tmp1);
        tmp2 = (smooth(tmp1,smoothing));
        tmp2(b) = NaN;
        plot(t,tmp2','color',[.6 .6 .6],'linewidth',1);
    end
    
    velocity_smoothing  = 50;
    
    for i = 1:length(tmp(:,1))
        tmp3 = smooth(tmp(i,:),velocity_smoothing); % change smoothing for velocity
        tmp4 = tmp3';
        vel_tmp(i,:) = PositionToVelocity(tmp4(:));
    end
    
    for i = 1:a(2) % getting the means
        mean_tmp(i) = nanmean(tmp(:,i));
        velocity_mean_tmp(i) = nanmean(vel_tmp(:,i));
    end
    
    [haxes1, hline1, hline2] = plotyy(t,mean_tmp,t,velocity_mean_tmp);
    set(hline1,'Color','green','LineWidth',2)
    set(hline2,'Color','red','LineWidth',2)
    
    
    set(haxes1(1),'YColor','black','Ylim',[-5 5],'YTick',[-2 0 2])
    set(haxes1(2),'YColor','black','Ylim',[-100 100],'YTick',[-40 0 40])
    if settings.ensemble_plot.zero_plot == 1
        plot([0 T],[0 0],'-.k')
    end
    
    ylabel(haxes1(2),'Velocity (deg/sec)')
    ylabel(haxes1(1),'Position (deg)')

%     axis([0 T ylim])
    xlabel('Time (s)')        
    
else
    ax = handles.plot_main;
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
end

savefig([handles.figname{1} '.fig'])


% --- Executes on selection change in pop_section1.
function pop_section1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_section1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'value');
str = get(hObject,'string');

section = str{val};

% set pop_movement list
a = fieldnames(handles.data1.(section));
set(handles.pop_movement1,'value',1);
set(handles.pop_movement1,'string',a);
% Hints: contents = cellstr(get(hObject,'String')) returns pop_section1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_section1


% --- Executes during object creation, after setting all properties.
function pop_section1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_section1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_movement1.
function pop_movement1_Callback(hObject, eventdata, handles)
% hObject    handle to pop_movement1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_movement1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_movement1


% --- Executes during object creation, after setting all properties.
function pop_movement1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_movement1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_section2.
function pop_section2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_section2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(hObject,'value');
str = get(hObject,'string');

section = str{val};

% set pop_movement list
a = fieldnames(handles.data2.(section));
set(handles.pop_movement2,'value',1);
set(handles.pop_movement2,'string',a);
% Hints: contents = cellstr(get(hObject,'String')) returns pop_section2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_section2


% --- Executes during object creation, after setting all properties.
function pop_section2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_section2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_movement2.
function pop_movement2_Callback(hObject, eventdata, handles)
% hObject    handle to pop_movement2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_movement2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_movement2


% --- Executes during object creation, after setting all properties.
function pop_movement2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_movement2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in pop_plottype.
function pop_plottype_Callback(hObject, eventdata, handles)
% hObject    handle to pop_plottype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_plottype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_plottype
handles.plottype = get(hObject,'value');

axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)

guidata(hObject,handles)

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


% --- Executes on button press in rb_movement1.
function rb_movement1_Callback(hObject, eventdata, handles)
% hObject    handle to rb_movement1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_movement1
handles.movement_num = 'movement1';
handles.num = 1;
set(hObject,'value',1)
set(handles.rb_movement2,'value',0)

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)
set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))

guidata(hObject,handles)

% --- Executes on button press in rb_movement2.
function rb_movement2_Callback(hObject, eventdata, handles)
% hObject    handle to rb_movement2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb_movement2
handles.movement_num = 'movement2';
handles.num = 1;
set(hObject,'value',1)
set(handles.rb_movement1,'value',0)

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)
set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))

guidata(hObject,handles)

% --- Executes on selection change in pop_mode.
function pop_mode_Callback(hObject, eventdata, handles)
% hObject    handle to pop_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pop_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pop_mode
handles.mode = get(hObject,'value');

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pop_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pop_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pb_movementupdate.
function pb_movementupdate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_movementupdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%
handles.num = 1;

section_val = get(handles.pop_section1,'value');
section_str = get(handles.pop_section1,'string');
a = section_str{section_val};
handles.section = a;

set(handles.text18,'string',a)
move_val = get(handles.pop_movement1,'value');
move_str = get(handles.pop_movement1,'string');
b = move_str{move_val};
handles.movement = b;

set(handles.text22,'string',b)
tmp = handles.eye_movements1.(a).(b);
handles.tmp.movement1 = [];
for i = 1:length(handles.data1.(a).(b))
    handles.tmp.movement1.seq_num(i) = handles.data1.(a).(b)(i).num_seq;
end

for i = 1:length(tmp)
    switch handles.mode
        case 1 %horizontal vergence
            handles.tmp.movement1.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(2,:)),20));
            handles.tmp.movement1.l_data(i,:) = handles.tmp.movement1.l_data(i,:) - mean(handles.tmp.movement1.l_data(i,1:50));
            handles.tmp.movement1.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(1,:)),20));
            handles.tmp.movement1.r_data(i,:) = handles.tmp.movement1.r_data(i,:) - mean(handles.tmp.movement1.r_data(i,1:50));
            handles.tmp.movement1.v_data(i,:) = handles.tmp.movement1.l_data(i,:) + handles.tmp.movement1.r_data(i,:);
        case 2 %horizontal version
            handles.tmp.movement1.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(2,:)),40));
            handles.tmp.movement1.l_data(i,:) = handles.tmp.movement1.l_data(i,:) - mean(handles.tmp.movement1.l_data(i,1:50));
            handles.tmp.movement1.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(1,:)),40));
            handles.tmp.movement1.r_data(i,:) = handles.tmp.movement1.r_data(i,:) - mean(handles.tmp.movement1.r_data(i,1:50));
            handles.tmp.movement1.v_data(i,:) = (handles.tmp.movement1.l_data(i,:) - handles.tmp.movement1.r_data(i,:))/2;
        case 3 %vertical vergence
            handles.tmp.movement1.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(4,:)),20));
            handles.tmp.movement1.l_data(i,:) = handles.tmp.movement1.l_data(i,:) - mean(handles.tmp.movement1.l_data(i,1:50));
            handles.tmp.movement1.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(3,:)),20));
            handles.tmp.movement1.r_data(i,:) = handles.tmp.movement1.r_data(i,:) - mean(handles.tmp.movement1.r_data(i,1:50));
            handles.tmp.movement1.v_data(i,:) = handles.tmp.movement1.l_data(i,:) + handles.tmp.movement1.r_data(i,:);
        case 4 %vertical version
            handles.tmp.movement1.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(4,:)),40));
            handles.tmp.movement1.l_data(i,:) = handles.tmp.movement1.l_data(i,:) - mean(handles.tmp.movement1.l_data(i,1:50));
            handles.tmp.movement1.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(3,:)),40));
            handles.tmp.movement1.r_data(i,:) = handles.tmp.movement1.r_data(i,:) - mean(handles.tmp.movement1.r_data(i,1:50));
            handles.tmp.movement1.v_data(i,:) = (handles.tmp.movement1.l_data(i,:) - handles.tmp.movement1.r_data(i,:))/2;
    end
end

handles.tmp.movement1.section = a;
handles.tmp.movement1.movement = b;

section_val = get(handles.pop_section2,'value');
section_str = get(handles.pop_section2,'string');
a = section_str{section_val};
handles.section = a;
set(handles.text21,'string',a)
move_val = get(handles.pop_movement2,'value');
move_str = get(handles.pop_movement2,'string');
b = move_str{move_val};
handles.movement = b;
set(handles.text23,'string',b)
tmp = handles.eye_movements2.(a).(b);

handles.tmp.movement2 = [];
for i = 1:length(handles.data2.(a).(b))
    handles.tmp.movement2.seq_num(i) = handles.data2.(a).(b)(i).num_seq;
end

for i = 1:length(tmp)
    switch handles.mode
        case 1 %horizontal vergence
            handles.tmp.movement2.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(2,:)),20));
            handles.tmp.movement2.l_data(i,:) = handles.tmp.movement2.l_data(i,:) - mean(handles.tmp.movement2.l_data(i,1:50));
            handles.tmp.movement2.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(1,:)),20));
            handles.tmp.movement2.r_data(i,:) = handles.tmp.movement2.r_data(i,:) - mean(handles.tmp.movement2.r_data(i,1:50));
            handles.tmp.movement2.v_data(i,:) = handles.tmp.movement2.l_data(i,:) + handles.tmp.movement2.r_data(i,:);
        case 2 %horizontal version
            handles.tmp.movement2.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(2,:)),40));
            handles.tmp.movement2.l_data(i,:) = handles.tmp.movement2.l_data(i,:) - mean(handles.tmp.movement2.l_data(i,1:50));
            handles.tmp.movement2.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(1,:)),40));
            handles.tmp.movement2.r_data(i,:) = handles.tmp.movement2.r_data(i,:) - mean(handles.tmp.movement2.r_data(i,1:50));
            handles.tmp.movement2.v_data(i,:) = (handles.tmp.movement2.l_data(i,:) - handles.tmp.movement2.r_data(i,:))/2;
        case 3 %vertical vergence
            handles.tmp.movement2.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(4,:)),20));
            handles.tmp.movement2.l_data(i,:) = handles.tmp.movement2.l_data(i,:) - mean(handles.tmp.movement2.l_data(i,1:50));
            handles.tmp.movement2.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(3,:)),20));
            handles.tmp.movement2.r_data(i,:) = handles.tmp.movement2.r_data(i,:) - mean(handles.tmp.movement2.r_data(i,1:50));
            handles.tmp.movement2.v_data(i,:) = handles.tmp.movement2.l_data(i,:) + handles.tmp.movement2.r_data(i,:);
        case 4 %vertical version
            handles.tmp.movement2.l_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(4,:)),40));
            handles.tmp.movement2.l_data(i,:) = handles.tmp.movement2.l_data(i,:) - mean(handles.tmp.movement2.l_data(i,1:50));
            handles.tmp.movement2.r_data(i,:) = transpose(EOMfilters(transpose(tmp{i}(3,:)),40));
            handles.tmp.movement2.r_data(i,:) = handles.tmp.movement2.r_data(i,:) - mean(handles.tmp.movement2.r_data(i,1:50));
            handles.tmp.movement2.v_data(i,:) = (handles.tmp.movement2.l_data(i,:) - handles.tmp.movement2.r_data(i,:))/2;
    end
end

handles.tmp.movement2.section = a;
handles.tmp.movement2.movement = b;


% Plotting
axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)

axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)

set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))

guidata(hObject,handles)

% --- Executes on button press in pb_editsettings.
function pb_editsettings_Callback(hObject, eventdata, handles)
% hObject    handle to pb_editsettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
plottype = get(handles.pop_plottype,'value');

switch plottype
    case 1
        sampleplot_settings;
    case 2
        ensembleplot_settings;
    case 3
        comparisonplot_settings;
end

% --- Executes on button press in pb_updatesettings.
function pb_updatesettings_Callback(hObject, eventdata, handles)
% hObject    handle to pb_updatesettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load('Programs\Settings\plot_maker_settings');

handles.settings = plot_maker_settings;

axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)
axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)
set(handles.edit_trial,'string',handles.num)


guidata(hObject, handles)


%% PLOTTING FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%% PLOTTING FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%
%%
function [pos_data,vel_data] = plot_main(data,num,movement,plottype,...
    settings,smoothing)
% data = whole movement data set
% num = current trial number
% movement = which movement is being highlighted; will not be necessary for
% certain types of plots
% plottype = type of plotting data
% plot_settings = to be made plot_settings structure that customizes the
% different plots
% smoothing = applies any desired smoothing
T = length(data.(movement).v_data)/500;
t = 0.002:0.002:T;

if plottype == 1 % sample_plot
    cla reset;

    hold on
    
    if settings.sample_plot.right == 1 % plots the right plot
        tmp = data.(movement).r_data(num,:);
        a = isnan(tmp);
        tmp1 = (smooth(tmp,smoothing));
        tmp1(a) = NaN;
        if settings.sample_plot.inverse_right == 0
            plot(t,tmp1','r','linewidth',2)
        else
            plot(t,-tmp1','r','linewidth',2)
        end
    end
    
    if settings.sample_plot.left == 1 % plots the left plot
        tmp = data.(movement).l_data(num,:);
        a = isnan(tmp);
        tmp1 = (smooth(tmp,smoothing));
        tmp1(a) = NaN;
        if settings.sample_plot.inverse_left == 0
            plot(t,tmp1','b','linewidth',2)
        else
            plot(t,-tmp1','b','linewidth',2)
        end
    end
    
    if settings.sample_plot.comb == 1 % plots the combined plot
        tmp = data.(movement).v_data(num,:);
        a = isnan(tmp);
        tmp1 = (smooth(tmp,smoothing));
        tmp1(a) = NaN;
        if settings.sample_plot.inverse_comb == 0
            plot(t,tmp1','g','linewidth',2)
        else
            plot(t,-tmp1','g','linewidth',2)
        end
    end
    
    if settings.sample_plot.zero == 1
        plot([0 T],[0 0],'-.k')
    end
    
    if settings.sample_plot.target == 1
        plot([0 T],[settings.sample_plot.target_amp settings.sample_plot.target_amp],'-.k')
    end
    
    % other plot settings
    
    if settings.sample_plot.auto == 1
        ylim = [-1.5*ceil(max(abs(tmp))) 1.5*ceil(max(abs(tmp)))];
    else
        ylim = settings.sample_plot.ylim;
    end
    
    axis([0 T ylim])
    xlabel('Time (s)')
    ylabel('Position (deg)')
    
elseif plottype == 2 % ensemble_plot
    cla reset;

    hold on
    tmp = data.(movement).v_data;
    
    beg_color = settings.ensemble_plot.beg_color;
    end_color = settings.ensemble_plot.end_color;
    bg_color = settings.ensemble_plot.bg_color;
    x_spacing = settings.ensemble_plot.x_spacing;
    y_spacing = settings.ensemble_plot.y_spacing;
    
    a = size(tmp);
    
    if settings.ensemble_plot.mode == 1 % regular ensemble plot
        for i = 1:a(1) % individual
            tmp1 = tmp(i,:);
            b = isnan(tmp1);
            tmp2 = (smooth(tmp1,smoothing));
            tmp2(b) = NaN;
            plot(t,tmp2','color',[.6 .6 .6],'linewidth',1);
        end
        
        for i = 1:a(2) % getting the mean
            mean_tmp(i) = nanmean(tmp(:,i));
        end
        
        if settings.ensemble_plot.focus == 1
            plot(t,mean_tmp,'g','linewidth',2.5)
        elseif settings.ensemble_plot.focus == 2
            plot(t,tmp(num,:),'g','linewidth',2.5)
        end % if focus == 0, then nothing is highlighted
        
               
        if settings.ensemble_plot.auto == 1
            ylim = [-1.5*ceil(max(abs(mean_tmp)))-a(1)*y_spacing 1.5*ceil(max(abs(mean_tmp)))];
        else
            ylim = settings.ensemble_plot.ylim;
        end
        
    elseif settings.ensemble_plot.mode == 2 % ensemble with gradients
        
        %         j = 1;
        
        for i = 1:a(1)
            tmp1 = tmp(i,:);
            b = isnan(tmp1);
            tmp2 = smooth(tmp1,smoothing);
            tmp2(b) = nan;
            plot(t+i*(x_spacing),tmp2-(i)*(y_spacing),...
                'Color',[beg_color(1)+(i)*(end_color(1)-beg_color(1))/(a(1))...
                beg_color(2)+(i)*(end_color(2)-beg_color(2))/(a(1))...
                beg_color(3)+(i)*(end_color(3)-beg_color(3))/(a(1))],...
                'linewidth',2)
            %
            %             plot(t+i*(x_spacing),tmp-(i)*(y_spacing))
            %             disp([beg_color(1)+(i)*(end_color(1)-beg_color(1))/(a(1))...
            %                 beg_color(2)+(i)*(end_color(2)-beg_color(2))/(a(1))...
            %                 beg_color(3)+(i)*(end_color(3)-beg_color(3))/(a(1))])
            %             disp(i)
        end
        for i = 1:a(2) % getting the mean
            mean_tmp(i) = nanmean(tmp(:,i));
        end
        if settings.ensemble_plot.auto == 1
            ylim = [-1.5*ceil(max(abs(mean_tmp)))-a(1)*y_spacing 1.5*ceil(max(abs(mean_tmp)))];
        else
            ylim = settings.ensemble_plot.ylim;
        end
    end
    
    if settings.ensemble_plot.zero_plot == 1
        plot([0 T],[0 0],'-.k')
    end
    
    if settings.ensemble_plot.target_plot == 1
        plot([0 T],[settings.ensemble_plot.target_amp settings.ensemble_plot.target_amp],'-.k')
    end
    
    axis([0 T ylim])
    xlabel('Time (s)')
    ylabel('Position (deg)')
    
elseif plottype == 3 % comparison_plot
    cla;

    % axis variables
    ylim_v = settings.comparison_plot.ylim_v;
    ytick_v = settings.comparison_plot.ytick_v;
    ylim_p = settings.comparison_plot.ylim_p;
    ytick_p = settings.comparison_plot.ytick_p;
    line1_color = 'blue';
    line2_color = 'red';
    
    
    %% get the means
    pos1 = data.movement1.v_data;
    pos2 = data.movement2.v_data;
    
    for i = 1:length(pos1(:,1))
        vel1(i,:) = PositionToVelocity(pos1(i,:));
    end
    
    
    for i = 1:length(pos2(:,1))
        vel2(i,:) = PositionToVelocity(pos2(i,:));
    end
    
    for i = 1:length(vel1)
        velmean1(i) = nanmean(vel1(:,i));
    end
    
    
    for i = 1:length(vel2)
        velmean2(i) = nanmean(vel2(:,i));
    end
    
    
    for i = 1:length(pos1)
        posmean1(i) = nanmean(pos1(:,i));
    end
    
    
    for i = 1:length(pos2)
        posmean2(i) = nanmean(pos2(:,i));
    end
    
    [haxes1, hline1, hline2] = plotyy(t,velmean1,t,posmean1);
    [haxes2, hline3, hline4] = plotyy(t,velmean2,t,posmean2);
    plot([0 T],[0 0],'-.k')
    set(hline2,'Color',line1_color,'LineWidth',1.5)
    set(hline1,'Color',line1_color,'LineStyle','-.','LineWidth',1.5)
    set(hline4,'Color',line2_color,'LineWidth',1.5)
    set(hline3,'Color',line2_color,'LineStyle','-.','LineWidth',1.5)
    ylabel(haxes2(1),'Velocity (degrees/sec)') % label left y-axis
    ylabel(haxes2(2),'Position (degrees)') % label right y-axis
    xlabel(haxes2(1),'Time (s)') % label x-axis
    
    set(haxes1(1),'YColor','black','Ylim',ylim_v,'YTick',ytick_v)
    set(haxes2(1),'YColor','black','Ylim',ylim_v,'YTick',ytick_v)
    set(haxes2(2),'YColor','black','Ylim',ylim_p,'YTick',ytick_p)
    set(haxes1(2),'YColor','black','Ylim',ylim_p,'YTick',ytick_p)
    
elseif plottype == 4 % ensemble plot with velocity
    cla reset;
    
    hold on
    tmp = data.(movement).v_data;
    
    a = size(tmp);

    for i = 1:a(1) % individual
        tmp1 = tmp(i,:);
        b = isnan(tmp1);
        tmp2 = (smooth(tmp1,smoothing));
        tmp2(b) = NaN;
        plot(t,tmp2','color',[.6 .6 .6],'linewidth',1);
    end
    
    velocity_smoothing  = 50;
    
    for i = 1:length(tmp(:,1))
        tmp3 = smooth(tmp(i,:),velocity_smoothing); % change smoothing for velocity
        tmp4 = tmp3';
        vel_tmp(i,:) = PositionToVelocity(tmp4(:));
    end
    
    for i = 1:a(2) % getting the means
        mean_tmp(i) = nanmean(tmp(:,i));
        velocity_mean_tmp(i) = nanmean(vel_tmp(:,i));
    end
    
    [haxes1, hline1, hline2] = plotyy(t,mean_tmp,t,velocity_mean_tmp);
    set(hline1,'Color','green','LineWidth',2)
    set(hline2,'Color','red','LineWidth',2)
    
    
    set(haxes1(1),'YColor','black','Ylim',[-5 5],'YTick',[-2 0 2])
    set(haxes1(2),'YColor','black','Ylim',[-100 100],'YTick',[-40 0 40])
    if settings.ensemble_plot.zero_plot == 1
        plot([0 T],[0 0],'-.k')
    end
    
    ylabel(haxes1(2),'Velocity (deg/sec)')
    ylabel(haxes1(1),'Position (deg)')

%     axis([0 T ylim])
    xlabel('Time (s)')
end

function plot_sample(tmp,num,movement,smoothing)
% plots a single trial so operator can decide if he/she wants to remove the
% trial completely

% data - the plot data
% smoothing - value of the smoothing function
% axis - to be determined later (axis of the single_plot)

tmp1 = tmp.(movement).v_data(num,:);
T = length(tmp1)/500;
t = 0.002:0.002:T;
a = find(isnan(tmp1));

cla;

tmp2 = smooth(tmp1,smoothing); %smooth data
b = tmp2';

b(a) = NaN;

plot(t,b); %plot the data



function ens_plot(data,smoothing,x_spacing,y_spacing,bgcolor,beg_color,end_color)
% regular ensemble plots have x_spacing and y_spacing values of zero.

switch nargin %default values
    case 4
        bgcolor = [0 0 0];
        beg_color = [.3 .3 .3];
        end_color = [1 1 1];
    case 5
        beg_color = [.3 .3 .3];
        end_color = [1 1 1];
end

cla;
hold on;

a = size(data);
t = 0.002:0.002:a(2)/500; % time

for i = 1:a(1);
    b = find(isnan(data(i,:)));
    data1 = smooth(data(i,:),smoothing);
    c = data1';
    c(b) = NaN;
    plot(t+(i-1)*(x_spacing),c-(i-1)*(y_spacing),...
        'Color',[beg_color(1)+(i-1)*(end_color(1)-beg_color(1))/(a(1))...
        beg_color(2)+(i-1)*(end_color(2)-beg_color(2))/(a(1))...
        beg_color(3)+(i-1)*(end_color(3)-beg_color(3))/(a(1))])
end

ax = gca;
set(ax,'Color',bgcolor) % setting the background color





%%%%%%%%%%%%%%%%%%%%%%%%%% OTHER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function output_data = blink_removal(input_data)
figure; % makes figure
plot(input_data) % plot data onto the figure

[x,~] = ginput(2); % choose data points of blink

data2(ceil(x(1)):ceil(x(2))) = NaN;
close;

output_data = data2;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTES: STUFF TO BE ADDED IN LATER VERSIONS OF THE CODE

% Different plotting options for the ensemble plot (i.e. normalizing the
% time and spacing each individual trial so each one can be seen apart from
% the other trials)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
save('test','handles')


% --- Executes on button press in pb_load.
function pb_load_Callback(hObject, eventdata, handles)
% hObject    handle to pb_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName] = ...
    uigetfile('*.mat','Select the raw data file','','MultiSelect','off');

try
    load([pathName fileName])
catch
    return
end

handles.tmp = tmp;
handles.num = 1;

try
    set(handles.text18,'string',handles.tmp.movement1.section) % section1
catch
end

try
    set(handles.text22,'string',handles.tmp.movement1.movement) % movement1
catch
end

try
    set(handles.text21,'string',handles.tmp.movement2.section) % section2
catch
end

try
    set(handles.text23,'string',handles.tmp.movement2.movement) % movement2
catch
end

% Plotting
axes(handles.plot_secondary)
plot_sample(handles.tmp,handles.num,handles.movement_num,handles.smoothing)

axes(handles.plot_main)
plot_main(handles.tmp,handles.num,handles.movement_num,handles.plottype,...
    handles.settings,handles.smoothing)

set(handles.edit_trial,'string',handles.tmp.(handles.movement_num).seq_num(handles.num))

guidata(hObject,handles)


% --- Executes on button press in pb_savedata.
function pb_savedata_Callback(hObject, eventdata, handles)
% hObject    handle to pb_savedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp = handles.tmp;
handles.fn = inputdlg('Name Data File');
% disp(handles.filename)
save(handles.fn{1},'tmp');
