//
//  YTX_MenuSwitchTableViewCell.h
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MemuBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@class YTX_MenuSwitchTableViewCell;

@protocol YTX_MenuSwitchActionDelegate <NSObject>

- (void)ytx_MenuSwitchAction:(id)cellData withInndex:(NSIndexPath *)indexPath switchView:(JTMaterialSwitch *)switchView;

@end
@interface YTX_MenuSwitchTableViewCell : YTX_MemuBaseCell
@property (nonatomic, assign) id<YTX_MenuSwitchActionDelegate>delegate;
@property (strong, nonatomic) IBOutlet UILabel *ytx_switchTextLabel;
@property (strong, nonatomic) IBOutlet JTMaterialSwitch *ytx_switchControl;
@property (nonatomic, strong) NSIndexPath *indexP;

@end

NS_ASSUME_NONNULL_END
