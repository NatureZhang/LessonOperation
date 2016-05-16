//
//  MyOperation.h
//  NSOperation
//
//  Created by zhangdong on 16/5/16.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>

// http://www.jianshu.com/p/c6650fcc6612

@interface MyOperation : NSOperation{
    BOOL        executing;
    BOOL        finished;
}

- (void)completeOperation;

@end
