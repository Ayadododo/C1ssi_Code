%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���������άģ�����ĺ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ver_weight=compute_weight(vertex,face)
%��άģ�͵�������
[~,face_num]=size(face);       %~��ʾ���Ե�һ������ֵ
%������άģ��ÿ���������
face_weight=[];
for i=1:face_num
    face_weight(i,1)=(vertex(1,face(1,i))+vertex(1,face(2,i))+vertex(1,face(3,i)))/3;
    face_weight(i,2)=(vertex(2,face(1,i))+vertex(2,face(2,i))+vertex(2,face(3,i)))/3;
    face_weight(i,3)=(vertex(3,face(1,i))+vertex(3,face(2,i))+vertex(3,face(3,i)))/3;
end
%������άģ������
ver_weight=mean(face_weight);       %mean���������������ÿ�о���Ԫ�ص�ƽ��ֵ
end