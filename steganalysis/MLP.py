import warnings

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.preprocessing import StandardScaler
warnings.filterwarnings("ignore")

#读取CSV,去掉表头得到数据
csv_name='760MRS128L0.1T3_76mrs0.03.csv';
print('当前数据集用FLD时准确率为：85%')
lfs = pd.read_csv(csv_name)
lfs_target = np.array(lfs['is_Stego'])
lfs = lfs.drop(['is_Stego'], axis=1)
X = lfs.values
y = lfs_target
def MLP():
    #划分数据集,比例为0.3，每次随机
    x_train, X_test, y_train, Y_test = train_test_split(X, y, test_size=0.3, random_state=0)

    #由于感知机对特征缩放敏感，标准化数据,缩放到标准正态分布
    scaler=StandardScaler()
    scaler.fit(x_train)
    x_train=scaler.transform(x_train)
    X_test=scaler.transform(X_test)

    #初始化感知机模型，拟合训练数据
    #感知机76-19-1
    clf = MLPClassifier(solver='lbfgs', alpha=1e-5,hidden_layer_sizes=(19,), activation='relu',random_state=1,max_iter=100)
    clf.fit(x_train,y_train)
    score=clf.score(X_test,Y_test)
    return score
#多次实验验证模型准确率
list=[]
for i in range(10):
    list.append(MLP())
print("感知机的平均检测准确率为：",np.mean(list))