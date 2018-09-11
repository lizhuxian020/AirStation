//
//  DrawerManager.h
//
//  Created by MIST on 03/09/2017.
//  Copyright © 2017 MIST. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ICSDrawerController.h"

#define kDrawerManager [DrawerManager shareDrawerManager]

@interface DrawerManager : NSObject

@property (nonatomic, weak, readonly) ICSDrawerController *drawer;

/**
 是否需要手势展开侧滑
 */
@property (nonatomic, assign) BOOL needDrawer;


/**
 侧滑管理员单例

 @return 侧滑管理员
 */
+ (instancetype)shareDrawerManager;

- (ICSDrawerController *)setupLeftVC:(UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting> *)leftVC
                             rightVC:(UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting> *)rightVC;

@end
