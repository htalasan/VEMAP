function export_means(filename, xcel_file)
% This function takes data .m file(s) and an xcel file and outputs an xcel
% file (filename) that contains the means of the different parameters of 
% all of the movements that are considered 'good' in the data set. This
% function will try to input data for every movement. However, if a
% movement is corrupt or one of its trials was not processed correctly, the
% function will disp and error on the command window.
%
% Calls:
% export_means
%   - Export to default value of filename and using the default xcel_file below
% export_means(filename)
%   - Export to filename, using the default xcel_file below
% export_means(filename, xcel_file)
%   - Export to filename using the xcel_file
%
% NOTES:    
% xcel_file must have a '.xlsx' or xcel suffix at the end
% xcel_file should be saved into the VEMAP folder
% xcel_file is exported from the google shared sheet 'VENL - fMRI Analysis'
%
% Revision History:
% Rev   Date        Author          Changes
%  A    9/18/2017   Henry Talasan   Initial Release
%  B    12/7/2017   HT              uncommented code to return if nothing
%                                   is chosen
% 1.0.2 2018/05/03  HT              Changed rev level nomenclature. Added
%                                   more comments

if nargin == 1
    xcel_file = 'VNEL - Analysis.xlsx'; % can change the default xcel_file here
elseif nargin == 0
    xcel_file = 'VNEL - Analysis.xlsx';
    filename = 'sample'; % can change the default filename here
end


[FileName,PathName] = uigetfile('*.mat*','Select the data file to export'...
    ,('Data\Processed'),'Multiselect','on');
try
    if FileName == 0 || isempty(FileName)% if nothing chosen do nothing.
        return
    end
catch
end

% EXCEL EXPORT (main function)
filename = [filename '.xlsx'];
sheet = 'data';
headers = {'Subject' 'Time of Experiment' 'Subject Type' 'Type of Therapy'...
    'Section' 'Movement' 'Latency' 'Latency STD'...
    'Time to Peak' 'Time to Peak STD' 'Peak Velocity' 'Peak Velocity STD'...
    'Response Amplitude' 'Response Amp STD' 'Final Amplitude'...
    'Final Amp STD' 'Main Sequence Ratio' 'Main Sequence Ratio STD' 'N'...
    'Experiment'};
xlswrite(filename,headers,sheet,'A1');

%
ind = 1; %start index @ 1; index of the row to output
table = {}; %initialize empty table

if ischar(FileName) == 1 % single data file
    table = write_to_table(FileName, PathName, table, ind, xcel_file);
else
    h = waitbar(0, 'Exporting data to excel...');
    for filecount = 1:length(FileName) % multiple data files
        waitbar(filecount/length(FileName));
        [table, ind] = write_to_table(FileName{filecount}, PathName, table, ind, xcel_file);
    end
    close(h)
end

xlswrite(filename,table,sheet,'A2');

%% functions
function goodtrials_index = choose_trials(data,section,stimuli)
% chooses which are the good classifications
% <param: data>all the data</param> 
% <param: section>the section desired</param> 
% <param: stimuli>the stimuli desired</param> 
% <output: goodtrials_index>an index of all the "good" trials</output>

good_classifications = {... % add types here
    'Good'
    'Symmetrical Binocular Movement'
    'Asymmetrical Binocular Movement'
    'Single Saccade'
    'Sequential Saccade'
    };

k = 1;
goodtrials_index = [];
for i = 1:length(data.(section).(stimuli))
    classification = data.(section).(stimuli)(i).classifications;
    for j = 1:length(good_classifications)
        if strcmp(classification,good_classifications{j})
            goodtrials_index(k) = i;
            k = k + 1;
            break
        end
    end
end

function param_mean = get_param_mean(dat,good_trials_index,parameter,section)
% get the mean of the good trials
% <param: dat>all the data</param> 
% <param: good_trials_index>an index of all the "good" trials</param> 
% <param: parameter>parameter desired (e.g. response amplitude, peak velocity)</param> 
% <param: section>section desired</param>
% <output: param_mean>mean of the "good" parameters</output>

k = 1;
for i = good_trials_index % create array of trials
    
    if strcmp(section,'SACCADES') % choose between vert or horz
        axis_choice = 'version_horz';
    else
        axis_choice = 'vergence_horz';
    end
    
    % if other axis must be used, write code here...
    
    %     try
    arr(k) = dat(i).(axis_choice).(parameter);
    k = k+1;
    %     catch
    %         disp(arr)
    %         disp(parameter)
    %         disp(section)
    %     end
end

param_mean = nanmean(arr);

function param_std = get_param_std(dat,good_trials_index,parameter,section)
% get the std of the good trials
% <param: dat>all the data</param> 
% <param: good_trials_index>an index of all the "good" trials</param> 
% <param: parameter>parameter desired (e.g. response amplitude, peak velocity)</param> 
% <param: section>section desired</param>
% <output: param_std>std of the "good" parameters</output>

k = 1;
for i = good_trials_index % create array of trials
    
    if strcmp(section,'SACCADES') % choose between vert or horz
        axis_choice = 'version_horz';
    else
        axis_choice = 'vergence_horz';
    end
    
    arr(k) = dat(i).(axis_choice).(parameter);
    k = k+1;
    
end

param_std = nanstd(arr);

function [time_of_experiment, subject_type, type_of_therapy] = other_params(subject, session_date, filename)
% get the other params that cannot be garnered by just looking at the title
% and must use the table
% <param: subject>subject ID</param> 
% <param: session_date>date of the session</param> 
% <param: filename>analysis xcel sheet</param> 
% <output: time_of_experiment>before/after/date (if cannot figure before or after)</output>
% <output: subject_type>BNC/CI</output>
% <output: type_of_therapy>Active/Placebo</output>

