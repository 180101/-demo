//
//  ZDquestionModel.h
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDquestionModel : NSObject
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, strong) NSArray *option;

/** 用字典实例化对象的成员方法 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/** 用字典实例化对象的类方法,又称为工厂方法 */
+ (instancetype)questionWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
