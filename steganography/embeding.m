function c=embeding(a,b)
I=rgb2gray(a);
info=b;
infom=info(:);
[~,m]=size(I);%��ȡͼƬ�ı߳�
N= edge(I,'Canny');
xd=double(I);A=ghmap(xd);A=uint8(A);

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
c=B;