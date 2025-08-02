torch.Tensor

- 定义 tensor 类型，包含 7 种 CPU tensor 类型和 8 种 GPU tensor 类型
- 实现基于 Tensor 的各种数学操作、各种类型的转换

torch.Storage: 管理 Tensor 的存储

torch.nn

- torch.nn.Parameter(): Variable 的子类，用于管理网络的参数，默认 requires_grad=True.
- torch.nn.init: 初始化各种参数
- 函数包 torch.nn.functional 集合了损失函数，激活函数，标准化函数等函数
  - torch.nn.functional.(Activations): 激活函数，包括 ReLU、softmax 等
  - torch.nn.functional.Nomalization: 标准化（归一化）层，1d2d3d
  - torch.nn.functional.LossFunctions: 损失函数，L1Loss、MSELoss(均方误差)、CrossEntropyLoss(交叉熵)…
- 容器(Containers)
  - torch.nn.Module: 所有网络的基类，操作者的模型也应该继承这个类。继承后自动注册该网络。前向传播梯度记录（用于反向传播）
  - torch.nn.Sequential: 时序容器，可以更方便的搭建网络，把已有的网络层往里面放即可。
- 网络层
  - torch.nn.Linear: 全连接层
  - torch.nn.Conv1\2\3d: 卷积层，有一维二维三维
  - torch.nn.XXXPool1\2\3: 池化层，最大池化、平均池化等等，一维二维三维
- 现成网络模型
  - torch.nn.RNN: 卷积神经网络
  - torch.nn.LSTM: 长短期记忆人工神经网络
  - ......

torch.autograd: 对可求导的 Variable 变量进行求导

torch.optim: 一个实现了各种优化算法的库。对需要优化的参数（必须是 Variable 对象）进行求导。

torch.cuda: 实现了与 CPU 张量相同的功能，但使用 GPU 进行计算

torch.utils

- torch.utils.data.Dataset: 创建、保存数据集
- torch.utils.data.DataLoder: 包含对数据集的一些操作，比如 batch 操作(每次取数据集中的一小批)，shuffle 操作(随机取样)。

