//
//  EVShareViewController.m
//  EVSDKDemo
//
//  Created by Lcrnice on 2017/7/28.
//  Copyright © 2017年 cloudfocous. All rights reserved.
//

#import "EVShareViewController.h"
#import "CCAlertManager.h"

@interface EVShareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property (weak, nonatomic) IBOutlet UITextField *urlTF;

@end

@implementation EVShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    self.urlTF.text = self.urlString;
    UIImage *QRImage = [EVShareViewController qrImageForString:self.urlString imageSize:100 logoImageSize:100];
    self.QRImageView.image = QRImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (instancetype)instanceVC {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [storyBoard instantiateViewControllerWithIdentifier:@"EVShareViewController"];
}

- (IBAction)onBackgroundTouchDown:(id)sender {
    [self.urlTF resignFirstResponder];
    [self dismiss];
}

- (void)showInViewController:(UIViewController *)parentViewController {
    if (self.parentViewController == parentViewController) {
        return;
    }
    
    [parentViewController addChildViewController:self];
    self.view.alpha = 0.0;
    self.view.frame = parentViewController.view.bounds;
    [parentViewController.view addSubview:self.view];
    
    [self didMoveToParentViewController:parentViewController];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (IBAction)copyURL:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.urlString;
    
    [[CCAlertManager shareInstance] performComfirmTitle:@"已复制" message:nil comfirmTitle:@"ok" WithComfirm:nil];
}

- (IBAction)systemShare:(id)sender {
    NSString *titleText = @"易视云教育互动直播";
    NSURL *URL = [NSURL URLWithString:self.urlString];
    UIActivityViewController *a = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:titleText,URL, nil] applicationActivities:nil];
    [self presentViewController:a animated:true completion:nil];
}

#pragma mark - private methods
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *outPutImage = [filter outputImage];
    return [[self alloc] createNonInterpolatedUIImageFormCIImage:outPutImage withSize:Imagesize];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef); CGImageRelease(bitmapImage);
    
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newPic;
}

@end
