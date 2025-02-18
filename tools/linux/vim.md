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

# 配置目录

```bash
~/.vim/autoload/它是一个非常重要的目录，尽管听起来比实际复杂。简而言之，它里面放置的是当你真正需要的时候才被自动加载运行的文件，而不是在vim启动时就加载。
~/.vim/colors/是用来存放vim配色方案的。
~/.vim/plugin/存放的是每次启动vim都会被运行一次的插件，也就是说只要你想在vim启动时就运行的插件就放在这个目录下。我们可以放从vim-plug官方下载下来的插件.vim
~/.vim/syntax/语法描述脚本。我们放有关文本（比如c语言）语法相关的插件
~/.vim/doc/为插件放置文档的地方。例如:help的时候可以用到。
~/.vim/ftdetect/中的文件同样也会在vim启动时就运行。有些时候可能没有这个目录。ftdetect代表的是“filetype detection（文件类型检测）”。此目录中的文件应该用自动命令（autocommands）来检测和设置文件的类型，除此之外并无其他。也就是说，它们只该有一两行而已。
~/.vim/ftplugin/此目录中的文件有些不同。当vim给缓冲区的filetype设置一个值时，vim将会在~/.vim/ftplugin/ 目录下来查找和filetype相同名字的文件。例如你运行set filetype=derp这条命令后，vim将查找~/.vim/ftplugin/derp.vim此文件，如果存在就运行它。不仅如此，它还会运行ftplugin下相同名字的子目录中的所有文件，如~/.vim/ftplugin/derp/这个文件夹下的文件都会被运行。每次启用时，应该为不同的文件类型设置局部缓冲选项，如果设置为全局缓冲选项的话，将会覆盖所有打开的缓冲区。
~/.vim/indent/这里面的文件和ftplugin中的很像，它们也是根据它们的名字来加载的。它放置了相关文件类型的缩进。例如python应该怎么缩进，java应该怎么缩进等等。其实放在ftplugin中也可以，但单独列出来只是为了方便文件管理和理解。
~/.vim/compiler/和indent很像，它放的是相应文件类型应该如何编译的选项。
~/.vim/after/这里面的文件也会在vim每次启动的时候加载，不过是等待~/.vim/plugin/加载完成之后才加载after里的内容，所以叫做after。
~/.vim/spell/拼写检查脚本。
```

# 配置成 IDE

## 添加 python 语言支持

```bash
sudo apt install vim-nox
```

.vimrc 中启用 Python3 支持

```bash
if has('python3')
  let g:python3_host_prog = '/usr/bin/python3'  " 根据实际情况调整Python3路径
endif
```

## vim-plug

```bash
# 在线安装
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# 离线安装
# 下载文件https://github.com/junegunn/vim-plug/blob/master/plug.vim
# 将plug.vim放到目录中
mkdir -p  ~/.vim/autoload/
cp plug.vim ~/.vim/autoload/plug.vim
```

配置文件

```bash
call plug#begin('~/.vim/plugged')

" 示例插件（按需添加，这里是neovim的插件安装示例）
Plug 'https://gitcode.com/scrooloose/nerdtree'  " 文件树

call plug#end()
```

基础命令

```bash
# 安装插件
:PlugInstall

# 卸载插件
:PlugClean

# 更新vim-plug插件自身
:PlugUpgrade

# 更新所有已安装的插件
:PlugUpdate

# 查看当前已安装插件的状态信息
:PlugStatus
```

## NERDTree

```bash
" 二选一
Plug 'https://gitcode.com/scrooloose/nerdtree'
Plug 'scrooloose/nerdtree'
```

```bash
" 自动启用NERDTree: .vimrc最后加入一句
autocmd VimEnter * NERDTree
```

```bash
# 常用操作
左右栏切换：ctrl + w
```

## Auto Pairs

```bash
Plug 'jiangmiao/auto-pairs'
```
