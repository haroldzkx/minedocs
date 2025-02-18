# logging 用法 1

在开发过程中，将配置在代码里面写死并不是一个好的习惯，更好的做法是将配置写在配置文件里面，我们可以将配置写入到配置文件，然后运行时读取配置文件里面的配置，这样是更方便管理和维护的，首先我们定义一个 yaml 配置文件：

```yaml
# config.yaml
version: 1
formatters:
  brief:
    format: "%(asctime)s - %(message)s"
  simple:
    format: "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
handlers:
  console:
    class: logging.StreamHandler
    formatter: brief
    level: INFO
    stream: ext://sys.stdout
  file:
    class: logging.FileHandler
    formatter: simple
    level: DEBUG
    filename: debug.log
  error:
    class: logging.handlers.RotatingFileHandler
    level: ERROR
    formatter: simple
    filename: error.log
    maxBytes: 10485760
    backupCount: 20
    encoding: utf8
loggers:
  main.core:
    level: DEBUG
    handlers: [console, file, error]
root:
  level: DEBUG
  handlers: [console]
```

这里我们定义了 formatters、handlers、loggers、root 等模块，实际上对应的就是各个 Formatter、Handler、Logger 的配置，参数和它们的构造方法都是相同的。

接下来定义一个主入口文件，main.py，内容如下：

```python
# main.py
import logging
import core
import yaml
import logging.config
import os


def setup_logging(default_path='config.yaml', default_level=logging.INFO):
    path = default_path
    if os.path.exists(path):
        with open(path, 'r', encoding='utf-8') as f:
            config = yaml.load(f)
            logging.config.dictConfig(config)
    else:
        logging.basicConfig(level=default_level)


def log():
    logging.debug('Start')
    logging.info('Exec')
    logging.info('Finished')


if __name__ == '__main__':
    yaml_path = 'config.yaml'
    setup_logging(yaml_path)
    log()
    core.run()
```

定义 core.py 如下：

```python
import logging

logger = logging.getLogger('main.core')

def run():
    logger.info('Core Info')
    logger.debug('Core Debug')
    logger.error('Core Error')
```

观察配置文件，主入口文件 main.py 实际上对应的是 root 一项配置，它指定了 handlers 是 console，即只输出到控制台。

另外在 loggers 一项配置里面，我们定义了 main.core 模块，handlers 是 console、file、error 三项，即输出到控制台、输出到普通文件和回滚文件。

这样运行之后，我们便可以看到所有的运行结果输出到了控制台，在 debug.log 文件中则包含了 core.py 的运行结果。

通过配置文件，可以非常灵活地定义 Handler、Formatter、Logger 等配置，同时也显得非常直观，也非常容易维护，在实际项目中，推荐使用此种方式进行配置。

# logging 用法 2

一般会配置输出到文件、控制台和 Elasticsearch。

- 输出到控制台就仅仅是方便直接查看的；
- 输出到文件是方便直接存储，保留所有历史记录的备份；
- 输出到 Elasticsearch，直接将 Elasticsearch 作为存储和分析的中心，使用 Kibana 可以非常方便地分析和查看运行情况。

可以对 logging 做如下的封装写法：

