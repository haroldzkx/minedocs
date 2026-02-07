# 【算法效率的度量】

# 时间复杂度

时间复杂度是用来评估算法时间开销的。

事前预估算法时间开销 $T(n)$ 与问题规模 $n$ 的关系。

> 大 $O$ 表示“同阶” ，同等数量级。

> 即当 $n \to \infty$ 时，时间复杂度 $T(n)$ 与问题规模 $f(n)$ 为同等数量级。

**加法规则：多项相加，只保留最高阶的项，且系数变为 1**

$$
T(n)=T_1(n)+T_2(n)=O(f(n))+O(g(n))=O(max(f(n),g(n)))
$$

**乘法规则：多项相乘，都保留**

$$
T(n)=T_1(n) \times T_2(n) = O(f(n)) \times O(g(n)) = O(f(n) \times g(n))
$$

例如：

$$
T_3(n) = n^3 + n^2 log_2n
= O(n^3) + O(n^2 log_2n)
= O(n^3)
$$

**大小判断公式：**（常对幂指阶）

$$
O(1) < O(log_2n) < O(n) < O(nlog_2n) < O(n^2) < O(n^3) < O(2^n) < O(n!) < O(n^n)
$$

结论 1：顺序执行的代码只会影响常数项，可以忽略。

结论 2：只需挑循环中的一个基本操作（循环）分析它的执行次数与$n$的关系即可。

结论 3：如果有多层嵌套循环，只需关注最深层循环循环了几次。

下面给出几个例子，进行时间复杂度分析：

循环：

```c
void loveYou(int n){ //n为问题规模
    int i = 1;
    while( i <= n ){
        i++;
        printf("I love you %d\n", i);
        for ( int j = 1; j <= n; j++ ){
            printf("I am Iron Man ");
        }
    }
    printf("I love you more than %d \n", n);
}
```

时间开销与问题规模 $n$ 的关系：$T(n) = O(n) + O(n^2) = O(n^2)$。

> 注：只需要关注最深层循环循环了几次。

指数递增型：

```c
void loveYou(int n){ //n为问题规模
    int i = 1;
    while( i <= n ){
        i = i * 2;
        printf("I love you %d\n", i);
    }
    printf("I love you more than %d\n", n);
}
```

设最深层循环的语句频度（总共循环的次数）为 $x$ ，

则循环结束时刚好满足 $2^x > n，x = log_2n + 1$

$T(n) = O(x) = O(log_2n) + O(1) = O(log_2n)$

搜索数字型：

```c
void loveYou(int flag[], int n){ //n为问题规模
    printf("I am Iron Man \n");
    for( int i = 0; i <= n; i++ ){
        if( flag[i] == n ){
            printf("I love you %d \n", n);
            break;
        }
    }
}
int flag[n] = {1...n};//flag数组中乱序存放了 1-n这些数
loveYou(flag, n);
```

最好情况：元素 n 在第一个位置 最好时间复杂度：$T(n) = O(1)$

最坏情况：元素 n 在最后一个位置 最坏时间复杂度：$T(n) = O(n)$

平均情况：假设元素 n 在任意一个位置的概率相同为 $\frac{1}{n}$

平均时间复杂度：$T(n) = O(n)$

> 计算过程：
> 循环次数 $x = (1+2+3+...+n)\frac{1}{n}=(\frac{n(1+n)}{2})\frac{1}{n}=\frac{1}{2} n + \frac{1}{2}$ > $T(n) = O(x) = O(\frac{1}{2}n)+O(1)=O(n)$

小结：

1.  如何计算：  
    ① 找到一个基本操作（最深层循环）。
    ② 分析该基本操作的执行次数 $x $与问题规模 $n$ 的关系$ x = f(n) $。
    ③ $x $的数量级 $O(x)$ 就是算法时间复杂度 $T(n)$。
2.  常用技巧：  
    加法规则：$O(f(n)) + O(g(n)) = O(max(f(n), g(n)))$
    乘法规则：$O(f(n)) \times O(g(n)) = O(f(n) \times g(n))$。
    常见的渐进时间复杂度：
    $O(1) < O(log_2n) < O(n) < O(nlog_2n) < O(n^2) < O(n^3) < O(2^n) < O(n!) < O(n^n)$
3.  三种复杂度：  
    最坏时间复杂度：考虑输入数据“最坏”的情况。  
    平均时间复杂度：考虑所有输入数据都等概率出现的情况下，算法的期望运行时间。  
    最好时间复杂度：考虑输入数据“最好”的情况。

# 空间复杂度

空间复杂度指程序运行时的内存需求。

$S(n)$为该算法所耗费的存储空间，它是问题规模 n 的函数。记为 $S(n) = O(g(n))$

一个程序在执行时除需要存储空间来存放本身所用的指令、常数、变量和输入数据外，还需要一些对数据进行操作的工作单元和存储一些为实现计算所需信息的辅助空间。若输入数据所占空间只取决于问题本身，和算法无关，则只需分析除输入和程序之外的额外空间。

1. 如何计算：

   普通程序：

   a. 找到所占空间大小与问题规模相关的变量。

   b. 分析所占空间 $x$ 与问题规模 $n$ 的关系 $x = f(n)$ 。

   c. $x$的数量级 $O(x)$ 就是算法空间复杂度 $S(n)$ 。

   递归程序：

   a. 找到递归调用的深度 $x$ 与问题规模 $n$ 的关系 $x = f(n)$ 。

   b. $x$ 的数量级 $O(x)$ 就是算法空间复杂度 $S(n)$ 。

> 注：有的算法各层函数所需存储空间不同，分析方法略有区别。

2.  常用技巧  
    加法规则：$O(f(n)) + O(g(n)) = O(max(f(n), g(n)))$
    乘法规则：$O(f(n)) \times O(g(n)) = O(f(n) \times g(n))$。
    常见的渐进时间复杂度：
    $O(1) < O(log_2n) < O(n) < O(nlog_2n) < O(n^2) < O(n^3) < O(2^n) < O(n!) < O(n^n)$

例如：

```c
void test(int n){
    int flag[n];//声明一个长度为n的数组
    int i;
    //此处省却其他代码
}
```

假设一个 int 变量占 4B

则所需内存空间 $= 4 + 4n + 4 = 4n + 8$

则空间复杂度为：$S(n) = O(4n+8) = O(4n) + O(1) = O(n)$

> 只需关注存储空间大小与问题规模相关的变量。

```c
void test(int n){
    int flag[n][n];//声明n*n的二维数组
    int other[n];
    int i;
    //此处省略其他代码
}
```

则空间复杂度为：$S(n) = O(n^2) + O(n) + O(1) = O(n^2)$

递归型 1：

```c
void loveYou(int n){
    int a,b,c;
    if(n > 1){
        loveYou(n-1);
    }
    printf("I love you %d \n", n);
}
int main(){
    loveYou(5);
}
```

此时，空间复杂度=递归调用的深度 $S(n) = O(n)$

递归型 2：

```c
void loveYou(int n){
    int flag[n];
    if(n > 1){
        loveYou(n-1);
    }
    printf("I love you %d \n", n);
}
int main(){
    loveYou(5);
}
```

此时，空间复杂度为：

$$S(n)=O(1+2+...+n)=O(\frac{n(1+n)}{2}) = O(\frac{1}{2}n^2)+O(\frac{1}{2}n)=O(n^2)$$
