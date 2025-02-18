# 【配置】

# 配置文件（用户名，邮箱）

```bash
# 一台电脑配置一次即可
git config --global user.email "你的邮箱"
git config --global user.name "你的用户名"
```

```bash
# local只对某个仓库有效（默认值）
# 项目配置文件：项目/.git/config
git config --local

# global对当前用户所有仓库有效
# 全局配置文件：~/.gitconfig
git config --global

# system对系统所有登录用户有效
# 系统配置文件：/etc/.gitconfig
git config --system

# 显示config的配置
git config --list --local
git config --list --global
git config --list --system
```

# .gitignore

让 Git 不再管理当前目录下的某些文件，参考：https://github.com/github/gitignore
例：

```bash
*.h
!a.h
files/
*.py[c|h|d]
```

# 免密码登陆

1. URL 中实现

   ```bash
   git remote add 仓库别名 https://用户名:密码@github.com/xxxx/xxxx.git
   git push 仓库别名 分支名
   ```

2. 公私钥实现 SSH 连接（这个去看 GitHub 官方文档）

# 远程仓库

```bash
# 查看远程仓库地址及别名
git remote -v

# 查看远程仓库详细信息
git remote show <remote>

# 添加远程仓库地址并设置别名
git remote add <shortname> <url>

# 重命名远程仓库地址
git remote rename <oldname> <newname>

# 删除远程仓库地址
git remote remove <shortname>
```

# 快速解决冲突

1. 安装 beyond compare
2. 在 git 中配置

   ```bash
   git config --local merge.tool bc3(取的别名)
   git config --local mergetool.path "软件安装路径"
   git config --local mergetool.keepBackup false
   ```

3. 应用 beyond compare 解决冲突

   ```bash
   git mergetool
   ```

# 配置同时使用 Github/Gitee/...

```bash
# 1.更改 git 的全局设置（针对已安装 git）
# 查看配置
git config --global --list
# 删除配置
git config --global --unset user.name "xxx"
git config --global --unset user.email "xxx"

# 2.生成 SSH keys
# 生成的key都在 ~/.ssh 目录下
ssh-keygen -t ed25519 -C "xxx@xxx.com" -f ~/.ssh/id_rsa.gitee
ssh-keygen -t ed25519 -C "xxx@xxx.com" -f ~/.ssh/id_rsa.github

# 3.添加识别 SSH keys 新的私钥
ssh-agent bash
ssh-add ~/.ssh/id_rsa.github
ssh-add ~/.ssh/id_rsa.gitee

# 4.多账号配置 config 文件
touch ~/.ssh/config
# config 里的内容在下一个代码块中

# 5.将公钥添加到网站(gitee/github/...)上
cat ~/.ssh/id_rsa.github.pub
cat ~/.ssh/id_rsa.gitee.pub

# 6.测试是否连接成功
ssh -T git@github.com
ssh -T git@gitee.com
```

```bash
# ~/.ssh/config
#Default gitHub user Self
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa.github

#Add gitLab user
    Host git@gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_rsa.gitlab

# gitee
Host gitee.com
    Port 22
    HostName gitee.com
    User git
    IdentityFile ~/.ssh/id_rsa.gitee

# 其他自己搭建的
Host git@git.startdt.net
    Port 22
    HostName http://git.startdt.net
    User git
    IdentityFile ~/.ssh/lab_rsa.startdt
```

```bash
# gitee
git config --local user.name "haroldzkx"
git config --local user.email "registerhh@outlook.com"
git remote add origin git@gitee.com:haroldzkx/xxx.git
git branch -M main
git push -u origin main
```

```bash
# github
git config --local user.name "finchzkx"
git config --local user.email "registerhh@outlook.com"
git remote add origin git@github.com:finchzkx/xxx.git
git branch -M main
git push -u origin main
```

# git-portable

- Mac 和 Linux 都自带 git，用不到 git-portable 版

- 只有 Windows 上才需要用到 git-portable 版
