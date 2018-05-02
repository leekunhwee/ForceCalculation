
%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Copyright                           %
%     This code is developed by Jianhui Li     %
%%%%%%%%%%%%%%%%%%%%%%%%%

%% 求解切削力系数，采用线性回归
% 主轴转速为定值6000rpm，改变进给速度，从而实现改变每齿进给量。
clc
clear
close all

load force      % 导入实验切削力数据，为.mat文件，里面存放了5组不同每齿进给量下，1s内的3向切削力数据

t1 = 0;         % 开始时间
t2 = 1;         % 结束时间
r = 0.0001;     % 采样频率
t = t1:r:t2;    

% 注意方向，先将进给方向与参考的X正方向对应，判断此时的测力仪方向与参考方向之间的关系
% 测力仪三向正方向与参考方向对应的要变号，相反的不用变号，因为关注点在刀具，
% 两者是作用力与反作用力之间的关系
% 将测力仪平放，从测力仪尾部向前看，平举右手食指指向自己，拇指、食指，中指互为90度，分别代表测力仪的X、Y、Z的正向

% 本例中，由于测力仪摆放原因，参考X正向为测力仪Y负向，参考Y正向为测力仪X负向，参考Z正向为测力仪Z负向
% 因此无需改变符号，只需对调X和Y


%%   实际操作

% 其实在实际操作中，是取实际测量信号，求得力的平均值
% 这里为了演示方便，用的是计算信号加噪声代替实测信号
% 在以后的切削力实际求解中，应当取实测信号计算力的均值
% 在切削力模型足够精确的情况下，可以得到较为精确的拟合结果
% 然后将拟合后的切削力系数作为该试验条件下的切削力系数
% 所以实际步骤应该是直接导入实验数据计算平均力，然后通过线性回归的方法得到铣削力系数
% 切削力学模型虽然与计算切削力系数的过程并无关系，但其精确建模将是
% 切削力系数识别的意义和前提

% % % % % 定义切削参数
b = 3;                          % axial depth, mm 轴向切削深度
FT = [0.025 0.05 0.075 0.1 0.125];  % feed per tooth values, mm/tooth 每齿进给量阵
% % % % 
% % % % %槽铣
% % % % phis = 0;                       % cut start angle, deg
% % % % phie = 180;                     % cut exit angle, deg
% % % % 
% % % % % 定义刀具参数
% % % % gamma = 45;   % helix angle, deg
% % % % d = 16;                         % cutter diameter, mm
Nt = 2;                         % number of teeth, int 刀具齿数
% % % % omega = 6000;                   % spindle speed, rpm
% % % % 
% % % % mean_Fx = zeros(1, length(FT));%每组实验的平均力值 一共采用了五组进给实验值
% % % % mean_Fy = zeros(1, length(FT));
% % % % mean_Fz = zeros(1, length(FT));
% % % % 
% % % % mean_Fx(1) = mean(Fx_300); % 记录每组在增加噪声后得到的平均力
% % % % mean_Fy(1) = mean(Fy_300);
% % % % mean_Fz(1) = mean(Fz_300);
% % % % 
% % % % mean_Fx(2) = mean(Fx_600); % 记录每组在增加噪声后得到的平均力
% % % % mean_Fy(2) = mean(Fy_600);
% % % % mean_Fz(2) = mean(Fz_600);
% % % % 
% % % % mean_Fx(3) = mean(Fx_900); % 记录每组在增加噪声后得到的平均力
% % % % mean_Fy(3) = mean(Fy_900);
% % % % mean_Fz(3) = mean(Fz_900);
% % % % 
% % % % mean_Fx(4) = mean(Fx_1200); % 记录每组在增加噪声后得到的平均力
% % % % mean_Fy(4) = mean(Fy_1200);
% % % % mean_Fz(4) = mean(Fz_1200);
% % % % 
% % % % mean_Fx(5) = mean(Fx_1500); % 记录每组在增加噪声后得到的平均力
% % % % mean_Fy(5) = mean(Fy_1500);
% % % % mean_Fz(5) = mean(Fz_1500);

% % % figure(1)
% % % plot(tooth_angle, Force_x, 'r:', tooth_angle, Force_y, 'b--', tooth_angle, Force_z, 'k')
% % % axis([0 360 -600 1200])
% % % 
% % % grid on  
% % % 
% % % L1=legend('\fontsize{14}\fontname{Times New Roman}\itF_x ','\fontsize{14}\fontname{Times New Roman}\itF_y ','\fontsize{14}\fontname{Times New Roman}\itF_z ','location','northwest');
% % % set(L1,'Position',[0.47596812596395 0.620708350273608 0.117331854029425 0.269564407316218]);
% % % set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
% % % set(gcf,'unit','centimeters','position',[0 17 13.53 9.03],'color','white');%对应word（13.5,9）
% % % title('\fontsize{14}Cutting Force')
% % % xlabel('\fontsize{14}\fontname{Times New Roman}\it\phi \rm/ °')
% % % ylabel('\fontsize{14}\fontname{Times New Roman}\itF \rm/ N')
% % % hold on

