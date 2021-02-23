# SDStatisticsSDK

采集应用程序的崩溃信息，主要分为以下两种场景:

- NSException异常
- Unix信号异常

#### 捕获NSException异常

通过NSSetUncaughtExceptionHandler函数来全局设置异常处理函数，然后收集异常堆栈信息。

