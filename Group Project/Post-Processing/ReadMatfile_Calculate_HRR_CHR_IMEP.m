
% addpath '\\home.org.aalto.fi\chengq1\data\Desktop\Engine Study\Matlab_PostProcessing\natsortfiles' % reorder your cases
addpath 'C:\Users\nguye\Desktop\Thermo\Group Project\Post-Processing\natsortfiles' % reorder your cases
% Define a starting folder.
start_path = fullfile(matlabroot, '\toolbox');
if ~exist(start_path, 'dir')
    start_path = matlabroot;
end
% Ask user to confirm or change.
uiwait(msgbox('Pick a starting folder on the next window that will come up.'));
topLevelFolder = uigetdir(start_path);
if topLevelFolder == 0
    return;
end
% Get list of all subfolders.
allSubFolders = genpath(topLevelFolder);
% Parse into a cell array.
remain = allSubFolders;
listOfFolderNames = {};
while true
    [singleSubFolder, remain] = strtok(remain, ';');
    if isempty(singleSubFolder)
        break;
    end
    listOfFolderNames = [listOfFolderNames singleSubFolder];

    LOfFNs=natsortfiles(listOfFolderNames);
end
numberOfFolders = length(LOfFNs); % Process all image files in those folders.



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


%%



for kk = 1 : numberOfFolders
    thisFolder = LOfFNs{kk};
    fprintf('Processing folder %s\n', thisFolder);% Get this folder and print it out.

    filePattern = sprintf('%s/*.mat', thisFolder);
    baseFileNames = dir(filePattern);% Get ALL files.
    numberOfMatFiles = length(baseFileNames);

    if numberOfMatFiles >= 1   % Go through all those files.

        for f = 1 : numberOfMatFiles

            tStart(f,:) = tic;

            fullFileName = fullfile(thisFolder, baseFileNames(f).name);
            [pathstr,name,ext] = fileparts(fullFileName);
            newFilename = fullfile( pathstr,strcat(name,ext));
            D(kk).D(f).Data = load(newFilename);
            CADTime= D(kk).D(f).Data.Data1_X_PCyl1; % Read the Crank angle time
            SD(kk).D(f).CylPre= double(D(kk).D(f).Data.Data1_PCyl1');%Cylinder pressure

            [b1,a1] = butter(10,fnorm1,'low'); % Low pass Butterworth filter of order 10
            [b2,a2] = butter(10,fnorm2,'low'); % Low pass Butterworth filter of order 10


            low_data1 = filtfilt(b1,a1,SD(kk).D(f).CylPre(1:1400,:)); % filtering
            low_data2 = filtfilt(b2,a2,SD(kk).D(f).CylPre(1401:2200,:)); % filtering
            low_data3 = filtfilt(b1,a1,SD(kk).D(f).CylPre(2201:end,:)); % filtering

            SD(kk).D(f).SmoCylPre =  cat(1,low_data1,low_data2,low_data3); % Collecting filtered data


            SD(kk).D(f).HRR= D(kk).D(f).Data.Data1_dQ1;% Heat Release Rate
            SD(kk).D(f).CHR=D(kk).D(f).Data.Data1_T2_IntQ1;% Cummulative heat release
            SD(kk).D(f).InjCur=D(kk).D(f).Data.Data1_Injection_signal_1; % Injection current

            SD(kk).S(f).Torque= D(kk).D(f).Data.Data1_Torque1; % Torque of each cycle
            SD(kk).S(f).Power= D(kk).D(f).Data.Data1_Power1;% Power of each cycle
            SD(kk).S(f).CA5= D(kk).D(f).Data.Data1_MFB05_1; % 5% fuel burning rate
            SD(kk).S(f).CA10= D(kk).D(f).Data.Data1_MFB10_1; % 10% fuel burning rate
            SD(kk).S(f).CA50= D(kk).D(f).Data.Data1_MFB50_1; % 50% fuel burning rate
            SD(kk).S(f).CA90= D(kk).D(f).Data.Data1_MFB90_1; % 90% fuel burning rate
            SD(kk).S(f).SOC= D(kk).D(f).Data.Data1_SOC1; % Start of combustion


        end
    end

end



%%
%%% Define some basic engine paramters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cycle = 720 * 5;                % Data sampling size for each cycle
conrodLength=0.232;             %Connecting rod length
crankRadius=0.0725;             %Crank radius
lambda=crankRadius/conrodLength;%Crank to conrod ratio
Vd1=0.00140315;                 %Displacement volume in m^3
Rc=17.1;                        %Compression ratio- effective cr obtained from experiments
pistonD=0.1108;                 %Piston Diameter
pistonA=(pi/4)*(pistonD)^2;     %Piston Area
gamma=1.35;                     %From literature, ratio of specific heats
Vc=Vd1/(Rc-1);                  % Clearance Volume
rpm=1200;                       % Engine Speed
dtheta=0.2;                     % Sampling resolution

Cad= (0.2:0.2:720)';            % Cad value
Theta= Cad.*(pi/180);           % Convert the Cad to connect rod angle
PisM=crankRadius*((1-cos(Theta))+(1/lambda)*(1-sqrt(1-lambda^2*(sin(Theta)).^2)));    %Calculating piston movement at each CA radians
ComV= PisM*pistonA+Vc; %Momentary combustion volume
SOI_BTDC=7;


for t= 1:size(SD,2)
    for s=1:size(SD.D,2)
        for c=2:length(Theta) %k=2:length(Pr(i).Theta)
            SD(t).dV(c,1)=ComV(c,1)-ComV(c-1,1);
            SD(t).D(s).dPSmo(c,:)=SD(t).D(s).SmoCylPre(c,:)-SD(t).D(s).SmoCylPre(c-1,:);
            SD(t).D(s).dQSmo(c,:)=((100000*(1/(gamma-1))*(gamma*SD(t).D(s).SmoCylPre(c,:) ...
                *(SD(t).dV(c,1)/dtheta)+ComV(c,1)*(SD(t).D(s).dPSmo(c,:)/dtheta)))); % Check this formula from engine text book or papers
        end

        %%
        % Calculate CHR, IMEP and MFB based on our own method
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        SD(t).D(s).ReCHR(1:3600,1:size(SD(t).D(s).dQSmo,2))=0;
        for u=1700:2100
            if SD(t).D(s).dQSmo(u,:)<0
                SD(t).D(s).dQSmo(u,:)=0.001*abs(SD(t).D(s).dQSmo(u,:));
            end
            SD(t).D(s).ReCHR(u,:)=SD(t).D(s).ReCHR(u-1,:)+SD(t).D(s).dQSmo(u,:)*Theta(u,1); %cumulQ is cumulative heat release
        end

        %% Calculate the fuel burned rate based on Cumulative heat release
        for xx=1:100
            CA(xx,:) = (xx/100)*max(SD(t).D(s).ReCHR(1700:2100,:));
            F(xx).CA_tmp(1700:2100,:) = abs(SD(t).D(s).ReCHR(1700:2100,:)-CA(xx,:));
            [SD(t).D(s).CAV(xx,:) SD(t).D(s).CA_idx(xx,:)] = min(F(xx).CA_tmp(1700:2100,:),[],1);

            SD(t).D(s).CA_CAD(xx,:) = (1700+SD(t).D(s).CA_idx(xx,:))/5-(360-SOI_BTDC); % Crank-Angle degrees duration of % Heat released from Actual SOI
            SD(t).D(s).MS(xx,:)=SD(t).D(s).CA_CAD(xx,:)*1000/(RPM*6);                  % Convert the Crank-Angle degreesto milliseconds

            SD(t).D(s). AvgCA_CAD(xx,:)= mean(SD(t).D(s).CA_CAD(xx,:),2);
            SD(t).D(s). AvgMS(xx,:)= mean(SD(t).D(s).MS(xx,:),2);
        end
        %% Calculate the indicated mean effective pressure
        WD= SD(t).D(s).SmoCylPre.*SD(t).dV;
        SD(t).D(s).IMEP=sum(WD,1)/Vd1;  % Indicated mean effective pressure
        SD(t).D(s). AvgIMEP= mean(SD(t).D(s).IMEP); % average Indicated mean effective pressure

        [dPValues, dPIIndex] = min(SD(t).D(s).dPSmo(1760:1800,:),[],1); % calculate the start of ignition timing
        SD(t).D(s).dPCAD = (1760+dPIIndex)/5-(360-SOI_BTDC); % Crank-Angle degrees based ignition delay time
        SD(t).D(s).dPMS=SD(t).D(s).dPCAD*1000/(RPM*6);                  % ignition delay time in milliseconds

        SD(t).D(s).AVGdPMS=mean(SD(t).D(s).dPMS);
        SD(t).D(s).dPMS(SD(t).D(s).dPMS< 0.7*SD(t).D(s).AVGdPMS)=nan ;
        SD(t).D(s).dPMS(SD(t).D(s).dPMS> 1.3*SD(t).D(s).AVGdPMS)=nan;


        %% Calculate the coefficient of variations

        SD(t).D(s).STDMS=std( SD(t).D(s).MS,0,2);
        SD(t).D(s).STDIMEP=std( SD(t).D(s).IMEP,0,2);
        SD(t).D(s).STDIDTdP=std( SD(t).D(s).dPMS(~isnan( SD(t).D(s).dPMS)),0,2);

        for d= 1:100
            SD(t).D(s).COVIDT(d,:)=  SD(t).D(s).STDMS(d,1)*100./ SD(t).D(s).MS(d,:);
        end

        SD(t).D(s).COVIMEP=  SD(t).D(s).STDIMEP*100./ SD(t).D(s).IMEP;
        SD(t).D(s).COVIDTdP=  SD(t).D(s).STDIDTdP*100./ SD(t).D(s).dPMS;



    end
end


MatFolder='C:\Users\nguye\Desktop\Thermo\Group Project\Post-Processing'; % Define the folder to save the mat file. Change the path
SubName= '\Results'; % define the subfolder if needed
FullName=mkdir(strcat(MatFolder,SubName)); % create a new folder based on the aforementioned folder
FullMatFileName=fullfile([strcat(MatFolder,SubName),'\EngineData.mat']); % define the full name of the mat file
save(FullMatFileName,'SD') % save the desired mat data


