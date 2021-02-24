//
//  SDStatisticsSDK.m
//  SDStatisticsSDK
//
//  Created by JIANG SHOUDONG on 2021/2/23.
//

#import "SDStatisticsSDK.h"
#import "SDExceptionHandler.h"
@implementation SDStatisticsSDK

+ (instancetype)sharedInstance {
    static SDStatisticsSDK *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        instance = [[SDStatisticsSDK alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [SDExceptionHandler sharedInstance];
    }
    return self;
}

@end
