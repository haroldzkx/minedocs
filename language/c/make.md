# Makefile

<details>
<summary>MinGW make</summary>

```bash
# 方法1
# Windows 上使用的是 mingw32-make 命令，不是 make 命令
mingw32-make
mingw32-make run
mingw32-make clean
mingw32-make help
```

```bash
# 方法2
# 将 mingw64/bin/mingw32-make.exe 复制一份，重命名为 mingw64/bin/make.exe
# 然后就可以执行下面的命令
make
make run
make clean
make help
```

</details>

<details>
<summary>Makefile 1.0</summary>

```Makefile
# 声明使用哪个编译器
CC = gcc

# 定义编译选项
# -Wall: 启用所有警告
# -g: 生成调试信息
# -O2: 启用二级优化
CFLAGS = -Wall -g -O2

# 定义最终生成的可执行文件名称
# 将生成名为 app (Linux) 或 app.exe (Windows) 的程序
ifdef OS
	TARGET = app.exe
else
	TARGET = app
endif

# 定义源文件列表
# SRCS = main.c math_utils.c file_io.c
SRCS = mine.c

# 通过模式替换生成目标文件列表
# $(SRCS:.c=.o)：将SRCS中所有.c后缀替换为.o
# 结果：main.o math_utils.o file_io.o
OBJS = $(SRCS:.c=.o)

# 需要链接的库
# LIBS = -lm # 链接数学库
LIBS = 

# 检测操作系统并设置相应的命令
ifdef OS
    # Windows系统
    RM = del /Q /F
    MKDIR = if not exist
    RMDIR = rmdir /Q /S
    ECHO = @echo
else
    # Linux/Unix系统
    RM = rm -f
    MKDIR = mkdir -p
    RMDIR = rm -rf
    ECHO = @echo
endif

# 定义默认目标
# 当只输入 make 时，会构建 all 目标，它依赖于 $(TARGET)
all: $(TARGET)

# 链接规则
# $(TARGET): $(OBJS)：目标文件依赖于所有.o文件
# $(CC)：使用gcc编译器
# $(CFLAGS)：使用定义的编译选项
# -o $@：输出文件名为目标名称（$@表示当前目标）
# $^：所有依赖文件（即所有.o文件）
# -lm：链接数学库
$(TARGET): $(OBJS)
	$(ECHO) ------------- Link Target File -------------------------
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)
	$(ECHO) Build: $@
	$(ECHO) ------------- Build Complete ---------------------------

# 编译规则（模式规则）
# %.o: %.c：每个.o文件依赖于对应的.c文件
# -c：只编译不链接
# $<：第一个依赖文件（即对应的.c文件）
# -o $@：输出目标文件
%.o: %.c
	$(ECHO) ------------- Compile -------------------------
	$(CC) $(CFLAGS) -c $< -o $@
	$(ECHO) "Compile: $< -> $@"

# 清理规则 - 跨平台兼容
# 删除生成的可执行文件和所有目标文件
# rm -f：强制删除，不提示错误
clean:
	$(ECHO) ------------- Clean build files -------------------------
	$(RM) $(TARGET) $(OBJS)
	$(ECHO) ------------- Clean Complete ----------------------------

# 运行目标
run: $(TARGET)
	$(ECHO) ------------- Run Program and Output ----------------------------
	./$(TARGET)

# 显示帮助信息
help:
	$(ECHO) Commands:
	$(ECHO)   make         - Compile Project (Default)
	$(ECHO)   make clean   - Clean build file
	$(ECHO)   make run     - Compile and Run Program
	$(ECHO)   make help    - Show help infomation

# 创建构建目录（示例）
# build_dir:
# 	$(MKDIR) build
# 	$(ECHO) "Create Build Directory"

# 声明伪目标
# 告诉Make这些目标不是实际的文件，即使存在同名文件也要执行
.PHONY: all clean run help
```

</details>

# CMake