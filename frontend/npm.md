# nvm

<details>
<summary>Linux Install</summary>

```bash
# 离线安装 nvm

wget https://gitee.com/haroldzkx/board/releases/download/nvm/nvm-0.40.3.tar.gz
# 也可以去官网这里下载 nvm 的源码包
# https://github.com/nvm-sh/nvm/releases

mkdir -p ~/.nvm
tar -zxvf nvm-0.40.3.tar.gz -C ~/.nvm

# 在 .bashrc 或 .bash_aliases 里添加如下内容
export NVM_DIR="~/.nvm/nvm-0.40.3"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.bashrc

# Verify
nvm -v
```

</details>

<details>
<summary>MacOS Install</summary>

```bash
# install nvm
brew install nvm
mkdir ~/.nvm

vi ~/.zshrc
# 在 ~/.zshrc 配置文件后添加如下内容
export NVM_DIR="$HOME/.nvm"
 [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh" # This loads nvm
 [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
source ~/.zshrc
echo $NVM_DIR

# install node, npm
nvm install --lts
node -v
npm -v
```

</details>

<details>
<summary>Windows 10 Install</summary>

```bash
# 去这里找安装包安装
https://github.com/coreybutler/nvm-windows/releases
# nvm-setup.exe
```

```bash
nvm version

# 在 settings.txt 中添加
node_mirror: https://npmmirror.com/mirrors/node/
npm_mirror: https://npmmirror.com/mirrors/npm/

nvm list available
nvm install 22.11.0
nvm use
nvm on
node -v
npm -v
nvm list
```

</details>

<details>
<summary>node 离线安装</summary>

```bash
# 在这里找自己需要的 node 版本
# https://nodejs.org/download/release/

# 下载安装包
wget https://nodejs.org/download/release/latest-v22.x/node-v22.18.0-linux-x64.tar.gz

mkdir -p ~/.nvm/nvm-0.40.3/versions/node

# 解压
tar -zxvf node-v22.18.0-linux-x64.tar.gz -C ~/.nvm/nvm-0.40.3/versions/node

# 重命名
mv ~/.nvm/nvm-0.40.3/versions/node/node-v22.18.0-linux-x64 ~/.nvm/nvm-0.40.3/versions/node/v22.18.0

# 查看已安装的 node 版本
nvm ls
node -v
npm -v
npx -v
```

</details>

<details>
<summary>nvm commands</summary>

```bash
# 查看 nvm 版本
nvm -v

# 列出所有版本的 Node.js
nvm ls-remote

# 列出所有 LTS 版本的 Node.js
nvm ls-remote --lts

# 切换版本
nvm use 22.18.0
```

</details>

# node

<details>
<summary>npm 镜像</summary>

```bash
# 方法1：使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# 方法2：使用cnpm
npm install -g cnpm --registry=https://registry.npmmirror.com
cnpm install <package_name>

npm get registry
```

```bash
# Windows 配置镜像（没有验证，慎用）
# 在 nvm 的安装路径下有一个 settings.txt 文件
# 将下面两行内容添加到 settings.txt 文件中
node_mirror: https://npmmirror.com/mirrors/node/
npm_mirror: https://npmmirror.com/mirrors/npm/
```

</details>
