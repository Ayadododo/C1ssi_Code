%获取脚本文件mfilenname的文件夹路径
current_folder=fileparts(which('main.m'));
%获取以上文件夹父文件夹的路径
parent_folder=fileparts(current_folder);
%再获取子文件夹的路径
subfolder=fullfile(parent_folder,'MRS128_off')
%获取子文件夹中所有文件的列表
file_list = dir(fullfile(subfolder,'*.off'));
%循环处理每一个文件
%因为提取LFS76特征集，所以创建空矩阵存储特征向量
 
start_time=clock
for i=3:3
    dt=0.1*i;
    Tmax=3;
    feature_matrix = zeros(380,76);
%             disp("正在提取模型标号："+i);
%         file_path=fullfile(subfolder,file_list(11).name);
%         %每个子文件提取一个特征向量
%         f=LFS76_fea(file_path,dt,Tmax);
    for i = 1:length(file_list)
        disp("正在提取模型标号："+i);
        file_path=fullfile(subfolder,file_list(i).name);
        %每个子文件提取一个特征向量
        f=LFS76_fea(file_path,dt,Tmax);
        %合并多个特征向量
        feature_matrix(i,:) = f;
    end
    %保存至外部文件
    dt=num2str(dt)
    csvname=['MRS128L',dt,'T3_76.csv'];
    csvwrite(csvname,feature_matrix);
end


end_time=clock
time=end_time-start_time;
disp("总花费时间："+time);

%在将原始模型归一化，中心放置到坐标系中后，76维特征分别是
%1-12顶点笛卡尔三路坐标的——均值3、方差3、偏度3、峰度3——12
%13-16笛卡尔坐标系下的顶点范数——均值、方差、偏度、峰度——4
%17-28顶点拉普拉斯三路坐标的——均值3、方差3、偏度3、峰度3——12
%29-32拉普拉斯坐标系下的顶点范数——均值、方差、偏度、峰度——4
%33-36面法线——均值、方差、偏度、峰度——4
%37-40二面角——均值、方差、偏度、峰度——4
%41-44顶点法线——均值、方差、偏度、峰度——4
%45-48高斯曲率——均值、方差、偏度、峰度——4
%49-52曲率比——均值、方差、偏度、峰度——4
%53-64球坐标系下两个角度、一个长度——均值3、方差3、偏度3、峰度3——12
%65-76球坐标系下边长度——均值3、方差3、偏度3、峰度3——12
%笛卡尔坐标、笛卡尔顶点范数、拉普拉斯顶点范数、拉普拉斯坐标
%面法线、二面角、顶点法线、高斯曲率
%曲率比、球坐标系坐标、球坐标系边长