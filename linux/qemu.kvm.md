# Qemu-kvm

```bash
sudo apt update && sudo apt upgrade -y

# 检查 CPU 是否支持虚拟化
egrep -c '(vmx|svm)' /proc/cpuinfo

sudo apt install qemu-kvm qemu-utils \
  libvirt-daemon-system libvirt-clients \
  virtinst bridge-utils virt-manager
# qemu-kvm：QEMU 虚拟机管理器，支持 KVM 加速
# qemu-utils：包含 QEMU 的一些实用工具，如 qemu-img（用于虚拟机磁盘管理）
# libvirt-daemon-system：主要提供虚拟机管理功能
# libvirt-clients：提供了虚拟机管理工具，如 virsh，用于虚拟机的生命周期管理和监控
# bridge-utils：创建网络桥接（用于 VM 网络连接）
# virt-manager（可选）：提供 GUI 界面管理 VM
# virtinst：用于创建虚拟机，简化了虚拟机安装的过程

# 检查 KVM 是否已启用
kvm-ok
# 如果输出下面两行内容，说明 KVM 已启用
# INFO: /dev/kvm exists
# KVM acceleration can be used

# Analyze KVM
lsmod | grep kvm
# kvm_intel             380928  0
# kvm                  1142784  1 kvm_intel
# irqbypass              16384  1 kvm
virt-host-validate
# QEMU: Checking for hardware virtualization                                 : PASS
# QEMU: Checking if device /dev/kvm exists                                   : PASS
# QEMU: Checking if device /dev/kvm is accessible                            : PASS
# QEMU: Checking if device /dev/vhost-net exists                             : PASS
# QEMU: Checking if device /dev/net/tun exists                               : PASS
# QEMU: Checking for cgroup 'cpu' controller support                         : PASS
# QEMU: Checking for cgroup 'cpuacct' controller support                     : PASS
# QEMU: Checking for cgroup 'cpuset' controller support                      : PASS
# QEMU: Checking for cgroup 'memory' controller support                  the above should be possible    : PASS
# QEMU: Checking for cgroup 'devices' controller support                     : WARN (Enable 'devices' in kernel Kconfig file or mount/enable cgroup controller in your system)
# QEMU: Checking for cgroup 'blkio' controller support                       : PASS
# QEMU: Checking for device assignment IOMMU support                         : WARN (No ACPI DMAR table found, IOMMU either disabled in BIOS or not supported by this hardware platform)
# QEMU: Checking for secure guest support                                    : WARN (Unknown if this platform has Secure Guest support)

# 确保 libvirtd 服务已启动
sudo systemctl enable --now libvirtd
# 检查是否运行
sudo systemctl status libvirtd

# 添加当前用户到 libvirt 组
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)
# 然后重新登录或执行
newgrp libvirt
newgrp kvm
```

```bash
# kvm-ok command not found
sudo apt install cpu-checker

# 检查 KVM 模块是否加载
# 如果返回的结果中有 kvm_intel 或 kvm_amd，说明 KVM 模块已加载
lsmod | grep kvm
# 手动加载模块
sudo modprobe kvm_intel   # 对于 Intel 处理器
sudo modprobe kvm_amd     # 对于 AMD 处理器

# 如果输出下面两行内容，说明 KVM 已启用
# INFO: /dev/kvm exists
# KVM acceleration can be used
kvm-ok
```

```bash
# 在.bashrc中添加如下配置，才可以使用virsh list --all命令
export LIBVIRT_DEFAULT_URI="qemu:///system"
```

```bash
# --os-variant 参数
virt-install --osinfo list | grep debian
```
