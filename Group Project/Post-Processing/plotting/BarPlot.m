%% Define the value

Fuel= xlsread('C:\Users\nguye\Desktop\Thermo\Group Project\Post-Processing\plotting\Project Tasks-20200310.xlsx');

indx= [1 2 3 4 5];


for ii= 1: size(indx,2)
    MaxCHR(indx(ii))= max(SD.D(indx(ii)).AvgOReCHR);
    MaxDeweCHR(indx(ii))= max(SD.D(indx(ii)).AvgDeweCHR);

    EngEff(indx(ii))= MaxCHR(indx(ii))/Fuel(indx(ii),14);
    DeweEngEff(indx(ii))= MaxDeweCHR(indx(ii))/Fuel(indx(ii),14);
    
    
end



vals = [EngEff(indx); DeweEngEff(indx)];

b = bar(indx,vals);

xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

xtips2 = b(2).XEndPoints;
ytips2 = b(2).YEndPoints;
labels2 = string(b(2).YData);
text(xtips2,ytips2,labels2,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

fname = {'PI=1000 bar','PI=1200 bar','PI=1400 bar','PI=1600 bar','PI=1800 bar'}; 
set(gca, 'XTick', 1:length(fname),'XTickLabel',fname);

xlabel('Operating Conditions')
ylabel('Indicative Efficiency')
