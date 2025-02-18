# 消息队列

消息队列（Message Queue）是一种用于在不同进程，不同服务器之间传递消息的中间件技术。它提供了一种异步的通信机制，允许消息的发送者和接收者无需同时在线，从而提高了系统的解耦性和伸缩性。消息队列在分布式系统中扮演着至关重要的角色，它能够有效地缓冲和调度消息流，确保数据的一致性和系统的稳定性。

常见的消息队列有以下几种：

1. RabbitMQ: 适用于数据量不是特别大，但对消息传递的可靠性和事务性有较高要求的应用

2. RocketMQ: 适用于需要高可靠，高可用的大规模分布式系统

3. Redis: 虽然主要用作缓存数据库，但 Redis 也提供了消息队列的功能，如发布/订阅模式

4. Kafka: 一个分布式流处理平台，具有高吞吐量，可扩展性和容错性

选择：

- 如果需要处理大量数据，并且关注吞吐量和可扩展性，那么 Kafka 可能是最佳选择

- 如果系统对消息的可靠性和事务性有较高要求，并目消息路由较为复杂，RabbitMQ 可能更适合

- 如果系统规模较大，需要高可靠，高可用的消息服务，并且有顺序消息或分布式事务的需求，RocketMQ 可能是更合适的选择

# Kafka

<details>
<summary>Kafka 简介</summary>

Kafka 是由 Apache 软件基金会开发的一个开源流处理平台，它以其高吞吐量，可扩展性和容错性而闻名。Kafka主要用于构建实时的数据流和消息系统，以下是 Kafka 的一些关键特性：

- 分布式架构：Kafka 集群由多个服务器组成，可以跨多个数据中心部署，保证了高可用性和可扩展性。
- 高吞吐量：Kafka 能够处理大量的数据流，适用于需要高吞吐量的应用场景。
- 持久化：Kafka 将消息存储在磁盘上，即使系统发生故障，也能保证数据不丢失。
- 可扩展性：Kafka 支持水平扩展，可以通过增加更多的服务器来提高集群的处理能力。
- 多个消费者：Kafka 支持多个消费者同时消费同一消息流，且每个消费者可以独立控制消费的位置。
- 消息持久化：Kafka 能够保留大量的消息数据，支持数据回溯和重放。
- 流处理：Kafka 提供了流处理 API, 允许用户在数据流动过程中进行实时处理和分析。

Kafka 的这些特性使其在日志收集，流数据处理，实时分析，事件源等场景中得到了广泛的应用，例如，Kafka 可以用于处理用户行为数据，应用程序日志，系统监控数据等，是构建大数据和实时数据处理平台的重要工具。

</details>

<details>
<summary>Kafka 相关术语</summary>

- Broker: 消息中间件处理节点，一个 Kafka 节点就是一个broker，一个或者多个 Broker 可以组成一个 Kafka 集群

- Topic: Kafka 根据 Topic 对消息进行归类，发布到 Kafka 集群的每条消息都需要指定一个 Topic

- Event: 发送到指定 Topic 的“消息”

- Producer: 消息生产者，向 Broker 发送消息的客户端

- Consumer: 消息消费者，向 Broker 读取消息的客户端

- ConsumerGroup: 每个 Consumer 属于一个特定的 Consumer Group，一条消息可以被多个不同的 Consumer Group 消费，但是一个 Consumer Group 中只能有一个 Consumer 能够消费该消息

- Partition: 物理上的概念，一个 Topic 可以分为多个 Partition，每个 Partition 内部消息是有序的

</details>

<details>
<summary>安装</summary>

```bash
# 1.先安装JDK
sudo apt install default-jdk

# 2.下载安装包
kafka_2.13-3.8.0.tgz

# 3.解压安装包
tar -zxvf kafka_2.13-3.8.0.tgz
```

</details>

<details>
<summary>运行</summary>

```bash
# 进入到 kafka 的目录
cd kafka_2.13-3.8.0

# 修改配置 config/kraft/server.properties
advertised.listeners=PLAINTEXT://192.168.5.10:9092

# 启动
bin/kafka-server-start.sh config/kraft/server.properties
# 注意：
# config/server.properties 底层用的是 ZooKeeper
# config/kraft/server.properties 底层摆脱了 ZooKeeper
```

</details>

<details>
<summary>创建 Topic</summary>

消息需要发送给指定的 Topic

```bash
bin/kafka-topics.sh --create --topic seckill --bootstrap-server localhost:9092
```

</details>

<details>
<summary>生产消息</summary>

```bash
bin/kafka-console-producer.sh --topic seckill --bootstrap-server localhost:9092
>This is first event
>THis is second event
```

</details>

<details>
<summary>消费消息</summary>

```bash
bin/kafka-console-consumer.sh --topic seckill --from-beginning --bootstrap-server localhost:9092
>This is first event
>THis is second event
```

</details>

# Python 操作 Kafka

<details>
<summary>安装</summary>

```bash
pip install kafka-python

# kafka-python 在 Python 3.12 上存在bug，解决办法是不适用上面的命令安装
pip install git+https://github.com/dpkp/kafka-python.git
```

</details>

<details>
<summary>生产者</summary>

使用生产者生产数据前，先创建一个 Topic，然后使用以下代码发布数据到消息队列中

```python
from kafka import KafkaProducer
import json

kafka_producer = KafkaProducer(
    bootstrap_servers='192.168.0.7:9092',
    value_serializer=lambda v : json.dumps(v).encode('utf-8')
)

@router.post('/buy')
async def buy(
    data: BuySchema,
    user_id: int = Depends(auth_handler.auth_access_dependency)
):
    buy_data = data.model_dump()
    buy_data['user_id'] = user_id
    kafka_producer.send('seckill', buy_data)
    return "ok"
```

</details>

<details>
<summary>消费者</summary>

```python
from kafka import KafkaConsumer
import json

consumer = KafkaConsumer(
    'seckill',
    auto_offset_reset='earliest',
    bootstrap_servers=[settings.KAFKA_SERVER],
    value_deserializer=lambda m : json.loads(m.decode('utf-8'))
)

async def order_consumer():
    print("coming...")
    for message in consumer:
        print(message)
```

</details>

