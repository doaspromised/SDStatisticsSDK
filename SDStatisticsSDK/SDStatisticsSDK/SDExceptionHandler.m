//
//  SDExceptionHandler.m
//  SDStatisticsSDK
//
//  Created by JIANG SHOUDONG on 2021/2/23.
//

#import "SDExceptionHandler.h"

static NSString *const SDSignalExceptionHanlderName = @"SignalExceptionHanlder";
static NSString *const SDSignalExceptionHandlerUserInfo = @"SignalExceptionHandlerUserInfo";

@interface SDExceptionHandler ()

@property(nonatomic) NSUncaughtExceptionHandler *previousExceptionHandler;

@end

@implementation SDExceptionHandler

+ (instancetype)sharedInstance {
    static SDExceptionHandler *instacne = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        instacne = [[SDExceptionHandler alloc] init];
    });
    return instacne;
}

- (instancetype)init {
    if (self = [super init]) {
        // 在应用的实际开发中，可能会集成多个SDK，如果这些SDK都按照这种方法采集异常信息，总会有一些SDK采集不到异常信息。这是因为通过NSSetUncaughtExceptionHandler函数设置的一个全局异常处理函数，后面设置的异常处理函数会覆盖前面设置的异常处理函数。
        
        _previousExceptionHandler = NSGetUncaughtExceptionHandler();
        NSSetUncaughtExceptionHandler(&sdstatistics_uncaught_exception_handler);
        
        // 定义信号集结构体
        struct sigaction sig;
        // 将信号集初始化为空
        sigemptyset(&sig.sa_mask);
        // 在处理函数中传入__siginfo参数
        sig.sa_flags = SA_SIGINFO;
        // 设置信号集处理函数
        sig.sa_sigaction = &sdstatistics_signal_exception_handler;
        // 定义需要采集的信号类型
        int signals[] = { SIGILL, SIGABRT, SIGBUS, SIGFPE, SIGSEGV };
        for (int i = 0; i < sizeof(signals) / sizeof(int); i++) {
            // 注册信号处理
            int err = sigaction(signals[i], &sig, NULL);
            if (err) {
                NSLog(@"Errored while trying to set up sigaction for signal %d", signals[i]);
            }
        }
    }
    return self;
}

/**
 捕获Exception异常
 */
static void sdstatistics_uncaught_exception_handler(NSException *exception) {
    
    [[SDExceptionHandler sharedInstance] trackAppCrashedWithException:exception];
    NSUncaughtExceptionHandler *handler = [SDExceptionHandler sharedInstance].previousExceptionHandler;
    if (handler) {
        handler(exception);
    }
}

static void sdstatistics_signal_exception_handler(int sig, struct __siginfo *info, void *context) {
    NSDictionary *userInfo = @{ SDSignalExceptionHandlerUserInfo: @(sig) };
    NSString *reason = [NSString stringWithFormat:@"Signal %d was raised.", sig];
    // 创建一个异常对象，用于采集异常信息
    NSException *exception = [NSException exceptionWithName:SDSignalExceptionHanlderName reason:reason userInfo:userInfo];
    SDExceptionHandler *handler = [SDExceptionHandler sharedInstance];
    [handler trackAppCrashedWithException:exception];
}

- (void)trackAppCrashedWithException:(NSException *)exception {
//    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    // 异常名称
    NSString *name = [exception name];
    // 异常出现的原因
    NSString *reason = [exception reason];
    // 异常的堆栈信息,如果异常对象中没有堆栈信息，就获取当前线程的堆栈信息
    NSArray *stacks = [exception callStackSymbols] ?: [NSThread callStackSymbols];
    // 将信息组装
    NSString *exceptionInfo = [[NSString alloc] initWithFormat:@"Exception name: %@\nException reason: %@\nException stack: %@\n", name, reason, stacks];
    
    NSLog(@"\nexceptionInfo: %@\n", exceptionInfo);
}
@end
