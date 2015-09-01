//
//  UIViewController+JKPopup.h
//  UIViewController-JKPopup
//
//  Created by Jakey on 15/9/1.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JKPopupDismissBlock)(NSInteger jk_popTag);
@class JKPopupBackgroundView;

@interface UIViewController (JKPopup)
@property (nonatomic, strong) UIViewController *jk_popupParentViewController;
@property (nonatomic, strong) UIViewController *jk_popupViewController;
@property (nonatomic, strong) JKPopupBackgroundView *jk_popupBackgroundView;
@property (nonatomic, copy) JKPopupDismissBlock jk_popupDismissBlock;
@property (nonatomic, assign) NSInteger jk_popTag;

- (void)presentJKPopupViewController:(UIViewController*)jk_popupViewController;

- (void)presentJKPopupViewController:(UIViewController*)jk_popupViewController
                     backgroundTouch:(BOOL)enable
                           dismissed:(JKPopupDismissBlock)dismissed;

- (void)presentJKPopupViewController:(UIViewController*)jk_popupViewController
                   backgroundTouch:(BOOL)enable
                            popTag:(NSInteger)popTag
                         dismissed:(JKPopupDismissBlock)dismissed;

- (void)dismissJKPopupViewController:(JKPopupDismissBlock)dismissed;

@end


typedef void(^JKPopupBackgroundViewCallback)(CGPoint point);
@interface JKPopupBackgroundView : UIView
{
    JKPopupBackgroundViewCallback _callback;
}
-(void)touchesBegan:(void (^)(CGPoint point))callback;
@end
