//
//  UILabel+Collapse.m
//  UILabelExpandAll
//
//  Created by HE Jianfeng on 2017/3/28.
//  Copyright © 2017年 hjfrun. All rights reserved.
//

#import "UILabel+Collapse.h"
#import <objc/message.h>

@implementation UILabel (Collapse)

- (BOOL)expanded
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setExpanded:(BOOL)expanded
{
    objc_setAssociatedObject(self, @selector(expanded), @(expanded), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
