//
//  YTX_MenuTableViewProxy.h
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTX_MemuBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^YTXConfigBlock)(YTX_MemuBaseCell *cell, id cellData, NSIndexPath *indexPath);
typedef void(^YTXActionBlock)(YTX_MemuBaseCell *cell, id cellData, NSIndexPath *indexPath);

@interface YTX_MenuTableViewProxy : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *reuseIdentifier;
@property (copy) YTXConfigBlock cellConfigBlock;
@property (copy) YTXActionBlock cellActionBlock;
@property (nonatomic, strong) NSArray *dataArray;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
                          configuration:(YTXConfigBlock)cBlock
                                 action:(YTXActionBlock)aBlock NS_DESIGNATED_INITIALIZER;


@end

NS_ASSUME_NONNULL_END
