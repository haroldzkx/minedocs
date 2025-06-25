# 目录结构

```bash
curl      # 存放测试 API 的接口
    /xxx.sh
```

```bash
# 存放项目配置文件
settings/__init__.py
        /base.py
        /local.py
        /prod.py
```

```bash
app/__init__.py
   /admin.py
   /apps.py
   /migrations/__init__.py
   /models.py
   /tasks.py  # 放置需要丢到celery中去执行的任务
   /tests.py  # 有了testcase这个包，这个文件可以删除
   /testcase/__init__.py  # 放单元测试
            /test_forms.py
            /test_views.py
   /views.py
```

```bash
project/__init__.py
       /asgi.py
       /urls.py
       /wsgi.py
       /celery.py
```

```bash
manage.py
```
