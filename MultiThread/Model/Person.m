//
//  Person.m
//  AF_Demo
//
//  Created by Xujiangfei on 2018/5/15.
//  Copyright © 2018年 Xujiangfei. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)sayHello:(NSString *)name{
    NSLog(@"Hello, %@", name);
    NSLog(@"hello %@",[NSThread currentThread]);
}

@end
