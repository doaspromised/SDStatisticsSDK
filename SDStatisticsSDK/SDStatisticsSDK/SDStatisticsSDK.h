//
//  SDStatisticsSDK.h
//  SDStatisticsSDK
//
//  Created by JIANG SHOUDONG on 2021/2/23.
//

#import <Foundation/Foundation.h>

//! Project version number for SDStatisticsSDK.
FOUNDATION_EXPORT double SDStatisticsSDKVersionNumber;

//! Project version string for SDStatisticsSDK.
FOUNDATION_EXPORT const unsigned char SDStatisticsSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SDStatisticsSDK/PublicHeader.h>

@interface SDStatisticsSDK : NSObject
/**
 @abstract
 获取SDK实例
 
 @return 返回单例
 */
+ (instancetype)sharedInstance;

@end
