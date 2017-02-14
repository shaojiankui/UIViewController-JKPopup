//
//  RootViewController.m
//  UIViewController-JKPopup
//
//  Created by Jakey on 15/9/1.
//  Copyright © 2015年 www.skyfox.org. All rights reserved.
//

#import "RootViewController.h"
#import "UIViewController+JKPopup.h"
#import "DetailViewController.h"
#import "SecondViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)popupTouched:(id)sender {
    DetailViewController *detail = [[DetailViewController alloc]init];
    [self presentJKPopupViewController:detail];
}

- (IBAction)popup2Touched:(id)sender {
    DetailViewController *detail = [[DetailViewController alloc]init];
    [self presentJKPopupViewController:detail backgroundTouch:YES dismissed:^(NSInteger jk_popTag) {
        NSLog(@"jk_popTag:%zd",jk_popTag);

    }];
}

- (IBAction)newVCTouched:(id)sender {
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}

- (IBAction)presentTouched:(id)sender {
    DetailViewController *detail = [[DetailViewController alloc]init];
    detail.modalPresentationStyle =  UIModalPresentationFormSheet;
    [self presentViewController:detail animated:YES completion:^{
        
    }];
}

@end
