# 雪花算法原理

Snowflake，雪花算法是由 Twitter开源的分布式 ID 生成算法，以划分命名空间的方式将64-bit位分割成多个部分，每个部分代表不同的含义。

- 第1位占用1bit，其值始终是0，可看做是符号位不使用

- 第2位开始的41位是时间戳，41-bit位可表示2^41个数，每个数代表毫秒，那么雪花算法可用的时间年限是(1L<<41)/(1000L360024*365)=69年的时间

- 中间的10-bit位可表示机器数，即2^10=1024台机器，但是一般情况下我们不会部暑这么多台机器。如果我们对 IDC（互联网数据中心）有需求，还可以将10-bit分5-bit给 IDC，分5-bit给工作机器，这样就可以表示32个 IDC， 每个 IDC 下可以有32台机器，具体的划分可以根据自身需求定义

- 最后12-bit 位是自增序列，可表示2^12=4096个数

这样的划分之后相当于在一毫秒一个数据中心的一台机器上可产生4096个有序的不重复的 ID

![](https://gitee.com/haroldzkx/pbed1/raw/main/web/snowflake.jfif)

上面只是一个将64bit 划分的标准，当然也不一定这么做，可以根据不同业务的具体场景来划分，比如下面给出一个业务场景：

- 服务目前 QPS10万，预计几年之内会发展到百万

- 当前机器三地部署，上海，北京，深圳都有

- 当前机器10台左右，预计未来会增加至百台

这个时候我们根据上面的场景可以再次合理的划分64bit，QPS 几年之内会发展到百万，那么每毫秒就是千级的请求，目前10台机器那么每台机器承担百级的请求，为了保证扩展，后面的循环位可以限制到1024，也就是2^10，那么循环位10位就足够了。

机器三地部署我们可以用3bit总共8 位来表示机房位置，当前的机器10台，为了保证扩展到百台那么可以用7bit 128来表示，时间位依然是41bit，那么还剩下64-10-3-7-41-1=2bit，还剩下 2bit 可以用来进行扩展

<table>
    <tr>
        <td>1bit 符号位</td>
        <td>41位 时间戳</td>
        <td>3位 机房</td>
        <td>7位 机器ID</td>
        <td>10 循环位</td>
        <td>2位 扩展位</td>
    </tr>
</table>

# 时钟回拨

因为机器的原因会发生时间回拨，我们的雪花算法是强依赖我们的时间的，如果时间发生回拨，有可能会生成重复的 ID， 我们可以用当前时间和上一次的时间进行判断，如果当前时间小于上一次的时间那么肯定是发生了回拨，算法会直接抛出异常。

# 代码实现

<details>
<summary>snowflake/snowflake.py</summary>

```python
# Twitter's Snowflake algorithm implementation which is used to generate distributed IDs.
# https://github.com/twitter-archive/snowflake/blob/snowflake-2010/src/main/scala/com/twitter/service/snowflake/IdWorker.scala

import time

from .exceptions import InvalidSystemClock


# 64位ID的划分
WORKER_ID_BITS = 5
DATACENTER_ID_BITS = 5
SEQUENCE_BITS = 12

# 最大取值计算
MAX_WORKER_ID = -1 ^ (-1 << WORKER_ID_BITS)  # 2**5-1 0b11111
MAX_DATACENTER_ID = -1 ^ (-1 << DATACENTER_ID_BITS)

# 移位偏移计算
WOKER_ID_SHIFT = SEQUENCE_BITS
DATACENTER_ID_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS
TIMESTAMP_LEFT_SHIFT = SEQUENCE_BITS + WORKER_ID_BITS + DATACENTER_ID_BITS

# 序号循环掩码
SEQUENCE_MASK = -1 ^ (-1 << SEQUENCE_BITS)

# Twitter元年时间戳
TWEPOCH = 1288834974657


class Snowflake(object):
    """
    用于生成IDs
    """

    def __init__(self, datacenter_id, worker_id, sequence=0):
        """
        初始化
        :param datacenter_id: 数据中心（机器区域）ID
        :param worker_id: 机器ID
        :param sequence: 序号
        """
        # sanity check
        if worker_id > MAX_WORKER_ID or worker_id < 0:
            raise ValueError('worker_id值越界')

        if datacenter_id > MAX_DATACENTER_ID or datacenter_id < 0:
            raise ValueError('datacenter_id值越界')

        self.worker_id = worker_id
        self.datacenter_id = datacenter_id
        self.sequence = sequence

        self.last_timestamp = -1  # 上次计算的时间戳

    def _gen_timestamp(self):
        """
        生成整数时间戳
        :return:int timestamp
        """
        return int(time.time() * 1000)

    def get_id(self):
        """
        获取新ID
        :return:
        """
        timestamp = self._gen_timestamp()

        # 时钟回拨
        if timestamp < self.last_timestamp:
            raise InvalidSystemClock

        if timestamp == self.last_timestamp:
            self.sequence = (self.sequence + 1) & SEQUENCE_MASK
            if self.sequence == 0:
                timestamp = self._til_next_millis(self.last_timestamp)
        else:
            self.sequence = 0

        self.last_timestamp = timestamp

        new_id = ((timestamp - TWEPOCH) << TIMESTAMP_LEFT_SHIFT) | (self.datacenter_id << DATACENTER_ID_SHIFT) | \
                 (self.worker_id << WOKER_ID_SHIFT) | self.sequence
        return new_id

    def _til_next_millis(self, last_timestamp):
        """
        等到下一毫秒
        """
        timestamp = self._gen_timestamp()
        while timestamp <= last_timestamp:
            timestamp = self._gen_timestamp()
        return timestamp
```

</details>

<details>
<summary>snowflake/exceptions.py</summary>

```python
class InvalidSystemClock(Exception):
    """
    时钟回拨异常
    """
    pass
```

</details>