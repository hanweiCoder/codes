//
//  YTX_AlertViewController.h
//  YTX_AlertView
//
//  Created by 韩微 on 2019/12/28.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YTX_Action : NSObject

@property (nonatomic, readonly, copy) NSString            *title;
@property (nonatomic, readonly, copy) dispatch_block_t    action;

+ (YTX_Action *)actionWithTitle:(NSString *)title action:(dispatch_block_t)action;
- (id)initWithTitle:(NSString *)title action:(dispatch_block_t)action;

@end

@interface YTX_AlertViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL isSelect;

/// 初始化方法，传入文本和默认的布尔值
/// @param title 标题
/// @param selected 选择项的初始值
/// @param message 副标题
- (id)initWithTitle:(NSString *)title selected:(BOOL)selected message:(NSString *)message;

- (void)addAction:(YTX_Action *)action;

//- (void)show;

/// alert展示方法
/// @param fromViewController 在哪个控制器下弹出
/// @param flag 是否动画
/// @param completion 回调
- (void)presentFromViewController:(UIViewController *_Nullable)fromViewController animated:(BOOL)flag completion:(void (^_Nullable)(void))completion;

- (void)dismissWithAnimation:(BOOL)flag completion:(void (^_Nullable)(void))completion;


@end


NS_ASSUME_NONNULL_END
