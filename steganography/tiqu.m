%%GHM多小波提取过程，第一步，对信息图进行分解
%灰度图转换
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp("请选择含密图像。");
[embedfilename,pathname]=uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','All Image Files';'*.*','All Files'});
I = imread([pathname,embedfilename]);

%sigma=10;
%I=imnoise(I,'salt & pepper',0.0001);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%转换浮点数并且分解
[~,m]=size(I);
xd=double(I);A=ghmap(xd);A=uint8(A);
%subplot(222),imshow(I);title('处理后的信息图');
LL1=A(1:m/2,1:m/2);
HH1=A((m/2+1):m,(m/2+1):m);
LH1=A(1:m/2,(m/2+1):m);
HL1=A((m/2+1):m,1:(m/2));
LL2=A(1:m/4,1:m/4);
HH2=A((m/4+1):m/2,(m/4+1):m/2);
LH2=A(1:m/4,(m/4+1):m/2);
HL2=A((m/4+1):m/2,1:m/4);
%提取过程的第二步：对含信息的HH2和LL2进行检测和位置确定与提取
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pLL2=double(LL2);C= edge(pLL2,'canny');
pHH2=double(HH2);D = edge(pHH2,'canny');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 对子图LL2进行Canny边缘检测，阈值默认
% EdgeLL2= edge(LL2,'canny');
% % 对子图HH2进行Canny边缘检测，阈值默认
% EdgeHH2= edge(HH2,'canny');
% % 隐藏区域即为二者边缘图异或
% Hidden_area=xor(EdgeLL2,EdgeHH2);
% % 获取所有隐藏位置点坐标
% [x,y]=find(Hidden_area==1);
% %按照一定顺序排列位置信息
% Position=[y,x];
% % 获取位置信息的二维长度
% [colnumber,rownumber]=size(Position);
% %循环中将秘密信息嵌入第一位中
% for i = 1:colnumber  
%     %依次取出行列坐标
%     column=Position(i,1);
%     row=P(i,2);    
%     %修改LH2
%     LH2(row,column)=bitset(LH2(row,column),1,Secret_information_array);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%异或确定嵌入位置
F=xor(C,D);
%%嵌入位置坐标
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
subplot(221),imshow(I);title('信息图');
max=floor(m/100)*100;
t=t(1:max);
% pro="请输入密钥。\n";
% Key=input(pro);
Key=50
seq=floor(max/Key);
if(Key~=50)
    tt=reshape(t,seq,Key);
    disp("密钥错误，不予提取");
else
t=reshape(t,Key,seq);
subplot(222),imshow(t),title('信息提取');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%imwrite(t,'juzi8bitLH2_0.2_1.5.png');




