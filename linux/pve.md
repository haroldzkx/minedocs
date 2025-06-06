# 【Proxmox VE】

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
