# BibTex

```latex
% 导言区
\documentclass{ctexart} % ctexbook, ctexrep

% \usepackage{ctex}

% 正文区（文稿区）
\begin{document}
  % 一次管理，一次使用
  % 参考文献格式：
  % \begin{thebibliography}{编号样本}
    %   \bibitem[记号]{引用标志}文献条目1
    %   \bibitem[记号]{引用标志}文献条目2
    %   ...
    % \end{thebibliography}
  % 其中文献条目包括：作者，题目，出版社，年代，版本，页码等。
  % 引用时候要可以采用：\cite{引用标志1，引用标志2，...}

  引用一篇文章\cite{article1}
  引用一本书\cite{book1}等等。

  \begin{thebibliography}{99}
    % \emph{}命令用来强调参考文献中的某些内容
    % \texttt{}命令也有类似的效果
    \bibitem{article1}陈立辉,苏伟，蔡川，陈晓云.\emph{基于LaTeX的Web数学公式提取方法研究}[J]. 计算机科学. 2014(06)
    \bibitem{book1} William H. Press, Saul A. Teukolsky, William T. Vetterling, Brain P. Flannery, \emph{Numerical Recipes 3rd Edition: The Art of Scientific Computing}
    Cambridge University Press, New York, 2007.
    \bibitem{latexGuide} Kopka Helmut, W. Daly Patrick, \emph{Guide to \LaTeX}, $4^{th}$ Edition. Available at \texttt{http://www.amazon.com}.
    \bibitem{latexMath} Graetzer George, \emph{Math Into \LaTeX}, Birkhauser Boston; 3 edition (June 22, 2000).
  \end{thebibliography}

\end{document}
```

上面的做法不太方便，应该将参考文献抽出来，形成一个单独的文件。

# bib 文件

test.bib

```latex
% test.bib
@BOOK{mittelbach2004,
  title = {The {{\LaTeX}} Companion},
  publisher = {Addison-Wesley},
  year = {2004},
  author = {Frank Mittelbach and MIchel Goossens},
  series = {Tools and Techniques for Computer Typesetting},
  address = {Boston},
  edition = {Second}
}

@BOOK{mittelbach2001,
  title = {The {{\LaTeX}} Companion},
  publisher = {Addison-Wesley},
  year = {2004},
  author = {Frank Mittelbach and MIchel Goossens},
  series = {Tools and Techniques for Computer Typesetting},
  address = {Boston},
  edition = {Second}
}
```

latex.tex

```latex
% latex.tex
% 导言区
\documentclass{ctexart} % ctexbook, ctexrep

\usepackage{natbib} % 可以用这个宏包来使用更多参考文献的排版样式
\bibliographystyle{plain} % 指定参考文献的排版样式

% 正文区（文稿区）
\begin{document}

  这是一个参考文献的引用：\cite{mittelbach2004}

  % 用来将没有引用的参考文献也一同列出来
  % 也可以在{}中指定特定参考文献，*表示列出所有文件
  \nocite{*}
  % 指定参考文献数据库，可以不指定扩展名
  % 当有多个参考文献数据库，可以用逗号分隔
  \bibliography{test, cnki}

\end{document}
```

# BibLaTeX

```latex
% 导言区
\documentclass{ctexart} % ctexbook, ctexrep

% \usepackage{ctex}
% biblatex/biber
% 新的TEX参考文献排版引擎
% 样式文件（参考文献样式文件--bbx文件，引用样式文件--cbx文件）使用LaTeX编写
% 支持根据本地化排版，如：
%    biber -l zh__pinyin texfile，用于指定按拼音排序
%    biber -l zh__stroke texfile，用于按笔画排序
% 需要在文献工具中设置命令为：Biber
\usepackage[style=numeric, backend=biber]{biblatex}
\addbibresource{test.bib}

% 正文区（文稿区）
\begin{document}

  无格式化引用\cite{mittelbach2001}

  带方括号的引用\parencite{mittelbach2001}

  上标引用\supercite{mittelbach2001}

  \printbibliography[title={参考文献}]

\end{document}
```

# 编译文件

可以用批处理命令来编译文件

```bash
xelatex texFileName
biber -l zh__pinyin texFileName
xelatex texFileName
xelatex texFileName
del *.aux *.bbl *.bcf *.blg *.log *.xml
```
