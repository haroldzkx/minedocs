# 服务注册与发现

微服务架构是一种将应用程序作为一套小型服务的方式进行构建和部署的架构风格，每个服务运行在其独立的进程中，服务之间通过轻量级的通信机制（通常是HTTP资源API）进行互联。这种架构使得应用程序更易于扩展和管理，同时也提高了系统的可靠性和可维护性。

微服务架构中，系统被拆分成多个独立，可扩展，松耦合的服务单元，这些服务单元可能部署在不的服务器或容器上，且数量众多。在这样的架构下，服务之间的相互调用变得复杂，因此需要一机制来管理和维护服务实例的信息，这就是注册发现机制的重要性所在。注册发现机制确保了服务消费者能够快速，准确地找到所需的服务提供者，从而实现服务的透明调用，提高了系统的动态伸缩性和故障容错能力。
在微服务架构中，服务注册与发现是关键机制之一。

- 服务注册指的是服务实例在启动时在服务注册表中注册自己的过程，服务实例需要提供必要的信息，如服务名，IP地址，端口号等。

- 服务发现指的是在服务消费者需要调用服务提供者时，能够通过服务名从服务注册表中查询到服务实例的网络位置信息，从而实现服务间的相互调用。

常用的微服务注册与发现软件包括：

1. Eureka: Netflix开源的一个REST服务，用于定位服务，以实现中间层服务器的负载平衡和故障转移。

2. Consul: 由HashiCorp开发的工具，提供了服务发现，健康检查和键值存储功能。

3. Zookeeper: 是一个分布式的，开放源码的分布式应用程序协调服务，是Google的Chubby一个开源的实现，是Hadoop和HBase的重要组件。

4. Etcd: 一个分布式键值存储系统，用于共享配置和服务发现。

在Python中，选择合适的微服务注册与发现软件取决于具体的项目需求和环境。如果是在kubernetes这样的容器管理平台中，etcd是一个不错的选择，因为它与kubernetes集成得很好。Consul也是一个好的选择，因为它提供了丰富的功能，并且支持多数据中心。Eureka虽然主要与Spring Cloud集成使用，但也有Python客户端，可以用于Python项目。

# Consul

Consul是一个功能全面的服务发现和配置工具，具有以下特点：

1. 服务注册与发现：Consul 允许服务在启动时注册自己，并可以通过 DNS 或 HTTP 接口查询服务信息。

2. 健康检查：Consul 提供了健康检查机制，可以定期检查服务实例的健康状态，确保服务列表的信息是最新的。

3. 键值存储：Consul 内置了分布式键值存储，可以用于存储服务配置信息，支持动态更新。

4. 多数据中心支持：Consul 原生支持多数据中心，可以在不同的数据中心之间进行服务注册和发现。

5. Raft 算法：Consul 使用 Raft 算法来保证集群的一致性，即使在网络分区或节点故障的情况下也能保特服务的稳定性。

6. 易于集成：Consul 提供了丰富的 API 和集成接口，可以轻松与其他系统集成。

