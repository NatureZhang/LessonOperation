//
//  ViewController.h
//  NSOperation
//
//  Created by zhangdong on 16/5/16.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@end

/*
 NSOperation 表示了一个独立的计算单元，作为一个抽象类，它给他的子类一个十分有用而且线程安全的方式来建立状态、优先级、依赖性、和取消等的模型
 
 NSOperationQueue 控制着这些并行操作的执行，它扮演着优先级队列的角色，让它管理的高优先级操作能优先于低优先级的操作运行的情况下，使它管理的操作能基本遵循先进先出的原则进行
 
 可以调用 start 开始一个NSOperation，也可以将它添加到NSOperationQueue中，添加之后，它会在队列拍到它以后自动执行
*/