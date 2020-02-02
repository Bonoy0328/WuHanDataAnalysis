function [] = WuHanDataAnalysisFun(dataDir,forecastDays)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%读取数据
[NUM,TXT,RAW] = xlsread(dataDir);
%%对于位置数据做插值处理
%step1,重症，死亡，治愈subBad subDied subGod
days = size(NUM,1);
fordays = forecastDays;
Had = fliplr(NUM(:,1)');
Bad = fliplr(NUM(:,2)');
Died = fliplr(NUM(:,3)');
God = fliplr(NUM(:,4)');
%重症患者
figure 
subBad = [Bad(1:11),Bad(13),Bad(15:days)];
subBadX = [1:11,13,15:days];
subplot(2,1,1)
plot(subBadX,subBad);
hold on
plot(subBadX,subBad,'g^')
fitX = 1:0.01:days;
P = polyfit(subBadX,subBad,5);
fitBad = polyval(P,fitX);
plot(fitX,fitBad,'r--');
Bad(12) = round(polyval(P,12));
Bad(14) = round(polyval(P,14));
Bad(2,:) = round(polyval(P,[1:days]));
plot([12,14],[Bad(1,12),Bad(1,14)],'r^')
max = 0;
for i = 1:1:fordays
    plot(days+i,round(polyval(P,days+i)),'mo','MarkerSize',10,'LineWidth',3);
    text(days-5+i,round(polyval(P,days+i)),strcat('No.',num2str(round(polyval(P,days+i)))));
    if(round(polyval(P,days+i)) > max)
        max = round(polyval(P,days+i));
    end
end
% text(days-4,round(polyval(P,days+1)),strcat('今天:',num2str(round(polyval(P,days+1)))))
% text(days-3,round(polyval(P,days+2)),strcat('明天:',num2str(round(polyval(P,days+2)))))
% text(days-2,round(polyval(P,days+3)),strcat('后天:',num2str(round(polyval(P,days+3)))))
grid on
MSE_Bad = sum((Bad(1,:) - Bad(2,:)).^2)/days;
RMSE_Bad = sqrt(MSE_Bad)
text(10,750,strcat('RMSE=',num2str(RMSE_Bad)))
legend('数据曲线','数据点','拟合曲线','拟合数据点','Location','NorthWest')
xlabel('日期')
ylabel('人数')
set(gca,'Ylim',[0,max*1.1],'XTick',0:days+fordays+1,'Xlim',[0,days+fordays+1],'NextPlot','replacechildren')
title('重症患者')
%治愈患者
subGod = [God(1:13),God(16:days)];
subGodX = [1:13,16:days];
subplot(2,1,2)
plot(subGodX,subGod);
hold on
plot(subGodX,subGod,'g^');
P = polyfit(subGodX,subGod,6);
fitGod = polyval(P,fitX);
plot(fitX,fitGod,'r--');
God(14) = round(polyval(P,14));
God(15) = round(polyval(P,15));
God(2,:) = round(polyval(P,[1:days]));
plot([14,15],[God(1,14),God(1,15)],'r^')
max = 0;
for i = 1:1:fordays
    plot(days+i,round(polyval(P,days+i)),'mo','MarkerSize',10,'LineWidth',3);
    text(days-5+i,round(polyval(P,days+i)),strcat('No.',num2str(round(polyval(P,days+i)))));
    if(round(polyval(P,days+i)) > max)
        max = round(polyval(P,days+i));
    end
end
MSE_God = sum((God(1,:) - God(2,:)).^2)/days;
RMSE_God = sqrt(MSE_God)
text(10,75,strcat('RMSE=',num2str(RMSE_God)))
legend('数据曲线','数据点','拟合曲线','拟合数据点','Location','NorthWest')
xlabel('日期')
ylabel('人数')
set(gca,'Ylim',[0,max*1.1],'XTick',0:days+fordays+1,'Xlim',[0,days+fordays+1],'NextPlot','replacechildren')
title('治愈患者')
% text(days-4,round(polyval(P,days+1)),strcat('今天:',num2str(round(polyval(P,days+1)))))
% text(days-3,round(polyval(P,days+2)),strcat('明天:',num2str(round(polyval(P,days+2)))))
% text(days-2,round(polyval(P,days+3)),strcat('后天:',num2str(round(polyval(P,days+3)))))
grid on
%确诊人数
figure
subplot(2,1,1)
X = 1:days;
plot(X,Had)
hold on
plot(X,Had,'g^')
P = polyfit(X,Had,6);
fitHad = polyval(P,fitX);
Had(2,:) = round(polyval(P,[1:days]));
MSE_Had = sum((Had(1,:) - Had(2,:)).^2)/days;
RMSE_Had = sqrt(MSE_Had)
text(10,5000,strcat('RMSE=',num2str(RMSE_Had)))
plot(fitX,fitHad,'r--');
max = 0;
for i = 1:1:fordays
    plot(days+i,round(polyval(P,days+i)),'mo','MarkerSize',10,'LineWidth',3);
    text(days-5+i,round(polyval(P,days+i)),strcat('No.',num2str(round(polyval(P,days+i)))));
    if(round(polyval(P,days+i)) > max)
        max = round(polyval(P,days+i));
    end
end
title('确诊人数')
grid on
legend('数据曲线','数据点','拟合曲线','Location','NorthWest')
xlabel('日期')
ylabel('人数')
% text(days-5,round(polyval(P,days+1)),strcat('今天:',num2str(round(polyval(P,days+1)))))
% text(days-4,round(polyval(P,days+2)),strcat('明天:',num2str(round(polyval(P,days+2)))))
% text(days-3,round(polyval(P,days+3)),strcat('后天:',num2str(round(polyval(P,days+3)))))
set(gca,'Ylim',[0,max*1.1],'XTick',0:days+fordays+1,'Xlim',[0,days+fordays+1],'NextPlot','replacechildren')

%死亡人数
subplot(2,1,2)
plot(X,Died)
hold on
plot(X,Died,'g^')
P = polyfit(X,Died,6);
fitDied = polyval(P,fitX);
Died(2,:) = round(polyval(P,[1:days]));
MSE_Died = sum((Died(1,:) - Died(2,:)).^2)/days;
RMSE_Died = sqrt(MSE_Died)
text(10,200,strcat('RMSE=',num2str(RMSE_Died)))
plot(fitX,fitDied,'r--');
max = 0;
for i = 1:1:fordays
    plot(days+i,round(polyval(P,days+i)),'mo','MarkerSize',10,'LineWidth',3);
    text(days-4+i,round(polyval(P,days+i)),strcat('No.',num2str(round(polyval(P,days+i)))))
    if(round(polyval(P,days+i)) > max)
        max = round(polyval(P,days+i));
    end
end
title('死亡人数')
grid on
legend('数据曲线','数据点','拟合曲线','Location','NorthWest')
xlabel('日期')
ylabel('人数')
% text(days-4,round(polyval(P,days+1)),strcat('今天:',num2str(round(polyval(P,days+1)))))
% text(days-3,round(polyval(P,days+2)),strcat('明天:',num2str(round(polyval(P,days+2)))))
% text(days-2,round(polyval(P,days+3)),strcat('后天:',num2str(round(polyval(P,days+3)))))
set(gca,'Ylim',[0,max*1.1],'XTick',0:days+fordays+1,'Ylim',[0,700],'Xlim',[0,days+fordays+1],'NextPlot','replacechildren')

%日死亡率，日死亡人数/日确诊人数
HadOneDay = Had(1,5:days) - Had(1,4:days-1);
DiedOneDay = Died(1,5:days) - Died(1,4:days-1);
DiedRateDay = DiedOneDay./HadOneDay.*100;
figure
subplot(2,1,1)
bar([5:days],DiedRateDay)
hold on
plot([5:days],DiedRateDay,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
grid on
xlabel('Days')
ylabel('%')
title('日死亡率')
set(gca,'XTick',0:days+2,'Xlim',[0,days+2],'NextPlot','replacechildren')
%累计死亡率
DiedRate = (Died(1,:).*100)./Had(1,:);
subplot(2,1,2)
bar([1:days],DiedRate);
hold on
plot([1:days],DiedRate,'--gs',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5])
grid on
xlabel('Days')
ylabel('%')
title('累计死亡率')
set(gca,'XTick',0:days+2,'Xlim',[0,days+2],'NextPlot','replacechildren')


end

