//
//  YTXAddMenuItem.m
//  YTXMenu
//
//  Created by 韩微 on 2019/2/22.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTXAddMenuItem.h"

@implementation YTXAddMenuItem

+ (YTXAddMenuItem *)createWithTitle:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className initalType:(RowProtocolInitalType)initalType {
    YTXAddMenuItem *item = [[YTXAddMenuItem alloc] init];
    item.className = className;
    item.title = title;
    item.iconPath = iconPath;
    item.initalType = initalType;
    return item;
}

@end
