# 如何做项目

初学者可以给自己树立一个目标，做一个类似 QQ 这样的软件出来，它可以有无限的优化空间，比如：

1. 刚开始只是用 Qt、GTK+、WxWidgets、Fltk 等 GUI 库构建了一个界面，并不能发送和接受信息。

2. 增加一对一聊天功能，在这个过程中可以学习通信（socket）。

3. 同时支持多人聊天，每增加一个对话就开启了一个线程，这个过程中可以学习多线程编程。

4. 提高服务器的性能，让单台服务器同时抗住一万个人聊天，这个时候你可能就需要去优化程序了，就需要关注线程创建、调度的开销，关注通信过程中的缓存。

5. 增加群聊功能，让服务器可以给多个用户发送消息，这个时候你对通信的理解将更加深入。

6. 最后呢，你可以将多台服务器联合起来，抗住几十万人甚至上百万人聊天。

你可以自己完成这个项目，也可以组队完成，在这个过程中你将会全方位的学习 Linux C/C++ 编程。

总之，初学者要让学习过程变得有趣，不要天天研究操作系统、数据结构、算法、内存、线程进程、通信等理论，一定要去实践。
