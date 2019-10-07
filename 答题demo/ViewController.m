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
//#import "ZDWebViewController.h"
#import <WebKit/WebKit.h>

#define RGBMAIN    [UIColor colorWithRed:(71 / 255.0) green:(134 / 255.0) blue:(247 / 255.0) alpha:1]//主颜色
#define kCoinW 90 //金币宽度
#define kTitleH 30 //标题高度
#define kSideW ((KScrnW - kCenterSize) * 0.5 - kAnsMargin * 1.5) //4个按钮的宽度
#define kSideH (kCenterSize * 0.5 - kAnsMargin * 4) //4个按钮的高度
#define kCenterSize (200.0/414.0 * KScrnW) //中间图片的大小
#define kAnsMargin 10 //答案按钮的间距
#define kColNum 7 //每行显示7个答案
#define kAnsSize ((KScrnW - 2 * kAnsMargin) / kColNum - kAnsMargin) //答案大小
#define KScrnH [[UIScreen mainScreen] bounds].size.height
#define KScrnW [[UIScreen mainScreen] bounds].size.width
//判断是否是ipad
#define is_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhoneX，Xs（iPhoneX，iPhoneXs）
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(414, 896), [[UIScreen mainScreen] currentMode].size) && !is_Pad : NO)
//判断iPhoneXsMax
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !is_Pad : NO)
//判断是否是iphonex的所有系列
#define kDevice_Is_iPhoneXAll (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs_Max)
#define KTarbarH  (kDevice_Is_iPhoneXAll ? 44 : 20)
#define kBottom self.view.safeAreaInsets.bottom

@interface ViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scroView;
@property (strong, nonatomic) UIImageView *backView;        //背景视图
@property (strong, nonatomic) UILabel *pageLabel;  //页数文本框
@property (strong, nonatomic) UILabel *titleLabel; //标题文本框
@property (strong, nonatomic) UIButton *scoreBtn;  //金币按钮

@property (strong, nonatomic) UIButton *backBtn;    //返回按钮
@property (strong, nonatomic) WKWebView *webView;   //帮助网页

@property (strong, nonatomic) UIButton *centerBtn;  //中间大图
@property (strong, nonatomic) UIButton *maskBtn;    //蒙版
@property (strong, nonatomic) NSArray *questsArr;   //题目列表
@property (assign, nonatomic) int qIndex;           //第几题

@property (strong, nonatomic) NSMutableArray *fourBtnsM;   //4个按钮
@property (strong, nonatomic) NSArray *btnTextArr;  //4个按钮文字列表
@property (strong, nonatomic) NSArray *iconArr;     //4个按钮图片的列表
@property (strong, nonatomic) NSArray *sideArr;     //4个按钮背景图片的列表，左右各一张

@property (strong, nonatomic) UIView *ansView; //答案视图
@property (strong, nonatomic) UIView *optView; //备选视图
@property (assign, nonatomic) BOOL isFull;     //答案填满
@property (assign, nonatomic) BOOL isGameOver; //游戏通关
@end

@implementation ViewController
# pragma mark - setter & getter

/** 背景视图 */
- (UIImageView *)backView{
    if (!_backView) {
        UIImage *backImg = [UIImage imageNamed:@"bj"];
        _backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KTarbarH, KScrnW, KScrnH - KTarbarH - kBottom)];
        [_backView setImage:backImg];
        _backView.userInteractionEnabled = YES;
        _backView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_backView];
    }
    return _backView;
}
/** 问题列表 */
- (NSArray *)questsArr{
    if (!_questsArr) {
        _questsArr = [ZDquestionModel getArrFromPlist];
    }
    return  _questsArr;
}

