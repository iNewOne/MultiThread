//
//  GCDViewController.m
//  MultiThread
//
//  Created by Xujiangfei on 2018/5/16.
//  Copyright © 2018年 Xujiangfei. All rights reserved.
//

#import "GCDViewController.h"

@interface GCDViewController ()

@property (nonatomic, strong) dispatch_semaphore_t semaphoreTicket;
@property (nonatomic, assign) NSInteger ticketCount;
@end

@implementation GCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD Test";
//    [self syncWithConcurrent];
//    [self asyncConcurrent];
//    [self syncSerial];
//    [self asyncSerial];
//    [self syncMain];
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
//    [self asyncMain];
//    [self communication];
//    [self barrier];
//    [self after];
//    [self apply];
//    [self group];
//    [self semaphoreDemoOne];
    [self initTickets];
    // Do any additional setup after loading the view from its nib.
}


/**
 线程同步
 */
- (void)semaphoreDemoOne{
    NSLog(@"currentThread --- %@", [NSThread currentThread]);
    NSLog(@"semaphore --- begin");
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@", [NSThread currentThread]);
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"samaphore --- end, number = %d", number);
    
}


/**
 模拟两个窗口售票
 */
- (void)initTickets{
    
    self.semaphoreTicket = dispatch_semaphore_create(1);
    self.ticketCount = 10;
    
    dispatch_queue_t queueOne = dispatch_queue_create("com.easyFly.one", 0);
    dispatch_queue_t queueTwo = dispatch_queue_create("com.easyFly.Two", 0);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(queueOne, ^{
        [weakSelf saleTicket];
    });

    dispatch_async(queueTwo, ^{
        [weakSelf saleTicket];
    });
    
}

- (void)saleTicket{
    while (true) {
        dispatch_semaphore_wait(_semaphoreTicket, DISPATCH_TIME_FOREVER);
        if (self.ticketCount > 0) {
            self.ticketCount --;
            NSLog(@"剩余票 --- %ld   窗口 --- %@", self.ticketCount, [NSThread currentThread]);
        }else{
            NSLog(@"所有票均已售完");
            // 相当于解锁
            dispatch_semaphore_signal(_semaphoreTicket);
            break;
        }
        dispatch_semaphore_signal(_semaphoreTicket);
    }
}




- (void)group{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"group one start");
    dispatch_group_enter(group);
    NSLog(@"CurrentThread --- %@", [NSThread currentThread]);
    dispatch_group_async(group, queue, ^{
        dispatch_async(queue, ^{
            NSLog(@"dispatch_async --- %@", [NSThread currentThread]);
            sleep(3);  //模拟异步请求
            NSLog(@"group one finished");
            dispatch_group_leave(group);
        });
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"dispatch_group_notify --- %@", [NSThread currentThread]);
        NSLog(@"group finished");
    });
}

- (void)apply {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    NSLog(@"apply---begin");
    dispatch_apply(5, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index, [NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 这里的代码指挥执行一次
    });
}

- (void)after{
    NSLog(@"currentThread---%@", [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"after---%@", [NSThread currentThread]);
    });
}


- (void)barrier{
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_async(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}


- (void)communication{
    dispatch_queue_t global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(global, ^{
        for (int i = 0; i < 3; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1--- %@", [NSThread currentThread]);
        }
        
        dispatch_async(main, ^{
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@", [NSThread currentThread]);
        });
    });
}

/**
 只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMain{
    NSLog(@"currentThread -- %@", [NSThread currentThread]);
    
    NSLog(@"begin");
    
    dispatch_queue_t queueu = dispatch_get_main_queue();
    
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"111----%@", [NSThread currentThread]);
        }
    });
    //追加任务
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"222----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"333----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}


/**
 卡死
 */
- (void)syncMain{
    NSLog(@"currentThread -- %@", [NSThread currentThread]);
    
    NSLog(@"begin");
    
    dispatch_queue_t queueu = dispatch_get_main_queue();
    
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"111----%@", [NSThread currentThread]);
        }
    });
    //追加任务
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"222----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"333----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}


/**
 创建新线程，但是任务是串行的，会一个一个执行
 */
- (void)asyncSerial{
    NSLog(@"currentThread -- %@", [NSThread currentThread]);
    
    NSLog(@"begin");
    
    dispatch_queue_t queueu = dispatch_queue_create("com.easyfly.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"111----%@", [NSThread currentThread]);
        }
    });
    //追加任务
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"222----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"333----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}


/**
 不会创建新的线程，在当前线程执行，任务串行执行
 */
- (void)syncSerial{
    NSLog(@"currentThread -- %@", [NSThread currentThread]);
    
    NSLog(@"begin");
    
    dispatch_queue_t queueu = dispatch_queue_create("com.easyfly.queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"111----%@", [NSThread currentThread]);
        }
    });
    //追加任务
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"222----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"333----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}


/**
 同步并发执行
 在当前线程执行任务，不会开启新线程，执行完一个任务，在执行下一个任务
 */
- (void)syncWithConcurrent{
    NSLog(@"currentThread -- %@", [NSThread currentThread]);
    
    NSLog(@"begin");

    dispatch_queue_t queueu = dispatch_queue_create("com.easyfly.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"111----%@", [NSThread currentThread]);
        }
    });
    //追加任务
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"222----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_sync(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"333----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}


/**
 可以开启多个线程，交替执行任务
 */
- (void)asyncConcurrent{
    NSLog(@"currentThread -- %@", [NSThread currentThread]);
    
    NSLog(@"begin");
    
    dispatch_queue_t queueu = dispatch_queue_create("com.easyfly.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"111----%@", [NSThread currentThread]);
        }
    });
    //追加任务
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"222----%@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queueu, ^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"333----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"end");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
