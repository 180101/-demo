//
//  AppDelegate.m
//  答题demo
//
//  Created by Jude Leslie on 2019/10/2.
//  Copyright © 2019 Jude Leslie. All rights reserved.
//
#define RGBMAIN    [UIColor colorWithRed:(71 / 255.0) green:(134 / 255.0) blue:(247 / 255.0) alpha:1]//主颜色
#define ResizableImageDataForMode(image,top,left,bottom,right,mode) [image resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]

#import "AppDelegate.h"
#import "UIImage+Radius.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    if (@available(iOS 13.0, *)) {
        return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    } else {
        // Fallback on earlier versions
        return nil;
    }
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

- (void)applicationDidFinishLaunching:(UIApplication *)application{
//    UINavigationBar *navVC = [[UINavigationController alloc]initWithRootViewController:self.window.rootViewController];;
//    self.window.rootViewController
    /*设置主控制器*/
//    [self mainTabBarController];
    UIViewController *pro = self.window.rootViewController;
    
    self.window = [[UIWindow alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window setRootViewController:pro];
    [self.window makeKeyAndVisible];
    [self setUpNavigationBarAppearance];
}

- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        UIColor *bgCorlor = RGBMAIN;
        UIImage *barBgImage = [UIImage imageWithColor:bgCorlor];
        backgroundImage = ResizableImageDataForMode(barBgImage, 0, 0, 1, 0, UIImageResizingModeStretch);
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:17],
                           NSForegroundColorAttributeName: [UIColor whiteColor],
                           };
    }
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

/** 禁止屏幕旋转 */
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate{
    return NO;
}
 
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
