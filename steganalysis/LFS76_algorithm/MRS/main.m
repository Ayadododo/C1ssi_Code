clc;
clear all;
%�����ļ�
%����Ƕ���㷨
%�������ļ�������
start_time=clock;
num_iterations = 400;%����100���ļ�
for i = 281:num_iterations
    num=i;%1������400
    num=num2str(num);%����ת��Ϊ�ַ���
    input_file=['C:\Users\Administrator\Documents\MATLAB\off\','',num,'','.off'];
    disp(input_file)
    [recov_vertex,face]=embed(input_file);
    out_file=['C:\Users\Administrator\Documents\MATLAB\MRS192_off\','StegoMRS192_','',num,'','.off'];
    disp(out_file)
    write_off(out_file,recov_vertex,face);
    
end
end_time=clock;
all_time=end_time-start_time;
disp("�ܻ���ʱ��"+all_time);