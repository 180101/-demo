//
//  ViewController.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import "ViewController.h"
#import "ZDquestionModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;//中间大图
@property (strong, nonatomic) UIButton *matteBtn;//蒙版
@property (strong, nonatomic) NSArray *questsArr;//题目列表
@end

@implementation ViewController
- (NSArray *)questsArr{
    if (!_questsArr) {
        NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            [arrM addObject:[ZDquestionModel questionWithDict:dict]];
        }
        _questsArr = arrM;
    }
    return  _questsArr;
}



/** 修改状态栏 */

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(UIButton *)matteBtn{
    if (!_matteBtn) {
        _matteBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
        _matteBtn.backgroundColor = [UIColor blackColor];
        _matteBtn.alpha = 0.0;
        [_matteBtn addTarget:self action:@selector(bigImgBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_matteBtn];
    }
    return _matteBtn;
}

- (IBAction)bigImgBtn{
    //1.增加蒙版
    if (self.matteBtn.alpha == 0.0) {
        //2.将图片移动导视图的顶层
        [self.view bringSubviewToFront:self.centerBtn];
        //3.动画放大图片
        [UIView animateWithDuration:0.5 animations:^{
            self.centerBtn.transform = CGAffineTransformScale(self.centerBtn.transform, 2.0, 2.0);
            self.matteBtn.alpha = 0.5;
        }];
    }else{
        //图片已经放大
        [UIView animateWithDuration:0.5 animations:^{
            self.centerBtn.transform = CGAffineTransformScale(self.centerBtn.transform, 0.5, 0.5);
            self.matteBtn.alpha = 0.0;
        } completion:^(BOOL finished){
//            [self.matteBtn removeFromSuperview];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}
@end