![架构图](https://gitee.com/haroldzkx/pbed1/raw/main/py/torch.1.png)

网络模块

数据模块

模型保存与重载模块

优化器模块

训练和测试模块

# Tensor

张量（Tensor）是 PyTorch 最基本的操作对象。

在几何定义中，张量是基于标量、向量和矩阵概念的延伸。

更直观地理解可以见下图。

![](https://gitee.com/haroldzkx/pbed1/raw/main/py/torch.2.jpg)

- 0 维张量：标量
- 1 维张量：vector
- 2 维张量：matrix  
  向量数据，形状为(samples, features)
- 3 维张量：cube  
  时间序列数据或序列数据，形状为(samples, timesteps, features)
- 4 维张量：vector of cubes  
  图像，形状为(samples, height, width, channels)或(samples, channels, height, width)
- 5 维张量：matrix of cubes  
  视频，形状为(samples, frames, height, width, channels) 或(samples, frames, channels, height, width)

```python
# 张量在代码中的形式，点击展开代码
import numpy as np

# 其实判断是几维张量，查一下小括号里面左侧中括号个数，有几个就是几维张量，算是一个小技巧。

"""0维张量"""
d_0 = np.array(5)
print(d_0.ndim)   # 0

"""1维张量"""
d_1 = np.array([1, 2, 3, 4, 5])
print(d_1.ndim, d_1.shape)  # 1 (5,)

"""2维张量"""
d_2 = np.array([[1, 2, 3, 4, 5],
               [6, 7, 8, 9, 10],
               [11, 12, 13, 14, 15]])
print(d_2.ndim, d_2.shape)  # 2 (3, 5)

"""3维张量"""
# 由3个二维张量构成
d_3 = np.array([[[1, 2, 3, 4, 5],
                [6, 7, 8, 9, 10],
                [11, 12, 13, 14, 15]],
               [[1, 2, 3, 4, 5],
                [6, 7, 8, 9, 10],
                [11, 12, 13, 14, 15]],
               [[1, 2, 3, 4, 5],
                [6, 7, 8, 9, 10],
                [11, 12, 13, 14, 15]]])
print(d_3.ndim, d_3.shape)  # 3 (3, 3, 5)
print(d_3)

"""4维张量"""
d_4 = np.array([d_3, d_3, d_3, d_3])
print(d_4.ndim, d_4.shape)  # 4 (4, 3, 3, 5)
print(d_4)

"""5维张量"""
d_5 = np.array([d_4, d_4, d_4])
print(d_5.ndim, d_5.shape)  # 5 (3, 4, 3, 3, 5)
print(d_5)
```

# Pipeline

架构：

1. 绘图模块。
2. 日志模块。
3. 实验参数模块。
4. 数据集模块。
5. EarlyStopping 模块和 checkpoint 模块。
6. 邮件通知模块。
7. GPU 配置模块。单 CPU 训练，单 GPU 训练，单机多 GPU 训练，多机多 GPU 训练，分布式训练，做成开关函数，放到 yaml 配置参数里
8. docker 配置文件

```python
configs/	# 一个实验一个 yaml 文件
    config.py/defaults.py
    xxx.yaml
    ....yaml
data/		# 还可以放一些数据预处理的代码
    datasets.py
    get_dataloader.py
evaluation/	# evaluation is a collection of code that aims to evaluate the performance and accuracy of our model.
executor/
model/
    main_model.py	# 这里用来组合各个模块
    model_gcn.py	# 模型的子组件
    model.transformer.py	# 模型的子组件
    ...
notebooks/	# jupyter notebooks放这里
utils/
    mail.py
    plot.py	# 调用logs文件夹里面的数据，进行画图
    model_utils.py
checkpoints/	# 用于进行断点训练的参数保存
logs/	# 这个模块，放一些训练日志文件，以及画图所用的数据文件
__init__.py
main.py
run_experiments.py
README.md
```

executor

- in this folder, we usually have all the functions and scripts that train the model or use it to predict something in different environments.
- And by different environments I mean: executors for GPUs, executors for distributed systems.
- This package is our connection with the outer world and it’s what our main.py will use.
- 一般放在 main.py 文件里就好，如果实验太大型了，可以创建 executor 这个文件夹

```python
# -*- coding: utf-8 -*-
""" main.py """

from configs.config import CFG
from model.unet import UNet


def run():
    """Builds model, loads data, trains and evaluates"""
    model = UNet(CFG)
    model.load_data()
    model.build()
    model.train()
    model.evaluate()


if __name__ == '__main__':
    run()
```

```python
""" run_experiments.py """
from yacs.config import CfgNode as CN


def get_cfg_defaults():
    # 创建默认配置
    cfg = CN()

    # 设置默认参数
    cfg.MODEL.NAME = "ResNet"
    cfg.MODEL.NUM_CLASSES = 10

    cfg.TRAIN.EPOCHS = 10
    cfg.TRAIN.SAVE_MODEL = True

    return cfg

def train(cfg):
    # 使用配置参数进行训练
    model_name = cfg.MODEL.NAME
    num_classes = cfg.MODEL.NUM_CLASSES

    epochs = cfg.TRAIN.EPOCHS
    save_model = cfg.TRAIN.SAVE_MODEL

    # 具体的训练代码实现...

if __name__ == '__main__':
    # 运行实验的顺序列表
    run_order = ["config_experiment1.yaml", "config_experiment2.yaml"]

    # 循环遍历运行顺序并运行实验
    for config_filename in run_order:
        # 构建配置文件的完整路径
        config_path = config_filename

        # 加载配置文件
        cfg = get_cfg_defaults()
        cfg.merge_from_file(config_path)
        cfg.freeze()

        # 运行实验
        train(cfg)
```
