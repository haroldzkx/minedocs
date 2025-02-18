# 备份微信聊天记录

Mac 电脑上的备份位置

```bash
/Library/Containers/com.tencent.xinWeChat/Data/Library/Application\ Support/com.tencent.xinWeChat/2.0b4.0.9
```

在 Mac 电脑系统内，微信的备份文件会存放在 2.0b4.0.9 的 Backup 文件夹内，并且备份目录的路径不会改变。每一个微信账号的聊天记录备份对应此目录下的一个文件夹，名称通常为一长串字母和数字的组合。

备份后打包文件

```bash
tar -czvf 20201110.20240501.tar.gz 16035ef422c8f9e6892ae1653e7afba0
```

然后上传 20201110.20240501.tar.gz 到网盘
就可以删除 Backup 文件夹了

解压打包文件

```bash
tar -xzvf 20201110.20240501.tar.gz
```
