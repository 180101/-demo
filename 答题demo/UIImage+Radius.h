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
/**
 Create and return a 1x1 point size image with the given color.
 
 @param color  The color.
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color;

/**
 Create and return a pure color image with the given color and size.
 
 @param color  The color.
 @param size   New image's type.
 */
+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
