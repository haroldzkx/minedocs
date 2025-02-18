# matplotlib 中文乱码问题解决

查看 matplotlib 系统自带的字体

```python
# 查询当前系统所有字体
from matplotlib.font_manager import FontManager
import subprocess

mpl_fonts = set(f.name for f in FontManager().ttflist)

print('all font list get from matplotlib.font_manager:')
for f in sorted(mpl_fonts):
    print('\t' + f)
```

运行结果如下：

```text
all font list get from matplotlib.font_manager:
	DejaVu Sans
	DejaVu Sans Display
	DejaVu Sans Mono
	DejaVu Serif
	DejaVu Serif Display
	STIXGeneral
	STIXNonUnicode
	STIXSizeFiveSym
	STIXSizeFourSym
	STIXSizeOneSym
	STIXSizeThreeSym
	STIXSizeTwoSym
	WenQuanYi Micro Hei
	WenQuanYi Zen Hei
	cmb10
	cmex10
	cmmi10
	cmr10
	cmss10
	cmsy10
	cmtt10
```

从结果里找一个中文字体，然后添加如下代码就可以解决。

> 注意：每个系统里内置的字体不一样，要自己挑一下字体，然后再用下面的代码

```python
# 设置支持中文字体
import matplotlib
matplotlib.rc('font', family='WenQuanYi Micro Hei')

# 或者添加如下代码
plt.rc('font', family='WenQuanYi Micro Hei')
```
