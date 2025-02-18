# Pandas 简介

Pandas 在管理结构化数据方面非常方便，其基本功能可以大致概括为以下五类：

- 数据/文本文件读取；
- 索引、选取和数据过滤；
- 算法运算和数据对齐；
- 函数应用和映射；
- 重置索引。

这些基本操作都建立在 Pandas 的基础数据结构之上。

Pandas 有两大基础数据结构：Series(一维数据结构)和 DataFrame(二维数据结构)。

# Series、DataFrame 及其基本操作

Series 和 DataFrame 是 Pandas 的两个核心数据结构，Series 是一维数据结构，DataFrame 是二维数据结构。

Pandas 是基于 NumPy 构建的，这两大数据结构也为时间序列分析提供了很好的支持。

## Series

Series 是一个类似于一维数组和字典的结合，类似于 Key-Value 的结构，Series 包括两个部分：index、values，这两部分的基础结构都是 ndarray。

Series 可以实现转置、拼接、迭代等。

接下来将通过一些简单的例子，初步认识 Series。首先导入需要的模块，代码如下。

```python
import pandas as pd
```

1.  创建 Series。  
    首先创建一个 Series，Series 的初始化方法有很多，以下列举两个，代码如下。

```python
a = pd.Series(('a':10 b 2, c':3))
b = pd.Series([10, 2, 3], index = ['a', "b', 'c'])
```

除了直接创建，也可以将现有的字典类型的数据转换成 Series，代码如下。

```python
data =('first':'hello', 'second': 'world', 'third':'!!')
c = pd.Series(data)
```

2.  访问其中的元素。

```python
a = pd.Series(('a':10, 'b':2, 'c':3))
b = pd.Series([10, 2, 3], index =【'a', 'b', 'c'])
```

访问其中 index 为‘b'的元素，代码如下。

```python
print(a[1]) #2
print(a('b'])#2
```

3.  修改索引。  
    将索引变为['x', 'y', 'z']，代码如下。

```python
a.index = ['x', 'y', 'z']
```

4.  拼接不同的 Series。  
    先创建两个不同的 Series，连接 a 和 b，Series 类型在运算时会自动对齐不同索引的数据，代码如下。

```python
a = pd.Series(('a':1, 'b':2, 'c':3))
b = pd.Series([10, 2, 3], index=['x', 'y', 'z'])
c = pd.concat([a, b])
```

## DataFrame

DataFrame 是一个类似于 Excel 表格的数据结构，索引包括行索引和列索引，每列可以是不同的数据类型(String、int、bool、...)，DataFrame 的每一列(或行)都是一个 Series，每一列(或行)的 series.name 即为当前列(或行)索引名。

下面将通过一些简单的例子，来初步认识 DataFrame。首先导入需要的模块，代码如下。

```python
import pandas as pd
import numpy as np
```

### 创建 DataFrame

DataFrame 是一个二维结构，较为常见的创建方法有：通过二维数组结构创建、通过字典创建、通过读取既有文件创建。

在创建 DataFrame 时，若没有指定行、列索引，则会自动生成从 0 开始的整数值作为索引，同时也可以指定 index 和 columns 不添加索引，代码如下。

```python
arr = np.random.rand(3, 3) #生成一个3x3的随机数矩阵
df = pd.DataFrame(arr)
display(df)

"""Output as below
0 1 2
0 0.13407 0.154330 0.805625
1 0.384434 0.720512 0.957487
2 0.678296 0.120157 0.238141
"""
```

此外，也可以指定行索引和列索引，可以理解成是存储了点 A、B、C 的三维坐标的一个表，代码如下。

```python
df2 = pd.DataPrame(arr, index=list("xyz"), columns=list("ABC"))
print(df2)

'''Output as below
    A           B           C
x   0.13407     0.154330    0.805625
y   0.384434    0.720512    0.957487
z   0.678296    0.120157    0.238141
'''
```

### DataFrame 的列操作

以上述 df2 这一 DataFrame 变量为例。获取点 A 的 x、y、z 坐标，可以通过三种方法获取：

- df[列索引]
- df.列索引
- df.iloc[:,:]

注意：在使用第一种方式时，获取的永远是列，索引只会被认为是列索引，而不是行索引；相反，第二种方式没有此类限制，故在使用中容易出现问题。第三类方法常用于获取多个列，其返回值也是一个 DataFrame。

这里以第三种方式为例，代码如下。

```python
pos_A = df2.ilocl:， 0] #选取所有行第0列
pos_A= df2.ilocl ， 0:2] #选取所有行第0列和第1列
df2['B'] #选取单列
df2[ ['B','C']] #选取多列，注意是两个方括号
```

