# 【Virtualbox】

实践：

- 导入 ova 虚拟机后，先打快照，命名为 init

# 虚拟机备份

| amd64               |                                                                                                                          |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| debian.init.ova     | 1.Pure OS + SSH                                                                                                          |
| debian.base.ova     | 1.Pure OS + SSH<br />2.sudo + aliyun repo + wget + curl + python3.11.2 + pip + vim + tmux                                |
| debian.mysql.ova    | 1.PureOS + SSH<br />2.sudo + aliyun repo + wget + vim + tmux<br />3.MySQL                                                |
| debian.docker.ova   | 1.Pure OS + SSH<br />2.sudo + aliyun repo + wget + curl + python3.11.2 + pip + vim + tmux<br />3.Docker + Docker Compose |
| debian.kde.init.ova | 1.Pure OS + SSH + KDE Plasma                                                                                             |

| arm64                 | `EFI\debian\grubaa64.efi`                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| debian.init.arm.ova   | 1.Pure OS + SSH                                                                                                          |
| debian.base.arm.ova   | 1.Pure OS + SSH<br />2.sudo + aliyun repo + wget + curl + python3.11.2 + pip + vim + tmux                                |
| debian.docker.arm.ova | 1.Pure OS + SSH<br />2.sudo + aliyun repo + wget + curl + python3.11.2 + pip + vim + tmux<br />3.Docker + Docker Compose |
