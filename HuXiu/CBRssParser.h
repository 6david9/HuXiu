//
//  CBRssParser.h
//  HuXiu
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBRssParser;
@protocol CBRssParserDelegate <NSObject>

@required
- (void)CBRssParser:(CBRssParser *)parser didParseWithResult:(id)result;

@end



@interface CBRssParser : NSObject

@property (strong, readonly, nonatomic) NSString *rssFile;
@property (weak, nonatomic) id delegate;

- (id)initWithRssFile:(NSString *)rssFile;
- (void)parse;

@end
