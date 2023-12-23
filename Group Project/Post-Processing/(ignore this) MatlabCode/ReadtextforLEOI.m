clear all  % clear the Workspcae
close all  % close all figures
clc        % clear the Command Window


%%
%define some parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cycle = 720 * 5; % Define the sample of each cycle
RPM=1200;        % define the engine speed

f=RPM*360*5/60;  % define sampling frequency

f_cutoff1=500;   % define the filtering frequency before and after combustion
f_cutoff2=2500;  % define the filtering frequency during combustion

fnorm1=f_cutoff1/(f/2);
fnorm2=f_cutoff2/(f/2);

%% Define the path of the data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

myFolder = '\\home.org.aalto.fi\chengq1\data\Desktop\Engine Study\ExperimentalData(forlearning)\'; % Define your working folder. Change this path to your own file loacation

if ~isdir(myFolder)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);
    uiwait(warndlg(errorMessage));
    return;
end
filePattern = fullfile(myFolder, '*.txt');
matFiles = dir(filePattern);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1:length(matFiles)
    
    baseFileName = matFiles(k).name;  % get the file name
    fullFileName = fullfile(myFolder, baseFileName); % get the full path and file name
    fprintf(1, 'Now reading %s\n', fullFileName);   % show the proceeding file in command window
    fileID = fopen(fullFileName,'r'); % get the file ID

    formatSpec1='%s'; % define the formatSpec for text reading

    N=38; % Define the cycle number

    O(k).C_title = textscan(fileID,formatSpec1,N); % read formatted data from text file to get the title of the data
    linenum = 1;

    nNumberCols = 198; % Change the Number to save cycles
    format = ['%s%s' repmat('%s', [1 nNumberCols])];
    delimiter = '\t';
    O(k).C_data=textscan(fileID, format, 'Delimiter', delimiter, 'HeaderLines' ,linenum-1, 'ReturnOnError', false); 
    % read formatted data from text file to get the value

    fclose(fileID);


    for j=1:length(O(k).C_data)
        G(k).CylPress(:,j)=O(k).C_data{1,j};
    end


    for n=1:size(G(k).CylPress,1)
        G(k).NCylPress(n,:) = str2num(char(strrep(G(k).CylPress(n,:),',','.')')); % convert the komma to dot
    end

    [b1,a1] = butter(10,fnorm1,'low'); % Low pass Butterworth filter of order 10
    [b2,a2] = butter(10,fnorm2,'low'); % Low pass Butterworth filter of order 10

    for m= 1:size(G(k).NCylPress,2)-1
        SCylPress(:,m)=G(k).NCylPress(1801:3600,m); % reorder the first part of the data
        BCylPress(:,m)=G(k).NCylPress(1:1800,m+1);  % reorder the second part of the data

        G(k).FCylPress=[SCylPress;BCylPress]; % Combine the first part and second part to get completelworkrt. 
        G(k).CylAvg = mean(G(k).FCylPress,2);

        low_data1 = filtfilt(b1,a1,G(k).FCylPress(1:1400,:)); % filtering
        low_data2 = filtfilt(b2,a2,G(k).FCylPress(1401:2200,:)); % filtering
        low_data3 = filtfilt(b1,a1,G(k).FCylPress(2201:end,:)); % filtering

        G(k).Smo =  cat(1,low_data1,low_data2,low_data3); % Collecting filtered data
    end

end

MatFolder='D:\Post_MatFile'; % Define the folder to save the mat file. Change the path
SubName= '\EngineData'; % define the subfolder if needed
FullName=mkdir(strcat(MatFolder,SubName)); % create a new folder based on the aforementioned folder
FullMatFileName=fullfile([strcat(MatFolder,SubName),'\EngineData.mat']); % define the full name of the mat file
save(FullMatFileName,'O','G') % save the desired mat data



