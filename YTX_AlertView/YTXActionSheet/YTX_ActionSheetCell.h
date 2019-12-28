//
//  YTX_ActionSheetCell.h
//  YouHui
//
//  Created by 韩微 on 2019/12/24.
//  Copyright © 2019 wwl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YTX_ActionSheetCell;
@class YTX_ActionBaseBtn;

@interface YTX_ActionBaseBtn : UIButton

@end

@protocol YTX_ActionSheetCollectionViewCellDelegate <NSObject>

- (void)filterMaterialView:(YTX_ActionBaseBtn *)filterBtnView didScrollToIndex:(NSUInteger)index;

@end
@interface YTX_ActionSheetCell : UICollectionViewCell
@property (nonatomic, weak) id <YTX_ActionSheetCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) YTX_ActionBaseBtn *selectBtn;
@property (nonatomic, strong) NSString *titleLabelStr;
@property (nonatomic, strong) NSString *iconPath;
@property (nonatomic, strong) NSString *iconSelectPath;
- (void)configWithData:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
