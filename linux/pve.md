# 【Proxmox VE】

# Todo

- 虚拟机模板是什么意思？有什么用？如何创建虚拟机模板？如何使用虚拟机模板克隆？链接克隆和完全克隆的区别？

- 虚拟机备份如何使用，导入导出备份？快照如何使用？

- CT 模板如何创建？如何使用？

- 一个 PVE 节点上有多块硬盘，如何用上所有的硬盘？

- 创建一个虚拟机中的各个参数是什么意思？应该如何设置？

- Windows10 虚拟机直通后的假内存占用如何解决？

# 创建虚拟机

# 虚拟机扩容（内存，磁盘，CPU）

# 配置

## 修改 PVE 的 IP

```bash
# 修改IP, 网关
vi /etc/network/interfaces

# 修改DNS服务器
vi /etc/resolv.conf

# 修改主机名解析的IP
vi /etc/hosts

# 修改开机界面提示的URL内容
vi /etc/issue

# 重启PVE
reboot
```

## 删除订阅提示

1. 进入 PVE 管理机的终端

2. 备份文件

   ```bash
   cd /usr/share/javascript/proxmox-widget-toolkit
   cp proxmoxlib.js proxmoxlib.js.bak
   ```

3. 修改文件：在指定位置添加一行代码 `res.data.status = 'active';`

   ```javascript
   success: function(response, opts) {
       let res = response.result;
       res.data.status = 'active'; // 在这里添加这一行内容
       if (res === null || res === undefined || !res || res
           .data.status.toLowerCase() !== 'active') {
           ...
           }
           ...
   }
   ```

4. 重启 web 服务查看效果

   ```bash
   systemctl restart pveproxy.service
   ```
