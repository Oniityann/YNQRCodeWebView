//
//  YNQRCodeWebView.m
//  YNQRCodeWebViewDemo
//
//  Created by 郑一楠 on 2017/6/29.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "YNQRCodeWebView.h"
#import "YNQRCodeDetector.h"
#import "ShowBigPicController.h"
#import <SafariServices/SafariServices.h>

@interface YNQRCodeWebView () <UIGestureRecognizerDelegate, UIWebViewDelegate, NSURLSessionDelegate>

@end

@implementation YNQRCodeWebView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self basicConfigure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self basicConfigure];
    }
    return self;
}

- (void)basicConfigure {
    self.delegate = self;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWebPic:)];
    longPress.delegate = self;
    [self addGestureRecognizer:longPress];
}

- (void)longPressWebPic:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    CGPoint touchPoint = [recognizer locationInView:self];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", touchPoint.x, touchPoint.y];
    NSString *urlToSave = [self stringByEvaluatingJavaScriptFromString:imgURL];
    
    if (urlToSave.length == 0) {
        return;
    }
    
//    ENLog(@"%@", urlToSave);
    
    [self imageWithUrl:urlToSave];
    
}

- (void)imageWithUrl:(NSString *)imageUrl {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue new]];
        
        NSURLRequest *imgRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0];
        
        NSURLSessionDownloadTask  *task = [session downloadTaskWithRequest:imgRequest completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                return ;
            }
            
            NSData *imageData = [NSData dataWithContentsOfURL:location];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIImage *image = [UIImage imageWithData:imageData];
                
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                
                CIQRCodeFeature *codeF = [YNQRCodeDetector yn_detectQRCodeWithImage:image];
                
                [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [ac addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self savePicture:image];
                }]];
                
                if (codeF.messageString) {
                    
                    [ac addAction:[UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:codeF.messageString]];
                        [[self currentViewController] presentViewController:safariVC animated:YES completion:nil];
                    }]];
                    
                }
                
                [[self currentViewController] presentViewController:ac animated:YES completion:nil];
            });   
        }];
        
        [task resume];
    });
}

- (void)savePicture:(UIImage *)image {
    if (image == nil) {
//        [SVProgressHUD showErrorWithStatus:@"图片还未加载"];
    } else {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo {
    
    if (error) {
        
//        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        
    } else {
        
//        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '95%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    NSString *resurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //    NSLog(@"requestString is %@",requestString);
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSLog(@"image url------%@", imageUrl);
        ShowBigPicController *sb = [[ShowBigPicController alloc] init];
        sb.imageURL = imageUrl;
        [[self currentViewController] presentViewController:sb animated:NO completion:nil];
        
        return NO;
    }
    return YES;
}

- (UIViewController *)currentViewController {
    UIWindow *keyWindow  = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

- (UINavigationController *)currentNavigationController {
    return [self currentViewController].navigationController;
}

@end
