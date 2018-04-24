%通用刀具铣削力计算程序，直线走刀时的铣削力计算，仅适用于满刀切
clc
clear
close all

load 20170822 % 实验数据，包含平底刀、R刀、球头刀

%切削力系数
Ktc=796.1 ; %切向作用力系数
Krc=168.8 ; %径向作用力系数
Kac=222 ;  %轴向作用力系数
Kte=27.7 ;  %切向刃口力系数
Kre=30.8 ;  %径向刃口力系数
Kae=1.4 ;  %轴向刃口力系数

%刀具几何
D=16;        %刀具直径mm
beta0=(25/180)*pi; %螺旋角rad
Nt=2;                   %刀具齿数
alpha=0; %锥头倾角rad
gama=0; %锥肩倾角rad
R=3;                    %刀具圆角半径  
Rr=5;  %圆角圆心径长 mm 
Rz=3;  %圆角圆心轴高 mm
Hx=0;  %锥肩螺旋角为定导程，否则取1，定螺旋角
Lead=pi*D/tan(beta0);
%切削方式
operation=1;            %顺铣

%切削参数
% ap = 1;  %轴向切深 mm
ae = 16;  %径向切宽 mm  
speed=800;            %主轴转速 rpm
feed=160;             %进给速度 mm/min

%仿真参数
t=0.1;           %仿真时间 s
dt=0.0001;       %时间步距 s
dz=0.01;        %轴向积分步距 mm

[Time,Fx_1,Fy_1,Fz_1]=CommonForceFull(1,ae,speed,feed,t,dt,dz,D,operation,Nt,R,Rr,Rz,beta0,alpha,gama,Hx,Lead,Ktc,Krc,Kac,Kte,Kre,Kae);
figure(1)
plot(Time,-Fy_1,'b',Time,-Fx_1,'r',Time,Fz_1,'g',Time,Fx_R_1(5040:5039+length(Time)),'b:',Time,Fy_R_1(5040:5039+length(Time)),'r:',Time,Fz_R_1(5040:5039+length(Time)),'g:','Linewidth',2)%由于实验中进给方向为Y方向，与规定的X方向不同，所以X与Y向需要对调
legend('Fx Pre.','Fy Pre.','Fz Pre.','Fx Mea.','Fy Mea.','Fz Mea.')
hold on
plot([0,t], [0,0], '-k');
set(gca,'FontSize', 10.5 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 17 13.53 9.03]);%对应word（13.5,9）
title('\fontsize{10.5}\fontname{宋体}球头刀切削力预测与实测  \fontname{Times New Roman}(\itap\rm=1 mm \itae\rm=16 mm)')
xlabel('\fontsize{10.5}\fontname{Times New Roman}\itt \rm/s')
ylabel('\fontsize{10.5}\fontname{Times New Roman}\itF \rm/N')

[Time,Fx_2,Fy_2,Fz_2]=CommonForceFull(2,ae,speed,feed,t,dt,dz,D,operation,Nt,R,Rr,Rz,beta0,alpha,gama,Hx,Lead,Ktc,Krc,Kac,Kte,Kre,Kae);
figure(2)
plot(Time,-Fy_2,'b',Time,-Fx_2,'r',Time,Fz_2,'g',Time,Fx_R_2(4942:4941+length(Time)),'b:',Time,Fy_R_2(4942:4941+length(Time)),'r:',Time,Fz_R_2(4942:4941+length(Time)),'g:','Linewidth',2)%由于实验中进给方向为Y方向，与规定的X方向不同，所以X与Y向需要对调
legend('Fx Pre.','Fy Pre.','Fz Pre.','Fx Mea.','Fy Mea.','Fz Mea.')
hold on
plot([0,t], [0,0], '-k');
set(gca,'FontSize', 10.5 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 17 13.53 9.03]);%对应word（13.5,9）
title('\fontsize{10.5}\fontname{宋体}球头刀切削力预测与实测  \fontname{Times New Roman}(\itap\rm=2 mm \itae\rm=16 mm)')
xlabel('\fontsize{10.5}\fontname{Times New Roman}\itt \rm/s')
ylabel('\fontsize{10.5}\fontname{Times New Roman}\itF \rm/N')

