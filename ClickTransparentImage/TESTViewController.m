//
//  TESTViewController.m
//  ClickTransparentImage
//
//  Created by TurtleKnight on 12-11-28.
//  Copyright (c) 2012年 LFS. All rights reserved.
//

#import "TESTViewController.h"

@interface TESTViewController ()

@end

@implementation TESTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIImage *image = [UIImage imageNamed:@"bear.png"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    [_imageView setFrame:CGRectMake(100, 100, image.size.width, image.size.height)];
    [self.view addSubview:_imageView];
    [_imageView release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:_imageView];
    //点击测试
    if ([self hasClickedImage:_imageView location:location]) {
        NSLog(@"%@",@"YES");
    }else{
        NSLog(@"%@",@"NO");
    }
}

//获得字节偏移值,w:每行像素数目.RGBA格式.
NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w){
    return y * w * 4 + x * 4 + 3; 
}

//判断点击的是否是UIView的不透明区域
- (BOOL) hasClickedImage:(UIImageView*)imageView location:(CGPoint)location
{
    UIImage *image = imageView.image;
    Byte *bytes = [self getBitmapFromImage:image];
    
    if (!CGRectContainsPoint(imageView.bounds, location))
        return NO;
    else
        return (bytes[alphaOffset(location.x, location.y, image.size.width)] !=0); //0为全透明
}

//获得图片字节数组
-(Byte*)getBitmapFromImage :(UIImage*)image
{
    CGImageRef imageRef = image.CGImage;
    //calloc在分配空间后将值自动置为0
    Byte *bitmapData = calloc(image.size.width * image.size.height * 4,1);

    CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                  CGImageGetWidth(imageRef),
                                                  CGImageGetHeight(imageRef),
                                                  CGImageGetBitsPerComponent(imageRef),
                                                  CGImageGetBytesPerRow(imageRef),
                                                  CGImageGetColorSpace(imageRef),
                                                  CGImageGetBitmapInfo(imageRef)
                                                  );
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    CGContextDrawImage(context, rect, image.CGImage);
    Byte *data = CGBitmapContextGetData(context);
   
//  //基础滤镜效果
//    for (int i=0; i<image.size.width * image.size.height*4; i+=4) {
//        int alpha = data[i+3];//防止运算溢出，data的每个元素只有8位
//        alpha-=100;
//        alpha = MAX(0, MIN(255, alpha));//safe color
//        data[i+3]=alpha;
//    }
//    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
//    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    UIImageView *newImageView = [[UIImageView alloc] initWithImage:newImage];
//    [newImageView setFrame:CGRectMake(100, 300, image.size.width, image.size.height)];
//    [self.view addSubview:newImageView];
//    [newImageView release];
    
     CGContextRelease(context);
    return data;
}


@end
