# NumPy 简介

NumPy 主要是围绕 ndarray 对象展开，通过 NumPy 的线性代数工具包对其进行一系列操作，如切片索引、广播、修改数组(形状、维度、元素的增删改)、连接数组等，以及对多维数组的点积等。除了数组，NumPy 还有很多函数，包括三角函数、统计函数等。下面结合例子，介绍 ndarray 以及其基础操作。

# ndarray 及其基本操作

NumPy 的重要特点之一就是 n 维数组对象，即 ndarray。

这一部分将从数组的创建开始，介绍 ndarray 的一些基本操作，包括索引和切片、形状修改、类型修改、通用函数、线性代数、统计函数等。

首先导入 NumPy，代码如下。

```python
import numpy as np
```

## 生成数组

1.  生成 0/1 数组  
    可以通过 np.ones(shape, dtype) 或 np.ones_like(a, shape)、np.zeros(shape, dtype)或 np.zeros_like(a, shape) 生成，代码如下。

```python
one_matrix = np.ones([3, 3]) # 生成一个3x3的矩阵，矩阵元素都为1
zero_matrix = np.zeros_like(one_matrix) # 生成一个3x3的矩阵，矩阵元素都为0
```

2.  从现有数据生成数组  
    通过 np.array(object, dtype) 或 np.asarray(a, dtype)依据已有的数组生成新的数组，代码如下。

```python
arr = np.array([[3, 4],[1, 2]])
arr1 = np.array(arr)
arr2 = np.asarray(arr)
print(arr)  # [[3, 4],[1, 2]]
print(arr1) # [[3, 4],[1, 2]]
pritn(arr2) # [[3, 4],[1, 2]]
```

可以发现，arrl 和 arr2 与 arr 完全一致，但采用了不同的函数，实际上这两个复制函数是不同的，对于 arr1 采用的是 np.array()，而 arr2 采用的是 np.asarray()。  
当修改 arr 的元素值的时候，arrl 的元素值不会改变，而 arr2 的元素值会随着 arr 的元素值变化而变化，代码如下。

```python
arr[1, 1] = 6
print(arr1) #[[3,4],[1, 2]]
print(arr2) #[[3, 4],[1, 6]]
```

3.  生成固定范围的数组  
    通过 np.linspace(start,stop,num=50)、np.arange([start=None],stop=None,[step=None])、np.logspace(start,stop,num=50) 均可以生成指定范围的数组，以 np.arange()为例，生成一个步长为 2 的等差数组，代码如下。

```python
arr = np.arange(0, 10, 2)
print(arr) #[0, 2, 4, 6, 8]
```

可以发现生成的数组不包含指定的最后一个数字，因为这个区间设定是左闭右开的。

4.  生成随机数数组  
    导包

```python
import numpy
import numpy as np
```

```python
# numpy.random.rand(d0, d1, ..., dn)，产生[0，1)之间 均匀分布 的随机浮点数，
# 其中，d0, d1, ..., dn表示传入的数组形状
np.random.rand(2)       #产生形状为(2,)的数组，也就是相当于有两个元素的一维数组
np.random.rand(2, 4)    #产生一个形状为(2,4)的数组，数组中的每个元素是[0,1)之间均匀分布的随机浮点数
```

```python
# numpy.random.random(size)，产生(0,1)之间的随机浮点数，非均匀分布
# numpy.random.random_sample、numpy.random.ranf、numpy.random.sample用法与该函数类似

'''
注意: 该函数和rand()的区别：
(1)random()参数只有一个参数"size”, 有三种取值: None、int型整数、int型元组
而在之前的numpy.random.rand()中可以有多个参数.
例如, 如果要产生一个3*3的随机数组(不考虑服从什么分布),
那么在rand中的写法是: numpy.random.rand(3,3),
而在random中的写法是: numpy.random.random((3,3))，这里面是个元组，是有小括弧的
(2)random()产生的随机数的分布为非均匀分布,
    numpy.random.rand()产生的随机数的分布为 均匀分布
'''

# 产生一个[0,1)之间的形状为(3,3)的数组
np.random.random((3,3))

# 产生[-5,0)之间的形状为(3,3)的随机数组, 即#5*[0,1)-5
5 * np.random.random_sample((3,3)) - 5

# 产生[5,10)之间的形状为(3,3)随机数组, 即10 * [0,1) - 5 * [0,1) + 5
(10 - 5) * np.random.random_sample((3,3)) + 5
```

