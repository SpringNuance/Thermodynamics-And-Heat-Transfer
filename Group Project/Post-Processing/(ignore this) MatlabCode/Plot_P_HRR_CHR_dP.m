RPM=1200;
dtheta=0.2;
K1=340:0.2:420;

BTDC=7;
InjDur=0.256;
SOI= 360-BTDC;
EOI= 360-BTDC+(RPM*360/60000)*InjDur;

SOI1= 360-BTDC+3;
EOI1= 360-BTDC+(RPM*360/60000)*InjDur+3;

indx= [1 2 3 4 5];


RGB= [1 0 0;0 1 0;0 0 1;0.8 0 0.5;0 0 0;0 1 1;0.5 0 0;0.5 0.5 0;0.5 0.5 0.5;0.5 0 0.5;1 0.5 0;1 0.5 0.5]; % Define the color for the curves

Marker= ['d' '*' 's' 'x' 'h' 'p' 'o']; % Define the Marker
Legend={'Pilot-2%','Pilot-3%','Pilot-5%','Pilot-8%','Pilot-10%'}; % Define the legend


sz=10;

load 'D:\Post_MatFile\EngineData\HRR.mat'
load 'D:\Post_MatFile\EngineData\EngineData.mat'
load 'D:\Post_MatFile\EngineData\CHR_IDT_IMEP_COV.mat'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f(1)=figure('position',[200 100 800 600])


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Filtered Pressure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iii=1:size(indx,2)
    for c=1700:2100
        H(indx(iii)).AdPSmo(c,:)=mean(G(indx(iii)).Smo(c,:)-G(indx(iii)).Smo(c-1,:));
    end
    pp1=plot(K1,H(indx(iii)).AdPSmo(1700:2100,:)/dtheta,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on
    p1=plot(K1,H(indx(iii)).dPSmo(1700:2100,:)/dtheta,'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on

    for cc=1:size(H(indx(iii)).dPSmo,2)
        p1(cc).Color(4)=0.01;
    end
end

ax1 = gca;
set(gca,'position',[0.1 0.1 0.8 0.4])
yyaxis(ax1,'left')
ax1.XColor = 'k';
ax1.YColor = 'k';

%xlabel('Crank Angle [Degree]');
ylabel('dP/d{\theta} [bar/CA]')
ax1.YTick=-4:2:6;
ax1.YLim=[-4 6];
% ax1.YTick=-8:2:8;
% ax1.YLim=[-8 8];
xlabel('Crank Angle [CA]');
ax1.LineWidth = 1;
ax1.FontSize=12;
box on
hold on

ax2=gca;
yyaxis(ax2,'right')


for iii=1:size(indx,2)
    pp2=plot(K1,mean(G(indx(iii)).Smo(1700:2100,:),2),'color',RGB(iii,:),'LineStyle','-.','LineWidth',1, 'Marker', 'none');
    hold on
    p2=plot(K1,G(indx(iii)).Smo(1700:2100,:),'color',RGB(iii,:),'LineStyle','-.','LineWidth',1, 'Marker', 'none');
    hold on
    for dd=1:size(H(indx(iii)).dPSmo,2)
        p2(dd).Color(4)=0.01;
    end
end

line('XData', [SOI SOI  EOI EOI], 'YData', [0 60 60 0], 'LineWidth', 2,'LineStyle', '-.', 'Color', [0 0.6 0]);
hold on
% l1=line([(1700+mean(H(indx(iii)).CA_idx(5,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(5,:),2))/5],[0 120 ],'LineWidth', 1,'LineStyle', '-.', 'Color', 'g')
% hold on
% l2=line([(1700+mean(H(indx(iii)).CA_idx(2,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(2,:),2))/5],[0 120 ],'LineWidth', 1,'LineStyle', '-.', 'Color', 'r')
% hold on
% l3=line([(1760+mean(H(indx(iii)).dPIIndex(1,:),2))/5 (1760+mean(H(indx(iii)).dPIIndex(1,:),2))/5],[0 120 ],'LineWidth', 1,'LineStyle', '-.', 'Color', 'b')

%legend([l1 l2 l3],'CA5-Based IDT','CA2-Based IDT','dP/d{\theta}-Based IDT','Location','northeast')
ax2.XColor = 'k';
ax2.YColor = 'k';

%xlabel('Crank Angle [Degree]');
ylabel('Cylinder Pressure [bar]')
ax2.YTick=0:20:160;
ax2.YLim=[0 160];

ax2.LineWidth = 1;
ax2.XTick=340:10:420;
ax2.XMinorTick='on'
ax2.XLim=[340 420];
ax2.FontSize=12
box on
hold on

ax3_pos = ax1.Position+[0 0.4 0 0]; % position of first axes
ax3 = axes('Position',ax3_pos,...
    'XAxisLocation','origin',...
    'YAxisLocation','right',...
    'Color','w');
ax3=gca;
yyaxis(ax3,'left')

for iii=1:size(indx,2)

    pp3=plot(K1,mean(H(indx(iii)).dQSmo(1700:2100,:),2),'color',RGB(iii,:),'LineStyle','-.','LineWidth',1, 'Marker', 'none');
    hold on
    p3=plot(K1,H(indx(iii)).dQSmo(1700:2100,:),'color',RGB(iii,:),'LineStyle','-.','LineWidth',1, 'Marker', 'none');
    hold on
    for ee=1:size(H(indx(iii)).dPSmo,2)
        p3(ee).Color(4)=0.01;
    end

    line([(1700+mean(H(indx(iii)).CA_idx(50,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(50,:),2))/5],[-20 200 ],'LineWidth', 0.8,'LineStyle', '-.', 'Color', RGB(iii,:));
    hold on
    line([(1700+mean(H(indx(iii)).CA_idx(90,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(90,:),2))/5],[-20 200 ],'LineWidth', 0.8,'LineStyle', '-.', 'Color', RGB(iii,:)*0.4);
    hold on
    line([(1700+mean(H(indx(iii)).CA_idx(5,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(5,:),2))/5],[-20 200 ],'LineWidth', 0.8,'LineStyle', '-.', 'Color', RGB(iii,:)*0.4);
end

% line('XData', [SOI SOI  EOI EOI], 'YData', [-40 200 200 -40], 'LineWidth', 2,'LineStyle', '-.', 'Color', [0 0.6 0]);
% hold on
%  line([(1700+mean(H(indx(iii)).CA_idx(50,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(50,:),2))/5],[-20 200 ],'LineWidth', 1,'LineStyle', '-.', 'Color', 'g')
%  hold on
%  line([(1700+mean(H(indx(iii)).CA_idx(90,:),2))/5 (1700+mean(H(indx(iii)).CA_idx(90,:),2))/5],[-20 200 ],'LineWidth', 1,'LineStyle', '-.', 'Color', 'r')
%  hold on
%  line([(1760+mean(H(indx(iii)).dPIIndex(1,:),2))/5 (1760+mean(H(indx(iii)).dPIIndex(1,:),2))/5],[-20 200 ],'LineWidth', 1,'LineStyle', '-.', 'Color', 'b')

text(351,80,'IDT \rightarrow','color','b','FontSize',10);
text(364,100,'CA50 \rightarrow','color','b','FontSize',10);
text(375,120,'CA90 \rightarrow','color','b','FontSize',10);

ax3.XColor = 'none';
ax3.YColor = 'k';

%xlabel('Crank Angle [Degree]');
ylabel('aHRR [J/CAD]')
ax3.YTick=0:40:200;
ax3.YLim=[-20 200];
ax3.LineWidth = 1;
ax3.XTick=[];
ax3.FontSize=12
hold on


ax4=gca;
yyaxis(ax4,'right')

for iii=1:size(indx,2)

    pp4(:,iii)=plot(K1,H(indx(iii)).AVGCHR(1700:2100,:),'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on
    p4=plot(K1,H(indx(iii)).CHR(1700:2100,:),'color',RGB(iii,:),'LineStyle','-','LineWidth',1, 'Marker', 'none');
    hold on

    for cc=1:size(H(indx(iii)).dPSmo,2)

        p4(cc).Color(4)=0.01;

    end

end
line('XData', [SOI SOI  EOI EOI], 'YData', [0 5e4 5e4 0], 'LineWidth', 2,'LineStyle', '-.', 'Color', [0 0.6 0]);
hold on
hLegend=legend([pp4(:,1:iii)],Legend,'NumColumns',5,'fontsize',7,'Position',[0.45 0.92 0.15 0.06]);

hold on

ax4.XColor = 'k';
ax4.YColor = 'k';

ylabel('Cumulative Heat Release [J]')
ax4.YTick=1.5e4:1.5e4:1.5e5;
ax4.YLim=[0 1.5e5];
ax4.LineWidth = 1;
ax4.XTick=[];
ax4.FontSize=12;



box on
hold on

% path='D:\Dual9';
% status=mkdir([path,sprintf('%2d',1)]);
% filename = sprintf('LambdaPressure%2d.png', 1);
% print(gcf, fullfile([path,sprintf('%2d',1)], filename), '-dpng','-r300')



