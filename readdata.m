clc
clear 
close all

%%
Fx_R_1 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_1.csv', 'R_1', 'B21:B10021'))';%读取Excel表中文件
Fy_R_1 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_1.csv', 'R_1', 'C21:C10021'))';%读取Excel表中文件
Fz_R_1 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_1.csv', 'R_1', 'D21:D10021'))';%读取Excel表中文件

Fx_R_2 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_2.csv', 'R_2', 'B21:B10021'))';%读取Excel表中文件
Fy_R_2 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_2.csv', 'R_2', 'C21:C10021'))';%读取Excel表中文件
Fz_R_2 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_2.csv', 'R_2', 'D21:D10021'))';%读取Excel表中文件

Fx_R_3 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_3.csv', 'R_3', 'B21:B10021'))';%读取Excel表中文件
Fy_R_3 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_3.csv', 'R_3', 'C21:C10021'))';%读取Excel表中文件
Fz_R_3 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_3.csv', 'R_3', 'D21:D10021'))';%读取Excel表中文件

Fx_R_4 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_4.csv', 'R_4', 'B21:B10021'))';%读取Excel表中文件
Fy_R_4 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_4.csv', 'R_4', 'C21:C10021'))';%读取Excel表中文件
Fz_R_4 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_4.csv', 'R_4', 'D21:D10021'))';%读取Excel表中文件

Fx_R_5 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_5.csv', 'R_5', 'B21:B10021'))';%读取Excel表中文件
Fy_R_5 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_5.csv', 'R_5', 'C21:C10021'))';%读取Excel表中文件
Fz_R_5 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\R_5.csv', 'R_5', 'D21:D10021'))';%读取Excel表中文件


%%
Fx_Ball_1 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_1.csv', 'Ball_1', 'B21:B10021'))';%读取Excel表中文件
Fy_Ball_1 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_1.csv', 'Ball_1', 'C21:C10021'))';%读取Excel表中文件
Fz_Ball_1 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_1.csv', 'Ball_1', 'D21:D10021'))';%读取Excel表中文件

Fx_Ball_2 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_2.csv', 'Ball_2', 'B21:B10021'))';%读取Excel表中文件
Fy_Ball_2 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_2.csv', 'Ball_2', 'C21:C10021'))';%读取Excel表中文件
Fz_Ball_2 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_2.csv', 'Ball_2', 'D21:D10021'))';%读取Excel表中文件

Fx_Ball_3 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_3.csv', 'Ball_3', 'B21:B10021'))';%读取Excel表中文件
Fy_Ball_3 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_3.csv', 'Ball_3', 'C21:C10021'))';%读取Excel表中文件
Fz_Ball_3 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_3.csv', 'Ball_3', 'D21:D10021'))';%读取Excel表中文件

Fx_Ball_4 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_4.csv', 'Ball_4', 'B21:B10021'))';%读取Excel表中文件
Fy_Ball_4 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_4.csv', 'Ball_4', 'C21:C10021'))';%读取Excel表中文件
Fz_Ball_4 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_4.csv', 'Ball_4', 'D21:D10021'))';%读取Excel表中文件

Fx_Ball_5 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_5.csv', 'Ball_5', 'B21:B10021'))';%读取Excel表中文件
Fy_Ball_5 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_5.csv', 'Ball_5', 'C21:C10021'))';%读取Excel表中文件
Fz_Ball_5 = (xlsread('E:\Work_leekunhwee\Experiments\2017.08.22\results\Ball_5.csv', 'Ball_5', 'D21:D10021'))';%读取Excel表中文件


%%
save ('20170822', 'Fx_R_1','Fy_R_1','Fz_R_1','Fx_R_2','Fy_R_2','Fz_R_2','Fx_R_3','Fy_R_3','Fz_R_3',...
                  'Fx_R_4','Fy_R_4','Fz_R_4','Fx_R_5','Fy_R_5','Fz_R_5',...
                  'Fx_Ball_1','Fy_Ball_1','Fz_Ball_1','Fx_Ball_2','Fy_Ball_2','Fz_Ball_2','Fx_Ball_3','Fy_Ball_3','Fz_Ball_3',...
                  'Fx_Ball_4','Fy_Ball_4','Fz_Ball_4','Fx_Ball_5','Fy_Ball_5','Fz_Ball_5')