```python
# uniform(low=0.0, high=1.0, size=None)，从指定范围内产生均匀分布的随机浮点数
# 如果在seed()中传入的数字相同，那么接下来生成的随机数序列都是相同的，
# 仅作用于最接近的那句随机数产生语句

# 默认产生一个[0,1)之间随机浮点数
np.random.uniform()

# 默认产生一个[1, 5)之间的形状为(2, 4)的随机浮点数
np.random.uniform(1, 5, size=(2,4))
```

```python
# numpy.random.randn(d0, d1, ..., dn)
# 产生服从 标准正态分布(均值为0，方差为1) 的随机浮点数，使用方法和rand()类似
np.random.rand(2)   # 产生形状为(2,)的数组
np.random.rand(2,4) # 产生一个形状为(2,4)的数组
# 如果要指定正态分布的均值和方差，则可使用下列公式，sigma*np.random.randn(...)+ mu:
# 2.5 * np.random.randn(2,4) + 3    # 2.5是标准差(注意2.5不是方差)，3是期望
```

```python
# numpy.random.normal(loc=0.0, scale=1.0, size=None)，
# 产生服从 正态分布(均值为 loc，标准差为scale)的随机浮点数
np.random.normal(1, 10, 1000)       # 产生均值为1标准差为10形状为(1000,)的数组
np.random.normal(3, 2, size=(2, 4)) # 产生均值为3标准差为2形状为(2,4)的数组
```

```python
# numpy.random.randint(low[, high, size, dtype])，
# 产生[low,high)之间的随机整数，如果high不指明，则产生[0, low)之间的随机整数
# size可以是int整数，或者int型的元组，表示产生随机数的个数，或者随机数组的形状
# dtype表示具体随机数的类型，默认是int，可以指定成int64
# 早期版本中该函数的形式为numpy.random.random_integers()

np.random.randint(10)           # 产生一个[0,10)之间的随机整数
np.random.randint(10, size=8)   # 产生[0,10)之间的随机整数8个，以数组的形式返回

# 产生[5,10)之间的形状为(2,4)的随机整数8个，以数组的形式返回
np.random.randint(5, 10, size=(2, 4))
```

```python
# numpy.random.choice(a, size=None, replace=True, p=None),
# 从一维array a中按概率p选择size个数据，若a为int，则从np.arrange(a)中选择，
# 若a为array，则直接从a中选择

# 从np.arrange(5)中等概率选择3个，等价于ng.randon.randint(0,5,3)
np.random.choice(5, 3)

# 从np.arrange(5)中按概率p选择3个
np.random.choice(5, 3, p=[0.1, 0, 0.3, 0.6, 0])

np.random.choice(5, 3, replace=False, p=[0.1, 0, 0.3, 0.6, 0.1])
aa_milne_arr = ['pooh', 'rabbit', 'piglet', 'Christopher']
np.random.choice(aa_milne_arr, 5, p=[0.5, 0.1, 0.1, 0.3])
```

```python
# numpy.random.shuffle(x)，按x的第一个维度进行打乱，x只能是array
# 对np.arange(9).reshape((3, 3))打乱
np.random.shuffle(np.arange(9).reshape((3, 3)))
```

```python
# numpy.random.permutation(x)，按x的第一个维度进行打乱，
# 若a为int，则对np.arrange(a)打乱，若a为array，则直接对a进行打乱
np.random.permutation(10) # 对np.arrange(10)打乱

# 对np.arange(9).reshape((3, 3))打乱
np.random.permutation(np.arange(9).reshape((3,3)))
```

