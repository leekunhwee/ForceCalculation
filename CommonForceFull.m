function [Time,Fx,Fy,Fz]=CommonForceFull(ap,ae,speed,feed,t,dt,dz,D,operation,Nt,R,Rr,Rz,beta0,alpha,gama,Hx,Lead,Ktc,Krc,Kac,Kte,Kre,Kae)
%%通用刀具铣削力计算程序，直线走刀时的铣削力计算，适用于满刀切
% 锥头与圆弧部分交点M
Mr = (Rz*tan(alpha)+Rr)/(((tan(alpha))^2)+1);
if alpha >= 0
    Mz = Mr*tan(alpha);
else
    Mz =-Mr*tan(alpha);
end
%圆弧与锥肩部分交点N
u  = (D/2)*(1-tan(alpha)*tan(gama));
Nz = ((Rr-u)*tan(gama)+Rz)/(((tan(gama))^2)+1);
Nr = u +Nz*tan(gama);

% 切削角度
phis = acos((D/2 - ae)/(D/2));  % (rad) the absolute angle of cutting 刀具浸入角度
if operation == 0             %逆铣 
    phist = 0;                %切入角 rad
    phiex = phist + phis;     %切出角 rad
else                          %顺铣
    phiex = pi;               %切出角 rad
    phist = phiex - phis;     %切入角 rad
