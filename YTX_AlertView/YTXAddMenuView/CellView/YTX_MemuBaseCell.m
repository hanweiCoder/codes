//
//  YTX_MemuBaseCell.m
//  YTXMenu
//
//  Created by 韩微 on 2019/12/10.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "YTX_MemuBaseCell.h"
#import "YTX_AddMenuView.h"

@implementation YTX_MemuBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configWithData:(id)data {
    
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ((self.borders & TOP) != 0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
    }
    else if ((self.borders & TOP_WITH_MARGIN) != 0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect) + CARD_PADDING, CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - CARD_PADDING, CGRectGetMinY(rect));
    }
    if ((self.borders & BOTTOM) != 0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }
    else if ((self.borders & BOTTOM_WITH_MARGIN) != 0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect) + CARD_PADDING, CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect) - CARD_PADDING, CGRectGetMaxY(rect));
    }
    if ((self.borders & LEFT) != 0) {
        CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    }
    if ((self.borders & RIGHT) != 0) {
        CGContextMoveToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect));
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithHexString:@"#999999"] CGColor] );
    CGContextSetLineWidth(context, 0.5f);
    CGContextStrokePath(context);
}

- (void)setBorders:(NSInteger)borders {
    if (_borders != borders) {
        _borders = borders;
        [self setNeedsDisplay];
    }
}
@end
