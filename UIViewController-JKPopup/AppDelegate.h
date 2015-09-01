//
//  AppDelegate.h
//  UIViewController-JKPopup
//
//  Created by Jakey on 15/9/1.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) UINavigationController *navgationController;
+(AppDelegate*)APP;
@end