/** 金币 */
- (UIButton *)scoreBtn{
    if (!_scoreBtn) {
        CGRect rect = CGRectMake(KScrnW - kCoinW - kAnsMargin * 0.5, KTarbarH + kAnsMargin, kCoinW, kTitleH);
        _scoreBtn = [[UIButton alloc]initWithFrame:rect];
        [_scoreBtn setTitle:@"10000" forState:UIControlStateNormal];
        [_scoreBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [_scoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_scoreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, kTitleH, 0, 0)];
        [_scoreBtn setImage:[UIImage imageNamed:@"coin"] forState:UIControlStateNormal];
        [_scoreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 90 - kTitleH)];
        _scoreBtn.userInteractionEnabled = NO;
        [self.backView addSubview:_scoreBtn];
    }
    return _scoreBtn;
}

/** 页数 */
- (UILabel *)pageLabel{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KTarbarH + kAnsMargin * 2.5, KScrnW, kTitleH)];
        _pageLabel.text = [NSString stringWithFormat:@"%d/%lu",self.qIndex + 1,self.questsArr.count];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.font = [UIFont systemFontOfSize: 20];
        _pageLabel.textColor = [UIColor whiteColor];
        [self.backView addSubview:_pageLabel];
    }
    return _pageLabel;
}


/** 标题 */
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, KTarbarH + kAnsMargin * 2.5 + kTitleH, KScrnW, kTitleH)];
        ZDquestionModel *qModel = self.questsArr[self.qIndex];
        _titleLabel.text = qModel.title;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize: 20];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.backView addSubview:_titleLabel];
    }
    return _titleLabel;
}


/** 中间大图 */
- (UIButton *)centerBtn{
    if (!_centerBtn) {
        CGFloat x = (KScrnW - kCenterSize) * 0.5;
        CGFloat y = KTarbarH + kAnsMargin * 2.5 + kTitleH * 2 + kAnsMargin;
        _centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, kCenterSize, kCenterSize)];
        [_centerBtn setBackgroundImage:[UIImage imageNamed:@"center_img"] forState:UIControlStateNormal];
        [_centerBtn setImage:[UIImage imageNamed:@"movie_ygbh"] forState:UIControlStateNormal];
        [_centerBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
        [_centerBtn addTarget:self action:@selector(bigClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backView addSubview:_centerBtn];
    }
    return _centerBtn;
}

/** 4个按钮 */
- (NSMutableArray *)fourBtnsM{
    if (!_fourBtnsM) {
        for (int i = 0; i < self.btnTextArr.count; i++) {
            CGFloat x = (KScrnW - kSideW) * (i / 2);
            CGFloat y = self.centerBtn.frame.origin.y + kAnsMargin * 2 + kCenterSize * 0.5 * (i % 2);
            UIButton * sideBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, y, kSideW, kSideH)];
            [sideBtn setTitle:self.btnTextArr[i] forState:UIControlStateNormal];
            [sideBtn setBackgroundImage:[UIImage imageNamed:self.sideArr[i / 2]] forState:UIControlStateNormal];
            [sideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [sideBtn setImage:(i == 3 ? nil : [UIImage imageNamed:self.iconArr[i]]) forState:UIControlStateNormal];
            [sideBtn setImageEdgeInsets:UIEdgeInsetsMake(kAnsMargin * 0.5, kAnsMargin * 0.5, kAnsMargin * 0.5, kSideW * (3.0/5.0))];
            sideBtn.tag = i * 1000 + 1086;
            sideBtn.highlighted = (i == 3 && self.qIndex >= 9 ? YES : NO);
            [sideBtn addTarget:self action:@selector(fourClicks:) forControlEvents:UIControlEventTouchUpInside];
            [_fourBtnsM addObject:sideBtn];
            [self.backView addSubview:sideBtn];
        }
    }
    return _fourBtnsM;
}