```python
# 如果在seed()中传入的数字相同，那么接下来生成的随机数序列都是相同的，
# 仅作用于最接近#的那句随机数产生语句
np.random.seed(10)

templ = np.random.rand(4) #array( [0.77132064, 0.02075195, 0.63364823, 0.74880388])
np.random.seed(10)
temp2 = np.random.rand(4) #array([0.77132064,0.02075195， 0.63364823， 0.74880388])
temp3 = np.random.rand(4) #array([0.49850701, 0.22479665,0.19806286, 0.76053071])
#上述temp1和temp2是相同的，temp3是不同的，因为seed仅作用于最接近的那句随机数产生语句
```

```python
# numpy.linspace(start, stop, num=50, endpoint=True, retstep=False, dtype=None, axis=0)
# 区间均等分
np.linspace(2.0, 3.0, num=5)                    # array([2., 2.25, 2.5, 2.75, 3.])
np.linspace(2.0, 3.0, num=5, endpoint =False)   # array([2.，2.2, 2.4, 2.6, 2.8])
np.linspace(2.0, 3.0, num=5, retstep=True)      #(array([2., 2.25, 2.5, 2.75, 3.]), 0.25)
```

```python
# zeros()、ones()、empty()三者用法一样，np.zeros(3,dtype=int) np.zeros((2,3))
# 使用empty()时需要对生成的每一个数进行重新赋值，否则即为随机数，所以慎重使用
# np.eye(2, 3, k=1)和np.identity(3): np.identity只能创建方形矩阵,
# np.eye可以创建矩形矩阵，且k值可以调节，为1的对角线的位置偏离度，0居中，1向上偏离1，2偏离2，以此类推，-1向下偏离，
# 值的绝对值过大就偏离出去了，整个矩阵就全是0了 np.diag 可以创建对角矩阵
```

## 数组的索引，切片

ndarray 的索引、切片与 list 稍不同，它只有一个'[]'，代码如下。

```python
arr = np.array([ [[1, 2, 3],[4, 5, 6]], [[7, 8, 9],[10, 11, 12]] ])
a1 = arr[0, :]
print(a1)   # [[1, 2, 3], [4, 5, 6]]
a2 = arr[0, 0, 0]
print(a2)   # 1
```

可以看到 ndarray 的切片索引方法就是：对象[x, y, z, ...]先行后列，依据对象的纬度输入的参数也不同。对于 ndarray 来说，以下两种索引方式均可以

```python
a = [[1, 2, 3],[4, 5, 6]], [[7, 8, 9],[10, 11, 12]]
b = np.array(a)
print(b[0, 1])  # array([4, 5, 6])
print(b[0][1])  # array([4, 5, 6])
```

而对于二维的 list 而言，只能使用[][]索引

```python
a = [[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [10, 11, 12]]
# b = np.array(a)
# print(a[0, 1]), 该种索引方式会报错
print(a[0][1])  # [4, 5, 6]
```

## 形状修改

通过 ndarray.T 可以实现一个矩阵的转置，代码如下。

```python
arr = np.array([[1, 2],[3, 4]])
print(arr.T)  # [[1, 3],[2, 4]]
```

通过 ndarray.reshapre()将 arr 变成一个 1 行 4 列的数组，reshape()实际上是将原来的数组压平成一维数组，然后再重新排序成目标形状，但不改变原数组，代码如下。

```python
new_arr = arr.reshape([1, 4])
print(new_arr)  # [[1, 2, 3, 4]]
```

通过 ndarray.resize()实现改变结构，但是 resize()会改变原数组，而不是直接返回一个新数组，代码如下。

```python
arr.resize([1, 4])
print(arr)  # [[1, 2, 3, 4]]
```

通过 np.repeat(a,reps,axis)，可以实现对原数组的复制、重构，其中，a 是目标数组；reps 是重复的次数；axis 标识沿某个方向复制，若 axis=0，则沿第 0 个维度变化的方向复制，即增加了行数，若 axis=None，则原数组会被展平成一维数组，代码如下。

```python
arr = np.array([[1, 2], [3, 4]])
flat_arr = np.repeat(arr, 2)
re_arr = np.repeat(arr, 2, axis = 1)
print(flat_arr) # [1, 1, 2, 2, 3, 3, 4, 4]
print(re_arr)   # [[1, 1, 2, 2], [3, 3, 4, 4]]
```

