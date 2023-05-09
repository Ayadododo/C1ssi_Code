%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����MRS��д��Ϣ����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [recov_vertex,face]=embed(filename)
    %��ȡ��άģ���ļ�
    [vertex,face]=read_mesh(filename);
    %������άģ������
    ver_weight=compute_weight(vertex,face);
    %��άģ�͵Ķ�������
    [~,ver_num]=size(vertex);
    %�����������д��Ϣ�ĳ���
    message_length=192;
    %�����������д��Ϣ
    message_bin=rand(message_length,1)>0.5;       %rand�����������ɵ�һ���������ڶ���������С�����������ÿ������Ԫ��ȡֵ��Χ��0��1֮��
    %������άģ��ÿ������ļ�����
    vertex_norm=[];
    ver_theta=[];
    ver_phi=[];
    for i=1:ver_num
        %������άģ��ÿ������ķ���
        temp_vertex_norm=sqrt((vertex(1,i)-ver_weight(1,1))^2+(vertex(2,i)-ver_weight(1,2))^2+(vertex(3,i)-ver_weight(1,3))^2);
        vertex_norm=[vertex_norm;temp_vertex_norm];
        %������άģ��ÿ������ķ�λ��
        temp_theta=atan2((vertex(2,i)-ver_weight(1,2)),(vertex(1,i)-ver_weight(1,1)));       %atan2�������������(�ڶ�����������һ������)��Ӧ�ĵ�һ���������Եڶ��������������޷�����ֵ
        ver_theta=[ver_theta;temp_theta];
        %������άģ��ÿ�����������
        temp_phi=acos((vertex(3,i)-ver_weight(1,3))/temp_vertex_norm);       %acos����������������ķ�����ֵ
        ver_phi=[ver_phi;temp_phi];
    end
%����������άģ�����ж���ķ���
[vertex_norm,index]=sort(vertex_norm);       %sort��������������������Ԫ�أ���һ������ֵ���������к�����飬�ڶ�������ֵ���������к�������е�����Ԫ���ڳ�ʼ�����е��±�
%���������������д��Ϣ�ĳ��ȸ�bin
ver_norm_bin=[];
ver_norm_bin_num=[];
for i=1:message_length
    %����ÿ��bin�е���άģ�͵Ķ��㷶������Сֵ�����ֵ
    bin_min_norm=vertex_norm(1)+((vertex_norm(end)-vertex_norm(1))/message_length)*(i-1);
    bin_max_norm=vertex_norm(1)+((vertex_norm(end)-vertex_norm(1))/message_length)*i+0.0001;
    %����ÿ��bin�е���άģ�͵Ķ��㷶��������
    bool_min=vertex_norm>=bin_min_norm;
    bool_max=vertex_norm<=bin_max_norm;
    bool_fit=bool_min & bool_max;       %&��ʾ�߼������
    bin_norm_num=sum(bool_fit);
    ver_norm_bin_num=[ver_norm_bin_num;bin_norm_num];
    %��������������άģ�͵Ķ��㷶����ӵ�ÿ��bin
    ver_norm_bin(i,1:bin_norm_num)=vertex_norm(bool_fit);
end
%��ÿ��bin�е���άģ�͵Ķ��㷶����һ��
ver_norm_bin_normalize=[];
for i=1:message_length
    %ÿ��bin�е���άģ�͵Ķ��㷶����Сֵ
    Min=min(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    %ÿ��bin�е���άģ�͵Ķ��㷶�����ֵ
    Max=max(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    %���bin�е���άģ�͵Ķ��㷶����������0��1��2�����bin�е���άģ�͵Ķ��㷶�������һ��
    if ver_norm_bin_num(i)<=2
        ver_norm_bin_normalize(i,1:ver_norm_bin_num(i))=ver_norm_bin(i,1:ver_norm_bin_num(i));
    else
        ver_norm_bin_normalize(i,1:ver_norm_bin_num(i))=(ver_norm_bin(i,1:ver_norm_bin_num(i))-Min)/(Max-Min);
    end
end
%���㷶���޸�ָ���仯����
k_c=0.001;
%��дǿ��ϵ��
a=0.03;
%��д��Ϣ
ver_norm_bin_normalize_embed=[];
for i=1:message_length
    %���bin�е���άģ�͵Ķ��㷶����������0��1��2�����bin������д��Ϣ
    if ver_norm_bin_num(i)<=2
        ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i));
    else
        %���㷶���޸�ָ��
        kn=1;
        %��д1
        if message_bin(i)==1
            ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
            avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));       %mean��������������������������Ԫ�صľ�ֵ
            %�޸ĵ�ǰbin�е���άģ�͵Ķ��㷶��ʹ��ƽ��ֵ������ֵ
            while avg<0.5+a
                kn=kn-k_c;
                ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
                avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));
            end
        %��д0
        elseif message_bin(i)==0
            ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
            avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));
            %�޸ĵ�ǰbin�е���άģ�͵Ķ��㷶��ʹ��ƽ��ֵС����ֵ
            while avg>0.5-a
                kn=kn+k_c;
                ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize(i,1:ver_norm_bin_num(i)).^kn;
                avg=mean(ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i)));
            end
        end
    end
end
%��ÿ��bin�е���άģ�͵Ķ��㷶������һ��
recov_ver_norm_bin=[];
for i=1:message_length
    Min=min(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    Max=max(ver_norm_bin(i,1:ver_norm_bin_num(i)));
    %���bin�е���άģ�͵Ķ��㷶����������0��1��2�����bin�е���άģ�͵Ķ��㷶�������һ��
    if ver_norm_bin_num(i)<=2
        recov_ver_norm_bin(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i));
    else
        recov_ver_norm_bin(i,1:ver_norm_bin_num(i))=ver_norm_bin_normalize_embed(i,1:ver_norm_bin_num(i))*(Max-Min)+Min;
    end
end
%���������������д��Ϣ�ĳ��ȸ�bin
recov_ver_norm=[];
for i=1:message_length
    for j=1:ver_norm_bin_num(i)
        recov_ver_norm=[recov_ver_norm;recov_ver_norm_bin(i,j)];
    end
end
%������άģ�͵Ķ�������������άģ�����ж���ķ���
temp_ver_norm=[];
for i=1:ver_num
    temp_ver_norm(i)=recov_ver_norm(index==i);
end
recov_ver_norm=temp_ver_norm;
%������άģ��ÿ�����������
recov_vertex=[];
for i=1:ver_num
    recov_vertex(i,1)=recov_ver_norm(i)*sin(ver_phi(i))*cos(ver_theta(i))+ver_weight(1,1);
    recov_vertex(i,2)=recov_ver_norm(i)*sin(ver_phi(i))*sin(ver_theta(i))+ver_weight(1,2);
    recov_vertex(i,3)=recov_ver_norm(i)*cos(ver_phi(i))+ver_weight(1,3);
end
%������άģ���ļ�

% out_file=fullfile('D:\matlab\bin\matlab�����ļ�\MRS\75_embed.off');       %fullfile���������ϲ��ļ�·��
% write_off(out_file,recov_vertex,face);

%��ʾ��άģ��

% subplot(1,2,1);
% title('��ʼ��άģ��');
% plot_mesh(vertex,face);
% subplot(1,2,2);
% title(['������άģ��(MRS ',num2str(message_length),'bits)']);
% plot_mesh(recov_vertex,face);

end