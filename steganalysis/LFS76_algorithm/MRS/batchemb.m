clc;
clear;
file_read = dir('C:\Users\Administrator\Desktop\data\off\*.off');
filename = {file_read.name}; 
file_length = length(file_read);
for i = 1:file_length
     id = file_read(i).name;
     disp(['--> MRS-----------embeding------------',id]);
     ori_file = strcat('C:\Users\Administrator\Desktop\data\off\','\',id);
     out_file = strcat('C:\Users\Administrator\Desktop\data\result\MRS\','\',id,'.off');
     MRS(ori_file,out_file);
end
disp('---finish---')