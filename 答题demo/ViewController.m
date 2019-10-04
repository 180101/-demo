//
//  ViewController.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import "ViewController.h"
#import "ZDquestionModel.h"
#import "UIImage+Radius.h"


#define kSideBtnRate (90.0/414.0) //提示按钮的比例
#define kCenterSize (200.0/414.0 * KScrnW) //中间图片的大小
#define kAnsMargin 10 //答案按钮的间距
#define kColNum 7 //每行显示7个答案
#define kAnsSize ((KScrnW - 2 * kAnsMargin) / kColNum - kAnsMargin) //答案大小
#define KScrnH [[UIScreen mainScreen] bounds].size.height
#define KScrnW [[UIScreen mainScreen] bounds].size.width


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *centerBtn;//中间大图
@property (strong, nonatomic) UIButton *maskBtn;//蒙版
@property (strong, nonatomic) NSArray *questsArr;//题目列表
@property (assign, nonatomic) int qIndex;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;//下一题
@property (strong, nonatomic) UIView *ansView;
@property (strong, nonatomic) UIView *optView;
@property (assign, nonatomic) BOOL isFull;
@end

@implementation ViewController
- (NSArray *)questsArr{
    if (!_questsArr) {
        _questsArr = [ZDquestionModel getArrFromPlist];
    }
    return  _questsArr;
}

/** 修改状态栏 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//** 中间大图 */
//- (UIButton *)centerBtn{
//    if (!_centerBtn) {
//        CGFloat btnX = (KScrnW - kCenterSize) * 0.5;
//        CGFloat btnY = self.titleLabel.frame.origin.y + self.titleLabel.bounds.size.height + kBtnMargin * 1.50;
//        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, kCenterSize, kCenterSize)];
//        [self.view addSubview:_centerBtn];
//    }
//    return _maskBtn;
//}

//** 蒙版 */
- (UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
        _maskBtn.backgroundColor = [UIColor blackColor];
        _maskBtn.alpha = 0.0;
        [_maskBtn addTarget:self action:@selector(bigImgBtn) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_maskBtn];
    }
    return _maskBtn;
}

/** 答案视图 */
- (UIView *)ansView{
    if (!_ansView) {
        CGFloat ansViewY = self.titleLabel.frame.origin.y + self.titleLabel.bounds.size.height + kAnsMargin * 3 + kCenterSize;
        _ansView = [[UIView alloc] initWithFrame:CGRectMake(0, ansViewY, KScrnW, kAnsSize)];
        [self.view addSubview:_ansView];
    }
    return _ansView;
}

/** 备选选项视图 */
- (UIView *)optView{
    if (!_optView) {
        CGFloat optViewY = self.ansView.frame.origin.y + kAnsSize + kAnsMargin * 1.5;
        CGFloat optViewH = KScrnH - optViewY - self.view.safeAreaInsets.bottom;
        _optView = [[UIView alloc] initWithFrame:CGRectMake(0, optViewY, KScrnW, optViewH)];
        [self.view addSubview:_optView];
    }
    return _optView;
}

/** 放大图片 */
- (IBAction)bigImgBtn{
    //1.增加蒙版
    if (self.maskBtn.alpha == 0.0) {
        //2.将图片移动导视图的顶层
        [self.view bringSubviewToFront:self.centerBtn];
        //3.动画放大图片
        [UIView animateWithDuration:0.5 animations:^{
            self.centerBtn.transform = CGAffineTransformScale(self.centerBtn.transform, 2.0, 2.0);
            self.maskBtn.alpha = 0.5;
        }];
    }else{
        //图片已经放大
        [UIView animateWithDuration:0.5 animations:^{
            self.centerBtn.transform = CGAffineTransformScale(self.centerBtn.transform, 0.5, 0.5);
            self.maskBtn.alpha = 0.0;
        } completion:^(BOOL finished){
//            [self.matteBtn removeFromSuperview];
        }];
    }
}

- (IBAction)tips {
}


- (IBAction)help {
}

/** 下一题 */
- (IBAction)nextQuest {
    //1、题目索引递增
    self.qIndex++;
    self.isFull = NO;
    if (self.qIndex >= self.questsArr.count) {
        NSLog(@"-=-=-通关了-=-=-");
        return;
    }
    //2、取出索引对应的题目模型
    ZDquestionModel *qModel = self.questsArr[self.qIndex];
    //3、设置基本信息
    [self createAnsInfo:qModel];
    
    //4、创建答案按钮
    [self createAnsBtns:qModel];
    
    //5、创建备选答案按钮
    [self createOptBtns:qModel];
}

/** 设置基本信息 */
- (void)createAnsInfo:(ZDquestionModel *)qModel {
    self.noLabel.text = [NSString stringWithFormat:@"%d/%lu",self.qIndex + 1,self.questsArr.count];
    self.titleLabel.text = qModel.title;
    [self.centerBtn setImage:qModel.image forState:UIControlStateNormal];
    //最后一题不能点
    self.nextButton.enabled = (self.qIndex != self.questsArr.count - 1);
    //先删除上一题的所有答案
    for (UIButton *btn in self.ansView.subviews) {
//        if (btn.tag == 10086||btn.tag == 10010) {
            [btn removeFromSuperview];
//        }
    }
}

