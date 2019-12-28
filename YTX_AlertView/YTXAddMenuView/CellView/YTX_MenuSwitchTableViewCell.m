//
//  YTX_MenuSwitchTableViewCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuSwitchTableViewCell.h"
#import "YTXAddMenuItem.h"

@interface YTX_MenuSwitchTableViewCell ()
@property (nonatomic, strong) YTXAddMenuItem *itemMenu;
@end

@implementation YTX_MenuSwitchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(id)data {
    if ([data isKindOfClass:[YTXAddMenuItem class]]) {
        YTXAddMenuItem *item = (YTXAddMenuItem *)data;
        self.itemMenu = item;
        self.ytx_switchTextLabel.text = item.title;
        [self.ytx_switchControl addTarget:self action:@selector(confSetSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    
}
- (void)confSetSwitchClick:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ytx_MenuSwitchAction:withInndex:)]) {
        [self.delegate ytx_MenuSwitchAction:self.itemMenu withInndex:self.indexP];
    }
}

@end
