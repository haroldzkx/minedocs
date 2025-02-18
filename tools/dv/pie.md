# 饼图

## 官方 Demo

```python
import matplotlib.pyplot as plt

# Pie chart, where the slices will be ordered and plotted counter-clockwise:
labels = 'Frogs', 'Hogs', 'Dogs', 'Logs'
sizes = [15, 30, 45, 10]
explode = (0, 0.1, 0, 0)  # only "explode" the 2nd slice (i.e. 'Hogs')

fig1, ax1 = plt.subplots()
ax1.pie(sizes, explode=explode, labels=labels, autopct='%1.1f%%',
        shadow=True, startangle=90)
ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.

plt.savefig('Demo_official.jpg')
plt.show()
```

![](https://gitee.com/haroldzkx/pbed1/raw/main/dv/pie.1.jpg)

## 示例

```python
from matplotlib import font_manager as fm
from matplotlib import cm
import matplotlib.pyplot as plt
%matplotlib inline
plt.style.use('ggplot')

import pandas as pd
import numpy as np

# 原始数据
shapes = [
    'Cross', 'Cone', 'Egg', 'Teardrop', 'Chevron',
    'Diamond', 'Cylinder', 'Rectangle', 'Flash', 'Cigar',
    'Changing', 'Formation', 'Oval', 'Disk', 'Sphere',
    'Fireball', 'Triangle', 'Circle', 'Light']
values = [
    287, 383, 842, 866, 1187,
    1405, 1495, 1620, 1717, 2313,
    2378, 3070, 4332, 5841, 6482,
    7785, 9358, 9818, 20254]

s = pd.Series(values, index=shapes)


labels = s.index
sizes = s.values

'''控制将某些类别突出显示'''
explode = (0,0,0,0,0,0,0,0,0,0,0,0.2,0,0,0,0,0.2,0,0)  # "explode" ， show the selected slice

'''设置绘图区域大小'''
fig, axes = plt.subplots(figsize=(8,5), ncols=2, dpi=800)
ax1, ax2 = axes.ravel()

'''设置颜色'''
# colormaps: Paired, autumn, rainbow, gray,spring,Darks
colors = cm.rainbow(np.arange(len(sizes))/len(sizes))

patches, texts, autotexts = ax1.pie(
    sizes,
    labels=labels,
    autopct='%1.0f%%',
    explode=explode,
    shadow=False,
    startangle=170,
    colors=colors,
    labeldistance=1.2,
    pctdistance=0.83,
    radius=0.4)
# labeldistance: labels显示的位置
# pctdistance: 控制百分比显示的位置
# radius: 控制切片突出的距离
# shadow: 设置阴影

ax1.axis('equal')

'''重新设置字体大小'''
proptease = fm.FontProperties()
proptease.set_size('x-small')
# font size include: ‘xx-small’,x-small’,'small’,'medium’,‘large’,‘x-large’,‘xx-large’ or number, e.g. '12'
plt.setp(autotexts, fontproperties=proptease)
plt.setp(texts, fontproperties=proptease)

ax1.set_title('Shapes', loc='center')

'''设置图例'''
# ax2 只显示图例（legend）
ax2.axis('off')
ax2.legend(patches, labels, loc='center left')

plt.tight_layout()
# plt.savefig("pie_shape_ufo.png", bbox_inches='tight')
plt.savefig('Demo_project_final.jpg')
plt.show()
```

![](https://gitee.com/haroldzkx/pbed1/raw/main/dv/pie.2.jpg)
