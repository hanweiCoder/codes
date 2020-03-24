//
//  YTX_MenuSwitchTableViewCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuSwitchTableViewCell.h"
#import "YTX_AddMenuView.h"

@interface YTX_MenuSwitchTableViewCell ()
@property (nonatomic, strong) YTX_AddMenuItem *itemMenu;
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
    if ([data isKindOfClass:[YTX_AddMenuItem class]]) {
        YTX_AddMenuItem *item = (YTX_AddMenuItem *)data;
        [self.ytx_switchControl setOnWithOutValueChangeNot:item.switchIsOn animated:NO];
        self.itemMenu = item;
//        self.ytx_switchTextLabel.font = VALUE(item.attributesDic, TO_INT(Title_Font));
//        self.ytx_switchTextLabel.textColor = VALUE(item.attributesDic, TO_INT(Title_Color));
        self.ytx_switchTextLabel.font = item.titleFont;
        self.ytx_switchTextLabel.textColor = item.titleColor;
        self.ytx_switchTextLabel.text = item.title;
        [self.ytx_switchControl addTarget:self action:@selector(confSetSwitchClick:) forControlEvents:UIControlEventValueChanged];
    }
    
}
- (void)confSetSwitchClick:(JTMaterialSwitch *)theSwitch {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ytx_MenuSwitchAction:withInndex:switchView:)]) {
        [self.delegate ytx_MenuSwitchAction:self.itemMenu withInndex:self.indexP switchView:theSwitch];
    }
}

@end
