import warnings

import numpy as np
import pandas as pd
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.ensemble import BaggingClassifier
from sklearn.metrics import roc_auc_score
from sklearn.model_selection import train_test_split
warnings.filterwarnings("ignore")

#读取带表头，且含正负样本和标签的数据集
def processSource(csv_name):
    lfs = pd.read_csv(csv_name)
    return lfs
#从数据源中提取出数据矩阵
def getnumsData(lfs):
    lfs_data = lfs.drop(['is_Stego'], axis=1)
    lfsData = lfs_data.values
    return lfsData

def getSourceData(lfs):
    lfs_data = lfs.drop(['is_Stego'], axis=1)
    lfsData = lfs_data.values
    return lfsData

def getSourceTarget(lfs):
    lfsTarget = np.array(lfs['is_Stego'])
    return lfsTarget

def  Classifier(csv_name):
    #预处理数据
    pS=processSource(csv_name)
    X = getnumsData(pS)
    Y = getSourceTarget(pS)
    # 划分训练集和测试集,
    x_train, X_test, y_train, Y_test = train_test_split(X, Y, test_size=testsplitsize, random_state=0)

    #定义基分类器
    base_classifier = base
    # 定义 Bagging 分类器
    bagging_classifier = BaggingClassifier(base_estimator=base_classifier,n_estimators=estimatersnums)
    # 拟合数据得到集成分类器
    bagging_classifier.fit(x_train, y_train)
    #对测试集进行预测，计算准确率
    data_acc = bagging_classifier.score(X_test,Y_test)
    #计算在测试集上的AUC
    y_score=bagging_classifier.decision_function(X_test)
    auc=roc_auc_score(Y_test,y_score)
    #保存二者到列表
    testacc.append(data_acc)
    testauc.append(auc)
    return data_acc


#定义常量
#估计器类型
base=LinearDiscriminantAnalysis()
# base=svm.SVC()
#估计器数量
estimatersnums=200
#测试集占总数据集的比例
testsplitsize=0.3
#设定数据集，运行模型，数据集和优化因子要对应起来
data="760MRS128L0.1T3_76mrs0.03.csv"
print("当前实验的数据集为：",data)
#保存多次实验的列表
testacc=[]
testauc=[]
#多次实验
for i in range(10):
    Classifier(data)
print('30次实验准确率与Auc均值:',np.mean(testacc),np.mean(testauc))


