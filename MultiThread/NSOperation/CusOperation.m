//
//  CusOperation.m
//  MultiThread
//
//  Created by Xujiangfei on 2018/5/17.
//  Copyright © 2018年 Xujiangfei. All rights reserved.
//

#import "CusOperation.h"

@implementation CusOperation

- (void)main{
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }
}

@end
