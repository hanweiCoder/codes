//
//  YTXAddMenuItem.h
//  YTXMenu
//
//  Created by 韩微 on 2019/2/22.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RowProtocolInitalType) {
    LGXIB,
    LGCODE
};

@interface YTXAddMenuItem : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, assign) RowProtocolInitalType initalType;


/// 自定义item
/// @param title 文本
/// @param iconPath 图标名称
/// @param className cell类名
/// @param initalType 是xib还是code
+ (YTXAddMenuItem *)createWithTitle:(NSString *)title iconPath:(NSString *)iconPath className:(NSString *)className initalType:(RowProtocolInitalType)initalType;

@end

NS_ASSUME_NONNULL_END
