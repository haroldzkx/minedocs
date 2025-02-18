# 【分文件编写与条件编译】

# 分文件编写

[https://www.itdaan.com/blog/2013/10/27/d234a613a7a848951e360180250f3b61.html](https://www.itdaan.com/blog/2013/10/27/d234a613a7a848951e360180250f3b61.html)

一般来说 latex 提供了两种包含子文件的方法：

`\input`和`\include`

一般编写书籍的时候使用`\include`，并且一章一个文件，因为它会自动给每个被`include`的部分创建一个新页。而写论文的时候多用`\input`。

需要提一下，导言区只需要宿主文件有就可以了，被包含的文件会沿用它。

## 用法

```latex
\input{chapter1}
\include{chapter2}
```

注意不加.tex 的后缀。

## 区别

- \input  
  它完全相当于 C/C++语言中的#include，可以理解为只起一个文本替换的作用。  
  因而，它可以嵌套使用。可以在任何位置使用（特别强调一下：可以在导言区使用）。  
  但是，任何一个子文件修改后，都需要对全文进行重新编译。所以对于编译有好几百页的书籍来说用它来管理章节是不太方便的（但是各个章节内部可以使用它），但对于论文，这点额外时间完全可以接受。  
  由于它只是一个文本替换，因而如果想只编译某些章节，那么所有的自动编号都会根据现在的内容重新编排。即如果第一章有 3 个公式，那么第二章的第一个公式应该是“公式 4”，如果我把第一章的\input 注释掉，那么第二章第一个公式会是“公式 1”。同样的情况还出现在图标、章节等所有自动编号上。
- \include  
  为了实现不改变最终效果（编号等资源的显示）的部分章节调试，可以使用\include 和与之配套的\includeonly。  
  它类似于编程中编译好的库文件。  
  它只能用在正文区，用来引入正文。  
  每个\include 的部分开始时会新起一页。  
  在某个部分修改的时候，针对宿主文件的重新编译不会影响其他文件。因而很节约编译时间。  
  如果只想在生成的文件中显示部分章节，不需要对正文区的\include 做任何操作，只需要在导言区写诸如\includeonly{chapter1,chapter3,chapter14}的一句就可以了。它表示只生成第 1、3、14 章。并且它不会因为把显示中间的章节，就把它们的自动编号空过去（但是如果在正文区注释掉了，那就另当别论了）。

# 条件编译

latex 可以使用：

```latex
\ifx...
...
\else
...
\fi
```

的结构执行条件指令。这在一些会议期刊所提供的 latex 模板中很常见，多是用来根据编译器版本选择合适的包和参数。

我们可以利用它来实现自动补完结构信息的功能。

如果你有 C/C++语言的相关知识，下面的概念会非常好理解，如果没有也没有关系，只需要按照后面“例 2”中黑体的部分操作就可以了。

我们可以在宿主文件中定义（\def）一个编译期常量，然后让各个子文件去检测这个常量是否存在，如果不存在就写入结构信息。

例如：

\def 的用法是这样的：\def\my_variable{hello}

它定义了一个名为“my_variable”的宏，它的内容是“hello”。

再在各个子文件中使用\ifx\my_variable\undefine 来检测这个宏是否没有定义（latex 没有提供"\defined"来检测是否已定义），并添加相应的内容。

## 例 1

```latex
%----------------my_paper.tex--------------
\documentclass{article}
%导言区\usepackage{...}
\begin{document}
\input{1-abstract}
\input{2-introduction}
\input{3-model}
\input{4-data}
\input{5-solve}
\input{6-conclusion}
\input{7-acknowledgment}
\bibliography{ref}
\bibliographystyle{abbrv}
\end{document}
%----------------1-abstract.tex---------------

\begin{abstract}
This paper .....
\end{abstract}
%-----------------2-introduction.tex------------

\section{Introduction}
..........
%----------------3-model.tex----------------

\section{Model}
............
\begin{equation}
........
\end{equation}
\subsection{Provement}
..............
```

## 例 2

由于导言区在每个独立编译的部分都中要使用，所以在这里可以将它也独立成一个文件（命名为 0-preamble.tex）。

```latex
%----------------my_paper.tex--------------
\input{0-preamble}
\def\all_in_one{all_in_one} % 条件编译
\begin{document}
\input{1-abstract}
\input{2-introduction}
\input{3-model}
\input{4-data}
\input{5-solve}
\input{6-conclusion}
\input{7-acknowledgment}
\bibliography{ref}
\bibliographystyle{abbrv}
\end{document}

%----------------0-preamble.tex---------------

\documentclass{article}
%导言区
\usepackage{...}

%----------------3-model.tex----------------
% 下面这一块属于条件编译
\ifx\all_in_one\undefined
\input{0-preamble}
\begin{document}
\fi

\section{Model}
............
\begin{equation}
........
\end{equation}
\subsection{Provement}
..............

% 下面这一块属于条件编译
\ifx\all_in_one\undefined
\end{document}
\fi
```
