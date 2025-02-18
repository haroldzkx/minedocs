# MacOS

```bash
brew install rename

# old_string 和 new_string 可以用正则表达式替代
rename 's/old_string/new_string/' *.mp4
```

# bat

```bat
@echo off
chcp 65001
setlocal enabledelayedexpansion

:: 设置要处理的根目录（支持拖放文件夹到脚本）
@REM if "%~1"=="" (
@REM     set "root_dir=%~dp0"
@REM ) else (
@REM     set "root_dir=%~1"
@REM )

set /p "root_dir=请输入目录："

:: 确保路径以反斜杠结尾
if not "%root_dir:~-1%"=="\" set "root_dir=%root_dir%\"

:: 用户输入配置
set /p "search=请输入要替换的字符串："
set /p "replace=请输入替换后的字符串（直接回车表示删除）："
set /p "ext=请输入文件扩展名（如 mp4、mkv 或 * 表示所有文件）："
if "%ext%"=="*" (set "file_mask=*") else (set "file_mask=*.%ext%")

echo.
echo [配置摘要]
echo 处理根目录: %root_dir%
echo 文件类型: %file_mask%
echo 替换规则: "%search%" → "%replace%"
echo.
pause

:: 开始递归处理
set "total_count=0"
for /r "%root_dir%" %%f in (%file_mask%) do (
    set "full_path=%%f"
    set "filename=%%~nxf"
    set "dir_path=%%~dpf"

    :: 仅处理文件名部分（保留扩展名）
    set "new_filename=!filename:%search%=%replace%!"

    if not "!filename!"=="!new_filename!" (
        echo 正在处理: "!full_path!"
        ren "!full_path!" "!new_filename!"
        set /a "total_count+=1"
    )
)

echo.
echo [完成] 共处理 !total_count! 个文件
pause
```