%get two arrays of the table, where num are numerical values of the table,
%ie strings, and txt are string values of the table, ie the other params
[num,txt] = xlsread(filename);

ind = index_of_string(subject, txt(:,1)); % getting the index of the subject

% find the time_of_experiment
dates = num(ind-1, 8:11); %get the session dates to compare (columns K to N in file)

if rem(find(dates==str2num(session_date)),2) == 1
    time_of_experiment = 'Before';
elseif rem(find(dates==str2num(session_date)),2) == 0
    time_of_experiment = 'After';
else
    time_of_experiment = session_date; % something is wrong but we'll do the analysis anyways
end

% find the subject_type
subject_type = txt(ind, 2);

% find the type_of_therapy
type_of_therapy = txt(ind, 3);



function index = index_of_string(str, cell_array_of_strings)
% function finds the index of the first string given a string and a cell
% structure of strings
% <param: str>string desired</param> 
% <param: cell_array_of_strings>cell array of strings</param> 
% <output: index>index of the first instance of string in cell array</output>

for i = 1:length(cell_array_of_strings)
    if strcmp(str, cell_array_of_strings(i))
        index = i;
        break;
    end
    
end


function [output_table, index] = write_to_table(FileName, PathName, input_table, index, xcel_filename)
% writes data to table
% <param: FileName>name of the data file to analyse</param> 
% <param: PathName>path name of the data file</param> 
% <param: input_table>initial table of data</param> 
% <param: index>current index of table</param> 
% <param: xcel_filename>analysis xcel sheet</param> 
% <output: output_table>appended table</output>
% <output: index>updated index number</output>

k = index;

str_split = strsplit(FileName,'_'); %splits the filename into sections
%get the different parameters from the filename
subject = str_split{1};
experiment = str_split{4};
session_date = str_split{end-1};

% look at the xcel table and get session, subject type, and type of
% therapy
[time_of_experiment, subject_type, type_of_therapy] = other_params(subject, session_date, xcel_filename);

load([PathName FileName])
Section_Names = fieldnames(data);

for j = 1:length(Section_Names) %goes through each section
    curr_section = Section_Names{j};
    Stimulus_Names = fieldnames(data.(curr_section));
    
    for i = 1:length(Stimulus_Names) %goes through each stimulus
        curr_stim = Stimulus_Names{i};
        dat = data.(curr_section).(curr_stim);
        try
            % get the "good" responses
            good_index = choose_trials(data,curr_section,curr_stim);
            
            table{k,1} = subject;
            table{k,2} = time_of_experiment;
            table(k,3) = subject_type;
            table(k,4) = type_of_therapy;
            table{k,5} = curr_section;
            table{k,6} = curr_stim;
            table{k,20} = experiment;
            
            if isempty(good_index) == 1
                % get the means
                latency_mean = 0;
                tpeak_mean = 0;
                vpeak_mean = 0;
                response_amp_mean = 0;
                final_amp_mean = 0;
                main_seq_ratio_mean = 0;
                
                % get the stds
                latency_std = 0;
                tpeak_std = 0;
                vpeak_std = 0;
                response_amp_std = 0;
                final_amp_std = 0;
                main_seq_ratio_std = 0;
                
                % write to the table
                table{k,7} = latency_mean;
                table{k,8} = latency_std;
                table{k,9} = tpeak_mean;
                table{k,10} = tpeak_std;
                table{k,11} = vpeak_mean;
                table{k,12} = vpeak_std;
                table{k,13} = response_amp_mean;
                table{k,14} = response_amp_std;
                table{k,15} = final_amp_mean;
                table{k,16} = final_amp_std;
                table{k,17} = main_seq_ratio_mean;
                table{k,18} = main_seq_ratio_std;
                table{k,19} = length(good_index);
                k = k+1;
                
            else
                % get the means
                latency_mean = get_param_mean(dat,good_index,'latency',curr_section);
                tpeak_mean = get_param_mean(dat,good_index,'tpeak',curr_section);
                vpeak_mean = get_param_mean(dat,good_index,'vpeak',curr_section);
                response_amp_mean = get_param_mean(dat,good_index,'response_amp',curr_section);
                final_amp_mean = get_param_mean(dat,good_index,'final_amp',curr_section);
                main_seq_ratio_mean = get_param_mean(dat,good_index,'main_seq_ratio',curr_section);
                
                % get the stds
                latency_std = get_param_std(dat,good_index,'latency',curr_section);
                tpeak_std = get_param_std(dat,good_index,'tpeak',curr_section);
                vpeak_std = get_param_std(dat,good_index,'vpeak',curr_section);
                response_amp_std = get_param_std(dat,good_index,'response_amp',curr_section);
                final_amp_std = get_param_std(dat,good_index,'final_amp',curr_section);
                main_seq_ratio_std = get_param_std(dat,good_index,'main_seq_ratio',curr_section);
                
                % write to the table
                table{k,7} = latency_mean;
                table{k,8} = latency_std;
                table{k,9} = tpeak_mean;
                table{k,10} = tpeak_std;
                table{k,11} = vpeak_mean;
                table{k,12} = vpeak_std;
                table{k,13} = response_amp_mean;
                table{k,14} = response_amp_std;
                table{k,15} = final_amp_mean;
                table{k,16} = final_amp_std;
                table{k,17} = main_seq_ratio_mean;
                table{k,18} = main_seq_ratio_std;
                table{k,19} = length(good_index);
                k = k+1;
            end
            
        catch
            disp(['Failed on ' curr_stim ' in ' curr_section ' for Subject, ' subject...
                '. Cannot compute']);
        end
        
    end
end

% add new table to input table
output_table = [input_table; table];




