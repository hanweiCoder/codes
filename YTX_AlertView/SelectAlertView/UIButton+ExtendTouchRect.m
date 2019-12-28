//
//  UIButton+ExtendTouchRect.m
//  YTX_AlertView
//
//  Created by 韩微 on 2019/12/28.
//  Copyright © 2019 韩微. All rights reserved.
//

#import "UIButton+ExtendTouchRect.h"
#import "NSObject+AOP.h"

#import <objc/runtime.h>

@implementation UIButton (ExtendTouchRect)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIButton aop_ExchangeInstanceSelector:@selector(pointInside:withEvent:) swizzledSelector:@selector(imp_pointInside:withEvent:) class:[UIButton class]];
    });
}

- (BOOL)imp_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchExtendInset, UIEdgeInsetsZero) || self.hidden ||
        ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled)) {
        return [self imp_pointInside:point withEvent:event]; // original implementation
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchExtendInset);
    hitFrame.size.width = MAX(hitFrame.size.width, 0); // don't allow negative sizes
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    return CGRectContainsPoint(hitFrame, point);
}
static char touchExtendInsetKey;
- (void)setTouchExtendInset:(UIEdgeInsets)touchExtendInset {
    objc_setAssociatedObject(self, &touchExtendInsetKey, [NSValue valueWithUIEdgeInsets:touchExtendInset],
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)touchExtendInset {
    return [objc_getAssociatedObject(self, &touchExtendInsetKey) UIEdgeInsetsValue];
}
@end
