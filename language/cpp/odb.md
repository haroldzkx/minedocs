
ODB组件 和 官网下载说明: [https://codesynthesis.com/products/odb/download.xhtml](https://codesynthesis.com/products/odb/download.xhtml)

Debian Binary Packages README: [https://codesynthesis.com/download/odb/2.5.0/debian/README.xhtml](https://codesynthesis.com/download/odb/2.5.0/debian/README.xhtml)

<details>
<summary>Debian 12 安装 ODB 2.5.0（二进制安装）</summary>

```bash
# 1.下载二进制安装包

mkdir odb-debs && cd odb-debs

# 1.1 下载方式(1)：gitee 下载（国内更快）
wget https://gitee.com/haroldzkx/board/releases/download/odb-2.5.0/odb-2.5.0.binary.tar
tar -xvf odb-2.5.0.binary.tar

# 1.2 下载方式(2)：官网下载
# 在这个链接里找二进制安装包
# https://codesynthesis.com/download/odb/2.5.0/debian/debian12/x86_64/

# ODB Compiler (odb)
wget https://codesynthesis.com/download/odb/2.5.0/debian/debian12/x86_64/odb_2.5.0-0~debian12_amd64.deb

# Common Runtime Library: 提供核心 ODB 的运行库 (libodb.so)
wget https://codesynthesis.com/download/odb/2.5.0/debian/debian12/x86_64/libodb_2.5.0-0~debian12_amd64.deb
# Common Runtime Library（开发头文件）: 提供 ODB 的公共头文件（如 <odb/...>）
wget https://codesynthesis.com/download/odb/2.5.0/debian/debian12/x86_64/libodb-dev_2.5.0-0~debian12_amd64.deb

# Database-Specific Runtime Library (MySQL): 提供与 MySQL 对接的动态库（libodb-mysql.so）
wget https://codesynthesis.com/download/odb/2.5.0/debian/debian12/x86_64/libodb-mysql_2.5.0-0~debian12_amd64.deb
# Database-Specific Runtime Library（开发头文件）: 提供 <odb/mysql/...> 的开发头文件
wget https://codesynthesis.com/download/odb/2.5.0/debian/debian12/x86_64/libodb-mysql-dev_2.5.0-0~debian12_amd64.deb
```

```bash
# 2.安装二进制安装包，如果 缺失依赖 会 自动修复
sudo dpkg -i *.deb || sudo apt -f install -y
```

```bash
# 3.验证
# 3.1 确认 ODB 编译器
which odb
odb --version

# 3.2 确认 Common Runtime (libodb)
# 查看头文件路径
ls /usr/include/odb
# 查看共享库
ls /usr/lib/x86_64-linux-gnu/ | grep libodb

# 3.3 确认 MySQL 后端运行时
# 查看头文件路径
ls /usr/include/odb/mysql
# 查看共享库
ls /usr/lib/x86_64-linux-gnu/ | grep libodb-mysql
```

</details>

<details>
<summary>Debian 12 安装 ODB 2.5.0（二进制安装）（测试运行）</summary>

```cpp
// hello.hxx
#include <string>
#include <odb/core.hxx>

#pragma db object
class Hello {
public:
    Hello() = default;
    Hello(const std::string& msg) : message(msg) {}

private:
    friend class odb::access;

    #pragma db id auto
    unsigned long id_;
    std::string message;
};
```

```bash
$ odb -d mysql --std c++11 --generate-query --generate-schema hello.hxx 
$ ls
hello.hxx  hello-odb.cxx  hello-odb.hxx  hello-odb.ixx  hello.sql
```

</details>

<details>
<summary>Debian 12 安装 ODB 2.5.0（源码安装）</summary>

```bash
# 0.依赖安装
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
  build-essential \
  g++ \
  make \
  curl \
  wget \
  git \
  tar \
  xz-utils \
  pkg-config

# 后面所有需要的包和脚本都在这里
wget https://gitee.com/haroldzkx/board/releases/download/odb-2.5.0/odb-2.5.0.source.tar
tar -xvf odb-2.5.0.source.tar
```

```bash
# 1. 在线 安装 build2
mkdir build2-build && cd build2-build

curl -sSfO https://download.build2.org/0.17.0/build2-install-0.17.0.sh

shasum -a 256 -b build2-install-0.17.0.sh
# b84e4114c61aa94c3f6278f010a0dc0536dda65ac39d3863152ec9b64510b86e

sh build2-install-0.17.0.sh --yes --trust yes
# Install directory: /usr/local/
# Build directory:   /home/xxx/build2-build/
# 测试下这个命令 sh build2-install-0.17.0.sh --yes --local

# 将超时时间设置长一点
sh build2-install-0.17.0.sh --timeout 1800

# 卸载 build2
sh build2-install-0.17.0.sh --uninstall

# 验证安装的 build2
b --version
bdep --version
bpkg --version
```

```bash
# TODO: 这里不完善
# 1. 离线 安装 build2
mkdir build2-build && cd build2-build

```

```bash
# 2. Building ODB Compiler
gcc --version
# gcc (Debian 12.2.0-14+deb12u1) 12.2.0

# 2.1 安装依赖
sudo apt install -y gcc-12-plugin-dev
# 这里的 12 是 gcc 的 major 版本号

# 2.2 create the build configuration
mkdir odb-build && cd odb-build

bpkg create -d odb-gcc-12 cc \
  config.cxx=g++ \
  config.cc.coptions=-O3 \
  config.bin.rpath=/usr/local/lib \
  config.install.root=/usr/local \
  config.install.sudo=sudo

# 2.3 build
cd odb-gcc-12

# online build odb
bpkg build odb@https://pkg.cppget.org/1/stable

# offline build odb (Recommand)
wget https://codesynthesis.com/download/odb/2.5.0/odb-2.5.0.tar.gz
wget https://codesynthesis.com/download/odb/2.5.0/libstudxml-1.1.0.tar.gz
wget https://codesynthesis.com/download/odb/2.5.0/libcutl-1.11.0.tar.gz

bpkg build --configure-only libstudxml-1.1.0.tar.gz
bpkg build --configure-only libcutl-1.11.0.tar.gz
bpkg build odb-2.5.0.tar.gz

# 2.4 test
bpkg test odb

# 2.5 install
bpkg install odb

# 2.6 verify odb install
which odb
odb --version
```

```bash
sudo apt install -y libmariadb-dev

# 3. Building ODB Runtime Libraries
cd odb-build

# 3.1 create the build configuration
bpkg create -d libodb-gcc-12 cc \
  config.cxx=g++ \
  config.cc.coptions=-O3 \
  config.install.root=/usr/local \
  config.install.sudo=sudo

cd libodb-gcc-12

# 3.2 build
# online build
bpkg add https://pkg.cppget.org/1/stable
bpkg fetch

bpkg build libodb

bpkg build libodb-sqlite
bpkg build libodb-pgsql
bpkg build libodb-mysql

bpkg build libodb-boost

# offline build (Recommand)
wget https://codesynthesis.com/download/odb/2.5.0/libodb-2.5.0.tar.gz
bpkg build libodb-2.5.0.tar.gz

wget https://codesynthesis.com/download/odb/2.5.0/libz-1.2.1200+5.tar.gz
wget https://codesynthesis.com/download/odb/2.5.0/libcrypto-1.1.1+21.tar.gz
wget https://codesynthesis.com/download/odb/2.5.0/libssl-1.1.1+21.tar.gz
wget https://codesynthesis.com/download/odb/2.5.0/libmysqlclient-8.0.15+18.tar.gz
wget https://codesynthesis.com/download/odb/2.5.0/libodb-mysql-2.5.0.tar.gz
bpkg build --configure-only libz-1.2.1200+5.tar.gz
bpkg build --configure-only libcrypto-1.1.1+21.tar.gz
bpkg build --configure-only libssl-1.1.1+21.tar.gz
bpkg build --configure-only libmysqlclient-8.0.15+18.tar.gz
bpkg build libodb-mysql-2.5.0.tar.gz

wget https://codesynthesis.com/download/odb/2.5.0/libodb-boost-2.5.0.tar.gz
bpkg build libodb-boost-2.5.0.tar.gz

# 3.3 install
bpkg status
bpkg install --all --recursive
```

```bash
# 4. verify 
# libodb 的头文件 路径
ls /usr/local/include/odb/
# libodb 的共享库 路径
ls -l /usr/local/lib/ | grep libodb
# mysql 后端运行时 的 头文件 路径
ls /usr/local/include/odb/mysql
# mysql 后端运行时 的 共享库 路径
ls -l /usr/local/lib/ | grep libodb-mysql
```

```bash
# 5. Other Commands
# uninstall
bpkg uninstall --all --recursive
# upgrade
bpkg fetch
bpkg status
bpkg uninstall --all --recursive
bpkg build --upgrade --recursive
bpkg install --all --recursive
```

</details>

<details>
<summary>Debian 12 安装 ODB 2.5.0（源码安装）（测试运行）</summary>

```cpp
#pragma once
#include <string>
#include <odb/core.hxx>

#pragma db object
class Hello {
public:
  Hello() = default;
  Hello(const std::string& msg) : message_(msg) {}

  const std::string& message() const { return message_; }
  void message(const std::string& msg) { message_ = msg; }

private:
  friend class odb::access;

  #pragma db id auto
  unsigned long id_;
  std::string message_;
};
```

```bash
$ odb -d mysql --std c++11 --generate-query --generate-schema hello.hxx 
$ ls
hello.hxx  hello-odb.cxx  hello-odb.hxx  hello-odb.ixx  hello.sql
```

</details>
