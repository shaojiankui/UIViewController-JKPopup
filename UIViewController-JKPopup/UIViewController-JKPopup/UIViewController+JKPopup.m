//
//  UIViewController+JKPopup.m
//  UIViewController-JKPopup
//
//  Created by Jakey on 15/9/1.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import "UIViewController+JKPopup.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define kPopupModalAnimationDuration 0.35

static const void *kPopupViewController = &kPopupViewController;
static const void *kPopupBackgroundView = &kPopupBackgroundView;
static const void *kPopupParentViewController = &kPopupParentViewController;

static const void *kDissmissCallback = &kDissmissCallback;
//static void * const keypath = (void*)&keypath;
static const void *k_pop_tag = &k_pop_tag;

@implementation UIViewController (JKPopup)
#pragma mark - get or setter
- (UIViewController*)jk_popupViewController {
    return objc_getAssociatedObject(self, kPopupViewController);
}

- (void)setJk_popupViewController:(UIViewController *)jk_popupViewController {
    objc_setAssociatedObject(self, kPopupViewController, jk_popupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView*)jk_popupBackgroundView {
    return objc_getAssociatedObject(self, kPopupBackgroundView);
}
- (void)setJk_popupBackgroundView:(UIView *)jk_popupBackgroundView {
    objc_setAssociatedObject(self, kPopupBackgroundView, jk_popupBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIViewController *)jk_popupParentViewController{
    return objc_getAssociatedObject(self, kPopupParentViewController);
}
-(void)setJk_popupParentViewController:(UIViewController *)jk_popupParentViewController{
    objc_setAssociatedObject(self, kPopupParentViewController, jk_popupParentViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void)setJk_popTag:(NSInteger)popTag{
    NSNumber *number = [[NSNumber alloc]initWithInteger:popTag];
    objc_setAssociatedObject(self, k_pop_tag, number, OBJC_ASSOCIATION_ASSIGN);
}
//get
-(NSInteger)jk_popTag{
    id  o = objc_getAssociatedObject(self, k_pop_tag);
    if (o) {
        return [o integerValue];
    }
    return 0;
}
#pragma mark --- Dismissed
- (void)setJk_popupDismissBlock:(JKPopupDismissBlock)dismissed
{
    objc_setAssociatedObject(self, &kDissmissCallback, dismissed, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (JKPopupDismissBlock)jk_popupDismissBlock
{
    return objc_getAssociatedObject(self, &kDissmissCallback);
}
#pragma mark -- present
- (void)presentJKPopupViewController:(UIViewController*)jk_popupViewController{
    [self presentJKPopupViewController:jk_popupViewController backgroundTouch:NO popTag:1314 dismissed:^(NSInteger jk_popTag) {
        
    }];
}
- (void)presentJKPopupViewController:(UIViewController*)jk_popupViewController
                     backgroundTouch:(BOOL)enable
                           dismissed:(JKPopupDismissBlock)dismissed{
    [self presentJKPopupViewController:jk_popupViewController backgroundTouch:enable popTag:1314 dismissed:dismissed];
}
- (void)presentJKPopupViewController:(UIViewController*)jk_popupViewController
                     backgroundTouch:(BOOL)enable
                              popTag:(NSInteger)popTag
                           dismissed:(JKPopupDismissBlock)dismissed{

    UIView *topView = [self topView];
    if ([topView.subviews containsObject:jk_popupViewController.view]) return;
    [self addChildViewController:jk_popupViewController];
    
    
    
    JKPopupBackgroundView *popupBackgroundView = [[JKPopupBackgroundView alloc] initWithFrame:topView.bounds];
    popupBackgroundView.tag = 123456;
    popupBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    popupBackgroundView.backgroundColor = [UIColor clearColor];
    popupBackgroundView.alpha = 0.5;
    
    [popupBackgroundView touchesBegan:^(CGPoint point) {
        if (enable) {
            [jk_popupViewController dismissJKPopupViewController:nil];
        }
    }];
    
    jk_popupViewController.jk_popupBackgroundView = popupBackgroundView;
    jk_popupViewController.jk_popTag = popTag;
    jk_popupViewController.jk_popupParentViewController  = self;

    self.jk_popupViewController = jk_popupViewController;
    self.jk_popupDismissBlock = [dismissed copy];

    [topView addSubview:jk_popupViewController.jk_popupBackgroundView];
    [self slideView:jk_popupViewController inView:topView isShow:YES];
    
    
}
- (void)dismissJKPopupViewController:(JKPopupDismissBlock)dismissed{
    self.jk_popupDismissBlock = [dismissed copy];
    UIView *topView = [self topView];
    [self slideView:self inView:topView isShow:NO];
 }
#pragma mark Animations
-(void)slideView:(UIViewController*)popupViewController inView:(UIView*)topView isShow:(BOOL)isShow{
    UIView *popupView  =popupViewController.view;
    
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    popupView.layer.shadowOffset = CGSizeMake(5, 5);
    popupView.layer.shadowRadius = 5;
    popupView.layer.shadowOpacity = 0.5;
    popupView.layer.shouldRasterize = YES;
    popupView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;

    
    CGFloat y = (topView.frame.size.height - popupView.frame.size.height) / 2;
    CGFloat x = (topView.frame.size.width - popupView.frame.size.width) / 2;

    if (isShow)
    {
        [topView addSubview:popupView];
        popupView.transform =  CGAffineTransformMakeTranslation(x,topView.frame.size.height);
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            popupView.transform =  CGAffineTransformMakeTranslation(x,y);
            popupViewController.jk_popupBackgroundView.alpha = 1.0f;
            [self.jk_popupViewController viewWillAppear:NO];
        } completion:^(BOOL finished) {
            [self.jk_popupViewController viewDidAppear:NO];
        }];
        
    }else
    {
        [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
            popupView.transform =  CGAffineTransformMakeTranslation(x,topView.frame.size.height);
//            popupView.transform =  CGAffineTransformIdentity;
            [self viewWillDisappear:NO];
            [self.jk_popupParentViewController viewWillAppear:NO];

        } completion:^(BOOL finished) {
            if (self.jk_popupDismissBlock)
            {
                self.jk_popupDismissBlock(self.jk_popTag);
                self.jk_popupDismissBlock = nil;
            }
            
            if (self.jk_popupParentViewController.jk_popupDismissBlock)
            {
                self.jk_popupParentViewController.jk_popupDismissBlock(self.jk_popTag);
                self.jk_popupParentViewController.jk_popupDismissBlock = nil;
            }
            
            [self viewDidDisappear:NO];
            [self.jk_popupParentViewController viewDidAppear:NO];
            [self.jk_popupBackgroundView removeFromSuperview];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
           
        }];

    }
   

}
#pragma mark --
-(UIView*)topView {
    UIViewController *viewcontroller = [self topShowViewController];
    return viewcontroller.view;
}
- (UIViewController*)topShowViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        if (rootViewController) {
            return rootViewController;
        }else{
            UIViewController *recentView = self;
            
            while (recentView.parentViewController != nil) {
                recentView = recentView.parentViewController;
            }
            return recentView;
            
        }
    }
}
@end


@implementation JKPopupBackgroundView

-(void)touchesBegan:(void (^)(CGPoint))callback{
    _callback = [callback copy];
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {0.0f, 1.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (_callback) {
        _callback(point);
    }
}
@end
