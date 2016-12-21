//
//  LXBreadcrumbView.h
//  LXBreadcrumbNavigation
//
//  Created by 李翔 on 16/8/10.
//  Copyright © 2016年 Lee Xiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXBreadcrumbView : UIView

/**
 面包屑导航展示的数组
 */
@property (nonatomic, strong) NSMutableArray *crumbs;

/**
 点击面包屑导航传出被点击的block
 */
@property (nonatomic, strong) void(^clickBlock)(NSInteger);
@end
