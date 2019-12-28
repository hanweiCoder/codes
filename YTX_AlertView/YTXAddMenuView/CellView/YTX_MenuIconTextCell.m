//
//  YTX_MenuIconTextCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuIconTextCell.h"
#import "YTXAddMenuItem.h"
#import <Masonry/Masonry.h>
@interface YTX_MenuIconTextCell ()
@property (nonatomic, strong) UIImageView *textIconImageView;
@property (nonatomic, strong) UILabel *textNameLabel;
@end

@implementation YTX_MenuIconTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.textIconImageView];
        self.textNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.textNameLabel];
//        self.textNameLabel.textAlignment = NSTextAlignmentCenter;
        self.textNameLabel.font = [UIFont systemFontOfSize:16];
        self.textNameLabel.textColor = [UIColor whiteColor];
        
        [self.textIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.textNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.textIconImageView.mas_right).offset(10);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(self.textIconImageView.mas_height);
        }];
        
       }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(id)data {
    if ([data isKindOfClass:[YTXAddMenuItem class]]) {
        YTXAddMenuItem *item = (YTXAddMenuItem *)data;
        self.textNameLabel.text = item.title;
        self.textIconImageView.image = [UIImage imageNamed:item.iconPath];
    }
    
}
@end
