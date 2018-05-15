//
//  ThreadViewController.m
//  MultiThread
//
//  Created by Xujiangfei on 2018/5/15.
//  Copyright © 2018年 Xujiangfei. All rights reserved.
//

#import "ThreadViewController.h"
#define kImageUrl @"https://upload-images.jianshu.io/upload_images/270478-ab196e24bf11be78.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/700"

@interface ThreadViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSThread测试";
    // Do any additional setup after loading the view from its nib.
}

//为开辟线程按钮事件
- (IBAction)blockTest:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Hint" message:@"Just For Test" delegate:nil cancelButtonTitle:@"YES" otherButtonTitles: nil];
    [alert show];
}

//开辟新线程按钮时间
- (IBAction)noMultiAction:(id)sender {
    [self loadImage];
}

-(void)loadImage{
    NSURL *imageUrl = [NSURL URLWithString:kImageUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
    [self updateImageData:imageData];
}
-(void)updateImageData:(NSData*)imageData{
    UIImage *image = [UIImage imageWithData:imageData];
    [self performSelectorOnMainThread:@selector(updateImageOnMainThread:) withObject:image waitUntilDone:NO]; //更新UI的部分应该在主线程
}

- (void)updateImageOnMainThread:(UIImage *)image{
    self.showImageView.image = image;
}

- (IBAction)multiAction:(id)sender {
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
