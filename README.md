# SDStatisticsSDK

采集应用程序的崩溃信息，主要分为以下两种场景:

- NSException异常
- Unix信号异常

#### 捕获NSException异常

通过NSSetUncaughtExceptionHandler函数来全局设置异常处理函数，然后收集异常堆栈信息

#### 捕获信号

##### Mach异常和Unix信号

Mach是Mac OS和iOS操作系统的微内核，Mach异常就是最底层的内核级异常。在iOS系统中，每个Tread、Task、Host都有一个异常端口数据。开发者可以通过设置Tread、Task、Host的异常端口来捕获Mach异常。Mach异常会被转换成相应的Unix信号，并传递给出错的线程。

Unix信号种类有很多，在iOS应用程序中，常见的Unix信号有如下几种：

- SIGILL：程序的非法指令，通常是因为可执行文件本身出现错误，或者试图执行数据段。堆栈溢出也有可能产生该信号
- SIGABRT：程序中止命令中止信号，调用abort函数时产生该信号
- SIGBUS：程序内存字节地址未对齐中止信号，比如访问一个4字节长的整数，但是其地址不是4的倍数
- SIGFPE：程序浮点异常信号，通常在浮点运算错误、溢出及除数为0等算数错误时产生该信号
- SIGKILL：程序结束接受中止信号，用来立即结束程序运行，不能被处理、阻塞和忽略
- SIGSEGV：程序无效内存中止信号，即试图访问未分配的内存，或者向没有写权限的内存地址写数据
- SIGPIPE：程序管道破裂信号，通常是在进程间通信时产生该信号
- SIGSTOP：程序进程中止信号，与SIGKILL一样，不能被处理、阻塞和忽略。

在iOS应用程序中，一般情况下，一般情况下，采集SIGILL、SIGABRT、SIGBUS、SIGPIPE和SIGSEGV这几个常见的信号，就能满足日常采集应用程序异常信息的需求。

