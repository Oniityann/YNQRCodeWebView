//
//  UIView+YNAdd.h
//  ButterballAlarm
//
//  Created by 郑一楠 on 2017/1/21.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YNAdd)

@property (nonatomic) CGFloat yn_left;        ///< Shortcut for frame.origin.x
@property (nonatomic) CGFloat yn_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat yn_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat yn_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat yn_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat yn_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat yn_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat yn_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint yn_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  yn_size;        ///< Shortcut for frame.size.

- (UIView *)yn_viewNamed:(NSString *)name;

@property (copy, nonatomic) NSString *yn_viewName;

@end

NS_ASSUME_NONNULL_END
