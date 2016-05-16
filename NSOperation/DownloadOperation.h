//
//  DownloadOperation.h
//  NSOperation
//
//  Created by zhangdong on 16/5/16.
//  Copyright © 2016年 zhangdong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// 图片下载的协议
@protocol DownloadOperationDelegate <NSObject>
- (void)downloadFinishWithImage:(UIImage *)image;
@end

@interface DownloadOperation : NSOperation

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, weak) id<DownloadOperationDelegate>delegate;
- (id)initWithUrl:(NSString *)url delegate:(id<DownloadOperationDelegate>)delegate;

@end
