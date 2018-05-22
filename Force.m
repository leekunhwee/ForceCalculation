
%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Copyright                        %
%     This code is developed by Jianhui Li    %
%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
close all

%切削力系数
Ktc=958.8599 ; %切向作用力系数
Krc=250.8633 ; %径向作用力系数
Kte=15.7580  ; %切向刃口力系数
Kre=19.4337  ; %径向刃口力系数
Kac=146.3614 ; %轴向作用力系数
Kae=18.2075  ; %轴向刃口力系数

%切削方式
operation=1;  %顺铣

%刀具几何
df=25;        %刀具直径
beta=1/4*pi;  %螺旋角
Nt=2;         %刀具齿数
phip=2*pi/Nt; %刀具齿间角

%切削参数
axis_immersion = 3;  %a轴向切深 mm
radial_immersion = 25;%切宽 /mm
speed=6000;          %主轴转速 rpm
feed=900;            %进给速度 mm/min
c=feed/Nt/speed;     %c进给率 mm/齿
phis = acos((df/2 - radial_immersion)/(df/2));  % (rad) the absolute angle of cutting 浸入角度
if operation == 0
    phist = 0;       % rad 逆铣          %切入角
    phiex = phist + phis;                  %切出角
else
    phiex = pi;      % rad 顺铣
    phist = phiex - phis;
end

%仿真参数
t=0.1;          %仿真时间 s
rotation=speed/60*t; %旋转圈数
step_r=0.01;    %角积分步距
step_b=0.01;    %轴向积分步距
K=2*pi*rotation/step_r ;  %角向积分步数
L=axis_immersion/step_b ; %轴向积分步数


Fx=zeros(1,floor(K));%floor 向下取整
Fy=zeros(1,floor(K));
Fz=zeros(1,floor(K));
Ft=zeros(1,floor(K));

Fk=zeros(1,floor(K));
T=zeros(1,floor(K));
step_h=zeros(1,length(L));%
phi_i =zeros(1,floor(K));
Time=zeros(1,floor(K));

for m=1:floor(K)
    phi_i(m)=phist+(m-1)*step_r;    %螺旋槽底部刃的接触角
    while phi_i(m)>2*pi
        phi_i(m)=phi_i(m)-2*pi;%循环
    end
    for i=1:Nt                      %第i个齿
        R1=phi_i(m)+(i-1)*phip;
        R2=R1;

        for j=1:L                               %第i个齿上的第j个轴向微元
            step_h(j)=(j-1)*step_b;             %第j个轴向微元的轴向高度
            R2=R1-2*tan(beta)/df*step_h(j);     %更新因螺旋槽引起的接触角变化
            
            if R2>2*pi
                R2=R2-2*pi;             %第i个刀齿上第j个微元的实际接触角度
            end
            
            if  phist<=R2&&R2<=phiex    %判断刀齿微元是否参与切削
                h=c*sin(R2);            %瞬时切削厚度与每齿进给量之间的关系
                
                ft=step_b*(Ktc*h+Kte);  %切向力微元
                fr=step_b*(Krc*h+Kre);  %径向力微元
                fa=step_b*(Kac*h+Kae);  %轴向力微元
                
                fy=-ft*cos(R2)-fr*sin(R2);
                fx=ft*sin(R2)-fr*cos(R2);
                fz=fa;
                
                Fx(m)=Fx(m)+fx;
                Fy(m)=Fy(m)+fy;
                Fz(m)=Fz(m)+fz;
                Ft(m)=Ft(m)+ft;
                
            end
        end%next j 下一个微元
    end%next i 下一个刀齿
Fk(m)=sqrt(Fx(m)^2+Fy(m)^2+Fz(m)^2); %切削合力
T(m)=df/2*Ft(m)/1e3 ; %切削力矩
Time(m)=(m-1)*t/floor(K);
end%next m 下一时刻的参考转角
plot(Time,Fx,'r')
hold on
plot(Time,Fy,'g')
hold on
plot(Time,Fz,'b')
hold on
% plot(Time,Fk,'k')
% hold on
% plot(Time,T,'m')
% hold on
legend('Fx','Fy','Fz')
