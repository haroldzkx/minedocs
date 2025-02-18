# 雷达图

```python
# 导入第三方模块
import numpy as np
import matplotlib.pyplot as plt

# 设置中文为雅黑
plt.rcParams['font.sans-serif'] = ['SimHei']

# 构造数据[561, 636, 338, 223, 244]
# 使用的时候，替换成自己的真实数据就好了
values = np.array([561, 636, 338, 223, 244])
feature = np.array(['200-500元','500-1000元','1000-2000元','2000-3000元','3000元以上'])
N = len(values)

# 设置雷达图的角度，用于平分切开一个圆面
angles=np.linspace(0, 2 * np.pi, N, endpoint=False)

# 将折线图形进行封闭操作
values = np.concatenate((values, [values[0]]))
angles = np.concatenate((angles, [angles[0]]))
feature=np.concatenate((feature,[feature[0]]))

# 创建图形
fig = plt.figure(figsize=(10,6), dpi=100)

# 这里一定要设置为极坐标格式
ax = fig.add_subplot(111, polar=True)

# 绘制折线图
ax.plot(angles, values, 'o-', linewidth=2)

# 填充颜色
ax.fill(angles, values, alpha=0.25)

# 添加每个特征的标签
ax.set_thetagrids(angles * 180 / np.pi, feature)

# 设置雷达图的范围
ax.set_ylim(0,700)

# 添加标题
plt.title('能接受的单次网购消费人群分布')

# 添加网格线
ax.grid(True)

# 保存图片
plt.savefig('raderfivteen.png')

# 显示图形
plt.show()
```

![](https://gitee.com/haroldzkx/pbed1/raw/main/dv/rader.png)
