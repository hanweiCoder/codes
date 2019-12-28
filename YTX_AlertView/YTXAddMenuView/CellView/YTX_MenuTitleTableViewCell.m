//
//  YTX_MenuTitleTableViewCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuTitleTableViewCell.h"
#import "YTXAddMenuItem.h"

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
    if ([data isKindOfClass:[YTXAddMenuItem class]]) {
        YTXAddMenuItem *item = (YTXAddMenuItem *)data;
        self.textName.text = item.title;
    }
    
}

@end
