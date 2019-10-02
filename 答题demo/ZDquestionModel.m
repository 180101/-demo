//
//  ZDquestionModel.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZDquestionModel.h"

@interface ZDquestionModel(){
    UIImage *_image;
}

@end

@implementation ZDquestionModel

- (UIImage *)image{
    if (!_image) {
        _image = [UIImage imageNamed:self.icon];
    }
    return _image;
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
//        self.answer = dict[@"answer"];
//        self.icon = dict[@"icon"];
//        self.title = dict[@"title"];
//        self.options = dict[@"options"];
        //采用KVC，允许间接修改对象属性
        [self setValuesForKeysWithDictionary:dict];
        //单个修改:
        //        [self setValue:dict[@"answer"] forKeyPath:@"answer"];
        //第一个参数是字典的数值
        //第二个参数是类的属性
        //要求类的属性必须在字典中存在，可以多不能少！
    }
    return self;
}
+ (instancetype)questionWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
+ (NSArray *)getArrFromPlist{
    NSArray *arr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"questions.plist" ofType:nil]];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        [arrM addObject:[ZDquestionModel questionWithDict:dict]];
    }
    return arrM;
}
//重写description方法，类似Java的toString()
- (NSString *)description{
    return [NSString stringWithFormat:@"<%@: %p> {answer:%@,icon:%@,title:%@,options:%@}",[self class],self, self.answer,self.icon,self.title,self.options]; 
}
@end
