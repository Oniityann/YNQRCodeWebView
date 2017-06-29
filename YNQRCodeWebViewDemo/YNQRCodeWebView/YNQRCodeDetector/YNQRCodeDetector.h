//
//  YNQRCodeDetector.h
//  bakana
//
//  Created by 郑一楠 on 2017/6/28.
//  Copyright © 2017年 ENeat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YNQRCodeDetector : NSObject

+ (CIQRCodeFeature *)yn_detectQRCodeWithImage:(UIImage *)image;

@end
