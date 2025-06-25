```bash
0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-=_+`[]{}|\;:'",./<>?!@#$%^&*()
```

```python
import random

a = '''0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-=_+`[]{}|\;:'",./<>?!@#$%^&*()'''
result = []

for i in range(5):
    shuffled = ''.join(random.sample(a, len(a)))
    result.append(shuffled)

with open('hello', 'w') as file:
    for item in result:
        file.write(item + '\n')
```
