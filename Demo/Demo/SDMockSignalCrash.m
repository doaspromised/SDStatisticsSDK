//
//  SDMockSignalCrash.m
//  Demo
//
//  Created by JIANG SHOUDONG on 2021/2/24.
//

#import "SDMockSignalCrash.h"

@implementation SDMockSignalCrash
- (void)signalCarsh {
    NSMutableArray<NSString *> *array = [[NSMutableArray alloc] init];
    [array addObject:@"First"];
    [array release];
    NSLog(@"%@", array.firstObject);
}
@end

