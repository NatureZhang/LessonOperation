//
//  ViewController.m
//  NSOperation
//
//  Created by zhangdong on 16/5/16.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import "ViewController.h"
#import "DownloadOperation.h"
#import "MyOperation.h"
/*
 
 1 方便控制线程执行顺序
 2 使用NSBlockOperation 可以使用块代码，不必单写线程方法，便于传递多个参数
 3 可以控制线程并发数，有效的对线程进行控制
 4 可以添加线程完成代码块，执行需要的操作
 
 */

/*
 
 1 http://www.cnblogs.com/mjios/archive/2013/04/19/3029765.html
 2 http://www.saitjr.com/ios/ios-multithreading-nsoperation.html
 
 */

/*
 http://www.jianshu.com/p/52fe1b85c404
 感觉这个总结的挺好的
 
 有了GCD 为什么还会有NSOperationQueue
 1  NSOperationQueue以及相关对象是基于GCD的Objective-C对象的封装，作为一个对象，为我们提供了更多的选项
 2  NSOperationQueue任务可以很方便的取消（也只能取消未执行的任务），而GCD没法停止已经加入队列的任务（其实是有的，但需要许多复杂的代码）
 3  NSOperation能够方便的通过依赖关系设置操作的执行顺序，可以控制任务在特定的任务执行完成后才执行，而GCD要实现这个功能的话，需要通过barrier或者group来控制顺序，如果依赖关系复杂的话，代码逻辑就非常复杂了
 4  NSOperation支持KVO，可以方便的监听任务的状态（完成、执行中、取消。。）
 5  NSOperation可以设置同一个队列中任务的优先级，能够使同一个并行队列中的任务区分先后的执行，而在GCD中，只能区分不同队列的优先级，如果要区分block任务的优先级，也需要大量的复杂代码
 6  通过自定义NSOperation，封装任务逻辑，提高整个代码的复用度
 */


@interface ViewController ()

@property (nonatomic, strong) NSOperation *operation;
@property (nonatomic, strong) NSBlockOperation *blockOperation;
@property (nonatomic, strong) DownloadOperation *dOperation;
@property (nonatomic, strong) NSOperationQueue *operationQueue;//队列

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self createOperation];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

// NSOperation 把一个操作封装到一个对象中

- (void)createOperation {

    /*
     如果操作中只有一个操作，将会在主线程中执行
     */
    
        // 1 NSInvocationOperation
    
//    _operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runOperation) object:nil];
//    _operation.completionBlock = ^() {
//        NSLog(@"NSInvocationOperation 执行完毕");
//    };
    
        // 2 NSBlockOperation
    
//    _operation = [NSBlockOperation blockOperationWithBlock:^{
//        for (int i = 0; i < 10000; i ++) {
//            
//            NSLog(@"operation_%@_%d_%d", [NSThread currentThread], [NSThread isMainThread], i);
//        }
//    }];
    
        // 3 并发执行多个操作(此时是在多线程中执行的，执行顺序不确定)
    
//    _operation = [NSBlockOperation blockOperationWithBlock:^{
//        NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
//    }];
//    
//    [(NSBlockOperation *)_operation addExecutionBlock:^() {
//        NSLog(@"又执行了2个新的操作，线程：%@", [NSThread currentThread]);
//    }];
//    
//    [(NSBlockOperation *)_operation addExecutionBlock:^() {
//        NSLog(@"又执行了3个新的操作，线程：%@", [NSThread currentThread]);
//    }];
//
//    [(NSBlockOperation *)_operation addExecutionBlock:^() {
//        NSLog(@"又执行了4个新的操作，线程：%@", [NSThread currentThread]);
//        for (int i = 0; i < 10000; i ++) {
//            
//            NSLog(@"operation_%@_%d_%d", [NSThread currentThread], [NSThread isMainThread], i);
//        }
//    }];
    
        // 4 自定义NSOperation
//    _operation = [[DownloadOperation alloc] init];

}

- (void)createOperationQueue {
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
         NSLog(@"执行第1次操作，线程：%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第2次操作，线程：%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"执行第3次操作，线程：%@", [NSThread currentThread]);
//        for (int i = 0; i < 10000; i ++) {
//            NSLog(@"执行第3次操作，线程：%@_%d", [NSThread currentThread], i);
//        }
    }];
    
    NSBlockOperation *operation4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第4次操作，线程：%@", [NSThread currentThread]);
    }];

    
    NSBlockOperation *operation5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"执行第5次操作，线程：%@", [NSThread currentThread]);
    }];
    
    self.operation = operation5;
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    [operation4 addDependency:operation3];
    [self.operation addDependency:operation4];
    
    [self.operationQueue addOperation:operation1];
    [self.operationQueue addOperation:operation2];
    [self.operationQueue addOperation:operation3];
    [self.operationQueue addOperation:operation4];
    [self.operationQueue addOperation:operation5];
    
    // 即使设置最大并发数为1，它也不是串行的，执行顺序仍然依赖于其它因素，比如operation是否准备好喝operation的优先级等
//    [self.operationQueue setMaxConcurrentOperationCount:1];
}


- (IBAction)startOperation:(id)sender {
    
    // 默认情况下，调用了start方法后并不会开一条新线程去执行操作，而是在当前线程同步执行操作，只有将operation 放到一个NSOperationQueue中才会异步执行操作
    // 如果有多个任务 就会开辟子线程去执行
//    [_operation start];
    
    
//     [self createOperationQueue];
    
//    _operation = [[MyOperation alloc] init];
//    [_operation start];
    
    
    
    /*
      添加到queue中的操作可以通过cancel取消
     */
    self.blockOperation = [NSBlockOperation blockOperationWithBlock:^{
       
        if ([self.blockOperation isCancelled]) {
            NSLog(@"取消了");
            return;
        }
        
        for (int i = 0; i < 10000 && ![self.blockOperation isCancelled]; i ++) {
            NSLog(@"blockOperationRun_%@_%d", [NSThread currentThread], i);
        }
        
        NSLog(@"%@", self.blockOperation);
    }];
    
    self.operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runOperation) object:nil];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperation:self.blockOperation];
    [self.operationQueue addOperation:self.operation];
}

- (IBAction)cancelOperation:(id)sender {
    
    // cancel 已经开始的操作无法取消，而未开始的操作可以取消
//    [_operation cancel];
    
    // 可以cancel掉队列中的所有未开始的操作
//    [self.operationQueue cancelAllOperations];
    
//    [self.operationQueue setSuspended:YES];
    
    [self.blockOperation cancel];
    [self.operation cancel];
    
}

- (void)runOperation {
    
    for (int i = 0; i < 10000 && ![self.operation isCancelled]; i ++) {
        
        NSLog(@"operation_%@_%d_%d", [NSThread currentThread], [NSThread isMainThread], i);
    }
    
    NSLog(@"%@", self.operation);
}

@end