end   
%切削参数
phip=2*pi/Nt;         %刀具齿间角 rad
c =  feed/Nt/speed;   %c进给率 mm/齿                                     
%仿真参数
K = t/dt ;         %角向积分步数
L = ap/dz ;        %轴向积分步数
%初始化
F  = zeros(floor(K),1);    %总切削力
phi= zeros(floor(K),1);  %位置角
Fx = zeros(floor(K),1);   
Fy = zeros(floor(K),1);
Fz = zeros(floor(K),1);   %X、Y、Z三方向的合力
Ft = zeros(floor(K),1);   %总切向力
Fr = zeros(floor(K),1);   %总法向力
Fa = zeros(floor(K),1);   %总轴向力
T  = zeros(floor(K),1);    %切削力矩
Time=zeros(floor(K),1); %时间序列
%刀具旋转循环开始
for i=1:floor(K)        %刀具第i步旋转
    phi(i)=phist+(i-1)*2*pi*speed*dt/60;%计算第i步刀具第一个刀齿端部的角位置
    %刀具刀齿循环开始
    for k=1:Nt%第k个刀具
        phi1=phi(i)+(k-1)*phip;            %计算第k个刀齿端部的角位置
        %刀齿上切削刃微元循环开始
        for j=1:L   %第k个刀具上的第j个微元
            Zj=j*dz;    %第j个微元的轴向高度,注意对于球头刀Zp不能为零，否则会使得dS计算时除零错误
            if alpha >0 && R>0    %针对锥头突出，且有圆弧部分的情况（通用立铣刀）
                rs=Mr/20;
                %定义几个分界点滞后角
                phi1s=log(rs)*tan(beta0)/cos(alpha); % 锥头部滞后角初始值
                phi1e=log(Mr)*tan(beta0)/cos(alpha)-phi1s; % 锥头部最终滞后角
                phias= (R+Mz-Rz)*tan(beta0)/R;%圆弧部分滞后角初始值
                phiae= (R+Nz-Rz)*tan(beta0)/R-phias+phi1e;%圆弧部分滞后角最终值
                if Zj<Mz	%对于锥头部分
                    Rj=Zj/tan(alpha);	%第j个微元的径向长度
                    if Rj>=rs   %定义锥头部的计算
                        betaj=beta0;    %该区域的螺旋角假设为恒定 
                        phij=log(Zj*cot(alpha))*tan(betaj)/cos(alpha)-phi1s;%锥头部滞后角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((Zj/tan(alpha))^2)*((tan(beta0)/Zj*cos(alpha))^2);
                        P2=((1/tan(alpha))^2);
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=alpha;   %轴向接触角，与切削刃法向切厚有关
                        db=dz/sin(ka);  %切削宽度
                    else
                        betaj=beta0;    %该区域的螺旋角假设为恒定
                        phij=log(Zj*cot(alpha))*tan(betaj)/cos(alpha);%锥头部滞后角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        dS=0;
                        ka=0;
                        db=0;
                    end
                elseif Zj>=Mz && Zj< Nz %定义圆弧部分的计算
                    Rj=sqrt(R^2-(R-Zj)^2)+Rr;%第j个微元的径向长度
                    betaj=atan(((Rj-Rr)*tan(beta0))/R);%第j个微元处的螺旋角
                    phij = (R+Zj-Rz)*tan(beta0)/R-phias+phi1e;%第j个微元的径向滞后角
                    phi2 = phi1-phij;   %更新第j个微元的接触角
                    %角度修正
                    phi2=phi2-2*pi*fix(phi2/2/pi);
                    if phi2<0                     
                        phi2=phi1+2*pi;              
                    end
                    %计算微元上的切削刃长度
                    P1=((sqrt(R^2-(R-Zj)^2)+Rr)^2)*(((tan(beta0)/R))^2);
                    P2=((Rz-Zj)^2)/(R^2-(Rz-Zj)^2);
                    dS=dz*sqrt(P1+P2+1);
                    %计算实际切宽
                    ka=asin((Rj-Rr)/R);  %轴向接触角，与切削刃法向切厚有关  
                    db=dz/sin(ka);  %切削宽度
                elseif Zj>=Nz %定义锥肩部分的计算 
                    Rj=u+Zj*tan(gama);  %第j个微元的径向长度
                    %定义锥肩螺旋角类型
                    if Hx==0  %定导程
                        betas=atan(2*pi*Nr/(Lead*cos(gama)));%公称螺旋角
                        phij=(Zj-Nz)*tan(betas)/Nr+phiae;%第j个微元的径向滞后角
                        betaj=atan((phij-phiae)*Rj/(Zj-Nz));%变化的螺旋角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((u+Zj*tan(gama))^2)*((tan(betas)/Nr)^2);
                        P2=(tan(gama))^2;
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                        db=dz/sin(ka);  %切削宽度
                    else  %定螺旋角
                        betaj=beta0;        %第j个微元处的螺旋角
                        if gama == 0 
                            phi2s=0;
                            phij=(Zj-Nz)*tan(betaj)-phi2s+phiae;
                            phi2 = phi1-phij;   %更新第j个微元的接触角
                            %角度修正
                            phi2=phi2-2*pi*fix(phi2/2/pi);
                            if phi2<0                     
                                phi2=phi1+2*pi;              
                            end
                            %计算微元上的切削刃长度
                            P1=((u+Zj*tan(gama))^2)*((tan(betaj)/Nr)^2);
                            P2=(tan(gama))^2;
                            dS=dz*sqrt(P1+P2+1);
                            %计算实际切宽
                            ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                            db=dz/sin(ka);  %切削宽度
                        else %gama!=0
                            phi2s=log(Nr)*tan(betaj)/sin(gama);
                            phij=log(Nr-(Nz-Zj)*tan(gama))*tan(betaj)/sin(gama)-phi2s+phiae;
                            phi2 = phi1-phij;   %更新第j个微元的接触角
                            %角度修正
                            phi2=phi2-2*pi*fix(phi2/2/pi);
                            if phi2<0                     
                                phi2=phi1+2*pi;              
                            end
                            %计算微元上的切削刃长度
                            P1=((u+Zj*tan(gama))^2)*((tan(betaj)*tan(gama)/(sin(gama)*(Nr-(Nz-Zj)*tan(gama))))^2);
                            P2=(tan(gama))^2;
                            dS=dz*sqrt(P1+P2+1);
                            %计算实际切宽
                            ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                            db=dz/sin(ka);  %切削宽度
                        end
                    end
                end
            elseif alpha >0 && R==0 %针对锥头突出，且无圆弧部分的情况（圆锥立铣刀）
                rs=Mr/20;
                %定义几个分界点滞后角
                phi1s=log(rs)*tan(beta0)/cos(alpha); % 锥头部滞后角初始值
                phi1e=log(Mr)*tan(beta0)/cos(alpha)-phi1s; % 锥头部最终滞后角