/** 蒙版 */
- (UIButton *)maskBtn{
    if (!_maskBtn) {
        _maskBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
        _maskBtn.backgroundColor = [UIColor blackColor];
        _maskBtn.alpha = 0.0;
        [_maskBtn addTarget:self action:@selector(bigClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.backView addSubview:_maskBtn];
    }
    return _maskBtn;
}

/** 答案视图 */
- (UIView *)ansView{
    if (!_ansView) {
        CGFloat ansViewY = self.titleLabel.frame.origin.y + kTitleH + kAnsMargin * 3 + kCenterSize;
        _ansView = [[UIView alloc] initWithFrame:CGRectMake(0, ansViewY, KScrnW, kAnsSize)];
        [self.backView addSubview:_ansView];
    }
    return _ansView;
}

/** 备选选项视图 */
- (UIView *)optView{
    if (!_optView) {
        CGFloat optViewY = self.ansView.frame.origin.y + kAnsSize + kAnsMargin * 1.5;
        CGFloat optViewH = KScrnH - optViewY - kBottom;
        _optView = [[UIView alloc] initWithFrame:CGRectMake(0, optViewY, KScrnW, optViewH)];
        [self.backView addSubview:_optView];
    }
    return _optView;
}


/** 网页视图 */
- (WKWebView *)webView{
        if (!_webView) {
            CGFloat webViewH = KScrnH -  kBottom - KTarbarH;
            _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, KScrnW, webViewH)];
            _webView.backgroundColor = [UIColor blackColor];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
            [_webView loadRequest:request];
            [_webView goBack];
            [_webView goForward];
            [_webView reload];
            
            NSLog(@">>>跳转成功<<<");
        }
        return _webView;
}

/** 返回按钮 */
- (UIButton *)backBtn{
    if (!_backBtn) {
//        UIImage *backImg = [UIImage imageWithColor:RGBMAIN];
//        backImg = [UIImage createRoundedRectImage:backImg size:CGSizeMake(kAnsSize, kAnsSize) radius:kAnsSize * 0.5];
        UIImage *backImg = [UIImage imageNamed:@"btn_back"];
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(KScrnW - kAnsMargin - kAnsSize, KScrnH -  kBottom - KTarbarH - kAnsMargin - kAnsSize, kAnsSize, kAnsSize)];
        [_backBtn setImage:backImg forState:UIControlStateNormal];
        _backBtn.adjustsImageSizeForAccessibilityContentSizeCategory = YES;
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:_backBtn];
    }
    return _backBtn;
}
#pragma mark - touchUpInside