安装方式：[https://developer.hashicorp.com/consul/install](https://developer.hashicorp.com/consul/install)

开发阶段仅创建一个server和一个client，运行命令：

```bash
consul agent -dev -client 0.0.0.0
```

操作方式：

<details>
<summary>1. 通过API</summary>

服务注册与发现，可以直接使用Consul API，然后通过网络请求库，比如requests/httpx来发送请求。

Consul API接口文档：[https://developer.hashicorp.com/consul/api-docs/agent/service](https://developer.hashicorp.com/consul/api-docs/agent/service)

</details>

<details>
<summary>2. 通过SDK</summary>

也可以使用SDK来操作。

操作Consul的各种官方和非官方的SDK地址：[https://developer.hashicorp.com/consul/api-docs/libraries-and-sdks](https://developer.hashicorp.com/consul/api-docs/libraries-and-sdks)

</details>

# py-consul

使用第三方的py-consul库来进行服务注册与发现。

py-consul: [https://github.com/criteo/py-consul](https://github.com/criteo/py-consul)

python-consul: [https://python-consul.readthedocs.io/en/latest/](https://python-consul.readthedocs.io/en/latest/)

安装：`pip install py-consul`

负载均衡: [https://github.com/grpc/grpc/blob/master/doc/load-balancing.md](https://github.com/grpc/grpc/blob/master/doc/load-balancing.md)

重用连接: [https://github.com/grpc/grpc/issues/20985](https://github.com/grpc/grpc/issues/20985)

## 服务注册

python与consul注册：[https://www.cnblogs.com/yuzhenjie/p/9398569.html](https://www.cnblogs.com/yuzhenjie/p/9398569.html)

<details>
<summary>gRPC服务注册，取消服务注册，自动获取IP和端口</summary>

```python
import consul
import uuid
import socket
from loguru import logger

client = consul.Consul(host='localhost', port=8500)

# 自动获取IP，port
def get_ip_port() -> Tuple[str, int]:
    sock_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock_ip.connect(('8.8.8.8', 80))
    ip = sock_ip.getsockname()[0]
    sock_ip.close()

    sock_port = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock_port.bind(("", 0))
    _, port = sock_port.getsockname()
    sock_port.close()
    return ip, port

# gRPC服务注册
def register_consul(ip: str, port: int):
    service_id = uuid.uuid4().hex
    client.agent.service.register(
        name='user_service',
        service_id=service_id,
        address=ip,
        port=port,
        tags=['user', 'grpc'],
        check=consul.Check.tcp(host=ip, port=port, interval='10s')
    )
    return service_id

# 取消服务注册
def deregister_consul(service_id: str):
    client.agent.service.deregister(service_id)

async def main():
    ip, port = get_ip_port()
    service_id = register_consul(ip, port)
    logger.info(f"gRPC服务已经启动：0.0.0.0:{port}")
    try:
        pass
    finally:
        deregister_consul(service_id)

if __name__ == '__main__':
    asyncio.run(main())
```

</details>

<details>
<summary>HTTP服务注册，取消注册，自动获取IP端口，服务发现，负载均衡</summary>

```python
import consul
from .single import SingletonMeta
import uuid
import socket
from typing import Tuple
import settings
# pip install dnspython
from dns import asyncresolver, rdatatype
from typing import List, Dict


def get_current_ip() -> Tuple[str, int]:
    sock_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock_ip.connect(('8.8.8.8', 80))
    ip = sock_ip.getsockname()[0]
    sock_ip.close()
    return ip


class ServiceAddress:
    def __init__(self, host: str, port: int):
        self.host = host
        self.port = port
        self.count = 0

    def increment(self):
        self.count += 1


class LoadBalancer:
    def __init__(self, addresses: List[Dict[str, str|int]]=None):
        self.addresses: List[ServiceAddress] = []
        if addresses:
            self.init_addresses(addresses)

    def init_addresses(self, addresses: List[Dict[str, str|int]]):
        self.addresses.clear()
        for address in addresses:
            self.addresses.append(ServiceAddress(host=address['ip'], port=address['port']))

    def get_address(self) -> Tuple[str|None, int|None]:
        if len(self.addresses) > 0:
            self.addresses.sort(key=lambda address: address.count)
            address = self.addresses[0]
            address.increment()
            return address.host, address.port
        else:
            return None, None


class MineConsul(metaclass=SingletonMeta):
    def __init__(self):
        self.consul_host = settings.CONSUL_HOST
        self.consul_http_port = settings.CONSUL_HTTP_PORT
        self.consul_dns_port = settings.CONSUL_DNS_PORT
        self.client = consul.Consul(host=self.consul_host, port=self.consul_http_port)
        self.user_service_id = uuid.uuid4().hex
        self.user_service_lb = LoadBalancer()

    # HTTP服务注册
    def register(self):
        ip = get_current_ip()
        port = settings.SERVER_PORT
        self.client.agent.service.register(
            name='user_api',
            service_id=self.user_service_id,
            address=ip,
            port=port,
            tags=['user', 'http'],
            check=consul.Check.http(url=f"http://{ip}:{port}/health", interval='10s')
        )

    # 取消注册
    def deregister(self):
        self.client.agent.service.deregister(self.user_service_id)

    # 服务发现
    async def fetch_user_service_addresses(self):
        resolver = asyncresolver.Resolver()
        resolver.nameservers = [self.consul_host]
        resolver.port = self.consul_dns_port

        answer_ip = await resolver.resolve(f'user_service.service.consul', rdatatype.A)
        ips = []
        for info in answer_ip:
            ips.append(info.address)

        ports = []
        answer_port = await resolver.resolve('user_service.service.consul', rdatatype.SRV)
        for info in answer_port:
            ports.append(info.port)

        user_addresses = []
        for index, port in enumerate(ports):
            if len(ips) == 1:
                user_addresses.append({"ip": ips[0], 'port': port})
            else:
                user_addresses.append({"ip": ips[index], 'port': port})
        self.user_service_lb.init_addresses(user_addresses)

    def get_one_user_service_address(self) -> Tuple[str|None, int|None]:
        return self.user_service_lb.get_address()
```

</details>

<details>
<summary>自动获取IP和端口</summary>

```python
import socket
from loguru import logger

def get_ip_port() -> Tuple[str, int]:
    sock_ip = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock_ip.connect(('8.8.8.8', 80))
    ip = sock_ip.getsockname()[0]
    sock_ip.close()

    sock_port = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock_port.bind(("", 0))
    _, port = sock_port.getsockname()
    sock_port.close()
    return ip, port
```

</details>