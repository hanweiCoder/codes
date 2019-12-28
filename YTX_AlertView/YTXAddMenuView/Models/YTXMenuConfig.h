//
//  YTXMenuConfig.h
//  YTXMenu
//
//  Created by 韩微 on 2019/2/22.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
数据源来自哪个模块，可以定义，主要确定数据源
 (通讯录、聊天、会控...)

- MenuFromAddress:  通讯录
- MenuFromChat:聊天
*/
typedef NS_ENUM(NSUInteger, MenuFromRouteMode) {
    MenuFromAddress,
    MenuFromChat,
    MenuFromConferenceMemberList,
};
@interface YTXMenuConfig : NSObject

@property (nonatomic, strong) NSArray *addMenuItems;

+ (YTXMenuConfig *)sharedConfig;
/// 数据源来自哪个模块
@property (nonatomic, assign) MenuFromRouteMode fromRoute;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
