//
//  NSArray+Log.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import "NSArray+Log.h"

//#import <AppKit/AppKit.h>


@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale{
    //遍历数组中的所有内容，将内容拼接成新的字符串然后返回
    NSMutableString *strM = [NSMutableString string];
    [strM appendString:@"(\n"];
    for (id obj in self) {
        //必须重写model中的description方法，这里才会显示正确
        //在拼接字符串的时候，appendFormat会调用obj的description方法
        [strM appendFormat:@"\t%@,\n",obj];
    }
    return strM;
}
@end
