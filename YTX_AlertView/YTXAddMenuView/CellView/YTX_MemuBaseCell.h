//
//  YTX_MemuBaseCell.h
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YTXMenuConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface YTX_MemuBaseCell : UITableViewCell
- (void)configWithData:(id)data;
@property (nonatomic, assign) NSInteger borders;

@end

NS_ASSUME_NONNULL_END