```python
import logging
import sys
from os import makedirs
from os.path import dirname, exists

from cmreslogging.handlers import CMRESHandler

loggers = {}

LOG_ENABLED = True  # 是否开启日志
LOG_TO_CONSOLE = True  # 是否输出到控制台
LOG_TO_FILE = True  # 是否输出到文件
LOG_TO_ES = True  # 是否输出到 Elasticsearch

LOG_PATH = './runtime.log'  # 日志文件路径
LOG_LEVEL = 'DEBUG'  # 日志级别
LOG_FORMAT = '%(levelname)s - %(asctime)s - process: %(process)d - %(filename)s - %(name)s - %(lineno)d - %(module)s - %(message)s'  # 每条日志输出格式
ELASTIC_SEARCH_HOST = 'eshost'  # Elasticsearch Host
ELASTIC_SEARCH_PORT = 9200  # Elasticsearch Port
ELASTIC_SEARCH_INDEX = 'runtime'  # Elasticsearch Index Name
APP_ENVIRONMENT = 'dev'  # 运行环境，如测试环境还是生产环境

def get_logger(name=None):
    """
    get logger by name
    :param name: name of logger
    :return: logger
    """
    global loggers

    if not name: name = __name__

    if loggers.get(name):
        return loggers.get(name)

    logger = logging.getLogger(name)
    logger.setLevel(LOG_LEVEL)

    # 输出到控制台
    if LOG_ENABLED and LOG_TO_CONSOLE:
        stream_handler = logging.StreamHandler(sys.stdout)
        stream_handler.setLevel(level=LOG_LEVEL)
        formatter = logging.Formatter(LOG_FORMAT)
        stream_handler.setFormatter(formatter)
        logger.addHandler(stream_handler)

    # 输出到文件
    if LOG_ENABLED and LOG_TO_FILE:
        # 如果路径不存在，创建日志文件文件夹
        log_dir = dirname(log_path)
        if not exists(log_dir): makedirs(log_dir)
        # 添加 FileHandler
        file_handler = logging.FileHandler(log_path, encoding='utf-8')
        file_handler.setLevel(level=LOG_LEVEL)
        formatter = logging.Formatter(LOG_FORMAT)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)

    # 输出到 Elasticsearch
    if LOG_ENABLED and LOG_TO_ES:
        # 添加 CMRESHandler
        es_handler = CMRESHandler(
            hosts=[{'host': ELASTIC_SEARCH_HOST, 'port': ELASTIC_SEARCH_PORT}],
            auth_type=CMRESHandler.AuthType.NO_AUTH, # 可以配置对应的认证权限
            es_index_name=ELASTIC_SEARCH_INDEX,
            index_name_frequency=CMRESHandler.IndexNameFrequency.MONTHLY,# 一个月分一个 Index
            es_additional_fields={'environment': APP_ENVIRONMENT})# 额外增加环境标识
        es_handler.setLevel(level=LOG_LEVEL)
        formatter = logging.Formatter(LOG_FORMAT)
        es_handler.setFormatter(formatter)
        logger.addHandler(es_handler)

    # 保存到全局 loggers
    loggers[name] = logger
    return logger
```

定义完了之后，只需要使用定义的方法获取一个 logger，然后 log 对应的内容即可：

```python
logger = get_logger()
logger.debug('this is a message')
```

# loguru

用类和 yaml 配置文件实现 loguru 使用的二次封装。

```python
folder_ = "./log/"
prefix_ = "polaris-"
rotation_ = "10 MB"
retention_ = "30 days"
encoding_ = "utf-8"
backtrace_ = True
diagnose_ = True

# 格式里面添加了process和thread记录，方便查看多进程和线程程序
format_ = '<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <level>{level: <8}</level> ' \
            '| <magenta>{process}</magenta>:<yellow>{thread}</yellow> ' \
            '| <cyan>{name}</cyan>:<cyan>{function}</cyan>:<yellow>{line}</yellow> - <level>{message}</level>'

# 这里面采用了层次式的日志记录方式，就是低级日志文件会记录比他高的所有级别日志，这样可以做到低等级日志最丰富，高级别日志更少更关键
# debug
logger.add(folder_ + prefix_ + "debug.log", level="DEBUG", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("DEBUG").no)

# info
logger.add(folder_ + prefix_ + "info.log", level="INFO", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("INFO").no)

# warning
logger.add(folder_ + prefix_ + "warning.log", level="WARNING", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("WARNING").no)

# error
logger.add(folder_ + prefix_ + "error.log", level="ERROR", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("ERROR").no)

# critical
logger.add(folder_ + prefix_ + "critical.log", level="CRITICAL", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=False,
            rotation=rotation_, retention=retention_, encoding=encoding_,
            filter=lambda record: record["level"].no >= logger.level("CRITICAL").no)

logger.add(sys.stderr, level="CRITICAL", backtrace=backtrace_, diagnose=diagnose_,
            format=format_, colorize=True,
            filter=lambda record: record["level"].no >= logger.level("CRITICAL").no)
```

# 参考内容

[https://cuiqingcai.com/6080.html](https://cuiqingcai.com/6080.html)

[https://cuiqingcai.com/7776.html](https://cuiqingcai.com/7776.html)
