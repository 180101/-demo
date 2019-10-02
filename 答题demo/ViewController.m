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

@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;//中间大图
@property (strong, nonatomic) UIButton *matteBtn;//蒙版
@property (strong, nonatomic) NSArray *questsArr;//题目列表
@property (assign, nonatomic) int qIndex;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;//下一题
@end

@implementation ViewController
- (NSArray *)questsArr{
    if (!_questsArr) {
        _questsArr = [ZDquestionModel getArrFromPlist];
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
/** 放大图片 */
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

/** 下一题 */
- (IBAction)nextQuest {
    //1、题目索引递增
    self.qIndex++;
    //2、取出索引对应的题目模型
    ZDquestionModel *qModel = self.questsArr[self.qIndex];
    //3、设置基本信息
    self.noLabel.text = [NSString stringWithFormat:@"%d/%lu",self.qIndex + 1,self.questsArr.count];
    self.titleLabel.text = qModel.title;
    [self.centerBtn setImage:qModel.image forState:UIControlStateNormal];
    //最后一题不能点
    self.nextButton.enabled = (self.qIndex != self.questsArr.count - 1);
    //4、创建答案按钮
    
    
    //5、创建备选答案按钮
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.qIndex = -1;
    [self nextQuest];
    
//    [self questsArr];
//    for (ZDquestionModel *qModel in self.questsArr) {
//        NSLog(@"%@",qModel);
//    }
    
}
@end
