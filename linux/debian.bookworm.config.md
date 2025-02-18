# 【Debian 12】

# 配置

## 授予主用户超级用户权限

```bash
su root

# 1.添加权限
ls -l /etc/sudoers && chmod +w /etc/sudoers

# 2.修改内容
vi /etc/sudoers

# 在 # User privilege specification 里添加如下内容
Username	ALL=(ALL:ALL) ALL

# 3.修改完后删除权限
chmod -w /etc/sudoers && ls -l /etc/sudoers

# 4.注销当前用户登录并重新登录以应用更改
```

```shell
#!/bin/bash

# Ensure the script is run as the root user
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root"
  exit
fi

# 1. Add permissions
echo "Adding write permission to /etc/sudoers"
chmod +w /etc/sudoers

# 2. Modify content
echo "Modifying /etc/sudoers file"
echo "Please enter the username to add sudo permission:"
read Username

# Check if the user already exists in the sudoers file
if grep -q "^$Username" /etc/sudoers; then
  echo "User $Username already exists in the sudoers file."
else
  echo "$Username\tALL=(ALL:ALL) ALL" >> /etc/sudoers
  echo "User $Username has been added to the sudoers file."
fi

# 3. Remove permissions after modification
echo "Removing write permission from /etc/sudoers"
chmod -w /etc/sudoers

# 4. Show the permissions after modification
ls -l /etc/sudoers

echo "Please log out and log back in to apply the changes."
```

## 换国内源

```shell
#!/bin/bash

# Backup the original sources.list file
cp /etc/apt/sources.list /etc/apt/sources.list.backup

# Comment out all lines in the sources.list file and add the new repositories
sed -i -e 's/^/#/' /etc/apt/sources.list
bash -c 'cat << EOF >> /etc/apt/sources.list
deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
EOF'

# Update the package lists
apt update
```

```bash
sudo vi /etc/apt/sources.list

# 将文件里的内容注释掉，添加如下内容，任选一个就行

# 添加之后更新源
sudo apt update
```

```bash
# 阿里云
deb https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb-src https://mirrors.aliyun.com/debian-security/ bookworm-security main
deb https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.aliyun.com/debian/ bookworm-backports main non-free non-free-firmware contrib
```

```bash
# 中科大
deb https://mirrors.ustc.edu.cn/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.ustc.edu.cn/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.ustc.edu.cn/debian-security/ bookworm-security main
deb-src https://mirrors.ustc.edu.cn/debian-security/ bookworm-security main
deb https://mirrors.ustc.edu.cn/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.ustc.edu.cn/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.ustc.edu.cn/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.ustc.edu.cn/debian/ bookworm-backports main non-free non-free-firmware contrib
```

```bash
# 网易
deb https://mirrors.163.com/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.163.com/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.163.com/debian-security/ bookworm-security main
deb-src https://mirrors.163.com/debian-security/ bookworm-security main
deb https://mirrors.163.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.163.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.163.com/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.163.com/debian/ bookworm-backports main non-free non-free-firmware contrib
```

```bash
# 腾讯云
deb https://mirrors.cloud.tencent.com/debian/ bookworm main non-free non-free-firmware contrib
deb-src https://mirrors.cloud.tencent.com/debian/ bookworm main non-free non-free-firmware contrib
deb https://mirrors.cloud.tencent.com/debian-security/ bookworm-security main
deb-src https://mirrors.cloud.tencent.com/debian-security/ bookworm-security main
deb https://mirrors.cloud.tencent.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb-src https://mirrors.cloud.tencent.com/debian/ bookworm-updates main non-free non-free-firmware contrib
deb https://mirrors.cloud.tencent.com/debian/ bookworm-backports main non-free non-free-firmware contrib
deb-src https://mirrors.cloud.tencent.com/debian/ bookworm-backports main non-free non-free-firmware contrib
```

## python-pip

自带 python3.11，但是没有 pip

```bash
sudo apt install python3-pip
```

## 远程桌面连接

```bash
# 安装XRDP
sudo apt update
sudo apt install xrdp

# 启动并启用XRDP服务，并检查启动状态
sudo systemctl enable --now xrdp
systemctl status xrdp --no-pager -l

# 将XRDP用户添加到SSL-Cert组
# 需要将XRDP用户添加到SSL-cert组才能正确访问它，
# 否则在建立远程桌面连接后它将仅显示空白屏幕
sudo adduser xrdp ssl-cert

# 重新启动XRDP服务器
sudo systemctl restart xrdp

# 在防火墙中允许端口
sudo ufw allow 3389

# 建议创建一个新用户用来远程登录
```

```bash
sudo apt install krdc freerdp2-wayland
```

## 修改主机名

```bash
sudo vim /etc/hostname
sudo vim /etc/hosts
```

## Uninstall LibreOffice

```bash
#不要漏掉通配符“?”，否则无法清除/卸载全部 LibreOffice 软件包
sudo apt-get purge libreoffice?

#不要漏掉通配符“?”，否则无法清除/卸载全部 LibreOffice 软件包
sudo aptitude purge libreoffice?

#不要漏掉通配符“*”，否则无法清除/卸载全部 LibreOffice 软件包
sudo apt-get remove --purge libreoffice*

# clear the remain package
sudo apt-get clean
sudo apt-get autoremove
```

