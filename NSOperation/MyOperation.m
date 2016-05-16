//
//  MyOperation.m
//  NSOperation
//
//  Created by zhangdong on 16/5/16.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "MyOperation.h"

@interface MyOperation ()

@property (nonatomic, strong) NSLock *lock;

@end

@implementation MyOperation

- (id)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished = NO;
    }
    return self;
}

- (void)start {
    [self.lock lock];
    // 在开始任务之前要测试一下是否取消
    if ([self isCancelled])
    {
        // 如果是已经取消了，必需要把Finish设为YES
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    // 如果没有取消，就继续运行代码
    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self.lock unlock];
}

- (void)main {
    @try {
        
        // 写你业务代码
        for (int i = 0; i < 10000; i ++) {
            NSLog(@"myoperation_%@_%d", [NSThread currentThread], i);
        }
        [self completeOperation];
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

- (void)completeOperation {
    [self.lock lock];
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    [self.lock unlock];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}
@end
