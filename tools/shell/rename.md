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

# Python

```python
from pathlib import Path


def replace_str(v_path=None, v_old='', v_new='') -> None:
    if not v_path:
        raise TypeError('参数错误,缺失参数v_path:文件路径')

    # parameter valid
    # if not v_old or not v_new:
    #     raise TypeError('请确认输入了被替换字符串和替换字符串')

    # if not v_path.is_dir() or v_path.is_file():
    #     raise TypeError('找不到文件目录,请确认')

    # 如果传入路径参数为字符串，则转为Path类型
    v_path = Path(v_path) if isinstance(v_path, str) else v_path

    # 提取主路径下的文件夹列表，并格式化路径问字符串，以便后续的替换操作
    # replace是没用的，但是已经写了，想修改吧，注释写了这么多了，算了，不改了，就这样吧
    dirs = [x.__str__().replace('\\', '/') for x in v_path.iterdir()] if v_path.is_dir() else []

    for path in dirs:
        # 被替换字符串存在于path路径中，直接替换
        if v_old in path:

            new_name = path.replace(v_old, v_new)
            new_path = v_path / new_name
            target = v_path / path
            target.rename(new_path)
            print(f' Success: old:{path}')
            print(f'      --> new:{new_path}')

            # 递归检查文件夹
            if Path(new_path).is_dir():
                replace_str(v_path=new_path, v_old=v_old, v_new=v_new)
        # 当前路径中没有被替换的字符串，继续递归向下检查
        else:
            replace_str(v_old, v_new, Path(path))


def rename_info(v_path: str, v_old: str, v_new: str) -> None:
    print(f' Note: Current File Path 【{v_path}】')
    print(f'       Current Old String【{v_old}】')
    print(f'       Current New String【{v_new}】')


if __name__ == '__main__':
    file_path = input('Please input file/directory path: ')
    old_str = input('Please input Old string: ')
    new_str = input('Please input New string: ')
    while True:
        print('#' * 50)
        rename_info(file_path, old_str, new_str)
        print('#' * 50)
        print(' 0) Exit 1) Rename 2) 更换路径 3)更换旧字符 4)更换新字符')
        operate = input(' Please Press 0) 1) 2) 3) 4): ')

        if operate == '0':
            break
        elif operate == '1':
            replace_str(file_path, old_str, new_str)
        elif operate == '2':
            file_path = input(' --> Please input file name/directory path: ')
        elif operate == '3':
            old_str = input(' --> Please input Old String: ')
        elif operate == '4':
            new_str = input(' --> Please input New String: ')
```
