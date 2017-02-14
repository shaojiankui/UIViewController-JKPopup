//
//  SecondViewController.m
//  UIViewController-JKPopup
//
//  Created by runlin on 2017/2/14.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import "SecondViewController.h"
#import "DetailViewController.h"
#import "UIViewController+JKPopup.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DetailViewController *detail = [[DetailViewController alloc]init];
    [self presentJKPopupViewController:detail];
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

@end
