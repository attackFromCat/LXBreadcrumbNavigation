//
//  ViewController.m
//  LXBreadcrumbNavigationDemo
//
//  Created by 李翔 on 2016/12/20.
//  Copyright © 2016年 Lee Xiang. All rights reserved.
//

#import "ViewController.h"
#import "LXBreadcrumbView.h"

static NSString *const reuseID = @"cell";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
{
    
    LXBreadcrumbView *_crumView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupTableView];
    
}
- (void)setupNavigation
{
    if (!_titleStr) {
        self.navigationItem.title = @"新闻";
        _crumbList = [NSMutableArray arrayWithObject:@"新闻"];
        [self saveCrumbListData];
    }else{
        self.navigationItem.title = _titleStr;
    }
}

- (void)setupBreadcrumbView
{
    _crumView = [[LXBreadcrumbView alloc] init];
    _crumView.backgroundColor = [UIColor lightGrayColor];
    _crumView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 44);
    
    
}

- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    _crumView = [[LXBreadcrumbView alloc] init];
    _crumView.backgroundColor = [UIColor lightGrayColor];
    _crumView.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 44);
    _crumView.crumbs = [self getCrumbListData];
    
    __weak __typeof(self) weakSelf  = self;
    [_crumView setClickBlock:^(NSInteger btnTag) {
        
        NSMutableArray *arr = weakSelf.navigationController.viewControllers.mutableCopy;
        [arr removeObjectsInRange:NSMakeRange(btnTag + 1, arr.count - btnTag - 1)];
        
        // 删除数组多余的数据
        weakSelf.crumbList = [weakSelf getCrumbListData];
        [weakSelf.crumbList removeObjectsInRange:NSMakeRange(btnTag + 1, weakSelf.crumbList.count - btnTag - 1)];
        [weakSelf saveCrumbListData];
        
        [weakSelf.navigationController setViewControllers:arr animated:YES];
        
    }];
    
    tableView.tableHeaderView = _crumView;
}

#pragma mark ------------------
#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    if (_titleStr) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@---%ld",_titleStr,indexPath.row];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"新闻---%ld",indexPath.row];
    }
    return cell;
}

#pragma mark ------------------
#pragma mark -UITableViewdelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *crumbList = @[
                           @"新闻",@"体育",@"足球",@"国际足球",@"西甲",@"皇家马德里"
                           ];
    ViewController *vc = [[ViewController alloc] init];
    int value = arc4random_uniform(6);
    vc.titleStr = crumbList[value];
    
    // 记录面包路径数组
    _crumbList = [self getCrumbListData];
    [_crumbList addObject:vc.titleStr];
    [self saveCrumbListData];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableArray *)getCrumbListData
{
    NSArray *crumbLists = [[NSUserDefaults standardUserDefaults] objectForKey:@"crumbList"];
    return [NSMutableArray arrayWithArray:crumbLists];
}

- (void)saveCrumbListData
{
    [[NSUserDefaults standardUserDefaults] setObject:_crumbList forKey:@"crumbList"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
