//
//  NSObject+AOP.h
//
//  Created by 韩微 on 2019/12/28.
//  Copyright © 2019 韩微. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AOP)


+(void)aop_ExchangeInstanceSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector class:(Class)categoryClass;

+(void)aop_ExchangeClassSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector class:(Class)categoryClass;
@end
