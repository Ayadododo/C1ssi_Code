# Code  
如果有任何问题请发邮件到1072602853@qq.com  

#### 文件说明
1. steganalysis隐写分析
2. steganography隐写算法

#### 三维模型隐写分析介绍
1. 3d mesh steganalysis 代码包含两个模块1）提取特征2）机器学习
2. 提取特征：通过matlaba处理.off文件，输出特征集csv
3. 机器学习：通过python+scikit+pandas+numpy处理特征集


#### 3D模型数据集说明  
1. PSB普林斯顿分割集，真实世界扫描得来。  X. Chen , A. Golovinskiy , T. Funkhouser , A benchmark for 3D mesh segmentation, ACM Trans. Graph. 28 (3) (2009) 73:1–73:12 . 
2. 包含20类，共计400个，其中261-280这20个人体模型存在网格问题，所以我们实验一般用380个  
3. 5月20日更新：LF文件夹下包含MRS算法嵌入128bit的五个平滑强度的特征集

#### 3D隐写分析相关论文及介绍（按照研究逻辑的时间顺序）
1. Ying Yang and Ioannis Ivrissimtzis, “Mesh discriminative features for 3D steganalysis,” ACM Transactions on Multimedia Computing, Communications, and Applications, vol. 10, no. 3, pp. 27:1–27:13, 2014.        特征集YANG208
2.  Z. Li, A.G. Bors, 3D mesh steganalysis using local shape features, in: Proceedings of IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP), 2016, pp. 2144–2148.       使用局部形状特征的3D网格隐写分析    特征集LFS52
3. D. Kim , H.-U. Jang , H.-Y. Choi , J. Son , I.-J. Yu , H.-K. Lee , Improved 3D mesh steganalysis using homogeneous kernel map, in: Proc. Int. Conf. on Information Science and Applications, 2017, pp. 358–365 . ——齐次核升维——特征集LFS64
4. Z. Li and A. G. Bors, “Steganalysis of 3D objects using statistics of local feature sets,” Inf. Sci., vols. 415–416, pp. 85–99, Nov. 2017.——使用局部特征集统计矩的三维隐写分析——LFS76
5. Z. Li , A.G. Bors , Selection of robust features for the cover source mismatch problem in 3D steganalysis, in: Proc. Int. Conf. on Pattern Recognition, 2016, pp. 4256–4261 . ——基于解决CSM问题的鲁棒特征筛选
6. Zhou H ,  Chen K ,  Zhang W , et al. Feature-Preserving Tensor Voting Model for Mesh Steganalysis[J]. IEEE Transactions on Visualization and Computer Graphics, 2019, PP(99):1-1.——投票张量特征NVT36——结合LFS64——组成100维NVT+
7. Li Z ,  Bors A G . Steganalysis of Meshes Based on 3D Wavelet multiresolution Analysis[J]. Information Sciences, 2020, 522:164-179.——3d小波特征228维，与LFS76组成304维效果较好
8. 平滑强度评测论文，大部分隐写算法在0.3，3参数下效果最好，级联特征效果最好
9. Li Z ,  Gong D ,  Liu F , et al. 3D Steganalysis Using the Extended Local Feature Set[C]// 2018:1683-1687.——扩展局部特征集——从LFS76到LFS124

#### 数字图像隐写分析常用数据集  
1. BOSSBase (BOWS2):
BOSSBase (Break Our Steganographic System) is a widely used dataset for image steganalysis.  
It consists of 10,000 grayscale images in BMP format, with a resolution of 512x512 pixels.  
2. BOWS2: BOWS2 (Break Our Watermarking System) is another dataset commonly used in steganalysis research.  
It contains 10,000 grayscale images in BMP format, with a resolution of 512x512 pixels.  
3. S-UNIWARD: S-UNIWARD is a dataset specifically designed for steganalysis of spatial domain image steganography algorithms.  
It consists of 50,000 grayscale images in BMP format, with a resolution of 512x512 pixels.  
4. HUGO: HUGO is a dataset created for steganalysis of JPEG steganography algorithms.   
It contains 50,000 color images in JPEG format, with a resolution of 512x512 pixels.


#### 三维网格
针对.off格式的三维网格，MATLAB中可以使用以下几种方法计算两个网格之间的差异：

1. 均方根误差（RMSE）：计算两个网格中每个顶点的坐标差异，并计算其平方的平均值，最后再开方。具体实现如下：

```matlab
% 读取两个.off格式的网格文件
[V1, F1] = read_off('mesh1.off');
[V2, F2] = read_off('mesh2.off');

% 计算顶点坐标差异
diff = V1 - V2;

% 计算均方根误差（RMSE）
rmse = sqrt(mean(sum(diff.^2, 2)));
```

2. 最大误差（Max Error）：计算两个网格中每个顶点的坐标差异，并取其绝对值中的最大值。具体实现如下：

```matlab
% 读取两个.off格式的网格文件
[V1, F1] = read_off('mesh1.off');
[V2, F2] = read_off('mesh2.off');

% 计算顶点坐标差异
diff = V1 - V2;

% 计算最大误差
max_error = max(abs(diff(:)));
```

