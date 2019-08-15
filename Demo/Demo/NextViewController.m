//
//  NextViewController.m
//  Demo
//
//  Created by JD on 2019/8/14.
//  Copyright © 2019 JD. All rights reserved.
//

#import "NextViewController.h"
#import "Manager.h"
#import "JDMutableWeakArray.h"
#import "TestObject.h"
#import "NSObject+JDDeallocBlock.h"

static int i = 0;

@interface NextViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray *normalArray;

@property (nonatomic, strong) JDMutableWeakArray *testArray;

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    i = i + 1;
    self.label = [[UILabel alloc] init];
    self.label.text = @"test";
    self.label.tag = i;
    self.label.frame = CGRectMake(100, 100, 100, 30);
    [self.view addSubview:self.label];
    
    [[Manager sharedInstance] addObject:self.label];
    
    self.normalArray = [NSMutableArray array];
    self.testArray = [[JDMutableWeakArray alloc] init];
    // Do any additional setup after loading the view.
}

- (IBAction)normalAction:(id)sender {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        @autoreleasepool {
            [self.normalArray removeAllObjects];
            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
            for (NSInteger i = 0 ; i < 100000; i++) {
                  NSObject *lable = [[NSObject alloc] init];
                [self.normalArray addObject:lable];
            }
            CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent() - startTime;

            NSLog(@"count:%ld,runtime:%f",self.normalArray.count,endTime);
        }
    });
    
}


/// 经测试，性能较NSMutableArray差10倍左右，请谨慎使用
- (IBAction)testDealloc:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        @autoreleasepool {
            CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
            for (NSInteger i = 0 ; i < 100000; i++) {
                TestObject *lable = [[TestObject alloc] init];
                lable.tag = i;
                [self.testArray addObject:lable];
                
                if (i % 2 == 0) {
                    [self.normalArray addObject:lable];
                }
            }
            CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent() - startTime;

            NSLog(@"count:%ld,runtime:%f",self.testArray.count,endTime);
        }
    });
}



- (IBAction)removeAction:(id)sender {
    [[Manager sharedInstance] removeObject:self.label];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    NSLog(@"NextViewController");
}

@end
