//
//  SDStatisticsSDK.m
//  SDStatisticsSDK
//
//  Created by JIANG SHOUDONG on 2021/2/23.
//

#import "SDStatisticsSDK.h"
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>
#import "SDExceptionHandler.h"

@interface SDStatisticsSDK ()
// 预置属性, sdk默认自动采集的数据
@property(nonatomic, strong) NSDictionary<NSString *, id> *automaticProperties;

@end

static NSString *const SDStatisticSDKVersion = @"1.0.0";

@implementation SDStatisticsSDK

+ (instancetype)sharedInstance {
    static SDStatisticsSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        instance = [[SDStatisticsSDK alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticProperties = [self collectAutomaticProperties];
        [SDExceptionHandler sharedInstance];
    }
    return self;
}

//MARK: - Properties
- (NSDictionary<NSString *, id> *)collectAutomaticProperties {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    properties[@"$os"] = @"iOS";
    properties[@"$lib"] = @"iOS";
    properties[@"$manufacturer"] = @"Apple";
    properties[@"$lib_version"] = SDStatisticSDKVersion;
    properties[@"$model"] = [self deviceModel];
    properties[@"$os_version"] = UIDevice.currentDevice.systemVersion;
    properties[@"$app_version"] = NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
    return properties.copy;
}
/// 获取手机型号
- (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char answer[size];
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = @(answer);
    return results;
    
}

- (void)printEvent: (NSDictionary *)event {
#if DEBUG
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:event options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        return NSLog(@"JSON Serialized Error: %@", error);
    }
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"[Event]: %@", json);
#endif
}
@end

@implementation SDStatisticsSDK (Track)

- (void)track:(NSString *)eventName properties:(NSDictionary<NSString *,id> *)properties {
    NSMutableDictionary *event = [NSMutableDictionary dictionary];
    event[@"event"] = eventName;
    event[@"time"] = [NSNumber numberWithLong:NSDate.date.timeIntervalSince1970 * 1000];
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    [eventProperties addEntriesFromDictionary:self.automaticProperties];
    [eventProperties addEntriesFromDictionary:properties];
    event[@"property"] = eventProperties;
    // 在xcode控制台打印日志
    [self printEvent:event];
}

@end