如果想在 df2 的最后一列添加上点 D 的坐标(1, 1, 1)，可以通过 df[列索引]=列数据 的方式，代码如下。

```python
df2['D'] =[1, 1,1]
```

修改 C 的坐标为(0.6, 0.5, 0.4)，并删除点 B，代码如下。

```python
df2['C'] = [0.6, 0.5, 0.4]
del df2[ 'B']
print(df2)

'''Output as below
    A           C       D
x   0.13407     0.6     1
Y   0.384434    0.5     1
2   0.678296    0.4     1
'''
```

### DataFrame 的行操作

还是以上述处理后的 df2 变量为例。若获取所有点在 x 轴上的位置，则可以通过两种方法：

- df.loc[行标签][列标签]
- df.iloc[:,:]

以第一种方法为例，代码如下。

```python
x = df2.loc['x']        #选取x行
x = df2.1oc['x']['A']   #选取x行A列的数据
```

至此已经了解了 df.loc[][] 以及 df.iloc[] 的用法，接下来对这两种用法进行一下对比：使用.iloc 访问数据的时候，可以不考虑数据的索引名，只需要知道该数据在整个数据集中的序号即可，使用 .loc 访问数据的时候，需要考虑数据的案引名，通过索引名来获取数据，效果与 iloc 一致。

如果想给变量再增加一个维度，例如 t 维度，可以通过 append 的方法，这样会返回一个新的 DataFrame，而不会改变原有的 DataFrame，代码如下。

```python
t = pd.Series([1, 1, 2], index=list("ACD"),name='t')
df3 = df2.append(t)

'''Output as below
    A           C       D
x   0.13407     0.6     1
y   0.384434    0.5     1
z   0.678296    0.4     1
t   1.000000    1.0     2
'''
```

如果删除新增的't'这一行，可以通过 df.drop(行索引，axis) 实现，axis 默认值为 None 即删除行，若 axis=1，则删除列，代码如下。

```python
df3.drop(['t'])
display(df3)

'''Output as below
    A           C       D
x   0.13407     0.6     1
y   0.384434    0.5     1
z   0.678296    0.4     1
'''
```

修改行数据的方法与列相同，这里不再赘述。

### DataFrame 数据查询

数据查询的方法可以分为以下五类：按区间查找、按条件查找、按数值查找、按列表查找、按函数查找。

这里以 df.loc 方法为例，df.iloc 方法类似。先创建一个 DataFrame:

```python
arr = np.array([[1, 3, 5], [0, 2, 1]， [32, 2，-3]])
df = pd.DataFrame(arr, index=list("abc"),columns=1ist("xyz"))
print(df)

'''Output as below
    x       y       z
a   1       3       s
b   0       2       1
c   32      2       -3
'''
```

在前面已经提到过如何使用 df.loc 和 df.iloc 按照标签值去查询，这里介绍通过 df.loc 按照区间范围进行查找，例如，获取 x 轴上 a、b 的坐标，代码如下。

```python
print(df.loc['a': 'b', 'x']) #('a':1,'b:0)
```

或者按照条件表达式查询，获取位于 z 轴正半轴的点的数据，代码如下。

```python
print(df.loc[(df['2']>0) & (df['z']<2), :])

'''Output as below
    x   y   z
b   0   2   1
'''
```

此外，还可以通过编写 lambda 函数来查找，获取在 x、z 轴正半轴的点的数据，代码如下。

```python
print(df.loc[lambda df:(df['z']>0) & (df['×']＞0)])

'''Output as below
    x   y   z
a   1   3   5
'''
```

### DataFrame 数据统计

1.  数据排序。  
    在处理带有时间戳的数据时，如地铁刷卡数据、手机信令数据等，有时需要将数据按照时间顺序排列，这样数据预处理时能够更加方便，或者按照已有的索引给数据进行重新排序，DataFrame 提供了这类方法。  
    新建一个 DataFrame，代码如下。

```python
dfs = pd.DataFrame(np.random.random((3,3)), index=[6, 2,5], columns=[3, 9, 1])
print(dfs)

'''Output as below
    3           9           1
6   0.003695    0.739854    0.19758
2   0.038442    0.521347    0.49912
5   0.698634    0.482931    0.87395
'''
```

按照索引升序排序，可以通过 df.sort_index(axis=0, ascending=True) 实现。  
默认通过行索引，按照升序排序，代码如下。

```python
newdfs1 = dfs.sort_index()
'''Output as below
    3           9           1
2   0.038442    0.521347    0.49912
5   0.698634    0.482931    0.87395
6   0.003695    0.739854    0.19758
'''
```

