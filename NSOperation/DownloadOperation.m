//
//  DownloadOperation.m
//  NSOperation
//
//  Created by zhangdong on 16/5/16.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "DownloadOperation.h"

@implementation DownloadOperation

- (id)initWithUrl:(NSString *)url delegate:(id<DownloadOperationDelegate>)delegate {
    if (self = [super init]) {
        self.imageUrl = url;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)dealloc {
    
}

- (void)main {
    
    // 新建一个自动释放池，如果是异步执行操作，那么将无法访问到主线程的自动释放池
    @autoreleasepool {
        if (self.isCancelled) {
            return;
        }
        
        for (int i = 0; i < 10000 && !(self.isCancelled); i ++) {
            
            NSLog(@"operation_%@_%d_%d", [NSThread currentThread], [NSThread isMainThread], i);
        }
        
        
/*
        // 获取图片数据
        NSURL *url = [NSURL URLWithString:self.imageUrl];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        if (self.isCancelled) {
            url = nil;
            imageData = nil;
            return;
        }
        
        // 初始化图片
        UIImage *image = [UIImage imageWithData:imageData];
        if (self.isCancelled) {
            image = nil;
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(downloadFinishWithImage:)]) {
            [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloadFinishWithImage:) withObject:image waitUntilDone:NO];
        }
*/
    
    
    
    }
}
@end
