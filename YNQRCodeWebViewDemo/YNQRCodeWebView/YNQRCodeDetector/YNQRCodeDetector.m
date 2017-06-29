//
//  YNQRCodeDetector.m
//  bakana
//
//  Created by 郑一楠 on 2017/6/28.
//  Copyright © 2017年 ENeat. All rights reserved.
//

#import "YNQRCodeDetector.h"

@implementation YNQRCodeDetector

+ (CIQRCodeFeature *)yn_detectQRCodeWithImage:(UIImage *)image {
    // 1. 创建上下文
    CIContext *context = [[CIContext alloc] init];
    
    // 2. 创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    // 3. 识别图片获取图片特征
    CIImage *imageCI = [[CIImage alloc] initWithImage:image];
    NSArray<CIFeature *> *features = [detector featuresInImage:imageCI];
    CIQRCodeFeature *codeF = (CIQRCodeFeature *)features.firstObject;
    
    return codeF;
}

@end
