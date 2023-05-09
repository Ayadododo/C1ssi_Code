import pandas as pd
import torch
from matplotlib import pyplot as plt
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from torch import nn, functional
from torch.utils.data import DataLoader, TensorDataset

#1读取CSV,去掉表头得到数据
csv_name='760MRS128L0.1T3_76mrs0.03.csv';
lfs = pd.read_csv(csv_name)
lfs_target=lfs[['is_Stego']].values
# lfs_target = np.array(lfs['is_Stego'])
lfs = lfs.drop(['is_Stego'], axis=1)
X = lfs.values
y = lfs_target
print('当前数据集760个，特征76维，在FLD上准确率平均值为85%')
print("X包含760个样本，每个样本是一个76维数组")
print("Y包含760个标签数据，每个样本是1维数组，要注意标签在深度学习和机器学习的区别",y.shape)



#2划分数据集,比例为0.3，每次随机
x_train, x_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=0)

#3由于神经网络对特征缩放敏感，标准化数据,缩放到标准正态分布
scaler=StandardScaler()
scaler.fit(x_train)
x_train=scaler.transform(x_train)
x_test=scaler.transform(x_test)
#方便转换成张量形式
x_train=x_train.reshape(-1,1,76)
x_test=x_test.reshape(-1,1,76)


#4将数据集封装成数据管道
dl_train = DataLoader(TensorDataset(torch.tensor(x_train).float(),torch.tensor(y_train).float()),
                     shuffle = True, batch_size=100)
dl_valid = DataLoader(TensorDataset(torch.tensor(x_test).float(),torch.tensor(y_test).float()),
                     shuffle = False,batch_size=100)

#5定义网络模型,一层卷积网络，目前测出比较好的参数有：
#1卷积类型4个，1*1卷积、304-19-1-优化器adam 0.001 mseloss bat100 epcho100
#2卷积类型4个，2*2卷积步长2、优化器adam 0.001 mseloss bat100 epcho50
#3卷积类型4个，卷积大小4，步长4，优化器adam 0.001 mseloss bat100 eplch150
def creat_net():
    net=nn.Sequential()
    net.add_module('con1v',nn.Conv1d(1,4,4,4))#输出100行样本 变为n*76/size/step 卷积核类型*样本维度
    net.add_module('relu1',nn.ReLU())
    # net.add_module('poo1',nn.MaxPool1d(2))#n*38
    net.add_module('flatten', nn.Flatten())
    net.add_module('linear1', nn.Linear(4*19, 19))
    net.add_module('linear2', nn.Linear(19, 1))
    net.add_module('relu2', nn.ReLU())
    return net
net=creat_net()

#6优化器，损失函数，准确率计算
optimzer = torch.optim.Adam(net.parameters(),lr=0.001)
loss_func = nn.MSELoss()
metric_func=lambda y_pred,y_true:accuracy_score(y_true.data.numpy(),y_pred.data.numpy()>0.5)
metric_name="accuracy"

#7训练模型
epochs=81#训练轮次
log_step_freq=30

#可以记录日志到csv
dfhistory=pd.DataFrame(columns=["epoch","loss",metric_name,"val_loss","val_"+metric_name])
for epoch in range(1,epochs+1):
    #1训练循环,每个轮次更新准确率和损失函数
    net.train()
    loss_sum=0.0
    metric_sum=0.0
    step=1
    for step,(features,labels) in enumerate(dl_train,1):
        #梯度清零
        optimzer.zero_grad()

        #正向传播计算损失
        predictions=net(features)
        loss = loss_func(predictions,labels)
        metric = metric_func(predictions,labels)

        #反向传播求梯度
        loss.backward()
        optimzer.step()

        #打印损失函数与准确率
        loss_sum += loss.item()
        metric_sum += metric.item()
        if step % log_step_freq == 0:
            print(("[step = %d] loss:%.3f,"+metric_name+":%.3f" )%
                  (step,loss_sum/step,metric_sum/step))

    #2.验证循环，不需要反向传播，只需要正向计算准确率
    net.eval()
    val_loss_sum = 0.0
    val_metric_sum = 0.0
    val_step = 1

    for val_step, (features, labels) in enumerate(dl_valid, 1):

        # 正向传播计算准确率
        predictions = net(features)
        val_loss = loss_func(predictions, labels)
        val_metric = metric_func(predictions, labels)

        # 打印损失函数与准确率
        val_loss_sum += val_loss.item()
        val_metric_sum += val_metric.item()

        #3.记录准确率信息并打印
    info = (epoch, loss_sum/step, metric_sum/step,
    val_loss_sum/val_step, val_metric_sum/val_step)
    dfhistory.loc[epoch-1] = info
    print(("\nEPOCH = %d, loss = %.3f," + metric_name + \
               "  = %.3f, val_loss = %.3f, " + "val_" + metric_name + " = %.3f")
              % info)
print('完成训练')

#8从日志中展示效果
def plot_metric(dfhistory, metric):
    train_metrics = dfhistory[metric]
    val_metrics = dfhistory['val_'+metric]
    epochs = range(1, len(train_metrics) + 1)
    plt.plot(epochs, train_metrics, 'bo--')
    plt.plot(epochs, val_metrics, 'ro-')
    plt.title('Training and validation '+ metric)
    plt.xlabel("Epochs")
    plt.ylabel(metric)
    plt.legend(["train_"+metric, 'val_'+metric])
    plt.show()
plot_metric(dfhistory,"loss")
plot_metric(dfhistory,"accuracy")