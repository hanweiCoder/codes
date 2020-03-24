//
//  YTX_ActionSheetCell.m
//  YouHui
//
//  Created by 韩微 on 2019/12/24.
//  Copyright © 2019 wwl. All rights reserved.
//

#import "YTX_ActionSheetCell.h"
#import <Masonry/Masonry.h>
@implementation YTX_ActionBaseBtn
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateHighlighted];
                
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height *0.7;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height - titleY;
    return CGRectMake(titleX, titleY-5, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = CGRectGetWidth(contentRect);
    CGFloat imageH = contentRect.size.height * 0.7;
    return CGRectMake(0, 5, imageW, imageH);
}

@end

@implementation YTX_ActionSheetCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

#pragma mark - Private

- (void)commonInit {
    [self setupSelectView];
}
- (void)setupSelectView {
    
    self.selectBtn = [[YTX_ActionBaseBtn alloc] init];
    [self addSubview:self.selectBtn];
    [self.selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
   
}

- (void)setTitleLabelStr:(NSString *)titleLabelStr {
    _titleLabelStr = titleLabelStr;
}
- (void)setIconPath:(NSString *)iconPath {
    _iconPath = iconPath;
}
- (void)setIconSelectPath:(NSString *)iconSelectPath {
    _iconSelectPath = iconSelectPath;
}
- (void)configWithData:(NSIndexPath *)indexPath {
    
    [self.selectBtn setTitle:_titleLabelStr forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:self.iconPath] forState:UIControlStateNormal];
    if (!KCNSSTRING_ISEMPTY(self.iconSelectPath)) {
        [self.selectBtn setImage:[UIImage imageNamed:self.iconSelectPath] forState:UIControlStateHighlighted];
    }
     
}
#pragma mark - Custom Accessor

- (void)selectBtnAction:(YTX_ActionBaseBtn *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(filterMaterialView:didScrollToIndex:)]) {
        [self.delegate filterMaterialView:btn didScrollToIndex:btn.tag];
    }
}


@end
