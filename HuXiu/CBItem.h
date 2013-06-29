//
//  CBItem.h
//  HuXiu
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBItem : NSObject

@property (strong, nonatomic) NSString *title;      // 正文标题
@property (strong, nonatomic) NSURL *link;          // 原文链接
@property (strong, nonatomic) NSURL *imageURL;      // 正文中包含的图片，不存在则为 nil
@property (strong, nonatomic) NSString *shortDesc;    // 简短描述
@property (assign, nonatomic) NSTimeInterval timeInterval;  // +0000 时区的 time interval

@end