## Install GPU Driver

```bash
sudo apt install nvidia-detect
sudo nvidia-detect

sudo apt install nvidia-driver
reboot
```

## .bashrc

```bash
# python
alias python='/usr/bin/python3'

# system
alias sb='source /home/pc/.bashrc'

# list directory
alias la='ls -a'
alias ll='ls -l'
alias llh='ls -lh'
alias list='ls -lha'

# docker
alias d='docker'
alias di='docker images | sed "s|registry.cn-shenzhen.aliyuncs.com/haroldfinch|\$ali|g"'
alias drm='docker rm'
alias drmi='docker rmi'
alias drmf='docker rm -f'
alias dps='docker ps'
alias dpsa='docker ps -a'
#export ali=registry.cn-shenzhen.aliyuncs.com/haroldfinch

alias dif='docker images --format "\nRepository: {{.Repository}}\nTag: {{.Tag}}\nImage ID: {{.ID}}\nCreated: {{.CreatedAt}}\nSize: {{.Size}}" | sed "s|registry.cn-shenzhen.aliyuncs.com/haroldfinch|\$ali|g"'

alias dpsamine='docker ps -a --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.Created}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"'
alias dpsmine='docker ps --format "\nContainer ID: {{.ID}}\nImage: {{.Image}}\nCommand: {{.Command}}\nCreated: {{.Created}}\nStatus: {{.Status}}\nPorts: {{.Ports}}\nContainer Name: {{.Names}}\n"'
```

# 安装软件

## 蒲公英

```bash
# download
wget https://pgy.oray.com/softwares/153/download/2156/PgyVisitor_6.2.0_x86_64.deb
mv PgyVisitor_6.2.0_x86_64.deb ~/Downloads/

# install
dpkg -i PgyVisitor_6.2.0_x86_64.deb

# check install and exec status
sudo systemctl status pgyvpn
dpkg -l | grep pgyvpn

# check install path info
find / -name pgyvpn 2>/dev/null
find / -name pgyvisitor 2>/dev/null

# give soft link
sudo ln -s /usr/sbin/pgyvisitor /usr/local/bin/pgyvisitor

# software setting
pgyvisitor login -u ACCOUNT -p PASSWORD
pgyvisitor logininfo
pgyvisitor autologin -y
pgyvisitor showsets
pgyvisitor getmbrs -m
```

## Tailscale

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

```bash
sudo tailscale up
```

## Docker

```bash
# 更新系统包和安装必要工具
sudo apt update
sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

# 添加 Docker 官方 GPG 密钥（从阿里云下载）
sudo curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 添加阿里云的 Docker 软件源
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://mirrors.aliyun.com/docker-ce/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# 更新 apt 软件包索引
sudo apt update

# 安装 Docker
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 启动并设置 Docker 开机自启
sudo systemctl start docker
sudo systemctl enable docker

# 验证 Docker 是否安装成功
docker --version

# 添加当前用户到 Docker 组（可选）
sudo usermod -aG docker $USER
# 然后退出当前会话并重新登录

 # 验证 Docker 服务
sudo systemctl status docker
```

```bash
# 卸载 Docker 包和相关依赖
sudo apt purge docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 删除 Docker 配置文件和数据目录
## 删除 Docker 配置和数据目录
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
## 删除 Docker 配置文件
sudo rm -rf /etc/systemd/system/docker.service.d
sudo rm -rf /etc/apt/sources.list.d/docker.list
## 删除 Docker 配置的 GPG 密钥
sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg

# 清理无用的依赖
sudo apt autoremove --purge
sudo apt clean

# 更新 apt 软件源
sudo apt-get update

# 确认 Docker 是否完全卸载
docker --version
```

## Skopeo

```bash
sudo apt install skopeo
```

## vim

```shell
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

## tmux

```powershell
# set scroll screen like vim
setw -g mode-keys vi

# session index from 1
set -g base-index 1

# pane index from 1, not 0
set -g pane-base-index 1

# vim style to move cursor in pane
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
```

```bash
tmux source-file ~/.tmux.conf
```

## fcitx5

```bash
sudo apt install \
fcitx5 \
fcitx5-frontend-qt5 \
fcitx5-frontend-gtk2 \
fcitx5-frontend-gtk3 \
fcitx5-pinyin \
fcitx5-chinese-addons \
fcitx5-chewing \
fcitx5-module-lua \
fcitx5-module-lua-common \
fcitx5-modules \
unicode-cldr-core

# /etc/environment
sudo sh -c 'cat << EOF >> /etc/environment
XIM=fcitx5
XIM_PROGRAM=fcitx5
GTK_IM_MODULE=fcitx5
QT_IM_MODULE=fcitx5
XMODIFIERS=@im=fcitx5
SDL_IM_MODULE=fcitx5
GLFW_IM_MODULE=fcitx5
EOF'

sudo bash -c 'source /etc/environment'

reboot
```
