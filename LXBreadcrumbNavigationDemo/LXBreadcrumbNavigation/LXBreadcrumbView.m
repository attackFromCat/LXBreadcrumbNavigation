//
//  LXBreadcrumbView.m
//  LXBreadcrumbNavigation
//
//  Created by 李翔 on 16/8/10.
//  Copyright © 2016年 Lee Xiang. All rights reserved.
//

#import "LXBreadcrumbView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScrollViewHeight 44 // 内容滚动视图的高度

@interface LXBreadcrumbView()

@end

@implementation LXBreadcrumbView
{
    UIScrollView        *_scrollView;
    NSMutableArray      *_btnArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScrollViewHeight)];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
        self.backgroundColor = [UIColor colorWithRed:0.922 green:0.929 blue:0.941 alpha:1.000];
        
        _btnArray = [NSMutableArray array];
    }
    return self;
}

- (void)setCrumbs:(NSMutableArray *)crumbs {
    
    for (UIView *subView in _scrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    _crumbs = crumbs.mutableCopy;
    
    CGFloat maxX = 15;
    CGFloat margin = 10;
    for (int i = 0; i < _crumbs.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        [_btnArray addObject:btn];
        [btn setTitle:crumbs[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        
        CGRect btnFrame = btn.frame;
        btnFrame.origin.x = maxX;
        btn.frame = btnFrame;
        CGPoint btnCenter = btn.center;
        btnCenter.y = _scrollView.bounds.size.height * 0.5;
        btn.center = btnCenter;
        
        maxX = CGRectGetMaxX(btn.frame) + margin;
        [_scrollView addSubview:btn];
        
        if (i != _crumbs.count - 1) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(maxX, 0, 6, 10)];
            imageView.image = [UIImage imageNamed:@"LXBreadcrumbView.bundle/arrow"];
            
            CGPoint imageViewCenter = imageView.center;
            imageViewCenter.y = _scrollView.bounds.size.height * 0.5;
            imageView.center = imageViewCenter;
            
            maxX = CGRectGetMaxX(imageView.frame) + margin;
            [_scrollView addSubview:imageView];
        } else {
             [btn setTitleColor:[UIColor colorWithRed:0.510 green:0.576 blue:0.620 alpha:1.000] forState:UIControlStateNormal];
        }
    }
    _scrollView.contentSize = CGSizeMake(maxX + margin, 0);
    
    CGFloat scrollViewWidth = _scrollView.frame.size.width;
    CGFloat contentSizeWidth = _scrollView.contentSize.width;
    if (contentSizeWidth > scrollViewWidth) {
        _scrollView.contentOffset = CGPointMake(contentSizeWidth - scrollViewWidth, 0);
    }
}

- (void)btnClick:(UIButton *)btn {
    if (_clickBlock && btn.tag < _crumbs.count) _clickBlock([_btnArray indexOfObject:btn]);
}

@end
