function varargout = Calculate_VEMAP(varargin)
% CALCULATE_VEMAP MATLAB code for Calculate_VEMAP.fig
%      CALCULATE_VEMAP, by itself, creates a new CALCULATE_VEMAP or raises the existing
%      singleton*.
%
%      H = CALCULATE_VEMAP returns the handle to a new CALCULATE_VEMAP or the handle to
%      the existing singleton*.
%
%      CALCULATE_VEMAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALCULATE_VEMAP.M with the given input arguments.
%
%      CALCULATE_VEMAP('Property','Value',...) creates a new CALCULATE_VEMAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Calculate_VEMAP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Calculate_VEMAP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Rev History
% 1.0   02/26/16    Release
% 1.1   03/11/16    Added Main Sequence ratio
% 1.2   03/16/16    Fixed the check boxes... added response_amp_index.


% Edit the above text to modify the response to help Calculate_VEMAP

% Last Modified by GUIDE v2.5 11-Apr-2016 17:06:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Calculate_VEMAP_OpeningFcn, ...
    'gui_OutputFcn',  @Calculate_VEMAP_OutputFcn, ...
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


% --- Executes just before Calculate_VEMAP is made visible.
function Calculate_VEMAP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Calculate_VEMAP (see VARARGIN)
set(handles.cb_latency,'value',1);
set(handles.cb_tpeak,'value',1);
set(handles.cb_tsettle,'value',1);
set(handles.cb_vpeak,'value',1);
set(handles.cb_respamp,'value',1);
set(handles.cb_finalamp,'value',1);
set(handles.cb_latency,'value',1);
set(handles.cb_timeconstant,'value',0);
set(handles.cb_mainsequenceratio,'value',1);
% Choose default command line output for Calculate_VEMAP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Calculate_VEMAP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Calculate_VEMAP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pb_calculate.
function pb_calculate_Callback(hObject, eventdata, handles)
% hObject    handle to pb_calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat*','Select the data file/s to analyze',('Data\Processed'),'MultiSelect','on');

try
    if FileName == 0
        return
    end
end

modes = {'vergence_horz' 'version_horz' 'vergence_vert' 'version_vert'};

