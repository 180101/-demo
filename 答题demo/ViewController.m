//
//  ViewController.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;

@end

@implementation ViewController
/** 修改状态栏 */

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)bigImgBtn {
    //1.增加蒙版
    UIButton *matteBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    matteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [matteBtn addTarget:self action:@selector(clickMatte:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:matteBtn];
    //2.将图片移动导视图的顶层
    [self.view bringSubviewToFront:self.centerBtn];
    //3.动画放大图片
    [UIView animateWithDuration:0.5 animations:^{
        self.centerBtn.transform = CGAffineTransformScale(self.centerBtn.transform, 2.0, 2.0);
    }];
    
}
-(void)clickMatte:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.centerBtn.transform = CGAffineTransformScale(self.centerBtn.transform, 0.5, 0.5);
    } completion:^(BOOL finished){
        [sender removeFromSuperview];
    }];
}

@end
