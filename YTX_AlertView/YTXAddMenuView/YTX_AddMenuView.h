//
//  YTX_AddMenuView.h
//  YouHui
//
//  Created by 韩微 on 2020/1/15.
//  Copyright © 2020 wwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RowProtocolInitalType) {
    LGXIB,
    LGCODE
};
typedef NS_ENUM(NSInteger, Border) {
    TOP = 0x00000001,
    LEFT = 0x00000002,
    RIGHT = 0x00000004,
    BOTTOM = 0x00000008,
    
    TOP_WITH_MARGIN = 0x00000010,
    BOTTOM_WITH_MARGIN = 0x00000020,
    
    NONE = 0x10000000,
};
#define CARD_PADDING 10.0f
#define PADDING 10.0f;
#define MARGIN 10.0f
@class YTX_AddMenuView;
typedef NS_ENUM(NSUInteger, MenuPointMode) {
    MenuPointModeTop,
    MenuPointModeDown
};
//cell属性
typedef NS_ENUM(NSUInteger, AddMenuProperty) {
    Title_Font,
    Title_Color,
    isHaveSwitch,
    NON_CardLineView
};

@interface YTX_AddMenuItem : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, assign) RowProtocolInitalType initalType;
@property (nonatomic, assign) BOOL switchIsOn;
@property (nonatomic, strong) NSDictionary* attributesDic;
@property (nonatomic, assign) NSInteger unreadCount;//消息未读数

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) BOOL isHaveSwitch;
@property (nonatomic, assign) BOOL none_CardLineView;



/// 自定义item
/// @param title 文本
/// @param iconPath 图标名称
/// @param className cell类名
/// @param initalType 是xib还是code
+ (YTX_AddMenuItem *)createWithTitle:(NSString *)title
                            iconPath:(NSString *)iconPath
                           className:(NSString *)className initalType:(RowProtocolInitalType)initalType switchIsOn:(BOOL)switchIsOn
                              property:(NSDictionary *)propertyDic
                            withUnreadCount:(NSInteger)unreadCount;

@end

/**
 * block回调
 *
 * @param actionMenuSheet YTX_AddMenuView对象自身
 * @param index       被点击按钮标识, 0.1.2.3...
 */
typedef void(^YTXAddMebuActionSheetBlock)(YTX_AddMenuView *actionMenuSheet, NSInteger index,  JTMaterialSwitch * _Nullable switchView);

@interface YTX_AddMenuView : UIView

/// 弹框
/// @param items 弹框的文本数据
/// @param frameTable tableView的坐标
/// @param tableViewColor 列表颜色
/// @param alpha 整个父视图的透明度
/// @param menuPointMode 三角朝向，目前只有上下
/// @param actionSheetBlock 点击事件回调或者switch按钮的回调
+ (void)showAddMenuViewActionSheetWithItemLists:(NSArray *)items withFrame:(CGRect)frameTable
                              withTableBackColor:(UIColor *)tableViewColor
                               withAlpha:(CGFloat)alpha withMenuPointMode:(MenuPointMode)menuPointMode
                         handler:(YTXAddMebuActionSheetBlock)actionSheetBlock;
- (instancetype)initWithItemLists:(NSArray *)items withFrame:(CGRect)frameTable
withTableBackColor:(UIColor *)tableViewColor
                      withAlpha:(CGFloat)alpha
                  withMenuPointMode:(MenuPointMode)menuPointMode
                          handler:(YTXAddMebuActionSheetBlock)actionSheetBlock ;

/**
 * 弹出视图
 */
- (void)show;

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