%%
mean_Fx = zeros(1, length(FT));%每组实验的平均力值 一共采用了五组进给实验值
mean_Fy = zeros(1, length(FT));
mean_Fz = zeros(1, length(FT));

mean_Fx(1) = mean(Fx_300); 
mean_Fy(1) = mean(Fy_300);
mean_Fz(1) = mean(Fz_300);

mean_Fx(2) = mean(Fx_600); 
mean_Fy(2) = mean(Fy_600);
mean_Fz(2) = mean(Fz_600);

mean_Fx(3) = mean(Fx_900);
mean_Fy(3) = mean(Fy_900);
mean_Fz(3) = mean(Fz_900);

mean_Fx(4) = mean(Fx_1200);
mean_Fy(4) = mean(Fy_1200);
mean_Fz(4) = mean(Fz_1200);

mean_Fx(5) = mean(Fx_1500); 
mean_Fy(5) = mean(Fy_1500);
mean_Fz(5) = mean(Fz_1500);

figure(1)
plot(t, Fx_300, 'r', t, Fy_300, 'g', t, Fz_300, 'b')
axis([0 0.1 -800 1000])
grid on  
L2=legend('\fontsize{14}\fontname{Times New Roman}\itF_x ','\fontsize{14}\fontname{Times New Roman}\itF_y ','\fontsize{14}\fontname{Times New Roman}\itF_z ','location','northwest');
set(L2,'Position',[0.777119887481565 0.611918206309045 0.117331854029425 0.269564407316218]);
set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 11.8 13.53 9.03],'color','white');%对应word（13.5,9）
title('\fontsize{14}\fontname{Times New Roman}Cutting Force    \itf_c\rm = 0.025mm')
xlabel('\fontsize{14}\fontname{Times New Roman}\itt \rm/ s')
ylabel('\fontsize{14}\fontname{Times New Roman}\itF \rm/ N')

hold on

figure(2)
plot(t, Fx_600, 'r', t, Fy_600, 'g', t, Fz_600, 'b')
axis([0 0.1 -800 1000])
grid on  
L2=legend('\fontsize{14}\fontname{Times New Roman}\itF_x ','\fontsize{14}\fontname{Times New Roman}\itF_y ','\fontsize{14}\fontname{Times New Roman}\itF_z ','location','northwest');
set(L2,'Position',[0.777119887481565 0.611918206309045 0.117331854029425 0.269564407316218]);
set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[14 11.8 13.53 9.03],'color','white');%对应word（13.5,9）
title('\fontsize{14}\fontname{Times New Roman}Cutting Force    \itf_c\rm = 0.05mm')
xlabel('\fontsize{14}\fontname{Times New Roman}\itt \rm/ s')
ylabel('\fontsize{14}\fontname{Times New Roman}\itF \rm/ N')
hold on

figure(3)
plot(t, Fx_900, 'r', t, Fy_900, 'g', t, Fz_900, 'b')
axis([0 0.1 -800 1000])
grid on  
L2=legend('\fontsize{14}\fontname{Times New Roman}\itF_x ','\fontsize{14}\fontname{Times New Roman}\itF_y ','\fontsize{14}\fontname{Times New Roman}\itF_z ','location','northwest');
set(L2,'Position',[0.777119887481565 0.611918206309045 0.117331854029425 0.269564407316218]);
set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 0.6 13.53 9.03],'color','white');%对应word（13.5,9）
title('\fontsize{14}\fontname{Times New Roman}Cutting Force    \itf_c\rm = 0.075mm')
xlabel('\fontsize{14}\fontname{Times New Roman}\itt \rm/ s')
ylabel('\fontsize{14}\fontname{Times New Roman}\itF \rm/ N')
hold on

