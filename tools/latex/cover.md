# 插入封面

参考链接：https://zhuanlan.zhihu.com/p/164590399

在导言区插入如下代码。

```latex
\usepackage{pdfpages}
```

在正文部分插入如下代码

```latex
\begin{titlepage}
    \includepdf[pages={1}]{cover.pdf}
\end{titlepage}
```