np.tile(a, reps)也可以通过复制原数组构建新的数组，其中，a 是目标数组；reps 是重复的次数。相较于 np.repeat()，np.tile()的参数更少，但是实现的功能是类似的，不过其复制的规则不同，np.tile()是对整个 array 进行复制，np.repeat()是对其中的元素进行复制，代码如下。

```python
arr = np.array([[1, 2], [3, 4]])
flat_arr = np.tile(arr, 2)
tile arr = np.tile(arr, (2, 1))
print(tile_arr) # [[1, 2]，[3,4], [1,2]，[3,4]]
print(flat_arr) # [1,1,2,2,3,3,4,4]
```

通过 np.concatenate((a, b), axis) 可以实现对数组的连接，其中，a、b 分别标识两个数组；axis 表示沿着第几个维度叠加，例如，axis=0 时，即沿第 0 个维度变化的方向相加，代码如下。

```python
a = [[1, 2], [3, 4]]
b = [[10, 11], [12, 13]]
res1 = np.concatenate((a, b), axis = 0)
print(res1)  # [[1, 2], [3, 4], [10, 11], [12, 13]]
res2 = np.concatenate((a, b), axis = 1)
print(res2)  # [[1, 2, 10, 11], [3, 4, 12, 13]]
```

此外，np.vstack((a, b))的作用与 np.concatenate((a, b), axis=0)相似，np.hstack((a, b))的作用与 np.concatenate((a, b), axis=1)相似，代码如下。

```python
v_res = np.vstack((a, b))
print(v_res)  # [[1, 2], [3, 4], [10, 11], [12, 13]]
h_res = np.hstack((a, b))
print(h_res)  # [[1, 2, 10, 11], [3, 4, 12, 13]
```

## 数组元素类型修改

首先生成一个数组，代码如下。

```python
arr = np.array([[1, 2], [3, 4]])
```

可以通过 ndarray.astype(str)将这个数组中的每个元素都变成 string 类型，该方法不改变原数组，而是返回一个新数组，代码如下。

```python
arr1 = arr.astype(str)
print(arr1)  # [['1' '2'], ['3' '4']]
```

## 数组的通用函数

通过 np.unique()可以除去现有数组中重复的元素，返回一个没有重复元素的一维数组，且这个方法不会改变原数组，代码如下。

```python
arr = np.array([[1, 1, 2, 3], [1, 22, 34，5]])
unigue = np.unique(arr)
print(unique)   # [1, 2, 3, 5, 22, 34]
```

如果按某个维度去除重复元素，则使用 axis 指定某一维度，代码如下。\

```python
a = [[1, 2, 3], [4, 5, 6]], [[1, 2, 3], [4, 5,6]]
b = np.array(a)
c = np.unigue(b, axis=0)
print(c) # array([ [[1, 2, 3], [4, S, 6]]])
```

通过 np.intersectld() 和 np.unionld() 可以分别求两个矩阵的交集和并集，代码如下。

```python
a = [1, 2, 3, 4]
b = [3, 4, 5, 6]
print(np.intersectld(a, b)) # [3；4]
print(np.unionld(a,b))      # [1, 2, 3, 4, 5, 6]
```

NumPy 中还有一些常用的一元函数、二元函数，可以对原数组进行操作，直接修改原数组的元素。

np.abs()可以计算浮点数、整数或复数的绝对值，代码如下。

```python
a = [-1, 2, -3, 4]
print(np.abs(a))    # [1, 2,3, 4]
```

np.sqrt()可以计算元素的平方根，相当于 Python 中的“\*\*”，代码如下。

```python
b = [3, 4, 5,6]
print(np.sqrt(b))   # [1.73205081，2，2.23606798，2.44948974]
```

np.square()可以计算各元素的平方，np.exp()可以计算各元素的 e 指数，np.power(arr,t)可以计算数组中各元素的 t 次方，代码如下。

```python
a = [-1, 2, -3, 4]
print(np.square(a)) # [1, 4, 9, 16]
print(np.exp(a))    # [3.67879441e-01,7.38905610e + 00,4.97870684e-02,5.45981500e+01]
print(np.power(a, 3))   #[-1, 8, -27, 64]
```

