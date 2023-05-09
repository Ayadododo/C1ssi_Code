%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%定义计算三维模型中心函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ver_weight=compute_weight(vertex,face)
%三维模型的面数量
[~,face_num]=size(face);       %~表示忽略第一个返回值
%计算三维模型每个面的中心
face_weight=[];
for i=1:face_num
    face_weight(i,1)=(vertex(1,face(1,i))+vertex(1,face(2,i))+vertex(1,face(3,i)))/3;
    face_weight(i,2)=(vertex(2,face(1,i))+vertex(2,face(2,i))+vertex(2,face(3,i)))/3;
    face_weight(i,3)=(vertex(3,face(1,i))+vertex(3,face(2,i))+vertex(3,face(3,i)))/3;
end
%计算三维模型中心
ver_weight=mean(face_weight);       %mean函数用来计算矩阵每列矩阵元素的平均值
end