[Time,Fx_3,Fy_3,Fz_3]=CommonForceFull(3,ae,speed,feed,t,dt,dz,D,operation,Nt,R,Rr,Rz,beta0,alpha,gama,Hx,Lead,Ktc,Krc,Kac,Kte,Kre,Kae);
figure(3)
plot(Time,-Fy_3,'b',Time,-Fx_3,'r',Time,Fz_3,'g',Time,Fx_R_3(4902:4901+length(Time)),'b:',Time,Fy_R_3(4902:4901+length(Time)),'r:',Time,Fz_R_3(4902:4901+length(Time)),'g:','Linewidth',2)%由于实验中进给方向为Y方向，与规定的X方向不同，所以X与Y向需要对调
legend('Fx Pre.','Fy Pre.','Fz Pre.','Fx Mea.','Fy Mea.','Fz Mea.')
hold on
plot([0,t], [0,0], '-k');
set(gca,'FontSize', 10.5 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 17 13.53 9.03]);%对应word（13.5,9）
title('\fontsize{10.5}\fontname{宋体}球头刀切削力预测与实测  \fontname{Times New Roman}(\itap\rm=3 mm \itae\rm=16 mm)')
xlabel('\fontsize{10.5}\fontname{Times New Roman}\itt \rm/s')
ylabel('\fontsize{10.5}\fontname{Times New Roman}\itF \rm/N')

[Time,Fx_4,Fy_4,Fz_4]=CommonForceFull(4,ae,speed,feed,t,dt,dz,D,operation,Nt,R,Rr,Rz,beta0,alpha,gama,Hx,Lead,Ktc,Krc,Kac,Kte,Kre,Kae);
figure(4)
plot(Time,-Fy_4,'b',Time,-Fx_4,'r',Time,Fz_4,'g',Time,Fx_R_4(5086:5085+length(Time)),'b:',Time,Fy_R_4(5086:5085+length(Time)),'r:',Time,Fz_R_4(5086:5085+length(Time)),'g:','Linewidth',2)%由于实验中进给方向为Y方向，与规定的X方向不同，所以X与Y向需要对调
legend('Fx Pre.','Fy Pre.','Fz Pre.','Fx Mea.','Fy Mea.','Fz Mea.')
hold on
plot([0,t], [0,0], '-k');
set(gca,'FontSize', 10.5 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 17 13.53 9.03]);%对应word（13.5,9）
title('\fontsize{10.5}\fontname{宋体}球头刀切削力预测与实测  \fontname{Times New Roman}(\itap\rm=4 mm \itae\rm=16 mm)')
xlabel('\fontsize{10.5}\fontname{Times New Roman}\itt \rm/s')
ylabel('\fontsize{10.5}\fontname{Times New Roman}\itF \rm/N')

[Time,Fx_5,Fy_5,Fz_5]=CommonForceFull(5,ae,speed,feed,t,dt,dz,D,operation,Nt,R,Rr,Rz,beta0,alpha,gama,Hx,Lead,Ktc,Krc,Kac,Kte,Kre,Kae);
figure(5)
plot(Time,-Fy_5,'b',Time,-Fx_5,'r',Time,Fz_5,'g',Time,Fx_R_5(4703:4702+length(Time)),'b:',Time,Fy_R_5(4703:4702+length(Time)),'r:',Time,Fz_R_5(4703:4702+length(Time)),'g:','Linewidth',2)%由于实验中进给方向为Y方向，与规定的X方向不同，所以X与Y向需要对调
legend('Fx Pre.','Fy Pre.','Fz Pre.','Fx Mea.','Fy Mea.','Fz Mea.')
hold on
plot([0,t], [0,0], '-k');
set(gca,'FontSize', 10.5 ,'FontName', 'Times New Roman')
set(gcf,'unit','centimeters','position',[0 17 13.53 9.03]);%对应word（13.5,9）
title('\fontsize{10.5}\fontname{宋体}球头刀切削力预测与实测  \fontname{Times New Roman}(\itap\rm=5 mm \itae\rm=16 mm)')
xlabel('\fontsize{10.5}\fontname{Times New Roman}\itt \rm/s')
ylabel('\fontsize{10.5}\fontname{Times New Roman}\itF \rm/N')