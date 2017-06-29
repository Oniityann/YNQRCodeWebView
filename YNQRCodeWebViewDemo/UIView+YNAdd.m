//
//  UIView+YNAdd.m
//  ButterballAlarm
//
//  Created by 郑一楠 on 2017/1/21.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "UIView+YNAdd.h"
#import <objc/runtime.h>

static const void *YNViewNameKey = @"YNViewName";

@implementation UIView (YNAdd)

- (void)setYn_left:(CGFloat)yn_left {
    CGRect frame = self.frame;
    frame.origin.x = yn_left;
    self.frame = frame;
}

- (CGFloat)yn_left {
    return self.frame.origin.x;
}

- (void)setYn_top:(CGFloat)yn_top {
    CGRect frame = self.frame;
    frame.origin.y = yn_top;
    self.frame = frame;
}

- (CGFloat)yn_top {
    return self.frame.origin.y;
}

- (void)setYn_right:(CGFloat)yn_right {
    CGRect frame = self.frame;
    frame.origin.x = yn_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)yn_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setYn_bottom:(CGFloat)yn_bottom {
    CGRect frame = self.frame;
    frame.origin.y = yn_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)yn_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setYn_width:(CGFloat)yn_width {
    CGRect frame = self.frame;
    frame.size.width = yn_width;
    self.frame = frame;
}

- (CGFloat)yn_width {
    return self.frame.size.width;
}

- (void)setYn_height:(CGFloat)yn_height {
    CGRect frame = self.frame;
    frame.size.height = yn_height;
    self.frame = frame;
}

- (CGFloat)yn_height {
    return self.frame.size.height;
}

- (void)setYn_centerX:(CGFloat)yn_centerX {
    self.center = CGPointMake(yn_centerX, self.center.y);
}

- (CGFloat)yn_centerX {
    return self.center.x;
}

- (void)setYn_centerY:(CGFloat)yn_centerY {
    self.center = CGPointMake(self.center.x, yn_centerY);
}

- (CGFloat)yn_centerY {
    return self.center.y;
}

- (void)setYn_origin:(CGPoint)yn_origin {
    CGRect frame = self.frame;
    frame.origin = yn_origin;
    self.frame = frame;
}

- (CGPoint)yn_origin {
    return self.frame.origin;
}

- (void)setYn_size:(CGSize)yn_size {
    CGRect frame = self.frame;
    frame.size = yn_size;
    self.frame = frame;
}

- (CGSize)yn_size {
    return self.frame.size;
}

- (void)setYn_viewName:(NSString *)yn_viewName {
    objc_setAssociatedObject(self, YNViewNameKey, yn_viewName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)yn_viewName {
    return objc_getAssociatedObject(self, YNViewNameKey);
}

- (UIView *)yn_viewNamed:(NSString *)name {
    
    if (!name) {
        return nil;
    }
    
    return [self viewWithName:name];
}

- (UIView *)viewWithName:(NSString *)aName {
    
    if (!aName) {
        return nil;
    }
    
    if ([self.yn_viewName isEqualToString:aName]) {
        return self;
    }
    
    for (UIView *subview in self.subviews) {
        UIView *theView = [subview yn_viewNamed:aName];
        if (theView) {
            return theView;
            break;
        }
    }
    
    return nil;
}

@end