/** 创建答案按钮 */
- (void)createAnsBtns:(ZDquestionModel *)qModel {
    int ansNum = (int)qModel.answer.length;
//    if (self.ansView.subviews.count != ansNum) {
        //答案的字数就是按钮的个数
        int btnCount = (int)qModel.answer.length;
        NSLog(@"-----btnCount = %d",btnCount);
        //计算第一个按钮的起始位置
        CGFloat fstAnsX = (KScrnW - ansNum * kAnsSize - (ansNum - 1) * kAnsMargin) * 0.5;
        for (int i = 0; i < btnCount; i++) {
            //计算每个按钮的起始位置
            CGFloat ansBtnX = fstAnsX + i * (kAnsSize + kAnsMargin);
            UIButton *ansBtn = [[UIButton alloc]initWithFrame:CGRectMake(ansBtnX, 0, kAnsSize, kAnsSize)];
            //设置背景图片
            UIImage *btnImg = [UIImage imageNamed:@"btn_answer"];
            btnImg = [UIImage createRoundedRectImage:btnImg size:btnImg.size radius:6.0];
            
            UIImage *highlightedImg = [UIImage imageNamed:@"btn_answer_highlighted"];
            highlightedImg = [UIImage createRoundedRectImage:highlightedImg size:highlightedImg.size radius:6.0];
            [ansBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
            [ansBtn setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
            
//            ansBtn.tag = 10086;
            [ansBtn setTitle:nil forState:UIControlStateNormal];
            [ansBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //添加监听方法
            [ansBtn addTarget:self action:@selector(ansClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.ansView addSubview:ansBtn];
        }
//    }
}

/** 创建备选答案按钮 */
- (void)createOptBtns: (ZDquestionModel *)qModel {
    //判断界面未刷新的时候option按钮的个数（上一题），如果不等于新一题qModel.options.count，删除原有按钮，重新创建
    if (self.optView.subviews.count != qModel.options.count) {
        CGFloat fstOptX = kAnsMargin * 1.5;
        for (int i = 0; i < qModel.options.count; i++) {
            int rowN = i / kColNum;//行数
            int colN = i % kColNum;//列数
            CGFloat optBtnX = fstOptX + colN * (kAnsSize + kAnsMargin);
            CGFloat optBtnY = rowN * (kAnsSize + kAnsMargin);
            UIButton *optBtn = [[UIButton alloc]initWithFrame:CGRectMake(optBtnX, optBtnY, kAnsSize, kAnsSize)];
            //设置背景图片
            UIImage *btnImg = [UIImage imageNamed:@"btn_option"];
            btnImg = [UIImage createRoundedRectImage:btnImg size:btnImg.size radius:6.0];
            
            UIImage *highlightedImg = [UIImage imageNamed:@"btn_option_highlighted"];
            highlightedImg = [UIImage createRoundedRectImage:highlightedImg size:highlightedImg.size radius:6.0];
            [optBtn setBackgroundImage:btnImg forState:UIControlStateNormal];
            [optBtn setBackgroundImage:highlightedImg forState:UIControlStateHighlighted];
            //设置答案内容
            [optBtn setTitle:qModel.options[i] forState:UIControlStateNormal];
            [optBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
//            optBtn.tag = 10010;
            [optBtn addTarget:self action:@selector(optClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.optView addSubview:optBtn];
            
        }
    }
    //设置按钮标题，遍历optView，依次给出每个按钮的标题
    int i = 0;
    for (UIButton *btn in self.optView.subviews) {
        [btn setTitle:qModel.options[i++] forState:UIControlStateNormal];
        //点击下一题,恢复所有隐藏的备选按钮
        btn.hidden = NO;
    }
}

/** 答案按钮点击事件 */
- (void)ansClick: (UIButton *)sender {
    NSLog(@"===%@",sender.currentTitle);
    //1、判断是否有文字，如果没有直接返回
    if (sender.currentTitle.length != 0) {
        //2、如果有文字
        for (UIButton *optBtn in self.optView.subviews) {
            //找到optView中所有被隐藏的文字里，文字和答案一致的那个
            if ([optBtn.currentTitle isEqualToString:sender.currentTitle] && optBtn.isHidden) {
                //#1清空ansClick中的文字
                [sender setTitle:nil forState:UIControlStateNormal];
                //#2将opt按钮的隐藏恢复
                optBtn.hidden = NO;
                break;
            }
        }
    }
    //将所有答案按钮设为黑色
    for (UIButton *btn in self.ansView.subviews) {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    self.isFull = NO;
    return;
    
}

/** 备选按钮点击事件 */
- (void)optClick: (UIButton *)sender {
    if (!self.isFull) {
        NSLog(@"---%@",sender.currentTitle);
        //1、把optView中的文字，填充到ansView
        //先找到ansView中第一个文字为空的按钮
        for (UIButton *btn in self.ansView.subviews) {
            if (btn.currentTitle.length == 0) {
                //显示答案文字
                [btn setTitle:sender.currentTitle forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                break;
            }
        }
        //2、将optClick按钮隐藏
        sender.hidden = YES;
        //3、填充完后，判断胜负
        self.isFull = YES;
        NSMutableString *strM = [NSMutableString string];
        for (UIButton *btn in self.ansView.subviews) {
            if (btn.currentTitle.length == 0) {
                //没有填满
                self.isFull = NO;
                break;
            }else{
                [strM appendString:btn.currentTitle];
            }
        }
        if (self.isFull) {
            //用户选择的文字和当前题目的答案进行对对比
            ZDquestionModel *qModel = self.questsArr[self.qIndex];
            if ([qModel.answer isEqualToString:strM]) {
                NSLog(@"答对了");
                //答案改为蓝色
                for (UIButton *btn in self.ansView.subviews) {
                    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
                //跳到下一题
                if (self.qIndex + 1 >= self.questsArr.count) {
                    NSLog(@"-=-=-通关了-=-=-");
                    return;
                }else{
                    [self performSelector:@selector(nextQuest) withObject:nil afterDelay:0.5];
                }
            }else{
                NSLog(@"答错了");
                //答案改为红色
                for (UIButton *btn in self.ansView.subviews) {
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
            }
        }
    }
    return;
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
