%%GHM��С����ȡ���̣���һ��������Ϣͼ���зֽ�
%�Ҷ�ͼת��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("��ѡ����ͼ��");
[embedfilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
I = imread([pathname,embedfilename]);

%sigma=10;
%I=imnoise(I,'salt & pepper',0.0001);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ת�����������ҷֽ�
[~,m]=size(I);
xd=double(I);A=ghmap(xd);A=uint8(A);
%subplot(222),imshow(I);title('��������Ϣͼ');
LL1=A(1:m/2,1:m/2);
HH1=A((m/2+1):m,(m/2+1):m);
LH1=A(1:m/2,(m/2+1):m);
HL1=A((m/2+1):m,1:(m/2));
LL2=A(1:m/4,1:m/4);
HH2=A((m/4+1):m/2,(m/4+1):m/2);
LH2=A(1:m/4,(m/4+1):m/2);
HL2=A((m/4+1):m/2,1:m/4);
%��ȡ���̵ĵڶ������Ժ���Ϣ��HH2��LL2���м���λ��ȷ������ȡ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pLL2=double(LL2);C= edge(pLL2,'canny');
pHH2=double(HH2);D = edge(pHH2,'canny');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ͼLL2����Canny��Ե��⣬��ֵĬ��
% EdgeLL2= edge(LL2,'canny');
% % ����ͼHH2����Canny��Ե��⣬��ֵĬ��
% EdgeHH2= edge(HH2,'canny');
% % ��������Ϊ���߱�Եͼ���
% Hidden_area=xor(EdgeLL2,EdgeHH2);
% % ��ȡ��������λ�õ�����
% [x,y]=find(Hidden_area==1);
% %����һ��˳������λ����Ϣ
% Position=[y,x];
% % ��ȡλ����Ϣ�Ķ�ά����
% [colnumber,rownumber]=size(Position);
% %ѭ���н�������ϢǶ���һλ��
% for i = 1:colnumber  
%     %����ȡ����������
%     column=Position(i,1);
%     row=P(i,2);    
%     %�޸�LH2
%     LH2(row,column)=bitset(LH2(row,column),1,Secret_information_array);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ȷ��Ƕ��λ��
F=xor(C,D);
%%Ƕ��λ������
[x,y]=find(F==1);
P=[y,x];
[m,n]=size(P);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X=bitget(LH2,1);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=zeros(1,m);
for j=1:m
    c=P(j,1);r=P(j,2);
       t(1,j)=X(r,c);  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subplot(221),imshow(I);title('��Ϣͼ');
max=floor(m/100)*100;
t=t(1:max);
% pro="��������Կ��\n";
% Key=input(pro);
Key=50
seq=floor(max/Key);
if(Key~=50)
    tt=reshape(t,seq,Key);
    disp("��Կ���󣬲�����ȡ");
else
t=reshape(t,Key,seq);
subplot(222),imshow(t),title('��Ϣ��ȡ');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%imwrite(t,'juzi8bitLH2_0.2_1.5.png');