- (void)fourClicks:(UIButton *)sender{
    switch (sender.tag) {
        case 1086:
            [self tipClick];
            break;
        case 2086:
            [self helpClick];
            break;
        case 3086:
            [self bigClick];
            break;
        case 4086:
            [self nextQuest];
            break;
        default:
            break;
    }
}
/** 放大图片 */
- (void)bigClick{
    //1.增加蒙版
    if (self.maskBtn.alpha == 0.0) {
        //2.将图片移动导视图的顶层
        [self.backView bringSubviewToFront:self.centerBtn];
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
/** 返回按钮点击事件 */
- (void)backClick:(UIButton *)sender{
    [sender removeFromSuperview];
    [self.webView removeFromSuperview];
    self.webView = nil;
    return;
}
/** 提示按钮点击 */
- (void)tipClick {
    //1、将ansView清空,而且optView全部恢复，等价于每个ansBtn都ansClick
    for (UIButton *btn in self.ansView.subviews) {
        [self ansClick:btn];
    }
    
    //2、选中optView中正确答案的第一个字,然后optClick
    ZDquestionModel *qmodel = self.questsArr[self.qIndex];
    for (UIButton *btn in self.optView.subviews) {
        if ([btn.currentTitle isEqualToString:[qmodel.answer substringToIndex:1]]) {
            [self optClick:btn];
            //减分操作
            [self changeScore: -1000];
            break;
        }
    }
    return;
}
/** 帮助按钮点击 */
- (void)helpClick {
    NSLog(@"正在跳转...");
    [self.webView addSubview:self.backBtn];
    [self.backView addSubview:self.webView];
    //
}

/** 下一题 */
- (void)nextQuest {
    //1、题目索引递增
    //int 和 ul 比较的时候要注意转换为int
    if (self.qIndex + 1 >= (int)self.questsArr.count) {
        NSLog(@"-=-=-题目到底了-=-=-");
        UIButton * nextBtn = [self.fourBtnsM objectAtIndex:3];
        nextBtn.enabled = NO;
        return;
    }
    self.isFull = NO;
    self.qIndex++;
    //2、取出索引对应的题目模型
    ZDquestionModel *qModel = self.questsArr[self.qIndex];
    //3、设置基本信息
    [self createAnsInfo:qModel];
    //4、创建答案按钮
    [self createAnsBtns:qModel];
    //5、创建备选答案按钮
    [self createOptBtns:qModel];
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
                if (self.qIndex + 1 >= (int)self.questsArr.count) {
                    NSLog(@"-=-=-通关了-=-=-");
                    if (!self.isGameOver) {
                        [self changeScore: 500];
                    }
                    self.isGameOver = YES;
                    return;
                }else{
                    //加分操作
                    [self changeScore: 500];
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

//-(void)keyboardWillHide{
/*这个判断也能解决页面不恢复的问题，但是这个方法会引发另一个问题：当页面有多个输入框的时候，在相互切换时，页面会跟随切换抖动，因为键盘在隐藏和显示的时候页面会有一个上下移动的动画，所以造成了在切换输入框时页面抖动的问题.*/
    //    if (@available(iOS 12.0, *)) {
    //        WKWebView *webview = (WKWebView*)self.webV;
    //        for(UIView* v in webview.subviews){
    //            if([v isKindOfClass:NSClassFromString(@"WKScrollView")]){
    //                UIScrollView *scrollView = (UIScrollView*)v;
    //                [scrollView setContentOffset:CGPointMake(0, 0)];
    //            }
    //        }
    //    }
    
//    if (@available(iOS 12.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//}
//- (void)keyboardWillShow{
//    if (@available(iOS 12.0, *)) {
//        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//    }
//}
#pragma mark - private & public
/** 设置基本信息 */
- (void)createAnsInfo:(ZDquestionModel *)qModel {
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%lu",self.qIndex + 1,self.questsArr.count];
    self.titleLabel.text = qModel.title;
    [self.scoreBtn setTitle:self.scoreBtn.currentTitle forState:UIControlStateNormal];
    [self.centerBtn setImage:qModel.image forState:UIControlStateNormal];
    //最后一题不能点
    UIButton *nextBtn = [self.fourBtnsM objectAtIndex:3];
    nextBtn.enabled = (self.qIndex != self.questsArr.count - 1);
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
            [ansBtn setTitle:nil forState:UIControlStateNormal];
            [ansBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //添加监听方法
            [ansBtn addTarget:self action:@selector(ansClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.ansView addSubview:ansBtn];
        }
//    }
}

/** 创建备选选项所有按钮 */
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

- (void)changeScore: (int)score{
    int scoreNum = [self.scoreBtn.currentTitle intValue];
    scoreNum += score;
    if (scoreNum >= 0) {
        [self.scoreBtn setTitle:[NSString stringWithFormat:@"%d",scoreNum] forState:UIControlStateNormal];
    }else if (scoreNum == -500){
        [self.scoreBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    return;
}

/** 修改状态栏 */
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification
//                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification
//                                                   object:nil];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.qIndex = -1;
    self.isGameOver = NO;
    [self.scoreBtn setTitle:@"10000" forState:UIControlStateNormal];
    self.btnTextArr = @[@"提示",@"帮助",@"大图",@"下一题"];
    self.iconArr = @[@"icon_tip",@"icon_help",@"icon_img"];
    self.sideArr = @[@"btn_left",@"btn_right"];
    [self nextQuest];
    self.scroView.delegate = self;
    if ([self.scroView.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scroView.delegate scrollViewDidScroll:self.scroView];
    }
    return;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"滑动完成");
}
@end