%                 phias= 0;%圆弧部分滞后角初始值
                phiae= phi1e;%圆弧部分滞后角最终值
                if Zj<Mz	%对于锥头部分
                    Rj=Zj/tan(alpha);	%第j个微元的径向长度
                    if Rj>=rs   %定义锥头部的计算
                        betaj=beta0;    %该区域的螺旋角假设为恒定 
                        phij=log(Zj*cot(alpha))*tan(betaj)/cos(alpha)-phi1s;%锥头部滞后角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((Zj/tan(alpha))^2)*((tan(beta0)/Zj*cos(alpha))^2);
                        P2=((1/tan(alpha))^2);
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=alpha;   %轴向接触角，与切削刃法向切厚有关
                        db=dz/sin(ka);  %切削宽度
                    else
                        betaj=beta0;    %该区域的螺旋角假设为恒定
                        phij=log(Zj*cot(alpha))*tan(betaj)/cos(alpha);%锥头部滞后角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        dS=0;
                        ka=0;
                        db=0;
                    end
                else  %直接定义锥肩部分的计算 
                    Rj=u+Zj*tan(gama);  %第j个微元的径向长度
                    %定义锥肩螺旋角类型
                    if Hx==0  %定导程
                        betas=atan(2*pi*Nr/(Lead*cos(gama)));%公称螺旋角
                        phij=(Zj-Nz)*tan(betas)/Nr+phiae;%第j个微元的径向滞后角
                        betaj=atan((phij-phiae)*Rj/(Zj-Nz));%变化的螺旋角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((u+Zj*tan(gama))^2)*((tan(betas)/Nr)^2);
                        P2=(tan(gama))^2;
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                        db=dz/sin(ka);  %切削宽度
                    else  %定螺旋角
                        betaj=beta0;        %第j个微元处的螺旋角
                        if gama == 0 
                            phi2s=0;
                            phij=(Zj-Nz)*tan(betaj)-phi2s+phiae;
                            phi2 = phi1-phij;   %更新第j个微元的接触角
                            %角度修正
                            phi2=phi2-2*pi*fix(phi2/2/pi);
                            if phi2<0                     
                                phi2=phi1+2*pi;              
                            end
                            %计算微元上的切削刃长度
                            P1=((u+Zj*tan(gama))^2)*((tan(betaj)/Nr)^2);
                            P2=(tan(gama))^2;
                            dS=dz*sqrt(P1+P2+1);
                            %计算实际切宽
                            ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                            db=dz/sin(ka);  %切削宽度
                        else %gama!=0
                            phi2s=log(Nr)*tan(betaj)/sin(gama);
                            phij=log(Nr-(Nz-Zj)*tan(gama))*tan(betaj)/sin(gama)-phi2s+phiae;
                            phi2 = phi1-phij;   %更新第j个微元的接触角
                            %角度修正
                            phi2=phi2-2*pi*fix(phi2/2/pi);
                            if phi2<0                     
                                phi2=phi1+2*pi;              
                            end
                            %计算微元上的切削刃长度
                            P1=((u+Zj*tan(gama))^2)*((tan(betaj)*tan(gama)/(sin(gama)*(Nr-(Nz-Zj)*tan(gama))))^2);
                            P2=(tan(gama))^2;
                            dS=dz*sqrt(P1+P2+1);
                            %计算实际切宽
                            ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                            db=dz/sin(ka);  %切削宽度
                        end
                    end
                end
            elseif alpha <=0 && R>0    %针对锥头不突出，且有圆弧部分的情况（球头刀，R刀，锥形球头刀，圆形立铣刀）
                %定义几个分界点滞后角
