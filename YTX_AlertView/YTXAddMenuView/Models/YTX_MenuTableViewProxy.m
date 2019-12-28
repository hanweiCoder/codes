//
//  YTX_MenuTableViewProxy.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuTableViewProxy.h"
#import "YTXAddMenuItem.h"
#import "YTX_MemuBaseCell.h"

#define     RGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

@implementation YTX_MenuTableViewProxy

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier configuration:(YTXConfigBlock)cBlock action:(YTXActionBlock)aBlock {
    if (self = [super init]) {
        _reuseIdentifier = reuseIdentifier;
        _cellConfigBlock = cBlock;
        _cellActionBlock = aBlock;
    }
    return self;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.cellActionBlock) {
        self.cellActionBlock([tableView cellForRowAtIndexPath:indexPath], self.dataArray[indexPath.row], indexPath);
    }
}

#pragma mark tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YTXAddMenuItem *item = self.dataArray[indexPath.row];
    YTX_MemuBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:item.className forIndexPath:indexPath];
    if (!cell) {
        cell = [[YTX_MemuBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.className];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [self colorBlackForAddMenu];
    if (self.cellConfigBlock) self.cellConfigBlock(cell, self.dataArray[indexPath.row], indexPath);
    return cell;
}

- (UIColor *)colorBlackForAddMenu {
    return RGBAColor(71, 70, 73, 1.0);
}
@end
