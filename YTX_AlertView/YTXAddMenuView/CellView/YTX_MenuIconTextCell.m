//
//  YTX_MenuIconTextCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MenuIconTextCell.h"
#import "YTX_AddMenuView.h"
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
        self.borders = NONE;
        self.textIconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.textIconImageView];
        self.textNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.textNameLabel];
        //        self.textNameLabel.textAlignment = NSTextAlignmentCenter;
        self.textNameLabel.font = [UIFont systemFontOfSize:16];
        self.textNameLabel.textColor = [UIColor whiteColor];
        self.unreadImage = [[UIImageView alloc] init];
        self.unreadImage.hidden = YES;
        self.unreadImage.layer.masksToBounds = YES;
        self.unreadImage.layer.cornerRadius = 5;
        self.unreadImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.unreadImage];
        
        [self.textIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(19);
            make.size.mas_equalTo(CGSizeMake(16, 17));
        }];
        
        [self.textNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.textIconImageView.mas_right).offset(13);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(self.textIconImageView.mas_height);
        }];
        [self.unreadImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textIconImageView.mas_right).offset(42);
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.top.equalTo(self).offset(10);
        }];
        
//        if ([YTXMenuConfig sharedConfig].fromRoute == MenuFromConferenceHomePage) {
//            self.textNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
//        }
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(id)data {
    if ([data isKindOfClass:[YTX_AddMenuItem class]]) {
        YTX_AddMenuItem *item = (YTX_AddMenuItem *)data;
        
//        self.textNameLabel.font = VALUE(item.attributesDic, TO_INT(Title_Font));
//        self.textNameLabel.textColor = VALUE(item.attributesDic, TO_INT(Title_Color));
        self.textNameLabel.font = item.titleFont;
        self.textNameLabel.textColor = item.titleColor;
        self.textNameLabel.text = item.title;
        self.unreadImage.hidden = item.unreadCount > 0?NO:YES;
        self.textIconImageView.image = [UIImage imageNamed:item.iconPath];
    }
    
}
@end