figure(4)
plot(t, Fx_1200, 'r', t, Fy_1200, 'g', t, Fz_1200, 'b')
axis([0 0.1 -800 1000])
grid on  
L2=legend('\fontsize{14}\fontname{Times New Roman}\itF_x ','\fontsize{14}\fontname{Times New Roman}\itF_y ','\fontsize{14}\fontname{Times New Roman}\itF_z ','location','northwest');
set(L2,'Position',[0.777119887481565 0.611918206309045 0.117331854029425 0.269564407316218]);
set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[14 0.6 13.53 9.03],'color','white');%对应word（13.5,9）
title('\fontsize{14}\fontname{Times New Roman}Cutting Force    \itf_c\rm = 0.1mm')
xlabel('\fontsize{14}\fontname{Times New Roman}\itt \rm/ s')
ylabel('\fontsize{14}\fontname{Times New Roman}\itF \rm/ N')
hold on

figure(5)
plot(t, Fx_1500, 'r', t, Fy_1500, 'g', t, Fz_1500, 'b')
axis([0 0.1 -800 1000])
grid on  
L2=legend('\fontsize{14}\fontname{Times New Roman}\itF_x ','\fontsize{14}\fontname{Times New Roman}\itF_y ','\fontsize{14}\fontname{Times New Roman}\itF_z ','location','northwest');
set(L2,'Position',[0.777119887481565 0.611918206309045 0.117331854029425 0.269564407316218]);
set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[28 0.6 13.53 9.03],'color','white');%对应word（13.5,9）
title('\fontsize{14}\fontname{Times New Roman}Cutting Force    \itf_c\rm = 0.125mm')
xlabel('\fontsize{14}\fontname{Times New Roman}\itt \rm/ s')
ylabel('\fontsize{14}\fontname{Times New Roman}\itF \rm/ N')
hold on

% n为实验组数 

% linear regression，线性回归
n = length(FT);  
a1x = (n*sum(FT.*mean_Fx) - sum(FT)*sum(mean_Fx))/(n*sum(FT.^2) - (sum(FT))^2);
a0x = mean(mean_Fx) - a1x*mean(FT);

Ktc_fit = 4*a1x/(Nt*b)              %最终计算的系数
Kte_fit = pi*a0x/(Nt*b)

a1y = (n*sum(FT.*mean_Fy) - sum(FT)*sum(mean_Fy))/(n*sum(FT.^2) - (sum(FT))^2);
a0y = mean(mean_Fy) - a1y*mean(FT);
Krc_fit = -4*a1y/(Nt*b)
Kre_fit = -pi*a0y/(Nt*b)
% 公式参考Altintas的《Manufacturing Automation》 P47
% 由于此处X与Y方向互换，所以公式中的系数相应更改

a1z = (n*sum(FT.*mean_Fz) - sum(FT)*sum(mean_Fz))/(n*sum(FT.^2) - (sum(FT))^2);
a0z = mean(mean_Fz) - a1z*mean(FT);
Kac_fit = pi*a1z/(Nt*b)
Kae_fit = 2*a0z/(Nt*b)

figure(6)
plot(FT, mean_Fx, 'ro', FT, mean_Fy, 'gs', FT, mean_Fz, 'b^')
hold on
% axis([0 0.3 -125 525])
% xlabel('f_t (mm/tooth)')
% ylabel('Mean Force (N)')
% best fit lines
plot(FT, a0x+a1x*FT, 'r', FT, a0y+a1y*FT, 'g', FT, a0z+a1z*FT, 'b')

grid on  
L3=legend('\fontsize{14}\fontname{Times New Roman}\itx ','\fontsize{14}\fontname{Times New Roman}\ity ','\fontsize{14}\fontname{Times New Roman}\itz ','location','northwest');
set(L3,'Position',[0.790098857533526 0.686580607467004 0.0976562494761311 0.208211137926823]);
set(gca,'FontSize', 14 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[28 11.8 13.53 9.03],'color','white');%对应word（13.5,9）
title('\fontsize{14}Average Cutting Force')
xlabel('\fontsize{14}\fontname{Times New Roman}\it f_t \rm/ mm·tooth^{-1}')
ylabel('\fontsize{14}\fontname{Times New Roman}\itFm \rm/ N')

% coefficients of determination 评价线性回归的好坏
rx2 = (sum((mean_Fx - mean(mean_Fx)).^2) - sum((mean_Fx - a0x - a1x*FT).^2))/(sum((mean_Fx - mean(mean_Fx)).^2)) %评价线性回归好坏的系数
ry2 = (sum((mean_Fy - mean(mean_Fy)).^2) - sum((mean_Fy - a0y - a1y*FT).^2))/(sum((mean_Fy - mean(mean_Fy)).^2))
rz2 = (sum((mean_Fz - mean(mean_Fz)).^2) - sum((mean_Fz - a0z - a1z*FT).^2))/(sum((mean_Fz - mean(mean_Fz)).^2))
