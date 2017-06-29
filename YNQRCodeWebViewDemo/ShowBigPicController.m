//
//  ShowBigPicController.m
//  bakana
//
//  Created by 郑一楠 on 2017/6/27.
//  Copyright © 2017年 ENeat. All rights reserved.
//

#import "ShowBigPicController.h"
#import "YNQRCodeDetector.h"
#import "UIView+YNAdd.h"
#import <SafariServices/SafariServices.h>

@interface ShowBigPicController () <NSURLSessionDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation ShowBigPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self basicConfigure];
    
    [self mainConfigure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - basic configuration

- (void)basicConfigure {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToFrontPage)];
    [self.view addGestureRecognizer:tap];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.yn_centerY = self.view.frame.size.width * 0.5;
    [self.imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imageLongPress)]];
    [self.scrollView addSubview:self.imageView];
}

- (void)mainConfigure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:self.imageURL];
        
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
                
                CGFloat pictureW = self.view.frame.size.width;
                CGFloat pictureH = pictureW * image.size.height / image.size.width;
                if (pictureH > self.view.frame.size.height) {
                    self.imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
                    self.scrollView.contentSize = CGSizeMake(0, pictureH);
                } else {
                    self.imageView.yn_size = CGSizeMake(pictureW, pictureH);
                    self.imageView.yn_centerY = self.view.frame.size.width * 0.5;
                }
//                [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURL]];
                self.imageView.image = image;
            });
        }];
        
        [task resume];
    });
}

#pragma mark - target / action

- (void)backToFrontPage {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)imageLongPress {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    CIQRCodeFeature *codeF = [YNQRCodeDetector yn_detectQRCodeWithImage:self.imageView.image];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self savePicture];
    }]];
    
    if (codeF.messageString) {
        
        [ac addAction:[UIAlertAction actionWithTitle:@"识别二维码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:codeF.messageString]];
            [self presentViewController:safariVC animated:YES completion:nil];
        }]];
    }
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)savePicture {
    if (self.imageView.image == nil) {
//        [SVProgressHUD showErrorWithStatus:@"图片还未加载"];
    } else {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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

@end