3. Hausdorff距离（Hausdorff distance）：Hausdorff距离是两个网格之间最大的点到点距离，即第一个网格中的每个点到第二个网格的最近点的距离的最大值，或者第二个网格中的每个点到第一个网格的最近点的距离的最大值。具体实现如下：

```matlab
% 读取两个.off格式的网格文件
[V1, F1] = read_off('mesh1.off');
[V2, F2] = read_off('mesh2.off');

% 计算第一个网格中每个点到第二个网格的最近点的距离
D1 = pdist2(V1, V2);
min_D1 = min(D1, [], 2); % 取每行的最小值

% 计算第二个网格中每个点到第一个网格的最近点的距离
D2 = pdist2(V2, V1);
min_D2 = min(D2, [], 2); % 取每行的最小值

% 计算Hausdorff距离
hausdorff_distance = max(max(min_D1), max(min_D2));
```


#### 成对划分样本
```python
import random
import pandas as pd

def generate_indices(n, x):
    """生成随机标号列表

    Args:
        n (int): 标号数量
        x (float): 切分比例

    Returns:
        list: 随机标号列表
    """
    indices = list(range(n))
    random.shuffle(indices)
    return indices[:int(n * x)]

def split_data_by_indices(data1_file, data2_file, indices):
    """按标号将数据分割成四个列表

    Args:
        data1_file (str): 第一个CSV文件路径
        data2_file (str): 第二个CSV文件路径
        indices (list): 随机标号列表

    Returns:
        tuple: 四个列表，包括data1_train, data1_test, data2_train, data2_test
    """
    data1 = pd.read_csv(data1_file)
    data2 = pd.read_csv(data2_file)
    data1_train, data1_test, data2_train, data2_test = [], [], [], []
    for i, row in data1.iterrows():
        if i in indices:
            data1_test.append(row)
        else:
            data1_train.append(row)
    for i, row in data2.iterrows():
        if i in indices:
            data2_test.append(row)
        else:
            data2_train.append(row)
    return data1_train, data1_test, data2_train, data2_test

def save_data_to_csv(data1_train, data1_test, data2_train, data2_test, prefix):
    """将四个列表存储到CSV文件中

    Args:
        data1_train (list): 第一个CSV文件的训练集列表
        data1_test (list): 第一个CSV文件的测试集列表
        data2_train (list): 第二个CSV文件的训练集列表
        data2_test (list): 第二个CSV文件的测试集列表
        prefix (str): 文件名前缀
    """
    pd.DataFrame(data1_train).to_csv(f'{prefix}_data1_train.csv', index=False)
    pd.DataFrame(data1_test).to_csv(f'{prefix}_data1_test.csv', index=False)
    pd.DataFrame(data2_train).to_csv(f'{prefix}_data2_train.csv', index=False)
    pd.DataFrame(data2_test).to_csv(f'{prefix}_data2_test.csv', index=False)

```


#### 空域图像隐写算法
1. 秘密信息：不论格式、编码，最终是一串比特流010101...
2. 载体：RGB图像、灰度图像
3. 密钥：编码格式、嵌入方式、嵌入位置等都算隐写算法的密钥
- 本科毕设：基于边缘检测度量变化的图像隐写
    1. 秘密信息：二值图像（黑白图像）转换为比特流
    2. 载体：灰度图像
    3. 密钥：使用GHM多小波分解载体，嵌入位置由边缘检测低频区域的差值决定
    4. 使用方式：下载steganography下的所有.m文件，country是一张载体图片  
        info1 和 info2 是两张宽相等，长度不相等的秘密图像，嵌入后会生成Secret.png文件  
        之后再选择tiqu.m选择Secret.png文件就可以看到提取后的，其中代码将宽度设置为密钥，程序中已写。  
        载体图像：<img decoding="async" src="steganography/country.png" width="10%"> 
        秘密信息：![秘密信息](steganography/info1.png)
        含密图像：<img decoding="async" src="steganography/Secret.png" width="10%"> 
    5. 本科毕设demo很多细节处理的不好，诸如将彩色图转换为灰度图最后没转回来，包括文件名采用了拼音命名法等问题，而且当时虽然有gui，但是需要matlab环境，所以就不放了，算是一个复杂图像隐写算法的练习


#### 图像的离散余弦变换
```python
from PIL import Image
import numpy as np

# 读取图片
img = Image.open('example.jpg')

# 显示图片
img.show()

# 将图片转换为numpy数组
img_arr = np.array(img)

# 将数组转换为浮点数类型，并将像素值范围从[0, 255]转换为[-128, 127]
img_arr = np.float32(img_arr) - 128.0

# 将图片分成8x8的小块，并对每个小块进行DCT变换
dct_arr = np.zeros_like(img_arr)
for i in range(0, img_arr.shape[0], 8):
    for j in range(0, img_arr.shape[1], 8):
        dct_arr[i:i+8, j:j+8] = np.fft.fft2(img_arr[i:i+8, j:j+8], norm='ortho')

# 将DCT系数矩阵转换为图像
dct_img = Image.fromarray(np.uint8(dct_arr + 128.0))

# 显示DCT变换后的图像
dct_img.show()
```