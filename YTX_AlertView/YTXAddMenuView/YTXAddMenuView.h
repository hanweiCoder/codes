//
//  YTXAddMenuView.h
//  YTXMenu
//
//  Created by 韩微 on 2019/2/22.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTXAddMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MenuPointMode) {
    MenuPointModeTop,
    MenuPointModeDown
};

@class YTXAddMenuView;

@interface YTXAddMenuView : UIView
//在当前cell上的事件，点击or滑动按钮的action
@property (nonatomic, copy) void (^itemSelectedAction)(YTXAddMenuView *addMenuView, YTXAddMenuItem *item, NSIndexPath *indexPath);
//三角朝向
@property (nonatomic, assign) MenuPointMode menuPointMode;
//视图的坐标
@property (nonatomic, assign) CGRect frameTable;
/**
 *  显示AddMenu
 *
 *  @param view 父View
 */
- (void)showInView:(UIView *)view;

/**
 *  是否正在显示
 */
- (BOOL)isShow;

/**
 *  隐藏
 */
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
