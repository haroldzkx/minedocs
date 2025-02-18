# 【打包与压缩】

tar 命令用于为文件和目录创建压缩文件。

- 打包：将多个文件或目录变成一个文件
- 压缩：将一个大文件通过压缩算法变成一个小文件

有了 tar 命令，在需要压缩多个文件时，可以先将多个文件打成一个包（tar 命令），然后再用压缩程序进行压缩（gzip、bzip2 命令）。

```bash
# 将所有.png 文件打成一个名为 all.tar 的包，-c 表示产生新的包，-f 指定包的文件名
tar -cf all.tar \*.png

# 将所有.gif 文件增加到 all.tar 包里去，-r 表示增加文件
tar -rf all.tar \*.gif

# 更新原来 tar 包 all.tar 中的 logo.gif 文件，-u 表示更新文件
tar -uf all.tar logo.gif

# 列出 all.tar 包中的所有文件，-t 表示列出文件
tar -tf all.tar

# 将目录里所有.png 文件打包成 png.tar
tar -cvf png.tar \*.png

# 将目录里所有.png 文件打包成 png.tar 后，再用 gzip 压缩，生成一个 gzip 压缩包，命名为 png.tar.gz
tar -czf png.tar.gz \*.png

# 将目录里所有.png 文件打包成 png.tar 后，再用 bzip2 压缩，生成一个 bzip2 压缩包，命名为 png.tar.bz2
tar -cjf png.tar.bz2 \*.png

# 将目录里所有.png 文件打包成 png.tar 后，再用 compress 压缩，生成一个 umcompress 压缩包，命名为 png.tar.Z
tar -cZf png.tar.Z \*.png
```

```bash
# 解压 tar 包
tar -xvf file.tar

# 解压 tar.gz
tar -xzvf file.tar.gz

# 解压 tar.bz2
tar -xjvf file.tar.bz2

# 解压 tar.Z
tar -xZvf file.tar.Z
```
