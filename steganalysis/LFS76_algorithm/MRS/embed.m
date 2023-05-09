%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%定义MRS隐写信息函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [recov_vertex,face]=embed(filename)
    %读取三维模型文件
    [vertex,face]=read_mesh(filename);
    %计算三维模型中心
    ver_weight=compute_weight(vertex,face);
    %三维模型的顶点数量
    [~,ver_num]=size(vertex);
    %随机二进制隐写信息的长度
    message_length=192;
    %随机二进制隐写信息
    message_bin=rand(message_length,1)>0.5;       %rand函数用来生成第一个参数×第二个参数大小的随机数矩阵，每个矩阵元素取值范围在0到1之间
    %计算三维模型每个顶点的极坐标
    vertex_norm=[];
    ver_theta=[];
    ver_phi=[];
    for i=1:ver_num
        %计算三维模型每个顶点的范数
        temp_vertex_norm=sqrt((vertex(1,i)-ver_weight(1,1))^2+(vertex(2,i)-ver_weight(1,2))^2+(vertex(3,i)-ver_weight(1,3))^2);
        vertex_norm=[vertex_norm;temp_vertex_norm];
        %计算三维模型每个顶点的方位角
        temp_theta=atan2((vertex(2,i)-ver_weight(1,2)),(vertex(1,i)-ver_weight(1,1)));       %atan2函数用来计算点(第二个参数，第一个参数)对应的第一个参数除以第二个参数的四象限反正切值
        ver_theta=[ver_theta;temp_theta];
        %计算三维模型每个顶点的仰角
        temp_phi=acos((vertex(3,i)-ver_weight(1,3))/temp_vertex_norm);       %acos函数用来计算参数的反余弦值
        ver_phi=[ver_phi;temp_phi];
    end
%升序排列三维模型所有顶点的范数
[vertex_norm,index]=sort(vertex_norm);       %sort函数用来升序排列数组元素，第一个返回值是升序排列后的数组，第二个返回值是升序排列后的数组中的数组元素在初始数组中的下标
%划分随机二进制隐写信息的长度个bin
ver_norm_bin=[];
ver_norm_bin_num=[];
for i=1:message_length
    %计算每个bin中的三维模型的顶点范数的最小值和最大值
    bin_min_norm=vertex_norm(1)+((vertex_norm(end)-vertex_norm(1))/message_length)*(i-1);
    bin_max_norm=vertex_norm(1)+((vertex_norm(end)-vertex_norm(1))/message_length)*i+0.0001;
    %计算每个bin中的三维模型的顶点范数的数量
    bool_min=vertex_norm>=bin_min_norm;
    bool_max=vertex_norm<=bin_max_norm;
    bool_fit=bool_min & bool_max;       %&表示逻辑与操作
    bin_norm_num=sum(bool_fit);
    ver_norm_bin_num=[ver_norm_bin_num;bin_norm_num];
    %将满足条件的三维模型的顶点范数添加到每个bin
    ver_norm_bin(i,1:bin_norm_num)=vertex_norm(bool_fit);
end
%对每个bin中的三维模型的顶点范数归一化
ver_norm_bin_normalize=[];
for i=1:message_length
    %每个bin中的三维模型的顶点范数最小值
    Min=min(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    %每个bin中的三维模型的顶点范数最大值
    Max=max(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    %如果bin中的三维模型的顶点范数的数量是0、1、2，则该bin中的三维模型的顶点范数不会归一化
    if ver_norm_bin_num(i)<=2
        ver_norm_bin_normalize(i,1:ver_norm_bin_num(i))=ver_norm_bin(i,1:ver_norm_bin_num(i));
    else
        ver_norm_bin_normalize(i,1:ver_norm_bin_num(i))=(ver_norm_bin(i,1:ver_norm_bin_num(i))-Min)/(Max-Min);
    end
end
%顶点范数修改指数变化步长
k_c=0.001;
%隐写强度系数
a=0.03;
%隐写信息
ver_norm_bin_normalize_embed=[];
for i=1:message_length
    %如果bin中的三维模型的顶点范数的数量是0、1、2，则该bin不会隐写信息
    if ver_norm_bin_num(i)<=2
        ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i));
    else
        %顶点范数修改指数
        kn=1;
        %隐写1
        if message_bin(i)==1
            ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
            avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));       %mean函数用来计算数组中所有数组元素的均值
            %修改当前bin中的三维模型的顶点范数使得平均值大于阈值
            while avg<0.5+a
                kn=kn-k_c;
                ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
                avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));
            end
        %隐写0
        elseif message_bin(i)==0
            ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
            avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));
            %修改当前bin中的三维模型的顶点范数使得平均值小于阈值
            while avg>0.5-a
                kn=kn+k_c;
                ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
                avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));
            end
        end
    end
end
%对每个bin中的三维模型的顶点范数反归一化
recov_ver_norm_bin=[];
for i=1:message_length
    Min=min(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    Max=max(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    %如果bin中的三维模型的顶点范数的数量是0、1、2，则该bin中的三维模型的顶点范数不会归一化
    if ver_norm_bin_num(i)<=2
        recov_ver_norm_bin(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i));
    else
        recov_ver_norm_bin(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))*(Max-Min)+Min;
    end
end
%整合随机二进制隐写信息的长度个bin
recov_ver_norm=[];
for i=1:message_length
    for j=1:ver_norm_bin_num(i)
        recov_ver_norm=[recov_ver_norm;recov_ver_norm_bin(i,j)];
    end
end
%按照三维模型的顶点索引排列三维模型所有顶点的范数
temp_ver_norm=[];
for i=1:ver_num
    temp_ver_norm(i)=recov_ver_norm(index==i);
end
recov_ver_norm=temp_ver_norm;
%计算三维模型每个顶点的坐标
recov_vertex=[];
for i=1:ver_num
    recov_vertex(i,1)=recov_ver_norm(i)*sin(ver_phi(i))*cos(ver_theta(i))+ver_weight(1,1);
    recov_vertex(i,2)=recov_ver_norm(i)*sin(ver_phi(i))*sin(ver_theta(i))+ver_weight(1,2);
    recov_vertex(i,3)=recov_ver_norm(i)*cos(ver_phi(i))+ver_weight(1,3);
end
%保存三维模型文件

% out_file=fullfile('D:\matlab\bin\matlab程序文件\MRS\75_embed.off');       %fullfile函数用来合并文件路径
% write_off(out_file,recov_vertex,face);

%显示三维模型

% subplot(1,2,1);
% title('初始三维模型');
% plot_mesh(vertex,face);
% subplot(1,2,2);
% title(['含密三维模型(MRS ',num2str(message_length),'bits)']);
% plot_mesh(recov_vertex,face);

end