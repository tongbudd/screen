//
//  ViewController.m
//  整理屏幕截屏并保存相册
//
//  Created by 周天雨 on 16/4/7.
//  Copyright © 2016年 周天雨. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (IBAction)fullScreenshots:(id)sender;//全屏截图，包括window
- (IBAction)currentView:(id)sender;//currentView 当前的view

- (IBAction)currentView_set:(id)sender;//currentView 当前的view指定范围

- (IBAction)ceshi:(id)sender; //截屏--包括window,处理后清晰

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//全屏截图，包括window
- (IBAction)fullScreenshots:(id)sender {
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    [self AlertView];//保存后弹框提示
}
//currentView 当前的view
- (IBAction)currentView:(id)sender {
    UIGraphicsBeginImageContext(self.view.bounds.size); //currentView 当前的view
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);  //保存到相册中
    
    [self AlertView]; //保存后弹框提示
}
//currentView 当前的view指定范围  截取自定义的大小
- (IBAction)currentView_set:(id)sender {
    
    UIGraphicsBeginImageContext(CGSizeMake(320, 300)); //currentView 当前的view
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
     
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);  //保存到相册中
    
    [self AlertView];//保存后弹框提示
}


//截屏--包括window,处理后清晰
- (IBAction)ceshi:(id)sender {
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContextWithOptions(screenWindow.frame.size, NO, 0.0); // no ritina
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        
        if(window == screenWindow)
        {
            break;
        }else{
            [window.layer renderInContext:context];
        }
    }
    
     if ([screenWindow respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [screenWindow drawViewHierarchyInRect:screenWindow.bounds afterScreenUpdates:YES];
    } else {
        [screenWindow.layer renderInContext:context];
    }
    CGContextRestoreGState(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    screenWindow.layer.contents = nil;
    UIGraphicsEndImageContext();
    
    float iOSVersion = [UIDevice currentDevice].systemVersion.floatValue;
    if(iOSVersion < 8.0)
    {
        image = [self rotateUIInterfaceOrientationImage:image];
    }
    
    UIGraphicsEndImageContext();
    
    
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);  //保存到相册中
    
    [self AlertView];//保存后弹框提示
}

-(UIImage *)rotateUIInterfaceOrientationImage:(UIImage *)image{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    switch (orientation) {
        case UIInterfaceOrientationLandscapeRight:
        {
             NSLog(@"右");
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:
        {
            NSLog(@"左");
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationRight];
        }
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            NSLog(@"上");
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationDown];
        }
            break;
        case UIInterfaceOrientationPortrait:
        {
            NSLog(@"下");
            image = [UIImage imageWithCGImage:image.CGImage scale:1 orientation:UIImageOrientationUp];
        }
            break;
        case UIInterfaceOrientationUnknown:
        {
            NSLog(@"不知道");
        }
            break;
            
        default:
            break;
    }
    
    return image;
}

- (void)AlertView{
        UIAlertView  *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"已保存本地相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ] ;
    
        [alert show];
}

//获得屏幕图像
- (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//获得某个范围内的屏幕图像
- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return  theImage;
}
@end
