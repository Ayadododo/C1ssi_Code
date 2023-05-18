% 陈昊博  GHM+边缘检测嵌入过程
% 1.分解图片，利用其中两张或三张
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("请选择载体图像");
[embedfilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
I = imread([pathname,embedfilename]);
% [infofilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
% info= imread([pathname,infofilename]);
%I=imread('lenna.jpg');
disp("请选择秘密信息图像");
[embedfilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
info=imread([pathname,embedfilename]);
infom=info(:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I=rgb2gray(I);
[~,m]=size(I);%获取图片的边长
N= edge(I,'Canny');
%转换浮点数并且分解
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


%边缘检测：
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
%P就是横纵坐标位置
for i = 1:m      %可嵌入位置共有从1到m个
    lie=P(i,1);hang=P(i,2);      %嵌入位置的行列坐标，从P数组中提取
    if i<=num     %如果可嵌入位置小于嵌入字符位置，对应位最低位改的和信息一样
       change(hang,lie)=bitset(change(hang,lie),1,infom(i));
    else            %将后面的一律改为0，完成嵌入
       change(hang,lie)=bitset(change(hang,lie),1,0);
    end
end
%提取信息过程,按照顺序从坐标中提取前num个
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

%嵌入过程中的，带信息的HH2嵌入
L1=[LL2,LH2];L2=[HL2,HH2];LL1=[L1;L2];
UP=[LL1,LH1];DOWN=[HL1,HH1];
I2=[UP;DOWN];
%XXX=xor(I,img2);
xdd=double(I2);
B=ighmap(xdd);
B=uint8(B);

subplot(331),imshow(I);title('载体图像');
subplot(332),imshow(A);title('二阶GHM多小波分解');
subplot(333),imshow(LL2),title('二阶子图LL2');
subplot(334),imshow(HH2),title('二阶子图HH2');
subplot(335),imshow(C);title('LL2边缘检测');
subplot(336),imshow(D);title('HH2边缘检测');
subplot(337),imshow(F);title('边缘图异或图');
subplot(338),imshow(N);title('原图边缘检测');
subplot(339),imshow(B);title('含密图像');
disp("所选载体可嵌入容量为"+j);
disp("已显示所有过程，并且生成了名为Secret.png的含密图像");
imwrite(B,'Secret.png');

