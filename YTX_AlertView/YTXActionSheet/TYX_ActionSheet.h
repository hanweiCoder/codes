//
//  TYX_ActionSheet.h
//  YouHui
//
//  Created by 韩微 on 2019/12/23.
//  Copyright © 2019 wwl. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYX_ActionSheet;

NS_ASSUME_NONNULL_BEGIN
/**
 * block回调
 *
 * @param actionSheet TYX_ActionSheet对象自身
 * @param index       被点击按钮标识, 0.1.2.3...
 */
typedef void(^YTXActionSheetBlock)(TYX_ActionSheet *actionSheet, NSInteger index);

@interface TYX_ActionSheet : UIView

/**
 * 创建TYX_ActionSheet对象, 弹出的是actionSheet的视图
 *
 * @param title                  提示文本
 * @param cancelButtonTitle      取消按钮文本
 * @param destructiveButtonTitle 删除按钮文本
 * @param otherButtonTitles      其他按钮文本
 * @param actionSheetBlock                  block回调
 *
 */
+ (void)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(YTXActionSheetBlock)actionSheetBlock;

/**
 * 弹出TYX_ActionSheet视图, 弹出的是collectionView的视图
 *
 * @param title                  提示文本
 * @param cancelButtonTitle      取消按钮文本
 * @param itemList 单个item文本
 * @param itemPathList      单个item图标
 *@param itemHiglitPath     单个选中图标
 * @param actionSheetBlock                  block回调
 *
 */
+ (void)showActionSheetWithTitle:(NSString *)title
               cancelButtonTitle:(NSString *)cancelButtonTitle
                        itemList:(NSArray *)itemList
                    itemPathList:(NSArray *)itemPathList
                  itemHiglitPath:(NSArray *)itemHiglitPath
                         handler:(YTXActionSheetBlock)actionSheetBlock;

/**
 * 弹出视图
 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
