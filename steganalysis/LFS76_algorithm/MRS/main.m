clc;
clear all;
%输入文件
%调用嵌入算法
%生成新文件并保存
start_time=clock;
num_iterations = 400;%共有100个文件
for i = 281:num_iterations
    num=i;%1递增至400
    num=num2str(num);%数字转换为字符串
    input_file=['C:\Users\Administrator\Documents\MATLAB\off\','',num,'','.off'];
    disp(input_file)
    [recov_vertex,face]=embed(input_file);
    out_file=['C:\Users\Administrator\Documents\MATLAB\MRS192_off\','StegoMRS192_','',num,'','.off'];
    disp(out_file)
    write_off(out_file,recov_vertex,face);
    
end
end_time=clock;
all_time=end_time-start_time;
disp("总花费时间"+all_time);