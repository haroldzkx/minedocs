# Python线程安全的

```python
from threading import Lock

class SingletonMeta(type):
    """
    This is a thread-safe implementation of Singleton.
    """
    _instances = {}
    _lock: Lock = Lock()

    def __call__(cls, *args, **kwargs):
        with cls._lock:
            if cls not in cls._instances:
                instance = super().__call__(*args, **kwargs)
                cls._instances[cls] = instance
        return cls._instances[cls]

class Hello(metaclass=SingletonMeta):

    def __init__(self):
        pass

# 这就是单例的
hello = Hello()
```