%                 phi1s=0; % 锥头部滞后角初始值
                phi1e=0; % 锥头部最终滞后角
                phias= 0;%圆弧部分滞后角初始值
                phiae= (R+Nz-Rz)*tan(beta0)/R;%圆弧部分滞后角最终值
                if Zj< Nz %定义圆弧部分的计算
                    Rj=sqrt(R^2-(R-Zj)^2)+Rr;%第j个微元的径向长度
                    betaj=atan(((Rj-Rr)*tan(beta0))/R);%第j个微元处的螺旋角
                    phij = (R+Zj-Rz)*tan(beta0)/R-phias+phi1e;%第j个微元的径向滞后角
                    phi2 = phi1-phij;   %更新第j个微元的接触角
                    %角度修正
                    phi2=phi2-2*pi*fix(phi2/2/pi);
                    if phi2<0                     
                        phi2=phi1+2*pi;              
                    end
                    %计算微元上的切削刃长度
                    P1=((sqrt(R^2-(R-Zj)^2)+Rr)^2)*(((tan(beta0)/R))^2);
                    P2=((Rz-Zj)^2)/(R^2-(Rz-Zj)^2);
                    dS=dz*sqrt(P1+P2+1);
                    %计算实际切宽
                    ka=asin((Rj-Rr)/R);  %轴向接触角，与切削刃法向切厚有关  
                    db=dz/sin(ka);  %切削宽度
                elseif Zj>=Nz %定义锥肩部分的计算 
                    Rj=u+Zj*tan(gama);  %第j个微元的径向长度
                    %定义锥肩螺旋角类型
                    if Hx==0  %定导程
                        betas=atan(2*pi*Nr/(Lead*cos(gama)));%公称螺旋角
                        phij=(Zj-Nz)*tan(betas)/Nr+phiae;%第j个微元的径向滞后角
                        betaj=atan((phij-phiae)*Rj/(Zj-Nz));%变化的螺旋角
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((u+Zj*tan(gama))^2)*((tan(betas)/Nr)^2);
                        P2=(tan(gama))^2;
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                        db=dz/sin(ka);  %切削宽度
                    else  %定螺旋角
                        betaj=beta0;        %第j个微元处的螺旋角
                        if gama == 0 
                            phi2s=0;
                            phij=(Zj-Nz)*tan(betaj)-phi2s+phiae;
                            phi2 = phi1-phij;   %更新第j个微元的接触角
                            %角度修正
                            phi2=phi2-2*pi*fix(phi2/2/pi);
                            if phi2<0                     
                                phi2=phi1+2*pi;              
                            end
                            %计算微元上的切削刃长度
                            P1=((u+Zj*tan(gama))^2)*((tan(betaj)/Nr)^2);
                            P2=(tan(gama))^2;
                            dS=dz*sqrt(P1+P2+1);
                            %计算实际切宽
                            ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                            db=dz/sin(ka);  %切削宽度
                        else %gama!=0
                            phi2s=log(Nr)*tan(betaj)/sin(gama);
                            phij=log(Nr-(Nz-Zj)*tan(gama))*tan(betaj)/sin(gama)-phi2s+phiae;
                            phi2 = phi1-phij;   %更新第j个微元的接触角
                            %角度修正
                            phi2=phi2-2*pi*fix(phi2/2/pi);
                            if phi2<0                     
                                phi2=phi1+2*pi;              
                            end
                            %计算微元上的切削刃长度
                            P1=((u+Zj*tan(gama))^2)*((tan(betaj)*tan(gama)/(sin(gama)*(Nr-(Nz-Zj)*tan(gama))))^2);
                            P2=(tan(gama))^2;
                            dS=dz*sqrt(P1+P2+1);
                            %计算实际切宽
                            ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                            db=dz/sin(ka);  %切削宽度
                        end
                    end
                end
            elseif alpha <=0 && R==0    %针对锥头不突出，且无圆弧部分的情况（平底刀，锥形立铣刀）
                %定义几个分界点滞后角
%                 phi1s=0; % 锥头部滞后角初始值
                phi1e=0; % 锥头部最终滞后角
