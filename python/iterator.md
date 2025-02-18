# 迭代器

迭代器对象从集合的第一个元素开始访问，直到所有的元素被访问完结束。迭代器只能往前不会后退。

迭代器有两个基本的方法：

**iter()**：创建迭代器对象

**next()**：迭代迭代器对象

迭代器对象可以使用常规 for 语句进行遍历：

```python
list=[1,2,3,4]
it = iter(list)    # 创建迭代器对象
for x in it:
    print (x, end=" ")
```

也可以使用 next() 函数：

```python
import sys         # 引入 sys 模块

list=[1,2,3,4]
it = iter(list)    # 创建迭代器对象

while True:
    try:
        print (next(it))
    except StopIteration:
        sys.exit()
```

把一个类作为一个迭代器使用需要在类中实现两个方法`__iter__()`与`__next__()` 。

`__iter__()`方法返回一个特殊的迭代器对象， 这个迭代器对象实现了`__next__()`方法并通过 StopIteration 异常标识迭代的完成。

`__next__()`方法（Python 2 里是 next()）会返回下一个迭代器对象。

例如：创建一个返回数字的迭代器，初始值为 1，逐步递增 1：

```python
class MyNumbers:
    def __iter__(self):
        self.a = 1
        return self

    def __next__(self):
        x = self.a
        self.a += 1
        return x

myclass = MyNumbers()
myiter = iter(myclass)

print(next(myiter))
print(next(myiter))
print(next(myiter))
print(next(myiter))
print(next(myiter))
```

StopIteration 异常用于标识迭代的完成，防止出现无限循环的情况，在`__next__()`方法中我们可以设置在完成指定循环次数后触发 StopIteration 异常来结束迭代。

在 20 次迭代后停止执行：

```python
class MyNumbers:
    def __iter__(self):
        self.a = 1
        return self

    def __next__(self):
        if self.a <= 20:
            x = self.a
            self.a += 1
            return x
        else:
            raise StopIteration

myclass = MyNumbers()
myiter = iter(myclass)

for x in myiter:
    print(x)
```
