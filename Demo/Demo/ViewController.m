//
//  ViewController.m
//  Demo
//
//  Created by JIANG SHOUDONG on 2021/2/23.
//

#import "ViewController.h"
#import "SDMockSignalCrash.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)btnAction:(id)sender {
    
    NSArray *array = @[@1, @2];
    NSLog(@"%@", array[2]);
//    @try {
//        NSArray *array = @[@1, @2];
//        NSLog(@"%@", array[2]);
//    } @catch (NSException *exception) {
//        NSLog(@"%@", exception.name);
//    } @finally {
//        NSLog(@"33");
//    }
//    SDMockSignalCrash *sc = [SDMockSignalCrash new];
//    [sc signalCarsh];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
