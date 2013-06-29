//
//  CBRsParser.m
//  HuXiu
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import "CBRSSParser.h"
#import "CBItem.h"

@implementation CBRssParser

- (id)initWithRssFile:(NSString *)rssFile
{
    self = [super init];
    if (self) {
        _rssFile = rssFile;
    }
    return self;
}

- (void)parse
{
    if (self.rssFile == nil)    return;
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        [self parseWithXMLString:self.rssFile];
    });
}

#pragma mark - Private method
- (void)parseWithXMLString:(NSString *)xmlString
{
    NSError *error = nil;
    DDXMLDocument *document = [[DDXMLDocument alloc] initWithXMLString:xmlString options:0 error:&error];
    
    if (error)
    {
        NSLog(@"Failed to create XML document for reason: \n%@", error);
    }
    else
    {
        [self parseWithDocument:document];
    }
}

- (void)parseWithDocument:(DDXMLDocument *)document
{
    NSError *error = nil;
    NSArray *nodes = [document nodesForXPath:@"/rss/channel/item" error:&error];
    
    if (error)
    {
        NSLog(@"Failed to parse XML nodes for resson: \n%@", error);
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < [nodes count]; i++) {
            CBItem *item = parseXMLNodeForItem(nodes[i]);
            [results addObject:item];
        }
        [self notifyTheDelegateWithResult:results];
    }
}

CBItem *parseXMLNodeForItem(DDXMLElement *element)
{
    NSString *desc = [[[element elementsForName:@"description"] lastObject] stringValue];
    NSString *title = [[[element elementsForName:@"title"] lastObject] stringValue];
    NSString *linkString = [[[element elementsForName:@"link"] lastObject] stringValue];
    NSString *pubDate = [[[element elementsForName:@"pubDate"] lastObject] stringValue];
    NSString *shortDesc = parseDescriptionForShortDesc(desc);
    NSURL *imgURL = parseDescriptionForImageURL(desc);
    
    CBItem *item = [[CBItem alloc] init];
    item.title = title;
    item.link = URLFromString(linkString);
    item.shortDesc = shortDesc;
    item.imageURL = imgURL;
    item.timeInterval = parsePubDate(pubDate);
    return item;
}

NSTimeInterval parsePubDate(NSString *pubDate)
{
    return [pubDate localTimeIntervalFromString:pubDate withDateFormat:@"EE, dd MMM yyyy HH:mm:ss zzz"];
}

NSURL* parseDescriptionForImageURL(NSString *desc)
{
    NSString *imgURL = [desc itemForPattern:@"src=(http://[\\w\\d.=?/]+)" captureGroupIndex:1];
    return URLFromString(imgURL);
}

NSString *parseDescriptionForShortDesc(NSString *desc)
{
    NSMutableArray *results = [desc itemsForPattern:@"<div>((\\S|\\s)+?)(</div>)" captureGroupIndex:1];
    [results removeObject:@"<br />"];
    return [results composeString];
}

#pragma mark - Notify the delegate
- (void)notifyTheDelegateWithResult:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate != nil)
        {
            [self.delegate CBRssParser:self didParseWithResult:result];
        }
    });
}

@end