np.isnan()可以判断数组中哪些元素是空值，代码如下。

```python
c = [1, np.nan, 3, 5]
print(np.isnan(c))  # [False, True, False, False]
```

np.where()可以对数组进行筛选，有两种用法。

第一种用法为 np.where(condition, x, y)：x，y 是两个数组，condition 指选择条件，若满足条件则输出 x，否则输出 y。

第二种用法为 np.where(condition)：condition 是一个条件，数组中满足条件的元素所在位置输出为 1，否则输出 0。

np.where()的实现代码如下。

```python
a = [[1, 2], [3, 0]]
b = [[7, 8], [9, 1]]
print(np.where([[True, True], [False, False]], a, b)) # [[1, 2], [9，0]]
c = np.array(a)
print(np.where(c>1)) # (array([0, 1], dtype=int64), array([1, 0], dtype=int64))
```

NumPy 也实现了三角函数的计算，如 np.sin()、np.cos()、np.tan()等，代码如下。

```python
a = [-1, 2, -3, 4]
print(np.sin(a))    # [-0.84147098, 0.90929743, -0.14112001, -0.7568025]
print(np.cos(a))    # [0.54030231, -0.41614684, -0.9899925, -0.65364362]
print(np.tan(a))    # [-1.55740772, -2.18503986, 0.14254654, 1.15782128]
```

## 数组中的线性代数

NumPy 中的 np.linalg 模块实现了许多矩阵的基本操作，如求对角线元素、求对角线元素的和(求迹)、矩阵乘积、求解矩阵行列式等。这一部分将简要介绍其中一些函数的用法。

首先生成两个数组，代码如下。

```python
a = [1, 2, 3]
b = [[1, 3, 9], [2, 7, 0], [4, 3, 2]]
```

np.diag(matrix)函数中，matirx 为一个矩阵，当 matrix 为二维数组时，以一维数组的形式返回方阵的对角线；当 matrix 为一维数组时，则返回非对角线元素均为 0 的方阵，代码如下。

```python
print(np.diag(a))   # [[1, 0, 0], [0, 2, 0], [0, 0, 3]]
print(np.diag(b))   # [1, 7, 2]
```

np.trace()可以计算矩阵对角线元素的和，代码如下。

```python
print(np.trace(b))  # 10
```

np.dot()可以实现矩阵乘积，代码如下。

```python
print(np.dot(b, a)) # [34, 16, 16]
```

np.det()可以计算矩阵的行列式，代码如下。

```python
print(np.linalg.det(b)) # -196.00000000000009
```

np.linalg.eig()可以计算方阵的特征值、特征向量，eig 变量的第一项存储了方阵 b 的特征值，第二项存储了特征向量，代码如下。

```python
eig = np.linalg.eig(b)
print(eig[0])   # [-4.40641364, 9.92452468, 4.48188896]
print(eig[1])   # [[0.86881121, -0.6982852, 0.69750503],
                #  [-0.15233731, -0.47753756, -0.55399068],
                #  [-0.47112676, -0.53325009, 0.4545119]】
```

np.linalg.inv()可以计算矩阵的逆，代码如下。

```python
print(np.linalg.inv(b))
#[[-0.07142857, -0.10714286, 0.32142857],
# [0.02040816, 0.17346939, -0.09183673],
# [0.1122449, -0.04591837, -0.00510204]]
```

np.linalg.solve(A, b)可以求解线性方程组 Ax=b，A 为一个方阵，代码如下。

```python
print(np.linalg.solve(b,a)) # [0.67857143,0.09183673，0.00510204]
```

np.linalg.svd(a, full_matrices=1, compute_uv=1)可以用于矩阵的奇异值分解，返回该矩阵的左奇异值(u)、奇异值(s)、右奇异值(v)。

其中，a 是一个(M，N)矩阵；full.matrices 取值为 1 或 0(默认值为 1)，取值为 1 时，u 的大小为(M，M)，否则 u 的大小为(M，K)，v 的大小为(K，N)(K=min(M，N))；compute_uv 取值为 0 或 1(默认值为 1)，当取值为 1 时，计算 u、s、v，否则只计算 s，代码如下。

