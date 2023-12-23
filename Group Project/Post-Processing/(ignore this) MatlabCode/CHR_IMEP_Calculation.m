SOI_BTDC=7;
RPM=1200;

%%
%%% Define some basic engine paramters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cycle = 720 * 5;                % Data sampling size for each cycle
conrodLength=0.232;             %Connecting rod length
crankRadius=0.0725;             %Crank radius
lambda=crankRadius/conrodLength;%Crank to conrod ratio
Vd1=0.00140315;                 %Displacement volume in m^3
Rc=15.4;                        %Compression ratio- effective cr obtained from experiments
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

load 'D:\Post_MatFile\EngineData\HRR.mat'
load 'D:\Post_MatFile\EngineData\EngineData.mat'



for t=1:size(H,2)
    
    for s=1:size(H(t).dQSmo,2)
        H(t).CHR(1:3600,s)=0;
        for u=1700:2100
            H(t).dQSmo1(u,s)=H(t).dQSmo(u,s);
            if H(t).dQSmo1(u,s)<0
                H(t).dQSmo1(u,s)=0.001*abs(H(t).dQSmo1(u,s));
            end
            H(t).CHR(u,s)=H(t).CHR(u-1,s)+H(t).dQSmo1(u,s)*Theta(u,1); %cumulQ is cumulative heat release
            H(t).AVGCHR(u,:) = mean(H(t).CHR(u,1:s),2); % Calculate average Cumulative heat release
        end
    end
    
    %% Calculate the fuel burned rate based on Cumulative heat release
    for xx=1:100
            CA(xx,:) = (xx/100)*max(H(t).CHR(1700:2100,:));
            F(xx).CA_tmp(1700:2100,:) = abs(H(t).CHR(1700:2100,:)-CA(xx,:));
            [H(t).CAV(xx,:) H(t).CA_idx(xx,:)] = min(F(xx).CA_tmp(1700:2100,:),[],1);

            H(t).CA_CAD(xx,:) = (1700+H(t).CA_idx(xx,:))/5-(360-SOI_BTDC); % Crank-Angle degrees duration of % Heat released from Actual SOI
            H(t).MS(xx,:)=H(t).CA_CAD(xx,:)*1000/(RPM*6);                  % Convert the Crank-Angle degreesto milliseconds

            H(t). AvgCA_CAD(xx,:)= mean(H(t).CA_CAD(xx,:),2);
            H(t). AvgMS(xx,:)= mean(H(t).MS(xx,:),2);            
    end
    
    
 %% Calculate the indicated mean effective pressure
        WD= G(t).Smo.*H(t).dV;
        H(t).IMEP=sum(WD,1)/Vd1;  % Indicated mean effective pressure
        H(t). AvgIMEP= mean(H(t).IMEP); % average Indicated mean effective pressure

        [dPValues, dPIIndex] = min(H(t).dPSmo(1760:1800,:),[],1); % calculate the start of ignition timing
        H(t).dPCAD = (1760+dPIIndex)/5-(360-SOI_BTDC); % Crank-Angle degrees based ignition delay time
        H(t).dPMS=H(t).dPCAD*1000/(RPM*6);                  % ignition delay time in milliseconds
        
        H(t).AVGdPMS=mean(H(t).dPMS);
        H(t).dPMS(H(t).dPMS< 0.7*H(t).AVGdPMS)=nan ;
        H(t).dPMS(H(t).dPMS> 1.3*H(t).AVGdPMS)=nan;

        %% Calculate the coefficient of variations
        
    H(t).STDMS=std(H(t).MS,0,2);
    H(t).STDIMEP=std(H(t).IMEP,0,2);
    H(t).STDIDTdP=std(H(t).dPMS(~isnan(H(t).dPMS)),0,2);
    
    for d= 1:100
        H(t).COVIDT(d,:)= H(t).STDMS(d,1)*100./H(t).MS(d,:);
    end
    
    H(t).COVIMEP= H(t).STDIMEP*100./H(t).IMEP;
    H(t).COVIDTdP= H(t).STDIDTdP*100./H(t).dPMS;
    
    IDTCAD(:,t)=H(t). AvgCA_CAD;
    IDTMS(:,t)=H(t). AvgMS;
    IMEP(:,t)= H(t). AvgIMEP;
    dPIDTMS(:,t)=mean(H(t).dPMS(~isnan(H(t).dPMS)));
end

% %filename='\\work\T212\T202_tct\Research\Active_projects\Dual-Tri-Fuel\TriF_LEO1\Tri-Fuel20200104_1'
% matfile = fullfile(myFolder, 'PA2_Day1.mat');
% %save('HVO.mat','D','H','IMEP','IDTMS','IDTCAD','-v7.3')
% save(matfile,'D','H','IMEP','IDTMS','IDTCAD','-v7.3');

MatFolder='D:\Post_MatFile'; % Define the folder to save the mat file. Change the path
SubName= '\EngineData'; % define the subfolder if needed
FullName=mkdir(strcat(MatFolder,SubName)); % create a new folder based on the aforementioned folder
FullMatFileName=fullfile([strcat(MatFolder,SubName),'\CHR_IDT_IMEP_COV.mat']); % define the full name of the mat file
save(FullMatFileName,'H','IMEP','IDTMS','IDTCAD','-v7.3') % save the desired mat data



