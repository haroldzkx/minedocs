# 插入 Python 代码

在这个 GitHub 库（https://github.com/olivierverdier/python-latex-highlighting）里下载pythonhighlight.sty文件，放到和tex文件同一个目录下面。

在导言区加入：

```latex
\usepackage{graphicx}
\usepackage{pythonhighlight}
```

在正文部分加入：

```latex
\begin{python}
import numpy as np
import pandas as pd
print('why use Matlab?')
\end{python}
```
