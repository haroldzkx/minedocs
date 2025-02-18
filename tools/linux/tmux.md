# 【Tmux】

- tmux 使用手册：[http://louiszhai.github.io/2017/09/30/tmux/](http://louiszhai.github.io/2017/09/30/tmux/)
- tmux 官方文档：[https://github.com/tmux/tmux/wiki/Getting-Started](https://github.com/tmux/tmux/wiki/Getting-Started)
- tmux 命令详解：[http://man.openbsd.org/OpenBSD-current/man1/tmux.1](http://man.openbsd.org/OpenBSD-current/man1/tmux.1)
- tmux GitHub 官方 wiki：[https://github.com/tmux/tmux/wiki](https://github.com/tmux/tmux/wiki)

---

Server > Session > Window > Pane

- Server：是整个 tmux 的后台服务。有时候更改配置不生效，就要使用 tmux kill-server 来重启 tmux
- Session：是 tmux 的所有会话。一般只要保存一个 session 就足够了
- Window：相当于一个工作区，包含很多分屏，可以针对每种任务分一个 Window
- Pane：是在 Window 里面的小分屏。最常用也最好用

# session 会话

```bash
# 创建新的会话tmux
tmux

# 创建新的会话，命名为test_name
tmux new -s test_name

# 创建新的会话，命名为test_name，但不进入会话
tmux new -s test_name -d

# 默认进入第一个会话
tmux a

# 进入到名称为test_name的会话
tmux a -t test_name

# 离开会话
Ctrl + b d
tmux detach

# 查看已创建会话
tmux ls

# 切换会话
Ctrl + b s

# 仅仅删除test会话(即使是attached状态,也会删除)
tmux kill-session -t test

# 删除所有会话(attached状态的会略过)
tmux kill-session
```

# window 窗口

```bash
# 在会话中创建新的窗口
Ctrl + b c

# 切换窗口
Ctrl + b w
Ctrl + b 窗口对应的数字
# 切换到标号为 2 的窗口
Ctrl + b 2

# 重命名当前窗口
Ctrl + b ,
tmux rename-window 窗口名称

# 创建新窗口并命名
tmux new-window -n 窗口名称

# 退出并删除窗口
Ctrl + d
exit
```

# pane 窗格

## 切分窗口为窗格

```shell
# 左右分割
Ctrl + b %

# 上下分割
Ctrl + b "

# 窗格之间切换
Ctrl + b 方向键/ h j k l
```

## 调整 pane 的大小

```bash
Ctrl + b :resize-pane -U # 向上
Ctrl + b :resize-pane -D # 向下
Ctrl + b :resize-pane -L # 向左
Ctrl + b :resize-pane -R # 向右

# 在上下左右的调整里，最后的参数可以加数字 用以控制移动的大小
Ctrl + b :resize-pane -D 10

# 最大化当前面板，再重复一次按键后恢复正常
Ctrl + b z
```

# 翻屏

- `ctrl+b`，`[`：进入 tmux 翻屏模式。实现翻页，翻屏
- 上下键：实现上下翻页
- q 键：退出翻屏模式
- 用 vim 的翻屏操作

# 其他

```bash
# 显示时钟
Ctrl + b t

# 列出所有快捷键
tmux list-keys

# shell中使用：使用send命令进行推送, 结尾可以加一个enter, 直接回车
tmux send -t test_name "cmd" enter
```

# 复制文本

```bash
# 1.进入复制模式
Ctrl + b, [

# 2.开始复制，移动光标选择复制区域
空格键

# 3.复制选中文本并退出复制模式
回车键

# 4.粘贴文本
Ctrl + b, ]
```

# 配置文件

```powershell
# 设置像 vim 一样翻屏
setw -g mode-keys vi

# 会话计数：从 1 开始
set -g base-index 1

# 窗口计数：从 1 开始编号，而不是从 0 开始
set -g pane-base-index 1

# vim 风格的快捷键实现窗格间移动
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# 将 F5 绑定为前缀键
unbind C-b
set-option -g prefix F5
bind-key F5 send-prefix
```

```bash
tmux source-file ~/.tmux.conf
```

# 配置一登录就进入 tmux

在.bashrc 中添加如下内容，然后 `source ~/.bashrc`

```bash
# 启动或附加到tmux会话
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach || tmux new -s harold
fi
tmux ls
```
