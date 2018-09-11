//
//  DrawerManager.m
//
//  Created by MIST on 03/09/2017.
//  Copyright © 2017 MIST. All rights reserved.
//

#import "DrawerManager.h"

#import "AppDelegate.h"

static DrawerManager *manager = nil;

@implementation DrawerManager

+ (instancetype)shareDrawerManager{
    if (manager == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[DrawerManager alloc] init];
        });
    }
    return manager;
}

/**
 设置侧滑

 @param leftVC 左侧控制器
 @param rightVC 右侧控制器
 @return 返回侧滑控制器
 */
- (ICSDrawerController *)setupLeftVC:(UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting> *)leftVC
            rightVC:(UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting> *)rightVC{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
    ICSDrawerController *drawer = [[ICSDrawerController alloc] initWithLeftViewController:leftVC centerViewController:rightVC];
    _drawer = drawer;
    return _drawer;
}

/**
 重写needDrawer的set方法

 @param needDrawer 是否需要侧滑
 */
- (void)setNeedDrawer:(BOOL)needDrawer{
    _needDrawer = needDrawer;
    if (needDrawer == YES) {
        _drawer.isLock = NO;
    }else{
        _drawer.isLock = YES;
    }
}

@end
