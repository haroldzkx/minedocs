# 【git 常用命令】

# 版本 commit

## 生成版本

```bash
git commit -m "描述信息"

# 可以输入多行文本，然后遵循提交规范
git commit
# 一定要遵循版本提交规范
git commit -m "first line" -m "second line" -m "third line"

# 修改最新的一次commit信息
git commit --amend

# 修改老旧的commit的message
# 这里面有两个文件要修改，根据提示来就好
# 第一个文件里选择reword
git rebase -i 你要修改的commit的上一级commit
```

## 查看版本记录

```bash
git log
git log --oneline # 可以简略查看日志信息
git log -n 4 --oneline # 简略查看最近的4条日志
git log -n 4 # 查看最近的4条日志
git log -all --graph # 以图形化的方式查看日志
git log --graph --pretty=format:"%h %s" # 版本（分支）图形展示
```

## 版本回滚

```bash
# 回滚到前面的版本
git log
git reset --hard 版本号

# 回滚到后面的版本
git reflog
git reset --hard 版本号
```

## 本地合并多个 commit 为一个 commit

```bash
# 把连续的多个commit整理成一个commit
# 留一个pick状态，其他的都选择squash状态
git rebase -i 你要修改的commit的上一级commit

# 把间隔的多个commit整理成一个commit
git rebase -i 你要修改的commit的上一级commit
# 然后将所有的要整理到一起的commit放到一起，留一个pick状态，其他的选择squash状态，然后保存退出
# 然后使用continue命令去编写合并信息，保存退出就可以了
git rebase --continue
```

# 分支 branch

```bash
# 查看分支
git branch
git branch -v

# 创建分支
git branch 分支名称

# 重命名分支
git branch -m main xxx

# 切换分支
git checkout 分支名称
git checkout -b 分支名称 # 创建新分支并切换到新分支

# 分支合并（可能产生冲突）
git merge 要合并的分支
# 注意：切换分支再合并

# 删除分支
git branch -d 分支名称
```

# 分支合并

```bash
# 合并其他分支到main/release分支使用merge
# 例如，合并bugFix分支到main
git checkout main
git pull origin main
git merge bugFix
git push origin main

# 其他的分支使用git rebase
git checkout bugFix
git rebase main
```

# 标签 tag

```bash
# 创建本地Tag信息
git tag -a v1.0 -m "版本介绍"

# 删除Tag
git tag -d v1.0

# 将本地Tag信息推送到远程仓库
git push 仓库别名 --tags

# 更新本地Tag版本信息
git pull 仓库别名 --tags

# 切换Tag
git checkout v1.0

# 指定Tag下载代码
git clone -b v1.0 下载地址
```

# 文件重命名

```bash
git mv readme readme.md
```

# Github 代码托管

1. 准备工作
   1.1. 本机设置了 公私钥实现 SSH 连接
   1.2. 本机设置用户名和邮箱
   1.3. GitHub 创建空仓库
   1.4. 确定本地 git 仓库目录
   1.5. 创建 .gitignore 文件和 README.md 文件

2. 本地目录中进行 git 仓库初始化，并查看状态信息

```bash
# 初始化命令：进入要管理的文件夹，执行命令
git init

# 管理目录下的文件状态
# 注：新增的文件和修改过后的文件都是红色
git status
git log
```

3. 修改文件，并添加远程仓库信息

```bash
# 尽量设置 SSH 链接的仓库
git remote add <shortname> <url>
git remote add origin git@github.com:haroldzkx/archive.git

# 查看远程仓库信息
git remote -v
```

4. 修改完成后，生成版本（commit）

```bash
# 管理指定文件（红变绿）
git add 文件名
git add .

git commit -m "first line" -m "second line" -m "third line"
git branch -M main
```

5. 推送本地代码仓库到 GitHub

```bash
git push -u origin main
git log
```

# 基于 GitHub 做代码托

```bash
# 在公司进行开发
# 1.切换到dev分支进行开发
git checkout dev

# 2.把main分支合并到dev（仅一次）
git merge main

# 3.修改代码

# 4.提交代码
git add .
git commit -m "xx"
git push 仓库别名 dev
```

```bash
# 回到家中继续写代码
# 1.切换到dev分支进行开发
git checkout dev

# 2.拉取代码
git pull 仓库别名 dev
# 等价于
git fetch 仓库别名 dev
git merge 仓库别名/dev

# 3.继续开发

# 4.提交代码
git add .
git commit -m "xx"
git push 仓库别名 dev
```

```bash
# 开发完毕，要上线
# 1.将dev分支合并到master，进行上线
git checkout master
git merge dev
git push 仓库别名 master
# 2.把dev分支也推送到远程仓库
git checkout dev
git merge master
git push 仓库别名 dev
```

# 给开源软件贡献代码

1. fork 源代码，将别人源代码拷贝到自己的远程仓库

2. 在自己仓库进行修改代码

3. 给源代码的作者提交 修复 bug 的申请（pull request）
