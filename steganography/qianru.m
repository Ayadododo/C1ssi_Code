% ��껲�  GHM+��Ե���Ƕ�����
% 1.�ֽ�ͼƬ�������������Ż�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("��ѡ������ͼ��");
[embedfilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
I = imread([pathname,embedfilename]);
% [infofilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
% info= imread([pathname,infofilename]);
%I=imread('lenna.jpg');
disp("��ѡ��������Ϣͼ��");
[embedfilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
info=imread([pathname,embedfilename]);
infom=info(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=rgb2gray(I);
[~,m]=size(I);%��ȡͼƬ�ı߳�
N= edge(I,'Canny');
%ת�����������ҷֽ�
xd=double(I);
A=ghmap(xd);
A=uint8(A);


HH1=A((m/2+1):m,(m/2+1):m);
LH1=A(1:m/2,(m/2+1):m);
HL1=A((m/2+1):m,1:(m/2));
LL2=A(1:m/4,1:m/4);
HH2=A((m/4+1):m/2,(m/4+1):m/2);
LH2=A(1:m/4,(m/4+1):m/2);
HL2=A((m/4+1):m/2,1:m/4);


%��Ե��⣺
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pLL2=double(LL2);C= edge(pLL2,'Canny');
pHH2=double(HH2);D = edge(pHH2,'Canny');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=xor(C,D);
[x,y]=find(F==1);
num=length(infom);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
change=LH2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P=[y,x];
[m,n]=size(P);
%P���Ǻ�������λ��
for i = 1:m      %��Ƕ��λ�ù��д�1��m��
    lie=P(i,1);hang=P(i,2);      %Ƕ��λ�õ��������꣬��P��������ȡ
    if i<=num     %�����Ƕ��λ��С��Ƕ���ַ�λ�ã���Ӧλ���λ�ĵĺ���Ϣһ��
       change(hang,lie)=bitset(change(hang,lie),1,infom(i));
    else            %�������һ�ɸ�Ϊ0�����Ƕ��
       change(hang,lie)=bitset(change(hang,lie),1,0);
    end
end
%��ȡ��Ϣ����,����˳�����������ȡǰnum��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LH2=change;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
X=bitget(change,1);
t=zeros(1,num);
for j=1:m
    c=P(j,1);r=P(j,2);
    if j<=num
       t(1,j)=X(r,c);  
    end
end

%Ƕ������еģ�����Ϣ��HH2Ƕ��
L1=[LL2,LH2];L2=[HL2,HH2];LL1=[L1;L2];
UP=[LL1,LH1];DOWN=[HL1,HH1];
I2=[UP;DOWN];
%XXX=xor(I,img2);
xdd=double(I2);
B=ighmap(xdd);
B=uint8(B);

subplot(331),imshow(I);title('����ͼ��');
subplot(332),imshow(A);title('����GHM��С���ֽ�');
subplot(333),imshow(LL2),title('������ͼLL2');
subplot(334),imshow(HH2),title('������ͼHH2');
subplot(335),imshow(C);title('LL2��Ե���');
subplot(336),imshow(D);title('HH2��Ե���');
subplot(337),imshow(F);title('��Եͼ���ͼ');
subplot(338),imshow(N);title('ԭͼ��Ե���');
subplot(339),imshow(B);title('����ͼ��');
disp("��ѡ�����Ƕ������Ϊ"+j);
disp("����ʾ���й��̣�������������ΪSecret.png�ĺ���ͼ��");
imwrite(B,'Secret.png');