%                 phias= 0;%圆弧部分滞后角初始值
                phiae= phi1e;%圆弧部分滞后角最终值
                %直接定义锥肩部分的计算 
                Rj=u+Zj*tan(gama);  %第j个微元的径向长度
                %定义锥肩螺旋角类型
                if Hx==0  %定导程
                    betas=atan(2*pi*Nr/(Lead*cos(gama)));%公称螺旋角
                    phij=(Zj-Nz)*tan(betas)/Nr+phiae;%第j个微元的径向滞后角
                    betaj=atan((phij-phiae)*Rj/(Zj-Nz));%变化的螺旋角
                    phi2 = phi1-phij;   %更新第j个微元的接触角
                    %角度修正
                    phi2=phi2-2*pi*fix(phi2/2/pi);
                    if phi2<0                     
                        phi2=phi1+2*pi;              
                    end
                    %计算微元上的切削刃长度
                    P1=((u+Zj*tan(gama))^2)*((tan(betas)/Nr)^2);
                    P2=(tan(gama))^2;
                    dS=dz*sqrt(P1+P2+1);
                    %计算实际切宽
                    ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                    db=dz/sin(ka);  %切削宽度
                else  %定螺旋角
                    betaj=beta0;        %第j个微元处的螺旋角
                    if gama == 0 
                        phi2s=0;
                        phij=(Zj-Nz)*tan(betaj)-phi2s+phiae;
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((u+Zj*tan(gama))^2)*((tan(betaj)/Nr)^2);
                        P2=(tan(gama))^2;
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                        db=dz/sin(ka);  %切削宽度
                    else %gama!=0
                        phi2s=log(Nr)*tan(betaj)/sin(gama);
                        phij=log(Nr-(Nz-Zj)*tan(gama))*tan(betaj)/sin(gama)-phi2s+phiae;
                        phi2 = phi1-phij;   %更新第j个微元的接触角
                        %角度修正
                        phi2=phi2-2*pi*fix(phi2/2/pi);
                        if phi2<0                     
                            phi2=phi1+2*pi;              
                        end
                        %计算微元上的切削刃长度
                        P1=((u+Zj*tan(gama))^2)*((tan(betaj)*tan(gama)/(sin(gama)*(Nr-(Nz-Zj)*tan(gama))))^2);
                        P2=(tan(gama))^2;
                        dS=dz*sqrt(P1+P2+1);
                        %计算实际切宽
                        ka=pi/2-gama;  %轴向接触角，与切削刃法向切厚有关  
                        db=dz/sin(ka);  %切削宽度
                    end        
                end
            end

            if  phist<=phi2&&phi2<=phiex    %判断当前刀齿微元是否参与切削
                h=c*sin(phi2)*sin(ka);%沿切削刃法向的切厚
                
%                 dFt=Ktc*h*db/cos(betaj)+Kte*dS;
%                 dFr=Krc*h*db+Kre*dS;
%                 dFa=Kac*h*db*cos(betaj)+Kae*dS;

                dFt=Ktc*h*db+Kte*dS;
                dFr=Krc*h*db+Kre*dS;
                dFa=Kac*h*db+Kae*dS;

                dF=[dFt;dFr;dFa];

                M=[-cos(phi2) -sin(phi2)*sin(ka) -sin(phi2)*cos(ka);
                    sin(phi2) -cos(phi2)*sin(ka) -cos(phi2)*cos(ka);
                     0         cos(ka)           -sin(ka)];
                 
                dF1=M*dF;

                dFx=dF1(1);
                dFy=dF1(2);
                dFz=dF1(3);

                Ft(i)=Ft(i)+dFt;
                Fr(i)=Fr(i)+dFr;
                Fa(i)=Fa(i)+dFa;
                
                Fx(i)=Fx(i)+dFx;
                Fy(i)=Fy(i)+dFy;
                Fz(i)=Fz(i)+dFz;
            end
        end
    end
    F(i)=(Fx(i)^2+Fy(i)^2+Fz(i)^2)^0.5;
    T(i)=D/2*Ft(i)/1e3 ; %切削力矩
    Time(i)=(i-1)*t/floor(K);
end
