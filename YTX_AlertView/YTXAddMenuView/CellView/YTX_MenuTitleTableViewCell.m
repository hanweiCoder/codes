//
//  YTX_MenuTitleTableViewCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuTitleTableViewCell.h"
#import "YTX_AddMenuView.h"

@implementation YTX_MenuTitleTableViewCell

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
//        self.textName.font = VALUE(item.attributesDic, TO_INT(Title_Font));
//        self.textName.textColor = VALUE(item.attributesDic, TO_INT(Title_Color));
        self.textName.font = item.titleFont;
        self.textName.textColor = item.titleColor;
        self.textName.text = item.title;
    }
    
}

@end
