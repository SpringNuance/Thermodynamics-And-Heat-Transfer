
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

load 'D:\Post_MatFile\EngineData\EngineData.mat'


%%
%%% Calculate the Heat Release Rate based on Second Law of Thermodynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for t= 1:size(G,2)
    for s=1:size(G(t).Smo,2)
        for c=2:length(Theta) %k=2:length(Pr(i).Theta)
            H(t).dV(c,1)=ComV(c,1)-ComV(c-1,1);
            H(t).dPSmo(c,s)=G(t).Smo(c,s)-G(t).Smo(c-1,s);
            H(t).dQSmo(c,s)=((100000*(1/(gamma-1))*(gamma*G(t).Smo(c,s)*(H(t).dV(c,1)/dtheta)+ComV(c,1)*(H(t).dPSmo(c,s)/dtheta)))); % Check this formula from engine text book or papers
        end
    end
end

MatFolder='D:\Post_MatFile'; % Define the folder to save the mat file. Change the path
SubName= '\EngineData'; % define the subfolder if needed
FullName=mkdir(strcat(MatFolder,SubName)); % create a new folder based on the aforementioned folder
FullMatFileName=fullfile([strcat(MatFolder,SubName),'\HRR.mat']); % define the full name of the mat file
save(FullMatFileName,'H') % save the desired mat data



