//
//  NextViewController.m
//  Demo
//
//  Created by JD on 2019/8/14.
//  Copyright © 2019 JD. All rights reserved.
//

#import "NextViewController.h"
#import "TestObject.h"
#import "NSObject+JDDeallocBlock.h"

static int i = 0;

@interface NextViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray *normalArray;

@property (nonatomic, strong) NSPointerArray *weakPointerArray;

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
    
    self.normalArray = [NSMutableArray array];
    self.weakPointerArray = [NSPointerArray weakObjectsPointerArray];
    
    [NSHashTable weakObjectsHashTable];
    [NSPointerArray weakObjectsPointerArray];
    [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsWeakMemory];
    [NSMapTable weakToWeakObjectsMapTable];;
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
                [self.weakPointerArray addPointer:(__bridge void * _Nullable)(lable)];
                
                if (i % 2 == 0) {
                    [self.normalArray addObject:lable];
                }
            }
            CFAbsoluteTime endTime = CFAbsoluteTimeGetCurrent() - startTime;

            NSLog(@"count:%ld,runtime:%f",self.weakPointerArray.count,endTime);
        }
    });
}



- (IBAction)removeAction:(id)sender {
    NSLog(@"%@",sender);
}

- (void)point {
    //初始化一个弱引用数组对象
    NSPointerArray *weakPointerArray = [NSPointerArray weakObjectsPointerArray];
    for(int i=0;i<10;i++){
        NSObject *obj = [NSObject new];
        //往数组中添加对象
        [weakPointerArray addPointer:(__bridge void * _Nullable)(obj)];
    }
    //输出数组中的所有对象,如果没有对象会输出一个空数组
    NSArray *array = [weakPointerArray allObjects];
    NSLog(@"%@",array);
    //输出数组中的元素个数,包括NULL
    NSLog(@"%zd",weakPointerArray.count);//此时输出:10,因为NSObject在for循环之后就被释放了
    //先数组中添加一个NULL
    [weakPointerArray addPointer:NULL];
    NSLog(@"%zd",weakPointerArray.count);//输出:11
    //清空数组中的所有NULL,注意:经过测试如果直接compact是无法清空NULL,需要在compact之前,调用一次[_weakPointerArray addPointer:NULL],才可以清空
    [weakPointerArray compact];
    NSLog(@"%zd",weakPointerArray.count);//输出:0
    //注意:如果直接往_weakPointerArray中添加对象,那么addPointer方法执行完毕之后,NSObject会直接被释放掉
    [weakPointerArray addPointer:(__bridge void * _Nullable)([NSObject new])];
    NSLog(@"%@",[weakPointerArray allObjects]);//输出:空数组 NSPointArray[7633:454561] ()
    //应该这样添加对象
    NSObject *obj = [NSObject new];
    [weakPointerArray addPointer:(__bridge void * _Nullable)obj];
    NSLog(@"%@",[weakPointerArray allObjects]);//输出:NSPointArray[7633:454561] ("<NSObject: 0x6000000078c0>")
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
