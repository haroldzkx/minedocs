支付宝有沙箱环境，可以用于开发阶段测试。

控制台首页：[https://open.alipay.com/develop/manage](https://open.alipay.com/develop/manage)

沙盒环境首页：[https://open.alipay.com/develop/sandbox/app](https://open.alipay.com/develop/sandbox/app)

python-alipay-sdk Github（非官方）：[https://github.com/fzlee/alipay/blob/master/README.zh-hans.md](https://github.com/fzlee/alipay/blob/master/README.zh-hans.md)

APP接入指南：[https://opendocs.alipay.com/open/01dcc0](https://opendocs.alipay.com/open/01dcc0)

<details>
<summary>支付流程图解</summary>

![](https://mdn.alipayobjects.com/afts/img/A*TKy2TKpVL3wAAAAAAAAAAAAAAa8wAA/original?bz=openpt_doc&t=4msaCTXlxU0OKJWNkWsscvHbSGcA6jWukIuBa4lIU0UDAAAAZAAAMK8AAAAA)

</details>

# 准备工作

<details>
<summary>1.安装python-alipay-sdk</summary>

```python
pip install python-alipay-sdk
```

</details>

<details>
<summary>2.生成密钥文件</summary>

先下载安装OpenSSL， https://wiki.openssl.org/index.php/Binaries

```bash
# 生成私钥
openssl genrsa -out app_private_key.pem 2048
# 生成公钥
openssl rsa -in app_private_key.pem -pubout -out app_public_key.pem
```

如果是Mac或者Linux系统，则应该先输入openssl，在输入剩余的命令

```bash
openssl
OpenSSL> genrsa -out app_private_key.pem 2048
OpenSSL> rsa -in app_private_key.pem -pubout -out app_public_key.pem
OpenSSL> exit
```

</details>

<details>
<summary>3.Python代码实现</summary>

```python
from alipay import AliPay
from alipay.utils import AliPayConfig
import aiofiles

# 支付宝网页下载的证书不能直接被使用，需要加上头尾
# 你可以在此处找到例子： tests/certs/ali/ali_private_key.pem
# 异步读取公钥和私钥
async with aiofiles.open('keys/app_private.key', mode='r') as f:
    app_private_key_string = await f.read()
async with aiofiles.open('keys/alipay_public.pem', mode='r') as f:
    alipay_public_key_string = await f.read()

alipay = AliPay(
    appid=settings.ALIPAY_APP_ID,
    app_notify_url=None,  # 默认回调 url
    app_private_key_string=app_private_key_string,
    # 支付宝的公钥，验证支付宝回传消息使用，不是你自己的公钥,
    alipay_public_key_string=alipay_public_key_string,
    sign_type="RSA",  # RSA 或者 RSA2
    # 沙箱环境需要设置debug=True
    debug=True,  # 默认 False
    verbose=True,  # 输出调试数据
    config=AliPayConfig(timeout=15)  # 可选，请求超时时间
)

# App 支付，将 order_string 返回给 app 即可
order_string = alipay.api_alipay_trade_app_pay(
    out_trade_no=str(order.id),
    total_amount=float(order.amount),
    subject=seckill.commodity.title
)
# 获取支付宝的orderStr
return {"alipay_order": order_string}
```

</details>