按照值的降序排序，可以通过 df.sort_values(3, ascending=False)，代码如下。

```python
newdfs2 = dfs.sort_values(3, ascending=False)

'''Output as below
    3           9           1
5   0.698634    0.482931    0.87395
2   0.038442    0.521347    0.49912
6   0.003695    0.739854    0.19758
'''
```

2.  统计指标。  
    通过 DataFrame.describe() 可以获取整个 DataFrame 不同类别的各类统计指标，先读取测试文件，testl.csv 结构代码如下。

```python
file = pd.read_csv('./test1.CSV')
print(file)
```

结果如下。

```latex
name    size    level   weight
A       919     s       90
B       223     a       30
C       33      d       210
D       32      b       199
E       2999    s       140
F       2       d       200
```

测试文件记录了 A ～ F 一共 6 个物品的大小、等级以及重量。  
使用 file.describe() 对所有数字列进行统计，返回值中统计了个数、均值、标准差、最小值、25%～ 75%分位数、最大值等统计指标，代码如下。

```python
print(file.describe())
```

结果如下。

```latex
        size        weight
count   6.0000      6.0000
mean    701.3333    144.B333
std     1178.0660   72.719782
mìn     2.0000      30.0000
25号    32.2500     102.5000
50号    128.0000    169.5000
75号    745.0000    199.7500
max     2999.0000   210.0000
```

可以通过 file[].mean() 或 file[].max() 等方法，单独计算某一列对应的某一统计指标，代码如下。

```python
print(file['size'].max())       # 2999
print(file['weight'].mean())   # 144.8333
```

3.  分类汇总。  
    GroupBy 可以将数据按条件进行分类，进行分组索引。  
    以另一个测试文件 test2.csv 为例，先导入这个测试文件，该文件的结构查看代码如下。

```python
file2 = pd.read_csv('./test2.csv')
```

此外，GroupBy 可以计算目标类别的统计特征，例如，按 level 将物品分类，并计算所有数字列的统计特征。代码如下。

```python
print(file2.groupby('level').describe())
```

除了对单一列进行分组外，GroupBy 也可以对多个列进行分组，例如，对 'level'、'place_of_production' 两个列同时进行分组。  
例如，获取每个工厂都生成了哪些类别的物品，每个类别的数字特征的均值和求和是多少。代码如下。

```python
df = file2.groupby(['place_of_production', 'level']).agg([np.mean, np.sum])
print(df)
```

进一步，如果要分析各个工厂生产不同类别商品的数量的均值和求和，代码如下。

```python
df2 = file2.groupby(['place_of_production', 'level'])['number'].agg([np.mean, np.sum])
print(df2)
```

最后，如果要遍历 GroupBy 的结果，不能直接打印其内容，而是要通过迭代获取。  
以测试文件 test2.csv 为例，导入测试文件 2，并按照生产地进行分类，首先尝试打印 GroupBy 结果，代码如下。

```python
file2= pd.read_csv('./test2.csv')
df3 = file2.groupby('place_of_production')
print(df3)
#<pandas.core.groupby.generic.DataFrameGroupBy object at 0x000001863D3C3D0>
```

此时发现返回值并不是所期待的表格，而是返回了 df3 变量的类型，因为 GroupBy 的结果是一个对象，不能直接打印其内容。  
当然也可以把 df3 强制转换格式为 list 再输出，但结果不便于进行进一步处理。  
因此，可以通过对 GroupBy 的结果进行遍历，再获取期望的信息，代码如下。

```python
for name, group in df3:
    print(name)         # 分组后的组名
    print(group)        # 组内信息
    print('-' * 20)     # 分割线
```

# Pandas 和 NumPy 的异同

- NumPy 是数值计算的扩展包，能够高效处理 N 维数组，即处理高维数组或矩阵时会方便。
- Pandas 是 Python 的一个数据分析包，主要是做数据处理用的，以处理二维表格为主。
- NumPy 只能存储相同类型的 ndarray，Pandas 能处理不同类型的数据，例如，二维表格中不同列可以是不同类型的数据，一列为整数，一列为字符串。
- NumPy 支持并行计算，所以 TensorFlow 2.0、PyTorch 都能和 NumPy 无缝转换。NumPy 底层使用 C 语言编写，效率远高于纯 Python 代码。
- Pandas 是基于 NumPy 的一种工具，该工具是为了解决数据分析任务而创建的。Pandas 提供了大量快速便捷地处理数据的函数和方法。
- Pandas 和 NumPy 可以相互转换，DataFrame 转换为 ndarray 只需要使用 df.values 即可，ndarray 转换为 DataFrame 使用 pd.DataFrame(array)即可。
