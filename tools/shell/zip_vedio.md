# bat

```bat
@echo off
chcp 65001
setlocal enabledelayedexpansion

:: call是同步调用方式，下面的bat脚本里末尾不要有 pause 语句
call ./xxx.bat

call ./zip.bat

......

pause
```

```bat
@echo off
chcp 65001
setlocal enabledelayedexpansion

:: 设置输入和输出目录
set "input_dir=./django"
set "output_dir=./django-zip"

:: 创建输出目录（如果不存在）
if not exist "%output_dir%" mkdir "%output_dir%"

:: 遍历输入目录中的所有mp4文件
for %%F in ("%input_dir%\*.mp4") do (
    set "filename=%%~nF"
    set "extension=%%~xF"

    :: 处理文件名中的特殊字符（如竖线|）
    set "safe_filename=!filename!"

    :: 使用ffmpeg进行压缩
    echo 正在处理: %%F
    ffmpeg -i "%%F" -c:v libx265 -x265-params crf=18 -c:a copy "%output_dir%\!safe_filename!!extension!"
    echo.
)

:: 遍历输入目录中的所有avi文件
for %%F in ("%input_dir%\*.avi") do (
    set "filename=%%~nF"
    set "extension=%%~xF"

    :: 处理文件名中的特殊字符（如竖线|）
    set "safe_filename=!filename!"

    :: 使用ffmpeg进行压缩
    echo 正在处理: %%F
    ffmpeg -i "%%F" -c:v libx265 -x265-params crf=18 -c:a copy "%output_dir%\!safe_filename!.mp4"
    echo.
)

echo 所有视频处理完成
:: pause
```

crf 值的范围是 0-50，0 为无损压缩，20 以内可以视觉上无损，一般设置为 18 就可以，可以将 100M 的视频压缩到 20M

```bash
ffmpeg -i a.mp4 -c:v libx265 -x265-params crf=18 b.mp4
ffmpeg -i "./web/xxx.avi" -c:v libx265 -x265-params crf=18 -c:a copy "./web-zip/xxx.mp4"
```
