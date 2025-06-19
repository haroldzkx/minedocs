# 【npm】

nvm 是环境管理工具

npm 是 node 程序包管理器

npx 是 node 程序包运行器

# 安装

## MacOS

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

## Windows10

```bash
# 去这里找安装包安装
https://github.com/coreybutler/nvm-windows/releases
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

# 使用

## 设置镜像源

```bash
# 方法1：使用淘宝镜像
npm config set registry https://registry.npmmirror.com

# 方法2：使用cnpm
npm install -g cnpm --registry=https://registry.npmmirror.com
cnpm install <package_name>

npm get registry
```
