RPM=1200;
dtheta=0.2;
K1=(340:0.2:400)';


indx= [1 2 3 4 5];

RGB= [1 0 0;0 1 0;0 0 1;0.8 0 0.5;0 0 0;0 1 1;0.5 0 0;0.5 0.5 0;0.5 0.5 0.5;0.5 0 0.5;1 0.5 0;1 0.5 0.5]; % Define the color for the curves

Marker= ['d' '*' 's' 'x' 'h' 'p' 'o']; % Define the Marker
Legend={'Pilot-2%','Pilot-3%','Pilot-5%','Pilot-8%','Pilot-10%'}; % Define the legend


sz=10;

% load 'D:\Post_MatFile\EngineData\HRR.mat'
% load 'D:\Post_MatFile\EngineData\EngineData.mat'
% load 'D:\Post_MatFile\EngineData\CHR_IDT_IMEP_COV.mat'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f(1)=figure('position',[200 100 800 600])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Filtered Pressure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iii=1:size(indx,2)
    SD.D(indx(iii)).EffCylPre = SD.D(indx(iii)).CylPre(1700:2000,:);
    SD.D(indx(iii)).AvgPre = mean(SD.D(indx(iii)).EffCylPre,2);


    pp1=plot(K1,SD.D(indx(iii)).AvgPre,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on
    p1=plot(K1,SD.D(indx(iii)).EffCylPre,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on

    for cc=1:size(SD.D(indx(iii)).EffCylPre,2)
        p1(cc).Color(4)=0.01;
    end

end

ax1 = gca;
set(gca,'position',[0.1 0.1 0.8 0.38])
yyaxis(ax1,'left')
ax1.XColor = 'k';
ax1.YColor = 'k';

%xlabel('Crank Angle [Degree]');
ylabel('Raw Pressure [bar]')
ax1.YTick=0:20:120;
ax1.YLim=[0 120];
% ax1.YTick=-8:2:8;
% ax1.YLim=[-8 8];
xlabel('Crank Angle [CA]');
ax1.LineWidth = 1;
ax1.FontSize=12;
box on
hold on

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Pressure Rise Rate

ax2=gca;
yyaxis(ax2,'right')


for iii=1:size(indx,2)

    SD.D(indx(iii)).EffInjCur = SD.D(indx(iii)).InjCur(:,1700:2000)';
    SD.D(indx(iii)).AvgInjCur = mean(SD.D(indx(iii)).EffInjCur,2);

    Inj1= plot(K1,SD.D(indx(iii)).AvgInjCur,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on
    Injj1= plot(K1,SD.D(indx(iii)).EffInjCur,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');

    for cc=1:size(SD.D(indx(iii)).EffInjCur,2)
        Injj1(cc).Color(4)=0.01;
    end

end


ax2.XColor = 'k';
ax2.YColor = 'k';

%xlabel('Crank Angle [Degree]');
ylabel('Injection Current [A]')
ax2.YTick=0:20:100;
ax2.YLim=[0 100];

ax2.LineWidth = 1;
ax2.XTick=340:10:400;
ax2.XMinorTick='on'
ax2.XLim=[340 400];
ax2.FontSize=12
box on
hold on

ax3_pos = ax1.Position+[0 0.44 0 0]; % position of first axes
ax3 = axes('Position',ax3_pos,...
    'XAxisLocation','origin',...
    'YAxisLocation','left',...
    'Color','w');


yyaxis(ax3,'left')

for iii=1:size(indx,2)

    SD.D(indx(iii)).EffHRR = SD.D(indx(iii)).dQSmo(1700:2000,:);
    SD.D(indx(iii)).AvgHRR = mean(SD.D(indx(iii)).EffHRR,2);

    SD.D(indx(iii)).DeweHRR = SD.D(indx(iii)).HRR(:,1700:2000)';
    SD.D(indx(iii)).AvgDeweHRR = mean(SD.D(indx(iii)).DeweHRR,2);


    pp1=plot(K1,SD.D(indx(iii)).AvgHRR,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on
    p1=plot(K1,SD.D(indx(iii)).EffHRR,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on

    dd1=plot(K1,SD.D(indx(iii)).AvgDeweHRR,'color',RGB(iii,:),'LineStyle','--','LineWidth',1, 'Marker', 'none');
    hold on
    d1=plot(K1,SD.D(indx(iii)).DeweHRR,'color',RGB(iii,:),'LineStyle','--','LineWidth',1, 'Marker', 'none');
    hold on

    for cc=1:size(SD.D(indx(iii)).EffHRR,2)
        p1(cc).Color(4)=0.01;
        d1(cc).Color(4)=0.01;
    end

end

ax3.XColor = 'none';
ax3.YColor = 'k';

%xlabel('Crank Angle [Degree]');
ylabel('Heat Release Rate [J/CA]')
ax3.YTick=-20:40:240;
ax3.YLim=[-20 240];
ax3.LineWidth = 1;
ax3.XTick=[];
ax3.FontSize=12;


hold on

ax4=gca;
yyaxis(ax4,'right')

for iii=1:size(indx,2)

    SD.D(indx(iii)).EffInjCur = SD.D(indx(iii)).InjCur(:,1700:2000)';
    SD.D(indx(iii)).AvgInjCur = mean(SD.D(indx(iii)).EffInjCur,2);

    Inj1(:,iii)= plot(K1,SD.D(indx(iii)).AvgInjCur,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on
    Injj1= plot(K1,SD.D(indx(iii)).EffInjCur,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');

    for cc=1:size(SD.D(indx(iii)).EffInjCur,2)
        Injj1(cc).Color(4)=0.01;
    end

end

hold on
hLegend=legend([Inj1(:,1:iii)],Legend,'NumColumns',5,'fontsize',10,'Position',[0.25 0.93 0.5 0.06]);

hold on




ax4.XColor = 'k';
ax4.YColor = 'k';

ylabel('Injection Current [A]')
ax4.YTick=0:20:100;
ax4.YLim=[0 100];
ax4.LineWidth = 1;
ax4.XTick=[];
ax4.FontSize=12;

box on


path='\\home.org.aalto.fi\chengq1\data\Desktop\Engine Study';
status=mkdir([path,sprintf('%2d',1)]);
filename = sprintf('LambdaPressure%2d.png', 1);
print(gcf, fullfile([path,sprintf('%2d',1)], filename), '-dpng','-r300')



