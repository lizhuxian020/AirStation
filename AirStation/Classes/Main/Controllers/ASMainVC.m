//
//  ASMainVC.m
//  AirStation
//
//  Created by mist on 2018/9/11.
//  Copyright © 2018 mistak1992. All rights reserved.
//

#import "ASMainVC.h"

#import "ASNavMainVC.h"

#import "ASHomeVC.h"

#import "ASMineVC.h"

@interface ASMainVC ()

@end

@implementation ASMainVC

- (void)setupUI{
    //样式
    self.tabBar.tintColor = kGrayColor(245);
    self.tabBar.translucent = NO;
    //首页
    ASHomeVC *homeVC = [ASHomeVC new];
    homeVC.title = @"首页";
    [homeVC.tabBarItem setImage:[UIImage imageNamed:@"icon-首页未选中"]];
    [homeVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon-首页选中"]];
    ASNavMainVC *homeNav = [[ASNavMainVC alloc] initWithRootViewController:homeVC];
    //我的
    ASMineVC *mineVC = [ASMineVC new];
    mineVC.title = @"我的";
    [mineVC.tabBarItem setImage:[UIImage imageNamed:@"icon-圈子未选中"]];
    [mineVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"icon-圈子选中"]];
    ASNavMainVC *mineNav = [[ASNavMainVC alloc] initWithRootViewController:mineVC];
    self.viewControllers = @[homeNav, mineNav];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
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