if ischar(FileName) == 1
    
    load([PathName FileName]);
    
    % calculate all the things
    
    a = fieldnames(data);
    b = fieldnames(data.(a{1}));
    
    %     if isempty(data.(a{1}).(b{1})(1).vergence_horz.vpeak) == 0 % checks if the calculations have been done
    %%
    a = fieldnames(data);
    
    handles.h = waitbar(0,'Calculating parameters...');
    for i = 1:length(a)
        section = (a{i});
        b = fieldnames(data.(a{i}));
        
        for j = 1:length(b)
            movement = (b{j});
            for k = 1:length(data.(section).(movement))
                tmp = eye_movements.(section).(movement){k};
                for h = 1:4
                    % add calculations here
                    if get(handles.cb_vpeak,'value') == 1
                        data.(section).(movement)(k).(modes{h}).vpeak = vpeak(tmp,h);
                    end
                    
                    if get(handles.cb_latency,'value') == 1
                        data.(section).(movement)(k).(modes{h}).latency = latency(tmp,h);
                    end
                    
                    if get(handles.cb_tpeak,'value') == 1
                        data.(section).(movement)(k).(modes{h}).tpeak = tpeak(tmp,h);
                    end
                    
                    if get(handles.cb_tsettle,'value') == 1
                        data.(section).(movement)(k).(modes{h}).tsettle = settlingtime(tmp,h);
                    end
                    
                    if get(handles.cb_finalamp,'value') == 1
                        data.(section).(movement)(k).(modes{h}).final_amp = amplitude(tmp,h);
                    end
                    
                    if get(handles.cb_respamp,'value') == 1
                        [data.(section).(movement)(k).(modes{h}).response_amp,...
                            data.(section).(movement)(k).(modes{h}).response_amp_index] = response(tmp,h,[]);
                    end
                    
                    if get(handles.cb_timeconstant,'value') == 1
                        data.(section).(movement)(k).(modes{h}).time_constant...
                            = time_constant(tmp,h);
                    end
                    
                    if get(handles.cb_mainsequenceratio,'value') == 1
                        data.(section).(movement)(k).(modes{h}).main_seq_ratio...
                            = data.(section).(movement)(k).(modes{h}).vpeak/...
                            data.(section).(movement)(k).(modes{h}).response_amp;
                    end
                end
            end
        end
        waitbar(i/length(a))
        %         end
        
    end
    close(handles.h)
    handles.eye_movements = eye_movements;
    handles.data = data;
    
    save(['Data\Processed\' FileName],'eye_movements','data')
else
    for filei = 1:length(FileName)
        load([PathName FileName{filei}])
        
        % calculate all the things
        
        a = fieldnames(data);
        b = fieldnames(data.(a{1}));
        
        %         if isempty(data.(a{1}).(b{1})(1).vergence_horz.vpeak) == 1 % checks if the calculations have been done
        %%
        a = fieldnames(data);
        
        handles.h = waitbar(0,'Calculating parameters...');
        for i = 1:length(a)
            section = (a{i});
            b = fieldnames(data.(a{i}));
            
            for j = 1:length(b)
                movement = (b{j});
                for k = 1:length(data.(section).(movement))
                    tmp = eye_movements.(section).(movement){k};
                    for h = 1:4
                        % add calculations here
                        if get(handles.cb_vpeak,'value') == 1
                            data.(section).(movement)(k).(modes{h}).vpeak = vpeak(tmp,h);
                        end
                        
                        if get(handles.cb_latency,'value') == 1
                            data.(section).(movement)(k).(modes{h}).latency = latency(tmp,h);
                        end
                        
                        if get(handles.cb_vpeak,'value') == 1
                            data.(section).(movement)(k).(modes{h}).tpeak = tpeak(tmp,h);
                        end
                        
                        if get(handles.cb_tsettle,'value') == 1
                            data.(section).(movement)(k).(modes{h}).tsettle = settlingtime(tmp,h);
                        end
                        
                        if get(handles.cb_finalamp,'value') == 1
                            data.(section).(movement)(k).(modes{h}).final_amp = amplitude(tmp,h);
                        end
                        
                        if get(handles.cb_respamp,'value') == 1
                            [data.(section).(movement)(k).(modes{h}).response_amp,...
                                data.(section).(movement)(k).(modes{h}).response_amp_index] = response(tmp,h,[]);
                        end
                        
%                         if get(handles.cb_timeconstant,'value') == 1
%                             data.(section).(movement)(k).(modes{h}).time_constant...
%                                 = time_constant(tmp,h);
%                         end
%                         
                        if get(handles.cb_mainsequenceratio,'value') == 1
                            data.(section).(movement)(k).(modes{h}).main_seq_ratio...
                                = data.(section).(movement)(k).(modes{h}).vpeak/...
                                data.(section).(movement)(k).(modes{h}).response_amp;
                        end
                    end
                end
            end
            waitbar(i/length(a))
        end
        close(handles.h)
        %         end
        
        handles.eye_movements = eye_movements;
        handles.data = data;
        
        save([PathName FileName{filei}],'eye_movements','data')
        
    end
    
end


% --- Executes on button press in pb_close.
function pb_close_Callback(hObject, eventdata, handles)
% hObject    handle to pb_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in cb_xverg.
function cb_xverg_Callback(hObject, eventdata, handles)
% hObject    handle to cb_xverg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_xverg


% --- Executes on button press in cb_xvers.
function cb_xvers_Callback(hObject, eventdata, handles)
% hObject    handle to cb_xvers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_xvers


% --- Executes on button press in cb_yverg.
function cb_yverg_Callback(hObject, eventdata, handles)
% hObject    handle to cb_yverg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_yverg


% --- Executes on button press in cb_yvers.
function cb_yvers_Callback(hObject, eventdata, handles)
% hObject    handle to cb_yvers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_yvers


% --- Executes on button press in cb_latency.
function cb_latency_Callback(hObject, eventdata, handles)
% hObject    handle to cb_latency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_latency


% --- Executes on button press in cb_tpeak.
function cb_tpeak_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_tpeak


% --- Executes on button press in cb_tsettle.
function cb_tsettle_Callback(hObject, eventdata, handles)
% hObject    handle to cb_tsettle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_tsettle


% --- Executes on button press in cb_mainsequenceratio.
function cb_mainsequenceratio_Callback(hObject, eventdata, handles)
% hObject    handle to cb_mainsequenceratio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_mainsequenceratio


% --- Executes on button press in cb_vpeak.
function cb_vpeak_Callback(hObject, eventdata, handles)
% hObject    handle to cb_vpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_vpeak


% --- Executes on button press in cb_respamp.
function cb_respamp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_respamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_respamp


% --- Executes on button press in cb_finalamp.
function cb_finalamp_Callback(hObject, eventdata, handles)
% hObject    handle to cb_finalamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_finalamp


% --- Executes on button press in cb_timeconstant.
function cb_timeconstant_Callback(hObject, eventdata, handles)
% hObject    handle to cb_timeconstant (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb_timeconstant
