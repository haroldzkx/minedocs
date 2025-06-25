# bat

```bat
@echo off
chcp 65001
setlocal enabledelayedexpansion

:: 设置要删除的文件扩展名
set "fileExtension=pdf"

:: 设置要搜索的根目录
set "directory=D:\geektemp"

:: 递归查找并删除指定类型的文件
for /r "%directory%" %%f in (*.%fileExtension%) do (
    echo 删除文件: %%f
    del /f /q "%%f"
)

set "fileExtension1=m4a"
for /r "%directory%" %%f in (*.%fileExtension1%) do (
    echo 删除文件: %%f
    del /f /q "%%f"
)

echo 完成删除操作
pause
```
