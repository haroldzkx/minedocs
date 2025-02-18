# 【Vim】

# 配置文件

```bash
# ~/.vimrc
set showmatch         " Highlight parentheses

set number            " set line number

set cindent           " C-style indent

set autoindent

set tabstop=4         " set tab width
set softtabstop=4
set shiftwidth=4      " The uniform indentation is 4

syntax on

" Use a mix of absolute and relative line numbers
" Use absolute line numbers in Insert mode
" Use relative line numbers in other modes
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END
```

# 操作

```bash
#【文件及多窗口】
# 浏览目录。定位到文件所在行，回车进入指定文件
:Ex

# 列出缓冲列表。缓冲列表中保存最近使用文件，行头有标号
:ls

# 进入最近使用文件。进入缓冲列表的下个缓冲，即最近一次使用文件
:bn

# 进入缓冲列表中标号为 N 的文件。
# b 10 指 buffer 10，进入缓冲列表，即最近一次使用文件
:b[N]

# 在新窗口打开最近使用文件
# s 指 split，水平方向; v 指 vertical，垂直方向。
:sbn
:vbn

# 只保留当前窗口
:on(ly)
```

```bash
#【查找】
/ hello # 从光标所在位置向文件尾搜索

? hello # 从光标所在位置向文件头搜索

n   # 查找下一个

N   # 查找上一个

# 开始向文件头的方向搜索光标所在位置的单词的下一个出现位置
#

*   # 开始向文件尾的方向搜索光标所在位置的单词的下一个出现位置
```

```bash
#【替换】
# 给第 3，7，23 行添加注释
:g/^\v(3|7|23)/s/^/# /

# 给多行（5-10行）添加注释
:5,10s/^/# /
:5,10s/^/\/\//

# 替换多行（2-4行）内容：将test替换为demo
:2,4s/test/demo/g
```

```bash
#【删除文本】
dw	# 从光标当前的位置开始删除，直到删到单词最后
daw	# 直接删除光标所在的一个单词
bdw	# 将光标定位到单词首字母，然后删除整个单词
dd	# 删除整行

:5d     # 删除单行: 删除第5行
:5,10d  # 删除多行: 第5行到第10行的内容
:1d | 13d | 19d # 删除多个不连续的指定行
:.,+4d  # 删除从当前行开始往下数的 5 行
:.,$d   # 删除从当前行到文件结尾的内容
:%d     # 删除文件的所有内容
```

```bash
#【翻屏幕】
Ctrl + f[forward]	# 整页 向下 翻页
Ctrl + b[backward]	# 整页 向上 翻页
Ctrl + d[down]		# 半页 向下 翻页
Ctrl + u[up]		# 半页 向上 翻页
```