```python
svd = np.linalg.svd(b)
```

变量 svd 有三个分量，第一个分量是左奇异值，第二个分量是奇异值，第三个分量是右奇异值。

## 数组统计分析

1.  np.sum(a, axis)计算数组 a 沿指定轴的和；
2.  np.mean(a, axis)计算数组 a 沿指定轴的平均值；
3.  min(axis)和 a.max(axis)用于获取数组 a 沿指定轴的最小值和最大值；
4.  np.std(a, axis)计算数组 a 沿指定轴的标准差；
5.  np.var(a, axis)计算数组 a 沿指定轴的方差；
6.  np.argmin(a, axis)和 np.argmax(a, axis)分别用于获取数组 a 沿指定轴的最小值和最大值的索引。

> 注: axis=None 时，会返回所有元素的和；axis=0 时，会沿着第 0 个维度（也就是列）的变化方向进行计算，即按列求和；axis=1 时，则为按行求和，以此类推，代码如下。

```python
a = np.array([[1, 2, 3], [4, 5, 6]])
print(np.sum(a))            # 21
print(np.sum(a, axis=0))    # [5, 7, 9]
print(np.mean(a, axis=1))   # [2, 5]
print(a.min(axis=0))        # [1, 2, 3]
print(np.std(a, axis=1))    # [0.81649658, 0.81649658]
print(np.argmax(a, axis=1)) # [2, 2]
```

# NumPy 读取和写入文件

NumPy 可以读写文本文件，后缀名为.npy 的二进制文件，后缀名为.dat 的多维数组文件。

注意：NumPy 不能读写 Excel 文件，读写 Excel 文件可使用 Pandas。

## 读写文本文件

NumPy 中读取 CSV 或 txt 格式的文本文件可以使用 numpy.loadtxt()函数，此函数最常用的参数为

```python
numpy.loadtxt(
    fname,
    dtype=<class 'float'>,
    delimiter=None,
    skiprows=0,
    encoding='bytes',
    max_rows=None)
```

其中，fname 为要导人文件的路径和名称，dtype 为结果数组的数据类型，delimiter 为加载文件的分隔符，默认为空格，skiprows 为从开始跳过第一行的行数，encoding 为用于解码输入文件的编码，默认为 bytes,max_rows 为读取 skiprows 行后的最大行数，除了 fname 外，其余参数均可选。返回值为读取的 n 维数组，代码如下。

```python
import numpy as np
a = np.loadtxt('test.txt')
print(a)
```

如果要将数组保持原格式写入 txt 或者 CSV 格式的文件中去，使用 numpy.savetxt()函数，常用参数与 loadtxt()函数的相同，代码如下。

```python
import nunpy as np
data = np.ones((2,3))
np.savetxt(fname="./test.csv", X=data, deliniter=',', encoding='utf- 8')
#保存一个2行3列元素值全为1的数组
```

## 读写二进制文件

NumPy 可以将数组保存为.npy 二进制文件。NumPy 中读取二进制文件使用 numpy.load(file)函数，写入二进制文件使用 numpy.save(file,array)函数，其中，file 是文件路径与名称，array 是数组变量，代码如下。

```python
import numpy as np
a = np.arange(15).reshape(3,5)
np.save("a.npy", a)
b = np.load("a.npy")
```

## 读写多维数据文件

NumPy 中还可以使用 numpy.fromfile(file, dtype=float, count=-1, sep='')函数读取后缀名为.dat 的多维数据文件，file 为文件的路径和名称，dtype 为读取的数据类型，count 为读取的元素个数，sep 为数据分隔符。

NumPy 写入多维数据文件使用 tofile()数，格式为 a.tofile(file, sep='', format='%s')，其中，file 为文件的路径和名称，sep 为数据分隔符，format 为写入数据的格式，两者也需要配合使用，代码如下。

```python
import numpy as np
a = np.arange(100).reshape(5, 10, 2)
a.tofile('b.dat', sep=',', format='d')
c = np.fromfile('b.dat', dtype=np.int, sep=',')
```
