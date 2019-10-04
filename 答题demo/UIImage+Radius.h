//
//  UIImage+Radius.h
//  答题demo
//
//  Created by Jude Leslie on 2019/10/3.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Radius)
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
@end

NS_ASSUME_NONNULL_END
