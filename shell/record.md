# Windows 自动录屏脚本

```bash
@echo off
setlocal enabledelayedexpansion

rem 获取当前目录路径
set "current_dir=%cd%"

rem 设置文件夹路径
set "folder=E:\BaiduNetdiskDownload\jangoweb\chapter7"

rem 遍历文件夹中的所有 MP4 文件
for %%F in (%folder%\*.mp4) do (
    set filename=%%~nxF
    for /f "tokens=2 delims=." %%a in ("!filename!") do (
        set result=%%a
    )
    echo Playing: %%F for !result! seconds

    start /MAX "" "%current_dir%\win.exe" "%%F"

    timeout /t !result! >nul

    wmic process where "name='win.exe'" delete >nul 2>&1
)

@REM endlocal
pause
```
